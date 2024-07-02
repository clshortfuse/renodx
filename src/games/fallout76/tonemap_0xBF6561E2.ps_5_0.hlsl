#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:53:11 2024
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s8_s : register(s8);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[8];
}

cbuffer cb12 : register(b12) {
  float4 cb12[55];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t0.Sample(s0_s, v1.xy).xyz;
  r0.w = t3.SampleLevel(s3_s, v1.xy, 0).w;
  r0.w = 255 * r0.w;
  r0.w = (uint)r0.w;
  r0.w = cmp((int)r0.w == 1);
  r1.xy = (int2)v0.xy;
  r1.zw = float2(0, 0);
  r1.x = t4.Load(r1.xyz).x;
  r1.x = cmp(r1.x < 0.99999994);
  r0.w = r0.w ? r1.x : 0;
  if (r0.w != 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return;
  }
  r0.w = t1.Sample(s1_s, v1.xy).x;
  r1.x = t1.Sample(s1_s, float2(0.5, 0.5)).x;
  r1.y = cmp(0.5 < cb2[0].z);
  if (r1.y != 0) {
    r1.yz = v1.xy * cb2[7].zw + float2(-0.5, -0.5);
    r2.xy = floor(r1.yz);
    r2.xy = float2(1, 1) + r2.xy;
    r2.xy = r2.xy / cb2[7].zw;
    r1.yz = frac(r1.yz);
    r2.xyzw = t2.Gather(s8_s, r2.xy).xyzw;
    r3.xy = float2(1, 1) + -r1.yz;
    r2.xyzw = log2(r2.xwyz);
    r2.xy = r3.xx * r2.yx;
    r2.xy = exp2(r2.xy);
    r1.yw = r2.wz * r1.yy;
    r1.yw = exp2(r1.yw);
    r1.yw = r2.xy * r1.yw;
    r1.yw = log2(r1.yw);
    r1.y = r3.y * r1.y;
    r1.y = exp2(r1.y);
    r1.z = r1.z * r1.w;
    r1.z = exp2(r1.z);
    r1.y = r1.y * r1.z;
  } else {
    r1.y = t2.Sample(s2_s, v1.xy).x;
  }
  r1.zw = cb2[1].xy * r0.ww;
  r1.y = max(r1.y, r1.z);
  r1.y = min(r1.y, r1.w);
  r1.z = 1 + -cb2[1].z;
  r1.y = log2(r1.y);
  r1.y = r1.z * r1.y;
  r1.y = exp2(r1.y);
  r1.x = log2(r1.x);
  r1.x = cb2[1].z * r1.x;
  r1.x = exp2(r1.x);
  r1.x = r1.y * r1.x;
  r1.y = cmp(1.00000001e-010 < cb12[54].x);
  r1.x = max(9.99999975e-005, r1.x);
  r1.x = cb12[54].y / r1.x;
  r1.x = r1.y ? cb12[54].x : r1.x;
  r1.x = max(cb12[54].z, r1.x);
  r1.x = min(cb12[54].w, r1.x);
  r0.w = max(9.99999975e-005, r0.w);
  r0.w = cb12[54].y / r0.w;
  r0.w = r1.y ? cb12[54].x : r0.w;
  r0.w = max(cb12[54].z, r0.w);
  r0.w = min(cb12[54].w, r0.w);
  r0.w = log2(r0.w);
  r0.w = -cb2[1].w * r0.w;
  r0.w = exp2(r0.w);
  r1.x = log2(r1.x);
  r1.x = cb2[1].w * r1.x;
  r1.x = exp2(r1.x);
  r0.w = r1.x * r0.w;
  r0.xyz = r0.xyz * r0.www;  // not auto exposure
  r1.x = cmp(0.5 < cb2[2].w);

  const float3 untonemapped = r0.xyz;

  // tonemapping
  if (r1.x != 0 && (injectedData.toneMapType == 0 || injectedData.toneMapHueCorrection)) {  // vanilla
    // Select ACES or Uncharted2 tonemapper
    r1.xy = float2(-1, -2) + cb2[2].xx;
    r2.xyz = r0.xyz * float3(2.50999999, 2.50999999, 2.50999999) + float3(0.0299999993, 0.0299999993, 0.0299999993);
    r2.xyz = r2.xyz * r0.xyz;
    r3.xyz = r0.xyz * float3(2.43000007, 2.43000007, 2.43000007) + float3(0.589999974, 0.589999974, 0.589999974);
    r4.xyz = r0.xyz * r3.xyz + float3(0.140000001, 0.140000001, 0.140000001);
    r2.xyz = saturate(r2.xyz / r4.xyz);
    r1.xy = cmp(abs(r1.xy) < float2(9.99999975e-005, 9.99999975e-005));
    r1.z = max(9.99999975e-005, cb2[2].y);
    r1.w = 0.560000002 / r1.z;
    r1.w = 2.43000007 + r1.w;
    r2.w = r1.z * r1.z;
    r2.w = 0.140000001 / r2.w;
    r1.w = r2.w + r1.w;
    r2.w = cb2[0].x * cb2[0].x;
    r2.w = -r2.w * 2.43000007 + 0.0299999993;
    r3.w = -0.589999974 + r1.w;
    r2.w = r3.w * cb2[0].x + r2.w;
    r4.xyz = r1.www * r0.xyz + float3(0.0299999993, 0.0299999993, 0.0299999993);
    r4.xyz = r4.xyz * r0.xyz;
    r3.xyz = r0.xyz * r3.xyz + r2.www;
    r3.xyz = saturate(r4.xyz / r3.xyz);
    r4.xyz = r0.xyz + r0.xyz;
    r5.xyz = r0.xyz * float3(0.300000012, 0.300000012, 0.300000012) + float3(0.0500000007, 0.0500000007, 0.0500000007);
    r1.w = 0.200000003 * cb2[2].z;
    r5.xyz = r4.xyz * r5.xyz + r1.www;
    r6.xyz = r0.xyz * float3(0.300000012, 0.300000012, 0.300000012) + float3(0.5, 0.5, 0.5);
    r4.xyz = r4.xyz * r6.xyz + float3(0.0599999987, 0.0599999987, 0.0599999987);
    r4.xyz = r5.xyz / r4.xyz;
    r4.xyz = -cb2[2].zzz * float3(3.33333325, 3.33333325, 3.33333325) + r4.xyz;
    r5.xy = r1.zz * float2(0.150000006, 0.150000006) + float2(0.0500000007, 0.5);
    r1.w = r1.z * r5.x + r1.w;
    r1.z = r1.z * r5.y + 0.0599999987;
    r1.z = r1.w / r1.z;
    r1.z = -cb2[2].z * 3.33333325 + r1.z;
    r1.z = 1 / r1.z;
    r4.xyz = r4.xyz * r1.zzz;
    r1.yzw = r1.yyy ? r3.xyz : r4.xyz;
    r0.xyz = r1.xxx ? r2.xyz : r1.yzw;

    if (injectedData.toneMapType != 0) {
      r0.xyz = renodx::color::correct::Hue(untonemapped, r0.xyz);
    }
  } else {  // untonemapped
    r0.xyz = untonemapped;
  }

  // scene filter adjustment
  r1.x = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
  r0.w = 0;
  float3 outputColor = r0.xyz;  // before scene filter
  r0.xyzw = -r1.xxxx + r0.xyzw;
  r0.xyzw = cb2[3].xxxx * r0.xyzw + r1.xxxx;
  r1.xyzw = r1.xxxx * cb2[4].xyzw + -r0.xyzw;
  r0.xyzw = cb2[4].wwww * r1.xyzw + r0.xyzw;
  r0.w = cb2[3].w * r0.w;
  r0.xyz = cb2[3].www * r0.xyz + -cb2[0].xxx;
  o0.xyz = cb2[3].zzz * r0.xyz + cb2[0].xxx;
  o0.w = r0.w;

  o0.xyz = lerp(outputColor, o0.xyz, injectedData.fxSceneFilter);

  return;
}