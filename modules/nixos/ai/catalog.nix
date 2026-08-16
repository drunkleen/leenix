# LEENIX canonical AI capability registry.
#
# Single source of truth for the declarative AI catalog. Everything else in
# modules/nixos/ai/ is DERIVED from this file:
#   - options.nix     generates leenix.ai.<category>.<leaf>.enable
#   - assertions.nix  profile-gate / unfree / platform assertions
#   - checks.nix      frozen-count + consistency checks
#   - default.nix     package composition (imported by profiles/ai.nix)
#
# Leaf metadata:
#   description       human-readable capability description
#   kind              cli / tui / gui / runtime
#   classification    "A" = global Nix-owned package
#   packages          pkgs: -> [ pkg ... ]
#   platforms         [ "x86_64-linux" "aarch64-linux" ]
#   guarded           defensive package selection (pkgs.X or null + availableOn)
#   unfree            requires nixpkgs.config.allowUnfree (never silently enabled)
#   heavy             package/build heaviness
#   runtimeHeavy      runtime/model-storage heaviness (local runtimes, many GB)
#   configPath        documented declarative config path (HM-owned, non-secret)
#   themeSupport      A native LEENIUM / B terminal-inherited / C partial / D none
#   autoUpdatePolicy  documented self-update handling for Nix-owned install
{
  codingAgents = {
    "claudeCode" = { description = "Claude Code (Anthropic agentic coding CLI)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.claude-code ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = false; runtimeHeavy = false; configPath = "~/.claude/settings.json"; themeSupport = "C"; autoUpdatePolicy = "disabled-by-nixpkgs (DISABLE_AUTOUPDATER)"; };
    "codex"      = { description = "OpenAI Codex CLI"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.codex ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = false; configPath = "~/.codex/config.toml"; themeSupport = "B"; autoUpdatePolicy = "config auto_update=false"; };
    "geminiCli"  = { description = "Google Gemini CLI"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.gemini-cli ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = false; configPath = "~/.gemini/settings.json"; themeSupport = "C"; autoUpdatePolicy = "disabled-by-nixpkgs (enableAutoUpdate=false)"; };
    "goose"      = { description = "Goose (Block terminal AI agent)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.goose ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = false; configPath = "~/.config/goose/config.toml"; themeSupport = "B"; autoUpdatePolicy = "none"; };
    "openclaw"   = { description = "OpenClaw (self-hosted AI assistant/agent)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.openclaw ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = false; configPath = "~/.openclaw/"; themeSupport = "B"; autoUpdatePolicy = "none"; };
    "opencode"   = { description = "OpenCode (terminal AI coding agent)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.opencode ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = false; configPath = "~/.config/opencode/opencode.json"; themeSupport = "A"; autoUpdatePolicy = "config autoupdate=false"; };
    "qwenCode"   = { description = "Qwen Code (Qwen CLI coding agent)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.qwen-code ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = false; configPath = "~/.config/qwen-code/"; themeSupport = "B"; autoUpdatePolicy = "none"; };
  };
  localRuntimes = {
    "gpt4all"   = { description = "GPT4All (local model GUI)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.gpt4all ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = true; configPath = ""; themeSupport = "D"; autoUpdatePolicy = "none"; };
    "jan"       = { description = "Jan (local model GUI)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.jan ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = true; configPath = "~/.config/jan/"; themeSupport = "D"; autoUpdatePolicy = "none"; };
    "koboldcpp" = { description = "KoboldCpp (local LLM server)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.koboldcpp ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = true; configPath = ""; themeSupport = "D"; autoUpdatePolicy = "none"; };
    "llamaCpp"  = { description = "llama.cpp (local inference CLI)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.llama-cpp ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = true; configPath = ""; themeSupport = "D"; autoUpdatePolicy = "none"; };
    "lmstudio"  = { description = "LM Studio (local model GUI)"; kind = "gui"; classification = "A"; packages = pkgs: [ pkgs.lmstudio ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = true; heavy = false; runtimeHeavy = true; configPath = "~/.lmstudio/"; themeSupport = "D"; autoUpdatePolicy = "none"; };
    "ollama"    = { description = "Ollama (local model runtime CLI/server)"; kind = "runtime"; classification = "A"; packages = pkgs: [ pkgs.ollama ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = true; configPath = ""; themeSupport = "D"; autoUpdatePolicy = "none"; };
  };
  mcp = {
    "mcpProxy" = { description = "mcp-proxy (MCP stdio/sse proxy tool)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.mcp-proxy ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = false; configPath = ""; themeSupport = "D"; autoUpdatePolicy = "none"; };
  };
  utilities = {
    "aider"  = { description = "Aider (terminal AI pair programmer)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.aider-chat ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = false; configPath = "~/.aider.conf.yml"; themeSupport = "C"; autoUpdatePolicy = "none"; };
    "fabric" = { description = "Fabric (AI prompt/context utility)"; kind = "cli"; classification = "A"; packages = pkgs: [ pkgs.fabric-ai ]; platforms = [ "x86_64-linux" "aarch64-linux" ]; guarded = false; unfree = false; heavy = false; runtimeHeavy = false; configPath = "~/.config/fabric/"; themeSupport = "B"; autoUpdatePolicy = "none"; };
  };
}
