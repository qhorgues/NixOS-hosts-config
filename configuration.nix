{ self, inputs, qhorgues-config, pkgs, pkgs-unstable, ... }:
{
    imports = [
        inputs.nixos-hardware.nixosModules.framework-16-7040-amd
        ./hardware-configuration.nix
    ];

    mx = {
      core.network.security-mode = true;
      hardware = {
        ssd.lists = [ "/" ]; # All mountpoint with a SSD
        framework-fan-ctrl.enable = false; # If you use framework-laptop
        powersave.enable = false; # Auto energy saving mode on batterie
        gpu = {
          vendor = "amd"; #  "nvidia"/"intel"
          acceleration = "rocm"; #  "cuda" or null
          generation = "rdna3"; # Use chipset reférence or null
          # (ex: Nvidia: "ada-lovelace", "blackwell",
          #               "ampere", "pascal",
          #  AMD: "rdna4", "gcn-4-gen", "gcn-1-gen")
        };
        bluetooth.enable = true;
      };
      main-user = { # Define main user
        enable = true;
        userName = "<username>";
        userFullName = "<Full name>";
      };
      gnome = {
        enable = true;
        scaling = 1;
        text-scaling = 1;
      };
      services = {
        vm = {
          enable = false; # Enable VM tools
          users = [ "<username>" ]; # Trusted user
        };
        docker = {
          enable = false; # Enable docker tools
          users = [ "<username>" ]; # Trusted user
        };
        lamp.enable = false; # Enable Apache/PHP/MariaDB stack
        postgresql.enable = false; # Enable postgres SQL
        llm = {
          enable = false; # Enable ollama tools
          open-webui.enable = false;
        };
        printing.enable = false;
        ios-connect.enable = false; # Enable IOS connection tools
      };
      programs = { # Enable some system app
        modeling.enable = false;
        obs-studio.enable = false;
        games = {
          enable = false;
          force-fsr4-for-rdna3 = false; # Only for AMD radeon 7000 user
          gamemode.users = [ "<username>" ]; # Allowed user for gamemode
        };
        team-viewer.enable = false; # Enable team viewerapp
        arduino = { # Enable arduino dev kit
          enable = false;
          users = [ "<username>" ]; # Allowed user for arduino access
        };
      };
    };

    networking.hostName = "<hostname>";


    boot.kernelParams = [
    ];

    services.udev.extraRules = ''
    '';

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
          inherit self inputs pkgs pkgs-unstable qhorgues-config;
      };
      users = {
        "<username>" = import ./username.nix;
      };
    };
}
