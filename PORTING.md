# PORTING.md(RUNO、旧称: open-aruaru-runo-iLumi → aon)

このリポジトリは`aon-co-jp`エコシステム全体の**メタ索引**であり、
移植対象となる実装コード・お引越し可能な機能を一切持たない
(ローカル作業ドライブは`F:\runo`)。

他プロジェクトの`PORTING.md`(お引越し可能ファイル一覧)への入口は、
[`README.md`](README.md)の一覧表から各プロジェクトへ辿ることができる。

移植可能な資産が生じた場合(索引生成補助スクリプト等)、この節を更新する。

---

## 2026-09-01(続き2) チェックポイント(open-cuda + aruaru-llm + open-english: Attentionスキップ軽量パス実装 + 「open-cudaは必須の相方」明文化)

**背景**: 直前チェックポイント(d631cf1)の「未着手・次回検討候補」に
明記されていた **open-cuda + aruaru-llm + open-english の3リポジトリに
またがる開発** ——「線形アダプタ折りたたみで潰した層のAttentionを、
出力をゼロで捨てるだけでなく推論時に丸ごとスキップする軽量パス」——を
実装した。あわせてユーザー指示「aruaru-llmを使うリポジトリは全て
open-cudaも一緒にSETUPすべきことを日英で明記、またはインストーラー
同梱」へ対応した。

### 実施内容

1. **Attentionスキップ軽量パス(3リポジトリスライス)**:
   - **open-cuda**(`crates/open-cuda-llm/src/lib.rs`、正本): `DecoderLayer`
     へ`skip_attention: bool`(既定`false`、`linear_adapter`のみ`true`)。
     `forward_step`/`forward_prefill`が`skip_attention`時にln_1・QKV射影・
     softmax・P·V・attn_out・KVキャッシュpushを一切実行せず残差だけを
     FFNへ渡す。`linear_adapter`の`qkv`/`attn_out`はゼロ出力なので
     **ビット単位で数値等価**(生成トークン列が1トークンも変わらない)。
     `AdapterFoldReport`へ`attention_compute_skipped: bool`追加。
   - **aruaru-llm**: `FoldResult`/`FoldLayersResponse`へ
     `attention_compute_skipped: Option<bool>`(線形アダプタ版のみ
     `Some(true)`)、`POST /v1/models/fold-layers`レスポンスへ反映、
     disclosure文(日英)更新。
   - **open-english**: `index.html`のfold-layers開示文へ日英併記で追記、
     `app.js`がレスポンスの新フィールドをステータス欄へ表示。
   - **検証**: open-cuda `cargo test -p open-cuda-llm --release --
     --test-threads=1` **35件全green**(新規bitwise等価テスト
     `linear_adapter_attention_skip_is_bitwise_identical_to_computing_zeroed_attention`
     ——skip有無で`generate()`出力がバイト完全一致することを確認)。
     aruaru-llm `cargo test --release -- --test-threads=1` **101件全green**。
     open-english `node --check` OK + 実ブラウザで白画面なし・新開示文が
     DOMに存在を確認。
   - **残課題**: skip版の実速度向上幅(CPU/GPU実測)は未取得——
     open-cuda側に`--ignored`ベンチ
     `manual_bench_attention_skip_vs_computed_zeroed_attention`を用意済み、
     次回開発機で実行。

2. **「open-cudaは必須の相方」明文化**: 調査の結論——**open-cudaは
   `aruaru-llm`バイナリへ静的リンクされるため別途同梱・別プロセス
   起動は不要**。`fetch-aruaru-llm.ps1`/`.sh`が取得するリリース済み
   `aruaru-llm`実行ファイルに`opencuda-*`(GEMM・Attention・GPT-2
   デコーダ・埋め込み・音声認識)が既に含まれる。ソースからビルドする
   場合のみ隣に`open-cuda`のcloneが必要(CIは`release.yml`が自動clone)。
   Vulkan/DirectX GPUバックエンドだけは`aruaru-llm`側のGPUビルド
   (`installgpu`タスク、既定オフ)使用時のみ有効。
   `aruaru-llm/README.md`・`README-English.md`に「open-cudaは必須の
   相方(SET)」節を新設(正本)、`open-english/installer/{windows,unix}/
   fetch-aruaru-llm.{ps1,sh}`のコメントにも日英併記で追記。

