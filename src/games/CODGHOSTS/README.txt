Call of Duty: Ghosts - Pragmap V2 tonemappers (UNMODIFIED Pragmap core)

What this package does
======================
This variant keeps PragmapV2.hlsl COMPLETELY UNMODIFIED.

The five tonemappers still expose the Pragmap addon controls, but the controls
are handled externally in the tonemappers:

- Hue Strength
- Blowout
- Shoulder
- Shoulder Compression

Behavior
========
Hue Strength and Blowout
------------------------
These still feed directly into the ORIGINAL pragmap() function:

    pragmap(color, peak, hueStrength, blowoutStrength)

The expanded upper-range mapping from the previous package is preserved so the
controls remain easy to see in-game.

Shoulder and Shoulder Compression
---------------------------------
Because PragmapV2.hlsl is untouched, its internal 0.8 shoulder and internal
compression behavior remain hardcoded.

So in this package, Shoulder and Shoulder Compression are applied as an
OPTIONAL EXTRA post-Pragmap overshoot stage using overshootCorrection().

Defaults are chosen so the stage is bypassed by default:

    Shoulder             = 80% -> 0.80
    Shoulder Compression = 75% -> 0.75

At those defaults, the output matches the original Pragmap output exactly.
Moving those controls applies an extra post-Pragmap shaping stage.

Files included
==============
- PragmapV2.hlsl  (original, unmodified)
- shared.h
- addon.cpp
- tonemapper_0x9B6E3C62.ps_5_0.hlsl
- tonemapper2_0x3953C72A.ps_5_0.hlsl
- tonemapper3_0xE73A0FFC.ps_5_0.hlsl
- tonemapper4_0xF008CC1D.ps_5_0.hlsl
- tonemapper5_0xD1DAA81A.ps_5_0.hlsl
