#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[8];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float2 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, v2.xy).xyzw;
  r0.xyzw = r1.xyzw + -r0.xyzw;
  /*r2.xyzw = cmp(float4(0,0,0,0) < r0.xyzw);
  r3.xyzw = cmp(r0.xyzw < float4(0,0,0,0));*/
  r0.xyzw = saturate(-cb0[7].yyyy + r0.xyzw);
  /*r2.xyzw = (int4)-r2.xyzw + (int4)r3.xyzw;
  r2.xyzw = (int4)r2.xyzw;*/
  r2.xyzw = sign(r0.xyzw);
  r0.xyzw = r2.xyzw * r0.xyzw;
  r2.x = 1 + -cb0[7].y;
  r0.xyzw = r0.xyzw / r2.xxxx;
  o0.xyzw = r0.xyzw * cb0[7].xxxx + r1.xyzw;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}