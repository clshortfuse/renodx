#include "../../common.hlsl"

Texture2DArray<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[43];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r0.xy = r0.xy * cb0[1].xy + cb0[1].zw;
  r0.x = t1.Sample(s0_s, r0.xy).w;
  r0.x = -0.5 + r0.x;
  r0.x = r0.x + r0.x;
  r0.yz = cb1[42].xy * v1.xy;
  r0.yz = (uint2)r0.yz;
  r0.yz = (uint2)r0.yz;
  r1.xy = float2(-1,-1) + cb1[42].xy;
  r1.xy = cb0[3].zw * r1.xy;
  r0.yz = r0.yz * cb0[3].xy + r1.xy;
  r1.xy = (uint2)r0.yz;
  r1.zw = float2(0,0);
  r0.yzw = t0.Load(r1.xyww).xyz;
  r1.x = t2.Load(r1.xyzw).x;
  if (injectedData.fxFilmGrainType == 0.f) {
  r1.yzw = r0.yzw * r0.xxx;
  r1.yzw = cb0[0].xxx * r1.yzw * injectedData.fxFilmGrain;
  r0.x = renodx::color::y::from::BT709(saturate(r0.yzw));
  r0.x = sqrt(r0.x);
  r0.x = cb0[0].y * -r0.x + 1;
  r0.xyz = r1.yzw * r0.xxx + r0.yzw;
  } else {
    r0.xyz = applyFilmGrain(r0.yzw, v1);
  }
  o0.xyz = r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  o0.w = cb0[5].x == 1.0 ? r1.x : 1;
  return;
}