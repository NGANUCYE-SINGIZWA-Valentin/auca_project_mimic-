# Auto-sync GitHub updates script
# This script fetches latest changes from upstream and pushes to your origin

# Get the script's directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Change to project directory
Set-Location $scriptDir

Write-Host "🔄 Starting GitHub Auto-Sync..." -ForegroundColor Cyan
Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray

# 1. Fetch from upstream (main repository)
Write-Host "`n📥 Fetching from upstream..." -ForegroundColor Yellow
git fetch upstream main 2>&1 | Write-Host

# 2. Check if upstream/main is ahead of local main
$upstreamHash = git rev-parse upstream/main 2>&1
$localHash = git rev-parse main 2>&1

if ($upstreamHash -eq $localHash) {
    Write-Host "✅ Already up to date with upstream!" -ForegroundColor Green
    exit 0
}

# 3. Stash any local changes (database file, etc.)
Write-Host "`n💾 Stashing local changes..." -ForegroundColor Yellow
git stash push -m "auto-sync: stashing local changes" -- db.sqlite3 2>&1 | Write-Host

# 4. Merge upstream changes
Write-Host "`n🔗 Merging upstream changes..." -ForegroundColor Yellow
git merge upstream/main --no-edit 2>&1 | Write-Host

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Merge failed. Check conflicts manually." -ForegroundColor Red
    exit 1
}

# 5. Push to your origin (your GitHub fork)
Write-Host "`n⬆️  Pushing to origin..." -ForegroundColor Yellow
git push origin main 2>&1 | Write-Host

Write-Host "`n✅ GitHub Sync Complete!" -ForegroundColor Green
Write-Host "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
