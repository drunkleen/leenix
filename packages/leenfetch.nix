{
  lib,
  rustPlatform,
  src,
  ...
}:

# LEENIX About tool: leenfetch (github:drunkleen/leenfetch). Pure-Rust, no
# native build dependencies (image png/jpeg features are pure Rust). Packaged
# from the pinned flake input; not (yet) in nixpkgs.
rustPlatform.buildRustPackage rec {
  pname = "leenfetch";
  version = "1.4.2";

  inherit src;

  cargoLock.lockFile = "${src}/Cargo.lock";

  # Two unit tests in modules/linux/info/gpu.rs read the live /sys/class/drm
  # layout of the build machine and are not hermetic (fail in the sandbox);
  # the binary itself builds and runs cleanly.
  doCheck = false;

  meta = with lib; {
    description = "Fast, minimal, customizable system info tool in Rust (Neofetch alternative)";
    homepage = "https://github.com/drunkleen/leenfetch";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "leenfetch";
  };
}
