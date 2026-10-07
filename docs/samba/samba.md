# Samba File Sharing

## Users
- chandru, raju, aruna: private shares, read-write for themselves only.
- amrita: home-admin account, read-write across all three.

## Permission model
Each primary user owns a private directory (`chmod 2770`) under their
own private group. Amrita is added as a supplementary member of each
of those groups rather than using ACLs, since her access is "all of
them," not a sparse subset — plain group membership is the simpler,
correct tool here.

The `family` group is organizational only (reserved for a future
shared folder) and is not used for access control.

## Provisioning
    sudo scripts/samba/setup-family-shares.sh
Safe to re-run. Does not set Samba passwords — run `smbpasswd -a <user>`
manually, once, per user.

## Verifying
    scripts/samba/test-shares.sh <test-password>
Exits non-zero if any access check fails.