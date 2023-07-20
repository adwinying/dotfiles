#
# programs/configs for the terminal
#

{ pkgs, config, dotfiles, secrets, ... }: {
  imports = [
    # zsh
    ({
      home.packages = with pkgs; [
        jq
        gettext
        bitwarden-cli
        file
        zsh
      ];
      home.file = {
        ".zsh".source = "${dotfiles}/zsh/.zsh";
        ".zshrc".text = let
          localPath = "${config.home.homeDirectory}/.dotfiles";
          remotePath = "https://github.com/adwinying/dotfiles.git";
        in ''
          if [[ ! -d ${localPath} ]]; then
            ${pkgs.git}/bin/git clone ${remotePath} ${localPath}
          fi

          source ${localPath}/zsh/.zshrc

          if [[ ! -d ${config.home.homeDirectory}/.secrets ]]; then
            echo "WARNING: ~/.secrets directory not found. Some applications may not work properly."
            echo "Run \`bootstrap-secrets\` to bootstrap this machine's secrets."
            echo "Create ~/.secrets directory to supress this message."
          fi
        '';
        ".zshenv".source = "${dotfiles}/zsh/.zshenv";
      };
    })

    # tmux
    ({
      home.packages = [
        pkgs.tmux
      ];
      home.file = {
        ".tmux".source = "${dotfiles}/tmux/.tmux";
        ".tmux.conf".source = "${dotfiles}/tmux/.tmux.conf";
      };
    })

    # vim
    ({
      home.packages = [
        pkgs.vim
      ];
      home.file = {
        ".vim".source = "${dotfiles}/vim/.vim";
      };
    })

    # lazygit
    ({
      home.packages = [ pkgs.lazygit ];
      xdg.configFile.lazygit.source = "${dotfiles}/lazygit/.config/lazygit";
    })

    # git
    ({
      home.packages = [ pkgs.git ];
      programs.git.enable = true;
      programs.git.userEmail = "adwinying@gmail.com";
      programs.git.userName = "Adwin Ying";
    })

    # ssh
    ({
      home.file = {
        ".ssh/id_ed25519".source = "${secrets}/id_ed25519";
        ".ssh/id_ed25519.pub".source = "${secrets}/id_ed25519.pub";
      };
    })

    # direnv
    ({
      home.packages = with pkgs; [
        direnv
        nix-direnv
      ];
      home.file = {
        ".localrc/direnv".text = ''
          export DIRENV_LOG_FORMAT=
          eval "$(direnv hook zsh)"
        '';
        ".config/direnv/direnvrc".text = "source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
      };
    })

    # process-compose
    ({
      home.packages = [ pkgs.process-compose ];
      xdg.configFile.process-compose.source = "${dotfiles}/process-compose/.config/process-compose";
    })

    # ranger
    ({
      home.packages = [ pkgs.ranger ];
      xdg.configFile.ranger.source = "${dotfiles}/ranger/.config/ranger";
    })

    # btop
    ({
      home.packages = [ pkgs.btop ];
      xdg.configFile.btop.source = "${dotfiles}/btop/.config/btop";
    })
  ];

  # misc.
  home.packages = with pkgs; [
    gnused
    gawk
    mosh
    lazydocker
    neofetch
    ripgrep
    unzip
  ];
}
