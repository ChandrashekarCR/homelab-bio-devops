# Contributing

This repository documents and automates a personal homelab. Prefer small,
reviewable changes that are safe to repeat and easy to recover.

## Standard workflow

1. Start with an issue containing the problem, scope, acceptance criteria, and
   security or operational risks.
2. Create a branch from `master` using
   `<issue-number>-<type>-<short-description>`, such as
   `10-feat-samba-family-share`.
3. Implement the smallest complete change. Keep secrets and host-specific
   credentials out of the repository.
4. Add or update documentation and automated validation.
5. Run the local checks and record their results in the pull request.
6. Commit using `<type>: <imperative description>`.
7. Push the branch and open a pull request using the repository template.
8. Link the issue, wait for CI, respond to review, and merge only when CI is
   green and the change is understood.

## What good automation looks like

- **Declarative:** describe the desired end state rather than a one-time
  sequence.
- **Idempotent:** a second run should converge without duplicating accounts,
  data, or configuration.
- **Secure by default:** least privilege, explicit network boundaries, no
  plaintext secrets, and safe failure behavior.
- **Observable:** validate inputs and configuration, report errors, and make
  important changes visible in logs or command output.
- **Recoverable:** document backups, rollback, and the effect of destructive
  operations.

## Testing expectations

Documentation-only changes need a content review. Shell scripts need syntax
validation, ShellCheck, and focused behavior tests. Service changes also need
configuration validation and a documented manual smoke test on a disposable or
well-understood host. Do not claim a production deployment was tested when
only static checks were run.

## Commits and pull requests

Use one of these commit types: `feat`, `fix`, `docs`, `chore`, `refactor`, or
`test`. Keep each commit focused. A pull request should explain the problem,
the design, validation performed, operational impact, and any follow-up work.
