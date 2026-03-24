{ config, pkgs, lib, ... }:

{
  services.postgresql = {
    enable      = true;
    package     = pkgs.postgresql_18;

    dataDir     = "/var/lib/postgresql/18";

    # Authentification : local via peer pour postgres,
    # mot de passe scram-sha-256 pour les autres connexions
    authentication = lib.mkOverride 10 ''
      # TYPE  DATABASE        USER            ADDRESS       METHOD
      local   all             postgres                      peer
      local   finance_app     finance_app                   scram-sha-256
      host    finance_app     finance_app     127.0.0.1/32  scram-sha-256
      host    finance_app     finance_app     ::1/128       scram-sha-256
    '';

    settings = {
      max_connections        = 100;

      shared_buffers         = "1GB";
      work_mem               = "16MB";
      maintenance_work_mem   = "128MB";

      log_connections        = true;
      log_disconnections     = true;
      log_duration           = false;
      log_min_duration_statement = 500;

      client_encoding        = "UTF8";
    };

    # Création de la base et de l'utilisateur au premier démarrage
    initialScript = pkgs.writeText "pg-init.sql" ''
      -- Utilisateur applicatif
      CREATE USER finance_app WITH
        PASSWORD 'password'
        NOSUPERUSER
        NOCREATEDB
        NOCREATEROLE
        LOGIN;

      -- Base de données
      CREATE DATABASE finance_app
        OWNER     = finance_app
        ENCODING  = 'UTF8'
        LC_COLLATE = 'en_US.UTF-8'
        LC_CTYPE   = 'en_US.UTF-8'
        TEMPLATE  = template0;

      -- Droits sur la base
      GRANT CONNECT ON DATABASE finance_app TO finance_app ;

      -- Droits sur le schéma public
      \connect finance_app
      GRANT USAGE  ON SCHEMA public TO finance_app;
      GRANT CREATE ON SCHEMA public TO finance_app;
      GRANT ALL PRIVILEGES ON ALL TABLES    IN SCHEMA public TO finance_app;
      GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO finance_app;

      -- Droits par défaut pour les futures tables
      ALTER DEFAULT PRIVILEGES IN SCHEMA public
        GRANT ALL ON TABLES    TO finance_app;
      ALTER DEFAULT PRIVILEGES IN SCHEMA public
        GRANT ALL ON SEQUENCES TO finance_app;
    '';
  };

  networking.firewall.allowedTCPPorts = lib.mkIf
    config.services.postgresql.enable
    [ /* 5432 décommentez si accès réseau nécessaire */ ];

    users.groups.postgres.members = ["quentin" "fabrice"];
}
