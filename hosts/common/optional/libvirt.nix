{inputs, lib, pkgs, config, ...}:
{
  imports = [ ];

  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    parallelShutdown = 3;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      # ovmf = {
      #   enable = true;
      #   packages = [
      #     pkgs.OVMFFull.fd
      #   ];
      # };
    };
    # extraConfig = ''swtpm = "/run/current-system/sw/bin/swtpm"'';
  };
  virtualisation.spiceUSBRedirection.enable = true;

  # systemd.services.virt-secret-init-encryption = {
  #   enable = true;
  #   # We override the broken /usr/bin/sh command with a direct path to bash
  #   serviceConfig.ExecStart = lib.mkForce (
  #     "${pkgs.bash}/bin/bash -c 'umask 0077 && (dd if=/dev/random status=none bs=32 count=1 | ${pkgs.systemd}/bin/systemd-creds encrypt --name=secrets-encryption-key - /var/lib/libvirt/secrets/secrets-encryption-key)'"
  #   );
  #   # Ensure the directory exists before the service runs
  #   preStart = "mkdir -p /var/lib/libvirt/secrets";
  # };

  systemd.sockets.virtqemud = {
    description = "Libvirt QEMU local socket";
    wantedBy = [ "sockets.target" ];
  };

  environment.systemPackages = [
    pkgs.qemu_kvm
    pkgs.qemu
    pkgs.swtpm
    pkgs.OVMFFull
  ];

  users.users.${config.hostSpec.username} = {
    extraGroups = [ "libvirtd" ];
  };
}

