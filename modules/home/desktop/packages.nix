{
  pkgs,
  lib,
  ...
}:

let
  # LocalSend ships its binary as `localsend_app`. LEENIX exposes the canonical
  # `localsend` command (GUI + `--headless send|receive` CLI) so scripts and the
  # menu call one stable name. No daemon is fabricated: `--headless receive`
  # runs LocalSend's own CLI receiver.
  localsend = pkgs.writeShellApplication {
    name = "localsend";
    runtimeInputs = [ pkgs.localsend ];
    text = ''
      exec localsend_app "$@"
    '';
  };
in
{
  # Desktop capability packages: LocalSend (file sharing, headless CLI for
  # sending) and v4l-utils (camera discovery). Installed with the desktop
  # profile only — never part of the universal base.
  home.packages = with pkgs; [
    localsend
    v4l-utils
  ];
}
