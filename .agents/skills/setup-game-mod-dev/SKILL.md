---
name: setup-game-mod-dev
description: "RenoDX workflow for setting up or resuming game mod development with Clang debug builds, DevKit, MCP bridge, ReShade game-folder links, live shader paths, per-game addon scaffolds, metadata, shader dump/decompile baselines, and verification. Use when starting a new src/games/{game} mod, continuing game-specific addon work, configuring DevKit for a game, or turning DevKit findings into a real mod."
argument-hint: "game title/folder, install path, graphics API, and fresh vs continuing"
---

# Setup Game Mod Development

Set up **RenoDX mod development for a specific game**. Cover the local toolchain, DevKit/MCP inspection, game-folder ReShade/addon links, and the initial or continued `src/games/{game}` workflow.

Focus on the **development environment and mod scaffold**. For swapchain/resource tracing, HDR source proof, resource upgrades, or rejecting final-SDR inverse-tonemap approaches, use `swapchain-resource-analysis`. For shader-side tonemap/LUT math after the target pass is known, use `handle-sdr-tonemap-lut`.

## Related skills and scope

| Need | Use |
|---|---|
| Create/resume a game folder, build targets, link ReShade/addons, configure DevKit paths | This skill |
| Trace final output, resource formats, swapchain proxy, `SwapChainPass`, SDR/HDR output toggle, or HDR source proof | `swapchain-resource-analysis` |
| Edit the proven game shader for RenoDRT/PsychoV/LUT bridge math | `handle-sdr-tonemap-lut` |

Keep this skill focused on getting the mod development environment and baseline workflow ready. Record enough facts for handoff, but do not duplicate the specialized swapchain/resource or shader-math workflows.

## Boundaries

- Keep changes local to one `src/games/{game}` folder unless cross-mod work is explicitly requested.
- Do not change global CMake presets, CI workflows, vendored dependencies, or external submodules.
- New mods start from `src/games/generic`.
- Use the CMake target named after the mod folder; the output artifact is `renodx-{mod}.addon64` or `.addon32`.
- Use the `devkit` and `mcp_bridge` targets for local inspection; their debug outputs are `renodx-devkit.addon64` and `renodx-mcp-bridge.exe`.
- Prefer Clang CMake presets for real development builds. Use VS Code CMake build integration when available, but select the `clang-*` configure/build presets. Treat `ninja-*` and `vs-*` presets as workflow testing paths only, not normal mod development paths.
- Do not build a game addon while that game is running with the addon loaded; the DLL can be locked.
- Do not put dumped `.cso` files in `src/games/{game}`. They can shadow editable HLSL during live shader loading.

## Required setup facts

Collect or infer these before editing files or changing a game folder:

| Fact | Notes |
|---|---|
| Work mode | `continue` if `src/games/{game}` exists or the user says resume; `fresh` otherwise. |
| Mod folder id | Lowercase folder name under `src/games`, usually no spaces. |
| Game title | Human-readable metadata title. |
| Game binary folder | The folder where ReShade and `.addon64`/`.addon32` files must load from. Infer from metadata when possible, but verify because it may be a subfolder such as `...\Binaries\Win64`. |
| Executable/process | `game_exe` or `process_name` for metadata and runtime checks. |
| Graphics API | Usually `d3d11`, `d3d12`, or `vulkan`; affects loader DLL naming and shader targets. |
| Architecture | Usually `x64`; use `.addon32` only for 32-bit games. |
| Swapchain/output state | Optional early fact: known swapchain format/color space, especially RGBA8U/UNORM bottlenecks or existing HDR/scRGB/PQ paths. |
| Proxy/resource need | Optional early fact: whether evidence suggests a RGBA16F proxy, resource upgrade, `SwapChainPass` output shader, or output preset cbuffer is needed before shader-side tonemap work. |
| Store ids | Steam/GOG/Microsoft/Nexus ids if known. |
| Loader name | Default is often `dxgi.dll`; honor `deploy.reshade_preferred_name` or game-specific requirements. |
| ReShade state | Whether the game folder already has a ReShade loader DLL, `ReShade.ini`, and `ReShade.log`. |

