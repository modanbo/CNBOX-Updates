# NAJXBox Manager - Public Files

Current authority: ../channel.json.

Current version: **2.0.9**

Validated authority:
- exact build head: 1f4e3ac03324e3eb2309a817fc5451d008ab9649
- GitHub Actions run: 36271660560 - SUCCESS
- Chinese UI + Chinese vehicle names Runtime: PASS
- Chinese UI + English vehicle names Runtime: PASS
- Restore Original Language Runtime: PASS

Live GitHub files:
- CNBOX_Manager.exe - legacy stable Public compatibility alias.
- NAJXBox_Manager.exe - canonical stable Public alias.
- NAJXBox_Manager_v2.0.9.exe - current versioned Public binary.
- CNBOX_Manager_Creator.exe - legacy Creator engineering alias.
- NAJXBox_Manager_Creator.exe - canonical Creator engineering alias.
- NAJXBox_Manager_Creator_v2.0.9.exe - current versioned Creator binary.

Public Manager SHA256: 3335f513b60b671b95f377bd14bad586bddd4cc55a809492b9d26817e8d98bd3
Creator Manager SHA256: 4f220a44bc3c80fd00ef89ec8cfee3737e33e08d0935e39aef95bd892ed5552f

M209-032:
- both localization buttons share one enhanced language-owned fonts_zh_cn_sg.swf;
- Restore Original Language removes/restores it through exact language ownership;
- normal users do not run a PowerShell font patch.

Distribution boundary:
- Public self-update channel points only to the Public Manager.
- Creator remains an engineering binary retained in GitHub/Drive.
- Gitee final exact Public-only mirror is current at commit `9f83864`; Creator is excluded.
