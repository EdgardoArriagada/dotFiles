---
name: changelog
description: Use when the user wants to review recent repository changes, catch up on what teammates committed, or understand what happened in a codebase over a time period. Triggers on "what changed", "catch me up", "recent changes", "changelog", "what did the team do".
---

# Changelog

Generate a contextual briefing of recent repository changes. The audience is a technical person with **zero prior knowledge** of these changes — they should be able to answer questions about any change after reading the report.

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

### 2. Gather raw data

Run these git commands with `--all` to cover all branches:

```bash
# Commits in range
git log --all --since="<range>" --format="%H|%an|%ad|%s" --date=short

# PRs (merge commits + squash-merged)
git log --all --since="<range>" --merges --format="%H|%s"
git log --all --since="<range>" --format="%H|%s" --grep="(#[0-9]*)"
```

### 3. Group into logical changes

Do NOT present a flat list of commits. Group commits into **logical changes** — typically one per PR or one per coherent feature/fix if there's no PR. Multiple commits touching the same concern are ONE logical change.

### 4. Build context for each logical change

For each logical change, read the actual code to understand it:

```bash
# Read the diff to understand WHAT changed
git show <commit_hash> --stat
git show <commit_hash> -- <key_files>   # read relevant hunks

# For merge/squash commits with PR number, try fetching the PR body
gh pr view <number> --json title,body,author,labels 2>/dev/null
```

**You MUST read the actual diffs and/or changed files.** Commit messages alone are not enough — they're often vague or incomplete. Your job is to understand the change and explain it clearly.

### 5. Write the report

#### Structure

**a) Executive summary (2-3 sentences)**
What was the overall focus this period? Any themes or patterns?

**b) For each logical change, a section with:**

> **<Title — what it does in plain language>**
> *<Author> · <Date> · <PR link if available>*
>
> **What changed:** 1-3 sentences explaining concretely what was added, modified, or removed. Mention specific components, endpoints, behaviors — not file names.
>
> **Why it matters:** 1-2 sentences on the motivation or impact. Why was this done? What problem does it solve? What does it enable? If you can't tell from the diff/PR, say "Motivation unclear from commit history" — don't fabricate.
>
> **Key details:** Bullet list of important specifics someone might be asked about (new dependencies, config changes, API changes, behavior changes, breaking changes). Omit this section if there are no notable details.

**c) If applicable: heads-up section**
Breaking changes, new dependencies, config changes, or anything that might affect other team members.

#### Ordering

Order changes by importance/impact, not chronologically. The most significant change goes first.

## Tone and style

- Write for a technical reader who has NO context about these changes
- Be specific: "Added rate limiting to the /search endpoint (max 100 req/s per user)" not "Updated search functionality"
- Explain WHY, not just WHAT — "to prevent abuse from automated scrapers" not just "added rate limiting"
- Use domain language, not git language — say "Added a health check endpoint" not "Added new file ping.go"
- Never list file paths as the primary description of a change. Mention files only in "Key details" when someone might need to find the code
- Skip trivial changes (typo fixes, formatting) unless they're the only changes in the period
- Keep the total report concise — aim for a report that takes 2-3 minutes to read
