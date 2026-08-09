#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

// BECROWNED demo
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0)
{
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.z = 0;
  r0.yw = cmp(float2(0, 0) < cb0[4].xy);
  r0.y = r0.w ? r0.y : 0;
  r1.xy = r0.yy ? cb0[4].xy : cb0[2].xy;
  r0.x = -r1.y;
  r0.xy = v1.xy + r0.zx;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.z = 0;
  r2.xyzw = v1.xyxy + r1.zyxz;
  r1.w = -r1.x;
  r1.xy = v1.xy + r1.wz;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r2.xy).xyzw;
  r2.xyzw = t0.Sample(s0_s, r2.zw).xyzw;
  r0.xyz = r3.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  r0.xyz = r0.xyz + r2.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = -r0.xyz * float3(0.200000003,0.200000003,0.200000003) + r1.xyz;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = max(-cb0[3].yyy, r0.xyz);
  r0.xyz = min(cb0[3].yyy, r0.xyz);
  }
  r0.xyz = r0.xyz * cb0[3].xxx + r1.xyz;
  if (injectedData.toneMapType == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = PostToneMapScale(r0.xyz, injectedData.gammaSpace != 0.f);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}