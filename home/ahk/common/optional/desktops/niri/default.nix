{ pkgs, inputs, ... }:

{
  # 1. Install the necessary packages
  home.packages = with pkgs; [
    niri
    # noctalia
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    xwayland-satellite # Optional: for X11 app support in niri
    alacritty          # Or your preferred terminal
  ];

  # 2. Configure niri
  # This creates ~/.config/niri/config.kdl
  xdg.configFile."niri/config.kdl".text = ''
    // Spawn noctalia on startup
    spawn-at-startup "noctalia"

    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        touchpad {
            tap
            natural-scroll
        }
    }

    layout {
        gap 10
        center-focused-column "never"
    }

    // Basic Keybindings
    binds {
        Mod+Return { spawn "alacritty"; }
        Mod+Q { close-window; }
        Mod+Shift+E { quit; }
        
        // Focus movement
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        
        // Column resizing
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
    }
  '';

  # 3. Configure noctalia
  # This creates ~/.config/noctalia/config.toml
  xdg.configFile."noctalia/config.toml".text = ''
    # Sample Noctalia Configuration
    [bar]
    height = 30
    location = "top"
    font = "Sans 11"

    [modules]
    left = ["workspaces"]
    center = ["clock"]
    right = ["cpu", "memory", "battery", "network"]

    [module.clock]
    format = "%Y-%m-%d %H:%M"
    
    [module.workspaces]
    # Noctalia tracks niri workspaces automatically via IPC
    active_style = "bold"
  '';
}
