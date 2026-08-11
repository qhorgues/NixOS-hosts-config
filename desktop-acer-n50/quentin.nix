{ pkgs, qhorgues-config, ... }:
{
  imports = [
    ./home-manager/zed-remote-folder.nix
  ];

  mx = {
    update = {
        flake_path = "/home/quentin/config";
        flake_config = "desktop-acer-n50";
    };
    auto-update.enable = true;
    desktop-environment.gnome = {
      connection = false;
      live-wallpaper = true;
    };
    programs = {
      firefox.enable = true; # Install firefox pre setup
      thunderbird.enable = true; # # Install thunderbird
      cryptomator.enable = true; # Install cryptomator
      office.enable = true; # Install all office tools (libre office, only office, latex studio)
      discord.enable = true; # Install discord flatpak
      element.enable = true; # Install Element flatpak
      audio-enhancer.enable = false; # Install audio enhancer with custom profiles
      zed-editor.enable = true; # Install custom zed editor
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
        gnome-dev = false;
        ci = false;
      };
    };
  };

  home.keyboard = {
    layout = "fr";
    variant = "fr";
  };

  home.packages =
  [
    qhorgues-config.packages.${pkgs.stdenv.hostPlatform.system}.coe33
  ];
}
