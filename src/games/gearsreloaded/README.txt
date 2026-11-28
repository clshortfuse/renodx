Gears Reloaded - RenoDX HDR

RenoDRT, PsychoV35 and PrismTM are the HDR tone mappers. Game Brightness
sets scene paper white; Peak Brightness sets the selected mapper's display peak.
UI Brightness is independent. Keep HDR enabled in the game. In custom modes the
in-game HDR peak, paper-white, brightness, contrast and PQ-curve settings are
bypassed by the registered scene, LUT and output replacements. Vanilla / Preset
Off disables replacement through per-draw callbacks, retaining the original
game bytecode and in-game sliders. The mod brightness
controls are disabled in Vanilla.

SDR BLACK MATCH
SDR shadow matching is automatic, with no strength slider. It follows the
native SDR grade only at low luminance, fading out between 1% and 5% of
reference white. The greater of SDR luminance and neutral maximum channel
protects saturated lights. Midtones retain the existing HDR response. No
extra gamma correction, half-strength blend or near-black adjustment is added.
Saved SDRBlackMatch values are ignored. Game Brightness defaults to 203 nits.
GPU diagnostics identified native SDR OutputColorSpace=1, inverse gamma
approximately 1/2.2 and overlay inverse ratio 1. Native SDR decodes artist gamma
2.2, then writes sRGB. The previous reference incorrectly reused HDR's inverse
gamma and applied power 4.4. Alpha now evaluates the native SDR artist blend
on the SDR grid, stores sRGB-shaped luminance and is sampled separately using
the scene's SDR address before sRGB decoding. A scalar luminance channel
approximates colored RGB interpolation; runtime color/shadow checks remain
necessary.

The existing native HDR RGB LUT and mapper path are retained. LUT alpha stores
sRGB-shaped SDR luminance on its own SDR-addressed grid. The addon
upgrades only the 1024x32 R10G10B10A2 LUT targets to RGBA16F so the extra channel
can retain shadow precision; the original two-bit alpha cannot carry it.
The HDR scene, UI and 10-bit swapchain are unchanged. This texture format
change requires rebuilding the addon and restarting the game. Do not load the
new black-match shader path against an old unupgraded LUT: alpha would be zero
or quantized and the shadow reference would be invalid.

PIPELINE
The scene is captured after exposure, bloom, depth of field and vignette, before
the native Hable curve. The LUT builders preserve the native artist blend,
including both textures in the two-LUT variant, using a fixed reference look:
140-nit paper white, 1000-nit native target and native brightness 1.3. This is a
look reference, not the custom mapper's brightness limit. Its scene WhiteScale
(1.8271834) is distinct from the LUT inverse-Hable white parameter (0.51513636).

A matching neutral reference reconstructs the grade on the real upstream HDR.
After shared user grading, RenoDRT, PsychoV35 or PrismTM maps that HDR signal.
PsychoV35 uses the shared test35 implementation on the same linear signal and
keeps the native-color matching path. It replaces V30 in the existing menu
slot and retains internal ID 30, setting keys and controls. The injected layout
now has 40 floats; the original 36 offsets remain unchanged. Existing Psycho presets now select V35. Live shaders also accept the
already-loaded addon's V30 selection; rebuild to update the menu label.
The native look is retained through paper white and blended smoothly into the
selected mapper above it. Mod Game Brightness scales paper white; mod Peak
Brightness supplies the mapper's peak. Neither depends on the game's sliders.
Highlight luminance follows the selected mapper while RGB ratios follow the
native LUT reference after user grading. This prevents saturated highlights
from washing toward white during grade reconstruction and tone mapping.
The scene is encoded as BT.2020 PQ for the existing motion-blur and HDR/UI path.
Native overlay fades remain after the mapper. The 10-bit swapchain is retained.
LUT domain coordinates are clamped at zero before log2 to prevent interpolated
UV roundoff from corrupting the black node in recompiled shaders.

