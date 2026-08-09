#include "../tonemap.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[114];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-1,-1,1,1) * cb0[113].xyxy;
  r1.x = 0.5 * cb0[112].x;
  r2.xyzw = r0.xyzy * r1.xxxx + v1.xyxy;
  r0.xyzw = r0.xwzw * r1.xxxx + v1.xyxy;
  r1.xyzw = t1.Sample(s1_s, r2.xy).xyzw;
  r2.xyzw = t1.Sample(s1_s, r2.zw).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = float3(0.25,0.25,0.25) * r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  if(injectedData.countOld < injectedData.countNew){
    r1.xyz = InvertToneMapScale(r1.xyz, true);
  } else {
    r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  r0.xyz = r0.xyz * cb0[112].yyy * injectedData.fxBloom + r1.xyz;
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld <= injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}