Gears Reloaded - RenoDX HDR

RenoDRT, PsychoV30 and PrismTM are the primary HDR tone mappers. Game Brightness
sets scene paper white; Peak Brightness sets the selected mapper's display peak.
UI Brightness is independent. Keep HDR enabled in the game. In custom modes the
in-game HDR peak, paper-white, brightness, contrast and PQ-curve settings are
bypassed by the registered scene, LUT and output replacements. Vanilla / Preset
Off disables replacement through per-draw callbacks, retaining the original
game bytecode and in-game sliders. The mod brightness
controls are disabled in Vanilla.

PIPELINE
The scene is captured after exposure, bloom, depth of field and vignette, before
the native Hable curve. The LUT builders preserve the native artist blend,
including both textures in the two-LUT variant, using a fixed reference look:
140-nit paper white, 1000-nit native target and native brightness 1.3. This is a
look reference, not the custom mapper's brightness limit. Its scene WhiteScale
(1.8271834) is distinct from the LUT inverse-Hable white parameter (0.51513636).

A matching neutral reference reconstructs the grade on the real upstream HDR.
After shared user grading, RenoDRT, PsychoV30 or PrismTM maps that HDR signal.
The native look is retained through paper white and blended smoothly into the
selected mapper above it. Mod Game Brightness scales paper white; mod Peak
Brightness supplies the mapper's peak. Neither depends on the game's sliders.
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
The matching revision was compiled and activated through DevKit for all six
shaders. With RenoDRT selected, Game Brightness 140 and Peak Brightness 2700, a
same-frame 256-step neutral ramp matched the native scene shader exactly at
the 10-bit PQ readback precision for all 108 samples through 140 nits. The full
custom ramp was monotone and reached approximately 2707 nits. This comparison
uses the fixed native reference LUT; it does not imply equality for arbitrary
in-game calibration settings, colored samples or the custom highlight range.
The active one-texture LUT's black node also matched the native capture.

Live GPU neutral-step tests, before grading, were monotone and finite for all
three mappers. A requested 2700-nit peak measured about 2707 nits in the 10-bit
readback; 4000 measured about 3992. At scene input 0.18, Game Brightness 140 gave
25.25 nits and 300 gave 54.07 nits, with peak held near 2700. These differences
from ideal values include 10-bit PQ and RGBA16F readback quantization. Actual
gameplay need not reach the selected peak.

After installing/restarting:
1. Confirm RenoDX - Gears Reloaded loads and all six replacements are embedded.
2. Select RenoDRT, PsychoV30 and PrismTM; check Game Brightness, Peak Brightness,
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
