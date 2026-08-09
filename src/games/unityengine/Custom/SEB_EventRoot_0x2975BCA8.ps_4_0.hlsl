#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[3];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.z = r0.x + r0.y;
  r0.z = -0.01 + r0.z;
  if (r0.z < 0) discard;
  r0.z = max(cb0[2].x, cb0[2].y);
  r1.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r2.xyzw = cb0[1].xyzw + -r1.xyzw;
  r1.xyzw = r0.zzzz * r2.xyzw + r1.xyzw;
  r1.xyzw = r1.xyzw * r0.yyyy;
  r1.xyzw = cb0[2].zzzz * r1.xyzw;
  r0.y = 1 + -r0.x;
  r1.xyz = r0.yyy * r1.xyz;
  o0.w = r0.y * r1.w + r0.x;
  o0.xyz = cb0[0].xyz * r0.xxx + r1.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}