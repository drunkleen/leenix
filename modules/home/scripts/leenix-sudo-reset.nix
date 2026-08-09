{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-sudo-reset";

      runtimeInputs = with pkgs; [
        shadow
        linux-pam
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Reset the sudo lockout/faillock for the current user.

        su -c "faillock --reset --user $USER"
      '';
    })
  ];
}