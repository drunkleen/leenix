{
  lib,
  pkgs,
  leenix,
  ...
}:

let
  # Canonical session locale derived from the typed LEENIX policy (typed
  # leenix.* policy -> config.leenix -> HM specialArg `leenix`).
  # LANGUAGE drives LANG / LC_MESSAGES / LC_TIME; REGION drives regional LC_*.
  # LC_CTYPE and LC_COLLATE are deliberately left unset so they inherit from
  # LANG. LC_ALL is never set.
  lang = leenix.locale.language;
  region = leenix.locale.region;

  localeEnv = {
    LANG = lang;
    LC_MESSAGES = lang;
    LC_TIME = lang;
    LC_ADDRESS = region;
    LC_IDENTIFICATION = region;
    LC_MEASUREMENT = region;
    LC_MONETARY = region;
    LC_NAME = region;
    LC_NUMERIC = region;
    LC_PAPER = region;
    LC_TELEPHONE = region;
  };

  envArgs = lib.concatStringsSep " " (
    lib.mapAttrsToList (n: v: "${n}=${lib.escapeShellArg v}") localeEnv
  );
in
{
  # systemd environment.d: every user unit receives the canonical locale,
  # overriding any stale values a persistent user manager may still hold.
  systemd.user.sessionVariables = localeEnv;

  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-locale-env";

      runtimeInputs = with pkgs; [
        systemd
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Sync the LEENIX locale into the systemd user manager (replaces stale values).

        # The systemd user manager can persist across logouts and retain the
        # pre-change locale environment. Re-apply the canonical locale
        # authoritatively, then drop LC_CTYPE/LC_COLLATE so they inherit from
        # LANG. Run at every graphical-session start.
        set -euo pipefail

        systemctl --user set-environment ${envArgs}
        systemctl --user unset-environment LC_CTYPE LC_COLLATE
        dbus-update-activation-environment --systemd --all
      '';
    })
  ];
}
