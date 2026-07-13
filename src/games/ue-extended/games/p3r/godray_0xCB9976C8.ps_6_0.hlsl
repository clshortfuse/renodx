#include "../postfx.hlsli"

Texture2D<float4> t0 : register(t0);

cbuffer cb0 : register(b0) {
  float2 $Globals_000 : packoffset(c000.x);
  float2 $Globals_008 : packoffset(c000.z);
  float2 $Globals_016 : packoffset(c001.x);
  float2 $Globals_024 : packoffset(c001.z);
  int2 $Globals_032 : packoffset(c002.x);
  int2 $Globals_040 : packoffset(c002.z);
  float2 $Globals_048 : packoffset(c003.x);
  float2 $Globals_056 : packoffset(c003.z);
  float2 $Globals_064 : packoffset(c004.x);
  float2 $Globals_072 : packoffset(c004.z);
  float2 $Globals_080 : packoffset(c005.x);
  float2 $Globals_088 : packoffset(c005.z);
  float2 $Globals_096 : packoffset(c006.x);
  float2 $Globals_104 : packoffset(c006.z);
  float2 $Globals_112 : packoffset(c007.x);
  float2 $Globals_120 : packoffset(c007.z);
  float2 $Globals_128 : packoffset(c008.x);
  float2 $Globals_136 : packoffset(c008.z);
  int2 $Globals_144 : packoffset(c009.x);
  int2 $Globals_152 : packoffset(c009.z);
  float2 $Globals_160 : packoffset(c010.x);
  float2 $Globals_168 : packoffset(c010.z);
  float2 $Globals_176 : packoffset(c011.x);
  float2 $Globals_184 : packoffset(c011.z);
  float2 $Globals_192 : packoffset(c012.x);
  float2 $Globals_200 : packoffset(c012.z);
  float2 $Globals_208 : packoffset(c013.x);
  float2 $Globals_216 : packoffset(c013.z);
  float2 $Globals_224 : packoffset(c014.x);
  float2 $Globals_232 : packoffset(c014.z);
  float2 $Globals_240 : packoffset(c015.x);
  float2 $Globals_248 : packoffset(c015.z);
  int2 $Globals_256 : packoffset(c016.x);
  int2 $Globals_264 : packoffset(c016.z);
  float2 $Globals_272 : packoffset(c017.x);
  float2 $Globals_280 : packoffset(c017.z);
  float2 $Globals_288 : packoffset(c018.x);
  float2 $Globals_296 : packoffset(c018.z);
  float2 $Globals_304 : packoffset(c019.x);
  float2 $Globals_312 : packoffset(c019.z);
  float2 $Globals_320 : packoffset(c020.x);
  float2 $Globals_328 : packoffset(c020.z);
  float2 $Globals_336 : packoffset(c021.x);
  float2 $Globals_344 : packoffset(c021.z);
  float2 $Globals_352 : packoffset(c022.x);
  float2 $Globals_360 : packoffset(c022.z);
  int2 $Globals_368 : packoffset(c023.x);
  int2 $Globals_376 : packoffset(c023.z);
  float2 $Globals_384 : packoffset(c024.x);
  float2 $Globals_392 : packoffset(c024.z);
  float2 $Globals_400 : packoffset(c025.x);
  float2 $Globals_408 : packoffset(c025.z);
  float2 $Globals_416 : packoffset(c026.x);
  float2 $Globals_424 : packoffset(c026.z);
  float2 $Globals_432 : packoffset(c027.x);
  float2 $Globals_440 : packoffset(c027.z);
  float2 $Globals_448 : packoffset(c028.x);
  float2 $Globals_456 : packoffset(c028.z);
  float2 $Globals_464 : packoffset(c029.x);
  float2 $Globals_472 : packoffset(c029.z);
  int2 $Globals_480 : packoffset(c030.x);
  int2 $Globals_488 : packoffset(c030.z);
  float2 $Globals_496 : packoffset(c031.x);
  float2 $Globals_504 : packoffset(c031.z);
  float2 $Globals_512 : packoffset(c032.x);
  float2 $Globals_520 : packoffset(c032.z);
  float2 $Globals_528 : packoffset(c033.x);
  float2 $Globals_536 : packoffset(c033.z);
  float2 $Globals_544 : packoffset(c034.x);
  float2 $Globals_552 : packoffset(c034.z);
  float2 $Globals_560 : packoffset(c035.x);
  float2 $Globals_568 : packoffset(c035.z);
  float2 $Globals_576 : packoffset(c036.x);
  float2 $Globals_584 : packoffset(c036.z);
  int2 $Globals_592 : packoffset(c037.x);
  int2 $Globals_600 : packoffset(c037.z);
  float2 $Globals_608 : packoffset(c038.x);
  float2 $Globals_616 : packoffset(c038.z);
  float2 $Globals_624 : packoffset(c039.x);
  float2 $Globals_632 : packoffset(c039.z);
  float2 $Globals_640 : packoffset(c040.x);
  float2 $Globals_648 : packoffset(c040.z);
  float2 $Globals_656 : packoffset(c041.x);
  float2 $Globals_664 : packoffset(c041.z);
  float4 $Globals_672 : packoffset(c042.x);
};

cbuffer cb1 : register(b1) {
  float4 MaterialCollection0_000[1] : packoffset(c000.x);
};

