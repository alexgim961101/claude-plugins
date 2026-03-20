# smart

> v2.0.0

리뷰 가능성을 최우선으로 하는 풀 개발 워크플로우 플러그인.

PRD 작성부터 기술 스펙, 기능 기획, TDD 구현, 멀티 에이전트 코드 리뷰까지 — 모든 단계의 산출물이 **사람이 리뷰하기 쉽도록** 설계되었습니다.

---

## Quick Start

```bash
# 1. 마켓플레이스 등록 (최초 1회)
/plugin add https://github.com/alexgim961101/claude-plugins

# 2. 플러그인 설치
/plugin install smart@alexgim961101-claude-plugins

# 3. 사용 시작
/init 사용자 알림 시스템       # PRD 생성
/spec                          # 기술 스펙 + 기능 목록
/plan 이메일 알림 기능          # 기능 기획 + 구현 계획
/impl 1-1                     # 첫 번째 유닛 TDD 구현
/review                        # 코드 리뷰
```

---

## 워크플로우

```
[신규 프로젝트]
  /init  →  docs/PRD.md                     프로젝트 요구사항 정의
  /spec  →  docs/SPEC.md                    기술 스펙 + 아키텍처
             docs/FEATURE_LIST.md            기능 목록 + 우선순위

[공통 (신규 + 기존 프로젝트)]
  /plan  →  docs/FEATURE_PLAN.md            큰 기능 → 작은 기능 분해
             docs/IMPL_PLAN_*.md             작은 기능별 구현 계획 (한글 의사코드)
  /impl  →  tests + code                    TDD 구현 (의사코드 → 코드 주석)
  /review →  터미널 출력                      3개 에이전트 병렬 코드 리뷰
```

### 산출물 전체 목록

| 단계 | 파일 | 설명 |
|------|------|------|
| `/init` | `docs/PRD.md` | 프로젝트 개요, 핵심 목표, 요구사항, 제약 조건, KPI |
| `/spec` | `docs/SPEC.md` | 기술 스택(+선정 이유), 아키텍처, 디렉토리 구조, 모니터링 |
| `/spec` | `docs/FEATURE_LIST.md` | P0/P1/P2 우선순위, 기능 의존 관계, MVP 범위 |
| `/plan` | `docs/FEATURE_PLAN.md` | 리스크 분석, 대안 검토, 기능 분해, 구현 순서 |
| `/plan` | `docs/IMPL_PLAN_*.md` | 한글 의사코드, class/함수 설명, 테스트 시나리오, 커밋 메시지 |
| `/impl` | 테스트 + 소스 코드 | TDD 구현, 의사코드가 코드 옆 주석으로 배치 |
| `/review` | 터미널 출력 | 정합성/품질/테스트 3관점 리뷰 + 문서 동기화 제안 |

---

## Skill 상세

### `/init` — PRD 작성

새 프로젝트의 요구사항을 정의합니다. 시각적/UI 내용은 제외합니다.

```
docs/PRD.md
├── 프로젝트 개요
├── 핵심 목표 (측정 가능)
├── 핵심 요구사항 / 비기능 요구사항
├── 제약 조건 / 가정 사항
├── 범위 밖 (Out of Scope)
├── 용어 정의 (Glossary)
└── 성공 지표 (KPI)
```

### `/spec` — 기술 스펙 + 기능 목록

기술 결정사항과 기능 목록을 정리합니다. 모든 기술 선택에 선정 이유가 포함됩니다.

```
docs/SPEC.md                    docs/FEATURE_LIST.md
├── 기술 스택 (+ 선정 이유)      ├── 우선순위별 기능 목록 (P0/P1/P2)
├── 아키텍처 개요                ├── 기능 간 의존 관계
├── 디렉토리 구조                └── MVP 범위
├── 외부 의존성 (+ 대안 비교)
├── 모니터링 & 로깅 전략
└── CI/CD 고려사항
```

### `/plan` — 기능 기획 + 구현 계획

멀티 에이전트로 리스크/아키텍처를 분석하고, 기능을 논리적 단위로 분해합니다.

**Phase 1** — FEATURE_PLAN.md 생성 → 사용자 확인 대기
**Phase 2** — 확인 후 IMPL_PLAN을 병렬 에이전트로 생성

