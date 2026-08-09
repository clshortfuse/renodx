#include "../../common.hlsl"

Texture2DArray<float4> t3 : register(t3);
Texture2DArray<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
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
  float4 r0,r1;
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
  r1.xy = cb0[1].zw + r1.xy;
  r1.xy = r1.xy / cb0[1].xy;
  r1.xy = (r1.xy >= -r1.xy) ? frac(abs(r1.xy)) : -frac(abs(r1.xy));
  r1.xy = cb0[1].xy * r1.xy;
  r1.xy = (uint2)r1.xy;
  r1.zw = float2(0,0);
  r1.x = t1.Load(r1.xyz).w;
  r1.x = -0.5 + r1.x;
  r1.x = r1.x + r1.x;
  r0.zw = float2(0,0);
  r1.yzw = t0.Load(r0.xyww).xyz;
  r0.x = t3.Load(r0.xyzw).x;
  if (injectedData.fxFilmGrainType == 0.f) {
  r0.yzw = r1.yzw * r1.xxx;
  r0.yzw = cb0[0].xxx * r0.yzw * injectedData.fxFilmGrain;
  r1.x = renodx::color::y::from::BT709(saturate(r1.yzw));
  r1.x = sqrt(r1.x);
  r1.x = cb0[0].y * -r1.x + 1;
  r0.yzw = r0.yzw * r1.xxx + r1.yzw;
  } else {
    r0.yzw = applyFilmGrain(r1.yzw, v1);
  }
  r1.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r1.xy = cb1[43].xy * r1.xy;
  r1.z = 0;
  r1.xyzw = t2.SampleLevel(s0_s, r1.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.yzw + r1.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  o0.w = cb0[4].x == 1.0 ? r0.x : 1;
  return;
}