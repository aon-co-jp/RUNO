# 開発方針＆開発環境ルール(aon、旧称: open-aruaru-runo-iLumi)

作業ドライブは`F:\open-runo`。この節は
[`open-raid-z`](https://github.com/aon-co-jp/open-raid-z)の`CLAUDE.md`を
**正本**とし、各プロジェクトへコピーして同期する既存の運用ルール継承方針に
準じる(比較的新しいフレームワークの参照資料一覧・AI駆動開発ツールに関する
所感・確認不要の自動継続/リミット解除後の自動再開・白画面バグ等を
見逃さない検証徹底、等の全リポジトリ共通ルールは、詳細をここに複製せず
`open-raid-z/CLAUDE.md`を参照すること)。

## このリポジトリの役割

**このリポジトリは`F:\open-runo`エコシステム全体のメタ索引であり、
個別のコード実装は持たない。** `aon-co-jp` organization配下に分散する
各プロジェクト(RCosmo/RFrontEnd/RPoem/aruaru-db/aruaru-llm/aruaru-tokyo/
audiocafe-tokyo-rust/audiocafe.tokyo/e-gov.info/karu.tokyo/open-cuda/
open-easy-web/open-raid-z/open-web-server/rs-to-readme等)への入口
(README・PORTING.md・CLAUDE.md・役割の要約)を、`README.md`に一箇所へ
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

## HANDOFF

- **2026-07-20 新規作成**: 空リポジトリとしてclone済みの状態から、
  README.md(全プロジェクト一覧、各`.git/config`のリモートURLで実在を
  確認したもののみ掲載)・本CLAUDE.md・PORTING.mdを新規作成。
  `aruaru-tokyo`側にも対応する索引ページ(`/open-aruaru-runo-iLumi`、
  エイリアス`/open-aruaru-runo`)を実装し、TOPページからリンクを追加した
  (詳細は`aruaru-tokyo/CLAUDE.md`のHANDOFF参照)。
  - 次にすべきこと: `poem-cosmo-tauri`等、ドキュメント上言及されるが
    ローカルドライブ上に実体(git clone)が確認できないプロジェクトが
    今後cloneされた場合、この索引にも追加する。
