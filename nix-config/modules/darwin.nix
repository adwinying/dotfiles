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

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
