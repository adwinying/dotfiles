{
  description = "Personal nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Authorized SSH public keys
    sshAuthorizedKeys.url = "https://github.com/adwinying.keys";
    sshAuthorizedKeys.flake = false;

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      macdev = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          hostname = "macdev";
          username = "adwin";
          system   = "aarch64-linux";
        };
        modules = [ ./machines ];
      };
    };
  };
}
