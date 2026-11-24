# jelly-harness

[obra/superpowers](https://github.com/obra/superpowers) v7.0.2를 바탕으로 한 개인 포크입니다. 기획 단계만 요구사항·설계·과제 문서를 차례로 쓰고 승인받는 방식(SDD)으로 바꿨습니다. 구현·디버깅·검증 스킬과 세션 시작 훅은 upstream 그대로입니다.

## upstream과 다른 점

| 파일 | 바뀐 내용 |
|---|---|
| `skills/brainstorming/SKILL.md` | 대화 절차와 단일 설계 문서를 없앴습니다. 일의 크기를 정한 다음 큰 기능이면 `requirements.md`와 `design.md`를 따로 써서 각각 승인받게 합니다. |
| `skills/writing-plans/SKILL.md` | 세 군데를 바꿨습니다. 계획 저장 위치를 `docs/specs/<feature-name>/tasks.md`로 바꿨습니다. 계획 첫 줄에서 실행 스킬 지정을 뺐습니다. 실행 방식을 고르게 하던 질문은 "승인 뒤 `/clear`, 구현 수단은 과제를 보고 판단"으로 바꿨습니다. |
| `.claude-plugin/marketplace.json` | 마켓플레이스 이름과 설치 이름을 `jelly-harness`로 바꿨습니다. |
| `.github/workflows/upstream-release-check.yml`, `.github/scripts/upstream-release-check.sh` | upstream에 새 릴리스가 나오면 이 레포에 이슈를 여는 점검을 추가했습니다. |
| `README.md`, `CLAUDE.md` | 이 포크에 맞게 새로 썼습니다. |

그 밖의 스킬, 훅, 문서(`RELEASE-NOTES.md`, `AGENTS.md`, `docs/` 등)는 upstream 것입니다.

플러그인 내부 이름은 `superpowers` 그대로입니다. 그래서 스킬은 `superpowers:brainstorming`처럼 upstream과 같은 접두어로 부릅니다.

## 설치

레포를 클론한 뒤 그 폴더를 로컬 마켓플레이스로 추가합니다.

```
git clone https://github.com/jelitz/jelly-harness.git
```

```
/plugin marketplace add <클론한 폴더의 절대 경로>
/plugin install jelly-harness@jelly-harness
```

- GitHub 주소로 바로 설치하지 않습니다. 그렇게 설치하면 매니페스트의 버전(7.0.2)이 바뀔 때까지 처음 받은 복사본을 계속 쓰므로 이 포크에서 스킬을 고쳐도 반영되지 않습니다. 로컬 경로로 추가하면 폴더에서 바로 읽으므로 다음 세션이나 `/reload-plugins`에서 반영됩니다.
- 다른 superpowers 설치본은 제거합니다. 이름이 같은 플러그인 둘이 켜져 있으면 한쪽의 훅만 등록됩니다.
- 큰 기능의 문서 구성은 `writing-sdd-blueprints` 스킬이 정합니다. 이 스킬은 이 레포에 없으므로 `~/.claude/skills/`에 따로 둡니다.

## 쓰는 흐름

1. `superpowers:brainstorming`이 일의 크기를 정합니다. 한 문장으로 설명되는 변경은 바로 수행합니다. 작은 변경은 채팅에서 계획을 승인받고 수행합니다.
2. 큰 기능이면 Claude가 `docs/specs/<feature-name>/requirements.md`를 쓰고 사용자가 승인합니다. 이어서 `design.md`도 같은 방식으로 승인받습니다.
3. `superpowers:writing-plans`가 같은 폴더에 `tasks.md`를 씁니다. 과제 제목은 `### Task N: 이름` 형식입니다.
4. 사용자가 `tasks.md`를 승인하면 `/clear`로 컨텍스트를 비우고 구현을 시작합니다. 구현 수단은 Claude가 과제 수, 과제 사이의 의존, 파일 겹침을 보고 고릅니다.
5. 과제를 마치면 제목 끝에 ✅를 붙이고 `implemented.md`를 함께 갱신합니다.

## upstream 릴리스 반영

`Upstream release check` 워크플로가 매일 09:17(한국 시간)에 obra/superpowers의 최신 릴리스를 확인합니다. 아직 병합하지 않은 릴리스가 있으면 "upstream v○○ 릴리스: 병합 필요" 이슈를 열고 레포 소유자에게 배정합니다. 이슈는 릴리스마다 하나만 열립니다. 본문에는 이 포크에서 고친 파일 중 upstream에서도 바뀐 파일이 적힙니다.

병합은 로컬 클론에서 합니다.

```
git fetch upstream --tags
git merge v<새 버전>
```

병합 충돌은 파일마다 처리 방법이 다릅니다.

| 파일 | 처리 |
|---|---|
| `skills/brainstorming/SKILL.md`, `README.md` | 이 포크의 내용을 유지합니다. |
| `skills/writing-plans/SKILL.md` | upstream 변경을 받습니다. 저장 위치, 계획 첫 줄, 실행 방식 안내 세 군데만 이 포크의 내용으로 둡니다. |
| `.claude-plugin/marketplace.json` | 이름은 `jelly-harness`로 두고 버전은 upstream 값을 받습니다. |

병합한 뒤 `claude plugin validate .`로 검증하고 `git push origin main`으로 올립니다. 열려 있는 세션은 `/reload-plugins`로 반영합니다.

`upstream` 원격이 없는 클론에서는 `git remote add upstream https://github.com/obra/superpowers.git`를 먼저 실행합니다.

## 주의와 한계

- superpowers의 실행 스킬은 `### Task N:` 형식의 제목만 과제로 읽습니다. `T1`처럼 다른 표기를 쓴 `tasks.md`는 읽지 못합니다.
- `superpowers:subagent-driven-development`는 구현 서브에이전트를 한 번에 하나씩만 띄웁니다. upstream의 설계이고 이 포크에서 바꾸지 않았습니다.
- 2026-11-24 기준으로 설치와 스킬 로드까지만 확인했습니다. 이 구성으로 기능 하나를 끝까지 만든 기록은 아직 없습니다.

## 라이선스

MIT. 원저작자는 [obra/superpowers](https://github.com/obra/superpowers)의 Jesse Vincent입니다. [LICENSE](LICENSE)는 upstream 그대로입니다.
