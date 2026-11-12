Call of Duty: Black Ops Cold War - native HDR RenoDX mod

ACTIVE SHADERS
0xCB76A9C1.ps_6_1: scene composition, scene LUT, shared grading and the
                   selected mapper above the knee.
0xA93248D1.ps_6_1: late PQ LUT, black correction, highlight extension and output.
0xE6F6BF3D.ps_6_1: generic UI image quad, also used for full-screen black fades.
All three are registered in addon.cpp. Vanilla retains the reconstructed native paths.

BLACK FADES (0xE6F6BF3D, ui_black_0xE6F6BF3D.ps_6_1.hlsl)
The start-of-mission/cutscene black screen is a ~98-99.96% opaque black quad
drawn by this shader with straight alpha over the HDR scene. 2026-10-20 capture:
scene-pass output averaged ~17 nits (peaks ~2500), the quad transmitted 0.04%,
and the final output still showed the scene at up to ~0.4-0.6 nits; earlier in
the fade far more. In custom modes, black pixels only get transmission
t' = t^k, k = 1 + log2(Peak / Game Brightness) / log2(50) (~1.66 at 2700/203),
so a 98%-opaque black hides peak highlights as well as it hid SDR white.
Verified live: that screen became fully black apart from subtitles.
Not yet checked: other UI black elements drawn by this shader (letterbox bars,
text shadows, dark panels become slightly more opaque) and fades into menus.
0xEAF106A3 (a sibling UI image shader with clip-rect alpha) is not used by this
fade; a separate experimental copy of it was seen in the DevKit probe folder.

SCENE PASS (0xCB76A9C1) - port of CODWW2MapHDR / CODWW2MapShoulder
The scene LUT (t1) is the vanilla tonemapper: absolute PQ in, linear game units
out (1.0 = 100 nits). 2026-10-20 neutral-ramp probe: a continuous filmic curve,
octave log-slopes 0.79-0.94 from 100 to 1600 nits, 0.68 and 0.46 above, about
2575 nits at PQ 1.0.
Previously the custom path ran the selected mapper FIRST and this LUT after it,
so highlights were tone-mapped twice: PsychoV30 at a 2700-nit peak mapped
10,000 -> 2125 nits and the LUT then took that to ~1212 (1000 -> 544; the LUT
alone gives 688). The PQ/linear lerp used for Scene Grading was also removed.
Now, as in WWII:
1. The live LUT runs first. An octave walk from 100 nits follows its neutral
   response until the output would pass the mapper knee or half the LUT's own
   maximum. WWII's 0.9 near-linear test is not used here: this LUT never becomes
   near-linear, so that test would stop at the first octave. Below the walk end
   the LUT is used as-is; above it luminance continues at the last octave slope
   (capped at 1.5). Grade colour comes from one octave below the walk end.
   Scene Grading blends native LUT colour with the neutral LUT response.
2. Shared grading (Exposure, Highlights, Shadows, Contrast, Flare, Saturation)
   runs once for all mappers, with WWII's parameter conventions.
3. The selected mapper (RenoDRT, PsychoV30, Prism) compresses only above the
   knee, 45% of Peak Brightness and never below Game Brightness, with its 0.18
   anchor translated to the knee. Highlight Saturation and Blowout follow.
4. RenderIntermediatePass as before; output in the LUT's units for the late pass.
Measured live at Peak 2700 / Game 203 / PsychoV30 (scene pass output, nits):
scene 400 -> 312, 1000 -> 688, 2000 -> 1175, 3000 -> 1538, 10000 -> 2200
(was 288, 544, 769, 912, 1212). Through the late pass: 1000 -> ~665,
2000 -> ~1125, 10000 -> ~2068 (was 531, 741, 1155). Gameplay swapchain peak
rose from ~1400-1600 to ~2500 nits. Below ~200 nits the output is unchanged.
Saturated red/green/blue/orange ramps stay monotonic; PsychoV30 desaturates
toward the peak as in WWII's per-channel path.

LUT COMPARISON AND CHANGES
Compared against these implementations in this checkout:
- aptinnocence/tonemap10_0xABA0921A.ps_5_0.hlsl samples the LUT black endpoint,
  decodes PQ and uses lut::CorrectBlack to remove a measured luminance floor.
