# VPS 厳選バックアップ 候補リスト(下書き 2026-10-26)

印: ◎=残す(最新のみ) / ○=残す(世代を絞る) / △=要確認 / ×=バックアップしない(再取得・再生成できる)
**あなたが印を直してください。** 確定したらこの印のとおりにバックアップスクリプトを作ります。
サイズは `ssh conoha` で読み取りだけして測った値です(VPSの `/` は 99GB 中 76GB 使用)。

## A. 今の暗号化バックアップが入れているもの(毎日03:30、1回約56KB・14世代)

| 項目 | 場所 | サイズ | 推奨 | メモ |
|---|---|---|---|---|
| PostgreSQL 全DB(pg_dump)+ロール | `/var/lib/pgsql` | 約47MB | ◎ | 圧縮後は数十KB。最重要 |
| aruaru-db のデータ | `/root/aruaru-db-data` | 76KB | ◎ | |
| nginx 設定 | `/etc/nginx` | 272KB | ◎ | 証明書の秘密鍵が入っていないか要確認 |
| systemd ユニット | `/etc/systemd/system` | 500KB | ◎ | |
| cron | `/etc/cron.d`・`crontab -l` | 小 | ◎ | |
| `aruaru-tokyo.env` | `/root/aruaru-tokyo.env` | 4KB | **△(秘密)** | パスワード・キーが入る。**暗号化しないバックアップには入れない** |
| rs-sync の `store.json` | `/root/rs-sync/data/store.json` | 小 | **△(秘密)** | アカウント情報・トークン。**暗号化しないバックアップには入れない** |

## B. 今のバックアップに入っていない、守る価値があるもの

| 項目 | 場所 | サイズ | 推奨 | メモ |
|---|---|---|---|---|
| aruaru-llm の学習データ | `/root/repository/aruaru-llm/data` | 2.9MB | ◎ | 今は6時間ごとにGitHubへ退避済み |
| aruaru-IME のデータ | `/var/lib/aruaru-ime` | 183MB | △ | 中身を確認してから(辞書は再取得できるか) |
| audiocafe のバックアップ | `/root/backup-audiocafe-20261008` | 34MB | △ | 古い一時バックアップなら最新版だけ |
| aon.tokyo の孤立コミット | `/root/aon-tokyo-git-orphans-20261003` | 43MB | △ | 救出用。不要なら削除候補 |
| rs-sync のデータ | `/root/rs-sync/data` | 2.5GB | △ | `store.json` 以外の中身を要確認 |
| 各サイトの `/root/url/*` | `aon.tokyo` 22GB・`easy-web.tokyo` 6.8GB・`aruaru.tokyo` 4.1GB ほか | 約36GB | △ | 動画・アップロードなど**再生成できないものだけ**を選ぶ必要がある。次に中身を調べる |

## C. バックアップ不要(再取得・再生成できる)

| 項目 | サイズ | 推奨 | 理由 |
|---|---|---|---|
| `/root/repository/*`(各リポジトリのclone) | 21GB | × | GitHubが正本。`git pull` で戻る |
| `target/`(ビルド成果物) | aruaru-llm だけで 1.5GB | × | 再ビルドできる |
| `aruaru-llm/models`(モデル) | 1.7GB | × | 再ダウンロードできる(取得元の記録だけ残す) |
| `/root/mirror-cache` | 1.1GB | × | キャッシュ |
| `/root/ows-stream-target`・`/root/atr-sonic-target` | 4.8GB・624MB | × | ビルド成果物らしい名前(要確認) |
| `*.bak-*`・`aruaru-llm.bin.*`・`open-easy-web-server.bak-*` | 計約 190MB | × | 古いバイナリの退避。最新版以外は不要 |
| `/root/sync-repos.log` | 25MB | × | ログ |
| `/var/lib/plocate`・`dnf`・`selinux` | 計約 35MB | × | OSが再生成 |

## 暗号化しない場合の注意

`aruaru-tokyo.env`・`rs-sync/data/store.json`・nginx の秘密鍵・`/root/.secrets/` には秘密情報が入っています。
暗号化しないバックアップにこれらを入れると、保存先(GitLab等)を見られた人にそのまま渡ります。
**秘密を含むものは別に、暗号化して手元(`F:\`)に置く**ことを提案します。
