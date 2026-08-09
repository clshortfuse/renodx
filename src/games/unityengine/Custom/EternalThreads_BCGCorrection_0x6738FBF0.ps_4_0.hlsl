#include "../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[2].xy + cb0[2].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  if (injectedData.toneMapType == 0.f) {
  r0.xyz = r0.xyz * float3(255,255,255) + float3(-128,-128,-128);
  r0.w = 259 + -cb0[3].x;
  r0.w = 255 * r0.w;
  r1.xy = float2(255,1) + cb0[3].xz;
  r1.x = 259 * r1.x;
  r1.y = 1 / r1.y;
  r0.w = r1.x / r0.w;
  r0.xyz = r0.www * r0.xyz + cb0[3].yyy;
  r0.xyz = float3(128,128,128) + r0.xyz;
  r0.xyz = max(float3(0,0,0), r0.xyz);
  r0.xyz = min(float3(255,255,255), r0.xyz);
  r0.xyz = float3(0.00392156886,0.00392156886,0.00392156886) * r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r1.yyy * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(1,1,1) * r0.xyz;
  r0.xyz = min(float3(1,1,1), r0.xyz);
  }
    if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}