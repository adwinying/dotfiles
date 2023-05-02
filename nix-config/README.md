# nix-config

Personal nix config.

## Directories

| Name            | Description                                                                          |
| --------------- | ------------------------------------------------------------------------------------ |
| `machines`      | Contains machine configs (hardware, system settings/packages).                       |
| `modules`       | Contains system configs for a certain feature that is only used by some machines.    |
| `users`         | Contains user (`home-manager`) configs. (ie. `machines`, but for user).              |
| `profiles`      | Contains user configs for a group of related packages. (ie. `modules`, but for user) |

## Usage

### 💿 From a live install

1. Partition disks (following is an example)

```bash
$ sudo -i
$ cfdisk

# select partition type: gpt
# create the following partitions:
# - 512M, EFI System Partition
# - 63.5G, ext4

# format partitions
$ mkfs.fat -F 32 -n boot /dev/vda1
$ mkfs.ext4 -L nixos /dev/vda2
```

2. Mount partitions

```bash
$ mount /dev/disk/by-label/nixos /mnt
$ mkdir /mnt/boot
$ mount /dev/disk/by-label/boot /mnt/boot
```

3. Bootstrap

```bash
# nix stable does not support non-flake inputs yet
$ nix-env -iA nixos.nixUnstable

$ nixos-install --flake github:adwinying/dotfiles?dir=nix-config#hostname
```

### From an existing nixOS install

1. Clone this repo

```bash
$ git clone https://github.com/adwinying/dotfiles ~/.dotfiles
```

2. Bootstrap

```bash
$ cd ~/.dotfiles/nix-config
$ nix shell --experimental-features 'nix-command flakes' nixpkgs#nixos-rebuild
$ sudo nixos-rebuild switch --flake .#hostname
```

## Inspiration

- Base templates: https://github.com/Misterio77/nix-starter-configs
- Multi machine configs: https://github.com/wimpysworld/nix-config
- Directory structure: https://github.com/gianarb/dotfiles/tree/main/nixos
- macOS configs : https://github.com/mitchellh/nixos-config
- profile directory: https://github.com/davidak/nixos-config/tree/master/profiles
