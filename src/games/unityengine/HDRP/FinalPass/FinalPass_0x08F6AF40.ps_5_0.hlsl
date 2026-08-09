#include "../../common.hlsl"

Texture2DArray<float4> t3 : register(t3);
Texture2DArray<float4> t2 : register(t2);
Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[44];
}
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[42].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(-1,-1) + cb1[42].xy;
  r0.zw = cb0[3].zw * r0.zw;
  r0.xy = r0.xy * cb0[3].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0,0);
  r1.xyz = t0.Load(r0.xyww).xyz;
  r0.x = t3.Load(r0.xyzw).x;
  r0.yzw = r1.xyz;
  r1.z = cb0[2].z;
  r2.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r1.xy = cb0[2].xy * r2.xy;
  r2.xy = cb1[43].xy * r2.xy;
  r1.x = t2.Sample(s1_s, r1.xyz).w;
  r1.x = r1.x * 2 + -1;
  r1.y = 1 + -abs(r1.x);
  r1.x = (r1.x >= 0) ? 1 : -1;
  r1.y = sqrt(r1.y);
  r1.y = 1 + -r1.y;
  r1.x = r1.x * r1.y;
  r0.yzw = applyDither(r0.yzw, r1.x * (1.0 / 255.0));
  r2.z = 0;
  r1.xyzw = t1.SampleLevel(s0_s, r2.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.yzw + r1.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  o0.w = cb0[4].x == 1.0 ? r0.x : 1;
  return;
}