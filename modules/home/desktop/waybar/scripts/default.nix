{ pkgs, ... }:

{
  weather = import ./weather.nix { inherit pkgs; };
  idleIndicator = import ./idle-indicator.nix { inherit pkgs; };
  notificationIndicator = import ./notification-silencing-indicator.nix { inherit pkgs; };
  screenrecordingIndicator = import ./screenrecording-indicator.nix { inherit pkgs; };
}
