#!/usr/bin/env bash
# 配布で失敗したものの再試行: 409なら現在のshaで、404(ファイル無し)ならshaなしで書く。
# Retry for failures: on 409 use the current blob sha; on 404 (file absent) write without sha.
set -u
ORG=aon-co-jp; P=.github/workflows/docs-latest.yml; F="$(dirname "$0")/docs-latest.yml"
B64=$(base64 -w0 "$F"); LOCAL=$(git hash-object "$F")
grep '^FAIL ' "$1" | sed 's/^FAIL \([^:]*\):.*/\1/' | while read -r n; do
  br=$(gh api "repos/$ORG/$n" -q .default_branch </dev/null)
  cur=$(gh api "repos/$ORG/$n/contents/$P?ref=$br" -q .sha </dev/null 2>/dev/null || true)
  if [ "$cur" = "$LOCAL" ]; then echo "same $n"; continue; fi
  args=(-f message="ci: mirror latest top-level .md and list latest installers (docs branch)" -f content="$B64" -f branch="$br")
  [ -n "$cur" ] && args+=(-f sha="$cur")
  if gh api -X PUT "repos/$ORG/$n/contents/$P" "${args[@]}" >/dev/null 2>/tmp/rr.err </dev/null; then echo "ok   $n"; else echo "FAIL $n: $(head -c 120 /tmp/rr.err)"; fi
  sleep 1
done
