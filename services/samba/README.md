# Samba family share

This directory contains the configuration for one standalone Samba share named
`family`. The share is deliberately limited to three Samba-only users:

- `chandru`
- `raju`
- `aruna`

All three users belong to the Linux group `family`. The Linux user `amrita` is
not a Samba service user. The setup script removes an existing Samba passdb
entry for `amrita` but does not delete or modify the Linux account.

## Security model

- Samba uses local users and its local passdb; no passwords are stored in Git.
- The `family` share is read/write for members of `family`.
- Files are created with group read/write permissions (`0660`); directories use
  group read/write/execute permissions (`0770`).
- SMB1 is disabled by requiring SMB2 or newer.
- The Samba host must be restricted to the trusted LAN with the host firewall.
  Do not expose TCP ports 139 or 445 to the public internet.

## Installation on the Samba host

Copy this repository to the host, then run:

```bash
sudo ./scripts/setup-samba.sh
```

The script is idempotent. It will:

1. Install no packages automatically; install `samba` and `smbclient` first if
   they are missing.
2. Create the `family` group and the three Linux accounts without home
   directories and with `/usr/sbin/nologin`.
3. Remove `amrita` from Samba's passdb if an entry exists.
4. Create or enable each Samba account and prompt for each password without
   writing it to disk.
5. Install the configuration, validate it with `testparm`, create the share
   directory, and restart/enable `smbd`.

The script does not remove unrelated Samba users. Review existing users with:

```bash
sudo pdbedit -L
```

The share directory defaults to `/srv/samba/family`. Override it for a
different disk or mount point:

```bash
sudo SAMBA_SHARE_PATH=/mnt/storage/family ./scripts/setup-samba.sh
```

The parent filesystem must already be mounted before running the script.

## Client access

From a trusted Linux client:

```bash
smbclient //SERVER_NAME/family -U chandru
```

For Windows, use `\\SERVER_NAME\family` and authenticate as one of the three
Samba users.

## Verification and operations

Validate configuration without restarting:

```bash
sudo testparm -s /etc/samba/smb.conf
```

Check service state and recent logs:

```bash
systemctl status smbd
journalctl -u smbd --since today
```

Verify that `amrita` remains a Linux user but is not a Samba user:

```bash
id amrita
sudo pdbedit -L | grep -E '^amrita:'
```

The second command should return no output. Back up the data and test restore
before treating the share as production storage; Samba does not provide
backups.
