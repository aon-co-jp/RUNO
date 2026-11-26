# Rust化の対象一覧 / Rustify inventory (2026-11-26)

指示(ユーザー): 脆弱性が出にくいよう、Rust でない言語は Rust 化する。
取得方法: `gh repo list aon-co-jp` 164件 → `gh api repos/aon-co-jp/<r>/languages`(GitHub の言語バイト数。行数ではなく KB)。Rust・Markdown 以外を持つ 102 件を下に並べた(多い順)。

## 優先順と判断(初版。本番稼働・外部入力は既存の記録から判断、未実測の項目は「要確認」)
| 優先 | リポジトリ | 非Rust部分 | 本番 | 外部入力 | Rust化の判断 |
|---|---|---|---|---|---|
| 1 | audiocafe-tokyo-php | PHP 1.7MB | VPS(audiocafe.tokyo の一部ページ・cron の `--cron-tech`) | 受ける | **対象**。Rust 版 `audiocafe-tokyo-rust` が既にありトップは Rust。残る PHP の経路を洗い出して Rust 版へ移す |
| 2 | old.aon.tokyo | PHP・Python | 要確認(aon.tokyo は Rust で TOP 404) | 要確認 | 本番で動いていなければ対象外(凍結)、動いていれば移植 |
| 3 | aruaru-db-archive | PHP 439KB | 非公開・保管用 | 受けない見込み | 要確認(保管データなら対象外) |
| 4 | 2FastAPI・MFastAPI・2MFastAPI・2Poem・2RPoRea・RMojo・Java_to・pl2pl | Python | 配布物(CLI) | ローカル | **並行担当あり**。重ならないよう各担当へ委ねる。MFastAPI は Python 構文互換が仕様なので Python 部分は残す |
| 5 | open-network-amp・open-av-amp・ftp-auto-sync・OnlineTimeRecorder | Python | 手元/配布 | 一部(ネットワーク) | 対象(ネットワークに出るものから) |
| 6 | open-vsc-claude・2FastAPI-VSC | TS/JS | VS Code 拡張 | — | **不可**(VS Code 拡張は JS 必須) |
| — | 各 Kotlin/Java/Swift(Android/iOS) | Kotlin 等 | 端末アプリ | — | **不可**(UI 層。中身は既に Rust の .so) |
| — | HTML/CSS/ブラウザ JS(maid-cafe-*・open-english・Reaxt 等) | JS | ブラウザ | — | **不可**(ブラウザ上。WASM 化は個別検討) |
| — | Shell・PowerShell・Inno Setup・NSIS・Makefile・Dockerfile | 構築用 | 構築のみ | 受けない | 対象外(ビルド・インストーラー) |
| — | whisper.cpp | C/C++ | 第三者フォーク | — | **不可**(フォーク。Rust 版は `rs-whisper` で別途) |
| — | HLSL/GLSL/Cuda/Metal | シェーダー | — | — | 不可(GPU 言語) |
| — | COBOL・Mojo(pl2pl・RPoRea 等) | 変換元サンプル/バインディング | — | — | 不可(変換対象の見本・他言語向け入口) |

## 進捗
- 2026-11-26: 一覧作成(`bb812d3`)。
- 2026-11-26: **優先1の一部を完了** — audiocafe.tokyo の多言語ページ51本(`/aruaru/`・`/aruaru-lady/`・`/rakuten-mobile/` の `index-<言語>.php`)を audiocafe-tokyo-rust へ移植(`be24174`)。本番でPHP版とバイト一致・経路を4401→4400へ切り替え・PHPへのアクセス0を実測。*51 multilingual pages ported, byte-identical, production switched.*
- 未了(優先1の残り): トップ `/index.php`(8,382行)、残り全部を受ける経路(4401)、`aruaru/cron.php`・`aruaru-lady/cron.php`(毎朝)。これらが済むまで `audiocafe-php-legacy`・`audiocafe-cron-php` は止めない。*Remaining: top /index.php, the catch-all route and the two daily cron.php jobs; the PHP services stay until then.*