### 次にすべきこと

1. 稼働中の`aruaru-llm`がある環境で、open-englishのfold-layersボタン→
   レスポンスの`attention_compute_skipped`表示の実HTTP検証。
2. skip版の実速度向上幅の実測(`open-cuda`側`--ignored`ベンチ、
   NVIDIA GT 730の開発機で)。
3. 前回チェックポイントの残課題(2)(高性能統合GPUでの再実測)、(3)
   (日本語較正データの品質定量評価)は引き続き未着手。

### コミット

- open-cuda / aruaru-llm / open-english / RUNO(本チェックポイント)。

---

## 2026-09-01 チェックポイント(open-cuda + aruaru-llm + open-english: Model Folding残タスク4項目完了、セッション末尾のため記録)

**背景**: 直前セッションで実装した「Model Folding」(層冗長性検出+
実際の層折り畳み、3手法: 独立閾値/連続ブロック探索/線形アダプタ)に
ついて、ユーザーから明示された4つの未着手タスクへ対応した。

**実施内容(全4項目、実機検証済み)**:

1. **`ridge_lambda`外部化**: `open-cuda`側`fold_block_with_linear_
   adapter`に`ridge_lambda: Option<f32>`引数を追加、`aruaru-llm`側
   `POST /v1/models/fold-layers`のリクエストパラメータ経由で調整
   可能に。非有限・非正値は`ensure!`で拒否。テスト実行・pass確認済み。
2. **open-english UIボタン**: `index.html`/`app.js`に`fold-layers`を
   実際に呼ぶフォーム+ボタンを実装。稼働中aruaru-llmサーバー
   (`127.0.0.1:4601`)へ実HTTPリクエストを送り、`ridge_lambda_used`が
   正しく反映され折りたたみ前後とも自然な英文が生成されることを確認。
3. **GPU実測**: 実機(NVIDIA GT 730)でVulkan/DirectX経由のベンチマーク
   を実際に実行(`--ignored`テスト)。結果: CPU 1.96〜2.07秒に対し
   DirectXは4.0〜4.6秒(約2倍遅い)、Vulkanは32〜44秒(約17〜22倍遅い)
   ——GPUの方が明確に遅いという結果を誇張せずそのまま記録した。
4. **多言語較正**: 英日中仏独西6言語の較正プロンプトを新設し、fold系
   3関数の既定較正データへ配線。日本語プロンプトを含む較正データで
   実GPT-2重みの折りたたみを実行し、クラッシュしないことを確認
   (品質が英語と同等とまでは主張していない——語彙が英語中心のBPE
   トークナイザのため)。

**注意点**: このセッションでは並行して複数のバックグラウンドエージェント
を起動しており、うち何回かは「エージェントを起動しました」という空虚な
報告のみでツール呼び出し1回・実質作業ゼロのまま終了する不具合が発生した
(委任を繰り返す再帰的な問題)。「委任するな、自分で直接ツールを使え」と
明記した指示でようやく実質的な作業に至った。今後同様の作業を依頼する際は、
この失敗パターンを踏まえて指示すること。

**コミット**: open-cuda `b6e8c3b`、aruaru-llm `071a50a`、open-english
`1bfbed2`(いずれもpush済み、日英併記でCLAUDE.mdに記録)。

**残課題**: (1) Attentionサブ層を完全スキップする軽量パスは未実装、
(2) より高性能な統合GPU(過去実測のAdreno 619等)での再実測は該当
ハードウェアが無く未検証、(3) 日本語較正データでの生成品質の定量評価
(現状は「クラッシュしないこと」の確認止まり)。

---

## 2026-08-29 チェックポイント(open-english + aruaru-llm: AI音声認識(ASR)精度の抜本改善、セッション末尾のため記録)

