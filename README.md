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

## 登入流程變更：改用原生 Google Sign-In SDK (2025/10/20)

為了提供更好的使用者體驗並避免瀏覽器跳轉，登入流程已從原本的 `signInWithOAuth` (依賴深層連結) 修改為使用 `google_sign_in` 套件進行原生登入。

新的登入流程如下：
1.  用戶在 App 內點擊登入按鈕。
2.  App 呼叫原生 Google 登入介面。
3.  用戶授權後，App 取得 `idToken`。
4.  App 將 `idToken` 傳送給 Supabase 的 `signInWithIdToken` 方法進行驗證並建立 Session。

### 【重要】新流程的必要設定步驟

為了讓新的登入流程正常運作，你**必須**手動完成以下設定步驟。

#### **步驟 1：取得 Flutter 套件**

在終端機中，進入你的 `frontend` 目錄，然後執行：

```bash
flutter pub get
```
這會安裝我們新加入的 `google_sign_in` 套件。

#### **步驟 2：設定 `GOOGLE_WEB_CLIENT_ID`**

新的程式碼需要一個 `GOOGLE_WEB_CLIENT_ID` 來向 Supabase 驗證 `idToken`。

1.  前往 [Google Cloud Console API & Services > Credentials](https://console.cloud.google.com/apis/credentials)。
2.  在 **OAuth 2.0 Client IDs** 列表中，找到類型為 **Web client** 的用戶端。這通常是你為 Supabase Google 登入設定的那個。
3.  複製該用戶端的 **Client ID**。
4.  打開你專案中的 `frontend/.env` 檔案，加入以下這一行，並貼上你複製的 Client ID：
    ```
    GOOGLE_WEB_CLIENT_ID=你的-Web-Client-ID-貼在這裡.apps.googleusercontent.com
    ```

#### **步驟 3：設定 Android 憑證和 SHA-1 指紋**

這是最關鍵的一步，目的是授權你的 Android App 使用 Google 登入。

1.  **產生 SHA-1 指紋**:
    *   在你的專案根目錄打開終端機。
    *   進入 `frontend/android` 目錄：`cd frontend/android`
    *   執行以下指令：
        ```bash
        ./gradlew signingReport
        ```
        (如果是在 Windows 上，請執行 `gradlew signingReport`)
    *   你會看到一長串的輸出。找到 `variant: debug` 或 `variant: release` 區塊，並複製 `SHA1` 後面的值。它看起來像這樣：`A1:B2:C3:...:F9`。

2.  **在 Google Cloud Console 中加入 SHA-1**:
    *   回到 [Google Cloud Console API & Services > Credentials](https://console.cloud.google.com/apis/credentials) 頁面。
    *   在 **OAuth 2.0 Client IDs** 列表中，找到**類型為 Android** 的用戶端。（如果沒有，你需要為你的 App 建立一個）。
    *   點擊名稱進入編輯頁面。
    *   點擊 **ADD FINGERPRINT**。
    *   將你剛剛複製的 `SHA-1` 指紋貼上，然後儲存。

#### **步驟 4：重新執行 App**

1.  **完全移除**你手機或模擬器上舊的 App 版本。
2.  重新建置並執行你的 Flutter 專案。

---

## Supabase 外部設定 (手動)

**注意：以下為舊版 `signInWithOAuth` 流程的設定說明，在新流程中已不再需要設定 Redirect URL。此處僅為歷史紀錄保留。**

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
flutter clean
flutter pub get
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

---

## Supabase 自動同步設定 (一次性)

正如我們所討論的，您需要在 Supabase 後端資料庫設定一個「觸發器」，讓新用戶的資料可以從 `auth.users` 表自動複製到 `public.profile` 表。

這是一個 **一次性** 的設定，完成後此同步流程將會 **永久自動** 執行。

### 操作步驟

1.  登入您的 [Supabase 專案儀表板](https://supabase.com/dashboard)。
2.  在左側選單中，點擊 **SQL Editor** (圖示為 </> )。
3.  點擊 **+ New query** 按鈕。
4.  將下方的完整 SQL 程式碼複製並貼到編輯器中。
5.  點擊 **RUN** 按鈕。

### 需要執行的 SQL 程式碼

```sql
-- 刪除舊的 RLS 策略、觸發器和函式 (如果存在)，以便重新建立
-- This makes the script re-runnable without errors.
DROP POLICY IF EXISTS "Public profiles are viewable by everyone." ON public.profiles;
DROP POLICY IF EXISTS "Users can update own profile." ON public.profiles;
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
DROP FUNCTION IF EXISTS public.handle_new_user();

-- 1. 建立或替換一個函式，用於在 public.profiles 中為新用戶建立資料
CREATE OR REPLACE FUNCTION public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (uid, name, email, "photoUrl")
  values (new.id, new.raw_user_meta_data->>'name', new.email, new.raw_user_meta_data->>'avatar_url');
  return new;
end;
$$;

-- 2. 建立一個觸發器，在 auth.users 表有新資料時自動呼叫上述函式
CREATE OR REPLACE TRIGGER on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- 3. 為 'profiles' 表啟用資料列級安全 (RLS)
alter table public.profiles enable row level security;

-- 4. 設定 RLS 策略：只允許用戶讀取和更新自己的 profile
create policy "Users can view their own profile."
  on public.profiles for select
  using ( auth.uid() = uid );

create policy "Users can update own profile."
  on public.profiles for update
  using ( auth.uid() = uid );
```