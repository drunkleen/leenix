{
  xdg.dataFile = {
    "applications/leenium-lock.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Lock Screen
      GenericName=Power Action
      Comment=Lock the current session
      Icon=system-lock-screen
      Exec=loginctl lock-session
      Terminal=false
      Categories=System;
      Keywords=lock;screen;session;power;
    '';

    "applications/leenium-logout.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Log Out
      GenericName=Power Action
      Comment=Exit the current Hyprland session
      Icon=system-log-out
      Exec=hyprctl dispatch exit
      Terminal=false
      Categories=System;
      Keywords=logout;exit;session;power;
    '';

    "applications/leenium-suspend.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Suspend
      GenericName=Power Action
      Comment=Suspend the computer
      Icon=system-suspend
      Exec=systemctl suspend
      Terminal=false
      Categories=System;
      Keywords=suspend;sleep;power;
    '';

    "applications/leenium-reboot.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Reboot
      GenericName=Power Action
      Comment=Restart the computer
      Icon=system-reboot
      Exec=systemctl reboot
      Terminal=false
      Categories=System;
      Keywords=reboot;restart;power;
    '';

    "applications/leenium-shutdown.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=Shut Down
      GenericName=Power Action
      Comment=Power off the computer
      Icon=system-shutdown
      Exec=systemctl poweroff
      Terminal=false
      Categories=System;
      Keywords=shutdown;poweroff;power;
    '';
  };
}
