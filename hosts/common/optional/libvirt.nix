{inputs, lib, pkgs, config, ...}:
{
  imports = [ ];

  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    enable = true;
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
    extraConfig = ''swtpm = "/run/current-system/sw/bin/swtpm"'';
  };
  virtualisation.spiceUSBRedirection.enable = true;

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

