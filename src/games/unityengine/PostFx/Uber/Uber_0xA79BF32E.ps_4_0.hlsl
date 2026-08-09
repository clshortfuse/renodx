#include "../../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float2 v2 : TEXCOORD2,
  float2 w2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[9].y;
  r0.y = 0;
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r1.xyz = cb0[9].www * r1.zxy;
  r1.yzx = lutShaper(r1.yzx);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r1.yzw = cb0[9].zzz * r1.xyz;
  r0.z = floor(r1.y);
  r2.xy = float2(0.5,0.5) * cb0[9].xy;
  r2.yz = r1.zw * cb0[9].xy + r2.xy;
  r2.x = r0.z * cb0[9].y + r2.y;
  r0.z = r1.x * cb0[9].z + -r0.z;
  r0.xy = r2.xz + r0.xy;
  r1.xyzw = t1.Sample(s1_s, r2.xz).xyzw;
  r2.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyw = r2.xyz + -r1.xyz;
  r0.xyz = r0.zzz * r0.xyw + r1.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t1, r1.yzx, cb0[9].z + 1u);
  }
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  if(injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}