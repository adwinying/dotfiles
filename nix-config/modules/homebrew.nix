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
        "betterdisplay"
        "the-unarchiver"
        "mac-mouse-fix"
        "tailscale"
        "nikitabobko/tap/aerospace"
      ];

      homebrew.masApps = {
        RunCat = 1429033973;
        ScreenZen = 1541027222;
        "Microsoft Remote Desktop" = 1295203466;
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
