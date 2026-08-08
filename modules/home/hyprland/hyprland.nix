{ ... }:

{
  home.file.".config/hypr/hyprland.conf" = {
    force = true;

    text = ''
      # Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/

      # Use defaults Omarchy defaults (but don't edit these directly!)

      source = ~/.local/share/omarchy/default/hypr/envs.conf
      source = ~/.local/share/omarchy/default/hypr/looknfeel.conf
      source = ~/.local/share/omarchy/default/hypr/input.conf
      source = ~/.config/omarchy/current/theme/hyprland.conf

      # Change your own setup in these files (and overwrite any settings from defaults!)

      source = ~/.config/hypr/bindings/media.conf
      source = ~/.config/hypr/bindings/clipboard.conf
      source = ~/.config/hypr/bindings/tiling-v2.conf
      source = ~/.config/hypr/bindings/utilities.conf

      source = ~/.config/hypr/monitors.conf
      source = ~/.config/hypr/input.conf
      source = ~/.config/hypr/bindings.conf
      source = ~/.config/hypr/looknfeel.conf
      source = ~/.config/hypr/autostart.conf

      source = ~/.config/hypr/windows.conf
      
      # Toggle config flags dynamically

      source = ~/.local/state/omarchy/toggles/hypr/*.conf

      # Add any other personal Hyprland configuration below

      # windowrule = workspace 5, match:class qemu
    '';
  };
}
