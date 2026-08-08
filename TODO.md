# Leenix TODO

Leenix is the declarative definition of my personal Linux environment.

The primary target is **Omarchy**, not NixOS.

The goal is to be able to install a fresh Omarchy system, clone this
repository, run a small bootstrap process, and restore as much of my
personal environment as reasonably possible using **Nix + Home Manager**.

---

## Core Principles

- [x] Omarchy remains responsible for the base operating system.
- [x] Nix manages portable user-space software wherever it is a good fit.
- [x] Home Manager manages user configuration wherever it is a good fit.
- [ ] Avoid having both pacman and Nix own the same application unless there
      is a deliberate reason.
- [ ] Prefer reproducible and declarative configuration over manual setup.
- [ ] Keep machine-specific state separate from portable configuration.
- [ ] Never store plaintext private keys or secrets in Git.
- [ ] YubiKey support is a first-class part of the architecture.
- [ ] Every milestone must be tested on the actual Omarchy environment before
      it is considered complete.

---

# Milestone 0 — Foundation

Goal: make Leenix work as a clean standalone Nix/Home Manager project on
Omarchy.

## Clean Start

- [x] Keep the previous NixOS implementation available as Git history/reference.
- [x] Create the `omarchy-rebuild` branch.
- [x] Remove the previous implementation from the new branch.
- [x] Start the new implementation from an empty repository tree.

## Nix

- [x] Install upstream Nix using the official multi-user daemon installer.
- [x] Verify Nix installation.
- [x] Enable `nix-command`.
- [x] Enable flakes.
- [x] Verify flakes work.

Current baseline:

- User: `snape`
- Host: `hogwarts`
- Architecture: `x86_64-linux`
- Base OS: Omarchy
- Nix: multi-user daemon installation

## Flake

- [x] Create a minimal `flake.nix`.
- [x] Add `nixpkgs`.
- [x] Add Home Manager.
- [x] Make Home Manager follow the same `nixpkgs`.
- [x] Define `x86_64-linux`.
- [x] Define the `snape@hogwarts` Home Manager configuration.
- [x] Generate a fresh `flake.lock`.
- [x] Verify `nix flake check`.

## Home Manager

- [x] Create `home/snape/default.nix`.
- [x] Configure username.
- [x] Configure home directory.
- [x] Set Home Manager state version.
- [x] Enable Home Manager itself.
- [x] Build the activation package successfully.
- [x] Activate the first Home Manager generation.
- [x] Verify Home Manager generations.
- [x] Verify Home Manager is available in the user PATH.
- [x] Verify standalone `home-manager switch`.

Standard activation command:

    home-manager switch --flake .#snape@hogwarts

## Module Architecture

- [x] Create `modules/home/default.nix`.
- [x] Import the Home Manager module tree from `home/snape/default.nix`.
- [x] Create the initial `modules/home/cli/` module.
- [x] Verify nested module imports work.
- [x] Verify Home Manager activation after introducing the module tree.

Current structure:

    leenix/
    ├── flake.nix
    ├── flake.lock
    ├── TODO.md
    ├── home/
    │   └── snape/
    │       └── default.nix
    └── modules/
        └── home/
            ├── default.nix
            └── cli/
                └── default.nix

## Package Ownership Rules

- [x] Omarchy owns the base operating system.
- [x] Nix/Home Manager will own portable user-space software we migrate.
- [ ] Audit ownership before migrating an existing Omarchy package.
- [ ] Remove duplicate package ownership where appropriate.
- [ ] Document exceptions where pacman/AUR/Flatpak remains the better owner.

## Bootstrap

- [ ] Define the final bootstrap workflow.
- [ ] Document Nix installation.
- [ ] Automate Nix configuration where appropriate.
- [ ] Make bootstrap safe to re-run.
- [ ] Eventually reduce fresh-machine setup to a small documented procedure.

Full bootstrap automation will be completed in Milestone 9 after the
environment architecture is stable.

## Foundation Verification

- [x] `nix flake check` passes.
- [x] Home Manager configuration builds.
- [x] Home Manager activation succeeds on Omarchy.
- [x] Re-running Home Manager activation succeeds.
- [x] Home Manager generation is created correctly.
- [x] Existing Omarchy installation remains functional.
- [ ] Commit the clean Foundation implementation.

