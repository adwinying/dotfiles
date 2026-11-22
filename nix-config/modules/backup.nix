#
# NAS appconfig backup with kopia
#
# The repo connection (SFTP to frame1) and password come from bootstrap-secrets
# (secrets/nas/kopia). Everything else is here.
#

{ pkgs, config, username, ... }: let
  kopiaConfig = "/home/${username}/.secrets/kopia/repository.config";
  appdataDir = "/home/${username}/nas-docker/appdata";
  plex = "/plex/config/Library/Application Support/Plex Media Server";

  # Imported before every snapshot, so the repo always matches this file.
  kopiaPolicy = pkgs.writeText "kopia-policy.json" (builtins.toJSON {
    "${username}@${config.networking.hostName}:${appdataDir}" = {
      # With one snapshot a day: every day for 10 days, weekly for 4 weeks,
      # monthly for 2 years, yearly for 3 years.
      retention = {
        keepLatest = 10;
        keepHourly = 48;
        keepDaily = 7;
        keepWeekly = 4;
        keepMonthly = 24;
        keepAnnual = 3;
        ignoreIdenticalSnapshots = false;
      };
      files.ignore = [
        # Plex re-downloads artwork and thumbnails. Plug-in Support holds the
        # library database, so it stays in.
        "${plex}/Metadata/"
        "${plex}/Media/"
        "${plex}/Cache/"
        # hermes caches and browser installs
        "/hermes/data/.cache/"
        "/hermes/data/.playwright-browsers/"
        "/hermes/data/.playwright/"
        "/hermes/data/installs/"
      ];
      compression = {
        compressorName = "zstd";
        # Already compressed
        neverCompress = [
          ".jpg" ".jpeg" ".png" ".webp" ".gif" ".heic" ".avif"
          ".mp4" ".mkv" ".mov" ".webm"
          ".mp3" ".m4a" ".aac" ".ogg" ".flac"
          ".zip" ".gz" ".tgz" ".xz" ".zst" ".7z" ".bz2" ".rar"
          ".woff2"
        ];
      };
    };
  });
in {
  # kopia CLI for restores and inspection
  environment.systemPackages = [ pkgs.kopia ];
  environment.sessionVariables.KOPIA_CONFIG_PATH = kopiaConfig;

  # Every day at 6:30am, clear of the weekly Sunday 6:01 LAN link flap
  systemd.timers.backup = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 6:30:00";
      Unit = "backup.service";
    };
  };

  systemd.services.backup = {
    environment.KOPIA_CONFIG_PATH = kopiaConfig;
    script = ''
      set -eu

      export PATH=$PATH:${pkgs.kopia}/bin
      export PATH=$PATH:${pkgs.coreutils}/bin
      export PATH=$PATH:${pkgs.curl}/bin

      healthcheck_endpoint_path=/home/${username}/.secrets/healthcheck_backup_endpoint
      healthcheck_endpoint_url=$(cat $healthcheck_endpoint_path)

      kopia policy import --from-file=${kopiaPolicy}
      kopia snapshot create "${appdataDir}"
      curl -fsS --retry 3 $healthcheck_endpoint_url
    '';
    serviceConfig = {
      Type = "oneshot";
      User = username;
      # Containers write root-only files (Home Assistant's .storage, auth
      # tokens). Read access to everything, without running as root, keeps
      # kopia's config, cache and locks owned by the user.
      AmbientCapabilities = "CAP_DAC_READ_SEARCH";
    };
  };
}
