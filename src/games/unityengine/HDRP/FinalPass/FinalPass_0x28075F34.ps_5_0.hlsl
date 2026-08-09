#include "../../common.hlsl"

Texture2DArray<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
cbuffer cb1 : register(b1){
  float4 cb1[47];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[46].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(-1,-1) + cb1[46].xy;
  r0.zw = cb0[3].zw * r0.zw;
  r0.xy = r0.xy * cb0[3].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0,0);
  r0.z = t1.Load(r0.xyzw).x;
  r0.xyw = t0.Load(r0.xyww).xyz;
  o0.xyz = r0.xyw;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  o0.w = cb0[5].x == 1.0 ? r0.z : 1;
  return;
}