### Milestone 0 Status

**IN PROGRESS — ready for Foundation commit.**

---

# Milestone 1 — Identity, Git, SSH & YubiKey

Goal: declaratively restore developer identity and secure access without
storing private secrets in Git.

## Git

- [ ] Audit the current Git configuration.
- [ ] Manage Git through Home Manager.
- [ ] Configure username and email.
- [ ] Configure default branch behavior.
- [ ] Configure aliases.
- [ ] Configure global ignore rules.
- [ ] Decide whether to use `delta`.
- [ ] Configure commit signing.
- [ ] Configure GitHub-specific behavior if needed.

## SSH

- [ ] Audit the current SSH setup.
- [ ] Manage SSH configuration declaratively.
- [ ] Define GitHub SSH configuration.
- [ ] Define frequently used SSH hosts.
- [ ] Define identity selection rules.
- [ ] Configure SSH agent behavior.
- [ ] Verify permissions.

## YubiKey

- [ ] Inventory current YubiKey functionality.
- [ ] Inventory existing YubiKeys.
- [ ] Decide which YubiKey responsibilities are system-level.
- [ ] Decide which YubiKey responsibilities are user-level.
- [ ] Configure FIDO2-backed SSH identities.
- [ ] Configure Git signing through YubiKey.
- [ ] Decide whether GPG functionality is required.
- [ ] Configure agent integration if required.
- [ ] Verify authentication after a fresh login.
- [ ] Verify authentication after reboot.
- [ ] Document recovery/fallback procedures.

## Secrets Architecture

- [ ] Decide whether encrypted secret files are actually needed.
- [ ] Evaluate `agenix`.
- [ ] Evaluate `sops-nix` if necessary.
- [ ] Prefer hardware-backed secrets where possible.
- [ ] Define what may exist in Git.
- [ ] Define what must remain encrypted.
- [ ] Define machine-specific secrets.
- [ ] Define user-specific secrets.
- [ ] Ensure no plaintext private SSH key exists in Git.

## Verification

- [ ] Git works.
- [ ] GitHub SSH authentication works.
- [ ] YubiKey SSH authentication works.
- [ ] Commit signing works.
- [ ] Home Manager rebuild does not destroy SSH state.

---

# Milestone 2 — CLI Workspace

Goal: move everyday terminal tools into Nix and make the command-line
environment reproducible.

## Audit

- [ ] Inventory currently used CLI applications.
- [ ] Identify CLI tools currently installed by Omarchy/pacman.
- [ ] Decide ownership for each tool.
- [ ] Identify tools that should remain system-owned.

## Core CLI Packages

Candidates include:

- [ ] `bat`
- [ ] `eza`
- [ ] `ripgrep`
- [ ] `fd`
- [ ] `fzf`
- [ ] `jq`
- [ ] `yq`
- [ ] `tree`
- [ ] `btop`
- [ ] `htop`
- [ ] `curl`
- [ ] `wget`
- [ ] `httpie`
- [ ] `rsync`
- [ ] `unzip`
- [ ] `zip`
- [ ] `p7zip`
- [ ] `file`
- [ ] other tools discovered during the audit

## Leenfetch

- [ ] Bring `leenfetch` into Leenix.
- [ ] Decide whether `leenfetch` lives in this repository or an external source.
- [ ] Package `leenfetch` with Nix.
- [ ] Expose `leenfetch` as a Leenix package.
- [ ] Install `leenfetch` through Home Manager.
- [ ] Verify it on Omarchy.

`leenfetch` is the preferred personal system-fetch tool instead of
`fastfetch`.

## Yazi

- [ ] Install Yazi through Nix.
- [ ] Audit current Yazi configuration.
- [ ] Manage Yazi configuration.
- [ ] Manage keybindings.
- [ ] Manage plugins.
- [ ] Manage themes.
- [ ] Verify preview dependencies.
- [ ] Verify archive integration.
- [ ] Verify image/media previews.

## Verification

- [ ] Migrated CLI binaries come from Nix.
- [ ] CLI applications work after a fresh login.
- [ ] Yazi works correctly.
- [ ] Leenfetch works correctly.
- [ ] Rebuild is reproducible.

---

