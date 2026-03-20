---
description: Implement a feature unit with TDD and Korean pseudocode comments for easy review
argument-hint: [feature unit ID or name]
allowed-tools: [Read, Glob, Grep, Bash, Agent, Write, Edit]
---

# Impl Command

The user has invoked `/impl` with the following input:

**Arguments:** $ARGUMENTS

## Instructions

1. Read `skills/impl/SKILL.md` to load the full implementation process.
2. If `$ARGUMENTS` is empty, read `docs/FEATURE_PLAN.md` and suggest the next unit to implement based on dependency ordering.
3. Otherwise, treat `$ARGUMENTS` as the target feature unit and follow the process in SKILL.md exactly.
