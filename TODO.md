# Leenix TODO

## Completed

-   [x] Centralize machine-specific variables
-   [x] Pass variables through flake into modules
-   [x] Refactor Home Manager layout
-   [x] Add Home Manager Neovim module
-   [x] Move Neovim configuration into Leenix (`dotfiles/nvim`)
-   [x] Manage Neovim config with Home Manager
-   [x] Verify Nix-managed Neovim (`0.12.4`)

## Next Tasks

### Home Modules

-   [ ] Review `modules/home/ssh`
-   [ ] Review `modules/home/cli`
-   [ ] Remove remaining hardcoded machine values

### System Modules

-   [ ] Audit `system/security`
-   [ ] Review boot module

### Variables

-   [ ] Refine platform/host/user variable separation

### Future

-   [ ] Add Leenix architecture documentation
-   [ ] Document rebuild workflow
-   [ ] Test deployment on a clean machine
