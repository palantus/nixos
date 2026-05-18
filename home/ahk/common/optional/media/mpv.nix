{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    package = pkgs.mpv.override {
      # Ensures it's compiled with full Wayland/Vulkan support
      scripts = [ pkgs.mpvScripts.mpris ];
    };
    config = {
      # --- The Fixes ---
      vo = "gpu-next";
      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      hwdec = "vaapi"; # Native for your 9070XT

      # --- HDR Auto-Switching ---
      target-colorspace-hint = "yes";
      tone-mapping = "bt.2446a"; # Excellent for HDR->SDR if it fails, or fine-tuning HDR
      
      # --- Clean up ---
      # Remove d3d11-output-csp completely!
      
      # --- Quality ---
      profile = "gpu-hq";
      video-sync = "display-resample";
    };
  };
}
