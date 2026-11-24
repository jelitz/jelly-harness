# jelly-harness

[![Upstream release check][check-badge]][check-runs] [![upstream 버전][upstream-badge]][upstream-releases] [![라이선스][license-badge]](LICENSE)

----

jelly-harness는 Claude Code 플러그인 [superpowers]의 개인 포크입니다. 기획 단계를 요구사항·설계·과제 문서를 차례로 쓰고 승인받는 방식(SDD)으로 바꿨습니다.

jelly-harness는 원본인 [obra/superpowers][superpowers](이하 upstream)의 릴리스를 바탕으로 합니다. 바꾼 스킬은 `brainstorming`과 `writing-plans` 둘입니다. 구현·디버깅·검증 스킬과 세션 시작 훅은 upstream 그대로입니다. 바뀐 파일은 [upstream과 다른 점][differences]에 모두 적었습니다.

jelly-harness는 개인 용도로 관리하는 비공식 포크입니다. obra/superpowers 프로젝트와는 관계가 없습니다. 2026-11-24 기준으로 설치와 스킬 로드까지만 확인했습니다. 이 구성으로 기능 하나를 끝까지 만든 기록은 아직 없습니다.

----

## jelly-harness 쓰기 시작하기

레포를 클론한 뒤 그 폴더를 로컬 마켓플레이스로 추가합니다.

```
git clone https://github.com/jelitz/jelly-harness.git
```

```
/plugin marketplace add <클론한 폴더의 절대 경로>
/plugin install jelly-harness@jelly-harness
```

- GitHub 주소로 바로 설치하지 않습니다. 그렇게 설치하면 매니페스트의 버전이 바뀔 때까지 처음 받은 복사본을 계속 쓰므로 이 포크에서 스킬을 고쳐도 반영되지 않습니다.
- 다른 superpowers 설치본은 제거합니다. 이름이 같은 플러그인 둘이 켜져 있으면 한쪽의 훅만 등록됩니다.
- 큰 기능의 문서 구성은 `writing-sdd-blueprints` 스킬이 정합니다. 이 스킬은 이 레포에 들어 있지 않습니다. 같은 이름의 스킬을 `~/.claude/skills/`에 직접 두어야 합니다.

큰 기능 하나를 진행하는 순서는 [쓰는 흐름][flow]에 있습니다.

## jelly-harness 고치기 시작하기

Claude Code는 로컬 경로로 추가한 플러그인을 클론한 폴더에서 바로 읽습니다. 파일을 고치면 다음 세션이나 `/reload-plugins`에서 반영됩니다.

##### 스킬이나 매니페스트를 고쳤을 때

```
claude plugin validate .
```

##### upstream에 새 릴리스가 나왔을 때

```
git fetch upstream --tags
git merge v<새 버전>
```

`Upstream release check` 워크플로가 매일 upstream의 최신 릴리스를 확인합니다. 아직 병합하지 않은 릴리스가 있으면 이 레포에 이슈를 엽니다. 충돌 처리 방법을 포함한 병합 절차는 [upstream 릴리스 반영][merging]에 있습니다.

## 지원

개인 포크라 따로 둔 지원 창구는 없습니다. 이 포크에서 바꾼 부분의 문제는 [이 레포의 이슈][issues]에 남길 수 있습니다. 바꾸지 않은 스킬의 사용법은 [upstream README][superpowers]에 있습니다. 이 포크에서 생긴 문제를 upstream 이슈 트래커에 올리지 않습니다.

## 라이선스

MIT. 원저작자는 [obra/superpowers][superpowers]의 Jesse Vincent입니다. [LICENSE](LICENSE)는 upstream 그대로입니다.

[check-badge]: https://github.com/jelitz/jelly-harness/actions/workflows/upstream-release-check.yml/badge.svg
[check-runs]: https://github.com/jelitz/jelly-harness/actions/workflows/upstream-release-check.yml
[differences]: docs/jelly-harness.md#upstream과-다른-점
[flow]: docs/jelly-harness.md#쓰는-흐름
[issues]: https://github.com/jelitz/jelly-harness/issues
[license-badge]: https://img.shields.io/github/license/jelitz/jelly-harness
[merging]: docs/jelly-harness.md#upstream-릴리스-반영
[superpowers]: https://github.com/obra/superpowers
[upstream-badge]: https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fraw.githubusercontent.com%2Fjelitz%2Fjelly-harness%2Fmain%2F.claude-plugin%2Fmarketplace.json&query=%24.plugins%5B0%5D.version&label=upstream&prefix=v
[upstream-releases]: https://github.com/obra/superpowers/releases
