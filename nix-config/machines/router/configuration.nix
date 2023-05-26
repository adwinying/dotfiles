#
# router-specific configs
#

{ pkgs, username, ... }: {
  # Import system modules for this machine
  imports = [
    ../../modules/base.nix
  ];

  # Import addtional user profiles for this machine
  _module.args.profiles = [];
}
