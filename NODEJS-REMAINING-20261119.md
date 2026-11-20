# Node.js 全廃の洗い出し(2026-11-19、ユーザー指示「REST API・Node.js全廃、JSONはRS-JSON、二重使用しない」)

手元`F:\`のpackage.json(node_modules・作業コピー除く)を分類した。**これは調査結果であり、除去の完了ではない。**

## A. 除去済み
- `whisper.cpp`(fork `aon-co-jp/whisper.cpp`の`master`): `examples/addon.node`・専用CI・`CMAKE_JS_VERSION`分岐を削除。

## B. Node不要にできる(Rust/静的化で置換可、順次実施)
- `open-upstream-watch`: Playwright E2E(`scripts/e2e-ui.js`)のみがNode。Rust製ブラウザ試験(例: `fantoccini`/`thirtyfour`)へ置換する案。
- `Reaxt/clients/js`: JS向けConnectクライアント。ブラウザ側JSなのでNode実行は不要、`package.json`の扱い(削除またはWASM化)を判断。
- `2Poem/examples/django_proj`: 例のフロント(react・@wundergraph/sdk)。例を静的/Leptosへ置換。

## C. 製品の性質上Nodeが必須(判断待ち)
- VS Code拡張(`2FastAPI-VSC`・`open-vsc-claude`・`open-english*/vscode-extension`・`maid-cafe-programming-school`・`webeditor-sftp/vscode-extension`): VS Code拡張はNode.js上で動く規格。全廃=拡張の提供をやめるか、LSP等の外部Rustプロセス+最小の薄いJS(ビルド時のみ)に寄せる。
- Tauriの画面ビルド(`make-disk`・`open-media`・`open-bar/app`・`webeditor-sftp`・`aruaru-admin`): `@tauri-apps/cli`/vite はビルド時のNode。全廃=Rust製UI(Leptos/Dioxus)+`cargo tauri`(cargoのtauri-cli)への移行。

## D. JSONの二重使用の確認(未着手)
- 方針: JSONはRS-JSONに統一し、`serde_json`/`sonic-rs`/`nlohmann`との併用を避ける。`grep`で`serde_json`・`nlohmann`の併用箇所を洗い出す。whisper.cppの`examples/server`(httplib+nlohmann)は別作業。

## 次の手
B→D→C(判断後)の順。各リポジトリで置換後、テスト・push・VPS反映(自動)。
