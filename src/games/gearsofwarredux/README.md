# Gears of War Redux — RenoDX HDR

Experimental D3D11/x64 mod. Output defaults to FP16 scRGB; a global
`HDR Output (Restart Required)` setting also offers 10-bit PQ/BT.2020 HDR10.
Tone mapper choices are Vanilla, RenoDRT (default), PsychoV30, PrismTM and
Simple HDR. Color Grading includes
Exposure, Highlights, Shadows, Contrast, Saturation, Highlight Saturation,
Blowout, Flare and Scene Grading. Intermediate/Advanced settings expose these
controls. Defaults are neutral, with Scene Grading at 100%; Flare applies only
to RenoDRT, matching the user's CODGHOSTS mod.

## Changes

- Replace `0x4D17CEAB.ps_5_0.hlsl`, the captured DOF/color-grade/gamma pass.
  Bypass its two upper RGB clamps for HDR modes; keep the original shadow
  offsets, grade, overlay, bloom/DOF weights, gamma and output alpha.
- Decode the unclipped gamma result to linear light, apply the selected display
  mapper, and encode a gamma 2.2 intermediate for the original motion blur.
- Replace `0x29CCB91A.ps_5_0.hlsl`, the DLSS/FSR2 final motion-blur pass,
  bypassing its upper RGB clamp in HDR. With linear DLSS input enabled, encode
  each of its five color samples back to gamma 2.2 before the original blur,
  color scale and fade. Limit DLSS reconstruction overshoot to the selected
  peak by scaling RGB together. Preserve motion vectors, sample coordinates
  and output alpha; FSR2 continues using the gamma input path.
- Trial the user's aspect-ratio upgrade rules: native FP16 upgrades for
  render-target textures in RGBA8 UNORM/typeless/sRGB, BGRA8 UNORM, and
  RGB10A2/BGR10A2 UNORM, matching 16:9, 16:10, 24:10, 43:18 or 64:27 within
  `0.001`. This covers the captured grade RTV and both copy/SRV aliases.
  Aspect matching also includes smaller targets with those ratios; it is
  broader than the previous exact-dimension/exact-usage policy.
  Retain a separate native RGBA8-to-FP16 rule for the DLSS UAV/SRV output,
  restricted to output dimensions, one layer and captured usage `0x1cc8`.
  The scene rules alone would miss this texture because it has no RTV usage.
  Native upgrades let NGX receive the texture the engine actually wrote;
  ordinary resource clones left its original input black. UE3 allocates its
  scene buffers at output size and renders into a smaller rect when upscaling.
  A later DLSS upscaling capture confirmed the native FP16 chain and a visible
  image; the remaining 0-1 clamp was inside DLSS's SDR processing mode.
- Intercept the interface-3 `ReduxUpscalers64.dll!RxUp_DLSS_Create` export in
  `dlss.hpp` and add HDR flag `0x1`. For actual upscaling, also enable automatic
  exposure (`0x10`), following the shared RenoDX Streamline implementation used
  by Starfield. Preserve quality, dimensions, other flags and return values.
  Intercept `RxUp_DLSS_Evaluate` to supply a cached linear FP16 copy of the
  gamma composite; `dlss_decode_color.cs_5_0.hlsl` converts only the render
  rect. Alternate source textures reuse the same conversion output and UAV
  when their dimensions match; only the input SRV changes. Device or resolution
  changes recreate the output. Restore compute bindings after conversion. DLAA skips this conversion
  and keeps the previous HDR-only configuration. Hook exports for cached
  pointers and watch the engine's `GetProcAddress` import for late DLL loading.
  Unsupported wrapper interfaces are logged and left unchanged. No upscaler
  files on disk are modified, and no extra tonemapping pass is added.
- Keep the existing FP16 scene/bloom buffers and RG16 UNORM velocity buffer.
- Use a thin `SwapChainPass` proxy to decode the float composite and output
  linear scRGB or PQ HDR10, matching the actual swapchain format/color space.
  The output choice is loaded at startup and requires a restart; changing it
  in the overlay cannot relabel or re-encode the currently active output.
  Positive RGB skips the shared BT.2020 gamut-compression round trip; negative
  RGB and HDR10 use the full shared path. Both keep UI scaling and the peak bound.
  Game/UI draws target the FP16 swapchain clone directly, with compatibility
  mode disabled and only the necessary D3D11 RTV binding/clear hooks enabled. Present reads that
  clone without first copying the full native backbuffer. Offscreen engine/NGX
  resources continue using native upgrades, not clones.
  Its separate D3D11 command flush is disabled after each proxy's first use.
- Use a versioned 80-byte injection layout at D3D11 b13. An absent or older
  injection buffer leaves the original game shader path active. Layout version
  4 retains the DLSS linear-output flag and uses the last former padding float
  for the actual output preset. The buffer remains 80 bytes / 20 floats.

`common.hlsl` applies one shared exposure/highlights/shadows/contrast/saturation
grade before dispatching the requested mapper, following CODWW2's common-grading
pattern. Each mapper's internal grading is neutral; PsychoV30's advanced cone,
gamut and compression controls remain active. Highlight Saturation and Blowout
use the same post-map grade for all HDR modes. RenoDRT uses its Reinhard
curve per channel in AP1, retains Flare, skips hue restoration, and shares
a uniform RGB peak bound with PsychoV30 and Prism. The curves remain distinct;
matching controls and reference white do not make their entire responses equal.
PsychoV30 uses the shared repository implementation. `prismTM.hlsl` preserves
the MIT-licensed Prism inset/curve/outset sequence from the user's CODWW2 mod.
Simple HDR preserves the authored grade and RGB ratios, using one rational
max-channel shoulder above reference white instead of a perceptual mapper.
Its knee is reduced when display peak is too low to contain reference white.
Neutral grading skips the optional grading work; all grading sliders remain
available. The other mapper choices and their defaults are unchanged.

Vanilla retains the original SDR RGB clamps, while allowing Exposure,
Highlights, Shadows, Contrast and Saturation. Scene Grading blends the game's
authored shadow/highlight/midtone/desaturation adjustments in HDR; the fade
overlay and gamma/color scale remain fully active. Preset Off resets grading
controls and reference whites, with
the selected HDR output format remaining active. This is an appearance comparison, not a native SDR
swapchain toggle.

UI Brightness scales UI composited after the scene pass. HUD/UI already baked
into the captured scene cannot be independently scaled by this implementation.
Menu, HUD, loading screen and video coverage remain to be checked.

