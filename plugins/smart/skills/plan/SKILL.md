---
name: plan
description: >
  Plan a feature with multi-agent risk analysis, architecture review, and implementation plans.
  Generates docs/FEATURE_PLAN.md (feature decomposition into big/small logical units) and
  docs/IMPL_PLAN_*.md (Korean pseudocode implementation plans per small unit — no real code).
  Use this skill whenever the user says "기획", "계획 세워줘", "어떻게 구현할까", "설계해줘", "플랜 짜줘",
  "기능 분해", "구현 계획", "feature plan", "let's plan", "before we implement", or describes a feature and asks how to approach it.
  Always use this skill proactively when a non-trivial feature discussion begins, even without explicit request.
version: 2.1.0
---

# Plan — Feature Planning & Implementation Plans

Decompose a feature into logical units and generate implementation plans for each unit.

This skill's outputs feed directly into `/impl`, where pseudocode becomes inline code comments.
The clearer the pseudocode, the easier the final code review.
Pseudocode expresses **intent (WHAT)**, code expresses **mechanism (HOW)** — reviewers check alignment between the two.

## Critical: This Skill Produces Documents, Not Code

This skill's sole purpose is to produce **plan documents** (`docs/FEATURE_PLAN.md`, `docs/IMPL_PLAN_*.md`).
The deliverable is markdown files on disk — not a conversational summary, not a mental plan, not inline analysis.

If you find yourself analyzing code and forming a plan without writing documents, you are not following this skill.
Stop and write the documents.

### Plan Mode Awareness

When this skill runs inside Claude Code's Plan Mode, the environment tends to ask "shall I implement this?" after planning completes.
This is misleading — the plan phase is NOT complete until documents are written to disk.

**At the end of planning, always ask:**
> "계획 문서를 작성하겠습니다. 진행할까요?"

Do NOT ask "이대로 구현할까요?" or "코드를 작성할까요?" — those questions skip the document creation step.
Implementation happens later via `/impl`, only after plan documents exist and the user has reviewed them.

## When to Apply

- Designing or planning a feature
- Reviewing approach before implementation
- User invokes `/plan`

## Process (Two Phases)

### Phase 1: Generate FEATURE_PLAN.md

#### Step 1: Clarify Requirements

If the description is vague, ask **up to 3** targeted questions. Wait for response.

#### Step 2: Scan Codebase

Check in order:
1. `CLAUDE.md` — project conventions
2. `docs/PRD.md`, `docs/SPEC.md`, `docs/FEATURE_LIST.md` — prior documents
3. Top-level project structure (ls only)
4. Key config files (`package.json`, `build.gradle`, `go.mod`, etc.)
5. Up to 5 relevant source files (Glob with keywords)

Summarize as `CODEBASE_CONTEXT`.

#### Step 3: Launch Analysis Agents

**Environment Detection:**
- If you have access to the `Agent` tool → use **Option A** (parallel)
- If the `Agent` tool is NOT available → use **Option B** (sequential)

**Option A — Parallel (Agent tool available):**

Run two agents **simultaneously** using the Agent tool.

**Agent A — Risk Analyst**
Read `~/.claude/plugins/marketplaces/alexgim961101-claude-plugins/plugins/smart/skills/plan/agents/risk-analyst.md`. Fill in `{{FEATURE_DESCRIPTION}}` and `{{CODEBASE_CONTEXT}}`.

**Agent B — Architecture Reviewer**
Read `~/.claude/plugins/marketplaces/alexgim961101-claude-plugins/plugins/smart/skills/plan/agents/arch-reviewer.md`. Fill in `{{FEATURE_DESCRIPTION}}` and `{{CODEBASE_CONTEXT}}`.

**Option B — Sequential (Agent tool NOT available):**

Perform each analysis inline, one at a time:

1. Read `~/.claude/plugins/marketplaces/alexgim961101-claude-plugins/plugins/smart/skills/plan/agents/risk-analyst.md`. Perform the Risk Analysis inline, filling in `{{FEATURE_DESCRIPTION}}` and `{{CODEBASE_CONTEXT}}` with the values collected above. Write the result.
2. Read `~/.claude/plugins/marketplaces/alexgim961101-claude-plugins/plugins/smart/skills/plan/agents/arch-reviewer.md`. Perform the Architecture Review inline, filling in `{{FEATURE_DESCRIPTION}}` and `{{CODEBASE_CONTEXT}}` with the values collected above. Write the result.

---

Extract `RECOMMENDED_APPROACH` from the Architecture Reviewer's `### 추천:` block.
If no clear recommendation, use fallback: `"추천 접근법 미확정 — 별도 아키텍처 결정 필요"`

#### Step 4: Generate FEATURE_PLAN.md

Write `docs/FEATURE_PLAN.md` with this structure:

