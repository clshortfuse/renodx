# Deferred lighting decompile fixes

The updated shaders were reconstructed from the game's original DXIL. The raw
decompiles compiled successfully but did not preserve several native control-flow
edges. These repairs restore vanilla behavior; they are not new lighting effects.

## What was fixed

- **GI corner-loop continuation** (`F273B9DE`, `3EB5AAD9`, `4C3103FB`):
  the continuation flag was never set, so sampling stopped after one corner.
  Restored all 10 copied backedges, carrying RGB, weight, valid count and index
  through eight corners before normalization. A bare `continue` would target the
  wrong synthetic `do(false)` wrapper.
- **Material/output fall-through** (`3EB5AAD9`, `4C3103FB`, `B440B471`):
  completed material branches left only an inner wrapper, then executed unrelated
  shading or overwrote valid UAV output with undefined values. Restored native
  function returns and direct transfers to the combined-output join.
- **Completed shadow-path exits**: PCF/depth-gather branches continued through
  fallback shadow calculations, overwriting their completed result. Restored the
  correct outer-wrapper exits in 30 comparison-gather copies and 14 ordinary
  depth-gather copies across the affected variants.
- **Screen-space soft-shadow selection** (all 11 shaders, 66 copies):
  fourth-channel matches incorrectly ran the ordinary-light path first; unlisted
  lights fell through into `SoftShadowsMask`, defaulted to channel X and were
  shaded again. Restored first-valid X/Y/Z/W selection, unused-slot handling and
  the no-match exit that bypasses mask sampling and duplicate shading.

## Shared code and scope

- `deferred_soft_shadow.hlsli`: native packed light-ID/channel selection; returns
  `-1` when no active slot matches.
- `deferred_output.hlsli`: reused native diffuse-times-albedo plus specular,
  HDR scaling, clamps and UAV stores for the corrected output joins.

Bindings, buffer layouts, native game-update changes and lighting math were kept.
The decompile fixes themselves do not modify the decompiler or old shaders.

## IS-FAST port

The updated shaders now use the old shaders' IS-FAST rotation overrides: the same
112 unique sites/seeds (176 copies in expanded branches), periodic 128x128x32
noise indexing and angle formula. Only rotation angles change; kernel radii,
tap scheduling, gathers, bias and lighting accumulation remain native.

- `deferred_isfast.hlsli` contains the shared helpers. Change its `#if 1` to
  `#if 0` to compile every site's original `#else` angle statement and omit the
  noise SRV. The separate SSR switch below can still keep the injection cbuffer
  active in its shader; disable both features to select all original paths.
- With the custom branch compiled, the existing **IS-FAST Shadow Noise** setting
  selects On/Off. Off preserves the original deterministic angle calculation;
  Preset Off resets this setting too.
- `isfast_noise.hpp` registers the existing `t0,space50` noise-buffer callback for
  all 11 updated hashes while retaining old-version registrations. The existing
  88-byte `b0,space50` injection layout and 4 MiB noise buffer are unchanged.

## SSR port

`DeferredShading_0x6B725474.cs_6_6.hlsl` now carries the old `91447257` shader's
**SSR Pixelation Fix** modes; other permutations retain their native SSR sampling.

- **Off:** original linear color sample.
- **Sharp:** point-load color at the exact full/half-resolution pixel used by the
  packed reflection weight.
- **Filtered:** the old guarded 5x5 color-only filter, with spatial, depth, normal
  and weight-similarity rejection, a luminance cap and 85% filtered-color blend.
  The original center coverage and environment/SSR weight blend remain unchanged.

Change the `#if 1` at the top of that shader to `#if 0` to select its original
`#else` sample independently of IS-FAST. This disabled-SSR build exactly reproduces
the pre-SSR IS-FAST-enabled binary. No new resource bindings or settings are added;
the filter uses the updated game's renormalized center normal. Preset Off resets
the existing SSR setting to Off.

## Verification

All 11 replacements were freshly rebuilt with `007firstlight-shaders` and their
recompiled LLVM compared against the original `.ll`/`.cso`. Checked contracts,
loop/output witnesses and synthetic material/GI/multi-light executions pass;
undefined phi inputs are zero. The LLVM is **not textually identical**, and these
checks are not an exhaustive GPU-equivalence proof.

For runtime verification, compare each shader alone using DevKit Original/File,
especially GI-lit surfaces, split-output materials, completed shadow branches and
lights with each soft-shadow channel or no matching slot.

Build `007firstlight` with the game closed to update addon registrations; shader
embeds are under `build/007firstlight.include/embed`. Test IS-FAST Off/On and
SSR Off/Sharp/Filtered (full/half resolution, screen edges and foreground
silhouettes), plus Preset Off, after loading the rebuilt addon. DevKit shader
reload alone does not update the addon's noise-view registrations. Offline
build/branch checks do not prove in-game noise quality, SSR appearance or bindings.