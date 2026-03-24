{ pkgs, qhorgues-config, ... }:
{
  imports = [
  ];

  mx = {
    update = {
        flake_path = "/etc/nixos";
        flake_config = "rpi-horgues";
    };
    auto-update.enable = true;
    programs = {
      firefox.enable = true; # Install firefox pre setup
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
      git.enable = true; # Install git with config
      vim.enable = false; # Install vim
      linux-base-tools.enable = true; # Install linux base tools (htop, fastfetch, ...)
      winboat.enable = false; # Install Winboat /!\ NEED ENABLE DOCKER ON SYSTEM CONFIG

      # Enable dev tools
      dev = {
        enable = true;
        nix = true;
        cpp = false;
        mpi-lib = false;
        rust = false;
        python = false;
        node = false;
        php = false;
        sql = true;
        java = false;
        gnome-dev = false;
        ci = false;
      };
    };
  };

  home.username = "quentin";
  home.homeDirectory = "/home/quentin";
  home.keyboard = {
    layout = "fr";
    variant = "fr";
  };
}
