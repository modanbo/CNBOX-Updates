# NAJXBox MoE 1.2.0 FULL REBUILD — OWNER VERDICT

Date: 2026-09-23
Status: ARCHITECTURE LOCK BEFORE IMPLEMENTATION

## Why a full rebuild is authorized

Runtime evidence invalidated the previous ownership assumptions:
- NA settings UIs leaked into the product;
- battle cursor/drag owners conflicted;
- 1.1.2/1.1.3 introduced a confirmed battle-damage display regression;
- most importantly, the native WoT battle damage counter was reported stuck at 0 while the MoE stack was installed.

Therefore the previous “do not redissect unchanged cores” rule is superseded for this incident. The new goal is not to modify the old composition; it is to remove it.

## Final dependency verdict

### REJECT AS RUNTIME DEPENDENCY — ProTanki stack

#### tv.protanki.gunmarkscalc_8.1.01.wotmod
Use only as semantic/reference evidence.
Do not install it in 1.2.0.

Reason:
- protected Python event/data owner;
- own BattleDisplayable/Injector/View;
- own old/new/new-simple panels;
- own dragArea/cursor/position flow;
- settings and UI integration depend on the surrounding ProTanki ecosystem.

#### izeberg.modssettingsapi_1.7.0.wotmod
Reject.

Reason:
- settings window owner;
- hotkey owner;
- registered settings callbacks and state persistence;
- directly caused unwanted third-party settings UI to be exposed in prior packages.

#### me.poliroid.modslistapi_1.7.9.wotmod
Reject.

Reason:
- lobby modification-list button/popover owner;
- GameFace/lobby injection owner;
- not required for MoE calculations.

### REJECT AS RUNTIME DEPENDENCY — EVV stack

#### champi.expectedvehiclevalues2_2.05.000.wotmod
Use only as historical/threshold semantic reference.
Do not install whole WOTMOD in 1.2.0.

Reason:
- contains both garage and battle UI;
- protected Python combines data/model/settings ownership;
- battle SWF has its own Ctrl/keyboard drag implementation;
- full runtime package is much broader than the threshold data we actually need.

#### champi.settingsgui_1.81.wotmod
Reject.

Reason:
- explicit CHAMPi settings UI owner.

#### aslain.modmenu_2.0.17.wotmod
Reject.

Reason:
- explicit garage Mod Menu/settings owner.

#### gambiter.guiflash_0.6.6.wotmod
Reject.

Reason:
- not a passive helper;
- owns Battle/Lobby runtime view lifecycle;
- owns SHOW_CURSOR/HIDE_CURSOR handling;
- owns draggable components and cursor behavior;
- high-risk overlap with the WoT-native Ctrl cursor path.

#### net.openwg.gameface_1.1.6.wotmod
Reject for the 1.2.0 target architecture unless a later proof shows a required non-UI data dependency.

Reason:
- new architecture uses one Scaleform/Flash official-CN-style view;
- no need to keep the old EVV GameFace injection stack.

## RETAIN AS AUTHORITY / REIMPLEMENT SAFELY

### Official CN UI contract

Source authority:
- user-supplied official CN WBP 2.4.0.1
- wotassist.markongun.swf SHA256:
  06b5af3c859de1f343a14e66dcc433cb99eee0e237b5131981f453a9eea2f851

Retain:
- MarkOnGunUI visual/state contract;
- MarkOnGunPanel visual/state contract;
- exact 147x93 battle geometry;
- exact 210x134 lobby geometry;
- official ring/stars/arrows/background assets;
- as_updateData array contract;
- official drag/hover interaction semantics.

Do not retain:
- CN request server;
- CN RequestCache;
- CN MDICT/ESTIMATEDICT network ownership;
- unsafe monkey-patch patterns if they can suppress WoT-native event processing.

### WoT-native data

Garage source:
- current vehicle dossier:
  - movingAvgDamage
  - damageRating
  - marksOnGun

Battle source:
- WoT battle feedback events:
  - DAMAGE
  - RADIO_ASSIST
  - TRACK_ASSIST
  - STUN_ASSIST
  - TANKING

The plugin must observe/subscribe without replacing or swallowing the original native battle feedback chain.

## Formula authority

The official CN protected code metadata exposes:
- movingAvgDamage
- c_movingAvgDamage
- battleDamage
- assist buckets
- calc()
- constant 0.019801980198019802

That constant equals 2 / 101, consistent with a 100-period EMA.

Target formula to verify offline before implementation:
combined = damage + max(radio_assist, track_assist, stun_assist)
new_moving_average = old_moving_average + (2 / 101) * (combined - old_moving_average)

The exact assist selection and all edge cases must be validated before Runtime.

## Threshold data

65/85/95/100 thresholds are NOT a reason to reinstall EVV.

Target:
- NAJXBox-owned read-only threshold database shipped with the plugin/update;
- updated out-of-game by build/Manager workflow;
- game runtime reads locally only.

Candidate public reference source:
- Tomato.gg NA MoE requirements (65/85/95/100, timestamped).

No live browser/network dependency is allowed in battle.

## 1.2.0 target package

One NAJXBox-owned WOTMOD only:
- one Python core;
- one official-CN-contract SWF;
- one private/simple config for position/language only;
- optional local threshold JSON.

No third-party settings/menu/list framework.
No third-party cursor/drag framework.
No ProTanki WOTMOD.
No EVV WOTMOD.
No Aslain ModMenu.
No CHAMPi SettingsGUI.
No ModsSettingsAPI.
No ModsListAPI.
No GUIFlash.
No OpenWG GameFace unless later evidence proves it is strictly required.

## Release blockers

Before first Runtime package:
1. static proof that native battle feedback owner is not replaced;
2. no third-party settings UI owners in package;
3. no third-party battle cursor/drag owners in package;
4. one visible battle view owner;
5. one visible garage view owner;
6. offline formula vectors PASS;
7. threshold database provenance/version recorded;
8. two review passes.

Runtime must prove:
- WoT native damage counter increments normally;
- official 147x93 battle UI;
- official 210x134 garage UI;
- Ctrl shows WoT cursor;
- panel drag/persistence works;
- no foreign settings UI;
- all displayed MoE values update correctly.
