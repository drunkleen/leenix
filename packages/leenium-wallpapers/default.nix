{
  lib,
  imagemagick,
  stdenvNoCC,
}:

let
  palette = import ../../lib/leenium.nix;
  bg = palette.background.main;
  surface = palette.neutral.elevated;
  teal = palette.accent.teal;
  cyan = palette.accent.cyan;
  size = "2560x1440";
in

stdenvNoCC.mkDerivation {
  pname = "leenium-wallpapers";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ imagemagick ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/wallpapers"

    magick -size ${size} gradient:${bg}-${surface} -fill "${teal}44" -draw "circle 1280,720 2160,720" -fill "${cyan}33" -draw "circle 1280,720 1920,720" -fill "${teal}55" -draw "circle 1280,720 1620,720" -quality 92 "$out/share/wallpapers/leenium-main.jpg"

    runHook postInstall
  '';

  meta = {
    description = "Original dark Leenium wallpapers";
    homepage = "https://leenix.local";
    license = lib.licenses.mit;
  };
}
