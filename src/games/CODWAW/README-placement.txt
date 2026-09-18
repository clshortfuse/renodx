Call of Duty: World at War - Psycho replacement + Pragmap

Tone mapper modes:
  Vanilla
  RenoDRT
  Psycho
  Pragmap

PsychoV24 has been removed entirely.
The Psycho mode uses the supplied psychov.hlsl implementation.

Generic Psycho integration names:
  psycho_compression
  psycho_cone_response
  psycho_purity
  psycho_gamut_compression
  psycho_gamut_mode

File name remains:
  shaders/tonemap/psychov/psychov.hlsl

DX9 injection layout:
  c50-c59 remains stable.
  c60:
    x = Psycho Purity
    y = Pragmap Hue Strength
    z = Pragmap Blowout Strength
    w = padding

V5 direct-output behavior retained:
  Game Brightness 203 nits = identity baseline.
  Gamma Correction 2.2 = identity baseline.
  No RenderIntermediatePass / EncodeColor / color-space conversion.

Placement:
  addon.cpp -> game addon source
  shared.h -> game shared header
  tonemapper_renodrt_psycho_pragmap.ps_3_0.hlsl -> replacement tonemapper
  pragmap.hlsl -> beside the game tonemapper/shared.h
  psychov.hlsl -> shaders/tonemap/psychov/psychov.hlsl
