{
  description = "Personal nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Nixpkgs (bleeding edge)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Nix-darwin
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Authorized SSH public keys
    sshAuthorizedKeys.url = "https://github.com/adwinying.keys";
    sshAuthorizedKeys.flake = false;

    # TODO: Add any other flake you might need
    # flake-utils.url = "github:numtide/flake-utils";
    # hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { nixpkgs, nix-darwin, home-manager, ... }@inputs: {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    # Live ISOs can be built using `nix build .#nixosConfigurations.live-$(uname -m).config.system.build.isoImage`
    nixosConfigurations = let
      mkMachineConfig = { hostname, ... }@attrs: nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs ; } // attrs;
        modules = [ ./machines/${hostname}/configuration.nix ];
      };
    in {
      workdev = mkMachineConfig {
        hostname = "workdev";
        username = "ying.z";
        system   = "aarch64-linux";
      };

      mayodev = mkMachineConfig {
        hostname = "mayodev";
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

      router = mkMachineConfig {
        hostname = "router";
        username = "adwin";
        system   = "x86_64-linux";
      };

      outpost = mkMachineConfig {
        hostname = "outpost";
        username = "adwin";
        system   = "x86_64-linux";
      };

      nas = mkMachineConfig {
        hostname = "nas";
        username = "adwin";
        system   = "x86_64-linux";
      };

      thkpad = mkMachineConfig {
        hostname = "thkpad";
        username = "adwin";
        system   = "x86_64-linux";
      };

      live-x86_64 = mkMachineConfig {
        hostname = "live";
        username = "nixos";
        system   = "x86_64-linux";
      };

      live-aarch64 = mkMachineConfig {
        hostname = "live";
        username = "nixos";
        system   = "aarch64-linux";
      };
    };

    # Nix-darwin configuration entrypoint
    # Available through 'darwin-rebuild --flake .#your-hostname'
    darwinConfigurations = let
      mkMachineConfig = { hostname, ... }@attrs: nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs ; } // attrs;
        modules = [ ./machines/${hostname}/configuration.nix ];
      };
    in {
      mayonaca = mkMachineConfig {
        hostname = "mayonaca";
        username = "adwin";
        system   = "aarch64-darwin";
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
          modules = [
            ./profiles/base.nix
            ./profiles/cli.nix
          ] ++ profiles;
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
