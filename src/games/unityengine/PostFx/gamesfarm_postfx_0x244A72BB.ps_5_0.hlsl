#include "../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  float4 v3 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = t2.Sample(s1_s, v1.xy).y;
  r0.x = sign(r0.x);
  r1.xyzw = t1.Sample(s2_s, v1.xy).xyzw;
  r0.y = 1 + -r1.w;
  r0.y = log2(r0.y);
  r0.y = cb0[3].x * r0.y;
  r0.y = exp2(r0.y);
  r0.xy = float2(1,1) + -r0.xy;
  r0.x = r0.y * r0.x;
  r0.y = 1 + -cb0[2].w;
  r0.x = r0.x * r0.y;
  r0.yz = float2(-0.5,-0.5) + v1.xy;
  r0.yz = r0.yz + r0.yz;
  r0.y = dot(r0.yz, r0.yz);
  r0.y = cb0[2].x * r0.y;
  r0.y = -r0.y * 0.1 + 1;
  r0.z = 1 + -r0.y;
  r0.y = cb0[2].y * r0.z + r0.y;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r2.xyzw = r2.xyzw * r0.yyyy;
  r0.yzw = r1.xyz * cb0[3].yyy + -r2.xyz;
  r2.xyz = r0.xxx * r0.yzw + r2.xyz;
  o0.xyzw = cb0[3].zzzz * r2.xyzw;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  return;
}