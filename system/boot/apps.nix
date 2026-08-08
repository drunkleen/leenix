{ pkgs, systemConfig }:

let
  boot = import ./config.nix;

  hooks = pkgs.lib.concatStringsSep " " boot.mkinitcpio.hooks;
  files = pkgs.lib.concatStringsSep " " boot.mkinitcpio.files;

  zswap =
    if boot.root.zswap then
      "1"
    else
      "0";

  rootMode =
    if boot.root.readWrite then
      "rw"
    else
      "ro";

  proposedHooks =
    "HOOKS=(${hooks})";

  proposedFiles =
    "FILES+=(${files})";

  proposedCmdline =
    "rd.luks.name=${boot.luks.uuid}=${boot.luks.mapperName} "
    + "rd.luks.options=${boot.luks.uuid}=fido2-device=${boot.luks.fido2.device} "
    + "root=/dev/mapper/${boot.luks.mapperName} "
    + "zswap.enabled=${zswap} "
    + "rootflags=${boot.root.flags} "
    + "${rootMode} "
    + "rootfstype=${boot.root.fsType}";

  bootPreview = pkgs.writeShellApplication {
    name = "leenix-boot-preview";

    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
    ];

    text = ''
      echo "== Current mkinitcpio drop-in =="
      cat '${boot.mkinitcpio.configFile}'

      echo
      echo "== Proposed mkinitcpio drop-in =="
      echo '${proposedHooks}'
      echo '${proposedFiles}'

      echo
      echo "== Current Limine crypt cmdline =="
      grep 'cryptdevice=' /etc/default/limine || true
      grep 'rd.luks.name=' /etc/default/limine || true

      echo
      echo "== Proposed Limine crypt cmdline =="
      echo '${proposedCmdline}'

      echo
      echo "== Required system packages =="
      printf '%s\n' ${pkgs.lib.escapeShellArgs systemConfig.packages}

      echo
      echo "== No changes have been made =="
    '';
  };

  bootApply = pkgs.writeShellApplication {
    name = "leenix-boot-apply";

    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      gnused
    ];

    text = ''
      set -euo pipefail

      if (( EUID != 0 )); then
        echo "Run with sudo." >&2
        exit 1
      fi

      mkinitcpio_conf='${boot.mkinitcpio.configFile}'
      limine_conf="/etc/default/limine"

      echo "== Validating current system =="

      [[ -f "$mkinitcpio_conf" ]] || {
        echo "Missing mkinitcpio config: $mkinitcpio_conf" >&2
        exit 1
      }

      [[ -f "$limine_conf" ]] || {
        echo "Missing Limine config: $limine_conf" >&2
        exit 1
      }

      if ! grep -Eq '^[[:space:]]*HOOKS=' "$mkinitcpio_conf"; then
        echo "No HOOKS declaration found in $mkinitcpio_conf" >&2
        exit 1
      fi

      if ! grep -Eq 'cryptdevice=|rd\.luks\.name=' "$limine_conf"; then
        echo "Could not find encrypted-root kernel command line." >&2
        exit 1
      fi

      echo "Validation passed."

      echo
      echo "== Creating backups =="

      cp -a \
        "$mkinitcpio_conf" \
        "$mkinitcpio_conf.leenix-backup"

      cp -a \
        "$limine_conf" \
        "$limine_conf.leenix-backup"

      echo
      echo "== Writing mkinitcpio drop-in =="

      cat > "$mkinitcpio_conf" <<'EOF'
${proposedHooks}
${proposedFiles}
EOF

      echo
      echo "== Updating Limine kernel command line =="

      if grep -q 'cryptdevice=' "$limine_conf"; then
        sed -i \
          's|KERNEL_CMDLINE\[default\]+="cryptdevice=.*rootfstype=btrfs"|KERNEL_CMDLINE[default]+="${proposedCmdline}"|' \
          "$limine_conf"
      elif grep -q 'rd.luks.name=' "$limine_conf"; then
        sed -i \
          's|KERNEL_CMDLINE\[default\]+="rd\.luks\.name=.*rootfstype=btrfs"|KERNEL_CMDLINE[default]+="${proposedCmdline}"|' \
          "$limine_conf"
      else
        echo "Could not update encrypted-root kernel command line." >&2
        exit 1
      fi

      echo
      echo "== Result =="

      cat "$mkinitcpio_conf"

      echo
      grep 'rd.luks.name=' "$limine_conf"

      echo
      echo "Boot configuration updated."
      echo "UKI has NOT been rebuilt."
      echo "Do not reboot yet."
    '';
  };

  bootRollback = pkgs.writeShellApplication {
    name = "leenix-boot-rollback";

    runtimeInputs = with pkgs; [
      coreutils
    ];

    text = ''
      set -euo pipefail

      if (( EUID != 0 )); then
        echo "Run with sudo." >&2
        exit 1
      fi

      mkinitcpio_conf='${boot.mkinitcpio.configFile}'
      mkinitcpio_backup="$mkinitcpio_conf.leenix-backup"

      limine_conf="/etc/default/limine"
      limine_backup="$limine_conf.leenix-backup"

      [[ -f "$mkinitcpio_backup" ]] || {
        echo "Missing backup: $mkinitcpio_backup" >&2
        exit 1
      }

      [[ -f "$limine_backup" ]] || {
        echo "Missing backup: $limine_backup" >&2
        exit 1
      }

      echo "== Restoring boot configuration =="

      cp -a \
        "$mkinitcpio_backup" \
        "$mkinitcpio_conf"

      cp -a \
        "$limine_backup" \
        "$limine_conf"

      echo
      echo "Boot configuration restored."

      echo
      echo "Rebuild the UKI before rebooting:"
      echo
      echo "  sudo limine-update"
    '';
  };
in
{
  packages = {
    boot-preview = bootPreview;
    boot-apply = bootApply;
    boot-rollback = bootRollback;
  };

  apps = {
    boot-preview = {
      type = "app";
      program = "${bootPreview}/bin/leenix-boot-preview";

      meta = {
        description = "Preview Leenix boot integration changes";
      };
    };

    boot-apply = {
      type = "app";
      program = "${bootApply}/bin/leenix-boot-apply";

      meta = {
        description = "Apply Leenix boot integration";
      };
    };

    boot-rollback = {
      type = "app";
      program = "${bootRollback}/bin/leenix-boot-rollback";

      meta = {
        description = "Rollback Leenix boot integration";
      };
    };
  };
}
