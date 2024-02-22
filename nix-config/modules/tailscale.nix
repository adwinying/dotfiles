{ lib, pkgs, system, config, username, ... }: let
  cfg = config.services.tailscale;
in {
  options.services.tailscale = with lib; {
    enableSshAgent = mkOption {
      description = "Allow Tailscale to run an SSH server";
      type = types.bool;
      default = true;
    };

    exitNode = mkOption {
      description = "Allow current machine to be a Tailscale exit node";
      type = types.bool;
      default = false;
    };

    advertiseRoutes = mkOption {
      description = "Advertise routes to the Tailscale network ie. subnet routing";
      type = types.nullOr types.str;
      example = "192.168.1.0/24";
      default = null;
    };

    acceptRoutes = mkOption {
      description = "Accept routes from the Tailscale network";
      type = types.bool;
      default = false;
    };

    advertiseTags = mkOption {
      description = "Advertise tags to the Tailscale network";
      type = types.str;
      default = "tag:nixos";
    };

    acceptRisk = mkOption {
      description = "Accept risk when connecting to Tailscale";
      type = types.nullOr types.str;
      default = "lose-ssh";
    };

    authKey = mkOption {
      description = "The Tailscale authentication key";
      type = types.str;
      example = "tskey-client-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
      default = "$(${pkgs.coreutils}/bin/cat /home/${username}/.secrets/tailscale_auth_key | ${pkgs.findutils}/bin/xargs)?ephemeral=false";
    };
  };

  config = {
    services.tailscale.enable = true;
    services.tailscale.package = pkgs.unstable.tailscale;
  };

  imports = let
    isDarwin = builtins.match "^(.+-darwin)$" system == [ system ];
    osConfigs = if isDarwin
      then ({ homebrew.masApps.Tailscale = 1475387142; })
      else ({
        networking.firewall.checkReversePath = "loose";

        # create a oneshot job to authenticate to Tailscale
        systemd.services.tailscale-autoconnect = {
          description = "Automatic connection to Tailscale";

          # make sure tailscale is running before trying to connect to tailscale
          after = [ "network-pre.target" "tailscale.service" ];
          wants = [ "network-pre.target" "tailscale.service" ];
          wantedBy = [ "multi-user.target" ];

          # set this service as a oneshot job
          serviceConfig.Type = "oneshot";

          # have the job run this shell script
          script = let
            sshArgs = if cfg.enableSshAgent
              then "--ssh"
              else "";
            exitNodeArgs = if cfg.exitNode
              then "--advertise-exit-node"
              else "";
            inboundSubnetRoutingArgs = if cfg.acceptRoutes
              then "--accept-routes"
              else "";
            outboundSubnetRoutingArgs = if cfg.advertiseRoutes == null
              then ""
              else "--advertise-routes=${cfg.advertiseRoutes}";
            tagArgs = if cfg.advertiseTags == null
              then ""
              else "--advertise-tags=${cfg.advertiseTags}";
            riskArgs = if cfg.acceptRisk == null
              then ""
              else "--accept-risk=${cfg.acceptRisk}";
            authKeyArgs = "--auth-key=${cfg.authKey} ";
          in ''
            # wait for tailscaled to settle
            sleep 2

            # authenticate with tailscale
            ${pkgs.unstable.tailscale}/bin/tailscale up ${sshArgs} ${authKeyArgs} ${tagArgs} ${exitNodeArgs} ${outboundSubnetRoutingArgs} ${inboundSubnetRoutingArgs} ${riskArgs}
          '';
        };
      });
  in [
    osConfigs
  ];
}
