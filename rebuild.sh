#!/usr/bin/env bash
set -euo pipefail

# Simple wrapper around nixos-rebuild that runs a pre-cleanup step.
# Usage: rebuild <hostname>

if [[ $# -ne 1 ]]; then
  echo "Usage: $(basename "$0") <hostname>"
  exit 1
fi

HOSTNAME="$1"

echo ">>> Deleting problematic mimeapps.list.bk for user $USER..."
rm -f "${HOME}/.config/mimeapps.list.bk"

echo ">>> Rebuilding NixOS for host: ${HOSTNAME}"
sudo nixos-rebuild switch --flake "${HOME}/nixos#${HOSTNAME}"

echo ">>> Deleting problematic mimeapps.list.bk again for user $USER..."
rm -f "${HOME}/.config/mimeapps.list.bk"

echo ">>> Rebuild complete."

