(function(){
  const root = document.documentElement;
  const key = 'ccam-theme';
  const saved = localStorage.getItem(key);
  const prefersLight = window.matchMedia && window.matchMedia('(prefers-color-scheme: light)').matches;
  if (saved === 'light' || (!saved && prefersLight)) root.classList.add('light');

  const btn = document.getElementById('themeToggle');
  if (btn) {
    btn.addEventListener('click', () => {
      root.classList.toggle('light');
      localStorage.setItem(key, root.classList.contains('light') ? 'light' : 'dark');
    });
  }

  // Copy-to-clipboard for any pre > code blocks
  document.querySelectorAll('pre > code').forEach(code => {
    const pre = code.parentElement;
    const wrap = document.createElement('div');
    wrap.style.position = 'relative';
    pre.parentNode.insertBefore(wrap, pre);
    wrap.appendChild(pre);

    const btn = document.createElement('button');
    btn.textContent = 'Copy';
    btn.setAttribute('aria-label', 'Copy code');
    btn.className = 'copy-btn';
    btn.style.position = 'absolute';
    btn.style.top = '.5rem';
    btn.style.right = '.5rem';
    btn.style.padding = '.3rem .6rem';
    btn.style.borderRadius = '.4rem';
    btn.style.border = '1px solid var(--border)';
    btn.style.background = 'var(--bg-alt)';
    btn.style.color = 'var(--text)';
    btn.addEventListener('click', async () => {
      try { await navigator.clipboard.writeText(code.textContent); btn.textContent = 'Copied!'; setTimeout(()=>btn.textContent='Copy',1200); }
      catch(e){ console.warn('Clipboard failed', e); }
    });
    wrap.appendChild(btn);
  });
})();
