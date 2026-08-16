# Canonical LEENIX host-policy entrypoint.
#
# The tracked default policy is split by responsibility across variables/*.nix
# and merged here (collision-safe) into ONE effective host-policy attrset that
# exactly matches the historical single-file schema. Nothing outside this
# entrypoint needs to know the policy is physically split.
#
# Pipeline:
#   variables.nix/*.nix  ->  variables.nix  ->  mkHost  ->  host.nix
#
# mkHost (lib/mkHost.nix) imports this file with NO arguments and then applies
# the machine-local, gitignored hosts/<host>/local.nix overrides on top via
# `lib.recursiveUpdate`. leenix-config reads the same files (impure).
let
  mergeHostVariables = import ../../lib/mergeHostVariables.nix;
in
mergeHostVariables [
  { file = "variables/ai.nix"; value = import ./variables/ai.nix; }
  { file = "variables/boot.nix"; value = import ./variables/boot.nix; }
  { file = "variables/cybersecurity.nix"; value = import ./variables/cybersecurity.nix; }
  { file = "variables/desktop.nix"; value = import ./variables/desktop.nix; }
  { file = "variables/development.nix"; value = import ./variables/development.nix; }
  { file = "variables/hardware.nix"; value = import ./variables/hardware.nix; }
  { file = "variables/identity.nix"; value = import ./variables/identity.nix; }
  { file = "variables/locale.nix"; value = import ./variables/locale.nix; }
  { file = "variables/memory.nix"; value = import ./variables/memory.nix; }
  { file = "variables/networking.nix"; value = import ./variables/networking.nix; }
  { file = "variables/profiles.nix"; value = import ./variables/profiles.nix; }
  { file = "variables/security.nix"; value = import ./variables/security.nix; }
  { file = "variables/storage.nix"; value = import ./variables/storage.nix; }
]
