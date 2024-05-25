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

struct FrameData {
  uint value00;           // _23_m0[0u].x
  uint value01;           // _23_m0[0u].y
  float2 value02;         // _23_m0[0u].zw
  float value03;          // _23_m0[1u].x
  float value04;          // _23_m0[1u].y
  float value05;          // _23_m0[1u].z
  float fGamma;           // _23_m0[1u].w
  float fContrast;        // _23_m0[2u].x
  uint supportsHDR;       // _23_m0[2u].y
  float fBrightnessHDR;   // _23_m0[2u].z
  float lutScalingPow;    // _23_m0[2u].w
  FrameDebug frameDebug;  // _23_m0[3u-6u].xyzw
  float4 value12;         // _23_m0[7u].xyzw
  float value13;          // _23_m0[8u].x
  float value14;          // _23_m0[8u].y
  uint value15;           // _23_m0[8u].z
  uint value16;           // _23_m0[8u].w
};



struct EffectsAlphaThresholdParams {
  float effectsAlphaThresholdParams00;
  float effectsAlphaThresholdParams01;
  float effectsAlphaThresholdParams02;
  float effectsAlphaThresholdParams03;
};

struct TonemappingParams {
  float acesParam00;
  float acesParam01;
  float hableToeStrength;
  float hableToeLength;
  float hableShoulderStrength;
  float hableShoulderLength;
  float hableShoulderAngle;
  uint tonemappingParams07;
};

struct GPUDebugGeometrySettings {
  uint gpuDebugGeometrySettings00;
  uint gpuDebugGeometrySettings01;
  uint gpuDebugGeometrySettings02;
  uint gpuDebugGeometrySettings03;
};

struct TiledLightingDebug {
  uint tiledLightingDebug00;
  uint tiledLightingDebug01;
  float tiledLightingDebug02;
  float tiledLightingDebug03;
  float tiledLightingDebug04;
  uint tiledLightingDebug05;
  uint tiledLightingDebug06;
  uint tiledLightingDebug07;
};

struct MomentBasedOITSettings {
  float momentBasedOITSettings00;
  float momentBasedOITSettings01;
  float momentBasedOITSettings02;
  float momentBasedOITSettings03;
  float momentBasedOITSettings04;
  float momentBasedOITSettings05;
  float momentBasedOITSettings06;
  float momentBasedOITSettings07;
  float2 momentBasedOITSettings08;
  float momentBasedOITSettings09;
  float momentBasedOITSettings10;
  float momentBasedOITSettings11;
  uint momentBasedOITSettings12;
  uint momentBasedOITSettings13;
  uint momentBasedOITSettings14;
};

struct CameraBlock {
  float3 cameraBlock00;
  uint cameraBlock01;
  float4x4 cameraBlock02;
  float4x4 cameraBlock03;
  float4x4 cameraBlock04;
  float4x4 cameraBlock05;
  float4x4 cameraBlock06;
  float4x4 cameraBlock07;
  float3 cameraBlock08;
  uint cameraBlock09;
  float4x4 cameraBlock10;
  float4x4 cameraBlock11;
  float4x4 cameraBlock12;
  float4 cameraBlock13;
  float4 cameraBlock14;
  float4 cameraBlock15;
  float4 cameraBlock16;
  float2 cameraBlock17;
  float cameraBlock18;
  float cameraBlock19;
};

struct ResolutionBlock {
  float2 resolutionBlock00;
  float2 resolutionBlock01;
  float2 resolutionBlock02;
  float2 resolutionBlock03;
  uint4 resolutionBlock04;
  float2 resolutionBlock05;
  float2 resolutionBlock06;
  float2 resolutionBlock07;
  float2 resolutionBlock08;
  float2 resolutionBlock09;
  uint2 resolutionBlock10;
  uint4 resolutionBlock11;
  float resolutionBlock12;
  uint resolutionBlock13;
  uint resolutionBlock14;
  uint resolutionBlock15;
};

struct CameraBlockArray {
  CameraBlock cameraBlockArray00[3];
  ResolutionBlock cameraBlockArray01[5];
};

struct VolumeShape {
  uint volumeShape00;
  float3 volumeShape01;
  float4x3 volumeShape02;
  float4x3 volumeShape03;
};

struct Force {
  float3 force00;
  uint force01;
  VolumeShape volumeShape;
  float force03;
  float force04;
  uint force05;
  uint force06;
  float4 force07;
  float4 force08[8];
};

