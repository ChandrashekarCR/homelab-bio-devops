#!/usr/bin/env bash

set -euo pipefail

readonly ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
readonly CONFIG="${ROOT_DIR}/services/samba/smb.conf"
readonly SETUP_SCRIPT="${ROOT_DIR}/scripts/setup-samba.sh"

grep -q '^   security = user$' "${CONFIG}"
grep -q '^   server min protocol = SMB2$' "${CONFIG}"
grep -q '^   map to guest = never$' "${CONFIG}"
grep -q '^   valid users = @family$' "${CONFIG}"
grep -q '^   force group = family$' "${CONFIG}"
grep -q '^   path = /srv/samba/family$' "${CONFIG}"

for user in chandru raju aruna; do
  grep -q "${user}" "${SETUP_SCRIPT}"
done

grep -q 'LEGACY_USER="amrita"' "${SETUP_SCRIPT}"
grep -q 'smbpasswd -x' "${SETUP_SCRIPT}"
! grep -q 'smbpasswd.*amrita' "${CONFIG}"

printf 'Samba configuration checks passed.\n'
