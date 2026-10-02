#!/usr/bin/env python3
import argparse, hashlib, json, struct, zipfile
from collections import OrderedDict
from pathlib import Path

EXPECTED_BASE_SHA256 = "b402d07e3b98a6ffbe5b0afc89b18f2be7224d2f730063a81d47c44f07c9fd1c"
EXPECTED_FINAL_SHA256 = "88b4932ed7106e89183a1c7ca778c559db02225bfc6f12a1707e0d51c89d0667"
FINAL_MANIFEST = OrderedDict([
 ("schemaVersion",3),("packVersion","1.1.1"),("wotVersion","2.4.0.2"),
 ("source","ASIA Simplified Chinese UI + targeted CN same-key task/mission fallback + CN vehicle-name layer + NAJXBox TahomaZH Western Symbols R1"),
 ("asiaMoCount",296),("cnVehicleMoCount",14),("enhancedFontPath","asia/res/gui/flash/fonts_zh_cn_sg.swf"),
 ("enhancedFontSha256","108e0ae0dbd7ad0330114cf082bdc33ecdae30aa6dcb3cb3b1a82dae75331b45"),
 ("enhancedFontGlyphs",28759),("enhancedFontAddedGlyphs",20),("createdAtUtc","2026-10-02T19:30:00Z"),
 ("enhancedFontBaseSha256","5c7b7f32ffa1cc1d8cef019da5f727b43253018558ceaaaaba5ca993c69435ca"),
 ("retentionPolicy","CUMULATIVE_PREVIOUS_FORMAL_PLUS_CURRENT_OFFICIAL_CURRENT_WINS"),("retentionBasePackVersion","1.1"),
 ("retentionBasePackSha256","e6fd0b357617bf4267a3b29458f9b810be9717d907d929c5c8c0fcb5b098a3a7"),
 ("retainedDormantEntries",3),("currentOfficialOverrides",2),
 ("retentionRule","Keep prior translated entries when temporarily absent; current official donor wins on the same key. Delete only with explicit permanent-removal evidence or a proven semantic/key conflict."),
 ("versionPolicy","THREE_SEGMENT_FORMAL_VERSION_X_Y_Z"),("previousFormalVersion","1.1.0"),
 ("previousFormalDisplay","1.1 (legacy two-segment display)"),("changeClass","PATCH_TRANSLATION_COMPLETENESS"),
 ("taskTranslationFallbackPolicy","CURRENT_NA_KEY_REQUIRED; ASIA_MISSING_OR_PARTIAL_LATIN; CN_SAME_KEY_VALID_CJK; CN_VALUE_ONLY_FOR_EXACT_SAME_KEY"),
 ("taskTranslationFallbackFiles",["quests.mo","personal_missions.mo","personal_missions_details.mo","weekly_quests.mo","battle_pass.mo","marathon.mo"]),
 ("taskTranslationFallbackEntries",64),("runtimeRequired",False),("lockAuthorization","USER_APPROVED_STATIC_TWO_REVIEW_DIRECT_LOCK")
])

def sha(path):
 h=hashlib.sha256()
 with open(path,'rb') as f:
  for c in iter(lambda:f.read(1024*1024),b''):h.update(c)
 return h.hexdigest()

def parse_mo(data):
 m=struct.unpack_from('<I',data,0)[0]
 if m==0x950412de:e='<'
 elif m==0xde120495:e='>'
 else:raise ValueError('invalid MO magic')
 revision,n,oo,to,_,_=struct.unpack_from(e+'6I',data,4)
 entries=[]
 for i in range(n):
  ol,op=struct.unpack_from(e+'2I',data,oo+i*8);tl,tp=struct.unpack_from(e+'2I',data,to+i*8)
  entries.append([data[op:op+ol],data[tp:tp+tl]])
 return e,revision,entries

def rewrite_mo(data,repl):
 e,revision,entries=parse_mo(data);keys={o.decode('utf-8') for o,_ in entries}
 missing=set(repl)-keys
 if missing:raise RuntimeError('missing MO keys: '+repr(sorted(missing)))
 out=[]
 for ob,tb in entries:
  k=ob.decode('utf-8')
  if k in repl:tb=repl[k].encode('utf-8')
  out.append((ob,tb))
 n=len(out);oo=28;to=oo+n*8;strings=to+n*8;buf=bytearray(b'\0'*strings);pos=strings;ot=[];tt=[]
 for ob,tb in out:ot.append((len(ob),pos));buf.extend(ob+b'\0');pos+=len(ob)+1
 for ob,tb in out:tt.append((len(tb),pos));buf.extend(tb+b'\0');pos+=len(tb)+1
 magic=0x950412de if e=='<' else 0xde120495
 struct.pack_into(e+'7I',buf,0,magic,revision,n,oo,to,0,0)
 for i,(ln,off) in enumerate(ot):struct.pack_into(e+'2I',buf,oo+i*8,ln,off)
 for i,(ln,off) in enumerate(tt):struct.pack_into(e+'2I',buf,to+i*8,ln,off)
 return bytes(buf)

def main():
 ap=argparse.ArgumentParser();ap.add_argument('base');ap.add_argument('map');ap.add_argument('out');a=ap.parse_args()
 if sha(a.base)!=EXPECTED_BASE_SHA256:raise SystemExit('base SHA mismatch')
 repl=json.loads(Path(a.map).read_text(encoding='utf-8'))
 manifest=(json.dumps(FINAL_MANIFEST,ensure_ascii=False,indent=4)+'\n').encode()
 with zipfile.ZipFile(a.base) as zin,zipfile.ZipFile(a.out,'w') as zout:
  zout.comment=zin.comment
  for info in zin.infolist():
   data=zin.read(info.filename);fn=info.filename.rsplit('/',1)[-1]
   if info.filename.startswith('asia/res/text/lc_messages/') and fn in repl:data=rewrite_mo(data,repl[fn])
   elif info.filename=='language_pack_manifest.json':data=manifest
   zout.writestr(info,data)
 got=sha(a.out);print('final_sha256='+got)
 if got!=EXPECTED_FINAL_SHA256:raise SystemExit('final SHA mismatch')
 print('LANGUAGE_1.1.1_EXACT_REBUILD_PASS')
if __name__=='__main__':main()
