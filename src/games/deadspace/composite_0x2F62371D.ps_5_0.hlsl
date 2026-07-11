#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Sun Jun 21 01:25:35 2026
Texture2D<float4> t10 : register(t10);  // 1x1 rgba9_unorm

Texture3D<float4> t9 : register(t9);  // 1x1x1 rgba8_unorm

Texture2D<float4> t1 : register(t1);  // UI / HUD layer

Texture2D<float4> t0 : register(t0);  // Scene color, normalized around SDR reference white

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[9];
}

// Composite pass notes:
// - Samples scene color from t0 and treats 1.0 as 100 nits.
// - Optionally composites UI from t1 over the scene.
// - Optional post blocks are selected by bits in cb0[4].y.
// - Final output is linear scRGB, where 1.0 represents 80 nits,
//   so 100 nit scene white becomes 1.25.

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  o0.w = 1;

  // Scene input. Clamp away negative values, then convert from normalized scene
  // scale to absolute luminance-ish units where 1.0 == 100 nits.
  r0.xyz = t0.SampleLevel(s0_s, v1.xy, 0).xyz;

#if 0
  o0.rgb = r0.rgb;
  o0.rgb *= 10000.f / 80.f;
  return;
#endif

  // r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = float3(100, 100, 100) * r0.xyz;

  // Feature bits from cb0[4].y:
  //   bit 3  (8):  composite UI/HUD
  //   bit 0  (1):  HDR color/appearance adjustment block
  //   bit 4 (16):  screen-space dithering / chroma noise block
  //   bit 1  (2):  3D LUT block
  r1.xyzw = asint(cb0[4].yyyy) & int4(8, 1, 16, 2);

  // Composite UI over scene. UI RGB is pre-scaled by cb0[3].y, and alpha is
  // scaled by cb0[3].z before attenuating the scene behind it.
  if (r1.x != 0) {
    float4 ui = t1.SampleLevel(s2_s, v1.xy, 0);

    float3 ui_color = ui.rgb;

    if (RENODX_SDR_EOTF_EMULATION_UI != 0.f) {
      ui_color = renodx::color::correct::GammaSafe(ui_color);
    }

    if (OVERRIDE_UI_BRIGHTNESS == 0.f) {
      ui_color *= cb0[3].y;
    } else {
      ui_color *= RENODX_GRAPHICS_WHITE_NITS / 100.f;
    }
    float ui_alpha = ui.a * cb0[3].z;

    if (CUSTOM_SHOW_UI == 0.f) {
      ui_color = 0.f;
      ui_alpha = 0.f;
    }

    r0.rgb = r0.rgb * (1.f - ui_alpha) + ui_color;
  }

  // Optional HDR color adjustment path.
  // The repeated constants 0.159301758 / 18.8515625 / 18.6875 / 0.8359375
  // are ST.2084/PQ constants. This block moves through PQ-coded values and
  // a LMS/IPT-like opponent color space to apply user/display controls from
  // cb0[6], cb0[7], and cb0[8], then returns to linear luminance units.
  if (r1.y != 0) {
    // Original shader PQ-encoded and immediately decoded the current 100-nit scale.
    r2.rgb = r0.rgb / 100.f;

    // Convert through sRGB-style transfer so the following matrix/color
    // controls operate on display-encoded values.
    // r3.xyz = float3(100, 100, 100) * r2.xyz;
    // r4.xyz = float3(1292, 1292, 1292) * r2.xyz;
    // r3.xyz = log2(r3.xyz);
    // r3.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r3.xyz;
    // r3.xyz = exp2(r3.xyz);
    // r3.xyz = r3.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    // r2.xyz = cmp(float3(3.13080018e-05, 3.13080018e-05, 3.13080018e-05) >= r2.xyz);
    // r2.xyz = r2.xyz ? r4.xyz : r3.xyz;
    r2.rgb = renodx::color::srgb::EncodeSafe(100.f * r2.rgb);

    // r2.xyz = float3(-0.5, -0.5, -0.5) + r2.xyz;
    // r0.w = cb0[6].w * cb0[7].z + 1;
    // r2.xyz = r2.xyz * r0.www + float3(0.5, 0.5, 0.5);
    // r2.xyz = -cb0[6].www * cb0[7].www + r2.xyz;
    r2.rgb = (r2.rgb - 0.5f) * (1.f + cb0[6].w * cb0[7].z) + 0.5f;
    r2.rgb -= cb0[6].w * cb0[7].w;

    // RGB to LMS/opponent-like space. The large coefficients are the forward
    // matrix used by this color appearance adjustment.
    r0.w = dot(r2.xyz, float3(17.8824005, 43.5161018, 4.11934996));
    r1.x = dot(r2.xyz, float3(3.45565009, 27.1553993, 3.86714005));
    r1.y = dot(r2.xyz, float3(0.0299565997, 0.184309006, 1.46709001));
    r2.w = 0.801109016 * r1.x;
    r3.xy = float2(2.52810001, 1.24827003) * r1.yy;
    r3.x = r1.x * 2.02343988 + -r3.x;
    r4.xyzw = float4(1, 1, 1, 1) + -cb0[6].xyzw;
    r3.z = r4.x * r0.w;
    r3.x = r3.x * cb0[6].x + r3.z;
    r3.y = r0.w * 0.494206995 + r3.y;
    r1.xy = r4.yz * r1.xy;
    r1.x = r3.y * cb0[6].y + r1.x;
    r0.w = r0.w * -0.395913005 + r2.w;
    r0.w = r0.w * cb0[6].z + r1.y;

    // Opponent/LMS back to RGB-like values, with a saturation-style blend
    // controlled by cb0[6].w.
    r3.yzw = float3(-0.130504414, 0.0540193282, -0.00412161462) * r1.xxx;
    r3.xyz = r3.xxx * float3(0.0809444487, -0.0102485335, -0.000365296932) + r3.yzw;
    r3.xyz = r0.www * float3(0.116721064, -0.113614708, 0.693511426) + r3.xyz;
    r3.xyz = -r3.xyz + r2.xyz;
    r3.yz = r3.xx * float2(0.699999988, 0.699999988) + r3.yz;
    r3.x = 0;
    r3.xyz = saturate(r3.xyz + r2.xyz);
    r2.xyz = r4.www * r2.xyz;
    r2.xyz = r3.xyz * cb0[6].www + r2.xyz;
    r2.xyz = float3(-0.5, -0.5, -0.5) + r2.xyz;
    r0.w = 1 + cb0[7].y;
    r2.xyz = r2.xyz * r0.www + float3(0.5, 0.5, 0.5);
    r0.w = cb0[8].x * cb0[6].w + cb0[7].x;
    r2.xyz = r2.xyz + r0.www;

    // srgb decode
    r2.rgb = renodx::color::srgb::DecodeSafe(r2.rgb);
  }

  // Optional screen-space dither/chroma-noise block.
  // Convert linear color to sRGB code values, perturb YCbCr chroma with t10,
  // convert back to RGB, then decode to linear again. This reduces banding in
  // the composite output.
  if (r1.z != 0) {
    r1.xy = cb0[2].xy * v1.xy;

    r2.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);

    r1.xy = trunc(r1.xy);
    r1.xy = cb0[2].zw * r1.xy;
    r1.xyz = t10.SampleLevel(s1_s, r1.xy, 0).xyz;
    r3.x = dot(r2.xyz, float3(0.298999995, 0.587000012, 0.114));  // BT.601 luma
    r0.w = dot(r2.xyz, float3(-0.168699995, -0.33129999, 0.5));
    r2.w = dot(r2.xyz, float3(0.5, -0.41870001, -0.0812999979));
    r1.x = r1.x + r1.y;
    r1.x = saturate(r1.x + r1.z);
    r3.w = 18 * r0.w;
    r3.w = frac(r3.w);
    r1.y = r1.y * 0.5 + -r3.w;
    r1.y = r1.y * r1.x;
    r3.y = r1.y * 0.055555556 + r0.w;
    r0.w = 18 * r2.w;
    r0.w = frac(r0.w);
    r0.w = r1.z * 0.5 + -r0.w;
    r0.w = r0.w * r1.x;
    r3.z = r0.w * 0.055555556 + r2.w;
    r0.w = 1 + -r1.x;
    r4.x = dot(r3.xz, float2(1, 1.40199995));
    r4.y = dot(r3.xyz, float3(1, -0.344139993, -0.714139998));
    r4.z = dot(r3.xy, float2(1, 1.77199996));
    r1.xyz = r4.xyz * r1.xxx;
    r1.xyz = r2.xyz * r0.www + r1.xyz;

    r0.rgb = renodx::color::srgb::DecodeSafe(r1.rgb);
  }

  // Optional 3D LUT. Values are quantized through half-float bit patterns,
  // scaled into the LUT domain with cb0[4].z, and sampled at texel centers.
  if (r1.w != 0) {
    r1.xyz = f32tof16(r0.xyz);
    r1.xyz = (uint3)r1.xyz;
    r1.xyz = cb0[4].zzz * r1.xyz;
    r1.xyz = r1.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
    r0.xyz = t9.SampleLevel(s1_s, r1.xyz, 0).xyz;
  }

  // Convert the internal 100-nit scale to scRGB output scale.
  // scRGB uses 1.0 == 80 nits, so 100 / 80 == 1.25.
  o0.xyz = float3(1.25, 1.25, 1.25) * r0.xyz;

  o0.rgb = renodx::color::bt709::clamp::AP1(o0.rgb);

