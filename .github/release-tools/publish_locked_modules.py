#!/usr/bin/env python3
import argparse, hashlib, json, os, shutil, zipfile
from pathlib import Path

BOX_SHA="b40c9b17b8ac42806b857bb92120e2ebc36148498ff28a6c046d72890d7406f2"
MOE_SHA="5d6bcfc871fdec58f8c8195eaecb0b9351a980ea917f3c054c0de66ebb134e19"
MOE_WOTMOD_SHA="8ecb8017d8a38fca4415f542b1d4501b5d16c91f2460f5ab882e41e75c9c3804"
LANG_SHA="88b4932ed7106e89183a1c7ca778c559db02225bfc6f12a1707e0d51c89d0667"
BOX_PUBLIC_VERSION="2402-01-R34-R2F9-UNIFIED-R6"
BOX_CREATOR_VERSION="2402-01-R34-R2F9-FINAL_LOCK-R6"
RAW="https://raw.githubusercontent.com/modanbo/CNBOX-Updates/main"

def sha_file(path):
    h=hashlib.sha256()
    with open(path,"rb") as f:
        for c in iter(lambda:f.read(1024*1024),b""):h.update(c)
    return h.hexdigest()

def category(path):
    p=path.replace("\\","/").lower()
    if p.endswith("com.modxvm.xfw.crashfix_12.0.0.wotmod"):return "xvm_crashfix"
    if "com.modxvm.xvm_" in p and p.endswith(".wotmod"):return "xvm_core_wotmod"
    if "/net.openwg.common_" in p and p.endswith(".wotmod"):return "openwg_common"
    if "/net.openwg.fix." in p and p.endswith(".wotmod"):return "openwg_fix"
    if p.endswith("/audioww/xvm.bnk") or p.endswith("/audioww/xvm_wg.bnk"):return "xvm_audio"
    if "/scripts/client/gui/mods/mod_cnbox" in p or "/gui/flash/atlases/cnbox" in p or "battlevehiclemarkersapp.swf" in p or "/gui/maps/icons/vehicle/contour/cnbox_overhead_jx/" in p:return "cnbox_owner"
    if p.startswith("res_mods/configs/xvm/aslain/"):return "aslain_xvm_profile"
    if p.startswith("res_mods/configs/xvm/py_macro/"):return "xvm_py_macro"
    if p=="res_mods/configs/xvm/xvm.xc":return "xvm_root_config"
    if "/scripts/client/gui/mods/__init__.pyc" in p:return "xvm_client_runtime"
    if p.startswith("res_mods/mods/shared_resources/xvm/"):return "xvm_shared_runtime"
    return "other"

def box_files(box):
    rows=[];counts={}
    with zipfile.ZipFile(box) as z:
        for info in z.infolist():
            if info.is_dir():continue
            data=z.read(info.filename);c=category(info.filename);counts[c]=counts.get(c,0)+1
            rows.append({"path":info.filename.replace("\\","/"),"category":c,"sizeBytes":len(data),"sha256":hashlib.sha256(data).hexdigest()})
    if len(rows)!=534:raise SystemExit("Box file count != 534")
    return rows,dict(sorted(counts.items()))

