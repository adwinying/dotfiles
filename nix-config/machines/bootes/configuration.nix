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

  # Bootloader configs
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.initrd.kernelModules = [ "nvme" ];

  # No need firewall as this machine is not public facing
  networking.firewall.enable = false;

  # Import addtional user profiles for this machine
  _module.args.profiles = [
    ../../profiles/dev.nix
  ];
}