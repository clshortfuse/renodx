#include "../../common.hlsl"

Texture2DArray<float4> t4 : register(t4);
Texture2DArray<float4> t3 : register(t3);
Texture2DArray<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[80];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
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
  r1.xyz = t0.Load(r0.xyww).xyz;
  r0.x = t4.Load(r0.xyzw).x;
  r0.y = renodx::color::y::from::BT709(saturate(r1.xyz));
  r0.y = sqrt(r0.y);
  r0.y = cb0[0].y * -r0.y + 1;
  r0.zw = v1.xy * cb0[3].xy + cb0[3].zw;
  if(injectedData.fxFilmGrainType == 0.f){
  r2.xy = r0.zw * cb0[1].xy + cb0[1].zw;
  r1.w = t1.SampleBias(s1_s, r2.xy, cb1[79].y).w;
  r1.w = -0.5 + r1.w;
  r1.w = r1.w + r1.w;
  r2.xyz = r1.xyz * r1.www;
  r2.xyz = cb0[0].xxx * r2.xyz * injectedData.fxFilmGrain;
  r1.xyz = r2.xyz * r0.yyy + r1.xyz;
  } else {
    r1.xyz = applyFilmGrain(r1.xyz, v1);
  }
  r2.xy = cb0[2].xy * r0.zw;
  r3.xy = cb1[48].xy * r0.zw;
  r2.z = cb0[2].z;
  r0.y = t3.SampleBias(s1_s, r2.xyz, cb1[79].y).w;
  r0.y = r0.y * 2 + -1;
  r0.z = 1 + -abs(r0.y);
  r0.y = r0.y >= 0 ? 1 : -1;
  r0.z = sqrt(r0.z);
  r0.z = 1 + -r0.z;
  r0.y = r0.y * r0.z;
  r0.yzw = applyDither(r1.xyz, r0.y * (1.0 / 255.0));
  r3.z = 0;
  r1.xyzw = t2.SampleLevel(s0_s, r3.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.yzw + r1.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  o0.w = cb0[5].x == 1.0 ? r0.x : 1;
  return;
}