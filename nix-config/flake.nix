{
  description = "Personal nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    # Nixpkgs (bleeding edge)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Authorized SSH public keys
    sshAuthorizedKeys.url = "https://github.com/adwinying.keys";
    sshAuthorizedKeys.flake = false;

    # TODO: Add any other flake you might need
    # flake-utils.url = "github:numtide/flake-utils";
    # hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = let
      mkMachineConfig = { hostname, ... }@attrs: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs ; } // attrs;
        modules = [ ./machines/${hostname}/configuration.nix ];
      };
    in {
      workdev = mkMachineConfig {
        hostname = "workdev";
        username = "adwin";
        system   = "aarch64-linux";
      };

      tunnel = mkMachineConfig {
        hostname = "tunnel";
        username = "adwin";
        system   = "aarch64-linux";
      };

      bootes = mkMachineConfig {
        hostname = "bootes";
        username = "adwin";
        system   = "aarch64-linux";
      };
    };
  };
}