## English summary
Inventory of 102 repositories with non-Rust code (GitHub language bytes, not line counts). Priority 1 is the PHP still running for audiocafe.tokyo; Python CLIs are owned by parallel sessions; browser JS, Android/iOS UI, VS Code extensions, build scripts, shaders, the whisper.cpp fork and COBOL/Mojo samples cannot or need not be ported. Status: inventory only, nothing ported yet.

## 全件(非Rust の上位5言語)
| リポジトリ | 種別 | Rust | 非Rust |
|---|---|---|---|
| whisper.cpp | fork public | 0KB | C++ 13105KB, C 7545KB, Cuda 2279KB, Metal 662KB, GLSL 378KB |
| maid-cafe-tokyo |  public | 1109KB | JavaScript 2305KB, HTML 679KB, Kotlin 126KB, CSS 86KB, Shell 58KB |
| open-english |  public | 676KB | JavaScript 2305KB, HTML 591KB, Kotlin 126KB, CSS 86KB, Shell 53KB |
| maid-cafe-english |  public | 681KB | JavaScript 2292KB, HTML 591KB, Kotlin 126KB, CSS 78KB, Shell 47KB |
| open-english-pc |  public | 0KB | JavaScript 2224KB, HTML 574KB, CSS 81KB, Kotlin 61KB, Shell 0KB |
| audiocafe-tokyo-php |  public | 0KB | PHP 1752KB, HTML 442KB, CSS 6KB, Shell 1KB |
| open-network-amp |  public | 0KB | Python 1142KB, HTML 24KB |
| old.aon.tokyo |  public | 0KB | HTML 523KB, PHP 269KB, Python 118KB, CSS 18KB, JavaScript 4KB |
| aruaru-db-archive |  private | 843KB | PHP 439KB, HTML 388KB |
| open-av-amp |  public | 0KB | Python 656KB, HTML 26KB |
| open-media |  public | 601KB | JavaScript 289KB, HTML 129KB, Kotlin 69KB, NSIS 31KB, Shell 13KB |
| open-aruaru |  public | 979KB | TypeScript 125KB, PowerShell 85KB, HTML 68KB, Shell 44KB, JavaScript 23KB |
| aruaru-db |  public | 1225KB | TypeScript 205KB, Python 22KB, Java 16KB, Kotlin 16KB, Mojo 14KB |
| 2FastAPI |  public | 0KB | Python 257KB, HTML 25KB, Shell 7KB, PowerShell 5KB, Inno Setup 1KB |
| MFastAPI |  public | 72KB | Python 99KB, Mojo 50KB, Shell 30KB, HTML 30KB, C 15KB |
| open-vsc-claude |  public | 0KB | JavaScript 116KB, TypeScript 106KB, HTML 0KB |
| ftp-auto-sync |  public | 0KB | Python 213KB, PowerShell 2KB, Inno Setup 1KB, Batchfile 0KB |
| RS-Sync |  public | 397KB | HTML 137KB, Kotlin 29KB, Inno Setup 5KB, Shell 3KB, PowerShell 3KB |
| pl2pl |  public | 762KB | HTML 70KB, Shell 27KB, COBOL 21KB, Python 18KB, PHP 10KB |
| open-web-server |  public | 1052KB | Kotlin 118KB, Shell 17KB, Swift 10KB, PowerShell 8KB, Inno Setup 6KB |
| maid-cafe-se |  public | 293KB | Kotlin 109KB, PowerShell 20KB, JavaScript 11KB, Shell 9KB, HTML 8KB |
| audiocafe-tokyo-rust |  public | 555KB | HTML 158KB, Python 5KB, JavaScript 2KB |
| open-easy-web |  public | 805KB | Shell 57KB, Kotlin 54KB, PowerShell 20KB, HTML 16KB, Inno Setup 6KB |
| 2Poem |  public | 0KB | Python 132KB |
| open-backup |  public | 156KB | HTML 96KB, Java 7KB, PowerShell 4KB, Inno Setup 2KB, Shell 0KB |
| maid-cafe-programming-school |  public | 0KB | TypeScript 84KB, HTML 17KB |
| realdata.pro |  public | 427KB | HTML 87KB, Shell 1KB, PowerShell 1KB |
| aruaru-IME |  public | 846KB | Java 23KB, Shell 21KB, PowerShell 16KB, C++ 9KB, HTML 5KB |
| 360-speaker |  public | 58KB | HTML 85KB, Shell 1KB |
| aon-tokyo |  public | 5KB | HTML 77KB, CSS 0KB |
| open-redmine |  public | 422KB | JavaScript 30KB, HTML 21KB, Kotlin 16KB, Inno Setup 3KB, PowerShell 2KB |
| RMojo |  public | 156KB | HTML 29KB, Python 23KB, Shell 7KB, PowerShell 2KB, Inno Setup 2KB |
| 2RPoRea |  public | 0KB | Python 67KB |
| aruaru-llm |  public | 960KB | Kotlin 18KB, Shell 17KB, HTML 13KB, PowerShell 9KB, Inno Setup 7KB |
| open-bar |  public | 288KB | JavaScript 38KB, HTML 13KB, CSS 5KB, Shell 4KB |
| RPoRea |  public | 40KB | HTML 41KB, Python 7KB, C 4KB, Mojo 3KB, Shell 2KB |
| webeditor-sftp |  public | 69KB | TypeScript 43KB, JavaScript 9KB, HTML 5KB, CSS 3KB |
| RS-Ops |  public | 111KB | HTML 52KB, Inno Setup 3KB, PowerShell 2KB, Shell 1KB |
| open-directx |  public | 831KB | HLSL 43KB, PowerShell 15KB |
| open-gitea |  public | 212KB | JavaScript 25KB, HTML 17KB, PowerShell 7KB, Shell 5KB, Inno Setup 2KB |
| 2MFastAPI |  public | 0KB | HTML 30KB, Python 28KB, Shell 0KB |
| RPoem |  public | 1994KB | HTML 19KB, Kotlin 16KB, Shell 7KB, Inno Setup 4KB, Makefile 3KB |
| OnlineTimeRecorder |  public | 0KB | Python 26KB, HTML 22KB, CSS 5KB |
| pdf-r2l-rs |  public | 74KB | Kotlin 34KB, PowerShell 5KB, HTML 4KB, Shell 4KB, Inno Setup 2KB |
| Reaxt |  public | 332KB | HTML 45KB, JavaScript 4KB |
| 2FastAPI-VSC |  public | 0KB | HTML 23KB, TypeScript 12KB, Python 6KB, JavaScript 4KB, Shell 0KB |
| aruaru.tokyo |  public | 603KB | HTML 28KB, JavaScript 10KB, CSS 7KB |
| runo.tokyo |  public | 141KB | HTML 26KB, JavaScript 6KB, CSS 5KB, Inno Setup 3KB, PowerShell 2KB |
| pdf-r2l-win |  public | 72KB | Kotlin 33KB, PowerShell 5KB, Shell 4KB, Inno Setup 2KB |
| pdf-r2l-script-win |  public | 72KB | Kotlin 33KB, PowerShell 5KB, Shell 4KB, Inno Setup 2KB |
| open-mirror |  public | 0KB | HTML 20KB, Shell 18KB, PowerShell 1KB, Python 1KB |
| dream-os |  public | 191KB | Shell 22KB, PowerShell 12KB, Kotlin 2KB, JavaScript 1KB, Batchfile 0KB |
| RS-Red |  public | 183KB | JavaScript 21KB, HTML 11KB, PowerShell 2KB, Shell 2KB |
| rs-link-fusion |  public | 96KB | Kotlin 16KB, HTML 7KB, PowerShell 4KB, Shell 3KB, Inno Setup 3KB |
| open-cosmo |  public | 1597KB | HTML 18KB, Shell 7KB, Makefile 3KB, Inno Setup 2KB, PowerShell 2KB |
| open-cg-cad |  public | 325KB | HTML 34KB |
| open-raid-z |  public | 739KB | HLSL 11KB, Shell 8KB, HTML 3KB, PowerShell 3KB, Inno Setup 3KB |
| Java_to |  public | 247KB | Python 18KB, Java 6KB, Shell 5KB, Inno Setup 2KB |
| open-cuda |  public | 891KB | HLSL 17KB, HTML 4KB, PowerShell 3KB, Batchfile 2KB, Shell 2KB |
| poem-runo |  public | 387KB | TypeScript 23KB, HTML 3KB, Makefile 2KB, Dockerfile 1KB |
| RS-Node.js |  public | 78KB | JavaScript 26KB, Shell 0KB, TypeScript 0KB |
| rsa-rs |  public | 119KB | Shell 26KB |
| COBOL_to |  public | 232KB | COBOL 20KB, Inno Setup 2KB, Shell 2KB |
| version-control |  public | 147KB | Shell 13KB, HTML 10KB, Batchfile 0KB |
| RUNO |  public | 0KB | Python 17KB, Shell 7KB |
| aon.tokyo |  public | 0KB | HTML 16KB, CSS 6KB |
| karu-tokyo |  public | 1KB | HTML 19KB, CSS 0KB |
| fuser-android |  public | 374KB | Shell 11KB, Makefile 3KB, Dockerfile 2KB |
| sftp-git |  public | 68KB | TypeScript 8KB, JavaScript 8KB |
| aruaru |  public | 340KB | PowerShell 12KB, Shell 2KB |
| aruaru-search |  public | 172KB | HTML 10KB, Shell 3KB, PowerShell 1KB |
| rs-whisper |  public | 49KB | C++ 7KB, Shell 3KB, Python 2KB |
| open-runo |  public | 1087KB | HTML 6KB, Makefile 3KB, Dockerfile 1KB, Inno Setup 1KB |
| RS-Blog |  public | 106KB | HTML 4KB, Inno Setup 3KB, PowerShell 2KB, Shell 2KB |
| RS-EC |  public | 156KB | HTML 4KB, Inno Setup 3KB, PowerShell 2KB, Shell 2KB |
| tract-onnx-patch |  public | 0KB | Python 11KB |
| open-kagaku |  public | 54KB | HTML 10KB |
| open-upstream-watch |  public | 134KB | JavaScript 7KB, CSS 2KB, HTML 0KB |
| RS-Guard |  public | 66KB | Inno Setup 3KB, HTML 2KB, PowerShell 2KB, Shell 1KB |
| pdf-r2l-script-android |  public | 3KB | Kotlin 6KB, Shell 0KB, PowerShell 0KB |
| pdf-r2l-android |  public | 3KB | Kotlin 6KB, Shell 0KB, PowerShell 0KB |
| dentaku |  public | 0KB | HTML 3KB, JavaScript 1KB |
| OnlineTimeRecorder2 |  public | 0KB | Python 5KB |
| aruaru-jobs |  public | 4KB | JavaScript 2KB, HTML 1KB, CSS 0KB |
| open-raid-z-installer |  public | 46KB | CSS 3KB, PowerShell 1KB, HTML 0KB |
| open-cpu |  public | 152KB | HTML 4KB |
| open-audio-sr |  public | 11KB | Python 2KB, Shell 1KB |
| open-music-llm |  public | 0KB | Python 3KB |
| aruaru-web |  public | 13KB | HTML 3KB |
| vps-tidy |  public | 76KB | PowerShell 2KB |
| open-github-backup |  private | 0KB | Shell 2KB |
| backup-to-discord-by-github |  public | 152KB | PowerShell 1KB |
| pdf-r2l-script-mac |  public | 8KB | Shell 1KB, PowerShell 0KB |
| nameandemail |  public | 0KB | HTML 1KB |
| rs-kokoro-ja |  public | 42KB | Python 1KB |
| pdf-r2l-mac |  public | 7KB | Shell 1KB, PowerShell 0KB |
| RS-TypeScript |  public | 103KB | TypeScript 1KB |
| rs-xorriso |  public | 15KB | PowerShell 1KB |
| rs-FFmpeg |  public | 15KB | PowerShell 1KB |
| aruaru.pro |  public | 121KB | Shell 0KB |
| pdf-r2l-script-linux |  public | 8KB | Shell 0KB, PowerShell 0KB |
| pdf-r2l-linux |  public | 7KB | Shell 0KB, PowerShell 0KB |
