{
  description = "Raspberry Pi 5 configuration flake";
    inputs = {
      nixpkgs.follows = "qhorgues-config/nixpkgs";
      nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
      qhorgues-config.url = "github:qhorgues/NixOS-config";
      # nixos-hardware.url = "github:NixOS/nixos-hardware";
      home-manager = {
        url = "github:nix-community/home-manager/release-25.11";
        inputs.nixpkgs.follows = "nixpkgs";
		  };
    };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

	outputs = { self, nixpkgs, nixos-raspberrypi, qhorgues-config, home-manager, ... }@inputs:
	{
	  nixosConfigurations = {
		 rpi-horgues = nixos-raspberrypi.lib.nixosSystem {
      specialArgs = { 
        	inherit nixos-raspberrypi;
	        self = qhorgues-config;
	      };
        modules = [
	        ./configuration.nix
	        qhorgues-config.nixosModules.modulix-os
	        home-manager.nixosModules.default
        ];
      };
    };
  };
}
