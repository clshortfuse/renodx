#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat Oct 03 23:02:43 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[39];
}




// 3Dmigoto declarations
#define cmp -

// Some levels draw a full-screen vignette through this UI shader: black RGB
// with the vignette in the alpha of a 256x256 BC3 texture that has no mips.
// The texture's content changes only per 4x4 block, and the game samples it
// with point filtering, so at 4K it shows as hard ~60-pixel squares: the
// visible grey grid/blockiness (Vanilla too).
// For that overlay (texture shape plus a quad whose UVs span the screen)
// the alpha is rebuilt with a cubic B-spline over the texture's 4x4 blocks
// (its content is only 64x64 effective), using GatherAlpha so the result does
// not depend on the bound sampler. B-splines are C2-continuous, so no edges or
// seams remain; a ~1 10-bit-step dither breaks residual banding. Other UI is
// unchanged.
bool CODWW2IsVignetteOverlay(float4 position, float2 uv) {
  uint width, height, levels;
  t0.GetDimensions(0, width, height, levels);
  if (width != 256u || height != 256u || levels != 1u) return false;
  float2 uv_per_pixel = float2(ddx(uv.x), ddy(uv.y));
  float2 uv_from_position = position.xy * uv_per_pixel;
  return all(uv_per_pixel > 0.f) && all(abs(uv_from_position - uv) < 0.01f);
}

float4 CODWW2BSplineWeights(float f) {
  float f2 = f * f;
  float f3 = f2 * f;
  float omf = 1.f - f;
  return float4(omf * omf * omf, 4.f - 6.f * f2 + 3.f * f3,
                1.f + 3.f * f + 3.f * f2 - 3.f * f3, f3) / 6.f;
}

// Mean alpha of the central 2x2 texels of one 4x4 block (one gather).
float CODWW2BlockAlpha(int2 block) {
  block = clamp(block, 0, 63);
  float2 uv = (float2(block) * 4.f + 2.f) / 256.f;
  float4 a = t0.GatherAlpha(s0_s, uv);
  return dot(a, 0.25f);
}

// The vignette's content only changes per 4x4 texel block (64x64 effective),
// so a cubic B-spline over block centres rebuilds a smooth, seamless falloff.
float CODWW2SampleSmoothVignetteAlpha(float2 uv) {
  float2 p = uv * 64.f - 0.5f;
  float2 base = floor(p);
  float2 f = p - base;
  float4 wx = CODWW2BSplineWeights(f.x);
  float4 wy = CODWW2BSplineWeights(f.y);
  int2 b = int2(base) - 1;
  float sum = 0.f;
  [unroll] for (int y = 0; y < 4; ++y) {
    float row = CODWW2BlockAlpha(b + int2(0, y)) * wx.x
              + CODWW2BlockAlpha(b + int2(1, y)) * wx.y
              + CODWW2BlockAlpha(b + int2(2, y)) * wx.z
              + CODWW2BlockAlpha(b + int2(3, y)) * wx.w;
    sum += row * wy[y];
  }
  return sum;
}

