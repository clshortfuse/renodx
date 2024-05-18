#include "../../shaders/tonemap.hlsl"
#include "./shared.h"

cbuffer _31_33 : register(b0, space0) { float4 _33_m0[1] : packoffset(c0); }

cbuffer _21_23 : register(b0, space6) { float4 _23_m0[9] : packoffset(c0); }

cbuffer _26_28 : register(b0, space7) { float4 _28_m0[3265] : packoffset(c0); }

Texture2D<float4> _8 : register(t0, space9);   // untonemapped
Texture2D<float4> _9 : register(t1, space9);   // unknown R8_UNORM
Texture2D<float4> _10 : register(t2, space9);  // bloom
Texture3D<float4> _13 : register(t3, space9);  // rgba16_float LUT

StructuredBuffer<uint4> _17 : register(t4, space9);
SamplerState _36 : register(s0, space9);



static float4 gl_FragCoord;
static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  uint4 _63 = asuint(_33_m0[0u]);
  uint _64 = _63.x;
  uint _66 = _64 * 12u;
  float4 _81 = asfloat(uint4(_17.Load(_66).x, _17.Load(_66 + 1u).x, _17.Load(_66 + 2u).x, _17.Load(_66 + 3u).x));

  float _85 = _81.w;
  uint _88 = (_64 * 12u) + 4u;
  float4 _101 = asfloat(uint4(_17.Load(_88).x, _17.Load(_88 + 1u).x, _17.Load(_88 + 2u).x, _17.Load(_88 + 3u).x));

  float _105 = _101.w;
  float _111 = asfloat(_17.Load((_64 * 12u) + 8u).x);
  float _116 = asfloat(_17.Load((_64 * 12u) + 9u).x);
  float _122 = asfloat(_17.Load((_64 * 12u) + 10u).x);
  float4 _126 = _8.Load(int3(uint2(uint(gl_FragCoord.x), uint(gl_FragCoord.y)), 0u));
  float3 inputColor = _126.rgb;
  float _138;
  if (asuint(_23_m0[2u]).y == 0u) {
    _138 = 1.0f;
  } else {
    _138 = ((1.0f - _23_m0[2u].z) * 0.85000002384185791015625f) + _23_m0[2u].z;
  }
  float4 _146 = _10.SampleLevel(_36, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);  // Bloom

  float _152 = asfloat(_63.z);
  float _159 = ((_146.x * _138) * _152) + _126.x;
  float _160 = ((_146.y * _138) * _152) + _126.y;
  float _161 = ((_146.z * _138) * _152) + _126.z;
  uint _162 = _63.y;
  float _175;
  float _180;
  float _185;
  if (_162 == 0u) {
    _175 = clamp(_159, 0.0f, 1.0f);
    _180 = clamp(_160, 0.0f, 1.0f);
    _185 = clamp(_161, 0.0f, 1.0f);
  } else {
    float frontier_phi_5_4_ladder;
    float frontier_phi_5_4_ladder_1;
    float frontier_phi_5_4_ladder_2;
    if (_162 == 1u) {
      frontier_phi_5_4_ladder = clamp((((_159 * 2.5099999904632568359375f) + 0.02999999932944774627685546875f) * _159) / ((((_159 * 2.4300000667572021484375f) + 0.589999973773956298828125f) * _159) + 0.14000000059604644775390625f), 0.0f, 1.0f);
      frontier_phi_5_4_ladder_1 = clamp((((_160 * 2.5099999904632568359375f) + 0.02999999932944774627685546875f) * _160) / ((((_160 * 2.4300000667572021484375f) + 0.589999973773956298828125f) * _160) + 0.14000000059604644775390625f), 0.0f, 1.0f);
      frontier_phi_5_4_ladder_2 = clamp((((_161 * 2.5099999904632568359375f) + 0.02999999932944774627685546875f) * _161) / ((((_161 * 2.4300000667572021484375f) + 0.589999973773956298828125f) * _161) + 0.14000000059604644775390625f), 0.0f, 1.0f);
    } else {
      float frontier_phi_5_4_ladder_7_ladder;
      float frontier_phi_5_4_ladder_7_ladder_1;
      float frontier_phi_5_4_ladder_7_ladder_2;
      if (_162 == 2u) {
        float _467 = ((0.560000002384185791015625f / _28_m0[3262u].x) + 2.4300000667572021484375f) + (_28_m0[3262u].y / (_28_m0[3262u].x * _28_m0[3262u].x));
        frontier_phi_5_4_ladder_7_ladder = clamp((((_467 * _159) + 0.02999999932944774627685546875f) * _159) / (_28_m0[3262u].y + (((_159 * 2.4300000667572021484375f) + 0.589999973773956298828125f) * _159)), 0.0f, 1.0f);
        frontier_phi_5_4_ladder_7_ladder_1 = clamp((((_467 * _160) + 0.02999999932944774627685546875f) * _160) / (_28_m0[3262u].y + (((_160 * 2.4300000667572021484375f) + 0.589999973773956298828125f) * _160)), 0.0f, 1.0f);
        frontier_phi_5_4_ladder_7_ladder_2 = clamp((((_467 * _161) + 0.02999999932944774627685546875f) * _161) / (_28_m0[3262u].y + (((_161 * 2.4300000667572021484375f) + 0.589999973773956298828125f) * _161)), 0.0f, 1.0f);
      } else {
        float frontier_phi_5_4_ladder_7_ladder_11_ladder;
        float frontier_phi_5_4_ladder_7_ladder_11_ladder_1;
        float frontier_phi_5_4_ladder_7_ladder_11_ladder_2;
        if (_162 == 3u) {
          float _57[3];
          _57[0u] = _159;
          _57[1u] = _160;
          _57[2u] = _161;
          float _517 = max(0.0f, _28_m0[3263u].x);
          float _519 = clamp(_28_m0[3263u].z, 0.0f, 1.0f);
          float _520 = exp2(log2(clamp(_28_m0[3262u].w, 0.0f, 1.0f)) * 2.2000000476837158203125f) * 0.5f;
          float _522 = (1.0f - clamp(_28_m0[3262u].z, 0.0f, 1.0f)) * _520;
          float _523 = 1.0f - _522;
          float _525 = (1.0f - min(0.999989986419677734375f, max(1.1920928955078125e-07f, clamp(_28_m0[3263u].y, 0.0f, 1.0f)))) * _523;
          float _532 = ((_520 + (-0.99999988079071044921875f)) + _523) + exp2(_517);
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
          float _570 = _559 - max(1.1920928955078125e-07f, exp2(log2(_525 + _522)));
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
          frontier_phi_5_4_ladder_7_ladder_11_ladder = _58[0u];
          frontier_phi_5_4_ladder_7_ladder_11_ladder_1 = _58[1u];
          frontier_phi_5_4_ladder_7_ladder_11_ladder_2 = _58[2u];
        } else {
          frontier_phi_5_4_ladder_7_ladder_11_ladder = clamp(_159, 0.0f, 1.0f);
          frontier_phi_5_4_ladder_7_ladder_11_ladder_1 = clamp(_160, 0.0f, 1.0f);
          frontier_phi_5_4_ladder_7_ladder_11_ladder_2 = clamp(_161, 0.0f, 1.0f);
        }
        frontier_phi_5_4_ladder_7_ladder = frontier_phi_5_4_ladder_7_ladder_11_ladder;
        frontier_phi_5_4_ladder_7_ladder_1 = frontier_phi_5_4_ladder_7_ladder_11_ladder_1;
        frontier_phi_5_4_ladder_7_ladder_2 = frontier_phi_5_4_ladder_7_ladder_11_ladder_2;
      }
      frontier_phi_5_4_ladder = frontier_phi_5_4_ladder_7_ladder;
      frontier_phi_5_4_ladder_1 = frontier_phi_5_4_ladder_7_ladder_1;
      frontier_phi_5_4_ladder_2 = frontier_phi_5_4_ladder_7_ladder_2;
    }
    _175 = frontier_phi_5_4_ladder;
    _180 = frontier_phi_5_4_ladder_1;
    _185 = frontier_phi_5_4_ladder_2;
  }
  float _194 = dot(float3(_175, _180, _185), float3(0.2125000059604644775390625f, 0.7153999805450439453125f, 0.07209999859333038330078125f));
  float _207 = ((_175 - _194) * _111) + _194;
  float _208 = ((_180 - _194) * _111) + _194;
  float _209 = ((_185 - _194) * _111) + _194;
  float _231 = (((((((_194 * _81.x) - _207) * _85) + _207) * _116) - _28_m0[316u].z) * _122) + _28_m0[316u].z;
  float _232 = (((((((_194 * _81.y) - _208) * _85) + _208) * _116) - _28_m0[316u].z) * _122) + _28_m0[316u].z;
  float _233 = (((((((_194 * _81.z) - _209) * _85) + _209) * _116) - _28_m0[316u].z) * _122) + _28_m0[316u].z;
  float _246 = max(_23_m0[2u].x, 0.001000000047497451305389404296875f);
  float _256 = (((((_101.x - _231) * _105) + _231) * 2.0f) + (-1.0f)) * _246;
  float _257 = (((((_101.y - _232) * _105) + _232) * 2.0f) + (-1.0f)) * _246;
  float _258 = (((((_101.z - _233) * _105) + _233) * 2.0f) + (-1.0f)) * _246;
  float _263 = (_246 / sqrt((_246 * _246) + 1.0f)) * 2.0f;
  float _287 = 1.0f / max(_23_m0[1u].w, 0.001000000047497451305389404296875f);
  float _305 = max(
    (exp2(log2((_256 / (sqrt((_256 * _256) + 1.0f) * _263)) + 0.5f) * _287) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f),
    0.0f
  );
  float _306 = max(
    (exp2(log2((_257 / (sqrt((_257 * _257) + 1.0f) * _263)) + 0.5f) * _287) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f),
    0.0f
  );
  float _307 = max(
    (exp2(log2((_258 / (sqrt((_258 * _258) + 1.0f) * _263)) + 0.5f) * _287) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f),
    0.0f
  );
  float4 _320 = _13.Sample(
    _36, float3((_305 * 0.9375f) + 0.03125f, (_306 * 0.9375f) + 0.03125f, (_307 * 0.9375f) + 0.03125f)
  );
  float _322 = _320.x;
  float _323 = _320.y;
  float _324 = _320.z;
  float4 _327 = _9.Sample(_36, float2(TEXCOORD.x, TEXCOORD.y));
  float _329 = _327.x;
  float _336 = (_329 * (_305 - _322)) + _322;
  float _337 = (_329 * (_306 - _323)) + _323;
  float _338 = (_329 * (_307 - _324)) + _324;
  float _374;
  float _376;
  float _378;
  if (asuint(_23_m0[2u]).y == 0u) {
    _374 = _336;
    _376 = _337;
    _378 = _338;
  } else {
    float4 _386 = _13.Sample(_36, 0.03125f.xxx);
    float4 _392 = _13.Sample(_36, 0.96875f.xxx);
    float _398 = min(_386.x, min(_386.y, _386.z));
    float _403 = 1.0f / max(0.0f, max(_392.x, max(_392.y, _392.z)) - _398);
    float _410 = clamp(_403 * (_336 - _398), 0.0f, 1.0f);
    float _411 = clamp(_403 * (_337 - _398), 0.0f, 1.0f);
    float _412 = clamp(_403 * (_338 - _398), 0.0f, 1.0f);
    float _435 = exp2(log2(_410) * _23_m0[2u].w);
    float _436 = exp2(log2(_411) * _23_m0[2u].w);
    float _437 = exp2(log2(_412) * _23_m0[2u].w);
    _374 = (_23_m0[2u].z * (((_435 * (1.0f - exp2((_410 * _410) * (-14.42694091796875f)))) - _336) + ((1.0f - _435) * _410))) + _336;
    _376 = (_23_m0[2u].z * (((_436 * (1.0f - exp2((_411 * _411) * (-14.42694091796875f)))) - _337) + ((1.0f - _436) * _411))) + _337;
    _378 = ((((_437 * (1.0f - exp2((_412 * _412) * (-14.42694091796875f)))) - _338) + ((1.0f - _437) * _412)) * _23_m0[2u].z) + _338;
  }
  SV_Target.x = _374;
  SV_Target.y = _376;
  SV_Target.z = _378;

  SV_Target.rgb = inputColor.rgb;

  float3 outputColor = SV_Target.rgb;

  float vanillaMidGray = 0.18f;
  float renoDRTContrast = 1.0f;
  float renoDRTFlare = 0.f;
  float renoDRTShadows = 1.f;
  float renoDRTDechroma = 0.5f;
  float renoDRTSaturation = 1.0f;
  float renoDRTHighlights = 1.0f;

  ToneMapParams tmParams = {
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
  };
  ToneMapLUTParams lutParams = buildLUTParams(
    _36,
    injectedData.colorGradeLUTStrength,
    injectedData.colorGradeLUTScaling,
    TONE_MAP_LUT_TYPE__SRGB,
    TONE_MAP_LUT_TYPE__SRGB,
    16.f
  );

  outputColor = toneMap(inputColor, tmParams, lutParams, _13);

  if (injectedData.toneMapGammaCorrection) {
    outputColor = gammaCorrectSafe(outputColor);
  }
  outputColor *= injectedData.toneMapGameNits / injectedData.toneMapUINits;

  SV_Target.rgb = outputColor.rgb;

  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
