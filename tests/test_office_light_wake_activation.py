import pathlib
import unittest

ROOT = pathlib.Path(__file__).parents[1]


class OfficeLightWakeActivationTests(unittest.TestCase):
    def test_manual_monitor_off_starts_wake_listener_first(self):
        source = (ROOT / "hosts/nixos/desktop/office-lights.nix").read_text()
        script = source.split("text = ''", 1)[1].split("'';", 1)[0]
        self.assertLess(
            script.index("systemctl --user start office-light-wake.service"),
            script.index("systemctl --user start office-light-screen-off.service"),
        )

    def test_idle_monitor_off_starts_wake_listener_first(self):
        source = (ROOT / "hosts/nixos/desktop/noctalia.nix").read_text()
        command = source.split('command = "', 1)[1].split('";', 1)[0]
        self.assertLess(
            command.index("systemctl --user start office-light-wake.service"),
            command.index("systemctl --user start office-light-screen-off.service"),
        )


if __name__ == "__main__":
    unittest.main()