# Milestone 3 — Zsh & Shell Experience

Goal: make the complete interactive shell environment declarative while
preserving the Omarchy behavior we actually want.

## Audit

- [ ] Audit Omarchy's current Zsh setup.
- [ ] Audit `.zshrc`.
- [ ] Audit aliases.
- [ ] Audit functions.
- [ ] Audit plugins.
- [ ] Audit environment variables.
- [ ] Identify Omarchy-specific shell behavior worth preserving.

## Zsh

- [ ] Manage Zsh configuration through Home Manager where appropriate.
- [ ] Migrate personal `.zshrc` behavior.
- [ ] Migrate aliases.
- [ ] Migrate functions.
- [ ] Configure completions.
- [ ] Configure shell options.
- [ ] Configure history.
- [ ] Configure session variables.
- [ ] Configure plugin loading.

## Prompt

- [ ] Identify the current prompt implementation.
- [ ] Decide whether to retain it or replace it.
- [ ] Manage prompt configuration declaratively.
- [ ] Verify Git performance.
- [ ] Verify SSH behavior.

## Shell Integrations

- [ ] Configure `fzf`.
- [ ] Configure `direnv`.
- [ ] Configure `nix-direnv`.
- [ ] Configure `zoxide` if desired.

## Verification

- [ ] New shell starts without errors.
- [ ] Shell startup remains fast.
- [ ] History works.
- [ ] Completion works.
- [ ] Aliases work.
- [ ] Functions work.
- [ ] Desired Omarchy behavior is preserved.

---

# Milestone 4 — Neovim

Goal: rebuild the personal Neovim environment declaratively using the old
Leenix implementation only as a reference.

## Audit

- [ ] Inspect the current Omarchy Neovim setup.
- [ ] Inspect the old Leenix Neovim implementation.
- [ ] Inventory plugins.
- [ ] Inventory Treesitter parsers.
- [ ] Inventory LSP servers.
- [ ] Inventory formatters.
- [ ] Inventory linters.
- [ ] Identify obsolete configuration.

## Neovim Runtime

- [ ] Install Neovim through Nix.
- [ ] Set Neovim as the default editor.
- [ ] Manage `~/.config/nvim` declaratively.
- [ ] Verify Wayland clipboard integration.

## Configuration

- [ ] Rebuild the Neovim module from scratch.
- [ ] Reuse old configuration only where deliberately chosen.
- [ ] Manage Lua configuration.
- [ ] Manage themes.
- [ ] Manage keybindings.

## Plugins

- [ ] Decide how plugins are managed.
- [ ] Configure Treesitter.
- [ ] Configure Telescope.
- [ ] Configure completion.
- [ ] Configure snippets.
- [ ] Configure Git integration.
- [ ] Configure UI plugins.

## LSP / Formatting / Linting

- [ ] Decide which editor tooling should be globally available.
- [ ] Avoid globally installing complete language toolchains unnecessarily.
- [ ] Configure Rust support.
- [ ] Configure Go support.
- [ ] Configure JavaScript/TypeScript support.
- [ ] Configure Python support.
- [ ] Configure Lua support.
- [ ] Configure shell support.
- [ ] Configure data/config formats.
- [ ] Configure Docker support.
- [ ] Add other languages as needed.

## Verification

- [ ] `nvim` comes from Nix.
- [ ] Neovim starts without errors.
- [ ] Plugins load.
- [ ] Treesitter works.
- [ ] LSP works.
- [ ] Formatting works.
- [ ] Linting works.
- [ ] Clipboard works.
- [ ] Git integration works.
- [ ] Home Manager can recreate the configuration.

---

# Milestone 5 — Terminal Environment

Goal: declaratively define the terminal stack surrounding the shell.

## Terminal Emulator

- [ ] Audit the current Omarchy terminal configuration.
- [ ] Decide which terminal emulator Leenix should manage.
- [ ] Install the terminal through Nix if appropriate.
- [ ] Manage terminal configuration.
- [ ] Manage fonts.
- [ ] Manage keybindings.
- [ ] Manage shell integration.
- [ ] Manage colors/theme where appropriate.

Candidates:

- [ ] Kitty
- [ ] Ghostty
- [ ] another terminal if preferred

## Terminal Workflow

