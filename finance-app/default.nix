{ config, pkgs, lib, ... }:

{
  imports = [
    ./postgres-finance.nix
  ];
  
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3001 ];
  };

  environment.systemPackages = with pkgs; [
    nodejs_20
    nodePackages.npm
  ];

   users.groups.finance-app.members = ["quentin" "fabrice"];

  systemd.tmpfiles.rules = [
    # Type  Chemin                    Mode  User  Groupe       Age  Arg
    "d      /srv/finance-app          0770  root  finance-app   -    -"
  ];

  systemd.services.finance-app = {
    description = "Serveur Node.js";
    after       = [ "network.target" ];
    wantedBy    = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart     = "${pkgs.nodejs_20}/bin/node /srv/finance-app/backend-server.js";
      WorkingDirectory = "/srv/finance-app";
      Restart       = "on-failure";
      RestartSec    = "5s";

      User          = "finance-app-runner";
      Group         = "finance-app";

      NoNewPrivileges      = true;
      ProtectSystem        = "strict";
      ReadWritePaths       = [ "/srv/finance-app/files" ];
      PrivateTmp           = true;
    };
  };

  users.users.finance-app-runner = {
    isSystemUser = true;
    group        = "finance-app";
    description  = "Utilisateur du service Node.js";
  };
}
