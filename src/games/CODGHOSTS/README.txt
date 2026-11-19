COD Ghosts - Shared tone-mapper basis (updated 2026-10-01)

All seven tone-mapper shaders now include common.hlsl. This replaces the
duplicated extension/reconstruction pipelines described in the older notes below.
- Passes 1-5 use the supplied extended UC2/Hable basis, with the tangent at
  output midgray 0.18 and the game's separate RGB coefficients retained.
- LUT passes 1/2/5 use Neutwo max-channel compression, the original 16-cube LUT
  coordinates, and division by the same scale to reconstruct HDR after grading.
- Passes 3/4 use the same extended UC2 basis without inventing a LUT.
- Pass 6 retains its encoded-space analytic grade; pass 7 retains its native
  adaptive dual-power curve and 32-cube LUT. Their HDR grading uses the same
  bounded proxy and scale reconstruction as the Hable/LUT passes.
- The selectable modes are Vanilla (0), RenoDRT (3), and Prism (4). The old
  Pragmap selection now maps to Prism, retaining the saved selection index.
  Vanilla retains the original curve/grade. RenoDRT still uses the extended UC2
  and smooth Reinhard shoulder; its shoulder now begins at diffuse white (1.0)
  instead of output midgray (0.18). This preserves more upper-midtone and highlight
  brightness without raising exposure, UI white, or the configured HDR peak.
  The Scaling control selects luminance or per-channel rolloff. Luminance mode
  limits RGB uniformly at peak to preserve saturated highlight chromaticity.
- prismTM.hlsl imports the provided MIT-licensed Prism inset matrix, per-channel
  smooth Reinhard curve at anchor 0.18, and outset matrix. It shares the existing
  guarded rolloff instead of duplicating that function. The supplied unused
  adaptation-contrast helper is not part of Prism's tone-mapping path.
  Any outset overshoot is limited uniformly to peak. Prism uses the general color
  controls; obsolete Pragmap-specific controls were removed from the addon UI.
  Retired Pragmap fields stay in shared.h to preserve injected-buffer offsets.
- All seven passes now finish through RenderIntermediatePass, restoring Game
  Brightness / UI Brightness normalization and the configured gamma/encoding.
  Passes 1-5 retain their authored encoded output-range adjustment. This is
  decoded back to linear before RenoDX's output stage, so it is not encoded twice.
  Passes 6/7 also normalize their native encoded Vanilla output through that stage.
  SDR clipping happens before scene/UI scaling, preserving Vanilla brightness
  above UI white. Source alpha and each pass's distortion are preserved.
- The HDR peak is corrected into the output stage's input gamma domain so the
  later gamma correction does not reduce the configured absolute peak in nits.
- Shared IEEE bit checks guard NaN/INF without relying on FXC's isfinite()
  optimization. Divisions, powers, roots, LUT scales, perceptual color stages,
  distortion coordinates, and final RGB retain finite/FP16 protection. Signed
  Lab/JzAzBz chroma and the AP1 saturated-color guard are retained.
- Local FXC compilation passed for all seven after the Prism replacement and
  brighter RenoDRT shoulder. The CODGHOSTS Clang debug addon target also built
  successfully with Ghosts closed. The rebuilt renodx-CODGHOSTS.addon64 was copied
  into the game folder; its SHA256 matches the build artifact. The previous
  installed addon and edited sources are backed up in this chat's workspace.
  In-game appearance/slider confirmation is pending.
  In game, select Prism in Tone Mapper, then compare RenoDRT at the same exposure
  and peak. Keep the camera fixed: adjust UI Brightness with Game Brightness held,
  then Game Brightness with UI held. Compare neutral and saturated highlights in
  RenoDRT/Prism, then confirm Vanilla brightness and gamma controls still work.
- Rebuild after closing the game: cmake --build --preset clang-x64-debug --target CODGHOSTS
  Artifact: renodx-CODGHOSTS.addon64; inspect the seven 0xHASH.h shader embeds.
  Rebuild with Ghosts closed; shader-only reloads cannot update the addon UI label.

