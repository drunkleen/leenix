{ config, ... }:

{
  disko.devices.disk.main = {
    type = "disk";
    device = config.leenix.disk.device;

    content = {
      type = "gpt";

      partitions = {
        ESP = {
          size = "2G";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";

            mountOptions = [
              "umask=0077"
            ];
          };
        };

        luks = {
          size = "100%";

          content = {
            type = "luks";
            name = "cryptroot";

            settings = {
              allowDiscards = true;
            };

            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];

              subvolumes = {
                "@root" = {
                  mountpoint = "/";

                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                    "discard=async"
                  ];
                };

                "@home" = {
                  mountpoint = "/home";

                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                    "discard=async"
                  ];
                };

                "@nix" = {
                  mountpoint = "/nix";

                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                    "discard=async"
                  ];
                };

                "@log" = {
                  mountpoint = "/var/log";

                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                    "discard=async"
                  ];
                };

                "@snapshots" = {
                  mountpoint = "/.snapshots";

                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                    "ssd"
                    "discard=async"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}
