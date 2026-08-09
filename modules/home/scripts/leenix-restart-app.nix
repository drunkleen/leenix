{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-app";

      runtimeInputs = with pkgs; [
        procps
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Restart an application by killing it and relaunching via uwsm.

        # leenix:args= [application-args...]

        pkill -x "$1"
        setsid uwsm-app -- "$@" >/dev/null 2>&1 &
      '';
    })
  ];
}