The post-scene HUD shader `0xDF37C319.ps_4_0.hlsl` restores the original
UNORM RGB bound before writing to the floating-point HDR target. Its Gamma=1
path previously returned the unbounded texture/color product. UI values above
white could therefore be amplified by the output proxy's gamma decode. The
replacement caps RGB at 0..1, leaves alpha unchanged, and lets the existing
proxy apply UI Brightness. It does not cap the scene at UI white.

On 2026-11-02, DevKit confirmed this shader drawing after the scene motion-blur
pass directly into the FP16 swapchain clone. The replacement compiled and was
live-loaded. A focused D3D11 WARP render check passed 36 cases / 73,728 component
checks across gamma, component replication and color/alpha inputs. Original UI
output reached 15.2917; corrected RGB stayed within 0..1. Normal-range RGB and
alpha were preserved exactly. This main-HUD clamp alone did not resolve the
reported flash; the reload material below uses a separate shader.

The reload-bar flare uses `0xECF8AA5E.ps_4_0.hlsl`. A subsequent capture found
it alpha-blending directly into the FP16 swapchain clone after scene mapping
and between the main HUD draws. The pre-proxy composite contained a peak RGB
value of 8.3984375 in the upper-right HUD area. At the saved 203-nit UI white,
gamma-2.2 decoding would represent about 21,915 nits before any final output
peak limit. Its material color and fog calculation had no output bound.

The replacement saturates this material's final RGBA, containing both color
and blend-factor overshoot while preserving normal-range material values.
It compiled and was activated through DevKit. Subsequent HUD-region readbacks
were below 1 (maximum 0.9350586), with scene highlights elsewhere above 1;
these live captures are not frozen-frame comparisons. The user reproduced
the reload flash after activation and confirmed it was fixed.

Rebuild target `gearsofwarredux` after closing the game to embed both added UI
replacements, bringing the registration count to six. Inspect generated
`build/gearsofwarredux.include/embed/0xDF37C319.h` and `0xECF8AA5E.h`. After
restarting, check reload flashes, HUD, damage, notifications, menus, fades and
transparent UI, including unequal Game/UI brightness and both output modes.

## DevKit findings — 2026-10-04

Observed binary:
`C:\Games\Gears Of War Redux\Gamefiles\Binaries\Win64\Gears Of War Redux.exe`.

The connection was `renodx-devkit-mcp-31796`, device 0, D3D11. One snapshot
contained 957 records and 231 tracked shaders; all 179 tracked pixel shaders
were inspected. This proves the captured scene path, not every possible
post-processing permutation.

| Pass | Shader | Captured resources | Action |
| --- | --- | --- | --- |
| Bloom/DOF prefilter, draw 948 | `0x82B00F11` | FP16 scene to 962×542 FP16 | Retain |
| DOF/color grade/gamma, draw 954 | `0x4D17CEAB` | FP16 scene + blur to 3840×2160 RGBA8 | Replace shader and upgrade color |
| Color copy, record 955 | No shader | RGBA8 RTV to RGBA8 sampling alias | Preserve FP16 through both resources |
| Motion blur, draw 956 | `0x51477221` | Color + RG16 velocity + FP16 scene/depth | Retain original shader |
| Final RenoDX proxy | Local proxy shader | FP16 gamma composite to linear scRGB | Shared output conversion |

Original scene resource `0x00000000595A7860`, SRV
`0x00000000520C2B28`, was FP16. Live readback measured RGB maxima of
7.5625, 6.078125 and 3.355469; 9,038 pixels had an RGB channel above 1.
Every pixel was finite. Scene alpha contains depth and must not be treated as
RGB HDR evidence.

The color-grade RTV was resource `0x00000000595ABD20`, view
`0x000000004CD9B720`. Its copied alias was resource
`0x00000000595A67E0`, SRV `0x00000000520C5DE8`. Both were RGBA8 and the
alias readback was limited to RGB ≤1. Handles are session-specific identifiers,
not persistent resource-selection rules.

Original bytecode was dumped through MCP to the game's `renodx-dev/dump`
folder. The decompiled originals of the grade and motion-blur shaders compiled
and both were activated as live baselines, then unloaded. Baseline readbacks
were finite and remained SDR-clamped. Readbacks sampled a changing live scene;
no frozen-frame or exact pixel-equivalence result is claimed.

The previously loaded generic addon had already created an HDR10 target with
an FP16 proxy; that did not remove the upstream color-grade clamps.

## DLSS black-screen capture — 2026-10-04

Connection `renodx-devkit-mcp-60040` captured 2,308 records and 309 shaders.
The game log confirmed DLSS enabled in DLAA/native-resolution mode at
3840×2160. This captures the temporal DLSS path; lower-resolution Quality,
Balanced and Performance modes still need testing after rebuilding.

| Record | Operation | Finding |
| --- | --- | --- |
| 2304 | `0x4D17CEAB` to resource `0x5909E0A0` | Original RGBA8 was entirely black; FP16 clone `0x4C4BABE0` had a finite scene, RGB peaks 1.1025/1.0303/0.9624 |
| 2305 | Copy grade color to engine alias `0x59099920` | Both were managed by the addon's clone rule |
| 2306 | Copy upscaler output `0x4C7B6460` to `0x5909EBA0` | Downstream original and FP16 clone both read entirely black |
| 2307 | `0x29CCB91A` final upscaled motion blur | Reads RG16F motion + upscaled color, then clips RGB to 0–1; final target was black |

The installed `Engine/Shaders/UpscaledMotionBlur.usf` identifies this as the
final DLSS/FSR2 pass. The capture proves valid color exists in the clone and
the native original is empty. The inferred NGX handoff failure is addressed by
native FP16 upgrades rather than shader-bound clones. Including UAV usage keeps
the upscaler's output and engine copy destinations at the same format.

The original `0x29CCB91A` bytecode was dumped and its unchanged decompilation
compiled and activated as a live baseline. It remained finite and black, as
expected from its black input. This does not establish pixel equivalence on a
visible scene. The baseline was unloaded and the default live directory restored.
DevKit cannot toggle the game addon's resource clones, so native upgrades require
an addon rebuild and restart. No game shader files or upscaler DLLs were edited.

## Motion blur disabled — 2026-10-24

