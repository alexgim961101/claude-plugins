---
description: Review implemented code against the plan with 3 parallel analysis agents
argument-hint: [file paths or feature name to review]
allowed-tools: [Read, Glob, Grep, Bash, Agent]
---

# Review Command

The user has invoked `/review` with the following input:

**Arguments:** $ARGUMENTS

## Instructions

1. Read `skills/review/SKILL.md` to load the full review process.
2. If `$ARGUMENTS` is empty, use `git diff` to identify recently changed files as the review scope.
3. Otherwise, treat `$ARGUMENTS` as the scope of the review and follow the process in SKILL.md exactly.
