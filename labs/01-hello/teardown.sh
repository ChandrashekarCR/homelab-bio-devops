#!/usr/bin/env bash
# Remove everything lab-hello created. Safe to run repeatedly.
# Exits non-zero if anything is left behind.
set -euo pipefail

unit=lab-hello.service

if systemctl list-unit-files "$unit" --no-legend | grep -q .; then
  sudo systemctl disable --now "$unit"
fi

sudo rm -f "/etc/systemd/system/$unit"
sudo systemctl daemon-reload

# reset-failed errors when there's no failed record

sudo systemctl reset-failed "$unit" 2>/dev/null || true
sudo rm -rf /srv/lab/hello

echo "--- teardown verification ---"
fail=0
check() {
  local what=$1; shift
  if "$@"; then echo "FAIL: $what"; fail=1; else echo "ok:   no $what"; fi
}
check "unit file"        bash -c "systemctl list-unit-files $unit --no-legend | grep -q ."
check "running process"  systemctl is-active --quiet "$unit"
check "listener on 8000" bash -c "ss -tlnH 'sport = :8000' | grep -q ."
check "files"            test -e /srv/lab/hello
exit "$fail"