Before asking for missing facts, read `src/games/{mod}/metadata.json` when it exists. Use `deploy.steam_appid`, `deploy.game_exe`, `deploy.process_name`, `deploy.api`, `deploy.architecture`, `deploy.reshade_preferred_name`, and `deploy.detection.default_install_paths` to reduce guessing. If `steam_appid` is present, resolve the local Steam install by reading Steam `libraryfolders.vdf` and `appmanifest_{appid}.acf`, then use `game_exe`/`process_name` to locate the binary folder. Steam metadata alone usually resolves only the install root; still ask when executable metadata is missing, the game is not locally installed, or multiple executable matches make the injection folder ambiguous.

## Expected agent output

When invoked, produce or maintain these sections in the response or working notes:

1. **Setup facts** - game folder, install/binary folder, API, arch, and mode.
2. **Existing state** - mod folder files, metadata, registered shaders, current build artifacts, and relevant scratch/verification notes.
3. **Build plan** - exact Clang debug CMake targets (`devkit`, `mcp_bridge`, `{mod}`) and any game-shutdown requirement.
4. **Game-folder link plan** - ReShade bootstrap state, loader DLL, DevKit addon, and game addon symlink/copy targets; list conflicts instead of deleting unknown files.
5. **DevKit plan** - MCP connection, tools path, live shader path, snapshot, draw/resource/shader inspection steps, and any handoff needed for swapchain/resource proof.
6. **Baseline plan** - original capture, dump/decompile location, editable HLSL location, 1:1 live baseline validation.
7. **Verification checklist** - target built, files generated, addon loaded, shader replacement active, runtime output validated.

## Continue an existing mod

Use this path when `src/games/{mod}` already exists.

1. Inspect the existing folder:
   - `metadata.json`
   - `addon.cpp`
   - `shared.h`
   - existing shader replacements and includes
   - committed `README.md`, verification/dev notes, or repo memory if present
2. Treat the folder name as the build target unless CMake target listing proves otherwise.
3. Preserve existing shader registrations and settings unless the user asks to replace them.
4. Rebuild only the smallest relevant targets:
   - `devkit` and `mcp_bridge` if inspection tooling changed or is missing
   - `{mod}` for the game addon
5. Re-link only the game folder artifacts needed for this session:
   - ReShade loader DLL if missing or known-good symlink target changed
   - `renodx-devkit.addon64` or `.addon32`
   - `renodx-{mod}.addon64` or `.addon32`
6. Point DevKit live shaders at the existing mod folder only if it is clean of dumped binaries and unrelated scratch files.
7. Keep concise build/runtime checks in the agent response or existing committed mod docs when setup knowledge changes.

## Start a fresh mod

1. Create `src/games/{mod}` by copying the relevant files from `src/games/generic`.
2. Keep the first scaffold minimal:
   - `addon.cpp`
   - `shared.h`
   - `metadata.json`
   - shader files only after a real target shader is proven
3. Update exported addon text in `addon.cpp`:
   - `NAME` should identify RenoDX for the game.
   - `DESCRIPTION` should identify the game-specific module.
4. Create `metadata.json` with the schema, `id`, `title`, `status`, optional `summary`/`tags`, and `deploy` fields such as `game_exe`, `api`, `steam_appid`, and `architecture`.
5. Let the top-level CMake auto-discover the mod through `addon.cpp`; do not edit global CMake just to add a game folder.
6. Build the new mod target before adding shader complexity.
7. Add shader registrations only after DevKit identifies stable target shader hashes.

## Local toolchain and build setup

Clang debug is the default path for mod development builds.

| Architecture | Configure preset | Development build preset |
|---|---|---|
| x64 | `clang-x64` | `clang-x64-debug` |
| x86 | `clang-x86` | `clang-x86-debug` |

When working on mods, assume debug build artifacts. Use release presets only for explicit packaging/deploy requests, not normal development or DevKit iteration. Do not use `ninja-*`, `vs-*`, or ad-hoc build folders for real mod development; reserve them for workflow testing or explicit user requests.

1. Ensure repo-local shader tools exist in `bin` when DevKit decompilation or DXC isolation is needed:
   - `dxc.exe`
   - `dxcompiler.dll`
   - `cmd_Decompiler.exe`
   - optional SPIR-V tools
2. If tools are missing, run the repo setup script from the repo root with install/update intent.
3. Build these targets for live inspection:
   - `devkit`
   - `mcp_bridge`
4. Build the game target named `{mod}`.
5. If a build fails because the output `.addon64`/`.addon32` is locked, stop the game and rebuild; do not work around it by renaming random artifacts.

## Game-folder ReShade and addon links

