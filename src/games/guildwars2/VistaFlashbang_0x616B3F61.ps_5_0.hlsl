#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[2];
}

void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  float3 tex = r0.xyz;
  r1.x = r0.w * cb0[0].w + -cb0[1].x;
  r0.xyzw = cb0[0].xyzw * r0.xyzw;
  o0.xyzw = r0.xyzw;
  uint2 textureSize;
  t0.GetDimensions(textureSize.x, textureSize.y);
  if (textureSize.x == 4 && textureSize.y == 4 && all(cb0[0].xyz == 1.f) && all(tex == 1.f)) {
    o0 *= injectedData.fxFlashbang;
  }
  if (r1.x < 0) discard;
  return;
}