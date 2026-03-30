{

  description = "My personnal host config";

  inputs = {
    qhorgues-config.url = "github:qhorgues/NixOS-config";
    nixpkgs.follows = "qhorgues-config/nixpkgs";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    qhorgues-config.inputs.nixpkgs-unstable.follows = "nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = { self, qhorgues-config, nixos-hardware, ... }:
  {
    nixosConfigurations =
    {
      fw-laptop-16 = qhorgues-config.lib.make-system {
        system = "x86_64-linux";
        modules = [
          ./fw-laptop-16/configuration.nix
        ];
        specialArgs = {
          inherit nixos-hardware;
        };
      };
    };
  };
}
