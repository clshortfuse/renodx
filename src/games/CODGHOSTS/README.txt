COD Ghosts - Auto Exposure Adaptation Speed Slider

Files included:
- 0xBAF5EC49.ps_5_0.hlsl
- shared.h
- addon.cpp

What changed:
1. Added a new RenoDX slider: Auto Exposure Adapt Speed
2. Added a new injected field in shared.h:
   auto_exposure_adaptation_speed
3. Rewrote the exposure adaptation shader in a human-readable form.
4. The slider directly scales the temporal adaptation step:
   100% = original game speed
    35% = calmer default for HDR
     0% = effectively frozen exposure

Important:
- This shader is the temporal eye-adaptation pass, not the final tonemapper.
- You should save 0xBAF5EC49.ps_5_0.hlsl over the actual hash filename for this shader once you identify it in your project/trace.
- shared.h and addon.cpp are based on the current CODGHOSTS_AutoExposureStrength version.

Suggested starting values:
- Auto Exposure Strength: 60%
- Auto Exposure Adapt Speed: 35%

If adaptation still flickers too much:
- Lower Adapt Speed first.
- If the exposure amount is still too aggressive, then lower Auto Exposure Strength too.
