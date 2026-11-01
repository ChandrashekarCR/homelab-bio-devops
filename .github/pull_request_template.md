<!-- PR title = the squash-commit subject: "type(scope): summary", e.g. "fix(lab): make teardown fail loudly" -->

## What and why

<!-- One or two sentences. What problem does this solve? -->

Closes #

## Changes

-

## How I tested it

<!-- Copy the issue's acceptance criteria here and tick them with evidence. -->

- [ ] Built and tested in the lab first (box / netlab / scratch dir: ______), or: not needed because ______
- [ ] `scripts/check.sh` and `bats tests/` pass locally
- [ ] Verified on prod (if applicable)

```text
# Paste the commands you ran and the relevant output.
```

## Rollback

<!-- Exact commands to undo this on the server. "Revert the PR" alone is not enough if state changed. -->

```bash

```

## Risk

- [ ] Low: docs, lab-only, or easily reverted
- [ ] Medium: touches a family service; done outside quiet hours (18–22)
- [ ] High: DNS, network, firewall, SSH or data; announced to the family (template D.8)

## Self-review checklist

- [ ] I read every line of the diff on the **Files changed** tab, as a stranger would
- [ ] No secrets, keys, tokens, public IP or DuckDNS name in the diff
- [ ] Permissions and access boundaries reviewed (least privilege)
- [ ] Backup, rollback and recovery impact considered
- [ ] Safe to apply twice (idempotent), or the limitation is documented
- [ ] Docs updated (README / service card / runbook / docs/*.md)
- [ ] `PROGRESS.md` ticked if this completes a quest
