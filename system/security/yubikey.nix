{ variables }:

{
  authFile = variables.yubikey.authFile;

  userPresence = true;
  userVerification = false;
  pinVerification = true;
}
