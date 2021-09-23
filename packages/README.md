# pacman packages

Package list for easy bootstrap

## Prerequisites

- Arch Linux (btw)
- Your favorite AUR hepler (paru in my case)

## How to use

### Installing packages from all lists

```bash
$ paru -S - < *.txt
```

### Installing packages from specified lists

```bash
$ paru -S - < list1.txt list2.txt
```

### Backing up packages

```bash
$ pacman -Qqe > pkglist.txt
```
