{ variables }:

{
  luks = {
    inherit (variables.boot.luks)
      device
      uuid
      mapperName;

    fido2 = variables.boot.fido2;
  };

  mkinitcpio = {
    configFile = "/etc/mkinitcpio.conf.d/leenix_hooks.conf";

    hooks = [
      "base"
      "systemd"
      "plymouth"
      "keyboard"
      "autodetect"
      "microcode"
      "modconf"
      "kms"
      "sd-vconsole"
      "block"
      "sd-encrypt"
      "filesystems"
      "fsck"
      "btrfs-overlayfs"
    ];

    files = [
      "/etc/vconsole.conf"
    ];
  };

  root = variables.boot.root;
}
