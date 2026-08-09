#include "../tonemap.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[5];
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xyz = cb0[3].zxy * r0.yzx;
  r1.xyz = cb0[3].yzx * r0.zxy + -r1.xyz;
  r1.xyz = cb0[2].yyy * r1.xyz;
  r1.xyz = r0.xyz * cb0[2].xxx + r1.xyz;
  r1.w = 1 + -cb0[2].x;
  r0.x = dot(cb0[3].xyz, r0.xyz);
  o0.w = r0.w;
  r0.xyz = cb0[3].xyz * r0.xxx;
  r0.xyz = r0.xyz * r1.www + r1.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[3].www + float3(0.5,0.5,0.5);
  r0.xyz = cb0[4].xxx + r0.xyz;
  r0.w = renodx::color::y::from::NTSC1953(r0.xyz);
  r0.xyz = r0.xyz + -r0.www;
  o0.xyz = cb0[4].yyy * r0.xyz + r0.www;
  if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
  }
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
  o0.xyz = applyUserNoTonemap(o0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
  o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  } else if(injectedData.gammaSpace != 0.f){
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}