#!/usr/bin/env bash
set -euo pipefail

SMB_CONF="/etc/samba/smb.conf"
SHARE_ROOT="/media/myfiles"
PRIMARY_USERS=("chandru" "raju" "aruna")
ADMIN_USER="amrita"
FAIL=0

if [[ $EUID -ne 0 ]]; then
    echo "Error: This test must run as root (sudo $0)" >&2
    exit 1
fi

echo "=== STARTING SAMBA SETUP LOGICAL VERIFICATION ==="

# 1. Test Global Samba Syntax First
if testparm -s "$SMB_CONF" &>/dev/null; then
    echo "✓ PASS: smb.conf syntax is valid."
else
    echo "✗ FAIL: smb.conf has syntax errors."
    FAIL=1
fi

# 2. Test Admin Config and Access to All Files
if grep -q "^\[all_files\]" "$SMB_CONF"; then
    echo "✓ PASS: Share [all_files] exists for admin."
    # Extract valid users for all_files block
    ADMIN_SHARE_USERS=$(sed -n '/^\[all_files\]/,/^\[/p' "$SMB_CONF" | grep -i "valid users" || true)
    if echo "$ADMIN_SHARE_USERS" | grep -qw "$ADMIN_USER"; then
        echo "✓ PASS: [all_files] correctly restricts access to $ADMIN_USER."
    else
        echo "✗ FAIL: [all_files] configuration is missing $ADMIN_USER in valid users."
        FAIL=1
    fi
else
    echo "✗ FAIL: Share [all_files] is missing from smb.conf."
    FAIL=1
fi

# 3. Test Each Primary User Loop Logic
for user in "${PRIMARY_USERS[@]}"; do
    echo "--- Testing Logic for User: $user ---"

    # Check Linux User Account
    if id "$user" &>/dev/null; then
        echo "  ✓ PASS: Linux system profile for '$user' exists."
        
        # Verify user shell is locked
        USER_SHELL=$(getent passwd "$user" | cut -d: -f7)
        if [[ "$USER_SHELL" == "/usr/sbin/nologin" ]]; then
            echo "  ✓ PASS: '$user' shell is safely set to nologin."
        else
            echo "  ✗ FAIL: '$user' has a dangerous active shell ($USER_SHELL)."
            FAIL=1
        fi
    else
        echo "  ✗ FAIL: Linux user '$user' does not exist."
        FAIL=1
        continue
    fi

    # Check Directory & Group Permissions (2770 Verification)
    DIR="$SHARE_ROOT/$user"
    if [[ -d "$DIR" ]]; then
        echo "  ✓ PASS: Directory $DIR exists."
        
        # Check ownership
        OWNER=$(stat -c '%U:%G' "$DIR")
        if [[ "$OWNER" == "$user:$user" ]]; then
            echo "  ✓ PASS: $DIR is correctly owned by $user:$user."
        else
            echo "  ✗ FAIL: $DIR ownership is wrong (expected $user:$user, got $OWNER)."
            FAIL=1
        fi

        # Check exact Octal Permissions (should be 2770)
        PERM=$(stat -c '%a' "$DIR")
        if [[ "$PERM" == "2770" ]]; then
            echo "  ✓ PASS: $DIR has the correct 2770 (SetGID) permissions."
        else
            echo "  ✗ FAIL: $DIR permissions are broken (expected 2770, got $PERM)."
            FAIL=1
        fi
    else
        echo "  ✗ FAIL: Directory $DIR does not exist."
        FAIL=1
    fi

    # Check if Admin is in the user's private group
    if id -nG "$ADMIN_USER" | grep -qw "$user"; then
        echo "  ✓ PASS: $ADMIN_USER is a member of the '$user' group."
    else
        echo "  ✗ FAIL: $ADMIN_USER lacks group membership to access '$user' files."
        FAIL=1
    fi

    # Parse smb.conf block for the user
    if grep -q "^\[$user\]" "$SMB_CONF"; then
        echo "  ✓ PASS: Share block [$user] exists in smb.conf."
        
        # Isolate the share block text to check valid users line
        SHARE_BLOCK=$(sed -n "/^\[$user\]/,/^\[/p" "$SMB_CONF" | grep -i "valid users" || true)
        if echo "$SHARE_BLOCK" | grep -qw "$user" && echo "$SHARE_BLOCK" | grep -qw "$ADMIN_USER"; then
            echo "  ✓ PASS: Samba configuration allows '$user' and '$ADMIN_USER'."
        else
            echo "  ✗ FAIL: Samba configuration users mismatch (got: $SHARE_BLOCK)."
            FAIL=1
        fi
    else
        echo "  ✗ FAIL: Share block [$user] missing from smb.conf."
        FAIL=1
    fi
done

echo "=================================================="
if [[ $FAIL -eq 0 ]]; then
    echo "SUCCESS: All logical configuration checks passed perfectly."
else
    echo "ERROR: One or more configuration blocks have logical flaws."
fi

exit $FAIL
