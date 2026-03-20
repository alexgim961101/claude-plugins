# smart

멀티 에이전트 기반 피처 플래닝 플러그인. 코드를 작성하기 **전에** 구조화된 리뷰 가능한 플랜을 생성합니다.

리스크 분석, 아키텍처 대안 검토, API/데이터 모델 초안, 그리고 작은 구현 유닛 분해를 포함합니다.

---

## 설치

### 1. 마켓플레이스 등록 (최초 1회)

```bash
/plugin add https://github.com/alexgim961101/claude-plugins
```

### 2. 플러그인 설치

```bash
/plugin install smart@alexgim961101-claude-plugins
```

설치가 완료되면 `/plan` slash command와 `plan` skill이 활성화됩니다.

---

## 사용법

### Slash Command

```
/plan <기능 설명>
```

예시:

```
/plan 사용자 알림 시스템 구현 — 이메일과 푸시 알림을 지원해야 함
```

`<기능 설명>`이 비어 있으면 Claude가 먼저 기능 설명을 요청합니다.

### 자동 트리거 (Skill)

다음 표현을 사용하면 `plan` skill이 자동으로 활성화됩니다:

- `기획해줘`, `계획 세워줘`, `설계해줘`, `플랜 짜줘`
- `feature plan`, `let's plan`, `before we implement`
- 비자명 기능에 대해 구현 방법을 묻는 경우

---

## 동작 방식

1. **요구사항 명확화** — 기능 설명이 불명확하면 최대 3개의 질문으로 명확화
2. **코드베이스 스캔** — 관련 파일, 컨벤션, 기술 스택 파악
3. **3개 에이전트 병렬 실행**:
   - **Risk Analyst** — 리스크, 엣지케이스, 보안 이슈 도출
   - **Architecture Reviewer** — 대안 검토 및 접근법 추천
   - **Unit Planner** — 구현 유닛 분해 (독립적으로 리뷰 가능한 단위)
4. **초안 작성** — API 인터페이스, 데이터 모델, 테스트 시나리오
5. **플랜 저장** — 프로젝트의 `plans/` 디렉토리에 마크다운 파일로 저장

---

## 출력 구조

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

---

## 플러그인 재설치 / 업데이트

플러그인 소스가 변경된 경우, 아래 순서로 재등록합니다:

```bash
# 1. 기존 플러그인 제거
/plugin uninstall smart

# 2. 마켓플레이스 갱신 (소스가 변경된 경우)
/plugin remove alexgim961101-claude-plugins
/plugin add https://github.com/alexgim961101/claude-plugins

# 3. 재설치
/plugin install smart@alexgim961101-claude-plugins
```

---

## 설계 원칙

- **비판적, 비확인적** — 가정에 도전하며 아이디어를 그대로 승인하지 않음
- **초안 수준** — 완결된 스펙이 아닌 구조와 핵심만 담은 초안
- **소규모 유닛** — 각 구현 유닛은 한 번에 리뷰 가능한 크기
- **명확한 추천** — 여러 옵션 나열이 아닌 명확한 근거를 가진 단일 추천
