# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, config, pkgs, username, ... }: {
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
      export EDITOR="vim"
      export PAGER="less -FirSwX"
    '';
  };

  # Define shared vars for all modules
  _module.args = with config.lib.file; {
    dotfiles = mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles";
    secrets = mkOutOfStoreSymlink "${config.home.homeDirectory}/.secrets";
  };

  # Enable home-manager
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Nix convenience scripts
  home.packages = with pkgs; let
    dotfiles = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles";

    syncAllHosts = writeShellScriptBin "sync-all-hosts" ''
      pushd ${dotfiles}/nix-config

      HOSTS=$(nix eval .#nixosConfigurations --apply 'pkgs: builtins.concatStringsSep " " (builtins.attrNames pkgs)' | xargs)

      for host in $HOSTS; do
        echo "Syncing $host:"

        # Check host accessible via SSH
        IS_HOST_ACTIVE=$(ssh -o ConnectTimeout=5 $host exit &> /dev/null)

        # Skip if host is not accessible
        if [[ $? -ne 0 ]]; then
          echo "Host $host is not accessible via SSH; skipping..."
          continue
        fi

        # Run sync script on host via SSH
        ssh $host "cd ~/.dotfiles && git pull && rebuild-host && bootstrap-secrets"
      done

      popd

      echo "Done!"
    '';

    rebuildHost = writeShellScriptBin "rebuild-host" ''
      sudo nixos-rebuild switch --flake $HOME/.dotfiles/nix-config#
    '';

    bootstrapSecrets = writeShellScriptBin "bootstrap-secrets" ''
      if [[ -z "$BW_SESSION" ]]; then
        export BW_SESSION=$(bw unlock --raw)
      fi

      ${dotfiles}/scripts/bootstrap_secrets.sh
    '';
  in [
    syncAllHosts
    rebuildHost
    bootstrapSecrets
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
