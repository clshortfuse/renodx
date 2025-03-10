#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:50 2024
Texture3D<float4> t6 : register(t6);

Texture3D<float4> t5 : register(t5);

Texture3D<float4> t4 : register(t4);

Texture3D<float4> t3 : register(t3);

Texture2D<float4> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[2];
}

// 3Dmigoto declarations
#define cmp -

void main(float4 v0: SV_POSITION0, float2 v1: TEXCOORD0, out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  // r0.xyz = log2(r0.xyz);

  o0.w = r0.w;

  renodx::lut::Config lut_config = renodx::lut::config::Create(
      s3_s,
      1.f,
      injectedData.colorGradeLUTScaling,  // Cleans up raised black floor
      renodx::lut::config::type::GAMMA_2_2,
      renodx::lut::config::type::GAMMA_2_2,
      16);

  float3 outputColor = r0.rgb;
  renodx::tonemap::config::DualToneMap dualToneMap = ApplyDualToneMap(r0.rgb);
  if (injectedData.colorGradeLUTStrength == 0.f || injectedData.toneMapType == 1.f) {
    outputColor = dualToneMap.color_hdr;
  } else {
    float3 hdrColor = dualToneMap.color_hdr;
    float3 sdrColor = dualToneMap.color_sdr;

    // r0.xyz = float3(0.454545468,0.454545468,0.454545468) * r0.xyz;
    // r0.xyz = exp2(r0.xyz);

    r0.xyz = sdrColor;
    r1.xyz = r0.xyz;  // * float3(0.9375,0.9375,0.9375) + float3(0.03125,0.03125,0.03125);

    r2.xyz = renodx::lut::Sample(t3, lut_config, r1.xyz);  // r2.xyz = t3.Sample(s3_s, r1.xyz).xyz;

    r2.xyz = cb2[0].xxx * r2.xyz;
    r0.xyz = r0.xyz * cb2[1].xxx + r2.xyz;

    lut_config.lut_sampler = s4_s;
    r2.xyz = renodx::lut::Sample(t4, lut_config, r1.xyz);  // r2.xyz = t4.Sample(s4_s, r1.xyz).xyz;

    r0.xyz = r2.xyz * cb2[0].yyy + r0.xyz;

    lut_config.lut_sampler = s5_s;
    r2.xyz = renodx::lut::Sample(t5, lut_config, r1.xyz);  // r2.xyz = t5.Sample(s5_s, r1.xyz).xyz;

    lut_config.lut_sampler = s6_s;
    r1.xyz = renodx::lut::Sample(t6, lut_config, r1.xyz);  // r1.xyz = t6.Sample(s6_s, r1.xyz).xyz;

    r0.xyz = r2.xyz * cb2[0].zzz + r0.xyz;
    o0.xyz = r1.xyz * cb2[0].www + r0.xyz;

    if (injectedData.toneMapType == 0.f) {
      outputColor = lerp(outputColor, o0.xyz, injectedData.colorGradeLUTStrength);
    } else {
      outputColor = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, o0.xyz, injectedData.colorGradeLUTStrength);
    }
  }
  o0.rgb = outputColor;
  if (injectedData.fxFilmGrain) {
    float3 grainedColor = renodx::effects::ApplyFilmGrain(
        o0.rgb,
        v1.xy,
        frac(injectedData.elapsedTime / 1000.f),
        injectedData.fxFilmGrain * 0.03f,
        1.f);
    o0.xyz = grainedColor;
  }

  if (!injectedData.toneMapGammaCorrection) {
    o0.rgb = renodx::color::correct::GammaSafe(o0.rgb, true);
  }

  o0.rgb *= injectedData.toneMapGameNits / 80.f;
  return;
}