struct WindData {
  uint windData00;
  float windData01;
  float windData02;
  float windData03;
  float windData04;
  float windData05;
  float windData06;
  float windData07;
  float windData08;
  float windData09;
  float windData10;
  float windData11;
  Force force[8];
};

struct CameraExposureData {
  float cameraExposureData00;
  float cameraExposureData01;
  float cameraExposureData02;
  float cameraExposureData03;
  float cameraExposureData04;
  float cameraExposureData05;
  float cameraExposureData06;
  float cameraExposureData07;
};

struct GlobalLightData {
  uint globalLightData00;
  uint globalLightData01;
  uint globalLightData02;
  uint globalLightData03;
};


struct SPerSceneConstants {
  CameraBlockArray cameraBlockArray;
  WindData windData;
  CameraExposureData cameraExposureData;
  GlobalLightData globalLightData;
  float4 data01[2936];
  MomentBasedOITSettings momentBasedOITSettings;
  TiledLightingDebug tiledLightingDebug;
  GPUDebugGeometrySettings gpuDebugGeometrySettings;
  TonemappingParams tonemappingParams;
  EffectsAlphaThresholdParams effectsAlphaThresholdParams;
};

cbuffer SharedFrameData : register(b0, space6) {
  FrameData frameData : packoffset(c0);
}

cbuffer PerSceneConstants : register(b0, space7) {
  SPerSceneConstants perSceneConstants : packoffset(c0);
}

cbuffer stub_PushConstantWrapper_HDRComposite : register(b0, space0) {
  struct PushConstantWrapper_HDRComposite {
    uint bufferIndex;     // _33_m0[0u].x // 1u
    uint toneMapperEnum;  // _33_m0[1u].x // 3u
    uint bloomStrength;   // _33_m0[2u].x // 0.28f
  } pushConstants : packoffset(c0);
}

Texture2D<float3> _8 : register(t0, space9);   // untonemapped
Texture2D<float> _9 : register(t1, space9);    // unknown R8_UNORM
Texture2D<float3> _10 : register(t2, space9);  // bloom
Texture3D<float3> _13 : register(t3, space9);  // rgba16_float LUT

struct HDRCompositeData {
  float4 value00;
  float4 value01;
  float value02;
  float value03;
  float value04;
  uint value05;
};

StructuredBuffer<HDRCompositeData> _17 : register(t4, space9);
SamplerState _36 : register(s0, space9);

