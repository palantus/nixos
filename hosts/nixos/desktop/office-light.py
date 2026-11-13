#!/usr/bin/env python3
"""Control the office light through the Home Assistant REST API.

Set HA_URL and HA_TOKEN in the environment. With no argument, toggle the
light. Use --on/--off for idempotent boot and shutdown hooks.
"""

import json
import os
import sys
from datetime import datetime
from typing import Any
import urllib.error
import urllib.request

ENTITY_ID = "light.kontorskab_kontorlys"


def request(ha_url: str, token: str, path: str, payload: dict | None = None) -> Any:
    data = None if payload is None else json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        f"{ha_url.rstrip('/')}{path}",
        data=data,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        method="GET" if payload is None else "POST",
    )
    with urllib.request.urlopen(req, timeout=10) as response:
        body = response.read()
        return json.loads(body) if body else None


def main() -> int:
    if len(sys.argv) > 2 or (len(sys.argv) == 2 and sys.argv[1] not in {"--on", "--off"}):
        print(f"Usage: {sys.argv[0]} [--on|--off]", file=sys.stderr)
        return 2

    ha_url = os.environ.get("HA_URL")
    token = os.environ.get("HA_TOKEN")
    if not ha_url or not token:
        print("Set both HA_URL and HA_TOKEN environment variables.", file=sys.stderr)
        return 2

    try:
        mode = sys.argv[1] if len(sys.argv) == 2 else None
        if mode is None:
            current = request(ha_url, token, f"/api/states/{ENTITY_ID}").get("state")
            if current not in {"on", "off"}:
                print(f"Unexpected state for {ENTITY_ID}: {current!r}", file=sys.stderr)
                return 1
            turn_on = current == "off"
            turn_off = current == "on"
        else:
            current = None
            turn_on = mode == "--on"
            turn_off = mode == "--off"

        if turn_off and current == "off":
            print("Office light already off; no change needed.")
            return 0

        brightness = None
        if turn_on:
            brightness = 75 if datetime.now().hour < 18 else 40
            service = "turn_on"
            payload = {"entity_id": ENTITY_ID, "brightness_pct": brightness}
        else:
            service = "turn_off"
            payload = {"entity_id": ENTITY_ID}
        request(ha_url, token, f"/api/services/light/{service}", payload)

        target = "on" if turn_on else "off"
        suffix = f" at {brightness}%" if brightness is not None else ""
        print(f"Requested office light {target}{suffix}.")
        return 0
    except urllib.error.HTTPError as exc:
        print(f"Home Assistant returned HTTP {exc.code}.", file=sys.stderr)
    except (urllib.error.URLError, TimeoutError) as exc:
        print(f"Could not reach Home Assistant: {exc}", file=sys.stderr)
    except (ValueError, KeyError, TypeError) as exc:
        print(f"Unexpected Home Assistant response: {exc}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
