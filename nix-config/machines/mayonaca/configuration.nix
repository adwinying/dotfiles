#
# mayonaca-specific configs
#

{ inputs, ... }: {
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
}
