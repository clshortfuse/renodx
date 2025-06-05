#include "../common.hlsl"

Texture2D<float4> g_SourceTexture : register(t0);

Texture2D<float4> g_ToneMapTableTexture : register(t1);

Texture2D<float4> g_GlareAccTexture : register(t3);

Texture3D<float4> g_ColorGradingLUTTexture : register(t2);

cbuffer cbPostProcessCommon : register(b4) {
  float2 g_dynamicScreenPercentage : packoffset(c000.x);
  float2 g_texSizeReciprocal : packoffset(c000.z);
  float2 g_dynamicScreenPercentage_Primary : packoffset(c001.x);
  float2 g_primaryTexSizeReciprocal : packoffset(c001.z);
  float2 g_dynamicScreenPercentage_Prev : packoffset(c002.x);
  float2 g_prevTexSizeReciprocal : packoffset(c002.z);
  float2 g_dynamicScreenPercentage_PrevPrimary : packoffset(c003.x);
  float2 g_prevPrimaryTexSizeReciprocal : packoffset(c003.z);
};

cbuffer cbToneMap : register(b1) {
  float3 g_ToneMapInvSceneLumScale : packoffset(c000.x);
  float4 g_ReinhardParam : packoffset(c001.x);
  float4 g_ToneMapParam : packoffset(c002.x);
  float4 g_ToneMapSceneLumScale : packoffset(c003.x);
  float4 g_AdaptParam : packoffset(c004.x);
  float4 g_AdaptCenterWeight : packoffset(c005.x);
  float4 g_BrightPassThreshold : packoffset(c006.x);
  float4 g_GlareLuminance : packoffset(c007.x);
  float4 g_BloomBoostColor : packoffset(c008.x);
  float4 g_vBloomFinalColor : packoffset(c009.x);
  float4 g_vBloomScaleParam : packoffset(c010.x);
  float4 g_mtxColorMultiplyer[3] : packoffset(c011.x);
  float4 g_vChromaticAberrationRG : packoffset(c014.x);
  float4 g_vChromaticAberrationB : packoffset(c015.x);
  int4 g_bEnableFlags : packoffset(c016.x);
  float4 g_vFeedBackBlurParam : packoffset(c017.x);
  float4 g_vVignettingParam : packoffset(c018.x);
  float4 g_vHDRDisplayParam : packoffset(c019.x);
  float4 g_vChromaticAberrationShapeParam : packoffset(c020.x);
  float4 g_vScreenSize : packoffset(c021.x);
  float4 g_vSampleDistanceAdjust : packoffset(c022.x);
  uint4 g_vMaxSampleCount : packoffset(c023.x);
  float4 g_vScenePreExposure : packoffset(c024.x);
  float4 g_vCameraParam : packoffset(c025.x);
};

