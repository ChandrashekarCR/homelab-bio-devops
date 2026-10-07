#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
REPO_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
readonly REPO_ROOT
readonly CONFIG_SOURCE="${REPO_ROOT}/services/samba/smb.conf"
readonly SAMBA_CONFIG="${SAMBA_CONFIG:-/etc/samba/smb.conf}"
readonly SHARE_PATH="${SAMBA_SHARE_PATH:-/srv/samba/family}"
readonly SAMBA_GROUP="family"
readonly LEGACY_USER="amrita"
readonly SAMBA_USERS=(chandru raju aruna)

if [[ "${EUID}" -ne 0 ]]; then
  printf 'Run this script as root, for example: sudo %s\n' "$0" >&2
  exit 1
fi

for command_name in groupadd useradd usermod id install getent pdbedit smbpasswd testparm systemctl; do
  if ! command -v "${command_name}" >/dev/null 2>&1; then
    printf 'Required command not found: %s\nInstall Samba before running this script.\n' \
      "${command_name}" >&2
    exit 1
  fi
done

groupadd --force "${SAMBA_GROUP}"

for user in "${SAMBA_USERS[@]}"; do
  if ! id "${user}" >/dev/null 2>&1; then
    useradd --no-create-home --shell /usr/sbin/nologin --gid "${SAMBA_GROUP}" \
      --comment "Samba-only user" "${user}"
  else
    usermod --shell /usr/sbin/nologin --append --groups "${SAMBA_GROUP}" "${user}"
  fi
done

if pdbedit -L -u "${LEGACY_USER}" >/dev/null 2>&1; then
  smbpasswd -x "${LEGACY_USER}"
  printf 'Removed Samba account for %s; the Linux account was retained.\n' "${LEGACY_USER}"
fi

install -d -m 0770 -o root -g "${SAMBA_GROUP}" "${SHARE_PATH}"
testparm -s "${CONFIG_SOURCE}" >/dev/null
install -D -m 0644 "${CONFIG_SOURCE}" "${SAMBA_CONFIG}"

for user in "${SAMBA_USERS[@]}"; do
  if ! pdbedit -L -u "${user}" >/dev/null 2>&1; then
    printf 'Set the Samba password for %s.\n' "${user}"
    smbpasswd -a "${user}"
  fi
  smbpasswd -e "${user}" >/dev/null
done

systemctl enable smbd
systemctl restart smbd
printf 'Samba family share is configured at %s.\n' "${SHARE_PATH}"
