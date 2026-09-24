# -*- coding: utf-8 -*-
"""WoT mod loader entry for the independent NAJXBox MoE candidate."""
try:
    from gui.mods.najxbox_moe_independent import ui
    ui.setup()
except Exception:
    try:
        import traceback
        traceback.print_exc()
    except Exception:
        pass
