# NAJXBox Updates — Public Distribution

Role: **CURRENT PUBLIC DISTRIBUTION**

Machine update authority: `channel.json`.

## Current release set

- Manager Public: **2.1.5**
  - `manager/NAJXBox_Manager.exe`
  - legacy alias: `manager/CNBOX_Manager.exe`
  - SHA256: `47706d47671df61787a4fc8b5088e178b1fcc0c595590635a77f183d1bc469d5`
- Manager Creator (GitHub engineering distribution only): **2.1.5**
  - SHA256: `682a1804d76bf8d0fb9d22b26934d780889c86135acdef49649c96d703e368f8`
- Box: **1.1.0**
  - compatibility/public alias: `2402-01-R34-R2F9-UNIFIED-R6`
  - WoT: `2.4.0.2`
  - payload: `payloads/2.4.0.2/unified/CNBOX_PAYLOAD_R6.zip`
  - SHA256: `b40c9b17b8ac42806b857bb92120e2ebc36148498ff28a6c046d72890d7406f2`
- MoE / 打环: **1.3.0**
  - payload: `moe/1.3.0/NAJXBOX_MoE_INDEPENDENT_1.3.0_WOT_2.4.0.2_FINAL_LOCK.zip`
  - SHA256: `5d6bcfc871fdec58f8c8195eaecb0b9351a980ea917f3c054c0de66ebb134e19`
- Language / 汉化: **1.1.2**
  - payload: `language/NAJXBOX_LANGUAGE_1.1.2_WOT_2.4.0.2_FINAL_LOCK.zip`
  - SHA256: `1f2fa9c38f9029dba2a3ef3e2660fa828b3760f4e0c5958c1e26818300442f18`

Environment baseline:
- WoT `2.4.0.2`
- Aslain Creator/engineering compatibility `#02` (Public Box bytes remain the same R6 payload)
- XVM `13.1.0.0093`

## Current-tree retention rule

This repository's live distribution tree keeps the current installable release set. Superseded binary releases are retained by Git history and by the private engineering/Drive rollback archives rather than as competing current files.

Unique engineering history/reference material such as `moe/HISTORY.md`, `moe/reference/`, `moe/source/` and `moe/diagnostics/` is retained.

## Gitee

Gitee `modanbo/cnbox-updates-cn` is a **Public-only exact mirror** rebuilt from the current GitHub channel. Creator/private/history/test/evidence content is forbidden there.

Current Manager 2.1.5 GitHub publication is complete; Gitee synchronization is the remaining manual publication gate before the private engineering authority promotes Manager 2.1.5 as CURRENT_RELEASE.

For release identity, always use `channel.json` and `CURRENT_RELEASE_INDEX.md`.
