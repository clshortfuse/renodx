// ---- Created with 3Dmigoto v1.4.1 on Sat Oct 25 04:23:53 2025
// Per-pixel post process that tone maps scene color, blends LUTs, and applies exposure controls

#include "./shared.h"

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[222];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : TEXCOORD0,
  float4 v1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float2 v4 : TEXCOORD4,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;


  if (RENODX_TONE_MAP_TYPE != 0.0f) {
    // Derive a smooth vignette-style weight from motion/velocity stored in v2.xy
    r0.x = dot(v2.xy, v2.xy);
    r0.y = 1 + r0.x;
    r0.x = saturate(-r0.x * 2 + r0.y);
    r0.x = r0.x * r0.x;
    r0.x = r0.x * r0.x;
    // Sample the scene color buffer and apply per-channel gain/offset tweaks
    r1.xyzw = t2.Sample(s2_s, v3.xy).xyzw;
    r0.yzw = r1.xyz * cb0[188].xxx + cb0[188].yyy;
    r1.xyz = r1.xyz * cb0[186].xxx + cb0[186].yyy;
    r1.w = dot(r0.yzw, float3(0.333333343,0.333333343,0.333333343));
    r0.yzw = -r1.www + r0.yzw;
    r0.yzw = cb0[189].xxx * r0.yzw + r1.www;
    r0.yzw = r0.yzw * cb0[188].zzz + cb0[188].www;
    // Fetch primary albedo/lighting buffer and modulate with the previous tone adjustments
    r2.xyzw = t0.Sample(s0_s, v0.xy, int2(0, 0)).xyzw;
    // Retain original alpha handling so UI composition keeps behaving
    r3.xyz = r2.xyz * r0.yzw;
    r1.w = dot(r2.xyzw, cb0[155].xyzw);
    o0.w = saturate(cb0[154].w + r1.w);

    // Blend the original bloom
    const float3 bloom_rgb = t1.Sample(s1_s, v1.xy, int2(0, 0)).xyz;
    const float bloom_weight = 0.005f * CUSTOM_BLOOM_STRENGTH;
    float3 scene_with_bloom = r3.xyz + bloom_rgb * (r0.yzw * bloom_weight);

    // Re-apply the vignette with user-adjustable strength.
    const float vignette_falloff = r0.x;
    const float vignette_strength = saturate(CUSTOM_VIGNETTE_STRENGTH);
    const float vignette_mix = lerp(1.0f, vignette_falloff, vignette_strength);
    scene_with_bloom *= vignette_mix;

    // Bypass the game's tone-curve, saturation, and LUT processing
    const float3 scene_linear = max(float3(0,0,0), scene_with_bloom);
    const float exposure_boost = 50.0f;  // Manual exposure lift now that the game curve is bypassed.
    const float3 boosted_linear = scene_linear * exposure_boost;
    const float3 scene_pow = pow(boosted_linear, float3(0.416666657f,0.416666657f,0.416666657f));
    const float3 scene_high = 1.055f * scene_pow - 0.055f;
    const float3 scene_low = boosted_linear * 12.92f;
    const float3 use_high = step(float3(0.0031308f,0.0031308f,0.0031308f), boosted_linear);
    o0.xyz = lerp(scene_low, scene_high, use_high);
    return;
  }

  // Vanilla tone curve, saturation, and LUT application used when RenoDX is disabled.
  r0.x = dot(v2.xy, v2.xy);
  r0.y = 1 + r0.x;
  r0.x = saturate(-r0.x * 2 + r0.y);
  r0.x = r0.x * r0.x;
  r0.x = r0.x * r0.x;
  r1.xyzw = t2.Sample(s2_s, v3.xy).xyzw;
  r0.yzw = r1.xyz * cb0[188].xxx + cb0[188].yyy;
  r1.xyz = r1.xyz * cb0[186].xxx + cb0[186].yyy;
  r1.w = dot(r0.yzw, float3(0.333333343,0.333333343,0.333333343));
  r0.yzw = -r1.www + r0.yzw;
  r0.yzw = cb0[189].xxx * r0.yzw + r1.www;
  r0.yzw = r0.yzw * cb0[188].zzz + cb0[188].www;
  r2.xyzw = t0.Sample(s0_s, v0.xy, int2(0, 0)).xyzw;
  r3.xyz = r2.xyz * r0.yzw;
  r1.w = dot(r2.xyzw, cb0[155].xyzw);
  o0.w = saturate(cb0[154].w + r1.w);
  r3.w = 1;
  r2.x = dot(r3.xyzw, cb0[215].xyzw);
  r2.y = dot(r3.xyzw, cb0[216].xyzw);
  r2.z = dot(r3.xyzw, cb0[217].xyzw);
  r2.xyz = r2.xyz * r0.xxx;
  r2.xyz = max(float3(5.96046448e-08,5.96046448e-08,5.96046448e-08), r2.xyz);
  r2.xyz = cb0[209].xxx * -r2.xyz;
  r2.xyz = float3(1.44269502,1.44269502,1.44269502) * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r3.xyz = -r2.xyz * cb0[209].yyy + float3(1,1,1);
  r2.xyz = float3(1,1,1) + -r2.xyz;
  r3.xyz = r3.xyz * r3.xyz;
  r2.xyz = saturate(r3.xyz * r2.xyz);
  r3.xyz = float3(1,1,1) + -r2.xyz;
  r0.x = dot(r1.xyz, float3(0.333333343,0.333333343,0.333333343));
  r1.xyz = r1.xyz + -r0.xxx;
  r1.xyz = saturate(cb0[187].xxx * r1.xyz + r0.xxx);
  r1.xyz = r1.xyz * cb0[186].zzz + cb0[186].www;
  r4.xyzw = t1.Sample(s1_s, v1.xy, int2(0, 0)).xyzw;
  r0.xyz = r4.xyz * r0.yzw + r1.xyz;
  r0.w = 1;
  r1.x = saturate(dot(r0.xyzw, cb0[219].xyzw));
  r1.y = saturate(dot(r0.xyzw, cb0[220].xyzw));
  r1.z = saturate(dot(r0.xyzw, cb0[221].xyzw));
  r0.xyz = r3.xyz * r1.xyz + r2.xyz;
  r0.xyz = max(float3(5.96046448e-08,5.96046448e-08,5.96046448e-08), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = cb0[202].xxx * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = cb0[203].yyy * r0.xyz;
  r2.xyzw = t3.Sample(s3_s, v4.xy, int2(0, 0)).xyzw;
  r1.xyz = r2.xxx * cb0[203].xxx + r1.xyz;
  r1.xyz = cb0[203].zzz + r1.xyz;
  o0.xyz = r1.xyz + r0.xyz;
  return;
}