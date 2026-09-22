# CNBOX Manager v2.0.1

CNBOX Manager v2.0.1 is a Manager/Creator maintenance release. It fixes Creator test-candidate version visibility and test-transaction identity. It does **not** change the CNBOX Box functional release.

## Release identity

- Source repository: private engineering repository `modanbo/NA-BOX`
- Source branch: `manager-v2-rebuild`
- Source commit embedded in binaries: `8c84a663c951a3ffadaa792200cd975ada6b7736`
- Verified self-hosted workflow run: `35763527932`
- Runner: `SEAGULL` / self-hosted Windows X64
- Workflow result: PASS
- Architecture audit: PASS
- Public Build: PASS
- Public SelfTest: PASS
- Creator Build: PASS
- Creator SelfTest: PASS
- Dual-flavor ZIP SHA256: `796035dc712b7cbb5f4ac7f443e3f986443d55f842c26cd245826fa17c1088ff`
- Public SHA256: `e32fbb44e3cc641b3a1c64362c5cb183938c77ef39fcf97f68cac9b3be848476`
- Creator SHA256: `4f6631656ed59aa90bae2abe3a532cb3a1cad8e592acfc9031fd3c18927e0e81`
- File/assembly version: `2.0.1.0`

## What changed

Creator v2.0.0 displayed only the local test-transaction state. Before a test package was installed, the UI could only show `无活动测试包`, even when engineering had already published a current test candidate.

v2.0.1 adds explicit Creator test-candidate identity:

- before install: `可用: <candidate version>`;
- after exact install: `活动: <candidate version>`;
- if candidate-owned files change after install: `已变化: <candidate version>`;
- install confirmation shows version, ZIP name and SHA256;
- `TestPackageTransaction` persists candidate version/status/Aslain/XVM identity;
- future test ZIPs may carry root `CNBOX_CANDIDATE_MANIFEST.json`;
- root test metadata is never installed into the WoT client;
- older test ZIPs remain identifiable when their exact SHA256 matches the Creator-only channel candidate.

## Creator-only candidate channel

`channel.json` has a top-level `creatorTestPackage` object. It is deliberately **outside** `releases[]`.

Therefore:

- Public release selection ignores it;
- normal Creator Box release selection ignores it;
- it cannot promote a test candidate to a formal Box release;
- it is used only by Creator test-package UI / transaction identity.

Current advertised candidate:

- version: `2401-05-R34-R2F9-TEST-CANDIDATE-R4`
- WoT: `2.4.0.1`
- Aslain: `2.4.0.1 #05`
- XVM: `13.1.0.0090`
- Runtime ZIP SHA256: `65852ab8876c415a96e02f4b46b5680fd3350f7592f290ed9adcb7b488cdcf0c`

R4 remains a Runtime candidate and is **not FINAL_LOCK** until the required real-game Runtime/regression/rollback closure passes.

## Self-hosted build correction

Private GitHub-hosted runners were unavailable because paid Actions overage is intentionally disabled. The project now has a no-paid-Actions self-hosted build path.

During bring-up, the self-hosted runner exposed two environment assumptions:

1. Windows PowerShell execution policy blocked the runner's temporary script. The workflow now uses per-process `-ExecutionPolicy Bypass`; no permanent Windows policy change is required.
2. The old Aslain freshness SelfTest assumed the machine's local Aslain catalog set was empty. That happened to be true on hosted runners but not on the user's real SEAGULL machine. The test was corrected to bind to the machine's actual current catalog-set identity while preserving the original rule that any later manifest/catalog generation change invalidates stale evidence.

The final v2.0.1 run passed both flavors and all SelfTests.

## Published program paths

Public:
- stable: `manager/CNBOX_Manager.exe`
- versioned: `manager/CNBOX_Manager_v2.0.1.exe`

Creator:
- stable: `manager/CNBOX_Manager_Creator.exe`
- versioned: `manager/CNBOX_Manager_Creator_v2.0.1.exe`

Dual-flavor archive:
- `manager/CNBOX_Manager_v2.0.1.zip`

## Public / Creator separation

Public remains restricted to verified `PUBLIC_STANDALONE + FINAL_LOCK` releases. Creator remains on the Aslain-versioned compatibility track. Creator test candidates are isolated from both formal selection paths.

This Manager release does not alter the current Public Box functional release and does not promote Aslain #05 R4.