#if 0
  // normalize and print cbuffers
  o0.rgb *= 80.f;
  {
    int4 debug_flags = asint(cb0[4].yyyy) & int4(8, 1, 16, 2);

    renodx::canvas::Context debug_canvas = renodx::canvas::CreateContext(
        v0.xy,                  // current pixel position in screen space
        float2(24.f, 24.f),     // text origin, top-left offset in pixels
        float2(20.f, 30.f),     // glyph size in pixels
        o0.rgb,                 // existing output color to draw over
        1.f,                    // existing output alpha
        float3(1.f, 1.f, 1.f),  // text color
        1.f,                    // text alpha scale
        1.f);                   // text intensity scale

    renodx::canvas::DrawText(debug_canvas, 'U', 'I', ' ', 'b', 'r', 'i', ':', ' ');
    renodx::canvas::DrawFloat(debug_canvas, cb0[3].y, 1.f, 6.f, false, false);

    renodx::canvas::NewLine(debug_canvas);
    renodx::canvas::DrawText(debug_canvas, 'H', 'D', 'R', ' ', 's', 'a', 't', ':', ' ');
    renodx::canvas::DrawFloat(debug_canvas, cb0[6].w, 1.f, 6.f, false, false);

    renodx::canvas::NewLine(debug_canvas);
    renodx::canvas::DrawText(debug_canvas, 'b', 'r', 'i', ' ', 'o', 'f', 'f', ':', ' ');
    renodx::canvas::DrawFloat(debug_canvas, cb0[7].x, 1.f, 6.f, false, false);

    renodx::canvas::NewLine(debug_canvas);
    renodx::canvas::DrawText(debug_canvas, 'c', 'o', 'n', 't', 'r', 'a', 's', 't', ':', ' ');
    renodx::canvas::DrawFloat(debug_canvas, cb0[7].y, 1.f, 6.f, false, false);

    renodx::canvas::NewLine(debug_canvas);
    renodx::canvas::DrawText(debug_canvas, 's', 'c', 'a', 'l', 'e', ' ', 'p', 'i', 'v', ':', ' ');
    renodx::canvas::DrawFloat(debug_canvas, cb0[7].z, 1.f, 6.f, false, false);

    renodx::canvas::NewLine(debug_canvas);
    renodx::canvas::DrawText(debug_canvas, 'b', 'l', 'a', 'c', 'k', ' ', 'o', 'f', 'f', ':', ' ');
    renodx::canvas::DrawFloat(debug_canvas, cb0[7].w, 1.f, 6.f, false, false);

    renodx::canvas::NewLine(debug_canvas);
    renodx::canvas::DrawText(debug_canvas, 'a', 'd', 'd', ' ', 'o', 'f', 'f', ':', ' ');
    renodx::canvas::DrawFloat(debug_canvas, cb0[8].x, 1.f, 6.f, false, false);

    renodx::canvas::NewLine(debug_canvas, 2.f);
    renodx::canvas::DrawText(debug_canvas, 'b', 'i', 't', ' ', 'm', 'a', 's', 'k', ' ', 'r', 'e', 'g', ' ', 'v', 'a', 'l');

    renodx::canvas::NewLine(debug_canvas);
    renodx::canvas::DrawText(debug_canvas, 'b', '3', ' ', '8', ' ', 'r', '1', '.', 'x', ' ', 'U', 'I', ':', ' ');
    renodx::canvas::DrawInteger(debug_canvas, debug_flags.x);

    renodx::canvas::NewLine(debug_canvas);
    renodx::canvas::DrawText(debug_canvas, 'b', '0', ' ', '1', ' ', 'r', '1', '.', 'y', ' ', 'H', 'D', 'R', ':', ' ');
    renodx::canvas::DrawInteger(debug_canvas, debug_flags.y);

    renodx::canvas::NewLine(debug_canvas);
    renodx::canvas::DrawText(debug_canvas, 'b', '4', ' ', '1', '6', ' ', 'r', '1', '.', 'z', ' ', 'D', 'T', 'H', ':', ' ');
    renodx::canvas::DrawInteger(debug_canvas, debug_flags.z);

    renodx::canvas::NewLine(debug_canvas);
    renodx::canvas::DrawText(debug_canvas, 'b', '1', ' ', '2', ' ', 'r', '1', '.', 'w', ' ', 'L', 'U', 'T', ':', ' ');
    renodx::canvas::DrawInteger(debug_canvas, debug_flags.w);

    o0.rgb = renodx::canvas::GetOutput(debug_canvas).rgb;
  }
  o0.rgb /= 80.f;
#endif

  return;
}
