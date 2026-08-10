{ nixos-hardware, lib, pkgs, ... }:
{
    imports = [
      nixos-hardware.nixosModules.framework-16-7040-amd
      ./hardware-configuration.nix
    ];

    time.timeZone = lib.mkForce "Asia/Ho_Chi_Minh";

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
      kernel = {
        cachyos-kernel = {
          enable = true;
          package = pkgs.cachyosKernels.linux-cachyos-bore-zen4;
        };
      };
      main-user = { # Define main user
        enable = true;
        userName = "quentin";
        userFullName = "Quentin Horgues";
      };
      desktop = {
        environment = "gnome"; # "none"/"gnome"/"plasma"/"lxqt"
        gnome = {
          scaling = 2;
          text-scaling = 0.7;
        };
      };
      fonts.enable = true;
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
        lamp.enable = false; # Enable Apache/PHP/MariaDB stack
        postgresql.enable = false; # Enable postgres SQL
        llm = {
          enable = true;
          ramOverflow.enable = true;
          open-webui.enable = false;
          modelsPreset = {
            "gemma4:e4b" = {
              hf-repo = "bartowski/google_gemma-4-E4B-it-GGUF";
              hf-file = "google_gemma-4-E4B-it-Q4_K_M.gguf";
              alias    = "gemma4:e4b";
              ctx-size = "65536";
              temp     = "1.0";
              top-p    = "0.95";
              min-p    = "0.01";
              top-k    = "40";
              jinja    = "on";
              load-on-startup = "false";
              stop-timeout    = "60";
            };
            "qwen2.5-coder:7b" = {
              hf-repo = "bartowski/Qwen2.5-Coder-7B-Instruct-GGUF";
              hf-file = "Qwen2.5-Coder-7B-Instruct-Q4_K_M.gguf";
              alias    = "qwen2.5-coder:7b";
              ctx-size = "32768";
              temp     = "0.7";
              top-p    = "0.95";
              min-p    = "0.01";
              top-k    = "20";
              jinja    = "on";
              load-on-startup = "false";
              stop-timeout    = "60";
            };

            "qwen3.5:9b" = {
              hf-repo = "bartowski/Qwen_Qwen3.5-9B-GGUF";
              hf-file = "Qwen_Qwen3.5-9B-Q4_K_M.gguf";
              alias    = "qwen3.5:9b";
              ctx-size = "262144";
              temp     = "1.0";
              top-p    = "0.95";
              min-p    = "0.01";
              top-k    = "40";
              jinja    = "on";
              load-on-startup = "false";
              stop-timeout    = "60";
            };
          };
        };
        printing.enable = false;
        ios-connect.enable = false; # Enable IOS connection tools
        remote-desktop = { # Sunshine game streaming server
          enable = true;
          app = [
            {
              name = "Smartphone";
              steam = true;
              output = "DP-8";
            }
            {
              name = "Laptop 13";
              steam = true;
              output = "DP-7";
            }
          ];
        };
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
        modeling.enable = true;
        obs-studio.enable = false;
        games = {
          enable = true;
          latest-unstable-mesa-driver.enable = false;
          force-fsr4-for-rdna3 = true; # Only for AMD radeon 7000 user
          users = [ "quentin" ]; # Allowed user for gamemode
          game_lib_dirs = [
            "/mnt/Games"
          ];
          lsfg.enable = false;
          heroic.enable = false;
          lutris.enable = false;
          umu.enable = false;

          gamescopeSession = {
            enable = true;
            screen = {
              width = 2560;
              height = 1440;
            };
          };
        };
        team-viewer.enable = false; # Enable team viewerapp
        arduino = { # Enable arduino dev kit
          enable = false;
          users = [ "quentin" ]; # Allowed user for arduino access
        };
      };
      virtual-display = {
        enable = true;
        displays = [
          {
            videoOutput = "DP-7";
            width = 1920;
            height = 1080;
            refreshRate = 60;
            displayName = "Laptop13";
          }
          {
            videoOutput = "DP-8";
            width = 2404;
            height = 1080;
            refreshRate = 120;
            enableHdr = true;
            displayName = "Smartphone";
          }
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      (callPackage ./pkgs/fw16-keyboard.nix { })
    ];

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

    nix.settings = {
      extra-platforms = [ "aarch64-linux" ];
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    services.keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings = {
          main = {
            rightalt = "layer(altgr)";
          };
          altgr = {
            "1" = "e";
            "S-1" = "E";
          };
        };
      };
    };
}
