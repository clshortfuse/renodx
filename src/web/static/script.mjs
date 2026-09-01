// @ts-nocheck
// Material Design Web exposes its builder through a runtime global and template DSL.

(() => {
  const { addSVGAlias } =
    globalThis['@shortfuse/materialdesignweb'].svgAlias;
  const viewBox = '0 -960 960 960';
  const aliases = [
    ['sports_esports', 'M182-200q-51 0-79-35.5T82-322l42-300q9-60 53.5-99T282-760h396q60 0 104.5 39t53.5 99l42 300q7 51-21 86.5T778-200q-21 0-39-7.5T706-230l-90-90H344l-90 90q-15 15-33 22.5t-39 7.5Zm16-86 114-114h336l114 114q2 2 16 6 11 0 17.5-6.5T800-304l-44-308q-4-29-26-48.5T678-680H282q-30 0-52 19.5T204-612l-44 308q-2 11 4.5 17.5T182-280q2 0 16-6Zm510.5-165.5Q720-463 720-480t-11.5-28.5Q697-520 680-520t-28.5 11.5Q640-497 640-480t11.5 28.5Q663-440 680-440t28.5-11.5Zm-80-120Q640-583 640-600t-11.5-28.5Q617-640 600-640t-28.5 11.5Q560-617 560-600t11.5 28.5Q583-560 600-560t28.5-11.5ZM310-440h60v-70h70v-60h-70v-70h-60v70h-70v60h70v70Zm170-40Z'],
    ['sports_esports#filled', 'M182-200q-51 0-79-35.5T82-322l42-300q9-60 53.5-99T282-760h396q60 0 104.5 39t53.5 99l42 300q7 51-21 86.5T778-200q-21 0-39-7.5T706-230l-90-90H344l-90 90q-15 15-33 22.5t-39 7.5Zm526.5-251.5Q720-463 720-480t-11.5-28.5Q697-520 680-520t-28.5 11.5Q640-497 640-480t11.5 28.5Q663-440 680-440t28.5-11.5Zm-80-120Q640-583 640-600t-11.5-28.5Q617-640 600-640t-28.5 11.5Q560-617 560-600t11.5 28.5Q583-560 600-560t28.5-11.5ZM310-440h60v-70h70v-60h-70v-70h-60v70h-70v60h70v70Z'],
    ['code', 'M320-240 80-480l240-240 57 57-184 184 183 183-56 56Zm320 0-57-57 184-184-183-183 56-56 240 240-240 240Z'],
    ['code#filled', 'M320-240 80-480l240-240 57 57-184 184 183 183-56 56Zm320 0-57-57 184-184-183-183 56-56 240 240-240 240Z'],
    ['hdr_on', 'M640-360v-240h140q24 0 42 18t18 42v40q0 23-10.5 35.5T804-444l36 84h-60l-36-80h-44v80h-60Zm60-140h80v-40h-80v40ZM120-360v-240h60v80h80v-80h60v240h-60v-100h-80v100h-60Zm260 0v-240h140q24 0 42 18t18 42v120q0 24-18 42t-42 18H380Zm60-60h80v-120h-80v120Z'],
    ['deployed_code', 'M440-183v-274L200-596v274l240 139Zm80 0 240-139v-274L520-457v274Zm-40-343 237-137-237-137-237 137 237 137ZM160-252q-19-11-29.5-29T120-321v-318q0-22 10.5-40t29.5-29l280-161q19-11 40-11t40 11l280 161q19 11 29.5 29t10.5 40v318q0 22-10.5 40T800-252L520-91q-19 11-40 11t-40-11L160-252Zm320-228Z'],
    ['tune', 'M440-120v-240h80v80h320v80H520v80h-80Zm-320-80v-80h240v80H120Zm160-160v-80H120v-80h160v-80h80v240h-80Zm160-80v-80h400v80H440Zm160-160v-240h80v80h160v80H680v80h-80Zm-480-80v-80h400v80H120Z'],
    ['open_in_new', 'M200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h280v80H200v560h560v-280h80v280q0 33-23.5 56.5T760-120H200Zm188-212-56-56 372-372H560v-80h280v280h-80v-144L388-332Z'],
    ['open_in_new#filled', 'M200-120q-33 0-56.5-23.5T120-200v-560q0-33 23.5-56.5T200-840h280v80H200v560h560v-280h80v280q0 33-23.5 56.5T760-120H200Zm188-212-56-56 372-372H560v-80h280v280h-80v-144L388-332Z'],
    ['forum', 'M880-80 720-240H320q-33 0-56.5-23.5T240-320v-40h440q33 0 56.5-23.5T760-440v-280h40q33 0 56.5 23.5T880-640v560ZM160-473l47-47h393v-280H160v327ZM80-280v-520q0-33 23.5-56.5T160-880h440q33 0 56.5 23.5T680-800v280q0 33-23.5 56.5T600-440H240L80-280Zm80-240v-280 280Z'],
    ['forum#filled', 'M280-240q-17 0-28.5-11.5T240-280v-80h520v-360h80q17 0 28.5 11.5T880-680v600L720-240H280ZM80-280v-560q0-17 11.5-28.5T120-880h520q17 0 28.5 11.5T680-840v360q0 17-11.5 28.5T640-440H240L80-280Z'],
    ['handshake', 'M475-160q4 0 8-2t6-4l328-328q12-12 17.5-27t5.5-30q0-16-5.5-30.5T817-607L647-777q-11-12-25.5-17.5T591-800q-15 0-30 5.5T534-777l-11 11 74 75q15 14 22 32t7 38q0 42-28.5 70.5T527-522q-20 0-38.5-7T456-550l-75-74-175 175q-3 3-4.5 6.5T200-435q0 8 6 14.5t14 6.5q4 0 8-2t6-4l136-136 56 56-135 136q-3 3-4.5 6.5T285-350q0 8 6 14t14 6q4 0 8-2t6-4l136-135 56 56-135 136q-3 2-4.5 6t-1.5 8q0 8 6 14t14 6q4 0 7.5-1.5t6.5-4.5l136-135 56 56-136 136q-3 3-4.5 6.5T454-180q0 8 6.5 14t14.5 6Zm-1 80q-37 0-65.5-24.5T375-166q-34-5-57-28t-28-57q-34-5-56.5-28.5T206-336q-38-5-62-33t-24-66q0-20 7.5-38.5T149-506l232-231 131 131q2 3 6 4.5t8 1.5q9 0 15-5.5t6-14.5q0-4-1.5-8t-4.5-6L398-777q-11-12-25.5-17.5T342-800q-15 0-30 5.5T285-777L144-635q-9 9-15 21t-8 24q-2 12 0 24.5t8 23.5l-58 58q-17-23-25-50.5T40-590q2-28 14-54.5T87-692l141-141q24-23 53.5-35t60.5-12q31 0 60.5 12t52.5 35l11 11 11-11q24-23 53.5-35t60.5-12q31 0 60.5 12t52.5 35l169 169q23 23 35 53t12 61q0 31-12 60.5T873-437L545-110q-14 14-32.5 22T474-80Zm-99-560Z'],
    ['search', 'M784-120 532-372q-30 24-69 38t-83 14q-109 0-184.5-75.5T120-580q0-109 75.5-184.5T380-840q109 0 184.5 75.5T640-580q0 44-14 83t-38 69l252 252-56 56ZM380-400q75 0 127.5-52.5T560-580q0-75-52.5-127.5T380-760q-75 0-127.5 52.5T200-580q0 75 52.5 127.5T380-400Z'],
    ['search#filled', 'M784-120 532-372q-30 24-69 38t-83 14q-109 0-184.5-75.5T120-580q0-109 75.5-184.5T380-840q109 0 184.5 75.5T640-580q0 44-14 83t-38 69l252 252-56 56ZM380-400q75 0 127.5-52.5T560-580q0-75-52.5-127.5T380-760q-75 0-127.5 52.5T200-580q0 75 52.5 127.5T380-400Z'],
    ['download', 'M480-320 280-520l56-58 104 104v-326h80v326l104-104 56 58-200 200ZM240-160q-33 0-56.5-23.5T160-240v-120h80v120h480v-120h80v120q0 33-23.5 56.5T720-160H240Z'],
    ['search_off', 'M138.5-138.5Q80-197 80-280t58.5-141.5Q197-480 280-480t141.5 58.5Q480-363 480-280t-58.5 141.5Q363-80 280-80t-141.5-58.5ZM824-120 568-376q-12-13-25.5-26.5T516-428q38-24 61-64t23-88q0-75-52.5-127.5T420-760q-75 0-127.5 52.5T240-580q0 6 .5 11.5T242-557q-18 2-39.5 8T164-535q-2-11-3-22t-1-23q0-109 75.5-184.5T420-840q109 0 184.5 75.5T680-580q0 43-13.5 81.5T629-428l251 252-56 56Zm-615-61 71-71 70 71 29-28-71-71 71-71-28-28-71 71-71-71-28 28 71 71-71 71 28 28Z'],
    ['cloud_off', 'M792-56 686-160H260q-92 0-156-64T40-380q0-77 47.5-137T210-594q3-8 6-15.5t6-16.5L56-792l56-56 736 736-56 56ZM260-240h346L284-562q-2 11-3 21t-1 21h-20q-58 0-99 41t-41 99q0 58 41 99t99 41Zm185-161Zm419 191-58-56q17-14 25.5-32.5T840-340q0-42-29-71t-71-29h-60v-80q0-83-58.5-141.5T480-720q-27 0-52 6.5T380-693l-58-58q35-24 74.5-36.5T480-800q117 0 198.5 81.5T760-520q69 8 114.5 59.5T920-340q0 39-15 72.5T864-210ZM593-479Z'],
  ];

  for (const [name, path] of aliases) {
    addSVGAlias(name, path, viewBox);
  }
})();