```markdown
# {기능명} — Feature Plan

> 생성일: {YYYY-MM-DD}
> 상태: 초안 (검토 필요)

---

## 목표

한 문장으로 이 기능의 목적을 정의한다.

---

## 배경 & 컨텍스트

코드베이스 컨텍스트 요약 (기존 관련 모듈, 기술 스택 등)

---

## 범위

**In Scope**
- ...

**Out of Scope**
- ...

---

{Agent A 리스크 분석 결과 — 그대로 삽입}

---

{Agent B 대안 검토 결과 — 그대로 삽입}

---

## 기능 분해

### 큰 기능 1: {이름}
> {한 줄 설명}

- **1-1. {작은 기능명}**: {설명}
- **1-2. {작은 기능명}**: {설명}
- **1-3. {작은 기능명}**: {설명}

### 큰 기능 2: {이름}
> {한 줄 설명}

- **2-1. {작은 기능명}**: {설명}
- **2-2. {작은 기능명}**: {설명}

---

## 구현 순서

의존 관계를 고려한 순서를 명시한다.
예: 1-1 → 1-2 → 2-1 → 1-3 → 2-2

---

## 미결 사항 (Open Questions)

- ...
```

Feature decomposition rules:
- **Big features**: logical groups by domain/concern
- **Small features**: independently implementable, **reviewable in one sitting** (1-2 day scope)
- **No code** — descriptions only
- Each small feature maps 1:1 to one IMPL_PLAN document

After saving, output:
- Save path
- Count of big features and small features
- Top 2-3 risks
- Recommended approach (one line)

Then ask: **"기능 분해를 검토해 주세요. 수정할 부분이 있으면 말씀해 주세요. 확정되면 각 기능 단위별 구현 계획(IMPL_PLAN) 문서를 생성합니다."**

**Do not proceed to Phase 2 until user confirms.**

> **Plan Mode 주의:** 이 시점에서 Plan Mode를 종료(ExitPlanMode)하더라도, 코드 구현이 아닌 IMPL_PLAN 문서 작성이 다음 단계이다. "코드를 작성하겠습니다"가 아니라 "구현 계획 문서를 생성하겠습니다"로 안내한다.

---

### Phase 2: Generate IMPL_PLAN Documents (After User Confirmation)

Once the user confirms the decomposition, generate one IMPL_PLAN per small feature unit.

#### Step 5: IMPL_PLAN Generation

**Environment Detection:**
- If you have access to the `Agent` tool → use **Option A** (parallel)
- If the `Agent` tool is NOT available → use **Option B** (sequential)

Context passed to each agent/analysis:
- `CODEBASE_CONTEXT` (shared — all agents receive the same)
- `FEATURE_PLAN` content (shared — for understanding relationships between units)
- `RECOMMENDED_APPROACH` (shared)
- Specific small feature unit description (individual)

**Option A — Parallel (Agent tool available):**

Spawn one Agent per small feature unit using the Agent tool.
Independent units run **in parallel**.
Agent instructions: read `~/.claude/plugins/marketplaces/alexgim961101-claude-plugins/plugins/smart/skills/plan/agents/impl-planner.md`.

**Option B — Sequential (Agent tool NOT available):**

For each small feature unit, one at a time:
1. Read `~/.claude/plugins/marketplaces/alexgim961101-claude-plugins/plugins/smart/skills/plan/agents/impl-planner.md`.
2. Perform the IMPL_PLAN generation inline with the context above.
3. Save the result before proceeding to the next unit.

Each agent generates: `docs/IMPL_PLAN_{feature-id}.md`

Examples:
- `docs/IMPL_PLAN_1-1.md`
- `docs/IMPL_PLAN_1-2.md`
- `docs/IMPL_PLAN_2-1.md`

#### Step 6: Consistency Check

After all agents complete, the parent verifies:
- No overlapping responsibilities between units
- Dependency ordering matches FEATURE_PLAN
- Naming conventions are consistent

Fix any issues found.

#### Step 7: Request Review

Output:
- List of generated IMPL_PLAN files
- One-line summary for each

Then ask: **"구현 계획 문서가 생성되었습니다. 각 IMPL_PLAN 문서를 검토해 주세요. 확정되면 `/impl`로 구현을 시작할 수 있습니다."**

> 이 시점이 `/plan` 스킬의 완료 지점이다. 사용자가 명시적으로 `/impl`을 호출하기 전까지 코드를 작성하지 않는다.

## Quality Rules

- Be critical — challenge the user's initial assumptions
- Each small feature unit must be **independently reviewable** in one sitting
- **IMPL_PLAN 문서에 코드 블록(```) 사용 금지** — 추천 커밋 메시지만 예외. 함수 시그니처, import문, 변수 선언 등 프로그래밍 언어 문법을 포함하지 않는다. 동작 흐름은 번호 매긴 한글 문장으로만 표현한다.
- Every IMPL_PLAN must include a **recommended English commit message**
- Pseudocode will become inline code comments during `/impl`, so write it clear and concise
- 실제 코드는 `/impl` 실행 시에만 코드베이스에 작성된다. 계획 문서는 순수하게 한글 설명만 포함한다.
