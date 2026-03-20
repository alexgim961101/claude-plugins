# claude-plugins

Personal Claude Code plugins marketplace.

## 마켓플레이스 등록

```bash
/plugin add https://github.com/alexgim961101/claude-plugins
```

## Plugins

| Plugin | Version | 설명 |
|--------|---------|------|
| [smart](./plugins/smart) | v2.0.0 | 풀 개발 워크플로우 — PRD, 기술 스펙, 기능 기획, TDD 구현, 멀티 에이전트 코드 리뷰 |

## 플러그인 설치

```bash
/plugin install smart@alexgim961101-claude-plugins
```

## 사용 가능한 명령어

| 명령어 | 설명 |
|--------|------|
| `/init` | PRD (Product Requirements Document) 생성 |
| `/spec` | 기술 스펙 + 기능 목록 정의 |
| `/plan` | 멀티 에이전트 기능 기획 + 구현 계획 |
| `/impl` | TDD 기반 구현 (한글 의사코드 주석) |
| `/review` | 3개 에이전트 병렬 코드 리뷰 |

자세한 사용법은 [플러그인 README](./plugins/smart/README.md)를 참고하세요.
