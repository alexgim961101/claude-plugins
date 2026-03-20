---
name: init
description: >
  Create a PRD (Product Requirements Document) for a new project. Generates docs/PRD.md with project overview,
  core goals, functional/non-functional requirements, constraints, and success metrics — excluding all visual/UI content.
  Use this skill whenever the user says "프로젝트 시작", "새 프로젝트", "프로젝트 초기화", "project init", "new project",
  "start a project", "PRD 작성", or describes a new project idea and needs to formalize requirements.
  Always use this skill proactively when a new project discussion begins, even if the user hasn't explicitly asked for a PRD.
version: 1.0.0
---

# Init — PRD Creation

Generate a PRD (Product Requirements Document) for a new project.
Exclude all visual/UI content and focus on core goals and requirements.

The PRD serves as the reference point for all subsequent documents (SPEC, FEATURE_LIST, FEATURE_PLAN).
An unclear PRD causes confusion at every downstream stage, so clarity here is critical.

## When to Apply

- Starting a new project
- Existing project has no PRD
- User invokes `/init`

## Process

### Step 1: Gather Requirements

If the description is unclear, ask **up to 3** targeted questions:

1. What is the **core problem** this project solves?
2. Who is the **target user**?
3. Any key **constraints** (tech, timeline, team)?

Wait for user response before proceeding.

### Step 2: Scan Project Root

Check existing state:
1. `CLAUDE.md` — project conventions
2. `docs/` directory existence
3. `README.md` — existing project description
4. Key config files (`package.json`, `build.gradle`, `go.mod`, etc.)

### Step 3: Generate docs/PRD.md

Create `docs/` directory if it doesn't exist, then write `docs/PRD.md` using this template:

```markdown
# {프로젝트명} — PRD (Product Requirements Document)

> 생성일: {YYYY-MM-DD}
> 상태: 초안 (검토 필요)

---

## 프로젝트 개요

한 문장으로 프로젝트가 해결하려는 문제를 설명한다.

---

## 핵심 목표

- 목표 1 (측정 가능하게 작성)
- 목표 2
- 목표 3

---

## 대상 사용자

- 사용자 유형과 주요 특성
- 사용 맥락 (언제, 어디서, 왜 사용하는지)

---

## 핵심 요구사항 (Functional Requirements)

- **FR-1**: ...
- **FR-2**: ...
- **FR-3**: ...

---

## 비기능 요구사항 (Non-Functional Requirements)

- **NFR-1 (성능)**: ...
- **NFR-2 (보안)**: ...
- **NFR-3 (확장성)**: ...

---

## 제약 조건 (Constraints)

- 기술적 제약
- 시간적 제약
- 인력/비용 제약

---

## 가정 사항 (Assumptions)

- 검증이 필요한 가정들을 나열한다
- 가정이 틀렸을 때의 영향을 함께 적는다

---

## 범위 밖 (Out of Scope)

- 이 프로젝트에서 명시적으로 다루지 않는 것
- 스코프 크립을 방지하기 위해 구체적으로 작성한다

---

## 용어 정의 (Glossary)

| 용어 | 정의 |
|------|------|
| ... | ... |

---

## 성공 지표 (KPI/Metrics)

| 지표 | 목표치 | 측정 방법 |
|------|--------|-----------|
| ... | ... | ... |
```

### Step 4: Request Review

After generation, output:
- PRD save path
- Core goals summary (2-3 lines)

Then ask: **"PRD를 검토해 주세요. 수정할 부분이 있으면 말씀해 주세요. 확정되면 `/spec`으로 기술 스펙을 작성합니다."**

## Quality Rules

- Challenge vague goals — unmeasurable goals like "improve UX" must be made specific
- Write each section as scannable bullet points — avoid long paragraphs
- Requirements must be specific enough to test against
- Exclude all visual/UI content
