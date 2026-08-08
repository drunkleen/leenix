{ pkgs, systemConfig, sudo, hyprlock }:

let
  sudoAuthFile =
    sudo.u2f.authFile;

  sudoUserPresence =
    if sudo.u2f.userPresence then
      "1"
    else
      "0";

  sudoUserVerification =
    if sudo.u2f.userVerification then
      "1"
    else
      "0";

  sudoPinVerification =
    if sudo.u2f.pinVerification then
      "1"
    else
      "0";

  hyprlockAuthFile =
    hyprlock.pam.hyprlock.u2f.authFile;

  hyprlockUserPresence =
    if hyprlock.pam.hyprlock.u2f.userPresence then
      "1"
    else
      "0";

  hyprlockUserVerification =
    if hyprlock.pam.hyprlock.u2f.userVerification then
      "1"
    else
      "0";

  hyprlockPinVerification =
    if hyprlock.pam.hyprlock.u2f.pinVerification then
      "1"
    else
      "0";

  proposedSudoPam = ''
    #%PAM-1.0

    auth sufficient pam_u2f.so authfile=${sudoAuthFile} cue userpresence=${sudoUserPresence} userverification=${sudoUserVerification} pinverification=${sudoPinVerification}
    auth include system-auth

    account include system-auth

    session include system-auth
    session optional pam_systemd.so class=none
  '';

  proposedHyprlockPam = ''
    #%PAM-1.0

    auth sufficient pam_u2f.so authfile=${hyprlockAuthFile} cue userpresence=${hyprlockUserPresence} userverification=${hyprlockUserVerification} pinverification=${hyprlockPinVerification}
    auth include system-auth

    account include system-auth

    session include system-auth
    session optional pam_systemd.so class=none
  '';

  securityPreview = pkgs.writeShellApplication {
    name = "leenix-security-preview";

    runtimeInputs = with pkgs; [
      coreutils
    ];

    text = ''
      echo "== Current sudo PAM configuration =="
      cat /etc/pam.d/sudo

      echo
      echo "== Proposed sudo PAM configuration =="
      cat <<'EOF'
    ${proposedSudoPam}
    EOF

      echo
      echo "== Current Hyprlock PAM configuration =="
      cat /etc/pam.d/hyprlock

      echo
      echo "== Proposed Hyprlock PAM configuration =="
      cat <<'EOF'
    ${proposedHyprlockPam}
    EOF

      echo
      echo "== U2F auth file =="

      if [[ -f '${sudoAuthFile}' ]]; then
        echo "Found: ${sudoAuthFile}"
      else
        echo "Missing: ${sudoAuthFile}"
      fi

      echo
      echo "== Required system packages =="
      printf '%s\n' ${pkgs.lib.escapeShellArgs systemConfig.packages}

      echo
      echo "== No changes have been made =="
    '';
  };

  securityApply = pkgs.writeShellApplication {
    name = "leenix-security-apply";

    runtimeInputs = with pkgs; [
      coreutils
    ];

    text = ''
      set -euo pipefail

      if (( EUID != 0 )); then
        echo "Run as root." >&2
        exit 1
      fi

      sudo_pam="/etc/pam.d/sudo"
      sudo_backup="/etc/pam.d/sudo.leenix-backup"

      hyprlock_pam="/etc/pam.d/hyprlock"
      hyprlock_backup="/etc/pam.d/hyprlock.leenix-backup"

      auth_file='${sudoAuthFile}'

      echo "== Validating PAM integration =="

      [[ -f "$sudo_pam" ]] || {
        echo "Missing PAM service: $sudo_pam" >&2
        exit 1
      }

      [[ -f "$hyprlock_pam" ]] || {
        echo "Missing PAM service: $hyprlock_pam" >&2
        exit 1
      }

      [[ -f "$auth_file" ]] || {
        echo "Missing U2F auth file: $auth_file" >&2
        exit 1
      }

      [[ -r "$auth_file" ]] || {
        echo "U2F auth file is not readable: $auth_file" >&2
        exit 1
      }

      [[ -f /usr/lib/security/pam_u2f.so ]] || {
        echo "pam_u2f.so is not installed." >&2
        echo "Required Arch package: pam-u2f" >&2
        exit 1
      }

      echo "Validation passed."

      echo
      echo "== Creating backups =="

      if [[ ! -f "$sudo_backup" ]]; then
        cp -a "$sudo_pam" "$sudo_backup"
      else
        echo "Existing backup preserved: $sudo_backup"
      fi

      if [[ ! -f "$hyprlock_backup" ]]; then
        cp -a "$hyprlock_pam" "$hyprlock_backup"
      else
        echo "Existing backup preserved: $hyprlock_backup"
      fi

      echo
      echo "== Writing sudo PAM configuration =="

      cat > "$sudo_pam" <<'EOF'
    ${proposedSudoPam}
    EOF

      chmod 644 "$sudo_pam"

      echo
      echo "== Writing Hyprlock PAM configuration =="

      cat > "$hyprlock_pam" <<'EOF'
    ${proposedHyprlockPam}
    EOF

      chmod 644 "$hyprlock_pam"

      echo
      echo "== Installed sudo PAM configuration =="
      cat "$sudo_pam"

      echo
      echo "== Installed Hyprlock PAM configuration =="
      cat "$hyprlock_pam"

      echo
      echo "PAM configuration updated."
      echo
      echo "Keep an existing root shell open."
      echo "Test sudo from a separate terminal before closing it."
      echo "Do not lock the current graphical session until Hyprlock has been tested."
    '';
  };

  securityRollback = pkgs.writeShellApplication {
    name = "leenix-security-rollback";

    runtimeInputs = with pkgs; [
      coreutils
    ];

    text = ''
      set -euo pipefail

      if (( EUID != 0 )); then
        echo "Run as root." >&2
        exit 1
      fi

      sudo_pam="/etc/pam.d/sudo"
      sudo_backup="/etc/pam.d/sudo.leenix-backup"

      hyprlock_pam="/etc/pam.d/hyprlock"
      hyprlock_backup="/etc/pam.d/hyprlock.leenix-backup"

      [[ -f "$sudo_backup" ]] || {
        echo "Missing backup: $sudo_backup" >&2
        exit 1
      }

      [[ -f "$hyprlock_backup" ]] || {
        echo "Missing backup: $hyprlock_backup" >&2
        exit 1
      }

      echo "== Restoring sudo PAM configuration =="

      cp -a "$sudo_backup" "$sudo_pam"

      echo
      echo "== Restoring Hyprlock PAM configuration =="

      cp -a "$hyprlock_backup" "$hyprlock_pam"

      echo
      echo "== Restored sudo configuration =="
      cat "$sudo_pam"

      echo
      echo "== Restored Hyprlock configuration =="
      cat "$hyprlock_pam"

      echo
      echo "sudo and Hyprlock PAM configurations restored."
    '';
  };
in
{
  packages = {
    security-preview = securityPreview;
    security-apply = securityApply;
    security-rollback = securityRollback;
  };

  apps = {
    security-preview = {
      type = "app";
      program = "${securityPreview}/bin/leenix-security-preview";

      meta = {
        description = "Preview Leenix PAM security integration";
      };
    };

    security-apply = {
      type = "app";
      program = "${securityApply}/bin/leenix-security-apply";

      meta = {
        description = "Apply Leenix PAM security integration";
      };
    };

    security-rollback = {
      type = "app";
      program = "${securityRollback}/bin/leenix-security-rollback";

      meta = {
        description = "Rollback Leenix PAM security integration";
      };
    };
  };
}
