{ inputs, config, pkgs, username, ... }: {
  environment.systemPackages = [ pkgs.docker ];
  virtualisation.docker.enable = true;
  users.users.${username}.extraGroups = [ "docker" ];
}
