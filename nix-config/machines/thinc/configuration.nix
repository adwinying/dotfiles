#
# thinc-specific configs
#

{ inputs, ... }: {
  # Import system modules for this machine
  imports = [
    ../../modules/base.nix
    ../../modules/darwin.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Import addtional user profiles for this machine
  _module.args.profiles = [
  ];
}
