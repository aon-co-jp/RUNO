# 開発方針＆開発環境ルール(RUNO)

作業ドライブは`F:\runo`。本リポジトリ自身のローカルcloneは`F:\runo`直下
(サブディレクトリ無し)。この節は
[`open-raid-z`](https://github.com/aon-co-jp/open-raid-z)の
`CLAUDE.md`を**正本**とし、各プロジェクトへコピーして同期する既存の
運用ルール継承方針に準じる(比較的新しいフレームワークの参照資料一覧・
AI駆動開発ツールに関する所感・確認不要の自動継続/リミット解除後の
自動再開・白画面バグ等を見逃さない検証徹底、等の全リポジトリ共通ルールは、
詳細をここに複製せず`open-raid-z/CLAUDE.md`を参照すること)。

## このリポジトリの役割

**このリポジトリは`aon-co-jp`エコシステム全体のメタ索引であり、
個別のコード実装は持たない。** `aon-co-jp` organization配下に分散する
各プロジェクト(RCosmo/RFrontEnd/RPoem/aruaru-db/aruaru-llm/aruaru-tokyo/
aruaru-vpn/audiocafe-tokyo-rust/audiocafe.tokyo/e-gov.info/karu.tokyo/open-cuda/
open-directx/open-easy-web/open-english(ジャンル: 学習/Study)/
open-raid-z/open-tv-chat/open-LiveKit/open-web-server/rs-dpiAwareness/rs-to-readme等)への
入口(README・PORTING.md・CLAUDE.md・役割の要約)を、`README.md`に一箇所へ
まとめて掲載することだけを目的とする。

- コードを書く場合でも、それはこのリポジトリ自身のビルド設定
  (CI等)や索引生成補助スクリプトの範囲にとどめ、各プロジェクトの
  実装そのものをこのリポジトリへ移植・複製しないこと。
- 索引内容(プロジェクト一覧・リンク・役割説明)は、各プロジェクトの
  実際のREADME.md/CLAUDE.mdの記載に基づいて記述し、推測で埋めないこと。
  プロジェクトが増減した場合はこの`README.md`を更新する。
- 同じ内容を表示するWebページ実装が
  [`aruaru-tokyo`](https://github.com/aon-co-jp/aruaru-tokyo)側
  (`/open-aruaru-runo-iLumi`、エイリアス`/open-aruaru-runo`)に存在する。
  索引の内容(プロジェクト一覧)を変更する際は、両リポジトリ間で
  記載内容が乖離しないよう注意する(自動同期の仕組みは無いため、
  手動で追従させる)。


## UI・インストーラーの品質ルール(全リポジトリ共通)

GUI・Android アプリ・インストーラーを作る/変更するときの試験ルール(複数の解像度・縦横・文字サイズでの確認、主要ボタンの画面下固定、
実データでの通し試験、インストール/アンインストール試験)は、正本の[`open-raid-z/CLAUDE.md`](https://github.com/aon-co-jp/open-raid-z)
「運用ルール」節に追記した。試験スクリプトとチェックリストは[`pdf-r2l-rs`](https://github.com/aon-co-jp/pdf-r2l-rs)の
`scripts/ui-test/`・`docs/UI-TEST-CHECKLIST.md`(2026-10-10)。
## GitHub organization

https://github.com/aon-co-jp

## 複数リポジトリ横断セッションチェックポイント

`F:\runo`ローカル作業ドライブでの複数リポジトリ横断セッション
(open-redmine・rs-sync・open-easy-web等をまたぐ作業)の直近の到達点・
次回再開ポイントは、このリポジトリの[`PORTING.md`](PORTING.md)内
「複数リポジトリ横断セッションチェックポイント」節でホストする
(このリポジトリ本来の役割=エコシステム全体のメタ索引とは別目的の
追加コンテンツであり、索引一覧表〈README.md〉自体の構成・内容には
影響しない)。

## HANDOFF
- **2026-11-20 aruaru-IME v0.2.29 公開(人名の候補) / aruaru-IME v0.2.29 released (given names)**: よく使う人名(正浩・浩)を最有力の次の上位3つに出し、辞書に無い名前も名前の部品(まさ+ひろ、たか+のぶ)から作って必ず候補に出す(`aruaru-IME/crates/aruaru-ime-core/src/names.rs`)。試験207件成功、CI全14ジョブ成功、Release 10ファイル、VPSのエンジン(`.bak-20261120c`)・配布ファイル・紹介ページを v0.2.29 に更新。**未了**: このPCはアンインストール直後の再インストールが再起動待ち(次のサインインで自動インストールを予約、結果は`aruaru-IME/dist/installer-e2e.log`)。*Common given names now rank in the top 3, unknown names are composed from name parts; released and deployed. Open: this PC's re-install runs at the next sign-in.*
- **2026-11-19 世界情勢Q&Aの類義語検索・学習機能・本番反映(別アカウントでの再開用) / News Q&A similar-word search, learning, deployed**: **日本語**: 保存記事に合うものが無いとき、類義語(戦争→紛争など)で探し直す機能を `maid-cafe-english`(`server/src/news_qa.rs`、`769c085`)に追加しました。数字を含む質問では広げず、足す語は最大8語です。回答できなかった質問の学習は**既定OFF**で、インストールした本人のPC(localhost)から `learn=1` を付けたときだけ、言葉と回数だけを保存します(質問文は保存せず、公開サーバーでは動きません。実測済み)。VPS(`open-english` と `open-english-demo`)へ差し替え済みで、maid-cafe.tokyo は200・エラーログ0です。同日、`rs-sync.service` のSMTPパスワードを `/etc/rs-sync.env`(権限600)へ移しました。**未了**: 学習をONにする画面、localhostでの記録の通し確認、類義語表の拡張、`open-english` リポジトリへの取り込み(VPSのクローンに未コミットのパッチあり、`git pull` 前に確認)、RS-Syncの実スマホQR・実SMTPの通し。詳細と貼り付け用メッセージは `maid-cafe-english` の `PORTING.md` 末尾と[`PORTING.md`](PORTING.md)末尾(日英)。 **English**: When no saved article matches, the app now searches again with similar words (for example, war and conflict) in `maid-cafe-english` (`server/src/news_qa.rs`, `769c085`). It does not widen questions that contain numbers, and adds at most 8 words. Learning from unanswered questions is **off by default**: it works only on the installer's own PC (localhost) with `learn=1`, and saves only words and counts (never the question text; it does not run on public servers, which we checked). The VPS programs (`open-english`, `open-english-demo`) are swapped; maid-cafe.tokyo returns 200 with no errors. On the same day the SMTP password of `rs-sync.service` moved to `/etc/rs-sync.env` (mode 600). **Open**: a screen to turn learning on, a real localhost check, a bigger similar-word table, moving the change into the `open-english` repository (the VPS clone has uncommitted patches, so check before `git pull`), and the RS-Sync real-phone QR and real-SMTP tests. Details and the paste-ready message are at the end of `maid-cafe-english`'s `PORTING.md` and of [`PORTING.md`](PORTING.md).
- **2026-11-19 残り作業の確認 / Checking what is left**: aruaru-llmの遅延は解消(VPS 4サービスactive・負荷低・エラー0)。残り=maid-cafe-tokyoの「答えられないとき補完」(未着手)、RS-Syncのスマホ実QR・実メール`otp_qr`(ユーザー操作が必要)・`login_mode`永続化・SMTPパスワード移設、version-control実要約の確認。やさしい説明と日英の貼り付け用メッセージは[`PORTING.md`](PORTING.md)末尾。*aruaru-llm slowness is gone (4 VPS services active, low load, 0 errors). Open: maid-cafe-tokyo answer fallback (not started), RS-Sync real-phone QR / real-email `otp_qr` (need the user), `login_mode` persistence, SMTP password move, a real version-control summary. Plain-language notes and the JA/EN paste-ready message are at the end of PORTING.md.*
- **2026-11-18 aruaru-llm Generate遅延の解消・本番反映(別アカウントでの再開用)**: 原因は(1)小さな行列積・softmaxのrayon並列化(1トークン約1秒)と(2)長い知識文脈のプレフィル。open-cuda `480718f`を`main`へpushし、aruaru-llm(プロンプト64トークン上限`4805563`込み)をバックアップ`aruaru-llm.before-gemmfix-20261118`付きでVPSへ差し替え済み。本番(4コア)は8トークン6.0秒・48トークン22.8秒・エラーログ0(修正前は150秒超)。**未了**: version-controlの実際の要約呼び出し(`llm_timeout_secs=45`)の確認、VPSの`/root/aruaru-llm`ソースは未更新(バイナリのみ)、作業用`F:\_work\llm-fix`・`llm-cm`・`gt*.sh`/`b*.sh`は未削除。スマホ実機のテストは行わない(ユーザー指示)。再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-18 aruaru-llm Generate遅延の解消・本番反映」。
- **2026-11-18 open-web-server 2FA統合の本番反映・loopback切替の残り(別アカウントでの再開用) / 2FA production swap, loopback pending (resume on another account)**: **日本語**: 2FA統合は`main`(`27dcd7c`)・本番(2026-11-09、本番機能セット`admin-2fa,domain-watchdog,fastcgi-client,ddns,sftp`)まで完了、テスト全成功、旧バイナリ`.before-main-20261109m`。**未了**: `STATIC_TOKEN_MODE=loopback`への切替は、本人のメールOTP+TOTPログイン→Bearerで`ListTenants`確認(設計書§8手順5)の後。それまで`any`。再開リポジトリ=`F:\open-web-server`・`F:\RPoem`・`F:\runo`。貼り付け用メッセージは[`PORTING.md`](PORTING.md)末尾(日英)。**English**: The 2FA integration is on `main` (`27dcd7c`) and in production (2026-11-09, production feature set); tests pass; rollback binary `.before-main-20261109m`. **Open**: the `loopback` switch, only after the owner's own e-mail OTP + TOTP login and a `ListTenants` check with the Bearer (design doc §8 step 5); keep `any` until then. Repos: `F:\open-web-server`, `F:\RPoem`, `F:\runo`. Paste-ready message at the end of PORTING.md (JA/EN).
- **2026-11-18 ログイン方式(otp/otp_qr/qr)とQR確認ログインの横展開(別アカウントでの再開用) / Login-mode rollout (resume on another account)**: 完了=open-english・open-easy-web(VPS反映済み)・RS-Blog・RS-EC・RS-Sync(`88a90b6`、本番未反映)。未了=RS-Syncの本番反映、実スマホでのQR撮影の通し試験、open-gitea・open-redmine(RS-Opsは全面RESTのため先にConnect化)。手元クローンは`origin/main`と分岐しているため`git pull`せず`F:
uno
epository\_work\`に新規clone。貼り付け用メッセージは[`PORTING.md`](PORTING.md)末尾(日英)。*Done: open-english, open-easy-web (deployed), RS-Blog, RS-EC, RS-Sync (not yet in production). Open: deploy RS-Sync, a real phone-camera QR test, open-gitea / open-redmine (RS-Ops needs Connect first). Local clones have diverged: work in fresh clones under `_work`. Paste-ready message at the end of PORTING.md (JA/EN).*
- **2026-11-18 別アカウントでの再開用(open-bar v0.1.1・tract-onnx-patch v0.1.0・open-media GPU版) / Resume on another account**: **日本語**: open-bar v0.1.1(deep-link・起動中表示・出だしノイズ対策)公開済み、easy-web.tokyoに紹介カード追加済み(`/open-bar/`)。新リポジトリ`tract-onnx-patch`v0.1.0公開済み。open-mediaのGPU版(ort/DirectML)はコンパイルと単体テスト成功。**未了**: open-barのインストーラーでの`openbar://`登録・自動起動・「起動中」表示の実機確認、open-mediaのGPU実推論(モデルのダウンロード許可待ち)、open-barの未コミット作業中変更(映像の位置補正)。再開リポジトリ=`F:\open-bar`・`F:\open-media`・`F:\tract-onnx-patch`・`F:\runo`。**English**: open-bar v0.1.1 and the new repo `tract-onnx-patch` v0.1.0 are released; the intro card is on easy-web.tokyo (`/open-bar/`); open-media's GPU build (ort/DirectML) compiles and passes unit tests. **Open**: real-machine check of `openbar://` registration, auto-launch and "running" status; GPU inference with the real model (download permission pending); open-bar's uncommitted video-offset work. Repos: `F:\open-bar`, `F:\open-media`, `F:\tract-onnx-patch`, `F:\runo`.
- **2026-11-18 SQLite(C依存)廃止・VPS反映 / Dropped C-based SQLite, deployed**: RPoem・open-web-serverからSQLiteを外し(libsqlite3-sysはsqlx制限で更新不能)、VPSのopen-web-serverとRPoemゲートウェイを差し替え済み。未了=ロックファイルの残り・DbMutate実書き込み確認。詳細は[`PORTING.md`](PORTING.md)末尾(日英)。
- **2026-11-17 全セッション統合の再開用メモ / Consolidated resume memo**: 未了の優先順(x-tenantの本番確認、aruaru-IMEの起動項目とメモ帳入力、open-gitea VPSクローンの分岐、RS-EC/RS-Blogの本番確認の残り、脆弱性メール分)と日英の貼り付け用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-17 全セッション統合の再開用メモ」。*Priority-ordered open items and the paste-ready JA/EN message are at the end of PORTING.md.*
- **2026-11-17 version-control通知(RUNO・aon.tokyo・bdg・rs-sync のクローン遅れ)の対応 / Clone-lag notice handled**: VPSの4クローンを`fetch`+`merge --ff-only`で最新化し、aon.tokyo・rs-sync・bdg・rs-sync-demoを再起動(全active、bdg旧版は`bdg-server.prev`)。**未了**: bdgのGitHub Webhook実受信の確認、VPS bdgの`Cargo.lock`未コミット差分の扱い、rs-sync/bdg自身の文書追記。再開するリポジトリ=`F:
uno`・VPSの`backup-to-discord-by-github`/`rs-sync`/`aon.tokyo`。貼り付け用メッセージは[`PORTING.md`](PORTING.md)末尾(日英)。*Four VPS clones fast-forwarded and four services restarted (all active; old bdg binary kept as `bdg-server.prev`). Open: a real webhook into bdg, the uncommitted `Cargo.lock` diff on the VPS bdg clone, per-repo notes. Paste-ready message at the end of PORTING.md (JA/EN).*
- **2026-11-17 aruaru-IMEインストーラーの管理者での入れ直し(別アカウントでの再開用) / aruaru-IME admin re-install (resume on another account)**: **日本語**: 2026-11-17 に `aruaru-IME` v0.2.23 のインストーラー(`F:\aruaru-IME\dist\aruaru-ime-windows-x86_64-setup.exe`、SHA256は同梱の`.sha256`と一致)を、常駐`aruaru-ime-daemon`を止めてから管理者権限で入れ直し、アンインストール情報に0.2.23が登録されたことを確認した。**未確認**: 入れ直し後に常駐エンジンが起動しているか、メモ帳等での実入力(変換)、残ったTSF DLLの扱い。**注意**: 手元の`aruaru-IME`のタグは`v0.2.23`だが、他の記録には`v0.2.25`(旧経路削除版)の公開とある。入れた版が最新かは未確認(`git fetch --tags`とGitHubのReleaseで要確認)。UAC・管理者操作は私(Claude)から承認できないので、再実行は本人が行う。 **English**: On 2026-11-17 the `aruaru-IME` v0.2.23 installer (`F:\aruaru-IME\dist\aruaru-ime-windows-x86_64-setup.exe`, SHA256 matches the bundled `.sha256`) was re-installed with administrator rights after stopping the resident `aruaru-ime-daemon`; 0.2.23 is registered in the uninstall list. **Unverified**: whether the resident engine is running after the re-install, real typing (conversion) in Notepad etc., and the leftover TSF DLL. **Note**: the local `aruaru-IME` tag is `v0.2.23` while other records mention `v0.2.25` (legacy routes removed) as released; check `git fetch --tags` and the GitHub Release to confirm the installed version is the latest. UAC/admin prompts cannot be approved by Claude, so any re-run is done by the owner. 再開するリポジトリ=`aruaru-IME`・`runo`。再開用メッセージは[`PORTING.md`](PORTING.md)末尾(日英)。
- **2026-11-17 pdf-r2l-rs再開用メモ / Resume memo**: v1.3.1、exe追加済み、未了と再開用メッセージは[`PORTING.md`](PORTING.md)末尾と`pdf-r2l-rs/PORTING.md`末尾(日英)。*v1.3.1 with installer exe; open items and resume message at the end of PORTING.md and pdf-r2l-rs/PORTING.md.*
- **2026-11-17 open-media公開ページ・トップ紹介カード(別アカウントでの再開用) / open-media public pages (resume on another account)**: `easy-web.tokyo/open-media/`(紹介・最新リリース自動表示)と`/demo/`、トップの紹介カードが公開済み(open-media docs `1eeec5c`・open-easy-web-app `6b01170`)。未了=CD再挿入でのopen-media優先の実機確認・DVD/Blu-ray実ディスク・macOS/Android TV実機・他の未紹介プロジェクトの紹介。再開リポジトリは`F:\open-media`・`F:\runo`。貼り付け用メッセージは[`PORTING.md`](PORTING.md)末尾(日英)とopen-mediaの`PORTING.md`末尾。 *open-media intro/demo pages and the top-page card are live; open: real-hardware checks (CD AutoPlay priority, DVD/Blu-ray, macOS, Android TV) and intro pages for other projects. Repos: `F:\open-media`, `F:\runo`. Paste-ready message at the end of both PORTING.md files.*

- **2026-11-17 version-control通知の依存更新(RS-Blog・RS-EC・karu.tokyo)の再開用メモ / Resume memo**: RustSec対応(h2/rustls/webpki/tokio)は完了・VPS反映済み、本番ログイン後の通し確認も済み。再開するリポジトリ=`F:\runo`・`F:RS-Blog`・`F:RS-EC`・`karu-tokyo`(新規clone)・`open-gitea`(分岐は未対処、触る前に確認)。貼り付け用メッセージは[`PORTING.md`](PORTING.md)末尾(日英)。*RustSec fixes done and deployed, authenticated production checks done; repos to resume: runo, RS-Blog, RS-EC, karu-tokyo (fresh clone), open-gitea (divergence untouched, ask first). Paste-ready message at the end of PORTING.md (JA/EN).*
- **2026-11-17 open-cosmo・RPoem・aruaru-db のREST全廃の仕上げ(別アカウントでの再開用) / Finishing REST abolition in open-cosmo, RPoem, aruaru-db (resume on another account)**: **日本語**: 3リポジトリとも自前RESTは0本(例外=SCIM・`/health`・ACME・`/mcp`・`/graphql`系・`/demo`のみ)。RPoemの`/internal/db/mutate`も`Admin/DbMutate`(Connect、`x-api-key`必須)へ移し、RPoem `781c824`・open-cosmo `132e300`・open-web-server `Ledger`(環境変数`OPEN_RUNO_API_KEY`)を同時変更。`cargo test`全成功、VPSで一時起動して新401/400/200・旧404、aruaru-dbは本番で旧404・新401を実測。**未了**: open-cosmo本体の本番起動の判断、`openapi.rs`の旧記述整理、`Ledger`を動かす環境の`OPEN_RUNO_API_KEY`確認。再開するリポジトリは`runo`・`RPoem`・`open-cosmo`・`open-web-server`・`aruaru-db`(新規clone)。貼り付け用の再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-17 別アカウントでの再開用メモ(open-cosmo・RPoem・aruaru-db …)」(日英)。 **English**: All three repositories have 0 own REST routes (exceptions only: SCIM, `/health`, ACME, `/mcp`, `/graphql` family, `/demo`). RPoem's `/internal/db/mutate` also moved to `Admin/DbMutate` (Connect, `x-api-key` required), with RPoem `781c824`, open-cosmo `132e300` and the open-web-server `Ledger` (env `OPEN_RUNO_API_KEY`) changed together. `cargo test` passes; verified on the VPS with a temporary run (new 401/400/200, old 404) and in production for aruaru-db (old 404, new 401). **Open**: whether to run open-cosmo itself in production, tidying `openapi.rs`, confirming `OPEN_RUNO_API_KEY` wherever a `Ledger` runs. Repos to resume: `runo`, `RPoem`, `open-cosmo`, `open-web-server`, `aruaru-db` (fresh clone). Paste-ready resume message at the end of [`PORTING.md`](PORTING.md) (JA/EN).
- **2026-11-17 RS-EC・RS-Blogの本番ログイン後の確認と再開用メモ(別アカウントでの再開用) / Production checks after login and resume memo**: **日本語**: 2026-11-08に本番VPSで管理者メールOTPログインし実呼び出しを確認(RS-Blog=Posts Create/Get/List/Delete・RS-EC=Products Create/Get/List/Delete+Cart/Get、いずれも200・削除後Get404・Logout 200、確認用データは削除済み)。本番にSMTPが無くOTPが送れなかったため、`rs-blog.service.d/20-smtp.conf`・`rs-ec.service.d/20-smtp.conf`(権限600、open-easy-webと同じLolipop SMTP)を追加した(open-redmineのGmail設定はGoogleに535で拒否)。**未了**: RS-Blog=Categories/Tags/Pages/Comments、RS-EC=Accounts/Categories/Favorites/Reviews/Cart/Orders(`Orders/Checkout`は本番に注文が1件残る)、両方のQRログイン・`otp_qr`(確認後は必ず`otp`へ戻す)。OTPは5分で失効し両サービスのメールが区別できないので1サービスずつ。再開するリポジトリは`RS-EC`・`RS-Blog`(どちらも新規clone)・`runo`。貼り付け用メッセージは各リポジトリのREADME/CLAUDE/PORTING末尾「2026-11-17 追記」(日英)と[`API-REST-REMAINING-20261106.md`](API-REST-REMAINING-20261106.md)末尾。 **English**: On 2026-11-08 I logged in on the production VPS with the admin e-mail OTP and made real calls (RS-Blog: Posts Create/Get/List/Delete; RS-EC: Products Create/Get/List/Delete + Cart/Get; all 200, Get after delete 404, Logout 200, test data deleted). Production had no SMTP, so drop-ins `rs-blog.service.d/20-smtp.conf` and `rs-ec.service.d/20-smtp.conf` (mode 600, same Lolipop SMTP as open-easy-web) were added (open-redmine's Gmail settings were rejected with 535). **Open**: RS-Blog Categories/Tags/Pages/Comments; RS-EC Accounts/Categories/Favorites/Reviews/Cart/Orders (`Orders/Checkout` leaves one order in production); the QR login and `otp_qr` for both (always restore `otp`). OTPs expire in 5 minutes and the two services' mails look alike, so one service at a time. Repos to resume: `RS-EC`, `RS-Blog` (fresh clones) and `runo`. Paste-ready messages are at the end of each repo's README/CLAUDE/PORTING ("2026-11-17 追記", JA/EN) and at the end of `API-REST-REMAINING-20261106.md`.
- **2026-11-17 aon.tokyo・backup-to-discord-by-githubのREST全廃判定(別アカウントでの再開用) / Classification done (resume on another account)**: 両リポジトリとも移す自前RESTは無し(aon.tokyo=全ルート例外、bdg=管理APIは`9066b60`でConnect化・本番反映済み、残りは`/healthz`とGitHub Webhookの例外)。本番実測・再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-17 再開用メモ: aon.tokyo・backup-to-discord-by-github…」(日英)。*Neither repo has own REST left (aon.tokyo all exceptions; bdg admin API on Connect and deployed, remaining `/healthz` and GitHub webhook are exceptions). Production checks and the resume message are at the end of PORTING.md (JA/EN).*
- **2026-11-17 maid-cafe-se v0.5.7の再検証・リリース本文更新(別アカウントでの再開用) / v0.5.7 re-verification (resume on another account)**: **日本語**: 添付7ファイルのハッシュ一致、APK/.aabは同一証明書、AppImageはWSLで起動しUI 200。Mac署名はAppleシークレット未登録で未実行。再開するリポジトリは`F:\maid-cafe-se`と`F:\runo`。貼り付け用メッセージは[`PORTING.md`](PORTING.md)末尾(日英)と`maid-cafe-se`の`PORTING.md`末尾。**English**: hashes of all 7 assets match; APK/.aab share one certificate; the AppImage starts under WSL (UI 200); Mac signing has not run (no Apple secrets). Repos: `F:\maid-cafe-se`, `F:\runo`. Paste-ready message at the end of [`PORTING.md`](PORTING.md) (JA/EN) and of maid-cafe-se's `PORTING.md`.
- **2026-11-15 easy-web.tokyoの製品紹介ページ(別アカウントでの再開用) / Product intro pages (resume on another account)**: 9製品の紹介・ダウンロードページが公開済み(`open-gitea`は`/open-gitea/intro/`、他は`/<repo>/`)。実体は各リポジトリの`webpage/index.html`、VPSは`/root/easy-web.tokyo/<repo>`+`<repo>-web.service`(ポート8131〜8139)+open-web-serverの`domains.toml`。**未了**: トップページへの製品カード、`open-raid-z`(管理UI・VPSクローンに未コミット変更あり、未着手)、リリース更新時のリンク/SHA-256の手動更新。再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-15 再開用メモ: easy-web.tokyo の製品紹介ページ」(日英)。*Nine product intro/download pages are live (open-gitea at /open-gitea/intro/). Open: top-page cards, open-raid-z (admin UI, VPS clone has uncommitted changes, untouched), manual link/SHA-256 updates on new releases. Resume message at the end of PORTING.md (JA/EN).*
- **2026-11-15 Ledger→RPoem接続の通し確認・別アカウントでの再開用 / Ledger→RPoem wiring verified, resume on another account**: **日本語**: RPoemゲートウェイはVPSで稼働中、open-web-serverに`OPEN_RUNO_API_KEY`を設定して再起動(5ドメイン200)、`Admin/DbMutate`の実書き込み(200+`db_commit_id`、同キー再送で冪等)を確認。**未了**: RS-EC注文・決済/QRログイン/`otp_qr`の本番確認(OTPは本人が入力)、open-cosmo本体を起動するかの判断、RPoemゲートウェイの再ビルド・差し替え(appserver系を含める)、`loopback`切替(2FA実通し後)、aruaru-IME実機、version-controlメール由来の依存更新。再開するリポジトリは`F:\runo`・`RPoem`・`open-web-server`・`open-cosmo`・`RS-EC`・`RS-Blog`・`aruaru-IME`。貼り付け用の再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-15 再開用メモ: Ledger→RPoem接続の通し確認と残り」(日英)。 **English**: The RPoem gateway runs on the VPS; open-web-server got `OPEN_RUNO_API_KEY` and was restarted (5 domains 200); a real `Admin/DbMutate` write was verified (200 + `db_commit_id`, idempotent resend). **Open**: RS-EC checkout / QR login / `otp_qr` in production (the owner types the OTP), whether to run open-cosmo itself, rebuilding and swapping the RPoem gateway (to include the appserver changes), the `loopback` switch (after a real 2FA login), aruaru-IME on a device, and dependency updates from the version-control e-mail. Repos to resume: `F:\runo`, `RPoem`, `open-web-server`, `open-cosmo`, `RS-EC`, `RS-Blog`, `aruaru-IME`. The paste-ready resume message is at the end of [`PORTING.md`](PORTING.md) ("2026-11-15 再開用メモ: Ledger→RPoem接続の通し確認と残り", JA/EN).
- **2026-11-17 RPoemゲートウェイのDB化・Ledger接続(別アカウントでの再開用) / Gateway DB persistence and Ledger wiring**: ゲートウェイは実鍵認証+専用aruaru-dbで稼働(`db_commit_id`返却を実測、本番aruaru-serverは無変更)。**未了**: aruaru-db修正ブランチ`fix/insert-quoted-values`(`1590750`)のmain未マージ、Android実機確認、Ledger実書き込みの通し確認。再開リポジトリ: RPoem・aruaru-db・open-web-server・open-raid-z・open-easy-web・`runo`。貼り付け用メッセージは[`PORTING.md`](PORTING.md)末尾(日英)。*Gateway runs with real key auth and a dedicated aruaru-db (`db_commit_id` verified, production untouched). Open: merge of the aruaru-db fix branch, Android device check, real Ledger write. Paste-ready message at the end of PORTING.md.*
- **2026-11-17 追記 RPoem「分身の術」ホスティング: 実プロセス通し確認の完了 / Real-process E2E done**: **日本語**: `open-web-server` の `tests/e2e_site_fleet.rs` で、`sites.toml` の process サイトを `site-fleet` で実プロセス起動→Host振り分け転送→同時接続上限503+Retry-After→crash復帰を実HTTPで確認(成功)。未了: hyper転送、段階3(別uid/cgroup/Isolator/PHP-FPM)、Admin Site* RPC、tenant分離、本番VPS反映。最新の再開用メッセージは`open-easy-web/CLAUDE.md`・`PORTING.md`末尾「2026-11-17 追記」。 **English**: `tests/e2e_site_fleet.rs` in `open-web-server` verifies over real HTTP that process sites from `sites.toml` start via `site-fleet`, route by Host, return 503 + Retry-After over the limit and recover from a crash (passes). Open: hyper forwarding, stage 3, Admin Site* RPCs, tenant isolation, production deploy. Latest resume message: end of `open-easy-web/CLAUDE.md` / `PORTING.md` ("2026-11-17 追記").
- **2026-11-17 RPoemゲートウェイのVPS反映(appserver系Connect化) / Gateway deployed**: 新Connect応答・旧404・DbMutate健在を実測、ロールバック用バイナリあり。未了=実プロセス起動の通し試験・open-easy-web反映確認・Ledger実書き込み。再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-17 追記」(日英)。*Gateway swapped on the VPS and verified; open: real process-start test, open-easy-web deploy check, real Ledger write. Resume message at the end of PORTING.md.*
- **2026-11-17 aruaru-db Web管理画面の白画面修正・admin.rs警告0(別アカウントでの再開用) / Admin web white-screen fixes, zero warnings**: **日本語**: aruaru-dbの`admin.rs`未使用警告を全て解消(`9a390b8`)。Web管理画面(aruaru-admin)は修正前に白画面で、4件(`serverBase`未定義・Tauriダイアログのvite解決・クラスタ応答の形式・対応DBの日本語ステータス)を直し、ローカルで全10画面・`CreateBackup`(token無し401/有り200)・旧REST 0を確認(`aca3fca`)。**未了**: `aruaru-db-admin-web`のVPS配備(本番は`web/`のデモUI)、`tsc`型エラー、ダッシュボード/ブランチ/クエリのスタブ。再開するリポジトリは`aruaru-db`(新規clone)・`open-cosmo`・`F:\runo`。貼り付け用の再開用メッセージは[`PORTING.md`](PORTING.md)末尾(日英)。**English**: All unused-code warnings in aruaru-db `admin.rs` are gone (`9a390b8`). The admin web app was a white screen before; four bugs were fixed and verified locally (all 10 pages, `CreateBackup` 401 without / 200 with a token, 0 old-REST calls; `aca3fca`). **Open**: VPS deployment of `aruaru-db-admin-web`, `tsc` type errors, Dashboard/Branch/Query stubs. Repos: `aruaru-db` (fresh clone), `open-cosmo`, `F:\runo`. Paste-ready resume message at the end of [`PORTING.md`](PORTING.md) (JA/EN).
- **2026-11-17 version-control通知14件の依存更新・VPS反映 / Dependency updates for the 14 version-control items**: **日本語**: 脆弱性はopen-gitea(`253de21`)・open-redmine(`13773b7`)・aruaru-llm(`d76b692`、古い`Cargo.lock`の未使用`rust-bert`系が原因で再生成により解消)を修正、メジャー更新はRS-Blog(`a8497f5`)・RS-EC(`a17163c`)のrand 0.10/sha2 0.11とaudiocafe-tokyo-rust(`a34b859`)のreqwest 0.13/html-escape 0.3。RS-Blog・RS-EC・open-redmine・audiocafe-tokyo-rustはVPSで再ビルド・再起動しhealthz 200(旧バイナリ`*.before-deps-20261117`)。`atr-base`/`atr-sonic`は別リポジトリではなくaudiocafe-tokyo-rustの作業用クローン。**未了**: aruaru-IMEの`windows-core` 0.100(`windows`が0.62.2で保留)、VPSのaruaru-llmクローン(17遅れ・未コミットあり、pullしない)、VPSのopen-gitea作業ツリー(履歴のみ整列済み、`static/`はディスク配信のため上書きしない)。再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-17 再開用メッセージ(依存更新)」(日英)。 **English**: Vulnerabilities fixed in open-gitea, open-redmine and aruaru-llm (stale `Cargo.lock` entries of unused `rust-bert`); majors done (rand 0.10/sha2 0.11 in RS-Blog and RS-EC, reqwest 0.13/html-escape 0.3 in audiocafe-tokyo-rust). Rebuilt and restarted on the VPS, all healthy (old binaries `*.before-deps-20261117`). `atr-base`/`atr-sonic` are working clones of audiocafe-tokyo-rust. **Open**: aruaru-IME `windows-core` 0.100 (on hold), the VPS aruaru-llm clone (17 behind, local changes), the VPS open-gitea working tree. Resume message at the end of [`PORTING.md`](PORTING.md).
- **2026-11-17 到達点のまとめと再開用メッセージ(別アカウントで再開用) / Checkpoint summary and resume message**: [`PORTING.md`](PORTING.md)末尾「2026-11-17 到達点のまとめと再開用メッセージ」(日英)に、各担当の最新報告をまとめた。最優先: `open-raid-z-installer`の通し試験(CSS修正版)→旧TS版の削除、次にストリーミングのVPS反映。ユーザーの許可・判断待ち=aruaru-IMEのメモ帳実入力・残ったTSF DLL、open-giteaの`/`の扱い。*Latest reports are collected at the end of PORTING.md (JA/EN). Top: end-to-end test of the CSS-fixed open-raid-z-installer, then deploy streaming; awaiting the owner: Notepad typing / leftover TSF DLL, open-gitea `/` routing.*
- **2026-11-15 RS-Sync依存更新・テスト/検証が上手くいかない理由の調査(別アカウントでの再開用) / RS-Sync dependency update and test-failure research (resume on another account)**: **日本語**: RS-Syncの依存を最新の主要版へ更新(`3b144cd`)、open-giteaテストをConnectへ追従(`177d68c`)、いずれもpush済み・全テスト通過・Androidクロスビルド成功。日英のWeb検索+GitHub調査で分かった失敗原因は、(1)並列テストがカレントディレクトリ/環境変数を奪い合う、(2)Windowsのウイルス対策等が一時ファイルを掴む、(3)モックがAPI形式変更で古くなる/AIのテストが実装をなぞる。**未了**: RS-Syncの稀に落ちる結合テスト`two_way_sync_propagates_dest_only_change_back_to_source`の原因特定、Android実機の起動確認。再開するリポジトリは`F:\RS-Sync`(aon-co-jp/RS-Sync)と`F:\runo`。貼り付け用の再開用メッセージは[`PORTING.md`](PORTING.md)末尾と`F:\RS-Sync\PORTING.md`末尾(日英)。**English**: RS-Sync dependencies were updated to the latest majors (`3b144cd`) and the open-gitea test was aligned with Connect (`177d68c`); pushed, all tests pass, Android cross-builds succeed. Research (English/Japanese web search + GitHub) found three failure causes: parallel tests fighting over cwd/environment variables, Windows antivirus holding temp files, and mocks going stale / AI-written tests mirroring the implementation. **Open**: root cause of the occasionally failing integration test `two_way_sync_propagates_dest_only_change_back_to_source` and a real-device Android launch check. Repos to resume: `F:\RS-Sync` (aon-co-jp/RS-Sync) and `F:\runo`. Paste-ready resume messages at the end of [`PORTING.md`](PORTING.md) and `F:\RS-Sync\PORTING.md` (JA/EN).
- **2026-11-15 MFastAPI/RMojo/2FastAPI/2FastAPI-VSC の紹介ページ(ダウンロード専用・13言語)**: `easy-web.tokyo/<名>`と`/<名>/demo`、トップ`/`・`/demo`の紹介、各GitHub READMEに反映。静的(VPS `easy-web-intros-web.service` 127.0.0.1:8141、`/root/easy-web-intros`、`domains.toml`に4件、ロールバック=`/root/domains.toml.before-intros-*`、`open-easy-web-server.before-intros-20261115`)。生成器は`F:\runo\.tmp-gen-intro.py`(未コミットの一時ファイル)。翻訳はAI作成でネイティブ検証前、台湾語は台湾の繁体字中国語。*Download-only 13-language intro pages are live.*
- **2026-11-15 REST全廃の本番確認・反映(別アカウントでの再開用) / Production verification of REST abolition (resume on another account)**: **日本語**: 移行済みサービスは本番で新Connect応答・旧REST 404を実測。aruaru-db(`849f082`)とopen-easy-web(`6344880`、旧`/ime/api/key|session`削除)をVPSへ反映、aruaru-IME v0.2.25で旧経路削除済み(2026-12-06の作業は不要)。**未了**: Android実機通し試験、VPS aruaru-dbの`Cargo.lock`未コミット差分。再開するリポジトリは`F:\runo`・`F:\aruaru-IME`・`F:\open-easy-web`・`aruaru-db`(新規clone)。貼り付け用メッセージは[`PORTING.md`](PORTING.md)末尾(日英)。**English**: Migrated services answer on new Connect and 404 on old REST in production. aruaru-db (`849f082`) and open-easy-web (`6344880`, legacy `/ime/api/key|session` removed) are deployed; aruaru-IME v0.2.25 dropped the legacy routes (the 2026-12-06 task is unnecessary). **Open**: (VPS `downloads/VERSION` now 0.2.25, resolved) Android E2E, uncommitted `Cargo.lock` diff on the VPS aruaru-db. Repos: `F:\runo`, `F:\aruaru-IME`, `F:\open-easy-web`, `aruaru-db` (fresh clone). Paste-ready message at the end of [`PORTING.md`](PORTING.md) (JA/EN).
- **2026-11-15 REST全廃の仕上げ(ストリーミング・bdg・open-cg-cad・e-gov)の再開用メモ(別アカウントで再開用) / Resume memo (streaming, bdg, open-cg-cad, e-gov)**: 到達点・未了・再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-15 別アカウントでの再開用メモ(REST全廃の仕上げ…)」(日英)。push済み=RPoemストリーミング(`1570371`・`34cb595`)、bdg管理APIのConnect化(`9066b60`)、open-cg-cad(`68aa70e`)、e-gov(`6301a9b`)。**本番は未反映**。未了=本番反映と通し確認、open-cg-cadの`Generate`正常系・ブラウザ・open-english認証呼び出し、`atr-sonic`/`open-easy-web-app`がGitHubに無い件。*Pushed: RPoem streaming limits/mid-stream errors, bdg/open-cg-cad/e-gov on Connect; production not updated; details and the resume message at the end of PORTING.md.*
- **2026-11-15 aruaru-db / open-cosmo のREST全廃の仕上げ・ブラウザ確認 / REST abolition finish and browser checks**: **日本語**: 両リポジトリとも自前RESTは0本(例外のみ)。aruaru-dbは公開`/graphql`から管理Mutationを撤去しConnect 32メソッドで同等機能を維持、`aruaru-server`・`realdata-aruaru-db`を本番反映済み。本番管理画面は白画面でなくConnect 200・旧REST 0・トークンなしRebalance 401、Tauri管理画面も起動しUI描画を確認。**未了**: `aruaru-admin`本体のブラウザ確認と反映、`admin.rs`の未使用警告、open-cosmoのdocs整理。再開するリポジトリは`aruaru-db`(新規clone)・`open-cosmo`・`F:\runo`。貼り付け用の再開用メッセージは[`PORTING.md`](PORTING.md)末尾(日英)。**English**: Both repos have 0 own REST routes (exceptions only). aruaru-db removed admin mutations from the public `/graphql` (32 Connect methods keep parity) and is deployed; the production admin UI renders, Connect returns 200, no old REST, tokenless Rebalance 401; the Tauri admin starts and renders. **Open**: browser test/deploy of the `aruaru-admin` app, `admin.rs` warnings, open-cosmo docs. Repos: `aruaru-db` (fresh clone), `open-cosmo`, `F:\runo`. Paste-ready resume message at the end of [`PORTING.md`](PORTING.md) (JA/EN).
- **2026-11-15 RPoem「分身の術」ホスティング(別アカウントでの再開用) / Bunshin hosting (resume on another account)**: **日本語**: 1VPSに`open-web-server`(Apache相当)と`RPoem`(Tomcat相当)を1回入れれば全サイトを分身で非同期・マルチスレッド収容する設計。仕様=`open-easy-web/docs/RPOEM_BUNSHIN_HOSTING_SPEC.md`。完了(push済み): open-web-server `a862f61`(sites.toml展開・同時接続上限・ポート自動割当)/`c971a38`(site-fleet)、RPoem `2b50b3e`(SiteFleet)。未了: 実プロセス通し確認、hyper転送、別uid/cgroup/Isolator、Admin Site* RPC、tenant分離(既定はtrusted=自分のサイトのみ)。本番VPS未反映。再開用メッセージは`open-easy-web/CLAUDE.md`・`PORTING.md`末尾の同名節。 **English**: Install `open-web-server` (Apache-like) and `RPoem` (Tomcat-like) once per VPS; per-site shadow-clone workers host every site, async and multi-threaded. Spec: `open-easy-web/docs/RPOEM_BUNSHIN_HOSTING_SPEC.md`. Done (pushed): open-web-server `a862f61` / `c971a38`, RPoem `2b50b3e`. Open: real-process E2E, hyper forwarding, per-site uid/cgroup/Isolator, Admin Site* RPCs, tenant isolation (default trusted = own sites only). Production VPS untouched. The resume message is in the same-named section at the end of `open-easy-web/CLAUDE.md` / `PORTING.md`.
- **2026-11-15 Android実機確認(REST全廃後)/ Android device verification after REST abolition**: aruaru-IME v0.2.24 は端末が新経路 `/ime/api/aruaru_ime.v1.Ime/Key` を21回叩き旧経路は0件(VPSアクセスログ`/var/log/messages`で確認)、open-english v0.8.18・open-redmine(新規ビルド、`/healthz`200)・open-media v0.1.10 は起動・画面・横向きが正常。端末設定は元に戻し済み。**未了**: open-english のチャット返答確認、open-media の再生/変換/書き込み、open-redmine のブラウザ側、文字サイズ、open-easy-web(端末は8月の旧版)。再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-15 Android実機確認」(日英)。*aruaru-IME on the device used only the new Connect route (21 calls, 0 legacy); open-english, open-redmine (fresh build, /healthz 200) and open-media start and rotate correctly; device settings were restored. Open: chat reply, open-media real operations, browser-side redmine, font sizes, open-easy-web. Resume message at the end of PORTING.md.*
- **2026-11-15 open-bar・version-control・インストーラー試験・RPoemゲートウェイの再開用メモ(別アカウントで再開用)**: 到達点・未了・再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-15 追記: open-bar・version-control・…」(日英)。最優先: `open-raid-z-installer`のMSIインストール/アンインストール試験(済むまで旧TS版`open_runo_installer`は削除しない)。open-barの実機テストは`-- --test-threads=1`で直列実行。aruaru-IMEのVPS反映は2026-12-06まで保留。*Status, open items and the resume message are at the end of PORTING.md (JA/EN). Top item: MSI install/uninstall test for open-raid-z-installer; run open-bar real-device tests serially; aruaru-IME VPS update held until 2026-12-06.*
- **2026-11-15 open-gitea / open-redmine のConnect化の本番反映 / Production deploy of open-gitea and open-redmine**: **日本語**: open-redmine(`6612f6b`)を2026-11-08にVPSへ反映(WSLビルド・バックアップ`/root/rd-bak-20261108-065255`・入れ替え・`open-redmine`/`open-redmine-demo`再起動、新Connect 200/400・旧`/api`404・画面は白画面でなくロールバック無し)。open-giteaは別セッションが2026-11-07に反映済み(二重に入れ替えていない)。**未了**: open-giteaの`/`が404(画面は`/ui`配下の仕様、反映前との比較と`/ui/`のブラウザ確認、入口の振り替え方の判断)、ログイン後の通し操作。再開するリポジトリは`F:\runo`・`F:\open-gitea-rest`・open-redmine(新規clone)。貼り付け用の再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-15 再開用メッセージ(open-gitea / open-redmine のConnect化の本番反映)」(日英)。**English**: open-redmine (`6612f6b`) was deployed to the VPS on 2026-11-08 (WSL build, backup `/root/rd-bak-20261108-065255`, swap, restart of `open-redmine`/`open-redmine-demo`; new Connect 200/400, old `/api` 404, UI not a white screen, no rollback). open-gitea had been deployed by another session on 2026-11-07 (not swapped twice). **Open**: open-gitea `/` returns 404 (the UI is served under `/ui` by design; compare with the pre-deploy binary, check `/ui/` in a browser, decide the entrance routing) and authenticated end-to-end flows. Repos to resume: `F:\runo`, `F:\open-gitea-rest`, open-redmine (fresh clone). The paste-ready resume message is at the end of [`PORTING.md`](PORTING.md) ("2026-11-15 再開用メッセージ(open-gitea / open-redmine …)", JA/EN).
- **2026-11-15 共有基盤の受付制御(aruaru-llm)・再開用メッセージ / Shared-base admission control, resume message**: aruaru-llmに同時実行上限・サイト別公平キュー・タイムアウト(429/503/504)を実装しVPS反映済み(2026-11-09)。open-cuda/open-directxはライブラリのまま。未了=前面の`x-tenant`付与の確認・実推論での公平性測定。再開用メッセージは[`PORTING.md`](PORTING.md)末尾と`aruaru-llm/CLAUDE.md`末尾(日英)。*Admission control (concurrency cap, per-site fair queue, 429/503/504) is live on the VPS; open: verify `x-tenant` at the front server, fairness with real inference. Resume message at the end of PORTING.md and aruaru-llm/CLAUDE.md.*
- **2026-11-15 version-control依存更新・open-raid-z/インストーラーのRust化(別アカウントでの再開用) / Dependency updates, Rust installer**: 到達点・未了・再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-15 別アカウントでの再開用メモ(version-control依存更新・open-raid-z/インストーラーのRust化)」(日英)。最優先: `open-raid-z-installer`の通し試験→旧TypeScript版の削除。*Status and the resume message are at the end of PORTING.md (JA/EN). Top item: end-to-end tests of open-raid-z-installer, then delete the old TypeScript installer.*
- **2026-11-15 Android同梱バイナリのConnect化・open-english v0.8.18 / Android bundled binaries on Connect, open-english v0.8.18**: `open_cpu`二重リンクは`aruaru-llm`の`[patch]`で解消(`dae7d25`)、v0.8.18のリリースCI成功、実機でリリースAPKの起動・Connect応答(旧REST=404)・クラッシュ0を確認。未了: 画面からのチャット・翻訳の通し試験、`open-english/server/Cargo.lock`の扱い(そのままコミットしない)。再開するリポジトリは`F:\open-english`(`maid-cafe-english`)と`F:\aruaru-llm`。再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-15 追記: Android同梱バイナリ」(日英)。*The `open_cpu` double link is fixed via a `[patch]` in aruaru-llm; the v0.8.18 release CI is green; the release APK was verified on a real device (Connect answers, old REST 404, no crashes). Open: end-to-end UI test, Cargo.lock policy. Resume repos: open-english (maid-cafe-english) and aruaru-llm; the resume message is at the end of PORTING.md.*
- **2026-11-15 再開用メッセージ(別アカウントで再開) / Resume message for another account**: 再開するリポジトリは`F:\runo`・`F:\version-control`・`F:\aruaru-search`・`F:\aruaru-llm`。確認済み=aruaru-search自動再開(本番ログ)・version-control `--pr`/`--push`(ローカルbare origin、`gh`は偽物)・version-control手元クローンの分岐解消・VPSの共有基盤は1プロセスずつ。未了=本物の`gh pr create`(許可待ち)、aruaru-llm要約の高速推論先での確認(VPSは3分超、確認呼び出しを連打しない)、共有基盤の同時要求上限・分離・タイムアウトの調査、CI赤3件。そのまま貼り付ける再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-15 再開用メッセージ」(日英)。*Repos to resume: runo, version-control, aruaru-search, aruaru-llm. Verified: auto-resume, --pr/--push (local bare origin, stubbed gh), clean version-control clone, shared base = one process each. Open: a real gh pr create (needs permission), llm summaries on a fast backend, shared-base concurrency survey, 3 red CIs. Paste-ready message at the end of PORTING.md.*
- **2026-11-15 2FastAPI/2FastAPI-VSC新設・RMojo v0.3.0・Windows ARM64(Snapdragon)対応 / New repos, RMojo v0.3.0, Windows ARM64**: 到達点・未了・再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-15 別アカウントでの再開用メモ」(日英)。最優先の未了: open-raid-z・open-easy-web・open-web-serverのARM64ジョブ(と同時に失敗しているx64/Linux)のCIログ確認と修正。*Status, open items and the resume message are at the end of PORTING.md (JA/EN). Top open item: the red CI of open-raid-z, open-easy-web and open-web-server.*
- **2026-11-08 open-web-server 2FA統合の確認 / admin-2fa verification**: `admin-2fa-connect`(`1845a0b`)は`origin/main`(`84fac90`)に統合済みで、`F:\open-web-server`は`main`に切替え済み(`F:\open-web-server-deps`はmainを譲るためdetached)。確認: RPoem `cargo check --locked --workspace` 成功、open-web-server `cargo test --workspace --locked` 全件成功(222+24+20、失敗0)、本番`/etc/open-web-server/admin.env`にADMIN_TOKEN/TLS_TOKEN/SMTP/2FA・鍵ストアあり(`STATIC_TOKEN_MODE`未設定=既定`any`で従来どおり)。**2026-11-09 追記**: VPSのクローンを`git pull --ff-only`で`27dcd7c`へ追従(再ビルド・再起動なし)。稼働中のバイナリ(11/6 11:12ビルド)は`STATIC_TOKEN_MODE`・`Reset2fa`を含み2FA統合版と整合するが、`27dcd7c`(Ledger→`Admin/DbMutate`、`OPEN_RUNO_API_KEY`必須)より前のビルド=未反映。**2026-11-09 本番差し替え完了**: `27dcd7c`を本番機能セット(`admin-2fa,domain-watchdog,fastcgi-client,ddns,sftp`、WSLビルド)でビルドし、カナリア→差し替え。再起動後 active・証明書56件不変・5ドメインHTTPS正常(aon.tokyoの404は仕様)・エラーログ0。旧バイナリは`target/release/open-web-server.before-main-20261109m`(ロールバック用)。ただしRPoemゲートウェイは停止中でLedger書き込み(`Admin/DbMutate`)は未稼働。落とし穴: 機能指定なしでビルドすると2FA無しの別物になる(最初のビルドは破棄)。**`loopback`切替は見送り**: 2FAストア(`admin`1件・10/28登録)はあるが鍵ストア(`key-store.json`)が存在せず、2FAログインの実通しが一度も済んでいない。切替前に本人がメールOTP+TOTPでログイン→Bearerで`ListTenants`が通ることを確認する(設計書§8手順5)。それまでloopbackにすると公開側の管理操作が締め出される。*VPS clone fast-forwarded; running binary predates 27dcd7c; loopback switch deferred until a real 2FA login is verified by the owner.*
- **2026-11-08 easy-web.tokyoに紹介・ダウンロードページを追加 / Intro pages added**: `aruaru-llm`・`aruaru-IME`・`open-easy-web`・`RS-EC`・`RS-Blog`・`RS-Ops`・`open-cosmo`・`RS-Red`の`webpage/index.html`を各リポジトリへpushし、VPSの`/root/easy-web.tokyo/<repo>`へ配置(ポート8131〜8139、`<repo>-web.service`、`domains.toml`に追記、表示確認済み)。ダウンロードはGitHubのリリースURL。**`open-gitea`は`easy-web.tokyo/open-gitea`が稼働中のアプリ(8090)に使われているため紹介ページは未配置**(置き場所の判断待ち)。公開の紹介ページなのでOTP・`/demo`は付けていない。 *Eight intro/download pages are live (ports 8131-8139); `open-gitea` is skipped because that path is the running app (port 8090).*
- **2026-11-08 aruaru-search自動再開・version-control拡張の検証 / Verification**: **日本語**: (1) aruaru-search `b15f63a`(休止からの自動再開)は**本番(VPS、`d26a750`稼働中)のログで実働を確認**: bing/yahoo-jp/braveが「探り: 成功。復帰します」で復帰し、braveはHTTP 429の探り失敗で指数バックオフ(段階0→1→2、探り300秒ごと)。Healthは`healthy 7/10`(excite・hackernewsは「ページの作りが変わった可能性」で別件、braveは429中)。(2) version-control `--pr`/`--push`: `scripts/remediate.sh`を**ローカルのbareリポジトリをoriginにしたWSLの往復**で確認(`vc/fix-日付-crate`ブランチをpush+PR経路、`--push`でmainへ直接push、どちらも成功)。**`gh`は偽物に差し替えており、本物の`gh pr create`は未実行**。(3) aruaru-llmによる変更点要約は**VPSでは実用にならない**: 同じ形のGenerate(`max_new_tokens=48`)が3分超(4コアCPUのGPT-2、4スレッド全使用)で、設定の`llm_timeout_secs=45`では必ず打ち切られ要約なし(失敗しても動作に影響しない設計どおり)。手元PCにaruaru-llmは無く未確認。要約を使うなら高速な推論先を`llm_url`に指す必要がある。**未了**: 本物の`gh pr create`、要約の実機確認、version-controlの手元クローンは`ahead 2 / behind 6`で分岐(ローカルの`--loop`2コミットは未push、`git pull`せず要整理)。**English**: Auto-resume is confirmed working in production logs (probe success -> recovered; brave backs off on 429). `--pr`/`--push` were round-tripped against a local bare origin in WSL with a stubbed `gh` (real `gh pr create` not run). The aruaru-llm summary is impractical on the 4-core VPS (>3 min per call vs a 45 s timeout) and untested elsewhere; the local version-control clone has diverged (ahead 2, behind 6).
- **2026-11-07 open-github-backup再開・easy-web.tokyo紹介ページ追加 / Resumed, intro pages added**: **日本語**: GitHubの課金は解消(手動実行でジョブ開始を確認)、`open-github-backup`のscheduleを再開(6時間おき差分+日曜全件)、検証runは成功(ミラー16・飛ばし132・失敗0)。宛先`runo-aruaru`は165件、Actions有効だった14件を無効化し、今後は作成直後に自動で無効化。VPSデータの暗号化バックアップは毎日03:30で稼働(14世代)。`easy-web.tokyo`に`open-media`・`pdf-r2l-rs`・`maid-cafe-se`・`open-cuda`・`open-cpu`・`RPoem`の紹介・ダウンロードページを追加(各リポジトリの`webpage/index.html`、ダウンロードはGitHubのリリースURL、表示確認済み)。**未了(判断待ち)**: `easy-web.tokyo/open-raid-z/`は紹介ページではなく管理UI(画面は誰でも開け、プール作成だけ管理者トークン)で、VPSのクローンに未コミット変更4件(紹介ページの削除を含む)がある→触っていない。本人限定のメールOTP化・`/demo`は未着手。詳細は`PORTING.md`末尾と`open-github-backup/CLAUDE.md`。 **English**: GitHub billing is resolved (a manual run started its job); `open-github-backup`'s schedule is back (6-hourly differential + Sunday full) and the verification run succeeded (16 mirrored, 132 skipped, 0 failed). The destination `runo-aruaru` has 165 repos; 14 with Actions enabled were disabled, and new ones are disabled right after creation. The encrypted VPS data backup runs daily at 03:30 (14 generations). Intro/download pages were added on `easy-web.tokyo` for `open-media`, `pdf-r2l-rs`, `maid-cafe-se`, `open-cuda`, `open-cpu` and `RPoem` (each repo's `webpage/index.html`; downloads point to GitHub release URLs; checked live). **Open (needs a decision)**: `easy-web.tokyo/open-raid-z/` shows an admin UI, not an intro page (anyone can open it; only pool creation needs the admin token), and the VPS clone has 4 uncommitted changes (including a deleted intro page) - left untouched. Owner-only e-mail OTP and `/demo` are not started.
- **2026-11-01 RPoemのREST全廃→管理操作はgRPC化、gRPC-web-Connect新設 / REST removed, admin = gRPC, new gRPC-web-Connect**: RPoemの`/api/`のRESTは全削除、管理操作は`open_runo.admin.v1.Admin`(gRPC。同じ定義をgRPC-web・Connectでも受け、1ポートでHTTP/1.1とh2cを判別)。管理画面・CLIをgRPC化(管理画面はConnect+gRPC-webのハイブリッド、RPC Inspector追加)、GraphQLは問い合わせ専用で本番防御4項目、gRPCはTLS1.3/mTLS。ハイブリッドは新リポジトリ[`gRPC-web-Connect`](https://github.com/aon-co-jp/gRPC-web-Connect)。open-web-serverの呼び出しはブランチ`rest-to-graphql`でConnect化(未push、前面は**HTTP/1.1のみ**で素のgRPCは通らない=実機確認)。VPSは`/root/RPoem`のgit pullと`/root/gRPC-web-Connect`のcloneのみ(ゲートウェイは未稼働、再起動なし)。詳細は`RPoem/CLAUDE.md`冒頭の「方針転換(gRPC)」。**未了**: セキュリティ更新の`version-control`連携(RustSec走査)、RPoem→gRPC-web-Connect置換、open-web-serverのHTTP/2対応。*Done: REST removed, admin over gRPC/gRPC-web/Connect, hybrid library published; open: version-control advisory scan, RPoem migration to the library, h2 in open-web-server.*
- **2026-10-28 version-control新設(全リポジトリの依存鮮度の監視→Claude向けメッセージをメール/LINEで通知) / New**: [`version-control`](https://github.com/aon-co-jp/version-control)(公開、`F:\version-control`、VPSは`/root/easy-web.tokyo/version-control`、公開`easy-web.tokyo/version-control`・デモ`/demo/`)。crates.io/npm/packagistとクローンの遅れを走査し、メジャー更新・クローンの遅れ/分岐は常にClaude行き、マイナー/パッチは自動保守(aruaru-llm/open-cuda/open-cpu/open-directx)が稼働中なら任せる。**メール通知は実働(VPSタイマー00/06/12/18時の:20)、LINEは未設定**(トークンとユーザーIDのtxtを`F:\`に置き、VPSへscp)。依存の書き換え・`git pull`はしない。お引越し手順と再開用メッセージは`version-control/PORTING.md`末尾。**落とし穴**: VPSのdomains.tomlは2つのパスが同一ファイル(追記は1回)、ポート8125はopen-mirror使用中(本機能は8126)。*Done: scanner + dashboard + e-mail notifications live; open: LINE, working through the first 326 major gaps.*
- **2026-10-26 open-mirror新設・厳選バックアップ・非公開リポジトリ公開 / open-mirror, curated backup, repositories published**: **日本語**: (1) `gitlab-mirror`→`open-mirror`に改名(公開。GitHub→GitLabの毎日ミラーは公開リポジトリのみ・PAT不要・Actions無料)。GitLab無料期間の問題ではなく、10/13以降の失敗はGitHub Actionsの課金(非公開で月の無料枠超過または支払い失敗)が原因だった。紹介・デモは`easy-web.tokyo/open-mirror`(`/demo`)、トップページにも紹介。(2) VPSの厳選バックアップ: 秘密・個人情報を除いたものを公開`aon-co-jp/vps-backup`へ、秘密・DBの中身は暗号化して手元`F:\vps-secrets`へ(VPSの`vps-curated-backup.timer`毎日03:45、手元のタスク`vps-secrets-pull`毎日10:00+ログオン時)。旧い非公開バックアップ(`runo-aruaru/vps-data-backup`、毎日03:30)はそのまま残す。(3) 公開+Release: open-fudousan・runo.tokyo・RS-Guard・runo-scanner・RS-BootStrap・sample-mario/harrier/maid・open-cg-cad・RS-Sync(履歴からGitHubトークンを除去して強制push)。**未了**: 非公開のまま=fbi/icpo/nasa.tokyo(実在機関名)・tessdata-jpn・open-github-backup等、`open-mirror`の「予定」機能(PC/スマホ等からの自動バックアップ、保存先の選択、厳選リストの実装)、手元の`zstd`は`%USERPROFILE%\bin`に導入済み。**落とし穴**: PowerShell 5.1で日本語を含むファイルを書かない(`feedback_powershell_utf8_edits`)。**English**: `gitlab-mirror` was renamed `open-mirror` (public; public repos only, no PAT, free Actions); the failures since 10/13 were GitHub Actions billing, not GitLab. A curated VPS backup now publishes only secret-free/PII-free data to the public `aon-co-jp/vps-backup` and keeps GPG-encrypted secrets on the PC (`F:\vps-secrets`). Eleven repositories were published with releases; RS-Sync had its history scrubbed of a GitHub token first. Still private: fbi/icpo/nasa.tokyo (real agency names), tessdata-jpn, etc.; the planned open-mirror features are not built yet.
- **2026-10-26 サイト更新・open-backup 暗号化/復元・PC の起動時 HDD 調査 / Site updates, open-backup encryption & restore, boot-time HDD diagnosis**:
  **日本語**: (1) **aruaru.tokyo / audiocafe.tokyo / aon.tokyo(=aon.co.jp)**に、ブログ・動画(クリックで再生)・福山雅治ビデオ集などを追加(各リポジトリにコミット・push・VPS反映済み)。
  反映の手順: `aruaru-tokyo` = GitHub へ push → VPS の `/root/aruaru.tokyo` で `git pull`・`cargo build --release`(終了コードを確認)・`systemctl restart aruaru.tokyo.service`。`audiocafe.tokyo` のトップは **Rust 版**で、VPS の `/root/repository/audiocafe-tokyo-rust/src/main.rs` を直接編集 → build → `audiocafe-tokyo-rust.service` を再起動 → push(`format!` 内に `{` `}` を書かない)。
  **前面で受けているのは nginx ではなく `open-web-server`**(nginx.service は停止中・触らない)。**`aon.tokyo` の TOP は 2026-10-20 から全パス404(`AON_TOP_HIDDEN=1`)**だが、`/video/fukuyama/` だけは公開(`StaticFilesEndpoint`)。
  (2) **`open-backup`**: 端末側の暗号化(XChaCha20-Poly1305+Argon2id)・zstd 圧縮・スレッド並列・画面/CLI からの復元を実装し、`67ac247`・`01c0041` で push。詳細は `open-backup/CLAUDE.md` の HANDOFF(2026-10-26)。GitHub への実 push を通した確認(git 方式・API 方式とも)と、Android(API 方式)の暗号化対応も完了(2026-10-26。API 方式の既存の不具合も1件修正)。GPU(open-cuda)は使わない(律速はディスクと回線)。
  (3) **PC の「OS 起動前に HDD が長時間動く」調査**(読み取りのみ): `Disk 1`(WD 3TB・`F:`)の「IO 再試行」(イベント153)が直近30日で39件(うち22件が 10/26 の起動時)、**予期しない電源断が90日で26回**(起動時の autochk の原因になりうる)。正常再起動後(11:24)は再試行0件。SyncFolder(Store アプリ)が **`F:\` 全体を `H:\` へミラー**(1.84百万ファイル・約35分)。二重バックアップする別アプリは見つからず。
  (4) **`F:`/`H:` の整理**: 再生成できる `target`/`node_modules`/`.gradle`/`__pycache__`(目印を確認したもののみ。`.venv`・起動項目が参照するものは除外)を削除中だったが、**セッションの切れ目で途中停止**。ログは scratchpad の `regen-delete.log`(`F:` 93件削除済み)・`regen-h.log`(`H:` 128件削除済み)。**続きは、同じ手順(`regen-candidates.txt` から安全確認 → 削除)で再実行可**。`H:\StreamGaGa`(約12.7GB、同じインストーラーが複数)と `H:\_sf`(SyncFolder のごみ箱 1.2GB)は**ユーザーの判断待ち**。`vps-backup-curation-list.md`(未コミットの下書き)は別作業のもの・VPS の場所を含むためコミットしない。
  **注意**: PowerShell 5.1 は BOM 無し UTF-8 の日本語 `.ps1` を読み違える(英数字だけで書く)。ブラウザ操作が安全確認で止まったら迂回せず `curl` 等で確認する。
  **English**: (1) Added blog links, click-to-play videos and a Fukuyama video set to aruaru.tokyo / audiocafe.tokyo / aon.tokyo; all committed, pushed and deployed. The edge server is **open-web-server, not nginx**; aon.tokyo's TOP stays 404 (hidden since 2026-10-20) except `/video/fukuyama/`. (2) `open-backup`: client-side encryption (XChaCha20-Poly1305 + Argon2id), zstd compression, multi-threading and UI/CLI restore (`67ac247`, `01c0041`); open: a real push to GitHub, Android (API backend). No GPU used. (3) Boot-time HDD activity diagnosis (read-only): `Disk 1` (WD 3TB, `F:`) I/O retries and 26 unexpected power losses in 90 days; zero retries after a clean reboot; SyncFolder mirrors all of `F:\` to `H:\` (no second app found). (4) Cleanup of regenerable build folders on `F:`/`H:` was interrupted; resume with the same verified procedure; `StreamGaGa` and `_sf` await the user's decision.
- **2026-10-26 backup-to-discord-by-github 新設(GitHub→暗号化→非公開Discord) / New**: [`backup-to-discord-by-github`](https://github.com/aon-co-jp/backup-to-discord-by-github)(公開、`F:\backup-to-discord-by-github`、VPSは`/root/repository/backup-to-discord-by-github`)。`bdg-core`(XChaCha20-Poly1305+Argon2id、分割、Discord REST、復元、世代整理)、`bdg`(CLI)、`bdg-server`(RPoemの管理API+GitHub Webhook)。RPoemに`webhook`/`body_limit`/`multipart_stream`を追加(`d41a70c`)。**本物のDiscordで`doctor`全OK・公開repoの往復一致を確認**。未了: 非公開repo(`F:github-token.txt`が401で拒否=失効、fine-grainedで取り直し要)、大容量(複数パート)の実機、スケジューラ登録、`easy-web.tokyo`配置、Webhook登録、`open-gitea`未調査。Botトークン/パスフレーズ/管理トークンは`F:`直下のtxt(パスフレーズ喪失=復元不能)。*Done: CLI + server + core verified against a mock and a real Discord channel (public repo round trip). Open: private repos (token rejected with 401), big multi-part repos, scheduler, deployment.*
- **2026-10-21 open-english を maid-cafe-english へ改名・お引越し(旧名も永久に残す) / Renamed open-english → maid-cafe-english (the old repo is kept forever)**: 新リポジトリ [`maid-cafe-english`](https://github.com/aon-co-jp/maid-cafe-english)(同一の履歴・タグ・最新リリース v0.8.14 をコピー)。旧 `open-english` はREADMEの改名バナーと`RENAMED.md`(約37言語)つきで永久に残す。**自動更新(サーバー・Android)は新旧の両方を問い合わせ、新しい版を採用**(どちらも削除しない)。範囲はGitHubの名前・README・文書のリンクまで(パッケージ名・公開URL・リリースのファイル名は不変)。**リリースは元の `open-english` にタグを push**し、`release.yml` のミラージョブが新リポジトリへ複製する(シークレット `MAID_CAFE_ENGLISH_TOKEN` は2026-10-21に設定済み〈`F:git.txt`由来、組織全体に書き込める広いトークンなので、可能なら`maid-cafe-english`だけの細粒度トークンへ差し替える〉)。詳細は `open-english/CLAUDE.md` 末尾の「HANDOFF 2026-10-21」。*Done: new repo with identical history/tags and a copy of the latest release; old repo kept with banners and a 37-language notice; self-update queries both repos and takes the newer release. The mirror secret `MAID_CAFE_ENGLISH_TOKEN` is set (broad token from `F:git.txt`; replace with a single-repo fine-grained token when possible).*
- **2026-10-18 Windows再起動前のお引越し・再開メッセージ / Resume message before the Windows restart**: 
  **日本語**: (1) `open-vsc-claude`(VS Code拡張、`F:\open-vsc-claude`、v0.1.2公開済み、デモ`https://easy-web.tokyo/open-vps-claude/`)の再開は同リポジトリの`PORTING.md`末尾「お引越し・再開用メッセージ」から。未了はMarketplace/Open VSX公開(所有者のアカウントとトークンが必要)・Cosmo Router実起動・実機iOS/Android。
  (2) `dream-os/vsc`(DreamOS Code=Code-OSS 1.142.0のビルド手順)は**WSLで`npm ci`と`gulp vscode-linux-x64-min`の`package-linux-x64`まで成功、最終工程(Copilot準備`prepareBuiltInCopilotRipgrepShim`)で失敗・原因未調査、`open-vsc-claude`の同梱と`verify.sh`は未実行**。再開は`F:\dream-os\vsc\BUILD-REPORT.md`の再開コマンド(PowerShellで`wsl -d Ubuntu -- bash /mnt/f/dream-os/vsc/build.sh`)。Git Bashは`/mnt/...`を書き換えるのでPowerShellを使う。
  (3) RPoemの外部サブグラフ中継(`babc658`)は反映済み。トークン類はリポジトリに入れず`F:\`直下のtxtに置く。
  **English**: (1) Resume `open-vsc-claude` (VS Code extension, v0.1.2 released, demo `https://easy-web.tokyo/open-vps-claude/`) from the "Resume message" at the end of its `PORTING.md`; open: Marketplace/Open VSX publication (owner account + token), running the Cosmo Router, real iOS/Android devices.
  (2) `dream-os/vsc` (build recipe for DreamOS Code = Code-OSS 1.142.0): in WSL **`npm ci` and the gulp `package-linux-x64` step succeeded; the final Copilot step `prepareBuiltInCopilotRipgrepShim` failed (cause not investigated); bundling `open-vsc-claude` and `verify.sh` have not run**. Resume with the commands in `F:\dream-os\vsc\BUILD-REPORT.md` (from PowerShell: `wsl -d Ubuntu -- bash /mnt/f/dream-os/vsc/build.sh`); Git Bash rewrites `/mnt/...` paths.
  (3) RPoem's external-subgraph forwarding (`babc658`) is in. Keep tokens out of repositories (txt files at the root of `F:\`).
- **2026-10-16 【決定】作者名は本名に統一(ユーザー指示) / DECISION: use the real name as the author (user decision)**: 直下の「公開リポジトリの個人情報の取り除き」の**未決だった食い違いは、ユーザーが「本名に統一」と決定して解決した**。以後、コミットの作者はgitのグローバル名**石 塚 正 浩（MASAHIRO ISHIZUKA）**(メールはGitHubの匿名メール`18116749+aon-co-jp@users.noreply.github.com`のまま)でよい。PC・VPSのgit名を本名に揃えた。別セッションが本名で出した「READMEに作者を追記」「Cargo.tomlのauthors」等のコミットは**そのまま正**(取り消さない)。「匿名にする」方針は取り下げ。既に匿名化した112リポジトリの過去コミットはそのまま(混在してよい)、`scrub-history.sh`による内容の名前除去と「open-englishの作者の答えを名前だけに」は、本名に統一するため**不要**。*The earlier open conflict was resolved by the user: the real name is canonical from now on; the anonymous-author policy is withdrawn (past anonymised commits stay as they are; the content scrub is no longer needed).* **注意は変わらず**: 書き換えたリポジトリで`git pull`しない(古い履歴が戻る)→`git fetch`+`git reset --mixed origin/<branch>`。
- **2026-10-16 公開リポジトリの個人情報の取り除き(アカウント引っ越しの引き継ぎの続き) / Removing personal information from public repositories**: 詳細は[`PORTING.md`](PORTING.md)「公開リポジトリの個人情報の取り除き」(日英)。**Claudeの記憶は失われる前提**で、全部そこに書いた。
  要点: 112個の公開リポジトリの、**全ブランチ・タグのコミットの作者・コミッターを匿名**(`aon-co-jp` / GitHubの匿名メール)に書き換え済み(内容は同一であることを確認、`--force-with-lease`で強制push)。今後のコミットも匿名(PC・VPSのgit設定済み)。第三者の作者表示は残す。書き換え前の完全なコピーは`F:\_anon\backup\`(約800MB。個人情報入りなので公開しない)。
  **未決(最優先)**: 別のセッションが「作者名を本人の名前に統一(`Cargo.toml`の`authors`)」というコミットを複数リポジトリへ push しており、匿名の方針と食い違う→ユーザーに確認。確認前に取り消さない。その後、ファイルの内容の名前・メールの取り除き(`F:\_anon\scrub-history.sh`)、`open-english`の作者の答えを名前だけに、VPSの写しの整列、の順。**書き換えたリポジトリで`git pull`しない**(古い履歴が戻る)。
  *Done: author/committer of all branches and tags of the 112 public repositories rewritten to an anonymous identity (contents verified identical; pushed with `--force-with-lease`); future commits are anonymous (PC and VPS git config set); third parties' attribution stays; complete pre-rewrite mirrors in `F:\_anon\backup\` (~800 MB, contain personal info, never publish). **Open (top priority)**: another session pushed "unify the author name to the real name (`authors` in `Cargo.toml`)" commits to several repositories, which conflicts with the anonymous policy → ask the user; do not revert before asking. Then: remove the name/e-mail from file contents (`F:\_anon\scrub-history.sh`), reduce `open-english`'s author answer to the name only, align the VPS clones. **Never `git pull` in a rewritten repository** (the old history would come back).*
- **2026-10-14 アカウント引っ越しの引き継ぎ**: 完了/未完了/注意点を[`PORTING.md`](PORTING.md)「アカウント引っ越しのための引き継ぎ」(日英)にまとめた。最優先の未完了は
  **`open-web-server`のVPS上の未push作業(certbot webroot修正ほか)をGitHubへpushすること**。次いでJSONの実コード切り替え(`audiocafe-tokyo-rust`の`fetch_cache`)、`maid-cafe-se`の上流設定。
  `aruaru-llm`・`audiocafe-tokyo-rust`のGitHub履歴は書き直されている(強制pushしない)。
- **2026-10-14 Hand-off for the account move**: done / not done / pitfalls are summarised in "Hand-off for moving to another account" in [`PORTING.md`](PORTING.md) (Japanese and English). The top unfinished item is
  **pushing the un-pushed work on the VPS in `open-web-server` (certbot webroot fix etc.) to GitHub**, then the real JSON code switch-over (`fetch_cache` in `audiocafe-tokyo-rust`) and setting an upstream for `maid-cafe-se`.
  The GitHub history of `aruaru-llm` and `audiocafe-tokyo-rust` was rewritten (do not force-push).
- **2026-10-14 audiocafe.tokyoのVPSお引越し準備(日英)**: 2026-10-08にVPS上だけで直したPHP(毎朝クロールの`--cron-tech`、AIの価格訂正、`aruaru-llm`連携、中間証明書)を、
  [`audiocafe-tokyo`](https://github.com/aon-co-jp/audiocafe-tokyo)の最新版へ3方向マージして保存(衝突0)。systemd・nginxの設定を`deploy/vps/`へ、手順を同リポジトリの`PORTING.md`
  「VPS お引越し手順」(日英)へ。`aruaru-llm`の知識はGitHubへ自動バックアップ・起動時に自動復元(実測済み)。**新品VPSでの通し試験は未実施**。
  同日、`aruaru-llm`(日本語検索)・`RS-JSON`(`parse_secure`、実測+14%・SIMD版は約5.8倍速い)・`open-easy-web`(ロリポップ向けオートクロール)・`aruaru-tokyo`・`audiocafe-tokyo-rust`の
  README/CLAUDE/PORTINGを日英で更新。**未了**: AI学習リンクのRust版表示、「無料」表記の検証、`RS-JSON`の入口への適用。
  **注意**: `audiocafe-tokyo`のPHPは本番より新しい部分がある(`rakuten-mobile`の言語切替ほか)。本番のファイルをそのままコピーしない。
- **2026-10-14 open-github-backup新設(GitHub Actionsで`aon-co-jp`→`runo-aruaru`自動バックアップ) / new**: 詳細は本リポジトリ`PORTING.md`末尾と`open-github-backup/CLAUDE.md`。10/8に全件成功したが、以降はGitHubの課金/利用上限でジョブ未開始(要Billing確認)。宛先のActions無効化・突き合わせ・新規3件の手動ミラー・VPSデータの暗号化バックアップ(毎日03:30)は完了、残りはBilling確認のみ。/ Full mirror OK on 10/8; jobs not starting since (billing). Actions disabled on the destination, reconciliation, manual mirror of 3 new repos and the encrypted VPS data backup (daily 03:30) are done; only Billing remains.
- **2026-10-14 お引越し対応 / Migration readiness**: aruaru-llm・open-englishのREADME/CLAUDE/PORTINGに日英の「お引越し」節を追記し、知識のGitHub退避(6時間ごと)とWEB/GitHubからの自動復元をVPSへ反映。詳細は`PORTING.md`末尾。 / Added bilingual Migration sections to aruaru-llm and open-english docs; knowledge is backed up to GitHub every 6 h and restores itself from the web/GitHub (deployed to the VPS). Details at the end of `PORTING.md`.
- **2026-10-14 open-mediaの文書を整備・VPSへ配置(引っ越し可能に)**: `open-media`の`README`/`CLAUDE`/`PORTING`を日英で整備(`CLAUDE.md`/`CLAUDE.en.md`/`PORTING.md`/`PORTING.en.md`)。**引っ越し手順は`open-media/PORTING.md`**(道具・鍵の運び方・確認・OS別状況)、環境診断は`scripts/doctor.ps1`、Androidローカルビルドは`scripts/android-local-build.ps1`。make-disk時代の記録は`docs/make-disk-legacy/`。VPSは`/root/repository/open-media`(`git pull`で追従)。公開は`v0.1.10`(自動更新・1つだけ起動・日本語フォント同梱で解決したUbuntuの文字化け・関連付け・自動再生)。**更新の署名鍵は`F:\open-media-updater.key`(別の場所にも保管。無くすと更新を配れない)**。未了: PowerDVDが先に開く件の入れ直し結果、DVD/Blu-ray実ディスク、macOS・Android TV実機。
- **2026-10-12 open-media新設(make-disk + open-bar)・v0.1.4リリース完了(2026-10-13追記)**: [`open-media`](https://github.com/aon-co-jp/open-media)(公開、MIT)。make-disk最終版(v0.1.32)は無変更で残し(`ai_upmix.rs`の以前からの未コミット変更のみ残存)、以降の開発はopen-mediaで継続。open-barに`loopback.rs`(OS出力音を受け取り→sinc→32bit/384kHzで別DACへ排他出力)・32bit出力・高音補正のCD/ハイレゾ適用スイッチを追加(`f6163cb`)。
  機能: ディスクプレーヤー(音声=open-barエンジン、映像=WebView、映像+別音声combo、DVD/BDタイトル列挙、映像はFull HD/4Kへlanczos引き上げ)、システム音声の橋渡し(Windows)、LinuxのPipeWire設定(`linux/pipewire/`、未検証)。
  **確認済み**: Windowsインストーラー(v0.1.2)のインストール/起動/アンインストール、実機の音楽CD(D:)を排他+アップサンプル352.8kHz+32bitで再生(音切れ0)、橋渡し(PHL→Loxjie DAC 48→384kHz/32bit)、Linux .debの起動(WSL)、Android実機(moto g53y, Android 14)でMP4/FLAC再生。
  **2026-10-13追記**: v0.1.4のCIは全OS成功(macOS Intel版はcrates.io一時障害で再実行)、CI版APKを実機に入れて起動・表示名open-mediaを確認、Android TV向けに十字キー操作の見やすさ対応(`2c03640`、TV実機は無し)。**未了**: (1)(完了)、(2)DVD/Blu-rayの実ディスク再生、(3)macOS実機、(4)自動アップデート(署名鍵未設定)、(5)YouTube/Netflix等への割り込みはループバック方式の音楽向けのみ・DRM音声は対象外、(6)TV(Android TV)対応は未着手。作業用の`F:\open-media-test`は不要になり次第削除可。
- **2026-10-11 aruaru-IME新設・v0.1.0アルファ公開(2026-10-12 v0.2.0公開: 中国語・季節用語・優先順位・全言語一覧・オンライン画面 easy-web.tokyo/ime、VPSにサーバー運転エンジン)**: [`aruaru-IME`](https://github.com/aon-co-jp/aruaru-IME)(Windows)。`pdf-r2l-rs`のOCR(`aruaru-llm`の`/v1/ocr`)とUIの試験ルールを応用した、画面の文脈から入力モードを予測してライブ変換するIME。
  Mozc OSS辞書+Viterbi、JMdictによる日英の相互翻訳、利用者辞書/ファイル取り込み/用語辞書、Googleドライブへの自動バックアップ、常駐エンジン+薄いTSF DLL(更新でアプリの再起動不要)、Inno Setupのインストーラー。
  **未了**: インストーラーの実機の通し試験、右クリックメニュー/2列候補窓の目視確認、多言語の切替入力・中国語・世界130言語、GitHubバックアップ、macOS/Linux/Android。再開は`aruaru-IME/CLAUDE.md`のHANDOFFから。VPSへのアップロードは不要(クライアントのアプリ)。
- **2026-10-10 pdf-r2l-rs(v1.0.2〜v1.2.0公開、以降は`main`に未リリースの開発中)**: `pdf-r2l-win`/`pdf-r2l-script-win`等8リポジトリを統合した、PDF仕様書だけを根拠にした独自実装の
  [`pdf-r2l-rs`](https://github.com/aon-co-jp/pdf-r2l-rs)(MIT OR Apache-2.0、Windows/macOS/Linux/Android)。旧8リポジトリは後継案内済み、`pdf-r2l-win`/`script-win`は完成版(v1.2.0)に置換済み。
  v1.2.0までの機能: 綴じ方向(右/左/元と同じ)、OCRの書体文字化(`aruaru-llm`の`/v1/ocr`、非公開`tessdata-jpn`)、画像の高解像度化(FHD〜16K、Real-ESRGAN CPU、ArmはNEON、実機で確認)、AI文脈補完の初版。
  **開発停止時点(未リリース)**: コントラスト自動補正(薄い文書が「白紙」判定されていたのを修正)、かすれ補正(超解像+再OCR、設定`reocr`)、AI文脈補完の拡張(Qwenが走査して不自然な1〜4文字を検出→候補採点→置換、検索`aruaru-search`で実文の裏付け、
  字形の照合=新設の共有クレート`RPoem/open-runo-glyph`をサーバーの`open-cuda` sgemmで実行、1升約14ms)。**測定の正直な結果**: 合成のかすれ文書で、補正のみ48%→+かすれ補正89%→補完は初版86〜90%、連続文字+検索を加えた版は87%(880秒)で**逆効果**。
  精度優先に作り直したが**作り直し後の通し測定は未了**。AI文脈補完は**実験的・既定オフ**。詳細・試験手順・次の手は`pdf-r2l-rs/PORTING.md`(日英)。
  **VPS本番の`aruaru-llm`**: `/v1/ocr`・`/v1/ocr/fill`は反映済み。停止時点の追加分(`/scan`・`/propose`・`/glyph-rank`・`/charset`)は2026-10-10にビルド・反映(VPSにQwen未導入のため補完系は503が正常。VPSは4コア・RAM3.6GBなので補完は手元PCのaruaru-llmを使う運用)。

- **2026-11-18 公開ミラー自動バックアップ(別アカウントでの再開用・最新) / Public-mirror backup, latest**: 稼働中(ok143・warn32・blocked2〈RPoemのgitleaks1件・old.aon.tokyo〉・orphan3〈FastAPIM/MojoU/mfastapi〉)。**下の2026-10-08の「未了」は古い**(例外コミットはpush済み)。未了=RPoem検出の調査・孤立3件の扱い確認・warn確認。再開リポジトリ=`aon-co-jp-backup/backup-system`(新規clone)・`F:\runo`・`F:\aruaru-llm`・`aruaru-db-archive`。貼り付け用メッセージは[`PORTING.md`](PORTING.md)末尾(日英)。*Running; the 2026-10-08 open items below are stale. Open: RPoem finding, 3 orphans, 32 warnings. Paste-ready message at the end of PORTING.md.*
- **2026-10-08 公開ミラー自動バックアップ `aon-co-jp-backup/backup-system` 新設(シャットダウン時点の引き継ぎ)**: `aon-co-jp`の**公開**リポジトリのみを、
  GitHub Actions(3時間おき+手動)で検査・匿名化して`aon-co-jp-backup`へ同名ミラーする。検査=gitleaks全履歴・危険ファイル名・個人情報ルール
  (`scripts/pii_scan.py`)。コミットのメールはミラー側のみ匿名化。20MB超・モデル・`install/*/*.exe`はミラーに含めない。止めたものは`STATUS.md`に記録。
  個人情報の疑いは`aruaru-db-archive/quarantine/`(非公開)へ退避(`ARCHIVE_PAT`登録済み)。トークンは`F:\backup-token.txt`/`F:\archive-token.txt`(値は出さない)。
  **二次判定は見送り(ユーザー判断A)**: aruaru-llmの`POST /v1/classify-pii`は実装・push済み(5d65774)だがVPS未反映・非公開のまま、ルール検出のみで運用。
  **未了/再開ポイント**: (1)最後の変更(OnlineTimeRecorder系`db.sqlite3`の例外=架空データ、ユーザー確認済み)がGitHubへ未pushの可能性。ネットワーク不調(TLS timeout)で確認できず。
  `F:\backup-system-unpushed.bundle`に全コミットを退避済み(`git clone`して`aon-co-jp-backup/backup-system`へpush、`gh workflow run mirror.yml`)。
  (2)新規リポジトリ作成は二次レート制限のため1回5件・3時間おきで追いつく運用、全99件の完了確認。(3)止まったもの: old.aon.tokyo/open-bar/pinax(gitleaks検出、誤検知か要確認)。
  (4)open-english.sqlite3は空DBで例外登録済み。(5)既存RS-Sync(非公開、フィルター無し)との役割整理。

- **2026-09-30 音声・音質の研究を横断反映**: maid-cafe-seでの研究(音程と声の太さの独立制御、AI帯域拡張+声向けのロールオフ検出、
  日本語ニューラルTTSのライセンス調査、Rust化と音質の実測)を、ユーザー指示でaruaru-llm/open-english/maidcafe-programming-school/
  make-disk/maid-cafe-seへ反映した。コード変更が入ったのはmake-disk(声向けの帯域拡張モード`AudioBwe.speech`)とmaid-cafe-se(Rust
  `maid-cafe-core`/`maid-cafe-enhance`)。aruaru-llm・maidcafe-programming-schoolは音声実装が無くドキュメントのみ、open-englishは
  WEB版/ローカル版/ミックス版ごとの効き方を記録(コード変更なし、音声合成エンドポイントと共有ライブラリの置き場所は要決定)。
  各リポジトリの`CLAUDE.md`「音声・音質の研究の成果」節、正本は`maid-cafe-se/PORTING.md`「音質向上の研究」。
  **同日、音声処理をRPoemの共有クレート`open-runo-voice`(`RPoem/crates/open-runo-voice`、`docs/voice.md`)へ切り出した**(ユーザー指示、
  「汎用化できるロジックはRPoemへ」の方針どおり)。maid-cafe-coreはそれを再公開している。

- **2026-09-27 aruaru-vpn新設**: `open-tv-chat`/`open-LiveKit`開発中に
  「TV CHAT利用者向け汎用VPNアプリも同時開発してはどうか」との提案があり、
  (1)独立VPN事業として運営する案は各国VPN法規制・運営者責任を理由に見送り、
  (2)本来の目的を隠して別サイトとして配布する案は不誠実・検知回避リスクを
  理由に見送り、(3)最終的に[Outline VPN](https://getoutline.org/)/
  [Algo VPN](https://github.com/trailofbits/algo)と同じ「利用者自身が
  自分のVPS上に自分専用の中継を立てる、用途を隠さないOSSテンプレート」
  方式を採用し`aon-co-jp/aruaru-vpn`を新規作成。**aon-co-jpは中継サーバー
  を運営しない**のが最重要方針。透明性告知文(`TRANSPARENCY_NOTICE.md`、
  日英正本+`open-tv-chat`と同じ主要30ヶ国語、AI翻訳につきネイティブ検証前)
  も作成済み。実装は未着手。本`README.md`に`aruaru-vpn`行を追加。
- **2026-09-27 音声系5リポジトリ新設・統合、限界前の緊急チェックポイント**:
  open-bar(バグ修正・open-audioコンテナ再生・高音補正・PD音源テストフィクスチャ)、
  open-av(音声専用プロファイルをopen-mqa-dsdへ統合、映像専用の薄いクレートへ)、
  open-mqa-dsd(上記コンテナ実装を吸収、旧称「open-audio」は廃止し
  `"format": "open-mqa-dsd"`へ改称)、**新規`open-audio-sr`**(AudioSR実在の拡散モデルで
  音声帯域拡張、実機で定量検証済み)、**新規`open-music-llm`**(MusicGen実在のオーディオLLMで
  音楽生成、環境構築のみで生成自体は未検証のまま中断)。各リポジトリのCLAUDE.md/PORTING.mdに
  詳細な引き継ぎ・環境固有の既知の問題(このPCでのPython import異常な遅さ等)を記録済み。
  本`README.md`にopen-bar/open-av/open-mqa-dsd/open-audio-sr/open-music-llmの行を追加。
  ユーザーから「もうリミットなので」との指示によりドキュメント更新・pushのみで緊急停止。

- **2026-08-28 ドキュメント整理**: 作業ドライブ移行(`F:\open-runo`→
  `F:\runo`)は完了し`F:\open-runo`自体が削除されたため、移行途上を
  前提とした記述・重複clone(`F:\open-runo\aon`)に関する記述を全文
  削除し、現在の構成(`F:\runo`のみ)を前提とした簡潔な記述へ整理した。
- **2026-09-03 aruaru-dbセッション記録の同期**: `aruaru-db`の公式薄い
  コネクタ拡張(続き27〜33、Go/Java/.NET/Ruby/Mojo新設・.NET実バグ修正・
  Python asyncpgハング調査)の詳細は、このリポジトリ本来の役割(索引)を
  汚さないよう、詳細記録は[`PORTING.md`](PORTING.md)の
  「複数リポジトリ横断セッションチェックポイント」節(続き27・続き28)へ
  日英併記で集約した。`README.md`の`aruaru-db`行の役割要約は今回の
  コネクタ追加では実質的な変更が無いため無編集(索引は実装詳細ではなく
  役割サマリのみを持つ既存方針どおり)。

  **🔁 再開用メッセージ(次回このセッションを続ける人へ)**: aruaru-db
  リポジトリ側の正本は`aruaru-db/CLAUDE.md`の「🛑 再開用メッセージ」節
  (続き32時点)。未解決の残作業は (1) Go/Java/Rubyコネクタの実ビルド・
  実テスト(この開発機にツールチェーン無し)、(2) 4コネクタとも実サーバ
  往復(ライブE2E)が未実施(.NETのみ2026-09-03に完了、`NoTypeLoading`
  修正込み)、(3) Python `asyncpg`の接続ハング問題の原因調査
  (`clients/python-aruaru-db/README.md`に記録、`live-check.py`で再現可)、
  (4) Mojoコネクタの実コンパイル・実テスト(`mojo`ツールチェーン無し)。
  VPS(`ssh conoha`、`/root/repository/aruaru-db`)は`git pull`で追従済み
  (サーバ本体は無変更のためサービス再起動は都度不要、クライアント
  コネクタのみの変更)。
- **2026-09-15 open-english-pc再統合によるリポジトリ削除**: 2026-09-10に
  `open-english`から submodule 切り出ししていた`aon-co-jp/open-english-pc`
  (クライアント実装 `web/` `pc/` `tablet/` `mobile/`)を、ユーザー指摘
  (「わざわざopen-englishから独立させた意味が無い」——インストーラー
  組み立て・リリースCI・配信サーバーが分離後も本体側に残ったままで、
  分離の目的が実現されていなかったため)により履歴を保持して本体へ
  再統合し、`open-english-pc`リポジトリ自体を削除した。本`README.md`から
  `open-english-pc`の行を削除。
- **2026-09-26 open-tv-chat新設**: Skype風「世界約130ヶ国語リアルタイム
  音声翻訳」対応のTV会議/ビデオチャットアプリ構想を`aon-co-jp/open-tv-chat`
  として新規作成。`easy-web.tokyo`でWindows/macOS/Linux/Android/iPhone向け
  クライアントを配布し、利用者PCに`open-web-server`を立てRust+`RPoem`
  (Cosmo互換)で動かす構成。音声翻訳は2ヶ国語〜最大10ヶ国語同時対応、対応言語は
  「英語名(現地呼称) = ネイティブ表記」併記(例: Iran (Persia) = فارسی (Farsi))。
  現時点は設計ドキュメント(README/CLAUDE.md/PORTING.md)のみで実装は未着手、
  音声翻訳エンジン(ASR/MT/TTS)の選定が次回最優先課題。詳細は
  `open-tv-chat/PORTING.md`の「次回再開ポイント」を参照。本`README.md`には
  `open-tv-chat`行を追加(役割要約のみ、実装詳細は転記しない既存方針どおり)。
- **2026-09-26 open-LiveKit新設**: `open-tv-chat`の通話リレーサーバー
  (既定モードで相手にIP非開示、翻訳もサーバー側処理)に使うSFU技術として、
  LiveKit(Go+Pion製、Apache-2.0)/mediasoup/Janus/Jitsi Videobridge/自前実装
  のトレードオフを比較した結果、ユーザーの意向により「LiveKitのアーキテクチャ
  を参考に、コードは流用せず一からRust+RPoemで再実装する」方針となり、
  `aon-co-jp/open-LiveKit`を新規作成。じっくり時間をかけてGoogle検索・GitHub
  調査を行った上で設計・実装を進める方針(ユーザー指示)。現時点はLiveKitの
  アーキテクチャ調査(SFUモデル・ルーム管理・Redisによる水平スケーリング・
  gRPC+Protocol Buffersシグナリング等)のみ、実装は未着手。詳細は
  `open-LiveKit/PORTING.md`の「次回再開ポイント」(WebRTCスタックのwebrtc-rs
  vs str0m比較から着手)を参照。本`README.md`には`open-LiveKit`行を追加。
- **2026-09-26 open-LiveKit技術選定1〜5決定+aruaru-db-archive新設**:
  GitHub調査(スター数・実運用実績・ライセンス)に基づき(1)WebRTCスタック=
  webrtc-rs、(3)シグナリング=RPoem GraphQL Subscriptions、(4)Simulcastは
  フェーズ2見送り、(5)翻訳エンジンはAgentフック方式、を決定。(2)水平
  スケーリングはユーザー指示により「`aruaru-db`+PostgreSQLのDUAL DB
  (VPS高速キャッシュ)+非公開の`aon-co-jp/aruaru-db-archive`(Git-on-SQL
  経由の自動バックアップ)」の2層構成に確定(世界中からの大量アクセス時に
  VPSストレージが溢れるのを防ぐため、データが古くなると自動でGitHub側
  リポジトリへ同期・VPS側は破棄する設計、利用者端末側にも任意でログ保存
  できる選択肢を用意)。`aruaru-db-archive`を新規作成(非公開)、雛形README
  のみでVPS側の自動同期実装は未着手。詳細は`open-LiveKit/README.md`
  「技術選定の決定事項」を参照。本`README.md`には`aruaru-db-archive`行を追加。

## JSON処理の使用方針: `parse_secure_sonic`(速い型+安全)と`sonic-rs`は使える所では全て使う(2026-10-14、ユーザー指示)
正本は[`RS-JSON`](https://github.com/aon-co-jp/RS-JSON)(`README.md`・`PORTING.md`)。

**方針**: JSONを読む所は、使える所では**全て** `rust-json`(RS-JSON)の `parse_secure_sonic`(`fast`機能、結果は`sonic_rs::Value`)を使う。
`sonic-rs` を直接使える所(型付き構造体への読み込みなど)も同様。使えない所は `parse_secure`(結果は`serde_json::Value`)を使う。
外部から来る信頼できない入力(HTTP本文・ネットワーク越しのファイル・アップロード)は、**必ずサイズ・深さ・重複キーの上限つき**で読む。

**実測(7 MB・4万件)**: `serde_json` 200 ms / `parse_secure` 217 ms / **`parse_secure_sonic` 83 ms(約2.4倍速い、防御込み)** / `sonic-rs`そのまま 33 ms(約6倍、防御なし)。
`serde_json::Value`に読む限りSIMDでもほぼ速くならない(188 ms)。**速さの源は、結果を連続した領域に詰め込む値の型**。

**使える所 / 使えない所**
- ✅ 読み取り中心で、JSONを大きく・頻繁に読む所(キャッシュJSON、設定、APIの応答、ログ、インデックス)。
- ✅ 外部からの入力の入口(速さより防御が目的。`parse_secure`でも可)。
- ⚠️ `serde_json::Value`を関数間で受け渡している既存コードは、型を`sonic_rs::Value`に直す書き換えが要る(`JsonValueTrait`/`JsonContainerTrait`のメソッド)。書き換えずに`serde_json::Value`へ読むと速くならない。
- ❌ WASM(`rust_json::light`、依存ゼロ)、PHP/JavaScript側のJSON処理(Rustの部品は使えない)。
- 注意: 依存先の`sonic-rs`は内部で`unsafe`を使う(自前コードに`unsafe`は無い)。小さなJSON(数KB)では体感差が出ない。速度目的の書き換えは、実測で効く所から。

**導入**: `Cargo.toml`に `rust-json = { path = "../RS-JSON", features = ["fast"] }`。使用例は`RS-JSON/README.md`。

**このリポジトリでの適用状況**: 未適用(方針のみ)。コードの切り替えは、JSONを大きく・頻繁に読む所から実測して順に行う。

## JSON handling policy: use `parse_secure_sonic` (fast type + secure) and `sonic-rs` everywhere they can be used (2026-10-14, user instruction)
The source of truth is [`RS-JSON`](https://github.com/aon-co-jp/RS-JSON) (`README.md`, `PORTING.md`).

**Policy**: wherever JSON is read, use `parse_secure_sonic` from `rust-json` (RS-JSON, the `fast` feature; the result is `sonic_rs::Value`) **everywhere it can be used**.
Use `sonic-rs` directly where possible too (e.g. reading into typed structs). Where it cannot be used, use `parse_secure` (result: `serde_json::Value`).
Untrusted input from outside (HTTP bodies, files over the network, uploads) **must always be read with size / depth / duplicate-key limits**.

**Measured (7 MB, 40,000 records)**: `serde_json` 200 ms / `parse_secure` 217 ms / **`parse_secure_sonic` 83 ms (about 2.4x faster, with the defences)** / raw `sonic-rs` 33 ms (about 6x, no defences).
Reading into `serde_json::Value` gives almost no speed-up even with SIMD (188 ms). **The speed comes from the value type that packs the result into contiguous memory.**

**Where it can / cannot be used**
- ✅ Read-heavy code that parses large or frequent JSON (cache JSON, config, API responses, logs, indexes).
- ✅ Entrances for outside input (the goal there is defence rather than speed; `parse_secure` is fine).
- ⚠️ Existing code that passes `serde_json::Value` between functions needs its type changed to `sonic_rs::Value` (methods from `JsonValueTrait` / `JsonContainerTrait`). Reading into `serde_json::Value` without that change is not faster.
- ❌ WASM (`rust_json::light`, zero dependencies) and the JSON handling on the PHP / JavaScript side (Rust components cannot be used there).
- Note: the `sonic-rs` dependency uses `unsafe` internally (our own code has none). For small JSON (a few KB) the difference is not noticeable; do speed-motivated rewrites where measurements show a benefit.

**Adoption**: in `Cargo.toml`, `rust-json = { path = "../RS-JSON", features = ["fast"] }`. Example in `RS-JSON/README.md`.

**Status in this repository**: Not yet applied (policy only). Code will be switched over place by place, starting where measurements show large or frequent JSON reads.

## API 方針: REST 全廃・gRPC / Connect へ (2026-11-04)

### 日本語
- **REST は全廃する。新しい API は REST で作らない。** ブラウザや `curl` から呼ぶ API は **Connect の単純呼び出し**(`POST /<パッケージ>.<Service>/<Method>`、`content-type: application/json`、本文は JSON)、サービス間は **gRPC / gRPC-web**(RPoem の管理API `open_runo.admin.v1.Admin` と同じ流儀)。ストリーミングは、必要になってから。
- **既存の REST は、触るときに順に移す。** 移したら旧 REST の経路は消す。移行が終わるまで残るが、**新規には追加しない**。
- **JSON は RS-JSON に統一**する(読み込みは `from_str_secure` / `parse_secure` でサイズ・深さ・重複キーの上限つき、書き出しは `rust_json::fast`)。ブラウザの WASM に `prost` は入れない(サイズが増えるため)。
- **例外(自分たちの API ではなく、相手の規格が決めているもの)**: ACME、OAuth/OIDC のコールバック、第三者(GitHub など)からの Webhook、ヘルスチェック、静的ファイル配信、OTLP など。これらは規格どおりの HTTP を受ける。
- 参考実装: `RPoem`(`open_runo.admin.v1.Admin`)、`open-easy-web`(`server/src/connect.rs`、`proto/open_easy_web/admin/v1/admin.proto`)。
- ※ このリポジトリのコードが既に方針どおりかどうかは、各リポジトリの現状による。この節は方針の記録であり、コードの変更を意味しない。

### English
- **REST is being abolished. New APIs are not built as REST.** APIs called from browsers or `curl` use **Connect unary calls** (`POST /<package>.<Service>/<Method>`, `content-type: application/json`, JSON body); service-to-service calls use **gRPC / gRPC-web** (the same style as RPoem's admin API `open_runo.admin.v1.Admin`). Streaming only when it is actually needed.
- **Existing REST endpoints are migrated one by one, when they are touched.** The old REST route is removed once migrated. Until migration is finished they remain, but **no new ones are added**.
- **JSON is unified on RS-JSON**: reading with `from_str_secure` / `parse_secure` (size, depth and duplicate-key limits), writing with `rust_json::fast`. `prost` is not put into browser WASM (it would grow the binary).
- **Exceptions (shapes dictated by someone else's standard, not our own API)**: ACME, OAuth/OIDC callbacks, webhooks from third parties (e.g. GitHub), health checks, static file serving, OTLP, and so on. These accept plain HTTP as the standard requires.
- Reference implementations: `RPoem` (`open_runo.admin.v1.Admin`) and `open-easy-web` (`server/src/connect.rs`, `proto/open_easy_web/admin/v1/admin.proto`).
- Note: whether the code in a given repository already follows this policy depends on that repository. This section records the policy; it does not mean the code has been changed.

### Deutsch (KI-Übersetzung, redaktionell überarbeitet; noch nicht von Muttersprachlern geprüft)
- **REST wird vollständig abgeschafft; neue APIs entstehen nicht mehr als REST.** APIs, die aus dem Browser oder per `curl` aufgerufen werden, verwenden **unäre Connect-Aufrufe** (`POST /<Paket>.<Service>/<Methode>`, `content-type: application/json`, JSON-Body). Zwischen Diensten kommen **gRPC bzw. gRPC-web** zum Einsatz, im selben Stil wie die Admin-API von RPoem (`open_runo.admin.v1.Admin`). Streaming wird erst ergänzt, wenn es tatsächlich gebraucht wird.
- **Bestehende REST-Endpunkte werden schrittweise umgestellt, und zwar immer dann, wenn man ohnehin an ihnen arbeitet.** Sobald ein Endpunkt umgestellt ist, wird die alte REST-Route entfernt. Bis zum Abschluss der Migration bleiben die übrigen bestehen, es werden aber **keine neuen mehr hinzugefügt**.
- **JSON wird einheitlich über RS-JSON verarbeitet**: Gelesen wird mit `from_str_secure` bzw. `parse_secure` (mit Obergrenzen für Größe, Verschachtelungstiefe und doppelte Schlüssel), geschrieben mit `rust_json::fast`. `prost` wird nicht in das Browser-WASM aufgenommen, da es die Datei vergrößern würde.
- **Ausnahmen (Schnittstellen, deren Form ein fremder Standard vorgibt und die nicht zu unserer eigenen API gehören)**: ACME, OAuth/OIDC-Callbacks, Webhooks von Drittanbietern (z. B. GitHub), Health-Checks, die Auslieferung statischer Dateien, OTLP und Ähnliches. Diese nehmen, wie vom jeweiligen Standard verlangt, gewöhnliches HTTP entgegen.
- Referenzimplementierungen: `RPoem` (`open_runo.admin.v1.Admin`) und `open-easy-web` (`server/src/connect.rs`, `proto/open_easy_web/admin/v1/admin.proto`).
- Hinweis: Ob der Code eines einzelnen Repositorys diese Richtlinie bereits erfüllt, hängt vom jeweiligen Repository ab. Dieser Abschnitt dokumentiert lediglich die Richtlinie; er besagt nicht, dass der Code schon angepasst wurde.

### Русский (перевод выполнен с помощью ИИ и отредактирован; носителями языка пока не проверен)
- **От REST мы полностью отказываемся; новые API больше не создаются в стиле REST.** API, к которым обращаются из браузера или через `curl`, используют **унарные вызовы Connect** (`POST /<пакет>.<Service>/<Method>`, `content-type: application/json`, тело запроса — JSON). Для взаимодействия между сервисами применяются **gRPC и gRPC-web** — в том же стиле, что и административный API RPoem (`open_runo.admin.v1.Admin`). Потоковая передача данных добавляется лишь тогда, когда в ней действительно возникает необходимость.
- **Существующие REST-эндпоинты переводятся поэтапно — по мере того, как с ними приходится работать.** После перевода старый REST-маршрут удаляется. Пока миграция не завершена, оставшиеся эндпоинты сохраняются, но **новые не добавляются**.
- **Работа с JSON унифицирована на основе RS-JSON**: чтение — через `from_str_secure` или `parse_secure` (с ограничениями на размер, глубину вложенности и повторяющиеся ключи), запись — через `rust_json::fast`. `prost` в браузерный WASM не включается, поскольку это увеличило бы размер файла.
- **Исключения (интерфейсы, форму которых определяет чужой стандарт, а не наш собственный API)**: ACME, обратные вызовы OAuth/OIDC, вебхуки сторонних сервисов (например, GitHub), проверки работоспособности, раздача статических файлов, OTLP и тому подобное. Такие интерфейсы принимают обычный HTTP, как того требует соответствующий стандарт.
- Эталонные реализации: `RPoem` (`open_runo.admin.v1.Admin`) и `open-easy-web` (`server/src/connect.rs`, `proto/open_easy_web/admin/v1/admin.proto`).
- Примечание: соответствует ли код конкретного репозитория этой политике, зависит от самого репозитория. Данный раздел лишь фиксирует политику и не означает, что код уже изменён.

## API 方針の補足: 用語の整理と使い分け (2026-11-04)

### 日本語
**1つに統一するものではなく、別の層の話です。** 「REST の代わり」になるのは Connect・gRPC・GraphQL だけで、WASM は画面を作る技術です。

| 用語 | 何か | REST の代わりか |
|---|---|---|
| REST | URL と HTTP メソッドで操作を表す API の作り方 | 全廃する側 |
| **Connect** | `POST /サービス名/メソッド名` に JSON を送る形式。`curl` でもブラウザの `fetch` でも呼べる | はい(**採用**) |
| **gRPC** | 同じ「サービス/メソッド」の考え方を、バイナリ(protobuf)と HTTP/2 で行う形式。速く、ストリーミングも得意 | はい(**サービス同士に採用**) |
| gRPC-web | gRPC のブラウザ向けの変形版 | はい(必要なら) |
| GraphQL | 欲しい項目を問い合わせる形式 | 一部だけ(**問い合わせ(読み取り)専用**) |
| WASM | Rust をブラウザの中で動かす仕組み | いいえ(画面を作る技術) |

- **ブラウザの画面や `curl` から呼ぶ API は Connect**(POST、JSON を RS-JSON で読み書き)。ブラウザの WASM は素の gRPC を話せず、Connect なら `fetch` のままで、`prost` を足さずに済む(画面のサイズも増えない)。
- **サービス同士の通信(サーバー間、重い処理、ストリーミング)は gRPC。** 多くは Connect で足りるので、ストリーミングが必要になった所だけ gRPC に上げる。
- **GraphQL は、まとめて問い合わせたいときの読み取り専用。** 書き込み(操作)には使わない。
- **WASM は画面を作る技術として、そのまま使う。** 画面から呼ぶ API が Connect になっただけ。
- 外部の規格が形を決めるもの(ACME、OAuth のコールバック、第三者の Webhook、ヘルスチェック、静的ファイル、OTLP)は、規格どおりの HTTP のまま。
- **迷ったら Connect。**

### English
**These are not alternatives to unify; they sit at different layers.** Only Connect, gRPC and GraphQL can replace REST; WASM is a way to build the UI.

| Term | What it is | Replaces REST? |
|---|---|---|
| REST | API style that expresses operations through URLs and HTTP methods | The thing being abolished |
| **Connect** | `POST /Service/Method` with a JSON body; callable from `curl` and from a browser `fetch` | Yes (**adopted**) |
| **gRPC** | The same service/method idea over binary (protobuf) and HTTP/2; fast, good at streaming | Yes (**for service-to-service**) |
| gRPC-web | A browser-friendly variant of gRPC | Yes (if needed) |
| GraphQL | A query language: ask for exactly the fields you want | Partly (**read-only queries**) |
| WASM | Runs Rust inside the browser | No (a UI technology) |

- **APIs called from browser screens or `curl` use Connect** (POST, JSON read and written with RS-JSON). Browser WASM cannot speak plain gRPC; with Connect it stays a `fetch`, and `prost` is not needed (the binary does not grow).
- **Service-to-service calls (server to server, heavy work, streaming) use gRPC.** Connect is enough in most places; move a call to gRPC only where streaming is actually needed.
- **GraphQL is read-only**, for queries that gather several pieces of data. It is not used for writes (operations).
- **WASM stays as the way to build the UI.** The API it calls simply became Connect.
- Interfaces whose shape an outside standard dictates (ACME, OAuth callbacks, third-party webhooks, health checks, static files, OTLP) stay plain HTTP.
- **When in doubt, use Connect.**

### Deutsch (KI-Übersetzung, sprachlich überarbeitet; noch nicht von Muttersprachlern geprüft)
**Es geht nicht darum, eine einzige Technik auszuwählen – die Begriffe liegen auf unterschiedlichen Ebenen.** Als Ersatz für REST kommen nur Connect, gRPC und GraphQL in Frage; WASM dagegen ist eine Technik, mit der die Benutzeroberfläche gebaut wird.

| Begriff | Was ist das? | Ersatz für REST? |
|---|---|---|
| REST | Ein API-Stil, bei dem Operationen über URLs und HTTP-Methoden ausgedrückt werden | wird abgeschafft |
| **Connect** | `POST /Dienst/Methode` mit JSON im Body; aufrufbar mit `curl` ebenso wie mit `fetch` im Browser | ja (**gewählt**) |
| **gRPC** | Dasselbe Prinzip aus Dienst und Methode, aber über binäres protobuf und HTTP/2; schnell und gut für Streaming geeignet | ja (**zwischen Diensten**) |
| gRPC-web | Eine für den Browser angepasste Variante von gRPC | ja (bei Bedarf) |
| GraphQL | Abfragesprache, mit der man genau die benötigten Felder anfordert | teilweise (**nur für lesende Abfragen**) |
| WASM | Führt Rust-Code direkt im Browser aus | nein (Technik für die Oberfläche) |

- **APIs, die von Browseroberflächen oder per `curl` aufgerufen werden, verwenden Connect** (POST; JSON wird mit RS-JSON gelesen und geschrieben). WASM im Browser kann kein reines gRPC sprechen. Mit Connect bleibt es bei einem gewöhnlichen `fetch`, und `prost` ist nicht nötig – die WASM-Datei wird dadurch nicht größer.
- **Für die Kommunikation zwischen Diensten (Server zu Server, rechenintensive Aufgaben, Streaming) wird gRPC eingesetzt.** In den meisten Fällen reicht Connect aus; auf gRPC wird nur dort umgestellt, wo Streaming tatsächlich gebraucht wird.
- **GraphQL dient ausschließlich lesenden Abfragen**, wenn mehrere Informationen gebündelt abgefragt werden sollen. Für Schreibzugriffe (Operationen) wird es nicht verwendet.
- **WASM bleibt die Technik für die Oberfläche.** Geändert hat sich lediglich, dass die aufgerufene API nun auf Connect beruht.
- Schnittstellen, deren Form durch einen externen Standard festgelegt ist (ACME, OAuth-Callbacks, Webhooks von Drittanbietern, Health-Checks, statische Dateien, OTLP), bleiben gewöhnliches HTTP.
- **Im Zweifel: Connect.**

### Русский (перевод выполнен с помощью ИИ и литературно отредактирован; носителями языка пока не проверен)
**Это не варианты, из которых нужно выбрать один, а технологии разных уровней.** Заменить REST могут только Connect, gRPC и GraphQL; WASM же — это способ создания пользовательского интерфейса.

| Термин | Что это | Заменяет REST? |
|---|---|---|
| REST | Стиль построения API, при котором операции выражаются через URL и HTTP-методы | отменяется |
| **Connect** | `POST /Сервис/Метод` с телом в формате JSON; вызывается как из `curl`, так и из браузерного `fetch` | да (**выбран**) |
| **gRPC** | Тот же принцип «сервис — метод», но поверх двоичного формата protobuf и HTTP/2; работает быстро и хорошо подходит для потоковой передачи | да (**для связи между сервисами**) |
| gRPC-web | Адаптированный для браузера вариант gRPC | да (при необходимости) |
| GraphQL | Язык запросов: клиент запрашивает ровно те поля, которые ему нужны | частично (**только запросы на чтение**) |
| WASM | Позволяет выполнять код на Rust прямо в браузере | нет (технология для интерфейса) |

- **API, которые вызываются из браузерных интерфейсов или через `curl`, строятся на Connect** (POST; JSON читается и записывается через RS-JSON). Браузерный WASM не умеет работать с «чистым» gRPC. С Connect достаточно обычного `fetch`, а `prost` не требуется — размер WASM-файла не увеличивается.
- **Для обмена между сервисами (сервер — сервер, ресурсоёмкие задачи, потоковая передача) применяется gRPC.** В большинстве случаев достаточно Connect; на gRPC переходят только там, где потоковая передача действительно необходима.
- **GraphQL используется только для чтения**, когда нужно получить сразу несколько связанных данных. Для записи (операций) он не применяется.
- **WASM по-прежнему остаётся технологией для интерфейса.** Изменилось лишь то, что вызываемый им API теперь построен на Connect.
- Интерфейсы, форма которых задана внешним стандартом (ACME, обратные вызовы OAuth, вебхуки сторонних сервисов, проверки работоспособности, статические файлы, OTLP), остаются обычным HTTP.
- **Если есть сомнения — выбирайте Connect.**


## REST 全廃の編集記録・実施状況 (2026-11-06)

### 日本語
- **決定(2026-11-04、ユーザー)**: aon-co-jp 全リポジトリで REST API を廃止し、Connect(ブラウザ/`curl`)と gRPC / gRPC-web(サービス間)へ移す。方針の正本は [`API-POLICY.md`](API-POLICY.md)、担当への共通指示は [`API-MIGRATION-BRIEF.md`](API-MIGRATION-BRIEF.md)、残りの一覧は [`API-REST-REMAINING-20261106.md`](API-REST-REMAINING-20261106.md)。
- **2026-11-07 更新**: 残り**266本**(実質約214本。ows-base/ows-streamの52本は open-web-server 複製の二重計上)。open-gitea・open-redmine は自前で、2026-11-08 時点で Connect 移行済み(cargo test 36/96件成功、open-redmineは本番反映を確認済み・VPSのソースも整列済み)。詳細は `API-REST-REMAINING-20261106.md` 末尾。
- **実施状況(origin 基準の静的な目安)**: REST風ルート 509(11-04)→481(11-05)→**318(11-06)**。移行済み: open-english・aruaru-search・aruaru-llm・open-web-server・RS-Sync・RS-EC・RS-Blog(2026-11-07、本番で新401/旧404を実測、cargo test 48/27本成功)・aruaru.tokyo。ほぼ移行: aruaru-db(残8)。作業中: open-cosmo(残22)、RPoem(23、第1段階)。
- **未移行**: aruaru-IME 14(一部) ほか小規模(aon.tokyo・backup-to-discord-by-githubは2026-11-08に判定済み=移行済み/例外のみ)。**例外か自前かの判定待ち**: open-gitea・open-redmine(Gitea/Redmine互換なら例外)、ows-base・ows-stream(管理APIは自前なら移行)。
- **進め方**: 各リポジトリで 調査 → 分類(移す/例外/ブラウザGET) → 開発 → TEST → 記録(README/CLAUDE/PORTING/POLICY) → 本番反映。同時に動かす担当は最大2つ。例外は理由と規格URLつきで `version-control` の台帳へ。
- **正直な注意**: この節は記録であり、全リポジトリの完了を意味しない。各リポジトリへの同内容の追記は、担当セッションがそのリポジトリを移行する際に行う。本番反映済みと確認できたのは open-english(直接確認)と RS-Sync(担当報告)のみ。

### English
- **Decision (2026-11-04, user)**: abolish REST across all aon-co-jp repositories; move to Connect (browser/`curl`) and gRPC / gRPC-web (service-to-service). Policy source: `API-POLICY.md`; shared instructions: `API-MIGRATION-BRIEF.md`; remaining list: `API-REST-REMAINING-20261106.md`.
- **Status (static estimate, origin-based)**: REST-like routes 509 (11-04) → 481 (11-05) → **318 (11-06)**. Migrated: open-english, aruaru-search, aruaru-llm, open-web-server, RS-Sync. Nearly: aruaru-db (8 left). In progress: open-cosmo (22), RPoem (23, stage 1).
- **Not migrated**: RS-EC 28, RS-Blog 22, aruaru.tokyo 17, aruaru-IME 14, and small ones (aon.tokyo and backup-to-discord-by-github were classified on 2026-11-08: migrated / exceptions only). **Exception-or-own undecided**: open-gitea, open-redmine, ows-base, ows-stream.
- **Process**: per repository: survey → classify → build → test → record (README/CLAUDE/PORTING/POLICY) → deploy. At most two assignees at a time. Exceptions go to the `version-control` ledger with reason and standard URL.
- **Caveat**: this is a record, not a claim that every repository is done; each repository's own docs are updated by its assignee when it is migrated. Production deployment is confirmed only for open-english and RS-Sync.

- **2026-11-07 追記**: aruaru.tokyo は移行済み(本番実測で新200/旧404)。aruaru-IME は常駐エンジン・TSF/macOS/fcitx5/ibus が Connect 済みで旧経路は2026-12-06までの期限つき互換、オンライン画面(crossui→easy-web /ime/api)とAndroid upstreamは**未了**。詳細は`API-REST-REMAINING-20261106.md`末尾。
- **2026-11-08 aon.tokyo / backup-to-discord-by-github のREST全廃判定**: aon.tokyoは全ルートが表示ページ・静的・healthzで自前APIが0=すべて例外(コード変更なし)。bdgは管理APIが`9066b60`でConnect化済み・本番反映済み(旧`/api/jobs`=404を実測)、残りは`/healthz`とGitHub Webhookの例外。詳細は`API-REST-REMAINING-20261106.md`末尾。確認済み(11-08): `/video/fukuyama/`のディレクトリ404は仕様で動画ファイルは206公開、bdgはトークン付き`ListTargets`が200。*Both repos classified: aon.tokyo has no own API (all exceptions); bdg admin API already on Connect and deployed; the fukuyama files (206) and an authenticated bdg call (200) were verified.*
- **2026-11-08 open-cosmo/RPoem/aruaru-db の確認**: 3リポジトリとも自前RESTはほぼ解消(open-cosmo `6c67196`・RPoem `6ca9b74`・aruaru-db `849f082`)。RPoemの `/internal/db/mutate` は呼び出し側 open-web-server `Ledger` の同時改修が要るため未移行、SCIMは例外。本番は open-cosmo/RPoem が非稼働。詳細は `API-REST-REMAINING-20261106.md` 末尾。
- **2026-11-08 RPoem `/internal/db/mutate` 移行完了**: `Admin/DbMutate`(Connect、`x-api-key` 必須)へ移し、RPoem `781c824`・open-cosmo `132e300`・open-web-server `Ledger`(環境変数 `OPEN_RUNO_API_KEY`)を同時変更。VPSで一時起動して新401/400/200・旧404を実測。open-cosmo/RPoem/aruaru-db のテスト成功。残るRESTはSCIM等の例外のみ。
- **2026-11-08 追記**: aruaru-IME のオンライン画面・Android上流もConnect化し、v0.2.24をRelease/VPSで同版に揃えた。旧経路の削除は2026-12-06。実機(Android/Windowsインストーラー)は未確認。詳細は`API-REST-REMAINING-20261106.md`末尾。

- **2026-11-14 Ledger→RPoem接続の配線完了**: RPoemゲートウェイは稼働中(127.0.0.1:8140、aruaru-db接続)。open-web-serverの`admin.env`に`OPEN_RUNO_API_KEY`を追加して再起動(旧は`admin.env.before-apikey`)、5ドメインHTTPS 200・正キー=400(入力検証)/誤キー=401を実測。**2026-11-14追記**: VPSでLedgerと同形のDbMutateを実送信し、db_commit_id返却・同キー再送で同一受領票(冪等)を確認。RPoemのVPSクローンはorigin(36e9450)へ追従済み(再ビルドなし)。open-cosmo本体の本番起動は、RPoemゲートウェイと役割が重なるため判断待ち。*Gateway live; OWS now has OPEN_RUNO_API_KEY (restarted, 5 domains 200, right key→400, wrong key→401); real Ledger write verified via DbMutate with the same JSON shape (200 + db_commit_id, idempotent resend).*

## 配備アーキテクチャ方針: 共有基盤を1回だけ入れ、サイトごとのインストールは不要 (2026-11-09、ユーザー指示)

### 日本語
- **役割の対応**: `open-web-server` = Apache相当(前面のWebサーバー)、`RPoem` = Tomcat相当(アプリケーションサーバー)。
- **共有基盤**: `open-cuda`・`aruaru-llm`・`open-directx` などの計算/AI基盤は、**VPSに1回インストールすれば足りる**。**WEBサイトごとにインストールしない**。各サイトは、共有基盤をConnect/gRPCで呼ぶだけにする。
- **並行処理**: 共有基盤は非同期・マルチスレッドで、複数サイトからの同時要求(「分身の術」)をさばく。サイト間で状態を混ぜない(要求単位・テナント単位で分離)。
- **記録の位置づけ**: これは方針の記録であり、現状の実装がすでにこの形であることを意味しない。各リポジトリの現状(サイトごとに同梱・個別起動していないか、同時要求の上限・分離・タイムアウト)は、未調査。調査は別途行い、結果を `API-REST-REMAINING-20261106.md` 等へ追記する。

### English
- **Role mapping**: `open-web-server` ≈ Apache (front web server); `RPoem` ≈ Tomcat (application server).
- **Shared base**: compute/AI components such as `open-cuda`, `aruaru-llm`, `open-directx` need to be installed **once on the VPS**, not per website. Each site only calls the shared base over Connect/gRPC.
- **Concurrency**: the shared base serves concurrent requests from many sites asynchronously and multi-threaded (the "shadow-clone" model), isolated per request/tenant.
- **Status**: this records a policy, not that the current code already works this way. Per-repo status (bundled per site? concurrency limits, isolation, timeouts) is not yet surveyed.
- **2026-11-15 appserver系REST10本・open-raid-z管理UIのConnect化(別アカウントでの再開用) / appserver REST and open-raid-z UI moved to Connect**: **日本語**: RPoem `6ca9b74`・open-cosmo `6c67196` で `/admin/appserver-processes*`・`/admin/appserver-tenants*` 計10本を `Admin/AppServer*` RPC へ、open-easy-web `33863ad`(呼び出し元)、open-raid-z `bb31771`(`/api/status`・`/api/create`→`Admin/Status`・`CreatePool`)。aruaru-dbは旧REST0本(記録のみ `849f082`)。試験成功(router 180・gateway 3・easy-web 4・raid-z 実サーバー確認)。**未了**: RPoemゲートウェイ・open-easy-webのVPS反映、Connect経由の実プロセス起動試験。再開するリポジトリは RPoem・open-cosmo・open-raid-z・open-easy-web・`runo`。再開用メッセージは[`PORTING.md`](PORTING.md)末尾「2026-11-15 再開用メモ: appserver系REST・open-raid-z管理UIのConnect化」(日英)。**English**: RPoem `6ca9b74` and open-cosmo `6c67196` moved the 10 appserver REST routes to `Admin/AppServer*` RPCs; open-easy-web `33863ad` (caller); open-raid-z `bb31771` (`Admin/Status`, `CreatePool`); aruaru-db has no old REST left (`849f082`, docs). Tests pass. **Open**: VPS deployment of the RPoem gateway and open-easy-web, a real process-start test over Connect. Repos to resume: RPoem, open-cosmo, open-raid-z, open-easy-web, `runo`. Paste-ready resume message at the end of [`PORTING.md`](PORTING.md) (JA/EN).

## Windows インストーラー方針 / Windows installer policy
**日本語**: インストーラーを持つ製品の Windows 版は、すべて `.exe`(Inno Setup/NSIS、必要なら PyInstaller 同梱)で配布する。PowerShell スクリプトは開発用に残すだけで、利用者向けの入口にしない。RMojo は `RMojo-Setup-x64/arm64.exe` を配布済み、2FastAPI は v0.3.1 から `2FastAPI-Setup-x64/arm64.exe`。MFastAPI は pip の wheel 配布でインストーラーを持たない(Windows でも `pip install mfastapi`)。
**English**: Every product that has an installer ships its Windows build as an `.exe` (Inno Setup/NSIS, with PyInstaller bundling where needed); PowerShell scripts stay for development only. RMojo ships `RMojo-Setup-x64/arm64.exe`; 2FastAPI ships `2FastAPI-Setup-x64/arm64.exe` since v0.3.1. MFastAPI has no installer (wheel only: `pip install mfastapi`, also on Windows).

## 2026-11-18 Cloud9からの引っ越しセッションの記録 / Session record (moved from the Cloud9 account)
**日本語**
- **開発の場所のルール**: プログラムの開発・TEST・DEBUGはこのローカルPC(WSL含む)で行う。VPSは配備(バックアップ付き差し替え)と実測確認だけに使い、負荷をかける試験やデバッグはしない(ユーザー指示)。
- **aruaru-llm / RPoem: OCRフォント配信のConnect化の完了**。`GET /v1/ocr/fonts/:name` を廃止し `POST /aruaru_llm.v1.Llm/OcrFont`(JSON `{name}` → `{name, content_type, sha256, data_base64}`)へ移した。本番VPSは別セッションで反映済みで、手元ビルドとSHA256が一致、`OcrFont` 200・不明名404・旧経路404・エラーログ0を実測した。aruaru-llm・RPoemとも`main`反映済み、version-controlの例外追記は`3863140`で取り消し済み。
- **pdf-r2l-rs v1.3.2(告知とバグ修正)**: 古いクライアント(v1.3.1以前、`open-runo-pdf-ocr` rev `3b644db`)は新サーバーからフォントを取得できなくなるため、README/CLAUDE/PORTINGに日英で告知を追記した(`c346c8b`)。rev更新後に実フォント取得を試すと、`OcrFont`の応答(約13MB)が`ureq` 3の既定上限10MBを超えて失敗する不具合を発見。RPoem `bb3af78`で上限を256MBへ引き上げ(`open-runo-pdf-ocr`の`client.rs`)、revを更新して、本番から`NotoSansJP-VF.ttf`(9.59MB、sha256照合つき)の取得に成功した。v1.3.2をタグ公開し、リリースCIは全ジョブ成功(exe・setup・deb・tar.gz・apk)。macOS向けの添付はない。
- **RS-Sync 本番反映**: `88a90b6`(ログイン方式otp/otp_qr/qrとQR確認ログイン)をWSLでビルドし(glibc 2.39)、VPSの`rs-sync`と`rs-sync-demo`を、バックアップ(`rs-sync.before-login-20261118`)と失敗時の自動ロールバック付きで入れ替えた。`GetLoginMode`200・認証なし`ListAccounts`401(デモは200)・旧`/api/accounts`404・`/healthz`200・`/qr-confirm.html`200・エラーログ0を実測。未了=実スマホのQR撮影、実SMTPでの`otp_qr`通し、`login_mode`の永続化。**注意**: VPSの`rs-sync.service`にSMTPパスワードが平文の環境変数で書かれている(`EnvironmentFile=`+権限600への移設を推奨)。
- **aruaru-llm Generate遅延の調査(原因は未特定)**: 本番VPSで8トークンのGenerateが3回連続で150秒を超え、切断後も4コアが100%のまま計算が続き、`dispatch end`のログが25分以上出なかった。知識文脈(`Known facts`/ニュース)は最大3+3件で短く、プロンプト長は原因ではない。`idle_background_fold`は35秒ごとに動作。測定でVPSに負荷を積んだため、以後の再現・修正はローカルPCで行う。
- **maid-cafe-tokyo**: `aon-co-jp/maid-cafe-tokyo`(open-englishとrealdata.proの融合、運用先https://maid-cafe.tokyo)は既に存在する(新規作成は不要)。次の作業「質問に答えられないとき、GitHubのニュース・知識DBとaruaru-searchから類義語でも拾って答える補完」はこのリポジトリに入れる(未着手)。
- **未了(優先順)**: (1)Generate遅延の原因特定(WSLでローカル再現)と、要約が`llm_timeout_secs=45`に収まるかの確認、(2)答えられないときの補完(maid-cafe-tokyo)、(3)RS-Syncの実スマホQR・実SMTP試験、(4)VPSのaruaru-llmに積み上がった計算の解消(再起動するかはユーザー判断)。

**English**
- **Where to develop**: development, TEST and DEBUG happen on this local PC (including WSL). The VPS is used only for deployment (swap with a backup) and verification, never for load tests or debugging (user instruction).
- **aruaru-llm / RPoem: OCR font delivery moved to Connect (done)**. `GET /v1/ocr/fonts/:name` was removed and replaced by `POST /aruaru_llm.v1.Llm/OcrFont` (JSON `{name}` -> `{name, content_type, sha256, data_base64}`). Production had already been swapped by another session; its SHA256 matches the local build, and `OcrFont` 200, unknown name 404, old route 404 and zero error logs were measured. Both repos are on `main`, and the version-control exception entry was reverted (`3863140`).
- **pdf-r2l-rs v1.3.2 (notice and bug fix)**: old clients (v1.3.1 and earlier, `open-runo-pdf-ocr` rev `3b644db`) can no longer fetch fonts from the new server, so a bilingual notice was added to README/CLAUDE/PORTING (`c346c8b`). After bumping the rev, a real font fetch revealed that the ~13 MB `OcrFont` response exceeded `ureq` 3's default 10 MB body limit. RPoem `bb3af78` raises it to 256 MB (`client.rs` in `open-runo-pdf-ocr`); after the rev bump, `NotoSansJP-VF.ttf` (9.59 MB, sha256-verified) was fetched from production. v1.3.2 was tagged and all release CI jobs passed (exe, setup, deb, tar.gz, apk); there is no macOS asset.
- **RS-Sync production deploy**: `88a90b6` (login modes otp/otp_qr/qr and QR confirm login) was built in WSL (glibc 2.39) and swapped into `rs-sync` and `rs-sync-demo` on the VPS with a backup (`rs-sync.before-login-20261118`) and automatic rollback. Verified: `GetLoginMode` 200, unauthenticated `ListAccounts` 401 (200 on the demo), old `/api/accounts` 404, `/healthz` 200, `/qr-confirm.html` 200, no error logs. Open: a real phone-camera QR test, `otp_qr` with real SMTP, persisting `login_mode`. **Caution**: the VPS `rs-sync.service` holds the SMTP password as a plain environment variable (move it to `EnvironmentFile=` with mode 600).
- **aruaru-llm Generate slowness (cause not yet found)**: on the production VPS an 8-token Generate exceeded 150 s three times in a row; the four cores stayed at 100% after the clients disconnected and no `dispatch end` log appeared for over 25 minutes. The knowledge context (`Known facts` / news) is at most 3+3 items, so prompt length is not the cause. `idle_background_fold` runs every 35 s. The probing piled load onto the VPS, so reproduction and fixes now happen on the local PC.
- **maid-cafe-tokyo**: `aon-co-jp/maid-cafe-tokyo` (fusion of open-english and realdata.pro, served at https://maid-cafe.tokyo) already exists, so no new repository is needed. The next feature, answering with similar-word matches from the GitHub-stocked news / knowledge DB and aruaru-search when a question cannot be answered well, goes into that repository (not started).
- **Open (in priority order)**: (1) find the cause of the Generate slowness (reproduce in WSL) and check whether summaries fit `llm_timeout_secs=45`; (2) the answer-fallback feature (maid-cafe-tokyo); (3) real-phone QR and real-SMTP tests for RS-Sync; (4) clear the piled-up computation on the VPS aruaru-llm (restart is the user's call).

### 再開用メッセージ(2026-11-18、別アカウントでそのまま貼り付け) / Resume message
**日本語**: 前のセッションの続きです。開発・TEST・DEBUGはこのローカルPC(WSL含む)で行い、VPSは配備と実測確認だけに使ってください。`F:\runo\PORTING.md` 末尾「2026-11-18 Cloud9からの引っ越しセッションの記録」を読んでから再開します。完了済み=aruaru-llm OCRフォントのConnect化(本番・main反映・例外取り消し)、pdf-r2l-rs v1.3.2(告知とOcrFont応答上限の修正、RPoem `bb3af78`)、RS-Sync `88a90b6` の本番反映。未了(この順で): (1)aruaru-llm Generate遅延の原因特定をWSLのローカルで再現して行う(VPSで8トークンが150秒超・切断後も4コア100%、`dispatch end`が出ない。知識文脈は短く原因ではない)と、要約が`llm_timeout_secs=45`に収まるかの確認、(2)`aon-co-jp/maid-cafe-tokyo`(既存。open-englishとrealdata.proの融合、運用先https://maid-cafe.tokyo)に「質問に答えられないとき、GitHubのニュース・知識DBとaruaru-searchから類義語でも拾って答える補完」を実装、(3)RS-Syncの実スマホQR撮影・実SMTPでの`otp_qr`通し・`login_mode`永続化(`rs-sync.service`のSMTPパスワードの`EnvironmentFile=`移設も)、(4)VPSのaruaru-llmに積み上がった計算の解消(再起動はユーザーに確認してから)。決まり: 新しいRESTは作らない(Connectのみ)、秘密は表示しない、実機で確認してから完了と報告する、返答は日本語のみ、pushやタグは確認してから。
**English**: Continuing from the previous session. Develop, TEST and DEBUG on this local PC (including WSL); use the VPS only for deployment and verification. Read "2026-11-18 Cloud9からの引っ越しセッションの記録" at the end of `F:\runo\PORTING.md` first. Done: aruaru-llm OCR font delivery on Connect (production, main, exception reverted), pdf-r2l-rs v1.3.2 (notice and the OcrFont response-limit fix, RPoem `bb3af78`), RS-Sync `88a90b6` deployed. Open (in this order): (1) find the cause of the aruaru-llm Generate slowness by reproducing it locally in WSL (on the VPS 8 tokens took over 150 s, four cores stayed at 100% after disconnect, no `dispatch end`; the knowledge context is short and not the cause), then check whether summaries fit `llm_timeout_secs=45`; (2) in `aon-co-jp/maid-cafe-tokyo` (existing; fusion of open-english and realdata.pro, served at https://maid-cafe.tokyo) implement the answer fallback that draws on the GitHub-stocked news / knowledge DB and aruaru-search, including similar words, when a question cannot be answered well; (3) RS-Sync: a real phone-camera QR test, an `otp_qr` run with real SMTP, persisting `login_mode` (and move the SMTP password in `rs-sync.service` to `EnvironmentFile=`); (4) clear the piled-up computation on the VPS aruaru-llm (ask the user before restarting). Rules: no new REST (Connect only), never print secrets, verify on real systems before reporting done, reply in Japanese only, confirm before pushing or tagging.

## 製品紹介URLの`/demo`ルール / `/demo` rule for product pages (2026-11-19)
**日本語**: 各製品の紹介URL(`easy-web.tokyo/<製品>`)の後ろに`/demo`を付けたページを置き、説明・最新版(GitHub Releases)・Windows版`.exe`のダウンロード(SHA-256付き、署名なしならそう明記)を載せる。`easy-web.tokyo`トップには全公開リポジトリの説明一覧があり、既定は重要・使用度順、ABC順に切替可(`open-easy-web/server/src/all_repos.rs`は生成物)。済み: RPoRea・Reaxt・2FastAPI系・MFastAPI・RMojo・2Poem、および`scripts/gen-demo.py`で生成した15製品(open-giteaは本体が`/`を使うため未対応、360-speakerは`web/demo`に配置)。.exeが無い製品はその旨を表示。 **English**: Every product page `easy-web.tokyo/<product>` gets a `/demo` page with an explanation, the latest version (GitHub Releases) and a Windows `.exe` download (with SHA-256; say so if unsigned). The top page lists every public repository, default order by importance/usage, switchable to A-Z. Done: RPoRea, Reaxt.

## インストール先ルール / Install location rule (2026-11-19, ユーザー指示)
**日本語**: aruaru-llm・open-directx・open-cuda・open-cpu など関連コンポーネントは、既定で`C:\aon-co-jp\open-easy-web\`以下に入れる。インストーラーでドライブ・フォルダーは選択可能。open-easy-webのInno Setup・`install.ps1`・`uninstall.ps1`は対応済み(aruaru-llmは`{app}\aruaru-llm`、取得は既定オン)。**未了**: open-cuda・open-cpuはaruaru-llmへ静的リンクのため単独の配置物が無く、open-directxは独立の配布物が未確認。インストーラーのビルドと実機の通し試験も未実施。 **English**: Related components (aruaru-llm, open-directx, open-cuda, open-cpu, ...) install under `C:\aon-co-jp\open-easy-web\` by default, and the installer lets the user pick the drive/folder. Done in open-easy-web's Inno Setup, `install.ps1` and `uninstall.ps1` (aruaru-llm goes to `{app}\aruaru-llm`, now checked by default). **Open**: open-cuda/open-cpu are statically linked into aruaru-llm (no separate files), open-directx has no standalone release yet; the installer was not built or tested on a real machine.

## 2026-11-19 方針: Node.js・REST API を使わない / JSONはRS-JSONだけ(日本語)
- **やること**: Node.js と REST API をやめます。JSONは `RS-JSON` だけで読み書きし、ほかのJSON部品(`serde_json`・`nlohmann` など)と**二重に使いません**。
- **済んだこと**: `whisper.cpp` の fork(`aon-co-jp/whisper.cpp`)から Node.js アドオン `examples/addon.node` と専用CIを消しました。洗い出しの結果は [`NODEJS-REMAINING-20261119.md`](NODEJS-REMAINING-20261119.md)。
- **まだのこと**: (1)置き換えられるもの(`open-upstream-watch` の試験、`Reaxt/clients/js`、`2Poem` の例)、(2)JSONの二重使用の洗い出し、(3)Node.jsが必須のもの(VS Code拡張、Tauriの画面ビルド)は、やめてよいか本人の判断待ち、(4)`whisper.cpp` の `examples/server`(REST+nlohmann)。
- **VPS**: `whisper.cpp` のVPSのクローンは2コミット遅れのまま(未更新)。


### English (simple words, easy to read)
- **What we do**: We stop using Node.js and REST APIs. We read and write JSON with `RS-JSON` only. We do **not** use two JSON tools at the same time (for example `serde_json` or `nlohmann` together with RS-JSON).
- **What is done**: In our copy of `whisper.cpp` (`aon-co-jp/whisper.cpp`), we deleted the Node.js add-on `examples/addon.node` and the tests that only ran it. The full list is in [`NODEJS-REMAINING-20261119.md`](NODEJS-REMAINING-20261119.md).
- **What is not done yet**: (1) things we can replace now (the `open-upstream-watch` test, `Reaxt/clients/js`, the `2Poem` example); (2) finding places that use two JSON tools; (3) things that really need Node.js (VS Code extensions, Tauri screen builds) - we wait for the owner to decide; (4) `examples/server` in `whisper.cpp` (REST + nlohmann).
- **VPS**: the VPS copy of `whisper.cpp` is still 2 commits behind (not updated).

## 2026-11-19 大きなモデル対応の調査と分割重み対応 / Large-model research and sharded weights (10 languages)

### 日本語
- **結論**: 東芝のシミュレーテッド分岐(SB)は**組合せ最適化(イジング/QUBO)の高速解法**で、LLMの推論そのものを速める技術ではない。使えるとすれば「どのエキスパート/層をGPU・RAM・ディスクのどこへ置くか」の配置計画をQUBOにする案だが、**効果は未検証**。DeepSeekの「折り畳み」に当たる技術は特定できていない。候補はMLA(KVキャッシュの低ランク圧縮)、MoE、FP8(論文では学習用)。MLA・MoEの遅延読み込みは`open-cuda`の`deepseek_arch.rs`に実装済み。
- **実装済み(main)**: Qwen2.5の分割重み(`model.safetensors.index.json`+複数ファイル)の取得(`aruaru-llm`、単一ファイルが404のときだけ分割取得、ストリーム書き込み)と読み込み(`open-cuda-llm`)。モックと合成データのテスト成功。実在の3Bは2分割・6.17GBと確認。
- **未了**: 実3Bの読み込み実測(f32展開で約12GB+生6GB、空きRAM約15GBでは危険)、7B(約15GB)はf32では32GB機に入らず遅延読み込み/量子化が必要、SB配置案の試作、DeepSeekの指す技術の確認(**ユーザーに要確認**)、CPU速度の実測。

### English
- **Findings**: Toshiba's Simulated Bifurcation (SB) is a fast solver for **combinatorial optimization (Ising/QUBO)**; it does not speed up LLM inference itself. The only plausible use is planning where experts/layers live (GPU, RAM, disk) as a QUBO, which is **unproven**. We could not identify what "DeepSeek folding" means; candidates are MLA (low-rank KV-cache compression), MoE, and FP8 (training-side in the paper). MLA and lazy MoE loading already exist in `open-cuda`'s `deepseek_arch.rs`.
- **Done (main)**: sharded Qwen2.5 weights (`model.safetensors.index.json` plus several files): download in `aruaru-llm` (only when the single file returns 404, streamed to disk) and loading in `open-cuda-llm`. Mock and synthetic tests pass. The real 3B model is confirmed to be 2 shards, 6.17 GB.
- **Open**: a real 3B load measurement (f32 expansion is about 12 GB plus 6 GB raw; risky with about 15 GB free), 7B (about 15 GB) does not fit a 32 GB machine in f32 and needs lazy loading or quantization, a prototype of SB placement, confirming what DeepSeek technique is meant (**ask the user**), CPU speed measurements.

### 简体中文
- **结论**:东芝的模拟分岔(SB)是**组合优化(Ising/QUBO)的快速求解方法**,并不能直接加速大模型推理。唯一可能的用法是把专家/层放在GPU、内存、磁盘哪里的规划写成QUBO,**效果未验证**。"DeepSeek折叠"具体指什么尚未确定,候选有MLA(KV缓存低秩压缩)、MoE、FP8(论文中用于训练)。MLA与MoE延迟加载已在`open-cuda`的`deepseek_arch.rs`中实现。
- **已完成(main)**:支持分片权重(`model.safetensors.index.json`+多个文件)的下载(`aruaru-llm`,仅在单文件返回404时启用,流式写盘)与加载(`open-cuda-llm`);模拟与合成测试通过。真实3B为2个分片、6.17GB。
- **未完成**:真实3B加载实测、7B(约15GB)需延迟加载或量化、SB配置原型、向用户确认DeepSeek所指技术、CPU速度实测。

### 繁體中文
- **結論**:東芝的模擬分岔(SB)是**組合最佳化(Ising/QUBO)的快速求解法**,並不能直接加速大型模型推論。唯一可能的用途是把專家/層放在GPU、記憶體、磁碟何處的規劃寫成QUBO,**效果未驗證**。「DeepSeek摺疊」具體指什麼尚未確定,候選為MLA(KV快取低秩壓縮)、MoE、FP8(論文中用於訓練)。MLA與MoE延遲載入已在`open-cuda`的`deepseek_arch.rs`實作。
- **已完成(main)**:支援分片權重(`model.safetensors.index.json`+多個檔案)的下載(`aruaru-llm`,僅在單檔回傳404時啟用,串流寫入)與載入(`open-cuda-llm`);模擬與合成測試通過。真實3B為2個分片、6.17GB。
- **未完成**:真實3B載入實測、7B(約15GB)需延遲載入或量化、SB配置原型、向使用者確認DeepSeek所指技術、CPU速度實測。

### 한국어
- **결론**: 도시바의 시뮬레이티드 분기(SB)는 **조합 최적화(Ising/QUBO)의 빠른 풀이법**이며 LLM 추론 자체를 빠르게 하지는 않습니다. 전문가/레이어를 GPU·RAM·디스크 어디에 둘지의 배치 계획을 QUBO로 만드는 용도만 생각할 수 있고 **효과는 검증되지 않았습니다**. "DeepSeek 접기"가 무엇인지는 특정하지 못했으며 후보는 MLA(KV 캐시 저랭크 압축), MoE, FP8(논문에서는 학습용)입니다. MLA와 MoE 지연 로딩은 `open-cuda`의 `deepseek_arch.rs`에 이미 구현되어 있습니다.
- **완료(main)**: 분할 가중치(`model.safetensors.index.json`+여러 파일)의 다운로드(`aruaru-llm`, 단일 파일이 404일 때만, 스트리밍 저장)와 로딩(`open-cuda-llm`). 모의·합성 테스트 통과. 실제 3B는 2분할, 6.17GB.
- **미완료**: 실제 3B 로딩 측정, 7B(약 15GB)는 지연 로딩/양자화 필요, SB 배치 시제품, DeepSeek가 가리키는 기술 확인(사용자에게 질문 필요), CPU 속도 측정.

### Deutsch
- **Ergebnis**: Toshibas Simulated Bifurcation (SB) ist ein schneller Löser für **kombinatorische Optimierung (Ising/QUBO)** und beschleunigt die LLM-Inferenz selbst nicht. Denkbar ist nur, die Platzierung von Experten/Schichten (GPU, RAM, Festplatte) als QUBO zu planen; **die Wirkung ist ungeprüft**. Was mit „DeepSeek-Faltung“ gemeint ist, konnten wir nicht klären; Kandidaten sind MLA (Low-Rank-Kompression des KV-Caches), MoE und FP8 (im Paper fürs Training). MLA und verzögertes MoE-Laden gibt es bereits in `deepseek_arch.rs` von `open-cuda`.
- **Erledigt (main)**: geteilte Gewichte (`model.safetensors.index.json` plus mehrere Dateien): Download in `aruaru-llm` (nur wenn die Einzeldatei 404 liefert, gestreamt) und Laden in `open-cuda-llm`. Mock- und Synthetiktests bestehen. Das echte 3B-Modell hat 2 Teile, 6,17 GB.
- **Offen**: Messung mit echtem 3B, 7B (ca. 15 GB) braucht verzögertes Laden oder Quantisierung, SB-Prototyp, Klärung der gemeinten DeepSeek-Technik (Nutzer fragen), CPU-Geschwindigkeit.

### Français
- **Conclusion** : la bifurcation simulée (SB) de Toshiba est un solveur rapide d'**optimisation combinatoire (Ising/QUBO)** ; elle n'accélère pas l'inférence des LLM elle-même. Seul usage plausible : planifier le placement des experts/couches (GPU, RAM, disque) sous forme de QUBO, **non vérifié**. Nous n'avons pas pu identifier ce que désigne le « pliage DeepSeek » ; candidats : MLA (compression de rang faible du cache KV), MoE, FP8 (pour l'entraînement dans l'article). MLA et le chargement paresseux du MoE existent déjà dans `deepseek_arch.rs` d'`open-cuda`.
- **Fait (main)** : poids fragmentés (`model.safetensors.index.json` et plusieurs fichiers) : téléchargement dans `aruaru-llm` (seulement si le fichier unique renvoie 404, écriture en flux) et chargement dans `open-cuda-llm`. Tests simulés et synthétiques réussis. Le vrai 3B compte 2 fragments, 6,17 Go.
- **À faire** : mesure avec le vrai 3B, le 7B (≈15 Go) exige chargement paresseux ou quantification, prototype SB, confirmer la technique DeepSeek visée (demander à l'utilisateur), vitesse CPU.

### Español
- **Conclusión**: la bifurcación simulada (SB) de Toshiba es un solucionador rápido de **optimización combinatoria (Ising/QUBO)**; no acelera la inferencia del LLM en sí. Lo único plausible es planificar dónde colocar expertos/capas (GPU, RAM, disco) como QUBO, **sin verificar**. No pudimos identificar qué es el «plegado de DeepSeek»; candidatos: MLA (compresión de rango bajo de la caché KV), MoE y FP8 (en el artículo, para entrenamiento). MLA y la carga perezosa de MoE ya existen en `deepseek_arch.rs` de `open-cuda`.
- **Hecho (main)**: pesos fragmentados (`model.safetensors.index.json` y varios archivos): descarga en `aruaru-llm` (solo si el archivo único da 404, en flujo) y carga en `open-cuda-llm`. Pruebas simuladas y sintéticas correctas. El 3B real tiene 2 fragmentos, 6,17 GB.
- **Pendiente**: medir con el 3B real, el 7B (≈15 GB) requiere carga perezosa o cuantización, prototipo SB, confirmar qué técnica de DeepSeek se pretende (preguntar al usuario), velocidad en CPU.

### Português
- **Conclusão**: a bifurcação simulada (SB) da Toshiba é um solucionador rápido de **otimização combinatória (Ising/QUBO)**; ela não acelera a inferência do LLM em si. O único uso plausível é planejar onde colocar especialistas/camadas (GPU, RAM, disco) como QUBO, **não verificado**. Não conseguimos identificar o que é o «dobramento da DeepSeek»; candidatos: MLA (compressão de baixo posto do cache KV), MoE e FP8 (no artigo, para treino). MLA e o carregamento preguiçoso de MoE já existem em `deepseek_arch.rs` do `open-cuda`.
- **Feito (main)**: pesos fragmentados (`model.safetensors.index.json` e vários arquivos): download no `aruaru-llm` (só se o arquivo único retornar 404, em fluxo) e carregamento no `open-cuda-llm`. Testes simulados e sintéticos passam. O 3B real tem 2 fragmentos, 6,17 GB.
- **Pendente**: medição com o 3B real, o 7B (≈15 GB) exige carregamento preguiçoso ou quantização, protótipo SB, confirmar a técnica da DeepSeek pretendida (perguntar ao usuário), velocidade em CPU.

### Русский
- **Вывод**: имитация бифуркации (SB) Toshiba — быстрый решатель **комбинаторной оптимизации (Ising/QUBO)**, она не ускоряет сам вывод LLM. Единственное правдоподобное применение — планирование размещения экспертов/слоёв (GPU, ОЗУ, диск) в виде QUBO, **не проверено**. Что такое «складывание DeepSeek», выяснить не удалось; кандидаты: MLA (низкоранговое сжатие KV-кэша), MoE и FP8 (в статье — для обучения). MLA и отложенная загрузка MoE уже есть в `deepseek_arch.rs` проекта `open-cuda`.
- **Готово (main)**: разделённые веса (`model.safetensors.index.json` и несколько файлов): загрузка в `aruaru-llm` (только если одиночный файл даёт 404, потоковая запись) и чтение в `open-cuda-llm`. Тесты на имитации и синтетике проходят. Настоящая 3B — 2 части, 6,17 ГБ.
- **Не сделано**: замер на настоящей 3B, 7B (≈15 ГБ) требует отложенной загрузки или квантования, прототип SB, уточнить у пользователя, какая техника DeepSeek имеется в виду, скорость на CPU.

## 2026-11-19 大きなAIモデルを動かす取り組みの現状 / Running bigger AI models: status and plan

### 日本語(やさしい説明)
**いまできること**
- 大きなAIモデルは、重さが1つのファイルでなく「いくつかに分かれたファイル」で配られることがあります。これを**自動で全部ダウンロードして、読み込める**ようになりました(`aruaru-llm` と `open-cuda`)。
- 本物の Qwen2.5-3B(約6GB、2つに分割)を、このパソコン(メモリ32GB、GPUなし)で**実際に読み込んで文章を作れる**ことを確かめました。読み込み約48秒、文章づくりは1秒に約0.6語(遅いけれど動きます)。
- 読み込みは「ファイルを丸ごとメモリに入れず、必要な所だけ読む」やり方に変えたので、メモリの使いすぎが減りました。

**調べて分かったこと**
- 東芝の「シミュレーテッド分岐」や富士通の「デジタルアニーラ」は、「たくさんの選択肢から一番よい組み合わせを探す」道具です。AIの文章づくりを直接速くする道具ではありません。使うなら「どの部品をどこに置くか」「どの部分を何ビットに縮めるか」を決める所です(研究論文はまだ少ない)。
- 「折り畳み(Model Folding)」は、似た部分をまとめてモデルを小さくする方法です。DeepSeek の MLA(記憶の圧縮)・MoE(専門家を必要な分だけ使う)・FP8(数を小さく表す)も同じ仲間の工夫です。
- 実験: 学習済みの Qwen に後からMLA圧縮をかけると、記憶を25%減らしただけで品質が落ち(迷い度 7.1→12.7)、50%減らすと文が壊れました。**後付けのMLAは使えない**と分かりました(DeepSeekは最初からその形で学習しています)。

**これから作るもの(確認なしで順に進めます)**
1. 重みを小さい数(f16や量子化)のまま使って、7B級(約12GB)もこのパソコンで動かす。
2. 層ごと・専門家ごとに「何ビットにするか」を自動で決める(まずは普通の計算、あとで焼きなましやSBも試す)。
3. 似た層をまとめる「折り畳み」を試し、品質と速さを必ず測る。
4. 速さの測定を毎回記録し、実用になるまで作る・試す・直すを何度も繰り返す。

**約束**: 未了の作業は、危険でない限り**いちいち確認せず進めます**。ただし、取り返しのつかない削除や、秘密の公開はしません。結果が悪かったときは、悪かったと正直に書きます。

### English (plain words, easy to read)
**What works now**
- Big AI models are often shipped as **several files** instead of one. The program can now **download all the parts and load them** (`aruaru-llm` and `open-cuda`).
- We loaded the real Qwen2.5-3B model (about 6 GB, 2 parts) on this PC (32 GB memory, no GPU) and **it wrote text**. Loading took about 48 seconds; writing was about 0.6 words per second (slow, but it works).
- Loading now reads only the parts it needs instead of copying whole files into memory, so it uses less memory.

**What we learned**
- Toshiba's "Simulated Bifurcation" and Fujitsu's "Digital Annealer" help **pick the best combination from many choices**. They do not make an AI write faster by themselves. They could help decide where to put each part, or how many bits each part gets (papers on this are still few).
- "Model folding" means merging similar parts to make a model smaller. DeepSeek's MLA (memory compression), MoE (use only the needed experts) and FP8 (small numbers) are cousins of this idea.
- Our test: adding MLA compression to an already-trained Qwen cut memory by 25% but made quality worse (perplexity 7.1 to 12.7), and a 50% cut broke the text. **Adding MLA afterwards does not work** (DeepSeek trains with it from the start).

**What we will build next (we go on without asking)**
1. Keep weights in small numbers (f16 or quantized) so 7B-size models (about 12 GB) can run on this PC.
2. Choose bits per layer and per expert automatically (plain math first, annealing or SB later).
3. Try "folding" similar layers, and always measure quality and speed.
4. Record every speed test, then build, test and fix again and again until it is truly useful.

**Promise**: for unfinished work we **go on without asking each time**, unless it is dangerous. We never do irreversible deletes or publish secrets. If a result is bad, we say so honestly.

## 2026-11-19 大きなAIを小さなパソコンで動かす / Running big AI on a small PC (10 languages, easy words)

### 日本語
**できたこと**: 大きなAIは、重さが「いくつかのファイル」に分かれていることがあります。それを自動でぜんぶダウンロードして、読めるようになりました。本物のAI(Qwen 3B、約6GB)を、GPUのないふつうのパソコンで動かして、文章を作れました。ちょっと遅いけれど、ちゃんと動きます。
**わかったこと**: 東芝や富士通の「最適な組み合わせを探す機械」は、AIを直接速くする道具ではありません。「どの部品を何ビットに縮めるか」を決める手伝いに使えるかもしれません。作ったあとの記憶の圧縮(MLA)は、品質が落ちるので使えませんでした。
**これから**: AIの重さを小さい数で持って、もっと大きなAI(約12GB)も動かします。「確認しないで進める」ので、止まらずに作って、試して、直します。

### English
**Done**: Big AI models often come in several files. The program now downloads every part and loads them. We ran a real AI (Qwen 3B, about 6 GB) on an ordinary PC without a GPU, and it wrote text. It is a bit slow, but it works.
**Learned**: The "best-combination finder" machines from Toshiba and Fujitsu do not make AI faster by themselves. They might help decide how many bits each part gets. Squeezing the memory afterwards (MLA) hurt quality, so we cannot use it.
**Next**: Keep the AI's weights in small numbers so even bigger AI (about 12 GB) can run. We go on without asking each time: build, test and fix again and again.

### 简体中文
**已完成**:大型AI的权重常被拆成好几个文件。现在程序能自动全部下载并读取。我们在没有显卡的普通电脑上运行了真正的AI(Qwen 3B,约6GB),它能写出文字。虽然有点慢,但是能用。
**发现**:东芝和富士通那种"找最佳组合的机器"不能直接让AI变快,也许能帮忙决定每个部分用几位数。事后压缩记忆(MLA)会让质量变差,所以不能用。
**接下来**:用更小的数字保存权重,让更大的AI(约12GB)也能运行。我们不会每次都问,而是不停地做、测、改。

### 繁體中文
**已完成**:大型AI的權重常被拆成好幾個檔案。現在程式能自動全部下載並讀取。我們在沒有顯示卡的一般電腦上執行了真正的AI(Qwen 3B,約6GB),它能寫出文字。雖然有點慢,但可以用。
**發現**:東芝和富士通那種「找最佳組合的機器」不能直接讓AI變快,也許能幫忙決定每個部分用幾位元。事後壓縮記憶(MLA)會讓品質變差,所以不能用。
**接下來**:用更小的數字保存權重,讓更大的AI(約12GB)也能執行。我們不會每次都詢問,而是不停地做、測、改。

### 한국어
**해낸 일**: 큰 AI는 무게(가중치)가 여러 파일로 나뉘어 있을 때가 많아요. 이제 프로그램이 전부 자동으로 내려받아 읽을 수 있어요. 그래픽카드가 없는 보통 컴퓨터에서 진짜 AI(Qwen 3B, 약 6GB)를 돌려 글을 만들었어요. 조금 느리지만 잘 돼요.
**알게 된 것**: 도시바와 후지쯔의 "가장 좋은 조합을 찾는 기계"는 AI를 직접 빠르게 하지는 않아요. 각 부분을 몇 비트로 줄일지 정하는 데 도움이 될 수는 있어요. 나중에 기억을 줄이는 방법(MLA)은 품질이 떨어져서 쓸 수 없었어요.
**앞으로**: 무게를 더 작은 숫자로 들고 있어서 더 큰 AI(약 12GB)도 돌릴 거예요. 매번 묻지 않고 만들고, 시험하고, 고치기를 계속해요.

### Deutsch
**Geschafft**: Große KI-Modelle bestehen oft aus mehreren Dateien. Das Programm lädt jetzt alle Teile selbst herunter und liest sie. Wir haben eine echte KI (Qwen 3B, etwa 6 GB) auf einem normalen PC ohne Grafikkarte laufen lassen, und sie hat Text geschrieben. Etwas langsam, aber es klappt.
**Gelernt**: Die „Maschinen, die die beste Kombination suchen“ von Toshiba und Fujitsu machen eine KI nicht von selbst schneller. Sie könnten helfen zu entscheiden, wie viele Bits jeder Teil bekommt. Das nachträgliche Zusammendrücken des Gedächtnisses (MLA) machte die Qualität schlechter, deshalb nutzen wir es nicht.
**Als Nächstes**: Die Gewichte in kleineren Zahlen speichern, damit noch größere KI (etwa 12 GB) läuft. Wir machen ohne Rückfrage weiter: bauen, testen, verbessern, immer wieder.

### Français
**Fait** : Les grosses IA sont souvent livrées en plusieurs fichiers. Le programme télécharge maintenant toutes les parties et les lit. Nous avons fait tourner une vraie IA (Qwen 3B, environ 6 Go) sur un PC ordinaire sans carte graphique, et elle a écrit du texte. C'est un peu lent, mais ça marche.
**Appris** : Les « machines qui cherchent la meilleure combinaison » de Toshiba et Fujitsu ne rendent pas l'IA plus rapide toutes seules. Elles pourraient aider à choisir combien de bits donner à chaque partie. Compresser la mémoire après coup (MLA) a abîmé la qualité, donc nous ne l'utilisons pas.
**Ensuite** : Garder les poids en plus petits nombres pour faire tourner de plus grosses IA (environ 12 Go). Nous continuons sans demander à chaque fois : construire, tester, corriger, encore et encore.

### Español
**Hecho**: Las IA grandes suelen venir en varios archivos. Ahora el programa descarga todas las partes y las lee. Ejecutamos una IA real (Qwen 3B, unos 6 GB) en un PC normal sin tarjeta gráfica y escribió texto. Es un poco lento, pero funciona.
**Aprendido**: Las «máquinas que buscan la mejor combinación» de Toshiba y Fujitsu no hacen más rápida a la IA por sí solas. Podrían ayudar a decidir cuántos bits da cada parte. Comprimir la memoria después (MLA) empeoró la calidad, así que no lo usamos.
**Siguiente**: Guardar los pesos con números más pequeños para que corran IA aún más grandes (unos 12 GB). Seguimos sin preguntar cada vez: construir, probar y arreglar una y otra vez.

### Português
**Feito**: As IAs grandes costumam vir em vários arquivos. Agora o programa baixa todas as partes e as lê. Rodamos uma IA de verdade (Qwen 3B, cerca de 6 GB) num PC comum sem placa de vídeo, e ela escreveu texto. É um pouco lento, mas funciona.
**Aprendido**: As «máquinas que procuram a melhor combinação» da Toshiba e da Fujitsu não deixam a IA mais rápida sozinhas. Elas podem ajudar a decidir quantos bits cada parte recebe. Comprimir a memória depois (MLA) piorou a qualidade, então não usamos.
**Próximo**: Guardar os pesos em números menores para rodar IAs ainda maiores (cerca de 12 GB). Seguimos sem perguntar toda vez: construir, testar e consertar, de novo e de novo.

### Русский
**Сделано**: Большие ИИ часто поставляются в нескольких файлах. Теперь программа сама скачивает все части и читает их. Мы запустили настоящий ИИ (Qwen 3B, около 6 ГБ) на обычном компьютере без видеокарты, и он написал текст. Немного медленно, но работает.
**Узнали**: «Машины, которые ищут лучшую комбинацию» от Toshiba и Fujitsu сами по себе ИИ не ускоряют. Возможно, они помогут решить, сколько бит дать каждой части. Сжатие памяти задним числом (MLA) ухудшило качество, поэтому мы его не используем.
**Дальше**: Хранить веса в меньших числах, чтобы запускать ещё более крупные ИИ (около 12 ГБ). Мы продолжаем без вопросов каждый раз: строим, проверяем, исправляем снова и снова.

> このリポジトリの変換機能は `pl2pl` に統合され、組み合わせ選択は pl2pl が最優先で進めます。/ The conversion features of this repository are being merged into `pl2pl`, which now carries the selectable-stack feature as top priority. https://github.com/aon-co-jp/pl2pl

## 最優先機能 / Top-priority feature: 組み合わせを選べる変換 (`pl2pl web --backend ...`) (2026-11-19, 10 languages)

```
pl2pl web <dir> --backend <rust-axum|rust-poem|fastapi|mfastapi|rpoem|rporea>
                [--frontend bootstrap-ts|rust-wasm|none] [--db none|mysql|mariadb|postgres|sqlite] --out <dir>
```
COBOL は変換器で、C / C++ / Fortran は「そのままビルドして呼ぶ橋渡し」(`legacy/build.sh`)で、選んだ組み合わせのアプリの骨組みになります。Axum 版は実際に起動して呼び出しの成功を確認済みです(COBOL と C/C++)。RPoem / RPoRea は Bootstrap・TypeScript なし(Rust→WASM)。

### 日本語
やさしく言うと、「古いプログラム(COBOL・C・C++・Fortran)を、今のウェブのしくみに乗せる」機能です。サーバーは Axum・Poem・FastAPI・RPoem・RPoRea から、画面は HTML5・CSS3・TypeScript・Bootstrap から、データベースは MySQL・MariaDB・PostgreSQL・SQLite から、好きな組み合わせを選べます。COBOL は書き換えて変換します。C・C++・Fortran は元のまま動かし、ウェブから呼べるようにします(まだ Rust への書き換えはしません)。メインフレーム・UNIX・Linux・Windows・Mac の COBOL を別の OS の COBOL へ直す機能は `pl2pl cobol`(IBM→GnuCOBOL)にあります。
### English
In simple words: it puts old programs (COBOL, C, C++, Fortran) onto today's web. You pick the server (Axum, Poem, FastAPI, RPoem or RPoRea), the screen (HTML5, CSS3, TypeScript, Bootstrap) and the database (MySQL, MariaDB, PostgreSQL or SQLite) in any allowed mix. COBOL is rewritten. C, C++ and Fortran keep running as they are, and the web calls them (they are not rewritten into Rust yet). Turning COBOL from one OS into COBOL for another OS is `pl2pl cobol` (IBM to GnuCOBOL).
### 简体中文
简单地说:把旧程序(COBOL、C、C++、Fortran)放到今天的网页上。服务器可选 Axum、Poem、FastAPI、RPoem、RPoRea;界面可选 HTML5、CSS3、TypeScript、Bootstrap;数据库可选 MySQL、MariaDB、PostgreSQL、SQLite,自由组合。COBOL 会被改写;C、C++、Fortran 保持原样运行,由网页调用(暂不改写成 Rust)。把 COBOL 从一个系统转到另一个系统用 `pl2pl cobol`。
### 繁體中文
簡單地說:把舊程式(COBOL、C、C++、Fortran)放到現在的網頁上。伺服器可選 Axum、Poem、FastAPI、RPoem、RPoRea;畫面可選 HTML5、CSS3、TypeScript、Bootstrap;資料庫可選 MySQL、MariaDB、PostgreSQL、SQLite,自由搭配。COBOL 會被改寫;C、C++、Fortran 維持原樣執行,由網頁呼叫(暫不改寫成 Rust)。把 COBOL 從一個系統轉到另一個系統用 `pl2pl cobol`。
### 한국어
쉽게 말하면, 오래된 프로그램(COBOL, C, C++, Fortran)을 지금의 웹에 올려 주는 기능입니다. 서버는 Axum, Poem, FastAPI, RPoem, RPoRea 중에서, 화면은 HTML5, CSS3, TypeScript, Bootstrap 중에서, 데이터베이스는 MySQL, MariaDB, PostgreSQL, SQLite 중에서 마음대로 조합할 수 있습니다. COBOL은 다시 써서 변환하고, C·C++·Fortran은 그대로 실행하면서 웹에서 부릅니다(아직 Rust로 다시 쓰지는 않습니다). COBOL을 다른 OS의 COBOL로 바꾸는 일은 `pl2pl cobol`이 합니다.
### Deutsch
Einfach gesagt: Alte Programme (COBOL, C, C++, Fortran) werden ins heutige Web gebracht. Man wählt Server (Axum, Poem, FastAPI, RPoem oder RPoRea), Oberfläche (HTML5, CSS3, TypeScript, Bootstrap) und Datenbank (MySQL, MariaDB, PostgreSQL oder SQLite) frei im erlaubten Rahmen. COBOL wird umgeschrieben; C, C++ und Fortran laufen unverändert und werden vom Web aus aufgerufen (noch nicht nach Rust umgeschrieben). COBOL für ein anderes Betriebssystem erzeugt `pl2pl cobol`.
### Français
En termes simples : on met de vieux programmes (COBOL, C, C++, Fortran) sur le web d'aujourd'hui. On choisit le serveur (Axum, Poem, FastAPI, RPoem ou RPoRea), l'écran (HTML5, CSS3, TypeScript, Bootstrap) et la base de données (MySQL, MariaDB, PostgreSQL ou SQLite) dans les combinaisons permises. Le COBOL est réécrit ; C, C++ et Fortran tournent tels quels et sont appelés par le web (pas encore réécrits en Rust). Pour du COBOL d'un autre système, voir `pl2pl cobol`.
### Español
En palabras sencillas: lleva programas antiguos (COBOL, C, C++, Fortran) a la web de hoy. Eliges el servidor (Axum, Poem, FastAPI, RPoem o RPoRea), la pantalla (HTML5, CSS3, TypeScript, Bootstrap) y la base de datos (MySQL, MariaDB, PostgreSQL o SQLite) con las combinaciones permitidas. El COBOL se reescribe; C, C++ y Fortran siguen funcionando tal cual y la web los llama (todavía no se reescriben en Rust). Para COBOL de otro sistema operativo, usa `pl2pl cobol`.
### Português
Em palavras simples: leva programas antigos (COBOL, C, C++, Fortran) para a web de hoje. Você escolhe o servidor (Axum, Poem, FastAPI, RPoem ou RPoRea), a tela (HTML5, CSS3, TypeScript, Bootstrap) e o banco de dados (MySQL, MariaDB, PostgreSQL ou SQLite) nas combinações permitidas. O COBOL é reescrito; C, C++ e Fortran continuam rodando como estão e a web os chama (ainda não são reescritos em Rust). Para COBOL de outro sistema, use `pl2pl cobol`.
### Русский
Простыми словами: старые программы (COBOL, C, C++, Fortran) переносятся в сегодняшний веб. Сервер выбирается из Axum, Poem, FastAPI, RPoem, RPoRea; интерфейс — из HTML5, CSS3, TypeScript, Bootstrap; база данных — из MySQL, MariaDB, PostgreSQL, SQLite, в допустимых сочетаниях. COBOL переписывается; C, C++ и Fortran работают как есть, а веб их вызывает (в Rust пока не переписываются). COBOL для другой ОС делает `pl2pl cobol`.

**確認したこと / Verified**: Axum(COBOL 7本・C・C++)を起動して `POST /cobol_to.Program/Run` が正しい出力を返す。全組み合わせの検査は単体試験。**まだ / Not yet**: gfortran の実機ビルド(この PC の WSL に無い)、C/C++/Fortran→Rust の書き換え、COBOL→別 OS の COBOL の拡張、Axum 以外の起動確認。**進め方 / How we work**: 未了は確認せず自動で進める(元のリポジトリの削除だけは最後に確認)。 / Unfinished items go on automatically without asking (only deleting the original repos is confirmed first).


## 2026-11-19 4姉妹(open-cosmo・RPoem・Reaxt・RPoRea)の現状 / Status of the four sister projects
このリポジトリは索引です。実装は各リポジトリにあります: [open-cosmo](https://github.com/aon-co-jp/open-cosmo)・[RPoem](https://github.com/aon-co-jp/RPoem)・[Reaxt](https://github.com/aon-co-jp/Reaxt)・[RPoRea](https://github.com/aon-co-jp/RPoRea)。This repository is only an index; the code lives in the four repositories above.

### 日本語(やさしい説明)
4つは**いつも一緒に**作ります。できていること: Reaxtのサーバーが入口(Cosmo)に参加でき、入口が1つの質問を複数のサーバーに分けて答えをまとめます。`@key`・`@requires`・`@provides`・`@skip`・`@include`・フラグメントにも対応し、本物のサーバー2つで確かめました。これから: `... on 型`の安全な対応(作業中)、書き込み後の取り直し、Reaxtの`Option`、Rust以外からの利用(Mojo・Mac・Android・iPhone)。未了は**確認せず自動で進めます**。

### English (simple words)
We always build the four **together**. Done: a Reaxt server can join the front door (Cosmo), and the front door splits one question across many servers and joins the answers. `@key`, `@requires`, `@provides`, `@skip`, `@include` and fragments work, and we checked it with two real servers. Next: safe `... on Type` support (in progress), re-reading after a write, `Option` in Reaxt, and use from other languages (Mojo, Mac, Android, iPhone). We keep going on unfinished jobs **without asking**.


## 2026-11-19 多言語版 / Translations (8 languages; 日本語・English are above / AI翻訳、ネイティブ確認前)

### 简体中文
**这四个项目始终一起开发。** `RPoem`是地基,`open-cosmo`是大门,`Reaxt`是编写界面和服务器任务的工具,`RPoRea`把RPoem和Reaxt合在一起。改动其中一个,就要检查另外三个,并在同一天更新四个项目的README、CLAUDE、PORTING、POLICY。
- **已经完成**:Reaxt服务器可加入Cosmo(`POST /_reaxt/graphql`);网关把一个问题分给多个服务器再合并答案;`@key`连接不同服务器里的同一个人或物(可嵌套、最多4步);`@requires`、`@provides`、`@skip`、`@include`(也可在无类型条件的片段里使用);Reaxt动作可以有类型并作为`@key`实体公开;用两个真实服务器验证了一次提问合并结果。
- **计划完成**:① 连接计划支持片段(已完成);② 安全支持`... on 类型`;③ 写入后重新读取最新值;④ Reaxt支持`Option`和更复杂的类型;⑤ 更广泛的真实连接测试;⑥ 从其他语言(C ABI)使用RPoRea,先用Mojo验证,再到Mac、Android、iPhone。
- **做事规则**:未完成的工作**无需确认,自动继续**;先测试、在真实服务器上确认后才说"完成";不写入密码等机密;不新增REST。

### 繁體中文
**這四個專案永遠一起開發。** `RPoem`是地基,`open-cosmo`是大門,`Reaxt`是撰寫畫面與伺服器工作的工具,`RPoRea`把RPoem與Reaxt結合在一起。改動其中一個,就要檢查另外三個,並在同一天更新四個專案的README、CLAUDE、PORTING、POLICY。
- **已經完成**:Reaxt伺服器可加入Cosmo(`POST /_reaxt/graphql`);閘道把一個問題分給多個伺服器再合併答案;`@key`連接不同伺服器裡的同一個人或物(可巢狀、最多4步);`@requires`、`@provides`、`@skip`、`@include`(也可用於沒有型別條件的片段);Reaxt動作可以有型別並作為`@key`實體公開;以兩個真實伺服器驗證了一次提問合併結果。
- **預計完成**:① 連接計畫支援片段(已完成);② 安全支援`... on 型別`;③ 寫入後重新讀取最新值;④ Reaxt支援`Option`與更複雜的型別;⑤ 更廣泛的真實連線測試;⑥ 從其他語言(C ABI)使用RPoRea,先以Mojo驗證,再到Mac、Android、iPhone。
- **做事規則**:未完成的工作**不需確認,自動繼續**;先測試、在真實伺服器上確認後才說「完成」;不寫入密碼等機密;不新增REST。

### 한국어
**이 네 프로젝트는 항상 함께 만듭니다.** `RPoem`은 바탕, `open-cosmo`는 현관문, `Reaxt`는 화면과 서버 작업을 쓰는 도구, `RPoRea`는 RPoem과 Reaxt를 합친 것입니다. 하나를 바꾸면 나머지 셋도 확인하고, 같은 날 네 프로젝트의 README, CLAUDE, PORTING, POLICY를 고칩니다.
- **이미 된 것**: Reaxt 서버가 Cosmo에 참여(`POST /_reaxt/graphql`), 게이트웨이가 질문 하나를 여러 서버에 나눠 묻고 답을 합침, `@key`로 서로 다른 서버의 같은 사람·물건을 연결(중첩, 최대 4단계), `@requires`·`@provides`·`@skip`·`@include`(타입 조건 없는 프래그먼트 안에서도 동작), Reaxt 액션에 타입을 주고 `@key` 엔티티로 공개, 실제 서버 2대로 한 번의 질문 결합 확인.
- **만들 예정**: ① 결합 계획에서 프래그먼트 지원(완료), ② `... on 타입`의 안전한 지원, ③ 쓰기 뒤 최신 값 다시 읽기, ④ Reaxt의 `Option`과 더 복잡한 타입, ⑤ 더 넓은 실제 연결 시험, ⑥ 다른 언어(C ABI)에서 RPoRea 사용(Mojo 확인 후 Mac·Android·iPhone).
- **작업 규칙**: 끝나지 않은 일은 **확인 없이 자동으로 계속**합니다. 시험하고 실제 서버에서 확인한 뒤에만 "완료"라고 씁니다. 비밀번호 같은 비밀은 쓰지 않고, 새 REST는 만들지 않습니다.

### Deutsch
**Diese vier Projekte entwickeln wir immer zusammen.** `RPoem` ist das Fundament, `open-cosmo` die Eingangstür, `Reaxt` das Werkzeug für Oberflächen und Server-Aufgaben, `RPoRea` verbindet RPoem und Reaxt. Ändern wir eines, prüfen wir die anderen drei und aktualisieren README, CLAUDE, PORTING und POLICY aller vier am selben Tag.
- **Schon fertig**: Reaxt-Server können Cosmo beitreten (`POST /_reaxt/graphql`); das Gateway verteilt eine Frage auf mehrere Server und fügt die Antworten zusammen; `@key` verbindet dieselbe Person oder Sache aus verschiedenen Servern (verschachtelt, bis zu 4 Schritte); `@requires`, `@provides`, `@skip`, `@include` (auch in Fragmenten ohne Typbedingung); Reaxt-Aktionen haben Typen und können als `@key`-Entitäten angeboten werden; mit zwei echten Servern wurde eine Frage erfolgreich zusammengeführt.
- **Geplant**: ① Fragmente im Verbindungsplan (erledigt); ② `... on Typ` sicher unterstützen; ③ nach dem Schreiben neue Werte lesen; ④ `Option` und komplexere Typen in Reaxt; ⑤ breitere Tests mit echten Verbindungen; ⑥ RPoRea aus anderen Sprachen (C ABI) nutzen, erst Mojo, dann Mac, Android, iPhone.
- **Arbeitsregel**: Unfertiges machen wir **ohne Rückfrage automatisch weiter**. Wir testen, prüfen auf echten Servern und schreiben erst dann „fertig“. Keine Geheimnisse (z. B. Passwörter) in Dateien, keine neuen REST-APIs.

### Français
**Nous développons toujours ces quatre projets ensemble.** `RPoem` est la base, `open-cosmo` la porte d'entrée, `Reaxt` l'outil pour écrire écrans et tâches serveur, `RPoRea` réunit RPoem et Reaxt. Si l'un change, nous vérifions les trois autres et mettons à jour README, CLAUDE, PORTING et POLICY des quatre le même jour.
- **Déjà fait** : un serveur Reaxt peut rejoindre Cosmo (`POST /_reaxt/graphql`) ; la passerelle répartit une question sur plusieurs serveurs et assemble les réponses ; `@key` relie la même personne ou chose située dans des serveurs différents (imbriqué, jusqu'à 4 étapes) ; `@requires`, `@provides`, `@skip`, `@include` (aussi dans les fragments sans condition de type) ; les actions Reaxt ont des types et deviennent des entités `@key` ; une question a été assemblée avec deux vrais serveurs.
- **Prévu** : ① fragments dans le plan de jointure (fait) ; ② `... on Type` de façon sûre ; ③ relire les valeurs après une écriture ; ④ `Option` et types plus riches dans Reaxt ; ⑤ tests de connexion réelle plus larges ; ⑥ utiliser RPoRea depuis d'autres langages (C ABI) : Mojo d'abord, puis Mac, Android, iPhone.
- **Règle de travail** : ce qui n'est pas fini continue **automatiquement, sans demander**. Nous testons, vérifions sur de vrais serveurs, puis seulement écrivons « terminé ». Pas de secrets (mots de passe…) dans les fichiers, pas de nouvelle API REST.

### Español
**Siempre desarrollamos estos cuatro proyectos juntos.** `RPoem` es la base, `open-cosmo` la puerta de entrada, `Reaxt` la herramienta para escribir pantallas y tareas del servidor, y `RPoRea` une RPoem y Reaxt. Si cambiamos uno, revisamos los otros tres y actualizamos README, CLAUDE, PORTING y POLICY de los cuatro el mismo día.
- **Ya funciona**: un servidor Reaxt puede unirse a Cosmo (`POST /_reaxt/graphql`); la pasarela reparte una pregunta entre varios servidores y junta las respuestas; `@key` une la misma persona o cosa que está en servidores distintos (anidado, hasta 4 pasos); `@requires`, `@provides`, `@skip`, `@include` (también en fragmentos sin condición de tipo); las acciones de Reaxt tienen tipos y se publican como entidades `@key`; se juntó una pregunta con dos servidores reales.
- **Planeado**: ① fragmentos en el plan de unión (hecho); ② `... on Tipo` de forma segura; ③ volver a leer los valores tras escribir; ④ `Option` y tipos más ricos en Reaxt; ⑤ pruebas de conexión real más amplias; ⑥ usar RPoRea desde otros lenguajes (C ABI): primero Mojo, luego Mac, Android e iPhone.
- **Regla de trabajo**: lo que falta se sigue **automáticamente, sin pedir confirmación**. Probamos, verificamos en servidores reales y solo entonces escribimos «terminado». Sin secretos (contraseñas) en los archivos y sin nuevas APIs REST.

### Português
**Sempre desenvolvemos estes quatro projetos juntos.** `RPoem` é a base, `open-cosmo` é a porta de entrada, `Reaxt` é a ferramenta para escrever telas e tarefas do servidor, e `RPoRea` une RPoem e Reaxt. Se mudamos um, verificamos os outros três e atualizamos README, CLAUDE, PORTING e POLICY dos quatro no mesmo dia.
- **Já funciona**: um servidor Reaxt pode entrar no Cosmo (`POST /_reaxt/graphql`); o gateway divide uma pergunta entre vários servidores e junta as respostas; `@key` liga a mesma pessoa ou coisa que está em servidores diferentes (aninhado, até 4 passos); `@requires`, `@provides`, `@skip`, `@include` (também em fragmentos sem condição de tipo); as ações do Reaxt têm tipos e viram entidades `@key`; uma pergunta foi juntada com dois servidores reais.
- **Planejado**: ① fragmentos no plano de junção (feito); ② `... on Tipo` de forma segura; ③ reler os valores após escrever; ④ `Option` e tipos mais ricos no Reaxt; ⑤ testes de conexão real mais amplos; ⑥ usar o RPoRea de outras linguagens (C ABI): primeiro Mojo, depois Mac, Android e iPhone.
- **Regra de trabalho**: o que falta continua **automaticamente, sem pedir confirmação**. Testamos, verificamos em servidores reais e só então escrevemos «concluído». Sem segredos (senhas) nos arquivos e sem novas APIs REST.

### Русский
**Эти четыре проекта мы всегда делаем вместе.** `RPoem` — основа, `open-cosmo` — входная дверь, `Reaxt` — инструмент для экранов и серверных задач, `RPoRea` соединяет RPoem и Reaxt. Если меняем один, проверяем остальные три и в тот же день обновляем README, CLAUDE, PORTING и POLICY всех четырёх.
- **Уже работает**: сервер Reaxt может присоединиться к Cosmo (`POST /_reaxt/graphql`); шлюз делит один вопрос между серверами и собирает ответы; `@key` связывает одного и того же человека или предмет из разных серверов (вложенно, до 4 шагов); `@requires`, `@provides`, `@skip`, `@include` (в том числе во фрагментах без условия типа); действия Reaxt имеют типы и открываются как сущности `@key`; на двух настоящих серверах один вопрос успешно объединён.
- **Планируется**: ① фрагменты в плане соединения (готово); ② безопасная поддержка `... on Тип`; ③ перечитывание значений после записи; ④ `Option` и более сложные типы в Reaxt; ⑤ более широкие проверки с реальными соединениями; ⑥ использование RPoRea из других языков (C ABI): сначала Mojo, затем Mac, Android и iPhone.
- **Правило работы**: незавершённое мы продолжаем **автоматически, не спрашивая подтверждения**. Сначала проверяем на настоящих серверах и только потом пишем «готово». Секреты (пароли) в файлы не пишем, новых REST-API не создаём.


## 2026-11-19 リミット前のチェックポイント(4姉妹・日本語、別アカウントでの再開用)
**到達点(すべてpush済み、試験成功)**
- ゲートウェイ(open-cosmo `remote_subgraphs.rs`): 複数サブグラフへの分割、`@key`結合(入れ子・4段連鎖)、`@requires`/`@provides`、`@skip`/`@include`、型条件なしのインラインフラグメントの展開、`... on 型`(親と同じ型のときだけ展開)。ゲートウェイ試験57件成功。
- Reaxt(`reaxt-actions`): アクションが型を持つ(`Wire::gql_type`・`wire_struct!`)、`@key`エンティティ(`ModuleActions::entity`)、`_entities`、選択の射影(別名・`__typename`・`... on`)、`Option<T>`(null可)、`f64`(Float)、JSONに無いフィールドは`Option`なら`None`。試験15件成功。
- 実機: `serve`と`serve_greeter`(どちらも型付き`Visitor`)をゲートウェイ(`OPEN_RUNO_SUBGRAPHS="名前=URL,..."`)の後ろに置き、1つの質問で`visits`と`count`が`@key`で結合されることを確認。2サーバーにまたがる変更は仕様どおり拒否。
- 文書: 4リポジトリとrunoのREADME/CLAUDE/PORTING/POLICYに、現状・完成予定・きまりを日英と8言語(AI翻訳、ネイティブ確認前)で記載済み。

**未了(この順で、確認不要で自動で進める)**
1. 変更(書き込み)の後に最新の値を取り直す機能。
2. 名前付きフラグメント(`...F`)と、型が違う`... on 型`(インターフェース/ユニオン)への安全な対応。
3. Reaxtの複雑な型(`Option`の入れ子、`HashMap`など)、`Wire`の対応型の拡張。
4. open-cosmoのルーターへReaxtをさらに広く実際につなぐ試験。
5. RPoRea(C ABI)をMojoで確認、Mac・Android・iPhoneへ。
6. クラウドでの軽い仕事の定期実行(2時間ごと): **GitHubをClaudeアカウントに接続**(https://claude.ai/connect-github)してから作る。

**注意**: Reaxtの型の登録(レジストリ)はプロセス内で共有。並列試験では`JSON`か型付きかの表記が揺れるので、SDL試験は`(input: JSON):`までで比べる。ゲートウェイの`OPEN_RUNO_SUBGRAPHS`は`名前=URL`形式。新しいRESTは作らない。秘密は書かない。

**再開用メッセージ**: 前の続きです。`F:\runo\PORTING.md`末尾「リミット前のチェックポイント(4姉妹)」を読んでから、open-cosmo・RPoem・Reaxt・RPoRea の未了を、確認なしで自動で進めてください。区切りごとにREADME/CLAUDE/PORTING/POLICYを10か国語で更新し、commitしてpushします。返答は日本語のみ。

## 2026-11-19 限界前チェックポイント(大きなモデル対応、別アカウントでの再開用)

**完了(すべて main に push 済み)**
- 分割重み(`model.safetensors.index.json`+複数ファイル)の取得(`aruaru-llm` `model_catalog.rs`、単一ファイルが404のときだけ・ストリーム書き込み・導入判定対応)と読み込み(`open-cuda-llm` `qwen_arch.rs`、mmap)。モックと合成データのテスト成功。
- 実機確認(32GB・GPUなし・CPU): Qwen2.5-3B(2分割・6.17GB)を読み込み生成成功(読込約48秒、約0.6語/秒、ppl 8.5)。1.5Bは ppl 7.08。
- 後付けMLA(PCA較正)は実用外: d_c=96でKV−25%だが ppl 12.7、d_c=64で崩れる(ppl 245)。MLAは学習時から入れる設計でないと効かない。
- FP8読み込み `QwenModel::load_fp8`: 量子化を二分探索化・ホスト並列化し、行列積を融合(`opencuda-blas`)。1.5Bで読込340→21秒、生成1067→69秒、ppl 7.27(f32は7.08)、メモリ約1/4。ただしf32より約2.8倍遅い。
- 調査: 東芝SB・富士通デジタルアニーラは組合せ最適化の道具でLLM推論を直接速めない。LLMでの先行例はTree-Ising(重みのQUBO修復、自己申告値)のみ。エキスパートごとのビット配分は線形/整数計画(GEMQ・BitsMoE)。「折り畳み」はModel Folding(ICLR 2025)・Layer Collapse・Sliding-Window Merging・GPTailor。DeepSeekのMLA・MoE遅延読み込みは `deepseek_arch.rs` に実装済み(実在チェックポイントでの通しは未確認)。
- クラウドセッションに調査文書 `docs/LARGE-MODEL-TECHNIQUES.md`(ブランチ `docs/large-model-techniques`)を依頼済み(終了通知は来ない。`aruaru-llm` のブランチを確認すること)。

**未了(確認なしで順に進める方針)**
1. 層ごとの感度測定(層を飛ばす/隣接層を平均する「折り畳み」)と、ビット配分の自動決定(まず貪欲法、次に焼きなまし・SB)。`QwenModel` に層スキップ機構を足して `qwen_mla_bench` 系の例で ppl と速度を測る。
2. FP8がf32より遅い問題(約2.8倍): SIMD化・f16保持・行単位スケール見直し。
3. 7B級(約12〜15GB)の実読み込み: FP8読み込みで32GB機に載るかを実測(要ダウンロード許可内の公開モデル)。
4. 実3BのFP8読み込み実測、`pl2pl llm setup` への分割モデル・FP8の反映、`aruaru-llm` のカタログに3Bの実機確認の記載。
5. 10言語文書は現状分を追記済み。上記の結果が出たら更新する。翻訳はAI作成でネイティブ検証前。

**注意**: `F:\open-cuda` の作業ブランチは `perf/serial-small-gemm`(`HEAD:main` を指定して push している)。`F:\aruaru-llm` は `Cargo.lock` と `data/` に未コミットの変更がある(別作業のもの、コミットしない)。モデルは `F:\aruaru-llm\models\qwen2.5-{1.5b,3b}-instruct`(サイズが大きいので消さない)。測定スクリプト: `open-cuda/crates/open-cuda-llm/examples/qwen_mla_bench.rs`(`QWEN_FP8=1` でFP8、引数にd_c)。


## 2026-11-19 まとめと再開のしかた / Summary and how to resume (日本語・English)

### 日本語(やさしい説明)
**今日できたこと**
- Reaxtのサーバーを、入口(open-cosmo)の後ろに並べて使えるようになりました。入口は、1つの質問を複数のサーバーに分けて聞き、答えを1つにまとめます。
- 別々のサーバーにある「同じ人・同じ物」の情報を、`@key`でつなげます。`@requires`・`@provides`・`@skip`・`@include`・フラグメントにも対応しました。
- Reaxtの仕事(アクション)に「型」(中身の形)を持たせられるようになりました。値が無いかもしれない型(`Option`)や小数(`f64`)も使えます。
- 本物のサーバー2つで、1回の質問に両方の答えが入ることを確かめました。試験はゲートウェイ57件・Reaxt15件が成功しています。

**まだ終わっていないこと(この順に進めます)**
1. 書き込みのあと、最新の値を取り直す。
2. 名前付きフラグメントや、型が違う`... on 型`への安全な対応。
3. Reaxtでもっと複雑な型を使えるようにする。
4. open-cosmoのルーターで、もっと広く実際につなぐ試験。
5. RPoReaをMojo・Mac・Android・iPhoneから使えるか確かめる。
6. 軽い仕事は、クラウドで2時間ごとに自動実行する(先にGitHubをClaudeにつなぐ: https://claude.ai/connect-github)。

**再開のしかた**: 新しい会話で「`F:\runo\PORTING.md`の末尾を読んで、4姉妹(open-cosmo・RPoem・Reaxt・RPoRea)の未了を確認なしで自動で進めて」と伝えてください。**進め方のきまり**: 確認は取らずに進める/試験して本物で確かめてから「できた」と書く/秘密は書かない/新しいRESTは作らない。

### English (natural, plain wording)
**What we got done today**
- Reaxt servers can now sit behind the front door (open-cosmo). The gateway splits one question across several servers and merges the answers into one.
- `@key` links the same person or item that lives on different servers. `@requires`, `@provides`, `@skip`, `@include` and fragments work too.
- Reaxt actions can now carry types (the shape of their data), including optional values (`Option`) and decimals (`f64`).
- With two real servers we confirmed that a single question returns data from both. All tests pass: 57 in the gateway and 15 in Reaxt.

**What is still open (we will go in this order)**
1. Re-read the latest values after a write.
2. Safe support for named fragments and for `... on Type` with a different type.
3. Richer types in Reaxt.
4. Wider real-world tests that connect Reaxt to the open-cosmo router.
5. Check that RPoRea works from Mojo, Mac, Android and iPhone.
6. Run the light jobs in the cloud every two hours (first connect GitHub to Claude: https://claude.ai/connect-github).

**How to resume**: in a new conversation, say "Read the end of `F:\runo\PORTING.md`, then keep working through the open items of the four sister projects (open-cosmo, RPoem, Reaxt, RPoRea) without asking for confirmation." **Working rules**: keep going without asking; test and verify on real systems before saying "done"; never write secrets; do not add new REST APIs.

## 2026-11-19 いまの状況と、つづきのやり方 / Status and how to continue (final checkpoint)

### 日本語(やさしく)
**いまできること**: 古いプログラム(COBOL・C・C++・Fortran)を、いまのウェブのしくみに乗せるお助けロボットです。`pl2pl web --backend ...` で、サーバー(Axum・Poem・FastAPI・RPoem・RPoRea)、画面(HTML5・CSS3・TypeScript・Bootstrap)、データベース(MySQL・MariaDB・PostgreSQL・SQLite)を好きな組み合わせで選べます。COBOL は書き換え、C・C++・Fortran は元のまま動かして呼びます。単純な C は `pl2pl c2rust` で Rust に書き換えられます。新しい版の自動チェック(`pl2pl watch`)は毎晩 03:00・毎朝 07:00 に動きます。
**まだのこと(確認せず、自動で進めます)**: C++・Fortran の Rust 化、C の対応範囲の拡大、Fortran の実機確認、RPoem/RPoRea の起動確認、COBOL から別 OS の COBOL への拡張、メール到達の確認、Kokkos の GPU 実行、8 か国語文書の更新。大きなモデル(3B・7B)の対応は別の記録(`PORTING.md` の大規模モデルの節)にあります。
**人にたずねること**: 元の `COBOL_to` / `Java_to` を消す作業だけです(元に戻せないため)。クラウドの定期実行は、GitHub の接続(https://claude.ai/connect-github)を待っています。
**つづけるには**: `F:\pl2pl\PORTING.md` の末尾から読みます。作る・試すのはこの PC(WSL)で、VPS は入れ替えと確認だけに使います。

### English (plain and friendly)
**What it does now**: pl2pl is a helper robot that puts old programs (COBOL, C, C++, Fortran) onto today's web. With `pl2pl web --backend ...` you pick the server (Axum, Poem, FastAPI, RPoem or RPoRea), the screen (HTML5, CSS3, TypeScript, Bootstrap) and the database (MySQL, MariaDB, PostgreSQL or SQLite) in any allowed mix. COBOL is rewritten; C, C++ and Fortran keep running as they are and the web calls them. Simple C can be rewritten into Rust with `pl2pl c2rust`. The automatic check for new versions (`pl2pl watch`) runs every night at 03:00 and every morning at 07:00.
**Still to do (we go on automatically, no need to ask)**: Rust versions of C++ and Fortran, wider C support, a real Fortran build check, starting RPoem/RPoRea, COBOL to COBOL for another OS, a real mail-arrival check, Kokkos on a GPU, and updating the 8 other language docs. Big-model work (3B and 7B) is recorded separately in the large-model section of `PORTING.md`.
**What we ask a person**: only deleting the original `COBOL_to` / `Java_to` (it cannot be undone). The cloud schedule is waiting for the GitHub connection (https://claude.ai/connect-github).
**To continue**: start from the end of `F:\pl2pl\PORTING.md`. Build and test on this PC (WSL); use the VPS only for swapping binaries and checking.


## 2026-11-19 最終まとめ(リミット前) / Final summary before the limit (日本語・English)

### 日本語(やさしい説明)
**さっき終わったこと**
- **名前付きフラグメント**(`...F`)に対応しました。ゲートウェイは、問い合わせの中の`...F`を、`... on 型 { }`の形に置きかえてから計画します。型が親と同じなら展開し、`@skip`/`@include`も効きます。ぐるぐる回る参照(循環)は、無限ループにならず、そのまま転送します。
- **Reaxtのサーバー**も、名前付きフラグメント・型なしの`... { }`・`@skip`/`@include`(変数もOK)を読めるようになりました。これで、全部の項目が除外されて「分割せずそのまま転送」になった場合も、ちゃんと動きます。
- 本物のサーバー2つをゲートウェイの後ろに置いて、`...F @include(if: $x)`で、`true`なら`visits`と`count`が結合されて返り、`false`なら`id`だけが返ることを確かめました。
- 試験: ゲートウェイ58件、Reaxt16件が成功。

**まだ終わっていないこと**
1. 書き込みのあと、最新の値を取り直す。
2. 型が違う`... on 型`(インターフェース/ユニオン)への安全な対応。
3. Reaxtでもっと複雑な型(`Option`の入れ子、`HashMap`など)を使えるようにする。
4. open-cosmoのルーターで、もっと広く実際につなぐ試験。
5. RPoReaをMojo・Mac・Android・iPhoneから使えるか確かめる。
6. 軽い仕事のクラウド定期実行(先にGitHubをClaudeにつなぐ)。

**再開のしかた**: 新しい会話で「`F:\runo\PORTING.md`の末尾を読んで、4姉妹の未了を確認なしで自動で進めて」と伝えてください。

### English (natural, plain wording)
**What we just finished**
- **Named fragments** (`...F`) are now supported. The gateway rewrites each `...F` into `... on Type { }` before planning. When the type matches the parent it is flattened, and `@skip`/`@include` work. A circular reference does not loop forever; the query is simply forwarded as it is.
- **Reaxt servers** can now read named fragments, untyped `... { }` and `@skip`/`@include` (variables too). So even when every field is excluded and the query is forwarded unsplit, it still works.
- With two real servers behind the gateway, `...F @include(if: $x)` returned `visits` and `count` joined together for `true`, and only `id` for `false`.
- Tests: 58 in the gateway and 16 in Reaxt all pass.

**What is still open**
1. Re-read the latest values after a write.
2. Safe support for `... on Type` with a different type (interfaces and unions).
3. Richer Reaxt types (nested `Option`, `HashMap`, and so on).
4. Wider real-world tests that connect Reaxt to the open-cosmo router.
5. Check that RPoRea works from Mojo, Mac, Android and iPhone.
6. Run the light jobs in the cloud on a schedule (first connect GitHub to Claude).

**How to resume**: in a new conversation, say "Read the end of `F:\runo\PORTING.md`, then keep working through the open items of the four sister projects without asking for confirmation."

- 最終追記 / Last update (2026-11-19): `pl2pl c2rust` は単純な C と C++(cout)に対応。残りは Fortran の Rust 化・RPoem/RPoRea の起動確認・COBOL の別OS拡張(確認せず自動で進める)。再開は `F:\pl2pl\PORTING.md` の末尾から。/ `pl2pl c2rust` now handles simple C and C++ (cout). Still open: Fortran to Rust, starting RPoem/RPoRea, extending COBOL to other OSes (continued automatically, no need to ask). Resume from the end of `F:\pl2pl\PORTING.md`.


## 2026-11-19 追記(リミット前の最後) / Last addition before the limit (日本語・English)

### 日本語(やさしい説明)
- Reaxtのアクションで使える整数の種類を増やしました(`u64`・`i8`・`i16`・`isize`を追加)。範囲の外の数(たとえば`i8`に`300`)や、負の数を`u64`に入れようとすると、エラーになります。試験は17件成功です。
- ゲートウェイの試験は58件成功のままです。名前付きフラグメント(`...F`)と`@skip`/`@include`は、本物のサーバー2つで確かめ済みです。
- **残りの仕事**: ①書き込みのあとに最新の値を取り直す ②型が違う`... on 型`(インターフェース/ユニオン) ③Reaxtのもっと複雑な型 ④open-cosmoのルーターでの広い実機試験 ⑤RPoReaをMojo・Mac・Android・iPhoneから使う ⑥軽い仕事のクラウド定期実行(先にGitHubをClaudeにつなぐ)。
- 再開のしかた: 新しい会話で「`F:\runo\PORTING.md`の末尾を読んで、4姉妹の未了を確認なしで自動で進めて」と伝えてください。

### English (natural, plain wording)
- Reaxt actions can now use more integer types (`u64`, `i8`, `i16` and `isize` were added). Out-of-range numbers (for example `300` as an `i8`) and negative numbers for a `u64` are rejected with an error. 17 tests pass.
- The gateway still passes its 58 tests. Named fragments (`...F`) and `@skip`/`@include` were checked with two real servers.
- **Still open**: (1) re-read the latest values after a write; (2) `... on Type` with a different type (interfaces and unions); (3) richer Reaxt types; (4) wider real-world tests with the open-cosmo router; (5) use RPoRea from Mojo, Mac, Android and iPhone; (6) run the light jobs in the cloud on a schedule (first connect GitHub to Claude).
- How to resume: in a new conversation, say "Read the end of `F:\runo\PORTING.md`, then keep working through the open items of the four sister projects without asking for confirmation."

## 2026-11-19 まとめ: 大きなAIを小さなパソコンで / Summary: big AI on a small PC

### 日本語(やさしい説明)
**できたこと**
- 重さが「いくつかのファイル」に分かれた大きなAIを、自動でぜんぶダウンロードして読めるようになりました(`aruaru-llm`・`open-cuda`)。
- 本物の Qwen2.5-3B(約6GB)を、GPUのないふつうのパソコンで動かして文章を作れました(読み込み約48秒、1秒に約0.6語)。
- 重さを「FP8」という小さい数で持つ方法を作りました。メモリが約4分の1になり、品質はほぼ同じです(迷い度 7.08→7.27)。速くする工夫で、読み込みは340秒→21秒、文章づくりは1067秒→69秒になりました。まだ普通の方法より約2.8倍遅いので、メモリが足りないときの手段です。

**試してわかったこと(正直な結果)**
- 後から記憶を圧縮する「MLA」は、品質が落ちるので使えません(25%減で迷い度 7.1→12.7、50%減で文が壊れる)。
- 「折り畳み(層を飛ばす)」を1.5Bで試しました。1層ずつ飛ばすと、真ん中あたりの層(5・10・12・15番など)は飛ばしてもほとんど平気でしたが、1番・24番・26番は大事でした。3層飛ばすと迷い度7.19(元7.08)で、速さは約7%だけ上がり、答えが少し不正確になりました。6層以上飛ばすと壊れます。**学び直しなしの層飛ばしは、効果が小さい**とわかりました。
- 東芝の「シミュレーテッド分岐」や富士通の「デジタルアニーラ」は、「いちばん良い組み合わせを探す」道具で、AIを直接速くはしません。使うなら「どの層を飛ばすか」「何ビットにするか」を決める所ですが、まだ試していません。

**これから(確認せず順に進めます)**
1. 層を飛ばす組み合わせを、焼きなましやSBで探して、貪欲法と比べる。
2. FP8を速くする(SIMD、f16保持)。
3. 7B(約12〜15GB)をFP8で32GBのパソコンに載せられるか測る。
4. `pl2pl llm setup` に分割モデルとFP8を反映する。

**約束**: 危なくない未了は、いちいち聞かずに進めます。取り返しのつかない削除や秘密の公開はしません。悪い結果も正直に書きます。

### English (plain and friendly)
**What works now**
- Big AI models are often split into several files. The program now downloads every part and loads them (`aruaru-llm` and `open-cuda`).
- We ran the real Qwen2.5-3B model (about 6 GB) on an ordinary PC with no GPU, and it wrote text (about 48 seconds to load, about 0.6 words per second).
- We built a way to keep the weights as small "FP8" numbers. Memory drops to about a quarter and quality stays almost the same (perplexity 7.08 to 7.27). After speed fixes, loading went from 340 s to 21 s and writing from 1067 s to 69 s. It is still about 2.8 times slower than the normal way, so it is for when memory is short.

**What we tested (honest results)**
- Squeezing the memory afterwards with MLA does not work: it hurts quality (25% smaller gave perplexity 7.1 to 12.7; 50% smaller broke the text).
- We tried "folding" by skipping layers on the 1.5B model. Skipping one layer at a time showed that many middle layers (5, 10, 12, 15 and so on) barely matter, while layers 1, 24 and 26 matter a lot. Skipping three layers gave perplexity 7.19 (from 7.08), only about 7% faster, with slightly less accurate answers. Skipping six or more breaks the model. **Skipping layers without retraining gives only a small gain.**
- Toshiba's Simulated Bifurcation and Fujitsu's Digital Annealer find the best combination among many choices. They do not speed up the AI by themselves. They could help choose which layers to skip or how many bits to use, but we have not tried that yet.

**What comes next (we go on without asking)**
1. Search for the best set of layers to skip with annealing or SB, and compare with the greedy way.
2. Make FP8 faster (SIMD, f16 storage).
3. Measure whether 7B (about 12 to 15 GB) fits a 32 GB PC with FP8.
4. Bring sharded models and FP8 into `pl2pl llm setup`.

**Our promise**: for safe unfinished work we go on without asking each time. We never do irreversible deletes or publish secrets, and we report bad results honestly.


## 2026-11-19 追記: 書き込みのあとの取り直し(実機確認) / Re-reading after a write (verified)

### 日本語(やさしい説明)
- 書き込み(変更)が型付きの結果を返すとき、**同じ1回の質問で、別のサーバーの最新の値も受け取れる**ことを、本物のサーバー2つで確かめました。例: `mutation { Touch(input:{id:"a1"}) { id visits count } }` は、書き込み(`visits`)を**1回だけ**実行し、そのあと`count`を別のサーバーから読みます(2回続けて呼ぶと`visits`は1、2と増えます)。
- 仕組みは、これまでの「変更は1回だけ実行して、読み取りだけをほかのサーバーへつなぐ」計画です。新しい仕組みを足さなくても、取り直しの目的を満たしています。`serve_greeter`に`Touch`の例を足しました。
- この項目(書き込み後の取り直し)は完了にします。残りは、型が違う`... on 型`、Reaxtのもっと複雑な型、広い実機試験、Mojo/Mac/Android/iPhone、クラウドの定期実行(先にGitHubをClaudeにつなぐ)です。

### English (natural, plain wording)
- When a write returns a typed result, **one single request can also bring back the latest values from another server**. We checked this with two real servers. Example: `mutation { Touch(input:{id:"a1"}) { id visits count } }` runs the write (`visits`) **exactly once**, then reads `count` from the other server (calling it twice makes `visits` go 1, then 2).
- It works through the existing plan: run the mutation once and join only read-only fields from other servers. No new mechanism was needed to meet the goal. We added a `Touch` example to `serve_greeter`.
- We mark this item (re-reading after a write) as done. Still open: `... on Type` with a different type, richer Reaxt types, wider real-world tests, Mojo/Mac/Android/iPhone, and the scheduled cloud runs (first connect GitHub to Claude).

- 最終まとめ / Final summary (2026-11-19): pl2pl は、COBOL・C・C++・Fortran を、選んだ組み合わせ(Axum・Poem・FastAPI・RPoem・RPoRea × HTML5/CSS3/TypeScript/Bootstrap × MySQL/MariaDB/PostgreSQL/SQLite)のウェブアプリにするお助けロボットです。`pl2pl cobol --os` で別 OS 用の COBOL ビルド、`pl2pl c2rust` で単純な C/C++ を Rust へ。残り: Fortran の Rust 化・RPoem サーバー実登録・メール到達確認・Kokkos GPU(確認せず自動で進める)。元の COBOL_to/Java_to を消す作業だけ最後に確認。再開は `F:\pl2pl\PORTING.md` の末尾。/ pl2pl is a helper robot that turns COBOL, C, C++ and Fortran into web apps in the mix you choose. `pl2pl cobol --os` builds COBOL for another OS and `pl2pl c2rust` rewrites simple C/C++ into Rust. Still open: Fortran to Rust, real RPoem server registration, mail-arrival check, Kokkos on a GPU (continued automatically). Only deleting the original COBOL_to/Java_to is confirmed first. Resume from the end of `F:\pl2pl\PORTING.md`.


## 2026-11-19 リミット前の最終まとめ(2回目) / Final summary before the limit, part 2 (日本語・English)

### 日本語(やさしい説明)
**終わったこと**
- **`... on 型`**: スキーマに「インターフェース」や「ユニオン」が1つも無いときは、型が違う`... on 別の型`は絶対に当てはまらないので、安全に取り除けるようにしました(`SubgraphModel.has_abstract`で判定)。インターフェース/ユニオンがあるときは、これまでどおり通常の転送にします。ゲートウェイ試験59件・federation試験16件が成功。
- **Androidスマホでの実機試験**: `librporea_ffi.so`(aarch64)をスマホ(A401OP)に入れ、Cのテストプログラム(`RPoRea/bindings/c/android_test.c`)で、サーバー起動・Connectの呼び出し(200)・ファイル配信・拒否(403)・GETは405(RESTなし)を確認し、すべて成功しました。
- **書き込み後の取り直し**: 実機で確認済み(前の節)。

**まだ終わっていないこと**
1. **Mojo**: WSLにMojoを入れて、`RPoRea`のC ABIを呼ぶ確認と`bindings/mojo`の作成(導入中。入ったら、動かして書く)。
2. Reaxtのもっと複雑な型(`Option`の入れ子、`HashMap`など)。
3. open-cosmoのルーターでの、もっと広い実機試験。
4. Mac・iPhoneでの確認。
5. 軽い仕事のクラウド定期実行(先にGitHubをClaudeにつなぐ)。

**再開のしかた**: 新しい会話で「`F:\runo\PORTING.md`の末尾を読んで、4姉妹の未了を確認なしで自動で進めて」と伝えてください。

### English (natural, plain wording)
**What is done**
- **`... on Type`**: when a schema has no interface or union at all, a fragment on a different type can never match, so it is now safely dropped (decided by `SubgraphModel.has_abstract`). When interfaces or unions exist, the query is forwarded unsplit as before. 59 gateway tests and 16 federation tests pass.
- **Real Android phone test**: we put `librporea_ffi.so` (aarch64) on the phone (A401OP) and ran a C test program (`RPoRea/bindings/c/android_test.c`). Starting the server, a Connect call (200), static assets, a denial (403) and GET returning 405 (no REST) all passed.
- **Re-reading after a write**: verified on real servers (previous section).

**What is still open**
1. **Mojo**: install Mojo in WSL, check that it can call RPoRea's C ABI, and write `bindings/mojo` (the install is running; once it finishes we run and write it).
2. Richer Reaxt types (nested `Option`, `HashMap`, and so on).
3. Wider real-world tests with the open-cosmo router.
4. Checks on Mac and iPhone.
5. Scheduled cloud runs for light jobs (first connect GitHub to Claude).

**How to resume**: in a new conversation, say "Read the end of `F:\runo\PORTING.md`, then keep working through the open items of the four sister projects without asking for confirmation."

## 2026-11-19 最後の追記: 飛ばす層の探し方 / Last note: choosing which layers to skip

### 日本語(やさしい説明)
- **やったこと**: AIの「飛ばしてもよい層」を、3つ選ぶ問題として2通りで探しました。(1)貪欲法=いちばん良い層を1つずつ足す。(2)焼きなまし=選び方を少しずつ入れ替えて探す。同じ試行回数(78回)で比べました。
- **結果(Qwen2.5-1.5B)**: 貪欲法は {5, 12, 15} 番で迷い度 7.187(元は 7.08)。焼きなましは {12, 15, 16} 番で 7.438。**この小さな問題では、焼きなましは貪欲法に勝てませんでした。** 5個の場合の比較は途中です。
- **気をつけること**: 1つの短い文だけで選んでいるので、その文にだけ合った選び方かもしれません。別の文でも確かめる必要があります。
- **ずっと言えること**: 東芝SBや富士通デジタルアニーラは、層がもっと多い大きなAIや、ビット配分のように選択肢が爆発する問題で試す価値があります。今回の小さな問題では、ふつうの方法で足ります。
- **アップロード**: コードと文書は GitHub の `main` に push しました。VPS には、きれいなクローンだけ安全に更新します(再ビルドや再起動はしません)。
- **これから(確認せず進めます)**: 5個の比較を終える、別の文で確かめる、FP8を速くする、7Bを測る、`pl2pl llm setup` に反映する。

### English (plain and friendly)
- **What we did**: We looked for three "layers that are safe to skip" in two ways. (1) Greedy: add the best layer one at a time. (2) Annealing: swap choices little by little. Both got the same number of tries (78).
- **Result (Qwen2.5-1.5B)**: Greedy picked layers {5, 12, 15} with perplexity 7.187 (the original is 7.08). Annealing picked {12, 15, 16} with 7.438. **On this small problem, annealing did not beat greedy.** The comparison for five layers is still running.
- **A caution**: We chose using one short sentence, so the choice may fit only that sentence. We must check with other sentences.
- **What still holds**: Toshiba's Simulated Bifurcation and Fujitsu's Digital Annealer are worth trying on bigger models with many more layers, or on problems like bit allocation where the choices explode. For this small problem, the plain method is enough.
- **Upload**: Code and docs are pushed to `main` on GitHub. On the VPS we only update clean clones safely (no rebuild, no restart).
- **Next (we go on without asking)**: finish the five-layer comparison, check with other sentences, make FP8 faster, measure 7B, and bring it into `pl2pl llm setup`.


## 2026-11-20 Mojoでの確認(WSL) / Mojo check (WSL) (日本語・English)

### 日本語(やさしい説明)
- **Mojo 1.2.0をWSL(Ubuntu)に入れました**(`pip install mojo`、仮想環境`~/mojo-venv`)。MojoはWindowsでは直接動かないので、WSLで使います。
- **MojoからRPoReaのC ABIを実際に呼ぶ試験**(`RPoRea/bindings/mojo/test_rporea.mojo`)が成功しました: ライブラリ読み込み → バージョン取得 → ビルダー作成 → ファイル登録 → サーバー起動 → HTTPで`hello from mojo`を取得(200) → 未登録のメソッドは404。実行のしかた: `RPOREA_LIB=/root/rporea-target/release/librporea_ffi.so mojo test_rporea.mojo`(WSL)。
- **Mojo 1.2での書き方のコツ**: ポインタは`Int`で渡す(`Int(s.unsafe_ptr())`)。`len(String)`は使えないので`byte_length()`。Pythonの値は`Int(py=...)`・`String(py=...)`で変換する。
- **まだ**: Mojoの関数をC側のコールバックとして渡す部分(`rporea_method`)は未了。Mac・iPhoneの確認も未了。
- Androidスマホ(A401OP)での実機試験は、前の節のとおり成功済みです。

### English (natural, plain wording)
- **Mojo 1.2.0 is installed in WSL (Ubuntu)** (`pip install mojo`, virtual environment `~/mojo-venv`). Mojo does not run natively on Windows, so we use it through WSL.
- **A test that calls RPoRea's C ABI from Mojo** (`RPoRea/bindings/mojo/test_rporea.mojo`) passes: load the library, read the version, create a builder, register a file, start the server, fetch `hello from mojo` over HTTP (200), and get 404 for an unregistered method. Run it in WSL with `RPOREA_LIB=/root/rporea-target/release/librporea_ffi.so mojo test_rporea.mojo`.
- **Tips for Mojo 1.2**: pass pointers as `Int` (`Int(s.unsafe_ptr())`); `len(String)` is not allowed, so use `byte_length()`; convert Python values with `Int(py=...)` and `String(py=...)`.
- **Still open**: passing a Mojo function as a C callback (`rporea_method`), and the Mac and iPhone checks.
- The real-phone test on the Android device (A401OP) passed earlier (see the previous section).


## 2026-11-20 追記: Mojoの関数をコールバックとして渡せた / A Mojo function works as a C callback (日本語・English)

### 日本語(やさしい説明)
- **Mojoで書いた関数を、RPoReaのメソッド(`rporea_method`)として登録できました。** `RPoRea/bindings/mojo/test_callback.mojo` で、`POST /demo.v1.Echo/Say` に`{"a":1}`を送ると、Mojoの関数が`{"echo":{"a":1}}`を返し、200になることを確かめました。
- 書き方のコツ: コールバックは`def 名前(user: Int, body: Int, blen: UInt, dst: Int, cap: UInt) abi("C") -> Int`と書きます(`out`はMojoの予約語なので`dst`)。ポインタは`Int`で受け取り、`UnsafePointer[UInt8, MutAnyOrigin](unsafe_from_address=...)`で読み書きします。登録のときは、関数をそのまま引数に渡します。
- 実行のしかた(WSL): `RPOREA_LIB=/root/rporea-target/release/librporea_ffi.so mojo test_callback.mojo`。
- **まだ**: Mac・iPhoneでの確認、Reaxtのもっと複雑な型、open-cosmoでの広い実機試験、クラウドの定期実行(先にGitHubをClaudeにつなぐ)。

### English (natural, plain wording)
- **A function written in Mojo can now be registered as an RPoRea method (`rporea_method`).** In `RPoRea/bindings/mojo/test_callback.mojo`, a `POST /demo.v1.Echo/Say` with `{"a":1}` returned `{"echo":{"a":1}}` with status 200, produced by the Mojo function.
- Tips: write the callback as `def name(user: Int, body: Int, blen: UInt, dst: Int, cap: UInt) abi("C") -> Int` (`out` is a reserved word in Mojo, so use `dst`). Receive pointers as `Int` and read or write them with `UnsafePointer[UInt8, MutAnyOrigin](unsafe_from_address=...)`. When registering, pass the function itself as the argument.
- Run it in WSL: `RPOREA_LIB=/root/rporea-target/release/librporea_ffi.so mojo test_callback.mojo`.
- **Still open**: the Mac and iPhone checks, richer Reaxt types, wider real-world tests with open-cosmo, and the scheduled cloud runs (first connect GitHub to Claude).

- 2026-11-20 追記 / Update: `pl2pl f2rust`(単純な Fortran → Rust)を追加。残り: RPoem サーバー実登録・メール到達確認・Kokkos GPU・gfortran 実機確認。/ Added `pl2pl f2rust` (simple Fortran to Rust). Still open: real RPoem server registration, mail-arrival check, Kokkos on a GPU, a real gfortran comparison.

- 2026-11-20 追記 / Update: 本物の gfortran で Fortran 橋渡しと `pl2pl f2rust` の出力一致を確認。残り: RPoem サーバー実登録・メール到達確認・Kokkos GPU。/ Fortran bridge and `pl2pl f2rust` output verified against a real gfortran. Still open: real RPoem server registration, mail-arrival check, Kokkos on a GPU.

## 2026-11-20 追記: 7Bも動いた / Update: 7B runs too

### 日本語(やさしい説明)
- **7Bが32GBのパソコンで動きました**: Qwen2.5-7B-Instruct(4つに分かれた約15GB)を、FP8で読み込んで文章を作れました。メモリに収まり、読み込みは約3.5分、文章づくりは1語あたり約8秒(とても遅いけれど、動きます)。品質の目安の迷い度は、評価用の文で8.6、別の文で12.2でした。1.5Bの別の文(12.1)とほぼ同じ値です。
- **層を飛ばす方法(折り畳み)の最終結果**: 1つの文だけで飛ばす層を選ぶと、別の文で悪くなりました(5・12・15番を飛ばすと別の文で約15%悪化、5層飛ばすとさらに悪化)。速くなるのは最大でも約14%です。**学び直しなしでは、実用的な効果は小さい**です。貪欲法と焼きなましは、この小さな問題では大差ありませんでした。
- **`pl2pl llm setup` について**: 分割モデルの対応は `aruaru-llm` の `main` に入りました。`pl2pl` が使う配布版(v0.2.5)にはまだ入っていないので、新しい版を出すまで、3Bは今までどおり自動で小さいモデルに下がります。新版を出したら3B・7Bも選べるようにします。
- **これから(確認せず進めます)**: FP8をもっと速くする(SIMDなど)、新しい版の公開、クラウドで頼んだ調査文書の確認。

### English (plain and friendly)
- **7B runs on a 32 GB PC**: We loaded Qwen2.5-7B-Instruct (about 15 GB in four parts) as FP8 and it wrote text. It fits in memory; loading took about 3.5 minutes and writing took about 8 seconds per word (very slow, but it works). The quality score (perplexity) was 8.6 on the test sentence and 12.2 on other sentences, about the same as the 1.5B model on other sentences (12.1).
- **Final result for layer skipping ("folding")**: Choosing layers to skip from a single sentence got worse on other sentences (skipping layers 5, 12 and 15 was about 15% worse on other sentences, and skipping five was worse still). The speed gain is at most about 14%. **Without retraining, the practical gain is small.** On this small problem, greedy search and annealing made little difference.
- **About `pl2pl llm setup`**: Sharded-model support is now on `main` in `aruaru-llm`. The released build that `pl2pl` uses (v0.2.5) does not have it yet, so until a new release, 3B still falls back to a smaller model as before. After the new release, 3B and 7B can be chosen.
- **Next (we go on without asking)**: make FP8 faster (SIMD and more), publish a new release, and check the survey document requested from the cloud.

- 2026-11-20 追記 / Update: RPoem/RPoRea の骨組みを本物の RPoem サーバー(`open-runo-connect-server`)に載せて確認(Connect JSON)。残り: gRPC/gRPC-web の実呼び出し・メール到達・Kokkos GPU。/ The RPoem/RPoRea scaffold runs on the real RPoem server (verified with Connect JSON). Still open: real gRPC/gRPC-web calls, mail arrival, Kokkos on a GPU.


## 2026-11-20 追記: Mac・iPhone・Androidの確認(CI) / Mac, iPhone and Android checks (CI) (日本語・English)

### 日本語(やさしい説明)
- **RPoReaにCI(GitHub Actions)を追加しました**(`RPoRea/.github/workflows/ci.yml`)。結果は**5つすべて成功**です。
  - Linux・macOS・Windows: ビルド、テスト、そして**PythonからC ABIを実際に呼ぶ試験**(macOSでは`.dylib`)。
  - iPhone(iOS): 実機用(`aarch64-apple-ios`)とシミュレーター用(`aarch64-apple-ios-sim`)のビルド。
  - Android(NDK): `aarch64-linux-android`のビルド。
- つまり、**Macでの動作(Python経由の実呼び出し)とiPhone向けのビルドが、CIで確認できました**。Androidはスマホの実機試験も成功済みです。iPhoneの実機・Macの実機での目視確認は、実機が無いのでできていません。
- CIがつまずいた理由と直し方: RPoReaは兄弟のリポジトリを相対パスで使うので、CIでも`Reaxt`・`RPoem`・`RS-JSON`・`open-web-server`・`RS-SmartTCP`・`open-raid-z`・`open-cpu`・`open-cuda`・`open-directx`を同じ親フォルダーへ取得します(`working-directory: RPoRea`)。新しい兄弟リポジトリを使うようになったら、`ci.yml`に足してください。
- **まだ**: クラウドの定期実行(先にGitHubをClaudeにつなぐ)。iPhone・Macの実機での確認。

### English (natural, plain wording)
- **We added CI (GitHub Actions) to RPoRea** (`RPoRea/.github/workflows/ci.yml`), and **all five jobs pass**.
  - Linux, macOS and Windows: build, tests, and a **Python test that really calls the C ABI** (the `.dylib` on macOS).
  - iPhone (iOS): builds for devices (`aarch64-apple-ios`) and the simulator (`aarch64-apple-ios-sim`).
  - Android (NDK): a build for `aarch64-linux-android`.
- So **running on a Mac (a real call through Python) and building for iPhone are now confirmed in CI**. Android also passed the real-phone test. We have not checked by eye on a real iPhone or a real Mac, because we have no such devices.
- Why CI tripped, and the fix: RPoRea uses sibling repositories through relative paths, so CI also checks out `Reaxt`, `RPoem`, `RS-JSON`, `open-web-server`, `RS-SmartTCP`, `open-raid-z`, `open-cpu`, `open-cuda` and `open-directx` into the same parent folder (`working-directory: RPoRea`). If RPoRea starts using another sibling repository, add it to `ci.yml`.
- **Still open**: scheduled cloud runs (first connect GitHub to Claude), and real-device checks on iPhone and Mac.

## 2026-11-20 低VRAM・VRAM無しでの安定高速化のノウハウ / Low-VRAM know-how
日本語: VRAMが無い/小さいPC・VPSでAIを安定して速く動かす技術(分割重み・mmap・FP8・混合精度・小行列の直列化・プロンプト上限・同時実行上限、効かなかった手法も)は [aruaru-llm/docs/LOW-VRAM-KNOWHOW.md](https://github.com/aon-co-jp/aruaru-llm/blob/main/docs/LOW-VRAM-KNOWHOW.md) に集約。AIやLLMを扱う関連リポジトリはこれを参照し、同じ失敗を繰り返さない。
English: Techniques for running AI stably and fast on machines with no or little VRAM (sharded weights, mmap, FP8, mixed precision, serial small GEMMs, prompt caps, concurrency caps, plus what did not work) are collected in the file above. Related repos that use AI/LLMs should follow it.

## 2026-11-20 方針: 姉妹リポジトリとして同時開発 / Sister repositories, developed together
**日本語**: pl2pl の変換機能は、`Reaxt`・`RPoRea`・`RPoem`・`RMojo`・`open-cosmo` などを、**変換の前でも後でも使える**ようにします(変換元として読む、変換先の骨組みとして出す、出力を動かす土台にする)。これらは `pl2pl` の**姉妹リポジトリ**として、今後は**いつも同時に一緒に開発**します。1つを変えたら、ほかの姉妹の動作確認と README / CLAUDE / PORTING / POLICY の更新を同じ日に行い、未了は確認せず自動で進めます(元の COBOL_to / Java_to の削除だけは最後に確認)。
**English**: pl2pl's conversion features must work with `Reaxt`, `RPoRea`, `RPoem`, `RMojo` and `open-cosmo` both **before and after conversion** (read as a source, emitted as a target scaffold, used as the runtime for the output). They are **sister repositories** of `pl2pl` and are **always developed together**: when one changes, check the others and update README / CLAUDE / PORTING / POLICY the same day. Unfinished items continue automatically; only deleting the original COBOL_to / Java_to is confirmed last.

## VPS向けLinuxバイナリの作り方(glibcの版ずれ対策、2026-11-20)
- 既定のWSL(`Ubuntu`)は Ubuntu 26.04 で glibc 2.43。VPS(AlmaLinux 10.2)は glibc 2.39。既定のWSLで作ると、VPSで「GLIBC_2.4x not found」で起動しないことがある。
- **VPSへ送るLinuxバイナリは、WSLの`Ubuntu-24.04`(glibc 2.39、Rust導入済み)で作る**。手順は [`vps-build.sh`](vps-build.sh):
  `wsl -d Ubuntu-24.04 -- bash /mnt/f/runo/vps-build.sh /mnt/f/<repo> <cargo buildの引数>`
  (出力先は`/root/vps-target/<repo>/release/`、Windowsからは`\wsl.localhost\Ubuntu-24.04\root\vps-target\...`)
- 作ったあと [`check-glibc.sh`](check-glibc.sh) が自動で検査し、2.39を超える版が必要なら NG で失敗する。他の方法で作ったバイナリも、送る前にこれを通す。VPSのOSを上げたら`VPS_GLIBC`で上限を変える。
- 確認済み: open-web-server(本番機能セット)をこの方法で作り、検査OK・VPSで`ldd`の不足0。逆に既定WSLの`/usr/bin/ls`は2.43が必要として正しくNGになる。

## Building Linux binaries for the VPS (glibc mismatch, 2026-11-20)
- The default WSL (`Ubuntu`) is Ubuntu 26.04 with glibc 2.43; the VPS (AlmaLinux 10.2) has glibc 2.39. Binaries built in the default WSL may fail on the VPS with "GLIBC_2.4x not found".
- **Build binaries for the VPS in the WSL distro `Ubuntu-24.04` (glibc 2.39, Rust installed)** with [`vps-build.sh`](vps-build.sh): `wsl -d Ubuntu-24.04 -- bash /mnt/f/runo/vps-build.sh /mnt/f/<repo> <cargo build args>`.
- [`check-glibc.sh`](check-glibc.sh) runs afterwards and fails (NG) if any binary needs a glibc newer than 2.39. Run it on binaries built any other way too. Raise the limit with `VPS_GLIBC` after upgrading the VPS OS.
- Verified: open-web-server (production features) built this way passes the check and has no missing libraries on the VPS; the default WSL's `/usr/bin/ls` is correctly rejected (needs 2.43).

## 2026-11-20 追記: RNode.js(Rust 版 Node.js 互換)を姉妹に追加 / RNode.js added as a sister
**日本語**: `RS-Node.js`(RNode.js)は、Node.js 互換を目指す Rust 製の実行環境です。JavaScript は Rust 製エンジン Boa、TypeScript は `RS-TypeScript` を通して動き、将来は `RS-JavaScript`(一から作る Rust 製エンジン)に差し替えられます。本物の Node.js(v26.5.0)と同じスクリプトの出力を比べて互換を確かめながら開発しており、現在の対応は `console`・`process`・`require`(`path`・`fs` の同期版)までです。Node.js を選んだ利用者への案内に、代わりの候補として追加しました。姉妹リポジトリ(Reaxt・RPoRea・RPoem・RMojo・open-cosmo・RS-TypeScript・RS-JavaScript・RS-Node.js・pl2pl)は同時に開発します。
**English**: `RS-Node.js` (RNode.js) is a Rust runtime aiming at Node.js compatibility. JavaScript runs on the Rust engine Boa and TypeScript through `RS-TypeScript`; `RS-JavaScript` (our from-scratch Rust engine) can replace Boa later. It is developed by comparing script output against real Node.js (v26.5.0); current coverage is `console`, `process` and `require` (synchronous `path` and `fs`). It is now listed as an alternative in the notice shown to users who pick Node.js. The sister repositories (Reaxt, RPoRea, RPoem, RMojo, open-cosmo, RS-TypeScript, RS-JavaScript, RS-Node.js, pl2pl) are developed together.


## 2026-11-20 現状と完成予定 / Status and planned work (日本語・English)

### 日本語(やさしい説明)
**現状(実機で確認済み)**
- 4姉妹(open-cosmo・RPoem・Reaxt・RPoRea)は、いつも一緒に作っています。
- ゲートウェイ(open-cosmo)は、複数のサーバーに質問を分けて、答えを1つにまとめます。`@key`・`@requires`・`@provides`・`@skip`・`@include`・名前付きフラグメント・書き込みのあとの取り直しに対応しています。試験はゲートウェイ59件、Reaxt 22件、本物のサーバーを並べた通し試験21項目が成功しています。
- **Reaxt 以外の実装とも結合できます**: Apollo(Node.js)と Rust の async-graphql のサブグラフを、Reaxt と並べて、分割と `@key` 結合が動くことを確かめました。
- Reaxt のアクションは、`Option`・`Vec`・`HashMap`・`f32`・`f64`・各種整数・`Box<T>`・最大6個までのタプルを使えます(v0.1.3 で公開済み)。
- RPoRea は、Python・Mojo・Android(実機)から呼べます。Mac と iPhone は CI での確認までです。
- 全公開リポジトリと非公開9件に、最新の `.md` とインストーラー一覧を出す仕組み(`docs-latest`)が入っています(日本時間 10時・12時・22時ごろ)。

**完成予定(未了)**
1. Mac・iPhone の実機確認(実機がありません)。
2. 7個以上のタプルへの対応(必要になってから)。
3. クラウドでの定期実行(GitHub を Claude につなぐと作れます)。
4. `docs-latest` の定期実行(cron)が実際に動いたかの確認(日本時間 22:07 以降)。
- 対象外にしたもの: `Option` の入れ子(`null` で段が区別できません)。

**決まり**: 終わっていない仕事は確認せず自動で進めます。試験して本物で確かめてから「できた」と書きます。秘密は書きません。新しい REST は作りません。Node.js は、ユーザーが許可した試験(Apollo の相互運用)だけで使います。

### English (plain words)
**Where we are (checked on real systems)**
- We always build the four sisters (open-cosmo, RPoem, Reaxt, RPoRea) together.
- The gateway (open-cosmo) splits a question across several servers and merges the answers. It supports `@key`, `@requires`, `@provides`, `@skip`, `@include`, named fragments and re-reading after a write. 59 gateway tests, 22 Reaxt tests and a 21-check end-to-end run with real servers all pass.
- **It also joins with non-Reaxt implementations**: we ran an Apollo (Node.js) subgraph and a Rust async-graphql subgraph next to Reaxt, and both splitting and `@key` joins worked.
- Reaxt actions can use `Option`, `Vec`, `HashMap`, `f32`, `f64`, the integer types, `Box<T>` and tuples of up to 6 elements (released in v0.1.3).
- RPoRea can be called from Python, Mojo and Android (real phone). Mac and iPhone are checked in CI only.
- Every public repository and 9 private ones have the `docs-latest` workflow, which shows the latest `.md` files and an installer list (about 10:00, 12:00 and 22:00 Japan time).

**Planned (still open)**
1. Real-device checks on Mac and iPhone (we have no devices).
2. Tuples of seven or more (when needed).
3. Scheduled cloud runs (possible once GitHub is connected to Claude).
4. Confirming that the `docs-latest` schedule (cron) really fires (after 22:07 Japan time).
- Left out on purpose: nested `Option` (`null` cannot tell the levels apart).

**Rules**: we go on with unfinished work without asking; we test and verify on real systems before saying "done"; we never write secrets; we add no new REST APIs; Node.js is used only for tests the owner allowed (the Apollo interop).
## 2026-11-20 version-control通知(10リポジトリ)対応の現状と完成予定 / Version-control notice (10 repos): status and plan

### 日本語
**現状(できたこと)**
- **依存の更新と脆弱性の修正**: lettre 0.11.24(RUSTSEC-2026-0560〜0565)を RS-Sync・open-web-server・open-easy-web へ、sqlx 0.9.1+libsqlite3-sys 0.40(RUSTSEC-2026-0459)を RPoem・open-cosmo・open-web-server へ入れ、qrcode 0.15・sonic-rs 0.5 などにも更新。どれもビルドと試験が成功し、push 済み。
- **本番への反映**: lettre を直した open-web-server(入口のサーバー)と open-easy-web を作り直して入れ替えました。14ドメインの応答が入れ替え前と同じ、エラーログ0。旧版は `*.before-lettre-20261120` に残しています。
- **RPoem の脆弱性チェック(security-audit.yml)**: 設定ファイルの書き方の誤りで動いていなかったのを直し、成功を確認。
- **VPS 用ビルドの glibc ずれ対策**: VPS 用の Linux プログラムは WSL の `Ubuntu-24.04`(glibc 2.39)で [`vps-build.sh`](vps-build.sh) を使って作り、[`check-glibc.sh`](check-glibc.sh) で自動検査します。
- **VPS のクローンの最新化**: RPoem・RUNO・open-cosmo・open-cuda・open-web-server・rs-sync・whisper.cpp に加え、遅れていた aruaru-llm・open-bar・open-easy-web-app も最新にしました。
  - aruaru-llm は、手元で変わっているファイル(動いているサービスが更新するニュースのデータ)と届いた変更が重ならないため、そのまま進めました。
  - open-bar と open-easy-web-app は、古い内容への書き戻しやビルドの残りでした。差分を `/root/<名前>-vps-local-20261120.patch` に保存し、`git stash` で退避してから進めたので、いつでも元に戻せます。
  - 動いているプログラムは入れ替えていません。
- **RS-Sync のときどき落ちる試験**: 同期の記録の保存・読み込みに失敗しても黙って無視していたのを直しました(一時ファイル+名前の置き換え、やり直し、失敗の報告)。試験は全109件成功で、問題の試験も25回中25回成功(`d73c2c1`)。ただし、この PC では修正前でも失敗が再現しなかったので、原因が確定したとは言えません。

**完成予定(これから)**
- RS-Sync の今回の修正を、次のリリースで本番に反映する。
- 実スマホのカメラでの QR ログイン、実際の SMTP での `otp_qr` の通し試験(人の操作が必要)。
- VPS の stash とパッチ(open-bar・open-easy-web-app)は、中身が不要と確かめられたら消す(今は残す)。

### English
**Current state (done)**
- **Dependency and security updates**:
  - lettre 0.11.24 (RUSTSEC-2026-0560..0565) in RS-Sync, open-web-server and open-easy-web.
  - sqlx 0.9.1 with libsqlite3-sys 0.40 (RUSTSEC-2026-0459) in RPoem, open-cosmo and open-web-server.
  - Also qrcode 0.15, sonic-rs 0.5 and others.
  - Everything builds, tests pass, and it is pushed.
- **Production**: rebuilt and swapped open-web-server (the front server) and open-easy-web with the lettre fix. All 14 domains answer exactly as before; error log 0. The old binaries are kept as `*.before-lettre-20261120`.
- **RPoem security audit (security-audit.yml)**: it was not running because of a YAML mistake. Fixed, and confirmed passing.
- **glibc mismatch for VPS builds**: VPS Linux binaries are now built in WSL `Ubuntu-24.04` (glibc 2.39) with [`vps-build.sh`](vps-build.sh), and checked automatically by [`check-glibc.sh`](check-glibc.sh).
- **VPS clones updated**: RPoem, RUNO, open-cosmo, open-cuda, open-web-server, rs-sync and whisper.cpp, plus aruaru-llm, open-bar and open-easy-web-app, which had fallen behind.
  - aruaru-llm: the locally changed file is news data written by the running service, and the incoming commits do not touch it, so it fast-forwarded as is.
  - open-bar and open-easy-web-app: the local changes were old-content reverts and build leftovers. They were saved to `/root/<name>-vps-local-20261120.patch` and stashed before the fast-forward, so both can be restored.
  - No running binaries were swapped.
- **RS-Sync flaky test**: failed saves and reads of the sync record were silently ignored. Now the state is written to a temp file and renamed into place, with retries, and failures are reported (`d73c2c1`). All 109 tests pass, and the flaky test passed 25 of 25 runs. Honest note: the failure did not reproduce on this PC even with the old code, so the cause is not proven.

**Planned (next)**
- Ship the RS-Sync fix to production with the next release.
- End-to-end tests that need a person: QR login with a real phone camera, and an `otp_qr` run with real SMTP.
- Remove the VPS stash and patches (open-bar, open-easy-web-app) once they are confirmed unneeded (kept for now).

## 2026-11-20 追記: RS-Sync の同期状態の修正を本番へ反映 / Update: RS-Sync state fix deployed to production

### 日本語
- `d73c2c1`(同期の記録を確実に保存する修正)を、VPS と同じ glibc 2.39 の WSL `Ubuntu-24.04` で作り(`vps-build.sh`、検査OK)、VPS の `rs-sync`(本番)と `rs-sync-demo`(デモ)を入れ替えました。2つは同じプログラムを使っています。
- 旧版は `/root/rs-sync/target/release/rs-sync.before-state-20261120` に残しました。失敗したら自動で元に戻す手順付きで、戻す必要はありませんでした。
- 確認したこと:
  - 本番: `GetLoginMode` 200、認証なしの `ListAccounts` 401。
  - デモ: `GetLoginMode` 200、`ListAccounts` 200。
  - 旧 `/api/accounts` は 404。公開URL 200、`/healthz` 200、エラーログ0、足りないライブラリ0。
- これで「本番への反映」は完了です。残りは、実スマホのカメラでの QR ログインと、実際のメールでの `otp_qr` の通し試験(人の操作が必要)です。

### English
- `d73c2c1` (reliable sync-state saving) was built in WSL `Ubuntu-24.04` with glibc 2.39, the same as the VPS (`vps-build.sh`, check OK). It was swapped into `rs-sync` (production) and `rs-sync-demo` (demo) on the VPS; both use the same binary.
- The old binary is kept at `/root/rs-sync/target/release/rs-sync.before-state-20261120`. The swap had automatic rollback on failure, and no rollback was needed.
- Verified:
  - Production: `GetLoginMode` 200; unauthenticated `ListAccounts` 401.
  - Demo: `GetLoginMode` 200; `ListAccounts` 200.
  - Old `/api/accounts` 404; public URL 200; `/healthz` 200; error log 0; no missing libraries.
- The production deploy is done. Still open: a QR login with a real phone camera and an `otp_qr` run with real mail (both need a person).


## 2026-11-20 現状と完成予定(8言語) / Status and planned work in 8 more languages (AI翻訳・ネイティブ確認前 / AI-translated, not yet native-checked)
日本語・English は直前の節「現状と完成予定 / Status and planned work」にあります。Japanese and English are in the section just above.

### 简体中文
**现状(已在真实环境确认)**:四个姐妹项目(open-cosmo、RPoem、Reaxt、RPoRea)始终一起开发。网关把一个问题分给多个服务器并合并答案,支持 `@key`、`@requires`、`@provides`、`@skip`、`@include`、具名片段和写入后重新读取。网关测试59项、Reaxt 测试22项、用真实服务器的端到端21项全部通过。已确认可与非 Reaxt 的实现(Apollo、Rust 的 async-graphql)联合。Reaxt v0.1.3 已发布(`f32`、`Box<T>`、最多6个元素的元组)。
**计划完成(未完成)**:① Mac 与 iPhone 真机确认(没有设备);② 云端定时执行(GitHub 已连接,但需在新会话或网页中注册,推送还需安装 Claude GitHub App);③ 确认 `docs-latest` 的定时(cron)确实触发。有意不支持:嵌套 `Option`。
**规则**:未完成的工作无需确认自动继续;在真实环境验证后才写"完成";不写入密码等机密;不新增 REST;Node.js 仅用于用户允许的测试。

### 繁體中文
**現況(已在真實環境確認)**:四個姊妹專案(open-cosmo、RPoem、Reaxt、RPoRea)一律一起開發。閘道把一個問題分給多個伺服器並合併答案,支援 `@key`、`@requires`、`@provides`、`@skip`、`@include`、具名片段與寫入後重新讀取。閘道測試59項、Reaxt 測試22項、以真實伺服器進行的端到端21項皆通過。已確認可與非 Reaxt 的實作(Apollo、Rust 的 async-graphql)聯合。Reaxt v0.1.3 已發布(`f32`、`Box<T>`、最多6個元素的元組)。
**預計完成(未完成)**:① Mac 與 iPhone 實機確認(沒有裝置);② 雲端定時執行(GitHub 已連接,但需在新工作階段或網頁中登錄,推送還需安裝 Claude GitHub App);③ 確認 `docs-latest` 的排程(cron)確實觸發。刻意不支援:巢狀 `Option`。
**規則**:未完成的工作不需確認自動繼續;在真實環境驗證後才寫「完成」;不寫入密碼等機密;不新增 REST;Node.js 僅用於使用者允許的測試。

### 한국어
**현황(실제 환경에서 확인)**: 네 자매 프로젝트(open-cosmo, RPoem, Reaxt, RPoRea)는 항상 함께 개발합니다. 게이트웨이는 질문 하나를 여러 서버에 나눠 묻고 답을 합치며, `@key`, `@requires`, `@provides`, `@skip`, `@include`, 이름 있는 프래그먼트, 쓰기 뒤 다시 읽기를 지원합니다. 게이트웨이 시험 59건, Reaxt 시험 22건, 실제 서버로 한 종단 간 시험 21항목이 모두 통과했습니다. Reaxt 외의 구현(Apollo, Rust의 async-graphql)과도 결합됨을 확인했습니다. Reaxt v0.1.3을 공개했습니다(`f32`, `Box<T>`, 최대 6개 요소의 튜플).
**완성 예정(미완료)**: ① Mac·iPhone 실기기 확인(기기가 없음), ② 클라우드 정기 실행(GitHub는 연결했으나 새 세션이나 웹에서 등록해야 하고, push에는 Claude GitHub App 설치가 필요), ③ `docs-latest`의 정기 실행(cron)이 실제로 동작하는지 확인. 의도적으로 제외: 중첩 `Option`.
**규칙**: 끝나지 않은 일은 확인 없이 자동으로 계속합니다. 실제 환경에서 확인한 뒤에만 "완료"라고 씁니다. 비밀번호 같은 비밀은 쓰지 않고, 새 REST는 만들지 않으며, Node.js는 사용자가 허가한 시험에만 씁니다.

### Deutsch
**Stand (auf echten Systemen geprüft)**: Die vier Schwesterprojekte (open-cosmo, RPoem, Reaxt, RPoRea) entwickeln wir immer gemeinsam. Das Gateway verteilt eine Frage auf mehrere Server und fügt die Antworten zusammen; es unterstützt `@key`, `@requires`, `@provides`, `@skip`, `@include`, benannte Fragmente und das erneute Lesen nach einem Schreibvorgang. 59 Gateway-Tests, 22 Reaxt-Tests und ein End-to-End-Lauf mit 21 Prüfungen auf echten Servern bestehen. Die Zusammenarbeit mit Implementierungen außerhalb von Reaxt (Apollo, Rusts async-graphql) ist bestätigt. Reaxt v0.1.3 ist veröffentlicht (`f32`, `Box<T>`, Tupel mit bis zu 6 Elementen).
**Geplant (offen)**: ① Prüfung auf echten Mac- und iPhone-Geräten (keine Geräte vorhanden); ② zeitgesteuerte Cloud-Läufe (GitHub ist verbunden, muss aber in einer neuen Sitzung oder im Web angelegt werden; zum Pushen braucht es zudem die Claude GitHub App); ③ Bestätigung, dass der Zeitplan (cron) von `docs-latest` wirklich auslöst. Bewusst ausgelassen: verschachteltes `Option`.
**Regeln**: Unfertiges machen wir ohne Rückfrage weiter; „fertig“ schreiben wir erst nach der Prüfung auf echten Systemen; keine Geheimnisse (z. B. Passwörter); keine neuen REST-APIs; Node.js nur für vom Eigentümer erlaubte Tests.

### Français
**État (vérifié sur de vrais systèmes)** : nous développons toujours ensemble les quatre projets sœurs (open-cosmo, RPoem, Reaxt, RPoRea). La passerelle répartit une question sur plusieurs serveurs et assemble les réponses ; elle gère `@key`, `@requires`, `@provides`, `@skip`, `@include`, les fragments nommés et la relecture après écriture. 59 tests de la passerelle, 22 tests de Reaxt et un essai de bout en bout de 21 contrôles sur de vrais serveurs réussissent. La jonction avec des implémentations autres que Reaxt (Apollo, async-graphql en Rust) est confirmée. Reaxt v0.1.3 est publié (`f32`, `Box<T>`, tuples jusqu'à 6 éléments).
**Prévu (à faire)** : ① vérifier sur de vrais Mac et iPhone (nous n'avons pas d'appareils) ; ② exécutions planifiées dans le cloud (GitHub est connecté, mais il faut les créer dans une nouvelle session ou sur le web ; pour pousser, il faut aussi installer la Claude GitHub App) ; ③ confirmer que la planification (cron) de `docs-latest` se déclenche vraiment. Exclu volontairement : `Option` imbriqué.
**Règles** : ce qui n'est pas fini continue sans demander ; nous n'écrivons « terminé » qu'après vérification sur de vrais systèmes ; pas de secrets (mots de passe…) ; pas de nouvelle API REST ; Node.js seulement pour les essais autorisés par le propriétaire.

### Español
**Estado (comprobado en sistemas reales)**: los cuatro proyectos hermanos (open-cosmo, RPoem, Reaxt, RPoRea) se desarrollan siempre juntos. La pasarela reparte una pregunta entre varios servidores y junta las respuestas; admite `@key`, `@requires`, `@provides`, `@skip`, `@include`, fragmentos con nombre y volver a leer tras escribir. Pasan 59 pruebas de la pasarela, 22 de Reaxt y una prueba de extremo a extremo de 21 comprobaciones con servidores reales. Se confirmó la unión con implementaciones distintas de Reaxt (Apollo y async-graphql de Rust). Reaxt v0.1.3 está publicado (`f32`, `Box<T>`, tuplas de hasta 6 elementos).
**Previsto (pendiente)**: ① comprobar en Mac y iPhone reales (no tenemos dispositivos); ② ejecuciones programadas en la nube (GitHub está conectado, pero hay que crearlas en una sesión nueva o en la web; para hacer push también hace falta instalar la Claude GitHub App); ③ confirmar que la programación (cron) de `docs-latest` realmente se dispara. Excluido a propósito: `Option` anidado.
**Reglas**: lo que falta continúa sin pedir confirmación; solo escribimos «terminado» tras verificar en sistemas reales; sin secretos (contraseñas); sin nuevas APIs REST; Node.js solo para pruebas que el propietario permita.

### Português
**Situação (verificada em sistemas reais)**: os quatro projetos irmãos (open-cosmo, RPoem, Reaxt, RPoRea) são sempre desenvolvidos juntos. O gateway divide uma pergunta entre vários servidores e junta as respostas; aceita `@key`, `@requires`, `@provides`, `@skip`, `@include`, fragmentos nomeados e reler após uma escrita. Passam 59 testes do gateway, 22 do Reaxt e uma execução de ponta a ponta com 21 verificações em servidores reais. A junção com implementações que não são Reaxt (Apollo e o async-graphql do Rust) foi confirmada. O Reaxt v0.1.3 foi publicado (`f32`, `Box<T>`, tuplas de até 6 elementos).
**Planejado (pendente)**: ① verificar em Mac e iPhone reais (não temos dispositivos); ② execuções agendadas na nuvem (o GitHub está conectado, mas é preciso criá-las numa nova sessão ou na web; para fazer push também é preciso instalar o Claude GitHub App); ③ confirmar que o agendamento (cron) do `docs-latest` realmente dispara. Excluído de propósito: `Option` aninhado.
**Regras**: o que falta continua sem pedir confirmação; só escrevemos «concluído» após verificar em sistemas reais; sem segredos (senhas); sem novas APIs REST; Node.js apenas em testes permitidos pelo proprietário.

### Русский
**Состояние (проверено на реальных системах)**: четыре родственных проекта (open-cosmo, RPoem, Reaxt, RPoRea) мы всегда развиваем вместе. Шлюз делит один вопрос между несколькими серверами и собирает ответы; поддерживаются `@key`, `@requires`, `@provides`, `@skip`, `@include`, именованные фрагменты и повторное чтение после записи. Проходят 59 тестов шлюза, 22 теста Reaxt и сквозной прогон из 21 проверки на настоящих серверах. Подтверждено объединение с реализациями, не являющимися Reaxt (Apollo и async-graphql на Rust). Выпущен Reaxt v0.1.3 (`f32`, `Box<T>`, кортежи до 6 элементов).
**Планируется (не завершено)**: ① проверка на настоящих Mac и iPhone (устройств нет); ② запуск по расписанию в облаке (GitHub подключён, но задачу нужно создать в новой сессии или в вебе; для push также нужно установить Claude GitHub App); ③ подтверждение того, что расписание (cron) `docs-latest` действительно срабатывает. Намеренно исключено: вложенный `Option`.
**Правила**: незавершённое продолжаем без вопросов; «готово» пишем только после проверки на реальных системах; секреты (пароли) не пишем; новых REST-API не создаём; Node.js — только для тестов, разрешённых владельцем.


## 2026-11-20 الوضع الحالي والخطة (العربية) / Status in Arabic (ترجمة بالذكاء الاصطناعي، لم يراجعها ناطق أصلي بعد)

**الوضع الحالي (تم التحقق منه على أنظمة حقيقية):** نطوّر المشاريع الأربعة الشقيقة (open-cosmo وRPoem وReaxt وRPoRea) دائماً معاً. تقسّم البوابة سؤالاً واحداً على عدة خوادم ثم تدمج الإجابات، وتدعم `@key` و`@requires` و`@provides` و`@skip` و`@include` والأجزاء المسمّاة (fragments) وإعادة القراءة بعد الكتابة. نجح 59 اختباراً للبوابة و22 اختباراً لـ Reaxt، وكذلك اختبار شامل من 21 فحصاً على خوادم حقيقية. وتأكد الدمج مع تطبيقات غير Reaxt (Apollo وasync-graphql في Rust). صدر Reaxt v0.1.3 (يدعم `f32` و`Box<T>` والصفوف المرتبة (tuples) حتى 6 عناصر).

**المخطط له (لم يكتمل بعد):** (1) التحقق على أجهزة Mac وiPhone الحقيقية (لا نملك الأجهزة)؛ (2) التشغيل الدوري في السحابة: أُنشئ الروتين `4sisters-light-work-every-2h` (كل ساعتين)، ويبقى تثبيت Claude GitHub App للسماح بالدفع (push)؛ (3) التأكد من أن الجدولة (cron) الخاصة بـ `docs-latest` تعمل فعلاً (لم تظهر بعد عملية بحدث `schedule`). مستبعد عمداً: `Option` المتداخل.

**القواعد:** نواصل العمل غير المنجز دون طلب تأكيد؛ لا نكتب «تم» إلا بعد التحقق على أنظمة حقيقية؛ لا نكتب معلومات سرّية (مثل كلمات المرور)؛ لا نضيف واجهات REST جديدة؛ ولا نستخدم Node.js إلا في الاختبارات التي سمح بها المالك.


## ۲۰۲۶-۱۱-۲۰ وضعیت و برنامه (فارسی) / Status in Persian (ترجمهٔ هوش مصنوعی؛ هنوز توسط فارسی‌زبان بومی بررسی نشده است)

**وضعیت کنونی (روی سامانه‌های واقعی بررسی شده):** چهار پروژهٔ خواهر (open-cosmo، RPoem، Reaxt و RPoRea) را همیشه با هم توسعه می‌دهیم. دروازه یک پرسش را میان چند سرور پخش می‌کند و پاسخ‌ها را در یک پاسخ واحد ترکیب می‌کند؛ از `@key`، `@requires`، `@provides`، `@skip`، `@include`، فرگمنت‌های نام‌دار و خواندن دوبارهٔ مقدارها پس از نوشتن پشتیبانی می‌کند. ۵۹ آزمون دروازه، ۲۲ آزمون Reaxt و یک آزمون سرتاسری با ۲۱ بررسی روی سرورهای واقعی موفق بود. ترکیب با پیاده‌سازی‌هایی غیر از Reaxt (Apollo و async-graphql در Rust) نیز تأیید شد. Reaxt نسخهٔ v0.1.3 منتشر شد (با پشتیبانی از `f32`، `Box<T>` و چندتایی‌ها تا ۶ عنصر).

**برنامه (هنوز انجام نشده):** (۱) بررسی روی دستگاه‌های واقعی Mac و iPhone (دستگاه نداریم)؛ (۲) اجرای زمان‌بندی‌شده در ابر: روتین `4sisters-light-work-every-2h` (هر دو ساعت) ساخته شد و برای push باید Claude GitHub App نصب شود؛ (۳) اطمینان از اینکه زمان‌بندی (cron) برای `docs-latest` واقعاً اجرا می‌شود (هنوز اجرایی با رویداد `schedule` دیده نشده است). عمداً کنار گذاشته شد: `Option` تودرتو.

**قواعد:** کارهای نیمه‌تمام را بدون پرسیدن ادامه می‌دهیم؛ فقط پس از بررسی روی سامانهٔ واقعی می‌نویسیم «انجام شد»؛ اطلاعات محرمانه (مثل گذرواژه‌ها) را نمی‌نویسیم؛ REST تازه اضافه نمی‌کنیم؛ و Node.js فقط برای آزمون‌هایی که مالک اجازه داده به کار می‌رود.


## 2026-11-21 追記: 定期実行の確認 / Scheduled runs checked
**日本語**: クラウドの定期実行2本は動いています。(1)4姉妹ルーチン(`4sisters-light-work-every-2h`、日本時間の奇数時17分)は11/21 01:17・03:17・05:17・07:17に自動で動き、例えば Reaxt に `Wire` の型違い拒否の試験を足しました(`eb90b7c`、25件成功)。(2)pl2pl の翻訳ルーチン(毎朝04:00)は ar・fa を新しく作り、8言語の古い行を直しました(`67fa522`)。残っていた、コマンド内の `<file>` が独・西・仏・葡で訳されていた点も直しました(`618fa9d`)。`docs-latest` の定期実行(cron)も、pl2pl・RPoem・Reaxt・RUNO で `schedule` による成功を確認しました。PORTING の「49件」と「55件」は、時期の違う試験の件数(当時49件、いまは55項目)で、誤りではありません。**残り**: Mac・iPhone の実機確認(実機がありません)。
**English**: Both cloud routines are running. (1) The four-sisters routine (`4sisters-light-work-every-2h`, odd JST hours at :17) ran by itself at 01:17, 03:17, 05:17 and 07:17 JST on 11/21; for example it added a wrong-type rejection test for `Wire` in Reaxt (`eb90b7c`, 25 tests pass). (2) The pl2pl translation routine (every day at 04:00) created ar and fa and fixed old lines in 8 languages (`67fa522`). The leftover issue, where `<file>` inside a command was translated in German, Spanish, French and Portuguese, is fixed (`618fa9d`). The `docs-latest` schedule (cron) also succeeded as a `schedule` event in pl2pl, RPoem, Reaxt and RUNO. The "49" and "55" in PORTING are counts from different times (49 then, 55 checks now), not a mistake. **Open**: real-device checks on Mac and iPhone (no devices).


## 2026-11-21 定期実行の確認結果 / Scheduled-run verification (12 languages; AI翻訳・ネイティブ確認前 / AI-translated, not native-checked)

### 日本語
`docs-latest` の定期実行(`schedule`)が UTC 21:00(日本時間 06:00)に成功しました。クラウドのルーチン(2時間ごと)も5回動き、push も通りました(Claude GitHub App が必要という見立ては外れ)。ただし、設定の時刻(日本時間 10:07・12:07・22:07)とは違う時刻に動いたので、次の実行(UTC 01:07)で再確認します。未了は Mac・iPhone の実機確認(実機なし)だけです。

### English
The scheduled run of `docs-latest` (`schedule` event) succeeded at 21:00 UTC (06:00 Japan time). The cloud routine (every two hours) also ran five times and its pushes went through, so the assumption that the Claude GitHub App was required was wrong. However, it fired at a different time from the configured slots (10:07, 12:07 and 22:07 Japan time), so we will check again at the next run (01:07 UTC). The only open item is the real-device check on Mac and iPhone (no devices).

### 简体中文
`docs-latest` 的定时运行(`schedule` 事件)在 UTC 21:00(日本时间 06:00)成功。云端例程(每两小时)也运行了五次,推送均已成功,因此"需要 Claude GitHub App"的判断是错误的。不过它触发的时间与设定的时间(日本时间 10:07、12:07、22:07)不同,所以将在下一次运行(UTC 01:07)再次确认。唯一未完成的是 Mac 与 iPhone 的真机确认(没有设备)。

### 繁體中文
`docs-latest` 的排程執行(`schedule` 事件)在 UTC 21:00(日本時間 06:00)成功。雲端例行程序(每兩小時)也執行了五次,推送皆已成功,因此「需要 Claude GitHub App」的判斷是錯的。不過它觸發的時間與設定的時間(日本時間 10:07、12:07、22:07)不同,所以會在下一次執行(UTC 01:07)再次確認。唯一未完成的是 Mac 與 iPhone 的實機確認(沒有裝置)。

### 한국어
`docs-latest`의 정기 실행(`schedule` 이벤트)이 UTC 21:00(일본 시간 06:00)에 성공했습니다. 클라우드 루틴(2시간마다)도 다섯 번 실행되었고 push도 통과해서, "Claude GitHub App이 필요하다"는 판단은 틀렸습니다. 다만 설정한 시각(일본 시간 10:07, 12:07, 22:07)과 다른 시각에 동작했으므로, 다음 실행(UTC 01:07)에서 다시 확인합니다. 남은 일은 Mac과 iPhone 실기기 확인(기기 없음)뿐입니다.

### Deutsch
Der geplante Lauf von `docs-latest` (Ereignis `schedule`) war um 21:00 UTC (06:00 japanischer Zeit) erfolgreich. Auch die Cloud-Routine (alle zwei Stunden) lief fünfmal, und ihre Pushes gingen durch; die Annahme, die Claude GitHub App sei nötig, war also falsch. Allerdings lief sie zu einer anderen Zeit als konfiguriert (10:07, 12:07 und 22:07 japanischer Zeit), deshalb prüfen wir beim nächsten Lauf (01:07 UTC) erneut. Offen bleibt nur die Prüfung auf echten Mac- und iPhone-Geräten (keine Geräte vorhanden).

### Français
L'exécution planifiée de `docs-latest` (événement `schedule`) a réussi à 21:00 UTC (06:00 heure du Japon). La routine cloud (toutes les deux heures) s'est aussi exécutée cinq fois et ses push sont passés ; l'hypothèse selon laquelle la Claude GitHub App était nécessaire était donc fausse. Toutefois, elle s'est déclenchée à une heure différente de celles configurées (10:07, 12:07 et 22:07 heure du Japon) ; nous vérifierons donc à la prochaine exécution (01:07 UTC). Il ne reste que la vérification sur de vrais Mac et iPhone (nous n'avons pas d'appareils).

### Español
La ejecución programada de `docs-latest` (evento `schedule`) tuvo éxito a las 21:00 UTC (06:00 hora de Japón). La rutina en la nube (cada dos horas) también se ejecutó cinco veces y sus push funcionaron, así que la suposición de que hacía falta la Claude GitHub App era errónea. Sin embargo, se disparó a una hora distinta de las configuradas (10:07, 12:07 y 22:07 hora de Japón), por lo que volveremos a comprobarlo en la próxima ejecución (01:07 UTC). Lo único pendiente es la comprobación en Mac y iPhone reales (no tenemos dispositivos).

### Português
A execução agendada do `docs-latest` (evento `schedule`) teve sucesso às 21:00 UTC (06:00 no horário do Japão). A rotina na nuvem (a cada duas horas) também rodou cinco vezes e seus push funcionaram, então a suposição de que o Claude GitHub App era necessário estava errada. Porém, ela disparou num horário diferente dos configurados (10:07, 12:07 e 22:07 no horário do Japão), por isso voltaremos a verificar na próxima execução (01:07 UTC). O único item pendente é a verificação em Mac e iPhone reais (não temos dispositivos).

### Русский
Запуск `docs-latest` по расписанию (событие `schedule`) успешно прошёл в 21:00 UTC (06:00 по японскому времени). Облачная рутина (каждые два часа) тоже выполнилась пять раз, и её push прошли, так что предположение о необходимости Claude GitHub App оказалось неверным. Однако она сработала не в настроенное время (10:07, 12:07 и 22:07 по японскому времени), поэтому мы проверим снова при следующем запуске (01:07 UTC). Не завершена только проверка на настоящих Mac и iPhone (устройств нет).

### العربية
نجح التشغيل المجدول لـ `docs-latest` (حدث `schedule`) في الساعة 21:00 بالتوقيت العالمي (06:00 بتوقيت اليابان). كما عمل الروتين السحابي (كل ساعتين) خمس مرات ونجحت عمليات الدفع (push)، فكان افتراض الحاجة إلى Claude GitHub App خاطئاً. غير أنه عمل في وقت مختلف عن الأوقات المضبوطة (10:07 و12:07 و22:07 بتوقيت اليابان)، لذا سنعيد التحقق في التشغيل التالي (01:07 بالتوقيت العالمي). والبند الوحيد المتبقي هو التحقق على أجهزة Mac وiPhone الحقيقية (لا نملك الأجهزة).

### فارسی
اجرای زمان‌بندی‌شدهٔ `docs-latest` (رویداد `schedule`) ساعت ۲۱:۰۰ به وقت UTC (۰۶:۰۰ به وقت ژاپن) موفق بود. روتین ابری (هر دو ساعت) هم پنج بار اجرا شد و push‌ها انجام شد؛ پس فرض لازم‌بودن Claude GitHub App نادرست بود. با این حال در زمانی متفاوت از زمان‌های تنظیم‌شده (۱۰:۰۷، ۱۲:۰۷ و ۲۲:۰۷ به وقت ژاپن) اجرا شد، بنابراین در اجرای بعدی (۰۱:۰۷ UTC) دوباره بررسی می‌کنیم. تنها کار باقی‌مانده بررسی روی دستگاه‌های واقعی Mac و iPhone است (دستگاه نداریم).


## 2026-11-21 現状と完成予定(12言語) / Status and what is left (12 languages)

### 日本語(原文)
**現状**: open-cosmo・RPoem・Reaxt・RPoRea の4つは、いつも一緒に作っています。ゲートウェイ(open-cosmo)は、1つの質問を複数のサーバーに分けて聞き、答えを1つにまとめます。`@key`・`@requires`・`@provides`・`@skip`・`@include`・名前付きフラグメント・書き込みのあとの取り直しに対応し、Apollo と async-graphql のサブグラフとも一緒に動くことを確かめました。Reaxt のアクションでは、`Option`・`Vec`・`HashMap`・小数・整数・`Box<T>`、そして **2〜12個組のタプル** が使えます(今回6個から12個へ広げ、試験26件がすべて成功)。RPoRea は Python と Mojo から、また Android の実機で呼べます。Mac は CI で Python からの呼び出しまで、iPhone は CI でビルドまで確かめています。クラウドの定期実行が、2時間ごとに小さな仕事を1つずつ進めています。
**残り**: Mac と iPhone の実機での確認だけです(ここには実機がありません)。入れ子の `Option` は、`null` では段の区別がつかないため、あえて対象外にしています。
**決まり**: 確認を取らずに進める/本物で確かめてから「完了」と書く/秘密は書かない/新しい REST は作らない。
*翻訳について: 日本語が原文です。ほかの言語は AI が翻訳し、ネイティブに近い自然さかを AI が確認しました。人間のネイティブによる確認はまだです。*

### English
**Where things stand**: We always build the four projects (open-cosmo, RPoem, Reaxt and RPoRea) together. The gateway (open-cosmo) splits one query across several servers and merges the answers into one. It supports `@key`, `@requires`, `@provides`, `@skip`, `@include`, named fragments and re-reading after a write, and we have confirmed that it works alongside Apollo and async-graphql subgraphs. Reaxt actions can use `Option`, `Vec`, `HashMap`, decimals, integers, `Box<T>` and **tuples of 2 to 12 elements** (raised from 6 to 12 this time; all 26 tests pass). RPoRea can be called from Python and Mojo, and on a real Android phone. For Mac, CI checks calls from Python; for iPhone, CI checks the build. A scheduled cloud run moves one small task forward every two hours.
**What is left**: only checks on a real Mac and a real iPhone (we have no such devices here). Nested `Option` is left out on purpose, because `null` cannot tell the levels apart.
**Rules**: keep going without asking; write "done" only after checking on real systems; never write secrets; add no new REST APIs.
*About the translations: Japanese is the original. The other languages were translated by AI, and AI checked that they read naturally, close to a native speaker's writing. No human native speaker has checked them yet.*

### 简体中文
**现状**：open-cosmo、RPoem、Reaxt、RPoRea 这四个项目始终一起开发。网关（open-cosmo）会把一个查询拆分给多台服务器，再把结果合并成一个。它支持 `@key`、`@requires`、`@provides`、`@skip`、`@include`、具名片段以及写入后重新读取，并已确认能与 Apollo 和 async-graphql 的子图协同工作。Reaxt 的动作可以使用 `Option`、`Vec`、`HashMap`、小数、整数、`Box<T>`，以及 **2 到 12 个元素的元组**（这次从 6 个扩展到 12 个，26 项测试全部通过）。RPoRea 可以从 Python 和 Mojo 调用，也能在真实的 Android 手机上调用。Mac 由 CI 验证了从 Python 的调用，iPhone 由 CI 验证了构建。云端定时任务每两小时推进一项小工作。
**剩余工作**：只剩在真实的 Mac 和 iPhone 上验证（这里没有这些设备）。嵌套的 `Option` 被有意排除在外，因为 `null` 无法区分层级。
**规则**：无需确认，自动继续；只有在真实系统上验证后才写“完成”；绝不写入机密；不新增 REST API。
*关于翻译：日文为原文。其他语言由 AI 翻译，并由 AI 检查读起来是否接近母语者的自然程度；尚未经过人工母语者审校。*

### 繁體中文
**現況**：open-cosmo、RPoem、Reaxt、RPoRea 這四個專案一律一起開發。閘道（open-cosmo）會把一個查詢拆給多台伺服器，再把結果合併成一個。它支援 `@key`、`@requires`、`@provides`、`@skip`、`@include`、具名片段以及寫入後重新讀取，也已確認能與 Apollo 和 async-graphql 的子圖搭配運作。Reaxt 的動作可以使用 `Option`、`Vec`、`HashMap`、小數、整數、`Box<T>`，以及 **2 到 12 個元素的元組**（這次從 6 個擴充到 12 個，26 項測試全部通過）。RPoRea 可以從 Python 和 Mojo 呼叫，也能在實體 Android 手機上呼叫。Mac 由 CI 驗證了從 Python 的呼叫，iPhone 由 CI 驗證了建置。雲端排程每兩小時推進一項小工作。
**尚待完成**：只剩在實體 Mac 和 iPhone 上確認（這裡沒有這些裝置）。巢狀 `Option` 刻意不支援，因為 `null` 無法區分層級。
**規則**：不需確認，自動繼續；只有在真實系統上確認後才寫「完成」；絕不寫入機密；不新增 REST API。
*關於翻譯：日文為原文。其他語言由 AI 翻譯，並由 AI 檢查讀起來是否接近母語人士的自然程度；尚未經過真人母語人士審閱。*

### 한국어
**현재 상황**: open-cosmo, RPoem, Reaxt, RPoRea 네 프로젝트는 항상 함께 개발합니다. 게이트웨이(open-cosmo)는 하나의 쿼리를 여러 서버로 나누어 보내고, 받은 답을 하나로 합칩니다. `@key`, `@requires`, `@provides`, `@skip`, `@include`, 이름 있는 프래그먼트, 쓰기 후 다시 읽기를 지원하며, Apollo와 async-graphql 서브그래프와도 함께 동작하는 것을 확인했습니다. Reaxt 액션에서는 `Option`, `Vec`, `HashMap`, 소수, 정수, `Box<T>`, 그리고 **2~12개 요소의 튜플**을 쓸 수 있습니다(이번에 6개에서 12개로 늘렸고, 테스트 26건이 모두 통과했습니다). RPoRea는 Python과 Mojo에서 호출할 수 있고, 실제 Android 휴대폰에서도 호출할 수 있습니다. Mac은 CI에서 Python 호출까지, iPhone은 CI에서 빌드까지 확인했습니다. 클라우드 정기 실행이 2시간마다 작은 작업을 하나씩 진행합니다.
**남은 일**: 실제 Mac과 iPhone에서 확인하는 일만 남았습니다(여기에는 해당 기기가 없습니다). 중첩된 `Option`은 `null`로는 단계를 구분할 수 없어서 일부러 지원하지 않습니다.
**규칙**: 확인을 묻지 않고 계속 진행합니다. 실제 환경에서 확인한 뒤에만 "완료"라고 씁니다. 비밀 정보는 절대 쓰지 않습니다. 새 REST API는 만들지 않습니다.
*번역 안내: 일본어가 원문입니다. 다른 언어는 AI가 번역하고, 원어민이 쓴 것처럼 자연스러운지 AI가 확인했습니다. 사람 원어민의 검토는 아직 받지 않았습니다.*

### Deutsch
**Aktueller Stand**: Die vier Projekte open-cosmo, RPoem, Reaxt und RPoRea entwickeln wir immer gemeinsam. Das Gateway (open-cosmo) verteilt eine Abfrage auf mehrere Server und führt die Antworten zu einer einzigen zusammen. Es unterstützt `@key`, `@requires`, `@provides`, `@skip`, `@include`, benannte Fragmente und das erneute Lesen nach einem Schreibvorgang; auch das Zusammenspiel mit Subgraphen von Apollo und async-graphql ist bestätigt. Reaxt-Aktionen können `Option`, `Vec`, `HashMap`, Dezimalzahlen, Ganzzahlen, `Box<T>` und **Tupel mit 2 bis 12 Elementen** verwenden (diesmal von 6 auf 12 erweitert; alle 26 Tests bestehen). RPoRea lässt sich aus Python und Mojo sowie auf einem echten Android-Smartphone aufrufen. Für den Mac prüft die CI Aufrufe aus Python, für das iPhone den Build. Ein geplanter Cloud-Lauf bringt alle zwei Stunden eine kleine Aufgabe voran.
**Was noch fehlt**: nur die Prüfung auf einem echten Mac und einem echten iPhone (solche Geräte haben wir hier nicht). Verschachteltes `Option` ist bewusst ausgenommen, weil sich die Ebenen an `null` nicht unterscheiden lassen.
**Regeln**: ohne Rückfrage weitermachen; „fertig“ erst nach der Prüfung auf echten Systemen schreiben; niemals Geheimnisse aufschreiben; keine neuen REST-APIs.
*Zur Übersetzung: Das Japanische ist das Original. Die anderen Sprachen hat eine KI übersetzt und anschließend geprüft, ob sie so natürlich klingen, wie ein Muttersprachler schreiben würde. Eine Prüfung durch menschliche Muttersprachler steht noch aus.*

### Français
**Où en est-on** : nous développons toujours ensemble les quatre projets open-cosmo, RPoem, Reaxt et RPoRea. La passerelle (open-cosmo) répartit une requête entre plusieurs serveurs et fusionne les réponses en une seule. Elle prend en charge `@key`, `@requires`, `@provides`, `@skip`, `@include`, les fragments nommés et la relecture après une écriture ; nous avons aussi vérifié qu'elle fonctionne avec des sous-graphes Apollo et async-graphql. Les actions Reaxt peuvent utiliser `Option`, `Vec`, `HashMap`, les nombres décimaux, les entiers, `Box<T>` et **les tuples de 2 à 12 éléments** (étendus cette fois de 6 à 12 ; les 26 tests passent). RPoRea peut être appelé depuis Python et Mojo, ainsi que sur un vrai téléphone Android. Sur Mac, la CI vérifie les appels depuis Python ; pour l'iPhone, elle vérifie la compilation. Une exécution planifiée dans le cloud fait avancer une petite tâche toutes les deux heures.
**Ce qui reste** : uniquement les vérifications sur un vrai Mac et un vrai iPhone (nous n'avons pas ces appareils ici). Les `Option` imbriqués sont volontairement exclus, car `null` ne permet pas de distinguer les niveaux.
**Règles** : continuer sans demander de confirmation ; n'écrire « terminé » qu'après vérification sur de vrais systèmes ; ne jamais écrire de secrets ; ne pas ajouter de nouvelle API REST.
*À propos de la traduction : le japonais est l'original. Les autres langues ont été traduites par une IA, qui a ensuite vérifié qu'elles se lisent aussi naturellement qu'un texte écrit par un locuteur natif. Aucun locuteur natif humain ne les a encore relues.*

### Español
**Situación actual**: los cuatro proyectos open-cosmo, RPoem, Reaxt y RPoRea se desarrollan siempre juntos. La pasarela (open-cosmo) reparte una consulta entre varios servidores y une las respuestas en una sola. Admite `@key`, `@requires`, `@provides`, `@skip`, `@include`, fragmentos con nombre y la relectura tras una escritura, y comprobamos que también funciona junto a subgrafos de Apollo y async-graphql. Las acciones de Reaxt pueden usar `Option`, `Vec`, `HashMap`, números decimales, enteros, `Box<T>` y **tuplas de 2 a 12 elementos** (esta vez ampliadas de 6 a 12; pasan las 26 pruebas). RPoRea se puede llamar desde Python y Mojo, y también en un teléfono Android real. En Mac, la CI comprueba las llamadas desde Python; en iPhone, comprueba la compilación. Una ejecución programada en la nube hace avanzar una tarea pequeña cada dos horas.
**Lo que falta**: solo las comprobaciones en un Mac y un iPhone reales (aquí no tenemos esos dispositivos). Los `Option` anidados quedan fuera a propósito, porque con `null` no se pueden distinguir los niveles.
**Reglas**: seguir sin pedir confirmación; escribir «terminado» solo después de comprobarlo en sistemas reales; no escribir nunca secretos; no añadir nuevas API REST.
*Sobre la traducción: el japonés es el original. Los demás idiomas los tradujo una IA, que después comprobó que suenen tan naturales como si los hubiera escrito un hablante nativo. Todavía no los ha revisado ningún hablante nativo humano.*

### Português
**Situação atual**: os quatro projetos open-cosmo, RPoem, Reaxt e RPoRea são sempre desenvolvidos juntos. O gateway (open-cosmo) divide uma consulta entre vários servidores e junta as respostas em uma só. Ele suporta `@key`, `@requires`, `@provides`, `@skip`, `@include`, fragmentos nomeados e a releitura após uma escrita, e confirmamos que também funciona junto com subgrafos do Apollo e do async-graphql. As ações do Reaxt podem usar `Option`, `Vec`, `HashMap`, números decimais, inteiros, `Box<T>` e **tuplas de 2 a 12 elementos** (desta vez ampliadas de 6 para 12; os 26 testes passam). O RPoRea pode ser chamado a partir de Python e Mojo, e também em um celular Android de verdade. No Mac, a CI verifica as chamadas a partir de Python; no iPhone, verifica a compilação. Uma execução agendada na nuvem faz avançar uma pequena tarefa a cada duas horas.
**O que falta**: apenas as verificações em um Mac e um iPhone de verdade (não temos esses aparelhos aqui). `Option` aninhado fica de fora de propósito, porque com `null` não dá para distinguir os níveis.
**Regras**: seguir sem pedir confirmação; escrever “concluído” só depois de verificar em sistemas reais; nunca escrever segredos; não criar novas APIs REST.
*Sobre a tradução: o japonês é o original. Os outros idiomas foram traduzidos por uma IA, que depois verificou se soam tão naturais quanto um texto escrito por um falante nativo. Nenhum falante nativo humano os revisou ainda.*

### Русский
**Текущее состояние**: четыре проекта — open-cosmo, RPoem, Reaxt и RPoRea — мы всегда развиваем вместе. Шлюз (open-cosmo) распределяет один запрос между несколькими серверами и объединяет ответы в один. Он поддерживает `@key`, `@requires`, `@provides`, `@skip`, `@include`, именованные фрагменты и повторное чтение после записи; совместная работа с подграфами Apollo и async-graphql тоже подтверждена. В действиях Reaxt можно использовать `Option`, `Vec`, `HashMap`, дробные и целые числа, `Box<T>`, а также **кортежи из 2–12 элементов** (на этот раз предел поднят с 6 до 12; все 26 тестов проходят). RPoRea можно вызывать из Python и Mojo, а также на настоящем Android-смартфоне. Для Mac CI проверяет вызовы из Python, для iPhone — сборку. Облачный запуск по расписанию каждые два часа выполняет одну небольшую задачу.
**Что осталось**: только проверка на настоящих Mac и iPhone (таких устройств у нас здесь нет). Вложенный `Option` намеренно не поддерживается: по `null` нельзя различить уровни вложенности.
**Правила**: продолжаем без вопросов; пишем «готово» только после проверки на реальных системах; никогда не записываем секреты; не добавляем новых REST API.
*О переводе: оригинал написан на японском. Остальные языки перевёл ИИ, а затем проверил, звучат ли они так же естественно, как текст носителя языка. Живые носители языка их пока не проверяли.*

### العربية
**الوضع الحالي:** نطوّر المشاريع الأربعة open-cosmo وRPoem وReaxt وRPoRea معًا دائمًا. تقسّم البوابة (open-cosmo) الاستعلام الواحد على عدة خوادم، ثم تدمج الإجابات في إجابة واحدة. وهي تدعم `@key` و`@requires` و`@provides` و`@skip` و`@include` والأجزاء المسمّاة (fragments) وإعادة القراءة بعد الكتابة، وتأكّدنا كذلك من أنها تعمل جنبًا إلى جنب مع الرسوم البيانية الفرعية (subgraphs) المبنية بـ Apollo وasync-graphql. ويمكن لإجراءات Reaxt استخدام `Option` و`Vec` و`HashMap` والأعداد العشرية والصحيحة و`Box<T>`، إضافةً إلى **الصفوف المرتّبة (tuples) التي تضم من عنصرين إلى 12 عنصرًا** (وسّعنا الحد هذه المرة من 6 إلى 12، ونجحت الاختبارات الـ26 كلها). ويمكن استدعاء RPoRea من Python وMojo، وكذلك على هاتف Android حقيقي. أما على Mac فيتحقق نظام التكامل المستمر (CI) من الاستدعاء من Python، وعلى iPhone يتحقق من البناء. ويُنجز تشغيلٌ سحابي مجدول مهمةً صغيرة واحدة كل ساعتين.
**ما تبقّى:** التحقق على جهازَي Mac وiPhone حقيقيين فقط (لا تتوفر لدينا هذه الأجهزة هنا). واستبعدنا `Option` المتداخل عمدًا، لأن `null` لا يتيح التمييز بين المستويات.
**القواعد:** نواصل العمل دون طلب تأكيد؛ ولا نكتب «تمّ» إلا بعد التحقق على أنظمة حقيقية؛ ولا نكتب أي معلومات سرّية أبدًا؛ ولا نضيف واجهات REST جديدة.
*عن الترجمة: النص الياباني هو الأصل. ترجم الذكاء الاصطناعي اللغات الأخرى، ثم تحقّق من أنها تُقرأ بسلاسة قريبة مما يكتبه متحدث أصلي. ولم يراجعها بعدُ أي متحدث أصلي من البشر.*

### فارسی
**وضعیت کنونی:** چهار پروژهٔ open-cosmo، RPoem، Reaxt و RPoRea را همیشه با هم توسعه می‌دهیم. دروازه (open-cosmo) یک پرس‌وجو را میان چند سرور پخش می‌کند و پاسخ‌ها را در یک پاسخ واحد ترکیب می‌کند. این دروازه از `@key`، `@requires`، `@provides`، `@skip`، `@include`، فرگمنت‌های نام‌دار و خواندن دوباره پس از نوشتن پشتیبانی می‌کند و تأیید کرده‌ایم که در کنار زیرگراف‌های Apollo و async-graphql هم درست کار می‌کند. اکشن‌های Reaxt می‌توانند از `Option`، `Vec`، `HashMap`، اعداد اعشاری و صحیح، `Box<T>` و **چندتایی‌های (tuple) ۲ تا ۱۲ عضوی** استفاده کنند (این بار سقف را از ۶ به ۱۲ رساندیم و هر ۲۶ آزمون موفق بود). RPoRea را می‌توان از Python و Mojo و همچنین روی یک گوشی واقعی Android فراخوانی کرد. برای Mac، سامانهٔ CI فراخوانی از Python را بررسی می‌کند و برای iPhone، ساخت (build) را. یک اجرای زمان‌بندی‌شدهٔ ابری هر دو ساعت یک کار کوچک را پیش می‌برد.
**آنچه مانده است:** فقط بررسی روی Mac و iPhone واقعی (این دستگاه‌ها را اینجا نداریم). `Option` تودرتو عمداً کنار گذاشته شده است، چون با `null` نمی‌توان سطح‌ها را از هم تشخیص داد.
**قواعد:** بدون پرسیدن ادامه می‌دهیم؛ فقط پس از بررسی روی سامانه‌های واقعی می‌نویسیم «انجام شد»؛ هرگز اطلاعات محرمانه نمی‌نویسیم؛ REST API تازه اضافه نمی‌کنیم.
*دربارهٔ ترجمه: متن ژاپنی متن اصلی است. زبان‌های دیگر را هوش مصنوعی ترجمه کرده و سپس بررسی کرده است که به همان اندازهٔ نوشتهٔ یک گویشور بومی روان و طبیعی باشند. هنوز هیچ گویشور بومیِ انسانی آن‌ها را بازبینی نکرده است.*


## 2026-11-21 依存更新と本番反映の現状 / Dependency updates and production status (12 languages: ja, en, zh-Hans, zh-Hant, ko, de, fr, es, pt, ru, ar, fa; AI翻訳・ネイティブ確認前 / AI-translated, not yet native-checked)

### 日本語
- **済み(本番反映)**: 脆弱性の修正(lettre: RS-Blog・RS-EC・open-redmine・open-gitea、quinn-udp: RS-Guard・aruaru-search・aruaru.tokyo・e-gov)を、VPS の 9 サービスへバックアップ付きで入れ替えました。全サービス稼働中、エラーログ 0、公開 URL は 200 です。
- **済み(GitHub へ反映、試験成功)**: base64 0.23(open-gitea)、reqwest 0.13(runo.tokyo)、ureq 3(open-media、`cargo check` のみ)、thiserror 2 と windows 0.62(open-raid-z)。
- **据え置き**: bincode 3.0.0 は中身が `compile_error!` だけの空の版なので、1.3 のままにしています。
- **未了**: これら 4 件のメジャー更新の本番入れ替え、open-media の通しビルドと実機確認、maid-cafe-programming-school の npm メジャー更新、VPS に残した stash とパッチの整理、`rs-whisper`(C++ の Rust 化)の段階 3 以降。

### English
- **Done (in production)**: the security fixes (lettre in RS-Blog, RS-EC, open-redmine and open-gitea; quinn-udp in RS-Guard, aruaru-search, aruaru.tokyo and e-gov) were swapped into 9 VPS services with backups. Every service is running, the error logs are empty, and the public URLs return 200.
- **Done (on GitHub, tests pass)**: base64 0.23 (open-gitea), reqwest 0.13 (runo.tokyo), ureq 3 (open-media, `cargo check` only), thiserror 2 and windows 0.62 (open-raid-z).
- **Held back**: bincode 3.0.0 is an empty release containing only `compile_error!`, so we stay on 1.3.
- **Open**: deploying these four major updates to production, a full build and real-device check of open-media, the npm major updates in maid-cafe-programming-school, cleaning up the stashes and patches left on the VPS, and stage 3 onward of `rs-whisper` (the C++ to Rust port).

### 简体中文
- **已完成(已上线)**:安全漏洞修复(lettre:RS-Blog、RS-EC、open-redmine、open-gitea;quinn-udp:RS-Guard、aruaru-search、aruaru.tokyo、e-gov)已带备份替换到 VPS 上的 9 个服务。所有服务运行正常,错误日志为 0,公开网址均返回 200。
- **已完成(已推送到 GitHub,测试通过)**:base64 0.23(open-gitea)、reqwest 0.13(runo.tokyo)、ureq 3(open-media,仅做了 `cargo check`)、thiserror 2 与 windows 0.62(open-raid-z)。
- **暂不升级**:bincode 3.0.0 是只含 `compile_error!` 的空版本,因此继续使用 1.3。
- **未完成**:将这四项大版本升级部署到线上、open-media 的完整构建与真机验证、maid-cafe-programming-school 的 npm 大版本升级、清理 VPS 上留下的 stash 和补丁,以及 `rs-whisper`(C++ 改写为 Rust)第 3 阶段之后的工作。

### 繁體中文
- **已完成(已上線)**:安全漏洞修補(lettre:RS-Blog、RS-EC、open-redmine、open-gitea;quinn-udp:RS-Guard、aruaru-search、aruaru.tokyo、e-gov)已附備份替換到 VPS 上的 9 個服務。所有服務運作正常,錯誤日誌為 0,公開網址皆回應 200。
- **已完成(已推送到 GitHub,測試通過)**:base64 0.23(open-gitea)、reqwest 0.13(runo.tokyo)、ureq 3(open-media,僅執行 `cargo check`)、thiserror 2 與 windows 0.62(open-raid-z)。
- **暫不升級**:bincode 3.0.0 是只含 `compile_error!` 的空版本,因此維持 1.3。
- **未完成**:把這四項大版本升級部署到線上、open-media 的完整建置與實機驗證、maid-cafe-programming-school 的 npm 大版本升級、清理 VPS 上留下的 stash 與修補檔,以及 `rs-whisper`(將 C++ 改寫為 Rust)第 3 階段之後的工作。

### 한국어
- **완료(운영 반영)**: 보안 취약점 수정(lettre: RS-Blog·RS-EC·open-redmine·open-gitea, quinn-udp: RS-Guard·aruaru-search·aruaru.tokyo·e-gov)을 백업과 함께 VPS의 9개 서비스에 교체했습니다. 모든 서비스가 정상 동작하고 오류 로그는 0건이며, 공개 URL은 모두 200을 반환합니다.
- **완료(GitHub 반영, 테스트 통과)**: base64 0.23(open-gitea), reqwest 0.13(runo.tokyo), ureq 3(open-media, `cargo check`만 실행), thiserror 2와 windows 0.62(open-raid-z).
- **보류**: bincode 3.0.0은 `compile_error!`만 들어 있는 빈 버전이라 1.3을 그대로 씁니다.
- **미완료**: 이 네 가지 메이저 업데이트의 운영 반영, open-media의 전체 빌드와 실기기 확인, maid-cafe-programming-school의 npm 메이저 업데이트, VPS에 남은 stash와 패치 정리, `rs-whisper`(C++를 Rust로 옮기는 작업)의 3단계 이후.

### Deutsch
- **Erledigt (in Produktion)**: Die Sicherheitskorrekturen (lettre in RS-Blog, RS-EC, open-redmine und open-gitea; quinn-udp in RS-Guard, aruaru-search, aruaru.tokyo und e-gov) wurden mit Sicherungen in 9 VPS-Dienste eingespielt. Alle Dienste laufen, die Fehlerprotokolle sind leer, und die öffentlichen URLs antworten mit 200.
- **Erledigt (auf GitHub, Tests bestanden)**: base64 0.23 (open-gitea), reqwest 0.13 (runo.tokyo), ureq 3 (open-media, nur `cargo check`), thiserror 2 und windows 0.62 (open-raid-z).
- **Zurückgestellt**: bincode 3.0.0 ist eine leere Version, die nur `compile_error!` enthält; wir bleiben deshalb bei 1.3.
- **Offen**: diese vier Hauptversions-Updates in Produktion bringen, ein vollständiger Build und eine Prüfung von open-media auf echter Hardware, die npm-Hauptversions-Updates in maid-cafe-programming-school, das Aufräumen der auf dem VPS verbliebenen Stashes und Patches sowie ab Stufe 3 `rs-whisper` (die Portierung von C++ nach Rust).

### Français
- **Terminé (en production)** : les correctifs de sécurité (lettre dans RS-Blog, RS-EC, open-redmine et open-gitea ; quinn-udp dans RS-Guard, aruaru-search, aruaru.tokyo et e-gov) ont été déployés avec sauvegarde sur 9 services du VPS. Tous les services fonctionnent, les journaux d'erreurs sont vides et les URL publiques répondent 200.
- **Terminé (sur GitHub, tests réussis)** : base64 0.23 (open-gitea), reqwest 0.13 (runo.tokyo), ureq 3 (open-media, `cargo check` seulement), thiserror 2 et windows 0.62 (open-raid-z).
- **Mis de côté** : bincode 3.0.0 est une version vide qui ne contient que `compile_error!` ; nous restons donc sur la 1.3.
- **À faire** : déployer ces quatre mises à jour majeures en production, compiler entièrement open-media et le vérifier sur un vrai appareil, les mises à jour majeures npm de maid-cafe-programming-school, nettoyer les stashes et correctifs laissés sur le VPS, ainsi que `rs-whisper` (le portage de C++ vers Rust) à partir de l'étape 3.

### Español
- **Hecho (en producción)**: las correcciones de seguridad (lettre en RS-Blog, RS-EC, open-redmine y open-gitea; quinn-udp en RS-Guard, aruaru-search, aruaru.tokyo y e-gov) se desplegaron con copia de seguridad en 9 servicios del VPS. Todos los servicios funcionan, los registros de errores están vacíos y las URL públicas responden 200.
- **Hecho (en GitHub, pruebas superadas)**: base64 0.23 (open-gitea), reqwest 0.13 (runo.tokyo), ureq 3 (open-media, solo `cargo check`), thiserror 2 y windows 0.62 (open-raid-z).
- **Aplazado**: bincode 3.0.0 es una versión vacía que solo contiene `compile_error!`, así que seguimos con la 1.3.
- **Pendiente**: llevar estas cuatro actualizaciones mayores a producción, una compilación completa y una comprobación de open-media en un dispositivo real, las actualizaciones mayores de npm en maid-cafe-programming-school, limpiar los stashes y parches que quedaron en el VPS y, desde la etapa 3, `rs-whisper` (el port de C++ a Rust).

### Português
- **Feito (em produção)**: as correções de segurança (lettre em RS-Blog, RS-EC, open-redmine e open-gitea; quinn-udp em RS-Guard, aruaru-search, aruaru.tokyo e e-gov) foram aplicadas com backup em 9 serviços do VPS. Todos os serviços estão em execução, os logs de erro estão vazios e as URLs públicas respondem 200.
- **Feito (no GitHub, testes aprovados)**: base64 0.23 (open-gitea), reqwest 0.13 (runo.tokyo), ureq 3 (open-media, apenas `cargo check`), thiserror 2 e windows 0.62 (open-raid-z).
- **Adiado**: o bincode 3.0.0 é uma versão vazia que contém apenas `compile_error!`; por isso continuamos na 1.3.
- **Pendente**: levar essas quatro atualizações maiores para produção, uma compilação completa e a verificação do open-media em um dispositivo real, as atualizações maiores de npm em maid-cafe-programming-school, limpar os stashes e patches que ficaram no VPS e, a partir da etapa 3, o `rs-whisper` (o port de C++ para Rust).

### Русский
- **Готово (в продакшене)**: исправления уязвимостей (lettre в RS-Blog, RS-EC, open-redmine и open-gitea; quinn-udp в RS-Guard, aruaru-search, aruaru.tokyo и e-gov) выкачены на 9 сервисов VPS с резервными копиями. Все сервисы работают, журналы ошибок пусты, публичные URL отвечают кодом 200.
- **Готово (на GitHub, тесты пройдены)**: base64 0.23 (open-gitea), reqwest 0.13 (runo.tokyo), ureq 3 (open-media, только `cargo check`), thiserror 2 и windows 0.62 (open-raid-z).
- **Отложено**: bincode 3.0.0 — пустая версия, в которой есть только `compile_error!`, поэтому остаёмся на 1.3.
- **Не завершено**: выкатка этих четырёх крупных обновлений в продакшен, полная сборка и проверка open-media на реальном устройстве, крупные обновления npm в maid-cafe-programming-school, уборка оставшихся на VPS stash и патчей, а также `rs-whisper` (перенос C++ на Rust) начиная с этапа 3.

### العربية
- **تم (في الإنتاج)**: جرى تطبيق إصلاحات الثغرات الأمنية (lettre في RS-Blog وRS-EC وopen-redmine وopen-gitea؛ وquinn-udp في RS-Guard وaruaru-search وaruaru.tokyo وe-gov) على 9 خدمات في VPS مع نسخ احتياطية. جميع الخدمات تعمل، وسجلات الأخطاء فارغة، وتُرجع العناوين العامة الرمز 200.
- **تم (على GitHub مع نجاح الاختبارات)**: base64 0.23 (open-gitea)، وreqwest 0.13 (runo.tokyo)، وureq 3 (open-media، مع تشغيل `cargo check` فقط)، وthiserror 2 وwindows 0.62 (open-raid-z).
- **مؤجَّل**: الإصدار bincode 3.0.0 إصدار فارغ لا يحتوي إلا على `compile_error!`، لذلك نبقى على الإصدار 1.3.
- **لم يكتمل بعد**: نشر هذه التحديثات الرئيسية الأربعة في الإنتاج، وبناء open-media بالكامل مع التحقق منه على جهاز حقيقي، وتحديثات npm الرئيسية في maid-cafe-programming-school، وتنظيف ما تبقّى على VPS من stash وملفات التصحيح، ثم `rs-whisper` (نقل C++ إلى Rust) من المرحلة 3 فصاعدًا.

### فارسی
- **انجام‌شده (در محیط عملیاتی)**: اصلاحات امنیتی (lettre در RS-Blog، RS-EC، open-redmine و open-gitea؛ و quinn-udp در RS-Guard، aruaru-search، aruaru.tokyo و e-gov) همراه با پشتیبان‌گیری روی ۹ سرویس VPS جایگزین شد. همهٔ سرویس‌ها در حال اجرا هستند، گزارش‌های خطا خالی است و نشانی‌های عمومی پاسخ ۲۰۰ می‌دهند.
- **انجام‌شده (روی GitHub و با موفقیت آزمون‌ها)**: base64 0.23 (open-gitea)، reqwest 0.13 (runo.tokyo)، ureq 3 (open-media، فقط با `cargo check`)، و thiserror 2 و windows 0.62 (open-raid-z).
- **فعلاً کنار گذاشته شد**: bincode 3.0.0 نسخه‌ای تهی است که فقط `compile_error!` دارد؛ بنابراین نسخهٔ 1.3 را نگه می‌داریم.
- **باقی‌مانده**: استقرار این چهار به‌روزرسانی اصلی در محیط عملیاتی، ساخت کامل و بررسی open-media روی دستگاه واقعی، به‌روزرسانی‌های اصلی npm در maid-cafe-programming-school، پاک‌سازی stash و وصله‌های باقی‌مانده روی VPS، و از مرحلهٔ ۳ به بعد `rs-whisper` (انتقال C++ به Rust).


## 2026-11-21 追記: CI の品質チェックを通るように直した(12言語) / CI quality gate fixed (12 languages)
*日本語が原文です。ほかの言語は AI が翻訳し、ネイティブに近い自然さかを AI が確認しました。人間のネイティブ確認はまだです。 / Japanese is the original. The other languages were translated by AI and checked by AI for native-like fluency; no human native speaker has checked them yet.*

### 日本語(原文)
**やったこと**: RPoem と open-cosmo の CI(GitHub の自動チェック)は、60回以上続けて失敗していました。原因はプログラムの不具合ではなく、書き方の決まり(`rustfmt` の整形と `clippy` の警告)を守れていない箇所でした。整形をそろえ、警告を1つずつ直し、CI が通ることを確かめました。試験は RPoem が589件、open-cosmo が495件で、どちらもすべて成功です。動作は変えていません。CI の Rust(1.100)はこの PC の版(1.98)より新しく、新しい警告が1件出たため、同じ版を手元に入れて確かめました。試験で使うダミーサーバーを先に作る手順も、CI に足しました。open-cosmo の `clippy.toml` は、対応する Rust の版(1.88)と「試験の中では `unwrap` を許す」設定を RPoem にそろえました。
**残り**: Mac と iPhone の実機での確認だけです(ここには実機がありません)。

### English
**What we did**: CI (GitHub's automatic checks) for RPoem and open-cosmo had failed more than 60 times in a row. The cause was not a bug in the program but code that did not follow the style rules (`rustfmt` formatting and `clippy` warnings). We formatted the code, fixed the warnings one by one, and confirmed that CI now passes. All tests pass: 589 in RPoem and 495 in open-cosmo. Behavior is unchanged. CI uses a newer Rust (1.100) than this PC (1.98), and it raised one new warning, so we installed the same version locally to check. We also added a CI step that builds the dummy servers the tests use before the tests run. In open-cosmo, `clippy.toml` now matches RPoem: the supported Rust version (1.88) and the setting that allows `unwrap` inside tests.
**What is left**: only checks on a real Mac and a real iPhone (we have no such devices here).

### 简体中文
**完成的工作**：RPoem 和 open-cosmo 的 CI（GitHub 的自动检查）连续 60 多次运行都失败了。原因不是程序有缺陷，而是代码没有遵守规范（`rustfmt` 格式化和 `clippy` 警告）。我们统一了格式，逐一修正了警告，并确认 CI 现已通过。测试全部通过：RPoem 589 项，open-cosmo 495 项。程序行为没有改变。CI 使用的 Rust（1.100）比这台电脑上的版本（1.98）新，因此多出了一条新警告；我们在本地安装了相同版本进行确认。我们还在 CI 中加了一步：在运行测试前，先构建测试要用的模拟服务器。open-cosmo 的 `clippy.toml` 已与 RPoem 保持一致：支持的 Rust 版本（1.88），以及“允许在测试中使用 `unwrap`”的设置。
**剩余工作**：只剩在真实的 Mac 和 iPhone 上验证（这里没有这些设备）。

### 繁體中文
**完成的工作**：RPoem 和 open-cosmo 的 CI（GitHub 的自動檢查）連續 60 多次執行都失敗。原因不是程式有缺陷，而是程式碼沒有遵守規範（`rustfmt` 格式化和 `clippy` 警告）。我們統一了格式，逐一修正警告，並確認 CI 現在已經通過。測試全部通過：RPoem 589 項，open-cosmo 495 項。程式行為沒有改變。CI 使用的 Rust（1.100）比這台電腦上的版本（1.98）新，因此多出一則新警告；我們在本機安裝了相同版本來確認。我們也在 CI 加了一個步驟：執行測試前，先建置測試要用的模擬伺服器。open-cosmo 的 `clippy.toml` 已與 RPoem 一致：支援的 Rust 版本（1.88），以及「允許在測試中使用 `unwrap`」的設定。
**尚待完成**：只剩在實體 Mac 和 iPhone 上確認（這裡沒有這些裝置）。

### 한국어
**한 일**: RPoem과 open-cosmo의 CI(GitHub 자동 검사)는 60번 넘게 연속으로 실패하고 있었습니다. 원인은 프로그램의 버그가 아니라, 코드 작성 규칙(`rustfmt` 서식과 `clippy` 경고)을 지키지 않은 부분이었습니다. 서식을 맞추고 경고를 하나씩 고친 뒤, 이제 CI가 통과하는 것을 확인했습니다. 테스트는 RPoem 589건, open-cosmo 495건이 모두 통과했습니다. 동작은 바뀌지 않았습니다. CI의 Rust(1.100)가 이 PC의 버전(1.98)보다 새로워서 새 경고가 하나 나왔기 때문에, 같은 버전을 로컬에 설치해 확인했습니다. 또한 테스트에 쓰는 더미 서버를 테스트 전에 먼저 빌드하는 단계를 CI에 추가했습니다. open-cosmo의 `clippy.toml`은 지원하는 Rust 버전(1.88)과 "테스트 안에서는 `unwrap`을 허용"하는 설정을 RPoem과 같게 맞췄습니다.
**남은 일**: 실제 Mac과 iPhone에서 확인하는 일만 남았습니다(여기에는 해당 기기가 없습니다).

### Deutsch
**Was wir getan haben**: Die CI (die automatischen Prüfungen auf GitHub) von RPoem und open-cosmo war mehr als 60-mal in Folge fehlgeschlagen. Ursache war kein Fehler im Programm, sondern Code, der die Stilregeln nicht einhielt (Formatierung mit `rustfmt` und Warnungen von `clippy`). Wir haben den Code formatiert, die Warnungen einzeln behoben und bestätigt, dass die CI jetzt durchläuft. Alle Tests bestehen: 589 in RPoem und 495 in open-cosmo. Das Verhalten ist unverändert. Die CI nutzt eine neuere Rust-Version (1.100) als dieser PC (1.98) und meldete deshalb eine neue Warnung; wir haben dieselbe Version lokal installiert, um sie zu prüfen. Außerdem baut die CI jetzt vor den Tests die dafür nötigen Dummy-Server. In open-cosmo entspricht `clippy.toml` jetzt RPoem: die unterstützte Rust-Version (1.88) und die Einstellung, die `unwrap` in Tests erlaubt.
**Was noch fehlt**: nur die Prüfung auf einem echten Mac und einem echten iPhone (solche Geräte haben wir hier nicht).

### Français
**Ce que nous avons fait** : la CI (les vérifications automatiques de GitHub) de RPoem et d'open-cosmo échouait depuis plus de 60 exécutions consécutives. La cause n'était pas un bogue du programme, mais du code qui ne respectait pas les règles de style (mise en forme `rustfmt` et avertissements `clippy`). Nous avons mis le code en forme, corrigé les avertissements un par un, puis vérifié que la CI passe désormais. Tous les tests passent : 589 dans RPoem et 495 dans open-cosmo. Le comportement n'a pas changé. La CI utilise une version de Rust plus récente (1.100) que ce PC (1.98), ce qui a fait apparaître un nouvel avertissement ; nous avons installé la même version en local pour vérifier. Nous avons aussi ajouté à la CI une étape qui compile, avant les tests, les serveurs factices dont ils ont besoin. Dans open-cosmo, `clippy.toml` est désormais aligné sur RPoem : la version de Rust prise en charge (1.88) et le réglage qui autorise `unwrap` dans les tests.
**Ce qui reste** : uniquement les vérifications sur un vrai Mac et un vrai iPhone (nous n'avons pas ces appareils ici).

### Español
**Qué hicimos**: la CI (las comprobaciones automáticas de GitHub) de RPoem y open-cosmo llevaba más de 60 ejecuciones seguidas fallando. La causa no era un error del programa, sino código que no seguía las reglas de estilo (el formato de `rustfmt` y las advertencias de `clippy`). Dimos formato al código, corregimos las advertencias una por una y comprobamos que la CI ya pasa. Pasan todas las pruebas: 589 en RPoem y 495 en open-cosmo. El comportamiento no ha cambiado. La CI usa una versión de Rust más reciente (1.100) que este PC (1.98) y por eso apareció una advertencia nueva; instalamos la misma versión en local para comprobarlo. También añadimos a la CI un paso que compila, antes de las pruebas, los servidores de prueba que estas necesitan. En open-cosmo, `clippy.toml` ahora coincide con el de RPoem: la versión de Rust admitida (1.88) y el ajuste que permite `unwrap` dentro de las pruebas.
**Lo que falta**: solo las comprobaciones en un Mac y un iPhone reales (aquí no tenemos esos dispositivos).

### Português
**O que fizemos**: a CI (as verificações automáticas do GitHub) do RPoem e do open-cosmo vinha falhando havia mais de 60 execuções seguidas. A causa não era um defeito no programa, e sim código que não seguia as regras de estilo (a formatação do `rustfmt` e os avisos do `clippy`). Formatamos o código, corrigimos os avisos um a um e confirmamos que a CI agora passa. Todos os testes passam: 589 no RPoem e 495 no open-cosmo. O comportamento não mudou. A CI usa uma versão do Rust mais nova (1.100) que a deste PC (1.98), por isso apareceu um aviso novo; instalamos a mesma versão localmente para conferir. Também adicionamos à CI uma etapa que compila, antes dos testes, os servidores de teste de que eles precisam. No open-cosmo, o `clippy.toml` agora segue o do RPoem: a versão do Rust suportada (1.88) e a configuração que permite `unwrap` dentro dos testes.
**O que falta**: apenas as verificações em um Mac e um iPhone de verdade (não temos esses aparelhos aqui).

### Русский
**Что сделано**: CI (автоматические проверки на GitHub) у RPoem и open-cosmo падала более 60 запусков подряд. Причина была не в ошибке программы, а в коде, который не соответствовал правилам оформления (форматирование `rustfmt` и предупреждения `clippy`). Мы отформатировали код, по одному исправили предупреждения и убедились, что теперь CI проходит. Все тесты проходят: 589 в RPoem и 495 в open-cosmo. Поведение программ не изменилось. В CI используется более новая версия Rust (1.100), чем на этом ПК (1.98), поэтому появилось одно новое предупреждение; мы установили ту же версию локально, чтобы проверить. Кроме того, в CI добавлен шаг, который перед тестами собирает нужные им фиктивные серверы. В open-cosmo файл `clippy.toml` теперь совпадает с RPoem: поддерживаемая версия Rust (1.88) и настройка, разрешающая `unwrap` внутри тестов.
**Что осталось**: только проверка на настоящих Mac и iPhone (таких устройств у нас здесь нет).

### العربية
**ما أنجزناه:** ظلّ نظام التكامل المستمر (CI)، أي الفحوص التلقائية على GitHub، في مشروعَي RPoem وopen-cosmo يفشل في أكثر من 60 تشغيلًا متتاليًا. ولم يكن السبب خللًا في البرنامج، بل شيفرةً لا تلتزم بقواعد الأسلوب (تنسيق `rustfmt` وتحذيرات `clippy`). نسّقنا الشيفرة، وأصلحنا التحذيرات واحدًا تلو الآخر، وتأكّدنا من أن فحوص CI تنجح الآن. ونجحت الاختبارات كلها: 589 اختبارًا في RPoem و495 اختبارًا في open-cosmo. ولم يتغيّر سلوك البرنامج. ويستخدم نظام CI إصدارًا أحدث من Rust ‏(1.100) مما على هذا الحاسوب (1.98)، فظهر تحذير جديد واحد؛ لذلك ثبّتنا الإصدار نفسه محليًا للتحقق. وأضفنا كذلك إلى CI خطوة تبني الخوادم التجريبية التي تحتاجها الاختبارات قبل تشغيلها. وأصبح ملف `clippy.toml` في open-cosmo مطابقًا لما في RPoem: إصدار Rust المدعوم (1.88)، والإعداد الذي يسمح باستخدام `unwrap` داخل الاختبارات.
**ما تبقّى:** التحقق على جهازَي Mac وiPhone حقيقيين فقط (لا تتوفر لدينا هذه الأجهزة هنا).

### فارسی
**کاری که انجام دادیم:** CI (بررسی‌های خودکار GitHub) در RPoem و open-cosmo در بیش از ۶۰ اجرای پیاپی شکست خورده بود. علت، خطا در برنامه نبود؛ بخش‌هایی از کد قواعد نگارش (قالب‌بندی `rustfmt` و هشدارهای `clippy`) را رعایت نمی‌کردند. کد را قالب‌بندی کردیم، هشدارها را یکی‌یکی رفع کردیم و مطمئن شدیم که CI اکنون موفق است. همهٔ آزمون‌ها موفق‌اند: ۵۸۹ آزمون در RPoem و ۴۹۵ آزمون در open-cosmo. رفتار برنامه تغییری نکرده است. CI از نسخهٔ جدیدتری از Rust (۱.۱۰۰) نسبت به این رایانه (۱.۹۸) استفاده می‌کند و به همین دلیل یک هشدار تازه نشان داد؛ برای بررسی، همان نسخه را روی رایانهٔ خودمان نصب کردیم. همچنین گامی به CI افزودیم که پیش از اجرای آزمون‌ها، سرورهای آزمایشیِ موردنیاز آن‌ها را می‌سازد. فایل `clippy.toml` در open-cosmo اکنون با RPoem یکسان است: نسخهٔ پشتیبانی‌شدهٔ Rust (۱.۸۸) و تنظیمی که استفاده از `unwrap` را درون آزمون‌ها مجاز می‌کند.
**آنچه مانده است:** فقط بررسی روی Mac و iPhone واقعی (این دستگاه‌ها را اینجا نداریم).

## 2026-11-22 追記: 索引リポジトリの確認(日本語のみ)
- 4姉妹(RPoem・open-cosmo・Reaxt・RPoRea)のCIは最新で成功、`F:\runo` は `origin/main` と同期済みです。
- 別セッションの報告(aruaru-IME v0.2.30、RS-Node.js のESM対応、README索引3行の修正)は、記録として確認しただけで、このリポジトリでの変更はありません。
- `open-tv-chat` の実装は、翻訳モデルのダウンロード許可待ちの状態で、最初の一歩を選ぶところまで進みました(詳細は `open-tv-chat/PORTING.md` 末尾)。
- 残り: Mac・iPhone の実機確認(実機なし)。aruaru-IME v0.2.30 の exe は未インストール試験です。

## 2026-11-22 引っ越し(別アカウントでの再開)用の引き継ぎ / Hand-off for moving to another account

### 日本語
**優先して一緒に開発しているリポジトリ(すべて `aon-co-jp` 配下、`F:\<名前>`)**
- 変換: `pl2pl`(最優先。COBOL・C・C++・Fortran→Web)、`COBOL_to`、`Java_to`(元の2つの削除だけは最後に本人確認)
- 4姉妹: `RPoem`、`open-cosmo`、`Reaxt`、`RPoRea`。姉妹: `RMojo`、`RS-TypeScript`、`RS-JavaScript`、`RS-Node.js`
- AI・計算: `aruaru-llm`、`open-cuda`、`open-cpu`、`open-directx`、`rs-whisper`
- 会話・入力: `open-tv-chat`、`open-LiveKit`、`aruaru-IME`
- 基盤・運用: `open-web-server`、`open-easy-web`、`RS-JSON`、`version-control`、`runo`(この索引)、`2FastAPI`、`MFastAPI`

**この日の到達点**: 4姉妹のCIは成功。`open-tv-chat` の翻訳モデルMADLAD-400 3B(q4k、1.65GB、`F:\_work\models\madlad400-3b-mt-q4k`)をダウンロードし、WSL(`~/mt/candle`のquantized-t5例を改造、環境変数`MT_TOKENIZER`)でCPU実行に成功。ja→enは自然(「It's a very nice day today. Can we go for a walk together?」)、en→jaは前半を落とした。速度は約1.4語/秒、1回約37秒(読み込み込み、メモリ約4.8GB)で、**リアルタイムには遅い**。
**未了(この順)**: (1)`rs-whisper-transcribe`(引数にモデルと音声を渡す。例は `F:\_work\whisper.cpp\samples\jfk.wav`、`ggml-tiny.bin`)で文字起こし→MADLADで翻訳する通し計測、(2)結果を `open-tv-chat` の文書(日本語)へ記録し、古い「ダウンロード許可待ち」の行を直す、(3)Mac・iPhone実機確認(実機なし)、(4)aruaru-IME v0.2.30のexeインストール試験。
**決まり**: 確認せず自動で進める/本物で確認してから「完了」/秘密は書かない/新しいRESTは作らない/VPS用ビルドは`Ubuntu-24.04`/開発・試験は手元PC。

### English
**Priority repositories developed together (all under `aon-co-jp`, at `F:\<name>`)**
- Conversion: `pl2pl` (top priority; COBOL/C/C++/Fortran to web), `COBOL_to`, `Java_to` (only deleting these two originals needs the owner's confirmation, last)
- Four sisters: `RPoem`, `open-cosmo`, `Reaxt`, `RPoRea`; related: `RMojo`, `RS-TypeScript`, `RS-JavaScript`, `RS-Node.js`
- AI/compute: `aruaru-llm`, `open-cuda`, `open-cpu`, `open-directx`, `rs-whisper`
- Chat/input: `open-tv-chat`, `open-LiveKit`, `aruaru-IME`
- Infrastructure: `open-web-server`, `open-easy-web`, `RS-JSON`, `version-control`, `runo` (this index), `2FastAPI`, `MFastAPI`

**Reached today**: CI of the four sisters is green. For `open-tv-chat`, MADLAD-400 3B (q4k, 1.65 GB, `F:\_work\models\madlad400-3b-mt-q4k`) was downloaded and runs on CPU in WSL (candle's quantized-t5 example, patched with env `MT_TOKENIZER`, in `~/mt/candle`). ja-to-en reads naturally; en-to-ja dropped the first sentence. Speed is about 1.4 tokens/s and about 37 s per call including loading (about 4.8 GB RAM): **too slow for real time**.
**Open (in order)**: (1) an end-to-end measurement: `rs-whisper-transcribe` (pass model and audio; sample `F:\_work\whisper.cpp\samples\jfk.wav`, `ggml-tiny.bin`) then MADLAD; (2) record the result in `open-tv-chat` docs (Japanese) and fix the stale "waiting for download permission" line; (3) real Mac/iPhone checks (no devices); (4) install test of the aruaru-IME v0.2.30 exe.
**Rules**: continue without asking; verify on real systems before saying "done"; never write secrets; no new REST; build VPS binaries in `Ubuntu-24.04`; develop and test on the local PC.

### 再開用メッセージ / Resume message (paste as is)
**日本語**: 前の続きです。`F:\runo\PORTING.md` 末尾「2026-11-22 引っ越し(別アカウントでの再開)用の引き継ぎ」を読んでから、そこに載っている優先リポジトリ(pl2pl・COBOL_to・Java_to・RPoem・RPoRea・Reaxt・RMojo・aruaru-llm・open-cosmo・open-tv-chat ほか)の未了を、確認なしで自動で進めてください。まず open-tv-chat の「rs-whisper→MADLAD-400」通し計測から。決まり: 本物で確認してから完了と書く、秘密は書かない、新しいRESTは作らない、元のCOBOL_to/Java_toの削除だけは確認、返答は日本語のみ。
**English**: Continuing from before. Read "2026-11-22 引っ越し(別アカウントでの再開)用の引き継ぎ" at the end of `F:\runo\PORTING.md`, then keep working through the open items of the listed priority repositories (pl2pl, COBOL_to, Java_to, RPoem, RPoRea, Reaxt, RMojo, aruaru-llm, open-cosmo, open-tv-chat and others) without asking. Start with the open-tv-chat rs-whisper-to-MADLAD-400 end-to-end measurement. Rules: verify on real systems before saying done, never write secrets, no new REST, only deleting the original COBOL_to/Java_to needs confirmation.

## 2026-11-22 追記: 翻訳の高速化の知見を関連リポジトリで共有 / Sharing the translation-speed findings (日本語・English)

### 日本語
**共有する相手(同時に開発する)**: `open-tv-chat`(音声翻訳の本体)、`maid-cafe-english`(`maid-cafe.tokyo` の英語学習。翻訳・音声)、`maid-cafe-tokyo`(`https://maid-cafe.tokyo` の運用先)、`aruaru-llm`・`open-cuda`・`open-cpu`・`open-directx`(推論の土台)。なお、`open-maid-cafe` という名前のリポジトリは `aon-co-jp` に**存在しません**(あるのは `maid-cafe-tokyo`・`maid-cafe-english`・`maid-cafe-se`・`maid-cafe-programming-school`)。
**実測(CPU のみ、Ryzen 9 3950X・WSL・GPU は GT 730 2GB で実質使えない)**: 翻訳モデル MADLAD-400 3B(q4k、約1.65GB)を candle の quantized-t5 例で実行。
- 読み込みに約30秒かかるため、**常駐させて1回だけ読み込む**(標準入力から1行ずつ訳す形に改造、環境変数 `MT_TOKIENIZER` でトークナイザーを指定)。
- **短い文ごとに訳す**と、1文あたり約3〜8秒(2.7語/秒)。長い文をまとめるより、前半が落ちにくい。
- `RUSTFLAGS="-C target-cpu=native"` で語速が約2.3→2.7語/秒(約15%向上)。
- 音声認識(`rs-whisper` tiny、11秒の音声で約10.5秒)と合わせても、**そのままではリアルタイムに届かない**。次の候補は、小さい翻訳モデル、`open-cuda-llm` への T5 追加と比較、`open-cuda-whisper` との音声認識の比較、音声合成(Piper/Kokoro)。
**取り込み方針**: maid-cafe-english の翻訳・音声(AI回答や聞き取り)は、常駐+文ごと+native ビルドをまず適用する。新しい REST は作らず Connect/gRPC で呼ぶ。VPS は4コアで遅いので、**測定・開発は手元PC**、VPS は配備と確認だけ。
**未了**: (1)`open-cuda-llm` への T5 実装と candle との比較、(2)`open-cuda-whisper` と `rs-whisper` の比較、(3)GPU(Vulkan/DirectX)の実測(この PC の GT 730 は古く効果は期待薄)、(4)各リポジトリのコードへの実際の反映(今回は文書のみ)。

### English
**Who shares this (developed together)**: `open-tv-chat` (the voice-translation app), `maid-cafe-english` (English learning for `maid-cafe.tokyo`: translation and voice), `maid-cafe-tokyo` (the site running at `https://maid-cafe.tokyo`), and `aruaru-llm`, `open-cuda`, `open-cpu`, `open-directx` (the inference base). Note: there is **no** repository named `open-maid-cafe` in `aon-co-jp` (the existing ones are `maid-cafe-tokyo`, `maid-cafe-english`, `maid-cafe-se` and `maid-cafe-programming-school`).
**Measured (CPU only; Ryzen 9 3950X, WSL; the GT 730 2 GB GPU is effectively unusable)**: the MADLAD-400 3B translation model (q4k, about 1.65 GB) run with candle's quantized-t5 example.
- Loading takes about 30 s, so **keep it resident and load once** (patched to translate one line at a time from stdin; the tokenizer path comes from env `MT_TOKENIZER`).
- **Translating short sentences one by one** takes about 3 to 8 s each (2.7 tokens/s) and drops the first half less often than long input.
- `RUSTFLAGS="-C target-cpu=native"` raised speed from about 2.3 to 2.7 tokens/s (about 15%).
- Even with speech recognition (`rs-whisper` tiny, about 10.5 s for 11 s of audio) it is **still not real time**. Next candidates: a smaller translation model, adding T5 to `open-cuda-llm` and comparing, comparing `open-cuda-whisper` for recognition, and speech synthesis (Piper/Kokoro).
**Adoption policy**: apply resident + sentence-by-sentence + native build first to maid-cafe-english's translation and voice (AI answers and listening). No new REST; call over Connect/gRPC. The VPS has 4 slow cores, so **measure and develop on the local PC**; use the VPS only to deploy and verify.
**Open**: (1) T5 in `open-cuda-llm` and a comparison with candle; (2) `open-cuda-whisper` vs `rs-whisper`; (3) GPU (Vulkan/DirectX) measurements (this PC's GT 730 is old, little gain expected); (4) real code changes in each repository (this round is documentation only).

### 再開用メッセージ(2026-11-22、翻訳高速化・関連リポジトリ共有) / Resume message
**日本語**: 前の続きです。`F:\runo\PORTING.md` 末尾の「翻訳の高速化の知見を関連リポジトリで共有」を読んでから、`open-tv-chat`・`maid-cafe-english`・`maid-cafe-tokyo`(`open-maid-cafe` という名前のリポジトリは存在しません)・`aruaru-llm`・`open-cuda`・`open-cpu`・`open-directx` の未了を、確認なしで自動で進めてください。順番: (1)常駐+文ごと翻訳を maid-cafe-english のコードへ反映、(2)`open-cuda-llm` に T5 を追加して candle と比較、(3)`open-cuda-whisper` と `rs-whisper` の比較、(4)GPU 実測。作業は手元PC(WSL)、VPS は配備と確認のみ。決まり: 本物で確認してから完了、秘密は書かない、新しいRESTは作らない、返答は日本語のみ。
**English**: Continuing from before. Read "Sharing the translation-speed findings" at the end of `F:\runo\PORTING.md`, then keep working through the open items of `open-tv-chat`, `maid-cafe-english`, `maid-cafe-tokyo` (there is no repository named `open-maid-cafe`), `aruaru-llm`, `open-cuda`, `open-cpu` and `open-directx` without asking. Order: (1) apply resident + sentence-by-sentence translation to maid-cafe-english's code; (2) add T5 to `open-cuda-llm` and compare with candle; (3) compare `open-cuda-whisper` with `rs-whisper`; (4) GPU measurements. Work on the local PC (WSL); use the VPS only to deploy and verify. Rules: verify on real systems before saying done, never write secrets, no new REST.


## 2026-11-22 現状・完成予定・課題(日本語・English)

### 日本語
**現状(本番で確認済み)**
- version-control の通知7件に対応しました。`russh-sftp` 4 への更新は rs-sync・open-web-server・open-easy-web・open-raid-z で終わり、前の3つは VPS に入れ替えました(`/` などの応答は入れ替え前と同じ、エラーログ0、旧版は `*.before-sftp4-20261122` などで保管)。
- quinn-udp の脆弱性(rs-link-fusion)と lindera 7(rs-kokoro-ja)も更新して push しました。
- REST 全廃の仕上げとして、`x-tenant` を送る変更と、aruaru-llm の同時実行の受付制御(上限・公平キュー)を VPS に反映しました。
- 4姉妹(RPoem・open-cosmo・Reaxt・RPoRea)の CI は成功しています。

**完成予定**
1. SFTP の実サーバー相手の通し確認(VPS の sshd を相手に dist_sync か rs-sync で行う)。
2. 本番の aruaru-llm が `x-tenant` を受け取る様子を、実際の通信で観測する。
3. open-tv-chat の翻訳高速化(常駐+文ごと+native ビルドの反映、`open-cuda-llm` への T5 追加、`rs-whisper` との比較)。

**課題(正直な未了・見送り)**
- SFTP は、いまのところモックのサーバーでの単体・統合試験までしか確認できていません(WSL に sshd が無い)。
- `x-tenant` は、本番の通信ではまだ観測できていません(tcpdump では aruaru-llm の通信が捕まらなかった)。
- 見送り中の大型更新: rs-link-fusion(aggligator・chacha20系・eframe/egui・ndt7-client 0.3・rand 0.10。API の書き換えと複数NICの実機確認が要る)、open-raid-z の fuser 0.19(macOS・Android 実機が要る)、bincode 3(中身が空の版なので 1.3 のまま)。
- VPS の aruaru-llm クローンは11遅れで手元変更あり(pull しない)。open-gitea の VPS クローンは分岐(44遅れ/26先行)で、触る前に本人確認が要る。
- Mac・iPhone の実機確認(実機なし)。手元の作業用フォルダー(`F:\_wt-aruaru-llm`・`F:\_wt-ime`・`F:\_work_rlf`・`F:\_*.bin`)は、削除が止まったため手動で整理が要る。
- 決まり: 確認せず自動で進める/本物で確認してから「完了」/秘密は書かない/新しい REST は作らない/VPS 用ビルドは `Ubuntu-24.04`。

### English
**Current state (verified in production)**
- The 7 version-control notices were handled. The `russh-sftp` 4 update is done in rs-sync, open-web-server, open-easy-web and open-raid-z; the first three were swapped into the VPS (responses such as `/` match the pre-swap ones, error logs are empty, old binaries kept as `*.before-sftp4-20261122` and similar).
- The quinn-udp vulnerability (rs-link-fusion) and lindera 7 (rs-kokoro-ja) were updated and pushed.
- As part of finishing the REST abolition, the change that sends `x-tenant` and aruaru-llm's admission control (concurrency cap and fair queue) were deployed to the VPS.
- CI of the four sisters (RPoem, open-cosmo, Reaxt, RPoRea) is green.

**Planned**
1. An end-to-end SFTP check against a real server (use the VPS sshd with dist_sync or rs-sync).
2. Observe production aruaru-llm actually receiving `x-tenant` in real traffic.
3. Translation speed-ups for open-tv-chat (resident + sentence-by-sentence + native build, T5 in `open-cuda-llm`, comparison with `rs-whisper`).

**Issues (honest open items and deferrals)**
- SFTP is verified only by unit and integration tests against a mock server so far (WSL has no sshd).
- `x-tenant` has not yet been observed in production traffic (tcpdump did not capture aruaru-llm calls).
- Deferred major updates: rs-link-fusion (aggligator, the chacha20 family, eframe/egui, ndt7-client 0.3, rand 0.10; these need API rewrites and multi-NIC real-device checks), open-raid-z's fuser 0.19 (needs macOS and Android devices), and bincode 3 (an empty release, so we stay on 1.3).
- The VPS aruaru-llm clone is 11 commits behind with local changes (do not pull). The VPS open-gitea clone has diverged (44 behind / 26 ahead); ask the owner before touching it.
- Real-device checks on Mac and iPhone (no devices). Local work folders (`F:\_wt-aruaru-llm`, `F:\_wt-ime`, `F:\_work_rlf`, `F:\_*.bin`) need manual cleanup because deletion was blocked.
- Rules: continue without asking; verify on real systems before saying "done"; never write secrets; no new REST; build VPS binaries in `Ubuntu-24.04`.

## 2026-11-22 現状・完成予定・課題: PowerDVD の高音ノイズと WMP の CD 書き込みでの声の変化(日本語・English)

### 日本語
**現状(調査のみ、設定は未変更・原因は未確定)**
- 症状1: PowerDVD(ブルーレイ)で人の声の高音にノイズが入る。症状2: Windows Media Player で mp4 を音楽 CD へ直接書き込むと、女性の声が男性の声のように低く聞こえる(以前は無かった)。
- 確認できた事実: 既定の出力 `スピーカー (LOXJIE AUDIO)` の既定形式が **384,000 Hz / 32bit**(共有モード)。ドライバーは XMOS 5.50.0(2022-09-08 版)で **2026-10-10 に導入**(同日に Driver Booster 14 も導入)。open-bar は起動しておらず原因ではない。PowerDVD の `audiodg`・本体に第三者の音声処理モジュールは見当たらない。WMP の設定は `CDBurnNormalizeAudio=1`(書き込み時に音量均一化)・`CDBurnSpeed=3` で、声の高さを変える設定ではない。11月に UniConverter 18(11/11)・Leawo Prof. Media 13(11/15)・KB5132061/KB5132688(11/11)が入った。
- 最有力の推定: 384kHz 既定形式への再サンプリング(症状1)。症状2(声が低くなる=サンプルレートの取り違え)は、384kHz 設定の影響か、コーデックや更新の差し替えかを切り分けていない。

**完成予定(次の手順、所有者の操作が要る)**
1. `LOXJIE AUDIO` の既定形式を 24bit / 48000 Hz に下げ、PowerDVD の同じ場面でノイズが消えるか確認する。
2. WMP で短い mp4 を CD-RW かディスクイメージへ書き、声の高さが戻るか確認する。
3. 1 で直れば、ドライバーを以前の版へ戻すか、384kHz を使うのは排他モードの再生(open-bar / open-media)だけにする。2 だけ直らなければ UniConverter / Leawo のコーデックを外して再確認する。

**課題**
- 再現はまだ(所有者の実機での確認待ち)。設定変更は「システム設定の変更」にあたるため、こちらでは行わない。
- 管理者権限が要る確認(WMP の Windows 機能の状態など)は未実施。
- ドライバーを導入したのが Driver Booster かどうかは未確認。

### English
**Status (investigation only; no settings changed; cause not confirmed)**
- Symptom 1: PowerDVD (Blu-ray) adds noise to high-pitched human voices. Symptom 2: burning an mp4 straight to an audio CD with Windows Media Player makes women's voices sound like men's (this did not happen before).
- Facts: the default output `Speakers (LOXJIE AUDIO)` has a default format of **384,000 Hz / 32-bit** (shared mode). Its driver is XMOS 5.50.0 (dated 2022-09-08), **installed on 2026-10-10** (Driver Booster 14 was installed the same day). open-bar is not running, so it is not the cause. No third-party audio-processing module was found in `audiodg` or PowerDVD. WMP has `CDBurnNormalizeAudio=1` (volume normalization on burn) and `CDBurnSpeed=3`, neither of which changes pitch. In November, UniConverter 18 (11/11), Leawo Prof. Media 13 (11/15) and KB5132061/KB5132688 (11/11) were installed.
- Leading hypothesis: resampling to the 384 kHz default format (symptom 1). Symptom 2 (lower voices mean a sample-rate mix-up) is not yet separated into "caused by the 384 kHz setting" versus "a codec or update was swapped".

**Planned (next steps; the owner must act)**
1. Lower the `LOXJIE AUDIO` default format to 24-bit / 48,000 Hz and check whether the PowerDVD noise disappears on the same scene.
2. Burn a short mp4 with WMP to a CD-RW or a disc image and check whether the voice pitch returns.
3. If step 1 fixes it, roll the driver back or use 384 kHz only for exclusive-mode playback (open-bar / open-media). If only step 2 stays broken, remove the UniConverter / Leawo codecs and retest.

**Issues**
- Not reproduced yet (waiting for the owner's real-device check). Changing the default format is a system-settings change, so we do not do it ourselves.
- Checks that need administrator rights (e.g. the WMP Windows feature state) were not done.
- It is not confirmed whether Driver Booster installed the driver.
