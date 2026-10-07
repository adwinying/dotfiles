{ ... }: {
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "check";
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
        "handy"
      ];

      homebrew.masApps = {
        RunCat = 1429033973;
        ScreenZen = 1541027222;
        Windows = 1295203466;
        Openterface = 6478481082;
        Amphetamine = 937984704;
      };
    })

    # dev
    ({
      homebrew.casks = [
        "ghostty"
        "sublime-text"
        "orbstack"
        "tableplus"
        "t3-code"
        "hamed-elfayome/claude-usage/claude-usage-tracker"
        "bambu-studio"
        "shapr3d"
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
        "blackhole-16ch"
        "moonlight"
        "parsec"
        "affinity"
      ];
    })
  ];
}
