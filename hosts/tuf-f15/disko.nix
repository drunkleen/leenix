_:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-INTEL_SSDPEKNU512GZ_BTKA21210B8Z512A";

      content = {
        type = "gpt";

        partitions = {
          ESP = {
            label = "NIXBOOT";
            name = "ESP";
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
            label = "NIXOS-LUKS";
            size = "100%";

            content = {
              type = "luks";
              name = "cryptroot";

              settings = {
                allowDiscards = true;
              };

              content = {
                type = "btrfs";
                extraArgs = [
                  "-L"
                  "NIXOS"
                  "-f"
                ];

                subvolumes = {
                  "@root" = {
                    mountpoint = "/";

                    mountOptions = [
                      "compress=zstd:1"
                      "noatime"
                      "ssd"
                    ];
                  };

                  "@home" = {
                    mountpoint = "/home";

                    mountOptions = [
                      "compress=zstd:1"
                      "noatime"
                      "ssd"
                    ];
                  };

                  "@nix" = {
                    mountpoint = "/nix";

                    mountOptions = [
                      "compress=zstd:1"
                      "noatime"
                      "ssd"
                    ];
                  };

                  "@log" = {
                    mountpoint = "/var/log";

                    mountOptions = [
                      "compress=zstd:1"
                      "noatime"
                      "ssd"
                    ];
                  };

                  "@snapshots" = {
                    mountpoint = "/.snapshots";

                    mountOptions = [
                      "compress=zstd:1"
                      "noatime"
                      "ssd"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
