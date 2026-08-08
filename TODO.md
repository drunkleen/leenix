# Leenix TODO

Leenix is the declarative definition of my personal Linux environment.

The primary target is **Omarchy**, not NixOS.

The goal is to install a fresh Omarchy system, clone this repository, run a small bootstrap process, and restore as much of the personal environment as reasonably possible using **Nix + Home Manager**.

---

## Core Principles

- [x] Omarchy remains responsible for the base operating system.
- [x] Nix manages portable user-space software wherever it is a good fit.
- [x] Home Manager manages user configuration wherever it is a good fit.
- [x] Avoid having both pacman and Nix own the same application unless deliberate.
- [x] Prefer reproducible and declarative configuration over manual setup.
- [x] Keep machine-specific state separate from portable configuration.
- [x] Never store plaintext private keys or secrets in Git.
- [x] YubiKey support is a first-class part of the architecture.
- [x] Every milestone must be tested on the actual Omarchy environment.
- [x] Keep NixOS-specific code isolated.

---

# Milestone 0 — Foundation

Goal: make Leenix work as a clean standalone Nix/Home Manager project on Omarchy.

## Architecture

- [x] Decide the repository layout.
- [x] Define the boundary between Omarchy, pacman/AUR, Nix, and Home Manager.
- [x] Decide host-specific configuration representation.
- [x] Decide user-specific configuration representation.
- [x] Isolate/archive old NixOS-specific configuration.
- [x] Define conventions for modules, packages, shells, secrets, and hosts.

## Nix / Flake

- [x] Review the existing `flake.nix`.
- [x] Add standalone Home Manager configuration.
- [x] Define the primary user/host target.
- [x] Ensure `nix flake check` works without NixOS.
- [ ] Add formatting/linting checks where useful.
- [x] Keep `flake.lock` committed and reproducible.

## Home Manager

- [x] Create the minimal Home Manager entry point.
- [x] Verify Home Manager activation on Omarchy.
- [x] Start with a deliberately minimal configuration.
- [x] Confirm Omarchy configuration is not unexpectedly overwritten.
- [ ] Define a standard switch command.

## Bootstrap

- [ ] Define the initial bootstrap workflow.
- [ ] Document prerequisites.
- [x] Install/configure Nix with flakes enabled.
- [x] Bootstrap Home Manager without globally installing it.
- [ ] Add an initial bootstrap script or command.

## Verification

- [x] `nix flake check` passes.
- [x] Home Manager builds successfully.
- [x] Home Manager activation succeeds on Omarchy.
- [x] Re-running activation is idempotent.
- [x] No important Omarchy functionality is broken.

---

# Milestone 1 — Identity, Git, SSH & YubiKey

Goal: declaratively restore developer identity and secure access without storing private secrets in Git.

## Git

- [ ] Manage Git through Home Manager.
- [ ] Configure username and email.
- [ ] Configure default branch behavior.
- [ ] Configure aliases.
- [ ] Configure global ignore rules.
- [ ] Decide whether to use `delta`.
- [ ] Configure commit signing if desired.
- [ ] Configure GitHub-specific settings if needed.

## SSH

- [ ] Manage `~/.ssh/config` declaratively.
- [ ] Define GitHub SSH configuration.
- [ ] Define frequently used SSH hosts.
- [ ] Define identity selection rules.
- [ ] Configure SSH agent behavior.
- [ ] Verify file permissions.

## YubiKey

- [x] Inventory current YubiKey functionality.
- [x] Decide which functionality belongs to Omarchy/system configuration vs Home Manager.
- [ ] Configure FIDO2-backed SSH identities.
- [ ] Configure Git signing through the YubiKey if desired.
- [ ] Configure GPG integration if needed.
- [ ] Configure SSH agent / gpg-agent integration if needed.
- [ ] Verify authentication survives reboot/login.
- [ ] Document authentication recovery/fallback procedures.

## Secrets Architecture

