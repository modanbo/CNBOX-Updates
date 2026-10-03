# NAJXBox Manager — Public Files

Current machine authority: `../channel.json`.

## Current version

**2.1.5**

- exact final source: `810a1a4e8d6141e26768a7624a5324daf277da57`
- final validation Run: `37124572198`
- Public SHA256: `47706d47671df61787a4fc8b5088e178b1fcc0c595590635a77f183d1bc469d5`
- Creator SHA256: `caf3e20eabc1bd46ab1aeebeef3d75588d64c4beb24a3f007c2010388516f89e`
- Public/Creator Build + SelfTest + UI: PASS
- final full-button/closure audit: PASS
- real-machine bottom-border correction: PASS

Presentation contract:
- Aslain current/latest text is black; update notice is DarkGreen.
- Box/MoE/Language current form `<installed> | 最新版本<latest>` is all black.
- Update form `<installed> | 可更新<latest>` keeps the prefix black and colors only `可更新<latest>` DarkGreen.
- MoE action button remains `安装/更新打环插件`.

Security:
- Defender: NOT_REQUIRED / NON_BLOCKING.
- VirusTotal: NOT RUN for this exact build.
- disposition: USER_APPROVED EXACT-SHA RELEASE EXCEPTION.
- exception scope: Public SHA `47706d47671df61787a4fc8b5088e178b1fcc0c595590635a77f183d1bc469d5` only.

Live Manager files:
- `CNBOX_Manager.exe` — legacy Public alias.
- `NAJXBox_Manager.exe` — canonical Public alias.
- `NAJXBox_Manager_v2.1.5.exe` — versioned Public binary.
- `CNBOX_Manager_Creator.exe` — legacy Creator alias.
- `NAJXBox_Manager_Creator.exe` — canonical Creator alias.
- `NAJXBox_Manager_Creator_v2.1.5.exe` — versioned Creator binary.
- `NAJXBox_Manager_v2.1.5_RELEASE_EXCEPTION.json` — exact-SHA security disposition.

Superseded versioned Manager binaries are removed from the live tree; Git history/private rollback storage retains their provenance.
