---
description: Define technical specifications and feature list for the project
argument-hint: [tech preferences or context]
allowed-tools: [Read, Glob, Grep, Bash, Write]
---

# Spec Command

The user has invoked `/spec` with the following input:

**Arguments:** $ARGUMENTS

## Instructions

1. Read `skills/spec/SKILL.md` to load the full specification process.
2. If `$ARGUMENTS` is empty and no `docs/PRD.md` exists, ask the user to describe the project or run `/init` first.
3. Otherwise, follow the process in SKILL.md exactly.
