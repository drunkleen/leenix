# LEENIX Makefile — thin UX layer.
#
# Nix is the source of truth. This file only wraps common commands and
# must not duplicate configuration logic.

HOST  ?= tuf-f15
FLAKE ?= .

.DEFAULT_GOAL := help

help: ## Show this help
	@echo "LEENIX — NixOS framework (UX wrapper)"
	@echo ""
	@echo "Usage:"
	@echo "  make <target> HOST=<host>"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*## ' Makefile | awk 'BEGIN {FS = ":.*## "}; {printf "  %-12s %s\n", $$1, $$2}'
	@echo ""
	@echo "Default host: $(HOST)"

check: ## Run nix flake check (non-activating)
	nix flake check $(FLAKE)

build: ## Build the host system (non-activating)
	sudo nixos-rebuild build --flake $(FLAKE)#$(HOST)

switch: ## Activate the host system (applies changes)
	sudo nixos-rebuild switch --flake $(FLAKE)#$(HOST)

boot: ## Activate the host system on next boot
	sudo nixos-rebuild boot --flake $(FLAKE)#$(HOST)

show: ## Show flake outputs and host disk policy
	@echo "== Flake outputs =="
	nix flake show $(FLAKE)
	@echo ""
	@echo "== Host: $(HOST) =="
	@echo "  disk device:  $$(nix eval --raw $(FLAKE)#nixosConfigurations.$(HOST).config.disko.devices.disk.main.device)"
	@echo "  disk layout:  $$(nix eval --raw $(FLAKE)#nixosConfigurations.$(HOST).config.leenix.disk.layout)"

fmt: ## Format the framework Nix files (explicit list; avoids nix fmt auto-discovery bug)
	nix fmt flake.nix home/default.nix modules/home/default.nix

clean: ## Remove local build artifacts
	@if [ -e result ]; then sudo rm -f result; fi
	@rm -rf .direnv
	@echo "Cleaned build artifacts."

update: ## Update flake inputs
	nix flake update $(FLAKE)

disk-plan: ## Show the disko plan for a host (read-only)
	@echo "== Disko plan for: $(HOST) =="
	@echo "  device:     $$(nix eval --raw $(FLAKE)#nixosConfigurations.$(HOST).config.disko.devices.disk.main.device)"
	@echo "  table:      $$(nix eval --raw $(FLAKE)#nixosConfigurations.$(HOST).config.disko.devices.disk.main.content.type)"
	@echo "  partitions: $$(nix eval --json $(FLAKE)#nixosConfigurations.$(HOST).config.disko.devices.disk.main.content.partitions --apply 'p: builtins.attrNames p')"
	@echo ""
	@echo "No changes have been made. Use 'make disk-apply' only for a fresh install."

disk-apply: ## DESTRUCTIVE: wipe and partition the host disk via disko
	@echo ""
	@echo "================================================================"
	@echo "  DANGER: disk-apply is DESTRUCTIVE."
	@echo ""
	@echo "  It will WIPE the target disk and repartition it via disko."
	@echo "  This is only meant for (re)installing $(HOST)."
	@echo ""
	@echo "  Target device: $$(nix eval --raw $(FLAKE)#nixosConfigurations.$(HOST).config.disko.devices.disk.main.device)"
	@echo "================================================================"
	@echo ""
	@read -p "Type '$(HOST)' to confirm the host: " H; \
	  [ "$$H" = "$(HOST)" ] || { echo "Aborted."; exit 1; }
	@read -p "Type 'YES' to confirm you want to WIPE this disk: " Y; \
	  [ "$$Y" = "YES" ] || { echo "Aborted."; exit 1; }
	@echo ""
	@echo "Wiping and partitioning the disk. Data will be lost."
	sudo nix run $(FLAKE)#nixosConfigurations.$(HOST).config.system.build.disko

.PHONY: help check build switch boot show fmt clean update disk-plan disk-apply
