{ ... }: {
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
  };

  imports = [
    # utils
    ({
      homebrew.casks = [
        "hammerspoon"
        "raycast"
        "flux"
        "aldente"
        "the-unarchiver"
        "mac-mouse-fix"
        "nikitabobko/tap/aerospace"
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
