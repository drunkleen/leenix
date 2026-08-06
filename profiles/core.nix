{
  inputs,
  pkgs,
  vars,
  ...
}:

{
  nix.settings.warn-dirty = false;

  environment.systemPackages = [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  time.timeZone = vars.timezone;
  i18n.defaultLocale = vars.locale;
  console.keyMap = vars.keymap;
}