**対象リポジトリ**: `open-english`(branch `master`、集中)、`aruaru-llm`
(branch `main`、`POST /v1/transcribe` 新設)。関連参照のみ:
`open-directx` / `open-cuda` / `open-cpu`(既存の推論基盤、今回コード変更なし)。

**正本**: `open-english/docs/SPEECH_RECOGNITION_REDESIGN.md`(英日・多言語で
Google/GitHub 調査した結果 + 3 フェーズ設計 + 試作駆動の進め方 + 受け入れ
基準)。各リポジトリの詳細は `open-english/CLAUDE.md` / `aruaru-llm/CLAUDE.md`
の 2026-08-29 HANDOFF。

### 到達点

- **P1(クライアントのみ・新規依存ゼロ、`open-english/app.js`)= 実装済み**:
  P1-α `speechLangTag()`(BCP-47 言語タグ、ja/en 固定を廃止)、
  P1-β `refineTranscript(alts, langTag)`(n-best → 1 回の LLM 訂正、
  空/過長は却下して 1-best へ)、P1-β2 `lastTrainerUtterance()`(直前
  トレーナー発話で contextual biasing)、P1-γ `speechTranslationHelper()`
  (話した内容を母国語へ翻訳して補助表示)。
- **P2-α(ブラウザ内 Whisper、transformers.js)= 実装済み**: 実行段
  カスケード WebGPU → WebNN(npu/gpu/cpu)→ WASM(スレッド数は
  `/v1/cpu-runtime` = open-cpu ヒント)。マイク押下で Web Speech API と
  `MediaRecorder` を並行起動、認識終了時に Whisper 候補 + Web Speech
  n-best を融合。モデル/ランタイムは `fetch-whisper-model.ps1` +
  `whisper-model-installer.exe` + `server` の `maybe_fetch_whisper_model()`
  で同一オリジン配信。未配置なら静かに無効化 → Web Speech API 単独
  (回帰ゼロ)。
- **2026-08-29 多言語再調査を反映**: transformers.js の dtype 落とし穴
  (WebGPU + q8 デコーダは出力が壊れる)→ **fp32 encoder + q4 decoder の
  ハイブリッド**へ修正。tfjs は 3.8.1 固定(v4-next はタイムスタンプ
  回帰)。幻覚対策の `condition_on_previous_text:false` 等を追加。
- **P2-β(`aruaru-llm` の `POST /v1/transcribe`)= ✅ 完了(方針変更込み)**:
  `whisper-rs` 直リンクは Windows/MSVC ビルド不能(`0.16.0` でも
  `WHISPER_DONT_GENERATE_BINDINGS=1` でも解消せず、issue 2026-04-21)→
  **whisper.cpp のプレビルド CLI(`whisper-cli`)を子プロセス起動**する
  方式へ全面書き換え(`pg_dump` / `adb` と同じ)。Cargo feature 撤去。
  `is_available()` = `cli_present && model_present` の実行時判定。
  `cargo test --release` **100 passed / 1 ignored**。実 CLI + 実 GGML
  での E2E のみ未達。
- **P2-α を VPS 本番(`easy-web.tokyo/open-english/`)へ実配信・実ブラウザ
  検証済み**: Linux 用 `installer/unix/fetch-whisper-model.sh` 新設、
  ORT は jsep 統合ビルドのみ、`app.js` の vendor/model パスをアプリの
  ベース(`/` or `/open-english/`)からの相対に。`open-english-server`
  再ビルド・再起動、モデル配信ルート全 200、`loadWhisperModule()` 成功。
- **P2-γ(`open-english`)= ✅ 3 経路融合を配線済み**: `serverTranscribeBlob()`
  新設。可否は `lastRuntimeInfo.whisper`(`GET /v1/runtime`)で判定、
  到達不可なら静かにスキップ。`finalizeVoiceInput()` が
  `Promise.all([whisperTranscribeBlob, serverTranscribeBlob])` で並行実行し
  `serverAlts.concat(whisperAlts).concat(speechAlts)` を `refineTranscript()`
  へ。VPS 配信済み、実ブラウザで関数定義・f32→base64 往復を確認。
