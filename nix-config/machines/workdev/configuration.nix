#
# workdev-specific configs
#

{ inputs, ... }: {
  # Import system modules for this machine
  imports = [
    (inputs.nixpkgs + "/nixos/modules/virtualisation/lxc-container.nix")
    ../../modules/base.nix
    ../../modules/docker.nix
    ../../modules/tailscale.nix
    ../../modules/xserver.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # No need firewall as this machine is not public facing
  networking.firewall.enable = false;

  # # Enable QEMU's guest agent
  # services.qemuGuest.enable = true;
  # services.spice-vdagentd.enable = true;

  # Import addtional user profiles for this machine
  _module.args.profiles = [
    ../../profiles/dev.nix
    ../../profiles/gui.nix
  ];
}
