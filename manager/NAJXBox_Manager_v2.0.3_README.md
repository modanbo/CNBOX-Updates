# NAJXBox Manager v2.0.3

Status: **FORMAL BRANDING-CLOSURE RELEASE / PUBLIC BUILD PASS / PUBLIC SELFTEST PASS / CREATOR BUILD PASS / CREATOR SELFTEST PASS / WINDOWS VERSIONINFO PASS / UI SNAPSHOT PASS / ICON PASS**

Date: 2026-09-22

## Scope

v2.0.3 finishes the **program-side** rename from CNBOX Manager to NAJXBox Manager.

Repository, mirror, history, channel and compatibility owner names are intentionally **not** globally renamed. Existing GitHub/Gitee/Drive names may continue using CNBOX where they are stable endpoints, historical provenance or compatibility owners.

This release changes the executable identity without breaking legacy updater/state compatibility.

## Build authority

- source branch: `manager-v2-rebuild`
- branding source commit: `0616c01e8a00ae70990cc009e35323dd4c399228`
- workflow fix / built head: `cb8a3dfee1d1ccee3b7f42acd7b702ede9a5e3fe`
- verified SEAGULL self-hosted run: `35782308953`
- artifact id: `10718616773`

## Version and hashes

- file / assembly version: `2.0.3.0`
- Public EXE SHA256: `3abdec35f6294d4ddf4066a84041ce7e362f39e50ebbe575b6a5097c97d4bbeb`
- Creator EXE SHA256: `d577ff95e0dc0104728ad3a73e98f3c0370b7196e1a56fd8b65d3ee2585f988b`
- dual-flavor artifact ZIP SHA256: `3e914414c66613bafdf35671b4436f3eeb5534307cc70c4b501f8b037dae4bc6`

## Windows executable identity — CLOSED

Both Public and Creator builds passed an explicit Windows VersionInfo gate:

- `ProductName = NAJXBox Manager`
- `FileDescription = NAJXBox Manager`
- `CompanyName = NAJXBox`
- `InternalName = NAJXBox_Manager.exe`
- `OriginalFilename = NAJXBox_Manager.exe`
- `FileVersion = 2.0.3.0`

The compiled assembly/output name is now `NAJXBox_Manager`, so the actual built executable is `NAJXBox_Manager.exe`.

Generated application icon resource names are also NAJXBox:
- `NAJXBox_Public.ico`
- `NAJXBox_Creator.ico`

The visible icon monogram remains `NA`.

## User-facing program branding

The existing v2.0.2 NAJXBox UI branding is retained and revalidated:
- `NAJXBox Manager 2.0`
- `NAJXBox Manager 2.0 · Creator`
- `正式 NAJXBox`
- `可用 NAJXBox`
- `安装 / 更新 NAJXBox`
- NAJXBox backup/language/runtime/test-package wording

The right-side edition marker reports `v2.0.3`.

## Program-owned external identity cleanup

New program-owned external identifiers now use NAJXBox where compatibility does not require the historical name:
- Manager HTTP User-Agent: `NAJXBox-Manager/2.0`
- MoE HTTP User-Agent: `NAJXBox-Manager-MoE/2.0`
- self-update temporary executable prefix: `NAJXBox_Manager_`
- new temporary MoE safety/download prefixes: `NAJXBox_MoE_`

## Compatibility identifiers intentionally preserved

These are **not rename defects** and remain CNBOX-compatible by design:
- public repository/raw endpoint: `modanbo/CNBOX-Updates`
- Gitee legacy mirror: `modanbo/cnbox-updates-cn`
- legacy stable updater URL `manager/CNBOX_Manager.exe`
- legacy LocalAppData/state folder `CNBOX_Manager`
- historical JSON fields such as `cnboxVersion`
- legacy backup/language/MoE/candidate owner paths and manifest names
- old release names, payload paths, hashes and history evidence
- internal source namespace/path names that are not user-facing executable identity

Changing those in-place would break old installs, rollback, updater continuity or provenance.

## Published aliases

Public:
- legacy stable compatibility path: `manager/CNBOX_Manager.exe`
- NAJXBox stable alias: `manager/NAJXBox_Manager.exe`
- NAJXBox versioned: `manager/NAJXBox_Manager_v2.0.3.exe`

Creator:
- legacy stable compatibility path: `manager/CNBOX_Manager_Creator.exe`
- NAJXBox stable alias: `manager/NAJXBox_Manager_Creator.exe`
- NAJXBox versioned: `manager/NAJXBox_Manager_Creator_v2.0.3.exe`

Bundle:
- `manager/NAJXBox_Manager_v2.0.3.zip`

For each flavor, the legacy stable alias and NAJXBox alias are the exact same binary bytes.

## Functional boundary

v2.0.3 is a Manager program-branding closure. It does **not** change:
- the formal Box payload or functional lock;
- Aslain #05 R4 candidate bytes;
- PlayersPanel / EFF / localization behavior;
- Public-vs-Creator track separation;
- collection-role semantics from v2.0.2;
- MoE ownership/persistence rules.

The formal Box baseline and current Aslain #05 engineering target therefore remain unchanged.
