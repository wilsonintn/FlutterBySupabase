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

在執行專案前，您必須手動完成以下在 Supabase 和 Google Cloud Console 的設定。

### Redirect URL：一個重要的「暗號」

在設定過程中，您會不斷看到 `io.supabase.flutterdemo://login-callback/` 這串字。您可以把它想像成一個您自己發明的「**暗號**」。

這個暗號**不是**您 App 的真實名稱，而是用來讓 App 在登入後能正確跳轉回來的一個內部地址。為了讓整個流程順利運作，這個暗號**必須在以下三個地方完全一致**：

1.  **Supabase 控制台** (您正在設定的地方)
2.  **Flutter 程式碼** (`main.dart` 中的 `redirectTo` 參數)
3.  **Android 設定檔** (`AndroidManifest.xml` 中的 `scheme`)

本專案已在程式碼和 Android 設定檔中使用了上述暗號，因此您在 Supabase 控制台也必須使用完全相同的值。

---

### 詳細設定步驟

1.  **Supabase 專案**:
    - 在 `supabase.com` 建立新專案。
    - 進入 **Authentication** > **Providers** > **Google**，啟用 Google 登入。
    - 進入 **Authentication** > **URL Configuration**，在 `Redirect URLs` 中新增我們約定好的「暗號」：`io.supabase.flutterdemo://login-callback/`。
2.  **Google Cloud Console**:
    - 建立一個 **Web 應用程式 (Web application)** 類型的 OAuth 2.0 Client ID。
      > **[註]**：因為驗證流程是由 Supabase 後端與 Google 溝通，所以請選擇「Web 應用程式」。
    - 將取得的 `Client ID` 和 `Client Secret` 填入到 Supabase 的 Google Provider 設定中。
3.  **資料庫 (Database)**:
    - **建立 `profiles` 表與 `auth.users` 關聯**: Supabase 會自動建立 `auth.users` 表。我們應另外建立一個 `public.profiles` 表來存放 App 的使用者資料 (如：暱稱)，並透過 `id` 欄位將兩者關聯。這是 Supabase 開發的最佳實踐。
    - 依照您的需求建立其他資料表 (例如 `notes`) 並設定 Row Level Security (RLS)。
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

## 版本更新紀錄

此處記錄專案的重大版本更新。關於如何提交新的變更，請參考上方的「版本控制 (Git)」章節。

---

- **Commit:** 7f10e82870cb5e0067a5a17c96871cc07459ebea
  **Date:** Mon Oct 20 15:41:41 2025 +0800
  **Message:** feat: 整合 Supabase Google 登入流程
