# -*- coding: utf-8 -*-
from __future__ import print_function
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'source'))
sys.path.insert(0, ROOT)
from najxbox_moe_independent import mathcore

def close(a, b, eps=1e-8):
    return abs(a - b) <= eps

assert close(mathcore.combined_damage(1000, 200, 300, 100), 1300.0)
assert close(mathcore.projected_average(3378, 3749), 3378 + (2.0/101.0)*(3749-3378))
assert close(mathcore.projected_average(3396, 955), 3396 + (2.0/101.0)*(955-3396))

source_files = []
for root, _, names in os.walk(os.path.join(ROOT)):
    for name in names:
        if name.endswith('.py'):
            source_files.append(os.path.join(root, name))
source_files.append(os.path.join(ROOT, 'mod_najxbox_moe.py'))

forbidden = [
    'PlayerAvatar.onBattleEvents',
    'requests.',
    'urllib2',
    'threading',
    'tv.protanki',
    'champi.',
    'gambiter.',
    'modssettingsapi',
    'modslistapi',
    'openwg.gameface',
]
for path in source_files:
    data = open(path, 'rb').read().decode('utf-8').lower()
    for token in forbidden:
        assert token.lower() not in data, (path, token)

print('PASS independent source/static gates')
