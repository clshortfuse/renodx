#include "../../common.hlsli"

Texture2DArray<float4> t2 : register(t2);
Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
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
  r1.xy = (uint2)r0.xy;
  r1.zw = r1.xy / cb0[2].xy;
  r1.xy = r1.xy / cb1[43].xy;
  r2.xy = (int2)r1.xy;
  r1.zw = frac(abs(r1.zw));
  r1.xy = r1.zw >= -r1.zw ? frac(abs(r1.zw)) : -frac(abs(r1.zw));
  r1.xy = cb0[2].xy * r1.xy;
  r1.xy = (uint2)r1.xy;
  r1.z = (int)cb0[2].z;
  r1.w = 0;
  r1.x = t1.Load(r1.xyzw).w;
  r1.x = r1.x * 2 + -1;
  r1.y = 1 + -abs(r1.x);
  r1.x = r1.x >= 0 ? 1 : -1;
  r1.y = sqrt(r1.y);
  r1.y = 1 + -r1.y;
  r1.x = r1.x * r1.y;
  r2.zw = float2(0,0);
  r1.yzw = t0.Load(r2.xyzw).xyz;
  r1.xyz = applyDither(r1.yzw, r1.x * (1.0 / 255.0));
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r1.xyz = PostToneMapScale(r1.xyz);
  }
  o0.xyz = r1.xyz;
  r0.zw = float2(0,0);
  r0.x = t2.Load(r0.xyzw).x;
  o0.w = cb0[4].x == 1.0 ? r0.x : 1;
  return;
}