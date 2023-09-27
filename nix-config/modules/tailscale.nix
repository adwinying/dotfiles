{ lib, pkgs, system, ... }: {
  services.tailscale.enable = true;
  services.tailscale.package = pkgs.unstable.tailscale;

  imports = let
    isDarwin = builtins.match "^(.+-darwin)$" system == [ system ];
    osConfigs = if isDarwin
      then ({ homebrew.masApps.Tailscale = 1475387142; })
      else ({ networking.firewall.checkReversePath = "loose"; });
  in [
    osConfigs
  ];
}
