Call of Duty: WWII - RenoDX native HDR mod

REGISTERED SHADERS
- 0x1A5B4531: scene tone-map/LUT pass with vignette, cb3[43].
- 0x0031657D: scene tone-map/LUT pass without vignette, cb3[42]. The game
  switches to this variant after a bayonet charge and can keep using it until
  a checkpoint reset. Both variants share tonemap.hlsli and hdr.hlsli.
- 0x28220589: native PQ Rec.2020-to-linear scRGB output conversion. Adds a
  final peak limit after temporal/post-processing and UI composition.
- 0xDBC723D4: textured HDR UI. UI white is adjustable before PQ encoding.
  Some levels also draw a full-screen vignette through it: black RGB, the
  vignette in the alpha of a 256x256 BC3 texture without mips, whose content
  only changes per 4x4 texel block (64x64 effective), sampled with point
  filtering. At 4K that shows as hard ~60-pixel grey squares, in Vanilla too.
  Fix: for that overlay (256x256, 1 mip, UVs spanning the screen) the alpha
  is rebuilt with a cubic B-spline over the 4x4 block centres (16
  GatherAlpha calls, independent of the bound sampler; C2-continuous, so no
  edges or seams), plus a +-1 10-bit-step triangular dither. Other UI is
  unchanged. A plain Gaussian blur through the game's point sampler did NOT
  work (taps snap to texels). Verified live 2026-10-17 by visualising the
  alpha x4: original blocky, rebuilt smooth.
- 0x046F5E22: HDR font/shadow/outline rendering. The same UI white adjustment
  covers foreground, shadow, and outline, preserving the original blending.
- 0xC70BB301: TAA resolve (after the scene pass, on PQ Rec.2020). Motion
  vectors (t7, packed 10:10 bits), neighborhood-clamped history (t3, t8),
  luma rejection (t4-t6), a deferred-resolve append list (u7), sharpening,
  and, at the end, the game's FILM GRAIN on o0 only (o1/o2 history copies stay
  grain-free). Grain = BC4 noise t0 (256x512), animated by cb3[32].x, scaled
  by cb3[32].w and faded by (1 - median(rgb)^2). The replacement is a hand
  translation of the DXBC with exact bytecode immediates; the only changes are
  the grain strength (RENODX_FX_FILM_GRAIN) and the grain type option.

Identified but not replaced:
- 0x825B600A: screen-space lens overlay (dirt/blood/water splatter style),
  drawn after the TAA resolve and before the UI. Two masks (t0, t3) faded by a
  per-draw timer (v2), two normal maps (t2, t4), lit from cb3[32]-[37] with a
  pow-15 specular, tinted between cb3[42]/cb3[43] colors, strength cb4[0].
  It alpha-blends PQ output; its color is sRGB-encoded then raised to 2.4,
  scaled by cb3[4].x, converted to Rec.2020 and PQ-encoded, so its brightness
  follows the game's HDR menu rather than the mod's Game Brightness.

The unregistered Cold War scaffold shaders are retained for compatibility;
their hashes do not occur in the captured WWII frames.

ENGINE FLAGS
cb3[5], cb3[6].x, and cb3[8].w contain integer bit patterns. Use asuint tests
to preserve DXBC if_nz/if_z behavior. Float tests can flush these flags to zero,
select SDR encoding, or skip the HDR LUT, causing the later PQ decoder to
produce nearly 10,000 nits. UI colorblind-mode flags also use raw integer bits.

HDR PIPELINE
The scene input is linear HDR (R11G11B10), with bloom and engine exposure.
The native 64-cubed LUT is R10G10B10A2 and returns PQ Rec.2020. Its input units
are not nits: the measured neutral input 1 produced about 13.5 nits in the
captured scene, not the old assumed 100 nits.

The custom path keeps the native LUT input and shadow/midtone response. It
samples the currently bound LUT's neutral response at inputs 4 and 8 to fit
the forward response below the highlight knee. Above that range, the actual
upstream HDR source extends this response around the LUT's fixed highlight
compression. Native grade/color direction is retained. This is a shader-side
HDR LUT bridge, not inverse tone mapping of a completed SDR frame.

The selected mapper applies a shoulder above diffuse white, with its 0.18
anchor translated to white. This prevents a second midtone compression when
switching between native HDR, RenoDRT, PsychoV30, and Prism. Changing peak or
curve can still change average brightness when a scene contains highlights.
The two-point LUT fit needs comparisons across other missions and grades.

