---
description: Critically plan a feature with multi-agent risk analysis, architecture review, and implementation unit breakdown
argument-hint: [feature description]
allowed-tools: [Read, Glob, Grep, Bash, Agent, Write]
---

# Smart Plan Command

The user has invoked `/plan` with the following input:

**Arguments:** $ARGUMENTS

## Instructions

1. Read `skills/plan/SKILL.md` to load the full planning process.
2. If `$ARGUMENTS` is empty, ask the user to describe the feature before proceeding.
3. Otherwise, treat `$ARGUMENTS` as the initial feature description and follow the process in SKILL.md exactly.
