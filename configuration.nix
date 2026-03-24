{...}:
{
	imports = [
		./hardware-configuration.nix
		#./wireguard.nix
		./finance-app
	];

	mx = {
      core.network.security-mode = false;
      bootloader.enable = false;
      hardware = {
        ssd.lists = [ "/" ]; # All mountpoint with a SSD
        framework-fan-ctrl.enable = false; # If you use framework-laptop
        powersave.enable = false; # Auto energy saving mode on batterie
        bluetooth.enable = false;
        gpu = {
          vendor = null; #  "amd"/"nvidia"/"intel"
          computing = null; #  "rocm"/"cuda" or null
          generation = null;
        };
      };
      main-user = { # Define main user
        enable = true;
        userName = "quentin";
        userFullName = "Quentin Horgues";
      };
      gnome = {
        enable = true;
        remote-desktop = true;
      };
      services = {
        vm = {
          enable = false; # Enable VM tools
          users = [ "quentin" ]; # Trusted user
        };
        docker = {
          enable = false; # Enable docker tools
          users = [ "quentin" ]; # Trusted user
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
        home-manager = {
          enable = true;
          users = {
            quentin = {
              configPath = ./quentin.nix;
              homeModule = "quentin";
            };
            fabrice = {
              configPath = ./fabrice.nix;
            };
          };
        };
        modeling.enable = false;
        obs-studio.enable = false;
        games = {
          enable = false;
          gamemode.users = [ "quentin" ]; # Allowed user for gamemode
        };
        team-viewer.enable = false; # Enable team viewerapp
        arduino = { # Enable arduino dev kit
          enable = false;
          users = [ "quentin" ]; # Allowed user for arduino access
        };
      };
    };

    networking.hostName = "rpi-horgues";

    users.users."fabrice"= {
      isNormalUser = true;
      initialPassword = "1234";
      description = "Fabrice Horgues";
      extraGroups = [ "networkmanager" ];
    };
    services.gnome.gnome-remote-desktop.enable = true;
    networking.firewall.allowedTCPPorts = [ 3389 ];
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        domain = true;
        addresses = true;
      };
    };

    services.openssh = {
      enable = true;
      ports = [ 1317 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "quentin" "fabrice" ];
      };
    };
    nix.settings.trusted-public-keys = [
      "fw-laptop-16:d+GNo/L8eIPwX9Raqt7LAugodyJT2YAALYsbKu0m1O4="
    ];
    nix.settings.trusted-users = [ "quentin" ];
}
