{inputs, lib, pkgs, config, ...}:
{
  imports = [ ];

  programs.virt-manager.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = [
    pkgs.qemu_kvm
    pkgs.qemu
  ];

  users.users.${config.hostSpec.username} = {
    extraGroups = [ "libvirtd" ];
  };
}