- [ ] Decide whether to use `tmux`, `zellij`, or neither.
- [ ] Configure it if selected.
- [ ] Verify SSH-aware behavior.
- [ ] Verify URL/file opening.
- [ ] Verify Wayland clipboard behavior.

## Verification

- [ ] Terminal launches correctly.
- [ ] Fonts render correctly.
- [ ] Shell integration works.
- [ ] SSH sessions behave correctly.
- [ ] Home Manager restores terminal configuration.

---

# Milestone 6 — Development Environments

Goal: define reproducible programming environments without unnecessarily
polluting the global Home Manager profile.

## Architecture

- [ ] Decide global tools vs project-specific tools.
- [ ] Define a reusable `devShell` pattern.
- [ ] Integrate `direnv`.
- [ ] Integrate `nix-direnv`.
- [ ] Define language environment conventions.

## Rust

- [ ] Create Rust development environment.
- [ ] Configure Rust toolchain.
- [ ] Configure Cargo tooling.
- [ ] Configure formatter.
- [ ] Configure linter.
- [ ] Configure debugger if desired.
- [ ] Verify native dependencies.

## Go

- [ ] Create Go development environment.
- [ ] Configure Go toolchain.
- [ ] Configure `gopls`.
- [ ] Configure formatting/linting.
- [ ] Configure debugger if desired.

## JavaScript / TypeScript

- [ ] Create Node development environment.
- [ ] Decide Node version strategy.
- [ ] Decide package manager strategy.
- [ ] Evaluate npm / pnpm / yarn / bun.
- [ ] Configure TypeScript tooling.

## Python

- [ ] Decide Python environment strategy.
- [ ] Create reusable Python development environment.
- [ ] Configure Ruff.
- [ ] Configure Pyright.
- [ ] Define virtualenv interaction policy.

## Additional Languages

- [ ] Zig if needed.
- [ ] Java if needed.
- [ ] C/C++ if needed.
- [ ] Haskell if needed.
- [ ] Add other environments when actually needed.

## Shared Development Tools

- [ ] GitHub CLI.
- [ ] Docker/Podman client tools.
- [ ] Database clients.
- [ ] API tooling.
- [ ] Debugging tools.
- [ ] Profiling tools.

## Verification

- [ ] Every defined `nix develop` environment works.
- [ ] `direnv` activation works where intended.
- [ ] Neovim sees environment-specific tooling.
- [ ] Development environments do not unnecessarily pollute the global profile.

---

# Milestone 7 — Desktop Applications

Goal: declaratively define everyday graphical applications where Nix is a
good owner.

## Application Audit

- [ ] Inventory currently used GUI applications.
- [ ] Check package quality in nixpkgs.
- [ ] Decide Nix / pacman / AUR / Flatpak ownership per application.
- [ ] Do not force applications into Nix when system integration is worse.

Initial candidates:

- [ ] Bitwarden
- [ ] Telegram
- [ ] Signal
- [ ] Browser
- [ ] Media player
- [ ] PDF tools
- [ ] Image tools
- [ ] Communication applications
- [ ] Development GUI applications
- [ ] Other daily applications

## Defaults

- [ ] Configure default browser where appropriate.
- [ ] Configure default editor.
- [ ] Configure MIME associations.
- [ ] Configure URL handlers.
- [ ] Configure file associations.

## Verification

- [ ] Applications launch correctly.
- [ ] Wayland integration works.
- [ ] File pickers work.
- [ ] Default-app behavior works.
- [ ] Applications survive rebuild/update correctly.

---

# Milestone 8 — Desktop Experience & Omarchy Integration

Goal: declaratively manage desktop pieces that provide clear value without
fighting Omarchy.

This milestone is intentionally conservative.

## Audit Omarchy

- [ ] Hyprland configuration.
- [ ] Waybar.
- [ ] Launcher.
- [ ] Notifications.
- [ ] OSD.
- [ ] Clipboard.
- [ ] Screenshots.
- [ ] Wallpapers.
- [ ] Themes.
- [ ] Fonts.
- [ ] XDG configuration.

## Ownership Decision

For every desktop component, explicitly choose one:

- [ ] Omarchy owns it.
- [ ] Home Manager owns it.
- [ ] Leenix layers personal configuration over Omarchy.
- [ ] Document why.

