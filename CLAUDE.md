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
audiocafe-tokyo-rust/audiocafe.tokyo/e-gov.info/karu.tokyo/open-cuda/
open-directx/open-easy-web/open-english(ジャンル: 学習/Study)/
open-raid-z/open-tv-chat/open-LiveKit/open-web-server/rs-to-readme等)への
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
