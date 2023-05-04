#
# programs/configs for GUI environment
#

{ pkgs, config, username, ... }: let
  dotfiles = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles";
in {
  imports = [
    # awesome
    ({
      home.packages = with pkgs; [
        xorg.xinit
        awesome
        feh
      ];
      xsession = {
        enable = true;
        windowManager.awesome.enable = true;
        windowManager.awesome.luaModules = [
          pkgs.luajitPackages.lgi
        ];
      };
      xdg.configFile.awesome.source = "${dotfiles}/awesomewm/.config/awesome";
      home.file = {
        ".Xresources".source = "${dotfiles}/xinit/.Xresources";
        ".xinitrc".source = "${dotfiles}/xinit/.xinitrc";
      };
    })

    # rofi
    ({
      home.packages = [ pkgs.rofi ];
      xdg.configFile.rofi.source = "${dotfiles}/rofi/.config/rofi";
    })

    # alacritty
    ({
      home.packages = [ pkgs.alacritty ];
      xdg.configFile.alacritty.source = "${dotfiles}/alacritty/.config/alacritty";
    })
  ];
}
