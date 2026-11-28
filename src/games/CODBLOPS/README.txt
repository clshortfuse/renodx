Core-transparent bloom/flare shader set

All seven shaders retain the earlier original-size / transparent-halo changes.

Default core density/alpha cap: 0.70
Halo density/alpha remains at the prior ~0.30-0.35 values.

The two particle shaders 0x1832D7DB and 0x039025BC preserve their RGB path and reduce core alpha separately.
The bloom/additive shaders have no independent opacity channel, so their hot-core bloom contribution is capped to 70% density instead.

PsychoV30 and gamma correction

The PsychoV option now calls the shared test30.hlsl implementation. Compression,
cone response, gamut compression, and gamut selection keep their saved V24 keys.
The tone-mapper dropdown keeps its existing saved selection index.
V30 uses Purity in place of the old PsychoV24 Highlight Saturation control; the
shared Highlight Saturation slider still provides highlight-only grading.
The V24 Gamut Hue Restore control is removed because V30 authors its hue direction
internally. Its DX9 constant slot remains reserved to preserve the c50-c63 layout.

BO1 calibrates PsychoV30's default neutral highlight response against the existing
RenoDRT finite-white curve. The gain fades in between 1x and 4x diffuse white;
lower input values retain the original PsychoV30 response. Compression, cone
response, and purity still modify the result. Peak limiting scales RGB uniformly
in the selected target gamut. This avoids raising exposure to compensate for
PsychoV30's asymptotic shoulder at high display peaks.

BO1's composite writes gamma-2 encoded RGB. The color-grade pass decodes this
transport before the linear-light tonemapper. The Gamma Correction setting runs
after the display mapper, SDR color matching, and post-tonemap grading through
RenderIntermediatePass, which also applies white scaling and output encoding.

Build and manual verification

1. Close Black Ops, then build: cmake --build --preset clang-x86-debug --target CODBLOPS
2. Check build32/CODBLOPS.include/embed/0x357DE7FD.cso and 0x357DE7FD.h were regenerated.
3. Load build32/Debug/renodx-CODBLOPS.addon32 from the folder containing BlackOps.exe
   or BlackOpsMP.exe, restart the game, and check ReShade.log for the loaded addon.
4. Select PsychoV30 and check Compression, Cone Response, Purity, and gamut controls.
5. Compare Gamma Correction Off, 2.2, and BT.1886 in the same scene; check shadows,
   midtones, saturated highlights, and the HUD. Verify Vanilla and RenoDRT still work.
6. Compare PsychoV30 and RenoDRT in the same bright scene at a high peak setting.
   PsychoV30 highlights should use comparable headroom while shadows stay unchanged.
