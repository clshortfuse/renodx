# Gears 5 native HDR tone mapping

Replaces the captured native HDR path with PsychoV35, PrismTM, RenoDRT or Vanilla+. The
custom path uses RenoDX peak/paper-white controls and bypasses the game's HDR
calibration curve, HDR saturation and final SDR-to-HDR expansion. Scene eye
adaptation, bloom, lens dust, vignette, white balance and authored grading remain.

Enable the game's native HDR mode. SDR mode and uncaptured shader permutations
have not been validated. Vanilla and Preset Off restore the original shaders,
including the game's original UI brightness behavior.

## Controls

- Tone Mapper: Vanilla, RenoDRT, PsychoV35 (default), PrismTM, Vanilla+.
- Vanilla+ extends the native SDR filmic curve using its scene-specific midgray
  tangent. It retains the original toe, ACES preprocessing, desaturation and
  artist LUT coordinates, then transfers the artist grade onto the extended
  signal. A Reinhard shoulder above reference white limits HDR highlights to
  the selected peak. The original four selector indices are unchanged.
- Peak Brightness: custom output target, 48â€“4000 nits; default 1000.
- Game Brightness: custom scene paper white; default 203 nits.
- UI Brightness: independent UI white, 48â€“203 nits; default and hard maximum 203.
  This limits the UI's own contribution. Bright scene pixels visible through a
  translucent overlay can remain brighter than 203 nits.
- Grading controls are neutral by default. PsychoV35 targets BT.709 by default.
- Scene gamma correction: fixed sRGB-to-gamma-2.2 correction before UI blending,
  with no extra slider. The correction applies only to each channel's SDR-range
  portion relative to paper white. Values above paper white retain their level;
  UI brightness is unchanged. This is the user-selected display response after
  SDR shadow matching, so final shadows are darker than the uncorrected reference.
- SDR shadow matching is automatic, with no strength slider. Dark-shadow
  luminance follows the native SDR filmic/artist-grade reference, fading out
  between 1% and 5% of reference white. Midtones and highlights retain the
  selected HDR mapper's response. Saved SDRContrastMatch values are ignored.

## Captured pipeline and replacements

1. `0xEA1C6FF4.cs_5_1.hlsl`: CombineLUTs builder with an artist LUT texture. The native log-shaper domain
   is decoded into scene-linear BT.709. The replacement branches before the
   native ACES curve, after white balance and linear grading. It calls the
   selected custom mapper after reconstructing the native artist grade onto
   the scene-linear input. The 16-slice artist LUTs use their original SDR
   filmic coordinates and blend weights, rather than HDR-mapper coordinates.
   `0xC29D7F6F.cs_5_1.hlsl` covers the captured variant without an artist LUT
   texture. The dual-artist-LUT variant `0xF930FE01.cs_5_1.hlsl` preserves both
   textures and cb0[48..50] blend weights. All three use the same mapper
   and peak-relative carrier encoder. `0x4BEE8631.cs_5_1.hlsl` handles the
   three-artist-LUT blend observed during tactical view, including cb0[51]'s
   third grade weight. It uses the same SDR shadow reference and carrier.
   Each variant also evaluates its native
   filmic/artist-grade reference before display calibration. The shared matcher
   uses its luminance only for dark shadows, without a separate gamma-2.2 display correction. This runs in the small generated LUT,
   rather than tonemapping a completed SDR frame.
2. Original scene composite `0xB06AD2C3` retains exposure, bloom and vignette,
   then samples CombineLUTs into the 10-bit FinalSceneBuffer.
3. Original CAS `0x8585638A` sharpens that buffer in its existing gamma-2 domain.
   The custom LUT carries peak-relative gamma-2 values through these UNORM
   resources; the native composite's 1.05 factor is compensated in the LUT.
4. `0x47FB02F4.cs_5_1.hlsl`: final HDR/UI compute composite. It decodes the
   carrier into scene nits, applies the scene gamma-2.2 correction relative to
   paper white, decodes the separate SDR UI, scales the UI using
   RenoDX's slider, blends in linear light and writes BT.2020/PQ. It bypasses
   the native UI calibration curve, global saturation and SDR2HDRLUT lookup.
5. `0x5BB15E0E.cs_5_1.hlsl`: tactical-view composite. Its native palettes,
   white tint, additive offsets and outlines are SDR-white-relative. Scale
   these contributions by UI Brightness / Peak Brightness before writing
   the scene carrier, so tactical white is no longer interpreted as HDR peak.
   Scene color and depth/stencil-based tactical masks remain in their native path.
