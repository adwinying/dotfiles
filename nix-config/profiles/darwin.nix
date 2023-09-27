#
# darwin-specific home-manager configs
# GUI applications are managed by homebrew cask
# @see modules/homebrew.nix
#

{ dotfiles, ... }: {
  imports = [
    # yabai
    ({
      xdg.configFile.yabai.source = "${dotfiles}/yabai/.config/yabai";
    })

    # alacritty
    ({
      xdg.configFile.alacritty.source = "${dotfiles}/alacritty/.config/alacritty";
    })

    # hammerspoon
    ({
      home.file.".hammerspoon".source = "${dotfiles}/hammerspoon/.hammerspoon";
    })
  ];
}
