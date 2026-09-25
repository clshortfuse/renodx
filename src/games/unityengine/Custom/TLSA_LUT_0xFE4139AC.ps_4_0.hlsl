#include "../common.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[30];
}

float3 vanillaUC2(float3 color){
  return renodx::tonemap::uncharted2::BT709(2.f * cb0[28].y * saturate(color), cb0[28].z);
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  o0.w = saturate(r0.w);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  r0.xyz *= 2 * cb0[28].y;
  r0.xyz = Uncharted2Tonemap(r0.xyz, 0.22f, 0.3f, 0.1f, 0.2f, 0.01f, 0.3f, cb0[28].z);
  r1.xyz = handleUserLUT(r0.xyz, t1, s1_s, cb0[29].xyz, 0, true);
  o0.xyz = r1.xyz;
  return;
}