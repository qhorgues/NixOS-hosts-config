{ pkgs, qhorgues-config, ... }:
{
  imports = [
  ];

  mx = {
    update = {
        flake_path = "/home/quentin/config";
        flake_config = "default";
    };
    auto-update.enable = true;
    programs = {
      firefox.enable = false; # Install firefox pre setup
      thunderbird.enable = false; # # Install thunderbird
      cryptomator.enable = false; # Install cryptomator
      office.enable = false; # Install all office tools (libbre office, only office, latex studio)
      discord.enable = false; # Install discord flatpak
      element.enable = false; # Install Element flatpak
      audio-enhancer.enable = false; # Install audio enhancer with custom profiles
      zed-editor.enable = false; # Install custom zed editor
      ssh.enable = false; # Install ssh client
      vscode.enable = false; # Install custom VS Code
      kdrive.enable = false; # Install kdrive
      graphism.enable = false; # Install graphism tools (GIMP, Krita, Inkscape)
      git.enable = false; # Install git with config
      vim.enable = false; # Install vim
      linux-base-tools.enable = false; # Install linux base tools (htop, fastfetch, ...)
      winboat.enable = false; # Install Winboat /!\ NEED ENABLE DOCKER ON SYSTEM CONFIG

      # Enable dev tools
      dev = {
        enable = false;
        nix = false;
        cpp = false;
        mpi-lib = false;
        rust = false;
        python = false;
        node = false;
        php = false;
        sql = false;
        java = false;
        gnome-dev = false;
        ci = false;
      };
    };
  };

  home.username = "<username>";
  home.homeDirectory = "/home/quentin";
  home.keyboard = {
    layout = "fr";
    variant = "fr";
  };

  home.packages = [
    pkgs.sushi
    qhorgues-config.packages.coe33.${pkgs.stdenv.hostPlatform.system}
  ];
}
