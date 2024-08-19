#
# NAS appconfig backup
#

{ pkgs, secrets, username, ... }: {
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

            appdata_dir=/home/${username}/nas-docker/appdata

            healthcheck_endpoint_path=${secrets}/healthcheck_backup_endpoint
            healthcheck_endpoint_url=$(cat $healthcheck_endpoint_path)

            kopia snapshot create $appdata_dir
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
