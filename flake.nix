{
  description = "Template config";

  inputs = {
    qhorgues-config.url = "github:qhorgues/NixOS-config";
    nixpkgs.follows = "qhorgues-config/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    home-manager = {
        url = "github:nix-community/home-manager/release-25.11";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, qhorgues-config, nixos-hardware, home-manager, ... }:
  let
    nixpkgsConfig = {
      allowUnfree = true;
    };
  in
  {
    nixosConfigurations =
    {
      default = let
        system = "x86_64-linux"; # Depend on your architechture
        pkgs-unstable = import nixpkgs-unstable {
          system = system;
          config = nixpkgsConfig;
        };
      in nixpkgs.lib.nixosSystem
      {
        system = system;
        specialArgs = { inherit nixos-hardware pkgs-unstable;
          self = qhorgues-config;
        };
        modules = [
          qhorgues-config.nixosModules.modulix-os
          home-manager.nixosModules.default
          ./configuration.nix
        ];
      };
    };

  };
}
