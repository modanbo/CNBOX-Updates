# -*- coding: utf-8 -*-
"""REFERENCE ONLY — removed from NAJXBox MoE 1.2.0 runtime source.

Historical pure helpers from the abandoned WG mastery-distribution threshold route.
They are preserved only so future reviews can see exactly what was rejected.

Current 1.2.0 authority:
- threshold snapshot is built out-of-game from the validated NA MoE SSR dataset;
- runtime threshold access is local-only;
- no application_id, WG mastery request, HTTP path, or runtime cache owner is allowed.
"""

# -*- coding: utf-8 -*-
"""Pure parsing/cache helpers for the official Wargaming mastery distribution API.

Network I/O is intentionally NOT implemented here. Runtime fetch code will call these
pure helpers and remain separately reviewable.
"""
import json

STORE_VERSION = 1
PERCENTILES = (20, 40, 55, 65, 75, 85, 95, 100)
REQUIRED = (65, 85, 95, 100)


def build_query(application_id, tank_ids):
    ids = []
    for raw in tank_ids or ():
        try:
            value = int(raw)
        except (TypeError, ValueError):
            continue
        if value > 0 and value not in ids:
            ids.append(value)
    ids = ids[:100]
    return {
        "application_id": str(application_id or ""),
        "distribution": "damage",
        "percentile": ",".join(str(x) for x in PERCENTILES),
        "tank_id": ",".join(str(x) for x in ids),
    }


def parse_response(text):
    table = {}
    updated_at = None
    if not text:
        return table, updated_at
    try:
        blob = json.loads(text)
    except (TypeError, ValueError):
        return table, updated_at
    if not isinstance(blob, dict) or blob.get("status") != "ok":
        return table, updated_at
    data = blob.get("data")
    if not isinstance(data, dict):
        return table, updated_at
    try:
        if data.get("updated_at") is not None:
            updated_at = int(data.get("updated_at"))
    except (TypeError, ValueError):
        updated_at = None
    dist = data.get("distribution")
    if not isinstance(dist, dict):
        return table, updated_at

    for tank_id, anchors in dist.items():
        if not isinstance(anchors, dict):
            continue
        try:
            tid = int(tank_id)
        except (TypeError, ValueError):
            continue
        row = {}
        for pct in PERCENTILES:
            try:
                value = int(anchors.get(str(pct)))
            except (TypeError, ValueError):
                continue
            if value > 0:
                row[pct] = value
        if all(pct in row for pct in REQUIRED):
            table[tid] = row
    return table, updated_at


def make_cache(region, fetched_at, updated_at, table):
    rows = {}
    for tank_id, anchors in (table or {}).items():
        try:
            tid = str(int(tank_id))
        except (TypeError, ValueError):
            continue
        clean = {}
        for pct, value in (anchors or {}).items():
            try:
                p = int(pct)
                d = int(value)
            except (TypeError, ValueError):
                continue
            if p in PERCENTILES and d > 0:
                clean[str(p)] = d
        if all(str(pct) in clean for pct in REQUIRED):
            rows[tid] = clean
    return {
        "version": STORE_VERSION,
        "region": str(region or ""),
        "fetched_at": int(fetched_at or 0),
        "updated_at": int(updated_at or 0),
        "table": rows,
    }


def read_cache(blob, region, now_epoch, max_age_seconds):
    if not isinstance(blob, dict):
        return {}
    if blob.get("version") != STORE_VERSION:
        return {}
    if str(blob.get("region") or "") != str(region or ""):
        return {}
    try:
        fetched = int(blob.get("fetched_at") or 0)
        now = int(now_epoch)
        age = int(max_age_seconds)
    except (TypeError, ValueError):
        return {}
    if fetched <= 0 or now < fetched or now - fetched > age:
        return {}

    out = {}
    for tank_id, anchors in (blob.get("table") or {}).items():
        try:
            tid = int(tank_id)
        except (TypeError, ValueError):
            continue
        row = {}
        for pct, value in (anchors or {}).items():
            try:
                p = int(pct)
                d = int(value)
            except (TypeError, ValueError):
                continue
            if p in PERCENTILES and d > 0:
                row[p] = d
        if all(pct in row for pct in REQUIRED):
            out[tid] = row
    return out
