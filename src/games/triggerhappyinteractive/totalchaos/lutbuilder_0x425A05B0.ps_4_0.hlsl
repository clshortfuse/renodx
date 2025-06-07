#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[39];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[29].y;
  r1.yz = -cb0[28].yz + w1.xy;
  r2.x = cb0[28].x * r1.y;
  r1.x = frac(r2.x);
  r2.x = r1.x / cb0[28].x;
  r1.w = -r2.x + r1.y;
  r2.xyz = cb0[28].www * r1.xzw;
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r3.xyz = cb0[29].zzz * r2.zxy;
  r1.y = floor(r3.x);
  r3.xw = float2(0.5,0.5) * cb0[29].xy;
  r3.yz = r3.yz * cb0[29].xy + r3.xw;
  r3.x = r1.y * cb0[29].y + r3.y;
  r1.y = r2.z * cb0[29].z + -r1.y;
  r0.yw = float2(0,0.25);
  r0.xy = r3.xz + r0.xy;
  r3.xyzw = t0.Sample(s0_s, r3.xz).xyzw;
  r4.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r4.xyz = r4.xyz + -r3.xyz;
  r3.xyz = r1.yyy * r4.xyz + r3.xyz;
  } else {
    r3.rgb = renodx::lut::SampleTetrahedral(t0, r2.rgb, cb0[29].z + 1u);
  }
  r1.xyz = -r1.xzw * cb0[28].www + r3.xyz;
  r1.xyz = cb0[29].www * r1.xyz + r2.xyz;
  //r1.xyz = r1.xyz * cb0[32].www + float3(-0.217637643,-0.217637643,-0.217637643);
  r1.xyz = r1.xyz + float3(-0.217637643,-0.217637643,-0.217637643);
  r1.xyz = r1.xyz * cb0[32].zzz + float3(0.217637643,0.217637643,0.217637643);
  r2.x = dot(float3(0.390404999,0.549941003,0.00892631989), r1.xyz);
  r2.y = dot(float3(0.070841603,0.963172019,0.00135775004), r1.xyz);
  r2.z = dot(float3(0.0231081992,0.128021002,0.936245024), r1.xyz);
  r1.xyz = cb0[30].xyz * r2.xyz;
  r2.x = dot(float3(2.85846996,-1.62879002,-0.0248910002), r1.xyz);
  r2.y = dot(float3(-0.210181996,1.15820003,0.000324280991), r1.xyz);
  r2.z = dot(float3(-0.0418119989,-0.118169002,1.06867003), r1.xyz);
  r1.xyz = cb0[31].xyz * r2.xyz;
  r2.x = dot(r1.xyz, cb0[33].xyz);
  r2.y = dot(r1.xyz, cb0[34].xyz);
  r2.z = dot(r1.xyz, cb0[35].xyz);
  r1.xyz = r2.xyz * cb0[38].xyz + cb0[36].xyz;
  r2.xyz = log2(abs(r1.xyz));
  r1.xyz = saturate(r1.xyz * float3(renodx::math::FLT_MAX,renodx::math::FLT_MAX,renodx::math::FLT_MAX) + float3(0.5,0.5,0.5));
  r1.xyz = r1.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r2.xyz = cb0[37].xyz * r2.xyz;
  r2.xyz = exp2(r2.xyz);
  r1.xyz = r2.xyz * r1.xyz;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r0.x = cmp(r1.y >= r1.z);
  r0.x = r0.x ? 1.000000 : 0;
  r2.xy = r1.zy;
  r3.xy = -r2.xy + r1.yz;
  r2.zw = float2(-1,0.666666687);
  r3.zw = float2(1,-1);
  r2.xyzw = r0.xxxx * r3.xywz + r2.xywz;
  r0.x = cmp(r1.x >= r2.x);
  r0.x = r0.x ? 1.000000 : 0;
  r3.z = r2.w;
  r2.w = r1.x;
  r1.z = dot(r1.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r3.xyw = r2.wyx;
  r3.xyzw = r3.xyzw + -r2.xyzw;
  r2.xyzw = r0.xxxx * r3.xyzw + r2.xyzw;
  r0.x = min(r2.w, r2.y);
  r0.x = r2.x + -r0.x;
  r0.y = r0.x * 6 + 9.99999975e-05;
  r2.y = r2.w + -r2.y;
  r0.y = r2.y / r0.y;
  r0.y = r2.z + r0.y;
  r0.z = abs(r0.y);
  r3.xyzw = t1.SampleLevel(s1_s, r0.zw, 0).yxzw;
  r4.x = cb0[32].x + r0.z;
  r3.x = saturate(r3.x);
  r0.y = r3.x + r3.x;
  r0.z = 9.99999975e-05 + r2.x;
  r1.x = r0.x / r0.z;
  r1.yw = float2(0.25,0.25);
  r3.xyzw = t1.SampleLevel(s1_s, r1.xy, 0).zxyw;
  r5.xyzw = t1.SampleLevel(s1_s, r1.zw, 0).wxyz;
  r5.x = saturate(r5.x);
  r3.x = saturate(r3.x);
  r0.x = dot(r3.xx, r0.yy);
  r0.x = r5.x * r0.x;
  r0.x = dot(cb0[32].yy, r0.xx);
  r4.y = 0.25;
  r3.xyzw = t1.SampleLevel(s1_s, r4.xy, 0).xyzw;
  r3.x = saturate(r3.x);
  r0.y = r3.x + r4.x;
  r0.yzw = float3(-0.5,0.5,-1.5) + r0.yyy;
  r1.y = cmp(1 < r0.y);
  r0.w = r1.y ? r0.w : r0.y;
  r0.y = cmp(r0.y < 0);
  r0.y = r0.y ? r0.z : r0.w;
  r0.yzw = float3(1,0.666666687,0.333333343) + r0.yyy;
  r0.yzw = frac(r0.yzw);
  r0.yzw = r0.yzw * float3(6,6,6) + float3(-3,-3,-3);
  r0.yzw = saturate(float3(-1,-1,-1) + abs(r0.yzw));
  r0.yzw = float3(-1,-1,-1) + r0.yzw;
  r0.yzw = r1.xxx * r0.yzw + float3(1,1,1);
  r1.xyz = r2.xxx * r0.yzw;
  r1.x = dot(r1.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.yzw = r2.xxx * r0.yzw + -r1.xxx;
  r0.xyz = saturate(r0.xxx * r0.yzw + r1.xxx);
  r0.xyz = float3(0.00390625,0.00390625,0.00390625) + r0.xyz;
  r0.w = 0.75;
  r1.xyzw = t1.Sample(s1_s, r0.xw).wxyz;
  r1.x = saturate(r1.x);
  r2.xyzw = t1.Sample(s1_s, r0.yw).xyzw;
  r0.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
  r1.z = saturate(r0.w);
  r1.y = saturate(r2.w);
  r0.xyz = float3(0.00390625,0.00390625,0.00390625) + r1.xyz;
  r0.w = 0.75;
  r1.xyzw = t1.Sample(s1_s, r0.xw).xyzw;
  o0.x = saturate(r1.x);
  r1.xyzw = t1.Sample(s1_s, r0.yw).xyzw;
  r0.xyzw = t1.Sample(s1_s, r0.zw).xyzw;
  o0.z = saturate(r0.z);
  o0.y = saturate(r1.y);
  o0.w = 1;
  return;
}