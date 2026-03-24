{ config, pkgs, ... }:

{
  # Activer le forwarding IP
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.wireguard.interfaces = {
    wg0 = {
      # IP du serveur dans le tunnel
      ips = [ "10.100.0.1/24" ];
      listenPort = 51820;

      # Clé privée (générer avec : wg genkey)
      privateKeyFile = "/etc/wireguard/private.key";

      # Règles de routage post-up/down
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      peers = [
        {
          # Client 1
          publicKey = "CLEF_PUBLIQUE_CLIENT_1=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          # Client 2
          publicKey = "CLEF_PUBLIQUE_CLIENT_2=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };

  # Ouvrir le port dans le firewall
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
    # Autoriser le trafic entre les peers
    extraCommands = ''
      iptables -A FORWARD -i wg0 -j ACCEPT
      iptables -A FORWARD -o wg0 -j ACCEPT
    '';
  };
}