SamplerState SS_ClampLinear : register(s1);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float3 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float _13 = g_dynamicScreenPercentage.x * TEXCOORD.x;
  float _14 = g_dynamicScreenPercentage.y * TEXCOORD.y;
  float4 _15 = g_GlareAccTexture.SampleLevel(SS_ClampLinear, float2(_13, _14), 0.0f);
  float4 _24 = g_SourceTexture.SampleLevel(SS_ClampLinear, float2(_13, _14), 0.0f);
  float _35 = (g_ToneMapSceneLumScale.x * _24.x) + (g_GlareLuminance.x * _15.x);
  float _36 = (g_ToneMapSceneLumScale.y * _24.y) + (g_GlareLuminance.x * _15.y);
  float _37 = (g_ToneMapSceneLumScale.z * _24.z) + (g_GlareLuminance.x * _15.z);
  float _65 = max(0.0f, (mad(_37, (g_mtxColorMultiplyer[0].z), mad(_36, (g_mtxColorMultiplyer[0].y), (_35 * (g_mtxColorMultiplyer[0].x)))) + (g_mtxColorMultiplyer[0].w)));
  float _66 = max(0.0f, (mad(_37, (g_mtxColorMultiplyer[1].z), mad(_36, (g_mtxColorMultiplyer[1].y), (_35 * (g_mtxColorMultiplyer[1].x)))) + (g_mtxColorMultiplyer[1].w)));
  float _67 = max(0.0f, (mad(_37, (g_mtxColorMultiplyer[2].z), mad(_36, (g_mtxColorMultiplyer[2].y), ((g_mtxColorMultiplyer[2].x) * _35))) + (g_mtxColorMultiplyer[2].w)));

  float3 untonemapped = float3(_65, _66, _67);
  if (CUSTOM_MATCH_MIDGRAY) {
    float y_in = renodx::color::y::from::NTSC1953(untonemapped);
    float y_out = g_ToneMapTableTexture.SampleLevel(SS_ClampLinear, float2((((y_in / (y_in + 0.20000000298023224f)) * 0.9990234375f) + 0.00048828125f), 0.0f), 0.0f).r;
    const float midgray = 0.18f;
    float midgray_lum = g_ToneMapTableTexture.SampleLevel(SS_ClampLinear, float2((((midgray / (midgray + 0.20000000298023224f)) * 0.9990234375f) + 0.00048828125f), 0.0f), 0.0f).r;

    float3 luminance_tonemapped = untonemapped * (y_out / y_in);
    untonemapped = untonemapped * (midgray_lum / midgray);
    untonemapped = lerp(luminance_tonemapped, untonemapped, saturate(luminance_tonemapped));
  }

  float3 sdr_tonemapped;
  if (!ApplyLuminanceSaturationAdjustments(untonemapped, sdr_tonemapped)) {
    float4 _74 = g_ToneMapTableTexture.SampleLevel(SS_ClampLinear, float2((_65 / (_65 + 0.20000000298023224f)), 0.0f), 0.0f);
    float4 _76 = g_ToneMapTableTexture.SampleLevel(SS_ClampLinear, float2((_66 / (_66 + 0.20000000298023224f)), 0.0f), 0.0f);
    float4 _78 = g_ToneMapTableTexture.SampleLevel(SS_ClampLinear, float2((_67 / (_67 + 0.20000000298023224f)), 0.0f), 0.0f);

    sdr_tonemapped = float3(_74.x, _76.x, _78.x);
  }
  float _89 = g_vVignettingParam.x * ((TEXCOORD.x * 2.0f) + -1.0f);
  float _90 = g_vVignettingParam.y * ((TEXCOORD.y * 2.0f) + -1.0f);
  float _97 = saturate(1.0f - saturate((sqrt(dot(float2(_89, _90), float2(_89, _90))) * g_vVignettingParam.z) + g_vVignettingParam.w));
  float _101 = (_97 * _97) * (3.0f - (_97 * 2.0f));
  float _102 = _101 * _101;
  float _103 = _102 * _102;

  const float vanilla_gamma = 1 / g_ToneMapParam.z;

  float4 _130 = g_ColorGradingLUTTexture.Sample(SS_ClampLinear, float3(((exp2(log2(max((_103 * sdr_tonemapped.r), 0.0f)) * g_ToneMapParam.z) * 0.9375f) + 0.03125f), ((exp2(log2(max((_103 * sdr_tonemapped.g), 0.0f)) * g_ToneMapParam.z) * 0.9375f) + 0.03125f), ((exp2(log2(max((_103 * sdr_tonemapped.b), 0.0f)) * g_ToneMapParam.z) * 0.9375f) + 0.03125f)));
  if (RENODX_TONE_MAP_TYPE) {
    _130.rgb = SampleLUT((sdr_tonemapped * _103), g_ColorGradingLUTTexture, SS_ClampLinear);
  }
  float _214;
  float _215;
  float _216;
  [branch]
  if (!(g_bEnableFlags.z == 0)) {
    if (Tonemap(untonemapped, _130, SV_Target, TEXCOORD)) {
      return SV_Target;
    } else {
      float _135 = 1.0f / g_ToneMapParam.z;
      float _145 = exp2(log2(max(_130.x, 0.0f)) * _135);
      float _146 = exp2(log2(max(_130.y, 0.0f)) * _135);
      float _147 = exp2(log2(max(_130.z, 0.0f)) * _135);
      float _159 = 1.0f / g_ReinhardParam.x;
      float _169 = dot(float3(exp2(log2(_145 / max((1.0f - _145), 0.009999999776482582f)) * _159), exp2(log2(_146 / max((1.0f - _146), 0.009999999776482582f)) * _159), exp2(log2(_147 / max((1.0f - _147), 0.009999999776482582f)) * _159)), float3(0.298909991979599f, 0.5866100192070007f, 0.11448000371456146f));
      float _172 = (pow(_169, g_ReinhardParam.x));
      float _180 = exp2(log2(((_169 + -1.0f) * 0.05263157933950424f) + 1.0f) * g_ReinhardParam.x);
      float _187 = select((_169 > 1.0f), ((((_180 / (_180 + 1.0f)) + -0.5f) * 19.0f) + 0.5f), (_172 / (_172 + 1.0f)));
      float _192 = dot(float3(_145, _146, _147), float3(0.298909991979599f, 0.5866100192070007f, 0.11448000371456146f)) + 9.999999747378752e-05f;
      _214 = (exp2(log2(g_vHDRDisplayParam.y * ((_187 * _145) / _192)) * 0.3030303120613098f) * 0.49770236015319824f);
      _215 = (exp2(log2(g_vHDRDisplayParam.y * ((_187 * _146) / _192)) * 0.3030303120613098f) * 0.49770236015319824f);
      _216 = (exp2(log2(g_vHDRDisplayParam.y * ((_187 * _147) / _192)) * 0.3030303120613098f) * 0.49770236015319824f);
    }
  } else {
    _214 = _130.x;
    _215 = _130.y;
    _216 = _130.z;
  }
  SV_Target.x = _214;
  SV_Target.y = _215;
  SV_Target.z = _216;
  SV_Target.w = 1.0f;
  return SV_Target;
}
