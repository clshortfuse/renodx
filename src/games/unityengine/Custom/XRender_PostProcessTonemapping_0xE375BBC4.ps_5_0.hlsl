#include "../common.hlsli"

Texture2D<float4> t5 : register(t5);
Texture3D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture3D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb3 : register(b3){
  float4 cb3[3];
}
cbuffer cb2 : register(b2){
  float4 cb2[4];
}
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
  float4 r0,r1,r2,r3;
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
  r1.xy = t2.Load(float4(0,0,0,0)).xw;
  r1.z = dot(r0.xyz, float3(0.333333343,0.333333343,0.333333343));
  r1.z = max(cb2[3].x, r1.z);
  r1.z = log2(r1.z);
  r1.y = cb3[1].x * r1.y;
  r1.y = 0.180000007 * r1.y;
  r1.y = log2(r1.y);
  r2.xy = cb3[1].zw * v1.xy;
  r1.w = r1.z * cb2[2].z + cb2[2].w;
  r1.w = r1.w * 31 + 0.5;
  r2.z = 0.03125 * r1.w;
  r2.xy = t4.SampleLevel(s0_s, r2.xyz, 0).xy;
  r1.w = r2.x / r2.y;
  r2.x = t5.SampleLevel(s0_s, v1.xy, 0).x;
  r2.y = cmp(r2.y < 0.00100000005);
  r1.w = r2.y ? r2.x : r1.w;
  r2.x = r2.x + -r1.w;
  r1.w = cb3[0].w * r2.x + r1.w;
  r2.x = log2(r1.x);
  r1.zw = r2.xx + r1.zw;
  r2.x = r1.z + -r1.w;
  r1.w = r1.w + -r1.y;
  r2.y = cmp(0 < r1.w);
  r2.z = r2.y ? cb3[0].x : cb3[0].y;
  r2.w = -cb3[2].x + r1.w;
  r2.w = max(0, r2.w);
  r2.w = -r2.w + r1.w;
  r3.x = cb3[2].y + r1.w;
  r3.x = min(0, r3.x);
  r3.x = -r3.x + r1.w;
  r2.y = r2.y ? r2.w : r3.x;
  r1.w = -r2.y + r1.w;
  r1.y = r2.y + r1.y;
  r1.y = r1.w * r2.z + r1.y;
  r1.y = r2.x * cb3[0].z + r1.y;
  r1.y = r1.y + -r1.z;
  r1.y = exp2(r1.y);
  r0.xyz = r1.yyy * r0.xyz;
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
  r0.xyz = float3(1.04999995,1.04999995,1.04999995) * r0.xyz;
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