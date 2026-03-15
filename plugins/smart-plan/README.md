# smart-plan

A critical, multi-agent feature planning plugin for Claude Code.

Produces a structured, human-reviewable plan **before you write any code** — with risk analysis, architecture alternatives, API/data model drafts, and small implementation units.

## Usage

```
/smart-plan <feature description>
```

Or just start describing a feature — the skill activates automatically.

## What It Does

1. **Clarifies** the requirement (up to 3 questions if vague)
2. **Scans** the codebase for relevant context
3. **Runs 3 agents in parallel**:
   - Risk Analyst — surfaces risks, edge cases, security issues
   - Architecture Reviewer — evaluates alternatives, recommends an approach
   - Unit Planner — breaks the feature into small, reviewable implementation units
4. **Drafts** API interface, data model, and test scenarios
5. **Saves** the plan to `plans/` in your project

## Output

```
plans/{feature-name}.md
├── 목표 & 배경
├── 범위 (In/Out of Scope)
├── 리스크 & 엣지케이스
├── 대안 검토 (테이블 + 추천안)
├── API 인터페이스 초안
├── 데이터 모델 초안
├── 테스트 시나리오
├── 구현 유닛 (체크리스트)
└── 기술적 고려사항
```

## Design Philosophy

- **Critical, not confirmatory** — challenges assumptions, doesn't rubber-stamp ideas
- **Detailed but not speckit** — drafts, not finalized specs; structure, not every field
- **Small units** — each implementation unit is independently reviewable in one sitting
- **Opinionated** — recommends one approach with clear reasoning, not a list of options

## Installation

```
/plugin install smart-plan@alexgim961101-claude-plugins
```
