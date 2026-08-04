{ vars, ... }:

{
  time.timeZone = vars.timezone;

  i18n = {
    defaultLocale = vars.locale;

    extraLocaleSettings = {
      LC_ADDRESS = vars.locale;
      LC_IDENTIFICATION = vars.locale;
      LC_MEASUREMENT = vars.locale;
      LC_MONETARY = vars.locale;
      LC_NAME = vars.locale;
      LC_NUMERIC = vars.locale;
      LC_PAPER = vars.locale;
      LC_TELEPHONE = vars.locale;
      LC_TIME = vars.locale;
    };
  };

  console = {
    keyMap = vars.keymap;
  };
}
