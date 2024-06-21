#include "../../shaders/tonemap.hlsl"
#include "./shared.h"

struct FrameDebug {
  uint2 value00;  // _23_m0[3u].xy
  uint2 value01;  // _23_m0[3u].zw
  uint2 value02;  // _23_m0[4u].xy
  uint value03;   // _23_m0[4u].z
  uint value04;   // _23_m0[4u].w
  float value05;  // _23_m0[5u].x
  uint value06;   // _23_m0[5u].y
  uint value07;   // _23_m0[5u].z
  uint value08;   // _23_m0[5u].w
  uint value09;   // _23_m0[6u].x
  uint value10;   // _23_m0[6u].y
  uint value11;   // _23_m0[6u].z
  uint value12;   // _23_m0[6u].w
};

cbuffer SharedFrameData : register(b0, space6) {
  struct FrameData {
    uint value00;           // _23_m0[0u].x
    uint value01;           // _23_m0[0u].y
    float2 value02;         // _23_m0[0u].zw
    float value03;          // _23_m0[1u].x
    float value04;          // _23_m0[1u].y
    float value05;          // _23_m0[1u].z
    float fGamma;          // _23_m0[1u].w
    float fContrast;          // _23_m0[2u].x
    uint supportsHDR;           // _23_m0[2u].y
    float fBrightnessHDR;          // _23_m0[2u].z
    float lutScalingPow;          // _23_m0[2u].w
    FrameDebug frameDebug;  // _23_m0[3u-6u].xyzw
    float4 value12;         // _23_m0[7u].xyzw
    float value13;          // _23_m0[8u].x
    float value14;          // _23_m0[8u].y
    uint value15;           // _23_m0[8u].z
    uint value16;           // _23_m0[8u].w
  } frameData : packoffset(c0);
}

#ifdef USE_TONEMAP
cbuffer PerSceneConstants : register(b0, space7) {
  float4 _28_m0[3265] : packoffset(c0);
}

cbuffer stub_PushConstantWrapper_HDRComposite : register(b0, space0) {
  struct PushConstantWrapper_HDRComposite {
    uint value00;      // _33_m0[0u].x
    uint toneMapType;  // _33_m0[1u].x
    uint value02;      // _33_m0[2u].x
  } pushConstants : packoffset(c0);
}
#endif

Texture2D<float3> _8 : register(t0, space9);  // untonemapped
Texture2D<float> _9 : register(t1, space9);   // unknown R8_UNORM
#ifdef USE_BLOOM
Texture2D<float3> _10 : register(t2, space9);  // bloom
#endif
Texture3D<float3> _13 : register(t3, space9);  // rgba16_float LUT

#ifdef USE_TONEMAP
struct HDRCompositeData {
  float4 value00;
  float4 value01;
  float value02;
  float value03;
  float value04;
  uint value05;
};

StructuredBuffer<HDRCompositeData> _17 : register(t4, space9);
#endif
SamplerState _36 : register(s0, space9);

