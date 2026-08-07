{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    networkmanagerapplet
  ];

  systemd.user.services.nm-applet = {
    Unit = {
      After = lib.mkForce [ config.leenix.fallbackSession.target ];
      PartOf = lib.mkForce [ config.leenix.fallbackSession.target ];
      Description = "NetworkManager Applet";
    };

    Service = {
      ExecStart = lib.getExe pkgs.networkmanagerapplet;
      Restart = "on-failure";
    };

    Install.WantedBy = lib.mkForce [ config.leenix.fallbackSession.target ];
  };
}
