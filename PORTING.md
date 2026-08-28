# PORTING.md(RUNO、旧称: open-aruaru-runo-iLumi → aon)

このリポジトリは`aon-co-jp`エコシステム全体の**メタ索引**であり、
移植対象となる実装コード・お引越し可能な機能を一切持たない
(ローカル作業ドライブは`F:\runo`)。

他プロジェクトの`PORTING.md`(お引越し可能ファイル一覧)への入口は、
[`README.md`](README.md)の一覧表から各プロジェクトへ辿ることができる。

移植可能な資産が生じた場合(索引生成補助スクリプト等)、この節を更新する。

---

## 2026-08-20 チェックポイント(利用制限接近のため記録、大規模マルチリポジトリセッション)

ユーザー指示「リミットなので、README/CLAUDE/PORTINGを日本語で編集して
push・コミットして停止して」により、本セッションの到達点をここに記録する。

**このセッションで作業したリポジトリ(概要)**:
- **open-english**: モデル重み配置・同期バックアップUI、Facebook経由
  入口ページ、クロスプラットフォーム自動アップデート(Windows/Linux/
  macOS)+自動ロールバック、無料枠情報バナー(Google/DeepSeek/ChatGPT/
  Gemini/Claude)、1日利用回数制限メッセージ、スマホ計算ワーカー
  (PhoneAccelWorker、NNAPI検出+PC URL自動検出)、PS/Switch/Wii/WiiU
  ロードマップ(許可待ちとして明文化)。**重大なデータ損失バグを発見・
  修正**(Windows自動更新で会話履歴DBが消失する実害バグ、実インストーラー
  経由のE2E検証まで完了)。
- **aruaru-llm**: アイドル検知バックグラウンド基盤、NPU/USB検出、
  タスク配布API、自己更新機構、open-cuda連携の運用ルール整理。
- **open-cuda・open-directx**: 常駐サービス化の是非を事実ベースで
  調査(本家DirectX/CUDAもランタイムライブラリ方式と確認、実装見送り)、
  open-directxにLLM推論用の固定2x2 GEMMコンピュートシェーダーを実装・
  実機検証、FlexQ風INT6量子化を実装。
- **aruaru-db**: 自動アップデート機能(GitHub Releases検知+ヘルスチェック
  +ロールバック)を実装・実E2E検証(モックAPI経由)。Raft(openraft)・
  Multi-Raft・HTAP(OLAPキャッシュ)が既に実装済みと判明、TiFlash/
  CockroachDB Serverless/Neon型の3パターンを統合した「トライブリッド」
  実装に着手中(セッション中断、要再開)。
- **world-lab**: ワークユニット永続化(aruaru-db実DB、プロセス再起動を
  跨いだ復元を実機検証済み)、コーディネータをRPoem(Tomcat相当)+
  open-web-server(Apache相当)ベースへ再構築(既存の暗号化・リプレイ
  対策資産を保持したまま、SupervisedTenantRegistry経由でプロセス管理)。
  「4層4重通信」は過大と判断し見送り(正直な理由付き)。
- **dream-os**: `aruaru_persistence.rs`のドキュメント不整合(認証要否の
  誤記)を発見・修正。
- **open-easy-web・open-web-server・RPoem・rs-sync・open-raid-z**:
  自動更新機能の実装・完成、インストーラー整理(open-easy-webはサービス
  登録方式に統合)。
- **多言語翻訳**: 上記の変更を、各リポジトリの既存多言語ドキュメント
  (英語・中国語・独伊仏露烏ヘブライペルシャ語等、リポジトリごとに
  対応言語は異なる)へ反映。

**進行中・要再開のタスク**:
1. `aruaru-db`のトライブリッド実装(TiFlash非同期HTAP+CockroachDB
   Serverless層分離+Neonブランチング機能の統合)——特にNeon型
   ブランチング(Git-on-SQLとの親和性が高い)を優先。
2. 一部リポジトリでpush待ちのコミットが残っている可能性がある
   (各リポジトリの`git log --oneline origin/<branch>..HEAD`で確認)。

**正直な開示**: このセッションは非常に長時間・多数のバックグラウンド
エージェントを並行実行しており、一部エージェントが「委任した」等の
空応答で実作業をしていないケースが複数回発生し、都度直接指示して
やり直させる対応を行った。次回セッション再開時は、まず各リポジトリの
`git status`/`git log`で実際の到達点を裏取りしてから続行すること
(このエコシステム共通の運用ルール通り)。

---

## 2026-08-04(さらに続き) チェックポイント(多言語ページ展開＋open-directx/open-cuda/aruaru-llm連携強化、セッション末尾のため記録)

ユーザー指示「今日はここまでにします」により本セッションを終了。次回
再開の起点は以下の通り。

**今回完了した作業(コミット・push済み)**:
1. **多言語ページ展開**(`audiocafe-tokyo-php`・`audiocafe-tokyo-rust`・
   `open-web-server`): `aruaru`/`aruaru-lady`を11言語→18言語へ拡張、
   `rakuten-mobile`にヘブライ語を追加、3サイトとも18言語で統一。日本語
   ページ(Rust版)に多言語ナビを新設。本番デプロイ中に2つの実バグ
   (`open-web-server`のルーティングが多言語ページへの到達を阻んでいた、
   過去HANDOFFの「rakuten-mobile本番反映済み」という記述が実は誤りで
   VPS上に実ファイルが存在しなかった)を発見・修正し、実インターネット
   経由で全言語ページの200応答を確認済み。
2. **open-directx**: D3D11グラフィックスパイプラインのピクセル位置↔NDC
   座標変換式を実機(NVIDIA GT 730)で検証するテストを追加、実測誤差1
   (UNORM丸め範囲内)で一致確認。push済み(`3424340`)。
3. **open-cuda**: `open-cuda-llm`にQKV融合GEMM＋プリフィル/デコード
   分離を実装。実GPT-2 124M重みで変更前後の生成トークン列が完全一致
   することを実証(挙動を変えない最適化であることの証明)。push済み
   (`d8a49c7`)。
4. **aruaru-llm**: `real-vulkan` featureを新設し実推論をVulkanへ
   ディスパッチする配線を追加。実機検証の結果、**`open-cuda`側
   `Linear::forward`が`matmul.spv`を`sgemm`へ渡していないため
   `GemmPath::VulkanGeneric`が機能しない(即座にエラー)という未解決の
   実バグを発見**——性能比較のベンチマークはまだ実施できていない。
   push済み(`0327661`)。`open-cuda/CLAUDE.md`にも次回最優先課題として
   記録済み。

