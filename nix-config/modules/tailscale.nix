{ config, pkgs, ... }: {
  services.tailscale.enable = true;
  services.tailscale.package = pkgs.unstable.tailscale;
  networking.firewall.checkReversePath = "loose";
}
