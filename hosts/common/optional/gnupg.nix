{inputs, lib, pkgs, config, ...}:
{
  environment.systemPackages = with pkgs; [
      # gnupg
      # pinentry
      # pinentry-gnome
  ];

   # GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.pcscd.enable = true;

}

