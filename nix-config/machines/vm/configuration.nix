#
# vm-specific configs
#

{ inputs, pkgs, username, ... }: {
  # Import system modules for this machine
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/linux.nix
    ../../modules/wayland.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Bootloader config
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # No need firewall as this machine is not public facing
  networking.firewall.enable = false;

  # Import addtional user profiles for this machine
  _module.args.profiles = [
    ../../profiles/dev.nix
    ../../profiles/wayland.nix
  ];
}