**次回再開の起点(優先順位順)**:
1. **`open-cuda`の`Linear::forward`にSPIR-V(`matmul.spv`)配線を追加**
   (`crates/open-cuda-llm/src/lib.rs`、`open-cuda/CLAUDE.md`2026-08-04
   〈続き〉エントリ参照)——これが解消して初めて`aruaru-llm`側の
   実Vulkan/CPU速度比較ベンチマークが実施できる。
2. 上記完了後、`aruaru-llm`(`--features real-vulkan`)で実機再検証:
   CPU版とVulkan版の生成トークン列一致・実速度差の計測。
3. `open-directx`側の残課題(DXILチェーンクラスのDXBC側への追従、
   テクスチャサンプリング・スワップチェーン拡張、AMD/Intel実機検証)。

---

## 複数リポジトリ横断セッションチェックポイント(2026-08-04追加)

> 以下は`F:\runo`ローカル作業ドライブでのセッション(どのリポジトリ・
> どのセッションから再開しても迷わないための直近の到達点)の記録。
> このメタ索引リポジトリ自体の実装対象ではないが、複数プロジェクトに
> またがる作業の「今どこまで進んでいるか」を一箇所で追える場所として、
> このリポジトリでホストする(ユーザー指示、2026-08-04)。

どのリポジトリ・どのセッションから再開しても迷わないための、直近の
到達点と次回再開ポイントの一覧。各詳細は各リポジトリの`CLAUDE.md`の
HANDOFFセクション参照。

## 2026-08-28 VPS(ConoHa、`ssh conoha`)ディレクトリ構成整理

**背景**: ユーザー指示「`/root`の下にrepositoryフォルダを作りリポジトリ
はそこに移動、`/root`の下にURLフォルダを作りWEBサイトはそこに移動、
シンボリックリンクを貼って全てのVPSとGithubのプログラムに対して編集
して」への対応。ハードリンクはLinuxの仕様上ディレクトリには作成
できない(ファイル単位のみ)ことをユーザーへ説明し、シンボリックリンク
のみで進める・ドメイン兼リポジトリのフォルダは両方(`/root/repository`
に実体+`/root/url`にもシンボリックリンク)に置く・1サービスずつ停止→
移動→シンボリックリンク作成→起動→実HTTP確認、という方針で合意の上
実施した。

### 実施内容

1. **`/root/repository/`(27件、gitリポジトリ)・`/root/url/`(10件、
   ドメイン兼リポジトリ8件+非リポジトリのWEB/デモ用ディレクトリ2件
   `easy-web.tokyo`・`open-raid-z-demo-disks`)を新設**。旧`/root/<名前>`
   には全てシンボリックリンクを残し、systemdユニット・nginx alias等の
   既存の絶対パス参照はすべて透過的に機能する(実際に編集が必要だった
   設定ファイルは無かった——`open-web-server`の`domains.toml`はポート・
   パスプレフィックスのみでファイルパス不使用、nginx側の唯一の
   `/root/`参照〈aruaru.tokyoの動画ファイルalias〉もシンボリックリンク
   越しにそのまま機能、cron〈`sync-repos.sh`〉・certbot設定にも該当
   パス参照は無かったことを確認済み)。
2. **移動対象外(意図的に現状維持)**: `aon.co.jp`・`audiocafe.tokyo`
   (実サイトは`/var/www/audiocafe.tokyo`、この`/root/audiocafe.tokyo`は
   未使用の古いclone)・`aruaru-db-data`(データディレクトリ、コードでは
   ない)・`disabled-vhosts-backup`・`dream-os`・`easy-web`(`.tokyo`
   無し)・`gitbucket-test`・`gitea-test`・`mirror-cache`・`open-aruaru`・
   `open-aruaru-core`・トップレベルの`open-cg-cad-demo`/`open-english-demo`
   (実体はいずれも`easy-web.tokyo`配下にあり、こちらは無関係な残骸)・
   `open-mqa`・`RFrontEnd`(`.git`が無く正規のcloneではない)・
   `rs-gitbucket`・トップレベルの`rs-sync-demo`(実サービスは
   `/root/rs-sync`を指すため無関係)・`world-lab`。いずれも稼働中の
   systemdサービスから参照されておらず、リポジトリともWEBサイトの実体
   とも言い切れないため今回は触れていない。
3. **予期しない発見・修復(今回の移動作業とは別の既存問題)**: サービス
   停止のたびに`target/release/<binary>`の実在を確認したところ、
   **このVPS全体で12個のサービスが、実体は既にディスクから削除済み
   (過去のディスク容量整理等の影響と推測)なのにプロセスだけ稼働を
   続けている「ゴースト状態」だったことが判明**——今回サービスを
   一度停止したことで初めて表面化した(今回の移動作業が原因ではなく、
   移動のために止めたことで顕在化した)。対象:
   `open-gitea`・`fbi.tokyo`・`e-gov.info`・`karu.tokyo`・`icpo.tokyo`・
   `runo.tokyo`・`open-redmine`・`RS-Blog`・`RS-EC`・`open-cg-cad`/
   `open-cg-cad-demo`・`open-kagaku`(いずれも現在チェックアウト済みの
   ソースのまま`cargo build --release`で再ビルド、`git pull`はしていない
   ——今回の目的はインフラ修復であり、無関係な機能更新を混在させない
   ため)。**`RS-Ops`はソースディレクトリ自体
   (`/root/runo.tokyo/RS-Ops`)が消失していたため、GitHubから再clone→
   ビルド→起動**して復旧した。全12件、再ビルド後に`systemctl is-active`
   +実際にTCPポートでlistenしていることを確認済み。
4. **`open-web-server`(全ドメインのリバースプロキシ)は当初Phase 6
   〈最後〉に予定していたが、RPoem等の相対パスsibling依存
   (`../../open-web-server/crates/...`)を解決するため、実際には
   `open-gitea`再ビルドの前段で先行して移動した**。
5. **実HTTP検証**: 移動・再ビルド後、`aon.tokyo`・`aruaru.tokyo`・
   `e-gov.info`・`fbi.tokyo`・`icpo.tokyo`・`karu.tokyo`・`nasa.tokyo`・
   `runo.tokyo`・`easy-web.tokyo`(および`/rsync`・`/open-redmine`・
   `/rs-sync`・`/rs-link-fusion`配下)・`runo.tokyo/RS-Ops`が実際に
   `https://`経由で200を返すことを確認。`easy-web.tokyo/open-gitea/`の
   404は移動前から存在した仕様(バックエンド自体がルートパスで404を
   返す)であり回帰ではないことを確認済み。
6. **GitHub側の「VPS上の作業パス」記載更新(5リポジトリ、CLAUDE.mdの
   現状記述のみ——HANDOFFの日付付き履歴エントリは当時の事実の記録
   として書き換えていない)**: `RS-Blog`・`RS-EC`・`open-redmine`・
   `rs-link-fusion`・`e-gov.info`(ドメイン兼リポジトリのため
   `/root/url/e-gov.info`併設にも言及)。各リポジトリで無関係な既存の
   未コミット差分(`open-redmine`のREADME/installスクリプト、
   `rs-link-fusion`の`Cargo.lock`)には触れず、`CLAUDE.md`のみを個別に
   commit・push済み。
