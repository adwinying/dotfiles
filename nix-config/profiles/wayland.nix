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
    qt = {
      enable = true;
      platformTheme = "gtk3";
    };
    gtk = {
      enable = true;
      theme.name = "Nordic-darker";
      theme.package = pkgs.nordic;
      iconTheme.name = "Zafiro-icons-Dark";
      iconTheme.package = pkgs.zafiro-icons;
    };
  })

  # hyprland
  ({
    home.packages = with pkgs; [
      hyprpaper
      waybar
      gtklock
      wl-clipboard
      cliphist
      pavucontrol
      brightnessctl
      playerctl
      libnotify
      swaynotificationcenter
    ];
    xdg.configFile.hypr.source = "${dotfiles}/hyprland/.config/hypr";
    xdg.configFile.swaync.source = "${dotfiles}/swaync/.config/swaync";
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
