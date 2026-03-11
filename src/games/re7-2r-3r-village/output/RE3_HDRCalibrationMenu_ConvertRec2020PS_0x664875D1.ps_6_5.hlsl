#include "../common.hlsli"

Texture2D<float4> tLinearImage : register(t0);

cbuffer HDRMapping : register(b0) {
  float whitePaperNits : packoffset(c000.x);
  float configImageAlphaScale : packoffset(c000.y);
  float displayMaxNits : packoffset(c000.z);
  float displayMinNits : packoffset(c000.w);
  float4 displayMaxNitsRect : packoffset(c001.x);
  float4 standardMaxNitsRect : packoffset(c002.x);
  float4 mdrOutRangeRect : packoffset(c003.x);
  uint drawMode : packoffset(c004.x);
  float gammaForHDR : packoffset(c004.y);
  float2 configDrawRectSize : packoffset(c004.z);
};

SamplerState PointBorder : register(s2, space32);

float4 main(
    noperspective float4 SV_Position: SV_Position,
    linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float4 SV_Target;
    float4 _6 = tLinearImage.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
#if 1
    _6.rgb = ApplyGammaCorrection(_6.rgb);
#endif
    float _32 = 10000.0f / whitePaperNits;
    float _45 = exp2(log2(saturate(exp2(log2(mad(0.04331360012292862f, _6.z, mad(0.3292819857597351f, _6.y, (_6.x * 0.627403974533081f)))) * 1.f) / _32)) * 0.1593017578125f);
    float _46 = exp2(log2(saturate(exp2(log2(mad(0.011361200362443924f, _6.z, mad(0.9195399880409241f, _6.y, (_6.x * 0.06909699738025665f)))) * 1.f) / _32)) * 0.1593017578125f);
    float _47 = exp2(log2(saturate(exp2(log2(mad(0.8955950140953064f, _6.z, mad(0.08801320195198059f, _6.y, (_6.x * 0.01639159955084324f)))) * 1.f) / _32)) * 0.1593017578125f);
    float _72 = saturate(exp2(log2(((_45 * 18.8515625f) + 0.8359375f) / ((_45 * 18.6875f) + 1.0f)) * 78.84375f));
    float _73 = saturate(exp2(log2(((_46 * 18.8515625f) + 0.8359375f) / ((_46 * 18.6875f) + 1.0f)) * 78.84375f));
    float _74 = saturate(exp2(log2(((_47 * 18.8515625f) + 0.8359375f) / ((_47 * 18.6875f) + 1.0f)) * 78.84375f));
    float _106;
    float _107;
    float _108;
    float _171;
    float _172;
    float _173;
    float _201;
    float _202;
    float _203;
    int _204;
    float _289;
    float _290;
    float _291;
    if (!((drawMode & 1) == 0)) {
      float _85 = saturate((max(max(_6.x, _6.y), _6.z) * 9.999999747378752e-05f) * whitePaperNits) * 10000.0f;
      do {
        if (((bool)((bool)(TEXCOORD.x >= mdrOutRangeRect.x) && (bool)(TEXCOORD.x <= mdrOutRangeRect.z))) && ((bool)((bool)(TEXCOORD.y >= mdrOutRangeRect.y) && (bool)(TEXCOORD.y <= mdrOutRangeRect.w)))) {
          do {
            if (!(_85 >= displayMaxNits)) {
              if (!(_85 <= displayMinNits)) {
                break;
              } else {
                _106 = 0.0f;
                _107 = 0.0f;
                _108 = 0.5f;
              }
            } else {
              _106 = 0.5f;
              _107 = 0.0f;
              _108 = 0.0f;
            }
            break;
          } while (false);
        }
        _106 = _72;
        _107 = _73;
        _108 = _74;
      } while (false);
    } else {
      _106 = _72;
      _107 = _73;
      _108 = _74;
    }
    if (!((drawMode & 2) == 0)) {
      float _117 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
      float _126 = saturate(exp2(log2(((_117 * 18.8515625f) + 0.8359375f) / ((_117 * 18.6875f) + 1.0f)) * 78.84375f));
      float _132 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
      float _142 = _126 - saturate(exp2(log2(((_132 * 18.8515625f) + 0.8359375f) / ((_132 * 18.6875f) + 1.0f)) * 78.84375f));
      float _146 = saturate(_106 / _126);
      float _147 = saturate(_107 / _126);
      float _148 = saturate(_108 / _126);
      _171 = min(((((2.0f - (_146 + _146)) * _142) + (_146 * _126)) * _146), _106);
      _172 = min(((((2.0f - (_147 + _147)) * _142) + (_147 * _126)) * _147), _107);
      _173 = min(((((2.0f - (_148 + _148)) * _142) + (_148 * _126)) * _148), _108);
    } else {
      _171 = _106;
      _172 = _107;
      _173 = _108;
    }
    if (!((drawMode & 4) == 0)) {
      do {
        if (((bool)((bool)(TEXCOORD.x >= standardMaxNitsRect.x) && (bool)(TEXCOORD.x <= standardMaxNitsRect.z))) && ((bool)((bool)(TEXCOORD.y >= standardMaxNitsRect.y) && (bool)(TEXCOORD.y <= standardMaxNitsRect.w)))) {
          _201 = ((configImageAlphaScale * (1.0f - _171)) + _171);
          _202 = ((configImageAlphaScale * (1.0f - _172)) + _172);
          _203 = ((configImageAlphaScale * (1.0f - _173)) + _173);
          _204 = 1;
        } else {
          _201 = _171;
          _202 = _172;
          _203 = _173;
          _204 = 0;
        }
        if (((bool)((bool)(TEXCOORD.x >= displayMaxNitsRect.x) && (bool)(TEXCOORD.x <= displayMaxNitsRect.z))) && ((bool)((bool)(TEXCOORD.y >= displayMaxNitsRect.y) && (bool)(TEXCOORD.y <= displayMaxNitsRect.w)))) {
          float _220 = displayMaxNits / whitePaperNits;
          float _242 = exp2(log2(saturate(mad(0.04331360012292862f, _220, mad(0.3292819857597351f, _220, (_220 * 0.627403974533081f))) / _32)) * 0.1593017578125f);
          float _243 = exp2(log2(saturate(mad(0.011361200362443924f, _220, mad(0.9195399880409241f, _220, (_220 * 0.06909699738025665f))) / _32)) * 0.1593017578125f);
          float _244 = exp2(log2(saturate(mad(0.8955950140953064f, _220, mad(0.08801320195198059f, _220, (_220 * 0.01639159955084324f))) / _32)) * 0.1593017578125f);
          float _278 = ((saturate(exp2(log2(((_242 * 18.8515625f) + 0.8359375f) / ((_242 * 18.6875f) + 1.0f)) * 78.84375f)) - _201) * configImageAlphaScale) + _201;
          float _279 = ((saturate(exp2(log2(((_243 * 18.8515625f) + 0.8359375f) / ((_243 * 18.6875f) + 1.0f)) * 78.84375f)) - _202) * configImageAlphaScale) + _202;
          float _280 = ((saturate(exp2(log2(((_244 * 18.8515625f) + 0.8359375f) / ((_244 * 18.6875f) + 1.0f)) * 78.84375f)) - _203) * configImageAlphaScale) + _203;
          bool _281 = (_204 != 0);
          _289 = select(_281, min(_201, _278), _278);
          _290 = select(_281, min(_202, _279), _279);
          _291 = select(_281, min(_203, _280), _280);
        } else {
          _289 = _201;
          _290 = _202;
          _291 = _203;
        }
      } while (false);
    } else {
      _289 = _171;
      _290 = _172;
      _291 = _173;
    }
    SV_Target.x = _289;
    SV_Target.y = _290;
    SV_Target.z = _291;
    SV_Target.w = 1.0f;
    return SV_Target;
  } else {
    float4 SV_Target;
    float4 _6 = tLinearImage.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
    float _32 = 4761.90478515625f / whitePaperNits;
    float _45 = exp2(log2(saturate(exp2(log2(mad(0.04331360012292862f, _6.z, mad(0.3292819857597351f, _6.y, (_6.x * 0.627403974533081f)))) * gammaForHDR) / _32)) * 0.17156982421875f);
    float _46 = exp2(log2(saturate(exp2(log2(mad(0.011361200362443924f, _6.z, mad(0.9195399880409241f, _6.y, (_6.x * 0.06909699738025665f)))) * gammaForHDR) / _32)) * 0.17156982421875f);
    float _47 = exp2(log2(saturate(exp2(log2(mad(0.8955950140953064f, _6.z, mad(0.08801320195198059f, _6.y, (_6.x * 0.01639159955084324f)))) * gammaForHDR) / _32)) * 0.17156982421875f);
    float _72 = saturate(exp2(log2(((_45 * 16.71875f) + 0.84375f) / ((_45 * 16.5625f) + 1.0f)) * 82.53125f));
    float _73 = saturate(exp2(log2(((_46 * 16.71875f) + 0.84375f) / ((_46 * 16.5625f) + 1.0f)) * 82.53125f));
    float _74 = saturate(exp2(log2(((_47 * 16.71875f) + 0.84375f) / ((_47 * 16.5625f) + 1.0f)) * 82.53125f));
    float _106;
    float _107;
    float _108;
    float _171;
    float _172;
    float _173;
    float _201;
    float _202;
    float _203;
    int _204;
    float _289;
    float _290;
    float _291;
    if (!((drawMode & 1) == 0)) {
      float _85 = saturate((max(max(_6.x, _6.y), _6.z) * 9.999999747378752e-05f) * whitePaperNits) * 10000.0f;
      do {
        if (((bool)((bool)(TEXCOORD.x >= mdrOutRangeRect.x) && (bool)(TEXCOORD.x <= mdrOutRangeRect.z))) && ((bool)((bool)(TEXCOORD.y >= mdrOutRangeRect.y) && (bool)(TEXCOORD.y <= mdrOutRangeRect.w)))) {
          do {
            if (!(_85 >= displayMaxNits)) {
              if (!(_85 <= displayMinNits)) {
                break;
              } else {
                _106 = 0.0f;
                _107 = 0.0f;
                _108 = 0.5f;
              }
            } else {
              _106 = 0.5f;
              _107 = 0.0f;
              _108 = 0.0f;
            }
            break;
          } while (false);
        }
        _106 = _72;
        _107 = _73;
        _108 = _74;
      } while (false);
    } else {
      _106 = _72;
      _107 = _73;
      _108 = _74;
    }
    if (!((drawMode & 2) == 0)) {
      float _117 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
      float _126 = saturate(exp2(log2(((_117 * 18.8515625f) + 0.8359375f) / ((_117 * 18.6875f) + 1.0f)) * 78.84375f));
      float _132 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
      float _142 = _126 - saturate(exp2(log2(((_132 * 18.8515625f) + 0.8359375f) / ((_132 * 18.6875f) + 1.0f)) * 78.84375f));
      float _146 = saturate(_106 / _126);
      float _147 = saturate(_107 / _126);
      float _148 = saturate(_108 / _126);
      _171 = min(((((2.0f - (_146 + _146)) * _142) + (_146 * _126)) * _146), _106);
      _172 = min(((((2.0f - (_147 + _147)) * _142) + (_147 * _126)) * _147), _107);
      _173 = min(((((2.0f - (_148 + _148)) * _142) + (_148 * _126)) * _148), _108);
    } else {
      _171 = _106;
      _172 = _107;
      _173 = _108;
    }
    if (!((drawMode & 4) == 0)) {
      do {
        if (((bool)((bool)(TEXCOORD.x >= standardMaxNitsRect.x) && (bool)(TEXCOORD.x <= standardMaxNitsRect.z))) && ((bool)((bool)(TEXCOORD.y >= standardMaxNitsRect.y) && (bool)(TEXCOORD.y <= standardMaxNitsRect.w)))) {
          _201 = ((configImageAlphaScale * (1.0f - _171)) + _171);
          _202 = ((configImageAlphaScale * (1.0f - _172)) + _172);
          _203 = ((configImageAlphaScale * (1.0f - _173)) + _173);
          _204 = 1;
        } else {
          _201 = _171;
          _202 = _172;
          _203 = _173;
          _204 = 0;
        }
        if (((bool)((bool)(TEXCOORD.x >= displayMaxNitsRect.x) && (bool)(TEXCOORD.x <= displayMaxNitsRect.z))) && ((bool)((bool)(TEXCOORD.y >= displayMaxNitsRect.y) && (bool)(TEXCOORD.y <= displayMaxNitsRect.w)))) {
          float _220 = displayMaxNits / whitePaperNits;
          float _242 = exp2(log2(saturate(mad(0.04331360012292862f, _220, mad(0.3292819857597351f, _220, (_220 * 0.627403974533081f))) / _32)) * 0.17156982421875f);
          float _243 = exp2(log2(saturate(mad(0.011361200362443924f, _220, mad(0.9195399880409241f, _220, (_220 * 0.06909699738025665f))) / _32)) * 0.17156982421875f);
          float _244 = exp2(log2(saturate(mad(0.8955950140953064f, _220, mad(0.08801320195198059f, _220, (_220 * 0.01639159955084324f))) / _32)) * 0.17156982421875f);
          float _278 = ((saturate(exp2(log2(((_242 * 16.71875f) + 0.84375f) / ((_242 * 16.5625f) + 1.0f)) * 82.53125f)) - _201) * configImageAlphaScale) + _201;
          float _279 = ((saturate(exp2(log2(((_243 * 16.71875f) + 0.84375f) / ((_243 * 16.5625f) + 1.0f)) * 82.53125f)) - _202) * configImageAlphaScale) + _202;
          float _280 = ((saturate(exp2(log2(((_244 * 16.71875f) + 0.84375f) / ((_244 * 16.5625f) + 1.0f)) * 82.53125f)) - _203) * configImageAlphaScale) + _203;
          bool _281 = (_204 != 0);
          _289 = select(_281, min(_201, _278), _278);
          _290 = select(_281, min(_202, _279), _279);
          _291 = select(_281, min(_203, _280), _280);
        } else {
          _289 = _201;
          _290 = _202;
          _291 = _203;
        }
      } while (false);
    } else {
      _289 = _171;
      _290 = _172;
      _291 = _173;
    }
    SV_Target.x = _289;
    SV_Target.y = _290;
    SV_Target.z = _291;
    SV_Target.w = 1.0f;
    return SV_Target;
  }
}
