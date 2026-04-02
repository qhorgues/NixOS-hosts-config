{secretsPath, config, ...}: {
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };

  age.secrets.wireguard-key = {
    file = "${secretsPath}/fw-laptop-16/wireguard-key.age";
    owner = "root";
    mode  = "0400";
  };

  networking.networkmanager.ensureProfiles = {
    profiles = {
      "VPN-Parent" = {
        connection = {
          id = "vpn-parent";
          type = "wireguard";
        };
        wireguard = {
          private-key = config.age.secrets.wireguard-key.file;
        };
        "wireguard-peer.CLEF_PUBLIQUE_DU_SERVEUR=" = {
          endpoint = "vpn.exemple.com:51820";
          allowed-ips = "0.0.0.0/0;";
        };
        ipv4 = {
          method = "manual";
          address1 = "10.0.0.2/24";
        };
      };
    };
  };
}
