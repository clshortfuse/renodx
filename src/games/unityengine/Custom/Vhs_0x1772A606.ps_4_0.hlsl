#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[3];
}
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[2].y + v1.y;
  r0.x = 100 * r0.x;
  r0.x = cos(r0.x);
  r0.x = r0.x / cb0[3].y;
  r0.x = v1.x + r0.x;
  r0.z = cb0[3].x + v1.y;
  r0.xy = frac(r0.xz);
  r0.zw = cb0[2].ww + r0.xy;
  r1.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r0.zw = -cb0[2].ww + r0.xy;
  r2.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.x = -0.5 + r0.y;
  r0.x = -0.49 + abs(r0.x);
  r0.x = max(0, r0.x);
  r0.x = ceil(r0.x);
  r0.x = 1 + -r0.x;
  r1.xw = r2.xw;
  r2.xyzw = t0.Sample(s0_s, r0.zw).xyzw;
  r1.z = r2.z;
  r2.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r3.xyzw = r2.xyzw + -r1.xyzw;
  r0.y = -cb0[2].z + r2.x;
  r0.y = ceil(r0.y);
  r1.xyzw = r0.yyyy * r3.xyzw + r1.xyzw;
  o0.xyzw = r1.xyzw * r0.xxxx;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}