- **付随のサービス向上(ユーザー確認の上)**: (a) HTTPS 配信時に
  aruaru-llm の平文 HTTP プローブをやめ Mixed Content エラーを解消
  (実ブラウザで消失を確認)、(b) VPS の `open-english.service` の平文
  SMTP パスワードを `/etc/open-english.env`(mode 600)+ `EnvironmentFile=`
  へ移設(`systemctl cat` に出なくなった、`request-otp` が `{"sent":true}`
  で SMTP 継続動作を確認)。

### 到達点(続き、2026-08-29 セッション後半)

- **P2-γ VAD = ✅ 2 段実装済み**(`open-english/app.js`):
  - 第一段 `trimSilenceVad()`(依存ゼロ・DLゼロの RMS ベース、30ms/10ms
    フレーム、適応しきい値でトリム)。VPS 実ブラウザで 3s 合成音→1.44s 確認。
  - 第二段 `sileroVadTrim()` = **Silero VAD(ONNX v5、`onnx-community/
    silero-vad` ~2.2MB)**。transformers.js は `InferenceSession` を公開
    しないので standalone `onnxruntime-web@1.22.0`(非 jsep wasm 一式)を
    `/vendor/ort-vad/` へ**完全隔離**して vendor。512 サンプルごとに発話
    確率 → ヒステリシス + 最小発話長 + ギャップ連結で発話区間へまとめ
    **内部の無音も落とす**。`vadTrim()` = Silero → RMS フォールバック
    (必ず有効 PCM、回帰ゼロ)。**VPS 実ブラウザ検証**: セッションロード
    849ms、I/O 名自動検出(`input`/`state`/`sr`→`output`/`stateN`)、
    推論 89ms/3s、合成音は非発話と正しく判定(誤検出なし)。
- **P2-β contextual biasing = ✅**: `/v1/transcribe` に `prompt` フィールド
  (`aruaru-llm`、末尾1000字に切詰 → `whisper-cli --prompt`)。`open-english`
  の `serverTranscribePcm()` が `lastTrainerUtterance()` を送る。
- **評価ハーネス(§5)= ✅ 実装済み**: `open-english/tools/asr-bench/wer.mjs`
  (依存ゼロ Node、`--ref`/`--hyp`/`--keywords`/`--md`。NFKC 正規化 →
  語 or 文字 Levenshtein、`lang`+空白率で CJK 自動判定、kw-recall =
  R-WER 近似、`missing` = 取りこぼし数、言語別内訳。自己テスト済み)+
  `split-bench.mjs`(`window.__asrBench` → `hyp-*.jsonl`)+ `app.js` の
  `localStorage["openEnglish.asrBench"]="1"` ダンプ + `docs/asr-eval/`
  (README・`refs.example.jsonl`・`keywords.example.jsonl`・`.gitignore`)。

### 次にすべきこと(他アカウントでの再開ポイント)

1. **実機 E2E(最優先、実マイクが要る)**: `open-english` をブラウザで開き
   `localStorage.setItem("openEnglish.asrBench","1")` → 各発話を話す →
   `copy(JSON.stringify(window.__asrBench))` → `split-bench.mjs` →
   `wer.mjs --md` で WER/CER を出し `docs/asr-eval/README.md` の結果ログへ。
   同時に、利用者 PC へ プレビルド `whisper-cli` + `ggml-base.bin` を置いて
   `POST /v1/transcribe` の実書き起こしと Silero の実発話セグメント抽出を確認。
2. **Moonshine を低遅延エンジン候補に**(`open-english`): 27M・量子化 ONNX
   ~50MB、日本語版 `moonshine-tiny-ja-ONNX` あり。Whisper より軽速。
   `getWhisperPipeline()` 相当を Moonshine 用に足し、融合リストへ 4 本目として。
3. **P3(`aruaru-llm`)**: Parakeet-TDT-0.6B-v3 / Canary-1B-v2 / Omnilingual
   ASR を `/v1/transcribe` の選択可能エンジンに(`whisper-cli` と同じ
   「プレビルドバイナリを子プロセス」パターンで)。評価は Open ASR
   Leaderboard(多言語 + long-form)を `docs/asr-eval/` 基準に。

