#
# programs/configs for the development
#

{ pkgs, dotfiles, ... }: {
  imports = [
    # neovim
    ({
      home.packages = with pkgs; [
        gnumake
        gcc
        cargo
        nodejs
        unstable.luajit
        unstable.rustc
        unstable.neovim # get the latest and greatest version
      ];
      xdg.configFile.nvim.source = "${dotfiles}/neovim/.config/nvim";
    })
  ];
}
