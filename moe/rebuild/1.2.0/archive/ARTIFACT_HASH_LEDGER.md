# NAJXBox MoE — Artifact / Hash Evidence Ledger

Date: 2026-09-23
Purpose: immutable lookup ledger for source identity.

## Official CN authority chain

| Layer | Artifact | Size | SHA256 | Status |
|---|---|---:|---|---|
| WBP | `2.4.0.1-105ad6c75b9855c6fd70c247bfa01312.wbp` | 310025 | `3eea4d9432a0e7ed0400583d2108bc4873b6e14531d576023dec2bd948c6bd16` | AUTHORITY |
| WOTMOD | `Files/mod_mark_on_gun.wotmod` | 320639 | `d681691e7205b1b41f682fdbe7491bbed8af8c78d847afc6dbba93d1455501d4` | AUTHORITY |
| SWF | `res/gui/flash/wotassist.markongun.swf` | 36170 | `06b5af3c859de1f343a14e66dcc433cb99eee0e237b5131981f453a9eea2f851` | AUTHORITY |

Duplicate WBP upload with `(1)` suffix is byte-identical.

## Pinned NA/Global upstream identities

ProTanki Aslain outer package:
- `MarksOnGun_Gun_Marks_Calculator_a834e732.zip`
- SHA256: `3df826d272877fca504b48d968b68e4e82e7118ba7da17c27ae61c5fc24201ee`

Original ProTanki WOTMOD:
- `tv.protanki.gunmarkscalc_8.1.01.wotmod`
- SHA256: `e83eeab978e7599fb0924e01933df1c863977ee33984e2701270b23cda27a408`

CHAMPi EVV pinned Aslain package:
- version: 2.05.000
- archived package SHA256 from history: `4fcb507d6ab133b959c99fa18af5c917e98b824f7a2b0e86210db5a3df87555c`

## Historical candidate evidence

These are evidence only, not 1.2.0 baselines.

1.0.9:
- payload: `0cdf01752860e172ae52bcd75ad31993bf13a5698662910f76b8f699f2aa2744`
- ProTanki WOTMOD: `8728f3d3a15a17e98873bf4e51ae32ec96fb01053ffd119f5f276b332b24e2f4`
- EVV WOTMOD: `fc22480047e9f64e14fe5f0a38e283bfe4f7382250246b36b07ec0829968b4d6`

1.0.10:
- payload: `f9f36389eb2177438efdbf75e5846bb010ec5f2f20411ad6e32097b532508f2f`
- ProTanki WOTMOD: `6fe0cf9eed57cd9adfcd55edf4884ae79d8abee41ae71daa775e7c4506d6b56a`
- EVV WOTMOD: `0da6b4511e22a6be977bbce881245d1bc21c927d4763d232288c38db61961710`

1.1.0:
- payload: `5b98aac5340547ff4bfe2c1f6d2fa16545fc7873d9e9df21158214c71cce8b50`
- ProTanki WOTMOD: `50dff15a98b1613c5847477500a822f091ee11f385d5e6e45445524c47860809`
- EVV WOTMOD: `2fec0d57ca5e8cdabf4bf580f77c39f1974530c075533908bf6da6ad1127c0f0`

1.1.2:
- payload: `21d2a89711efd591fe7091237538871c17a83cb2c5540a6cbc2762e3792eb3cb`

## 1.2.0 verification evidence

- `STATIC_GATE_VERIFY.txt`
- latest recorded result: PASS
- `PASS_ALL 12`
- gates include:
  - formula;
  - threshold local-only;
  - native damage observer-only;
  - rejected-framework absence;
  - single official-contract view ownership.

## Recovery probe interpretation

`OFFICIAL_SWF_RECOVERY_PROBE.txt` reported `EXACT_HASH_NOT_FOUND` when scanning derived 1.0.9-1.1.3 payloads.

This does NOT mean the authority asset was lost. The original WBP was later recovered from the user file library and exactly matched all three locked hashes.

Permanent rule:
- derived candidate payloads are not source archives;
- original upstream artifacts and their hashes remain the identity authority.
