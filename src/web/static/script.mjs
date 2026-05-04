// @ts-check

/** @type {import('https://cdn.jsdelivr.net/npm/@shortfuse/materialdesignweb@0.10.3').CustomElement} */
const { CustomElement } = globalThis['@shortfuse/materialdesignweb'];

function formatSize(bytes) {
  if (bytes === null || bytes === undefined) return 'Unknown';
  const units = ['B', 'KB', 'MB', 'GB'];
  let size = Number(bytes);
  let unitIndex = 0;
  while (size >= 1024 && unitIndex < units.length - 1) {
    size /= 1024;
    unitIndex += 1;
  }
  return `${size.toFixed(2)} ${units[unitIndex]}`;
}

function pushUnique(values, value) {
  if (!value || values.includes(value)) return;
  values.push(value);
}

function getGameImageCandidates(game) {
  const appid = game?.steam_appid ?? game?.deploy?.steam_appid;
  const candidates = [];
  pushUnique(candidates, game?.header);
  for (const image of game?.images ?? []) {
    pushUnique(candidates, image);
  }
  if (appid != null) {
    pushUnique(candidates, `https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/${appid}/header.jpg`);
    pushUnique(candidates, `https://cdn.akamai.steamstatic.com/steam/apps/${appid}/header.jpg`);
    pushUnique(candidates, `https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/${appid}/library_hero.jpg`);
    pushUnique(candidates, `https://cdn.akamai.steamstatic.com/steam/apps/${appid}/library_hero.jpg`);
  }
  return candidates;
}

async function loadMetadata() {
  const url = './generated-metadata.json';
  console.log('[DEBUG] loadMetadata: fetching', url);
  const start = performance.now();
  try {
    const res = await fetch(url);
    if (!res.ok) {
      console.warn('[WARN] loadMetadata: not found', res.status);
      return null;
    }
    const data = await res.json();
    console.log('[DEBUG] loadMetadata: mods', data?.mods?.length ?? 0, 'artifacts', data?.artifacts?.length ?? 0, 'elapsed', (performance.now() - start).toFixed(2) + 'ms');
    return data;
  } catch (e) {
    console.error('[ERROR] loadMetadata:', e);
    return null;
  }
}

async function loadGamesIndex() {
  const url = './games-index.json';
  console.log('[DEBUG] loadGamesIndex: fetching', url);
  const start = performance.now();
  try {
    const res = await fetch(url);
    if (!res.ok) {
      console.warn('[WARN] loadGamesIndex: not found', res.status);
      return null;
    }
    const data = await res.json();
    console.log('[DEBUG] loadGamesIndex: games', data?.games?.length ?? 0, 'elapsed', (performance.now() - start).toFixed(2) + 'ms');
    return data;
  } catch (e) {
    console.error('[ERROR] loadGamesIndex:', e);
    return null;
  }
}

