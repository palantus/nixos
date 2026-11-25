{ config, lib, pkgs, ... }:

let
  officeLight = pkgs.writeShellScriptBin "office-light" ''
    exec ${pkgs.python3}/bin/python3 ${./office-light.py} "$@"
  '';

  officeLightManualOff = pkgs.writeShellApplication {
    name = "office-light-manual-off";
    runtimeInputs = with pkgs; [ coreutils systemd niri ];
    text = ''
      systemctl --user start office-light-wake.service
      systemctl --user start office-light-screen-off.service
      sleep 0.2 # Let the Super+M key release before forcing swayidle idle.
      systemctl --user kill --signal=SIGUSR1 office-light-wake.service
      niri msg action power-off-monitors
    '';
  };

  officeLightWake = pkgs.writeShellScript "office-light-wake" ''
    exec ${pkgs.swayidle}/bin/swayidle -w timeout 1 \
      ${pkgs.coreutils}/bin/true resume \
      '${pkgs.systemd}/bin/systemctl --user start office-light-screen-on.service'
  '';

  envFile = "/home/ahk/.config/office-lights.env";
in
{
  environment.systemPackages = [ officeLight officeLightManualOff ];

  # Create /home/ahk/.config/office-lights.env with HA_URL and HA_TOKEN;
  # keep it user-readable only (chmod 600) and never commit it.
  systemd.services.office-lights = {
    description = "Turn office lights on at boot and off at shutdown";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    serviceConfig = {
      EnvironmentFile = "/home/ahk/.config/office-lights.env";
      Type = "oneshot";
      RemainAfterExit = true;
      User = "ahk";
      ExecStart = "${officeLight}/bin/office-light --on";
      ExecStop = "${officeLight}/bin/office-light --off";
      TimeoutStartSec = "30s";
      TimeoutStopSec = "30s";
    };
  };

  systemd.user.services = {
    office-light-screen-off = {
      description = "Save and turn off the office light for display sleep";
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = envFile;
        ExecStart = "${officeLight}/bin/office-light --screen-off";
      };
    };

    office-light-screen-on = {
      description = "Restore the office light after display wake";
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = envFile;
        ExecStart = "${officeLight}/bin/office-light --screen-on";
      };
    };

    office-light-wake = {
      description = "Detect input after display power-off and restore the office light";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = officeLightWake;
        Restart = "on-failure";
      };
    };
  };
}
