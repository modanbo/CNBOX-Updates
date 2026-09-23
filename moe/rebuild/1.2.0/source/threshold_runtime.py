# -*- coding: utf-8 -*-
"""Runtime WG mastery-threshold provider for NAJXBox MoE 1.2.0.

One-tank lazy fetch only. Network work stays on a worker thread; adoption and
callbacks run on the BigWorld main thread. No game-state mutation.
"""
import json
import os
import threading
import time

import wgapi

REGION = "com"
API_URL = "https://api.worldoftanks.com/wot/tanks/mastery/"
APPLICATION_ID = "__WG_APPLICATION_ID__"
CACHE_MAX_AGE = 12 * 60 * 60
POLL_INTERVAL = 0.25

_table = {}
_loaded = False
_inflight = set()
_listeners = []


def _log(message):
    try:
        import logging
        logging.getLogger("NAJXBox_MoE").info(message)
    except Exception:
        pass


def _data_dir():
    try:
        import helpers
        return os.path.join(helpers.getPreferencesDirPath(), "mods_data", "NAJXBox_MoE")
    except Exception:
        return os.path.join("mods", "configs", "NAJXBox_MoE")


def _cache_path():
    return os.path.join(_data_dir(), "thresholds.json")


def _read_disk():
    try:
        path = _cache_path()
        if not os.path.isfile(path):
            return None
        with open(path, "rb") as fh:
            return json.loads(fh.read().decode("utf-8"))
    except Exception:
        return None


def _write_disk(blob):
    try:
        path = _cache_path()
        folder = os.path.dirname(path)
        if not os.path.isdir(folder):
            os.makedirs(folder)
        tmp = path + ".tmp"
        with open(tmp, "wb") as fh:
            fh.write(json.dumps(blob, separators=(",", ":"), sort_keys=True).encode("utf-8"))
        if os.path.isfile(path):
            try:
                os.remove(path)
            except OSError:
                pass
        os.rename(tmp, path)
    except Exception:
        pass


def _ensure_loaded():
    global _loaded, _table
    if _loaded:
        return
    _loaded = True
    blob = _read_disk()
    _table = wgapi.read_cache(blob, REGION, int(time.time()), CACHE_MAX_AGE)


def add_listener(callback):
    if callback not in _listeners:
        _listeners.append(callback)


def remove_listener(callback):
    try:
        _listeners.remove(callback)
    except ValueError:
        pass


def _notify(tank_id):
    for callback in list(_listeners):
        try:
            callback(tank_id)
        except Exception:
            pass


def get(tank_id):
    _ensure_loaded()
    try:
        tid = int(tank_id or 0)
    except (TypeError, ValueError):
        return {}
    if not tid:
        return {}
    row = _table.get(tid)
    if row:
        return dict(row)
    request(tid)
    return {}


def enabled():
    app = str(APPLICATION_ID or "")
    return bool(app and not app.startswith("__"))


def _build_url(tank_id):
    query = wgapi.build_query(APPLICATION_ID, [tank_id])
    try:
        from urllib import urlencode
    except ImportError:
        from urllib.parse import urlencode
    return API_URL + "?" + urlencode(query)


def _fetch_text(url):
    from helpers import http
    response = http.openUrl(url, timeout=15.0, agent="NAJXBox-MoE/1.2.0")
    if response is not None and response.isValid() and response.hasData():
        return response.getData()
    return None


class _FetchThread(threading.Thread):
    def __init__(self, tank_id):
        threading.Thread.__init__(self)
        self.tank_id = int(tank_id)
        self.table = {}
        self.updated_at = None
        self.error = None
        self.daemon = True
        self.name = "NAJXBox MoE threshold fetch"

    def run(self):
        try:
            text = _fetch_text(_build_url(self.tank_id))
            self.table, self.updated_at = wgapi.parse_response(text)
        except Exception as exc:
            self.error = repr(exc)


def request(tank_id):
    _ensure_loaded()
    if not enabled():
        return False
    try:
        tid = int(tank_id or 0)
    except (TypeError, ValueError):
        return False
    if not tid or tid in _table or tid in _inflight:
        return False
    _inflight.add(tid)
    worker = _FetchThread(tid)
    worker.start()
    _schedule_poll(worker)
    return True


def _schedule_poll(worker):
    try:
        import BigWorld
        BigWorld.callback(POLL_INTERVAL, lambda: _poll(worker))
    except Exception:
        _inflight.discard(worker.tank_id)


def _poll(worker):
    global _table
    if worker.is_alive():
        _schedule_poll(worker)
        return

    tid = worker.tank_id
    _inflight.discard(tid)
    if worker.table and tid in worker.table:
        _table[tid] = dict(worker.table[tid])
        blob = wgapi.make_cache(
            REGION,
            int(time.time()),
            int(worker.updated_at or 0),
            _table)
        _write_disk(blob)
        _log("thresholds updated for tank %d" % tid)
        _notify(tid)
    elif worker.error:
        _log("threshold fetch failed for tank %d: %s" % (tid, worker.error))
