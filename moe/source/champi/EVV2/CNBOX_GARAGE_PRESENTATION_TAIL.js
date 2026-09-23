/* NAJXBox MoE 1.0.10 — tri-locale isolated official-CN garage presentation tail.
 * This file is concatenated AFTER the byte-identical upstream EVV2.js.
 * It only reads EVV's existing currentState and paints a child overlay.
 * It does not alter calculation, model acquisition, events, Ctrl-drag, anchors or savePosition.
 */

;(() => {
  const LIGHT_STAR = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAVCAYAAABCIB6VAAADY0lEQVR4nMWUT28bRRjGfzO7613bie1GdZ3QYNI0EGQQCPXWz8AVJDgggThQqfAV0kicEBcOFd+hqUBICCFxKIdKnCpQqwS1adIS4jqOWztxvfZ6/8zLwUnjxE0qDoj3MtJq3t8+88wzL/wfJSJK5IoWES1yzRqsV7SIqBf12idBYUkDCpY1vKNgWQADSyIiRikl/wp8AK1YbGLhYmGtapKyIX7XMOXFe/uOhevRo4uGRQuKDndtl1wl3QsbhT9Xn/72pFWdJut5NDc8+NWBxT17Rq1RBwoXFVQUVCxqgY2HQ8r16PdSD9Y3PoqN+dJS6urs3LmviL0QvxEwMx9CM4brZmDRguyfYEjxHrSeOGRSLi4ZYskSxKeDJLlcKhUR1Metzs4ruI0xxvIZ2k2PxkqK+xPWoH/EikUFsxryFr2mgxN6+Jkxv7l9/sFW/bNcNjuZK+TJ5ccyO9vty63H8hpuMs5u6JF63SF70Rr08wy+b4WGZZu7trva/uMbEt426BnbtiY8N0WpVMR2U5AYarU6vSAgjqK2oB9qxb1XC299wrwVwu+xUu8no6koriu36/wUmuSD6ZdKXjY3fvhGLM3U9BQAQbebq1ZrbypLfcuZjob881KxOFgakZSn52/msuMfPnq01e4+7TwvSQR+l83qVt9z05dm52d+QLYF+gLvPYveHnhB4LqhMGMwiTlT9u4UCqc+rda2+xhzmCrCZnVLMuPpS2cnZ28griEpGwgEOAoGqAilCUOmkWBKkZd2aiJYqCMRVQqtlUorb4tUFNPuJ8SBgQuHFOjBXiWwItz/3hAXYlLdsOf3TruObSNC60mTzY0qzUYTkgTHdgjizgSR28c7FTGVTwAZfoVDiheEuYuG0InZJeoE0aQxhrW1v3jc3P0FbX3eare/W1t/aBKT0OnF5/C2I+JbCeyaYRtgKBVKKRG5ZigVE5rToemvzSVKbuRz+a8nz758D9XSSPnn+t8bV3c6/hdam1miTEixGMOPAhcOO3b4XkTDLQtKNs07DnbZxnc0OtConkLSgvEM2cgQuzH93XgwkN6IlVKjHg+zYd1APeZ2PcQPAnTQA3zUmA/46KCHHwTcvhkyRbQ3J0Ym3FHF6uD7koKVEwZ6ZT+3sm/lseBjfnJsnTTo/7P6B3q4sKDQJhpiAAAAAElFTkSuQmCC';
  const DARK_STAR = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABYAAAAVCAYAAABCIB6VAAAA3ElEQVR4nO3RsUpDQRSE4W+jEiUmEJJ3sAooaX0DK/FNLWws7C1t0qVQGwtBBAULGYtcQTBZL2qhkKl2z+z8nD2Htf6EknSSnCTpts10Wr7bwwiTXwMn2cBBc50k2f4xOEkP+9htSluYJuknKbXsJzPJocW3B9ipZF/wiIdSykWbjucNuAaFLsa4btUxJBnjqAmv0ivOSyntwQ18iGNsLrNxWkq5W5WvLe+p4hc8V7JV8OALv/ddcP/DeY4zzCzGwGLBK7Vsfu8a4QaXpZT7pnab5ApTDGvgtf6x3gC30jvo6eVG3gAAAABJRU5ErkJggg==';
  const ARROW_UP = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAYAAAALCAYAAABcUvyWAAAAWUlEQVR4nMWJIRZAQAAFZzcI3GPfQ3YdmkOoEmEbl9I3OAnFF/axSTbp/xl40NyiqXuuAeAcS7IiRHXUmCEY1OfgNrBVDFeAvbHgliQhbremLy/k9WY++DXcjt8VNRtSLMUAAAAASUVORK5CYII=';
  const ARROW_DOWN = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAYAAAALCAYAAABcUvyWAAAAXUlEQVR4nGNggIL/Trr//zvp/ofxmRhwgAGVYPzvqLuAgZEhHkX0//9FjP+NpbgY+IVOMzAwakFFrzN8fGfCxHj22TeG3/9C4ap//wthPPvsG0K3g3b8fwetBBgfANc4Hc+q0W68AAAAAElFTkSuQmCC';

  let boundRoot = null;
  let panel = null;
  let observer = null;
  let scheduled = false;

  const finite = (value, fallback = 0) => {
    const n = Number(value);
    return Number.isFinite(n) ? n : fallback;
  };
  const clamp = (value, min, max) => Math.max(min, Math.min(max, value));
  const rounded = (value) => String(Math.round(finite(value, 0)));
  const threshold = (value) => finite(value, 0) > 0 ? rounded(value) : '--';

  function resolvePresentationLocale() {
    const values = [];
    const htmlLang = document.documentElement && document.documentElement.lang;
    const bodyLang = document.body && document.body.lang;
    if (htmlLang) values.push(htmlLang);
    if (bodyLang) values.push(bodyLang);
    if (typeof navigator !== 'undefined') {
      if (navigator.language) values.push(navigator.language);
      if (navigator.languages && navigator.languages.length) {
        for (const lang of navigator.languages) values.push(lang);
      }
    }
    for (const value of values) {
      const lang = String(value || '').trim().toLowerCase();
      if (/^zh(?:[-_]|$)/.test(lang)) return 'zh';
    }
    return 'en';
  }

  function applyPresentationLocale(root, el) {
    const locale = resolvePresentationLocale();
    root.setAttribute('data-najx-moe-locale', locale);
    el.setAttribute('data-najx-moe-locale', locale);
    const avgLabel = el.querySelector('.najx-avg-label');
    if (avgLabel) avgLabel.textContent = locale === 'zh' ? '平均标伤' : 'Avg. DMG';
  }

  function createPanel(root) {
    const el = document.createElement('div');
    el.className = 'najx-moe-official';
    el.setAttribute('aria-hidden', 'true');
    el.innerHTML = `
      <div class="najx-ring">
        <svg viewBox="0 0 40 40" aria-hidden="true">
          <circle class="najx-ring-track" cx="20" cy="20" r="16" pathLength="100"></circle>
          <circle class="najx-ring-value" cx="20" cy="20" r="16" pathLength="100"></circle>
        </svg>
      </div>
      <img class="najx-star najx-star-1" alt="">
      <img class="najx-star najx-star-2" alt="">
      <img class="najx-star najx-star-3" alt="">
      <div class="najx-rating-row is-flat">
        <span class="najx-rating">--</span>
        <img class="najx-rating-arrow" alt="">
        <span class="najx-rating-delta">0.00%</span>
      </div>
      <div class="najx-avg-row">
        <span class="najx-avg-label"></span>
        <span class="najx-avg-value">--</span>
      </div>
      <span class="najx-threshold-label najx-t65-label">65%</span>
      <span class="najx-threshold-value najx-t65-value">--</span>
      <span class="najx-threshold-label najx-t85-label">85%</span>
      <span class="najx-threshold-value najx-t85-value">--</span>
      <span class="najx-threshold-label najx-t95-label">95%</span>
      <span class="najx-threshold-value najx-t95-value">--</span>
      <span class="najx-threshold-label najx-t100-label">100%</span>
      <span class="najx-threshold-value najx-t100-value">--</span>
    `;
    root.appendChild(el);
    applyPresentationLocale(root, el);
    return el;
  }

  function render() {
    scheduled = false;
    if (!boundRoot || !panel || !boundRoot.isConnected) return;

    applyPresentationLocale(boundRoot, panel);

    const pct = clamp(finite(currentState.moePercent, -1), -1, 100);
    const delta = finite(currentState.moePercentDelta, 0);
    const avg = finite(currentState.moeAVG, 0);
    const marks = clamp(Math.round(finite(currentState.moeMarks, 0)), 0, 3);

    const rating = panel.querySelector('.najx-rating');
    rating.textContent = pct >= 0 ? pct.toFixed(2) + '%' : '--';

    const row = panel.querySelector('.najx-rating-row');
    const arrow = panel.querySelector('.najx-rating-arrow');
    const deltaText = panel.querySelector('.najx-rating-delta');
    row.classList.remove('is-up', 'is-down', 'is-flat');
    if (delta > 0) {
      row.classList.add('is-up');
      arrow.src = ARROW_UP;
      arrow.style.visibility = 'visible';
    } else if (delta < 0) {
      row.classList.add('is-down');
      arrow.src = ARROW_DOWN;
      arrow.style.visibility = 'visible';
    } else {
      row.classList.add('is-flat');
      arrow.removeAttribute('src');
      arrow.style.visibility = 'hidden';
    }
    deltaText.textContent = Math.abs(delta).toFixed(2) + '%';

    panel.querySelector('.najx-avg-value').textContent = avg > 0 ? rounded(avg) : '--';
    panel.querySelector('.najx-t65-value').textContent = threshold(currentState.moe1);
    panel.querySelector('.najx-t85-value').textContent = threshold(currentState.moe2);
    panel.querySelector('.najx-t95-value').textContent = threshold(currentState.moe3);
    panel.querySelector('.najx-t100-value').textContent = threshold(currentState.moe4);

    for (let i = 1; i <= 3; i++) {
      panel.querySelector('.najx-star-' + i).src = i <= marks ? LIGHT_STAR : DARK_STAR;
    }

    const progress = pct < 0 ? 0 : pct;
    const ring = panel.querySelector('.najx-ring-value');
    ring.style.strokeDasharray = progress + ' ' + (100 - progress);
  }

  function scheduleRender() {
    if (scheduled) return;
    scheduled = true;
    requestAnimationFrame(render);
  }

  function bind(root) {
    if (boundRoot === root && panel && panel.isConnected) return;
    if (observer) observer.disconnect();

    boundRoot = root;
    root.classList.add('najx-moe-cn-official');
    panel = root.querySelector(':scope > .najx-moe-official') || createPanel(root);
    applyPresentationLocale(root, panel);

    observer = new MutationObserver(scheduleRender);
    const header = root.querySelector(':scope > .evv2-header');
    const progress = root.querySelector(':scope > .evv2-progress');
    if (header) observer.observe(header, {subtree:true, childList:true, characterData:true, attributes:true});
    if (progress) observer.observe(progress, {subtree:true, childList:true, characterData:true, attributes:true});
    scheduleRender();
  }

  function findRoot() {
    const root = document.getElementById('evv2-root');
    if (root) bind(root);
    requestAnimationFrame(findRoot);
  }

  findRoot();
})();
