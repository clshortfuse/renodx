#include "../../common.hlsli"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[43];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  r1.xyzw = float4(-1,-1,1,1) * cb0[32].xyxy;
  r2.x = 0.5 * cb0[34].x;
  r3.xyzw = saturate(r1.xyzy * r2.xxxx + v1.xyxy);
  r3.xyzw = cb0[26].xxxx * r3.xyzw;
  r4.xyzw = t1.Sample(s1_s, r3.xy).xyzw;
  r3.xyzw = t1.Sample(s1_s, r3.zw).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r1.xyzw = saturate(r1.xwzw * r2.xxxx + v1.xyxy);
  r1.xyzw = cb0[26].xxxx * r1.xyzw;
  r2.xyzw = t1.Sample(s1_s, r1.xy).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r1.xyzw = t1.Sample(s1_s, r1.zw).xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r1.xyzw = cb0[34].yyyy * r1.xyzw * CUSTOM_BLOOM;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t2.Sample(s2_s, r2.xy).xyzw;
  r3.xyz = float3(0.25,0.25,0.25) * r1.xyz;
  r2.xyz = cb0[34].zzz * r2.xyz * CUSTOM_LENS;
  r1.xyzw = float4(0.25,0.25,0.25,1) * r1.xyzw;
  r4.xyz = cb0[35].xyz * r1.xyz;
  r4.w = 0.25 * r1.w;
  r0.xyzw = r4.xyzw + r0.xyzw;
  r1.xyz = r2.xyz * r3.xyz;
  r1.w = 0;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.w = saturate(r0.w);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  r1.xy = -cb0[38].xy + v1.xy;
  r1.yz = cb0[39].xx * abs(r1.yx) * min(1.f, CUSTOM_VIGNETTE);
  r1.w = cb0[22].x / cb0[22].y;
  r1.w = -1 + r1.w;
  r1.w = cb0[39].w * r1.w + 1;
  r1.x = r1.z * r1.w;
  r1.xy = saturate(r1.xy);
  r1.xy = log2(r1.xy);
  r1.xy = cb0[39].zz * r1.xy;
  r1.xy = exp2(r1.xy);
  r1.x = dot(r1.xy, r1.xy);
  r1.x = 1 + -r1.x;
  r1.x = max(0, r1.x);
  r1.x = log2(r1.x);
  r1.x = cb0[39].y * r1.x * max(1.f, CUSTOM_VIGNETTE);
  r1.x = exp2(r1.x);
  r1.yzw = float3(1,1,1) + -cb0[37].xyz;
  r1.yzw = r1.xxx * r1.yzw + cb0[37].xyz;
  r0.xyz = r1.yzw * r0.xyz;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  r0.w = -1 + r0.w;
  r0.w = saturate(r1.x * r0.w + 1);
  if (cb0[42].x > 0.5) {
    o0.w = renodx::color::y::from::BT709(saturate(r0.xyz));
  } else {
    o0.w = r0.w;
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}