#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[120];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if(injectedData.isClamped != 0.f){
    r0.xyz = rolloffSdr(r0.xyz);
  }
  r0.xyz = min(cb0[119].yyy, r0.xyz);
  r0.w = max(r0.x, r0.y);
  r0.w = max(r0.w, r0.z);
  r1.x = -cb0[119].z + r0.w;
  r0.w = max(9.99999975e-05, r0.w);
  r1.y = cb0[119].w + r1.x;
  r1.y = max(0, r1.y);
  r1.z = cb0[119].w + cb0[119].w;
  r1.y = min(r1.y, r1.z);
  r1.y = r1.y * r1.y;
  r1.z = cb0[119].w * 4 + 9.99999975e-05;
  r1.y = r1.y / r1.z;
  r1.x = max(r1.x, r1.y);
  r0.w = r1.x / r0.w;
  r0.xyz = r0.xyz * r0.www;
  o0.xyz = sqrt(r0.xyz);
  o0.w = 1;
  return;
}