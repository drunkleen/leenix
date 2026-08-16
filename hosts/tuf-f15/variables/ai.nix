# Host AI policy control panel — every accepted catalog leaf is explicitly
# listed, alphabetically ordered, all false by default.
#
# DATA / POLICY ONLY: booleans. Package implementation and capability metadata
# live in modules/nixos/ai/catalog.nix. profiles.ai (the master gate) is owned
# by variables/profiles.nix. Local runtimes install the binary only; models
# stay mutable user/runtime state.
{
  ai = {
    codingAgents = {
      claudeCode = false;
      codex = false;
      geminiCli = false;
      goose = false;
      openclaw = false;
      opencode = false;
      qwenCode = false;
    };
    localRuntimes = {
      gpt4all = false;
      jan = false;
      koboldcpp = false;
      llamaCpp = false;
      lmstudio = false;
      ollama = false;
    };
    mcp = {
      mcpProxy = false;
    };
    utilities = {
      aider = false;
      fabric = false;
    };
  };
}
