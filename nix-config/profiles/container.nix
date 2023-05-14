#
# Overrides for container environment
#

{ lib, ... }: {
  home.homeDirectory = lib.mkForce "/root";
}
