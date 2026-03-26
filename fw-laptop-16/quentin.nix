{ pkgs, qhorgues-config, ... }:
{
  imports = [
    ./home-manager/zed-remote-folder.nix
  ];

  mx = {
    update = {
        flake_path = "/home/quentin/config";
        flake_config = "default";
    };
    auto-update.enable = true;
    desktop-environment.gnome.connection = true;
    programs = {
      firefox.enable = true; # Install firefox pre setup
      thunderbird.enable = true; # # Install thunderbird
      cryptomator.enable = true; # Install cryptomator
      office.enable = true; # Install all office tools (libbre office, only office, latex studio)
      discord.enable = true; # Install discord flatpak
      element.enable = true; # Install Element flatpak
      audio-enhancer.enable = true; # Install audio enhancer with custom profiles
      zed-editor.enable = true; # Install custom zed editor
      ssh.enable = true; # Install ssh client
      vscode.enable = true; # Install custom VS Code
      kdrive.enable = true; # Install kdrive
      graphism.enable = true; # Install graphism tools (GIMP, Krita, Inkscape)
      git.enable = true; # Install git with config
      vim.enable = false; # Install vim
      linux-base-tools.enable = true; # Install linux base tools (htop, fastfetch, ...)
      winboat.enable = true; # Install Winboat /!\ NEED ENABLE DOCKER ON SYSTEM CONFIG

      # Enable dev tools
      dev = {
        enable = true;
        nix = true;
        cpp = true;
        mpi-lib = true;
        rust = true;
        python = true;
        node = true;
        php = true;
        sql = true;
        java = true;
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

  home.file.".config/BOE_CQ_______NE160QDM_NZ6.icm".source = ./home-manager/BOE_CQ_______NE160QDM_NZ6.icm;

  home.packages = [
    pkgs.sushi
    qhorgues-config.packages.${pkgs.stdenv.hostPlatform.system}.coe33
  ];

  nix.settings.secret-key-files = [ "/etc/nix/signing-key.sec" ];
}