7. **未実施(次回以降の課題)**: 他の全リポジトリ(`RS-Guard`・
   `RS-JSON`・`RS-SmartTCP`・`aruaru-db`・`audiocafe-tokyo-rust`・
   `open-gitea`・`open-web-server`・`rs-sync`・`open-raid-z`等)の
   CLAUDE.md内にも`/root/`への言及はあるが、いずれも日付付きの過去の
   作業記録(HANDOFFエントリ)であり「現状」を宣言する文ではないと
   判断し今回は変更していない——今後これらのファイルへ「現状」節を
   新設する場合は新パス(`/root/repository/<名前>`)を使うこと。

## 2026-08-28 ログイン方式4択(パスワード無し/email OTP/QR撮影のみ/email OTP+QR撮影)の横展開チェックポイント

**背景**: ユーザー指示「ログインは、1.パスワード無し 2.email OTP
3.QR撮影のみ(自動送受信・自動承認) 4.email OTP+QR撮影、と選べるように。
open-englishに限らず全リポジトリへ展開して」への対応。QR確認は公開鍵・
秘密鍵などの非対称暗号は使わず、短命(3分・1回限り)なランダムトークンを
含むURLをQR化するだけの設計(open-english側でユーザーと確認済み)。
確認端末でこのURLを開くと、ボタン操作無しに自動的にログインが承認される
(「撮影すると自動送受信・自動承認」という要件への対応)。

### 完了・push済み

- **open-english**: 4方式すべて実装完了。`server/src/auth.rs`の
  `login_mode`設定(`none`/`otp`/`qr`/`otp_qr`)、`qr-confirm.html`新設。
  実HTTP検証・実ブラウザでの別タブ確認(自動承認→プライマリタブの
  ポーリング検出→ゲート自動クローズ)まで完了。VPS本番
  (`easy-web.tokyo/open-english/`)へもデプロイ・反映済み。詳細は
  [open-english/CLAUDE.md](open-english/CLAUDE.md)の2026-08-28
  HANDOFF参照。
- **open-easy-web**: `qr`/`otp_qr`の2方式を追加(**「パスワード無し」は
  意図的に非実装**——VPS/サイト管理という重要操作を扱うアプリのため、
  認証省略は不適切と判断した正直な設計判断、詳細は同リポジトリの
  CLAUDE.md参照)。既存のリアルTOTP基盤(`totp::qr_svg`)を再利用。
  実HTTP統合テスト4件を新規追加、`cargo test` 96件全green(3回連続
  実行でフレーク無し確認)。GitHubへcommit・push済み(`66bf1ea`)。
  **VPS本番デプロイは未実施**。詳細は
  [open-easy-web/CLAUDE.md](open-easy-web/CLAUDE.md)の2026-08-28
  HANDOFF参照。

- **RS-Blog**: `qr`/`otp_qr`の2方式を追加(**「パスワード無し」は
  意図的に非実装**——公開ブログの管理者アカウントであり、投稿の
  改ざん・削除が可能なためコンテンツ完全性を優先し、open-easy-webと
  同じ判断基準を適用)。RS-Blogは登録アカウント制を持たず単一の
  管理者(`RSBLOG_ADMIN_EMAIL`)のみのため、open-easy-webの
  「TOTP登録済みアカウントのみqr可」という前提条件は不要とし、QR単体
  ログインは事前準備なしに常時利用可能な設計にした。`src/auth.rs`に
  `login_mode`(otp/qr/otp_qr)・QRログインセッション一式、
  `src/main.rs`に管理API+`qr-confirm.html`を追加。`cargo build`成功
  (警告0件)、`cargo test`**26件全green**(新規11件、実HTTP経由の
  統合テスト3件を含む)。実バイナリを起動してのcurl検証も実施
  (`GET /`・`GET /api/auth/login-mode`・`POST /api/auth/qr-login/start`
  のモード別403・`GET /qr-confirm.html`・未ログインでの
  `POST /api/auth/login-mode`401・SMTP未設定時の`request-otp`503、
  いずれも期待通り)。GitHubへcommit・push済み(`15fe134`)。
  **VPS本番デプロイは未実施**(v0.1.0時点でRS-Blog自体がまだVPS本番
  稼働していないため対象外)。詳細は
  [RS-Blog/CLAUDE.md](RS-Blog/CLAUDE.md)の2026-08-28 HANDOFF参照。

- **RS-EC**: `otp`(既定)/`otp_qr`(QR確認2FA)の2方式のみ実装
  (**「パスワード無し」に加え、QR単体〈no-OTP〉ログインも意図的に
  非実装**——`RS-Blog`〈単一固定管理者〉やopen-easy-web〈TOTP登録済み
  アカウントのみqr可〉とは異なり、RS-ECは`accounts.rs`による複数の
  登録メールアドレス〈会員+管理者〉を持ち、TOTP等の事前登録済み第二
  要素も無いため、「メールアドレスさえ知っていればQRセッションを
  開始できてしまう」設計は注文・決済に関わるアカウントの完全性を
  損なうと判断した)。`src/auth.rs`に`login_mode`(otp/otp_qr)・
  QRログインセッション一式(常に`verify_otp`経由でのみ開始、単体
  start APIは無い)、`src/main.rs`に管理API+`qr-confirm.html`を追加。
  `cargo build`成功(警告0件)、`cargo test`**47件全green**(新規
  10件、実HTTP経由の統合テスト含む)。実バイナリを起動してのcurl
  検証も実施。GitHubへcommit・push済み(`394d74b`)。VPS本番デプロイは
  対象外(RS-EC自体がまだVPS本番稼働していない)。詳細は
  [RS-EC/CLAUDE.md](RS-EC/CLAUDE.md)の2026-08-28 HANDOFF参照。

### 未着手(次回再開ポイント、優先度は次回ユーザーに確認)

認証機能(`auth.rs`/`totp.rs`)を持つことを確認済みの残り4リポジトリ:

- **RS-Ops**
- **open-gitea**
- **open-redmine**
- **rs-sync**

