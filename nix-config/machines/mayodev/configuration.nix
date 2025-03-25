#
# workdev-specific configs
#

{ inputs, ... }: {
  # Import system modules for this machine
  imports = [
    (inputs.nixpkgs + "/nixos/modules/virtualisation/lxc-container.nix")
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/linux.nix
    ../../modules/docker.nix
    ../../modules/tailscale.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Increase file watch limit
  boot.kernel.sysctl."fs.inotify.max_user_watches" = 524288;

  # No need firewall as this machine is not public facing
  networking.firewall.enable = false;

  # Accept tailscale subnet routing routes
  services.tailscale.acceptRoutes = true;

  # Import addtional user profiles for this machine
  _module.args.profiles = [
    ../../profiles/dev.nix
  ];
}
