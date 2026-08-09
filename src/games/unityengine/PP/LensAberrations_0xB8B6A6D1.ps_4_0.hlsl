#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[13];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[12].xy + v1.xy;
  r0.xy = cb0[11].xx * r0.xy * min(1.f, injectedData.fxVignette);
  r0.x = dot(r0.xy, r0.xy);
  r0.x = 1 + -r0.x;
  r0.x = max(0, r0.x);
  r0.x = log2(r0.x);
  r0.x = cb0[11].y * r0.x * max(1.f, injectedData.fxVignette);
  r0.x = exp2(r0.x);
  r0.yzw = float3(1,1,1) + -cb0[10].xyz;
  r0.xyz = r0.xxx * r0.yzw + cb0[10].xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.xyz = r1.xyz * r0.xyz;
  o0.w = r1.w;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}