Use symlinks for local development when possible; copy only when symlinks are unavailable or the user asks for deploy-like behavior.

1. Resolve the **game binary folder** from metadata when possible. Prefer `deploy.detection.default_install_paths`, then Steam `deploy.steam_appid` via local `appmanifest_{appid}.acf`, then locate `deploy.game_exe`/`process_name` under that root. Do not assume the Steam install root is the injection folder.
2. Check for existing loader/addon files:
   - ReShade loader DLL, usually `dxgi.dll`
   - `ReShade.ini`
   - `renodx-devkit.addon64`/`.addon32`
   - `renodx-{mod}.addon64`/`.addon32`
3. If a target exists and is not a symlink or known build artifact, report it as a conflict or backup candidate instead of deleting it.
4. Use `scripts/setup-reshade.ps1` against the game binary folder when ReShade search paths or baseline `ReShade.ini` need setup.
5. Link the DevKit addon from the active build output.
6. Link the game addon from the active build output.
7. Launch the game and confirm `ReShade.log` shows both addons loaded.

### If the game folder has no ReShade yet

First use `scripts/setup-dev-env.ps1 -Update` or `-Install` to populate repo-local `bin` with `ReShade32.dll` and `ReShade64.dll` when they are available from the machine's ReShade install. Then use `scripts/setup-reshade.ps1` against the resolved game binary folder before linking addons. If a mod folder already has metadata, prefer `scripts/setup-reshade.ps1 -Mod {mod}` so the script can infer the Steam install and loader defaults from `metadata.json`.

The script currently does useful development setup tasks:

- creates the loader DLL, default `dxgi.dll`, as a symlink to repo-local `bin\ReShade64.dll`/`bin\ReShade32.dll` when available, falling back to `%ProgramData%\ReShade`;
- copies `%ProgramData%\ReShade\ReShade.ini` into the game folder when `ReShade.ini` is missing;
- updates `EffectSearchPaths` and `TextureSearchPaths` in `ReShade.ini` for the game folder and common ReShade shader folders.
- writes `[renodx-dev] ToolsPath` to the repo `bin` folder and `[renodx-dev] LivePath` to `src/games/{mod}` when `-Mod` resolves an existing mod folder, otherwise to the game folder's `renodx-dev\live` path. This avoids starting DevKit with no tools directory configured.

If setup reports that ReShade DLLs or `%ProgramData%\ReShade\ReShade.ini` are missing, install/configure ReShade first, rerun `scripts/setup-dev-env.ps1 -Update`, then rerun the game-folder setup. Do not fabricate a loader path.

Treat these as script limitations unless the user asks to change it:

- it defaults to `-Arch x64` and `-LoaderName dxgi.dll`;
- it leaves an existing non-symlink `dxgi.dll` untouched and reports the conflict.

For a 32-bit game, call the script with `-Arch x86`. For a non-`dxgi.dll` loader or a game that needs `deploy.reshade_preferred_name`, pass `-LoaderName` explicitly and still report any existing non-symlink conflict.

Pass `-LivePath <path>` when the DevKit live shader directory should differ from the mod folder or game-local `renodx-dev\live` directory.

## DevKit MCP setup

When the game is running with DevKit loaded:

1. Connect to the DevKit backend. If multiple connections exist, select the one for the target game.
2. Select the active rendering device; ignore devices with no tracked shaders/draws unless proven relevant.
3. Verify DevKit tools path is the repo `bin` directory. `scripts/setup-reshade.ps1` should preconfigure `[renodx-dev] ToolsPath`, but use the MCP/overlay setter if the running game loaded an older `ReShade.ini` or another profile:
   - `hasDxcompilerDll: true`
   - `hasCmdDecompiler: true` for DXBC SM4/5 decompilation
   - optional `hasDxilSpirv`/`hasSpirvCross` if SPIR-V paths are needed
4. Set live shader path deliberately:
   - `src/games/{mod}` for an existing clean editable mod folder
   - a temporary live folder for early exploration before a mod folder exists
5. Queue a snapshot and inspect late-frame draws first.
6. If no shader target is known, capture the late-frame anchors needed for handoff:
   - final blit/swapchain pass
   - last scene composite/tonemap pass candidates
   - UI/HUD/text pass candidates
7. Hand off to `swapchain-resource-analysis` when the task becomes resource-format proof, `SwapChainPass` output planning, SDR/HDR toggle behavior, or rejection of a final-SDR inverse-tonemap idea.
8. If the only proven input is the completed SDR backbuffer, do not build a RenoDX mod by inverse-tonemapping it; report the missing HDR-source/resource-upgrade problem instead.