DevKit capture (`renodx-devkit-mcp-31328`) with DLSS upscaling and motion
blur off: the engine replaces the final upscaled blur `0x29CCB91A` with a
plain final copy, `0x71B33647` (post-upscaler FP16 alias → swapchain proxy).
It applies ColorScale, the fade overlay, `saturate()` and `InverseGamma`.
Because DLSS upscaling now receives linear light, that shader read linear
color as gamma (crushed shadows), and its clamp limited output to UI white.

`0x71B33647.ps_5_0.hlsl` replaces it. With the DLSS linear flag set it
encodes the sample back to gamma 2.2, as `0x29CCB91A` does per tap; HDR
modes use `max(0, …)` instead of `saturate()` and keep the same peak bound
for DLSS overshoot. Fade, color scale and `InverseGamma` are unchanged.
Vanilla, DLAA, FSR2/native and an unbound injection buffer keep their
original input domain and clamp behavior.

## FSR1 HDR — 2026-10-24

DevKit capture (`renodx-devkit-mcp-21088`) with FSR1 selected: no DLSS
create, and `0x29CCB91A` is not used. The chain is grade `0x4D17CEAB` → copy →
original motion blur `0x51477221` → filter `0x42E6922B` → copy → EASU
`0x7194ED7A` → RCAS `0xD844C4C3` into the swapchain proxy, all on native
FP16 output-sized textures. EASU has no clamp and its output held values
up to 2.5. RCAS ended in `saturate()` and its ring limiter assumed a 0–1
range, so FSR1 clipped the scene at UI white.

`0xD844C4C3.ps_5_0.hlsl` replaces RCAS. In HDR modes the limiter uses
`range = max(1, pow(peak/ui_white, 1/2.2))` in place of 1 (equivalent to
RCAS on color/range, scaled back), and the final clamp becomes `max(0, …)`.
Color scale and fade overlay are kept; Vanilla and an unbound injection buffer
keep the original shader. Compiled with the user's FXC through DevKit live
loading (live copies unloaded afterwards); in-game HDR output needs the rebuilt addon.

## DLSS black-screen regression — 2026-10-24

After a game update, ReShade logged `flags 0x8 -> 0x19, 2559x1439 -> 3839x2159`:
the DLSS output size is now one pixel short of the 3840×2160 backbuffer.
DevKit capture (`renodx-devkit-mcp-27276`): the grade target was populated,
the DLSS input received FP16 linear color, but the post-DLSS FP16 sampling
alias read entirely zero after the engine copy, so the final upscaled blur
was black under the UI. The "DLSS Output" rule matched exact backbuffer
dimensions, so the 3839×2159 private NGX output stayed RGBA8 and the
RGBA8-to-FP16 copy was dropped by D3D11. The rule now matches the backbuffer
aspect ratio (tolerance 0.01) with the same exact usage `0x1cc8`, following
the `aspect_ratio = BACK_BUFFER` pattern used by other RenoDX mods. The NGX
output format itself was inferred, not read back. After rebuilding, the
post-DLSS alias should be nonzero and the scene visible in all DLSS modes.

## DLSS SDR-peak clipping capture — 2026-10-04

Connection `renodx-devkit-mcp-1332` captured 3,116 records and 357 shaders with
the new addon loaded (two replacements, 20 injection floats). The game log
reported actual DLSS upscaling, 1920×1080 to 3840×2160. Native FP16 upgrades
were active and the black-screen texture handoff was resolved.

The color-grade output at draw 3112 had RGB maxima 3.2793/2.9121/3.6465 and
13,054 pixels above 1.0. The post-DLSS sampling resource used by draw 3115 was
also FP16 but had RGB maxima exactly 1/1/1, with no pixel above 1.0. The final
motion-blur target had the same ceiling. With game white 203 nits, this encoded
ceiling produces 203 nits through the gamma 2.2/scRGB proxy, despite the 3500-nit
peak setting. All readings were finite live samples, not a frozen comparison.

Read-only inspection of the installed upscaler's saved DLSS create flags found
`0x8`: low-resolution motion vectors, with HDR bit `0x1` absent. The wrapper
creates NGX in SDR mode while its FP16 feed exceeds 1.0. Texture precision does
not enable DLSS HDR processing. `RxUp_DLSS_Create` also requests an RGBA8 private
output texture, but read-only native inspection confirmed the existing resource
upgrade already made that actual texture `DXGI_FORMAT_R16G16B16A16_FLOAT`
(format 10), 3840×2160. Its live pointer matched the source of copy record 3114.
No additional texture-creation hook is required.

The first game-local source fix added the HDR bit to every DLSS create request:
the observed flags `0x8` became `0x9`. The wrapper compares flags when deciding
whether to reuse a feature and recreates it when they change. See NVIDIA's DLSS programming
guide, section 3.1.2, for the SDR 0–1 range restriction and HDR processing flag.

## DLSS color and peak matching — 2026-10-04

The next restart, connection `renodx-devkit-mcp-24468`, confirmed the HDR hook
was active for 1920×1080 to 3840×2160. Draw 2715 still wrote the gamma 2.2
composite. Its largest RGB channel was 3.6465; the post-DLSS sampling alias
reached 3.7578. HDR range survived, but reconstruction could overshoot the
selected display peak. The user reported matching DLAA/native colors, with
different color and peak brightness only during upscaling.

The current correction supplies linear light at the NGX boundary and restores
the gamma representation in the existing final pass. The tone mapper and
authored grade are unchanged. Upscaling flags `0x8` now become `0x19`
(HDR plus AutoExposure); DLAA retains `0x9` and its original gamma feed.
The final peak bound uses `pow(peak/ui_white, 1/2.2)` in gamma space and a
single RGB scale, preserving channel ratios rather than clipping them separately.

Reference patterns inspected: Starfield's `utils/dlss/streamline_v2.hpp`
HDR/automatic-exposure configuration, its thin `SwapChainPass` proxy, and the
Gears of War 4/Unreal Engine linear BT.709 tonemap pipeline. The Redux boundary
conversion keeps its existing gamma post-processing intact.

Offscreen D3D11 WARP validation executed the production decoder and final
pixel shader. Dark, neutral, saturated and HDR samples round-tripped with
maximum encoded error 0.002375, consistent with FP16 rounding. Peak limiting,
nonzero render-rect origin, texture reuse and compute-state restoration passed;
the debug layer reported no errors. This tests our conversion, not NVIDIA's
reconstruction or an in-game visual match. The user builds and deploys the
addon; visual comparison between upscaling and DLAA/native remains pending.

## RenoDRT grading and performance audit — 2026-10-04