- cp2077/tonemapper.hlsl and thewitcher3/lutsampling.hlsl sample LUT reference
  values and use lut::Unclamp / RecolorUnclamped to correct endpoints.
- bulletstormfullclip/common.hlsl samples a bounded SDR reference, then uses
  UpgradeToneMap to restore HDR energy while carrying the LUT grade forward.

Cold War's late LUT already takes and returns absolute HDR PQ. SDR LUT scaling
or UpgradeToneMap cannot simply be substituted without a matched SDR reference.
The late pass therefore keeps the native centered 32-cubed sampling and uses:

1. Measured black: sample PQ black at LOD 0, decode it and the graded pixel to
   nits, subtract the measured BT.2020 luminance floor, and scale RGB uniformly.
   This replaces the fixed 0.005-0.20 nit fade to ungraded PQ. It retains graded
   RGB ratios and adapts to the current LUT. A zero floor is a no-op. Intentional
   LUT black lift is also removed; this is deliberately part of the custom look.
2. Highlight extension (port of CODWW2MapHDR, see CODWW2/hdr.hlsli and its
   README): the live LUT's shoulder is located per frame by walking octaves of
   the neutral response from 100 nits until the log-slope drops below 0.9 or
   the LUT passes 50% of its own maximum (PQ 1.0). Below the shoulder the LUT
   is used as-is; above it luminance continues at the LUT's last near-linear
   slope (capped at 1.5), so each level's grade exposure is preserved. Grade
   colour is sampled one octave below the shoulder, keeping colour and
   luminance continuous and no channel at the LUT ceiling.
   2026-10-20 DevKit probe: the tested level's LUT tops out at 1001 nits and
   compresses from ~400 nits (neutral 1000 -> 709). The walk stops at 400 nits
   (100->200->400 log-slopes 0.965/0.967; 400->800 0.692) and continues at
   0.967: 1000 -> ~955, 2000 -> ~1866 nits at a 2700-nit peak.
   Superseded: the original 40%-85% of display-peak recovery window left that
   compression unrecovered at high peaks; a 30%-100% of LUT-ceiling blend to the
   raw input worked but discarded the LUT's own highlight exposure.
   Cost: up to ~10 extra LOD-0 LUT fetches per pixel above 100 nits; the walk
   addresses are uniform across the frame.
3. Continuous peak shoulder: start at 99% of display peak and asymptotically
   approach peak. The old overshoot-only mapping jumped down to 99% immediately
   above peak. At 800 nits, 792 is unchanged, 800 maps to about 797.06, and 808
   maps to about 798.92. RGB ratios remain unchanged by the shoulder.
4. Clamp custom output to nonnegative PQ as well as the display peak AFTER the
   original dither/quantization. Vanilla retains the original quantization.

Cost: one extra 3D LUT fetch (black endpoint) plus the shoulder walk above. Native sampling remains trilinear;
tetrahedral interpolation is a separate quality/performance choice and does not
by itself fix a raised endpoint or recover brightness removed by the LUT.

VALIDATION / LIVE TEST
Compile both shaders with DXC: -T ps_6_1 -HV 2021 -O3 -E main.
Keep shared.h, prismTM.hlsl and the repository shader includes available.

In-game checks still required (synthetic checks cannot validate the game's LUT):
- Compare Vanilla with the previous version at identical game HDR settings.
- In custom modes inspect a dark neutral ramp, coloured shadows and scene changes.
  Check that intentional shadow detail survives measured-floor removal.
- Compare bright clouds, lamps and saturated effects at 400/800/1500 nit peaks.
  Check for banding or noise revealed by stronger highlight recovery.
- Test RenoDRT, PsychoV30 and PrismTM, plus menus/HUD and scene grade strength.
  This late full-screen correction can also affect UI already in the source.
- Use a float HDR capture to inspect the result; an SDR screenshot is insufficient
  to establish absolute nit levels or the correctness of the native HDR convention.

The shared PsychoV30 and prism() implementations are unchanged. Neither pass can
recover detail already clipped by an earlier pass. The LUT domain is treated as
BT.2020 for luminance weights (it feeds the HDR10 output); this was not proven
by a capture. Validated live in one level only; check other levels, interior/
exterior transitions, RenoDRT/Prism, and the grading sliders after the rebuild.