Potential components:

- [ ] Hyprland
- [ ] Waybar
- [ ] Walker
- [ ] SwayOSD
- [ ] notification daemon
- [ ] clipboard tooling
- [ ] screenshot tooling
- [ ] wallpaper tooling
- [ ] fonts
- [ ] cursor
- [ ] GTK
- [ ] Qt

## Verification

- [ ] Omarchy updates remain reasonably safe.
- [ ] Home Manager does not overwrite unrelated Omarchy files.
- [ ] Desktop session starts correctly.
- [ ] Keybindings work.
- [ ] Bar works.
- [ ] Launcher works.
- [ ] Notifications work.
- [ ] Clipboard/screenshots work.

---

# Milestone 9 — Secrets, State & Final Bootstrap

Goal: turn Leenix into a practical fresh-install and disaster-recovery system.

## Secrets

- [ ] Finalize the secrets architecture.
- [ ] Encrypt secret material that needs repository-backed storage.
- [ ] Document provisioning.
- [ ] Verify restoration on a fresh machine.
- [ ] Verify YubiKey-dependent authentication.
- [ ] Define emergency recovery procedures.

## Persistent State

Identify things that should not live in Nix but need a recovery strategy.

- [ ] Browser profile/bookmarks.
- [ ] Password manager state.
- [ ] SSH known-hosts policy.
- [ ] Application state.
- [ ] Development credentials.
- [ ] Local databases if applicable.
- [ ] User documents.
- [ ] Intentionally unmanaged dotfiles.
- [ ] Backup strategy.

## Final Bootstrap

Target:

    Fresh Omarchy
        ↓
    Install Nix
        ↓
    Clone Leenix
        ↓
    Provision YubiKey / secrets
        ↓
    Bootstrap Leenix
        ↓
    Activate Home Manager
        ↓
    Restore external state
        ↓
    Ready

Tasks:

- [ ] Create final bootstrap command/script.
- [ ] Detect prerequisites.
- [ ] Configure Nix.
- [ ] Validate the flake.
- [ ] Activate Home Manager.
- [ ] Handle host/user selection.
- [ ] Produce useful errors.
- [ ] Document unavoidable manual steps.
- [ ] Make bootstrap safe to re-run.

## Fresh Install Test

- [ ] Test against a clean Omarchy installation or disposable machine.
- [ ] Follow only documented instructions.
- [ ] Record missing assumptions.
- [ ] Fix missing automation/documentation.
- [ ] Repeat until reproducible.

## Final Acceptance Criteria

- [ ] Fresh Omarchy can be transformed into the personal environment using
      Leenix.
- [ ] CLI environment is restored.
- [ ] Zsh is restored.
- [ ] Neovim is restored.
- [ ] Git is restored.
- [ ] SSH configuration is restored.
- [ ] YubiKey authentication works.
- [ ] Development environments are restored.
- [ ] Desktop applications are restored.
- [ ] Selected desktop configuration is restored.
- [ ] Secrets are provisioned securely.
- [ ] No plaintext secrets exist in Git.
- [ ] The process is documented.
- [ ] The process is repeatable.

---

# Working Process

For every milestone:

1. Discuss the milestone.
2. Audit the current Omarchy environment.
3. Use the old Leenix implementation only as a reference where useful.
4. Decide architecture and ownership before implementation.
5. Break work into small steps.
6. Implement one step at a time.
7. Add new files to Git so flakes can see them.
8. Run formatting/checks.
9. Build when appropriate.
10. Activate through Home Manager.
11. Test actual behavior.
12. Fix regressions before continuing.
13. Commit completed logical units.
14. Update this TODO.
15. Move to the next milestone only after verification.

---

# Current Focus

## Milestone 0 — Foundation

Current state:

- [x] Nix installed.
- [x] Flakes enabled.
- [x] Clean Leenix implementation started.
- [x] Standalone Home Manager configured.
- [x] `snape@hogwarts` works.
- [x] Home Manager module tree works.
- [x] First activation successful.
- [x] Repeated activation successful.
- [ ] Add this `TODO.md`.
- [ ] Review `git status`.
- [ ] Commit Foundation.
- [ ] Mark Milestone 0 complete.

**Next action: finish and commit Milestone 0.**
