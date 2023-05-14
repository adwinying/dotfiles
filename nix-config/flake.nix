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

      nas = mkMachineConfig {
        hostname = "nas";
        username = "adwin";
        system   = "x86_64-linux";
      };

      bootes = mkMachineConfig {
        hostname = "bootes";
        username = "adwin";
        system   = "aarch64-linux";
      };
    };

    # Home manager configuration entrypoint
    # nixOS configs already configures home-manager
    # so this is only for non-NixOS systems
    homeConfigurations = let
      mkUserConfig = { system, username, profiles, ... }@attrs:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = { inherit inputs; } // attrs;
          modules = [ ./users/adwin.nix ] ++ profiles;
        };
    in {
      docker-x86_64  = mkUserConfig {
        username = "root";
        system   = "x86_64-linux";
        profiles = [ ./profiles/container.nix ];
      };

      docker-aarch64 = mkUserConfig {
        username = "root";
        system   = "aarch64-linux";
        profiles = [ ./profiles/container.nix ];
      };
    };
  };
}
