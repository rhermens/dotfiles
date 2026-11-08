{ ... }:
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/wwn-0x50014ee20b82d9c2";

    content = {
      type = "gpt";

      partitions = {
        ESP = {
          size = "1G";
          type = "EF00";

          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };

        root = {
          size = "100%";

          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}
