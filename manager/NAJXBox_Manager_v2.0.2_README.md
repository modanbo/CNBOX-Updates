# NAJXBox Manager v2.0.2

Status: **FORMAL RELEASE / PUBLIC BUILD PASS / PUBLIC SELFTEST PASS / CREATOR BUILD PASS / CREATOR SELFTEST PASS / UI SNAPSHOT PASS**

Date: 2026-09-22
Verified run: `35773869617`
Self-hosted runner: `SEAGULL / Windows / X64`
Source branch: `manager-v2-rebuild`
Source commit: `9ce4102057f5059490e671bb8ddeb8ce5ce739d8`

## Release hashes

- Public EXE SHA256: `7e6660b49b1614cef15d6e74467c4923648c9634479d76d0968c44cf4ebc45b4`
- Creator EXE SHA256: `b71ffdd4983b37af9bcc502e5660b2247488fa12c6c8a9a35ff2ee621e20e974`
- dual-flavor artifact ZIP SHA256: `46de3c1b7e5e4013191a772a84a09c36e0819919973eef47c8a3696200d4ec63`
- file/assembly version: `2.0.2.0`

## External product name

The user-facing product name is now **NAJXBox**.

v2.0.2 changes visible Manager/Creator branding and the generated icon monogram to NA / NAJXBox.

Backward compatibility is intentionally preserved:
- legacy `CNBOX_Manager` local state folders remain readable;
- historical `cnboxVersion` JSON/channel fields remain readable;
- historical package/manifests/hashes are not renamed in place;
- old stable updater URLs `manager/CNBOX_Manager.exe` and `manager/CNBOX_Manager_Creator.exe` remain valid and now carry the v2.0.2 binaries.

New canonical binary aliases are also published:
- `manager/NAJXBox_Manager.exe`
- `manager/NAJXBox_Manager_Creator.exe`
- `manager/NAJXBox_Manager_v2.0.2.exe`
- `manager/NAJXBox_Manager_Creator_v2.0.2.exe`
- `manager/NAJXBox_Manager_v2.0.2.zip`

Repository / Gitee / Drive renaming is a separate controlled migration after this release.

## 1. Clear current Mod identity

The old dashboard split Aslain, formal CNBOX and Creator test-package state across separate areas, so a user could not immediately tell whether the selected client was:

- only an Aslain #05 base,
- a formal locked Box,
- an active R4 test candidate,
- or an untracked/mixed residue state.

v2.0.2 adds a dedicated **当前运行 Mod** field and renames the old current Box cell to **正式 NAJXBox**.

Possible runtime identities include:

- `Aslain #05 基底`
- `正式 NAJXBox · #04 FINAL · 基底 #05`
- `测试 R4（活动） · 基底 #05`
- `测试 R4（文件已变化） · 基底 #05`
- `混合/未跟踪 · N 项`
- `未确认`

The formal release origin and the current Aslain base are deliberately separate. A #04 formal Box surviving on a #05 base must never be mislabeled as `#05 FINAL`.

The runtime identity model uses:
- active Creator test transaction first;
- verified formal installed state/fingerprint second;
- managed NAJXBox residue detection third;
- confirmed Aslain baseline only when no managed formal/test/residue evidence exists.

## 2. Collection model redefined

The ambiguous `Runtime 采集 / 诊断采集` split is replaced.

Creator UI now shows:

- **测试前完整采集**
- **Runtime 问题包**

and an inline explanation:

`测试前完整采集 = Public 独立包闭包检查；Runtime 问题包 = 游戏故障完整证据（已包含测试前核心）`

### 测试前完整采集

Purpose: prove the Creator test candidate contains everything needed to construct the **Public standalone** distribution, because Public users do not depend on Aslain being installed.

The package contains:
- `version.xml`
- `loc_version.xml`
- `aslain_installed.xml`
- Aslain/version metadata when present
- python/xvm logs
- complete known NAJXBox/XVM/OpenWG/PlayersPanel dependency scope
- full XVM Aslain config
- XVM `py_macro`
- XVM shared runtime
- XVM/OpenWG core/fix WOTMODs
- XVM audio banks
- NAJXBox owner files
- files introduced by the active Creator test transaction
- Manager installed state
- Creator test transaction
- Aslain native-state evidence