Reconnected to `renodx-devkit-mcp-56836`. The installed addon timestamp was
19:43:43 local; ReShade confirmed upscaling flags `0x8 -> 0x19` and successful
linear color conversion. Both target shaders were supplied by the addon, with
no disk/live overrides. The snapshot contained 2,022 records, 261 shaders and
1,385 live pipelines. The grade and upscaled-color sampling alias were native
FP16 resources. Snapshot capture was idle after this single capture.

The source previously gave RenoDRT internal grading, PsychoV30 physiological
grading/purity controls and Prism the shared RGB grade. RenoDRT also used
independent channel peak clamps. The common grade and uniform peak bound above
remove these inconsistent controls without replacing the mapper curves.
Offscreen WARP tests checked all three mappers: linear 0.18 gray mapped to
0.18 within 0.001; exposure 2 matched doubled input at exposure 1; black, dim,
neutral, saturated and bright inputs stayed finite and within the selected
RGB peak, including nonneutral grading controls. Flare is intentionally
RenoDRT-specific. This does not prove DLSS/DLAA visual equivalence.

Concrete avoidable costs and changes:

- FXC flattened the final shader's five conditional gamma encodes into
  unconditional log/exp calculations plus selects. They ran even in DLAA.
  Explicit uniform branches now put these operations, and the DLSS peak
  calculation, inside the linear-DLSS path. Disassembly confirms this.
- Correct the final peak bound to use UI white: the intermediate has already
  been scaled by Game/UI brightness. The previous Game-white denominator
  caused DLSS-only peak errors when those two settings differed.
- Shared grading bypasses neutral controls. RenoDRT no longer makes redundant
  OkLab hue round trips in the original luminance configuration.
  Making its mapper type constant also removes the unreachable ACES branch.
  That grading cleanup dropped the combined shader from 1,784 to 861 FXC instruction slots and
  14 to 11 temporary registers. These are static compiler counts, not executed
  instructions or an FPS measurement; the old mapper selection already branched.
- Cache the immutable input texture description and update the render-rect
  constant buffer only when the rect changes. Stop per-present module lookup
  and hook-install locking after the first installation attempt. These are
  small CPU-side savings, not an explanation of a large FPS loss.

Remaining potential costs:

- The earlier preset enabled `lilium__hdr_and_sdr_analysis`, with waveform,
  CIE diagram, gamut statistics and nits display. The installed effect includes
  multiple graphics/compute passes and atomic counters. Disable this technique
  in ReShade for a matched-scene FPS comparison. Compiling an effect alone is
  not proof it runs; the enabled preset is the evidence here, and runtime
  technique timing still needs checking in ReShade Statistics. The later
  20:41 audit found `Techniques=` empty; this effect was already disabled then.
- FP16 color buffers, their existing full-size copies, and the scRGB proxy
  increase bandwidth in every mode. One 3840×2160 FP16 RGBA image is about
  63.3 MiB, twice RGBA8. The captured native scene/bloom buffers were already
  FP16 and were retained. Do not undo required color upgrades to save bandwidth.
- Actual upscaling adds the render-rect linear conversion and five gamma
  encodes in the final 4K blur, plus NGX HDR/automatic exposure. The decoder
  bypasses DLAA, so it cannot explain a slowdown also seen with DLSS Off.
- DevKit/visible overlays and readbacks can add diagnostic overhead. Captures
  and readbacks were isolated, not continuous; no evidence of per-frame
  snapshot capture or duplicate tonemap draws was found in this snapshot.

DevKit provides binding/resource evidence, not GPU pass timings. No matched
with/without-mod FPS baseline was provided, so the dominant cause and actual
FPS improvement remain unmeasured. Benchmark the same stationary scene with
Lilium disabled, overlays closed and DevKit unloaded, then compare with the
original game. Switching to DLAA requires a restart, as reported by the user.
The decoder/blur round-trip and state-restoration WARP test still passes with
maximum encoded error 0.002375. FXC compilation and x64 addon syntax checks
pass; the user handles the addon build and deployment.

## Saturated highlight correction — 2026-10-04

The user clarified that highlight colors, rather than just grading controls,
were substantially different in RenoDRT. The shared-control cleanup did not
address this: scalar luminance mapping plus uniform peak limiting preserves
input RGB ratios, even for extremely bright colored lights. Prism and PsychoV30
reduce highlight saturation through their component/observer responses.

RenoDRT now uses the existing `ToneMapPass` Reinhard curve per channel in AP1,
with an AP1 working-space peak bound before conversion to BT.709. The common
RGB peak limiter still contains conversion overshoot. This keeps genuine
RenoDRT mapping and lets bright colored lights approach white. It does not
substitute Prism's matrices or curve, and does not add a render pass or global
desaturation. PsychoV30, Prism, the authored grade and the DLSS boundary are
unchanged. AP1 working-space references were checked in Gears of War 4 and the
Unreal Engine template; those references do not imply identical curve settings.

An offscreen production-helper sweep tested red, orange, green, blue, cyan,
magenta and neutral inputs at 0.18, 1, 4, 20, 100 and 1000 intensities, with
400-, 1000- and 3500-nit peaks. Across the selected saturated highlight samples,
mean absolute distance of max-normalized RGB from the two reference mappers
dropped from 0.3559/0.2863/0.1993 to 0.0371/0.0382/0.0391, respectively. This is
a synthetic RGB comparison, not a perceptual color-error score or an in-game
match. The curves retain their own highlight luminance responses. Gray anchor,
shared exposure, finite output, peak bounds, nonneutral grading and unequal
Game/UI-white tests also passed. FXC compiled the current grade shader to 878
instruction slots, 11 temporary registers; no GPU-time claim follows from that
static count. Existing shared compiler warnings remain.

DevKit `renodx-devkit-mcp-42928` confirmed the prior source changes were rebuilt:
the Release and installed addon files matched and were timestamped 20:05:17
local. A single snapshot contained 1,789 records; the native grade target was
FP16. This new highlight correction is source-only until the user rebuilds.
No live override or addon deployment was performed. Check colored emissives,
bright fire and metallic highlights across all three mappers at neutral grading
and matching brightness; compare both DLSS upscaling and DLAA/native, restarting
when switching modes requires it. Unbound/old injection and Vanilla fallback
behavior remain unchanged.

## Resource and per-frame overhead audit — 2026-10-04

DevKit connection `renodx-devkit-mcp-66772` captured the chugging session. The
startup log contained exactly four native upgrade allocations, all 3840×2160:

