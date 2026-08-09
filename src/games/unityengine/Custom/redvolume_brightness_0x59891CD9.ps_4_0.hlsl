#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[3];
}
cbuffer cb0 : register(b0){
  float4 cb0[20];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[19].x).xyzw;
  if(injectedData.toneMapType == 0.f){
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = cb1[2].xxx * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = min(float3(1,1,1), r0.xyz);
  } else {
    r0.xyz = renodx::math::SignPow(r0.xyz, cb1[2].x);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}