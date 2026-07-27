# ============================================================
# push.ps1
# このフォルダの変更をまとめてGitHubにアップロードするスクリプト
# 使い方: このファイルをプロジェクトのフォルダ(mp3-barcode-battle.htmlと同じ場所)に置いて実行する
# ============================================================

Write-Host "GitHubに変更をアップロードします..." -ForegroundColor Cyan

# 1. 変更内容の確認(何も変わっていなければここで知らせて終了)
$statusResult = git status --porcelain
if (-not $statusResult) {
    Write-Host "変更点がありません。アップロードするものはありませんでした。" -ForegroundColor Yellow
    exit
}

# 2. 何が変わったか一覧表示
Write-Host ""
Write-Host "変更されたファイル:" -ForegroundColor Cyan
git status --short
Write-Host ""

# 3. コミットメッセージ(変更内容のメモ)を入力してもらう
$message = Read-Host "コミットメッセージを入力してください(何も入力せずEnterで自動メモになります)"
if ([string]::IsNullOrWhiteSpace($message)) {
    $message = "update " + (Get-Date -Format "yyyy-MM-dd HH:mm")
}

# 4. add -> commit -> push を実行
git add -A
git commit -m "$message"

if ($LASTEXITCODE -ne 0) {
    Write-Host "コミットに失敗しました。上のメッセージを確認してください。" -ForegroundColor Red
    exit
}

git push

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "アップロード完了しました!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "プッシュに失敗しました。上のメッセージを確認してください。" -ForegroundColor Red
}
