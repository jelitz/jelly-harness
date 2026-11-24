#!/usr/bin/env bash
# Open an issue in this fork when upstream has a release that is not merged
# into the checked-out branch yet. Run from the repository root with full
# history.
#
# Env: GH_TOKEN (issues: write), GITHUB_REPOSITORY, GITHUB_REPOSITORY_OWNER
#      UPSTREAM   upstream repository, default obra/superpowers
#      FORCE      "true" opens a test issue even when nothing is pending
#      DRY_RUN    non-empty prints the title and body instead of opening one
set -euo pipefail

upstream=${UPSTREAM:-obra/superpowers}
latest=$(gh api "repos/$upstream/releases/latest" --jq .tag_name)
release_url=$(gh api "repos/$upstream/releases/latest" --jq .html_url)
published=$(gh api "repos/$upstream/releases/latest" --jq '.published_at[0:10]')

git remote get-url upstream >/dev/null 2>&1 \
  || git remote add upstream "https://github.com/$upstream.git"
git fetch --quiet --tags upstream

pending=1
if git merge-base --is-ancestor "$latest" HEAD; then pending=0; fi

if [ "$pending" = 0 ] && [ "${FORCE:-false}" != "true" ]; then
  echo "up to date: $latest is already merged"
  exit 0
fi

if [ "$pending" = 1 ]; then
  title="upstream $latest 릴리스: 병합 필요"
else
  title="[시험] upstream 릴리스 알림 ($latest 는 이미 병합됨)"
fi

# One issue per release: skip when an issue with this title exists, open or
# closed. The titles are read into a variable first, so a failed listing
# stops the script here instead of falling through to a duplicate issue.
if [ "$pending" = 1 ]; then
  titles=$(gh issue list --repo "$GITHUB_REPOSITORY" --state all --limit 500 \
    --json title --jq '.[].title')
  if grep -Fxq -- "$title" <<<"$titles"; then
    echo "already reported: $title"
    exit 0
  fi
fi

# The last upstream tag this branch contains, the files this fork changed
# since then, and the files upstream changed between that tag and the release.
base=$(git describe --tags --abbrev=0 HEAD)
mine=$(git diff --name-only "$base" HEAD -- . \
  ':(exclude).github/workflows' ':(exclude).github/scripts')
theirs=$(git diff --name-only "$base" "$latest")
overlap=$(comm -12 <(printf '%s\n' "$mine" | sort) <(printf '%s\n' "$theirs" | sort))
theirs_count=$(printf '%s\n' "$theirs" | grep -c . || true)

body=$(mktemp)
{
  if [ "$pending" = 1 ]; then
    echo "upstream(\`$upstream\`)에 새 릴리스 **$latest**가 나왔고, 이 포크에는 아직 병합되지 않았습니다."
  else
    echo "알림이 오는지 확인하려고 연 시험 이슈입니다. 지금 병합할 릴리스는 없습니다."
  fi
  echo
  echo "- 릴리스: $release_url ($published 게시)"
  echo "- 이 포크가 마지막으로 병합한 upstream 태그: \`$base\`"
  echo "- \`$base\`부터 \`$latest\`까지 upstream에서 바뀐 파일: ${theirs_count}개"
  echo
  echo "## 이 포크에서 고친 파일과 겹치는 변경"
  echo
  if [ -n "$overlap" ]; then
    echo "아래 파일은 이 포크에서도 고쳤고 upstream에서도 바뀌었습니다. 병합할 때 충돌이 납니다."
    echo
    printf '%s\n' "$overlap" | while IFS= read -r f; do
      stat=$(git diff --numstat "$base" "$latest" -- "$f" | awk '{print "+" $1 " -" $2}')
      echo "- \`$f\` (upstream $stat)"
    done
  else
    echo "이 포크에서 고친 파일은 이번 릴리스에서 바뀌지 않았습니다."
  fi
  echo
  echo "## 이 포크에서 고친 파일"
  echo
  if [ -n "$mine" ]; then
    printf '%s\n' "$mine" | sed 's/^/- `/; s/$/`/'
  else
    echo "없음"
  fi
  if [ "$pending" = 1 ]; then
    echo
    echo "## 병합 방법"
    echo
    echo '```'
    echo "git fetch upstream --tags"
    echo "git merge $latest"
    echo '```'
    echo
    echo "충돌이 나면 포크에서 고친 파일은 내 쪽을 유지하고, upstream 변경 중 가져올 것이 있는지는 릴리스 노트를 보고 정합니다."
  fi
} > "$body"

if [ -n "${DRY_RUN:-}" ]; then
  echo "TITLE: $title"
  cat "$body"
  exit 0
fi

gh issue create --repo "$GITHUB_REPOSITORY" --title "$title" \
  --body-file "$body" --assignee "$GITHUB_REPOSITORY_OWNER"
