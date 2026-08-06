{
  lib,
  makeWrapper,
  quickshell,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "leenix-shell";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm444 "$src/qml/shell.qml" "$out/share/leenix-shell/shell.qml"
    makeWrapper ${lib.getExe quickshell} "$out/bin/leenix-shell" \
      --add-flags "--no-duplicate -p $out/share/leenix-shell"

    runHook postInstall
  '';
}
