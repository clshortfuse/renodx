# RenoDX — Just Cause 2

Experimental HDR10 addon for the native Direct3D 10.1 renderer, 32-bit Steam
version (app 8190). Status: **work in progress**. HDR gameplay has been validated
with the standalone addon. A fresh installation defaults to SDR for comparison;
select HDR10 in the RenoDX panel to enable HDR.

## Implementation

- FP16 clones preserve scene, MSAA resolve destinations, and the backbuffer proxy.
  Both TYPELESS and UNORM aliases are required: FP16-to-RGBA8 resolves are invalid.
- `0x8301BC2E` and 14 related variants: composite before its final UNORM clamp,
  retaining each variant's depth of field, grain and world effects.
- `0x5046D433`: motion-blur output before the HUD.
- `0xBC4DBF99`: bounded exposure statistics, separate from HDR scene range.
- Eight packed-motion producers restore their original 0–1 data limits before
  MSAA resolve; their separate depth output and alpha tests remain unchanged.
- SM4 proxy shaders use `renodx::draw::SwapChainPass` for RGB10A2 SDR or HDR10.
  Both scene processing and the proxy follow the last successful DXGI
  color-space change, including when a requested transition fails.
- A D3D10 state block preserves game bindings around the present proxy. Captured
  references are released each frame to permit swapchain resize.

The composite performs depth-of-field blending, a screen-space hard-light grade,
luminance-dependent saturation, adapted exposure, tint, and vignette. Its `t3`
is an adapted exposure multiplier, not raw average luminance. It ends with
`sqrt(color)`; the UNORM write clips range rather than an analytic filmic curve.

Measured world draws use an sRGB RTV and the composite uses an sRGB SRV. Both
become linear with FP16. The game later resolves the backbuffer into its scene
texture and reads it again for exposure and motion blur. The replacement stores
`SRGBDecode(sqrt(color))` before that copy, preserving decoded-domain filtering.
The final motion pass returns an sRGB-shaped signal for unchanged HUD blending.
Gamma 2.0 and sRGB are deliberately treated as different transfer functions.

The HDR shoulder preserves values up to game white and compresses brighter values
toward the selected peak. Exposure, saturation, and contrast default to 1.0.
Game and UI white are independent. Vanilla scene range bypasses optional grading.

## Build and setup

Close the game before rebuilding a loaded addon.

```powershell
cmake --build --preset clang-x86-debug --target justcause2
```

Output: `build32/Debug/renodx-justcause2.addon32`. Deploy beside `JustCause2.exe`
with the 32-bit ReShade addon loader as `dxgi.dll`.

For a distribution build, use `clang-x86-release` with the same `justcause2`
target. Its output is `build32/Release/renodx-justcause2.addon32`. Generated shader
headers are under `build32/justcause2.include/embed`; they are not source files
to commit. End users need only the game addon and the ReShade addon loader;
DevKit is for development.

On the tested installation, ReShade's delayed system `d3d10.dll` hooks caused an
early exit. A local copy of that machine's `C:\Windows\SysWOW64\d3d10.dll` beside
the executable allowed native rendering. This system DLL is not distributed with
the mod. Existing DXVK loaders and other rendering addons were preserved in backups.

Development also uses `renodx-devkit.addon32`, tools path set to the repository
`bin`, and live path set to `src/games/justcause2`. Keep CSO dumps outside this
source folder. The compiled addon embeds its own shader replacements.

Use ReShade's Add-ons panel, **RenoDX Just Cause 2**, to select Display Output.
HDR10 requires an HDR display with Windows HDR active. Set peak, game white, and
UI white for the display. SDR remains available for comparison.

Peak Brightness supports 80–4000 nits. Use the display's calibrated peak in its
actual HDR gaming mode. A 2000-nit setting permits highlights toward that level;
it neither forces every scene to reach it nor makes the whole screen that bright.
Game Brightness and UI Brightness default to 203 nits independently of the peak.
The highlight shoulder approaches the selected maximum smoothly. It does not
expand clipped SDR white to the peak automatically.

To disable, close the game and rename `renodx-justcause2.addon32` so its filename
no longer ends in `.addon32`. Restore backed-up loaders separately when returning
to a previous renderer.

## Validation

Completed locally:

- Clang x86 Debug and Release builds including all 25 replacement pixel shaders
  and both SM4 proxy shaders. The runtime observations below used Debug builds.
- Original shader decompilation checks and main/motion 1:1 baseline live loading.
  Moving gameplay captures do not establish pixel-identical output.
- Native D3D10.1 gameplay at 2560×1440 with 8× MSAA after correcting resolve aliases.
  Draw captures confirm FP16 scene, MSAA and proxy clones.
- Post-composite SDR scene readback: finite pixels, bounded to 0–1.
- All 25 replacement pixel shaders compiled and embedded in the addon. The 14 added
  composites and eight motion producers also passed original decompiler
  validation. Six motion producers were observed in 353 draws of one frame.
- HDR10 readback at a 1000-nit configured peak: scene RGB maximum 9.539 in FP16,
  with 30,295 pixels above 1; composed FP16 output also retained values above 1.
  All analyzed textures had zero NaN/Inf pixels. The final RGB10A2 backbuffer was
  PQ encoded and DXGI confirmed PQ/BT.2020 output. These are live resource
  readbacks at separate presents, not synchronized frozen-frame comparisons.
- Packed-motion readback after the new producer patches remained within 0–1.
- SDR/HDR switching, swapchain recreation, and restart into HDR gameplay with
  only the game addon enabled (DevKit disabled).
- Final Debug build includes the effective-output-mode fallback correction.

Outstanding before a stable release:

- Broader fixed-scene SDR fidelity comparisons, menus/video and UI brightness
  comparisons, and settings selecting additional composite variants. A path
  bypassing the motion pass has not been validated.
- Packed-motion clamps restore bounds rather than emulating original 8-bit
  quantization; compare fast motion and all antialiasing modes for regressions.
- Physical display calibration and sustained highlight behavior. The 2000-nit
  configuration was reviewed mathematically, not measured on a 2000-nit display.

Build success and an HDR-capable swapchain alone are not HDR validation.
