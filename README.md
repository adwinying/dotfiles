# .files
Automagically configure dotfiles for terminal environment.

## Prerequisites
- [GNU Stow](http://www.gnu.org/software/stow/)

## Instructions
1. Clone the repository:
```bash
$ git clone https://github.com/adwinying/dotfiles .dotfiles
```

2. Use GNU Stow to symlink the dotfiles of the modules:
```bash
$ cd .dotfiles
$ stow -v git
$ stow -v tmux
$ stow -v vim
$ stow -v zsh
```

3. For macOS, there is also an optional install script:
```bash
$ ./macos.sh
$ brew bundle
```

## Uninstall
```bash
$ stow -vD git
```

## See Also
- [nix-config](https://github.com/adwinying/dotfiles/tree/master/nix-config)