CONTROLS
- Vanilla is the original path and Preset Off restores it. HDR and grading
  sliders are disabled in Vanilla rather than advertising ineffective controls.
- Game Brightness is a real output scale: default 300 nits preserves the native
  reference; changing it scales scene brightness without cancelling itself.
- UI Brightness adjusts the two captured HDR UI/font shaders independently.
- Exposure, Highlights, Shadows, Contrast, Saturation, Flare, Highlight
  Saturation, and Blowout are wired through shared grading for all custom modes.
- Scene Grading blends native LUT color with the neutral LUT response.
- Scaling affects RenoDRT and Prism. PsychoV30 uses its own LMS response;
  Scaling is disabled for that mode.
- PsychoV30's dedicated controls affect highlight mapping. Compression 0
  selects the shared implementation's automatic mode; positive values select
  manual compression. The shared PsychoV30 implementation is unchanged.
- Peak Brightness limits positive Rec.2020 channel values at the scene pass
  and again at final output. A 0.1% margin accommodates the game's approximate
  gamut matrix and FP16 rounding. Native output remains linear scRGB (80 nits
  per unit); no swapchain format change is required.
- Film Grain Type (Effects): Vanilla (the game's grain texture), RenoDX
  (renodx::effects::ApplyFilmGrain: luminance grain from Bartleson film-density
  graininess, on linear Rec.2020 with 1.0 = Game Brightness) or RenoDX Colored
  (ApplyFilmGrainColored: per-channel AP1 grain). The RenoDX types replace the
  game's grain, are seeded per frame from cb3[32].x and ignore the game's grain
  strength cb3[32].w.
- Film Grain: 0-100, 0 = off. With Vanilla, 50 = the game's strength and
  100 = double; RenoDX types use slider * 0.02 * 0.03 as in other RenoDX mods.
  Both work in every tone-mapper mode. Preset Off restores Vanilla at 50.

BUILD AND LIVE DEVELOPMENT
Target: CODWW2. Artifact: build/Debug/renodx-CODWW2.addon64.
Development build: cmake --build --preset clang-x64-debug --target CODWW2.
Close WWII before rebuilding/deploying its loaded addon.
Inspect generated embedded shaders for all six registered hashes.

Live shader loading can replace the newly found shader, but the running older
addon cannot inject settings into a hash it does not register. Rebuild and
restart are required for sliders on the bayonet-charge, output, and UI paths.
Do not mistake constant diagnostic probes for working addon settings.

RUNTIME CHECKS (2026-10-03)
- Captured the post-bayonet-charge state: 0x1A5B4531 was absent, and
  0x0031657D was original/unregistered. Both use the HDR LUT and later scRGB
  output. The apparent SDR switch was a missing replacement.
- Before the brightness fix, a stationary live comparison measured roughly
  58 nits average in Vanilla versus 42-43 in the custom modes.
- After the fix, alternating native/custom pixels in the same scene-pass
  frame measured average changes of +0.082% RenoDRT, +0.025% PsychoV30,
  and +0.120% Prism. These measurements exclude HUD and later post-processing;
  the paired method avoids camera/flicker differences between captures.
- Final scRGB captures with peaks forced to 300, 600, and 1500 nits measured
  299.68, 599.35, and 1488.38 nits respectively, with no NaN pixels.
- All replacement shaders compiled and activated through DevKit.
- Clang Debug CODWW2 build completed successfully. The restarted game's
  installed addon matches the user's fresh Release build (SHA256
  56B28F9CE31CCB9607F09D2CA14F973D50A1EC5457B2D913DD3C72EC61E12AAA).
  ReShade reports five registered custom shaders; DevKit confirms all five
  are supplied by the addon, with no constant diagnostic probes loaded.
- The installed addon contains the exact bytecode of all five current build
  shaders. A new post-charge capture confirms 0x0031657D is supplied by the
  addon (no live override). The user confirmed the Exposure control responds
  after bayonet charge without a checkpoint reset.

AFTER REBUILD
1. Confirm the installed addon registers all five hashes.
2. Select a custom mode, change Exposure and Game Brightness, then bayonet
   charge. Capture the alternate shader and confirm those sliders still respond
   without resetting the checkpoint.
