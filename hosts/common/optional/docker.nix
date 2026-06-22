{ pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman
    dockerCompat = true;

    # Required for containers under podman-compose to talk to each other
    defaultNetwork.settings.dns_enabled = true;
  };

  # Useful system packages for podman users
  environment.systemPackages = with pkgs; [
    podman-compose # If you need docker-compose style orchestration
  ];
}
