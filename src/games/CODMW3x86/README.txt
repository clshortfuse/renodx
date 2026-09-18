MW3 - WaW-style bloom workaround

Copy these nine shader files and bloom_legacy_safe.hlsl into the existing
src/games/CODMW3 folder, retaining the helper alongside the shaders, then rebuild
your MW3 addon. Back up the files being replaced first. This source bundle does
not contain a rebuilt addon DLL. The repository has not been modified.

HDR BRIGHTNESS RESTORATION IS RETAINED
All five output shaders still call RestorePostTonemapBloomHeadroom, using the
existing Bloom Strength slider and configured HDR display headroom. Restoration
now runs before intermediate encoding so the source and mapped RGB have matching
linear units. There is no new SDR clamp on the HDR scene outputs. The original
Vanilla-mode clamp remains.

WaW-style changes:
- bloom1: disable grayscale debug output; normalize the bloom-driving RGB copy
  and final bloom RGB by their maximum channel instead of clipping each channel.
- glow: normalize bloom RGB and use WaW's bounded strength curve with MW3's
  glowApply.w; bound alpha to 0-1. Values above white in the scene remain HDR.
- bloom2: normalize texture and vertex RGB independently before modulation;
  bound alpha; bypass depth feathering as in the supplied WaW workaround.
  MW3's sampler and constant registers are retained. Change FEATHER_MODE from 2
  to 0 to restore MW3's original absolute depth feather. Bypassing feather can
  expose hard intersections with geometry.
- blur: included unchanged; preserves intermediate HDR values and filter weights.
  The final glow pass bounds the bloom blend input.

Bloom normalization example: (4, 1.5, 0.25) -> (1, 0.375, 0.0625).
This limits the legacy bloom layer, not the HDR scene. It also limits the bloom
layer's own brightness range; this is the tradeoff in the requested workaround.
MW3's Bloom Strength is not multiplied again in bloom2, since it already controls
HDR restoration in the output shaders.

Validation: all nine shaders compile for ps_3_0 with FXC. Bloom2 also compiles
with FEATHER_MODE=0. Shared ACES loop-variable warnings persist in output shaders.
Checked RGB normalization, bounded strength, and restoration-before-encoding order.

Not yet verified in-game. Test the start of Eye of the Storm with both RenoDRT
and PsychoV24. This workaround bounds source factors for legacy complement
blending; it cannot guarantee every HDR blend is correct, or fix red tint already
introduced by level grading upstream. No global light whitening or level-grade
replacement is included.
