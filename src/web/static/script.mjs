// @ts-nocheck
// Material Design Web exposes its builder through a runtime global and template DSL.

(() => {
  const { addSVGAlias } =
    globalThis['@shortfuse/materialdesignweb'].svgAlias;
  const viewBox = '0 -960 960 960';
  const aliases = [
    ['info', 'M440-280h80v-240h-80v240Zm40-320q17 0 28.5-11.5T520-640q0-17-11.5-28.5T480-680q-17 0-28.5 11.5T440-640q0 17 11.5 28.5T480-600Zm0 520q-83 0-156-31.5T197-197q-54-54-85.5-127T80-480q0-83 31.5-156T197-763q54-54 127-85.5T480-880q83 0 156 31.5T763-763q54 54 85.5 127T880-480q0 83-31.5 156T763-197q-54 54-127 85.5T480-80Zm0-80q134 0 227-93t93-227q0-134-93-227t-227-93q-134 0-227 93t-93 227q0 134 93 227t227 93Z'],
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
    _infoMods: { type: 'array', value: () => [] },
    _infoTitle: { type: 'string', value: '' },
    _loading: { type: 'boolean', value: true },
    _error: 'string',
    query: { type: 'string', value: '' },
    hideInactive: { type: 'boolean', value: true },
    _filteredGames: {
      type: 'array',
      get({ _games, query, hideInactive }) {
        if (!Array.isArray(_games)) return [];

        const normalizedQuery = String(query || '').trim().toLocaleLowerCase();
        return _games.map(game => {
          const mods = game.mods.filter(mod => !hideInactive || !mod.inactive);
          return {
            ...game,
            mods: mods.map(mod => ({ ...mod, showStatusBadge: mods.length > 1 && ['beta', 'experimental'].includes(mod.status), statusBadge: mod.status })),
            showStatusBadge: mods.length === 1 && ['beta', 'experimental'].includes(mods[0].status),
            statusBadge: mods.length === 1 ? mods[0].status : '',
          };
        }).filter(game => game.mods.length > 0).filter((game) => {
          if (!normalizedQuery) return true;
          const values = [game?.title, game?.id, game?.status, ...(game?.aliases ?? []), ...(game?.tags ?? [])];
          for (const mod of game?.mods ?? []) {
            values.push(mod?.title, mod?.mod_name, mod?.id, mod?.variant, mod?.summary, mod?.status, mod?.category, mod?.compatibility, ...(mod?.maintainers ?? []), ...(mod?.notes ?? []), ...(mod?.tags ?? []));
          }
          return values.some(value => String(value || '').toLocaleLowerCase().includes(normalizedQuery));
        });
      },
    },
  })
  .expressions({
    showModTitle(_, { m, gm }) {
      return !!m && (gm?.mods?.length > 1 || m.category === 'engine');
    },
    showModCompatibility(_, { m }) {
      return ['in-progress', 'unsupported'].includes(m?.compatibility);
    },
    showGameCompatibility(_, { gm }) {
      return gm?.mods?.length === 1 && ['in-progress', 'unsupported'].includes(gm.mods[0].compatibility);
    },
    showGameBadges(_, { gm }) {
      return !!gm?.showStatusBadge || (gm?.mods?.length === 1 && ['in-progress', 'unsupported'].includes(gm.mods[0].compatibility));
    },
    gameCompatibility(_, { gm }) {
      return ({ 'in-progress': 'WIP', unsupported: 'Unsupported' })[gm?.mods?.[0]?.compatibility] || '';
    },
    showVariantBadges(_, { gm, m }) {
      return gm?.mods?.length > 1 && (m?.showStatusBadge || ['in-progress', 'unsupported'].includes(m?.compatibility));
    },
    showModSummary(_, { m }) {
      return !!m?.summary?.trim();
    },
    showModCredits(_, { m }) {
      return !!m?.maintainers?.length;
    },
    modCredits(_, { m }) {
      return m?.maintainers?.length ? `By ${m.maintainers.join(', ')}` : '';
    },
    showModRequirements(_, { m }) {
      return !!m?.deploy?.reshade_version_range;
    },
    showResults({ _filteredGames, _loading }) {
      return !_loading && Array.isArray(_filteredGames) && _filteredGames.length > 0;
    },
    showEmpty({ _filteredGames, _loading, _error }) {
      return !_loading && !_error && Array.isArray(_filteredGames) && _filteredGames.length === 0;
    },
    hasError({ _error }) {
      return !!_error;
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
    modDisplayTitle(_, { m, gm }) {
      if (!m) return '';
      const title = m.title || m.mod_name || m.id || 'RenoDX addon';
      if (!m.variant && title === gm?.title && gm?.mods?.length === 1) return '';
      return m.variant ? `${title} (${m.variant})` : title;
    },
    modCompatibility(_, { m }) {
      if (!m) return '';
      return ({ 'in-progress': 'WIP', unsupported: 'Unsupported' })[m.compatibility] || '';
    },
    hasModDetails(_, { m }) {
      return !!(m?.notes?.some(note => note.trim()) || m?.deploy?.reshade_version_range);
    },
    modRequirements(_, { m }) {
      if (!m) return '';
      return m.deploy?.reshade_version_range ? `Requires ReShade ${m.deploy.reshade_version_range}` : '';
    },
    linkLabel(_, { link }) {
      if (!link) return '';
      return link.label || ({ nexus: 'Nexus Mods', nexus_mods: 'Nexus Mods', snapshot: 'Snapshot', discord: 'Discord', gamebanana: 'GameBanana', discussion: 'Compatibility discussion', replacement: 'Replacement mod' })[link.kind] || link.kind;
    },
    linkIcon(_, { link }) {
      if (!link) return '';
      return ({ nexus: '', nexus_mods: '', snapshot: 'download', discord: 'forum', discussion: 'forum', support: 'forum', gamebanana: 'sports_esports', source: 'code', github: 'code' })[link.kind] ?? 'open_in_new';
    },
    linkIconSource(_, { link }) {
      // Inset the full-bleed brand mark to 18px within the standard 24px icon.
      return ['nexus', 'nexus_mods'].includes(link?.kind) ? './nexusmods.svg#svgView(viewBox(-4,-4,32,32))' : null;
    },
    artifactLabel(_, { v }) {
      if (!v) return '';
      const architecture = String(v.arch || 'download').toUpperCase();
      return v.size == null ? `Download ${architecture}` : `Download ${architecture} · ${formatSize(v.size)}`;
    },
  })
  .methods({
    changeInactiveFilter({ currentTarget }) {
      this.hideInactive = currentTarget.checked;
    },
    openModInfo({ currentTarget }) {
      const game = this._games.find(game => game.id === currentTarget.dataset.gameId);
      const mod = game?.mods.find(mod => mod.id === currentTarget.dataset.modId);
      if (!mod) return;
      this._infoMods = [mod];
      this._infoTitle = mod.title || game.title;
      this.shadowRoot.querySelector('#mod-info').showModal();
    },
    closeModInfo({ currentTarget }) {
      currentTarget.closest('mdw-dialog').close();
    },
    async refresh() {
      this._loading = true;
      this._error = '';
      try {
        const gamesIndex = await loadJson('./games-index.json');
        this._games = (gamesIndex.games || []).map(game => ({
          ...game,
          mods: (game.mods ?? []).filter(mod => mod.category !== 'related'),
        })).filter(game => game.mods.length > 0).map(game => ({
          ...game,
          showStatusBadge: game.mods?.length === 1 && ['beta', 'experimental'].includes(game.mods[0].status),
          statusBadge: game.mods?.length === 1 && ['beta', 'experimental'].includes(game.mods[0].status)
            ? game.mods[0].status : '',
          mods: (game.mods ?? []).map(mod => ({
            ...mod,
            inactive: mod.category === 'deprecated' || mod.compatibility === 'unsupported'
              || ['legacy', 'abandoned', 'deprecated'].includes(mod.support)
              || (mod.notes ?? []).some(note => /^(abandoned|currently broken|superseded by|no longer supported|not working with|needs to be redone)\b/i.test(note.trim())),
            showStatusBadge: game.mods.length > 1 && ['beta', 'experimental'].includes(mod.status),
            statusBadge: game.mods.length > 1 && ['beta', 'experimental'].includes(mod.status)
              ? mod.status : '',
            safeUrls: (mod.urls ?? []).filter(link => {
              try {
                const url = new URL(link.url);
                return ['https:', 'http:'].includes(url.protocol) && !url.username && !url.password;
              } catch { return false; }
            }),
          })),
        }));
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
    <mdw-box row wrap gap="16" y="center" padding-y="24">
      <mdw-input id="search" style="flex: 1 1 240px;" type="search" label="Search games or mods" icon="search"></mdw-input>
      <mdw-box row wrap gap="8">
        <mdw-filter-chip checked="{hideInactive}" on-change="{changeInactiveFilter}">Active</mdw-filter-chip>
      </mdw-box>
    </mdw-box>

    <mdw-card mdw-if="{_loading}" outlined shape-style="extra-large" padding="24" gap="16" x="center" y="center">
      <mdw-progress circle></mdw-progress>
      <mdw-body ink="on-surface-variant" size="large" align="center" text-padding="0">Loading current builds…</mdw-body>
    </mdw-card>

    <mdw-grid mdw-if="{showResults}" class="results-grid" gap="16" y="stretch">
      <mdw-card mdw-for="{gm of _filteredGames}" elevated shape-style="extra-large" color="surface-container" col-span-4="4" col-span-8="4" col-span-12="4">
        <mdw-box class="game-art">
          <img mdw-if="{hasGameHeader}" src="{gameImageHeader}" data-fallback-srcs="{gameImageFallbacks}" alt="" on-load="{onGameHeaderLoad}" on-error="{onGameHeaderError}">
          <mdw-box class="game-art-copy" row y="center" gap="8" padding="16">
            <mdw-title role="heading" aria-level="2" size="large" ink="on-surface" text-padding="0">{gm.title}</mdw-title>
            <mdw-box mdw-if="{showGameBadges}" class="game-badges" gap="4" x="end">
              <span mdw-if="{gm.showStatusBadge}" class="status-badge">{gm.statusBadge}</span>
              <span mdw-if="{showGameCompatibility}" class="status-badge">{gameCompatibility}</span>
            </mdw-box>
          </mdw-box>
        </mdw-box>
        <mdw-box class="mod-content" mdw-for="{m of gm.mods}" gap="8" padding="16">
          <mdw-title mdw-if="{showModTitle}" size="medium" text-padding="0">{modDisplayTitle}</mdw-title>
          <mdw-box mdw-if="{showVariantBadges}" row wrap gap="4" x="end">
            <span mdw-if="{m.showStatusBadge}" class="status-badge">{m.statusBadge}</span>
            <span mdw-if="{showModCompatibility}" class="status-badge">{modCompatibility}</span>
          </mdw-box>
          <mdw-body mdw-if="{showModCredits}" class="mod-credits" size="medium" text-padding="0">{modCredits}</mdw-body>
          <mdw-body mdw-if="{showModSummary}" size="medium" text-padding="0">{m.summary}</mdw-body>
          <mdw-box class="mod-actions" row wrap gap="4" aria-label="Downloads and resources">
            <mdw-icon-button mdw-if="{hasModDetails}" icon="info" data-game-id="{gm.id}" data-mod-id="{m.id}" aria-label="Mod information" aria-haspopup="dialog" on-click="{openModInfo}">Mod information</mdw-icon-button>
            <mdw-icon-button mdw-for="{link of m.safeUrls}" icon="{linkIcon}" src="{linkIconSource}" href="{link.url}" aria-label="{linkLabel}" target="_blank" rel="noopener noreferrer">{linkLabel}</mdw-icon-button>
            <mdw-icon-button mdw-for="{v of m.artifacts}" icon="download" href="{v.url}" aria-label="{artifactLabel}">{artifactLabel}</mdw-icon-button>
          </mdw-box>
        </mdw-box>
      </mdw-card>
    </mdw-grid>

    <mdw-dialog id="mod-info" headline="{_infoTitle}" aria-label="Mod information">
      <mdw-box mdw-for="{m of _infoMods}" gap="16">
        <mdw-body mdw-if="{showModCredits}" size="medium" text-padding="0">{modCredits}</mdw-body>
        <mdw-body mdw-if="{showModSummary}" size="medium" text-padding="0">{m.summary}</mdw-body>
        <mdw-body mdw-if="{showModRequirements}" size="medium" text-padding="0">{modRequirements}</mdw-body>
        <mdw-body class="metadata-note" mdw-for="{note of m.notes}" size="medium" text-padding="0">{note}</mdw-body>
      </mdw-box>
      <mdw-button slot="actions" autofocus on-click="{closeModInfo}">Close</mdw-button>
    </mdw-dialog>

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

    summary { cursor: pointer; }
    mdw-icon-button[src] { filter: invert(1); }
    .mod-actions > mdw-icon-button[icon="download"] { order: 1; }
    .results-grid > mdw-card { height: 100%; }
    .mod-content { flex: 1; flex-direction: row; flex-wrap: wrap; align-content: flex-start; align-items: center; }
    .mod-content > :not(.mod-credits):not(.mod-actions) { flex-basis: 100%; }
    .game-badges { flex: 0 0 auto; margin-inline-start: auto; max-width: 100%; min-width: 0; }
    .mod-credits { flex: 1 1 auto; }
    .mod-actions { order: 0; margin-inline-start: auto; flex: 0 1 auto; }
    .mod-content + .mod-content { border-top: 1px solid rgb(var(--mdw-color__outline-variant)); }
    .game-art-copy mdw-title { flex: 1 1 180px; min-width: 0; overflow-wrap: anywhere; }
    .status-badge {
      flex: none;
      align-self: flex-end;
      border: 1px solid rgb(var(--mdw-color__primary) / 45%);
      border-radius: 999px;
      padding: 3px 9px;
      background: rgb(0 0 0 / 72%);
      color: rgb(var(--mdw-color__primary));
      font-size: 12px;
      font-weight: 600;
      line-height: 18px;
      text-transform: capitalize;
      box-sizing: border-box;
      max-width: 100%;
      overflow-wrap: anywhere;
    }
    .metadata-note { white-space: pre-wrap; overflow-wrap: anywhere; }

    .game-art {
      position: relative;
      display: flex;
      flex-direction: column;
      justify-content: flex-end;
      flex-shrink: 0;
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
      position: relative;
      display: flex;
      flex-direction: row;
      flex-wrap: wrap;
      align-items: center;
      box-sizing: border-box;
      width: 100%;
      background: rgb(40 40 40 / 75%);
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
