#include "../OCIO.hlsli"

Texture2D<float4> SrcTexture : register(t0);

Texture2D<float4> OCIO_lut1d_0 : register(t1);

Texture3D<float4> OCIO_lut3d_1 : register(t2);

cbuffer RGCParamCB : register(b0) {
  struct RGCParam {
    float CyanLimit;
    float MagentaLimit;
    float YellowLimit;
    float CyanThreshold;
    float MagentaThreshold;
    float YellowThreshold;
    float RollOff;
    uint EnableReferenceGamutCompress;
    float InvCyanSTerm;
    float InvMagentaSTerm;
    float InvYellowSTerm;
    float InvRollOff;
  } rgcParam : packoffset(c000.x);
};

SamplerState PointBorder : register(s2, space32);

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _13 = SrcTexture.SampleLevel(PointBorder, float2(TEXCOORD.x, TEXCOORD.y), 0.0f);

  // AP1 -> AP0
  float _19 = mad(_13.z, 0.1638689935207367f, mad(_13.y, 0.1406790018081665f, (_13.x * 0.6954519748687744f)));
  float _22 = mad(_13.z, 0.0955343022942543f, mad(_13.y, 0.8596709966659546f, (_13.x * 0.04479460045695305f)));
  float _25 = mad(_13.z, 1.0015000104904175f, mad(_13.y, 0.004025210160762072f, (_13.x * -0.00552588002756238f)));
  float _26 = abs(_19);
  float _39;
  float _68;
  float _95;
  float _267;
  float _268;
  float _269;
  float _270;
  float _271;
  float _321;
  float _342;
  float _362;
  float _370;
  float _371;
  float _372;
  if (_26 > 6.103515625e-05f) {
    float _29 = min(_26, 65504.0f);
    float _31 = floor(log2(_29));
    float _32 = exp2(_31);
    _39 = dot(float3(_31, ((_29 - _32) / _32), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _39 = (_26 * 16777216.0f);
  }
  float _42 = _39 + select((_19 < 0.0f), 32768.0f, 0.0f);
  float _44 = floor(_42 * 0.00024420025874860585f);
  float4 _53 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_42 + 0.5f) - (_44 * 4095.0f)) * 0.000244140625f), ((_44 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _55 = abs(_22);
  if (_55 > 6.103515625e-05f) {
    float _58 = min(_55, 65504.0f);
    float _60 = floor(log2(_58));
    float _61 = exp2(_60);
    _68 = dot(float3(_60, ((_58 - _61) / _61), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _68 = (_55 * 16777216.0f);
  }
  float _71 = _68 + select((_22 < 0.0f), 32768.0f, 0.0f);
  float _73 = floor(_71 * 0.00024420025874860585f);
  float4 _80 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_71 + 0.5f) - (_73 * 4095.0f)) * 0.000244140625f), ((_73 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _82 = abs(_25);
  if (_82 > 6.103515625e-05f) {
    float _85 = min(_82, 65504.0f);
    float _87 = floor(log2(_85));
    float _88 = exp2(_87);
    _95 = dot(float3(_87, ((_85 - _88) / _88), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _95 = (_82 * 16777216.0f);
  }
  float _98 = _95 + select((_25 < 0.0f), 32768.0f, 0.0f);
  float _100 = floor(_98 * 0.00024420025874860585f);
  float4 _107 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_98 + 0.5f) - (_100 * 4095.0f)) * 0.000244140625f), ((_100 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _109 = _53.x * 64.0f;
  float _110 = _80.x * 64.0f;
  float _111 = _107.x * 64.0f;
  float _112 = floor(_109);
  float _113 = floor(_110);
  float _114 = floor(_111);
  float _115 = _109 - _112;
  float _116 = _110 - _113;
  float _117 = _111 - _114;
  float _121 = (_114 + 0.5f) * 0.015384615398943424f;
  float _122 = (_113 + 0.5f) * 0.015384615398943424f;
  float _123 = (_112 + 0.5f) * 0.015384615398943424f;
  float4 _126 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_121, _122, _123), 0.0f);
  float _130 = _121 + 0.015384615398943424f;
  float _131 = _122 + 0.015384615398943424f;
  float _132 = _123 + 0.015384615398943424f;
  float4 _133 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_130, _131, _132), 0.0f);
  if (!(!(_115 >= _116))) {
    if (!(!(_116 >= _117))) {
      float4 _141 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_121, _122, _132), 0.0f);
      float4 _145 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_121, _131, _132), 0.0f);
      float _149 = _115 - _116;
      float _150 = _116 - _117;
      _267 = ((_145.x * _150) + (_141.x * _149));
      _268 = ((_145.y * _150) + (_141.y * _149));
      _269 = ((_145.z * _150) + (_141.z * _149));
      _270 = _115;
      _271 = _117;
    } else {
      if (!(!(_115 >= _117))) {
        float4 _163 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_121, _122, _132), 0.0f);
        float4 _167 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_130, _122, _132), 0.0f);
        float _171 = _115 - _117;
        float _172 = _117 - _116;
        _267 = ((_167.x * _172) + (_163.x * _171));
        _268 = ((_167.y * _172) + (_163.y * _171));
        _269 = ((_167.z * _172) + (_163.z * _171));
        _270 = _115;
        _271 = _116;
      } else {
        float4 _183 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_130, _122, _123), 0.0f);
        float4 _187 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_130, _122, _132), 0.0f);
        float _191 = _117 - _115;
        float _192 = _115 - _116;
        _267 = ((_187.x * _192) + (_183.x * _191));
        _268 = ((_187.y * _192) + (_183.y * _191));
        _269 = ((_187.z * _192) + (_183.z * _191));
        _270 = _117;
        _271 = _116;
      }
    }
  } else {
    if (!(!(_116 <= _117))) {
      float4 _205 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_130, _122, _123), 0.0f);
      float4 _209 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_130, _131, _123), 0.0f);
      float _213 = _117 - _116;
      float _214 = _116 - _115;
      _267 = ((_209.x * _214) + (_205.x * _213));
      _268 = ((_209.y * _214) + (_205.y * _213));
      _269 = ((_209.z * _214) + (_205.z * _213));
      _270 = _117;
      _271 = _115;
    } else {
      if (!(!(_115 >= _117))) {
        float4 _227 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_121, _131, _123), 0.0f);
        float4 _231 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_121, _131, _132), 0.0f);
        float _235 = _116 - _115;
        float _236 = _115 - _117;
        _267 = ((_231.x * _236) + (_227.x * _235));
        _268 = ((_231.y * _236) + (_227.y * _235));
        _269 = ((_231.z * _236) + (_227.z * _235));
        _270 = _116;
        _271 = _117;
      } else {
        float4 _247 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_121, _131, _123), 0.0f);
        float4 _251 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_130, _131, _123), 0.0f);
        float _255 = _116 - _117;
        float _256 = _117 - _115;
        _267 = ((_251.x * _256) + (_247.x * _255));
        _268 = ((_251.y * _256) + (_247.y * _255));
        _269 = ((_251.z * _256) + (_247.z * _255));
        _270 = _116;
        _271 = _115;
      }
    }
  }
  float _272 = 1.0f - _270;
  float _282 = ((_272 * _126.x) + _267) + (_271 * _133.x);
  float _283 = ((_272 * _126.y) + _268) + (_271 * _133.y);
  float _284 = ((_272 * _126.z) + _269) + (_271 * _133.z);
  if (!(rgcParam.EnableReferenceGamutCompress == 0)) {
    float _290 = max(max(_282, _283), _284);
    if (!(_290 == 0.0f)) {
      float _296 = abs(_290);
      float _297 = (_290 - _282) / _296;
      float _298 = (_290 - _283) / _296;
      float _299 = (_290 - _284) / _296;
      do {
        if (!(!(_297 >= rgcParam.CyanThreshold))) {
          float _309 = _297 - rgcParam.CyanThreshold;
          _321 = ((_309 / exp2(log2(exp2(log2(rgcParam.InvCyanSTerm * _309) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.CyanThreshold);
        } else {
          _321 = _297;
        }
        do {
          if (!(!(_298 >= rgcParam.MagentaThreshold))) {
            float _330 = _298 - rgcParam.MagentaThreshold;
            _342 = ((_330 / exp2(log2(exp2(log2(rgcParam.InvMagentaSTerm * _330) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.MagentaThreshold);
          } else {
            _342 = _298;
          }
          do {
            if (!(!(_299 >= rgcParam.YellowThreshold))) {
              float _350 = _299 - rgcParam.YellowThreshold;
              _362 = ((_350 / exp2(log2(exp2(log2(rgcParam.InvYellowSTerm * _350) * rgcParam.RollOff) + 1.0f) * rgcParam.InvRollOff)) + rgcParam.YellowThreshold);
            } else {
              _362 = _299;
            }
            _370 = (_290 - (_321 * _296));
            _371 = (_290 - (_342 * _296));
            _372 = (_290 - (_362 * _296));
          } while (false);
        } while (false);
      } while (false);
    } else {
      _370 = _282;
      _371 = _283;
      _372 = _284;
    }
  } else {
    _370 = _282;
    _371 = _283;
    _372 = _284;
  }
  SV_Target.x = _370;
  SV_Target.y = _371;
  SV_Target.z = _372;
  SV_Target.w = 1.0f;

  // SV_Target.rgb *= 999.f;

  return SV_Target;
}


