
{ config, ... }:
let
  nasServer = "192.168.0.200";

  nasShareConfig = { shareName }: {
    device = "//${nasServer}/${shareName}";
    fsType = "cifs";

    # 1. automount: mounts on demand when you enter the folder
    # 2. idle-timeout: unmounts after 60s of inactivity to save resources
    # 3. uid/gid: maps the NAS files to YOUR local user ID
    options = [
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "credentials=/etc/nixos/smb-secrets"
      "uid=1000" # Run 'id' in terminal to confirm your UID, usually 1000
      "gid=100"  # Usually 100 for 'users' group
      "file_mode=0644"
      "dir_mode=0755"
    ];
  };
in {
  fileSystems."/home/ahk/nas/vm" = nasShareConfig {
    shareName = "vm";
  };
  fileSystems."/home/ahk/nas/backup" = nasShareConfig {
    shareName = "backup";
  };
  fileSystems."/home/ahk/nas/ahk" = nasShareConfig {
    shareName = "HomeDirs";
  };
  fileSystems."/home/ahk/nas/andet/andet" = nasShareConfig {
    shareName = "andet";
  };
  fileSystems."/home/ahk/nas/photo" = nasShareConfig {
    shareName = "photo";
  };
  fileSystems."/home/ahk/nas/downloads" = nasShareConfig {
    shareName = "downloads";
  };
}