いずれも`server/src/auth.rs`または`totp.rs`を保有していることは
確認済みだが、各リポジトリの認証設計(セッション方式・OTP実装・
TOTP有無・単一/複数アカウント制)は個別に異なる可能性が高く、着手前に
各リポジトリの既存`auth.rs`実装を読んでから、open-english/
open-easy-web/RS-Blog/RS-ECと同じパターン(`start_qr_login`/
`confirm_qr_login`/`qr_login_status`/`finish_qr_login`+
`qr-confirm.html`+`login_mode`管理API)を、そのリポジトリの既存設計に
合わせて移植する、という進め方を踏襲すること。「パスワード無し」
モードを実装してよいかどうかは、そのアプリが扱う操作の重要度に応じて
都度判断すること(open-easy-web=VPS管理アプリでは非実装、RS-Blog=
公開ブログ管理者アカウントでも非実装、という前例を判断基準として
参考にする)。加えて、**QR単体(no-OTP)ログインを実装してよいかは
「事前に本人確認できる仕組み(単一固定管理者、またはTOTP等の既存の
第二要素)を持つか」で判断すること**(RS-EC=複数アカウント制+
事前確認手段が無いため非実装、という前例を参考にする——単一
アカウントのRS-Blog/固定管理者のopen-easy-webでは実装済み)。

### 次回セッション開始時にそのまま使える再開メッセージ

```
ログイン4択方式(パスワード無し/email OTP/QR撮影のみ/email OTP+QR撮影)の
横展開を再開してください。open-english・open-easy-web・RS-Blog・RS-ECは
完了済み(`F:\runo\PORTING.md`の「2026-08-28 ログイン方式4択…横展開
チェックポイント」節参照)。残りはRS-Ops/open-gitea/open-redmine/rs-sync
の4リポジトリです。まず着手するリポジトリを1つ選んで(優先度を指定
するか、私に選ばせてください)、そのリポジトリのsrc/auth.rs(または
server/src/auth.rs)を読んでから、open-easy-web/RS-Blog/RS-ECと同じ
パターン(QR確認ログイン+login_mode管理API+qr-confirm.html)を移植して
ください。「パスワード無し」モードを実装するかどうかはそのアプリが扱う
操作の重要度に応じて、「QR単体(no-OTP)」モードを実装するかどうかは
事前に本人確認できる仕組み(単一固定管理者、またはTOTP等の既存の第二
要素)を持つかどうかで判断してください(RS-ECは複数アカウント制+
事前確認手段が無いため後者を非実装とした前例あり)。
```

## 2026-08-04(続き) チェックポイント(複数GitHubアカウント・Gitea/GitBucket連携・マルチデバイス同期の強化着手)

ユーザー指示「複数GitHubアカウントとGitea同期とVPSやレンタルサーバーや、
スマホやタブレットやPCなどと同期可能なWEBアプリの完成度、実用性、
使いやすさなどを向上させて」を受けて着手。

### 完了・push済み

- **open-redmine**: 本家Gitea(OSS)・GitBucket(OSS)のSCM連携を新規実装
  (`ScmProvider::Gitea`/`GitBucket`、`Project.scm_base_url`新設、
  `fetch_recent_commits_gitea`/`fetch_recent_commits_gitbucket`)。
  `rs-sync`の`GiteaProvider`/`GitbucketProvider`と同じ「公式API仕様に
  基づき実装するが実サーバー未検証」という開示方針を踏襲。
  `cargo test` 93→94件全green、`web/`側wasmビルドも成功(回帰なし)、
  commit・push済み(`bf4e924`)。詳細は
  [open-redmine/CLAUDE.md](open-redmine/CLAUDE.md)「2026-08-04」参照。

### 重大なブロッカーを発見(要ユーザー対応)

- **VPS(conoha、160.251.237.162)のディスクが満杯**(99GB中98GB
  使用、空き0バイト)。主因は`/root/aon.tokyo/`配下の個人/事業データ
  72GB(Content 31GB=動画等・Books 22GB=PDF書籍コレクション・backup
  3.4GB等)。これにより、本家Gitea/GitBucketの実サーバー検証用に
  計画していたDocker新規起動(`/root/gitea-test`・`/root/gitbucket-test`
  ディレクトリとdocker-compose.ymlは作成済みだが未起動)が実行不能。
  **ディスクプラン拡張はConoHaコントロールパネルでの契約変更が必要
  なため、ユーザー側の対応待ち**。拡張完了後、`docker compose up -d`を
  両ディレクトリで実行すれば起動できる状態まで準備済み。
- （余談・対応不要）ユーザーからConoHa VPS一覧に別途「mail-2026-07-18」
  (IP 133.117.75.153)というインスタンスがあるがメールはLOLIPOP運用の
  ため不要では、との確認があったが、時期が来ると自動解約される契約との
  ことで対応不要と判明。

### 次回再開の起点

**最優先(ブロッカー解消後すぐ着手できる状態に準備済み)**:
1. VPSディスク拡張(ユーザー対応待ち)後、`/root/gitea-test`・
   `/root/gitbucket-test`で`docker compose up -d`→本家Gitea/GitBucket
   実サーバーを起動→`rs-sync`の`GiteaProvider`/`GitbucketProvider`
   (`rs-sync/src/provider.rs`)と`open-redmine`の
   `fetch_recent_commits_gitea`/`_gitbucket`(今回実装分)を実HTTPで
   検証。

**ディスク拡張を待たずに継続可能**:
2. マルチデバイス同期の実インストール(`rs-sync`+`open-easy-web`+
   `open-web-server`連携)——調査エージェントを1件バックグラウンドで
   起動済み(rs-sync/open-easy-web/open-web-serverの現状連携ポイント・
   実際の「連携インストール」の具体的手順を調査中、結果は次回セッション
   冒頭で確認すること)。
3. 複数GitHubアカウント対応の強化(open-redmine/rs-syncでの複数
   アカウント切り替え・並行運用のUX改善、今回はGitea/GitBucket対応を
   優先したため未着手)。

## 2026-08-04 チェックポイント(リミット接近のため記録)

### 直近でpush済みの変更

- **open-redmine**: カスタムフィールド・保存済みクエリ・ロールプリセット・
  ガントチャート・優先度・カテゴリ・GitHub連携(GitHub/GitLab/Bitbucket
  対応、他セッションで拡張済み)
- **open-raid-z**: インストーラー電源プロファイル方針・Android優先方針・
  「省機能+省メモリボタン」標準方針を正本として記録(全リポジトリ横断)
- **rs-link-fusion**(旧RS-LinkFusion): リネーム・電源プロファイル実装・
  landingサーバー・VPSデプロイ完了
- **open-easy-web**: 電源プロファイル・メモリ円グラフ(実メモリ+仮想
  メモリ)・省機能ボタン・Androidアンインストール機能。実バグ発見・修正
  (`/admin/power-profile`が`open-web-server`自身の同名APIに横取りされ
  本番到達不能だった→`/admin/easyweb-power-profile`へリネームで解消)。
  VPS本番デプロイ・実HTTPS検証済み
