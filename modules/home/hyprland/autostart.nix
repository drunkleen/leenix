{ ... }:

{
  home.file.".config/hypr/autostart.conf" = {
    force = true;

    text = ''
      # Extra autostart processes

      # exec-once = uwsm-app -- my-service
    '';
  };
}
