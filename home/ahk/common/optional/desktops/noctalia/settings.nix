# Noctalia v5.4.1 settings; import this exactly like your previous settings.nix.
# Legacy options without a direct v5 equivalent are intentionally omitted.
# Restores intended v4 behaviour: hourly wallpaper rotation, notification filters,
# lock-before-suspend, launcher systemd scope, and the Stylix palette.
# GUI overrides in the Noctalia state directory still take precedence.
{ config, lib, ... }:
let
  # v5 reads palettes from JSON, not from a top-level `dark` settings table.
  # The v5.4.1 resolver accepts an absolute basename and appends `.json`.
  stylixPalette = builtins.toFile "noctalia-stylix.json" (builtins.toJSON {
    dark = {
      mSurface = "#${config.lib.stylix.colors.base00}";
      mOnSurface = "#${config.lib.stylix.colors.base03}";
      mSurfaceVariant = "#${config.lib.stylix.colors.base01}";
      mOnSurfaceVariant = "#${config.lib.stylix.colors.base04}";
  
      mPrimary = "#${config.lib.stylix.colors.base02}";
      mOnPrimary = "#${config.lib.stylix.colors.base0E}";
      mSecondary = "#${config.lib.stylix.colors.base0F}";
      mOnSecondary = "#${config.lib.stylix.colors.base01}";
      mTertiary = "#${config.lib.stylix.colors.base01}";
      mOnTertiary = "#${config.lib.stylix.colors.base0F}";
      mHover = "#${config.lib.stylix.colors.base01}";
      mOnHover = "#${config.lib.stylix.colors.base0A}";
  
      mError = "#${config.lib.stylix.colors.base08}";
      mOnError = "#${config.lib.stylix.colors.base00}";
  
      mOutline = "#${config.lib.stylix.colors.base01}";
  
      mShadow = "#000000";
    };
  });