- [ ] Decide between `agenix`, `sops-nix`, or another minimal secrets approach.
- [ ] Define what is allowed in Git.
- [ ] Define what must remain encrypted.
- [ ] Define machine-specific secrets.
- [ ] Define user-specific secrets.
- [ ] Ensure no private SSH key is stored unencrypted.
- [ ] Add secret files to ignore rules where appropriate.

## Verification

- [ ] Git works.
- [ ] GitHub SSH authentication works.
- [ ] YubiKey SSH authentication works.
- [ ] Commit signing works if enabled.
- [ ] Home Manager rebuild does not destroy SSH state.

---

# Milestone 1.5 — Omarchy System Integration

Goal: manage system-level integrations that cannot be handled by Home Manager alone, while keeping Omarchy as the base operating system.

## Architecture

- [x] Separate system-level configuration from `flake.nix`.
- [x] Create `system/` as the system integration boundary.
- [x] Separate boot configuration from boot implementation.
- [x] Separate security configuration from security implementation.
- [x] Keep `flake.nix` focused on composition and exports.

Current structure:

```text
system/
├── default.nix
├── boot/
│   ├── config.nix
│   ├── apps.nix
│   └── default.nix
└── security/
    ├── sudo.nix
    ├── hyprlock.nix
    ├── apps.nix
    └── default.nix
````

## Boot / LUKS / FIDO2

* [x] Install `libfido2`.
* [x] Verify FIDO2 device detection.
* [x] Create a LUKS header backup.
* [x] Enroll YubiKey FIDO2 credential into LUKS2.
* [x] Verify the LUKS FIDO2 keyslot.
* [x] Add `systemd` and `sd-encrypt` initramfs integration.
* [x] Add FIDO2 LUKS kernel command line.
* [x] Ensure `libfido2` is present in the generated UKI.
* [x] Rebuild the UKI with `limine-update`.
* [x] Verify FIDO2 unlock manually.
* [x] Keep password fallback available.
* [ ] Verify FIDO2 unlock after a real cold reboot.

## Sudo / PAM U2F

* [x] Install `pam-u2f`.
* [x] Register the YubiKey with `pamu2fcfg`.
* [x] Protect the U2F authorization file with appropriate permissions.
* [x] Add PAM U2F configuration for sudo.
* [x] Preserve password fallback.
* [x] Create sudo PAM backup/rollback path.
* [x] Verify `sudo` requires YubiKey presence.
* [x] Verify the PAM configuration from a separate terminal.
* [ ] Decide whether sudo password fallback should remain permanently.

## Hyprlock / PAM U2F

* [x] Add Hyprlock authentication module.
* [x] Define Hyprlock PAM policy.
* [x] Configure YubiKey authentication for Hyprlock.
* [x] Verify Hyprlock unlocks with YubiKey.
* [x] Verify Hyprlock password authentication when the YubiKey is unavailable.
* [x] Preserve password fallback.
* [x] Create Hyprlock PAM backup/rollback path.

## System Module Structure

* [x] Boot configuration lives in `system/boot/config.nix`.
* [x] Boot preview/apply/rollback lives in `system/boot/apps.nix`.
* [x] Sudo policy lives in `system/security/sudo.nix`.
* [x] Hyprlock policy lives in `system/security/hyprlock.nix`.
* [x] Security preview/apply/rollback lives in `system/security/apps.nix`.
* [x] `flake.nix` only composes system modules.
* [x] Verify boot preview after refactor.
* [x] Verify security preview after refactor.
* [x] Commit the completed refactor.
* [x] Commit Hyprlock FIDO2 integration.

## Recovery

* [ ] Document LUKS recovery procedure.
* [ ] Document PAM recovery procedure.
* [ ] Document how to restore the sudo PAM backup.
* [ ] Document how to restore the Hyprlock PAM backup.
* [ ] Document YubiKey loss/replacement procedure.

## Next

* [ ] Verify FIDO2 unlock after a real cold reboot.
* [ ] Decide whether sudo password fallback should remain permanently.
* [ ] Design reusable YubiKey/security module boundaries.
* [ ] Document recovery procedures for LUKS and PAM.

---

# Milestone 2 — CLI Workspace

Goal: move everyday terminal tools into Nix and make the command-line environment reproducible.

* [ ] Audit installed CLI applications.
* [ ] Classify each package as Nix / pacman / AUR / other.
* [ ] Add the initial Nix CLI package set.
* [ ] Install and manage Yazi through Nix.
* [ ] Manage Yazi configuration and keybindings.
* [ ] Define common environment variables, aliases, and functions.
* [ ] Verify migrated tools after a clean login.
* [ ] Verify rebuild reproducibility.

---

# Milestone 3 — Zsh & Shell Experience

Goal: make the complete interactive shell environment declarative.

* [ ] Audit current Omarchy Zsh configuration.
* [ ] Migrate custom `.zshrc` behavior.
* [ ] Migrate aliases, functions, completions, options, and history.
* [ ] Decide on prompt / Starship.
* [ ] Configure fzf, direnv, nix-direnv, and zoxide where used.
* [ ] Verify startup, history, completion, aliases, and functions.
* [ ] Preserve Omarchy shell functionality that should remain.

---

# Milestone 4 — Neovim

Goal: make Neovim and its development support stack reproducible through Leenix.

* [ ] Audit the existing Neovim module and Lua configuration.
* [ ] Separate portable configuration from system-specific assumptions.
* [ ] Install Neovim through Nix.
* [ ] Manage `~/.config/nvim` through Home Manager.
* [ ] Audit plugins, Treesitter, Telescope, completion, snippets, and Git integration.
* [ ] Audit LSP, formatters, and linters.
* [ ] Verify Rust, Go, TypeScript/JavaScript, Python, Lua, shell, YAML/JSON/TOML, and Docker tooling as needed.
* [ ] Verify Wayland clipboard integration.

---

# Milestone 5 — Terminal Environment

Goal: declaratively define the terminal stack around the shell.

* [ ] Choose the terminal emulator to standardize on.
* [ ] Manage its package/configuration where appropriate.
* [ ] Manage fonts, keybindings, shell integration, and theme/colors.
* [ ] Decide on `tmux`, `zellij`, or neither.
* [ ] Verify SSH and Wayland clipboard behavior.

Possible terminal:

* [ ] Kitty
* [ ] Ghostty
* [ ] another terminal, if preferred

---

# Milestone 6 — Development Environments

Goal: define reproducible programming environments without polluting the global profile unnecessarily.

* [ ] Define the boundary between global tools and project/dev-shell tools.
* [ ] Define a reusable dev-shell/module pattern.
* [ ] Integrate direnv / nix-direnv.
* [ ] Define Rust, Go, Node/TypeScript, and Python environments as needed.
* [ ] Add shared development tools where appropriate.
* [ ] Verify `nix develop` and editor integration.

---

# Milestone 7 — Desktop Applications

Goal: declaratively define everyday graphical applications that make sense to manage through Nix.

* [ ] Inventory GUI applications.
* [ ] Check package quality/availability in nixpkgs.
* [ ] Decide per application: Nix / pacman / AUR / Flatpak.
* [ ] Configure default applications and MIME associations where sensible.
* [ ] Verify Wayland integration and application behavior.

Candidates:

* [ ] Bitwarden
* [ ] Telegram
* [ ] Signal
* [ ] browser
* [ ] media player
* [ ] image tools
* [ ] PDF tools
* [ ] archive tools
* [ ] communication apps
* [ ] development GUI tools

---

# Milestone 8 — Desktop Experience & Omarchy Integration

Goal: declaratively manage desktop pieces that provide clear value without fighting Omarchy.

* [ ] Audit Omarchy-owned and custom Hyprland configuration.
* [ ] Audit Waybar, launcher, notifications, OSD, wallpapers, themes, fonts, and XDG configuration.
* [ ] Decide ownership for every component: Omarchy, Home Manager, or layered configuration.
* [ ] Keep Omarchy as the base desktop distribution.
* [ ] Verify desktop session, keybindings, Waybar, launcher, notifications, screenshots, and clipboard.

Potential components:

* [ ] Hyprland
* [ ] Waybar
* [ ] Walker
* [ ] SwayOSD
* [ ] notification daemon
* [ ] clipboard tools
* [ ] screenshot tools
* [ ] wallpaper tooling
* [ ] themes
* [ ] fonts
* [ ] cursor
* [ ] GTK configuration
* [ ] Qt configuration

---

# Milestone 9 — Secrets, State & Final Bootstrap

Goal: turn Leenix into a practical disaster-recovery/reinstallation system.

## Secrets

* [ ] Finalize encrypted secrets solution.
* [ ] Encrypt required secret material.
* [ ] Add secret provisioning documentation.
* [ ] Verify secrets can be restored on a fresh machine.
* [ ] Verify YubiKey-dependent secrets/authentication.
* [ ] Define emergency recovery procedure.

## Persistent State

* [ ] Browser profile/bookmarks strategy.
* [ ] Password manager data strategy.
* [ ] SSH known hosts policy.
* [ ] Application state.
* [ ] Development credentials.
* [ ] User documents.
* [ ] Backup strategy.

## Final Bootstrap

Target workflow:

```text
Fresh Omarchy
    ↓
