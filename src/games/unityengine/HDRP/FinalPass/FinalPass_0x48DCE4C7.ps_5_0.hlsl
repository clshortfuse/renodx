#include "../../common.hlsl"

Texture2DArray<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[43];
}
cbuffer cb0 : register(b0){
  float4 cb0[4];
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
  r0.xyzw = t0.Load(r0.xyzw).xyzw;
  r0.w = saturate(r0.w);
  r1.x = renodx::color::y::from::BT709(saturate(r0.xyz));
  r1.x = sqrt(r1.x);
  r1.x = cb0[0].y * -r1.x + 1;
  r1.yz = v1.xy * cb0[3].xy + cb0[3].zw;
  r3.xy = cb0[2].xy * r1.yz;
  if(injectedData.fxFilmGrainType == 0.f){
  r2.xy = r1.yz * cb0[1].xy + cb0[1].zw;
  r1.y = t1.Sample(s0_s, r2.xy).w;
  r1.y = -0.5 + r1.y;
  r1.y = r1.y + r1.y;
  r2.xyzw = r1.yyyy * r0.xyzw;
  r2.xyzw = cb0[0].xxxx * r2.xyzw * injectedData.fxFilmGrain;
  r0.xyzw = r2.xyzw * r1.xxxx + r0.xyzw;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, v1);
  }
  o0.w = r0.w;
  r3.z = cb0[2].z;
  r0.w = t2.Sample(s0_s, r3.xyz).w;
  r0.w = r0.w * 2 + -1;
  r1.x = 1 + -abs(r0.w);
  r0.w = r0.w >= 0 ? 1 : -1;
  r1.x = sqrt(r1.x);
  r1.x = 1 + -r1.x;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}