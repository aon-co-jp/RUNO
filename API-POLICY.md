<!-- 正本: aon-co-jp 全リポジトリ共通の「API 方針」。各リポジトリの README / CLAUDE / PORTING へ、この節をそのまま(言語ごとに)載せる。2026-11-04 ユーザー決定。独語・露語は 2026-11-04 に自然な技術文書の言い回しへ推敲(ネイティブ確認前)。 -->

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

## 補足: ストリーミングの対応状況 (2026-11-07)

### 日本語
- **server-streaming は対応済み**(`RPoem` の `open-runo-connect-*`、RPoem main `1570371`・`34cb595`)。Connect は `application/connect+json` のエンベロープ、gRPC / gRPC-web でも受ける。途中エラーは終端フレームで返し、件数・時間の上限、切断時の資源解放、実 TCP での `WatchEvents` 試験を通過。**VPS には未反映**。
- **使いどころ**: 変更の監視、進捗の逐次通知、長い生成の逐次返却など、サーバーから複数回返したい所。1回で済む呼び出しは従来どおり Connect の単純呼び出し。client-streaming / 双方向は、必要になってから。
- 独語・露語は未追記(日英のみ)。

### English
- **Server-streaming is supported** (`open-runo-connect-*` in RPoem, main `1570371` / `34cb595`): `application/connect+json` envelopes, also via gRPC / gRPC-web; mid-stream errors end with a terminal frame; item/time limits, resource release on disconnect, and a real-TCP `WatchEvents` test pass. **Not yet deployed to the VPS.**
- **When to use**: watching changes, progress updates, incremental results. One-shot calls stay plain Connect unary. Client-streaming / bidirectional only when needed.
- German and Russian not yet added.


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

## 2026-11-25 追記: Versionless API(バージョンを持たないAPI)の方針 / Versionless API policy

### 日本語
- **決定(2026-11-25、ユーザー指示)**: すべてのリポジトリで **Versionless API** の考え方を採る。URL・パッケージ名に `v1`・`v2` を付けず、**互換性を壊さずに足していく**。
- **決まり**
  1. **足すだけ**: 新しい操作・新しい欄を足す。既存の欄の意味を変えない・消さない・必須にしない。
  2. **受け取る側は寛容に**: 知らない欄は無視する(エラーにしない)。欄が無いときは既定値を使う。
  3. **やめるときは段階的に**: 古い操作や欄は「非推奨」と記録し、ログで使用が0になったことを確かめてから消す。期限は明記する。
  4. **新しいAPIのパッケージ名に版を入れない**(例: `rs_ops.Accounts/List`)。
  5. **どうしても壊す変更が要るときは、新しい名前の操作を足す**(例: `ListV2` ではなく、意味の分かる別名)。旧は上の3の手順で畳む。
- **既存への適用**: すでに `.v1` を含む既存のパッケージ名(`rs_blog.v1`・`rs_ec.v1`・`open_runo.admin.v1` など)は、**呼び出し側を壊さないため当面そのまま**にする。版なしの別名を**追加**して両方受け、使用が移ったあとで `.v1` を畳む(上の3)。新規と RS-Ops は最初から版なし。
- **正直な注意**: これは方針の記録で、全リポジトリへの適用は**これから順に**行う。まだ `.v1` が残っているリポジトリが多い。
- **「REST地獄」について**: Connect 化で、URL 設計の揺れ・メソッドの使い分け・バージョンごとの複製は減る。ただし、設計をいい加減にすれば Connect でも壊れる。Versionless の決まりを守ることが、その対策になる。

### English
- **Decision (2026-11-25, user instruction)**: every repository adopts the **Versionless API** idea. No `v1`/`v2` in URLs or package names; **evolve by adding, without breaking compatibility**.
- **Rules**
  1. **Only add**: add new operations and fields. Never change the meaning of, remove, or make required an existing field.
  2. **Be liberal in what you accept**: ignore unknown fields (do not error); use defaults for missing ones.
  3. **Retire in stages**: record old operations and fields as deprecated, confirm from logs that use has dropped to zero, then remove them, with a stated deadline.
  4. **No version in the package name of new APIs** (for example `rs_ops.Accounts/List`).
  5. **If a breaking change is unavoidable, add a new operation with a meaningful new name** (not `ListV2`) and retire the old one by rule 3.
