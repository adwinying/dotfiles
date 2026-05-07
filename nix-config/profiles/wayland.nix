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
      noto-fonts-color-emoji
      hackgen-font
      hackgen-nf-font
    ];
    xdg.configFile.fontconfig.source = "${dotfiles}/fontconfig/.config/fontconfig";
  })

  # theme
  ({
    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };
    gtk = {
      enable = true;
      theme.name = "Nordic-darker";
      theme.package = pkgs.nordic;
      iconTheme.name = "Zafiro-icons-Dark";
      iconTheme.package = pkgs.zafiro-icons;
      cursorTheme.name = "Adwaita";
      cursorTheme.package = pkgs.adwaita-icon-theme;
      font.name = "Noto Sans CJK JP";
    };
  })

  # hyprland
  ({
    home.packages = with pkgs; [
      unstable.noctalia-qs
      unstable.noctalia-shell
    ];
    xdg.configFile.hypr.source = "${dotfiles}/hyprland/.config/hypr";
    xdg.configFile.noctalia.source = "${dotfiles}/noctalia/.config/noctalia";
  })

  # ghostty
  ({
    home.packages = [ pkgs.ghostty ];
    xdg.configFile.ghostty.source = "${dotfiles}/ghostty/.config/ghostty";
  })

  # firefox
  ({
    home.packages = [ pkgs.firefox ];
  })
]
