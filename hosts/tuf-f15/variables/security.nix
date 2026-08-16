{
  security = {
    pam = {
      enable = true;
    };

    fido2 = {
      enable = false;
      userPresence = true;
      userVerification = false;
      pinVerification = true;
    };

    firewall = {
      enable = true;

      rules = [
        {
          name = "ssh-lan";
          protocol = "tcp";
          ports = [ 22 ];
          sources = [ "10.42.0.0/24" ];
        }
        {
          name = "ssh-tailscale";
          protocol = "tcp";
          ports = [ 22 ];
          interfaces = [ "tailscale0" ];
        }
      ];
    };
  };
}
