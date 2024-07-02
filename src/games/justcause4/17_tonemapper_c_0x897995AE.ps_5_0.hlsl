#include "./shared.h"

Texture2D<float4> t0 : register(t0);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t8 : register(t8);
Texture2D<float4> t9 : register(t9);
Texture3D<float4> t10 : register(t10);  // LUT
Texture2D<float4> t12 : register(t12);
Texture2D<float4> t13 : register(t13);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);

cbuffer cb6 : register(b6) { float4 cb6[5]; }

cbuffer cb1 : register(b1) { float4 cb1[2]; }

cbuffer cb0 : register(b0) { float4 cb0[17]; }

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_Position0, float4 v1 : TEXCOORD0, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[12].xy * v1.xy;
  r0.xy = min(cb0[12].zw, r0.xy);
  r0.z = t2.Sample(s1_s, r0.xy).x;

  r0.w = r0.z * cb0[1].z + cb0[1].w;
  r1.x = 1 / r0.w;
  r2.xyzw = cb0[5].xyzw * v1.yyyy;
  r2.xyzw = v1.xxxx * cb0[4].xyzw + r2.xyzw;
  r2.xyzw = r0.zzzz * cb0[6].xyzw + r2.xyzw;
  r2.xyzw = cb0[7].xyzw + r2.xyzw;
  r2.xyz = r2.xzy / r2.www;
  r2.xyz = -cb6[4].xzy + r2.xyz;
  r0.z = dot(r2.xyz, r2.xyz);
  r0.z = rsqrt(r0.z);
  r2.xyz = r2.zxy * r0.zzz;
  r0.z = cmp(0 < cb1[1].w);
  if (r0.z != 0) {
    r0.z = min(abs(r2.y), abs(r2.z));
    r0.w = max(abs(r2.y), abs(r2.z));
    r0.w = 1 / r0.w;
    r0.z = r0.z * r0.w;
    r0.w = r0.z * r0.z;
    r1.z = r0.w * 0.0208350997 + -0.0851330012;
    r1.z = r0.w * r1.z + 0.180141002;
    r1.z = r0.w * r1.z + -0.330299497;
    r0.w = r0.w * r1.z + 0.999866009;
    r1.z = r0.z * r0.w;
    r1.w = cmp(abs(r2.z) < abs(r2.y));
    r1.z = r1.z * -2 + 1.57079637;
    r1.z = r1.w ? r1.z : 0;
    r0.z = r0.z * r0.w + r1.z;
    r0.w = cmp(-r2.z < r2.z);
    r0.w = r0.w ? -3.141593 : 0;
    r0.z = r0.z + r0.w;
    r0.w = min(-r2.y, -r2.z);
    r1.z = max(-r2.y, -r2.z);
    r0.w = cmp(r0.w < -r0.w);
    r1.z = cmp(r1.z >= -r1.z);
    r0.w = r0.w ? r1.z : 0;
    r0.z = r0.w ? -r0.z : r0.z;
    r0.z = 3.14159012 + r0.z;
    r3.x = 0.159155071 * r0.z;
    r0.z = abs(r2.x) * 0.5 + 0.5;
    r3.y = -r2.x * r0.z;
    r0.z = saturate(cb1[1].z * r1.x);
    r0.w = cb1[1].x * r0.z;
    r1.z = saturate(-r2.x);
    r1.z = r1.z * r1.z;
    r1.z = r1.z * cb1[1].y + 1;
    r1.z = 1 / r1.z;
    r0.w = r1.z * r0.w;
    r3.xyzw = -cb1[0].xyzw + r3.xyxy;
    r3.xyzw = float4(8, 3, 25, 8) * r3.xyzw;
    r2.yz = t12.Sample(s0_s, r3.zw).yw;
    r2.yz = float2(-0.5, -0.5) + r2.yz;
    r2.yz = float2(0.75, 0.75) * r2.yz;
    r3.xyz = t12.Sample(s0_s, r3.xy).xyw;
    r2.w = -0;
    r2.yzw = r3.xyz + r2.wyz;
    r2.yzw = float3(0, -0.5, -0.5) + r2.yzw;
    r3.xy = r2.wz * r0.ww;
    r3.xy = r3.xy * r2.yy + v1.xy;
    r0.w = dot(r2.zw, r2.zw);
    r0.w = sqrt(r0.w);
    r0.w = r1.z * 0.300000012 + r0.w;
    r0.z = r0.w * r0.z;
    r0.z = r0.z * r1.z;
    r0.z = cb1[1].w * r0.z;
    r1.y = saturate(r0.z * r2.y);
    r0.zw = cb0[12].xy * r3.xy;
    r0.xy = min(cb0[12].zw, r0.zw);
    r0.z = t2.Sample(s1_s, r0.xy).x;
    r0.z = r0.z * cb0[1].z + cb0[1].w;
    r1.x = 1 / r0.z;
  } else {
    r3.xy = v1.xy;
    r1.y = 0;
  }
  r0.zw = cb0[13].xy * r3.xy;
  r0.zw = min(cb0[13].zw, r0.zw);
  r1.zw = cb0[15].xy * r3.xy;
  r1.zw = min(cb0[15].zw, r1.zw);
  r2.yzw = t1.Sample(s2_s, r0.zw).xyz;  // flare + bloom
  r4.xyz = t3.Sample(s2_s, r0.zw).xyz;  // bloom
  r5.xyz = t4.Sample(s2_s, r1.zw).xyz;  // bloom
  r6.xyz = t0.Sample(s2_s, r0.xy).xyz;  // flares
  r2.x = saturate(r2.x);
  r0.x = r2.x * r2.x;
  r0.x = r0.x * cb0[11].x + 1;
  r0.y = saturate(r1.x * cb0[3].x + -cb0[3].y);
  r0.x = r0.y / r0.x;
  r0.x = saturate(r0.x * cb0[2].w + cb0[11].z);
  r0.x = -0.100000001 + r0.x;
  r0.x = saturate(16 * r0.x);
  r0.y = t13.Sample(s2_s, r0.zw).x;  // depth
  r0.x = r0.x + r0.y;
  r0.y = 4 * r1.y;
  r0.y = min(1, r0.y);
  r0.x = saturate(r0.x + r0.y);
  r0.yzw = -r6.xyz + r2.yzw;
  r0.xyz = r0.xxx * r0.yzw + r6.xyz;
  r1.xyz = t9.Sample(s3_s, r3.xy).xyz;  // lens flare
  r1.xyz = r1.xyz * cb0[2].zzz + cb0[2].yyy;
  r1.xyz = r5.xyz * r1.xyz * injectedData.fxLensFlare;
  r1.xyz = r4.xyz * cb0[2].xxx * injectedData.fxBloom + r1.xyz;
  r0.xyz = r0.xyz * cb0[1].xxx + r1.xyz;
  r0.w = cmp(cb0[11].y == 0.000000);
  if (r0.w != 0) {
    r1.xyz = t8.Sample(s2_s, v1.xy).xyz;
    r1.xyz = float3(-1, -1, -1) + r1.xyz;
    r1.xyz = cb0[1].yyy * r1.xyz + float3(1, 1, 1);
    r1.xyz = lerp(1.f, r1.xyz, injectedData.fxVignette) * r0.xyz;
  } else {
    r2.xy = v1.xy * float2(2, 2) + float2(-1, -1);
    r2.xy = abs(r2.xy) * float2(0.5, 0.5) + float2(0.5, 0.5);
    r2.xy = float2(1, 1) + -r2.xy;
    r2.xyz = t8.Sample(s2_s, r2.xy).xyz;  // vertical mask ?
    r2.xyz = r2.xyz * r2.xyz + float3(-1, -1, -1);
    r2.xyz = cb0[1].yyy * r2.xyz + float3(1, 1, 1);
    r1.xyz = lerp(1.f, r2.xyz, injectedData.fxVignette) * r0.xyz;
  }

  float3 untonemapped = r1.xyz * 0.5f;

  float vanillaMidGray = 0.18f;

  float renoDRTContrast = 1.0f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = 0.5f;
  float renoDRTSaturation = 1.0f;
  float renoDRTHighlights = 1.0f;

  renodx::tonemap::Config config = renodx::tonemap::config::Create(
      injectedData.toneMapType,
      injectedData.toneMapPeakNits,
      injectedData.toneMapGameNits,
      injectedData.toneMapGammaCorrection,  // -1 == srgb
      injectedData.colorGradeExposure,
      injectedData.colorGradeHighlights,
      injectedData.colorGradeShadows,
      injectedData.colorGradeContrast,
      injectedData.colorGradeSaturation,
      vanillaMidGray,
      vanillaMidGray * 100.f,
      renoDRTHighlights,
      renoDRTShadows,
      renoDRTContrast,
      renoDRTSaturation,
      renoDRTDechroma,
      renoDRTFlare);
  renodx::lut::Config lut_config = renodx::lut::config::Create(
      s2_s,
      injectedData.colorGradeLUTStrength,
      injectedData.colorGradeLUTScaling,
      renodx::lut::config::type::GAMMA_2_0,
      renodx::lut::config::type::GAMMA_2_0,
      16.f);

  if (injectedData.toneMapType == 0.f) {
    r0.xyz = cb0[8].xxx * r1.xyz;
    r0.xyz = cb0[8].zzz * cb0[8].yyy + r0.xyz;
    r2.xy = cb0[9].xy * cb0[8].ww;
    r0.xyz = r1.xyz * r0.xyz + r2.xxx;
    r2.xzw = cb0[8].xxx * r1.xyz + cb0[8].yyy;
    r1.xyz = r1.xyz * r2.xzw + r2.yyy;
    r0.xyz = r0.xyz / r1.xyz;
    r0.w = cb0[9].x / cb0[9].y;
    r0.xyz = r0.xyz + -r0.www;
    r0.xyz = cb0[3].www * r0.xyz;
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.w = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
    r0.xyz = min(float3(1, 1, 1), r0.xyz);
    r1.x = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
    r0.xyz = saturate(cb0[0].xyz * r0.xyz);

    r0.xyz = sqrt(r0.xyz);
    r0.xyz = r0.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
    r0.xyz = t10.Sample(s2_s, r0.xyz).xyz;
    r0.xyz = r0.xyz * r0.xyz;

  } else {
    r0.xyz = renodx::tonemap::config::Apply(untonemapped, config, lut_config, t10);
  }

  if (injectedData.toneMapGammaCorrection) {
    r0.xyz = renodx::color::correct::GammaSafe(r0.xyz);
  }

  // Fake HDR?
  r0.xyz = r0.xyz * cb0[10].xxx + cb0[10].yyy;
  r0.w = r0.w / r1.x;
  r0.w = cb0[11].w * r0.w;
  r1.xyz = r0.xyz * r0.www;
  r0.xyz = cb0[16].xxx ? r1.xyz : r0.xyz;
  r0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  o0.w = sqrt(r0.w);
  o0.xyz = r0.xyz;

  o0.rgb *= injectedData.toneMapGameNits / 80.f;
  return;
}
