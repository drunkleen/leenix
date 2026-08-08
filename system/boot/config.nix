{
  luks = {
    device = "/dev/nvme0n1p2";
    uuid = "8da1c3c9-5ee6-4961-b935-4a3d76a6b0f0";
    mapperName = "root";

    fido2 = {
      device = "auto";
    };
  };

  mkinitcpio = {
    configFile = "/etc/mkinitcpio.conf.d/omarchy_hooks.conf";

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

  root = {
    zswap = false;
    flags = "subvol=@";
    readWrite = true;
    fsType = "btrfs";
  };
}
