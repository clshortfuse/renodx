#include "../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

void main(
  float2 v0 : TEXCOORD0,
  float4 v1 : SV_POSITION0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 1 + -cb0[5].x;
  r0.x = min(1, r0.x);
  r0.y = max(0, -cb0[4].w);
  r0.x = r0.x + -r0.y;
  r0.x = max(0.001, r0.x);
  r0.z = exp2(cb0[3].x);
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.yzw = r1.xyz * r0.zzz + -r0.yyy;
  o0.w = r1.w;
  r0.xyz = r0.yzw / r0.xxx;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = saturate(r0.xyz);
  }
  r0.xyz = cb0[5].yzw * r0.xyz;
  r0.xyz = r0.xyz * cb0[3].zzz + float3(-0.5,-0.5,-0.5);
  r1.xyz = cb0[3].www * r0.xyz;
  r0.xyz = cb0[3].www * r0.xyz + float3(0.5,0.5,0.5);
  r1.xyz = r1.xyz + r1.xyz;
  if(injectedData.toneMapType == 0.f){
    r1.xyz = saturate(r1.xyz);
  }
  r2.xyz = r1.xyz * float3(-2,-2,-2) + float3(3,3,3);
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r2.xy = float2(1,1) + cb0[4].yz;
  r2.xzw = r0.xyz * r2.xxx + -r0.xyz;
  r0.xyz = r1.xyz * r2.xzw + r0.xyz;
  r1.xyz = r0.xyz * r2.yyy + -r0.xyz;
  r2.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r2.xyz = float3(-2,-2,-2) * r2.xyz;
  if(injectedData.toneMapType == 0.f){
    r2.xyz = saturate(r2.xyz);
  }
  r3.xyz = r2.xyz * float3(-2,-2,-2) + float3(3,3,3);
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r0.xyz = r2.xyz * r1.xyz + r0.xyz;
  r0.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  r0.xyz = r0.xyz + -r0.www;
  r0.xyz = cb0[4].xxx * r0.xyz + r0.www;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = max(float3(0.0001,0.0001,0.0001), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.w = 1 / cb0[3].y;
  r0.xyz = r0.www * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = min(float3(1,1,1), r0.xyz);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, 1 / cb0[3].y);
  }
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}