| Original usage | Count | Required role |
| --- | ---: | --- |
| `0x1c04` | 1 | Grade output RTV |
| `0x1cc4` | 2 | Grade-to-NGX copy/SRV and post-NGX copy/SRV |
| `0x1cc8` | 1 | Private NGX output UAV/SRV |

The snapshot contained 3,768 records, with one grade draw and one final blur.
It showed the same grade target and aliases seen in the prior 4,403-record
snapshot. No additional upgrades appeared during the observed session. The
native scene, bloom and velocity formats remained unchanged. The then-current exact usage
filters preserved all four observed allocations; that tightening did not save
their bandwidth and is not itself evidence of an FPS improvement.

The addon previously requested the framework's general non-DX12 clone hooks,
which perform resource lookups on RTV/SRV bindings and every draw. These are
unnecessary for native color upgrades with the scRGB compatibility proxy:
the proxy copies the back buffer explicitly at present, rather than redirecting
game draws into a clone. `use_resource_cloning_dx12_only` now suppresses these
D3D11 hooks while leaving explicit proxy cloning and create-time format/view
upgrades available. Keep compatibility mode enabled; a mode that redirects
game rendering into a clone would need the binding hooks again.

A game-local present callback disables `auto_device_flush` and the cached
pass's `flush_after_render`. The framework creates each proxy lazily, so each
new proxy may flush on its first use. Subsequent frames rely on D3D11 Present
to submit the same commands. No additional render or compute pass is added.

The shared scRGB preset also encoded/decoded an intermediate gamma and
converted BT.709 to BT.2020 and back to compress negative components. For
nonnegative RGB those operations are mathematically redundant. The proxy now
branches around them while retaining the full previous path for negative RGB.
An offscreen D3D11 debug-layer comparison used the actual old/new pixel shaders
and production proxy vertex shader, 1,024 FP16 input colors (including black,
colored highlights and negative-component colors with positive luminance),
three peak settings and three UI whites. All 27,648 RGB comparisons passed:
maximum relative/absolute error `3.64706e-6`, negative-path error zero, finite
output and peak bounds. It rendered without an explicit Flush. FXC compilation
and x64 addon syntax checks passed; existing shared warnings remain.

The live game process's private memory grew from about 30 to 41 GiB while
Windows had very little available memory. Disabling/clearing DevKit's texture
replacement observations did not stop this growth, so that cache alone was
not identified as the cause. The user then restarted without DevKit and
reported stable memory but continuing FPS loss. This separates the diagnostic
memory problem from the remaining addon performance cost; it does not identify
the leaking allocation. Lilium was disabled in the latest preset. Test the new
source with DevKit absent, the same scene, fixed resolution/DLSS mode and
matching mapper settings. Actual FPS improvement is still unmeasured.

These changes are source-only. The user builds/deploys the addon. Confirm native
and DLAA still render in HDR, then restart into DLSS upscaling and verify its
color, peak, motion blur and fades. If a supported path allocates color with a
new usage combination, capture and add that descriptor instead of widening
the rule globally. A black picture or clipped copy suggests a missing required
allocation and should be investigated before judging performance.

## UE3 presentation and HDR10 follow-up — 2026-10-04

The earlier clone-hook suppression did not resolve the reported FPS drops.
Its compatibility proxy still copied a complete FP16 frame at every Present.
The current configuration supersedes that attempt: like the D3D11 Batman
Arkham Knight and Bulletstorm Full Clip addons, it disables
`swapchain_proxy_compatibility_mode` and explicitly registers only RTV binding
and RTV clearing for the game to draw into the proxy. The captured swapchain
uses `DXGI_USAGE_RENDER_TARGET_OUTPUT` only (`0x20`), so its original backbuffer
has no game SRV/UAV bindings to remap. The proxy pass binds its clone explicitly.
Native offscreen HDR textures already have the correct views; their SRV/UAV
bindings no longer run resource-clone lookups.
`use_resource_cloning_dx12_only` still suppresses the shared non-DX12 per-draw
render-pass handler, command-list clone tracking, barrier hooks and unrelated
UAV clear/descriptor-table machinery. Native D3D11 uses render-target binding,
so it does not need the deferred render-pass checks at each engine draw.
The scoped RTV clear callback clears the clone and skips the redundant original
clear when a clone exists. Offscreen clears remain native.
This removes one full-frame
FP16 copy, approximately 126.6 MiB of read/write traffic at 3840×2160. It does
not remove the required native color upgrades or DLSS's input conversion.
Batman also uses HDR10. UE3 DX9/device-proxy addons such as Spec Ops and
Borderlands 2 solve a different API constraint and are not copied wholesale.

Added Simple HDR as a fifth mapper, retaining the existing saved mapper
indices. It provides a low-cost way to test HDR with the original grade and
color ratios. Added optional HDR10 presentation: RGBA10 output plus matching
BT.2020/PQ encoding and DXGI HDR10 color space. scRGB remains the default.
The FP16 proxy and engine color chain remain necessary in either mode.
The output setting is global and applied only at startup. Its injected preset
follows the actual backbuffer on swapchain initialization and resize.

