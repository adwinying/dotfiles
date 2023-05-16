{ lib, username, ... }: {
  networking.wireless.enable = lib.mkForce false;
  networking.networkmanager.enable = true;
  users.users.${username}.extraGroups = [ "networkmanager" ];
}
