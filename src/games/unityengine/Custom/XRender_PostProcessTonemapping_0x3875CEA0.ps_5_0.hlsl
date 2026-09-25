#include "../common.hlsli"

Texture2D<float4> t5 : register(t5);
Texture3D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture3D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb4 : register(b4){
  float4 cb4[3];
}
cbuffer cb3 : register(b3){
  float4 cb3[4];
}
cbuffer cb2 : register(b2){
  float4 cb2[2];
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
  if (cb1[0].x <= 0) {
    r1.xyz = cb0[104].xxx * r0.xyz;
    r1.xyz = log2(abs(r1.xyz));
    r1.xyz = float3(0.454549998,0.454549998,0.454549998) * r1.xyz;
    o0.xyz = exp2(r1.xyz);
    o0.w = r0.w;
    return;
  }
  r1.y = cb2[1].y * cb2[1].z;
  r1.z = r1.y * r1.y + 1;
  r1.z = sqrt(r1.z);
  r1.z = 1.41421354 / r1.z;
  r2.xy = v1.xy * float2(2,-2) + float2(-1,1);
  r1.x = 1;
  r1.xy = r2.xy * r1.xy;
  r1.xy = r1.xy * r1.zz;
  r1.xy = cb2[0].xx * r1.xy * CUSTOM_VIGNETTE;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = 1 + r1.x;
  r1.x = 1 / r1.x;
  r1.x = r1.x * r1.x;
  r1.yzw = r1.xxx * r0.xyz;
  r2.xy = t2.Load(float4(0,0,0,0)).xw;
  r0.x = dot(r0.xyz, float3(0.333333343,0.333333343,0.333333343));
  r0.x = max(cb3[3].x, r0.x);
  r0.x = log2(r0.x);
  r0.y = cb4[1].x * r2.y;
  r0.y = 0.180000007 * r0.y;
  r0.y = log2(r0.y);
  r3.xy = cb4[1].zw * v1.xy;
  r0.z = r0.x * cb3[2].z + cb3[2].w;
  r0.z = r0.z * 31 + 0.5;
  r3.z = 0.03125 * r0.z;
  r2.yz = t4.SampleLevel(s0_s, r3.xyz, 0).xy;
  r0.z = r2.y / r2.z;
  r2.y = t5.SampleLevel(s0_s, v1.xy, 0).x;
  r2.z = cmp(r2.z < 0.00100000005);
  r0.z = r2.z ? r2.y : r0.z;
  r2.y = r2.y + -r0.z;
  r0.z = cb4[0].w * r2.y + r0.z;
  r2.y = log2(r2.x);
  r0.xz = r2.yy + r0.xz;
  r2.y = r0.x + -r0.z;
  r0.z = r0.z + -r0.y;
  r2.z = cmp(0 < r0.z);
  r2.w = r2.z ? cb4[0].x : cb4[0].y;
  r3.x = -cb4[2].x + r0.z;
  r3.x = max(0, r3.x);
  r3.y = cb4[2].y + r0.z;
  r3.y = min(0, r3.y);
  r3.xy = -r3.xy + r0.zz;
  r2.z = r2.z ? r3.x : r3.y;
  r0.z = -r2.z + r0.z;
  r0.y = r2.z + r0.y;
  r0.y = r0.z * r2.w + r0.y;
  r0.y = r2.y * cb4[0].z + r0.y;
  r0.x = r0.y + -r0.x;
  r0.x = exp2(r0.x);
  r0.xyz = r1.yzw * r0.xxx;
  r1.yzw = t3.SampleLevel(s0_s, v1.xy, 0).xyz;
  r1.yzw = cb0[104].yyy * r1.yzw * CUSTOM_BLOOM;
  r1.yzw = r1.yzw * r2.xxx;
  r1.xyz = r1.yzw * r1.xxx;
  r0.xyz = r0.xyz * r2.xxx + r1.xyz;
  if (CUSTOM_INTERNAL_LUT_SHAPER == 0.f) {
  r0.xyz = float3(0.00266771903,0.00266771903,0.00266771903) + r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(2.47393107,2.47393107,2.47393107) + r0.xyz;
  r0.xyz = saturate(r0.xyz * float3(0.0714285746,0.0714285746,0.0714285746) + float3(0.434017599,0.434017599,0.434017599));
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