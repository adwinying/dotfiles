# nix-config

Personal nix config.

## Directories

| Name            | Description                                                                                                                |
| --------------- | -------------------------------------------------------------------------------------------------------------------------  |
| `machines`      | Contains machine configs (hardware, system settings/packages). `default.nix` contains shared configs between all machines. |
| `modules`       | Contains system configs for a certain feature that is only used by some machines.                                          |
| `users`         | Contains user (`home-manager`) configs. (ie. `machines`, but for user).                                                    |
| `applications`  | Contains user configs for a group of related packages. (ie. `modules`, but for user)                                       |

## Usage

1. Clone this repo

```bash
$ git clone https://github.com/adwinying/dotfiles ~/.dotfiles
```

2. Bootstrap

```bash
$ cd ~/.dotfiles/nix-config

# If running from live install environment:
$ nixos-install --flake .#hostname

# If running from existing nixOS install:
$ sudo nixos-rebuild switch --flake .#hostname
```

## Inspiration

- Base templates: https://github.com/Misterio77/nix-starter-configs
- Multi machine configs: https://github.com/wimpysworld/nix-config
- Directory structure: https://github.com/gianarb/dotfiles/tree/main/nixos
- macOS configs : https://github.com/mitchellh/nixos-config
