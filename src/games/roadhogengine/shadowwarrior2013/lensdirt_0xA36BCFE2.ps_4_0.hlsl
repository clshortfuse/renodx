#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);

#define cmp -

void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s3_s, v1.zw).xyzw;
  r0.w = dot(r0.xyz, float3(1,1,1));
  r0.w = -9.99999975e-05 + r0.w;
  r0.w = cmp(r0.w < 0);
  if (r0.w != 0) discard;
  r1.xyzw = t0.Sample(s3_s, v1.xy).xyzw;
  r0.w = dot(r1.xyz, float3(1,1,1));
  r0.xyz = r1.xyz * r0.xyz;
  o0.xyz = v2.xyz * r0.xyz * injectedData.fxLens;
  r0.x = -9.99999975e-05 + r0.w;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  o0.w = 1;
  return;
}