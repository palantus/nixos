{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;

      #
      # ========= Host Config Functions =========
      #
      # Handle a given host config based on the system (only NixOS in this case)
      mkHost = host: {
        ${host} =
          let
            systemFunc = lib.nixosSystem;
          in
          systemFunc {
            specialArgs = {
              inherit
                inputs
                outputs;
              
              # ========== Extend lib with lib.custom ==========
              # NOTE: This approach allows lib.custom to propagate into hm
              # see: https://github.com/nix-community/home-manager/pull/3454
              lib = nixpkgs.lib.extend (self: super: { custom = import ./lib { inherit (nixpkgs) lib; }; });
            };
            modules = [ ./hosts/nixos/${host} ];
          };
        };

      # Invoke mkHost for each host config that is declared for NixOS
      mkHostConfigs =
        hosts: lib.foldl (acc: set: acc // set) { } (lib.map mkHost hosts);

      # Return the hosts declared in the given directory
      readHosts = folder: lib.attrNames (builtins.readDir ./hosts/${folder});
    in
    {
      #
      # ========= Host Configurations =========
      #
      # Building configurations is available through `just rebuild` or `nixos-rebuild --flake .#hostname`
      nixosConfigurations = mkHostConfigs (readHosts "nixos");
    };

          
  #   nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
  #     specialArgs = {inherit inputs;};
  #     modules = [
  #       ./hosts/thinkpad/configuration.nix
  #       inputs.home-manager.nixosModules.default
  #     ];
  #   };
  #   nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
  #     specialArgs = {inherit inputs;};
  #     modules = [
  #       ./hosts/desktop/configuration.nix
  #       inputs.home-manager.nixosModules.default
  #     ];
  #   };
  # };
}
