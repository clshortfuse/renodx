#include "./shared.h"

Texture2D<float4> t16 : register(t16);

Texture2D<float4> t11 : register(t11);

SamplerState s2_s : register(s2);

cbuffer cb0 : register(b0) {
  float4 cb0[26];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (uint2)v0.xy;
  r0.zw = (uint2)cb0[8].xy;
  r0.xy = (int2)-r0.zw + (int2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = cb0[7].zw * r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0, 0);
  r1.xyz = t11.Load(r0.xyz).xyz;
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = r1.xyz * r1.xyz;
  r2.xyz = float3(7, 7, 7) * r1.xyz;
  r0.z = cmp(0 != cb0[16].w);
  if (r0.z != 0) {
    r3.xyzw = (int4)r0.xyxy + int4(1, 0, -1, 0);
    r4.xy = r3.zw;
    r4.zw = float2(0, 0);
    r4.xyz = t11.Load(r4.xyz).xyz;
    r4.xyz = r4.xyz * r4.xyz;
    r4.xyz = r4.xyz * r4.xyz;
    r5.xyz = float3(7, 7, 7) * r4.xyz;
    r3.zw = float2(0, 0);
    r3.xyz = t11.Load(r3.xyz).xyz;
    r3.xyz = r3.xyz * r3.xyz;
    r3.xyz = r3.xyz * r3.xyz;
    r3.xyz = float3(7, 7, 7) * r3.xyz;
    r0.xyzw = (int4)r0.xyxy + int4(0, -1, 0, 1);
    r6.xy = r0.zw;
    r6.zw = float2(0, 0);
    r6.xyz = t11.Load(r6.xyz).xyz;
    r6.xyz = r6.xyz * r6.xyz;
    r6.xyz = r6.xyz * r6.xyz;
    r7.xyz = float3(7, 7, 7) * r6.xyz;
    r0.zw = float2(0, 0);
    r0.xyz = t11.Load(r0.xyz).xyz;
    r0.xyz = r0.xyz * r0.xyz;
    r0.xyz = r0.xyz * r0.xyz;
    r8.xyz = float3(7, 7, 7) * r0.xyz;
    r9.xyz = min(r5.xyz, r3.xyz);
    r9.xyz = min(r9.xyz, r2.xyz);
    r10.xyz = min(r8.xyz, r7.xyz);
    r9.xyz = min(r10.xyz, r9.xyz);
    r5.xyz = max(r5.xyz, r3.xyz);
    r5.xyz = max(r5.xyz, r2.xyz);
    r7.xyz = max(r8.xyz, r7.xyz);
    r5.xyz = max(r7.xyz, r5.xyz);
    r3.xyz = r4.xyz * float3(7, 7, 7) + r3.xyz;
    r3.xyz = r6.xyz * float3(7, 7, 7) + r3.xyz;
    r0.xyz = r0.xyz * float3(7, 7, 7) + r3.xyz;
    r0.xyz = float3(0.25, 0.25, 0.25) * r0.xyz;
    r1.xyz = r1.xyz * float3(7, 7, 7) + -r0.xyz;
    r0.xyz = cb0[17].xxx * r1.xyz + r0.xyz;
    r1.xyz = min(r0.xyz, r9.xyz);
    r0.xyz = max(r0.xyz, r9.xyz);
    r0.xyz = min(r0.xyz, r5.xyz);
    r2.xyz = max(r1.xyz, r0.xyz);
  }
  r0.xyz = saturate(r2.xyz);
  r0.x = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  r0.y = -r0.x * 4 + 1;
  r0.y = max(0, r0.y);
  r0.x = saturate(r0.x * 8 + -1);
  r0.z = 1 + -r0.y;
  r0.z = r0.z + -r0.x;
  r0.z = max(0, r0.z);
  r0.x = cb0[16].z * r0.x;
  r0.x = r0.y * cb0[16].x + r0.x;
  r0.x = r0.z * cb0[16].y + r0.x;
  r0.yz = v1.xy * cb0[15].xy + cb0[15].zw;
  r0.y = t16.SampleLevel(s2_s, r0.yz, 0).x;
  r0.y = r0.y * 2 + -1;
  r0.xyz = r0.yyy * r0.xxx + r2.xyz;

  // add saturation/blowout/hue shift sliders
  r0.rgb = renodx::color::grade::UserColorGrading(
      r0.rgb,
      1.f,
      1.f,
      1.f,
      1.f,
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_BLOWOUT,
      RENODX_TONE_MAP_HUE_SHIFT,
      renodx::tonemap::ExponentialRollOff(r0.rgb, 1.f, 2.f));

  if (!RENODX_GAMMA_CORRECTION) {
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.w = dot(float3(0.627403915, 0.329283029, 0.0433130674), r0.xyz);
    r1.x = dot(float3(0.069097288, 0.919540405, 0.0113623161), r0.xyz);
    r0.x = dot(float3(0.0163914394, 0.0880133063, 0.895595253), r0.xyz);
    r2.x = log2(r0.w);
    r2.y = log2(r1.x);
    r2.z = log2(r0.x);
    r0.xyz = cb0[25].zzz * r2.xyz;
    r0.xyz = exp2(r0.xyz);
  } else {
    r0.rgb = renodx::color::correct::GammaSafe(r0.rgb);
    r0.rgb = renodx::color::bt2020::from::BT709(r0.rgb);
  }

  float peak_nits;
  if (!RENODX_OVERRIDE_BRIGHTNESS) {
    if (RENODX_TONE_MAP_TYPE) {
      peak_nits = RENODX_PEAK_WHITE_NITS / (cb0[24].y * 100.f);
      r0.rgb = renodx::tonemap::ExponentialRollOff(r0.rgb, min(1.f, peak_nits * 0.5f), peak_nits);
    }
    r0.xyz = cb0[24].yyy * r0.xyz;
  } else {
    if (RENODX_TONE_MAP_TYPE) {
      peak_nits = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      r0.rgb = renodx::tonemap::ExponentialRollOff(r0.rgb, min(1.f, peak_nits * 0.5f), peak_nits);
    }
    r0.rgb *= RENODX_DIFFUSE_WHITE_NITS / 100.f;
  }

  if (!RENODX_USE_PQ_ENCODING) {
    r1.xyz = r0.xyz * float3(533095.75, 533095.75, 533095.75) + float3(47438308, 47438308, 47438308);
    r1.xyz = r0.xyz * r1.xyz + float3(29063622, 29063622, 29063622);
    r1.xyz = r0.xyz * r1.xyz + float3(575216.75, 575216.75, 575216.75);
    r1.xyz = r0.xyz * r1.xyz + float3(383.091034, 383.091034, 383.091034);
    r1.xyz = r0.xyz * r1.xyz + float3(0.000487781013, 0.000487781013, 0.000487781013);
    r2.xyz = r0.xyz * float3(66391356, 66391356, 66391356) + float3(81884528, 81884528, 81884528);
    r2.xyz = r0.xyz * r2.xyz + float3(4182885, 4182885, 4182885);
    r2.xyz = r0.xyz * r2.xyz + float3(10668.4043, 10668.4043, 10668.4043);
    r0.xyz = r0.xyz * r2.xyz + float3(1, 1, 1);
    o0.xyz = r1.xyz / r0.xyz;
  } else {
    o0.rgb = renodx::color::pq::EncodeSafe(r0.rgb, 100.f);
  }
  o0.w = 1;
  return;
}
