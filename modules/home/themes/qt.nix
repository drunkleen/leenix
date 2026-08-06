{ pkgs, ... }:

let
  leenium = import ../../../lib/leenium.nix;
  kvantum = pkgs.kdePackages.qtstyleplugin-kvantum;

  leeniumKvantumTheme = pkgs.runCommand "leenium-kvantum-theme" { } ''
    theme="$out/share/Kvantum/Leenium"
    mkdir -p "$theme"
    substitute ${kvantum}/share/Kvantum/KvGnome/KvGnome.kvconfig "$theme/Leenium.kvconfig" \
      --replace-fail '#f6f5f4' '${leenium.neutral.background}' \
      --replace-fail '#ffffff' '${leenium.neutral.foreground}' \
      --replace-fail '#f1efee' '${leenium.neutral.surface}' \
      --replace-fail '#3584e4' '${leenium.accent.teal}' \
      --replace-fail '#c4beb8ff' '${leenium.neutral.border}' \
      --replace-fail '#D9D9D9' '${leenium.neutral.elevated}' \
      --replace-fail '#787878' '${leenium.neutral.muted}' \
      --replace-fail '#0057AE' '${leenium.accent.cyan}' \
      --replace-fail '#452886' '${leenium.accent.blue}'
    ln -s ${kvantum}/share/Kvantum/KvGnome/KvGnome.svg "$theme/Leenium.svg"
  '';
in
{
  qt = {
    enable = true;

    platformTheme.name = "gtk";

    style = {
      name = "kvantum";
      package = [
        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.qt6Packages.qtstyleplugin-kvantum
      ];
    };
  };

  home = {
    packages = [ leeniumKvantumTheme ];
    sessionVariables.KVANTUM_THEME = "Leenium";
  };

  systemd.user.sessionVariables.KVANTUM_THEME = "Leenium";
}
