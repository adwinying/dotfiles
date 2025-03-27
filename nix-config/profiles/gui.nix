#
# programs/configs for GUI environment
# xserver module is required to use this profile
#

{ lib, pkgs, dotfiles, ... }: lib.mkMerge [
  # xorg
  ({
    home.packages = with pkgs; [
      xorg.xmodmap
      xcape
      xclip
    ];

    xsession = {
      enable = true;
      windowManager.awesome.enable = true;
      windowManager.awesome.luaModules = [
        pkgs.luajitPackages.lgi
      ];
    };

    home.file = {
      ".Xresources".source = "${dotfiles}/xinit/.Xresources";
      ".xinitrc".source = "${dotfiles}/xinit/.xinitrc";
      ".Xmodmap".source = "${dotfiles}/xmodmap/.Xmodmap";
    };
  })

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

  # awesome
  ({
    home.packages = with pkgs; [
      awesome
      picom
      feh
      inotify-tools
      light
      maim
      playerctl
    ];
    xdg.configFile.awesome.source = "${dotfiles}/awesomewm/.config/awesome";
  })

  # sound
  ({
    home.packages = with pkgs; [
      pavucontrol
      pulseaudio
    ];
  })

  # rofi
  ({
    home.packages = [ pkgs.rofi ];
    xdg.configFile.rofi.source = "${dotfiles}/rofi/.config/rofi";
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
