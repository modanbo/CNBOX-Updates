#!/usr/bin/env python3
"""One-time, identity-only publication of already-locked Box 1.2.0.

Never builds/edits game members. Reassembles the exact ZIP from Git-object
Base64 text shards, checks each original member against the frozen private
manifest, stages official Public channel and functional manifest only on pass.
"""
import base64
import copy
import hashlib
import json
import shutil
import zipfile
from collections import Counter
from pathlib import Path

SHA = '70c756fe280c76dbac2655d5bb1428d635f0e004f52d480dc5acf8fbb9ee1fe9'
PREVIOUS_SHA = 'b40c9b17b8ac42806b857bb92120e2ebc36148498ff28a6c046d72890d7406f2'
STAGING = Path('.release-staging/box120')
BINARY = Path('payloads/2.4.1.0/unified/CNBOX_PAYLOAD_R6.zip')
FUNC = Path('manifests/2.4.1.0/CNBOX_FUNCTIONAL_R34_R2F9_R6.json')
CHANNEL = Path('channel.json')
INDEX = Path('CURRENT_RELEASE_INDEX.md')
ROOT = 'https://raw.githubusercontent.com/modanbo/CNBOX-Updates/main/'


def check(test, message):
    if not test:
        raise RuntimeError('FROZEN_BOX120_RELEASE_STOP: ' + message)


def digest_file(path):
    h = hashlib.sha256()
    with path.open('rb') as stream:
        for chunk in iter(lambda: stream.read(2**20), b''):
            h.update(chunk)
    return h.hexdigest()


def write_json_exact(path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, ensure_ascii=False, indent=2)+'\n', encoding='utf8')


def category(path, old):
    if path in old:
        return old[path]
    if path.startswith('mods/') and '/com.modxvm.xvm_' in path:
        return 'xvm_core_wotmod'
    if path.startswith('mods/') and '/net.openwg/net.openwg.common_' in path:
        return 'openwg_common'
    raise RuntimeError('Unexpected new category path: ' + path)


