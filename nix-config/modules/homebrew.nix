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
        "flux-app"
        "aldente"
        "betterdisplay"
        "the-unarchiver"
        "mac-mouse-fix"
        "tailscale-app"
        "nikitabobko/tap/aerospace"
      ];

      homebrew.masApps = {
        RunCat = 1429033973;
        ScreenZen = 1541027222;
        Windows = 1295203466;
      };
    })

    # dev
    ({
      homebrew.casks = [
        "ghostty"
        "sublime-text"
        "orbstack"
        "tableplus"
        "bambu-studio"
        "kicad"
      ];
    })

    # media
    ({
      homebrew.casks = [
        "arc"
        "iina"
        "moonlight"
        "parsec"
      ];
    })
  ];
}
