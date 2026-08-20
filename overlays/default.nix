# LEENIX canonical overlay — the single package universe for every instance.
#
# Provides the LEENIX-flavoured package overrides consumed by all profiles,
# modules and instances:
#   - leenfetch: the LEENIX "About" tool, built from the pinned `leenfetch`
#     flake input source.
#   - hyprmon:    patched to skip rewriting the managed include when present.
#   - limine:     patched to demote the Linux-loader progress messages to
#                 verbose-only (clean menu -> Plymouth transition).
#
# This is a pure mechanical extraction of the overlay that previously lived in
# flake.nix; semantics are unchanged. Every derivation/toplevel that used the
# old overlay must produce identical output.
{ leenfetch }:
final: prev: {
  leenfetch = final.callPackage ../packages/leenfetch.nix {
    src = leenfetch;
  };

  # Patched HyprMon: skip rewriting the (possibly immutable, nix-managed) main
  # hyprland.lua when the managed `require("hyprmon")` include already exists.
  # See packages/hyprmon/skip-unchanged-config-write.patch.
  hyprmon = prev.hyprmon.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ../packages/hyprmon/skip-unchanged-config-write.patch ];
  });

  # Patched Limine: demote the two Linux-loader progress messages
  # ("linux: Loading kernel/module") to verbose-only output so the LEENIUM menu
  # stays visible and the menu -> Plymouth transition is clean, while panics,
  # warnings, menu, timeout, and boot semantics stay untouched.
  # See packages/limine/loading-messages-printv.patch.
  limine = prev.limine.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ../packages/limine/loading-messages-printv.patch ];
  });
}
