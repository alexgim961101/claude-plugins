---
name: spec
description: >
  Define technical specifications and feature list for a project. Generates docs/SPEC.md (tech stack, architecture,
  directory structure, monitoring strategy) and docs/FEATURE_LIST.md (prioritized features with dependencies and MVP scope).
  Use this skill whenever the user says "기술 스펙", "스펙 정의", "tech spec", "기술 스택", "feature list", "기능 목록",
  "아키텍처 설계", "스택 정하자", or wants to make technical decisions for a project.
  Always use this skill proactively when technical decision-making discussion begins, even without explicit request.
version: 1.0.0
---

# Spec — Technical Specification & Feature List

Generate SPEC.md and FEATURE_LIST.md for the project.

Every tech choice must include a **justification**. "It's popular" is not a reason.
A reviewer should immediately understand why each technology was selected.

## When to Apply

- Defining technical specifications
- Deciding tech stack
- Creating feature list
- Typically follows `/init` (PRD creation)

## Process

### Step 1: Collect PRD Context

Read `docs/PRD.md` if it exists to align with requirements.
If missing, ask the user for project context or suggest running `/init` first.

### Step 2: Scan Project

Detect existing tech stack:
1. Check config files: `package.json`, `build.gradle`, `pom.xml`, `go.mod`, `Cargo.toml`, `docker-compose.yml`, `pyproject.toml`
2. Check source directory structure (ls only, no recursive scan)
3. Read `CLAUDE.md` for project conventions

### Step 3: Clarify Tech Preferences

For new projects, ask **up to 3** questions:
1. Preferred language/framework?
2. Database requirements (RDBMS, NoSQL, in-memory, etc.)?
3. Deployment target (cloud, on-prem, containers, etc.)?

### Step 4: Generate docs/SPEC.md

```markdown
# {프로젝트명} — Technical Specification

> 생성일: {YYYY-MM-DD}
> 상태: 초안 (검토 필요)

---

## 기술 스택

| 영역 | 기술 | 버전 | 선정 이유 |
|------|------|------|-----------|
| 언어 | ... | ... | ... |
| 프레임워크 | ... | ... | ... |
| 데이터베이스 | ... | ... | ... |
| 캐시 | ... | ... | ... |
| 인프라 | ... | ... | ... |
| 기타 | ... | ... | ... |

---

## 아키텍처 개요

- **패턴**: (e.g., Layered, Hexagonal, Event-driven, CQRS)
- **계층 구조**: 각 계층의 책임
- **주요 컴포넌트**: 컴포넌트 간 관계와 데이터 흐름

---

## 디렉토리 구조

```
project-root/
├── src/
│   ├── ...
├── tests/
├── docs/
└── ...
```

각 주요 디렉토리의 역할을 한 줄로 설명한다.

---

## 외부 의존성

| 의존성 | 용도 | 대안 (검토함) |
|--------|------|---------------|
| ... | ... | ... |

---

## 개발 환경 설정

```bash
# 필요한 도구 및 버전
# 설정 명령어
```

---

## 모니터링 & 로깅 전략

- **로그 레벨 정책**: DEBUG / INFO / WARN / ERROR 각각의 사용 기준
- **구조화 로깅**: 로그 포맷 (JSON 등)
- **메트릭**: 수집할 핵심 메트릭
- **알림**: 알림 기준과 채널

---

## CI/CD 고려사항

- **빌드**: 빌드 도구, 단계
- **테스트**: 테스트 자동화 범위
- **배포**: 배포 전략 (Blue-Green, Rolling, Canary 등)
```

### Step 5: Generate docs/FEATURE_LIST.md

```markdown
# {프로젝트명} — Feature List

> 생성일: {YYYY-MM-DD}
> 상태: 초안 (검토 필요)

---

## 우선순위 정의

- **P0 (필수)**: MVP에 반드시 포함
- **P1 (중요)**: MVP 이후 첫 번째 iteration
- **P2 (희망)**: 리소스 여유 시 구현

---

## 기능 목록

| ID | 기능명 | 설명 | 우선순위 | 의존성 |
|----|--------|------|----------|--------|
| F-01 | ... | ... | P0 | - |
| F-02 | ... | ... | P0 | F-01 |
| F-03 | ... | ... | P1 | F-01, F-02 |

---

## MVP 범위

P0 기능만으로 구성된 최소 제품을 정의한다.

---

## 기능 의존 관계

어떤 기능이 먼저 구현되어야 하는지, 그 이유를 설명한다.
```

### Step 6: Request Review

After generation, output:
- SPEC.md and FEATURE_LIST.md save paths
- Tech stack summary
- Feature count (P0/P1/P2 each)

Then ask: **"기술 스펙과 기능 목록을 검토해 주세요. 확정되면 `/plan`으로 기능 기획을 시작합니다."**

## Quality Rules

- Every tech stack selection must include **justification** — compare with alternatives
- Verify consistency between PRD requirements and technical decisions
- Feature list must have explicit priorities and dependency ordering
- Directory structure should follow conventions of the chosen tech stack
