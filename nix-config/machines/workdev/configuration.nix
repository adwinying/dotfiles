#
# workdev-specific configs
#

{ inputs, ... }: {
  # Import system modules for this machine
  imports = [
    (inputs.nixpkgs + "/nixos/modules/virtualisation/lxc-container.nix")
    ../../modules/base.nix
    ../../modules/docker.nix
    ../../modules/tailscale.nix
    ../../modules/xserver.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # No need firewall as this machine is not public facing
  networking.firewall.enable = false;

  # Import addtional user profiles for this machine
  _module.args.profiles = [
    ../../profiles/dev.nix
    ../../profiles/gui.nix
  ];
}
