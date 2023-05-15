{ lib, ... }: {
  networking.wireless.enable = lib.mkForce false;
  networking.networkmanager.enable = true;
}
