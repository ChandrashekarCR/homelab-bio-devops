# 0001. Keep the learning handbook out of the public repo

- Status: Accepted
- Date: YYYY-MM-DD

## Context
The handbook in docs/book/ is a generated study guide. The repo is my
public portfolio and should show my own work.

## Decision
docs/book/ stays in .gitignore. The README links to my TILs, lab notes
and PROGRESS.md instead.

## Consequences
+ The portfolio shows only work I produced and understand.
- The handbook isn't backed up by GitHub. I'll include it in my restic
  backup (Day 9).