{
  networking = {
    iwd = true;

    ssh = {
      enable = true;
      autoStart = false;
      port = 22;

      passwordAuthentication = true;
      keyboardInteractiveAuthentication = false;
      permitRootLogin = "no";

      allowedUsers = [ "snape" ];

      publicKeys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPDUHKfH8eRMUlbQg4CKDo2cS3zFL+M03tRrFs/5fF4LAAAABHNzaDo= snape@drunkleen.com"
      ];
    };

    dns = {
      mode = "system";
      servers = [ ];
    };
  };
}
