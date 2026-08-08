{ variables }:

{
  pam = {
    hyprlock = {
      u2f = variables.yubikey;
    };
  };
}
