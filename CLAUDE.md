# CLAUDE.md

이 레포는 [obra/superpowers](https://github.com/obra/superpowers)의 개인 포크다. 소개와 설치는 `README.md`에 있다. upstream과 다른 점과 병합 절차는 `docs/jelly-harness.md`에 있다.

- `AGENTS.md`는 upstream에 기여할 때의 규칙이다. 이 포크의 작업에는 적용하지 않는다.
- 이 포크가 고친 파일은 아래 여덟 개다. 그 밖의 upstream 파일은 사용자가 요청할 때만 고친다. 고친 파일이 늘면 upstream을 병합할 때마다 충돌이 늘어난다. 새 파일을 고쳤으면 이 목록과 `docs/jelly-harness.md`의 「upstream과 다른 점」 표에 추가한다.
  - `skills/brainstorming/SKILL.md`
  - `skills/writing-plans/SKILL.md`
  - `.claude-plugin/marketplace.json`
  - `.github/workflows/upstream-release-check.yml`
  - `.github/scripts/upstream-release-check.sh`
  - `README.md`
  - `CLAUDE.md`
  - `docs/jelly-harness.md`
- `skills/writing-plans/SKILL.md`는 저장 위치, 계획 첫 줄, Execution Handoff 세 군데만 다르다. 이 범위를 넓히지 않는다.
- 플러그인 내부 이름(`.claude-plugin/plugin.json`의 `name`)은 `superpowers`로 둔다. 바꾸면 스킬끼리 서로 가리키는 `superpowers:` 참조를 모두 고쳐야 한다.
- `origin`은 `jelitz/jelly-harness`이고 `upstream`은 `obra/superpowers`다. upstream에는 푸시하지 않고 PR과 이슈도 만들지 않는다.
- 커밋 신원은 이 레포에 설정된 `user.name`과 `user.email`을 그대로 쓴다.
- upstream 릴리스를 병합할 때는 `docs/jelly-harness.md`의 「upstream 릴리스 반영」 절을 따른다.
- 스킬이나 매니페스트를 고친 뒤에는 `claude plugin validate .`를 실행한다. "CLAUDE.md at the plugin root" 경고는 이 파일이 플러그인과 함께 배포되지 않는다는 뜻이다. 이 파일은 이 레포에서 작업할 때만 쓰므로 그대로 둔다.
