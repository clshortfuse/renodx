#include "../../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[12];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = float4(-1,-1,1,1) * cb0[6].xyxy;
  r1.x = 0.5 * cb0[10].w;
  r2.xyzw = r0.xyzy * r1.xxxx + v1.xyxy;
  r0.xyzw = r0.xwzw * r1.xxxx + v1.xyxy;
  r1.xyzw = t1.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t1.Sample(s0_s, r2.zw).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r2.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t1.Sample(s0_s, r0.zw).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = cb0[11].xxx * r0.xyz * injectedData.fxBloom;
  r1.xyzw = t0.Sample(s1_s, w1.xy).xyzw;
  o0.xyz = r0.xyz * float3(0.25,0.25,0.25) + r1.xyz;
  o0.w = r1.w;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}