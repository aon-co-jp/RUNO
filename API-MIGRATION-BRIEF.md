# REST 全廃・Connect 移行 共通指示書 (2026-11-04)

ユーザー決定: 「REST 全廃・gRPC / Connect へ移す」。正本の方針文は `F:\runo\API-POLICY.md`(日英独露)。参考実装は `F:\open-easy-web`(`server/src/connect.rs`、`proto/open_easy_web/admin/v1/admin.proto`、`CLAUDE.md`「API 方針」)と `RPoem`(`open_runo.admin.v1.Admin`)。

## やること(リポジトリごと。調査 → 確認 → 開発 → TEST → DEBUG)
1. **現状の調査**: 担当リポジトリの GitHub の既定ブランチを新しく clone して(手元の `F:\<repo>` に未コミット変更や特定ブランチがあれば直接触らない)、REST 風ルートを実際にコードから洗い出し、一覧表にする(メソッド・パス・認証・呼び出し元=同リポジトリの画面/CLI、他リポジトリ、スクリプト、インストーラー、文書、`F:\` 配下の兄弟、VPSの systemd/タイマー/cron)。`version-control` の巡回は VPS の古い clone を数えているので数が古いことがある。数え直す。
2. **分類**(各ルートについて理由つきで):
   - **移す**: 自分たちの API → Connect の単純呼び出し(`POST /<パッケージ>.<Service>/<Method>`、`content-type: application/json`、読み書きは RS-JSON(`from_str_secure`/`parse_secure` の上限つき、書き出しは `rust_json::fast`))、サービス間は gRPC / gRPC-web。ブラウザの WASM に `prost`/`sonic-rs` は入れない。
   - **例外(移さず台帳に載せる)**: 相手の規格が形を決めるもの。ACME、OAuth/OIDC コールバック、第三者の Webhook、ヘルスチェック、静的ファイル、OTLP、そして **他の製品/標準との互換を目的とした API**(OpenAI 互換の `/v1/chat/completions` など、Gitea/Redmine/S3/WebDAV/Git smart HTTP の互換、PostgreSQL/MySQL 互換など)。例外は `F:\version-control\exceptions.toml` の形式に合わせて、理由・規格のURLつきで報告(台帳への追加は version-control のセッションに頼むか、PR 的に別コミットで)。
   - **ブラウザが直接開くGET(メール確認リンク等)**: 「リンク先は画面、確定は Connect の POST」に変える(トークンは URL のフラグメントに載せ、GET では副作用を起こさない)。
3. **開発**: 移すものを Connect に実装(認証・上限・エラー形式 `{"code","message"}` は open-easy-web の `connect.rs` に合わせる)。**呼び出し元をすべて同時に直す**(画面、CLI、他リポジトリのクライアント、スクリプト、インストーラー、文書)。外から使われていて直せない呼び出し元がある場合は、勝手に壊さず、期限つきの互換を残して(理由・期限を明記)、報告に書く。移し終えた旧 REST の経路は削除する。
4. **TEST/DEBUG**: 既存テストを新しい形に更新して全部通す。実サーバーを立てて `curl` で Connect を叩く(認証なし401・不正入力400・重複キー400・正常200、旧REST経路が404)。画面があるものは**ブラウザ(`mcp__Claude_Browser__*`)で主要操作を通し、白画面・エラー表示を見逃さない**。
5. **記録**: `README.md`・`CLAUDE.md`・`PORTING.md` に、移行の状況(移した/残した/例外と理由)を日本語で追記(四か国語の方針節は別セッションが反映済み。そこと整合させる)。commit・push(末尾 `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`)。
6. **本番(VPS)への反映**: サービスがあれば、WSL でリリースビルド → glibc 2.39 以下を確認 → scp → バックアップ → 入れ替え → 再起動 → 確認 → 失敗時は自動ロールバック。**VPS でビルドしない**(3.6GB メモリ。過去にフリーズ)。VPS 上の clone に未コミット変更があれば触らない。VPS のサービスのポート公開・再起動は、そのサービスの反映に必要な範囲だけ。反映できない/しない場合は理由を報告。

## 守ること
- 秘密(トークン・パスワード・SMTP 等)を画面・ログ・コミットに出さない(`systemctl cat` は伏せて見る)。`cargo fmt --all` 禁止(`cargo fmt -p`)。`git pull` は書き換え済みの履歴を戻すので、`git fetch` と `git reset`/新規clone。強制pushしない。
- `F:\open-web-server` の `admin-2fa-hardening` ブランチは触らない。
- Windows の PowerShell 5.1 は BOM無しUTF-8 の日本語 `.ps1` を読み違える(スクリプトは英数字のみ)。Git Bash は `/mnt/...` を書き換える(`MSYS_NO_PATHCONV=1 wsl -d Ubuntu -- bash スクリプト`)。Rust のビルドは WSL(`CARGO_TARGET_DIR` は WSL のホーム、PATH に `~/.cargo/bin`)か、Windows(`%USERPROFILE%\.cargo\bin` を前置き)。
- 他の兄弟リポジトリを直す必要が出たら、そのリポジトリの別cloneで小さな別コミットにする。
- チャットは日本語のみ。できなかったこと・確認できなかったことは正直に報告する。最後に、移したルート数/残したルート数/例外数、本番反映の有無を簡潔に。
