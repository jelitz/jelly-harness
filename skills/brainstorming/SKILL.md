---
name: brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, modifying behavior, or planning anything new, in software or out of it (a talk, a business, a renovation)."
---

# Brainstorming

이 포크의 brainstorming은 두 가지만 한다. 일의 크기를 정하고, 큰 기능이면 요구사항·설계·과제 문서 절차(SDD)로 넘긴다. upstream의 대화 절차와 단일 설계 문서는 쓰지 않는다.

## 먼저 읽는다

요청이 가리키는 파일과 그것이 닿는 코드를 먼저 읽는다. 탐색은 허락을 구하지 않고 한다. 프로젝트나 앞선 대화가 이미 답한 것은 묻지 않는다.

## 크기를 정한다

| 크기 | 기준 | 할 일 |
|---|---|---|
| 바로 할 일 | 변경을 한 문장으로 설명할 수 있다 | 질문 없이 수행하고 무엇을 했는지 말한다 |
| 작은 변경 | 한 문장으로는 부족하지만 스펙 문서까지는 필요 없다 | 계획을 채팅으로 보이고 승인을 받은 뒤 수행한다. 문서는 만들지 않는다 |
| 큰 기능 | 구현 전에 스펙을 확정해야 한다 | 아래 「큰 기능」을 따른다 |

정한 크기를 한 줄로 말한다. 사용자가 바꿀 수 있다. 작업 중에 범위가 커지면 멈추고 그 사실을 말한 뒤 한 단계 올린다. 서로 독립된 기능 여러 개라면 순서를 합의하고 하나씩 진행한다.

## 큰 기능

1. `writing-sdd-blueprints` 스킬을 호출한다. 문서 위치와 구성, 유지 규칙은 그 스킬이 정한다. 프로젝트 `CLAUDE.md`가 자체 문서 규칙을 두면 그것이 우선한다.
2. 인터뷰는 내장 질문 도구로 묶어서 한다. 명백한 질문은 피하고, 사용자가 고려하지 않았을 어려운 부분을 묻는다.
3. `requirements.md`를 쓰고 승인을 받는다. 그다음 `design.md`를 쓰고 승인을 받는다. 두 문서를 하나로 합치지 않는다.
4. `design.md`가 승인되면 `superpowers:writing-plans`를 호출해 같은 폴더에 `tasks.md`를 쓴다.

<HARD-GATE>
큰 기능은 `requirements.md`와 `design.md`가 각각 승인되기 전에는 아무것도 만들지 않는다. 제품 코드 작성, 스캐폴딩, 의존성 설치, 프로젝트 생성, 구현 스킬 호출이 모두 만들기에 해당한다. 읽기와 탐색은 해도 된다.
</HARD-GATE>
