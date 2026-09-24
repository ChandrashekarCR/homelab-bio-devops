# homelab-bio-devops

A personal, version-controlled DevOps lab for my homelab. It contains documentation, configuration, and automation for running self-hosted services reproducibly.

## Infrastructure

- Single Linux server (Ubuntu/Debian) on a local network
- Accessed via SSH
- Services run natively and/or in Docker containers
- Managed from a workstation using VS Code / Emacs with remote editing

## Purpose

- Document and automate the homelab setup
- Learn DevOps and software engineering practices in a real environment
- Provide a reproducible reference for rebuilding services
- Demonstrate "docs as code" and "infrastructure as code"

## Technologies (planned)

- Linux, SSH, systemd
- Git, GitHub
- Docker & Docker Compose
- Ansible
- Samba, Jellyfin, and other self-hosted services
- Emacs Org-mode
- AI coding assistants
- Monitoring, logging, backups, and secrets management

## Engineering principles

- Declarative and idempotent automation
- Everything in version control
- Documentation lives with code
- Secure by default
- Incremental, testable changes
- Keep it simple; tune as needed

> Status: Work in progress.