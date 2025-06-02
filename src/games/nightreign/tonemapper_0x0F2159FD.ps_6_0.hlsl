#include "./common.hlsl"

Texture2D<float4> g_SourceTexture : register(t0);

Texture2D<float4> g_ToneMapTableTexture : register(t1);

Texture2D<float4> g_GlareAccTexture : register(t3);

Texture2D<float4> g_LocalExposureGuideTexture : register(t9);

Texture3D<float4> g_LocalExposureBilateralGrid : register(t10);

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
  float4 g_vLocalExposureParam : packoffset(c026.x);
  float4 g_vLocalExposureTexScale : packoffset(c027.x);
  uint g_LocalExposureMode : packoffset(c028.x);
  float g_LocalExposureDetailBoost : packoffset(c028.y);
  float2 g_LocalExposureLumMinMax : packoffset(c028.z);
  float g_LocalExposureModeRate : packoffset(c029.x);
  uint padd0 : packoffset(c029.y);
  uint2 padd1 : packoffset(c029.z);
  float4 g_vVignettingColor : packoffset(c030.x);
};

SamplerState SS_ClampLinear : register(s3);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float3 TEXCOORD: TEXCOORD) : SV_Target {
  float4 SV_Target;
  float3 test;
  float _15 = g_dynamicScreenPercentage.x * TEXCOORD.x;
  float _16 = g_dynamicScreenPercentage.y * TEXCOORD.y;
  float4 _17 = g_GlareAccTexture.SampleLevel(SS_ClampLinear, float2(_15, _16), 0.0f);
  float4 _26 = g_SourceTexture.SampleLevel(SS_ClampLinear, float2(_15, _16), 0.0f);
  float _34 = g_ToneMapSceneLumScale.x * _26.x;
  float _35 = g_ToneMapSceneLumScale.y * _26.y;
  float _36 = g_ToneMapSceneLumScale.z * _26.z;

  float _63;
  float _127;
  float _128;
  float _135;
  float _143;
  float _342;
  float _343;
  float _344;
  if (!(g_LocalExposureMode == 0)) {
    do {
      if (!((g_LocalExposureMode & 1) == 0)) {
        float4 _58 = g_LocalExposureGuideTexture.SampleLevel(SS_ClampLinear, float2(min((g_vLocalExposureTexScale.x * TEXCOORD.x), (g_vLocalExposureTexScale.x - (g_vLocalExposureTexScale.z * 0.5f))), min((g_vLocalExposureTexScale.y * TEXCOORD.y), (g_vLocalExposureTexScale.y - (g_vLocalExposureTexScale.w * 0.5f)))), 0.0f);
        _63 = (_58.x - _58.y);
      } else {
        _63 = 0.0f;
      }
      do {
        if (!((g_LocalExposureMode & 2) == 0)) {
          float _68 = log2(dot(float3(_34, _35, _36), float3(0.298909991979599f, 0.5866100192070007f, 0.11448000371456146f)) + 9.999999747378752e-06f);
          float4 _79 = g_LocalExposureBilateralGrid.SampleLevel(SS_ClampLinear, float3(TEXCOORD.x, TEXCOORD.y, ((select(((uint)asint(abs(_68)) > (uint)2139095039), 0.0f, _68) - g_LocalExposureLumMinMax.x) / (g_LocalExposureLumMinMax.y - g_LocalExposureLumMinMax.x))), 0.0f);
          if (_79.y > 0.0f) {
            float _84 = _79.x / _79.y;
            float _87 = _84 - g_vLocalExposureParam.x;
            float _91 = select(((uint)asint(abs(_87)) > (uint)2139095039), 0.0f, _87);
            float _94 = -0.0f - _91;
            do {
              if (!((g_LocalExposureMode & 16) == 0)) {
                float _103 = max((g_vLocalExposureParam.z * 10.0f), 0.0010000000474974513f);
                float _104 = max((g_vLocalExposureParam.w * 10.0f), 0.0010000000474974513f);
                _127 = ((1.0f - exp2(((-0.0f - max(_91, 0.0f)) / (g_vLocalExposureParam.y * _103)) * 1.4426950216293335f)) * _103);
                _128 = ((1.0f - exp2(((-0.0f - max(_94, 0.0f)) / (g_vLocalExposureParam.y * _104)) * 1.4426950216293335f)) * _104);
              } else {
                _127 = (g_vLocalExposureParam.z * max((_91 - g_vLocalExposureParam.y), 0.0f));
                _128 = (g_vLocalExposureParam.w * max((_94 - g_vLocalExposureParam.y), 0.0f));
              }
              _135 = ((_128 - _127) + ((_68 - _84) * g_LocalExposureDetailBoost));
            } while (false);
          } else {
            _135 = 0.0f;
          }
        } else {
          _135 = 0.0f;
        }
        _143 = exp2((g_LocalExposureModeRate * (_135 - _63)) + _63);
      } while (false);
    } while (false);
  } else {
    _143 = 1.0f;
  }
  float _147 = (_143 * _34) + (g_GlareLuminance.x * _17.x);
  float _148 = (_143 * _35) + (g_GlareLuminance.x * _17.y);
  float _149 = (_143 * _36) + (g_GlareLuminance.x * _17.z);
  float _177 = max(0.0f, (mad(_149, (g_mtxColorMultiplyer[0].z), mad(_148, (g_mtxColorMultiplyer[0].y), (_147 * (g_mtxColorMultiplyer[0].x)))) + (g_mtxColorMultiplyer[0].w)));
  float _178 = max(0.0f, (mad(_149, (g_mtxColorMultiplyer[1].z), mad(_148, (g_mtxColorMultiplyer[1].y), ((g_mtxColorMultiplyer[1].x) * _147))) + (g_mtxColorMultiplyer[1].w)));
  float _179 = max(0.0f, (mad(_149, (g_mtxColorMultiplyer[2].z), mad(_148, (g_mtxColorMultiplyer[2].y), ((g_mtxColorMultiplyer[2].x) * _147))) + (g_mtxColorMultiplyer[2].w)));

  float3 untonemapped = float3(_177, _178, _179);

  float4 _192 = g_ToneMapTableTexture.SampleLevel(SS_ClampLinear, float2((((_177 / (_177 + 0.20000000298023224f)) * 0.9990234375f) + 0.00048828125f), 0.0f), 0.0f);
  float4 _194 = g_ToneMapTableTexture.SampleLevel(SS_ClampLinear, float2((((_178 / (_178 + 0.20000000298023224f)) * 0.9990234375f) + 0.00048828125f), 0.0f), 0.0f);
  float4 _196 = g_ToneMapTableTexture.SampleLevel(SS_ClampLinear, float2((((_179 / (_179 + 0.20000000298023224f)) * 0.9990234375f) + 0.00048828125f), 0.0f), 0.0f);

  float3 sceneColor = float3(_192.r, _194.r, _196.r);

  float _207 = g_vVignettingParam.x * ((TEXCOORD.x * 2.0f) + -1.0f);
  float _208 = g_vVignettingParam.y * ((TEXCOORD.y * 2.0f) + -1.0f);
  float _215 = saturate(1.0f - saturate((sqrt(dot(float2(_207, _208), float2(_207, _208))) * g_vVignettingParam.z) + g_vVignettingParam.w));
  float _219 = (_215 * _215) * (3.0f - (_215 * 2.0f));
  float _220 = _219 * _219;
  float _221 = _220 * _220;

  const float vanilla_gamma = 1 / g_ToneMapParam.z;
  sceneColor = ((_221 * (sceneColor - g_vVignettingColor.rgb)) + g_vVignettingColor.rgb);

  // g_ToneMapParam.z is 0.4545 according to renderdoc, might be different for SDR (Doubt)
  // Lut takes in gamma 2.2 (0.4545 = 1 / 2.2)
  float4 _258 = g_ColorGradingLUTTexture.Sample(SS_ClampLinear, ((exp2(log2(max(sceneColor.rgb, 0.0f)) * g_ToneMapParam.z) * 0.9375f) + 0.03125f));

  [branch]
  if (!(g_bEnableFlags.z == 0)) {
    // Only run in HDR, game launches in SDR
    if (RENODX_TONE_MAP_TYPE) {
      float3 sdr_gamma = _258.rgb;
      float3 sdr_linear = renodx::color::gamma::DecodeSafe(sdr_gamma, vanilla_gamma);
      float3 outputColor = renodx::draw::ToneMapPass(untonemapped, sdr_linear);
      outputColor = renodx::color::correct::GammaSafe(outputColor);
      outputColor = renodx::color::pq::EncodeSafe(outputColor, RENODX_DIFFUSE_WHITE_NITS);

      _342 = outputColor.r;
      _343 = outputColor.g;
      _344 = outputColor.b;
    } else {
      // HDR Inv tonemap

      // Decode the lut output (gamma 2.2)
      float _263 = 1.0f / g_ToneMapParam.z;
      float _273 = exp2(log2(max(_258.x, 0.0f)) * _263);
      float _274 = exp2(log2(max(_258.y, 0.0f)) * _263);
      float _275 = exp2(log2(max(_258.z, 0.0f)) * _263);

      float _287 = 1.0f / g_ReinhardParam.x;  // g_ReinhardParam.x = 1.9
      float _297 = dot(float3(
                           exp2(log2(_273 / max((1.0f - _273), 0.009999999776482582f)) * _287),
                           exp2(log2(_274 / max((1.0f - _274), 0.009999999776482582f)) * _287),
                           exp2(log2(_275 / max((1.0f - _275), 0.009999999776482582f)) * _287)),
                       float3(0.298909991979599f, 0.5866100192070007f, 0.11448000371456146f));
      float _300 = (pow(_297, g_ReinhardParam.x));
      float _308 = exp2(log2(((_297 + -1.0f) * 0.05263157933950424f) + 1.0f) * g_ReinhardParam.x);
      float _315 = select((_297 > 1.0f), ((((_308 / (_308 + 1.0f)) + -0.5f) * 19.0f) + 0.5f), (_300 / (_300 + 1.0f)));
      float _320 = dot(float3(_273, _274, _275), float3(0.298909991979599f, 0.5866100192070007f, 0.11448000371456146f)) + 9.999999747378752e-05f;
      _342 = (exp2(log2(g_vHDRDisplayParam.y * ((_315 * _273) / _320)) * 0.3030303120613098f) * 0.49770236015319824f);
      _343 = (exp2(log2(g_vHDRDisplayParam.y * ((_315 * _274) / _320)) * 0.3030303120613098f) * 0.49770236015319824f);
      _344 = (exp2(log2(g_vHDRDisplayParam.y * ((_315 * _275) / _320)) * 0.3030303120613098f) * 0.49770236015319824f);

      // Rewritten
      /* sceneColor = _258.rgb;                                                                        // lut output is in gamma
      sceneColor = renodx::color::gamma::DecodeSafe(max(sceneColor, 0.f), 1.f / g_ToneMapParam.b);  // 2.2f
      float reinhardGamma = g_ReinhardParam.x;
      float3 tempScene = sceneColor.rgb / max(1.f - sceneColor.rgb, 0.00999);
      float luminance_in_gamma = renodx::color::y::from::NTSC1953(renodx::color::gamma::EncodeSafe(tempScene, reinhardGamma));
      float luminance_linear = renodx::color::gamma::DecodeSafe(luminance_in_gamma, reinhardGamma); */
    }

  } else {
    // SDR
    _342 = _258.x;
    _343 = _258.y;
    _344 = _258.z;
  }
  SV_Target.x = _342;
  SV_Target.y = _343;
  SV_Target.z = _344;

  SV_Target.w = 1.0f;

  return SV_Target;
}