Bloom mode selection (2026-10-01):
- Effects > Bloom Mode offers Vanilla and Energy-Conserving. Vanilla is the
  default and restores the original threshold, full Gaussian blur passes, and
  game-controlled composite. The broken HDR peak-preserving mode is removed.
- Energy-Conserving keeps the threshold-free scene-to-blur lerp. Bloom Blend
  defaults to 30%; Bloom Internal Blend defaults to 85%. These sliders apply
  only to Energy-Conserving and are disabled while Vanilla is selected.
- The BloomCompositeMode saved key keeps index 0 for Energy-Conserving. Existing
  index 1 settings now use Vanilla. The injection layout keeps the same offsets.
  All seven tonemappers share this upstream switch.
- Manual comparison: switch modes around a bright light with the camera fixed.
  In Energy-Conserving, Bloom Blend at 0% leaves the source scene unchanged.
- Rebuild CODGHOSTS with the command above for the updated UI and shaders.

Earlier implementation notes:

COD Ghosts - Auto Exposure

Auto Exposure Mode (Intermediate/Advanced settings):
- HDR Smooth (default): filters exposure changes in log2 stops using the existing
  history, then applies the game directional movement limits and exposure bounds.
- Original: retains the previous movement limiter; 100% speed is game behavior.
- Vanilla tone mapper always uses original adaptation at full speed.

Auto Exposure Adapt Speed defaults to 20%. Start there, increasing it if room
transitions feel slow. 0% holds exposure subject to the current game bounds.
Smoothing retains the steady-state target and does not clamp HDR scene colors.
The game timing factor is reused; its units have not been verified in a capture.
The separate, hidden Auto Exposure Strength setting is unchanged.

Verification:
- Build: cmake --build --preset clang-x64-debug --target CODGHOSTS
- Artifact: renodx-CODGHOSTS.addon64; shader embed: 0xBAF5EC49.h.
- Confirm the replacement is active in game. Compare Original and HDR Smooth at
  the same speed in a flickering scene, then test dark/bright room transitions.
- Check 0% hold, Original at 100%, Vanilla, and multiple frame rates.
- If flicker persists at 0% with stable exposure bounds, investigate other
  adaptive tonemap paths, particularly the t4-driven blend in tonemapper7.
- Shader compilation and numerical response checks do not replace in-game QA.

LUTless Hable extension (passes 3/4):
- Preserve the complete SDR reference, including the encoded output-range
  adjustment, and the existing SDR reconstruction stage.
- lutless_extension.hlsl locates output midgray (0.18) by directly inverting
  the output-range adjustment and Hable quadratic, then samples the first
  derivative there for linear continuation. No inflection search is used.
- Live DevKit inspection of 0xE73A0FFC found scene input 0.18 mapped to about
  0.003 output; actual output midgray was near input 1.24 for that scene.
  These are measured examples, not hardcoded calibration values.
- FXC ps_5_0 compilation passed for 0xE73A0FFC and 0xF008CC1D. Numerical checks
  with captured constants passed continuity, slope matching, unchanged lower
  curve, and finite monotonic HDR extension. DevKit activated the replacements.
- User confirmed the active 0xE73A0FFC scene matches with improved highlights.
  0xF008CC1D shares the fix but still needs its own in-game scene check.
- Tonemapper 6 and LUT paths retain their previous behavior.
- Build: cmake --build --preset clang-x64-debug --target CODGHOSTS
  (after closing the game). Inspect 0xE73A0FFC.h and 0xF008CC1D.h in the shader
  embeds and renodx-CODGHOSTS.addon64. This session used live shaders; no addon
  rebuild was performed. Check both RenoDRT and Pragmap across other scenes.

LUT Hable extension (passes 1/2/5):
- lut_extension.hlsl finds per-channel scene inputs mapping to pre-LUT output
  midgray (0.18). The existing analytical derivative is evaluated at those
  inputs. LUT sampling, strength, compression and HDR reconstruction are unchanged.
- Live pass 0x9B6E3C62 measured pivots near 0.163/0.163/0.146 in the tested scene;
  GPU readback confirmed each maps to 0.18. These values are not hardcoded.
