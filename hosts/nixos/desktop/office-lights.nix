{ config, lib, pkgs, ... }:

let
  officeLight = pkgs.writeShellScriptBin "office-light" ''
    exec ${pkgs.python3}/bin/python3 ${./office-light.py} "$@"
  '';
in
{
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
}
