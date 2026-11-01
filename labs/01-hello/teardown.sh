#!/usr/bin/env  bash

set -euo pipefail

# Remove everything created in lab 1.2. Can run this again and again

sudo systemctl diable --now lab-hello.service 2>/dev/null || true
sudo rm -rf /etc/systemd/system/lab-hello.service
sudo systemctl daemon-reload
sudo rm -rf /srv/lab/hello/

echo "--- teardown verfication ---"
systemctl list-unit-files 'lab-hello*' --no-legend | grep -q . && echo "FAIL: unit still present" || echo "ok: unit gone"
sudo ss -tpln | grep -q ":8000" && echo "FAIL: port still listening" || echo "ok: port 8000 free"
[[ -e /srv/lab/hello/ ]] && echo "FAIL: files reamin" || echo "ok: files gone"
