{ yubikey }:

{
  pam = {
    hyprlock = {
      u2f = yubikey;
    };
  };
}
