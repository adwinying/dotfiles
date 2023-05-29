#
# router-specific configs
#

{ pkgs, username, ... }: {
  # Import system modules for this machine
  imports = [
    ../../modules/base.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Bootloader config
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Wireless config
  networking.wireless.iwd.enable = true;

  # Import addtional user profiles for this machine
  _module.args.profiles = [];
}
