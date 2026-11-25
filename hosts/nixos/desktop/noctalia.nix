{
  idle.behavior."screen-off" = {
    # Run the HA action and screen power request together; restore both on input.
    action = "command";
    command = "systemctl --user start office-light-wake.service && systemctl --user start office-light-screen-off.service && noctalia msg dpms-off";
    resume_command = "noctalia msg dpms-on; systemctl --user start office-light-screen-on.service";
  };
}