### コミット(すべて push 済み)

- `open-english@master`: `c26d7ca`(P2-α)→ … → `6671dde`(P2-γ 3 経路融合)
  → `571c8de`(評価ハーネス)→ `1eeef9f`(RMS VAD + PCM 一回デコード)→
  `da8d960`(Silero VAD)→ `2f85996`(standalone ORT loader)→ `3310bd4`
  (ORT を非 jsep で完全隔離)→ `6914a0a`(Silero VPS 検証記録)→ `ec28ffa`
  (serverTranscribePcm が prompt を送る)。
- `aruaru-llm@main`: `78a85e3`(P2-β API)→ … → `24bcfd1`(**方針変更実装** =
  whisper-cli 子プロセス、feature 撤去、100 テスト)→ `4e9ddb4`(README/
  CLAUDE/PORTING を CLI 方式へ)→ `b98b928`(`/v1/transcribe` に `prompt`)。
- `RUNO@main`(旧 runo): 本チェックポイント。
- **VPS(easy-web.tokyo)反映済み**: `/root/easy-web.tokyo/open-english` を
  最新へ、`open-english-server` 再ビルド・再起動、Whisper モデル + ORT +
  Silero VAD + vendor 一式を配信(全ルート 200)。`aruaru-llm` は利用者 PC
  側で動く設計のため VPS には配置しない(コードは GitHub 上)。

---

## 2026-08-29 チェックポイント(aruaru-db: REST 完全撤廃 P3 本体 + 付録A「2026最新設計」再構成、並列セッションで実施)

**対象リポジトリ**: `aruaru-db`(branch `main`)。**この ASR セッションと
並列**でバックグラウンドエージェントが実施。再開起点は
`aruaru-db/CLAUDE.md` 冒頭「🛑 復活用メッセージ」+ HANDOFF「続き10」、
正本は `aruaru-db/docs/CONTROL_PLANE_REDESIGN.md`。

### ユーザーの不変要求(逸脱禁止)
①SET 全体から REST を例外なく完全撤廃・中途半端禁止 ②RPoem は
WunderGraph Cosmo 互換・API キー完全自動ライフサイクル ③CockroachDB×
Snowflake ハイブリッド変種(TiDB 等、**関連全て**)の実装理論・技術を
取り込む ④世界中の言語で再調査し実用的になるまで再設計・再実装・
再テストを反復。**実装 P3 より ③ の調査・再設計を優先**。

### 到達点(push 済み `origin/main` `23ff114..250956d`)