3. Compare all modes at neutral grading and Game Brightness 300 in the same
   scene. Check dark detail, saturated highlights, vignette, and transitions.
4. Change UI Brightness and inspect HUD, menus, text, shadows, and outlines.
5. Check final output at several peaks, including a peak below game/UI white.
   Recheck after temporal effects and UI composition, not only at the scene pass.

GAME HDR SETTINGS ISOLATION (2026-10-17)
Goal: custom mappers should not respond to the game's HDR menu (brightness,
white point, black floor). Current state: only partly achieved.
- cb3[6].y (scene input scale) read 2.8284 (2^1.5), constant across frames and
  identical at default settings. Custom mode uses CODWW2_NATIVE_HDR_SCALE;
  Vanilla still reads cb3[6].y. cb5[3].x drifted per frame (~1.14, engine
  exposure) and stays live.
- The native 64^3 LUT carries both the level's grade and the menu settings.
  It is rewritten in place at level load and on menu changes; no GPU pass was
  seen writing it (41 compute shaders checked, no GS, no per-slice draws, also
  while a slider was moving), so it is most likely CPU-built and uploaded.
  Menu values therefore cannot be overridden at the source from shaders.
- Its baked shoulder flattened highlights to white near the game's peak
  (1331 nits at input 64, 1417 at 1024 under the settings at the time).
CODWW2MapHDR uses the live LUT as-is up to input 2. Above it, it locates the
live LUT's shoulder by walking octaves from input 2 until the neutral
log-slope drops below 0.9 (CODWW2_LUT_LINEAR_SLOPE). Luminance follows the live
LUT up to the shoulder and continues at its last near-linear slope beyond it;
grade color is sampled one octave below the shoulder. Levels differ: one LUT
measured slopes 1.05/0.94/0.60 at inputs 2-4/4-8/8-16, another 1.12/1.12/1.27,
so a fixed extension slope (1.05) left the second level up to 9% dim at input 8.
The walk also stops once the LUT exceeds 50% of its own maximum (input 1024),
and the continuation slope is capped at 1.5. Without that bound, interior and
transition LUTs that stay steep until just below their ceiling let the walk run
to input 512-1024, reproducing Vanilla's colour and peak for about a second when
entering or leaving interiors (no separate shader: captures and a paused frame
showed 0x0031657D running the custom path).
Custom mappers start their shoulder at CODWW2_SHOULDER_KNEE (45%) of Peak
Brightness, never below diffuse white, because Vanilla's LUT stays near-linear
to roughly 45% of its own peak; a shoulder at diffuse white dimmed 300-650 nit
content. In-game check (2026-10-17, 0x1A5B4531, synthetic neutral inputs run
through the live LUT and CODWW2MapHDR): exact PQ match at 0.25/1/4/8/16; at
input 64 Vanilla flattened at ~1330 nits while RenoDRT continued to ~1900.
Scene-RT mean PQ: Vanilla 0.4038, RenoDRT 0.4034 (0.3995 before), peak ~2400.
This fixes white clipping and makes the white point slider irrelevant; the
brightness and black floor sliders still act as base calibration.
Rejected attempts:
- Normalizing LUT brightness to a fixed input-1 value: cancelled brightness and
  white point, but black floor leaked and per-level brightness was erased.
- A fixed default-settings curve (floor 0.2533 nits, input 1 -> 70.98 nits):
  cancelled all three sliders, but other levels became far brighter than
  vanilla because each level's LUT carries its own exposure/grade.
- A fixed 1.05 extension slope above input 2: matched one level but not others.
LUT scale/offset (cb3[8]/cb3[9]) are 63/64 and 1/128: texel centering only.
Scene-pass cb3[4].x is ~0.003 (not the UI white value used by UI shaders).
Measured via a temporary DevKit probe that encodes constants or LUT samples
into the scene RT and reads them back with analyze_resource.

INTERIOR/EXTERIOR TRANSITION FLASH (2026-10-17)
Moving between interiors and exteriors briefly (~1 s) shifts color and peak,
then recovers. The user confirmed Vanilla does it too, so it is the game's
own transition (exposure adaptation or a lighting/grade blend), not a missing
tone-map replacement. Captures during transitions only showed the
registered scene pass. The v6 LUT ceiling bound did not change it.
Next step if it should be damped: check whether cb5[3].x (engine exposure)
or the CPU-built LUT changes during the flash, then smooth that signal
(see renodx-auto-exposure).
