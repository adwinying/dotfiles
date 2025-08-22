#
# hacobell-specific configs
#

{ inputs, lib, ... }: {
  # Import system modules for this machine
  imports = [
    ../../modules/base.nix
    ../../modules/darwin.nix
    ../../modules/homebrew.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Import addtional user profiles for this machine
  _module.args.profiles = [
    ../../profiles/darwin.nix
    ../../profiles/dev.nix
  ];

  # Set your hostname
  # networking.hostName = lib.mkForce "FD4GK2JLYQ";
}
