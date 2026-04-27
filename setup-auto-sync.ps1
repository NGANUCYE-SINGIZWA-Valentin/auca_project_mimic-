# Setup automatic GitHub syncing with Windows Task Scheduler
# Run this script as Administrator to schedule automatic syncs

# Configuration
$TaskName = "AUCA Project Auto-Sync"
$ScriptPath = "$PSScriptRoot\sync-github.ps1"
$ProjectPath = "$PSScriptRoot"

# Verify script exists
if (!(Test-Path $ScriptPath)) {
    Write-Host "❌ sync-github.ps1 not found!" -ForegroundColor Red
    exit 1
}

# Check if running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "❌ Please run this script as Administrator!" -ForegroundColor Red
    exit 1
}

Write-Host "🔧 Setting up GitHub Auto-Sync Task Scheduler..." -ForegroundColor Cyan

# Remove existing task if it exists
$existingTask = Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "🗑️  Removing existing task..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
}

# Create a trigger (runs every 6 hours)
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddSeconds(10) -RepetitionInterval (New-TimeSpan -Hours 6) -RepetitionDuration (New-TimeSpan -Days 36500)

# Create action to run PowerShell script
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -WindowStyle Hidden -File `"$ScriptPath`""

# Create task settings
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable `
    -MultipleInstances IgnoreNew

# Register the task
Write-Host "📅 Creating scheduled task..." -ForegroundColor Yellow
Register-ScheduledTask `
    -TaskName $TaskName `
    -Trigger $trigger `
    -Action $action `
    -Settings $settings `
    -Description "Automatically syncs AUCA Project with GitHub upstream every 6 hours" | Out-Null

Write-Host "✅ Task Scheduler setup complete!" -ForegroundColor Green
Write-Host "`n📋 Task Details:" -ForegroundColor Cyan
Write-Host "   Name: $TaskName"
Write-Host "   Schedule: Every 6 hours"
Write-Host "   Script: $ScriptPath"
Write-Host "`n💡 To modify the schedule:" -ForegroundColor Yellow
Write-Host "   1. Open Task Scheduler"
Write-Host "   2. Find task: '$TaskName'"
Write-Host "   3. Right-click → Properties → Triggers → Edit"
Write-Host "`n💡 To run manually:" -ForegroundColor Yellow
Write-Host "   PowerShell: & '$ScriptPath'"
Write-Host "   Or: cd '$ProjectPath' && .\sync-github.ps1"