// Triangular-PDF dither, +-1 step of a 10-bit target.
float CODWW2Dither(float2 position) {
  float a = frac(sin(dot(position, float2(12.9898f, 78.233f))) * 43758.5453f);
  float b = frac(sin(dot(position, float2(39.3468f, 11.1351f))) * 24634.6345f);
  return (a + b - 1.f) / 1023.f;
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  float ui_white = cb3[4].x;
  if (RENODX_TONE_MAP_TYPE != CODWW2_TONE_MAP_TYPE_VANILLA
      && RENODX_PEAK_WHITE_NITS > 0.f && RENODX_GRAPHICS_WHITE_NITS > 0.f) {
    ui_white = min(RENODX_GRAPHICS_WHITE_NITS, RENODX_PEAK_WHITE_NITS);
  }

  bool is_vignette = CODWW2IsVignetteOverlay(v0, v2.xy);
  r0.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  if (is_vignette) r0.w = CODWW2SampleSmoothVignetteAlpha(v2.xy);
  r1.xyzw = v1.xyzw * r0.xyzw;
  r2.xy = asuint(cb3[38].xy);
  r2.zw = cmp(int2(0,0) < (uint2)r2.xy);
  r3.xy = cmp((uint2)r2.xy < int2(4,4));
  r2.zw = r2.zw ? r3.xy : 0;
  if (r2.z != 0) {
    r3.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r1.xyz);
    r4.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
    r5.xyz = log2(r1.xyz);
    r5.xyz = float3(0.416666657,0.416666657,0.416666657) * r5.xyz;
    r5.xyz = exp2(r5.xyz);
    r5.xyz = r5.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r3.xyz = r3.xyz ? r4.xyz : r5.xyz;
    r4.x = dot(float3(17.8824005,43.5161018,4.11934996), r3.xyz);
    r4.y = dot(float3(3.45565009,27.1553993,3.86714005), r3.xyz);
    r4.z = dot(float3(0.0299565997,0.184309006,1.46709001), r3.xyz);
    switch (r2.x) {
      case 1 :      r3.xyz = float3(0,2.02343988,-2.52581);
      r5.xyz = float3(0,1,0);
      r6.xyz = float3(0,0,1);
      break;
      case 2 :      r3.xyz = float3(1,0,0);
      r5.xyz = float3(0.494206995,0,1.24827003);
      r6.xyz = float3(0,0,1);
      break;
      case 3 :      r3.xyz = float3(1,0,0);
      r5.xyz = float3(0,1,0);
      r6.xyz = float3(-0.0122450003,0.0720349997,0);
      break;
      case 0 :      r3.xyz = float3(1,0,0);
      r5.xyz = float3(0,1,0);
      r6.xyz = float3(0,0,1);
      break;
      default :
      r3.xyz = float3(1,0,0);
      r5.xyz = float3(0,1,0);
      r6.xyz = float3(0,0,1);
      break;
    }
    r3.x = dot(r3.xyz, r4.xyz);
    r3.y = dot(r5.xyz, r4.xyz);
    r3.z = dot(r6.xyz, r4.xyz);
    r4.x = dot(float3(0.0809444487,-0.130504414,0.116721064), r3.xyz);
    r4.y = dot(float3(-0.0102485335,0.0540193282,-0.113614708), r3.xyz);
    r4.z = dot(float3(-0.000365296932,-0.00412161462,0.693511426), r3.xyz);
    r3.xyz = max(float3(0,0,0), r4.xyz);
    r4.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r3.xyz);
    r5.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r3.xyz;
    r3.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r3.xyz;
    r3.xyz = float3(0.947867334,0.947867334,0.947867334) * r3.xyz;
    r3.xyz = log2(r3.xyz);
    r3.xyz = float3(2.4000001,2.4000001,2.4000001) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r3.xyz = r4.xyz ? r5.xyz : r3.xyz;
    r0.xyz = r0.xyz * v1.xyz + -r3.xyz;
    switch (r2.x) {
      case 1 :      r3.xy = float2(0,0);
      r4.xyz = float3(0.600000024,1,0);
      r5.xy = float2(0.600000024,1);
      break;
      case 2 :      r3.xy = float2(0,0);
      r4.xyz = float3(0.600000024,1,0);
      r5.xy = float2(0.600000024,1);
      break;
      case 3 :      r3.xy = float2(1,0.200000003);
      r4.xyz = float3(0,1,0.200000003);
      r5.xy = float2(0,0);
      break;
      case 0 :      r3.xy = float2(0,0);
      r4.xyz = float3(0,0,0);
      r5.xy = float2(0,0);
      break;
      default :
      r3.xy = float2(0,0);
      r4.xyz = float3(0,0,0);
      r5.xy = float2(0,0);
      break;
    }
    r3.x = dot(r3.xy, r0.xz);
    r3.y = dot(r4.xyz, r0.xyz);
    r3.z = dot(r5.xy, r0.xz);
    r1.xyz = r3.xyz * cb3[38].zzz + r1.xyz;
  }
  if (r2.w != 0) {
    r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r1.xyz);
    r2.xzw = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
    r3.xyz = log2(r1.xyz);
    r3.xyz = float3(0.416666657,0.416666657,0.416666657) * r3.xyz;
    r3.xyz = exp2(r3.xyz);
    r3.xyz = r3.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
    r0.xyz = r0.xyz ? r2.xzw : r3.xyz;
    r3.x = dot(float3(17.8824005,43.5161018,4.11934996), r0.xyz);
    r3.y = dot(float3(3.45565009,27.1553993,3.86714005), r0.xyz);
    r3.z = dot(float3(0.0299565997,0.184309006,1.46709001), r0.xyz);
    switch (r2.y) {
      case 1 :      r0.xyz = float3(0,2.02343988,-2.52581);
      r2.xyz = float3(0,1,0);
      r4.xyz = float3(0,0,1);
      break;
      case 2 :      r0.xyz = float3(1,0,0);
      r2.xyz = float3(0.494206995,0,1.24827003);
      r4.xyz = float3(0,0,1);
      break;
      case 3 :      r0.xyz = float3(1,0,0);
      r2.xyz = float3(0,1,0);
      r4.xyz = float3(-0.0122450003,0.0720349997,0);
      break;
      case 0 :      r0.xyz = float3(1,0,0);
      r2.xyz = float3(0,1,0);
      r4.xyz = float3(0,0,1);
      break;
      default :
      r0.xyz = float3(1,0,0);
      r2.xyz = float3(0,1,0);
      r4.xyz = float3(0,0,1);
      break;
    }
    r0.x = dot(r0.xyz, r3.xyz);
    r0.y = dot(r2.xyz, r3.xyz);
    r0.z = dot(r4.xyz, r3.xyz);
    r2.x = dot(float3(0.0809444487,-0.130504414,0.116721064), r0.xyz);
    r2.y = dot(float3(-0.0102485335,0.0540193282,-0.113614708), r0.xyz);
    r2.z = dot(float3(-0.000365296932,-0.00412161462,0.693511426), r0.xyz);
    r0.xyz = max(float3(0,0,0), r2.xyz);
    r2.xyz = cmp(float3(0.0404499993,0.0404499993,0.0404499993) >= r0.xyz);
    r3.xyz = float3(0.0773993805,0.0773993805,0.0773993805) * r0.xyz;
    r0.xyz = float3(0.0549999997,0.0549999997,0.0549999997) + r0.xyz;
    r0.xyz = float3(0.947867334,0.947867334,0.947867334) * r0.xyz;
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(2.4000001,2.4000001,2.4000001) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r1.xyz = r2.xyz ? r3.xyz : r0.xyz;
  }
  r0.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r1.xyz);
  r2.xyz = float3(12.9200001,12.9200001,12.9200001) * r1.xyz;
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  r0.xyz = r0.xyz ? r2.xyz : r1.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(2.4000001,2.4000001,2.4000001) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = ui_white.xxx * r0.xyz;
  r1.x = dot(float3(0.627399981,0.329299986,0.0432999991), r0.xyz);
  r1.y = dot(float3(0.0691,0.919499993,0.0114000002), r0.xyz);
  r1.z = dot(float3(0.0164000001,0.0879999995,0.895600021), r0.xyz);
  r0.xyz = float3(9.99999975e-005,9.99999975e-005,9.99999975e-005) * r1.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.159301758,0.159301758,0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  r0.xyz = r0.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375,78.84375,78.84375) * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = r1.w;
  if (is_vignette) o0.w = saturate(o0.w + CODWW2Dither(v0.xy));
  return;
}
