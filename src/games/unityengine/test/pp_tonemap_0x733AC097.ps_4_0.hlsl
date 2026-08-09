#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[32];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = cb0[31].xyz * cb0[30].xxx;
  r0.xyz = -r1.xyz * float3(2.55,2.55,2.55) + r0.xyz;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r0.w = exp2(cb0[29].y);
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = renodx::math::SignPow(r0.xyz, cb0[29].x);
  r0.w = renodx::color::y::from::BT709(r0.xyz);
  r1.xyzw = float4(1,1,1,1) + -r0.xyzw;
  r1.w = r1.w + r1.w;
  r1.xyz = -r1.www * r1.xyz + float3(1,1,1);
  r2.xyz = r0.www * r0.xyz;
  r0.w = -0.45 + r0.w;
  r0.w = saturate(10 * r0.w);
  r1.xyz = -r2.xyz * float3(2,2,2) + r1.xyz;
  r2.xyz = r2.xyz + r2.xyz;
  r1.xyz = r0.www * r1.xyz + r2.xyz;
  r2.xyz = cb0[29].www * r0.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r2.xyz = -cb0[29].www * r0.xyz + float3(1,1,1);
  r0.xyz = r2.xyz * r1.xyz + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.333333343,0.333333343,0.333333343));
  r1.xyz = r0.xyz + -r0.www;
  r0.xyz = r1.xyz * cb0[29].zzz + r0.xyz;
  r1.xyz = r1.xyz * cb0[29].zzz + float3(1,1,1);
  o0.xyz = r0.xyz / r1.xyz;
  if(injectedData.toneMapType >= 2.f){
    o0.xyz = rolloff(o0.xyz, 0.85f);
  }
  if(injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  o0.w = 1;
  return;
}