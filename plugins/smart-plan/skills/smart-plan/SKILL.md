---
name: smart-plan
description: >
  Use this skill when the user wants to plan a feature, design a new capability, or think through an implementation before writing code.
  Triggers on phrases like "기획", "계획 세워줘", "어떻게 구현할까", "설계해줘", "플랜 짜줘", "feature plan", "let's plan", "before we implement", or when the user describes a feature and asks how to approach it.
  Always use this skill proactively when a non-trivial feature discussion begins, even if the user hasn't explicitly asked for a plan.
version: 1.0.0
---

# Smart Plan

A critical, multi-agent feature planning skill that produces a structured, human-reviewable plan before any code is written.

## When This Skill Applies

- User wants to plan or design a feature
- User describes a new capability and asks how to approach it
- User wants to think through trade-offs before implementing
- User invokes `/smart-plan`

## Process

### Step 1a: Clarify (if needed)

If the feature description is vague or incomplete, ask **up to 3 targeted clarifying questions**. Wait for the user's response before proceeding to Step 1b.

### Step 1b: Scan Codebase

Once the feature description is clear, scan the following in order:
1. `CLAUDE.md` (project conventions — always read first)
2. Top-level project structure (`ls` only — do not recursively read)
3. Key config files: `package.json`, `build.gradle`, `docker-compose.yml`, `pom.xml` (whichever exist)
4. Up to 5 source files most relevant to the feature (use Glob with feature keywords, not a full tree scan)

Summarize findings as `CODEBASE_CONTEXT`: tech stack, key conventions, relevant modules.

### Step 2: Launch Agents

Run **Agent A (Risk Analyst)** and **Agent B (Architecture Reviewer)** in parallel using the Agent tool.

**Agent A — Risk Analyst**
Read `agents/risk-analyst.md`. Fill in:
- `{{FEATURE_DESCRIPTION}}`: full feature description
- `{{CODEBASE_CONTEXT}}`: focus on external dependencies, transaction patterns, security config

**Agent B — Architecture Reviewer**
Read `agents/arch-reviewer.md`. Fill in:
- `{{FEATURE_DESCRIPTION}}`: full feature description
- `{{CODEBASE_CONTEXT}}`: focus on existing architectural patterns, tech stack, infra

After Agent B completes, extract the `### 추천:` block as `RECOMMENDED_APPROACH`.
- If Agent B did not produce a clear recommendation, use the fallback: `"추천 접근법 미확정 — 별도 아키텍처 결정 필요"`

Then run **Agent C (Unit Planner)**:

**Agent C — Unit Planner**
Read `agents/unit-planner.md`. Fill in:
- `{{FEATURE_DESCRIPTION}}`: full feature description
- `{{RECOMMENDED_APPROACH}}`: from Agent B (or fallback above)
- `{{CODEBASE_CONTEXT}}`: focus on directory structure, coding conventions

### Step 3: Draft Supporting Sections

Draft the following yourself based on the feature and agent outputs:

**API 인터페이스 초안**
- List key endpoints or method signatures
- Show essential request/response shape (not full schema — just the important fields)
- Mark which are new vs modified

**데이터 모델 초안**
- List key entities and their critical fields
- Show relationships (1:N, N:M, etc.)
- Highlight any schema migrations required

**기술적 고려사항**
- Performance: expected load, bottlenecks, caching needs
- Security: auth boundaries, input validation, data sensitivity
- Scalability: horizontal scaling considerations, data growth

**미결 사항 (Open Questions)**
- List any decisions that need product/stakeholder input
- Flag assumptions that need validation

> Note: Test scenarios are produced by Agent A — do not re-draft them here.

### Step 4: Assemble and Save the Plan

Read `templates/plan.md` and fill each placeholder as follows:

| Placeholder | Source |
|---|---|
| `{{FEATURE_NAME}}` | kebab-case feature title |
| `{{DATE}}` | today's date (YYYY-MM-DD) |
| `{{GOAL}}` | one-sentence objective from Step 1 |
| `{{BACKGROUND}}` | codebase context summary from Step 1b |
| `{{IN_SCOPE}}` | bullet list confirmed in Step 1 |
| `{{OUT_OF_SCOPE}}` | bullet list confirmed in Step 1 |
| `{{RISKS_SECTION}}` | full markdown output from Agent A (verbatim) |
| `{{ALTERNATIVES_SECTION}}` | full markdown output from Agent B (verbatim) |
| `{{UNITS_SECTION}}` | full markdown output from Agent C (verbatim) |
| `{{API_DRAFT}}` | drafted in Step 3 |
| `{{DATA_MODEL_DRAFT}}` | drafted in Step 3 |
| `{{TEST_SCENARIOS}}` | from Agent A's `### 테스트 시나리오` block |
| `{{PERFORMANCE_NOTES}}` | drafted in Step 3 |
| `{{SECURITY_NOTES}}` | drafted in Step 3 |
| `{{SCALABILITY_NOTES}}` | drafted in Step 3 |
| `{{OPEN_QUESTIONS}}` | drafted in Step 3 |

**Save location** (in order of preference):
1. Check if `plans/` exists in the project root → save there
2. If not, create it with `mkdir -p plans/` → save there
3. If creation fails (permissions), fall back to `~/.claude/plans/`
4. If all fail, output the full plan to terminal and warn the user

**Filename format**: `{kebab-case-feature-name}.md`

After saving, output a concise summary to the terminal:
- Plan saved location
- Number of implementation units
- Top 2–3 risks
- Recommended approach (one line)

Then ask: **"플랜을 검토해 주세요. 수정하거나 보완할 부분이 있으면 말씀해 주세요."**

## Quality Constraints

- **Be critical**: Do not rubber-stamp the user's initial idea. Challenge assumptions.
- **Be concise**: Each section contains only what is needed — no padding, no repetition.
- **No over-specification**: API drafts show shape, not full OpenAPI. Data models show structure, not every column constraint.
- **Small units**: Each implementation unit must be independently reviewable in one sitting.
- **Honest trade-offs**: Alternative analysis must reflect real trade-offs, not a fake comparison.
