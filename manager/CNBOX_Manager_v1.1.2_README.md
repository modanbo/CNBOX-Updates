# CNBOX Manager v1.1.2 — Public Stable

## Release identity

- Manager: **v1.1.2**
- Public EXE: `manager/CNBOX_Manager.exe`
- Versioned Public EXE: `manager/CNBOX_Manager_v1.1.2.exe`
- Public SHA256: `93845b4189e46c55171be3361e4876ac48e5c6a6877d84c18b0ba2e8cb3035d9`
- Creator SHA256: `ca5cf53ce804005f5982bfbdaaadadde266bdb7a9f74034a4b0d622b5a5f64b8`
- Dual-flavor build ZIP SHA256: `99a2f707bdf8c748b8766fbd728c20ff9894803979cbfef3731f36bd979184f6`
- Build workflow run: `35529399505`
- Built source head: `ac7b02b4be86c80c63104deec03a826ddda90511`
- Public Box: `2401-R34-R2F9-UNIFIED-R2`
- Creator / Aslain baseline: `2401-03-R34-R2F9-FINAL_LOCK-R1`
- Shared functional ID: `WOT2401-R34-R2F9`
- WoT: `2.4.0.1`
- XVM: `13.1.0.0089`

Manager version updates are independent from Box functional-version updates. Public Standalone and Creator / Aslain are separate release tracks.

---

## Public vs Creator

### Public

Public is for external users/friends.

- Aslain is not required before installing CNBOX.
- The standalone payload contains the dependencies CNBOX needs.
- Unrelated Aslain plugins outside the declared CNBOX ownership scope are preserved.
- Runtime / Diagnostic / collection-path development controls are hidden.
- Public self-update always remains on the Public Manager track.

### Creator

Creator is the engineering build used by the CNBOX author.

- Retains Runtime, Diagnostic and collection controls.
- Tracks the actual installed Aslain build for bottom-up Creator migration.
- Must not be replaced by the Public self-updater.
- If Aslain advances before the next Creator migration is ready, the Creator track waits for that migration instead of falling back to Public Standalone.

---

## v1.1.2 localization root-cause closure

v1.1.2 closes the defect where the UI became Chinese but vehicle names remained English.

The final Runtime chain proved:

1. CN vehicle-name data was present.
2. The Manager matched and persisted the intended vehicle-name keys.
3. The versioned `res_mods` language overlay contained Chinese vehicle names.
4. Wulf `getTranslatedText()` returned Chinese for the same vehicle keys.
5. WoT still displayed English because an older `data.wgpdc` contained already-converted English `vehicles_list` / `vehicles_cache` objects.
6. When the localization-version key moved from NA `language=en` to `language=zh_sg`, WoT rebuilt the PDC.
7. Rebuilt VehicleItem / VehicleType objects then contained Chinese vehicle names.
8. The user confirmed the Chinese names visually in the real NA client.

Therefore the fix is not “more translation keys”. The localization-version/PDC lifecycle is now part of the language transaction.

---

## Language file model in v1.1.2

Normal localization no longer writes translated data into official NA `res`.

The Manager builds a complete current-version overlay under:

`res_mods/<WoTVersion>/text/lc_messages`

Font override:

`res_mods/<WoTVersion>/gui/flash/fontconfig.xml`

The current NA files remain the skeleton. ASIA donor translations are merged only for keys that exist in the current NA skeleton. New current-NA keys not present in the donor remain English.

Chinese vehicle-name mode applies CN vehicle base/`_short` pairs only after the normal UI donor merge.

---

## The three language actions

### 汉化（中文坦克名称）

Result:

- Chinese UI.
- Chinese vehicle names.
- CN vehicle base/`_short` values are used.
- Other UI text is merged from ASIA into the current NA skeleton.

### 汉化（英文坦克名称）

Result:

- Chinese UI.
- English vehicle names.
- Vehicle-name base/`_short` keys preserve the current NA English values.
- Other UI text remains localized.

### 恢复原始语言

Result:

- CNBOX-owned language overlay files are removed.
- Pre-existing user/mod overlay files are restored.
- Original NA `loc_version.xml` is restored.
- Legacy official-`res` language writes from old Manager builds are repaired from the original backup only when needed.
- `data.wgpdc` is invalidated so WoT rebuilds English vehicle localization on next launch.

---

## Direct switching is supported

**Yes — users may switch directly between the two localized modes.**

With WoT fully exited:

- Chinese UI + English vehicle names → click **汉化（中文坦克名称）** directly.
- Chinese UI + Chinese vehicle names → click **汉化（英文坦克名称）** directly.