- **Existing code**: package names that already contain `.v1` (`rs_blog.v1`, `rs_ec.v1`, `open_runo.admin.v1` and so on) **stay for now so callers do not break**. A versionless alias is **added** and both are accepted; `.v1` is retired after use has moved (rule 3). New work and RS-Ops are versionless from the start.
- **Honest note**: this records the policy. Applying it to every repository happens **step by step from now on**; many still contain `.v1`.
- **About "REST hell"**: Connect removes much of it (URL-design drift, method choices, per-version copies). A sloppy design can still break under Connect; following the Versionless rules is the remedy.

## 2026-11-25 追記: Versionless API の調査結果の取り込み(日英の検索・GitHub) / Research findings folded in (JA/EN web search and GitHub)

### 日本語
**調査の結果(英語・日本語のWeb検索とGitHub)**: 日本語の専用記事は少なく、資料は英語が中心だった。GitHub には同名の小さな学習用リポジトリがあるだけで、設計の手本になるものは見つからなかった。
- **追加で進化させる(additive)が出発点**: エンドポイント・欄・パラメーターを足すだけなら、大きな版は要らない。**名前を変えたいときは新しい名前を足し、古い方を「非推奨」にして残す。**
- **非推奨には期限を付ける**: 破壊的変更を承認した場合も、約6か月の猶予を置き、変更履歴で知らせ、影響を受ける利用者へ個別に連絡する例がある。応答ヘッダーとドキュメントに期限を示し、**少なくとも6〜12か月**(エコシステムによる)とする助言もある。
- **GraphQL の考え方**: スキーマは1つを進化させ、非推奨には置き換え先を示し、**使用状況を見て十分に減ってから**消す。型・欄・ディレクティブの削除と、既存欄の形の変更は破壊的変更。
- **落とし穴**: (1) **追加でも、既存の利用者が直さないと動かないなら破壊的**。(2) **列挙値(enum)を足すのは、利用者が未知の値を許容するときだけ安全**。(3) 「バージョンレス」は版管理が要らないという意味ではなく、**先を見通した設計が必要**で、古い利用者を無期限に支える負担も出る。(4) 安全上の欠陥や根本的に誤った動作の修正など、**版を切るしかない変更も残る**。(5) 互換は一部「人の問題」で、移行は利用者の更新の速さに左右される。
- **REST との違いについての慎重な見方**: GraphQL が版管理で本質的に優れているわけではなく、REST でも欄を足し、古い欄を非推奨にすれば同じことはできる。違いは、返す欄を利用者が選べる分、変更が破壊的になりにくい点と、ツールの支援。
- **私たちの規則への反映(上の1〜5に加える)**
  6. **足す欄は省略可能にする**。必須にしない。
  7. **列挙値を足すときは、利用者が未知の値を無視または既定扱いにできることを前提にする**。出力にだけ新しい値を足す場合は、先に利用者側(画面・SDK)を直す。
  8. **非推奨にしたら、記録(ここの台帳と各リポジトリの CHANGELOG)に日付・置き換え先・消す期限を書く**。消すのは、ログで使用が0になり、**既定で6か月以上**待ってから。自分たちだけが呼び出し側の内部APIは、使用が0になったことの確認で足りる。
  9. **安全上の緊急修正は例外**とし、理由と日付を記録して、必要なら版を切らずに新しい名前の操作で置き換える。
- **私たちの立場**: 呼び出し側の多くが自分たちのアプリ(画面・インストーラー・姉妹リポジトリ)なので、使用状況を測りやすく、Versionless は取り入れやすい。外部へ公開するAPIは、期限をより長く取る。