It also creates:

`NAJXBOX_PUBLIC_STANDALONE_INPUT_INVENTORY.json`

This is a SHA256 inventory of the active:
- `mods/<wotVersion>`
- `res_mods/<wotVersion>`
- `res_mods/configs/xvm`
- `res_mods/mods/shared_resources/xvm`
- `mods/configs`

Files outside the known dependency scope are inventoried for audit but are not automatically copied as Public dependencies. This is designed to expose a new dependency that Aslain supplies in Creator but which the standalone builder has not yet classified.

When an exact active test candidate is installed, the package is marked as candidate-closure eligible. Without an exact active candidate it is marked `BASELINE_ONLY`.

### Runtime 问题包

Purpose: one complete package for an actual in-game formal/test-candidate problem.

Runtime is defined as a **superset** of the pre-test standalone evidence. It includes the same dependency core and standalone inventory, then adds:
- recent screenshots
- fresh python/xvm issue context
- candidate/formal file-hash verification
- Manager/Aslain state
- Creator test transaction
- runtime issue summary

Both collection types include root:

`NAJXBOX_COLLECTION_ROLE.json`

Pre-test:
- role = `PRETEST_STANDALONE_FULL`

Runtime:
- role = `RUNTIME_PROBLEM_COMPLETE`
- `supersetOf = ["PRETEST_STANDALONE_FULL"]`
- `sameIncidentSecondPackageRequired = false`

Therefore, for the **same client/test state**, after a valid Runtime package is uploaded, the workflow must not generically request an additional diagnostic/pre-test package. A second package is justified only when the Runtime ZIP is corrupt or a specifically named artifact is demonstrably absent.

## 3. Collection button gating

The UI gating is now explicit:

- valid client / Aslain base only:
  - `测试前完整采集` = enabled
  - `Runtime 问题包` = disabled
- formal NAJXBox installed:
  - Runtime = enabled
- active Creator test candidate:
  - Runtime = enabled
- active test candidate with later file changes:
  - Runtime remains enabled so the mismatch can be captured
- Public flavor:
  - no Creator collection controls are exposed

This prevents a user from being guided to Runtime before any formal/test package exists.

## 4. Public standalone safety rule

Public is independent from Aslain.

The pre-test collector is therefore intentionally broader than a lightweight diagnostic collector. It exists to prevent this failure mode:

`Creator works because Aslain supplied a dependency -> Public package omits it -> external user fails`.

Before a new Public standalone package is promoted:
1. install the intended Creator test candidate exactly;
2. run `测试前完整采集` before real-game Runtime;
3. use the dependency files + whole-tree inventory to build/audit Public standalone;
4. run normal real-game Runtime;
5. use Runtime as the complete incident package if a game issue appears.

## 5. Validation closure

Final run `35773869617` passed:

- build environment: PASS
- Manager 2.0 architecture audit: PASS
- Public Build: PASS
- Public SelfTest: PASS
- Creator Build: PASS
- Creator SelfTest: PASS
- Public UI snapshot: PASS
- Creator UI snapshot: PASS
- artifact staging: PASS
- artifact upload: PASS

SelfTests cover:
- Public/Creator surface separation
- runtime identity formatting
- old formal #04 on current #05 base
- active R4 test identity
- changed test-owned files
- pre-test standalone inventory
- unrelated Aslain plugin inventory-vs-copy behavior
- XVM shared runtime inventory
- Runtime pre-test superset contract
- collection role markers
- no-double-upload contract
- collection button gating

## 6. R4 remains unchanged

This Manager release does **not** modify the Aslain #05 R4 Box payload.

Current R4:
- `2401-05-R34-R2F9-TEST-CANDIDATE-R4`
- SHA256 `65852ab8876c415a96e02f4b46b5680fd3350f7592f290ed9adcb7b488cdcf0c`
- status: TEST_CANDIDATE / static + two-review + rollback PASS / real game Runtime still required

Manager v2.0.2 must not promote R4 to FINAL_LOCK by itself.