- FXC ps_5_0 compilation passed for 0x9B6E3C62, 0x3953C72A and 0xD1DAA81A.
  Captured-constant checks passed inverse accuracy, derivative accuracy,
  continuity, and finite monotonic extension. DevKit activated all replacements.
- User confirmed the live pass 1 scene still matches. Passes 2/5 need their own
  scene checks. Adaptive pass 7 is unchanged. No addon rebuild was performed.
- Use the CODGHOSTS build target above after closing the game; inspect generated
  embeds 0x9B6E3C62.h, 0x3953C72A.h and 0xD1DAA81A.h. Compare Vanilla/RenoDRT/
  Pragmap, LUT strength, neutral and saturated highlights across LUT scenes.

LUTless highlight color preservation update:
- The pass 3/4 tangent extension is unchanged.
- Saturated highlights now take their chromaticity from the original SDR Hable
  curve at the extension boundary along the same input RGB ray, then scale that
  color to the HDR extension luminance.
- This prevents independently extended R/G/B channels from converging toward
  neutral white while preserving the brighter HDR highlight separation.
- The correction fades in from the extension boundary and reaches full strength
  around 1.5x the boundary input; neutral highlights remain neutral.
- HDR rolloff now scales luminance uniformly and caps max RGB at the configured
  peak, preserving saturated highlight ratios through RenoDX Highlights changes.
- The SDR reference uses the vanilla exposure path with the same RenoDX grading
  controls, keeping it tied to the original SDR midtone response.
- The SDR reconstruction stays exact through diffuse white, then fades out over
  0.5 HDR stops so clipped SDR white no longer washes out HDR highlights.
- FXC ps_5_0 compilation passed for both shaders after this update. Runtime
  comparison is pending; recheck SDR midtones and colored highlights in passes
  3/4, then raise RenoDX Highlights and confirm saturated lights retain color.

Bloom blend:
- The game's bloom chain starts with 0xD4F78522, a four-tap half-resolution
  downsample, then applies horizontal and vertical blur passes (0xEDF36DE8 and
  0xC9F99849) before compositing through 0xFA5D6514.
- The original downsample had a luminance soft-knee threshold in its RGB
  prefilter. Vanilla uses the original weight:
  alpha * (1 + cb2[0].x / max(alpha * luminance, -cb2[0].x)).
  Its zero-denominator case is guarded. Energy-Conserving removes that gate.
  Both modes preserve the original unthresholded average-luminance alpha for
  the exposure reduction chain and the original FP16 storage limit.
- Vanilla returns the complete Gaussian result from both blur passes and
  restores the composite RGB = blur * cb2[0].w + cb2[0].x, alpha = cb2[0].y.
  These paths were reconstructed from original game bytecode whose CRC32
  matches all four shader hashes. Custom bloom sliders do not affect Vanilla.
- Energy-Conserving scales blur RGB and output alpha by Bloom Blend. With the
  original ONE / INV_SRC_ALPHA blend state, this gives lerp(scene, blur, blend).
  The default blend is 30%. All seven tonemappers share this upstream pass.
- Ghosts has a half-resolution separable Gaussian blur, not the article's
  multi-resolution upsample pyramid, and exposes no native internal-blend
  control. Bloom Internal Blend approximates it by mixing each confirmed bloom
  blur pass between its input and its Gaussian result. The default is 85%; lower
  values retain more sharp HDR detail, while the existing kernel and HDR range
  are preserved. This changes blur contribution rather than the actual radius.
  The Energy-Conserving composite can reduce local HDR peaks as light spreads
  into nearby pixels. There is no peak-preserving residual extraction path.
- 0xB59B6B8D is a generic scene copy used outside the bloom composite and is
  intentionally left untouched. 0xD4F78522 creates the half-resolution source
  reused by bloom and exposure metering; its average-luminance alpha is preserved
  in both modes.
- DevKit capture identified 0xEDF36DE8 and 0xC9F99849 as the actual bloom blur
  passes. They were compiled and activated with the 85% internal mix; the
  unrelated 0x5FABC89E blur shader was not targeted.
- Earlier DevKit captures established the pass bindings and composite blend
  state. The new Vanilla/Energy-Conserving switch needs an in-game comparison.