float4 HDRComposite(float4 gl_FragCoord : SV_Position, float2 TEXCOORD : TEXCOORD0) : SV_Target {
  float3 _126 = _8.Load(int3(uint2(uint(gl_FragCoord.x), uint(gl_FragCoord.y)), 0u));
  float3 inputColor = _126;

#ifdef USE_TONEMAP
  uint _64 = pushConstants.value00;
  uint _66 = _64 * 12u;
  float4 colorFilter = _17[_64].value00;

  float colorFilterStrength = colorFilter.w;

  float4 colorFilter2 = _17[_64].value01;

  float colorFilter2Strength = colorFilter2.w;

  float _111 = _17[_64].value02;
  float _116 = _17[_64].value03;
  float _122 = _17[_64].value04;

#ifdef USE_BLOOM
  float _138;
  if (frameData.supportsHDR == 0u) {
    _138 = 1.0f;
  } else {
    _138 = lerp(frameData.fBrightnessHDR, 1.f, 0.85f);
  }
  float3 _146 = _10.SampleLevel(_36, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);  // Bloom
  float _152 = asfloat(pushConstants.value02);
  inputColor = _126 + (_138 * _146 * _152 * injectedData.fxBloom);
#endif  // USE_BLOOM

  float vanillaMidGray = 0.18f;
  float renoDRTContrast = 1.2f;
  float renoDRTFlare = 0.01f;
  float renoDRTShadows = 0.60f;
  float renoDRTDechroma = 0.50f;
  float renoDRTSaturation = 1.20f;
  float renoDRTHighlights = 1.10f;

  // float vanillaMidGray = 0.18f;
  // float renoDRTContrast = 1.0f;
  // float renoDRTFlare = 0.f;
  // float renoDRTShadows = 1.f;
  // float renoDRTDechroma = 0.5f;
  // float renoDRTSaturation = 1.0f;
  // float renoDRTHighlights = 1.0f;

  float3 hdrColor;
  float3 sdrColor;

  float customACESParam;
  if (pushConstants.toneMapType == 2u) {
    customACESParam = ((0.56f / _28_m0[3262u].x) + 2.43f) + (_28_m0[3262u].y / (_28_m0[3262u].x * _28_m0[3262u].x));
  }
  // Sample midgray for vanilla
  if (injectedData.toneMapType != 0.f) {
    // Grab vanilla midgray
    if (pushConstants.toneMapType == 1u) {
      // ACES SDR
      vanillaMidGray = saturate((((0.18f * 2.51f) + 0.03f) * 0.18f) / ((((0.18f * 2.43f) + 0.59f) * 0.18f) + 0.14f));
    } else if (pushConstants.toneMapType == 2u) {
      // Custom ACES SDR
      vanillaMidGray = saturate((((customACESParam * 0.18f) + 0.03f) * 0.18f) / (_28_m0[3262u].y + (((0.18f * 2.43f) + 0.59f) * 0.18f)));
    } else if (pushConstants.toneMapType == 3u) {
      // Custom Hable SDR

      float _520 = pow(saturate(_28_m0[3262u].w), 2.2f);
      float _522a = saturate(_28_m0[3262u].z);
      float _525a = saturate(_28_m0[3263u].y);
      float _525b = clamp(_525a, 1.1920928955078125e-07f, 0.999989986419677734375f);

      float _517 = max(0.0f, _28_m0[3263u].x);
      float _519 = saturate(_28_m0[3263u].z);

      float _522 = _520 * 0.5f * (1.0f - _522a);
      float _523 = 1.0f - _522;
      float _525 = (1.0f - _525b) * _523;

      float _570a = _525 + _522;
      float _532a = exp2(_517);

      float _532 = ((_520 + (-0.99999988079071044921875f)) + _523) + _532a;
      float _534 = (_517 * 2.0f) * _519;
      float _538 = 1.0f / _532;
      float _539 = _520 / _532;
      float _540 = (_525 + _520) / _532;
      float _541 = _525 / _532;
      float _545 = (abs(_541) < 1.1920928955078125e-07f) ? 1.0f : (_525 / _541);
      float _548 = _545 + 1.1920928955078125e-07f;
      float _549 = (_522 - (_545 * _539)) / _548;
      float _550 = log2(_548);
      float _553 = max(1.1920928955078125e-07f, exp2(log2(_522)));
      float _559 = exp2(log2(((_517 * 0.5f) * _519) + 1.0f));
      float _562 = (_548 * _539) / (_553 + 1.1920928955078125e-07f);
      float _563 = log2(_553);
      float _567 = (_562 * (-0.693147182464599609375f)) * log2(_539);
      float _569 = (1.0f - _540) + _534;
      float _570 = _559 - max(1.1920928955078125e-07f, exp2(log2(_570a)));
      float _578 = ((_548 * _569) / (_570 + 1.1920928955078125e-07f)) * 0.693147182464599609375f;
      float _580 = (log2(_570) * 0.693147182464599609375f) - (_578 * log2(_569));
      float _590;
      if (_534 > 0.0f) {
        precise float _588 = (-0.0f) - exp2(((_578 * log2(_534)) + _580) * 1.44269502162933349609375f);
        _590 = _588;
      } else {
        _590 = -0.0f;
      }
      float _592 = 1.0f / (_590 + _559);
      uint _599;
      float _596 = 0.18f;
      float _600;
      bool _601;

      _600 = _596 * _538;
      _601 = _600 < _539;
      float _611;
      if (_601) {
        float frontier_phi_20_17_ladder;
        if (_600 > 0.0f) {
          frontier_phi_20_17_ladder = exp2(
            ((((log2(_600) * _562) + _563) * 0.693147182464599609375f) + _567) * 1.44269502162933349609375f
          );
        } else {
          frontier_phi_20_17_ladder = 0.0f;
        }
        _611 = frontier_phi_20_17_ladder;
      } else {
        float frontier_phi_20_18_ladder;
        if (_600 < _540) {
          float _617 = _600 + _549;
          float frontier_phi_20_18_ladder_21_ladder;
          if (_617 > 0.0f) {
            frontier_phi_20_18_ladder_21_ladder = exp2(log2(_617) + _550);
          } else {
            frontier_phi_20_18_ladder_21_ladder = 0.0f;
          }
          frontier_phi_20_18_ladder = frontier_phi_20_18_ladder_21_ladder;
        } else {
          float _620 = ((-1.0f) - _534) + _600;
          float _631;
          if (_620 < (-0.0f)) {
            _631 = exp2(((_578 * log2((-0.0f) - _620)) + _580) * 1.44269502162933349609375f);
          } else {
            _631 = 0.0f;
          }
          frontier_phi_20_18_ladder = _559 - _631;
        }
        _611 = frontier_phi_20_18_ladder;
      }
      precise float _614 = _611 * _592;
      vanillaMidGray = _614;
    }
  }

  ToneMapParams tmParams = buildToneMapParams(
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
    renoDRTFlare
  );

  if (tmParams.type == 3.f) {
    tmParams.renoDRTSaturation *= tmParams.saturation;

    sdrColor = renoDRTToneMap(inputColor, tmParams, true);

    tmParams.renoDRTHighlights *= tmParams.highlights;
    tmParams.renoDRTShadows *= tmParams.shadows;
    tmParams.renoDRTContrast *= tmParams.contrast;

    hdrColor = renoDRTToneMap(inputColor, tmParams);
  } else {
    inputColor = applyUserColorGrading(
      inputColor,
      tmParams.exposure,
      tmParams.highlights,
      tmParams.shadows,
      tmParams.contrast,
      tmParams.saturation
    );

    if (tmParams.type == 1.f) {
      hdrColor = inputColor;
      sdrColor = saturate(inputColor);
    } else if (tmParams.type == 2.f) {
      hdrColor = acesToneMap(inputColor, tmParams);
      sdrColor = acesToneMap(inputColor, tmParams, true);
    } else {
      if (pushConstants.toneMapType == 0u) {
        // Clip SDR
        sdrColor = saturate(inputColor);
      } else if (pushConstants.toneMapType == 1u) {
        // ACES SDR
        sdrColor = saturate((((inputColor * 2.51f) + 0.03f) * inputColor) / ((((inputColor * 2.43f) + 0.59f) * inputColor) + 0.14f));
      } else if (pushConstants.toneMapType == 2u) {
        // Custom ACES SDR
        sdrColor = saturate((((customACESParam * inputColor) + 0.03f) * inputColor) / (_28_m0[3262u].y + (((inputColor * 2.43f) + 0.59f) * inputColor)));
      } else if (pushConstants.toneMapType == 3u) {
        // Custom Hable SDR
        float _159 = inputColor.r;
        float _160 = inputColor.g;
        float _161 = inputColor.b;

        float _57[3];
        _57[0u] = _159;
        _57[1u] = _160;
        _57[2u] = _161;
        float _520 = pow(saturate(_28_m0[3262u].w), 2.2f);
        float _522a = saturate(_28_m0[3262u].z);
        float _525a = saturate(_28_m0[3263u].y);
        float _525b = clamp(_525a, 1.1920928955078125e-07f, 0.999989986419677734375f);

        float _517 = max(0.0f, _28_m0[3263u].x);
        float _519 = saturate(_28_m0[3263u].z);

        float _522 = _520 * 0.5f * (1.0f - _522a);
        float _523 = 1.0f - _522;
        float _525 = (1.0f - _525b) * _523;

        float _570a = _525 + _522;
        float _532a = exp2(_517);

        float _532 = ((_520 + (-0.99999988079071044921875f)) + _523) + _532a;
        float _534 = (_517 * 2.0f) * _519;
        float _538 = 1.0f / _532;
        float _539 = _520 / _532;
        float _540 = (_525 + _520) / _532;
        float _541 = _525 / _532;
        float _545 = (abs(_541) < 1.1920928955078125e-07f) ? 1.0f : (_525 / _541);
        float _548 = _545 + 1.1920928955078125e-07f;
        float _549 = (_522 - (_545 * _539)) / _548;
        float _550 = log2(_548);
        float _553 = max(1.1920928955078125e-07f, exp2(log2(_522)));
        float _559 = exp2(log2(((_517 * 0.5f) * _519) + 1.0f));
        float _562 = (_548 * _539) / (_553 + 1.1920928955078125e-07f);
        float _563 = log2(_553);
        float _567 = (_562 * (-0.693147182464599609375f)) * log2(_539);
        float _569 = (1.0f - _540) + _534;
        float _570 = _559 - max(1.1920928955078125e-07f, exp2(log2(_570a)));
        float _578 = ((_548 * _569) / (_570 + 1.1920928955078125e-07f)) * 0.693147182464599609375f;
        float _580 = (log2(_570) * 0.693147182464599609375f) - (_578 * log2(_569));
        float _590;
        if (_534 > 0.0f) {
          precise float _588 = (-0.0f) - exp2(((_578 * log2(_534)) + _580) * 1.44269502162933349609375f);
          _590 = _588;
        } else {
          _590 = -0.0f;
        }
        float _592 = 1.0f / (_590 + _559);
        float _58[3];
        _58[0u] = 0.0f;
        _58[1u] = 0.0f;
        _58[2u] = 0.0f;
        uint _599;
        float _596 = _159;
        uint _598 = 0u;
        float _600;
        bool _601;
        for (;;) {
          _600 = _596 * _538;
          _601 = _600 < _539;
          float _611;
          if (_601) {
            float frontier_phi_20_17_ladder;
            if (_600 > 0.0f) {
              frontier_phi_20_17_ladder = exp2(
                ((((log2(_600) * _562) + _563) * 0.693147182464599609375f) + _567) * 1.44269502162933349609375f
              );
            } else {
              frontier_phi_20_17_ladder = 0.0f;
            }
            _611 = frontier_phi_20_17_ladder;
          } else {
            float frontier_phi_20_18_ladder;
            if (_600 < _540) {
              float _617 = _600 + _549;
              float frontier_phi_20_18_ladder_21_ladder;
              if (_617 > 0.0f) {
                frontier_phi_20_18_ladder_21_ladder = exp2(log2(_617) + _550);
              } else {
                frontier_phi_20_18_ladder_21_ladder = 0.0f;
              }
              frontier_phi_20_18_ladder = frontier_phi_20_18_ladder_21_ladder;
            } else {
              float _620 = ((-1.0f) - _534) + _600;
              float _631;
              if (_620 < (-0.0f)) {
                _631 = exp2(((_578 * log2((-0.0f) - _620)) + _580) * 1.44269502162933349609375f);
              } else {
                _631 = 0.0f;
              }
              frontier_phi_20_18_ladder = _559 - _631;
            }
            _611 = frontier_phi_20_18_ladder;
          }
          precise float _614 = _611 * _592;
          _58[_598] = _614;
          _599 = _598 + 1u;
          if (_599 == 3u) {
            break;
          }
          _596 = _57[_599];
          _598 = _599;
          continue;
        }
        sdrColor.r = _58[0u];
        sdrColor.g = _58[1u];
        sdrColor.b = _58[2u];
      } else {
        sdrColor = saturate(inputColor);
      }
      hdrColor = sdrColor;
    }
  }

  float constant316 = _28_m0[316u].z;

  float toneMappedY = dot(sdrColor, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
  float3 preGrayScaledColor = lerp(toneMappedY, sdrColor, _111);
  float3 colorFiltered = lerp(preGrayScaledColor, toneMappedY * colorFilter, colorFilterStrength);
  float3 brightendColor = colorFiltered * _116;
  float3 postGrayScaledColor = lerp(constant316, brightendColor, _122);
  float3 colorFiltered2 = lerp(postGrayScaledColor, colorFilter2.rgb, colorFilter2Strength);

#else   // USE_TONEMAP
  float3 hdrColor = inputColor;
  float3 sdrColor = saturate(inputColor);
  float3 colorFiltered2 = sdrColor;
#endif  // USE_TONEMAP

  float _246 = max(frameData.fContrast, 0.001000000047497451305389404296875f);

  float3 preContrast = (colorFiltered2 * 2.f - 1.f) * _246;

  float _263 = (_246 / sqrt((_246 * _246) + 1.0f)) * 2.0f;

  float3 contrastedColor = preContrast / (sqrt((preContrast * preContrast) + 1.0f) * _263) + 0.5f;

  float3 sceneGradedColor = lerp(sdrColor, contrastedColor, injectedData.colorGradeSceneGrading);

  float lutStrength = _9.Sample(_36, float2(TEXCOORD.x, TEXCOORD.y));

  LUTParams lutParams = buildLUTParams(
    _36,
    injectedData.colorGradeLUTStrength,
    injectedData.colorGradeLUTScaling,
    TONE_MAP_LUT_TYPE__SRGB,
    TONE_MAP_LUT_TYPE__SRGB,
    16.f
  );

  // float3 gammaColor = pow(contrastedColor, 1.0f / max(frameData.fGamma, 0.001000000047497451305389404296875f));
  // float _305 = gammaColor.r;
  // float _306 = gammaColor.g;
  // float _307 = gammaColor.b;

  // float3 lutCoordinates = float3((_305 * 0.9375f) + 0.03125f, (_306 * 0.9375f) + 0.03125f, (_307 * 0.9375f) + 0.03125f);
  // float3 lutOutputColor = _13.Sample(_36, lutCoordinates);
  // float3 lutBlendedColor = lerp(lutOutputColor, gammaColor, lutStrength);
  float3 lutColor = sampleLUT(_13, lutParams, sceneGradedColor);

  // Back in "output gamma"

  // float3 finalColor;
  if (frameData.supportsHDR == 0u) {
    // finalColor = lutColor;
  } else if (injectedData.colorGradeLUTScaling == 0.f) {
    // Vanilla LUT Scaling
    float3 lutColorInGamma = sign(lutColor) * pow(abs(lutColor), 1.f / 2.4f);
    float3 lutBlack = _13.Sample(_36, 0.03125f.xxx);                   // Sample first texel
    float3 lutWhite = _13.Sample(_36, 0.96875f.xxx);                   // Sample last texel
    float lutBlackMin = min(lutBlack.x, min(lutBlack.y, lutBlack.z));  // Min channel
    float lutWhiteMax = max(lutWhite.x, max(lutWhite.y, lutWhite.z));
    float lutRange = max(0.0f, lutWhiteMax - lutBlackMin);
    float rangeGap = 1.0f / lutRange;
    float3 scaledColor = saturate(rangeGap * (lutColorInGamma - lutBlackMin));

    float3 unknownScaling = 1.f - exp2(scaledColor * scaledColor * -14.42694091796875f);

    float3 contrastedColor2 = pow(scaledColor, frameData.lutScalingPow);
    float3 lutScaled = (frameData.fBrightnessHDR * (((contrastedColor2 * unknownScaling) - lutColorInGamma) + ((1.0f - contrastedColor2) * scaledColor))) + lutColorInGamma;
    lutColor = linearFromSRGB(saturate(lutColorInGamma));
  }

  // undo gamma
  // outputColor = sign(outputColor) * pow(outputColor, 1.f/2.4f);

  float3 outputColor;
  if (injectedData.toneMapType == 0.f) {
    outputColor = lerp(sceneGradedColor, lutColor, lutParams.strength);
  } else {
    outputColor = toneMapUpgrade(hdrColor, sdrColor, lutColor, lutParams.strength);
  }
  outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;

  float3 outputSigns = sign(outputColor);
  outputColor = abs(outputColor);
  outputColor = srgbFromLinear(outputColor);

  outputColor *= outputSigns;

  return float4(outputColor, 1.0f);
}
