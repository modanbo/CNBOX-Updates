# NAJXBox Manager v2.0.3

Status: **FORMAL BRANDING-CLOSURE RELEASE / PUBLIC BUILD PASS / PUBLIC SELFTEST PASS / CREATOR BUILD PASS / CREATOR SELFTEST PASS / WINDOWS VERSIONINFO PASS / UI SNAPSHOT PASS**

Date: 2026-09-22  
Verified self-hosted run: `35782308953`  
Build head: `cb8a3dfee1d1ccee3b7f42acd7b702ede9a5e3fe`

## Release hashes

- Public EXE SHA256: `3abdec35f6294d4ddf4066a84041ce7e362f39e50ebbe575b6a5097c97d4bbeb`
- Creator EXE SHA256: `d577ff95e0dc0104728ad3a73e98f3c0370b7196e1a56fd8b65d3ee2585f988b`
- dual-flavor artifact ZIP SHA256: `3e914414c66613bafdf35671b4436f3eeb5534307cc70c4b501f8b037dae4bc6`
- file/assembly version: `2.0.3.0`

## What v2.0.3 closes

v2.0.2 completed the visible NAJXBox UI branding. v2.0.3 completes the executable-level branding that remained underneath the UI.

Verified Windows executable identity:
- `ProductName = NAJXBox Manager`
- `FileDescription = NAJXBox Manager`
- `CompanyName = NAJXBox`
- `InternalName = NAJXBox_Manager.exe`
- `OriginalFilename = NAJXBox_Manager.exe`
- `FileVersion = 2.0.3.0`

The assembly output is now `NAJXBox_Manager.exe`. Public and Creator application icon resource names are also NAJXBox, and Manager-owned User-Agent / temporary self-update naming has been moved to NAJXBox.

## Compatibility boundary

This is **not** a destructive global rename.

The following legacy CNBOX identifiers remain intentionally supported because they are compatibility/state owners, not current branding:
- existing `LocalAppData\CNBOX_Manager` state;
- CNBOX backup/language/MoE/candidate manifest identifiers already written to user systems;
- historical `cnboxVersion` and `CNBOX_AUTHORITATIVE` channel fields;
- old payload/manifest filenames and historical hashes;
- legacy stable updater URL `manager/CNBOX_Manager.exe`;
- GitHub/Gitee/Drive repository and historical folder names.

The legacy stable executable aliases contain the **same v2.0.3 bytes** as the canonical NAJXBox stable aliases, preserving self-update for older Managers.

## Published aliases

Public:
- `manager/CNBOX_Manager.exe` — legacy compatibility alias
- `manager/NAJXBox_Manager.exe` — canonical stable alias
- `manager/NAJXBox_Manager_v2.0.3.exe` — versioned binary

Creator:
- `manager/CNBOX_Manager_Creator.exe` — legacy compatibility alias
- `manager/NAJXBox_Manager_Creator.exe` — canonical stable alias
- `manager/NAJXBox_Manager_Creator_v2.0.3.exe` — versioned binary

Package:
- `manager/NAJXBox_Manager_v2.0.3.zip`

## Validation

Run `35782308953` passed:
- architecture + external-branding static gate;
- Public Build;
- Public SelfTest;
- Creator Build;
- Creator SelfTest;
- Windows VersionInfo branding gate for both builds;
- Public/Creator UI snapshots;
- icon resource validation;
- artifact/hash staging.

No Box payload, Aslain compatibility rule, localization behavior, rollback behavior, Creator transaction logic, or MoE functional behavior was changed by this release.
