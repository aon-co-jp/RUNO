# 開発方針＆開発環境ルール(RUNO、旧称: open-aruaru-runo-iLumi → aon)

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
open-directx/open-easy-web/open-raid-z/open-web-server/rs-to-readme等)への入口
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

- **2026-07-20 (続き) open-directxを索引に追加、RUNOへ再改名反映**:
  ユーザー指示により`open-directx`・`open-cuda`・`aruaru-llm`を索引に含めるよう
  確認。`open-cuda`・`aruaru-llm`は既に掲載済みだったため対応不要。`open-directx`は
  ローカルドライブに実体(git clone)が無く、`git ls-remote`で疎通確認したところ
  GitHub上に空リポジトリとして存在するのみ(refなし)と判明したため、その旨を
  正直に明記した行を追加(内容が無いため役割は推測で埋めない)。
  また、このリポジトリ自体がユーザーにより`aon`→`RUNO`へ再度改名されたため、
  README.md/CLAUDE.md/PORTING.md内の自己参照リンク・表示名をすべて
  `aon-co-jp/RUNO`へ更新し、リモートURLも`git remote set-url`で切替・push済み。
  ローカルディレクトリ名`F:\open-runo\aon`は使用中のためリネーム未実施
  (実害なし、次回機会があれば`RUNO`へ変更する)。
- **2026-07-20 新規作成**: 空リポジトリとしてclone済みの状態から、
  README.md(全プロジェクト一覧、各`.git/config`のリモートURLで実在を
  確認したもののみ掲載)・本CLAUDE.md・PORTING.mdを新規作成。
  `aruaru-tokyo`側にも対応する索引ページ(`/open-aruaru-runo-iLumi`、
  エイリアス`/open-aruaru-runo`)を実装し、TOPページからリンクを追加した
  (詳細は`aruaru-tokyo/CLAUDE.md`のHANDOFF参照)。
  - 次にすべきこと: `poem-cosmo-tauri`等、ドキュメント上言及されるが
    ローカルドライブ上に実体(git clone)が確認できないプロジェクトが
    今後cloneされた場合、この索引にも追加する。
