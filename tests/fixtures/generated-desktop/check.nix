# Root `nix flake check` for the external-consumer fixture and the Phase 9D
# public-contract hardening (empty-username guard + disk-layout enum).
#
# Evaluates neutral policy through the PUBLIC `mkInstance` constructor and
# asserts public-contract + negative-test properties. It never recurses into
# the fixture flake (avoiding a Core <-> fixture cycle): it consumes the same
# policy modules directly. Succeeds only when every property holds.
#
# NOTE on negative tests: NixOS's own `fileSystems`/bootloader assertions can
# crash (not cleanly return) on an otherwise-incomplete eval, so these tests
# assert the FIX structurally / at the type boundary rather than forcing the
# whole `config.assertions` list:
#   - empty username  -> prove no `users.users.""` attrset is constructed
#                        (the base profile never builds it), which is the actual
#                        defect (previously an obscure NixOS error).
#   - invalid layout  -> prove the enum type rejects it (tryEval success=false).
{ mkInstance, pkgs, lib }:
let
  # ---- Positive generated-desktop instance (valid) ----
  gen = mkInstance {
    system = "x86_64-linux";
    modules = [ ./hardware.nix ./policy.nix ];
  };
  cfg = gen.config;

  hasLeenfetch = builtins.any (p: (p.pname or "") == "leenfetch") cfg.environment.systemPackages;

  # ---- Whole-system integration forcing ----
  # Force the authoritative system derivation so NixOS/Home Manager assertions
  # that only fire during a full build (e.g. the xdg.portal pathsToLink HM
  # assertion) are exercised by `nix flake check`. Evaluation/build-safe: no
  # switch, no disk operations. The check derivation depends on this toplevel so
  # it is built (not merely evaluated).
  systemToplevel = cfg.system.build.toplevel;
  portalEnabledViaCore = cfg.xdg.portal.enable or false;

  # ---- Negative: empty username (valid layout so the system eases cleanly) ----
  emptyUserCfg = (mkInstance {
    system = "x86_64-linux";
    modules = [ {
      system.stateVersion = "26.05";
      leenix = {
        host = { hostname = "g"; architecture = "x86_64-linux"; };
        user = { username = ""; homeDirectory = ""; extraGroups = [ ]; };
        git = { name = "A"; email = "a@e.org"; branch = "main"; };
        locale = { language = "en_US.UTF-8"; region = "en_US.UTF-8"; };
        keyboard = { layouts = [ "us" ]; options = [ ]; };
        cursor = { theme = "capitaine-cursors"; size = 24; };
        profiles.base.enable = true;
        hardware.intel.enable = true;
        disk.device = "/dev/vda";
        disk.layout = "laptop-luks-btrfs";
      };
    } ];
  }).config;

  # ---- Negative: invalid disk layout (enum type rejects) ----
  badLayoutTry = builtins.tryEval (mkInstance {
    system = "x86_64-linux";
    modules = [ {
      system.stateVersion = "26.05";
      leenix = {
        host = { hostname = "g"; architecture = "x86_64-linux"; };
        user = { username = "alice"; homeDirectory = "/home/alice"; extraGroups = [ ]; };
        git = { name = "A"; email = "a@e.org"; branch = "main"; };
        locale = { language = "en_US.UTF-8"; region = "en_US.UTF-8"; };
        keyboard = { layouts = [ "us" ]; options = [ ]; };
        cursor = { theme = "capitaine-cursors"; size = 24; };
        profiles.base.enable = true;
        hardware.intel.enable = true;
        disk.device = "/dev/vda";
        disk.layout = "definitely-not-a-layout";
      };
    } ];
  }).config.leenix.disk.layout;
  invalidLayoutRejected = !badLayoutTry.success;

  # ---- Negative: vscode explicit false (desktop) ----
  minimalValid = { ... }: {
    system.stateVersion = "26.05";
    leenix = {
      host = { hostname = "g"; architecture = "x86_64-linux"; };
      user = { username = "alice"; homeDirectory = "/home/alice"; extraGroups = [ ]; };
      git = { name = "A"; email = "a@e.org"; branch = "main"; };
      locale = { language = "en_US.UTF-8"; region = "en_US.UTF-8"; };
      keyboard = { layouts = [ "us" ]; options = [ ]; };
      cursor = { theme = "capitaine-cursors"; size = 24; };
      profiles.base.enable = true;
      hardware.intel.enable = true;
      disk.device = "/dev/vda";
      disk.layout = "laptop-luks-btrfs";
    };
  };

  vscFalse = (mkInstance {
    system = "x86_64-linux";
    modules = [ minimalValid { leenix.profiles.desktop.enable = true; leenix.development.editors.vscode.enable = false; } ];
  }).config.leenix.development.editors.vscode.enable;

  # ---- Negative: base-only (no desktop) ----
  baseOnly = (mkInstance {
    system = "x86_64-linux";
    modules = [ minimalValid ];
  }).config.leenix.development.editors.vscode.enable;

  props = [
    # ---- Positive contract ----
    { name = "hostname == generated-desktop"; ok = cfg.leenix.host.hostname == "generated-desktop"; }
    { name = "architecture == x86_64-linux"; ok = cfg.leenix.host.architecture == "x86_64-linux"; }
    { name = "username == alice"; ok = cfg.leenix.user.username == "alice"; }
    { name = "homeDirectory == /home/alice"; ok = cfg.leenix.user.homeDirectory == "/home/alice"; }
    { name = "profiles.base.enable"; ok = cfg.leenix.profiles.base.enable; }
    { name = "profiles.desktop.enable"; ok = cfg.leenix.profiles.desktop.enable; }
    { name = "editors.vscode enabled via desktop default"; ok = cfg.leenix.development.editors.vscode.enable; }
    { name = "home-manager user alice present"; ok = cfg.home-manager.users ? "alice"; }
    { name = "leenix overlay supplies leenfetch"; ok = hasLeenfetch; }
    { name = "desktop hyprland + uwsm enabled"; ok = cfg.leenix.desktop.hyprland.enable && cfg.leenix.desktop.uwsm.enable; }
    { name = "system.build.toplevel evaluates (whole-system forcing)"; ok = builtins.isString systemToplevel.drvPath; }
    { name = "xdg.portal.enable reached through Core composition"; ok = portalEnabledViaCore; }
    # ---- Negative hardening ----
    { name = "empty username: no users.users.\"\" constructed"; ok = !(emptyUserCfg.users.users ? ""); }
    { name = "empty username: username stays empty string policy"; ok = emptyUserCfg.leenix.user.username == ""; }
    { name = "invalid disk layout rejected by enum type"; ok = invalidLayoutRejected; }
    { name = "desktop + vscode=false -> false"; ok = vscFalse == false; }
    { name = "base-only -> vscode false"; ok = baseOnly == false; }
  ];

  failures = lib.filter (p: !p.ok) props;
  report = lib.concatMapStringsSep "\n" (p: if p.ok then "  PASS  ${p.name}" else "  FAIL  ${p.name}") props;
in
pkgs.runCommand "generated-desktop-public-check"
  {
    # Depend on the full system toplevel so `nix flake check` builds it, forcing
    # NixOS/Home Manager integration assertions to run. Build-only; never
    # switch or touch a real disk.
    arbitraryDeps = [ systemToplevel ];
  }
  (
  if failures == [ ] then
    ''
      cat > $out <<EOF
      generated-desktop public-contract + hardening check: OK
      ${report}
      EOF
      echo "generated-desktop public-contract + hardening check: OK"
    ''
  else
    ''
      cat >&2 <<EOF
      generated-desktop public-contract + hardening check: FAILED
      ${report}
      EOF
      exit 1
    ''
)
