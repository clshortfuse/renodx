#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s3_s, v1.xy).xyzw;
  r0.w = dot(r0.xyz, float3(1,1,1));
  o0.xyz = v2.xyz * r0.xyz * injectedData.fxLens;
  r0.x = -9.99999975e-05 + r0.w;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  o0.w = 1;
  return;
}