6. `0x2916AE8A.cs_5_1.hlsl`: red damage HUD material. Its health-vein and COG
   masks, animation and opacity remain native. The original scene composite
   `0x02E2D195` blends this material after the LUT, directly into the scene carrier.
   Decode its SDR color and encode it as UI Brightness / Peak Brightness before
   that blend, limiting its own color contribution to the UI slider (max 203 nits).
   Bright scene content visible through the translucent effect retains HDR range.

The original/decompiled shader bodies remain alongside the custom branches for
comparison. The injected buffer uses b13, space50. Standalone DevKit loading
without valid injected settings falls back to the original branch.

No resource upgrades or swapchain overrides are required for the captured path.
The pre-tonemap MotionBlur resource was confirmed to contain real HDR values
above 1 (up to 33.5 in the sampled capture). The output remains native 10-bit PQ.
This is a replacement of the scene's forward mapping, not expansion of the
completed SDR frame.

## Build and install

From the RenoDX repository in a Visual Studio developer environment with Clang
and Ninja available:

```powershell
cmake --preset clang-x64
cmake --build --preset clang-x64-debug --target gears5
```

Copy `build/Debug/renodx-gears5.addon64` beside the game's executable after closing
the game. The local binary folder is
`F:\SteamLibrary\steamapps\common\Gears5\GearGame\Binaries\Steam`.
Restart the game to load the rebuilt addon. DevKit LivePath is the repository's
`src/games/gears5` folder contains fourteen custom replacements.
When ending a diagnostic override, verify the selected source for each shader:
DevKit Unload selects Original, which can leave a native LUT paired with the
custom HDR composite. Reload all fourteen custom shaders together after rebuilding;
a game restart loads the embedded addon normally.

Keep this folder inside a RenoDX checkout: it depends on the shared shader
library, including PsychoV35. Gears Reloaded uses its own game-specific shader path.

## Validation and remaining checks

- Original DXBC was dumped and decompiled through DevKit.
- Both repaired baseline compute shaders compiled and activated live. The user
  confirmed the baseline image looked unchanged.
- All four scene LUT variants and both composites compile with FXC as cs_5_1.
- Post-integration addon rebuild and runtime image checks are pending.
- Gamma/contrast matching was compared live against a Vanilla SDR capture in
  the same room at 140-nit paper white. The user confirmed that shadows looked
  closer to SDR with sufficient detail. Moving actors and lighting changes
  prevent an exact frame-to-frame error claim.
- The older live preview fixes the former broad SDR match to 100% and paper white
  to 203 nits. The separate gamma-matching correction has been removed. The
  updated addon retains the 28-float injection layout and needs rebuilding
  and restarting for its permanent settings. Existing saved Game Brightness
  values may need to be reset to the new 203-nit default.

The low-luminance revision narrows matching in all four LUT variants to the
1â€“5% range above. It adds no gamma correction or resource upgrades. Rebuild and
restart to replace the older live preview; visual validation is pending.

The SDR-match slider has been removed; matching uses the SDR reference directly,
without a half-strength blend or extra near-black adjustment. Game Brightness
defaults to 203 nits. Rebuild/restart and compare shadow detail against SDR.

## SDR black-level audit

The dual-LUT variant was checked on the GPU in the Steam game. Its SDR reference
matched 32765 of 32768 native generated-LUT entries exactly; the remaining three
differed by one 10-bit step. Captured SDR calibration was identity (cb0[28] =
0,1,0,0; cb0[29].y = 1; cb0[54].x = 0 selects sRGB). No extra gamma correction
was needed. The installed Release shader instruction stream matched the source;
the temporary dark HDR result came from DevKit source selection after unloading
the diagnostic LUT, not a stale addon build.

The matcher now falls back to the SDR RGB reference when the HDR luminance is
zero or extremely small. Scaling zero could not restore SDR shadow detail.
Ordinary nonzero shadow matching and the midtone/highlight fade range are
unchanged. No zero-output failures occurred in the 343 fully matched low-light
nodes of the captured LUT; this is a safeguard for other grades/views. The 10-bit
LUT/carrier still introduces shadow quantization (about 3.5% median relative
luminance error for those nodes at 203-nit paper white and 3800-nit peak).