def main():
    shards = sorted(STAGING.glob('part_*.b64'))
    check(len(shards) == 28, f'expected 28 exact staged blobs, got {len(shards)}')
    check([p.name for p in shards] == [f'part_{i:03}.b64' for i in range(28)], 'shard order/name mismatch')
    formal = json.loads((STAGING/'frozen_formal_manifest.json').read_text(encoding='utf8'))
    exp = formal['package']['fileSha256']
    check(formal['formalVersion'] == '1.2.0' and formal['package']['sha256'] == SHA and len(exp)==533,'original final manifest not authoritative')
    # Collect source only within private staging; never write a public channel
    # until SHA + 533-member cryptographic checks are complete.
    BINARY.parent.mkdir(parents=True, exist_ok=True)
    check(not BINARY.exists(), 'Public 2.4.1.0 path pre-exists; refuse overwrite')
    staged_zip = STAGING/'assembled_unpublished.zip'
    with staged_zip.open('wb') as out:
        for i,p in enumerate(shards):
            txt = p.read_text(encoding='ascii')
            check(len(txt)==(546872 if i==27 else 700000), f'base64 fragment length {i}')
            out.write(base64.b64decode(txt,validate=True))
    check(staged_zip.stat().st_size == 14585152, 'source size differs from user-tested T06')
    check(digest_file(staged_zip) == SHA, 'source SHA differs from user-tested T06')
    with zipfile.ZipFile(staged_zip) as z:
        infos = z.infolist()
        check(len(infos)==533 and len({q.filename for q in infos})==533 and z.testzip() is None,'ZIP count, names or CRC invalid')
        check(all(f.filename.startswith(('mods/','res_mods/')) and not f.filename.startswith('/') and '..' not in Path(f.filename).parts for f in infos),'ZIP path owner invalid')
        files = {}
        for member in infos:
            raw = z.read(member.filename)
            files[member.filename] = hashlib.sha256(raw).hexdigest()
        check(files == exp, 'original frozen 533/533 file sha256 list mismatch')
    channel = json.loads(CHANNEL.read_text(encoding='utf8'))
    check(channel.get('managerVersion')=='2.1.5','Manager catalog version changed')
    old = [r for r in channel['releases'] if r.get('wotVersion')=='2.4.0.2' and r.get('releaseTrack')=='PUBLIC_STANDALONE' and r.get('payloadSha256')==PREVIOUS_SHA]
    check(len(old)==1 and len(old[0]['installedFiles'])==534,'old 1.1.0 published authority changed')
    check(len(channel['releases'])==2 and channel['releases'][1].get('releaseTrack')=='CREATOR_ASLAIN' and channel['releases'][1].get('payloadSha256')==PREVIOUS_SHA,'Creator old release changed')
    check(all(r.get('wotVersion')!='2.4.1.0' for r in channel['releases']),'already published 2.4.1.0; no double publisher')
    old_manifest = json.loads(Path('manifests/2.4.0.2/CNBOX_FUNCTIONAL_R34_R2F9_R6.json').read_text(encoding='utf8'))
    old_cats = {x['path'].replace('2.4.0.2','2.4.1.0'):x['category'] for x in old_manifest['files']}
    entries = []
    with zipfile.ZipFile(staged_zip) as z:
        for i in z.infolist():
            entries.append({'path':i.filename,'category':category(i.filename,old_cats),'sizeBytes':i.file_size,'sha256':files[i.filename]})
    counts=dict(sorted(Counter(x['category'] for x in entries).items()))
    func = {'schemaVersion':2,'functionalId':'WOT2410-R34-R2F9', 'release':'2410-03-R34-R2F9-FINAL_LOCK-R6',
        'formalVersion':'1.2.0', 'wotVersion':'2.4.1.0',
        'description':'Original owner-approved BOX1.2.0/T06 exact 533 member 2.4.1.0 #03 bytes; no game rebuild. Known unverified visual edge states retained in original formal evidence.',
        'sourceCreatorPayloadSha256':SHA,'publicPayloadSha256':SHA,'fileCount':533, 'categoryCounts':counts,'files':entries}
    write_json_exact(FUNC,func)
    manifest_sha=digest_file(FUNC)
    installed = [{'path':i.filename,'sha256':files[i.filename],'required':True} for i in zipfile.ZipFile(staged_zip).infolist()]
    # Old WoT2402 release entries remain byte/semantic-identical. No Manager,
    # MoE, Language or Creator executable is touched.
    other_before = {key:copy.deepcopy(value) for key,value in channel.items() if key!='releases'}
    standalone=copy.deepcopy(old[0]);standalone.update({
        'status':'FINAL_LOCK','wotVersion':'2.4.1.0','xvmVersion':'13.1.0.0098',
        'payloadUrl':ROOT+BINARY.as_posix(),'payloadSha256':SHA,
        'functionalId':'WOT2410-R34-R2F9','cnboxVersion':'2410-03-R34-R2F9-UNIFIED-R6',
        'aslainVersion':'ANY','displayVersion':'1.2.0',
        'notes':'Formal BOX1.2.0. Exact T06 tested 533-file bytes, no repack; WoT241 #03 native baseline provenance. User-approved disclosed unverified visual edges.',
        'releaseTrack':'PUBLIC_STANDALONE','functionalManifestUrl':ROOT+FUNC.as_posix(),
        'functionalManifestSha256':manifest_sha,'installedFiles':installed,'baselineFiles':[]})
    creator=copy.deepcopy(channel['releases'][1]);creator.update({
        'status':'FINAL_LOCK','wotVersion':'2.4.1.0','xvmVersion':'13.1.0.0098',
        'payloadUrl':ROOT+BINARY.as_posix(),'payloadSha256':SHA,
        'functionalId':'WOT2410-R34-R2F9','cnboxVersion':'2410-03-R34-R2F9-FINAL_LOCK-R6',
        'aslainVersion':'2.4.1.0 #03', 'releaseTrack':'CREATOR_ASLAIN',
        'notes':'Creator compatibility metadata for original BOX1.2.0 bytes. Separate Creator real rollback is not asserted PASS.',
        'installedFiles':installed,'baselineFiles':[]})
    channel['releases'] = [standalone,creator] + channel['releases']
    check(other_before=={key:value for key,value in channel.items() if key!='releases'}, 'non-BOX catalog changed')
    check(len(channel['releases'])==4 and len(channel['releases'][0]['installedFiles'])==533 and len(channel['releases'][2]['installedFiles'])==534,'four release entries incorrect')
    write_json_exact(CHANNEL,channel)
    idx = INDEX.read_text(encoding='utf8')
    check('The 1.2.0 ZIP is not stored as a binary' in idx, 'stale public index not expected; fail closed')
    idx=idx.replace('Box formal/display **current frozen baseline: 1.2.0**','Box formal/display **current published release: 1.2.0**')
    idx=idx.replace('Legacy Public `channel.json` remains unchanged and operational for old clients; this is NOT the current 1.2.0 baseline.','Previous WoT2402 release remains in the live `channel.json` for old clients, while WoT241 1.2.0 is the current release.')
    idx=idx.replace('**Release records synchronized:** GitHub engineering manifest + formal decision, Google Drive exact 1.2.0 ZIP, old 1.1.0 Drive folder marked HISTORY/ROLLBACK. The 1.2.0 ZIP is not stored as a binary in this Public GitHub repository; therefore `channel.json` continues serving the verified old WoT2402 1.1.0 asset and must not be represented as an active WoT241 1.2.0 auto-update. No Windows Runner workflow or monitor is active. This index records the formal 1.2.0 lock and links its exact Drive artifact. The earlier #02 failed candidates are historical technical evidence, not substitutes for 1.2.0.',
        '**Current BOX 1.2.0 published and downloadable:** original SHA256 `'+SHA+'` stored as exact 533-member `payloads/2.4.1.0/unified/CNBOX_PAYLOAD_R6.zip`; Manager `channel.json` provides the 1.2.0 standalone and Aslain03 Creator entries, complete installed-file hashes and exact functional manifest. The previously published 1.1.0/WoT2402 payload and catalog entries are retained only for older-client compatibility/rollback. No new game Runtime tests or recompiled game binaries. Gitee is separate deferred backup. Original Drive formal file unchanged.' )
    INDEX.write_text(idx,encoding='utf8')
    shutil.move(staged_zip,BINARY)
    check(digest_file(BINARY)==SHA,'published working tree binary bytes changed')
    print('BOX120_PUBLIC_PREP_VERIFIED 533/533 bytes, 1.2.0+old 1.1.0 channel; SHA',SHA,flush=True)
    print('FUNCTION_MANIFEST_SHA256',manifest_sha,flush=True)

if __name__=='__main__':main()