const RdxApp = CustomElement
  .extend()
  .observe({
    _metadata: { type: 'object' },
    _games: { type: 'array', value: () => [] },
    _loading: { type: 'boolean', value: true },
    _error: 'string',
  })
  .expressions({
    formatTotalSize({ _totalSize }) { return _totalSize ? formatSize(_totalSize) : '-'; },
    modImageHeader({ _metadata }, { gm }) {
      return getGameImageCandidates(gm)[0] ?? null;
    },
    modImageFallbacks({ _metadata }, { gm }) {
      return JSON.stringify(getGameImageCandidates(gm).slice(1));
    },
    hasGameHeader({ _metadata }, { gm }) {
      return getGameImageCandidates(gm).length > 0;
    },
    artifactDisplaySize({ metadata }, { artifact }) {
      if (!artifact) return '';
      if (artifact.size == null) return ''
      return formatSize(artifact.size);
    },
    modDisplayTitle({ metadata }, { m }) {
      if (!m) return '';
      const title = m.title || m.mod_name || m.id || 'RenoDX Addon';
      return m.variant ? `${title} (${m.variant})` : title;
    },
    artifactLabel({ metadata }, { v }) {
      if (!v) return '';
      const arch = v.arch || 'download';
      return v.size == null ? arch : `${arch} ${formatSize(v.size)}`;
    },
    hasBadges({ metadata }, { mod }) {
      if (!mod) return false;
      return !!mod.status || mod.tags?.length > 0;
    }
  })
  .methods({
    async refresh() {
      this._loading = true;
      try {
        const start = performance.now();

        // Load both metadata and games index
        const [metadata, gamesIndex] = await Promise.all([
          loadMetadata(),
          loadGamesIndex()
        ]);

        console.log('[DEBUG] data loaded in', (performance.now() - start).toFixed(2) + 'ms');

        if (!metadata || !gamesIndex) {
          throw new Error('Failed to load metadata or games index');
        }

        this._metadata = metadata;
        this._games = gamesIndex.games || [];
      } catch (e) {
        console.error('[ERROR] refresh:', e);
        this._error = 'Unable to load manifest / metadata. Check generated-metadata.json and games-index.json.';
      } finally {
        this._loading = false;
      }
    },
    onGameHeaderLoad({ currentTarget }) {
      console.log('Header image loaded:', currentTarget.src);
      currentTarget.setAttribute('image-loaded', 'true');
    },
    onGameHeaderError({ currentTarget }) {
      currentTarget.removeAttribute('image-loaded');

      let fallbackSrcs = [];
      try {
        fallbackSrcs = JSON.parse(currentTarget.dataset.fallbackSrcs || '[]');
      } catch (error) {
        console.warn('Unable to parse header image fallbacks:', error);
      }

      const [nextSrc, ...remainingSrcs] = fallbackSrcs;
      currentTarget.dataset.fallbackSrcs = JSON.stringify(remainingSrcs);
      if (nextSrc) {
        currentTarget.src = nextSrc;
      } else {
        currentTarget.removeAttribute('src');
      }
    }
  })
  .html`
    <mdw-root>
      <mdw-page>
        <mdw-pane block>
          <mdw-top-app-bar headline="RenoDX">
            <mdw-icon-button slot=trailing icon=info aria-label="About" href="https://github.com/clshortfuse/renodx" target=_blank></mdw-icon-button>
          </mdw-top-app-bar>
          <mdw-grid padding=pane padding-y=16 gap=16>
            <mdw-box mdw-if={_loading} x=center col-span=100%>
              <mdw-progress circle></mdw-progress>
            </mdw-box>

            <!-- Cards for each game, showing all mods for that game -->
            <mdw-card class=mod-card elevated col-span=4 col-span-8=4 col-span-12=6 mdw-for="{gm of _games}">
              <mdw-box class=placeholder-header>
                <img class=game-header mdw-if={hasGameHeader} src="{modImageHeader}" data-fallback-srcs="{modImageFallbacks}" alt="header image" loading=lazy on-load="{onGameHeaderLoad}" on-error="{onGameHeaderError}"/>
                <mdw-box class=game-title>
                  <mdw-headline size=small>{gm.title}</mdw-headline>
                </mdw-box>
              </mdw-box>
              <mdw-box padding=16 gap=12>
                <mdw-list>
                  <mdw-list-item class=mod-row mdw-for="{m of gm.mods}" lines=2>
                    <mdw-body class=mod-title>{modDisplayTitle}</mdw-body>
                    <mdw-box class=artifact-links slot=trailing row gap=8>
                      <mdw-button mdw-for="{v of m.artifacts}" outlined href={v.url}>
                        {artifactLabel}
                      </mdw-button>
                    </mdw-box>
                  </mdw-list-item>
                </mdw-list>
              </mdw-box>
            </mdw-card>
          </mdw-grid>
        </mdw-pane>
      </mdw-page>

      <mdw-snackbar-container slot=bottom-fixed mdw-if={_error}>
        <mdw-snackbar persistent close-button open>{_error}</mdw-snackbar>
      </mdw-snackbar-container>
    </mdw-root>
  `
  .css`
    .mod-card {
      overflow: clip; /* Allows rounded corners on images */
      min-width: 0;
    }
    .mod-card img {
      width: 100%;
      height: 100%;
      display: block;
      object-fit: cover;
    }
    .placeholder-header {
      position: relative;
      width: 100%;
      aspect-ratio: 460 / 215; /* Steam header aspect ratio */
      background: #102728;
    }
    .game-header {
      position: absolute;
      opacity: 0;
      inset: 0;
    }
    .game-header[image-loaded] {
      opacity: 1;
      transition: opacity 0.3s ease-in;
    }
    .game-title {
      position: absolute;
      inset: auto 0 0 0;
      padding: 48px 16px 16px;
      color: white;
      background: linear-gradient(0deg, rgb(0 0 0 / 0.72), rgb(0 0 0 / 0));
    }
    .mod-row {
      min-height: 64px;
    }
    .mod-title {
      min-width: 0;
      overflow-wrap: anywhere;
    }
    .artifact-links {
      display: flex;
      flex-wrap: wrap;
      justify-content: flex-end;
      max-width: 100%;
    }
    .artifact-links mdw-button {
      white-space: nowrap;
    }
  `
  .childEvents({
  })
  .on({
    connected() {
      console.log('[DEBUG] connected: start');
      this.refresh();
    },
  })
  .autoRegister('rdx-app');
