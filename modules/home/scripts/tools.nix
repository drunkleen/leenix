{ ... }:

{
  # Universal terminal tools: image/video transcoding. Headless-safe CLI
  # utilities that make sense on a minimal LEENIX VPS. Desktop-oriented tools
  # (reminder, weather, voxtype dictation) live in the desktop group.
  imports = [
    ./leenix-transcode-ascii.nix
    ./leenix-transcode.nix
  ];
}
