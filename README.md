# claude-plugins

Personal Claude Code plugins marketplace.

## 마켓플레이스 등록

이 레포는 `alexgim961101-claude-plugins` 마켓플레이스로 등록되어 있습니다.

마켓플레이스를 Claude Code에 추가하려면:

```bash
/plugin add https://github.com/alexgim961101/claude-plugins
```

## Plugins

| Plugin | 설명 |
|--------|------|
| [smart](./plugins/smart) | 멀티 에이전트 기반 피처 플래닝 — 리스크 분석, 아키텍처 대안 검토, 구현 유닛 분해 |

## 플러그인 설치 방법

마켓플레이스 등록 후, 아래 명령으로 개별 플러그인을 설치합니다:

```bash
/plugin install smart@alexgim961101-claude-plugins
```

설치 후 제공되는 slash command와 skill은 [각 플러그인 README](./plugins/smart/README.md)를 참고하세요.
