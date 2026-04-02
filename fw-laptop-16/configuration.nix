{ nixos-hardware, ... }:
{
    imports = [
      nixos-hardware.nixosModules.framework-16-7040-amd
      ./hardware-configuration.nix
      # ./vpn.nix
    ];

    mx = {
      core.network.security-mode = false;
      hardware = {
        ssd.lists = [ "/" "/mnt/Games" ]; # All mountpoint with a SSD
        framework-fan-ctrl.enable = true; # If you use framework-laptop
        powersave.enable = false; # Auto energy saving mode on batterie
        gpu = {
          vendor = "amd"; #  "amd"/"nvidia"/"intel"
          computing = "rocm"; #  "rocm"/"cuda" or null
          generation = "rdna3"; # Use chipset reférence or null
          # (ex: Nvidia: "ada-lovelace", "blackwell",
          #               "ampere", "pascal",
          #  AMD: "rdna4", "gcn-4-gen", "gcn-1-gen")
        };
        bluetooth.enable = true;
      };
      main-user = { # Define main user
        enable = true;
        userName = "quentin";
        userFullName = "Quentin Horgues";
      };
      gnome = {
        enable = true;
        scaling = 2;
        text-scaling = 0.7;
      };
      services = {
        vm = {
          enable = true; # Enable VM tools
          allArchitectures = true;
          users = [ "quentin" ]; # Trusted user
        };
        docker = {
          enable = true; # Enable docker tools
          users = [ "quentin" ]; # Trusted user
        };
        lamp.enable = true; # Enable Apache/PHP/MariaDB stack
        postgresql.enable = false; # Enable postgres SQL
        llm = {
          enable = true; # Enable ollama tools
          open-webui.enable = true;
        };
        printing.enable = true;
        ios-connect.enable = false; # Enable IOS connection tools
      };
      programs = { # Enable some system app
        home-manager = {
          enable = true;
          users = {
            quentin = {
              configPath = ./quentin.nix;
              homeModule = "quentin";
            };
          };
        };
        modeling.enable = false;
        obs-studio.enable = true;
        games = {
          enable = true;
          aggressive = true;
          force-fsr4-for-rdna3 = true; # Only for AMD radeon 7000 user
          gamemode.users = [ "quentin" ]; # Allowed user for gamemode
          lsfg.enable = false;
          heroic.enable = false;
          lutris.enable = false;
          umu.enable = false;
        };
        team-viewer.enable = false; # Enable team viewerapp
        arduino = { # Enable arduino dev kit
          enable = true;
          users = [ "quentin" ]; # Allowed user for arduino access
        };
      };
    };

    networking.hostName = "fw-laptop-16";


    fileSystems."/mnt/Games" =
    { device = "/dev/disk/by-uuid/1b35568b-4447-4c80-9880-4b359d4ecb6c";
        fsType = "ext4";
    };

    boot.kernelParams = [
    ];

    services.udev.extraRules = ''
        # Framework Laptop 16 Keyboard Module - ANSI
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0012", ATTR{power/wakeup}="disabled"

        # Framework Laptop 16 RGB Macropad
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0013", ATTR{power/wakeup}="disabled"

        # Framework Laptop 16 Numpad Module
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0014", ATTR{power/wakeup}="disabled"

        # Framework Laptop 16 Keyboard Module - ISO
        ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0018", ATTR{power/wakeup}="disabled"
    '';

    # Fix for AMD GPU crash
    nixpkgs.overlays = [
      (self: super:
        let
          version = "20250808";
        in
        {
        linux-firmware = super.linux-firmware.overrideAttrs (old: {
          version = version;
          src = super.fetchurl {
            url = "https://cdn.kernel.org/pub/linux/kernel/firmware/linux-firmware-${version}.tar.xz";
            sha256 = "sha256-wClVG0WhWSbJ16XfGgtUAEQGTxkVfFf8Edkf0Kreg38=";
          };
          patches = [];
        });
      })
    ];

    nix.settings = {
      sandbox = false;
      extra-platforms = [ "aarch64-linux" ];
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
}
