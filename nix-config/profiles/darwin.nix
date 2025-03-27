#
# darwin-specific home-manager configs
# GUI applications are managed by homebrew cask
# @see modules/homebrew.nix
#

{ dotfiles, ... }: {
  imports = [
    # aerospace
    ({
      xdg.configFile.aerospace.source = "${dotfiles}/aerospace/.config/aerospace";
    })

    # ghostty
    ({
      xdg.configFile.ghostty.source = "${dotfiles}/ghostty/.config/ghostty";
    })

    # hammerspoon
    ({
      home.file.".hammerspoon".source = "${dotfiles}/hammerspoon/.hammerspoon";
    })

    # lazygit
    ({
      home.file."Library/Application\ Support/lazygit".source = "${dotfiles}/lazygit/.config/lazygit";
    })
  ];
}
