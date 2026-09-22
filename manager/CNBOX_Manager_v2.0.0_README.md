# CNBOX Manager v2.0.0

CNBOX Manager v2.0.0 is the formal release of the rebuilt Manager 2.0 architecture. The RC5 binaries that passed the final regression are promoted byte-for-byte; there is no rebuild delta between RC5 and the v2.0.0 stable binaries.

## Release identity

- Source repository: private engineering repository `modanbo/NA-BOX`
- Source commit: `13be723a793e2fba8ecbbdc4141884108a81810f`
- Verified dual-build workflow: `35678464425`
- Workflow result: PASS
- Dual-flavor ZIP SHA256: `06dd40346f3975572c6dee0b483f4ef126edad44d306e74926fd51e9789a52ec`
- Public SHA256: `420d18d06cf346ce48bdbcb51a1f56f09a1c044dc546fec7b083555c28248998`
- Creator SHA256: `e3cc8b06612d0a591027ec99ad311db75ed82ebb38e78e6b27b3a587643ad4c8`

## Public / Creator separation

Public and Creator are separate build flavors and separate release-selection tracks.

Public accepts a Box release only when all of the following are true:

- `installMode = CNBOX_AUTHORITATIVE`
- `releaseTrack = PUBLIC_STANDALONE`
- `status = FINAL_LOCK`
- WoT version matches

`TEST_CANDIDATE`, `CANDIDATE`, Creator/Aslain releases, and newer-looking test functional versions are ignored by Public. Public therefore remains on the last verified locked standalone Box until a newer Public package is explicitly promoted to `FINAL_LOCK`.

The final RC5 regression intentionally inserted a newer-looking Public `TEST_CANDIDATE` and proved that Public still selected the existing `FINAL_LOCK`.

## Creator compatibility rule

Creator does not assume that adjacent Aslain versions are compatible.

For the current Aslain #05 case, the locked #04 Box is allowed only because the actual #05 owner/XVM/OpenWG/PlayersPanel dependency surface still satisfies the #04 FINAL_LOCK contract. If a future Aslain update changes a required dependency, compatibility fails and the old Box is blocked.

## Public Box status

This Manager promotion is not a Box functional update.

The current Public Box remains:

- release: `2401-R34-R2F9-UNIFIED-R2`
- track: `PUBLIC_STANDALONE`
- status: `FINAL_LOCK`

## Published program paths

Public:
- stable: `manager/CNBOX_Manager.exe`
- versioned: `manager/CNBOX_Manager_v2.0.0.exe`

Creator:
- stable: `manager/CNBOX_Manager_Creator.exe`
- versioned: `manager/CNBOX_Manager_Creator_v2.0.0.exe`

Dual-flavor archive:
- `manager/CNBOX_Manager_v2.0.0.zip`

## Validation gates

The Manager 2.0 build workflow performs:

- static architecture audit against legacy 1.x authority paths;
- Public Release build;
- Public self-test;
- Creator Release build;
- Creator self-test;
- Public / Creator UI snapshot validation;
- icon-resource validation;
- dual-flavor artifact staging;
- SHA-256 publication.

The v2.0.0 publication also uses the repository's hash-gated binary publisher so the source archive hash and extracted target binary hash must match before a stable file can be committed.
