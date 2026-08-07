{
  lib,
  makeWrapper,
  quickshell,
  stdenvNoCC,
}:

let
  leenium = import ../../lib/leenium.nix;

  colors = {
    bar = leenium.background.panel;
    text = leenium.neutral.foreground;
    muted = leenium.neutral.muted;
    accent = leenium.accent.cyan;
    active = leenium.background.active;
    urgent = leenium.accent.red;
  };

  mkColorLine = name: "  readonly property color ${name}: \"${colors.${name}}\"";

  colorsQml = lib.concatStringsSep "\n" (
    [
      "pragma Singleton"
      "import QtQuick"
      ""
      "QtObject {"
    ]
    ++ (map mkColorLine (builtins.attrNames colors))
    ++ [
      "}"
      ""
    ]
  );
in
stdenvNoCC.mkDerivation {
  pname = "leenix-shell";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/leenix-shell
    cp -r $src/qml/*.qml $out/share/leenix-shell/
    cp "$colorsQmlFile" $out/share/leenix-shell/Colors.qml

    makeWrapper ${lib.getExe quickshell} "$out/bin/leenix-shell" \
      --add-flags "--no-duplicate -p $out/share/leenix-shell"

    runHook postInstall
  '';

  colorsQmlFile = builtins.toFile "Colors.qml" colorsQml;

  meta = {
    mainProgram = "leenix-shell";
  };
}
