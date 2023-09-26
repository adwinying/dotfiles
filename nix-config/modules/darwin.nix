#
# Darwin-specific configs
#

{ self, inputs, pkgs, ... }: {
  imports = [
    # Import home-manager's Nix-darwin module
    inputs.home-manager.darwinModules.home-manager
  ];

  # Fonts to install
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [
    hackgen-font
    hackgen-nf-font
  ];

  # Apply configs to following networks
  networking.knownNetworkServices = [
    "Wi-Fi"
  ];

  # Set DNS
  networking.dns = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];

  # Enable sudo authentication with TouchID
  security.pam.enableSudoTouchIdAuth = true;

  # Auto upgrade nix package and the daemon service
  services.nix-daemon.enable = true;

  # System preferences
  system.defaults = {
    CustomUserPreferences = {
      # Disable Creation of Metadata Files on Network Volumes
      "com.apple.desktopservices".DSDontWriteNetworkStores = true;
      # Disable Creation of Metadata Files on USB Volumes
      "com.apple.desktopservices".DSDontWriteUSBStores = true;

      # Disable Disk Image Verification
      "com.apple.frameworks.diskimages" = {
        "skip-verify" = true;
        "skip-verify-locked" = true;
        "skip-verify-remote" = true;
      };
    };

    # enable full keyboard control
    NSGlobalDomain.AppleKeyboardUIMode = 3;

    # show all file extensions in Finder
    NSGlobalDomain.AppleShowAllExtensions = true;
    finder.AppleShowAllExtensions = true;

    # key repeat initial delay
    NSGlobalDomain.InitialKeyRepeat = 15;

    # key repeat rate
    NSGlobalDomain.KeyRepeat = 2;

    # disable autocorrect
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;

    # expand save panel by default
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;

    # expand print panel by default
    NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;

    # enable tap to click
    trackpad.Clicking = true;

    # enable three finger drag
    trackpad.TrackpadThreeFingerDrag = true;

    # trackpad tracking speed
    NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;

    # mouse tracking speed
    ".GlobalPreferences"."com.apple.mouse.scaling" = "100.0";

    # autohide dock
    dock.autohide = true;
    dock.autohide-delay = 0.0;

    # disable dock magnification
    dock.magnification = false;

    # dock icons normal size
    dock.tilesize = 28;

    # dock minimize/maximize effect
    dock.mineffect = "scale";

    # minimize window to dock icon
    dock.minimize-to-application = true;

    # disable automatic space sort by recent use
    dock.mru-spaces = false;

    # dock position
    dock.orientation = "left";

    # hide recent apps in dock
    dock.show-recents = false;

    # hot corners
    dock.wvous-bl-corner = 3;  # Application windows
    dock.wvous-br-corner = 4;  # Desktop
    dock.wvous-tl-corner = 2;  # Mission control
    dock.wvous-tr-corner = 12; # Notification center

    # set save target to local disk (not iCloud) by default
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;

    # set search scope to current dir
    finder.FXDefaultSearchScope = "SCcf";

    # set list view as default Finder view
    finder.FXPreferredViewStyle = "clmv";

    # show Finder path bar
    finder.ShowPathbar = true;

    # show Finder status bar
    finder.ShowStatusBar = true;

    # disable guest account
    loginwindow.GuestEnabled = false;

    # disable shadows when screenshotting windows
    screencapture.disable-shadow = true;
  };

  # enable keyboard mappings
  system.keyboard.enableKeyMapping = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