Microsoft documents 10-bit HDR10 as an output optimization: 32 bits per pixel
versus scRGB's 64. It can reduce presentation bandwidth and format-conversion
work; it does not halve the cost of all FP16 rendering or guarantee an FPS gain.
See [Microsoft HDR guidance](https://learn.microsoft.com/en-us/windows/win32/direct3darticles/high-dynamic-range).

Synthetic GPU timestamp checks ran the actual before/after production grade
shaders at 3840×2160 on this machine's RTX 4080 Super, with neutral grading,
3500-nit peak, 203-nit whites, and varied colors spanning about 0.016–38968
in the FP16 scene input. Three timed draws per mode gave these median costs:

| Mapper | Before | After |
|---|---:|---:|
| Vanilla | 0.0768 ms | 0.0778 ms |
| Simple HDR | — | 0.0891 ms |
| RenoDRT | 0.1034 ms | 0.1034 ms |
| PsychoV30 | 0.1648 ms | 0.1649 ms |
| PrismTM | 0.1106 ms | 0.1105 ms |

The before shader was extracted from the user's generated embed. Existing
mapper outputs matched exactly in the sampled FP16 output row. Simple HDR
matched its expected shoulder/color ratios, retained output above 1 and stayed
within the selected peak. These synthetic measurements isolate the grade
shader with small cached source textures. They do not include real-game
texture traffic, engine passes, NGX, presentation or CPU work, and do not
explain the reported ~95 versus ~45 FPS minima by themselves. The user confirmed
that ~95 FPS was the addon-free game; it was not the addon's Vanilla setting.
Thus the reported difference includes resource upgrades and presentation as
well as shader changes. The latest launch log has no RenoDX addon loaded.

Output tests compared the production proxy with full shared `SwapChainPass`
for both formats, including black, HDR/negative-channel colors, peaks 48/400/
1000/3500 and UI whites 48/203/500. All 73,728 RGB comparisons passed, maximum
relative/absolute error `3.64706e-6`, with finite output and scRGB peak bounds.
Actual RGB10A2 rendering matched reference PQ values to half a 10-bit code step
for 36,864 channels, with no D3D11 debug errors. Production shader compilation
used the repository's optimization/compatibility flags. Shared ACES/Shadows
warnings remain, including propagation of the Shadows warning into the game
helper. Addon C++ syntax-only validation passed with 28 existing shared warnings.

The user still builds and deploys the addon; no addon binary or game file was
modified here. Test the rebuilt mod with DevKit absent and unchanged scene,
resolution, DLSS mode, frame cap and grading. First compare the selected mapper
in scRGB with the prior build, then the addon's Vanilla and Simple HDR choices.
Change output to HDR10, restart,
and repeat the same comparison. Check HUD/menu compositing, fades, native/DLAA
and DLSS upscaling HDR/color/peak behavior. An in-game FPS fix is unconfirmed.

## Executable and launcher performance audit

Static inspection of the installed x64 game executable and the supplied
launcher (NSIS wrapper containing a 64-bit Electron app, version 2.0.72)
confirmed the real D3D11 launch path. The launcher adds `-d3d11` for DX11 and
does not add `-ONETHREAD`, `-d3ddebug`, affinity changes or process-priority
changes. The captured game device uses flags `0x1`, without the debug flag.
MSAA is 1x, and the native upgrade log shows allocations at startup/rebuild,
not a continuing per-frame allocation storm.

At the time of the static audit, `AllowCompositeDynamicUnCull=True` was active
in the game's engine config.
The launcher calls it **Light Movable Objects** and documents extra lighting
work and a restart requirement. Turning it off is the first game-side
performance comparison to make; it changes lighting on movable objects.

`AllowOcclusionQueries=False` was the shipped and then-current setting.
Enabling it may reduce hidden-object draws and the addon's per-draw work, but
the executable has a blocking query-result polling path. Redux's default
config says this cost performance on its GPU-bound handheld test. It is an
A/B test on this PC, not a guaranteed fix. The executable recognizes
`TOGGLEOCCLUSION` and flips the same occlusion-disable flag loaded from the
engine config, subject to the game's console-command access checks. If the
console accepts it, toggle in the same scene and toggle again to revert.
For a persistent comparison, use `AllowOcclusionQueries=True` in
`[Engine.IHVHacks]` and restart. Compare minimum FPS/stutters, not just average
FPS; keep resolution, DLSS mode, lights and addon build fixed for each pair.

The DLSS decoder now preserves its FP16 output texture/UAV when its source
changes but dimensions match. The earlier implementation unnecessarily
reallocated and cleared that output on every source change. This fix only
affects DLSS upscaling, not native/DLAA. The production helper passed a WARP
test with 100 alternating inputs, resize/recreation, color/peak checks and
compute-state restoration. Full addon syntax validation passed with the same
28 existing shared warnings. No executable was modified or launched for this
audit. The individual addon changes' in-game performance impact remains unmeasured.

The user subsequently reported that `AllowOcclusionQueries=True` improved FPS
substantially. A follow-up read confirmed it is saved in `WarEngine.ini`, with
`AllowCompositeDynamicUnCull=False`. The latest ReShade launch also contains
the `RTV-only D3D11 hooks` startup marker, confirming the newer addon is loaded.
Keep occlusion enabled for this machine. This result supports excess visible
draw work as a contributor to the slowdown, but does not isolate CPU versus
GPU cost or the benefit of each addon change. No numerical FPS/frametime result
was supplied. `DefaultEngine.ini` still has occlusion disabled; if the game
regenerates the config after an update, recheck the effective setting.

## Build and verification

The current source trials the user's format/aspect-ratio scene upgrade list,
superseding the three exact-usage rules documented in the earlier captures.
It registers 30 scene RT rules and one separate, captured DLSS UAV rule.
These are matching rules, not a fixed allocation count; the actual number of
upgraded resources depends on the game. The broad scene rules do not cover
unlisted aspect ratios, such as 32:9. The native output-sized DLSS UAV rule
still follows the actual backbuffer at any aspect ratio.

The DLSS HDR flags, linear input conversion, final gamma/peak handling and
output texture reuse remain active. No shaders or grading defaults changed
for this trial. A scratch check using the actual registration block and
production resource matcher passed 127 cases: all six formats/five ratios,
smaller scene RTs, the captured grade/copy/NGX chain, and rejected non-RT
inputs. Existing production DLSS color/peak/state/resize checks passed again.
The full addon passed syntax-only validation with 28 existing shared warnings.
This validates source/matching and the existing conversion, not the broader
upgrade list's actual in-game color or performance behavior. No addon was built
or deployed by the assistant; the previous rule block is saved in the task's
scratch folder as `gears-specific-upgrades.addon.cpp` for comparison/reversion.

The user handles the addon build. With the game closed, build target
`gearsofwarredux` using the existing `clang-x64-release` preset for performance checks:

```powershell
cmake --build --preset clang-x64-release --target gearsofwarredux
```

Expected Release output: `build/Release/renodx-gearsofwarredux.addon64`.
The game-folder addon is a regular file, not a link to the build output.
Expected shader embeds include `embed/0x4D17CEAB.h`, `embed/0x29CCB91A.h`,
`embed/dlss_decode_color.h` and the proxy shader headers
under `build/gearsofwarredux.include`. CMake must discover the new hash shader;
reconfigure with the existing x64 preset if your build interface needs it.

Deploy the rebuilt addon into the binary folder and restart. Do not load the
final HDR live shader against the earlier generic addon; its injection layout
has changed. The guard deliberately uses the vanilla path for that old buffer.

On the 17:40 restart, DevKit connection `renodx-devkit-mcp-79756` still loaded
the 16:41 game-folder copy. ReShade logged one custom shader and 12 injection
floats, and DevKit reported `0x29CCB91A` as Original. The new Release addon was
built at 17:39, but had a different file hash from the installed addon. This
black-screen report therefore did not test the new native-upgrade fix. After
deployment, the log should report two custom shaders and 20 injection floats.

Verify:

1. ReShade loads “RenoDX - Gears of War Redux”, the five tone mapper choices,
   and the restart-required HDR output choice.
   The log includes `Gears Redux HDR: layout 4, direct proxy, RTV-only D3D11 hooks`
   followed by `aspect-ratio upgrades` and the output chosen for that launch.
2. DevKit shows `0x4D17CEAB` and, with DLSS enabled, `0x29CCB91A` replaced by the addon; live overrides are unloaded
   when checking the embedded replacement.
3. The actual color-grade RTV, copy/SRV aliases and upscaler output use FP16;
   DevKit reports native upgrades rather than cloned color resources. Readbacks retain
   values above 1 when the scene contains highlights. Confirm no copy returns
   to an RGBA8 destination.
4. The output target is FP16 with extended linear/scRGB color space by default,
   or RGB10A2/PQ/BT.2020 when HDR10 was selected before restarting. The proxy
   remains FP16 and the game draws into it directly.
5. Peak and Game Brightness work in all HDR modes. Check motion blur,
   DOF, bloom, bright emissives, fades, saturated colors, menus, HUD and video.
6. Compare Vanilla and Preset Off against the original appearance at matching
   reference white. Capture additional hashes if disabling DOF/motion blur or
   changing post-processing settings uses a different shader.
7. Enable DLSS and check a visible scene in DLAA, Quality, Balanced and
   Performance modes. Confirm the input and output are populated, copies use
   matching FP16 formats, and the final upscaled blur preserves highlights.
   ReShade.log should contain `Gears Redux DLSS HDR: create hook installed`
   and a successful `flags 0x8 -> 0x19` message for upscaling, followed by
   `linear color input active; final blur restores gamma 2.2`.
   Post-DLSS reads are now linear, so their maxima cannot be compared directly
   with the gamma composite. The final gamma target must remain above 1.0
   for bright HDR scenes and at or below `pow(peak/ui_white, 1/2.2)`.
   Compare stationary scenes against DLAA/native at matching settings, then
   check motion blur and fades. Restart after mode changes requiring it;
   the user reports switching to DLAA requires a restart.
8. In Intermediate settings, adjust each grading slider in all HDR modes.
   Flare should be enabled only for RenoDRT. At neutral defaults and 100% Scene
   Grading, the authored grade is retained; at 0%, its adjustments are bypassed.
9. For the aspect-ratio trial, keep occlusion queries enabled and hold scene,
   resolution, DLSS mode, output and mapper fixed against the previous build.
   Check minimum FPS/stutters and memory, then HUD/menus, videos, bloom, DOF
   and fades for changed colors or missing output. Recheck DLSS upscaling for
   a visible HDR image with matching highlights/peak against native/DLAA.
   The four earlier native upgrades are a baseline, not an expected count for
   this broader policy. Runtime resource counts and performance need the
   user's new build; DevKit is not needed for the first visual/FPS comparison.

Validation completed here: original live baselines; final tone shader, DLSS
final shader and proxy pixel/vertex shader compilation with FXC. Compiler
warnings originate in shared ACES (loop-variable shadowing) and shared grading
(potentially uninitialized `Shadows` local around its early-return branch).
Shared library files were not changed. The addon was
not built or redeployed here at the user's request, and final HDR runtime
validation remains pending. The updated full addon source passed an x64
Clang C++20 syntax-only check (no addon object, DLL, build or deployment). Its 28
warnings originate in existing shared infrastructure; none came from `dlss.hpp`.
The subsequent standalone WARP check compiled a scratch test executable only;
the user's addon build outputs and installed addon were not replaced.

## UE3 swapchain isolation review — 2026-10-05

The user reports that disabling individual offscreen upgrades and shader
replacements did not remove the slowdown. Preserve the current diagnostic
source: both shader entries and the offscreen upgrade blocks are commented
out. The shader module now attaches only when at least one replacement is
registered, so an empty list also removes its pipeline-bind tracking and
injection-layout hooks. The output proxy still binds its own constants.
The startup message reports actual shader/rule counts instead of claiming
that aspect-ratio upgrades are active.

Nine other UE3 addons examined use swapchain v2: Batman AA/AK, Bulletstorm
Full Clip, Borderlands 2/GOTY Enhanced, Alice, Dishonored, Remember Me and
Spec Ops. Batman AK and Bulletstorm share the direct-proxy configuration;
the older cross-device examples have a different output route. Mass Effect
LE's addon does not register the swapchain module. The source comparison
does not prove that v2 is incompatible with UE3.

The latest launch log confirms RGBA8 DISCARD -> RGBA16F FLIP_DISCARD,
ALLOW_MODE_SWITCH -> ALLOW_TEARING, with three buffers and an initially
windowed swapchain. Presentation/frame pacing and the final FP16 proxy
remain suspects. Empty offscreen rules still retain shared resource
tracking and copy/resolve callbacks. The current path already avoids the
compatibility frame copy, repeated proxy Flush and the cross-device route.
Switching to v1 would retain flip/HDR changes and restore a per-frame DX11
proxy Flush, so it is not an established performance fix.

The saved ReShade preset enables Lilium HDR analysis with waveform/CIE
diagram/gamut analysis. Its effect has multiple GPU passes, including
HDR-specific gamut analysis. Saved state does not prove it was enabled
during every earlier FPS comparison; disable the whole analysis technique
for the next controlled comparison.

Manual check for the user's next `gearsofwarredux` build:

1. Restart with the diagnostic source and all ReShade effects disabled.
   The startup message should show `custom shaders: 0, offscreen upgrade
   rules: 0`, and `mods::shader attached` should be absent for this addon.
2. Hold scene/camera, resolution, FPS cap, occlusion setting and DLSS mode
   fixed. Compare with the addon disabled but the same ReShade installation
   and disabled effects. Restart when switching modes that require it.
3. If the loss persists, isolate original-format flip, raw HDR swapchain
   and the complete HDR proxy in separate timing-only builds; incorrect
   raw-buffer color is not a production HDR solution. Measure GPU busy time
   and Present waiting/composition before changing production window flags.

The modified addon passed the x64 Clang C++20 syntax-only check, with 28
existing shared-infrastructure warnings. No addon DLL was built or deployed,
no shared infrastructure was edited, and no new runtime FPS capture was
performed. Existing commented shader/resource experiments were preserved.

## Direct DX11 shader injection — 2026-10-05

The user subsequently confirmed a repeatable comparison: with the same scene
and upgrades enabled, performance recovers when both game shader entries are
disabled and drops when they are enabled. The saved ReShade preset now has
no enabled effects. This shifts the investigation to shader replacement,
injection/tracking overhead and execution of the replacement shaders.

The source at this point selects v2 through the default in `swapchain.hpp`;
removing a local version define alone does not select v1. This patch leaves
that selection unchanged and adds the selected version to the startup log.
The user's previous v1 result remains a reported comparison rather than a
new runtime measurement performed here.

`shader_injection.hpp` implements a game-local D3D11 path. It replaces the
two pixel shaders during creation and tracks only handles with the embedded
replacement bytecode. A pixel-shader bind callback supplies the existing
80-byte settings structure at b13 only for these handles. It uses one dynamic
buffer per recording context, uploads when the data changes, and rebinds it
after NGX/other output code changes b13. The direct path does not register
the shared game shader module, its draw/dispatch filters, pipeline cloning,
or injection-layout hooks. It still performs a small lookup on pixel-shader
binds; it does not eliminate all addon callbacks or GPU shader work.

Both game replacements are enabled again to make the new HDR path testable.
The resource rules restored by the user remain active and unchanged, and
the shader math, swapchain/proxy setup and DLSS conversion were not changed.
The new global `GearsShaderInjectionMode` setting requires a restart:

| Value | UI label | Behavior |
|---|---|---|
| 0 | Disabled | Original game shaders; no game shader module/direct injection |
| 1 | Direct DX11 | New targeted path; default |
| 2 | Standard | Previous shared RenoDX shader module for comparison |

The mode chosen at startup remains fixed for callback cleanup, even if the
UI value is changed before restarting. Disabled is a diagnostic baseline;
it does not deliver the complete HDR/DLSS shader corrections.

Manual validation for the user's `gearsofwarredux` addon build:

1. Rebuild locally, restart, and check the startup message says
   `shader injection: Direct DX11`, two custom shaders and 31 offscreen
   upgrade rules. Check the reported swapchain version as well.
2. The log should report `Gears Redux direct DX11 shader: replaced
   0x4d17ceab at creation`, and `0x29ccb91a` when that upscaler final shader
   is created. The game shader module should not attach in Direct mode.
3. Compare Disabled, Direct DX11 and Standard after separate restarts in
   the same scene, with the same resolution, mapper, DLSS mode, cap and
   upgrades. Keep ReShade effects disabled and occlusion queries enabled.
   Compare frame times/minimum FPS, and check Direct versus Standard for
   matching brightness, grading, HUD, fades and motion blur.
4. Check DLSS upscaling highlights/peak versus native/DLAA after the required
   restarts. Settings must update immediately in the next applicable shader
   pass, including the DLSS linear flag and output preset.

Validation here: full addon x64 Clang C++20 syntax-only check passed with
28 existing shared-code warnings. A scratch WARP GPU test exercised the
actual direct constant-buffer function and passed 4,080 field comparisons:
all 20 floats, changed/unchanged settings, DLSS flag changes, b13 rebinding,
unrelated PS/VS buffer slots, buffer reuse, ClearState and deferred-context
isolation. The test built a scratch executable and test shaders only.
No addon DLL was built/deployed, no shared RenoDX module was edited, and
the native replacement-event path and real-game performance still require
the user's build/runtime check. This is a targeted overhead reduction,
not a measured FPS fix or proof that shader arithmetic has no cost.

## Shader optimization review — 2026-10-05

The user reports that Direct DX11 injection now performs substantially
better. No numerical in-game frame-time capture accompanies that report.
The shared C++/HLSL `ShaderInjectData` in `shared.h` remains the normal RenoDX
layout pattern (also used by `batmanak` and `masseffectle`); Direct DX11
changes how its settings reach b13, rather than replacing the shared layout.

Two local changes in `0x4D17CEAB.ps_5_0.hlsl` reduce scene-pass work:

- Combine the positive game gamma result and its gamma-2.2 decode into one
  exponential on the configured path. Keep the original no-config path.
- When HDR Scene Grading is exactly zero, skip the authored shadow,
  highlight, midtone and desaturation calculation. Preserve the fade
  overlay, color scale, brightness, user grading and tone mapper.

The neutral user-grading fast path already exists in the shared library.
The final scRGB proxy already avoids a gamut round trip for positive RGB.
The DLSS decoder is a small load/pow/store pass. Its conversion and the
final blur's per-tap gamma conversions remain necessary to keep DLSS
upscaling in the same grading/blur domain as native and DLAA. No changes
were made to these files, the tone curves, `shared.h`, resource upgrades,
injection backend or swapchain selection during this review.

FXC Shader Model 5 compilation passed. A scratch WARP rendering test
compared before/after scene shaders across 372 cases (3,047,424 RGBA
components): all five mappers, grading strengths 0/0.5/1, four game gamma
settings, authored/user grades, DOF, fades, two peak/Game/UI white
configurations, negative/zero/bright inputs and invalid/unbound injection.
Outputs matched exactly in those cases; the test also checked that it
rendered nonempty pixels and exercised HDR highlights.

An isolated cached-input 3840x2160 pass on the RTX 4080 SUPER improved by
roughly 0.007–0.010 ms at normal Scene Grading. HDR modes at zero Scene
Grading saved roughly 0.025–0.028 ms. These scratch timings are not game
FPS measurements. The compiled shader contains 894 static instruction
slots versus 892 before, and still uses 12 temporary registers: the new
uniform branch adds code but skips work at runtime. Static totals include
all selectable tone mappers and do not mean they all execute together.

Manual validation after the user's next addon rebuild:

1. Keep Direct DX11 selected. Hold scene, resolution, output mode and
   DLSS mode fixed while comparing frame times with the previous build.
2. Check all five mappers at normal Scene Grading and at zero. Check
   colored highlights, game brightness, unequal Game/UI white, fades
   and DOF; zero Scene Grading must still retain fades and color scale.
3. Verify native/DLAA versus DLSS upscaling brightness and highlight
   colors after the required restarts, including motion blur and HUD.
4. Check both scRGB and HDR10 output if used. The shader's invalid or
   unbound configuration must continue to follow the original game path.

Only scratch shaders and test executables were built. No addon DLL was
built or deployed, and no installed game file was changed.