## Shader dump and baseline workflow

Follow this strictly to avoid common baseline/decompilation mistakes.

1. Do not hand-reconstruct a baseline shader from scratch.
2. Capture or analyze the original resource output before any replacement.
3. Dump/decompile through DevKit MCP first; do not manually call `cmd_Decompiler.exe` as the primary workflow.
4. Use the game's normal DevKit dump folder, usually `renodx-dev/dump`, for dumped `.cso` files and adjacent decompiled outputs.
5. Copy decompiled HLSL into `src/games/{mod}` only when it becomes the editable live baseline.
6. Keep `src/games/{mod}` free of dumped `.cso` binaries.
7. Live-load only the 1:1 baseline replacement first.
8. Capture/analyze the same output again and compare original vs baseline before adding HDR/tone-map changes.
9. Keep vanilla logic readable or commented while proving equivalence.
10. After the custom path is active, branch around expensive vanilla clip/LUT work instead of running vanilla and custom grading in the same pixel.
11. Guard shader injection paths so live shaders pass through when DevKit is active but the game addon/buffer binding is not loaded, for example by checking a valid injected peak value before using custom behavior.

## Turning DevKit findings into a real mod

DevKit experiments are proof, not the shipping path.

1. Move proven resource upgrades and shader registrations into `addon.cpp`.
2. Move final editable shader replacements into CRC-addressed files named `{CRC32}.{TARGET}.hlsl` or the existing folder's established `name_0xHASH.{TARGET}.hlsl` pattern.
3. Put substantial reusable shader logic in game-local `common.hlsl`, `common.hlsli`, or an existing purpose-specific include.
4. Keep `shared.h` aligned between C++ `ShaderInjectData` layout and HLSL macros.
5. For a proven swapchain proxy path, move only the validated pieces into the game addon: resource clone/upgrade configuration, fullscreen output shader registration, `SwapChainPass` proxy pixel shader, final scRGB/PQ or engine-native encoding state, and any injected output preset cbuffer field.
6. Keep UI/HUD/video scaling and composition decisions explicit; do not bury them in a final inverse-tonemap postprocess.
7. If the mod exposes an SDR/HDR output toggle, synchronize the user setting with the swapchain target/color space and the shader preset cbuffer during runtime presentation rather than hardcoding one output mode at startup.
8. Ensure the non-DevKit path works after restarting the game with only the game addon enabled, unless DevKit is explicitly part of the current verification.

## Verification checklist

Produce a concise verification checklist in the response. Only add or update a mod-local verification document when a committed convention already exists for that mod or the user asks for one. Prefer an existing `README.md` or existing committed dev/verification note over inventing a new filename.

Use [verification checklist template](./templates/verification-checklist.md) when a durable mod-local checklist is requested.

Include:

- Build target: `{mod}`.
- Expected output artifact: `renodx-{mod}.addon64` or `.addon32`.
- Generated shader embeds to inspect, if any.
- Game binary folder and addon/link expectations.
- Runtime checks:
   - ReShade loads.
   - DevKit loads when needed.
   - Game addon loads and shows the expected RenoDX title.
   - Relevant settings respond.
   - Target shader replacement is active.
   - Resource upgrades/clones preserve HDR values when applicable.
   - RGBA8U/UNORM bottlenecks are either intentionally left SDR-only or upgraded before HDR-critical data is lost.
   - Any proxy/output shader encodes the proven float signal through `SwapChainPass` or an equivalent output path without inverse-tonemapping final SDR.
   - SDR/HDR output toggles update the swapchain color space and injected output preset cbuffer consistently.
   - Final output mode/color space follows the selected setting.

Keep verification notes short and actionable: include the exact debug preset/target, expected artifact names, game-folder links, and runtime log/UI checks. Do not turn committed verification docs into scratch logs. For long investigations where agent context, tool output, or session limits can lose important state, keep a temporary scratch log with hypotheses, failed attempts, commands, captures, shader hashes, and next steps; migrate only stable game-specific facts into committed mod docs, metadata, or repo memory.

## Useful references

- `docs/DEVKIT_MCP.md` - deeper DevKit/MCP workflow and tool details.
- `src/games/AGENTS.md` - game-folder conventions.
- `src/games/generic` - new-mod scaffold.