in
{
  desktop_widgets = {
    enabled = false;
  };
  shell = {
    lang = "";
    time_format = "{:%H:%M}";
    avatar_path = "/home/ahk/nixos/assets/avatars/avatarparody_square.jpg";
    telemetry_enabled = false;
    polkit_agent = false;
    corner_radius_scale = 1.0;
    password_style = "default";
    launch_apps_custom_command = "systemd-run --user --scope --collect -- $CMD";
    animation = {
      enabled = true;
      speed = 1.0;
    };
    shadow = {
      direction = "down_right";
    };
    screen_corners = {
      enabled = false;
    };
    panel = {
      wallpaper_show_names = false;
      wallpaper_position = "center";
      session_position = "center";
      launcher_placement = "attached";
      clipboard_placement = "attached";
      control_center_placement = "attached";
      wallpaper_placement = "attached";
      session_placement = "attached";
      shadow = true;
    };
    launcher = {
      layout = "full";
      search_position = "bottom";
      default_view = "recent";
      categories = true;
      show_settings_button = false;
      show_session_button = false;
      app_grid = false;
      track_usage = true;
    };
    session = {
      grid = false;
      show_shortcuts = true;
      actions = [
        {
          action = "lock";
          enabled = true;
          shortcut = "1";
          countdown_seconds = 0;
        }
        {
          action = "suspend";
          enabled = true;
          shortcut = "2";
          countdown_seconds = 0;
        }
        {
          action = "hibernate";
          enabled = true;
          shortcut = "3";
          countdown_seconds = 0;
        }
        {
          action = "reboot";
          enabled = true;
          shortcut = "4";
          countdown_seconds = 0;
        }
        {
          action = "logout";
          enabled = true;
          shortcut = "5";
          countdown_seconds = 0;
        }
        {
          action = "shutdown";
          enabled = true;
          shortcut = "6";
          countdown_seconds = 0;
        }
        {
          action = "command";
          label = "Reboot to UEFI";
          command = "systemctl reboot --firmware-setup";
          enabled = true;
          shortcut = "7";
          countdown_seconds = 0;
        }
      ];
    };
  };
  accessibility = {
    ui_scale = 1.0;
  };
  brightness = {
    enable_ddcutil = false;
    minimum_brightness = 0.2;
    sync_all_monitors = false;
  };
  calendar = {
    enabled = true;
    event_date_format = "%A %e %B";
  };
  backdrop = {
    enabled = false;
    blur_intensity = 0.4;
    tint_intensity = 0.6;
  };
  lockscreen = {
    lock_before_suspend = true;
    fingerprint = true;
    blur_intensity = 0.25;
    tint_intensity = 0.6;
    monitors = [ ];
  };
  keybinds = {
    down = [ "Down" "Ctrl+J" ];
    validate = [ "Return" "KP_Enter" ];
    cancel = [ "Escape" ];
    left = [ "Left" "Ctrl+H" ];
    delete = [ "Delete" ];
    right = [ "Right" "Ctrl+L" ];
    up = [ "Up" "Ctrl+K" ];
  };
  idle = {
    behavior_order = [ "lock" "screen-off" ];
    behavior = {
      lock = {
        timeout = 660;
        action = "lock";
        enabled = false;
      };
      screen-off = {
        timeout = 300;
        action = "screen_off";
        enabled = true;
      };
      suspend = {
        timeout = 1800;
        action = "lock_and_suspend";
        enabled = false;
      };
    };
  };
  location = {
    auto_locate = false;
    address = "Calgary, AB";
  };
  nightlight = {
    enabled = false;
  };
  system = {
    monitor = {
      cpu_usage_activity_threshold = 80;
      cpu_usage_critical_threshold = 90;
      gpu_usage_activity_threshold = 80;
      gpu_usage_critical_threshold = 90;
      ram_pct_activity_threshold = 80;
      ram_pct_critical_threshold = 90;
      swap_pct_activity_threshold = 80;
      swap_pct_critical_threshold = 90;
      disk_used_pct_activity_threshold = 80;
      disk_used_pct_critical_threshold = 90;
      disk_free_pct_activity_threshold = 20;
      disk_free_pct_critical_threshold = 10;
      cpu_temp_activity_threshold = 80;
      cpu_temp_critical_threshold = 90;
      gpu_temp_activity_threshold = 80;
      gpu_temp_critical_threshold = 90;
    };
  };
  wallpaper = {
    enabled = true;
    default = {
      path = "/home/ahk/nixos/assets/wallpapers/zen-01.png";
    };
    directory = "/home/ahk/nixos/assets/wallpapers";
    fill_color = "#000000";
    fill_mode = "crop";
    per_monitor_directories = true;
    transition = [ "fade" "disc" "stripes" "wipe" "pixel" "honeycomb" ];
    transition_duration = 1500;
    edge_smoothness = 0.05;
    transition_on_startup = true;
    automation = {
      enabled = true;
      interval_seconds = 3600;
      order = "random";
    };
  };
  weather = {
    enabled = true;
    refresh_minutes = 15;
    unit = "metric";
    effects = true;
  };
  bar = {
    default = {
      position = "top";
      concave_edge_corners = false;
      auto_hide = false;
      auto_hide_delay_ms = 500;
      reserve_space = true;
      font_scale = 1.25;
      margin_ends = 0;
      margin_edge = 0;
      radius = 0;
      padding = 5;
      widget_spacing = 15;
      show_on_workspace_switch = true;
      capsule = false;
      border_width = 0.0;
      background_opacity = 1.0;
      start = [ "workspaces" ];
      center = [ "active_window" ];
      end = [ "notifications" "tray" "volume" "network" "bluetooth" "battery" "clock" ];
    };
  };
  battery = {
    warning_threshold = 20;
  };
  widget = {
    clock = {
      format = "{:%a %d.%m.%Y %H:%M}";
    };
  };
  dock = {
    enabled = false;
    position = "bottom";
  };
  notification = {
    enable_daemon = true;
    show_app_name = true;
    show_actions = true;
    position = "top_right";
    layer = "top";
    scale = 1.0;
    background_opacity = 0.95;
    border = true;
    border_color = "outline_variant";
    border_width = 1;
    follow_focused_output = false;
    offset_x = 20;
    offset_y = 8;
    monitors = [ ];
    collapse_on_dismiss = true;
    keep_dismissed_in_history = true;
    max_visible = 3;
    history_retention_hours = 0;
    filter = {
      chrome = {
        match = "chrome";
        play_sound = false;
        show_toast = false;
      };
      chromium = {
        match = "chromium";
        play_sound = false;
        show_toast = false;
      };
      discord = {
        match = "discord";
        play_sound = false;
        show_toast = false;
      };
      firefox = {
        match = "firefox";
        play_sound = false;
        show_toast = false;
      };
    };
  };
  osd = {
    enabled = true;
    hide_delay_ms = 2000;
    position = "top_right";
    monitors = [ ];
  };
  plugins = {
    auto_update = "all";
  };
  theme = {
    mode = "dark";
    shell_mode = "follow";
    source = "custom";
    custom_palette = lib.removeSuffix ".json" (toString stylixPalette);
    templates = {
      enable_builtin_templates = false;
      enable_community_templates = false;
    };
  };
}

# Removed rather than guessed:
# - general/ui options with no exact v5 equivalent (compact lockscreen, exact panel
#   opacity/font ratios, settings window styling, countdown/media widgets, etc.).
# - noctaliaPerformance: no matching v5 section; dock/desktop widgets remain off
#   through their explicit enabled=false settings above.
# - Disabled/empty hooks, disabled dock tuning, settingsVersion, empty plugin_settings.
# - Old wallpaper picker/Wallhaven options and empty favourites/monitor lists.
# - Old system-monitor external application and custom warning colours.
# - Commented v4 plugin widgets: not active in your supplied configuration.
# - plugins.autoUpdate/notifyUpdates: v5 ignores them; auto_update="all" retained.
# OSD numeric enabledTypes cannot be mapped safely; v5 default popup kinds are used.
# Exact v4 translucent panel appearance is left to the v5 appearance controls.
