#include "../common.hlsli"
// Resource Bindings:
//
// Name                                 Type  Format         Dim      ID      HLSL Bind  Count
// ------------------------------ ---------- ------- ----------- ------- -------------- ------
// SceneSampler                      sampler      NA          NA      S0      s0,space8      1
// SceneTexture                      texture  float4          2d      T0      t0,space8      1
// ShaderInstance_PerInstance        cbuffer      NA          NA     CB0     cb0,space8      1
Texture2D<float4> SceneTexture : register(t0, space8);

SamplerState SceneSampler : register(s0, space8);

cbuffer ShaderInstance_PerInstance : register(b0, space8) {
  struct InUniformParams {
    float4 mHDRCompressionControl;  // cb0[0],     Offset:    0
    float4 mHDRCompressionParam1;   // cb0[1],     Offset:   16
    float4 mHDRCompressionParam2;   // cb0[2],     Offset:   32
    float4 mHDRCompressionParam3;   // cb0[3],     Offset:   48
    float2 mRgb3dLookupScaleBias;   // cb0[4].xy,  Offset:   64
    float2 _padding0;               // cb0[4].zw,  Offset:   72 (for alignment)
    float4 mOETFSettingsPQ;         // cb0[5],     Offset:   80
    float4 mOETFSettings;           // cb0[6],     Offset:   96
  };
  InUniformParams mInUniformParams;
}

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_TARGET0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;
  o0.w = 1;

  r0.xyz = SceneTexture.Sample(SceneSampler, v1.xy).xyz;
  int output_mode = (int)mInUniformParams.mOETFSettingsPQ.w;
  // const float peak_white = 100.f;
  const float peak_white = mInUniformParams.mHDRCompressionParam3.x;

  // r0.rgb = renodx::color::pq::DecodeSafe(r0.rgb);
  // // const float peak_white = 400.f;
  // // const float diffuse_white = 100.f;
  // float3 untonemapped = r0.rgb;
  // // r0.rgb = exp2(renodx::tonemap::ExponentialRollOff(log2(untonemapped), log2(peak_white * 0.25f), log2(peak_white)));
  // // renodx::color::correct::Hue(r0.rgb, untonemapped);
  // o0.rgb = renodx::color::pq::EncodeSafe(r0.rgb);

  // o0.rgb = renodx::tonemap::ExponentialRollOff(r0.rgb, log2(peak_white * 0.375f), log2(peak_white));
  // return;

  if (output_mode == 0) {
    r1.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
    r1.w = 1 / mInUniformParams.mOETFSettingsPQ.x;
    r2.xy = log2(r1.xy);
    r2.z = log2(r1.z);
    r1.xyz = r2.xyz * r1.www;
    r0.xyz = exp2(r1.xyz);
  } else {
    if (output_mode == 2) {
      r1.xyz = log2(r0.xyz);
      r1.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r1.xyz;
      r1.xyz = exp2(r1.xyz);
      r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r1.xyz;
      r1.xyz = -r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
      r1.xyz = r2.xyz / r1.xyz;
      r1.xyz = max(float3(0, 0, 0), r1.xyz);
      r2.xy = float2(1, 1) / mInUniformParams.mOETFSettingsPQ.xy;
      r1.xyz = log2(r1.xyz);
      r1.xyz = r2.xxx * r1.xyz;
      r1.xyz = exp2(r1.xyz);
      r1.xyz = r1.xyz * r2.yyy;

      // r1.rgb = renodx::color::pq::DecodeSafe(r0.rgb, 1.f);

      r0.rgb = renodx::color::bt709::from::BT2020(r1.rgb);
    }
  }

  float3 untonemapped = r0.rgb;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.rgb = ApplyDeathStrandingToneMap(untonemapped, mInUniformParams.mHDRCompressionParam1,
                                        mInUniformParams.mHDRCompressionParam2, mInUniformParams.mHDRCompressionParam3);
  } else {
    r0.rgb = ApplyDeathStrandingToneMap(untonemapped, mInUniformParams.mHDRCompressionParam1,
                                        mInUniformParams.mHDRCompressionParam2, mInUniformParams.mHDRCompressionParam3, 1u);

    float peak_white = renodx::color::correct::GammaSafe(RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS, true);
    if (RENODX_TONE_MAP_TYPE == 2.f) {
      r0.rgb = ApplyDisplayMap(r0.rgb);
    }
    r0.rgb = ScaleScene(r0.rgb);
  }

  if (output_mode == 0) {
    r1.xyz = log2(r0.xyz);
    r1.xyz = mInUniformParams.mOETFSettings.xxx * r1.xyz;
    r2.xyz = exp2(r1.xyz);
    r3.xyz = cmp(r2.xyz < float3(0.00310000009, 0.00310000009, 0.00310000009));
    r2.xyz = float3(12.9200001, 12.9200001, 12.9200001) * r2.xyz;
    r1.xyz = float3(0.416666657, 0.416666657, 0.416666657) * r1.xyz;
    r1.xyz = exp2(r1.xyz);
    r1.xyz = r1.xyz * float3(1.05499995, 1.05499995, 1.05499995) + float3(-0.0549999997, -0.0549999997, -0.0549999997);
    r0.xyz = r3.xyz ? r2.xyz : r1.xyz;
  } else {
    if (output_mode == 2) {
      r1.x = dot(float3(0.627403915, 0.329283029, 0.0433130674), r0.xyz);
      r1.y = dot(float3(0.069097288, 0.919540405, 0.0113623161), r0.xyz);
      r1.z = dot(float3(0.0163914394, 0.0880133063, 0.895595253), r0.xyz);
      r1.xyz = mInUniformParams.mOETFSettingsPQ.yyy * r1.xyz;
      r1.xyz = log2(r1.xyz);
      r1.xyz = mInUniformParams.mOETFSettingsPQ.xxx * r1.xyz;
      r1.xyz = exp2(r1.xyz);
      r2.xyzw = r1.xxyy * float4(18.8515625, 18.6875, 18.8515625, 18.6875) + float4(0.8359375, 1, 0.8359375, 1);
      r1.xy = r2.xz / r2.yw;
      r1.xy = log2(r1.xy);
      r1.xy = float2(78.84375, 78.84375) * r1.xy;
      r0.xy = exp2(r1.xy);
      r1.xy = r1.zz * float2(18.8515625, 18.6875) + float2(0.8359375, 1);
      r0.w = r1.x / r1.y;
      r0.w = log2(r0.w);
      r0.w = 78.84375 * r0.w;
      r0.z = exp2(r0.w);
    }
  }
  o0.xyz = r0.xyz;
  return;
}
