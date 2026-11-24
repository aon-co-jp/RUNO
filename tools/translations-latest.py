#!/usr/bin/env python3
"""docs/ 内の *.md から、日本語以外の言語の「翻訳されている範囲の最新版」を拾い、
0-LATEST-TRANSLATIONS.md(docs ブランチの一番上に並ぶ名前)を作る。
Scans *.md in the given dir and builds 0-LATEST-TRANSLATIONS.md listing, per document and
language, the newest translated section found (even if older than the newest ja/en edit)."""
import re, sys, os, glob
d = sys.argv[1]
LANGS = [  # (code, 表示名, 見出しに含まれる語)
 ("en","English",["English"]),("zh-Hans","简体中文",["简体中文","Simplified"]),
 ("zh-Hant","繁體中文",["繁體中文","Traditional"]),("ko","한국어",["한국어"]),
 ("de","Deutsch",["Deutsch","German"]),("fr","Français",["Français","French"]),
 ("es","Español",["Español","Spanish"]),("pt","Português",["Português","Portuguese"]),
 ("ru","Русский",["Русский","Russian"]),("ar","العربية",["العربية","Arabic"]),
 ("fa","فارسی",["فارسی","Persian"])]
SUFFIX = {"German":"de","French":"fr","Spanish":"es","Portuguese":"pt","Russian":"ru","Arabic":"ar",
 "Persian":"fa","Korean":"ko","Chinese":"zh-Hans","English":"en","Japanese":"ja"}
DIG = str.maketrans("۰۱۲۳۴۵۶۷۸۹٠١٢٣٤٥٦٧٨٩", "01234567890123456789")
dated = re.compile(r"^##\s+(\d{4}-\d{2}-\d{2})")
head = re.compile(r"^#{3,4}\s+(.*)")
rows = []
for f in sorted(glob.glob(os.path.join(d, "*.md"))):
    name = os.path.basename(f)
    if name.startswith("0-LATEST") or name == "INSTALLERS.md": continue
    cur = ""; ja = ""; best = {}
    for line in open(f, encoding="utf-8", errors="replace"):
        line = line.translate(DIG)
        m = dated.match(line)
        if m:
            cur = m.group(1); ja = max(ja, cur); continue
        h = head.match(line)
        if h and cur:
            t = h.group(1)
            for code, _, keys in LANGS:
                if any(k in t for k in keys): best[code] = max(best.get(code, ""), cur)
    m = re.match(r".*?-(\w+)\.md$", name)
    if m and m.group(1) in SUFFIX:
        best.setdefault(SUFFIX[m.group(1)], "(file)")
    if best or ja: rows.append((name, ja, best))
out = ["# Latest translations / 翻訳されている範囲の最新版", "",
 "日本語・英語が常に最新の版です。ほかの言語は毎回は翻訳せず、翻訳済みの範囲の最新版を下に示します(最新の編集より古いことがあります。AI翻訳・ネイティブ確認前)。",
 "Japanese and English are always the newest. Other languages are not translated every time; this lists the newest translated section found (it may lag behind the latest edit; AI-translated, not yet native-checked).", ""]
for name, ja, best in rows:
    out += [f"## {name}", "", f"- 日本語 / ja: {ja or '-'} (latest)"]
    for code, label, _ in LANGS:
        v = best.get(code)
        out.append(f"- {label} / {code}: {v if v else 'not yet / まだ'}" + ("" if not v or v==ja else f" (older than {ja})" if ja and v!="(file)" else ""))
    out.append("")
open(os.path.join(d, "0-LATEST-TRANSLATIONS.md"), "w", encoding="utf-8").write("\n".join(out))
print("\n".join(out))