Install Nix
    ↓
Clone Leenix
    ↓
Provision YubiKey / secrets
    ↓
Run bootstrap
    ↓
Activate Home Manager
    ↓
Restore external state/backups
    ↓
Ready
```

* [ ] Create final bootstrap command/script.
* [ ] Detect required dependencies.
* [ ] Configure Nix.
* [ ] Validate flakes.
* [ ] Activate Home Manager.
* [ ] Handle host/user selection.
* [ ] Document manual steps that cannot be automated.
* [ ] Make bootstrap safe to re-run.

## Fresh Install Test

* [ ] Test on a clean Omarchy installation or disposable VM.
* [ ] Follow only the documented bootstrap procedure.
* [ ] Record missing steps.
* [ ] Fix undocumented assumptions.
* [ ] Repeat until reproducible.

## Final Acceptance Criteria

* [ ] A fresh Omarchy install can be converted into the personal environment using Leenix.
* [ ] Neovim is restored.
* [ ] Zsh/shell environment is restored.
* [ ] CLI applications are restored.
* [ ] Git is restored.
* [ ] SSH configuration is restored.
* [ ] YubiKey authentication works.
* [ ] Development environments are restored.
* [ ] Desktop applications are restored.
* [ ] Selected desktop configuration is restored.
* [ ] Secrets are provisioned securely.
* [ ] No plaintext secrets exist in Git.
* [ ] The process is documented.
* [ ] The process is repeatable.

---

# Working Process

For every milestone:

1. Discuss the milestone.
2. Audit the current Omarchy/Leenix state.
3. Decide architecture and ownership.
4. Break the milestone into small implementation steps.
5. Update this TODO if the design changes.
6. Implement one small step at a time.
7. Run `nix fmt`.
8. Run relevant checks.
9. Build the Home Manager configuration.
10. Activate it.
11. Manually verify real behavior.
12. Fix regressions.
13. Commit the completed logical unit.
14. Mark completed tasks in this file.
15. Move to the next task only after the previous one is verified.

---

# Current Focus

**Milestone 1.5 — Omarchy System Integration**

Completed:

* LUKS2 FIDO2 enrollment
* `sd-encrypt` boot integration
* FIDO2-aware Limine kernel command line
* UKI rebuild with FIDO2 support
* sudo PAM U2F integration
* YubiKey registration for PAM U2F
* Hyprlock PAM U2F integration
* Boot/security preview and rollback tooling
* Split system configuration into modular `system/boot` and `system/security` directories
* Refactored `flake.nix` to compose system modules
* Verified `nix flake check`
* Verified boot preview
* Verified security preview
* Verified sudo YubiKey authentication
* Verified Hyprlock YubiKey authentication
* Verified Hyprlock password fallback when YubiKey is unavailable
* Committed the system integration refactor
* Committed Hyprlock FIDO2 integration

Next:

* Verify FIDO2 unlock after a real cold reboot.
* Decide whether sudo password fallback should remain permanently.
* Design reusable YubiKey/security module boundaries.
* Document recovery procedures for LUKS and PAM.
