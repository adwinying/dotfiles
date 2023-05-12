#
# Common machine configs
#

{ inputs, lib, config, pkgs, hostname, username, system, ... }: {
  imports = [
    # Import your generated (nixos-generate-config) hardware configuration
    ../machines/${hostname}/hardware-configuration.nix

    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })

      # When applied, the unstable nixpkgs set (declared in the flake inputs)
      # will be accessible through 'pkgs.unstable'
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          system = final.system;
          config.allowUnfree = true;
        };
      })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
    '';

    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };
  };

  # Set your hostname
  networking.hostName = hostname;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users.${username} = {
    hashedPassword = "$y$j9T$KVgy.ReZophSp7Drn6dfe/$vHd3ect3ux0HVibBQaC/VSsQySz.Y3wocgqmsswxjh4";
    isNormalUser = true;
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [ inputs.sshAuthorizedKeys ];
    # Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
    extraGroups = [
      "wheel"
    ];
  };

  # Disable password prompt when using sudo
  security.sudo.wheelNeedsPassword = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    vim
    git
    wget
    curl
    less
  ];

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    permitRootLogin = "no";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";

  home-manager = {
    extraSpecialArgs = {
      inherit inputs username;
    };
    users = {
      # Import your home-manager configuration
      ${username} = import ../users/${username}.nix;
    };
  };

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = system;

}
