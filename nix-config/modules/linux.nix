#
# Linux-specific configs
#

{ inputs, pkgs, username, ... }: {
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  # Disable password prompt when using sudo
  security.sudo.wheelNeedsPassword = false;

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    settings.PermitRootLogin = "no";
  };

  # Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users.${username} = {
    hashedPassword = "$y$j9T$KVgy.ReZophSp7Drn6dfe/$vHd3ect3ux0HVibBQaC/VSsQySz.Y3wocgqmsswxjh4";
    isNormalUser = true;
    homeMode = "770";
    # Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
    extraGroups = [
      "wheel"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
  ];

  # nix-ld: Allows compiled binaries to run on NixOS
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    systemd
    zlib
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
