---
name: changelog
description: Use when the user wants to review recent repository changes, catch up on what teammates committed, or understand what happened in a codebase over a time period. Triggers on "what changed", "catch me up", "recent changes", "changelog", "what did the team do".
---

# Changelog

Summarize recent repository changes grouped by author and theme, with PR context.

## Usage

- `/changelog` — last 7 days (default)
- `/changelog 14d` — last 14 days
- `/changelog 2026-04-01 2026-04-10` — custom date range

## Workflow

### 1. Parse date range

| Input | Interpretation |
|-------|---------------|
| No args | `--since="7 days ago"` |
| `Nd` (e.g. `14d`) | `--since="N days ago"` |
| Single date | `--since="<date>"` |
| Two dates | `--since="<start>" --until="<end>"` |

### 2. Gather data

Run these git commands (use relative paths, never absolute). Always use `--all` to include all branches:

```bash
# All commits in range across all branches
git log --all --since="<range>" --format="%H|%an|%ad|%s" --date=short

# Diffstat summary
git log --all --since="<range>" --shortstat --format=""

# PRs: merge commits + squash-merged PRs (parse "#N" from subjects)
git log --all --since="<range>" --merges --format="%s"
git log --all --since="<range>" --format="%s" --grep="(#[0-9]*)"

# New files added
git log --all --since="<range>" --diff-filter=A --name-only --format=""

# Deleted files
git log --all --since="<range>" --diff-filter=D --name-only --format=""
```

**Note:** Many GitHub repos use squash-merge, so `--merges` alone misses PRs. The `--grep` command catches commit subjects containing `(#123)` patterns.

### 3. Present the summary

Structure the output in this order:

**a) Overview line**
> X commits by Y authors over Z days (N files changed, +A/-D lines)

**b) By Author** — for each contributor:
- Name and commit count
- Bullet list of their key changes (group related commits, don't list every commit individually)

**c) PRs Merged** — list merged PRs with title and author (extracted from merge commit messages)

**d) Notable Changes**
- New files added (list paths)
- Files deleted (list paths)
- Files renamed (if any)
- Large diffs (files with >100 lines changed)

**e) Hotspots** — top 5 most-modified files with change count

## Formatting Rules

- Use **relative paths** only (never absolute)
- Group related commits — don't list 6 commits that all update the same file separately
- Keep it scannable — use tables and bullets, not paragraphs
- Include commit hashes (short form, 7 chars) for traceability
- If the range has >50 commits, summarize themes at the top before the detailed breakdown
