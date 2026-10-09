#include "../../common.hlsli"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[40];
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

  r0.x = cb0[22].x / cb0[22].y;
  r0.x = -1 + r0.x;
  r0.x = cb0[39].w * r0.x + 1;
  r0.yz = -cb0[38].xy + v1.xy;
  r1.yz = cb0[39].xx * abs(r0.zy) * min(1.f, CUSTOM_VIGNETTE);
  r1.x = r1.z * r0.x;
  r1.xy = saturate(r1.xy);
  r0.xy = log2(r1.xy);
  r0.xy = cb0[39].zz * r0.xy;
  r0.xy = exp2(r0.xy);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = log2(r0.x);
  r0.x = cb0[39].y * r0.x * max(1.f, CUSTOM_VIGNETTE);
  r0.x = exp2(r0.x);
  r0.yzw = float3(1,1,1) + -cb0[37].xyz;
  r0.yzw = r0.xxx * r0.yzw + cb0[37].xyz;
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r2.w = -1.f + r1.w;
  r3.w = r0.x * r2.w + 1;
  r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  r3.xyz = r1.xyz * r0.yzw;
  r0.xyzw = float4(-1,-1,1,1) * cb0[32].xyxy;
  r1.x = 0.5 * cb0[34].x;
  r2.xyzw = saturate(r0.xyzy * r1.xxxx + v1.xyxy);
  r0.xyzw = saturate(r0.xwzw * r1.xxxx + v1.xyxy);
  r0.xyzw = cb0[26].xxxx * r0.xyzw;
  r1.xyzw = cb0[26].xxxx * r2.xyzw;
  r2.xyzw = t2.Sample(s2_s, r1.xy).xyzw;
  r1.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r2.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r0.xyzw = t2.Sample(s2_s, r0.zw).xyzw;
  r1.xyzw = r2.xyzw + r1.xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw * CUSTOM_BLOOM;
  r1.xyzw = float4(0.25,0.25,0.25,1) * r0.xyzw;
  r0.xyzw = float4(0.25,0.25,0.25,0.25) * r0.xyzw;
  r2.xyz = cb0[35].xyz * r1.xyz;
  r2.w = 0.25 * r1.w;
  r1.xyzw = r3.xyzw + r2.xyzw;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz * CUSTOM_LENS;
  r2.w = 0;
  r0.xyzw = r2.xyzw * r0.xyzw + r1.xyzw;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  o0.w = saturate(r0.w);
  r1.xy = v1.xy * cb0[30].xy + cb0[30].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = 1 + -abs(r0.w);
  r0.w = saturate(r0.w * renodx::math::FLT_MAX + 0.5);
  r0.w = r0.w * 2 + -1;
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}