#
# Common machine configs
#

{ inputs, lib, config, pkgs, hostname, username, system, profiles, ... }: {
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

    # Enable flakes and new 'nix' command
    settings.experimental-features = "nix-command flakes";

    # Deduplicate and optimize nix store
    optimise.automatic = true;

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
    shell = pkgs.zsh;
    home = if pkgs.stdenv.isDarwin
      then "/Users/${username}"
      else "/home/${username}";
    openssh.authorizedKeys.keyFiles = [ inputs.sshAuthorizedKeys ];
  };
  programs.zsh.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    home-manager
    vim
    wget
    curl
    less
  ];

  # home-manager
  home-manager = {
    extraSpecialArgs = {
      inherit inputs username;
    };
    users = {
      ${username}.imports = [
        ../profiles/base.nix
        ../profiles/cli.nix
      ] ++ profiles;
    };
    backupFileExtension = "bak";
  };

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = system;
}
