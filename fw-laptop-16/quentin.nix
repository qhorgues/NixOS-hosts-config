{ pkgs, qhorgues-config, ... }:
{
  imports = [
    ./home-manager/zed-remote-folder.nix
  ];

  mx = {
    update = {
        flake_path = "/home/quentin/config";
        flake_config = "fw-laptop-16";
    };
    auto-update.enable = true;
    desktop-environment.gnome.connection = true;
    programs = {
      firefox.enable = true; # Install firefox pre setup
      thunderbird.enable = true; # # Install thunderbird
      cryptomator.enable = true; # Install cryptomator
      office.enable = true; # Install all office tools (libre office, only office, latex studio)
      discord.enable = true; # Install discord flatpak
      element.enable = true; # Install Element flatpak
      audio-enhancer.enable = true; # Install audio enhancer with custom profiles
      zed-editor = {
        enable = true; # Install custom zed editor
        ollamaNumberToken = 100000;
      };
      ssh.enable = true; # Install ssh client
      vscode.enable = false; # Install custom VS Code
      kdrive.enable = true; # Install kdrive
      graphism.enable = true; # Install graphism tools (GIMP, Krita, Inkscape)
      git.enable = true; # Install git with config
      vim.enable = false; # Install vim
      linux-base-tools.enable = true; # Install linux base tools (htop, fastfetch, ...)
      winboat.enable = false; # Install Winboat /!\ NEED ENABLE DOCKER ON SYSTEM CONFIG

      # Enable dev tools
      dev = {
        enable = true;
        nix = true;
        cpp = true;
        mpi-lib = false;
        openmp-lib = false;
        rust = true;
        python = true;
        node = true;
        php = false;
        sql = true;
        java = false;
        gnome-dev = true;
        ci = false;
      };
    };
  };

  home.keyboard = {
    layout = "fr";
    variant = "fr";
  };

  home.file.".config/BOE_CQ_______NE160QDM_NZ6.icm".source = ./home-manager/BOE_CQ_______NE160QDM_NZ6.icm;

  home.packages = let
    mkGameConfigSwitcher = { ... } @ args: qhorgues-config.lib.mkGameConfigSwitcher ({
      inherit pkgs;
      saveBase = "$HOME/kDrive/Documents/Loisirs/Jeux";
      steamLibrary = "/mnt/Games/SteamLibrary";
    } // args);

  in
  [
    qhorgues-config.packages.${pkgs.stdenv.hostPlatform.system}.coe33
    pkgs.obsidian
    pkgs.filezilla
    pkgs.bitwarden-desktop

    (mkGameConfigSwitcher {
      game = "aoe4";
      savePath = "AOE4/Config-FW-16";
      steamId = "1466860";
      files = [
        {
          fileName = "configuration_system.lua";
          winPath = "users/steamuser/Documents/My Games/Age of Empires IV";
        }
      ];
    })
    (mkGameConfigSwitcher {
      game = "coe33";
      savePath = "Clair-Obscur_Expedition33/Config-FW-16";
      steamId = "1903340";
      files = [
        {
          fileName = "GameUserSettings.ini";
          winPath = "users/steamuser/AppData/Local/Sandfall/Saved/Config/Windows";
        }
      ];
    })
    (mkGameConfigSwitcher {
      game = "ml";
      savePath = "ManorLord/Config-FW-16";
      steamId = "1363080";
      files = [
        {
          fileName = "GameUserSettings.ini";
          winPath = "users/steamuser/AppData/Local/ManorLords/Saved/Config/Windows";
        }
        {
          fileName = "UserSettings.ini";
          winPath = "users/steamuser/AppData/Local/ManorLords/Saved/Config/Windows";
        }
      ];
    })
    # qhorgues-config.packages.${pkgs.stdenv.hostPlatform.system}.kiwix
  ];

  nix.settings.secret-key-files = [ "/etc/nix/signing-key.sec" ];
}
