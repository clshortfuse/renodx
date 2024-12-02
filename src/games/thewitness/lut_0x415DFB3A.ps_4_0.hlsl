#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May  4 23:53:52 2024
Texture3D<float4> t5 : register(t5);

Texture3D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1) { float4 cb1[14]; }

// 3Dmigoto declarations
#define cmp -

void main(float2 v0
          : TEXCOORD0, float w0
          : TEXCOORD4, float2 v1
          : TEXCOORD1, float2 w1
          : TEXCOORD2, float2 v2
          : TEXCOORD3, out float4 o0
          : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(0 < cb1[12].x);
  if (r0.x != 0) {
    r0.xy = cb1[12].zw * v2.xy;
    r0.z = dot(r0.xy, r0.xy);
    r0.z = sqrt(r0.z);
    r0.z = -0.660000026 + r0.z;
    r0.z = max(0, r0.z);
    r0.z = cb1[12].x * r0.z;
    r0.z = cb1[7].z * r0.z;
    r0.z = cb1[8].x * r0.z;
    r0.z = 0.000143612138 * r0.z;
    r0.z = min(16, r0.z);
    r0.xy = r0.xy * r0.zz;
    r0.xyzw = t0.SampleGrad(s0_s, v0.xy, r0.xy, float2(0, 0)).xyzw;
  } else {
    r0.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  }
  float3 testColor = r0.rgb;
  
  r1.xyzw = t3.Sample(s3_s, v0.xy).xyzw;
  r0.w = -cb1[13].x + r1.x;
  r0.w = cb1[13].y / r0.w;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.w = -cb1[13].z + r0.w;
  r1.w = cb1[13].w + -cb1[13].z;
  r0.w = saturate(r0.w / r1.w);
  
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;

  // r0.xyz = w0.xzz * r0.xyz;
  // bad decompile

  // r0.xyz = w0.x * r0.xyz;

  r0.xyz *= lerp(1.f, w0.x, injectedData.fxAutoExposure);

  // r0.xyz = min(float3(1024, 1024, 1024), r0.xyz);
  // remove clamp

  r0.xyz = min(float3(1024, 1024, 1024), r0.xyz);
  r0.w = max(r0.x, r0.y);
  r1.x = max(0.00999999978, r0.z);
  r0.w = max(r1.x, r0.w);
  r1.x = r0.w + r0.w;
  r1.y = cb1[2].x * cb1[1].x;
  r1.z = cb1[0].x * r1.x + r1.y;
  r1.w = cb1[4].x * cb1[3].x;
  r1.z = r1.x * r1.z + r1.w;
  r2.x = cb1[0].x * r1.x + cb1[1].x;
  r2.y = cb1[5].x * cb1[3].x;
  r1.x = r1.x * r2.x + r2.y;
  r1.x = r1.z / r1.x;
  r1.z = cb1[4].x / cb1[5].x;
  r1.y = cb1[0].x * cb1[6].x + r1.y;
  r1.y = cb1[6].x * r1.y + r1.w;
  r1.w = cb1[0].x * cb1[6].x + cb1[1].x;
  r1.w = cb1[6].x * r1.w + r2.y;
  r1.y = r1.y / r1.w;
  r1.xy = r1.xy + -r1.zz;
  r1.y = 1 / r1.y;
  r1.x = r1.x * r1.y;
  r0.w = r1.x / r0.w;

  // Bloom
  r1.xyzw = t1.Sample(s1_s, w1.xy).xyzw;
  r1.xyz = cb1[9].xxx * r1.xyz;

  if (injectedData.toneMapType == 0.f) {
    // Tonemap
    r0.xyz = r0.xyz * r0.www + r1.xyz * injectedData.fxBloom;
    r0.w = cmp(0 < cb1[9].y);
    if (r0.w != 0) {
      r1.xyzw = t2.Sample(s2_s, w1.xy).xyzw;
      r0.xyz = r1.xyz * cb1[9].yyy + r0.xyz;
    }

    float3 input_color = r0.xyz;

    r0.xyz = saturate(r0.xyz);
    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r1.xyzw = t4.Sample(s4_s, r0.xyz).xyzw;
    r0.xyzw = t5.Sample(s5_s, r0.xyz).xyzw;
    r0.xyz = r0.xyz + -r1.xyz;
    r0.xyz = saturate(cb1[11].xxx * r0.xyz + r1.xyz);

    // r0.xyz = t * (b - a) + a
    // r0.xyz = cb1[11].xxx * (r0.xyz + -r1.xyz) + (r1.xyz)

    r0.xyz = log2(r0.xyz);
    r0.xyz = float3(2.20000005, 2.20000005, 2.20000005) * r0.xyz;
    r0.xyz = exp2(r0.xyz);

    r0.xyz = lerp(input_color, r0.xyz, injectedData.colorGradeLUTStrength);

  } else {
    float vanillaMidGray = 0.18f * r0.w;
    // Add bloom to untonemapped
    r0.xyz = r0.xyz + (r1.xyz * injectedData.fxBloom);

    // Add unknown to untonemapped
    r0.w = cmp(0 < cb1[9].y);
    if (r0.w != 0) {
      r1.xyzw = t2.Sample(s2_s, w1.xy).xyzw;
      r0.xyz = r1.xyz * cb1[9].yyy + r0.xyz;
    }

    float3 untonemapped = r0.xyz;

    renodx::tonemap::Config config = renodx::tonemap::config::Create();
    config.type = injectedData.toneMapType;
    config.peak_nits = injectedData.toneMapPeakNits;
    config.game_nits = injectedData.toneMapGameNits;
    config.gamma_correction = injectedData.toneMapGammaCorrection;
    config.exposure = injectedData.colorGradeExposure;
    config.highlights = injectedData.colorGradeHighlights;
    config.shadows = injectedData.colorGradeShadows;
    config.contrast = injectedData.colorGradeContrast;
    config.saturation = injectedData.colorGradeSaturation;
    config.mid_gray_value = vanillaMidGray;
    config.mid_gray_nits = vanillaMidGray * 100.f;

    config.reno_drt_highlights = 1.4f;
    config.reno_drt_shadows = 1.0f;
    config.reno_drt_contrast = 1.00f;
    config.reno_drt_saturation = 1.00f;
    config.reno_drt_dechroma = injectedData.colorGradeBlowout;
    config.reno_drt_flare = lerp(0, 0.10, pow(injectedData.colorGradeFlare, 10.f));

    renodx::tonemap::config::DualToneMap dual_tone_map =
        renodx::tonemap::config::ApplyToneMaps(untonemapped, config);

    float3 hdr_color = dual_tone_map.color_hdr;
    float3 sdr_color = dual_tone_map.color_sdr;

    renodx::lut::Config lut_config = renodx::lut::config::Create(
        s4_s, 1.f, injectedData.colorGradeLUTScaling,
        renodx::lut::config::type::GAMMA_2_2,
        renodx::lut::config::type::GAMMA_2_2);

    float3 lut_color_a = renodx::lut::Sample(t4, lut_config, sdr_color);
    lut_config.lut_sampler = s5_s;
    float3 lut_color_b = renodx::lut::Sample(t5, lut_config, sdr_color);

    float3 lut_color = lerp(lut_color_a, lut_color_b, cb1[11].x);

    float3 final_color = renodx::tonemap::UpgradeToneMap(
        hdr_color, sdr_color, lut_color, injectedData.colorGradeLUTStrength);


    r0.xyz = final_color;

    if (injectedData.toneMapType == 1.f) {
      r0.xyz = untonemapped;
    }
  }

  r0.w = dot(v2.xy, v2.xy);
  r1.xy = cb1[7].zw * v0.xy;
  r1.x = dot(r1.xy, float2(0.0671110004, 0.00583699998));
  r1.x = frac(r1.x);
  r1.x = 52.9829178 * r1.x;
  r1.x = frac(r1.x);
  r0.w = -r1.x * 0.0500000007 + r0.w;
  r0.w = max(0, r0.w);
  r0.w = -0.600000024 + r0.w;
  r0.w = saturate(0.714285731 * r0.w);
  r1.x = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.x * r0.w;
  r0.w = -cb1[10].x * r0.w + 1;
  r0.xyz = r0.xyz * r0.www;
  r0.w = cmp(0 != cb1[12].y);
  r1.xy = cb1[12].zw * v2.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = -r1.x * 0.5 + 1;
  r1.x = max(0, r1.x);
  r1.y = r1.x * r1.x;
  r1.x = r1.x * r1.y;
  r1.xyz = r0.xyz * r1.xxx + -r0.xyz;
  r1.xyz = cb1[12].yyy * r1.xyz + r0.xyz;
  r0.xyz = r0.www ? r1.xyz : r0.xyz;
  r0.w = saturate(dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114)));
  o0.w = sqrt(r0.w);
  o0.xyz = r0.xyz;

  // o0.rgb = testColor.rgb;
  return;
}