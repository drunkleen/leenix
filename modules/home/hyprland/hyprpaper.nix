{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  wallpaper = inputs.self.packages.${pkgs.system}.leenium-wallpapers;
in
{
  services.hyprpaper = {
    enable = true;
    package = pkgs.hyprpaper;

    settings = {
      preload = [ "${wallpaper}/share/wallpapers/leenium-main.jpg" ];

      wallpaper = [
        {
          monitor = "auto";
          path = "${wallpaper}/share/wallpapers/leenium-main.jpg";
          fit_mode = "cover";
        }
      ];

      splash = false;
    };
  };

  systemd.user.services.hyprpaper = {
    Unit = {
      After = lib.mkForce [ config.leenix.fallbackSession.target ];
      PartOf = lib.mkForce [ config.leenix.fallbackSession.target ];
    };
    Install.WantedBy = lib.mkForce [ config.leenix.fallbackSession.target ];
  };
}
