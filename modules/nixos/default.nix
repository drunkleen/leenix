{ vars, ... }:

{
  imports = [
    ./boot
    ./networking
    ./services
    ./storage
    ./users
  ];

  time.timeZone = vars.timezone;
  i18n.defaultLocale = vars.locale;
  console.keyMap = vars.keymap;
}