- **③④ = ✅ 完了**: 英日独露中で 15 検索(一次論文・公式 doc・GitHub)。
  `docs/CONTROL_PLANE_REDESIGN.md` 付録 A を **59 → 約480行**へ全面再構成。
  TiDB/TiKV+TiFlash(DeltaTree=B+木×LSM、FFI push、**read-index SI 検証
  アルゴリズム**)・CockroachDB(Range/HLC/Pebble/closed ts/protected ts、
  MVCC range key)・YugabyteDB(DocDB/IntentsDB)・Snowflake(不変16MB
  マイクロパーティション/pruning/time travel)・**Neon vs Aurora**
  (safekeeper Paxos `flushLsn[n-quorum]` / pageserver materialize)・
  SingleStore(Universal Storage 5機能)・ClickHouse(MergeTree granule /
  **SharedMergeTree + Keeper**)・Iceberg/Delta/Hudi/**Paimon・Fluss**
  (deletion vector の RoaringBitmap レイアウト、MoR、record-level index、
  merge engine)・Photon/DuckDB(FSST/ALP、adaptive kernel 選択)を
  **実装方法(アーキ/データ構造/アルゴリズム)まで**、出典 URL 併記。
  取り込み判断を明記: **取り込む** = HLC(アルゴリズム明記)/
  **Raft-Learner 上の行→列非同期変換レプリカ(本命、`ColumnarApplier` 案)** /
  read-index+MVCC SI 検証 / deletion vector+MoR(段階的)。**条件付き保留**
  = 型認識軽量圧縮。**取り込まない(理由明記)** = Aurora 型モノリシック
  ストレージ。A.7 に `aruaru.yaml: htap` セクション案 + execution-config
  配布案、A.8 に「2026 業界の現実(単一エンジン HTAP は専用OLTP+専用
  OLAP+CDC に対しシェアを取れていない)」。
- **① P3 本体 = 3/5 群完了**: `closed-timestamp` / `wal-service` /
  `sharded-store` を GraphQL 化し REST 撤廃(`admin.rs` からルート・
  ハンドラ・構造体7個・`now_nanos()` 削除、`AdminCtx` へ `Arc` 注入 =
  `object_table`/`keyring` と同一パターン、safekeeper 列挙 off-by-one
  是正)。**着手前に grep で Tauri/Android/web クライアントの当該 REST
  参照が皆無なことを確認**。タイムスタンプ・LSN は GraphQL では String。
  `/closed-timestamp/{receive,publish}` は B4(ノード間 side transport、
  既にバイナリ)として残置。
- **次スライスへ(技術的理由を doc §8 P3・CLAUDE.md 続き10 に明記)**:
  `ephemeral-query`(`current_exe()`+`Command` で自プロセス再起動する
  `aruaru-server` バイナリ固有 → `Arc<dyn EphemeralRunner>` trait 注入が
  必要)、`multi-raft`(`MultiRaftCluster<crate::cluster::EngineApplier>`
  が server-local ジェネリック → trait object 化 or applier のクレート
  移設が必要)。状態注入だけで済んだ 3 群とは規模が別、というのが
  「回した」理由。
- **検証**: `cargo build --release -p aruaru-graphql -p aruaru-server`
  成功(11分17秒、既存 `build_cluster`/`propose_commit` の 2 警告のみ)。
  `cargo test -p aruaru-dist -p aruaru-graphql -p aruaru-server` 失敗 0
  (72 + 16 + 13、**新規 3 テスト**が closed_timestamp / wal_service /
  sharded_store を GraphQL だけで完結させ共有状態への実読み書きを検証)。
- **README.md / README-Japan.md / README-English.md / PORTING.md §7 /
  CLAUDE.md** を日英で整合。

### 続き(2026-08-31、別アカウント/別セッションで再開・完了分)

1. ✅ **実プロセス HTTP E2E**: 実 `aruaru-server` を起動し
   `closedTimestamp`/`walService`/`shardedStore*`/`selfIssueKey` を
   `/graphql` へ実 HTTP で確認、旧 REST パスが正しいトークン付きで
   実際に `404`(トークン無しの `401` に惑わされないことも確認)。
2. ✅ **`ephemeral-query` の GraphQL 化**: `EphemeralRunner` trait +
   型を `aruaru-dist::ephemeral` へ移設(`admin_shared.rs`/
   `keyring.rs`と同パターン)、`ProcessEphemeralRunner`
   (`aruaru-server`)が実装、`Mutation.ephemeralQuery`新設。実プロセス
   E2E(federatedQueryでテーブル作成→ephemeralQueryが実際に子プロセス
   を起動しSELECT結果を返す)まで確認済み。commit `c30a6b5`→`8bfec95`。
3. ✅ **`multi-raft` の GraphQL 化(P3 本体、最終スライス)**:
   `EngineApplier`を`aruaru-server::cluster`から`aruaru-dist::
   engine_applier`へ移設し、`aruaru-graphql`が`MultiRaftCluster
   <EngineApplier>`を具体型のまま共有(trait object化は不要と判明)。
   `Query.multiRaftScatterQuery`・`Mutation.multiRaftSplit`/
   `multiRaftMerge`新設。実プロセスE2E(split→scatter→merge の
   range数遷移1→2→1を実HTTPで確認、旧REST`/admin/multi-raft/*`は
   トークン付きで404)まで確認済み。commit `afb4826`。
   **これでP3本体(closed-timestamp・wal-service・sharded-store・
   ephemeral-query・multi-raft)が全て完了**。

### 続き2(2026-08-31、要求③実装トラック着手・完了分)

4. ✅ **A.6-1 HLC**: `aruaru-dist::hlc`(CockroachDB/Spanner方式、物理+
   論理成分をAtomicU64へパックしCASループでロックフリー実装)。9テスト
   全green(並行呼び出しでの重複無し検証込み)。`closed_ts`等への実配線は
   未実施。commit `c806846`。
5. ✅ **A.6-2 ColumnarApplier(本命)+ 実プロセス配線**: TiFlash型HTAPの
   核心=Raft-Learner上の行→列非同期変換レプリカ。`Applier` trait実装
   (行ストアミラー適用+テーブル全体を`table_format`〈Databend方式〉の
   blockへ列変換してcommit、min/max統計+主キーbloom filter)。
   `--columnar-learner`起動フラグを新設し、**実際にleader/columnar-
   learnerの2プロセスを起動し、CREATE TABLE→INSERT→UPDATEの各commitが
   binary Raft経由で別プロセスの列レプリカへ反映されることを実HTTPで
   確認**(replicationCount/snapshotIdの遷移、誤トークンでの401)。
   commit `56ef06c`→`27be65c`。
6. ✅ **A.6-4段階1 deletion vector + 枝刈り配線**: `BlockMeta.
   deletion_vector`(Delta Lake方式の論理削除、`BTreeSet<u64>`)。
   `with_deleted`/`is_deleted`/`live_row_count`。**`prune_range`/
   `prune_equality`が全行削除済みblockを実際に読み飛ばすよう配線**
   (「宣言しただけ」で終わらせず読み取り側を完成)。旧block JSONとの
   `serde(default)`後方互換込み、計8テスト。commit `b6aaaac`→`84b321e`。
   **残る配線**: `ColumnarApplier`の書き込み側からdeletion vectorを
   呼ぶ経路(A.6-4段階2 Merge-on-Reseへ格上げ時)。

### 次にすべきこと(aruaru-db、他アカウントでの再開ポイント)

1. A.6-4段階2(base+deltaのMerge-on-Read、`ColumnarApplier`をdelta蓄積
   方式へ格上げ)、HLCを`closed_ts`/`wal_service`/`multi_raft`へ配線、
   `aruaru.yaml: htap`セクションの実装(§5・A.7、この際`--columnar-
   learner`を宣言的設定経由の起動へ統合することも検討)。
2. `disaster_backup.email` reconcile(feature ゲート)、Tauri/Android/web
   の残りクライアント移行、P4(`admin_routes` 撤去 + `/raft/*` バイナリ化)。

### コミット(push 済み `origin/main`)

`6e5b3e0`(付録A 2026最新設計へ全面拡充)→ `efeebab`(**P3 本体** 3 群
GraphQL 化・REST 撤廃 + 日英ドキュメント整合)→ `33ae605`(付録A: 中国語
一次資料 / Paimon・Fluss)→ `250956d`(付録A: HLC アルゴリズム・Photon
adaptive execution)→ `c30a6b5`(続き11: 実プロセスHTTP E2E完了)→
`8bfec95`(続き12: ephemeral-query GraphQL化・REST撤廃)→
`afb4826`(続き13: multi-raft GraphQL化・REST撤廃、P3本体完了)→
`c806846`(続き14: A.6-1 HLC実装)→`56ef06c`(続き15: A.6-2 ColumnarApplier
本体)→`27be65c`(続き16: ColumnarApplier実プロセス配線・実HTTP検証)→
`b6aaaac`(続き17: A.6-4段階1 deletion vector)→`84b321e`(続き18: prune
系APIへのdeletion vector配線)。**VPS未反映**
(次回`git pull`で`8bfec95`まで追従させること)。

---

## 2026-08-29 チェックポイント(aruaru-db 管理面の抜本再設計、セッション末尾のため記録)

**対象リポジトリ**: `aruaru-db`(集中)、`RPoem`(SET の相方、次フェーズ P5 で本格関与)。

**到達点**: aruaru-db の `/admin/*` REST を**完全撤廃**する抜本再設計に着手。
「REST を 1 本ずつ GraphQL mutation へ」は *稼働中プロセスの生状態をフィールド
単位でライブ書き換えするアンチパターン* の移送にすぎない、というユーザー指摘を
受けた方針転換。正本の設計文書
[`repository/aruaru-db/docs/CONTROL_PLANE_REDESIGN.md`](repository/aruaru-db/docs/CONTROL_PLANE_REDESIGN.md)
を新設(設計哲学12か条・4バケツ仕分け・目標 HTTP 面・aruaru.yaml スキーマ・
フェーズ P0〜P6・付録 A=TiDB/TiFlash 調査・付録 B=REST 撤廃を可能にする
Cosmo の技術)。

進捗: P0(設計)/P1(宣言的設定基盤 `aruaru-server::config` + `--config` +
ホットリロード)/P2(`query.parallel` 4フィールド化、`follower_read.target_lag_ms`
完全ホットリロード)/P3 一部(`/admin/parallel*`・`/v1/keys/self-issue` 撤廃 →
GraphQL `explainDistributed`・`parallelJobs`・`selfIssueKey`)まで完了・push 済み。
各スライスで `cargo test` 失敗0。

**次回再開の起点**: **[repository/aruaru-db/CLAUDE.md](repository/aruaru-db/CLAUDE.md)
冒頭「🛑 復活用メッセージ」** をまず読む。P3 本体は `closed-timestamp` の
GraphQL 化から(`AdminCtx.closed_ts` 注入、`object_table`/`keyring` と同じ
パターン)。`wal-service`・`sharded-store` も同様。`ephemeral-query`・
`multi-raft` は trait 注入のリファクタが要る。

**ユーザーの不変の要求**: (1) SET(RPoem + aruaru-db)全体から REST API を
例外なく完全撤廃・中途半端禁止、(2) RPoem は Cosmo 互換で REST 不要・APIキー
完全自動ライフサイクル、(3) aruaru-db は CockroachDB×Snowflake ハイブリッド
変種の実在DB(TiDB 等)の技術を取り込む、(4) 必要なら多言語で再調査し
再設計・再実装・再テストを実用的になるまで数回繰り返す。

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

### 2026-08-28(続き) WEBサイト系8ドメインの実体を`/root/url/`側へ再配置

ユーザー指示「WEBサイトはリポジトリとは別です。ホームページやWEBサイトは
全てこの様に変更して」への対応。上記7分類のうち「ドメイン兼リポジトリ
(実体は`/root/repository/`、`/root/url/`は単なるsymlink)」としていた
8ドメインについて、**「WEBサイトとしての性質を優先し、実体を
`/root/url/`側に置く」**という設計へ変更した(gitリポジトリである
ことは副次的な属性、という位置づけ)。

- **変更内容**: `aon.tokyo`・`aruaru.tokyo`・`e-gov.info`・`fbi.tokyo`・
  `icpo.tokyo`・`karu.tokyo`・`nasa.tokyo`・`runo.tokyo`(+入れ子の
  `RS-Ops`)の8件について、実体を`/root/repository/<名前>`から
  `/root/url/<名前>`へ`mv`し、`/root/repository/<名前>`を
  `/root/url/<名前>`へのsymlinkへ変更した。旧`/root/<名前>`パスは
  変更していない(`/root/<名前>` → `/root/repository/<名前>` →
  `/root/url/<名前>`という2段のsymlinkチェーンとして、そのまま透過的に
  解決される——Linuxのパス解決はシンボリックリンクの多段チェーンを
  問題なく辿るため、既存のsystemdユニット等への影響は無い)。
- **手順**: 前回と同じ「1つずつサービス停止→`mv`→symlink再作成→
  起動→実際にTCPポートでlistenしているか確認」を徹底、全8件成功。
- **実HTTP検証**: 8ドメイン全て+`https://runo.tokyo/RS-Ops/`が
  実際に`200`を返すことを確認済み。
- **最終的な構成**: `/root/repository/<名前>`(gitリポジトリとしての
  参照、symlink)・`/root/url/<名前>`(WEBサイトとしての実体)・
  `/root/<名前>`(後方互換のためのsymlink、既存参照はそのまま機能)。
  この3者の役割分担が今回のセッションでの最終的な結論。

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
