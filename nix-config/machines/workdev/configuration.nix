#
# workdev-specific configs
#

{ inputs, lib, config, pkgs, ... }: {
  # Import system modules for this machine
  imports = [
    ../../modules/docker.nix
    ../../modules/tailscale.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  home-manager.extraSpecialArgs = {
    # Import user applications for this machine
    applications = [];
  };
}