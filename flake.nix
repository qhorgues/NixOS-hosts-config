{
  description = "A very basic flake";

  inputs = {
    qhorgues-config.url = "github:quentin/NixOS-config/remote-flake";
    nixpkgs.follows = "qhorgues-config/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
        url = "github:nix-community/home-manager/release-25.11";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, qhorgues-config, ... }@inputs:
  let
    nixpkgsConfig = {
      allowUnfree = true;
    };
  in
  {
    nixosConfigurations =
    {
      default = let
        system = "x86_64-linux";
      in nixpkgs.lib.nixosSystem
      {
        system = system;
        specialArgs = { inherit self qhorgues-config;
            pkgs-unstable = import nixpkgs-unstable {
              system = system;
              config = nixpkgsConfig;
            };
        };
        modules = [
          qhorgues-config.nixosModules.modulix-os
          ./configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
