{ browser, ... }:

{
  imports = [
    {
      firefox = ./firefox.nix;
      chromium = ./chromium.nix;
      google-chrome = ./google-chrome.nix;
      brave = ./brave.nix;
      vivaldi = ./vivaldi.nix;
      librewolf = ./librewolf.nix;
    }.${browser}
  ];
}
