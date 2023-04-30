#
# programs/configs for the terminal
#

{ pkgs, config, username, ... }: let
  dotfiles = config.lib.file.mkOutOfStoreSymlink "/home/${username}/.dotfiles";
in {
  imports = [
    # zsh
    ({
      home.packages = with pkgs; [
        jq
        file
        zsh
      ];
      home.file = {
        ".zsh".source = "${dotfiles}/zsh/.zsh";
        ".zshrc".text = let
          localPath = "/home/${username}/.dotfiles";
          remotePath = "https://github.com/adwinying/dotfiles.git";
        in ''
          if [[ ! -d ${localPath} ]]; then
            ${pkgs.git}/bin/git clone ${remotePath} ${localPath}
          fi

          source ${localPath}/zsh/.zshrc
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

    # neovim
    ({
      home.packages = with pkgs; [
        gnumake
        gcc
        cargo
        rustc
        nodejs
        unstable.neovim # get the latest and greatest version
      ];
      xdg.configFile.nvim.source = "${dotfiles}/neovim/.config/nvim";
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
    mosh
    lazydocker
    neofetch
    ripgrep
    unzip
  ];
}
