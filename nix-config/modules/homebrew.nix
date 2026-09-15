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
        "wispr-flow"
      ];

      homebrew.masApps = {
        RunCat = 1429033973;
        ScreenZen = 1541027222;
        Windows = 1295203466;
        Openterface = 6478481082;
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
        "utm"
      ];
    })

    # media
    ({
      homebrew.casks = [
        "arc"
        "zen"
        "helium-browser"
        "iina"
        "moonlight"
        "parsec"
        "affinity"
      ];
    })
  ];
}
