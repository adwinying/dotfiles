#
# hive-specific configs
#

{ pkgs, username, ... }: {
  # Import system modules for this machine
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/linux.nix
    ../../modules/docker.nix
    ../../modules/tailscale.nix
  ];

  # Import overlays for this machine
  nixpkgs.overlays = [];

  # Configure Tailscale
  services.tailscale = {
    acceptRoutes = true;
  };

  # Bootloader config
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Compressed swap in RAM and early OOM kills, so runaway agents
  # get killed before the whole machine freezes on 8GB RAM
  zramSwap.enable = true;
  services.earlyoom.enable = true;

  # Keep user services running without a login session
  users.users.${username}.linger = true;

  # Virtual display for headed browsers (bot detection blocks headless more often)
  systemd.services.xvfb = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = username;
      ExecStart = "${pkgs.xvfb}/bin/Xvfb :99 -screen 0 1920x1080x24 -nolisten tcp";
      Restart = "always";
    };
  };
  environment.variables.DISPLAY = ":99";

  # Required by Claude Code's sandbox on Linux
  environment.systemPackages = with pkgs; [
    bubblewrap
    socat
  ];

  # Configure firewall
  networking.firewall = {
    allowedTCPPorts = [
      # SSH
      22
    ];
    allowedUDPPorts = [
    ];
  };

  # Import addtional user profiles for this machine
  _module.args.profiles = [
    ../../profiles/dev.nix
  ];
}