All six shaders compiled and activated live after the safeguard change. The user
confirmed gameplay shadows look right. Other LUT variants compile but still need
scene-transition coverage. Rebuild after closing the game to embed the safeguard.

The later gamma-2.2 revision was previewed in the final HDR composite and accepted
by the user. The corrected output contained no NaN or infinity values. A numeric
ramp check was monotone, preserved zero and reference white, and left channels
above reference white unchanged. UI is blended after correction. The updated
composite is live-loaded and compiles with FXC as cs_5_1; rebuild/restart to embed it.

The red damage HUD was traced to `0x2916AE8A` using the health-vein/COG textures
and its post-LUT material input in `0x02E2D195`. The unchanged decompiled body
and corrected shader compile. A live preview at UI 203 / peak 3800 was accepted
by the user, and the captured output remained finite. The seven-shader embedding
target and C++ syntax check pass. The current preview pins those values because
the loaded addon does not yet register this new hash. Rebuild/restart to enable
its injected controls and Vanilla callback; the scene peak is not globally clamped.

## Native SDR grading transfer

The November 22 grading revision captures the native filmic result immediately
before the artist LUT as `neutral_sdr`, and its original decoded artist result
as `graded_sdr`. `ComputeUntonemappedGraded` transfers that grade onto the saved
scene-linear input before PsychoV35, PrismTM or RenoDRT. This follows the shared
Unreal grading-transfer approach and keeps the selected mapper's tone response.
The no-artist variant uses its native filmic color as both SDR references.
Existing low-luminance matching, scene gamma 2.2, paper white 203 and UI controls
remain in place. No new slider or injection-layout change is required.

The `gears5-shaders` target compiles all seven shaders and DevKit reports all
seven activated. Visual validation of the new grade and transitions is pending.
Rebuild the `gears5` addon after closing the game to embed these shader changes.

## Vanilla+ validation

All seven shaders compile and activated through DevKit in Gears 5. The captured
no-artist-LUT builder executed the Vanilla+ path, and the live preview was
accepted by the user. The sampled final PQ output contained no NaN or infinity
values. Numeric neutral ramps across three film configurations and five peak
ratios remained finite, monotone and bounded, preserved the toe/midgray, and
recovered the native filmic curve when peak equaled paper white. The three
artist-LUT variants compile; scene-transition coverage remains pending.

The accepted temporary preview is in
`C:\Users\ctied\Documents\Gears5-legacy-workaround\vanilla-plus-preview`.
It pins the mapper to Vanilla+ while retaining injected brightness and grading;
the currently loaded addon selector does not switch this temporary override.
The user handles building/installing the updated addon. After the subsequent
game restart, DevKit reconnected and LivePath was restored to `src/games/gears5`
for subsequent live loads. Select Vanilla+ (the fifth entry) in the addon;
the temporary forced preview is no longer required.

## Async Compute off: pixel variants

The addon registers the corresponding pixel paths alongside all seven compute
paths, using the same settings and Vanilla callback. No Async Compute setting
change is required. Native HDR mode remains required.

| Pass | Compute hash | Pixel hash |
|---|---|---|
| No artist LUT | `0xC29D7F6F` | `0xEC96FD43` |
| One artist LUT | `0xEA1C6FF4` | `0x18E1E866` |
| Two artist LUTs | `0xF930FE01` | `0xE0F20958` |
| Three artist LUTs | `0x4BEE8631` | `0xC508355B` |
| Final HDR/UI composite | `0x47FB02F4` | `0x4334A02D` |
| Tactical view | `0x5BB15E0E` | `0x8EA022B9` |
| Red damage HUD | `0x2916AE8A` | `0xD703EC94` |

The LUT pixel variants retain native raster UV/slice addressing and artist LUT
sampling. Both final composites share the carrier decode, scene gamma, UI-nits
blend and BT.2020/PQ encode. The pixel composite retains its native b0[15]
layout; compute uses b0[28]. Tactical palettes and red damage-HUD contributions
use the existing UI/peak scaling; native masks, opacity and fallback remain.

Validation: all seven original pixel baselines compile as ps_5_0. Replacement
pixel shaders target ps_5_1 for the existing b13, space50 injection layout.
Build `gears5-shaders` and `gears5`, then restart with the rebuilt addon. Check
all four LUT variants across scene/grade transitions, tactical vision, damage
HUD, UI brightness, peak/paper white, and Vanilla/Preset Off with Async Compute
both disabled and enabled. The integrated pixel path still requires runtime
verification after building/installing the addon.
