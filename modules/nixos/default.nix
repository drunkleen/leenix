{ vars, ... }:

{
  imports = [
    ./boot
    ./desktop
    ./hardware
    ./networking
    ./services
    ./storage
    ./users
  ];

  nix.settings.warn-dirty = false;

  time.timeZone = vars.timezone;
  i18n.defaultLocale = vars.locale;
  console.keyMap = vars.keymap;
}
