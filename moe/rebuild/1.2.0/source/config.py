# -*- coding: utf-8 -*-
"""Tiny file-only config. No settings GUI is registered by NAJXBox MoE."""
import json
import os

CONFIG_PATH = os.path.join("mods", "configs", "NAJXBox_MoE", "ui.json")

_DEFAULT = {
    "language": "auto",
    "lobby_x": 20,
    "lobby_y": 80,
    "battle_x": 20,
    "battle_y": 160,
}


def load():
    result = dict(_DEFAULT)
    try:
        if os.path.isfile(CONFIG_PATH):
            with open(CONFIG_PATH, "rb") as fh:
                blob = json.loads(fh.read().decode("utf-8"))
            if isinstance(blob, dict):
                for key in result:
                    if key in blob:
                        result[key] = blob[key]
    except Exception:
        pass
    return result


def save(cfg):
    try:
        folder = os.path.dirname(CONFIG_PATH)
        if not os.path.isdir(folder):
            os.makedirs(folder)
        tmp = CONFIG_PATH + ".tmp"
        with open(tmp, "wb") as fh:
            fh.write(json.dumps(cfg, ensure_ascii=False, indent=2).encode("utf-8"))
        if os.path.isfile(CONFIG_PATH):
            try:
                os.remove(CONFIG_PATH)
            except OSError:
                pass
        os.rename(tmp, CONFIG_PATH)
        return True
    except Exception:
        return False


def position_string():
    cfg = load()
    return "%d,%d,%d,%d" % (
        int(cfg.get("lobby_x") or 0),
        int(cfg.get("lobby_y") or 0),
        int(cfg.get("battle_x") or 0),
        int(cfg.get("battle_y") or 0),
    )


def save_position(is_battle, x, y):
    cfg = load()
    if is_battle:
        cfg["battle_x"] = int(x)
        cfg["battle_y"] = int(y)
    else:
        cfg["lobby_x"] = int(x)
        cfg["lobby_y"] = int(y)
    return save(cfg)


def language_code():
    cfg = load()
    explicit = str(cfg.get("language") or "auto").lower()
    if explicit in ("en", "zh"):
        return explicit
    try:
        from helpers import getClientLanguage
        language = str(getClientLanguage() or "").lower()
    except Exception:
        language = ""
    return "zh" if language.startswith("zh") else "en"
