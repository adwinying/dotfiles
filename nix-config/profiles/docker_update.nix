#
# NAS docker update
#

{ pkgs, secrets, config, ... }: {
  systemd.user = {
    timers.docker-update = {
      Unit.Description = "Update docker containers";

      Timer = {
        OnCalendar = "*-*-* 5:00:00";
        Unit = "docker-update.service";
      };

      Install = {
        WantedBy = [ "timers.target" ];
      };
    };

    services.docker-update = {
      Unit.Description = "Update docker containers";

      Service = {
        Type = "simple";
        ExecStart = let
          script = pkgs.writeShellScriptBin "script" ''
            set -eu

            export PATH=$PATH:${pkgs.bash}/bin
            export PATH=$PATH:${pkgs.coreutils}/bin
            export PATH=$PATH:${pkgs.docker}/bin
            export PATH=$PATH:${pkgs.curl}/bin

            home_path=${config.home.homeDirectory}
            dir_path=$home_path/nas-docker

            healthcheck_endpoint_path=${secrets}/healthcheck_docker_endpoint
            healthcheck_endpoint_url=$(cat $healthcheck_endpoint_path)

            cd $dir_path
            docker compose pull
            docker compose up -d
            docker image prune -f
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