```
docs/FEATURE_PLAN.md
├── 리스크 & 엣지케이스 (병렬 Agent: Risk Analyst)
├── 대안 검토 + 추천 (병렬 Agent: Architecture Reviewer)
├── 큰 기능 → 작은 기능 분해
└── 구현 순서

docs/IMPL_PLAN_{id}.md (각 작은 기능별, 병렬 Agent: Impl Planner)
├── 한글 의사코드 (코드 아님)
├── class/함수: 왜 필요, 언제 사용, 다루는 데이터
├── 예상 엣지케이스
├── 테스트 시나리오
└── 추천 영어 커밋 메시지
```

### `/impl` — TDD 구현

IMPL_PLAN을 기반으로 테스트 먼저 작성하고 구현합니다. **한 번에 하나의 유닛만** 처리하며, 리뷰 후 다음으로 진행합니다.

핵심: 구현 계획의 한글 의사코드가 코드 옆 주석으로 배치됩니다.

```python
# 사용자 입력을 받아서 유효성을 검증한다
# 유효하지 않으면 에러 메시지와 함께 400을 반환한다
def validate_input(data: dict) -> None:
    if not data.get("name"):
        raise ValidationError("name is required", status=400)
```

리뷰어는 **주석(의도)** 과 **코드(구현)** 의 일치 여부를 확인합니다.

### `/review` — 멀티 에이전트 코드 리뷰

3개의 독립 에이전트가 병렬로 코드를 검토합니다:

| 에이전트 | 관점 |
|----------|------|
| Alignment Reviewer | 계획-구현 정합성, 누락/초과 구현, 의사코드-코드 일치 |
| Quality Reviewer | 코드 품질, 보안 (OWASP Top 10), 유지보수성 |
| Test Reviewer | 테스트 커버리지/품질, 성능 이슈 (N+1, 동시성) |

추가로 **문서 동기화** 검토 — 구현 중 계획과 달라진 부분을 잡아 문서가 죽은 문서가 되는 것을 방지합니다.

---

## 자동 트리거 (Slash Command 없이)

각 skill은 자연어 표현으로도 자동 활성화됩니다:

| Skill | 자동 트리거 표현 |
|-------|-----------------|
| `init` | "프로젝트 시작", "새 프로젝트", "project init" |
| `spec` | "기술 스펙", "스택 정하자", "tech spec" |
| `plan` | "기획해줘", "계획 세워줘", "설계해줘", "어떻게 구현할까", "feature plan" |
| `impl` | "구현 시작", "구현해줘", "코딩 시작", "start coding" |
| `review` | "리뷰해줘", "검토해줘", "코드 확인", "code review" |

---

## 핵심 설계 원칙

- **리뷰 가능성 최우선** — 모든 산출물이 사람이 빠르게 훑을 수 있도록 설계됨
- **의도와 구현의 분리** — 한글 의사코드(의도)가 코드(구현) 옆에 배치되어 불일치를 즉시 발견
- **비판적, 비확인적** — 가정에 도전하며 아이디어를 그대로 승인하지 않음
- **소규모 단위** — 각 구현 유닛은 한 번에 리뷰 가능한 크기
- **문서는 살아있는 문서** — review에서 계획-구현 괴리를 잡아 문서를 최신 상태로 유지

---

## 프로젝트 구조

```
plugins/smart/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── init.md            # /init 진입점
│   ├── spec.md            # /spec 진입점
│   ├── plan.md            # /plan 진입점
│   ├── impl.md            # /impl 진입점
│   └── review.md          # /review 진입점
├── skills/
│   ├── init/
│   │   └── SKILL.md       # PRD 생성 프로세스
│   ├── spec/
│   │   └── SKILL.md       # 기술 스펙 + 기능 목록 프로세스
│   ├── plan/
│   │   ├── SKILL.md       # 기능 기획 프로세스 (v2.0)
│   │   └── agents/
│   │       ├── risk-analyst.md      # 리스크 분석 에이전트
│   │       ├── arch-reviewer.md     # 아키텍처 검토 에이전트
│   │       └── impl-planner.md      # 구현 계획 생성 에이전트
│   ├── impl/
│   │   └── SKILL.md       # TDD 구현 프로세스
│   └── review/
│       ├── SKILL.md       # 코드 리뷰 프로세스
│       └── agents/
│           ├── alignment-reviewer.md  # 계획-구현 정합성
│           ├── quality-reviewer.md    # 코드 품질 & 보안
│           └── test-reviewer.md       # 테스트 & 성능
└── README.md
```

---

## 플러그인 재설치 / 업데이트

```bash
/plugin uninstall smart
/plugin remove alexgim961101-claude-plugins
/plugin add https://github.com/alexgim961101/claude-plugins
/plugin install smart@alexgim961101-claude-plugins
```
