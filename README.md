# Flaskで始めるOIDC認可コードフロー

## 実行手順

1. `cd terraform && terraform apply`
1. ユーザプールにユーザの追加
1. `app/.env`の作成
1. `cd app && uv run python -m flask --app main run -p 8080`
    - Cognitoで設定した許可リダイレクトURIと一致させる必要がある.
1. ブラウザで`http://localhost:8080`へアクセス
    - `http://127.0.0.1:8080`はNG

## 処理フロー

1. Login時, 認可エンドポイント(CognitoのホステッドUI)へリダイレクト
   - このリクエストはクライアントID、スコープ、レスポンスタイプ、リダイレクトURIなどを含む
1. ユーザー認証後, リダイレクトエンドポイント(`/authorize`)へリダイレクト
   - このリクエストは認可コードを含む
1. Cognitoのトークンエンドポイントへアクセス(Basic認証)してアクセストークンを取得
