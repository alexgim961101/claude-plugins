---
name: review
description: >
  Review implemented code against the plan using 3 parallel agents — checking plan-implementation alignment,
  code quality/security, and test coverage/performance. Outputs a structured review report to terminal.
  Use this skill whenever the user says "리뷰", "검토", "코드 리뷰", "review", "code review", "검토해줘",
  "리뷰해줘", "코드 확인", "코드 봐줘", or wants to review implemented code, check quality, or verify implementation matches the plan.
  Always use this skill when the user asks to review code, even if they don't explicitly mention "review".
version: 1.1.0
---

# Review — Multi-Agent Code Review

Three independent agents review code from different perspectives in parallel.
Independence is intentional — agents don't share context, which reduces groupthink.

## When to Apply

- After implementation, when reviewing code
- Checking code quality or security
- Verifying implementation matches the plan
- User invokes `/review`

## Process

### Step 1: Identify Review Scope

**1. Determine diff range** (use the first that applies):

| Condition | Command | Rationale |
|-----------|---------|-----------|
| User specified files or commit range | Use what the user said | Explicit intent |
| On a feature branch (not main/master) | `git diff main...HEAD` | Full branch changes |
| Uncommitted changes exist | `git diff HEAD` | Working tree changes |
| None of the above | Ask the user what to review | Avoid guessing |

**2. Gather context documents** (best-effort — absence is normal):

| Document | How to find | If missing |
|----------|------------|------------|
| Implementation plan | `docs/IMPL_PLAN_*.md` matching changed modules | Use `git log --oneline` of the diff range to infer intent from commit messages |
| Technical spec | `docs/SPEC.md` | Use `CLAUDE.md` or project root config files (pyproject.toml, package.json, etc.) for conventions |

Not every project uses the smart pipeline (`/init` → `/spec` → `/plan` → `/impl`).
The review must work regardless — documents enrich the review but are not prerequisites.

**3. Collect review inputs:**

- `CHANGED_FILES`: list of modified/created files
- `DIFF_CONTENT`: output of the git diff command (this is what agents review — not the full files)
- `IMPL_PLAN`: implementation plan content, or commit messages summary if no plan exists
- `SPEC_CONTEXT`: technical spec sections, or project conventions from CLAUDE.md/config files
- `PROJECT_TYPE`: inferred project type (e.g., web API, CLI tool, batch pipeline, library) — agents use this to focus relevant checks

### Step 2: Launch Review Agents

**Environment Detection:**
- If you have access to the `Agent` tool → use **Option A** (parallel)
- If the `Agent` tool is NOT available → use **Option B** (sequential)

**Option A — Parallel (Agent tool available):**

Run all three agents **simultaneously** using the Agent tool.

**Agent A — Alignment Reviewer (계획-구현 정합성)**
Read `agents/alignment-reviewer.md`. Fill in `{{DIFF_CONTENT}}`, `{{CHANGED_FILES}}`, and `{{IMPL_PLAN}}`.

**Agent B — Quality Reviewer (코드 품질 & 보안)**
Read `agents/quality-reviewer.md`. Fill in `{{DIFF_CONTENT}}`, `{{CHANGED_FILES}}`, `{{SPEC_CONTEXT}}`, and `{{PROJECT_TYPE}}`.

**Agent C — Test Reviewer (테스트 & 성능)**
Read `agents/test-reviewer.md`. Fill in `{{DIFF_CONTENT}}`, `{{CHANGED_FILES}}`, and `{{IMPL_PLAN}}`.

**Option B — Sequential (Agent tool NOT available):**

Perform each review inline, one at a time:

1. Read `agents/alignment-reviewer.md`. Perform the Alignment Review inline. Write the result.
2. Read `agents/quality-reviewer.md`. Perform the Quality Review inline. Write the result.
3. Read `agents/test-reviewer.md`. Perform the Test Review inline. Write the result.

### Step 3: Assemble Review Report

Combine all three agent outputs into a single report.
**Output to terminal only** — do not save as a file (reviews are ephemeral, tied to specific code state).

Format:

```markdown
## 코드 리뷰 결과

> 리뷰 대상: {변경 파일 요약}
> 참조 계획: {IMPL_PLAN 파일명 또는 "commit messages 기반"}
> 리뷰 일시: {YYYY-MM-DD}

---

### 요약

- **전체 평가**: {Pass / Pass with comments / Changes requested}
- **발견된 이슈**: 치명적 {N}개, 주의 {N}개, 제안 {N}개

---

### 계획-구현 정합성

{Agent A 결과}

---

### 코드 품질 & 보안

{Agent B 결과}

---

### 테스트 & 성능

{Agent C 결과}

---

### 문서 동기화

구현 과정에서 계획과 달라진 부분이 있다면:
- 어떤 부분이 달라졌는지
- 어떤 문서(PRD, SPEC, FEATURE_PLAN, IMPL_PLAN)를 업데이트해야 하는지
없으면 "문서 업데이트 불필요"
(계획 문서가 없는 프로젝트의 경우 이 섹션 생략)

---

### 추천 액션

1. **[치명적]** {즉시 수정 — file:line 포함}
2. **[주의]** {권장 수정 — file:line 포함}
3. **[제안]** {개선 — file:line 포함}
```

Overall rating criteria:
- **Pass**: no issues
- **Pass with comments**: no critical issues, only warnings/suggestions
- **Changes requested**: 1+ critical issues

Then ask: **"리뷰 결과를 확인해 주세요. 수정이 필요한 항목이 있으면 말씀해 주세요."**

## Quality Rules

- Every issue must include specific location (file:line) and actionable suggestion
- Prioritize by severity — reviewers' time is limited
- Document sync section is mandatory when plan documents exist — catching plan drift early prevents documentation rot
- Avoid vague feedback like "improve this" — suggest specific changes like "change X to Y"
- Agents should review the **diff** to focus on what changed, reading full files only when surrounding context is needed to understand the change
