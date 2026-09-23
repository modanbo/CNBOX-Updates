# -*- coding: utf-8 -*-
"""World of Tanks loader entry for NAJXBox MoE 1.2.0."""

try:
    from najxbox_moe import view
    view.setup()
except Exception:
    # Never break client startup because of the optional MoE component.
    try:
        import traceback
        traceback.print_exc()
    except Exception:
        pass
