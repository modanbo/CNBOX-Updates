from __future__ import annotations
import argparse, base64, hashlib, io, json, os, pathlib, zipfile

OLD='13.1.0.0089'
NEW='13.1.0.0090'
OLD_XVM=f'mods/2.4.0.1/com.modxvm.xvm_{OLD}.wotmod'
NEW_XVM=f'mods/2.4.0.1/com.modxvm.xvm_{NEW}.wotmod'
TRIANGLE='res_mods/configs/xvm/Aslain/icons/cnbox_lighten.png'
CRISP_TRIANGLE_B64='iVBORw0KGgoAAAANSUhEUgAAABEAAAAPCAYAAAACsSQRAAAAjUlEQVR42mNgIAAy7Hj+E1LDRIwBhAxiImTL9AYWBrJBhh3P///7BOAYn2vwusQ3/xeDb/4vBrLCJMOO5z+6N6Y3sOAMGyYGKgAmYlxByDVMpKYJbOqYSI1SbPIs+FyxeSIbXtfMOPSFEcMl6LbgimJ0dUykhAWusGEkFCP4QGbDH4YZh74wMpLrCmQAANtxPvMbp3SJAAAAAElFTkSuQmCC'
FIXED_DT=(2026,9,20,0,0,0)

def zi(name:str)->zipfile.ZipInfo:
    z=zipfile.ZipInfo(name, FIXED_DT)
    z.compress_type=zipfile.ZIP_STORED
    z.create_system=0
    z.external_attr=0
    return z

def sha(b:bytes)->str:
    return hashlib.sha256(b).hexdigest()

def rebase_wotmod(src:bytes)->tuple[bytes,list[str]]:
    inp=zipfile.ZipFile(io.BytesIO(src),'r')
    out_io=io.BytesIO()
    changed=[]
    with zipfile.ZipFile(out_io,'w',compression=zipfile.ZIP_STORED,allowZip64=True) as out:
        for name in sorted(n for n in inp.namelist() if not n.endswith('/')):
            data=inp.read(name)
            newdata=data
            if OLD.encode() in data:
                if not (name=='meta.xml' or (name.startswith('res/mods/openwg_packages/') and name.endswith('/package.json'))):
                    raise RuntimeError(f'unexpected old-version reference in {name}')
                newdata=data.replace(OLD.encode(), NEW.encode())
                changed.append(name)
            out.writestr(zi(name),newdata)
    inp.close()
    if len(changed)!=26:
        raise RuntimeError(f'expected 26 metadata changes, got {len(changed)}')
    return out_io.getvalue(), changed

def build(base_zip:str,out_zip:str,manifest_path:str|None=None):
    with zipfile.ZipFile(base_zip,'r') as base:
        base_files={n:base.read(n) for n in base.namelist() if not n.endswith('/')}
    if len(base_files)!=21:
        raise RuntimeError(f'expected 21 base files, got {len(base_files)}')
    if OLD_XVM not in base_files or TRIANGLE not in base_files:
        raise RuntimeError('base owner missing')
    rebased, changed_meta = rebase_wotmod(base_files.pop(OLD_XVM))
    base_files[NEW_XVM]=rebased
    base_files[TRIANGLE]=base64.b64decode(CRISP_TRIANGLE_B64)
    if len(base_files)!=21:
        raise RuntimeError('candidate file count changed')
    pathlib.Path(out_zip).parent.mkdir(parents=True,exist_ok=True)
    with zipfile.ZipFile(out_zip,'w',compression=zipfile.ZIP_STORED,allowZip64=True) as out:
        for name in sorted(base_files):
            out.writestr(zi(name),base_files[name])
    manifest={
        'schemaVersion':1,
        'release':'2401-04-R34-R2F9-FINAL_LOCK-R1',
        'wotVersion':'2.4.0.1',
        'aslainVersion':'2.4.0.1 #04',
        'xvmVersion':NEW,
        'status':['FINAL_LOCK','STATIC_PROMOTED','TWO_REVIEW_PASS','RUNTIME_NOT_REQUIRED_FOR_THIS_DELTA'],
        'fileCount':21,
        'xvmMetadataChanged':changed_meta,
        'files':[{'path':n,'sizeBytes':len(base_files[n]),'sha256':sha(base_files[n])} for n in sorted(base_files)],
    }
    manifest['payloadSha256']=sha(pathlib.Path(out_zip).read_bytes())
    if manifest_path:
        pathlib.Path(manifest_path).parent.mkdir(parents=True,exist_ok=True)
        pathlib.Path(manifest_path).write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps({'payload':out_zip,'sha256':manifest['payloadSha256'],'bytes':os.path.getsize(out_zip),'xvmSha256':sha(rebased),'triangleSha256':sha(base_files[TRIANGLE]),'changedMetadata':len(changed_meta)},ensure_ascii=False))

if __name__=='__main__':
    ap=argparse.ArgumentParser()
    ap.add_argument('--base',required=True)
    ap.add_argument('--out',required=True)
    ap.add_argument('--manifest')
    a=ap.parse_args()
    build(a.base,a.out,a.manifest)
