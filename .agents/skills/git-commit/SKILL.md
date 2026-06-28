---
name: git-commit
description: Generate a git commit message from the current changes and write it to a COMMIT.md file so the user can commit with `git commit -F COMMIT.md`. Use this whenever the user asks to commit, write a commit message, describe their changes for a commit, or says things like "commit this", "write the commit message", or "summarize my changes for git". Trigger even when the user doesn't say "commit message" explicitly but clearly wants their diff turned into a commit.
---

# Git Commit

Turn the current code changes into a commit message that follows standard Git conventions, and write it to a file named `COMMIT.md` in the repository root. The user will commit with:

```
git commit -F COMMIT.md
```

## Workflow

1. Inspect what is actually changing. Prefer staged changes:
   - `git diff --staged` for staged content; fall back to `git diff` if nothing is staged.
   - `git status` to see which files are touched.
2. Read the diff to understand *intent*, not just which lines moved. Group related edits into logical changes — one bullet per idea, not per file.
3. Write the message to `COMMIT.md` in the format below.
4. Tell the user it's ready and remind them they can run `git commit -F COMMIT.md`. Don't run `git commit` yourself unless the user explicitly asks.

## Format

Write a **title** followed by a **compact list of changes**:

```
<title>

- <change 1>
- <change 2>
- <change 3>
```

### Title

Follow standard commit-message practice:

- One line, imperative mood ("Add", "Fix", "Refactor" — not "Added"/"Adds").
- Aim for ~50 characters, hard limit 72. No trailing period.
- Summarize the single most important thing the change accomplishes.

### List of changes — keep it compact

The body is a bullet list, and being compact is the point: each bullet is a short, scannable phrase, not a sentence with explanation. The reader should grasp each change at a glance.

- One bullet per logical change. Merge trivial edits (formatting, imports) into a single bullet or omit them.
- Start each bullet with a verb.
- No filler ("this commit", "we now", "added a change that"). State the change directly.
- Wrap body lines at ~72 characters.
- For a genuinely single-purpose change, a good title alone is enough — omit the body.

## Examples

**Example 1** — feature touching several files:
```
Add JWT-based authentication

- Add login and refresh endpoints to the auth router
- Store hashed refresh tokens in the users table
- Apply auth middleware to protected routes
```

**Example 2** — small focused change, no body needed:
```
Fix off-by-one error in pagination offset
```

**Example 3** — mixed cleanup, trivial edits merged:
```
Refactor notification delivery service

- Extract retry logic into a RetryPolicy class
- Replace the blocking HTTP client with an async client
- Tidy imports and formatting
```

## Notes

- Describe what changed and why it matters, never how many lines or how long it took.
- Don't invent intent the diff doesn't support. If the purpose is unclear, ask rather than guessing.
- Overwrite `COMMIT.md` if it already exists.
