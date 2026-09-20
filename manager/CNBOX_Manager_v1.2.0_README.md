# CNBOX Manager v1.2.0 — Detailed Guide

## Release identity

- Manager: **v1.2.0**
- Public SHA256: `5e4b956da1f182de9b6b5b14874f4665aae848a9bdef4ff0ed5db48298ed5fe1`
- Creator SHA256: `203ab9da4e358a0276ed552d4c69f1e3d27351bee614af2f4825ab4612436030`
- Dual-flavor build ZIP SHA256: `39752462c1d1f3a738833bb30cdcc0b43ababd7f21503753bd80efb258269d4b`
- GitHub Actions build/self-test run: `35530551967`
- Build source: `8a927604d0b4ef4ab6ebb08a3a18f87e6de4f796`

Current Box identities remain unchanged:
- Public Standalone: `2401-R34-R2F9-UNIFIED-R2`
- Creator / Aslain: `2401-03-R34-R2F9-FINAL_LOCK-R1`
- Shared functional ID: `WOT2401-R34-R2F9`

A Manager version update is not automatically a Box functional update.

## v1.2.0 new UI: current localization state

v1.2.0 adds a visible language-state label next to the language controls.

Normal states:
- `当前语言：原始 NA 英文`
- `当前语言：中文界面 + 中文坦克名称`
- `当前语言：中文界面 + 英文坦克名称`

Warning states:
- `状态异常（CNBOX 记录不一致）`
- `非 CNBOX / 未确认（<language>）`
- `无法确认`

Display colors:
- original NA English: gray;
- confirmed CNBOX localized mode: green;
- inconsistent / unmanaged / unknown: red.

The state refreshes after:
- selecting or detecting the NA client;
- applying Chinese UI + Chinese vehicle names;
- applying Chinese UI + English vehicle names;
- direct switching between those two localized modes;
- restoring original language.

The window title and main heading also display the actual Manager version:
- `CNBOX Manager v1.2.0`
- Creator: `CNBOX Manager v1.2.0 [Creator]`

## How state is determined

The Manager does **not** remember “the last button clicked” and present that as truth.

It verifies:
1. selected NA client;
2. current WoT version;
3. `loc_version.xml`;
4. versioned `res_mods/<WoTVersion>/CNBOX_LANGUAGE_OVERLAY_OWNER.json`.

A CNBOX localized mode is displayed only when the owner state and the active localization metadata agree.

No CNBOX owner state + `loc_version.language=en` is treated as `原始 NA 英文`.

An unproven or inconsistent state is shown as a warning instead of being silently classified as one of the normal modes.

## Direct switching is supported

**Yes.**

With World of Tanks fully exited:

`中文界面 + 英文坦克名称`
→ click **汉化（中文坦克名称）**
→ `中文界面 + 中文坦克名称`

and:

`中文界面 + 中文坦克名称`
→ click **汉化（英文坦克名称）**
→ `中文界面 + 英文坦克名称`

There is **no need** to press **恢复原始语言** between those two modes.

The Manager:
1. withdraws the previous CNBOX-owned language overlay;
2. restores the pre-CNBOX overlay baseline;
3. generates the selected full versioned overlay;
4. preserves the NA localization version/revision while localized language remains `zh_sg`;
5. invalidates `data.wgpdc`;
6. lets WoT rebuild the corresponding VehicleItem / VehicleType localization cache at next launch.

Use **恢复原始语言** only when the desired result is the original NA English UI and English vehicle names.

## v1.1.2 language pipeline retained unchanged

v1.2.0 does not redesign the language core again.

The previously Runtime-proven pipeline remains:
- official NA `res` stays original during normal localization;
- merged translation files are written under `res_mods/<WoTVersion>/text/lc_messages`;
- font override is written under `res_mods/<WoTVersion>/gui/flash/fontconfig.xml`;
- current NA files are the skeleton;
- ASIA donor translations are merged only for matching current-NA keys;
- unmatched new NA text remains English;
- Chinese vehicle-name mode overlays the CN base / `_short` vehicle-name keys;
- English vehicle-name mode preserves the original current-NA vehicle-name values;
- `loc_version.xml` keeps the NA client's own version/revision and uses `language=zh_sg` only while localized;
- `data.wgpdc` is invalidated only while WoT is fully exited;
- WoT rebuilds vehicle localization caches on next launch.

## Root cause of the old English vehicle-name defect

Real-client diagnosis proved:
- the Chinese vehicle-name data existed;
- 2844 intended vehicle-name values matched and were persisted;
- Wulf returned Chinese values from the versioned overlay;
- XVM did not hardcode the standard English vehicle names;
- the stale English strings were already converted and persisted in WoT's `data.wgpdc` `vehicles_list / vehicles_cache`.

Changing only the `.mo` files was therefore insufficient.

When the localization-version language key was changed from `en` to `zh_sg`, WoT rebuilt `data.wgpdc` and VehicleItem / VehicleType immediately received the Chinese vehicle names.

The final fix treats overlay + localization-version metadata + PDC lifecycle as one transaction.

## Restore original language

**恢复原始语言**:
1. removes only CNBOX-owned language-overlay files;
2. restores any language files that existed in the same overlay paths before CNBOX took ownership;
3. restores the original NA `loc_version.xml`;
4. repairs legacy official-`res` language writes if an older Manager version modified them;
5. invalidates `data.wgpdc`;
6. lets WoT rebuild an English cache next launch.

## Original-language backup

Default structure under the selected rollback backup root:

`CNBOX_LANGUAGE_BACKUPS/<clientID>/<generation>/original_language.zip`

It remains the authoritative repair/fallback snapshot for the current client generation.

v1.2.0 does not use this ZIP as a reason to rewrite official `res` during every normal localization operation.

## Pre-existing overlay preservation

Before CNBOX first owns the versioned language paths, existing files at those exact paths are saved in:

`preexisting_language_overlay.zip`

Switching/restoring removes only paths declared in the CNBOX language owner state, then restores the saved pre-existing overlay.

This avoids treating unrelated mod files as CNBOX files.

## WoT/WGC update handling

If WoT/WGC updates the client while localized and the four-part WoT version remains the same:
- the newer `loc_version.xml` revision is treated as authoritative;
- CNBOX does not overwrite it with a previous-generation revision;
- the next localization operation preserves the new version/revision and changes only the language field;
- a new original-language backup generation is created.

## Real-client Runtime closure already completed

The real NA client completed:
1. Chinese UI + Chinese vehicle names — **PASS**
2. Restore original NA English — **PASS**
3. Chinese UI + English vehicle names — **PASS**
4. Restore original NA English again — **PASS**

v1.2.0 only adds the visible current-state display and version presentation. It does not require the earlier V1→V5 diagnostic chain to be repeated.

## Public vs Creator

### Public
For external users/friends:
- Aslain is not required first;
- the Public Standalone Box includes the dependencies required by CNBOX;
- unrelated plugins outside CNBOX ownership are retained;
- Runtime/Diagnostic developer collection UI is hidden;
- self-update follows the public stable Manager channel.

### Creator
For the author's migration environment:
- retains Runtime/Diagnostic collection and creator tools;
- follows the actual Aslain version for future Creator Box migrations;
- must not be replaced by the Public Manager through public self-update;
- Public Standalone packaging is not used as a Creator-track update source.

## Operating rule

Before every language operation:
**fully exit World of Tanks.**

Then:
- choose either localized mode directly;
- read the visible `当前语言` status;
- launch WoT;
- use **恢复原始语言** only when returning to pure NA English.
