{ ... }: {
  homebrew.enable = true;

  imports = [
    # utils
    ({
      homebrew.brews = [
        { name = "koekeishiya/formulae/yabai"; }
      ];

      homebrew.casks = [
        "hammerspoon"
        "raycast"
        "flux"
        "aldente"
        "the-unarchiver"
      ];

      homebrew.masApps = {
        RunCat = 1429033973;
        "Microsoft Remote Desktop" = 1295203466;
      };
    })

    # dev
    ({
      homebrew.casks = [
        "alacritty"
        "sublime-text"
        "orbstack"
        "tableplus"
      ];
    })

    # media
    ({
      homebrew.casks = [
        "arc"
        "iina"
      ];
    })
  ];
}
