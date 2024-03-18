#
# programs/configs for the development
#

{ lib, pkgs, dotfiles, ... }: lib.mkMerge [
  # neovim
  ({
    home.packages = with pkgs; [
      gnumake
      gcc
      cargo
      nodejs
      unstable.go_1_22
      unstable.luajit
      unstable.rustc
      unstable.neovim # get the latest and greatest version
    ];
    xdg.configFile.nvim.source = "${dotfiles}/neovim/.config/nvim";
  })
]
