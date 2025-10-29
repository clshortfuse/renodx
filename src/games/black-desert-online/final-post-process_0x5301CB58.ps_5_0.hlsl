// Final post-process blend captured from Black Desert Online. The shader:
//   * builds a local luminance estimate from the eye-adaptation buffer (t1),
//   * applies a per-title colour tweak to the main scene sample (t0),
//   * mixes in bloom/lightshaft buffers (t3/t4) with game-specific masks,
//   * drives a highlight curve / exposure boost controlled by cb5,
//   * clamps to an SDR-like 0-100 range, optionally runs an ACES-ish rolloff,
//   * and writes an alpha based on the UI mask from t2.
// ---- Created with 3Dmigoto v1.4.1 on Sun Oct 26 01:57:28 2025

#include "./shared.h"

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb5 : register(b5)
{
  float4 cb5[4];
}

cbuffer cb4 : register(b4)
{
  float4 cb4[4];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[2];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[2];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Optional RenoDX override: bypass the game's eye adaptation and highlight curve entirely.
  if (CUSTOM_DISABLE_AUTO_EXPOSURE >= 0.5) {
    float3 scene_color = t0.Sample(s1_s, v1.xy).xyz;
    scene_color = max(float3(0,0,0), scene_color);
    scene_color = log2(scene_color);
    scene_color = cb3[1].www * scene_color;
    scene_color = exp2(scene_color);
    o0.xyz = scene_color;

    float2 ui_uv = cb5[3].xy * v1.xy;
    float ui_mask = t2.Sample(s0_s, ui_uv).x;
    float alpha = (-cb5[2].y + ui_mask) / ui_mask;
    o0.w = alpha * cb5[0].x + cb5[0].y;
    return;
  }

  // 3x3 luminance gather around the current pixel from the adaptation buffer (t1).
  r0.xy = -cb4[2].zw + v1.xy;
  r0.x = t1.SampleLevel(s1_s, r0.xy, 0).y;
  r1.xyzw = cb4[2].zwzw * float4(1,-1,-1,1) + v1.xyxy;
  r0.y = t1.SampleLevel(s1_s, r1.xy, 0).y;
  r0.z = t1.SampleLevel(s1_s, r1.zw, 0).y;
  r0.x = r0.x + r0.y;
  r0.yw = cb4[2].zw + v1.xy;
  r0.y = t1.SampleLevel(s1_s, r0.yw, 0).y;
  r0.x = r0.x + r0.y;
  r0.x = r0.x + r0.z;
  // Convert the scalar sum into RGB exposure scaling using cb0.
  r0.yzw = log2(cb0[1].xyz);
  r0.xyzw = float4(0.25,1.39999998,1.39999998,1.39999998) * r0.xyzw;
  r0.yzw = exp2(r0.yzw);
  float neutral_exposure = dot(r0.yzw, float3(0.333333343,0.333333343,0.333333343)) * r0.x;
  r0.xyz = neutral_exposure.xxx;
  // Sample scene colour, apply gamma tweak controlled by cb3.
  r1.xyz = t0.Sample(s1_s, v1.xy).xyz;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r1.xyz = log2(r1.xyz);
  r1.xyz = cb3[1].www * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  float3 base_scene_color = r1.xyz;
  // Blend between re-lit colour and original based on cb5 (acts as bypass flag).
  r0.xyz = r1.xyz;
  // Compute a softened baseline colour used later by the bloom mix.
  r1.xyz = r0.xyz * float3(0.5,0.5,0.5) + float3(0.00999999978,0.00999999978,0.00999999978);
  // Sample HDR bloom buffers and masks.
  r2.xy = v1.xy / cb2[0].xy;
  r0.w = t3.Sample(s1_s, r2.xy).x;
  r0.w = saturate(10 * r0.w);
  r2.xy = cb2[0].xy * v1.xy;
  r2.xyzw = t4.Sample(s1_s, r2.xy).xyzw;
  // Apply the depth/alpha-based bloom gating curves.
  r3.xyz = r2.xyz * r0.www + -r2.xyz;
  r2.xyz = r3.xyz * float3(0.5,0.5,0.5) + r2.xyz;
  r1.xyz = r2.xyz * r1.xyz + -r0.xyz;
  r0.w = saturate(1.70000005 * r2.w);
  r1.w = saturate(1 + -r2.w);
  r3.xyz = r2.xyz * r1.www;
  r1.w = r2.z + -r2.x;
  r1.w = saturate(1 + r1.w);
  r2.xyz = r3.xyz * r1.www;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r1.xyz = r0.xyz * r2.xyz + r2.xyz;
  r0.xyz = r1.xyz * float3(0.0199999996,0.0199999996,0.0199999996) + r0.xyz;
  // Allow HDR values to flow into the tone curve while keeping us inside the BT.709 hull.
  r0.xyz = max(float3(0,0,0), r0.xyz);
  // Exposure/contrast controls driven by cb5.
  r1.xyzw = float4(3,0.25,0.5,0.400000006) * cb5[1].yxyx;
  r2.xy = cmp(asint(cb5[2].zz) == int2(2,1));
  r1.xy = r2.xx ? r1.zw : r1.xy;
  r0.xyz = r1.yyy + r0.xyz;
  r0.xyz = r0.xyz * r1.xxx;
  r1.xyz = r0.xyz * cb5[1].www + float3(1,1,1);
  r0.xyz = cb5[1].www * r0.xyz;
  r2.xzw = r0.xyz * r0.xyz;
  r2.xzw = r2.xzw * cb5[2].xxx + r0.xyz;
  r1.xyz = r2.xzw / r1.xyz;
  // Optional Reinhard-like highlight rolloff (guarded by cb5[2].zz).
  float3 auto_exposed_color = r2.yyy ? r1.xyz : r0.xyz;
  float auto_exposure_strength = max(0.0, CUSTOM_AUTO_EXPOSURE_STRENGTH);
  o0.xyz = base_scene_color + (auto_exposed_color - base_scene_color) * auto_exposure_strength;
  // Alpha is generated from a UI mask (t2) and scaled/biased by cb5[0].
  r0.xy = cb5[3].xy * v1.xy;
  r0.x = t2.Sample(s0_s, r0.xy).x;
  r0.y = -cb5[2].y + r0.x;
  r0.x = r0.y / r0.x;
  o0.w = r0.x * cb5[0].x + cb5[0].y;
  return;
}