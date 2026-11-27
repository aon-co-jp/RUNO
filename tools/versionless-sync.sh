#!/usr/bin/env bash
# aon-co-jp の全リポジトリ(新規含む)の CLAUDE.md・README.md・PORTING.md・POLICY.md に、tools/sections/*.md の方針
# (Versionless・REST全廃・完成まで作り切る)を足す。CLAUDE.md は無ければ作る。ほかは既にあるものだけ。
# 各節の最初の空でない行を目印にし、無い節だけ足す。記載済みなら何もしない(冪等)。DRY_RUN=1 なら書かずに一覧だけ。
# Adds the policy sections to CLAUDE.md, README.md, PORTING.md and POLICY.md of every repo; idempotent.
set -u
ORG="${ORG:-aon-co-jp}"; HERE="$(cd "$(dirname "$0")" && pwd)"; SECDIR="$HERE/sections"
FILES="${SYNC_FILES:-CLAUDE.md README.md PORTING.md POLICY.md}"
MSG=$'docs: API方針(Versionless・REST全廃など)を追記(日英、自動)\n\nCo-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>'
T="$(mktemp -d)"; fail=0; upd=0; skip=0
gh api --paginate "user/repos?affiliation=owner&per_page=100" \
  --jq '.[] | select(.owner.login=="'"$ORG"'" and .archived==false and .disabled==false) | [.name,.default_branch,(.size|tostring)] | @tsv' > "$T/repos.tsv" || { echo "list failed"; exit 1; }
while IFS=$'	' read -r r b size; do
  [ -z "$b" ] && { echo "$r skip(empty)"; skip=$((skip+1)); continue; }
  for f in $FILES; do
    sha=$(gh api "repos/$ORG/$r/contents/$f?ref=$b" --jq .sha 2>/dev/null)
    if [ -n "$sha" ]; then
      gh api "repos/$ORG/$r/contents/$f?ref=$b" -H "Accept: application/vnd.github.raw" > "$T/old.md" 2>/dev/null
      extra=(-f sha="$sha")
    elif [ "$f" = "CLAUDE.md" ]; then
      printf '# CLAUDE.md
' > "$T/old.md"; extra=()
    else
      continue
    fi
    cp "$T/old.md" "$T/new.md"; added=0
    for sec in "$SECDIR"/*.md; do
      mark=$(grep -m1 -v '^[[:space:]]*$' "$sec")
      grep -qF -- "$mark" "$T/old.md" && continue
      cat "$sec" >> "$T/new.md"; added=$((added+1))
    done
    [ "$added" -eq 0 ] && { skip=$((skip+1)); continue; }
    if [ "${DRY_RUN:-0}" = 1 ]; then echo "$r/$f would-update($added)"; upd=$((upd+1)); continue; fi
    base64 -w0 "$T/new.md" > "$T/b64"
    if gh api -X PUT "repos/$ORG/$r/contents/$f" -f message="$MSG" -F content=@"$T/b64" -f branch="$b" "${extra[@]}" >/dev/null 2>"$T/err"; then
      echo "$r/$f updated($added)"; upd=$((upd+1))
    else echo "$r/$f FAIL $(head -c 160 "$T/err")"; fail=$((fail+1)); fi
  done
done < "$T/repos.tsv"
echo "done: updated=$upd skipped=$skip failed=$fail"
[ "$fail" -eq 0 ]