#
# NAS appconfig backup
#

{ pkgs, secrets, username, ... }: let
  appdataDir = "/home/${username}/nas-docker/appdata";
  plex = "/plex/config/Library/Application Support/Plex Media Server";

  # Imported before every snapshot, so the repo always matches this file.
  kopiaPolicy = pkgs.writeText "kopia-policy.json" (builtins.toJSON {
    "${username}@nas:${appdataDir}" = {
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
  home.packages = with pkgs; [
    kopia
  ];

  xdg.configFile.kopia.source = "${secrets}/kopia";

  # Trigger backup job every day at 6am
  systemd.user = {
    timers.backup = {
      Unit.Description = "NAS appconfig backup";

      Timer = {
        OnCalendar = "*-*-* 6:00:00";
        Unit = "backup.service";
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    services.backup = {
      Unit.Description = "NAS appconfig backup";

      Service = {
        Type = "simple";
        ExecStart = let
          script = pkgs.writeShellScriptBin "script" ''
            set -eu

            export PATH=$PATH:${pkgs.kopia}/bin
            export PATH=$PATH:${pkgs.coreutils}/bin
            export PATH=$PATH:${pkgs.curl}/bin

            healthcheck_endpoint_path=${secrets}/healthcheck_backup_endpoint
            healthcheck_endpoint_url=$(cat $healthcheck_endpoint_path)

            kopia policy import --from-file=${kopiaPolicy}
            kopia snapshot create "${appdataDir}"
            curl -fsS --retry 3 $healthcheck_endpoint_url
          '';
        in "${script}/bin/script";
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
