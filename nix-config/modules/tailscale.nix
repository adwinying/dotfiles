{ lib, pkgs, config, username, ... }: let
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

    acceptDns = mkOption {
      description = "Accept DNS config from the Tailscale network";
      type = types.bool;
      default = true;
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
  };

  config = {
    services.tailscale = {
      enable = true;
      package = pkgs.unstable.tailscale;
      useRoutingFeatures = if cfg.exitNode then "both" else "client";
      authKeyFile = "/home/${username}/.secrets/tailscale_auth_key";
      extraUpFlags = let
        sshArgs = if cfg.enableSshAgent
          then "--ssh"
          else "";
        exitNodeArgs = if cfg.exitNode
          then "--advertise-exit-node"
          else "";
        dnsArgs = if cfg.acceptDns
          then "--accept-dns"
          else "--accept-dns=false";
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
      in builtins.filter (s: s != "") [
        sshArgs
        tagArgs
        exitNodeArgs
        dnsArgs
        outboundSubnetRoutingArgs
        inboundSubnetRoutingArgs
        riskArgs
      ];
    };
  };
}
