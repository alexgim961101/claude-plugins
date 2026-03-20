---
name: review
description: >
  Review implemented code against the plan using 3 parallel agents — checking plan-implementation alignment,
  code quality/security, and test coverage/performance. Outputs a structured review report to terminal.
  Use this skill whenever the user says "리뷰", "검토", "코드 리뷰", "review", "code review", "검토해줘",
  "리뷰해줘", "코드 확인", "코드 봐줘", or wants to review implemented code, check quality, or verify implementation matches the plan.
  Always use this skill when the user asks to review code, even if they don't explicitly mention "review".
version: 1.0.0
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

1. Run `git diff` to find changes (vs main branch or last reviewed commit)
2. If no git changes, ask the user what to review
3. Read corresponding `docs/IMPL_PLAN_*.md` for intended design
4. Read `docs/SPEC.md` for technical conventions

Collect:
- `CHANGED_FILES`: list of modified/created files
- `CODE_CONTENT`: actual code being reviewed
- `IMPL_PLAN`: relevant implementation plan content
- `SPEC_CONTEXT`: relevant technical spec sections

### Step 2: Launch 3 Review Agents (Parallel)

Run all three agents **simultaneously** using the Agent tool.

**Agent A — Alignment Reviewer (계획-구현 정합성)**
Read `agents/alignment-reviewer.md`. Fill in `{{CODE_CONTENT}}` and `{{IMPL_PLAN}}`.

**Agent B — Quality Reviewer (코드 품질 & 보안)**
Read `agents/quality-reviewer.md`. Fill in `{{CODE_CONTENT}}` and `{{SPEC_CONTEXT}}`.

**Agent C — Test Reviewer (테스트 & 성능)**
Read `agents/test-reviewer.md`. Fill in `{{CODE_CONTENT}}` and `{{IMPL_PLAN}}`.

### Step 3: Assemble Review Report

Combine all three agent outputs into a single report.
**Output to terminal only** — do not save as a file (reviews are ephemeral, tied to specific code state).

Format:

```markdown
## 코드 리뷰 결과

> 리뷰 대상: {변경 파일 요약}
> 참조 계획: {IMPL_PLAN 파일명}
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
- Document sync section is mandatory — catching plan drift early prevents documentation rot
- Avoid vague feedback like "improve this" — suggest specific changes like "change X to Y"