- **aruaru-llm**: `POST /v1/translate`の実HTTP検証(GPT-2流用実装は
  実用に耐えないと判明)→翻訳プラグイン(M2M100/`rust-bert`、
  `nllb-translate` Cargo feature着脱式)を新設。**正直な開示**:
  feature有効時の実M2M100翻訳品質検証はlibtorch未整備のため未実施
- **rs-sync**: 36/36テスト全green、既に高い完成度(実機検証項目のみ残る)

### 次回再開の起点

**次にすべきこと(優先順)**:
1. `aruaru-llm`: `--features nllb-translate`での実ビルド・実M2M100翻訳の
   実HTTP検証(libtorchダウンロードを要するため時間のかかる作業)
2. `open-directx`/`open-cuda`/`aruaru-llm`のSET連携: 既にかなり作り
   込まれているため、各CLAUDE.mdのHANDOFF末尾「次にすべきこと」を確認
3. 「省機能+省メモリボタン」パターンの他GUI保有リポジトリ
   (`open-redmine`・`rs-link-fusion`)への展開
4. `open-raid-z`に記録したAndroid対応の段階的展開(NDKクロスビルド
   実証済みのリポジトリから優先)

### 参照

- プロジェクト自動認識: [runo-scan.txt](runo-scan.txt) / [runo-scanner](runo-scanner)
- 開発方針の正本: [open-raid-z/CLAUDE.md](open-raid-z/CLAUDE.md)

## 2026-08-03 チェックポイント(ユーザー指定4項目、「その順番で続けて」の進捗)

ユーザーが順番指定した4項目のうち、4番目まで一通り着手完了:

1. **rs-link-fusion・open-easy-webへのAndroid対応展開**: `open-easy-web`
   は既存の埋め込みバイナリ方式`.so`を再ビルドして最新化(1週間以上
   stale状態を解消)。`rs-link-fusion`は`tun-rs`crateにAndroid向け
   `DeviceBuilder`実装が存在しない(低レベルFDコードのみandroid-gated)
   ため、`VpnService`+JNI再設計が必要と判明——単純な`cargo ndk`では
   不可能なアーキテクチャ上の制約として記録([rs-link-fusion/CLAUDE.md](rs-link-fusion/CLAUDE.md)参照)。
2. **複数ドメインでのバイナリ共有(RPoemのSharedDispatcher統合)**:
   `open-web-server`の`TenantRegistry`が既に本番稼働中の同種機構である
   ため、RPoem側の`appserver_tenants.rs`(実装済みだが未デプロイ)を
   重複導入しない判断([open-raid-z/CLAUDE.md](open-raid-z/CLAUDE.md)参照)。
