#include "../common.hlsli"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture3D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[105];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r0.xyz = cb0[104].yyy * r0.xyz;
  r1.x = cmp(0 >= cb1[0].x);
  if (r1.x != 0) {
    r1.xyz = cb0[104].xxx * r0.xyz;
    r1.xyz = log2(abs(r1.xyz));
    r1.xyz = float3(0.454549998,0.454549998,0.454549998) * r1.xyz;
    o0.xyz = exp2(r1.xyz);
    o0.w = r0.w;
    return;
  }
  r1.x = t2.Load(float4(0,0,0,0)).x;
  r1.yzw = t3.SampleLevel(s0_s, v1.xy, 0).xyz;
  r1.yzw = cb0[104].yyy * r1.yzw * CUSTOM_BLOOM;
  r1.yzw = r1.yzw * r1.xxx;
  r0.xyz = r0.xyz * r1.xxx + r1.yzw;
  if (CUSTOM_INTERNAL_LUT_SHAPER == 0.f) {
  r0.xyz = float3(0.00266771903,0.00266771903,0.00266771903) + r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(2.47393107,2.47393107,2.47393107) + r0.xyz;
  r0.xyz = saturate(r0.xyz * float3(0.0714285746, 0.0714285746, 0.0714285746) + float3(0.434017599, 0.434017599, 0.434017599));
  } else {
    r0.xyz = lutShaper(r0.xyz);
  }
  if (CUSTOM_LUT_SAMPLE == 0.f) {
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xyz = t1.Sample(s0_s, r0.xyz).xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t1, r0.xyz, 32u);
  }
  r0.xyz = float3(1.04999995, 1.04999995, 1.04999995) * r0.xyz;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyzw = r0.xyzw;
  return;
}