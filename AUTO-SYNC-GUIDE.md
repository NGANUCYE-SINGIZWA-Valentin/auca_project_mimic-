# 🔄 GitHub Auto-Sync Setup Guide

This folder includes automated scripts to keep your local project synced with the upstream GitHub repository.

## What's Included

### 1. **sync-github.ps1**
A PowerShell script that automatically:
- Fetches latest changes from upstream (main GitHub repository)
- Merges updates into your local main branch
- Pushes changes to your GitHub fork (origin)
- Stashes local database files to avoid conflicts

### 2. **setup-auto-sync.ps1**
A setup script that:
- Creates a Windows Task Scheduler job
- Schedules automatic syncs every 6 hours
- Runs in the background without interrupting your work

---

## 🚀 Quick Start

### Option A: Manual Sync (Anytime)
```powershell
cd c:\Users\val\OneDrive\Desktop\auca_project_mimic--main
.\sync-github.ps1
```

### Option B: Automatic Sync (Every 6 Hours)

**Prerequisites:** Run PowerShell as Administrator

```powershell
cd c:\Users\val\OneDrive\Desktop\auca_project_mimic--main
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
.\setup-auto-sync.ps1
```

**What happens:**
- ✅ Creates a scheduled task "AUCA Project Auto-Sync"
- ✅ Runs automatically every 6 hours (24/7)
- ✅ Silently syncs in the background
- ✅ Logs results to Windows Event Viewer

---

## 📅 Modifying the Schedule

If you want to change sync frequency:

1. **Open Task Scheduler:**
   - Press `Win + R`, type `taskschd.msc`, press Enter
   
2. **Find the task:**
   - Navigate to: Task Scheduler Library → Search for "AUCA Project Auto-Sync"
   
3. **Modify trigger:**
   - Right-click → Properties → Triggers tab
   - Select the trigger → Edit → Change interval
   - Options: Every 1 hour, 2 hours, 4 hours, 6 hours, 12 hours, 24 hours

---

## 🔗 Remote Configuration

Your remotes are now set up as follows:

```
origin     → https://github.com/NGANUCYE-SINGIZWA-Valentin/auca_project_mimic-.git
             (Your GitHub fork - where changes are pushed)

upstream   → https://github.com/ub-victor/auca_project_mimic.git
             (Main repository - where updates come from)
```

**Sync Flow:**
```
GitHub (ub-victor) → fetch → upstream/main → merge → your main → push → origin
```

---

## 🛠️ Troubleshooting

### Task not running?
```powershell
# Check task status
Get-ScheduledTask -TaskName "AUCA Project Auto-Sync" | Get-ScheduledTaskInfo
```

### Manual sync failed?
Check git status and resolve any conflicts:
```powershell
cd c:\Users\val\OneDrive\Desktop\auca_project_mimic--main
git status
git log --oneline -5  # View recent commits
```

### Want to disable auto-sync?
```powershell
# As Administrator:
Unregister-ScheduledTask -TaskName "AUCA Project Auto-Sync" -Confirm:$false
```

---

## 📊 Workflow Summary

| When | What Happens | Who | Status |
|------|---|---|---|
| Every 6 hours | Auto-sync runs | Windows Task Scheduler | ✅ Active |
| Anytime | Manual sync | You run `sync-github.ps1` | On-demand |
| Merge conflicts | Alert user | Git | 🔔 Notification |
| New files added | Auto-integrated | Git | ✅ Auto-merged |

---

## 🎯 Next Steps

1. ✅ **Run setup (if you want auto-sync):**
   ```powershell
   .\setup-auto-sync.ps1
   ```

2. ✅ **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. ✅ **Create .env file:**
   Copy `.env.example` to `.env` and add your credentials:
   ```bash
   cp .env.example .env
   ```

4. ✅ **Run migrations:**
   ```bash
   python manage.py migrate
   ```

5. ✅ **Start development:**
   ```bash
   python manage.py runserver
   ```

---

## 📞 Questions?

- Check TASKS.md for team workflow
- Check README.md for project overview
- Check GitHub Issues for known problems
- Contact team lead: Victoire

Happy coding! 🚀
