# Senior engineering guidelines

Use this checklist for every future change in this repository.

## Before coding

- Read the issue and define observable acceptance criteria.
- Inspect existing scripts, configuration, and documentation before adding
  another pattern.
- Identify data, network, privilege, and recovery risks.
- Decide how the change will be tested locally and on the target host.

## While coding

- Prefer the simplest declarative and idempotent implementation.
- Reuse existing helpers and naming conventions.
- Validate inputs and fail explicitly; do not silently fall back.
- Keep credentials in environment variables, prompts, or a secrets manager.
- Avoid broad permissions, public network exposure, and unnecessary privileges.
- Document why a non-obvious choice was made.

## Before opening a pull request

- Run focused tests, syntax checks, linters, and service configuration checks.
- Review the diff for accidental files, secrets, destructive commands, and
  machine-specific values.
- Update the closest documentation and include operational instructions.
- Confirm repeated execution is safe, or document the exact limitation.
- Complete every relevant section of the pull request template.

## Review questions

1. Does this solve the issue rather than only changing symptoms?
2. What happens on a second run, partial failure, or rollback?
3. Who can access the resulting service or data?
4. How would we detect and recover from a failure?
5. Is the test evidence sufficient for the risk of the change?

## Delivery process

Issue -> branch -> implementation -> tests -> commit -> push -> pull request
-> CI -> review -> merge. Keep commits small and use imperative commit
messages such as `feat: add Samba family share automation`.
