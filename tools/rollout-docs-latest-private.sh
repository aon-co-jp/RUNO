#!/usr/bin/env bash
# 全非公開リポジトリ(アーカイブ除く)へ docs-latest.yml を配る。既にあれば内容が違うときだけ更新。
# Rolls docs-latest.yml out to every private non-archived repo; updates only when content differs.
set -u
ORG=aon-co-jp; F="$(dirname "$0")/docs-latest.yml"; P=.github/workflows/docs-latest.yml
B64=$(base64 -w0 "$F"); LOCAL=$(git hash-object "$F")
gh repo list $ORG --limit 500 --json name,visibility,isArchived,defaultBranchRef -q '.[]|select(.visibility=="PRIVATE" and (.isArchived|not))|[.name,.defaultBranchRef.name]|@tsv' | tr -d '\r' | while IFS=$'\t' read -r n br; do
  [ -z "$br" ] && { echo "skip(empty) $n"; continue; }
  sha=$(gh api "repos/$ORG/$n/contents/$P?ref=$br" -q .sha 2>/dev/null </dev/null || true)
  if [ -n "$sha" ] && [ "$sha" = "$LOCAL" ]; then echo "same $n"; continue; fi
  args=(-f message="ci: mirror latest top-level .md and list latest installers (docs branch)" -f content="$B64" -f branch="$br")
  [ -n "$sha" ] && args+=(-f sha="$sha")
  if gh api -X PUT "repos/$ORG/$n/contents/$P" "${args[@]}" >/dev/null 2>/tmp/ro.err </dev/null; then echo "ok   $n ($br)"; else echo "FAIL $n: $(head -c 120 /tmp/ro.err)"; fi
  sleep 1
done
