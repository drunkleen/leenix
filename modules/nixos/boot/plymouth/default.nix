# LEENIX Plymouth theme package.
# leenix.script is a minimal branding/color/logo substitution of the canonical
# upstream Omarchy theme (basecamp/omarchy @ 0820484, default/plymouth).
# lock.png/entry.png/bullet.png/progress_box.png/progress_bar.png under assets/
# are the upstream Omarchy PNGs used as geometry templates: dimensions and alpha
# channel are preserved exactly, RGB only is recolored to the LEENIX palette
# (accent #33b8a8, entry fill #11181a, track #182124) by
# /tmp/opencode/gen_leenix_assets.py (deterministic, Pillow 12.3.0).
# unlock.png is the user-supplied LEENIX logo, installed verbatim.
{
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "leenix-plymouth-theme";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/plymouth/themes/leenix"
    cp "$src/assets/"*.png "$out/share/plymouth/themes/leenix/"
    cp "$src/leenix.script" "$out/share/plymouth/themes/leenix/"
    sed -e "s|@THEME_OUT@|$out|" "$src/leenix.plymouth" \
      > "$out/share/plymouth/themes/leenix/leenix.plymouth"

    runHook postInstall
  '';
}
