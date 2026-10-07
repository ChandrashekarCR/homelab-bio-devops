#!/usr/bin/env bash

set -euo pipefail

SMB_CONF="/etc/samba/smb.conf"
SHARE_ROOT="/media/myfiles"
FAMILY_GROUP="family"
PRIMARY_USERS=("chandru" "raju" "aruna")
ADMIN_USER="amrita"

if [[ $EUID -ne 0 ]]; then
    echo "Run as root (sudo $0)" >&2
    exit 1
fi

# Family group organization only, not used for file access
if ! getent group "$FAMILY_GROUP" >/dev/null; then
  groupadd "$FAMILY_GROUP"
  echo "Created group: $FAMILY_GROUP"
fi

# Admin user (amrita) — Standard shell, gets a home directory
if ! id "$ADMIN_USER" &>/dev/null; then
  useradd -m -s /bin/bash -G "$FAMILY_GROUP" "$ADMIN_USER"
  echo "Created admin user: $ADMIN_USER"
fi

for user in "${PRIMARY_USERS[@]}"; do
    # SAMBA-ONLY USER CREATION: No home dir (-M), locked shell, system-like setup
    if ! id "$user" &>/dev/null; then
      useradd -M -s /usr/sbin/nologin -G "$FAMILY_GROUP" "$user"
      usermod -L "$user"  # Explicitly lock the Linux password database entry
      echo "Created Samba-only user: $user"
    fi

    # Ensure the user folder actually exists
    mkdir -p "$SHARE_ROOT/$user"

   # Grant amrita access via membership in this user's private group
    if ! id -nG "$ADMIN_USER" | grep -qw "$user"; then
      usermod -aG "$user" "$ADMIN_USER"
      echo "Added $ADMIN_USER to group: $user"
    fi

    # Fix ownership and enforce 2770 group permissions recursively
    chown -R "$user:$user" "$SHARE_ROOT/$user"
    find "$SHARE_ROOT/$user" -type d -exec chmod 2770 {} +
    find "$SHARE_ROOT/$user" -type f -exec chmod 0660 {} +

# Append the user's personal share block
    if ! grep -q "^\[$user\]" "$SMB_CONF"; then
      cat >> "$SMB_CONF" <<EOF

[$user]
   path = $SHARE_ROOT/$user
   valid users = $user, $ADMIN_USER
   read only = no
   browsable = yes
   create mask = 0770
   directory mask = 0770
EOF
      echo "Added smb.conf share: [$user]"
    fi
done

# 4. ADMIN ROOT SHARE: Allow amrita to view and manage everything from one share
if ! grep -q "^\[all_files\]" "$SMB_CONF"; then
  cat >> "$SMB_CONF" <<EOF

[all_files]
   path = $SHARE_ROOT
   valid users = $ADMIN_USER
   read only = no
   browsable = yes
   create mask = 0770
   directory mask = 2770
EOF
  echo "Added admin root smb.conf share: [all_files]"
fi

# Validate configuration
testparm -s "$SMB_CONF" >/dev/null
echo "smb.conf syntax OK"

systemctl restart smbd nmbd
systemctl enable smbd nmbd --quiet

cat <<EOF

Done. Samba passwords are NOT set by this script. Set them
manually, once, per user:

  sudo smbpasswd -a chandru
  sudo smbpasswd -a raju
  sudo smbpasswd -a aruna
  sudo smbpasswd -a amrita
EOF