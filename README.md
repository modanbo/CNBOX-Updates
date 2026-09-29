# NAJXBox Updates — Public Distribution

Role: **CURRENT PUBLIC DISTRIBUTION ONLY**

This repository is the stable Public update endpoint for NAJXBox Manager and legacy CNBOX-compatible clients.

Source of truth for machine update logic: `channel.json`.

## Current Public release

### Manager Public
- Version: **2.1.1**
- Canonical binary: `manager/NAJXBox_Manager.exe`
- Legacy compatibility alias: `manager/CNBOX_Manager.exe`
- SHA256: `35adb9af766646293eba0633b7bc7bc1901e0fa45383e35f39221ad7e7d2287b`

Creator 2.1.1 remains an engineering distribution on GitHub/Google Drive and is **not mirrored to Public Gitee**.

### Box
- Public release: **2401-R34-R2F9-UNIFIED-R5**
- Status: **FINAL_LOCK**
- WoT: **2.4.0.1**
- XVM: **13.1.0.0090**
- Package: `payloads/2.4.0.1/unified/CNBOX_PAYLOAD_R5.zip`
- SHA256: `cf8ce97f9e33ee013c0383d2c940d5ee37985749bd8e12e299b13a8ad70829b6`
- Current Creator/Aslain compatibility lock: **2401-09-R34-R2F9-FINAL_LOCK-R5**

Aslain #09 is a low-risk dependency rebase. The Public R5 Box payload remains byte-identical; no Public Box rebuild was required.

### Language
- Pack version: **1.1**
- Package: `language/CNBOX_LANGUAGE_PACK_2.4.0.1.zip`
- SHA256: `e6fd0b357617bf4267a3b29458f9b810be9717d907d929c5c8c0fcb5b098a3a7`

### MoE / 打环
- Version: **1.2.9**
- Status: **FINAL_LOCK / Runtime PASS**
- Package: `moe/1.2.9/NAJXBOX_MoE_INDEPENDENT_1.2.9_LOBBY_LIFECYCLE_OWNER_REBUILD_WOT_2.4.0.1.zip`
- Package SHA256: `624276153a5b65bd74eda0009ffba23061cb0d111ccb78dd7f1328b1f100136c`
- Installed WOTMOD SHA256: `fc81ac5bf0baa92339a179373835cd0246be78fb9cddde44d239270f5c8035b2`

## Public Gitee mirror

Gitee repository: `modanbo/cnbox-updates-cn`

**Gitee contains only three current Public payload files. No README, index, channel, manifest, language, SHA256SUMS, Creator, test package, or history file is published there.**

Exact Gitee file set:
- `manager/CNBOX_Manager.exe`
- `payloads/2.4.0.1/unified/CNBOX_PAYLOAD_R5.zip`
- `moe/1.2.9/NAJXBOX_MoE_INDEPENDENT_1.2.9_LOBBY_LIFECYCLE_OWNER_REBUILD_WOT_2.4.0.1.zip`

## Standard manual Gitee update command

Use this PowerShell procedure for manual Gitee replacement. It is intentionally fail-closed: cleanup is permitted only after the clone succeeds, the working path matches the dedicated temp directory, and `.git` exists.

```powershell
$ErrorActionPreference = "Stop"

$work = "$env:TEMP\NAJXBox_Gitee_Public"
$repo = "https://gitee.com/modanbo/cnbox-updates-cn.git"

# Set these to the exact current FINAL files before publishing.
$PublicManager = "C:\PATH\NAJXBox_Manager_v2.1.1.exe"
$Box = "C:\PATH\NAJXBOX_ASLAIN06_Y30_LOCKED_FINAL_1007_BILINGUAL_JX_NAME_R2_REVIEWED.zip"
$MoE = "C:\PATH\NAJXBOX_MoE_INDEPENDENT_1.2.9_LOBBY_LIFECYCLE_OWNER_REBUILD_WOT_2.4.0.1.zip"

if (Test-Path $work) {
    Remove-Item $work -Recurse -Force
}

git -c http.version=HTTP/1.1 clone --depth 1 $repo $work

if ($LASTEXITCODE -ne 0 -or !(Test-Path (Join-Path $work ".git"))) {
    throw "Gitee clone failed. STOPPED before cleanup."
}

Set-Location $work

if ((Get-Location).Path -ne $work) {
    throw "Wrong working directory. STOPPED before cleanup."
}

if (!(Test-Path ".git")) {
    throw "Not a Git repository. STOPPED before cleanup."
}

git config user.name "modanbo"
git config user.email "modanbo@users.noreply.gitee.com"

# Destructive cleanup is allowed only after all guards above pass.
Get-ChildItem -Force |
    Where-Object { $_.Name -ne ".git" } |
    Remove-Item -Recurse -Force

New-Item ".\manager" -ItemType Directory -Force | Out-Null
New-Item ".\payloads\2.4.0.1\unified" -ItemType Directory -Force | Out-Null
New-Item ".\moe\1.2.9" -ItemType Directory -Force | Out-Null

Copy-Item $PublicManager ".\manager\CNBOX_Manager.exe" -Force
Copy-Item $Box ".\payloads\2.4.0.1\unified\CNBOX_PAYLOAD_R5.zip" -Force
Copy-Item $MoE ".\moe\1.2.9\NAJXBOX_MoE_INDEPENDENT_1.2.9_LOBBY_LIFECYCLE_OWNER_REBUILD_WOT_2.4.0.1.zip" -Force

$files = @(Get-ChildItem -File -Recurse)
if ($files.Count -ne 3) {
    $files.FullName
    throw "Gitee staging must contain exactly 3 files."
}

git add -A
git status
git commit -m "Update Public Manager Box and MoE only"
git push origin main

git status
git log -1 --oneline
```

Important safety rule: **never run the cleanup block from `C:\Users\...` or another normal user directory.** If clone fails, stop and fix clone first.

## Authority

For update decisions, always use `channel.json` in GitHub.
For a human-readable snapshot, use `CURRENT_RELEASE_INDEX.md` in GitHub.
These documentation files are not part of the Gitee three-file mirror.