def copy_verified(src,dst,expected):
    got=sha_file(src)
    if got!=expected:raise SystemExit(f"SHA mismatch {src}: {got}")
    dst.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,dst)
    if sha_file(dst)!=expected:raise SystemExit(f"copied SHA mismatch {dst}")

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--repo",required=True);ap.add_argument("--box",required=True);ap.add_argument("--moe",required=True);ap.add_argument("--language",required=True)
    a=ap.parse_args();root=Path(a.repo).resolve();box=Path(a.box);moe=Path(a.moe);lang=Path(a.language)
    copy_verified(box,root/"payloads/2.4.0.2/unified/CNBOX_PAYLOAD_R6.zip",BOX_SHA)
    copy_verified(moe,root/"moe/1.3.0/NAJXBOX_MoE_INDEPENDENT_1.3.0_WOT_2.4.0.2_FINAL_LOCK.zip",MOE_SHA)
    copy_verified(lang,root/"language/NAJXBOX_LANGUAGE_1.1.1_WOT_2.4.0.2_FINAL_LOCK.zip",LANG_SHA)

    files,counts=box_files(box)
    manifest={
      "schemaVersion":2,"functionalId":"WOT2402-R34-R2F9","release":BOX_CREATOR_VERSION,"wotVersion":"2.4.0.2",
      "description":"Exact R6 534-file standalone tree promoted after WoT 2.4.0.2 / Aslain #01 real-client Runtime. No label-only payload repack.",
      "sourceCreatorPayloadSha256":BOX_SHA,"publicPayloadSha256":BOX_SHA,"fileCount":534,"categoryCounts":counts,"files":files
    }
    mp=root/"manifests/2.4.0.2/CNBOX_FUNCTIONAL_R34_R2F9_R6.json";mp.parent.mkdir(parents=True,exist_ok=True)
    mp.write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
    manifest_sha=sha_file(mp)

    installed=[{"path":r["path"],"sha256":r["sha256"],"required":True} for r in files]
    common={
      "status":"FINAL_LOCK","wotVersion":"2.4.0.2","xvmVersion":"13.1.0.0093","payloadUrl":f"{RAW}/payloads/2.4.0.2/unified/CNBOX_PAYLOAD_R6.zip",
      "payloadSha256":BOX_SHA,"baselineFiles":[],"installedFiles":installed,"functionalId":"WOT2402-R34-R2F9"
    }
    public=dict(common);public.update({
      "cnboxVersion":BOX_PUBLIC_VERSION,"aslainVersion":"ANY","installMode":"CNBOX_AUTHORITATIVE",
      "managedDirectories":["res_mods/configs/xvm/Aslain","res_mods/configs/xvm/py_macro","res_mods/mods/shared_resources/xvm"],
      "managedGlobs":["mods/{wotVersion}/com.modxvm.xvm_*.wotmod","mods/{wotVersion}/com.modxvm.xfw/com.modxvm.xfw.crashfix_*.wotmod","mods/{wotVersion}/net.openwg/net.openwg.common_*.wotmod","mods/{wotVersion}/net.openwg/net.openwg.fix.battleresultscache_*.wotmod","mods/{wotVersion}/net.openwg/net.openwg.fix.battleresultsreplays_*.wotmod","res_mods/{wotVersion}/audioww/xvm*.bnk"],
      "notes":"Public standalone alias of the exact Runtime-tested R6 bytes. Source manufacturing base Aslain #01 is provenance only; Public install remains Aslain-independent.",
      "releaseTrack":"PUBLIC_STANDALONE","functionalManifestUrl":f"{RAW}/manifests/2.4.0.2/CNBOX_FUNCTIONAL_R34_R2F9_R6.json","functionalManifestSha256":manifest_sha
    })
    creator=dict(common);creator.update({
      "cnboxVersion":BOX_CREATOR_VERSION,"aslainVersion":"2.4.0.2 #01",
      "notes":"Creator/Aslain #01 formal compatibility lock from exact Runtime-tested R6 bytes.",
      "releaseTrack":"CREATOR_ASLAIN","compatibilityClassification":"B_CLEAN_TARGET_OWNER_API_REBASE","sharedByteAuthority":True
    })

    cp=root/"channel.json";channel=json.loads(cp.read_text(encoding="utf-8-sig"))
    channel["latestAslainVersion"]="2.4.0.2 #01"
    oldrels=[x for x in channel.get("releases",[]) if x.get("cnboxVersion") not in (BOX_PUBLIC_VERSION,BOX_CREATOR_VERSION)]
    channel["releases"]=[public,creator]+oldrels

    lang_entry={
      "packVersion":"1.1.1","wotVersion":"2.4.0.2",
      "payloadUrl":f"{RAW}/language/NAJXBOX_LANGUAGE_1.1.1_WOT_2.4.0.2_FINAL_LOCK.zip","payloadSha256":LANG_SHA,
      "notes":"FINAL_LOCK. Cumulative current ASIA donor + exact same-key CN task/mission completeness fallback + exact CN vehicle-name donor + locked enhanced TahomaZH. 64 task/activity keys patched; Review 1 + Review 2 PASS; no Runtime required for translation-only patch."
    }
    channel["languagePacks"]=[lang_entry]+[x for x in channel.get("languagePacks",[]) if x.get("packVersion")!="1.1.1" or x.get("wotVersion")!="2.4.0.2"]
    moe_entry={
      "id":"CNBOX_MOE","version":"1.3.0","status":"FINAL_LOCK","wotVersion":"2.4.0.2",
      "sourceCore":"NAJXBox independent; exact 1.2.9 functional bytes + 2.4.0.2 generation/meta rebase",
      "payloadUrl":f"{RAW}/moe/1.3.0/NAJXBOX_MoE_INDEPENDENT_1.3.0_WOT_2.4.0.2_FINAL_LOCK.zip","payloadSha256":MOE_SHA,
      "notes":"Exact real-client Runtime-tested 1.3.0 FINAL_LOCK bytes. Historical internal WOTMOD filename 1.2.4 is retained; no cosmetic repack.",
      "installedFiles":[{"path":"mods/{WOT_VERSION}/najxbox.moe_independent_1.2.4.wotmod","sha256":MOE_WOTMOD_SHA,"required":True,"shared":False}]
    }
    channel["moePacks"]=[moe_entry]+[x for x in channel.get("moePacks",[]) if x.get("version")!="1.3.0" or x.get("wotVersion")!="2.4.0.2"]
    cp.write_text(json.dumps(channel,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")

    mdir=root/"moe/1.3.0";(mdir/"SHA256SUMS.txt").write_text(f"{MOE_SHA}  NAJXBOX_MoE_INDEPENDENT_1.3.0_WOT_2.4.0.2_FINAL_LOCK.zip\n",encoding="ascii")
    (mdir/"manifest.json").write_text(json.dumps(moe_entry,ensure_ascii=False,indent=2)+"\n",encoding="utf-8")
    (root/"language/NAJXBOX_LANGUAGE_1.1.1_WOT_2.4.0.2_FINAL_LOCK.zip.sha256.txt").write_text(f"{LANG_SHA}  NAJXBOX_LANGUAGE_1.1.1_WOT_2.4.0.2_FINAL_LOCK.zip\n",encoding="ascii")

    index=f"""# NAJXBox Current Public Release Index

Updated: 2026-10-02

## Current install authorities

- Manager Public: {channel.get('managerVersion')} / {channel.get('managerSha256')}
- Manager Creator: {channel.get('creatorManagerVersion')} / {channel.get('creatorManagerSha256')}
- Box Public: {BOX_PUBLIC_VERSION} / {BOX_SHA}
- Box Creator compatibility: {BOX_CREATOR_VERSION} / {BOX_SHA}
- MoE: 1.3.0 / {MOE_SHA}
- Language: 1.1.1 / {LANG_SHA}
- WoT: 2.4.0.2
- Aslain manufacturing/Creator base: #01
- XVM: 13.1.0.0093

Older Public releases remain repository history/rollback only. channel.json current entries are the installation authority.
"""
    (root/"CURRENT_RELEASE_INDEX.md").write_text(index,encoding="utf-8")
    print("PUBLIC_MODULE_RELEASE_STAGE_PASS")
    print("box_manifest_sha256="+manifest_sha)
if __name__=="__main__":main()