### English
**Findings (English and Japanese web search, plus GitHub)**: there is little Japanese-specific writing; the material is mostly English. GitHub has only small learning repositories with this name, nothing to use as a design model.
- **Additive evolution is the starting point**: if you only add endpoints, fields and parameters, no major version is needed. **To rename, add the new name and keep the old one marked deprecated.**
- **Deprecation needs a deadline**: one vendor gives about six months of grace for approved breaking changes, announces them in a changelog and contacts affected customers; other advice is to show the deadline in response headers and docs, **at least 6 to 12 months** depending on the ecosystem.
- **The GraphQL view**: evolve one schema, give replacement guidance on deprecations, and remove only **after observed usage is low enough**. Removing a type, field or directive and changing an existing field's shape are breaking changes.
- **Pitfalls**: (1) **an addition is breaking if existing consumers must change to keep working**; (2) **adding an enum value is safe only if clients tolerate unknown values**; (3) "versionless" does not mean no versioning is needed: it **demands foresight** and means supporting old clients indefinitely; (4) **some changes still need a version**, such as fixing a security flaw or fundamentally wrong behavior; (5) compatibility is partly social, since migration follows clients' release cadence.
- **A cautious view versus REST**: GraphQL is not inherently better at versioning; REST can add fields and deprecate old ones too. The difference is that clients choose their fields (so changes break less often) and the tooling support.
- **Folded into our rules (in addition to 1 to 5 above)**
  6. **New fields are optional**, never required.
  7. **When adding an enum value, assume clients ignore or default unknown values.** If a new value appears only in output, fix clients (UI, SDK) first.
  8. **After deprecating, record the date, the replacement and the removal deadline** (in this ledger and each repository's CHANGELOG). Remove only when logs show zero use **and at least 6 months have passed by default**. For internal APIs called only by our own apps, confirming zero use is enough.
  9. **Emergency security fixes are the exception**: record the reason and date, and replace with a new-named operation rather than a version bump where possible.
- **Our position**: most callers are our own apps (UIs, installers, sister repositories), so usage is easy to measure and Versionless is easy to adopt. Public-facing APIs get longer deadlines.

Sources / 出典: [GoldenPath: versionless schema design](https://goldenpath.graphql.org/solutions/versionless-schema-design/), [GoldenPath: versioning](https://goldenpath.graphql.org/practices/versioning/), [GraphQL: schema design](https://graphql.org/learn/schema-design/), [WunderGraph: Versionless APIs](https://wundergraph.com/blog/versionless_apis_making_apis_backwards_compatible_forever_to_enable_businesses_to_collaborate), [InfoQ: API evolution without versioning](https://www.infoq.com/news/2022/10/api-evolution-without-versioning), [VA API standards: API evolution](https://department-of-veterans-affairs.github.io/va-api-standards/lifecycle/api-evolution), [Apideck: versioning & breaking changes](https://developers.apideck.com/versioning), [Speakeasy: versioning best practices](https://www.speakeasy.com/api-design/versioning), [LogRocket: versioning fields in GraphQL](https://blog.logrocket.com/versioning-fields-graphql).

## 2026-11-25 追記: 参考資料2点の取り込み(Zenn「Versionless APIという世界」・WunderGraph) / Two references folded in (Zenn article and WunderGraph)

### 日本語
**参考**: [Zenn: Versionless APIという世界(kinzal、2022-12)](https://zenn.dev/kinzal/articles/74a761de1cc52d)、[WunderGraph: Versionless APIs(Jens Neuse、2021-09、2026年に更新)](https://wundergraph.com/blog/versionless_apis_making_apis_backwards_compatible_forever_to_enable_businesses_to_collaborate)。
- **言葉の意味**: Versionless は「版を管理しない」ではなく、**クライアントを壊さずAPIを進化させ続けられる**こと。サーバーレスと同じで、版が無いのではなく**版を気にしなくてよくなる**こと。GraphQL が REST より本質的に版管理に強いわけではない。Zenn の筆者も、REST でも適用できそうだとしている。→ **私たちの Connect(`POST /パッケージ.Service/Method` と JSON)は、この JSON-RPC 型の入口にあたり、相性がよい。**
- **WunderGraph の仕組み**: スキーマを内部の「仮想的な約束」として扱い、クライアントの操作を、JSON-RPC の窓口と**移行スクリプト(migration)**で新しいスキーマへ書き換える。クライアントには**版のハッシュ**を埋め込み、移行テストが通れば、クライアントを壊さずに更新できる。サポートするクライアント(例: 過去2か月に通信したもの)を指定して検査する。
- **移行(migration)でできること・できないこと(Zenn)**
  - 要求(request): **削除はいつでも可**。更新は元の情報で作れる場合だけ(例 timestamp→DateTime)。**必須の入力欄を足すのは不可**(情報が無い)。
  - 応答(response): **追加はいつでも可**。更新は元の情報で作れる場合だけ。**削除は、別の問い合わせで補えない限り不可**。
  - **古い処理(resolver)を残す方法**との比較: 残せば完全に互換だが、保守するコードが増え、DB を変えたとき古い処理も直す必要がある。**クライアントの更新が遅い(スマホなど)ほど古い処理が溜まる**。提供側がクライアントを制御できないなら移行方式、制御できる(BFF など)なら古い処理を残す手もある。
- **必要になるもの**: (1) **トレース(誰がどの古い版を使っているか)**。古い版・移行を消す判断に必須。(2) **スキーマの後方互換チェックをCIに**。過去N か月以内のクライアントが動かなくなる変更を禁止する。**禁止するのは「互換のない変更」ではなく「クライアントが動かなくなる変更」**で、影響の無い変更は自由。
- **ほかの現実**: IoT 機器やスマホアプリは更新されにくく、更新が出てから古い版を畳めるまで1年以上かかることもある。互換をいつまでも保つのは負担でもあり、破壊的な変更が必要な場面は実際にある。
- **私たちの規則への追加**
  10. **版の代わりに、どの呼び出し側がどの操作・欄を使っているかを記録する**(アクセスログの集計。`x-tenant` や呼び出し元名を使う)。消す判断はこの記録で行う。
  11. **互換チェックを試験に入れる**: 旧経路・旧欄の呼び出しが、変更後も動くことを確かめる試験を置く(RS-Blog の旧REST 404 の試験と同じ要領で、残す操作の「動く」側も)。
  12. **移行できない変更**(必須入力欄の追加、他で補えない応答欄の削除)は、**新しい名前の操作を足して**、旧は規則8で畳む。
  13. 呼び出し側を制御できる内部APIは、古い処理を残さず移行(読み替え)で済ませてよい。制御できない外部向けや、更新の遅い端末(スマホ・IoT)向けは期限を長く取る。

### English
**References**: [Zenn: "The world of Versionless APIs" (kinzal, 2022-12)](https://zenn.dev/kinzal/articles/74a761de1cc52d) and [WunderGraph: Versionless APIs (Jens Neuse, 2021-09, updated 2026)](https://wundergraph.com/blog/versionless_apis_making_apis_backwards_compatible_forever_to_enable_businesses_to_collaborate).
- **What the word means**: Versionless does not mean "no versioning"; it means you can **keep evolving the API without breaking clients**. Like "serverless", versions still exist, you just **do not have to think about them**. GraphQL is not inherently better than REST at this, and the Zenn author also thinks it applies to REST. → **Our Connect (`POST /package.Service/Method` with JSON) is this JSON-RPC-style facade, so it fits well.**
- **WunderGraph's mechanism**: treat the schema as an internal, virtual contract, and rewrite client operations onto the new schema through a JSON-RPC facade and **migration scripts**. A **version hash** is embedded in each client; when the migration test suite is green, the update ships without breaking clients. You choose which clients to support (for example those seen in the last two months) and test against them.
- **What migration can and cannot do (Zenn)**
  - Requests: **removal always works**. Updates work only when the old information suffices (timestamp to DateTime). **Adding a required input field cannot be migrated** (no information).
  - Responses: **addition always works**. Updates work only when the old information suffices. **Removal cannot be migrated unless another query can fill it in.**
  - **Versus keeping the old resolvers**: keeping them is fully compatible but the code to maintain grows, and a database change forces edits to the old resolvers too. **The slower clients update (mobile and so on), the more old resolvers pile up.** If you cannot control clients, prefer migration; if you can (a BFF, for example), keeping old resolvers is an option.
- **What you need**: (1) **tracing (who uses which old version)**, essential for deciding when to delete an old version or migration; (2) **a schema backward-compatibility check in CI** that forbids changes breaking clients seen in the last N months. **Forbid changes that break clients, not every incompatible change**; changes with no client impact are free.
- **Other realities**: IoT devices and mobile apps update slowly; it can take a year or more after an update before the old version can be retired. Keeping compatibility forever is a burden too, and breaking changes are sometimes truly needed.
- **Added to our rules**
  10. **Instead of versions, record which caller uses which operation and field** (aggregate access logs; use `x-tenant` or the caller name). Deletion decisions rest on this record.
  11. **Put compatibility checks into the tests**: tests that old paths and old fields still work after a change (like RS-Blog's old-REST-404 test, but for the "still works" side of what we keep).
  12. **Changes that cannot be migrated** (adding a required input field, removing a response field nothing else can fill in): **add a new-named operation** and retire the old one by rule 8.
  13. Internal APIs whose callers we control may use migration (translation) instead of keeping old handlers; externally facing APIs and slowly updating clients (phones, IoT) get longer deadlines.
