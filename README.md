# 20251020_SupabaseLogin

此專案為使用 Supabase、Flutter 和 Node.js 建立登入系統的範例。

## 目前開發進度

- **前端**: 已在 `frontend` 資料夾中建立一個新的 Flutter 專案。
- **後端**: 已在 `backend` 資料夾中建立一個使用 Express 的 Node.js 專案。並已設定好基礎的 `index.js` 檔案。

## 如何設定與執行

### 環境需求

- 已安裝 Flutter SDK
- 已安裝 Node.js 及 npm

### 前端 (Flutter)

前端是位於 `frontend` 資料夾中的 Flutter 專案。

**首次設定:**

在首次執行應用程式之前，或每當您在 `pubspec.yaml` 中新增套件時，您需要安裝所有必要的相依套件：

```bash
cd frontend
flutter pub get
```
(註：此步驟在初始設定時已經為您完成。)

**執行應用程式:**

```bash
cd frontend
flutter run
```
`flutter run` 指令在啟動前會自動偵測並下載過期的套件，因此這也是一個很方便的啟動方式。

### 後端 (Node.js)

執行後端伺服器：

```bash
cd backend
npm install
node index.js
```

伺服器將會啟動在 `http://localhost:8000`。

## 未來設置

此部分將會更新，以包含設定 Supabase 並將其連接到前端和後端的說明。

## 版本控制 (Git)

本專案使用 Git 進行版本控制，並已推送到遠端 GitHub 倉庫。

當您未來有新的程式碼變更時，可以使用以下步驟將其上傳：

1.  **將變更的檔案加入暫存區**

    ```bash
    # 加入所有變更的檔案
    git add .

    # 或只加入特定檔案
    git add <檔案路徑>
    ```

2.  **提交變更**

    為您的變更附上有意義的提交訊息。

    ```bash
    git commit -m "您的提交訊息 (例如: feat: 新增使用者登入功能)"
    ```

3.  **推送到遠端倉庫**

    將您提交的變更上傳到 GitHub。

    ```bash
    git push
    ```