/** @type {import('https://cdn.jsdelivr.net/npm/@shortfuse/materialdesignweb@0.11.4').CustomElement} */
const { CustomElement } = globalThis['@shortfuse/materialdesignweb'];

function formatSize(bytes) {
  if (bytes === null || bytes === undefined) return '';
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

async function loadJson(url) {
  const response = await fetch(url);
  if (!response.ok) throw new Error(`${url} returned ${response.status}`);
  return response.json();
}

const RdxModBrowser = CustomElement
  .extend()
  .observe({
    _games: { type: 'array', value: () => [] },
    _loading: { type: 'boolean', value: true },
    _error: 'string',
    query: { type: 'string', value: '' },
    _filteredGames: {
      type: 'array',
      get({ _games, query }) {
        if (!Array.isArray(_games)) return [];

        const normalizedQuery = String(query || '').trim().toLocaleLowerCase();
        if (!normalizedQuery) return _games;

        return _games.filter((game) => {
          const values = [game?.title, game?.id, game?.status, ...(game?.tags ?? [])];
          for (const mod of game?.mods ?? []) {
            values.push(mod?.title, mod?.mod_name, mod?.id, mod?.variant, mod?.summary, mod?.status, ...(mod?.tags ?? []));
          }
          return values.some(value => String(value || '').toLocaleLowerCase().includes(normalizedQuery));
        });
      },
    },
  })
  .expressions({
    showResults({ _filteredGames, _loading }) {
      return !_loading && Array.isArray(_filteredGames) && _filteredGames.length > 0;
    },
    showEmpty({ _filteredGames, _loading, _error }) {
      return !_loading && !_error && Array.isArray(_filteredGames) && _filteredGames.length === 0;
    },
    hasError({ _error }) {
      return !!_error;
    },
    resultLabel({ _filteredGames, _games, query }) {
      if (query) return `${_filteredGames.length} of ${_games.length} games`;
      return `${_games.length} games`;
    },
    gameImageHeader(_, { gm }) {
      return getGameImageCandidates(gm)[0] ?? null;
    },
    gameImageFallbacks(_, { gm }) {
      return JSON.stringify(getGameImageCandidates(gm).slice(1));
    },
    hasGameHeader(_, { gm }) {
      return getGameImageCandidates(gm).length > 0;
    },
    modDisplayTitle(_, { m }) {
      if (!m) return '';
      const title = m.title || m.mod_name || m.id || 'RenoDX addon';
      return m.variant ? `${title} (${m.variant})` : title;
    },
    artifactLabel(_, { v }) {
      if (!v) return '';
      const architecture = String(v.arch || 'download').toUpperCase();
      return v.size == null ? `Download ${architecture}` : `Download ${architecture} · ${formatSize(v.size)}`;
    },
  })
  .methods({
    async refresh() {
      this._loading = true;
      this._error = '';
      try {
        const gamesIndex = await loadJson('./games-index.json');
        this._games = gamesIndex.games || [];
      } catch (error) {
        console.error('Unable to load RenoDX downloads:', error);
        this._error = 'Downloads are temporarily unavailable. Visit GitHub for current releases.';
      } finally {
        this._loading = false;
      }
    },
    onGameHeaderLoad({ currentTarget }) {
      currentTarget.setAttribute('image-loaded', 'true');
    },
    onGameHeaderError({ currentTarget }) {
      currentTarget.removeAttribute('image-loaded');

      let fallbackSources = [];
      try {
        fallbackSources = JSON.parse(currentTarget.dataset.fallbackSrcs || '[]');
      } catch (error) {
        console.warn('Unable to parse game image fallbacks:', error);
      }

      const [nextSource, ...remainingSources] = fallbackSources;
      currentTarget.dataset.fallbackSrcs = JSON.stringify(remainingSources);
      if (nextSource) {
        currentTarget.src = nextSource;
      } else {
        currentTarget.removeAttribute('src');
      }
    },
  })
  .html`
    <mdw-grid gap="16" y="center" padding-y="24">
      <mdw-input id="search" type="search" label="Search games or mods" icon="search" col-span-4="4" col-span-8="5" col-span-12="5"></mdw-input>
      <mdw-box col-span-4="4" col-span-8="3" col-span-12="7" x="end">
        <mdw-label mdw-if="{!_loading}" ink="on-surface-variant" size="medium" text-padding="0">{resultLabel}</mdw-label>
      </mdw-box>
    </mdw-grid>

    <mdw-card mdw-if="{_loading}" outlined shape-style="extra-large" padding="24" gap="16" x="center" y="center">
      <mdw-progress circle></mdw-progress>
      <mdw-body ink="on-surface-variant" size="large" align="center" text-padding="0">Loading current builds…</mdw-body>
    </mdw-card>

    <mdw-grid mdw-if="{showResults}" gap="16" y="stretch">
      <mdw-card mdw-for="{gm of _filteredGames}" elevated shape-style="extra-large" color="surface-container" col-span-4="4" col-span-8="4" col-span-12="4">
        <mdw-box class="game-art">
          <img mdw-if="{hasGameHeader}" src="{gameImageHeader}" data-fallback-srcs="{gameImageFallbacks}" alt="" on-load="{onGameHeaderLoad}" on-error="{onGameHeaderError}">
          <mdw-box class="game-art-copy" padding="20">
            <mdw-title role="heading" aria-level="2" size="large" ink="on-surface" text-padding="0">{gm.title}</mdw-title>
          </mdw-box>
        </mdw-box>
        <mdw-box mdw-for="{m of gm.mods}" gap="12" padding="20">
          <mdw-title size="medium" text-padding="0">{modDisplayTitle}</mdw-title>
          <mdw-box row wrap gap="8">
            <mdw-button mdw-for="{v of m.artifacts}" outlined icon="download" href="{v.url}">{artifactLabel}</mdw-button>
          </mdw-box>
          <mdw-divider></mdw-divider>
        </mdw-box>
      </mdw-card>
    </mdw-grid>

    <mdw-card mdw-if="{showEmpty}" outlined shape-style="extra-large" padding="24" gap="16" x="center" y="center">
      <mdw-icon ink="primary" icon="search_off"></mdw-icon>
      <mdw-title size="large" align="center" text-padding="0">No matching games</mdw-title>
      <mdw-body ink="on-surface-variant" size="large" align="center" text-padding="0">Try a title, tag, or addon name.</mdw-body>
    </mdw-card>

    <mdw-card mdw-if="{hasError}" outlined shape-style="extra-large" padding="24" gap="16" x="center" y="center">
      <mdw-icon ink="primary" icon="cloud_off"></mdw-icon>
      <mdw-body ink="on-surface-variant" size="large" align="center" text-padding="0">{_error}</mdw-body>
      <mdw-button outlined icon="open_in_new" href="https://github.com/clshortfuse/renodx/wiki/Mods" target="_blank" rel="noopener" aria-label="Open community mod list (opens in a new tab)">Open community mod list</mdw-button>
    </mdw-card>
  `
  .css`
    :host {
      display: block;
    }

    .game-art {
      position: relative;
      overflow: hidden;
      aspect-ratio: 460 / 215;
      background: linear-gradient(135deg, rgb(var(--mdw-color__primary) / 32%), transparent), rgb(var(--mdw-color__surface-container-high));
    }

    .game-art img {
      position: absolute;
      inset: 0;
      width: 100%;
      height: 100%;
      object-fit: cover;
      opacity: 0;
      transition: opacity 220ms ease, transform 320ms ease;
    }

    .game-art img[image-loaded] {
      opacity: 1;
    }

    mdw-card:hover .game-art img[image-loaded] {
      transform: scale(1.025);
    }

    .game-art-copy {
      position: absolute;
      inset: auto 0 0;
      background: linear-gradient(transparent, rgb(0 0 0 / 88%));
    }

    @media (prefers-reduced-motion: reduce) {
      .game-art img {
        transition: none;
      }

      mdw-card:hover .game-art img[image-loaded] {
        transform: none;
      }
    }
  `
  .childEvents({
    search: {
      input({ currentTarget }) {
        this.query = currentTarget?.value || '';
      },
    },
  })
  .on({
    connected() {
      this.refresh();
    },
  })
  .autoRegister('rdx-mod-browser');
