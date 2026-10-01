# Homelab Bio-DevOps: Engineering Guidelines

## Project Purpose
This is a personal, version-controlled DevOps lab for a homelab. It contains documentation, configuration, and automation for running self-hosted services reproducibly.

## Core Engineering Principles
- **Declarative and Idempotent:** All automation (Ansible, Docker) must be declarative and safe to run multiple times.
- **Everything in Version Control:** All configuration, scripts, and documentation live in this repo.
- **Documentation Lives with Code:** Docs are as important as code. They are part of the same PR.
- **Secure by Default:** Never commit secrets. Use environment variables or a secrets manager.
- **Incremental, Testable Changes:** Break down features into small, verifiable steps.
- **Keep It Simple:** Choose the simplest solution that works.

## Commit Convention
All commits must follow this format:
`<type>: <description>`
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only
- `chore`: Maintenance tasks
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `test`: Adding or correcting tests

Example: `docs: add contribution guide to repo`

## Branch Naming
Branches should be named based on the issue and type of work:
`<issue-number>-<type>-<short-description>`
Example: `5-docs-contribution-guide`

## Development Workflow
The standard workflow for every change is:
1.  **Issue:** Every change starts with an issue in the tracker.
2.  **Branch:** Create a new branch from `main` using the naming convention above.
3.  **Development:** Make your changes in small, logical commits.
4.  **Local Testing:** Ensure your changes work as expected locally.
5.  **Commit:** Use the commit convention.
6.  **Push:** Push your branch to GitHub.
7.  **Pull Request:** Open a PR, fill out the template, and reference the issue.
8.  **CI:** Wait for all automated checks to pass.
9.  **Review:** A maintainer will review your PR.
10. **Merge:** Once approved and CI is green, the PR is merged.