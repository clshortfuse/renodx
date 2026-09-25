#include "../../common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

/*float3 vanillaUC2(float3 input) {
  float3 r0,r1,r2;
  r0 = input;
  // X * A + C * B
  r1.xyz = r0.xyz * float3(0.3,0.3,0.3) + float3(0.05,0.05,0.05);
  // 2 * X
  r2.xyz = r0.xyz + r0.xyz;
  // X * A + B
  r0.xyz = r0.xyz * float3(0.3, 0.3, 0.3) + float3(0.5, 0.5, 0.5);
  // 2 * X * (X * A + B) + D * F
  r0.xyz = r2.xyz * r0.xyz + float3(0.06,0.06,0.06);
  // 2 * X * (X * A + C * B) + D * E
  r1.xyz = r2.xyz * r1.xyz + float3(0.004,0.004,0.004);
  //
  r0.xyz = r1.xyz / r0.xyz;
  // - E / F
  r0.xyz = float3(-0.02 / 0.3, -0.02 / 0.3, -0.02 / 0.3) + r0.xyz;
  r0.xyz = float3(1.37906432,1.37906432,1.37906432) * r0.xyz; // 5.6
  return r0.xyz;
}*/

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = cb0[9].yyy * r0.xyz;
  r0.xyz = r0.xyz + r0.xyz;
  r0.xyz = Uncharted2Tonemap(r0.xyz, 0.3f, 0.5f, 0.1f, 0.2f, 0.02f, 0.3f, 5.6);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}