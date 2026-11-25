# 変換元×変換先の対応表 / Source-by-target conversion matrix (2026-11-25)

記号 / Legend: ✅ 実際に動かして確認 / verified by running ・ 🟡 骨組みのみ(本体はTODOが残る) / scaffold only ・ ⬜ 未対応 / not yet

| 変換元 \ 変換先 | RPoem | Poem(Axum) | FastAPI | MFastAPI | RPoRea / Reaxt | RMojo / Mojo | Java | Fortran | COBOL(別OS) |
|---|---|---|---|---|---|---|---|---|---|
| COBOL(メインフレーム/UNIX/Linux/Windows) | ✅ COBOL_to | ✅ pl2pl web | 🟡 COBOL_to | 🟡 COBOL_to | 🟡 2RPoRea(RPoem経由) | ⬜ | ⬜ | ⬜ | 🟡 pl2pl cobol --os |
| Java(Spring等) | 🟡 Java_to | ⬜ | ⬜ | ⬜ | 🟡 2RPoRea(RPoem経由) | ⬜ | — | ⬜ | ⬜ |
| Python(Flask/Django/FastAPI) | 🟡 2Poem | ⬜ | — | 🟡 2MFastAPI | 🟡 2RPoRea(RPoem経由) | ⬜ | ⬜ | ⬜ | ⬜ |
| PHP(Laravel) | 🟡 2RPoRea(2026-11-25 着手) | ⬜ | ⬜ | ⬜ | 🟡 2RPoRea | ⬜ | ⬜ | ⬜ | ⬜ |
| Perl | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| C / C++ | ✅ pl2pl web(橋渡し) | ✅ pl2pl web | 🟡 pl2pl web | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ | ⬜ |
| Fortran | 🟡 pl2pl web(橋渡し) | 🟡 pl2pl web | 🟡 pl2pl web | ⬜ | ⬜ | ⬜ | ⬜ | — | ⬜ |
| Node.js(Express/Nest) | ⬜ | ⬜ | ⬜ | 🟡 2MFastAPI(任意) | 🟡 2RPoRea(501の骨組み) | ⬜ | ⬜ | ⬜ | ⬜ |
| React/Next/Vue(画面) | — | — | — | — | 🟡 2RPoRea(静的JSX・useState・onClick) | — | — | — | — |

**日本語**: この表は各リポジトリの README・PORTING の記載と、2026-11-25 時点で実際に動かした結果から作った。⬜ の組み合わせを、PHP → Perl → COBOL→Java → Mojo/RMojo の順に埋める(ユーザー指示: 相互変換を最優先)。業務ロジックを移せたと偽らない。✅ は実際に起動・応答を確認したものだけ。
**English**: Built from each repository's README/PORTING and from what was actually run on 2026-11-25. The ⬜ cells are filled in this order: PHP, Perl, COBOL to Java, Mojo/RMojo (user instruction: cross-conversion is top priority). Business logic is never claimed as ported when it is not; ✅ means started and answered over HTTP.
