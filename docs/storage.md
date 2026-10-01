# Storage

The supported Samba storage implementation is documented in
[`services/samba/README.md`](../services/samba/README.md). It provides a
LAN-only family share for the Samba-only users `chandru`, `raju`, and `aruna`.

Storage services must have an explicit backup and restore plan before they are
treated as production services. A share configuration is not a backup.