cbuffer cb2 : register(b2) {
  float4 MaterialCollection1_000[5] : packoffset(c000.x);
};

cbuffer cb3 : register(b3) {
  float4 Material_000[2] : packoffset(c000.x);
  float4 Material_032[1] : packoffset(c002.x);
};

SamplerState s0 : register(s0);

// DXIL FirstbitHi: returns bit position counting from MSB (leading zeros count)
uint firstbithigh_msb(int value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }
uint firstbithigh_msb(uint value) { return (value == 0) ? 0xFFFFFFFF : (31u - firstbithigh(value)); }


// Undo the lutbuilder's scene scaling
float3 InverseSrgbScale(float3 srgb_color) {
  if (RENODX_DIFFUSE_WHITE_NITS != RENODX_GRAPHICS_WHITE_NITS) {
    srgb_color = ConditionalSrgbDecode(srgb_color);
    srgb_color /= (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS);
    srgb_color = ConditionalSrgbEncode(srgb_color);
  }
  return srgb_color;
}

// Re-apply the scene scaling on output
float3 ScaleScene(float3 color) {
  if (RENODX_DIFFUSE_WHITE_NITS != RENODX_GRAPHICS_WHITE_NITS) {
    color = ConditionalSrgbDecode(color);
    color *= (RENODX_DIFFUSE_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS);
    color = ConditionalSrgbEncode(color);
  }
  return color;
}

float3 InverseScaleSrgbWithTonemap(float3 srgb_color) {
  srgb_color = InverseSrgbScale(srgb_color);  // undo scaling -> sRGB-encoded SDR
  float3 linear_color = ConditionalSrgbDecode(srgb_color);
  linear_color = MaxChTonemapToOne(linear_color);
  return ConditionalSrgbEncode(linear_color);
}

float3 UpgradeToneMapAndScaleScene(float3 srgb_color,
                                   float3 stored_scaled_srgb) {
  float3 linear_color = ConditionalSrgbDecode(srgb_color);
  // Recover the unscaled HDR lutbuilder color in linear bt709.
  float3 tonemapped_linear =
      ConditionalSrgbDecode(InverseSrgbScale(stored_scaled_srgb));

  tonemapped_linear = renodx::tonemap::UpgradeToneMap(
      tonemapped_linear,                     // HDR color from the lutbuilder, decoded to linear bt709
      MaxChTonemapToOne(tonemapped_linear),  // Lutbuilder output tonemapped to 1 as our SDR reference color
      MaxChTonemapToOne(linear_color),       // Output of the PostFX shader
      1.f);

  // Re-encode to sRGB and re-apply the scene scaling.
  return ScaleScene(renodx::color::srgb::EncodeSafe(tonemapped_linear));
}

float4 main(
  precise noperspective float4 SV_Position : SV_Position,
  linear float4 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float _19;
  float _20;
  float4 _31;
  float _42;
  float _49;
  float _59;
  float _67;
  float _77;
  float _81;
  float _82;
  float _83;
  _19 = (SV_Position.x - ((float)((uint)((uint)($Globals_592.x))))) * ($Globals_616.x);
  _20 = (SV_Position.y - ((float)((uint)((uint)($Globals_592.y))))) * ($Globals_616.y);
  _31 = t0.Sample(s0, float2(((_19 * ($Globals_080.x)) + ($Globals_064.x)), ((_20 * ($Globals_080.y)) + ($Globals_064.y))));

  float3 tonemapped = _31.rgb;

  if (PROCESSING_PATH == 1.f) {
    _31.rgb = InverseScaleSrgbWithTonemap(_31.rgb);
  }

  _42 = 1.0f - _20;
  _49 = (_42 * _19) * (MaterialCollection1_000[0].y);
  _59 = ((1.0f - _19) * _42) * (MaterialCollection1_000[0].x);
  _67 = (MaterialCollection1_000[0].z) * _20;
  _77 = (MaterialCollection1_000[0].w) * (1.0f - (MaterialCollection0_000[0].x));
  _81 = (_77 * (((_59 * (MaterialCollection1_000[2].x)) + ((MaterialCollection1_000[4].x) * _67)) + (_49 * (MaterialCollection1_000[3].x)))) + _31.x;
  _82 = (_77 * (((_59 * (MaterialCollection1_000[2].y)) + ((MaterialCollection1_000[4].y) * _67)) + (_49 * (MaterialCollection1_000[3].y)))) + _31.y;
  _83 = (_77 * (((_59 * (MaterialCollection1_000[2].z)) + ((MaterialCollection1_000[4].z) * _67)) + (_49 * (MaterialCollection1_000[3].z)))) + _31.z;
  // Removed max 0
  SV_Target.x = ((((Material_000[1].x) - _81) * (Material_032[0].x)) + _81);
  SV_Target.y = ((((Material_000[1].y) - _82) * (Material_032[0].x)) + _82);
  SV_Target.z = ((((Material_000[1].z) - _83) * (Material_032[0].x)) + _83);


  if (PROCESSING_PATH == 1.f) {
    SV_Target.rgb = UpgradeToneMapAndScaleScene(SV_Target.rgb, tonemapped);
  }

  SV_Target.w = 1.0f;
  return SV_Target;
}