#
# live environment-specific configs
#

{ inputs, lib, ... }: {
  # Import system modules for this machine
  imports = [
    (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
    ../../modules/base.nix
    ../../modules/docker.nix
    ../../modules/tailscale.nix
    ../../modules/xserver.nix
    ../../modules/wireless.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Fix conflicting options from base.nix
  services.openssh.permitRootLogin = lib.mkForce "no";

  # Make ISO builds faster by using a less efficient compression algorithm
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";

  # Import addtional user profiles for this machine
  _module.args.profiles = [
    ../../profiles/gui.nix
  ];
}