float4 main(float4 gl_FragCoord : SV_Position, float2 TEXCOORD : TEXCOORD0) : SV_Target0 {
  uint _64 = pushConstants.bufferIndex;  // 1u
  uint _66 = _64 * 12u;
  float4 colorFilter = _17[_64].value00;

  float colorFilterStrength = colorFilter.w;

  float4 colorFilter2 = _17[_64].value01;

  float colorFilter2Strength = colorFilter2.w;

  float _111 = _17[_64].value02;
  float _116 = _17[_64].value03;
  float _122 = _17[_64].value04;
  float3 _126 = _8.Load(int3(uint2(uint(gl_FragCoord.x), uint(gl_FragCoord.y)), 0u));
  float _138;
  if (frameData.supportsHDR) {
    _138 = lerp(frameData.fBrightnessHDR, 1.f, 0.85f);
  } else {
    _138 = 1.f;
  }
  float3 _146 = _10.SampleLevel(_36, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);  // Bloom

  float _152 = asfloat(pushConstants.bloomStrength);  // Cast

  float3 bloomedColor = _126 + (_138 * _146 * _152);

  float _159 = bloomedColor.r;
  float _160 = bloomedColor.g;
  float _161 = bloomedColor.b;

  uint _162 = pushConstants.toneMapperEnum;
  float _175;
  float _180;
  float _185;
  float3 toneMappedColor;
  if (pushConstants.toneMapperEnum == 0u) {
    toneMappedColor = saturate(bloomedColor);
  } else if (pushConstants.toneMapperEnum == 1u) {
    toneMappedColor = saturate((((bloomedColor * 2.51f) + 0.03f) * bloomedColor) / ((((bloomedColor * 2.43f) + 0.59f) * bloomedColor) + 0.14f));
  } else if (pushConstants.toneMapperEnum == 2u) {
    float _467 = ((0.56f / perSceneConstants.tonemappingParams.acesParam00) + 2.43f) + (perSceneConstants.tonemappingParams.acesParam01 / (perSceneConstants.tonemappingParams.acesParam00 * perSceneConstants.tonemappingParams.acesParam00));
    toneMappedColor = saturate((((_467 * bloomedColor) + 0.03f) * bloomedColor) / (perSceneConstants.tonemappingParams.acesParam01 + (((bloomedColor * 2.43f) + 0.59f) * bloomedColor)));
  } else if (pushConstants.toneMapperEnum == 3u) {
    float _57[3];
    _57[0u] = _159;
    _57[1u] = _160;
    _57[2u] = _161;
    float _520 = pow(saturate(perSceneConstants.tonemappingParams.hableToeLength), 2.2f);
    float _522a = saturate(perSceneConstants.tonemappingParams.hableToeStrength);
    float _525a = saturate(perSceneConstants.tonemappingParams.hableShoulderLength);
    float _525b = clamp(_525a, 1.1920928955078125e-07f, 0.999989986419677734375f);

    float _517 = max(0.0f, perSceneConstants.tonemappingParams.hableShoulderStrength);
    float _519 = saturate(perSceneConstants.tonemappingParams.hableShoulderAngle);

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
    toneMappedColor.r = _58[0u];
    toneMappedColor.g = _58[1u];
    toneMappedColor.b = _58[2u];
  } else {
    toneMappedColor = saturate(bloomedColor);
  }
  float constant316 = perSceneConstants.cameraExposureData.cameraExposureData02;

  float toneMappedY = dot(toneMappedColor, float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
  float3 preGrayScaledColor = lerp(toneMappedY, toneMappedColor, _111);
  float3 colorFiltered = lerp(preGrayScaledColor, toneMappedY * colorFilter, colorFilterStrength);
  float3 brightendColor = colorFiltered * _116;
  float3 postGrayScaledColor = lerp(constant316, brightendColor, _122);
  float3 colorFiltered2 = lerp(postGrayScaledColor, colorFilter2, colorFilter2Strength);

  float _246 = max(frameData.fContrast, 0.001000000047497451305389404296875f);

  float3 preContrast = (colorFiltered2 * 2.f - 1.f) * _246;

  float _263 = (_246 / sqrt((_246 * _246) + 1.0f)) * 2.0f;

  float3 contrastedColor = preContrast / (sqrt((preContrast * preContrast) + 1.0f) * _263) + 0.5f;
  float3 gammaColor = pow(contrastedColor, 1.0f / max(frameData.fGamma, 0.001000000047497451305389404296875f));
  gammaColor *= 1.055f;
  gammaColor -= 0.055f;
  gammaColor = max(0, gammaColor);
  float _305 = gammaColor.r;
  float _306 = gammaColor.g;
  float _307 = gammaColor.b;

  float3 lutCoordinates = float3((_305 * 0.9375f) + 0.03125f, (_306 * 0.9375f) + 0.03125f, (_307 * 0.9375f) + 0.03125f);
  float3 lutOutputColor = _13.Sample(_36, lutCoordinates);
  float lutStrength = _9.Sample(_36, float2(TEXCOORD.x, TEXCOORD.y));
  float3 lutBlendedColor = lerp(lutOutputColor, gammaColor, lutStrength);

  float _336 = lutBlendedColor.r;
  float _337 = lutBlendedColor.g;
  float _338 = lutBlendedColor.b;

  float3 finalColor;
  if (frameData.supportsHDR == 0u) {
    finalColor = lutBlendedColor;
  } else {
    float3 lutBlack = _13.Sample(_36, 0.03125f.xxx);                   // Sample first texel
    float3 lutWhite = _13.Sample(_36, 0.96875f.xxx);                   // Sample last texel
    float lutBlackMin = min(lutBlack.x, min(lutBlack.y, lutBlack.z));  // Min channel
    float lutWhiteMax = max(lutWhite.x, max(lutWhite.y, lutWhite.z));
    float lutRange = max(0.0f, lutWhiteMax - lutBlackMin);
    float rangeGap = 1.0f / lutRange;
    float3 scaledColor = saturate(rangeGap * (lutBlendedColor - lutBlackMin));
    float3 unknownScaling = 1.f - exp2(scaledColor * scaledColor * -14.42694091796875f);

    float3 contrastedColor2 = pow(scaledColor, frameData.lutScalingPow);  // 3.5f
    finalColor = (frameData.fBrightnessHDR * (((contrastedColor2 * unknownScaling) - lutBlendedColor) + ((1.0f - contrastedColor2) * scaledColor))) + lutBlendedColor;
  }

  return float4(finalColor.rgb, 1.f);
}
