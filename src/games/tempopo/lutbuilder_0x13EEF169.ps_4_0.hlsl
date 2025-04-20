#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Thu Apr 17 17:04:51 2025
Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[148];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb0[132].x * v1.x;
  r0.x = floor(r0.x);
  r1.x = v1.x * cb0[132].x + -r0.x;
  r0.x = cb0[132].z * r0.x;
  r0.z = cb0[132].w * r0.x;
  r1.y = v1.y;
  r0.xy = -cb0[132].zz + r1.xy;
  r1.x = cb0[132].w;
  r1.z = 2;
  r0.xyz = r1.xxz * r0.xyz;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    r0.xyz = renodx::color::pq::Decode(r0.xyz, 100.f);
  }

  // float3 colorLMS = LinearToLMS(colorLinear);
  r1.x = dot(float3(0.390404999, 0.549941003, 0.00892631989), r0.xyz);
  r1.y = dot(float3(0.070841603, 0.963172019, 0.00135775004), r0.xyz);
  r1.z = dot(float3(0.0231081992, 0.128021002, 0.936245024), r0.xyz);

  // colorLMS *= _ColorBalance.xyz;
  r0.xyz = cb0[133].xyz * r1.xyz;
  r1.x = dot(float3(2.85846996, -1.62879002, -0.0248910002), r0.xyz);
  r1.y = dot(float3(-0.210181996, 1.15820003, 0.000324280991), r0.xyz);
  r1.z = dot(float3(-0.0418119989, -0.118169002, 1.06867003), r0.xyz);

  //  colorLinear = LMSToLinear(colorLMS);

  r0.xyz = r1.xyz * float3(5.55555582, 5.55555582, 5.55555582) + float3(0.0479959995, 0.0479959995, 0.0479959995);
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.0734997839, 0.0734997839, 0.0734997839) + float3(-0.0275523961, -0.0275523961, -0.0275523961);

  // colorLog = (colorLog - ACEScc_MIDGRAY) * _HueSatCon.z + ACEScc_MIDGRAY;
  r0.xyz = r0.xyz * cb0[138].zzz + float3(0.0275523961, 0.0275523961, 0.0275523961);

  // colorLinear = LogCToLinear(colorLog);
  r0.xyz = float3(13.6054821, 13.6054821, 13.6054821) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r0.xyz = float3(-0.0479959995, -0.0479959995, -0.0479959995) + r0.xyz;
  r0.xyz = float3(0.179999992, 0.179999992, 0.179999992) * r0.xyz;

  // colorLinear *= _ColorFilter.xyz;
  r0.xyz = cb0[134].xyz * r0.xyz;

  //  colorLinear = max(0.0, colorLinear);
  r0.xyz = max(float3(0, 0, 0), r0.xyz);

  // float3 colorGamma = PositivePow(colorLinear, 1.0 / 2.2);
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r0.xyz;
  r0.xyz = exp2(r0.xyz);

  // Split toning
  r1.xyz = r0.xyz + r0.xyz;
  r2.xyz = r0.xyz * r0.xyz;
  r3.xyz = min(float3(1, 1, 1), r0.xyz);
  r0.xyz = sqrt(r0.xyz);
  r0.w = dot(r3.xyz, float3(0.212672904, 0.715152204, 0.0721750036));
  r0.w = saturate(cb0[146].w + r0.w);
  r1.w = 1 + -r0.w;
  r3.xyz = float3(-0.5, -0.5, -0.5) + cb0[146].xyz;
  r3.xyz = r1.www * r3.xyz + float3(0.5, 0.5, 0.5);
  r4.xyz = -r3.xyz * float3(2, 2, 2) + float3(1, 1, 1);

  r2.xyz = r4.xyz * r2.xyz;
  r2.xyz = r1.xyz * r3.xyz + r2.xyz;
  r4.xyz = cmp(r3.xyz >= float3(0.5, 0.5, 0.5));
  r5.xyz = r4.xyz ? float3(0, 0, 0) : float3(1, 1, 1);
  r4.xyz = r4.xyz ? float3(1, 1, 1) : 0;
  r2.xyz = r5.xyz * r2.xyz;
  r5.xyz = float3(1, 1, 1) + -r3.xyz;
  r3.xyz = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
  r1.xyz = r5.xyz * r1.xyz;
  r0.xyz = r0.xyz * r3.xyz + r1.xyz;
  r0.xyz = r0.xyz * r4.xyz + r2.xyz;
  r1.xyz = r0.xyz + r0.xyz;
  r2.xyz = r0.xyz * r0.xyz;
  r0.xyz = sqrt(r0.xyz);
  r3.xyz = float3(-0.5, -0.5, -0.5) + cb0[147].xyz;
  r3.xyz = r0.www * r3.xyz + float3(0.5, 0.5, 0.5);
  r4.xyz = -r3.xyz * float3(2, 2, 2) + float3(1, 1, 1);
  r2.xyz = r4.xyz * r2.xyz;
  r2.xyz = r1.xyz * r3.xyz + r2.xyz;
  r4.xyz = cmp(r3.xyz >= float3(0.5, 0.5, 0.5));
  r5.xyz = r4.xyz ? float3(0, 0, 0) : float3(1, 1, 1);
  r4.xyz = r4.xyz ? float3(1, 1, 1) : 0;
  r2.xyz = r5.xyz * r2.xyz;
  r5.xyz = float3(1, 1, 1) + -r3.xyz;
  r3.xyz = r3.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
  r1.xyz = r5.xyz * r1.xyz;
  r0.xyz = r0.xyz * r3.xyz + r1.xyz;
  r0.xyz = r0.xyz * r4.xyz + r2.xyz;

  // colorLinear = PositivePow(colorGamma, 2.2);
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r0.xyz;
  r0.xyz = exp2(r0.xyz);

  // Channel mixing (Adobe style)
  r1.x = dot(r0.xyz, cb0[135].xyz);
  r1.y = dot(r0.xyz, cb0[136].xyz);
  r1.z = dot(r0.xyz, cb0[137].xyz);
  r0.xyz = cb0[143].xyz * r1.xyz;

  // Shadows, midtones, highlights
  r0.w = dot(r1.xyz, float3(0.212672904, 0.715152204, 0.0721750036));
  r2.xy = -cb0[145].xz + r0.ww;
  r2.zw = cb0[145].yw + -cb0[145].xz;
  r2.zw = float2(1, 1) / r2.zw;
  r2.xy = saturate(r2.xy * r2.zw);
  r2.zw = r2.xy * float2(-2, -2) + float2(3, 3);
  r2.xy = r2.xy * r2.xy;
  r0.w = -r2.z * r2.x + 1;
  r1.w = 1 + -r0.w;
  r1.w = -r2.w * r2.y + r1.w;
  r2.x = r2.w * r2.y;
  r0.xyz = r1.www * r0.xyz;
  r2.yzw = cb0[142].xyz * r1.xyz;
  r1.xyz = cb0[144].xyz * r1.xyz;
  r0.xyz = r2.yzw * r0.www + r0.xyz;
  r0.xyz = r1.xyz * r2.xxx + r0.xyz;

  // Lift, gamma, gain
  // TODO: Reduce Lift in HDR
  r0.xyz = r0.xyz * cb0[141].xyz + cb0[139].xyz;
  r1.xyz = cmp(float3(0, 0, 0) < r0.xyz);
  r2.xyz = cmp(r0.xyz < float3(0, 0, 0));
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = cb0[140].xyz * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = (int3)-r1.xyz + (int3)r2.xyz;
  r1.xyz = (int3)r1.xyz;
  r2.xyz = r1.xyz * r0.xyz;
  // HSV operations

  r3.xy = r2.zy;
  r0.xy = r1.yz * r0.yz + -r3.xy;
  r1.x = cmp(r3.y >= r2.z);
  r1.x = r1.x ? 1.000000 : 0;
  r3.zw = float2(-1, 0.666666687);
  r0.zw = float2(1, -1);
  r0.xyzw = r1.xxxx * r0.xywz + r3.xywz;
  r1.x = cmp(r2.x >= r0.x);
  r1.x = r1.x ? 1.000000 : 0;
  r3.z = r0.w;
  r0.w = r2.x;
  r2.x = dot(r2.xyz, float3(0.212672904, 0.715152204, 0.0721750036));
  r3.xyw = r0.wyx;
  r3.xyzw = r3.xyzw + -r0.xyzw;
  r0.xyzw = r1.xxxx * r3.xyzw + r0.xyzw;
  r1.x = min(r0.w, r0.y);
  r1.x = -r1.x + r0.x;
  r1.y = r1.x * 6 + 9.99999975e-05;
  r0.y = r0.w + -r0.y;
  r0.y = r0.y / r1.y;
  r0.y = r0.z + r0.y;
  r3.x = abs(r0.y);
  r2.z = cb0[138].x + r3.x;
  r2.yw = float2(0, 0);
  r4.xyzw = t4.SampleBias(s0_s, r2.zw, cb0[5].x).xyzw;
  r5.xyzw = t7.SampleBias(s0_s, r2.xy, cb0[5].x).xyzw;
  r5.x = saturate(r5.x);
  r0.y = r5.x + r5.x;
  r4.x = saturate(r4.x);
  r0.z = -0.5 + r4.x;
  r0.z = r2.z + r0.z;
  r0.w = cmp(1 < r0.z);
  r1.yz = float2(1, -1) + r0.zz;
  r0.w = r0.w ? r1.z : r0.z;
  r0.z = cmp(r0.z < 0);
  r0.z = r0.z ? r1.y : r0.w;
  r1.yzw = float3(1, 0.666666687, 0.333333343) + r0.zzz;
  r1.yzw = frac(r1.yzw);
  r1.yzw = r1.yzw * float3(6, 6, 6) + float3(-3, -3, -3);
  r1.yzw = saturate(float3(-1, -1, -1) + abs(r1.yzw));
  r1.yzw = float3(-1, -1, -1) + r1.yzw;
  r0.z = 9.99999975e-05 + r0.x;
  r3.z = r1.x / r0.z;
  r1.xyz = r3.zzz * r1.yzw + float3(1, 1, 1);
  r2.xyz = r1.xyz * r0.xxx;

  // Global saturation
  r0.z = dot(r2.xyz, float3(0.212672904, 0.715152204, 0.0721750036));
  r1.xyz = r0.xxx * r1.xyz + -r0.zzz;

  r3.yw = float2(0, 0);
  r2.xyzw = t5.SampleBias(s0_s, r3.xy, cb0[5].x).xyzw;
  r3.xyzw = t6.SampleBias(s0_s, r3.zw, cb0[5].x).xyzw;
  r3.x = saturate(r3.x);
  r0.x = r3.x + r3.x;
  r2.x = saturate(r2.x);
  r0.w = r2.x + r2.x;
  r0.x = r0.w * r0.x;
  r0.x = r0.x * r0.y;
  r0.x = cb0[138].y * r0.x;
  r0.xyz = r0.xxx * r1.xyz + r0.zzz;

  float3 untonemapped = r0.xyz;
  float3 sdr_color = renodx::tonemap::renodrt::NeutralSDR(untonemapped);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    r0.xyz = sdr_color;
  }

  r0.xyz = float3(0.00390625, 0.00390625, 0.00390625) + r0.xyz;
  r0.w = 0;
  r1.xyzw = t0.SampleBias(s0_s, r0.xw, cb0[5].x).xyzw;
  r1.x = saturate(r1.x);
  r2.xyzw = t0.SampleBias(s0_s, r0.yw, cb0[5].x).xyzw;
  r0.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[5].x).xyzw;
  r1.z = saturate(r0.x);
  r1.y = saturate(r2.x);
  r0.xyz = float3(0.00390625, 0.00390625, 0.00390625) + r1.xyz;
  r0.w = 0;
  r1.xyzw = t1.SampleBias(s0_s, r0.xw, cb0[5].x).xyzw;
  o0.x = saturate(r1.x);
  r1.xyzw = t2.SampleBias(s0_s, r0.yw, cb0[5].x).xyzw;
  r0.xyzw = t3.SampleBias(s0_s, r0.zw, cb0[5].x).xyzw;
  o0.z = saturate(r0.x);
  o0.y = saturate(r1.x);
  o0.w = 1;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    o0.rgb = renodx::tonemap::UpgradeToneMap(untonemapped, sdr_color, o0.rgb, 1.f);
  }

  return;
}
