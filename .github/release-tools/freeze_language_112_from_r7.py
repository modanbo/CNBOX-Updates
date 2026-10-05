#!/usr/bin/env python3
import copy, json, sys, zipfile

src, out = sys.argv[1], sys.argv[2]
with zipfile.ZipFile(src, "r") as zin:
    m = json.loads(zin.read("language_pack_manifest.json").decode("utf-8-sig"))
    m.update({
        "packVersion": "1.1.2",
        "previousFormalVersion": "1.1.1",
        "previousFormalDisplay": "1.1.1",
        "changeClass": "PATCH_GLOBAL_COMPLETENESS_AND_VEHICLE_NAME_STANDARDIZATION",
        "createdAtUtc": "2026-10-04T00:00:00Z",
        "runtimeRequired": True,
        "runtimeStatus": "PASS / USER_CONFIRMED_NO_ISSUES / EXACT_R7_CONTENT",
        "runtimeAuthorityCandidateRevision": "R7",
        "runtimeAuthorityCandidateSha256": "14f09a1b2aa64da70f5910a29b38d13c804d7ac680d6c5221d8fc347a9dc5fe9",
        "runtimeConfirmationDate": "2026-10-04",
        "lockAuthorization": "EXPLICIT_USER_FORMAL_LOCK_1.1.2_20261004",
        "candidateState": "FINAL_LOCK",
        "candidateRevision": None,
        "formalState": "FINAL_LOCK",
        "formalLockDate": "2026-10-04",
        "finalIdentityDelta": "MANIFEST_ONLY_FROM_RUNTIME_PASSED_R7; ALL 312 NON-MANIFEST MEMBERS BYTE-IDENTICAL TO R7",
        "candidateRuntimeGate": "CLOSED / R7 RUNTIME PASS / USER CONFIRMED NO ISSUES / FINAL IDENTITY MANIFEST-ONLY REPACK",
        "engineeringSourceCandidate": {
            "revision": "R7",
            "file": "NAJXBOX_LANGUAGE_GLOBAL_COMPLETENESS_CANDIDATE_R7_20261003.zip",
            "sha256": "14f09a1b2aa64da70f5910a29b38d13c804d7ac680d6c5221d8fc347a9dc5fe9",
            "reviews": ["REVIEW5_PASS", "REVIEW6_PASS"],
            "runtime": "PASS / USER_CONFIRMED_NO_ISSUES"
        }
    })
    mb = (json.dumps(m, ensure_ascii=False, indent=2) + "\n").encode("utf-8")
    with zipfile.ZipFile(out, "w") as zout:
        for info in zin.infolist():
            zi = copy.copy(info)
            zout.writestr(zi, mb if info.filename == "language_pack_manifest.json" else zin.read(info.filename))
