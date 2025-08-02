
#include "./common.hlsli"

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
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)v0.xy;
  r0.zw = (int2)cb0[8].xy;
  r0.xy = (int2)-r0.zw + (int2)r0.xy;
  r0.xy = (int2)r0.xy;
  r0.xy = cb0[7].zw * r0.xy;
  r0.xy = float2(0.5, 0.5) * r0.xy;
  r1.xy = (int2)r0.xy;
  r0.xy = trunc(r0.xy);
  r0.xy = cmp(r0.xy >= cb0[7].xy);
  r0.zw = cmp((int2)r1.xy < int2(0, 0));
  r0.z = (int)r0.w | (int)r0.z;
  r0.x = (int)r0.x | (int)r0.z;
  r0.x = (int)r0.y | (int)r0.x;
  r1.zw = float2(0, 0);
  r0.yzw = t11.Load(r1.xyz).xyz;
  r0.xyz = r0.xxx ? float3(0, 0, 0) : r0.yzw;
  r1.xyz = saturate(r0.xyz);
  r0.w = dot(r1.xyz, float3(0.298999995, 0.587000012, 0.114));
  r1.x = -r0.w * 4 + 1;
  r0.w = saturate(r0.w * 8 + -1);
  r1.x = max(0, r1.x);
  r1.y = 1 + -r1.x;
  r1.y = r1.y + -r0.w;
  r0.w = cb0[16].z * r0.w;
  r0.w = r1.x * cb0[16].x + r0.w;
  r1.x = max(0, r1.y);
  r0.w = r1.x * cb0[16].y + r0.w;
  r1.xy = v1.xy * cb0[15].xy + cb0[15].zw;
  r1.x = t16.SampleLevel(s2_s, r1.xy, 0).x;
  r1.x = r1.x * 2 + -1;
  r0.xyz = r1.xxx * r0.www + r0.xyz;

  r0.rgb = renodx::color::correct::Hue(r0.rgb, renodx::tonemap::ExponentialRollOff(r0.rgb, 1.f, 2.f), RENODX_TONE_MAP_HUE_SHIFT);

  if (!RENODX_GAMMA_CORRECTION) {
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.w = dot(float3(0.627403915, 0.329283029, 0.0433130674), r0.xyz);
    r1.x = log2(r0.w);
    r0.w = dot(float3(0.069097288, 0.919540405, 0.0113623161), r0.xyz);
    r0.x = dot(float3(0.0163914394, 0.0880133063, 0.895595253), r0.xyz);
    r1.z = log2(r0.x);
    r1.y = log2(r0.w);
    r0.xyz = cb0[25].zzz * r1.xyz;
    r0.xyz = exp2(r0.xyz);
  } else {
    r0.rgb = ApplyGammaCorrection(r0.rgb);
    r0.rgb = renodx::color::bt2020::from::BT709(r0.rgb);
  }

  float peak_nits;
  float3 untonemapped = r0.rgb;
  if (!RENODX_OVERRIDE_BRIGHTNESS) {
    if (RENODX_TONE_MAP_TYPE) {
      peak_nits = RENODX_PEAK_WHITE_NITS / (cb0[24].y * 100.f);
      r0.rgb = renodx::tonemap::ExponentialRollOff(r0.rgb, min(1.f, peak_nits * 0.5f), peak_nits);
    }
    r0.rgb = renodx::color::bt2020::from::BT709(ApplySaturationBlowoutHueCorrectionHighlightSaturation(renodx::color::bt709::from::BT2020(r0.rgb), untonemapped));
    r0.xyz = cb0[24].yyy * r0.xyz;
  } else {
    if (RENODX_TONE_MAP_TYPE) {
      peak_nits = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      r0.rgb = renodx::tonemap::ExponentialRollOff(r0.rgb, min(1.f, peak_nits * 0.5f), peak_nits);
    }
    r0.rgb = renodx::color::bt2020::from::BT709(ApplySaturationBlowoutHueCorrectionHighlightSaturation(renodx::color::bt709::from::BT2020(r0.rgb), untonemapped));
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
