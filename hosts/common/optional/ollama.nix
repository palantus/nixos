{ pkgs, ... }:
{
  # Enable ROCm and hardware graphics
  hardware.graphics = {
    extraPackages = with pkgs; [
      rocmPackages.clr
      rocmPackages.clr.icd # Essential for OpenCL/HIP discovery
      rocmPackages.rocminfo
      rocmPackages.rocm-smi
    ];
  };

  services.ollama = {
    enable = true;
    host = "0.0.0.0"; # make accessible to other computers

    # Use the ROCm-specific package directly
    package = pkgs.ollama-rocm; 
    
    # This helper handles the HSA_OVERRIDE_GFX_VERSION for you in newer NixOS
    rocmOverrideGfx = "12.0.1"; 

    # Keep the origins open for OpenCode to connect
    environmentVariables = {
      OLLAMA_ORIGINS = "http://localhost:*,http://127.0.0.1:*";
      # Sometimes RDNA 4 still needs the explicit env var alongside the helper
      HSA_OVERRIDE_GFX_VERSION = "12.0.1";
    };
  };

  environment.systemPackages = with pkgs; [
    rocmPackages.rocm-smi
  ];
}
