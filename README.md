# 20251020_SupabaseLogin

此專案為使用 Supabase、Flutter 和 Node.js 建立 Google 登入系統的範例。

## 目前開發進度

- **前端 (Flutter)**:
  - 整合 `supabase_flutter` 和 `flutter_dotenv`。
  - 實現了完整的 Google 登入、登出及自動登入流程 (包含啟動頁、登入頁、首頁)。
  - 自動設定 Android 的 `AndroidManifest.xml` 以支援登入後的回調 (Deep Link)。
- **後端 (Node.js)**:
  - 整合 `@supabase/supabase-js` 和 `dotenv`。
  - 設定了 Supabase 客戶端，使用 service_role key 進行初始化，為未來的後端管理操作做準備。
- **版本控制 (Git)**:
  - 專案已初始化 Git，並已連接到遠端倉庫。

## Supabase 外部設定 (手動)

在執行專案前，您必須手動完成以下在 Supabase 和 Google Cloud Console 的設定：

1.  **Supabase 專案**:
    - 在 `supabase.com` 建立新專案。
    - 進入 **Authentication** > **Providers** > **Google**，啟用 Google 登入。
    - 進入 **Authentication** > **URL Configuration**，在 `Redirect URLs` 中新增 `io.supabase.flutterdemo://login-callback/`。
2.  **Google Cloud Console**:
    - 建立一個 OAuth 2.0 Client ID。
    - 將取得的 `Client ID` 和 `Client Secret` 填入到 Supabase 的 Google Provider 設定中。
3.  **資料庫 (Database)**:
    - 依照您的需求建立資料表 (例如 `users`, `notes`) 並設定 Row Level Security (RLS)。
4.  **.env 檔案**:
    - 將您從 Supabase 取得的 `URL`, `anonKey`, `service_role key` 填入到前端和後端的 `.env` 檔案中 (此步驟您已確認完成)。

## 如何在本機執行

### 環境需求

- 已安裝 Flutter SDK
- 已安裝 Node.js 及 npm

### 前端 (Flutter)

前端是位於 `frontend` 資料夾中的 Flutter 專案。

**首次設定/安裝套件:**
```bash
cd frontend
flutter pub get
```

**執行應用程式:**
```bash
cd frontend
flutter run
```

### 後端 (Node.js)

執行後端伺服器：
```bash
cd backend
npm install
node index.js
```
伺服器將會啟動在 `http://localhost:8000`。

## 版本控制 (Git)

當您未來有新的程式碼變更時，可以使用以下步驟將其上傳：

1.  **將變更的檔案加入暫存區**: `git add .`
2.  **提交變更**: `git commit -m "您的提交訊息"`
3.  **推送到遠端倉庫**: `git push`
