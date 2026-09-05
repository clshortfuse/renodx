Call of Duty: Black Ops Cold War - RenoDX native-HDR scene pass
Target shader: 0xCB76A9C1.ps_6_1

WHY THIS SHADER
---------------
The solid-magenta probe proved 0xCB76A9C1 affects the full visible HDR image.

Its original DXIL proves:
- PostFxCBuffer at b6
- sampler s0
- 2D resources at t0, t2, t3
- 3D LUT at t1
- exposure texture at t5
- native linear HDR composition
- ST.2084/PQ encode
- 32x32x32 LUT half-texel coordinates
- final SV_Target output

WHAT THIS VERSION DOES
----------------------
1. Reconstructs the original shader in readable HLSL.
2. Leaves Tone Mapper = Vanilla as a reconstructed native Cold War path.
3. Inserts RenoDX ToneMapPass before Cold War's native PQ encoding.
4. Keeps the game's native PQ encoder and native 32^3 LUT.
5. Uses max(color, 0) before fractional power/PQ math.
6. Registers ONLY 0xCB76A9C1 in addon.cpp to avoid the earlier guessed shader set.

SCENE SLIDERS THAT THIS PASS CONSUMES
-------------------------------------
- Tone Mapper
- Peak Brightness
- Game Brightness
- Gamma Correction
- Scaling
- Working Color Space
- Hue Processor
- Hue Correction
- Hue Shift
- Clamp Color Space
- Clamp Peak
- Exposure
- Highlights
- Shadows
- Contrast
- Saturation
- Highlight Saturation
- Blowout
- Flare
- Scene Grading

IMPORTANT
---------
UI Brightness is NOT independently solvable from this one fullscreen scene pass.
It needs a separately proven UI/HUD shader so UI can be scaled without changing the scene.

Tone Mapper defaults to RenoDRT in this package so the sliders visibly respond.
Choose Vanilla for the reconstructed original Cold War HDR path.

INSTALL / LIVE TEST
-------------------
Use these three live/build source files together:
- addon.cpp
- shared.h
- tonemap_0xCB76A9C1.ps_6_1.hlsl

Remove/rename the old:
- tonemap_0x54F7D5AB.cs_6_1.hlsl
- ui_0xCF31DF83.ps_6_1.hlsl
- probe shaders

from the DevKit LivePath while testing, so only the intended CB76 replacement is live.

Expected DevKit line:
Compiling file: ...\tonemap_0xCB76A9C1.ps_6_1.hlsl, hash: 0xcb76a9c1, target: ps_6_1

FIRST TEST
----------
1. Start in Vanilla and verify the image is sane.
2. Switch Tone Mapper to RenoDRT.
3. Move Exposure dramatically.
4. Move Saturation dramatically.
5. Change Peak Brightness (e.g. 600 vs 1500).
6. Change Game Brightness.
7. Lower Scene Grading to confirm the native 3D LUT blend responds.

If Vanilla is wrong, stop there: that means one reconstructed native operation differs.
If Vanilla is correct but RenoDRT is wrong, the target shader is correct and only the
RenoDX-domain scaling/working-space bridge needs adjustment.

COMPILE FIX
-----------
This revision explicitly includes:
    ../../shaders/renodx.hlsl
inside tonemap_0xCB76A9C1.ps_6_1.hlsl.

This fixes:
    use of undeclared identifier 'renodx'
at renodx::draw::Config / renodx::draw::ToneMapPass.
