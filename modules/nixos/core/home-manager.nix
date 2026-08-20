{ config, ... }:

# LEENIX Core -> Home Manager typed policy bridge.
#
# Passes the fully evaluated, typed `config.leenix` policy tree to every Home
# Manager module via the `leenix` special argument. The dependency path:
#
#   typed leenix.* policy (set by the instance)
#       -> typed config.leenix.*
#       -> home-manager.extraSpecialArgs.leenix
#       -> Home consumers
#
# Design notes:
#   - `config.leenix` is already the single canonical typed policy source; no
#     second schema/projection is maintained. mkDefault/tri-state results are
#     already resolved before Home Manager ever reads the value.
#   - The whole subtree is plain data (verified: `builtins.toJSON config.leenix`
#     succeeds), so passing it as a specialArg is safe — no functions,
#     derivations, module internals or evaluation cycles. This mirrors Home
#     Manager's own `home-manager.extraSpecialArgs.nixosConfig = config`.
#   - Home modules never reach raw host `variables`; they only see the typed
#     policy under `leenix`.
#   - Future `leenix.*` options automatically become available to Home modules.
#
# This module is injected by the canonical mkInstance constructor for every
# instance (production tuf-f15 and fixtures alike), so it is Core-owned and
# requires no per-instance duplication.
{
  home-manager.extraSpecialArgs.leenix = config.leenix;
}
