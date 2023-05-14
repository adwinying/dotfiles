#
# adwin-specific user configs
#

{ profiles ? [], ... }: {
  # Import profiles here
  imports = profiles ++ [
    ../profiles/base.nix
    ../profiles/cli.nix
  ];
}
