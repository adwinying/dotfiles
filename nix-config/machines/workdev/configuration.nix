#
# workdev-specific configs
#

{ ... }: {
  # Import system modules for this machine
  imports = [
    ../../modules/base.nix
    ../../modules/docker.nix
    ../../modules/tailscale.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Import user profiles for this machine
  home-manager.extraSpecialArgs.profiles = [
    ../../profiles/dev.nix
  ];
}
