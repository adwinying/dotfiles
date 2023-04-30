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

  # Bootloader configs
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.initrd.kernelModules = [ "nvme" ];

  # Open ports 3000s and 8000s for development
  networking.firewall.allowedTCPPortRanges = [
    { from = 3000; to = 3999; }
    { from = 8000; to = 8999; }
  ];

  home-manager.extraSpecialArgs = {
    # Import user profiles for this machine
    profiles = [];
  };
}
