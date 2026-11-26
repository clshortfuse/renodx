#include "./shared.h"

Texture2D<float4> g_xEdgesTexture : register(t0);

Texture2D<float4> g_xAreaTexture : register(t1);

Texture2D<float4> g_xSearchTexture : register(t2);

cbuffer MLAAConstants : register(b0) {
  float4 g_xRTMetrics : packoffset(c000.x);
};

SamplerState g_xBilinearClamp : register(s3);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float2 TEXCOORD_1 : TEXCOORD1,
  linear float4 TEXCOORD_2[3] : TEXCOORD2
) : SV_Target {
  float4 SV_Target;
  // RenoDX: Ultra uses a longer diagonal search range
  float diag_limit = (CUSTOM_SMAA_ULTRA == 1.f) ? 15.0f : 7.0f;
  // RenoDX: search end, extended on Ultra
  float4 search_end = TEXCOORD_2[2];
  // RenoDX: Ultra search end
  if (CUSTOM_SMAA_ULTRA == 1.f) {
    search_end = float4(mad(g_xRTMetrics.x, -64.0f, TEXCOORD_2[0].x), mad(g_xRTMetrics.x, 64.0f, TEXCOORD_2[0].z), mad(g_xRTMetrics.y, -64.0f, TEXCOORD_2[1].y), mad(g_xRTMetrics.y, 64.0f, TEXCOORD_2[1].w));
  }
  float4 _22 =g_xEdgesTexture.Sample(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y));
  float _33;
  float _34;
  float _35;
  float _51;
  float _52;
  float _57;
  float _58;
  float _59;
  float _117;
  float _118;
  float _122;
  float _123;
  float _124;
  float _146;
  float _147;
  float _148;
  float _170;
  float _171;
  float _208;
  float _209;
  float _215;
  float _216;
  float _231;
  float _232;
  float _233;
  float _246;
  float _259;
  float _260;
  float _261;
  float _324;
  float _325;
  float _326;
  float _331;
  float _332;
  float _347;
  float _348;
  float _349;
  float _362;
  float _375;
  float _376;
  float _377;
  float _440;
  float _441;
  [branch]
  if (_22.y > 0.0f) {
    [branch]
    if (_22.x > 0.0f) {
      _33 = TEXCOORD.x;
      _34 = TEXCOORD.y;
      _35 = -1.0f;
      while(true) {
        float _36 = mad(g_xRTMetrics.x, -1.0f, _33);
        float _37 = _34 + g_xRTMetrics.y;
        float _38 = _35 + 1.0f;
        float4 _39 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_36, _37), 0.0f);
        float _42 = dot(float2(_39.x, _39.y), float2(0.5f, 0.5f));
        if ((bool)(_38 < diag_limit) && (bool)(_42 > 0.8999999761581421f)) {
          _33 = _36;
          _34 = _37;
          _35 = _38;
          continue;
        }
        _51 = (float((bool)(bool)(_39.y > 0.8999999761581421f)) + _38);
        _52 = _42;
        break;
      }
    } else {
      _51 = 0.0f;
      _52 = 0.0f;
    }
    _57 = TEXCOORD.x;
    _58 = TEXCOORD.y;
    _59 = -1.0f;
    while(true) {
      float _60 = _57 + g_xRTMetrics.x;
      float _61 = mad(g_xRTMetrics.y, -1.0f, _58);
      float _62 = _59 + 1.0f;
      float4 _63 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_60, _61), 0.0f);
      float _66 = dot(float2(_63.x, _63.y), float2(0.5f, 0.5f));
      if ((bool)(_62 < diag_limit) && (bool)(_66 > 0.8999999761581421f)) {
        _57 = _60;
        _58 = _61;
        _59 = _62;
        continue;
      }
      [branch]
      if ((_62 + _51) > 2.0f) {
        float4 _80 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(mad((0.25f - _51), g_xRTMetrics.x, TEXCOORD.x), mad(_51, g_xRTMetrics.y, TEXCOORD.y)), 0.0f, int2(-1, 0));
        float4 _83 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(mad(_62, g_xRTMetrics.x, TEXCOORD.x), mad((-1.25f - _59), g_xRTMetrics.y, TEXCOORD.y)), 0.0f, int2(1, 0));
        float4 _113 = g_xAreaTexture.SampleLevel(g_xBilinearClamp, float2((mad(0.0062500000931322575f, mad(20.0f, select((!(select((_52 < 0.8999999761581421f), 0.0f, 1.0f) == 0.0f)), 0.0f, mad(2.0f, round(_80.y), round(abs((_80.x * 5.0f) + -3.75f) * _80.x))), _51), 0.0031250000465661287f) + 0.5f), mad(0.0017857142956927419f, mad(20.0f, select((!(select((_66 < 0.8999999761581421f), 0.0f, 1.0f) == 0.0f)), 0.0f, mad(2.0f, round(_83.y), round(abs((_83.x * 5.0f) + -3.75f) * _83.x))), _62), 0.0008928571478463709f)), 0.0f);
        _117 = _113.x;
        _118 = _113.y;
      } else {
        _117 = 0.0f;
        _118 = 0.0f;
      }
      float _120 = (g_xRTMetrics.x * 0.25f) + TEXCOORD.x;
      _122 = _120;
      _123 = TEXCOORD.y;
      _124 = -1.0f;
      while(true) {
        float _125 = mad(g_xRTMetrics.x, -1.0f, _122);
        float _126 = mad(g_xRTMetrics.y, -1.0f, _123);
        float _127 = _124 + 1.0f;
        float4 _128 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_125, _126), 0.0f);
        float _137 = dot(float2(round(_128.x * abs((_128.x * 5.0f) + -3.75f)), round(_128.y)), float2(0.5f, 0.5f));
        if ((bool)(_127 < diag_limit) && (bool)(_137 > 0.8999999761581421f)) {
          _122 = _125;
          _123 = _126;
          _124 = _127;
          continue;
        }
        float4 _142 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, 0));
        [branch]
        if (_142.x > 0.0f) {
          _146 = _120;
          _147 = TEXCOORD.y;
          _148 = -1.0f;
          while(true) {
            float _149 = _146 + g_xRTMetrics.x;
            float _150 = _147 + g_xRTMetrics.y;
            float _151 = _148 + 1.0f;
            float4 _152 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_149, _150), 0.0f);
            float _160 = round(_152.y);
            float _161 = dot(float2(round(_152.x * abs((_152.x * 5.0f) + -3.75f)), _160), float2(0.5f, 0.5f));
            if ((bool)(_151 < diag_limit) && (bool)(_161 > 0.8999999761581421f)) {
              _146 = _149;
              _147 = _150;
              _148 = _151;
              continue;
            }
            _170 = (float((bool)(bool)(_160 > 0.8999999761581421f)) + _151);
            _171 = _161;
            break;
          }
        } else {
          _170 = 0.0f;
          _171 = 0.0f;
        }
        [branch]
        if ((_170 + _127) > 2.0f) {
          float _175 = -0.0f - _127;
          float _176 = mad(_175, g_xRTMetrics.x, TEXCOORD.x);
          float _177 = mad(_175, g_xRTMetrics.y, TEXCOORD.y);
          float4 _180 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_176, _177), 0.0f, int2(-1, 0));
          float4 _182 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_176, _177), 0.0f, int2(0, -1));
          float4 _184 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(mad(_170, g_xRTMetrics.x, TEXCOORD.x), mad(_170, g_xRTMetrics.y, TEXCOORD.y)), 0.0f, int2(1, 0));
          float4 _202 = g_xAreaTexture.SampleLevel(g_xBilinearClamp, float2((mad(0.0062500000931322575f, mad(20.0f, select((!(select((_137 < 0.8999999761581421f), 0.0f, 1.0f) == 0.0f)), 0.0f, mad(2.0f, _180.y, _182.x)), _127), 0.0031250000465661287f) + 0.5f), mad(0.0017857142956927419f, mad(20.0f, select((!(select((_171 < 0.8999999761581421f), 0.0f, 1.0f) == 0.0f)), 0.0f, mad(2.0f, _184.y, _184.x)), _170), 0.0008928571478463709f)), 0.0f);
          _208 = (_202.y + _117);
          _209 = (_202.x + _118);
        } else {
          _208 = _117;
          _209 = _118;
        }
        [branch]
        if (_208 == (-0.0f - _209)) {
          if (TEXCOORD_2[0].x > search_end.x) {
            _215 = TEXCOORD_2[0].x;
            _216 = TEXCOORD_2[0].y;
            while(true) {
              float4 _217 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_215, _216), 0.0f);
              float _223 = mad(-2.0f, g_xRTMetrics.x, _215);
              if ((bool)(_217.x == 0.0f) && ((bool)((bool)(_217.y > 0.8281000256538391f) && (bool)(_223 > search_end.x)))) {
                _215 = _223;
                _216 = mad(-0.0f, g_xRTMetrics.y, _216);
                continue;
              } else {
                _231 = _223;
                _232 = _217.x;
                _233 = _217.y;
              }
              break;
            }
          } else {
            _231 = TEXCOORD_2[0].x;
            _232 = 0.0f;
            _233 = 1.0f;
          }
          float4 _236 = g_xSearchTexture.SampleLevel(g_xBilinearClamp, float2(mad(0.5f, _232, 0.0078125f), mad(-2.0f, _233, 2.03125f)), 0.0f);
          float _241 = mad(g_xRTMetrics.x, mad(-2.007874011993408f, _236.x, 3.25f), _231);
          float4 _242 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_241, TEXCOORD_2[1].y), 0.0f);
          if (TEXCOORD_2[0].z < search_end.y) {
            _246 = TEXCOORD_2[0].z;
            while(true) {
              float4 _247 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_246, TEXCOORD_2[0].w), 0.0f);
              float _252 = mad(2.0f, g_xRTMetrics.x, _246);
              if ((bool)(_247.x == 0.0f) && ((bool)((bool)(_247.y > 0.8281000256538391f) && (bool)(_252 < search_end.y)))) {
                _246 = _252;
                continue;
              } else {
                _259 = _252;
                _260 = _247.x;
                _261 = _247.y;
              }
              break;
            }
          } else {
            _259 = TEXCOORD_2[0].z;
            _260 = 0.0f;
            _261 = 1.0f;
          }
          float4 _264 = g_xSearchTexture.SampleLevel(g_xBilinearClamp, float2(mad(0.5f, _260, 0.5234375f), mad(-2.0f, _261, 2.03125f)), 0.0f);
          float _270 = mad((-0.0f - g_xRTMetrics.x), mad(-2.007874011993408f, _264.x, 3.25f), _259);
          float _271 = -0.0f - TEXCOORD_1.x;
          float _277 = abs(round(mad(g_xRTMetrics.z, _241, _271)));
          float _278 = abs(round(mad(g_xRTMetrics.z, _270, _271)));
          float4 _281 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_270, TEXCOORD_2[1].y), 0.0f, int2(1, 0));
          float4 _291 = g_xAreaTexture.SampleLevel(g_xBilinearClamp, float2(mad(0.0062500000931322575f, mad(16.0f, round(_242.x * 4.0f), sqrt(_277)), 0.0031250000465661287f), mad(0.0017857142956927419f, mad(16.0f, round(_281.x * 4.0f), sqrt(_278)), 0.0008928571478463709f)), 0.0f);
          float _296 = select((_278 < _277), 0.0f, 1.0f);
          float _297 = select((_277 < _278), 0.0f, 1.0f);
          float _300 = _296 + _297;
          float _301 = (_296 * 0.75f) / _300;
          float _302 = (_297 * 0.75f) / _300;
          float4 _303 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_241, TEXCOORD.y), 0.0f, int2(0, 1));
          float4 _307 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_270, TEXCOORD.y), 0.0f, int2(1, 1));
          float4 _311 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_241, TEXCOORD.y), 0.0f, int2(0, -2));
          float4 _315 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_270, TEXCOORD.y), 0.0f, int2(1, -2));
          _324 = (saturate((1.0f - (_303.x * _301)) - (_307.x * _302)) * _291.x);
          _325 = (saturate((1.0f - (_311.x * _301)) - (_315.x * _302)) * _291.y);
          _326 = _22.x;
        } else {
          _324 = _208;
          _325 = _209;
          _326 = 0.0f;
        }
        break;
      }
      break;
    }
  } else {
    _324 = 0.0f;
    _325 = 0.0f;
    _326 = _22.x;
  }
  [branch]
  if (_326 > 0.0f) {
    if (TEXCOORD_2[1].y > search_end.z) {
      _331 = TEXCOORD_2[1].x;
      _332 = TEXCOORD_2[1].y;
      while(true) {
        float4 _333 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(_331, _332), 0.0f);
        float _340 = mad(-2.0f, g_xRTMetrics.y, _332);
        if ((bool)(_333.y == 0.0f) && ((bool)((bool)(_333.x > 0.8281000256538391f) && (bool)(_340 > search_end.z)))) {
          _331 = mad(-0.0f, g_xRTMetrics.x, _331);
          _332 = _340;
          continue;
        } else {
          _347 = _340;
          _348 = _333.x;
          _349 = _333.y;
        }
        break;
      }
    } else {
      _347 = TEXCOORD_2[1].y;
      _348 = 1.0f;
      _349 = 0.0f;
    }
    float4 _352 = g_xSearchTexture.SampleLevel(g_xBilinearClamp, float2(mad(0.5f, _349, 0.0078125f), mad(-2.0f, _348, 2.03125f)), 0.0f);
    float _357 = mad(g_xRTMetrics.y, mad(-2.007874011993408f, _352.x, 3.25f), _347);
    float4 _358 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD_2[0].x, _357), 0.0f);
    if (TEXCOORD_2[1].w < search_end.w) {
      _362 = TEXCOORD_2[1].w;
      while(true) {
        float4 _363 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD_2[1].z, _362), 0.0f);
        float _368 = mad(2.0f, g_xRTMetrics.y, _362);
        if ((bool)(_363.y == 0.0f) && ((bool)((bool)(_363.x > 0.8281000256538391f) && (bool)(_368 < search_end.w)))) {
          _362 = _368;
          continue;
        } else {
          _375 = _363.x;
          _376 = _363.y;
          _377 = _368;
        }
        break;
      }
    } else {
      _375 = 1.0f;
      _376 = 0.0f;
      _377 = TEXCOORD_2[1].w;
    }
    float4 _380 = g_xSearchTexture.SampleLevel(g_xBilinearClamp, float2(mad(0.5f, _376, 0.5234375f), mad(-2.0f, _375, 2.03125f)), 0.0f);
    float _386 = mad((-0.0f - g_xRTMetrics.y), mad(-2.007874011993408f, _380.x, 3.25f), _377);
    float _387 = -0.0f - TEXCOORD_1.y;
    float _393 = abs(round(mad(g_xRTMetrics.w, _357, _387)));
    float _394 = abs(round(mad(g_xRTMetrics.w, _386, _387)));
    float4 _397 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD_2[0].x, _386), 0.0f, int2(0, 1));
    float4 _407 = g_xAreaTexture.SampleLevel(g_xBilinearClamp, float2(mad(0.0062500000931322575f, mad(16.0f, round(_358.y * 4.0f), sqrt(_393)), 0.0031250000465661287f), mad(0.0017857142956927419f, mad(16.0f, round(_397.y * 4.0f), sqrt(_394)), 0.0008928571478463709f)), 0.0f);
    float _412 = select((_394 < _393), 0.0f, 1.0f);
    float _413 = select((_393 < _394), 0.0f, 1.0f);
    float _416 = _412 + _413;
    float _417 = (_412 * 0.75f) / _416;
    float _418 = (_413 * 0.75f) / _416;
    float4 _419 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, _357), 0.0f, int2(1, 0));
    float4 _423 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, _386), 0.0f, int2(1, 1));
    float4 _427 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, _357), 0.0f, int2(-2, 0));
    float4 _431 = g_xEdgesTexture.SampleLevel(g_xBilinearClamp, float2(TEXCOORD.x, _386), 0.0f, int2(-2, 1));
    _440 = (saturate((1.0f - (_419.y * _417)) - (_423.y * _418)) * _407.x);
    _441 = (saturate((1.0f - (_427.y * _417)) - (_431.y * _418)) * _407.y);
  } else {
    _440 = 0.0f;
    _441 = 0.0f;
  }
  SV_Target.x = _324;
  SV_Target.y = _325;
  SV_Target.z = _440;
  SV_Target.w = _441;
  return SV_Target;
}