REGISTERED SHADERS
0x53E6E14A.ps_5_1: one-texture LUT builder.
0x2E1C1BBE.ps_5_1: alternate one-texture LUT builder.
0x13AE6CC9.ps_5_1: two-texture LUT builder, including LUTWeights[2].
0xD3EA3D95.ps_5_1: scene composite without depth of field.
0xCCF1C731.ps_5_1: scene composite with depth of field.
0x42F14792.ps_5_1: HDR scene/UI composition, independent UI nits.
The originals are SM5.0; the replacements use SM5.1 for b13 / space50 injection
on DirectX 12. No dumped bytecode belongs in this source/live-shader directory.

BUILD
Close the game before building the addon. From a Visual Studio developer shell
in the repository root:
  cmake --preset clang-x64
  cmake --build --preset clang-x64-debug --target gearsreloaded
Expected addon: build/Debug/renodx-gearsreloaded.addon64
Generated index: build/gearsreloaded.include/embed/shaders.h
Inspect the six corresponding embed headers.
Game executable:
  GOWDE-WinGDK.exe

VERIFICATION
The SDR-black revision compiles all six PS5.1 replacements and passes a Clang
C++ syntax check. The source preserves the existing HDR RGB math and adds only
the shadow-reference alpha and low-luminance match. A Vanilla SDR reference was
captured from the Steam game. The restarted addon has 40 injected floats and
its 1024x32 LUT upgrade to RGBA16F was verified through DevKit. The corrected
reference is live in all six shaders. For the captured alternate LUT variant,
comparison with native SDR showed maximum sRGB-luminance node error 0.000120
and median 0.0000228. This validates LUT nodes, not exact colored interpolation
or whole-frame equivalence. Unpaused gameplay appearance and scene-transition
coverage still require visual checks. Rebuild after closing to embed the fix.

The matching revision was compiled and activated through DevKit for all six
shaders. With RenoDRT selected, Game Brightness 140 and Peak Brightness 2700, a
same-frame 256-step neutral ramp matched the native scene shader exactly at
the 10-bit PQ readback precision for all 108 samples through 140 nits. The full
custom ramp was monotone and reached approximately 2707 nits. This comparison
uses the fixed native reference LUT; it does not imply equality for arbitrary
in-game calibration settings, colored samples or the custom highlight range.
The active one-texture LUT's black node also matched the native capture.

Before replacing V30, a live colored-patch comparison in PsychoV30 at approximately 140-nit paper
white and a 3800-nit peak tested 16 colors at 16 intensity levels. All 116 patches
through paper white matched the fixed native LUT reference at readback
precision. Across 140 highlight patches, mean normalized BT.2020 RGB-ratio
error fell from 0.08431 to 0.000782 after reference-chromaticity preservation.
The reference samples were unchanged between captures. This metric measures
color ratios, not Delta E or displayed colorimeter accuracy. Other mappers,
two-LUT transitions, and actual gameplay still require visual confirmation.

The V35 path was separately exercised live with 256 colored patches: all 117
patches through paper white matched its current native LUT reference, and mean
normalized highlight RGB-ratio error was 0.000785. All six shaders compiled.
This is numeric shader validation; gameplay appearance remains unverified.

Live GPU neutral-step tests, before grading, were monotone and finite for all
three mappers. A requested 2700-nit peak measured about 2707 nits in the 10-bit
readback; 4000 measured about 3992. At scene input 0.18, Game Brightness 140 gave
25.25 nits and 300 gave 54.07 nits, with peak held near 2700. These differences
from ideal values include 10-bit PQ and RGBA16F readback quantization. Actual
gameplay need not reach the selected peak.

After installing/restarting:
1. Confirm RenoDX - Gears Reloaded loads and all six replacements are embedded.
2. Select RenoDRT, PsychoV35 and PrismTM; check Game Brightness, Peak Brightness,
   Scene Grading and the mapper-specific controls.
3. Change the game's HDR brightness/peak sliders while a custom mapper is
   active; scene output should follow the mod's controls instead.
4. Check both one-LUT variants and the two-LUT blend across scene transitions.
5. Check menus, HUD, subtitles, translucent UI, black fades and cutscenes.
6. Compare Vanilla / Preset Off with the unmodified native HDR path.
The matching revision was tested with the loaded addon's real slider values.
Its HLSL is live-loaded; rebuild the addon after closing the game to embed it.
The alternate one-LUT and two-LUT revisions compile, but still need runtime
scene-transition coverage. Check cutscenes, UI and saturated colors visually.
