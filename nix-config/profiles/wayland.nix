#
# programs/configs for wayland environment
# xserver module is required to use this profile
#

{ lib, pkgs, dotfiles, ... }: lib.mkMerge [
  # fonts
  ({
    home.packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      hackgen-font
      hackgen-nf-font
    ];
    xdg.configFile.fontconfig.source = "${dotfiles}/fontconfig/.config/fontconfig";
  })

  # theme
  ({
    home.packages = with pkgs; [
      nordic
      zafiro-icons
    ];
    qt = {
      enable = true;
      platformTheme = "gtk3";
    };
    home.file.".gtkrc-2.0".source = "${dotfiles}/gtk/.gtkrc-2.0";
    xdg.configFile."gtk-3.0".source = "${dotfiles}/gtk/.config/gtk-3.0";
  })

  # hyprland
  ({
    home.packages = with pkgs; [
      hyprpaper
      waybar
      gtklock
      wl-clipboard
      cliphist
    ];
    xdg.configFile.hypr.source = "${dotfiles}/hyprland/.config/hypr";
  })

  # rofi
  ({
    home.packages = with pkgs; [
      rofi-wayland-unwrapped
      rofi-calc
      rofi-emoji
    ];
    xdg.configFile.rofi.source = "${dotfiles}/rofi/.config/rofi";
  })

  # alacritty
  ({
    home.packages = [ pkgs.alacritty ];
    xdg.configFile.alacritty.source = "${dotfiles}/alacritty/.config/alacritty";
  })

  # firefox
  ({
    home.packages = [ pkgs.firefox ];
  })
]
