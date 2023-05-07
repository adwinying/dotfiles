# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, config, username, ... }: {
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
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    file.".localrc/sessionvars".text = ''
      export LANG="en_US.UTF-8"
      export LC_CTYPE="en_US.UTF-8"
      export LC_ALL="en_US.UTF-8"
      export EDITOR="nvim"
      export PAGER="less -FirSwX"
    '';
  };

  # Define shared vars for all modules
  _module.args = {
    dotfiles = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles";
    secrets = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.secrets";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