3. **RS-Sync動作確認・open-easy-web+open-web-server連携インストール**
   (2026-08-03に大きく進捗):
   - SFTPフォルダ同期を実conoha VPSで初めて実機検証、Windows開発機特有の
     バックスラッシュ混入パスバグを発見・修正(`join_unix_path`)。
   - WiFiルーターUSB共有・市販NAS向けにSMBバックエンド
     (`FolderEndpointKind::Smb`、`smb2`crate)を新規追加(実ルーター/NAS
     実機は無く未検証、正直な開示)。
   - デスクトップインストーラーをLinux(systemd、既存)に加え
     macOS(launchd)・Windows(Task Scheduler)へ拡張(この開発環境は
     ドメイン参加Windowsかつ非管理者アカウントのためTask Scheduler登録
     自体がAccess Deniedで実地確認未了、launchd plistのXML整形式のみ
     別途確認)。
   - Android版アプリシェルを新規実装(open-redmine版と同じ「リモート
     クライアント」設計)、`gradle assembleDebug`で実際にAPK生成まで確認
     (実機/エミュレータでの起動は未確認)。
   - iOS/iPadOS対応はユーザー指示により後回し、実現可能性調査のみ
     [open-easy-web/IOS_FEASIBILITY_MEMO.md](open-easy-web/IOS_FEASIBILITY_MEMO.md)
     に記録。
   詳細は[RS-Sync/CLAUDE.md](https://github.com/aon-co-jp/RS-Sync/blob/main/CLAUDE.md)
   「2026-08-03」系エントリ参照。
   **引き続き未着手**: Gitea(OSS)/GitBucket/GitLab/Bitbucket各プロバイダの
   実サーバー検証、open-easy-web+open-web-server連携によるマルチデバイス
   ドライブ同期+自動バックアップの実インストール作業。
4. **open-redmineのGitHub/GitBucket/Bitbucket/GitLab/Gitea連携対応**:
   GitHub(既存)に加えGitLab・Bitbucketを新規実装、実ネットワークAPI
   検証+ブラウザ実クリックE2E(GitLab側)完了、VPSへデプロイ・200確認
   済み。GitBucket・実Gitea(OSS)は実行中の検証用サーバーが無く
   未実装のまま(open-gitea自身にはコミット一覧APIが無いため代替不可)。
   詳細は[open-redmine/CLAUDE.md](open-redmine/CLAUDE.md)「2026-08-03」参照。

### 次回再開の起点

- 項目3の未着手部分(RS-Syncの実サーバー連携検証、open-easy-web+
  open-web-serverによるマルチデバイスドライブ同期+自動バックアップの
  インストール)が最大の残課題。
- 項目1の`rs-link-fusion`Android対応はVpnService+JNI再設計が必要な
  大きめの作業として別途スコープを切ること。
- 項目4のGitBucket/Gitea連携は実サーバーが用意できてから。
- GitHub側Webhook登録(ユーザー操作待ち、open-redmine)は引き続き
  ブロック中。

## 2026-08-01(続き5) チェックポイント(open-raid-z本体「A」完了、次は横断バックログ「B」)

ユーザー指示「Aを進めて完成したらBを進めて」(A=open-raid-z単体リポジトリ、
B=open-raid-z/CLAUDE.mdに記録された複数リポジトリ横断のバックログ)を
受け、Aから着手。

**Aで完了した内容**(詳細は[open-raid-z/CLAUDE.md](open-raid-z/CLAUDE.md)
「2026-08-01」エントリ参照):
1. GPU parity実装(P/Q both実機検証済み)が`orzctl`から一度も呼ばれて
   いなかった(死んだコード)実バグを発見・修正、全4サブコマンドで
   実際に接続。
2. 接続直後に実測ベンチマーク(`examples/raidz2_parity_benchmark.rs`
   新設)を行ったところ、この環境ではGPU版がCPU版よりおよそ9〜14倍
   遅いと判明——「実装した・検出できた」だけでGPUを既定にせず、
   `--accel gpu`明示指定時のみの実験的オプションへ設計修正(実測に
   基づく誠実な判断)。
3. 副次的に発見: Linux(`fuse_backend`)ビルドが`BridgeError`の
   非網羅マッチで壊れていた実バグを修正(Windows専業開発で長らく
   未検出だった回帰)。
4. Web管理UI(`web/`crate、以前ローカル検証止まりだった)を実際に
   VPSへデプロイ、`https://easy-web.tokyo/open-raid-z/`で実際に
   稼働中のプール状態を確認済み。

**B(横断バックログ)は未着手**——open-raid-z/CLAUDE.mdの「関連
プロジェクト」節・エコシステム共通方針セクションに記録されている
複数リポジトリ横断の項目(Android優先対応、GPU/NPU検出ロジックの
他リポジトリへの展開、`aruaru-db`側の同種Web管理UI等)から着手する。

### 次回再開の起点

- Bの横断バックログへ着手(具体的にどの項目から着手するかは次回
  `open-raid-z/CLAUDE.md`「関連プロジェクト」節・各リポジトリの
  「次にすべきこと」を巡回して優先度を判断する)
- GitHub側Webhook登録(ユーザー操作待ち、open-redmine)

## 2026-08-01(続き4) チェックポイント(残課題2件を消化)

前回チェックポイントの2項目に対応:

1. **GitHub側Webhook登録**(open-redmine): 引き続きユーザー操作待ち
   ——VPS保存済みのfine-grained PATに`Webhooks`権限が無く、エージェント
   側からは登録できない(手順は[open-redmine/CLAUDE.md](open-redmine/CLAUDE.md)
   「2026-08-01(続き2)」参照)。今回はこれ以上進められる状態ではない
   ため見送り。
2. **Android版UIへの電源プロファイル反映**(open-easy-web): 調査の結果、
   Android版ネイティブの電源プロファイル選択画面(`PowerProfile.kt`)は
   起動時の排他的3択(WakeLock取得有無というOSレベルのプロセス起動
   モード)であり、Web GUI側の独立チェックボックス(実行時に組み合わせ
   可能なランタイムフラグ)とは性質が異なる別概念と判明したため、
   変換は意図的に見送った。Androidアプリの「ブラウザで開く」ボタンは
   外部ブラウザでWeb GUIを開くだけの導線のため、Androidユーザーは
   既にこのボタン経由で新チェックボックスUIへ到達できる(Android側の
   コード変更は不要)。詳細は[open-easy-web/CLAUDE.md](open-easy-web/CLAUDE.md)
   「2026-08-01(続き2)」参照。

### 次回再開の起点

- GitHub側Webhook登録(ユーザー操作待ち、open-redmine)
- 現時点で他に明確な次のタスクは記録されていない。新しい指示を待つか、
  各リポジトリのCLAUDE.md「次にすべきこと」欄を巡回して優先度の高い
  ものから着手する。

## 2026-08-01(続き3) チェックポイント(open-easy-webも追従、全3リポジトリ完了)

前回チェックポイントの残課題「`open-easy-web`のチェックボックス方式への
追従」を実施。旧3ボタン方式(排他的選択、「省機能」ボタンが
`memory_saver`を自動設定)を、`open-redmine`/`open-gitea`と揃えた
チェックボックス方式へ変更。既存バックエンド(`power_profile.rs`の
`PowerProfileFlags`)は元々独立フラグの組み合わせを表現できる設計
だったため、フロントエンドのみの変更で対応できた。加えて新設
`GET /admin/easyweb-power-profile`でページ読み込み時にサーバー実態へ
同期する導線も追加。

実サーバーを起動しての実ブラウザ検証(チェックボックス変更→`curl`で
サーバー側の実際の状態変化を確認→組み合わせ→ボタンでの省機能表示/
全機能復元)・本番デプロイ・本番wasmバイナリへの新コード混入確認まで
完了。詳細は[open-easy-web/CLAUDE.md](open-easy-web/CLAUDE.md)の
2026-08-01付HANDOFF参照。

これで「省機能+省メモリ版に切替」ボタン導入対象の3リポジトリ
(`open-easy-web`・`open-redmine`・`open-gitea`)全てがチェックボックス
方式で揃った。

### 次回再開の起点

- GitHub側Webhook登録(ユーザー操作待ち、open-redmine、
  `open-redmine/CLAUDE.md`「2026-08-01(続き2)」参照)
- Android版UI(`open-easy-web/android/`)への電源プロファイル
  チェックボックス反映(優先度低、現状Android UIが同機能を持つか要確認)
- 他にGUIパネルを持つリポジトリが増えた場合、同パターンで展開

## 2026-08-01(続き8) チェックポイント(open-redmineのAndroid版アプリシェルを新規実装)

GitHub Webhook登録は引き続きブロック中(fine-grained PATに`Webhooks`
権限が無く、再試行しても`403`)——手動登録手順は
[open-redmine/CLAUDE.md](open-redmine/CLAUDE.md)参照。

ユーザー指示により、横断バックログのうちAndroid対応へ着手。
`open-raid-z/CLAUDE.md`の段階的着手方針(NDKクロスビルド実証済みの
リポジトリを優先)に該当する`open-redmine`に`android/`ディレクトリを
新規実装(`aruaru-db/android`・`open-web-server/android`と同じKotlin
パターン: 3電源プロファイル・電源抜き差しダイアログ・プロファイル別
ホーム画面アイコン)。open-redmine本体は既に完成度の高いWASMブラウザ
GUIを持つため、ネイティブUIを再実装せず「疎通確認+ブラウザで開く」
クライアントとして設計。`gradle :app:assembleDebug`成功・APK生成まで
確認済み(実機/エミュレータでの実疎通確認は未実施)。

### 次回再開の起点

- GitHub側Webhook登録(ユーザー操作待ち、open-redmine)
- Android対応の続き: `rs-link-fusion`・`open-easy-web`はまだ`android/`
  未着手
- 複数ドメインでのバイナリ共有(RPoemの`SharedDispatcher`/
  `appserver_tenants`経由の統合、`open-raid-z/CLAUDE.md`に複数箇所で
  「次回の課題」として記録されたまま)

## 2026-08-01(続き7) チェックポイント(横展開点検でopen-raid-zにも同じ実バグ発見・修正)

前回チェックポイントの提案「他にもGUI/管理APIを持つリポジトリがあれば
同様の観点で点検する価値がある」を実施。リポジトリ横断で`fetch('/api`
パターンを検索した結果、**`open-raid-z`のWeb管理UIにも`aruaru-db`と
全く同じ絶対パスfetch罠が実際に存在した**(直前のHANDOFFエントリ自体が
「絶対パスだから問題ない」と誤って記載していた箇所)。実ブラウザで
`https://easy-web.tokyo/open-raid-z/`が`{"error":"not found"}`を
表示することを確認した上で、`aruaru-db`と同じ`BASE_PATH`パターンで
修正・本番デプロイ・実ブラウザでの正常動作確認まで完了。
`aruaru.tokyo/src/main.rs`にも同じコードパターンが見つかったが、
こちらは`path_prefix`無しでドメインルートに直接マウントされているため
該当しないことを`domains.toml`で確認済み(誤検知)。

これで、`path_prefix`付きでデプロイされている全Web UI
(open-redmine・open-gitea・RS-Sync・aruaru-db・open-raid-z)の絶対パス
fetch罠点検が完了した。

### 次回再開の起点

- GitHub側Webhook登録(ユーザー操作待ち、open-redmine)
- Android優先対応・複数ドメインでのバイナリ共有等、`open-raid-z/
  CLAUDE.md`に記録された残りの横断バックログ項目
- 新規にpath_prefix付きWeb UIを追加する際は、最初からBASE_PATHパターンを
  組み込むこと(今回の教訓)

## 2026-08-01(続き6) チェックポイント(「B」横断バックログ、aruaru-db優先着手)

ユーザー指示「CLAUDEの判断で優先順位を付けて、すいすいどんどん開発を
進めて」を受け、`open-raid-z/CLAUDE.md`の「関連プロジェクト」から
`aruaru-db`(open-raid-zと対のWeb管理UIパターンを持つ、既に「次に
すべきこと」に「VPS実デプロイ」と明記されていた)を優先着手先として
選び、以下を実施:

1. **Web管理UIをVPS本番へデプロイ**(`aruaru-server`を単一ノード
   スタンドアロン構成でport 4001/5433に起動、Web UIをport 8111に起動、
   `https://easy-web.tokyo/aruaru-db/`で公開)。デプロイ直後、実ブラウザで
   開いたところ**実バグを発見**: `fetch('/api/status')`という絶対パス
   fetchが`/aruaru-db`マウント配下で壊れていた——open-redmine/
   open-gitea/RS-Syncが過去に繰り返し踏んだのと全く同じ「絶対パス
   fetch罠」がこのリポジトリでも初めて実際に踏まれた形。
   `ARUARU_WEB_BASE_PATH`を追加して修正、実ブラウザで正しく動作する
   ことを確認済み。
2. **GraphQL経由の管理操作に認証を適用**(実バグ修正): REST
   `/admin/*`は2026-07-30に認証済みだったが、**同じ管理操作を
   `/graphql`経由で呼べば無認証のまま実行できる抜け穴**が残っていた。
   `x-admin-token`検証を全Admin resolverへ適用(非管理系VCSクエリは
   対象外)、本番で実際にHTTPリクエストにより無トークン/誤トークン
   拒否・正トークン成功・非管理クエリは無認証で成功、の4パターンを
   確認済み。**なお、調査の過程で`cluster_propose`のRaftWriter経由化
   自体は2026-07-26に既に実装・テスト済みだったと判明**——CLAUDE.mdの
   「次にすべきこと」記載が更新されないまま古い情報として残っていた
   だけだった(このエコシステムで繰り返し見られる「ドキュメントの
   追従漏れ」パターン、実装自体は問題無し)。

詳細は[aruaru-db/CLAUDE.md](aruaru-db/CLAUDE.md)の2026-08-01付
HANDOFF各エントリ参照。

### 次回再開の起点

- 他にもGUI/管理APIを持つリポジトリがあれば同様の観点(絶対パスfetch・
  認証欠如)で点検する価値がある
- GitHub側Webhook登録(ユーザー操作待ち、open-redmine)
- Android優先対応・複数ドメインでのバイナリ共有等、`open-raid-z/
  CLAUDE.md`に記録された残りの横断バックログ項目

## 2026-08-01(続き2) チェックポイント(電源プロファイルUIをチェックボックス方式へ)

前回チェックポイントの「他のGUIを持つリポジトリへの省機能+省メモリ版
展開」を`open-gitea`で実施中、ユーザーから「省メモリ、常時電源接続などは
チェックボックスとボタンにして」という形式指定を受け、以下を実施:

1. **`open-gitea`**: 省電力/省メモリ/常時電源接続を独立チェックボックス
   として実装(`open-easy-web`の`PowerProfileFlags`と同じ組み合わせ
   可能な設計)+「省機能表示に切替」「全機能を復元」ボタン。実装中に
   **本番の実バグを発見**: `static/rgit_web.*`(2026-07-27のリネーム前・
   Wiki機能実装前の半年近く古いビルド)がコミットされたままで、
   `index.html`が実際にimportする`open_gitea_web.js`は一度も
   コミットされていなかった——本番は2026-07-28以降ずっと壊れたUI
   (JSファイル404)を配信していた。修正・デプロイ済み、実際に
   `404`→`200`になったことを確認。
2. **`open-redmine`**: 前回チェックポイントで実装した3ボタン方式
   (排他的選択)を、上記と同じチェックボックス方式へ作り直し。
3. **`open-raid-z/CLAUDE.md`**: エコシステム標準方針をチェックボックス
   方式へ改定。**`open-easy-web`(先行実装)は旧3ボタン方式のまま
   ——チェックボックス方式への追従は未着手として記録**。

いずれも本番(`easy-web.tokyo`)へデプロイ済み・実際にHTML/JSに新UIの
文字列が含まれることを確認済み。

### 次回再開の起点

- GitHub側Webhook登録(ユーザー操作待ち、open-redmine)
- `open-easy-web`の電源プロファイルUIをチェックボックス方式へ追従
- 他のGUIを持つリポジトリ(`rs-link-fusion`は静的ランディングページのみで
  対象外と判断——GUIパネルを持つ他リポジトリがあれば順次展開)

## 2026-08-01(続き) チェックポイント(open-redmine、上から順に4項目対応)

前回チェックポイントで挙げた4項目に上から順に対応した:
1. **本番デプロイ+実クリックE2E**: デプロイ済み。実クリックE2E自体は
   本番のOTPメール受信箱にアクセスできないため、ローカルで
   `RSCHIKETTO_DEV_LOG_OTP`+`BASE_PATH`一時変更により実施・確認済み。
2. **GitHub Webhook受信によるリアルタイム更新**: 実装・デプロイ・
   ローカルE2E(署名検証・キャッシュ優先・実クリックでバッジ→チケット
   詳細)確認済み。**GitHub側のWebhook登録は権限不足(fine-grained PATに
   Webhooks権限無し)でブロック中**——ユーザーによる手動登録または
   PATスコープ拡張が必要(手順は`open-redmine/CLAUDE.md`参照)。
3. **install.sh/install.ps1**: 前回「未着手」と記録していたが、実際には
   既に存在していた(2026-07-22時点で追加済み)。誤った記録だった。
4. **省機能+省メモリ版に切替ボタン**: 実装・デプロイ・実クリックE2E
   確認済み。

詳細は[open-redmine/CLAUDE.md](open-redmine/CLAUDE.md)の2026-08-01付
HANDOFF各エントリ参照。

### 次回再開の起点

- GitHub側Webhook登録(ユーザー操作待ち、上記2.)
- 他のGUIを持つリポジトリ(`rs-link-fusion`等)への「省機能+省メモリ版」
  展開(`open-raid-z/CLAUDE.md`の段階的着手方針)

## 2026-08-01 チェックポイント(open-redmine続き)

前回チェックポイント以降、`open-redmine`は単独でさらに進んでいた
(GitHubリポジトリ連携機能を追加、commit `4fdd9c6`)。今回のセッションは
その「次にすべきこと(2)」——GitHubコミットの参照チケットバッジを
クリック可能にする対応を実施・commit・push済み(`f5d656d`)。
詳細は[open-redmine/CLAUDE.md](open-redmine/CLAUDE.md)の
「2026-08-01」HANDOFFエントリ参照。

### 次回再開の起点

**[open-redmine/CLAUDE.md](open-redmine/CLAUDE.md)の「2026-08-01」
エントリ**から再開すること。次にすべきこと:
1. 本番(`easy-web.tokyo/open-redmine`)へのデプロイ+バッジクリックの
   実ブラウザE2E(このセッションでは未実施)
2. GitHub連携のWebhook受信によるリアルタイム更新(将来検討)
3. インストーラー(`install.sh`/`install.ps1`)自体がopen-redmineに
   まだ存在しない——電源プロファイル選択機能(省電力/省メモリ/常時電源
   接続、エコシステム全体の標準方針、詳細は
   [open-raid-z/CLAUDE.md](open-raid-z/CLAUDE.md)参照)の前提として
   先にインストーラー本体を新設する必要がある
4. 「省機能+省メモリ版に切替」ボタン(`open-easy-web`で先行実装済みの
   パターン)のopen-redmineへの展開はまだ未着手

## 2026-07-31 チェックポイント(open-redmine集中セッション)

### 直近でpush済みの変更(すべて`open-redmine`)

このセッションはユーザー指示「Redmine本家と違って対応していない機能を
open-redmineにも対応させて」「見た目の細部も本物に近づけて」「どんどん
一般的なチケット一覧の構成に近づけて」に沿って、`open-redmine`1リポジトリ
に集中して以下を実装・commit・push済み:

1. カスタムフィールド(`Project.custom_field_defs`+`Ticket.custom_fields`)
2. 保存済みクエリ(`src/saved_queries.rs`、個人用のみ)
3. 名前付きロールプリセット(`access::RolePreset`: Manager/Developer/Reporter)
4. ガントチャート・カレンダーGUI(`web/`、進捗%オーバーレイ付き)
5. スケジュール(開始日・期限日)・進捗率の入力/編集UI新設
6. チケットステータス`resolved`追加(担当者割り振り→resolved→closedの
   遷移を実HTTPで確認)
7. `web/`側の英語(日本語)併記を徹底(placeholder・動的エラーメッセージ約20箇所)
8. チケット一覧をRedmine本家に近いテーブル形式へ刷新(色分けバッジ・
   進捗バー・期限超過赤字表示)
9. 優先度(Priority、Low/Normal/High/Urgent/Immediateの5段階)フィールド追加
10. `created_at`/`updated_at`追加、一覧に更新日列+更新日降順の既定ソート
11. カテゴリ(Category)フィールド追加(`Project.category_defs`+
    `Ticket.category`、値の検証あり)

メインクレート`cargo test`: 81→85件、全green(回帰なし)。`web/`側
`cargo test`: 4件全green。各段階でwasm32リリースビルド+実バイナリでの
`curl`/DOM確認を実施(詳細・commit hashは`open-redmine/CLAUDE.md`の
2026-07-31付けHANDOFF各エントリ参照)。

**正直な開示**: このセッション環境のブラウザ拡張によるfetch計装が
原因で、実クリック操作でのフルE2E(ログイン→操作→表示確認)は行えず、
DOM直接注入によるレンダリング確認+curlによるAPI往復確認に留まった。

### 次回再開の起点

**[open-redmine/CLAUDE.md](open-redmine/CLAUDE.md)の「2026-07-31(続き4)」
カテゴリ追加のエントリ**から再開すること。次にすべきこと:
1. プロジェクトの`category_defs`/`custom_field_defs`管理画面
   (現状いずれもAPIのみ、web側UI未実装)
2. 一覧テーブルの列クリックによるソート機能
3. 本番(`easy-web.tokyo/open-redmine`)へのデプロイ+実クリックE2E
   (このセッションで未検証だった範囲)
4. 保存済みクエリ・ロールプリセットのweb側UI(現状APIのみ)

## 2026-07-29 チェックポイント

### 直近でpush済みの変更

- **aruaru-llm**: モデルカタログ・ホットスワップ機能
- **open-redmine**: 担当者フィールド・プロジェクトマネージャーロール・
  storageバックエンド修正
- **open-easy-web**: 分散同期・ディザスタリカバリ機能
- **open-raid-z**: SFTPホスト鍵TOFU検証
- **open-directx**: グラデーション補間・GPUベンダー診断・チェーン
  sub/div対応
- **aruaru-db**: Tauri Admin GUIのビルド不能状態解消

### 次回再開の起点

**[rs-sync/CLAUDE.md](rs-sync/CLAUDE.md)の「HANDOFF追記(2026-07-29続き5)」
フォルダ同期(SFTP)+通知機能+ハートビート横展開**から再開すること。
次にすべきこと:
1. 実SFTPサーバーでのフォルダ同期の実機検証
2. 実トークン期限切れシナリオでの通知メール実地確認
3. open-easy-webの`uninstall.ps1`(Windows版)が未作成
   (`install.ps1`のみ既存、`uninstall.sh`はLinux版のみ新設済み)

### 未コミット作業の確認・commit済み(2026-07-29)

前回チェックポイント時点で残っていた2件のローカル変更は、内容確認
(既存コードの削除ゼロ・純粋な追加のみと確認)・ビルド/テスト確認の上、
commit・pushした:
- `open-redmine`: チケット添付ファイルのアップロード/ダウンロード/削除API
  (`src/attachments.rs`新規+`src/main.rs`にハンドラ・ルート追加)。
  `cargo build`成功を確認。(`e9c55c0`)
- `open-raid-z`: ストライプ整列済み書き込みでRMWの読み出しを省略する
  高速パス(`pool.rs`)+検証テスト(`tests/unaligned_io.rs`)。該当テスト
  8件全green。(`1586497`)

### 参照

- プロジェクト自動認識: [runo-scan.txt](runo-scan.txt) / [runo-scanner](runo-scanner)
- 開発方針の正本: [open-raid-z/CLAUDE.md](open-raid-z/CLAUDE.md)