There is **no requirement to run 恢复原始语言 in between**.

Internally, Manager:

1. reads its language overlay owner state;
2. removes the prior CNBOX-owned overlay;
3. restores any overlay that existed before CNBOX took ownership;
4. returns to the original skeleton;
5. rebuilds the requested localized mode;
6. keeps the NA localization version/revision and sets localized language to `zh_sg`;
7. invalidates `data.wgpdc`;
8. lets WoT rebuild VehicleItem / VehicleType localization on next launch.

The required safety rule is that World of Tanks must be fully exited before any language operation.

---

## loc_version.xml behavior

When localized:

- `version`: preserve the NA client value.
- `revision`: preserve the NA client value.
- `language`: use `zh_sg`.

On restore:

- restore the exact original NA `loc_version.xml`.

If WGC/WoT updates the client while localized and changes the localization revision, the newer client revision remains authoritative. The Manager does not overwrite the newer revision with a previous-generation sidecar.

---

## data.wgpdc behavior

`data.wgpdc` is treated as derived persistent cache, not user data.

When switching localized modes or restoring original language, the Manager invalidates the cache while the selected WoT client is fully stopped. WoT rebuilds it on next launch with the new localization-version key and current overlay.

This is required even for Chinese-name ↔ English-name direct switches because both modes use `zh_sg`, while the vehicle-name content itself changes.

---

## Original-language backup

The original NA backup remains the recovery authority:

`<rollback backup root>/CNBOX_LANGUAGE_BACKUPS/<clientID>/<clientGeneration>/original_language.zip`

It stores the original current-generation NA language tree/font state.

v1.1.2 does not use this ZIP as a normal “overwrite official res every time” mechanism. It is a recovery/migration authority and is used to repair legacy v1.1.0/v1.1.1 official-`res` writes when hashes differ.

A new WoT generation creates a new original backup.

---

## Pre-existing overlay protection

CNBOX does not assume the versioned language overlay path belongs only to CNBOX.

On first ownership it stores pre-existing files in:

`preexisting_language_overlay.zip`

The owner state records exactly which paths CNBOX manages. Mode switching/restoration deletes only those CNBOX-owned files and then restores the user's pre-existing overlay.

---

## Running-client guard

Language apply/restore fails closed if the selected WoT client is running.

v1.1.2 recognizes executable layouts at:

- `WorldOfTanks.exe`
- `win64/WorldOfTanks.exe`
- `win32/WorldOfTanks.exe`

Do not manually change `.mo`, `loc_version.xml`, or `data.wgpdc` while WoT is running.

---

## Real Runtime matrix

The final real-client v1.1.2 Runtime passed all user-facing paths:

- 汉化（中文坦克名称）: **PASS**
- 恢复原始语言: **PASS**
- 汉化（英文坦克名称）: **PASS**
- 再恢复原始语言: **PASS**

The earlier V5 proof also showed that switching the localization key made WoT rebuild PDC and that VehicleItem / VehicleType values changed from English to Chinese as expected. V5 rollback restored the original `loc_version.xml` and original PDC SHA values.

No repeat of the V1→V5 diagnostic sequence is required for this release.

---

## Public Standalone Box relationship

Current Public Box:

`2401-R34-R2F9-UNIFIED-R2`

Current Creator/Aslain Box:

`2401-03-R34-R2F9-FINAL_LOCK-R1`

Both share:

`WOT2401-R34-R2F9`

The standalone R2 package is not a functional successor to the Creator R1 package. It is the same locked Box function packaged with the full dependency set for external users.

---

## Recommended normal workflow

1. Select the WoT NA client.
2. Check updates.
3. Install/repair CNBOX as needed.
4. Fully exit WoT before language switching.
5. Choose either Chinese vehicle names or English vehicle names.
6. Launch WoT normally.
7. To change vehicle-name mode later, fully exit WoT and click the other localized mode directly.
8. Use **恢复原始语言** only when returning to original NA English.

---

## Release verification

GitHub Actions run: `35529399505`

Result: `PASS_PUBLIC_CREATOR_BUILD_SMOKE_ARTIFACT`

Hashes:

- Public EXE: `93845b4189e46c55171be3361e4876ac48e5c6a6877d84c18b0ba2e8cb3035d9`
- Creator EXE: `ca5cf53ce804005f5982bfbdaaadadde266bdb7a9f74034a4b0d622b5a5f64b8`
- Dual-flavor ZIP: `99a2f707bdf8c748b8766fbd728c20ff9894803979cbfef3731f36bd979184f6`
