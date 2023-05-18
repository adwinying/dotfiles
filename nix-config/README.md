# nix-config

Personal nix config.

## Directories

| Name       | Description                                                                          |
| ---------- | ------------------------------------------------------------------------------------ |
| `machines` | Contains machine configs (hardware, system settings/packages).                       |
| `modules`  | Contains system configs for a certain feature that is only used by some machines.    |
| `profiles` | Contains user configs for a group of related packages. (ie. `modules`, but for user) |

## Usage

### 🐳 Trying it out on a docker image

The [adwinying/devcontainer](https://github.com/adwinying/devcontainer) repo generates a new docker image once a day via Github Actions:

```bash
$ docker run --rm -it adwinying/devcontainer
```

### 💿 Generating a live install ISO

```bash
# Enable nix experimental features
$ export NIX_CONFIG="experimental-features = nix-command flakes"

# arch can either be x86_64 or aarch64
$ nix build github:adwinying/dotfiles?dir=nix-config#nixosConfigurations.live-[arch].config.system.build.isoImage
```

### 📦 Bootstrapping from a live install

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
$ nixos-install --flake github:adwinying/dotfiles?dir=nix-config#hostname
```

### 📦 Bootstrapping from an existing nixOS install

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
