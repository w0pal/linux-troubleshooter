#!/usr/bin/env bash
set -euo pipefail

uname -a
echo "---"
cat /etc/os-release
echo "---"
systemd-detect-virt || true
echo "---"
ps -p 1 -o comm=
