{ pkgs, ... }:

{
  home.packages = [
    pkgs.cliamp
    (pkgs.writeShellApplication {
      name = "leenix-launch-music";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the terminal music player (CLIAMP) in the default terminal.
        # leenix:args= [file|dir|glob|url|--auto-play ...]
        # leenix:examples=leenix-launch-music ~/Downloads/song.mp3 | leenix-launch-music --auto-play ~/Music

        # Forward any arguments as CLIAMP positional args (files/directories/globs/URLs),
        # which CLIAMP resolves into its queue. Add --auto-play to start playback
        # immediately (matches CLIAMP's native flag contract).
        leenix-launch-or-focus-tui cliamp "$@"
      '';
    })
  ];
}
