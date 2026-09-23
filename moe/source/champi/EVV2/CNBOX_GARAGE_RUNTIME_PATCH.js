/* CNBOX MoE garage runtime patch — 1.0.7
 *
 * Purpose:
 * 1) keep EVV's existing Ctrl+drag path enabled even when the upstream settings
 *    model reports moveMode=false;
 * 2) migrate a clipped/out-of-viewport card to a safe visible location once,
 *    then persist it through EVV's own savePosition command.
 *
 * The MoE model/calculation fields are untouched.
 */
(function () {
    'use strict';

    const CNBOX_EDGE_MARGIN = 24;
    const CNBOX_CAROUSEL_CLEARANCE = 240;

    if (typeof updateStateFromModel === 'function') {
        const cnboxOriginalUpdateStateFromModel = updateStateFromModel;
        updateStateFromModel = function (state) {
            cnboxOriginalUpdateStateFromModel(state);
            if (typeof currentState === 'object' && currentState) {
                currentState.moveMode = true;
            }
        };
    }

    function cnboxForceDragEnabled() {
        if (typeof currentState === 'object' && currentState) {
            currentState.moveMode = true;
        }
    }

    function cnboxMigrateVisiblePosition() {
        const el = document.getElementById('evv2-root');
        if (!el || el.style.display === 'none') return;

        const rect = el.getBoundingClientRect();
        const vw = window.innerWidth || document.documentElement.clientWidth || 0;
        const vh = window.innerHeight || document.documentElement.clientHeight || 0;
        if (!vw || !vh || rect.width <= 0 || rect.height <= 0) return;

        const clipped =
            rect.left < CNBOX_EDGE_MARGIN ||
            rect.top < CNBOX_EDGE_MARGIN ||
            rect.right > vw - CNBOX_EDGE_MARGIN ||
            rect.bottom > vh - CNBOX_EDGE_MARGIN;

        if (!clipped) return;

        const maxLeft = Math.max(CNBOX_EDGE_MARGIN, vw - rect.width - CNBOX_EDGE_MARGIN);
        const maxTop = Math.max(CNBOX_EDGE_MARGIN, vh - rect.height - CNBOX_EDGE_MARGIN);

        const left = Math.max(
            CNBOX_EDGE_MARGIN,
            Math.min(maxLeft, vw - rect.width - 64)
        );
        const top = Math.max(
            CNBOX_EDGE_MARGIN,
            Math.min(maxTop, vh - rect.height - CNBOX_CAROUSEL_CLEARANCE)
        );

        el._evv2Pinned = true;
        el.style.transformOrigin = '0 0';
        el.style.right = 'auto';
        el.style.bottom = 'auto';
        el.style.left = Math.round(left) + 'px';
        el.style.top = Math.round(top) + 'px';

        if (typeof saveCurrentPosition === 'function') {
            saveCurrentPosition(el);
        }
    }

    function cnboxAfterPaint() {
        cnboxForceDragEnabled();
        setTimeout(cnboxMigrateVisiblePosition, 0);
    }

    if (typeof applyCurrentState === 'function') {
        const cnboxOriginalApplyCurrentState = applyCurrentState;
        applyCurrentState = function () {
            cnboxOriginalApplyCurrentState();
            cnboxAfterPaint();
        };
    }

    if (typeof engine !== 'undefined' && engine && engine.whenReady) {
        engine.whenReady.then(function () {
            cnboxAfterPaint();
            setTimeout(cnboxMigrateVisiblePosition, 150);
        });
    } else {
        setTimeout(cnboxAfterPaint, 250);
    }

    window.addEventListener('resize', function () {
        setTimeout(cnboxMigrateVisiblePosition, 0);
    });
})();
