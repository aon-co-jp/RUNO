# POLICY (aon-co-jp 共通方針の索引)

- API方針の正本: [API-POLICY.md](API-POLICY.md)(日英独露)
- 共通指示書: [API-MIGRATION-BRIEF.md](API-MIGRATION-BRIEF.md)
- 言語変換の共通の形(IR)の方針: [`pl2pl`](https://github.com/aon-co-jp/pl2pl) の `src/ir.rs`(入力側)と `src/ir_emit.rs`(書き出し側)。変換できない所は黙って消さず TODO で残す。出力を変えない変更は、前後の出力の diff が空で確かめる。(2026-11-19)
- Policy for the shared shape (IR) of language conversion: `src/ir.rs` (input side) and `src/ir_emit.rs` (writer side) in [`pl2pl`](https://github.com/aon-co-jp/pl2pl). Parts that cannot be converted are never dropped silently; they stay as TODO notes. A change that must not alter the output is proven by an empty diff of the output before and after. (2026-11-19)

## REST 全廃の編集記録・実施状況 (2026-11-06)

### 日本語
- **決定(2026-11-04、ユーザー)**: aon-co-jp 全リポジトリで REST API を廃止し、Connect(ブラウザ/`curl`)と gRPC / gRPC-web(サービス間)へ移す。方針の正本は [`API-POLICY.md`](API-POLICY.md)、担当への共通指示は [`API-MIGRATION-BRIEF.md`](API-MIGRATION-BRIEF.md)、残りの一覧は [`API-REST-REMAINING-20261106.md`](API-REST-REMAINING-20261106.md)。
- **実施状況(origin 基準の静的な目安)**: REST風ルート 509(11-04)→481(11-05)→**318(11-06)**。移行済み: open-english・aruaru-search・aruaru-llm・open-web-server・RS-Sync。ほぼ移行: aruaru-db(残8)。作業中: open-cosmo(残22)、RPoem(23、第1段階)。
- **未移行**: RS-EC 28 / RS-Blog 22 / aruaru.tokyo 17 / aruaru-IME 14 / aon.tokyo 13 / backup-to-discord-by-github 11 ほか小規模。**例外か自前かの判定待ち**: open-gitea・open-redmine(Gitea/Redmine互換なら例外)、ows-base・ows-stream(管理APIは自前なら移行)。
- **進め方**: 各リポジトリで 調査 → 分類(移す/例外/ブラウザGET) → 開発 → TEST → 記録(README/CLAUDE/PORTING/POLICY) → 本番反映。同時に動かす担当は最大2つ。例外は理由と規格URLつきで `version-control` の台帳へ。
- **正直な注意**: この節は記録であり、全リポジトリの完了を意味しない。各リポジトリへの同内容の追記は、担当セッションがそのリポジトリを移行する際に行う。本番反映済みと確認できたのは open-english(直接確認)と RS-Sync(担当報告)のみ。

### English
- **Decision (2026-11-04, user)**: abolish REST across all aon-co-jp repositories; move to Connect (browser/`curl`) and gRPC / gRPC-web (service-to-service). Policy source: `API-POLICY.md`; shared instructions: `API-MIGRATION-BRIEF.md`; remaining list: `API-REST-REMAINING-20261106.md`.
- **Status (static estimate, origin-based)**: REST-like routes 509 (11-04) → 481 (11-05) → **318 (11-06)**. Migrated: open-english, aruaru-search, aruaru-llm, open-web-server, RS-Sync. Nearly: aruaru-db (8 left). In progress: open-cosmo (22), RPoem (23, stage 1).
- **Not migrated**: RS-EC 28, RS-Blog 22, aruaru.tokyo 17, aruaru-IME 14, aon.tokyo 13, backup-to-discord-by-github 11, and small ones. **Exception-or-own undecided**: open-gitea, open-redmine, ows-base, ows-stream.
- **Process**: per repository: survey → classify → build → test → record (README/CLAUDE/PORTING/POLICY) → deploy. At most two assignees at a time. Exceptions go to the `version-control` ledger with reason and standard URL.
- **Caveat**: this is a record, not a claim that every repository is done; each repository's own docs are updated by its assignee when it is migrated. Production deployment is confirmed only for open-english and RS-Sync.

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

## 2026-11-19 いまの状況と、これから作るもの / Where we are now, and what comes next

### 日本語(やさしく)
**いまできること**: pl2pl は、PHP(Laravel など)や Python や Java で書かれたウェブアプリを、Python の FastAPI に作り直すお助けロボットです。道順(ルート)、データの入れ物(モデル)、見た目の部品(Blade の画面)、見張り番(ミドルウェア)まで変えられます。通し試験は 55 項目すべて合格です。
**新しく直したところ**: 「新しい版が出たら自動で確かめる」機能(`pl2pl watch`)が、古い道具のまま試していたので、合格しても本当の確認になっていませんでした。いまは、毎回**まっさらな部屋(新しい venv)に最新版を入れてから**試験します。fastapi 0.165 で本当に通ることを確かめました。Windows では WSL の中で動かすので、まちがった警報も出ません。
**これからやること(確認はいりません。自動で順に進めます)**:
1. 毎晩・毎朝の自動実行の登録(まちがい警報が出ないことを確かめてから)
2. メールが本当に届くかの確認(このPCにはメール送信の設定がありません)
3. aruaru-llm・Kokkos・open-cuda・open-directx での GPU 実行の確認
4. PHP の細かい残り(クラス部品のメソッドなど)
5. 8 か国語の文書を最新に合わせる
**人に聞くこと**: 元の COBOL_to / Java_to を消す作業だけは、元に戻せないので、最後に必ずあなたに聞きます。
**ルール**: 「未了(まだ終わっていないこと)は確認せず、自動で進める」と決まっています。

### English (simple words, easy to read)
**What it can do now**: pl2pl is a helper robot. It rebuilds web apps written in PHP (like Laravel), Python or Java into Python FastAPI. It can change routes, data models, Blade screens and middleware. All 55 end-to-end checks pass.
**What we fixed today**: The "check new versions by itself" feature (`pl2pl watch`) used old tools for its tests. So a pass did not really prove anything. Now every check starts in a **clean new room (a fresh venv), installs the newest version, and then runs the tests**. We confirmed it really passes on fastapi 0.165. On Windows it runs inside WSL, so false alarms are gone.
**What comes next (no need to ask; we go on by ourselves, in order)**:
1. Register the nightly and morning runs (after we are sure there are no false alarms)
2. Check that e-mail really arrives (this PC has no mail settings)
3. Check GPU runs with aruaru-llm, Kokkos, open-cuda and open-directx
4. Small PHP leftovers (class-component methods, and so on)
5. Bring the 8 other language docs up to date
**What we still ask a person**: deleting the original COBOL_to / Java_to cannot be undone, so we always ask you first.
**Rule**: "Unfinished work goes on automatically, without asking." This is the standing rule.

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

## 2026-11-19 到達点と再開用メモ(日本語・リミット前)
**できたこと(pl2pl)**: ①`pl2pl web --backend <rust-axum|rust-poem|fastapi|mfastapi|rpoem|rporea> [--frontend] [--db]` で、サーバー・画面・データベースの組み合わせを選んで変換(COBOL は変換、C・C++・Fortran は元のままビルドして呼ぶ橋渡し)。Axum・Poem・FastAPI は実際に起動して確認済み。②`pl2pl c2rust`(単純な C → Rust、fib で gcc と同じ出力)。③`pl2pl watch` は新版を「まっさらな venv」で試験(WSL)、毎晩 03:00・毎朝 07:00 の自動実行を登録済み。④テストは単体 46 件すべて成功。
**未了(確認せず自動で進める)**: C++・Fortran の Rust 化と C の対応範囲の拡大(ポインタ・構造体・配列)、gfortran での橋渡しの実機確認、RPoem/RPoRea の起動確認、COBOL を別 OS の COBOL へ直す機能の拡張、メール到達の確認、Kokkos の GPU 実行(新しい GPU の機械が必要)、8 か国語文書の更新。クラウド定期実行は GitHub 接続待ち(https://claude.ai/connect-github)。
**人に確認すること**: 元の COBOL_to / Java_to の削除だけ(元に戻せないので最後に確認)。
**再開の手順**: `F:\pl2pl` の `PORTING.md` 末尾を読む。開発・試験はこの PC(WSL)、VPS は配備と確認だけ。`git pull` は VPS の `/root/easy-web.tokyo/pl2pl` で `--ff-only`。


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

- 2026-11-19 追記 / Update: `pl2pl cobol --os/--dialect` を追加、RPoem/RPoRea の骨組みを実際に実行して確認。/ Added `pl2pl cobol --os/--dialect`; the RPoem/RPoRea scaffold was run for real. 詳細 / details: `F:\pl2pl\PORTING.md`.


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


## 2026-11-20 現状と完成予定 / Status and planned work (日本語・English)

### 日本語(やさしい説明)
**現状(実機で確認済み)**
- 4姉妹(open-cosmo・RPoem・Reaxt・RPoRea)は、いつも一緒に作っています。
- ゲートウェイ(open-cosmo)は、複数のサーバーに質問を分けて、答えを1つにまとめます。`@key`・`@requires`・`@provides`・`@skip`・`@include`・名前付きフラグメント・書き込みのあとの取り直しに対応しています。試験はゲートウェイ59件、Reaxt 22件、本物のサーバーを並べた通し試験21項目が成功しています。
- **Reaxt 以外の実装とも結合できます**: Apollo(Node.js)と Rust の async-graphql のサブグラフを、Reaxt と並べて、分割と `@key` 結合が動くことを確かめました。
- Reaxt のアクションは、`Option`・`Vec`・`HashMap`・`f32`・`f64`・各種整数・`Box<T>`・2〜3個のタプルを使えます(v0.1.2 まで公開済み、それ以降は `main`)。
- RPoRea は、Python・Mojo・Android(実機)から呼べます。Mac と iPhone は CI での確認までです。
- 全公開リポジトリと非公開9件に、最新の `.md` とインストーラー一覧を出す仕組み(`docs-latest`)が入っています(日本時間 10時・12時・22時ごろ)。

**完成予定(未了)**
1. Mac・iPhone の実機確認(実機がありません)。
2. 4つ以上のタプルへの対応(必要になってから)。
3. クラウドでの定期実行(GitHub を Claude につなぐと作れます)。
4. `docs-latest` の定期実行(cron)が実際に動いたかの確認(日本時間 22:07 以降)。
5. 次の `Reaxt` リリース(`f32`・`Box<T>`・タプルを入れる)。
- 対象外にしたもの: `Option` の入れ子(`null` で段が区別できません)。

**決まり**: 終わっていない仕事は確認せず自動で進めます。試験して本物で確かめてから「できた」と書きます。秘密は書きません。新しい REST は作りません。Node.js は、ユーザーが許可した試験(Apollo の相互運用)だけで使います。

### English (plain words)
**Where we are (checked on real systems)**
- We always build the four sisters (open-cosmo, RPoem, Reaxt, RPoRea) together.
- The gateway (open-cosmo) splits a question across several servers and merges the answers. It supports `@key`, `@requires`, `@provides`, `@skip`, `@include`, named fragments and re-reading after a write. 59 gateway tests, 22 Reaxt tests and a 21-check end-to-end run with real servers all pass.
- **It also joins with non-Reaxt implementations**: we ran an Apollo (Node.js) subgraph and a Rust async-graphql subgraph next to Reaxt, and both splitting and `@key` joins worked.
- Reaxt actions can use `Option`, `Vec`, `HashMap`, `f32`, `f64`, the integer types, `Box<T>` and 2- to 3-element tuples (released up to v0.1.2; later work is on `main`).
- RPoRea can be called from Python, Mojo and Android (real phone). Mac and iPhone are checked in CI only.
- Every public repository and 9 private ones have the `docs-latest` workflow, which shows the latest `.md` files and an installer list (about 10:00, 12:00 and 22:00 Japan time).

**Planned (still open)**
1. Real-device checks on Mac and iPhone (we have no devices).
2. Tuples of four or more (when needed).
3. Scheduled cloud runs (possible once GitHub is connected to Claude).
4. Confirming that the `docs-latest` schedule (cron) really fires (after 22:07 Japan time).
5. The next `Reaxt` release (to ship `f32`, `Box<T>` and tuples).
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
