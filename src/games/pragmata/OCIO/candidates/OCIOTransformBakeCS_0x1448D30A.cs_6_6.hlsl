#include "../../common.hlsli"
#include "../CBuffers/HDRMapping.hlsli"

Texture2D<float4> OCIO_lut1d_0 : register(t0);

Texture3D<float4> OCIO_lut3d_1 : register(t1);

RWTexture3D<float4> OutLUT : register(u0);

// cbuffer HDRMapping : register(b0) {
//   float whitePaperNits : packoffset(c000.x);
//   float configImageAlphaScale : packoffset(c000.y);
//   float displayMaxNits : packoffset(c000.z);
//   float displayMinNits : packoffset(c000.w);
//   float4 displayMaxNitsRect : packoffset(c001.x);
//   float4 secondaryDisplayMaxNitsRect : packoffset(c002.x);
//   float4 standardMaxNitsRect : packoffset(c003.x);
//   float4 secondaryStandardMaxNitsRect : packoffset(c004.x);
//   float2 displayMaxNitsRectSize : packoffset(c005.x);
//   float2 standardMaxNitsRectSize : packoffset(c005.z);
//   float4 mdrOutRangeRect : packoffset(c006.x);
//   uint drawMode : packoffset(c007.x);
//   float gammaForHDR : packoffset(c007.y);
//   float displayMaxNitsST2084 : packoffset(c007.z);
//   float displayMinNitsST2084 : packoffset(c007.w);
//   uint drawModeOnMDRPass : packoffset(c008.x);
//   float saturationForHDR : packoffset(c008.y);
//   float2 targetInvSize : packoffset(c008.z);
//   float toeEnd : packoffset(c009.x);
//   float toeStrength : packoffset(c009.y);
//   float blackPoint : packoffset(c009.z);
//   float shoulderStartPoint : packoffset(c009.w);
//   float shoulderStrength : packoffset(c010.x);
//   float whitePaperNitsForOverlay : packoffset(c010.y);
//   float saturationOnDisplayMapping : packoffset(c010.z);
//   float graphScale : packoffset(c010.w);
//   float4 hdrImageRect : packoffset(c011.x);
//   float2 hdrImageRectSize : packoffset(c012.x);
//   float secondaryDisplayMaxNits : packoffset(c012.z);
//   float secondaryDisplayMinNits : packoffset(c012.w);
//   float2 secondaryDisplayMaxNitsRectSize : packoffset(c013.x);
//   float2 secondaryStandardMaxNitsRectSize : packoffset(c013.z);
//   float shoulderAngle : packoffset(c014.x);
//   uint enableHDRAdjustmentForOverlay : packoffset(c014.y);
//   float brightnessAdjustmentForOverlay : packoffset(c014.z);
//   float saturateAdjustmentForOverlay : packoffset(c014.w);
// };

cbuffer OCIOTransformXYZMatrix : register(b1) {
  row_major float4x4 OCIO_ToXYZMatrix : packoffset(c000.x);
  row_major float4x4 OCIO_XYZToMatrix : packoffset(c004.x);
};

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _15 = displayMaxNits * 0.009999999776482582f;
  float _18 = _15 * shoulderStartPoint;
  float _19 = float((uint)SV_DispatchThreadID.x);
  float _20 = float((uint)SV_DispatchThreadID.y);
  float _21 = float((uint)SV_DispatchThreadID.z);
  float _22 = _19 * 0.01587301678955555f;
  float _23 = _20 * 0.01587301678955555f;
  float _24 = _21 * 0.01587301678955555f;
  float _38;
  float _52;
  float _66;
  float _240;
  float _248;
  float _290;
  float _295;
  float _402;
  float _431;
  float _458;
  float _630;
  float _631;
  float _632;
  float _633;
  float _634;
  if (!(!(_22 <= -0.3013699948787689f))) {
    _38 = (exp2((_19 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_22 < 1.468000054359436f) {
      _38 = exp2((_19 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _38 = 65504.0f;
    }
  }
  if (!(!(_23 <= -0.3013699948787689f))) {
    _52 = (exp2((_20 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_23 < 1.468000054359436f) {
      _52 = exp2((_20 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _52 = 65504.0f;
    }
  }
  if (!(!(_24 <= -0.3013699948787689f))) {
    _66 = (exp2((_21 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_24 < 1.468000054359436f) {
      _66 = exp2((_21 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _66 = 65504.0f;
    }
  }
  float _142 = _38 * 0.000244140625f;
  float _155 = exp2(log2(mad((round(mad(-0.03579999879002571f, (OCIO_ToXYZMatrix[2].z), mad(0.6976000070571899f, (OCIO_ToXYZMatrix[1].z), ((OCIO_ToXYZMatrix[0].z) * 0.35920000076293945f))) * 4096.0f) * 0.000244140625f), _66, mad((round(mad(-0.03579999879002571f, (OCIO_ToXYZMatrix[2].y), mad(0.6976000070571899f, (OCIO_ToXYZMatrix[1].y), ((OCIO_ToXYZMatrix[0].y) * 0.35920000076293945f))) * 4096.0f) * 0.000244140625f), _52, (round(mad(-0.03579999879002571f, (OCIO_ToXYZMatrix[2].x), mad(0.6976000070571899f, (OCIO_ToXYZMatrix[1].x), ((OCIO_ToXYZMatrix[0].x) * 0.35920000076293945f))) * 4096.0f) * _142))) * 0.009999999776482582f) * 0.1593017578125f);
  float _164 = saturate(exp2(log2(((_155 * 18.8515625f) + 0.8359375f) / ((_155 * 18.6875f) + 1.0f)) * 78.84375f));
  float _168 = exp2(log2(mad((round(mad(0.0754999965429306f, (OCIO_ToXYZMatrix[2].z), mad(1.1003999710083008f, (OCIO_ToXYZMatrix[1].z), ((OCIO_ToXYZMatrix[0].z) * -0.19220000505447388f))) * 4096.0f) * 0.000244140625f), _66, mad((round(mad(0.0754999965429306f, (OCIO_ToXYZMatrix[2].y), mad(1.1003999710083008f, (OCIO_ToXYZMatrix[1].y), ((OCIO_ToXYZMatrix[0].y) * -0.19220000505447388f))) * 4096.0f) * 0.000244140625f), _52, (round(mad(0.0754999965429306f, (OCIO_ToXYZMatrix[2].x), mad(1.1003999710083008f, (OCIO_ToXYZMatrix[1].x), ((OCIO_ToXYZMatrix[0].x) * -0.19220000505447388f))) * 4096.0f) * _142))) * 0.009999999776482582f) * 0.1593017578125f);
  float _177 = saturate(exp2(log2(((_168 * 18.8515625f) + 0.8359375f) / ((_168 * 18.6875f) + 1.0f)) * 78.84375f));
  float _181 = exp2(log2(mad((round(mad(0.8434000015258789f, (OCIO_ToXYZMatrix[2].z), mad(0.07490000128746033f, (OCIO_ToXYZMatrix[1].z), ((OCIO_ToXYZMatrix[0].z) * 0.007000000216066837f))) * 4096.0f) * 0.000244140625f), _66, mad((round(mad(0.8434000015258789f, (OCIO_ToXYZMatrix[2].y), mad(0.07490000128746033f, (OCIO_ToXYZMatrix[1].y), ((OCIO_ToXYZMatrix[0].y) * 0.007000000216066837f))) * 4096.0f) * 0.000244140625f), _52, (round(mad(0.8434000015258789f, (OCIO_ToXYZMatrix[2].x), mad(0.07490000128746033f, (OCIO_ToXYZMatrix[1].x), ((OCIO_ToXYZMatrix[0].x) * 0.007000000216066837f))) * 4096.0f) * _142))) * 0.009999999776482582f) * 0.1593017578125f);
  float _190 = saturate(exp2(log2(((_181 * 18.8515625f) + 0.8359375f) / ((_181 * 18.6875f) + 1.0f)) * 78.84375f));
  float _192 = (_177 + _164) * 0.5f;
  float _196 = toeEnd * 0.009999999776482582f;
  float _198 = blackPoint * 0.009999999776482582f;
  float _203 = exp2(log2(saturate(_192)) * 0.012683313339948654f);
  float _212 = exp2(log2(max(0.0f, (_203 + -0.8359375f)) / (18.8515625f - (_203 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  if (!(_196 == 0.0f)) {
    float _215 = max(_198, 0.0f);
    float _219 = saturate((_212 - _215) / (_196 - _215));
    do {
      if (!(_212 <= _198)) {
        if (!(!(_198 >= 0.0f))) {
          float _230 = -1.0f / (_198 + -1.0f);
          _240 = ((1.0f - _230) + (_230 * _212));
        } else {
          _240 = ((-0.0f - _198) - (_212 * (-1.0f - _198)));
        }
      } else {
        _240 = 0.0f;
      }
      _248 = ((((pow(_240, toeStrength))-_212) * (1.0f - ((_219 * _219) * (3.0f - (_219 * 2.0f))))) + _212);
    } while (false);
  } else {
    _248 = _212;
  }
  if (!((bool)(_18 == _15) && (bool)(_248 > _15))) {
    float _256 = (1.0f - shoulderStartPoint) * _15;
    float _257 = _15 - _256;
    float _258 = exp2(shoulderStrength);
    float _261 = _257 / _258;
    float _262 = _15 - _261;
    float _263 = ((1.0f / _258) * _248) - _15;
    do {
      if (_263 < -0.0f) {
        float _279 = ((((((shoulderAngle + -0.5f) * min(shoulderStrength, 1.0f)) + 0.5f) * 2.0f) * _262) * select((_261 == 0.0f), 1.0f, (_257 / _261))) / _256;
        _290 = (-0.0f - exp2((log2(_256) - (log2(_262) * _279)) + (log2(-0.0f - _263) * _279)));
      } else {
        _290 = -0.0f;
      }
      _295 = select((_248 <= _18), _248, (_290 + _15));
    } while (false);
  } else {
    _295 = _15;
  }
  float _299 = exp2(log2(_295 * 0.009999999776482582f) * 0.1593017578125f);
  float _308 = saturate(exp2(log2(((_299 * 18.8515625f) + 0.8359375f) / ((_299 * 18.6875f) + 1.0f)) * 78.84375f));
  float _315 = min((_192 / _308), (_308 / _192)) * (saturationOnDisplayMapping * 0.000244140625f);
  float _316 = _315 * dot(float3(_164, _177, _190), float3(6610.0f, -13613.0f, 7003.0f));
  float _317 = _315 * dot(float3(_164, _177, _190), float3(17933.0f, -17390.0f, -543.0f));
  float _327 = exp2(log2(saturate(mad(0.11100000143051147f, _317, mad(0.008999999612569809f, _316, _308)))) * 0.012683313339948654f);
  float _335 = exp2(log2(max(0.0f, (_327 + -0.8359375f)) / (18.8515625f - (_327 * 18.6875f))) * 6.277394771575928f);
  float _339 = exp2(log2(saturate(mad(-0.11100000143051147f, _317, mad(-0.008999999612569809f, _316, _308)))) * 0.012683313339948654f);
  float _348 = exp2(log2(max(0.0f, (_339 + -0.8359375f)) / (18.8515625f - (_339 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _352 = exp2(log2(saturate(mad(-0.32100000977516174f, _317, mad(0.5600000023841858f, _316, _308)))) * 0.012683313339948654f);
  float _361 = exp2(log2(max(0.0f, (_352 + -0.8359375f)) / (18.8515625f - (_352 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _364 = mad(0.2070000022649765f, _361, mad(-1.3270000219345093f, _348, (_335 * 207.10000610351562f)));
  float _367 = mad(-0.04500000178813934f, _361, mad(0.6809999942779541f, _348, (_335 * 36.5f)));
  float _370 = mad(1.187999963760376f, _361, mad(-0.05000000074505806f, _348, (_335 * -4.900000095367432f)));
  float _373 = mad((OCIO_XYZToMatrix[0].z), _370, mad((OCIO_XYZToMatrix[0].y), _367, (_364 * (OCIO_XYZToMatrix[0].x))));
  float _376 = mad((OCIO_XYZToMatrix[1].z), _370, mad((OCIO_XYZToMatrix[1].y), _367, (_364 * (OCIO_XYZToMatrix[1].x))));
  float _379 = mad((OCIO_XYZToMatrix[2].z), _370, mad((OCIO_XYZToMatrix[2].y), _367, (_364 * (OCIO_XYZToMatrix[2].x))));

  // AP1 -> AP0
  float _382 = mad(_379, 0.1638689935207367f, mad(_376, 0.1406790018081665f, (_373 * 0.6954519748687744f)));
  float _385 = mad(_379, 0.0955343022942543f, mad(_376, 0.8596709966659546f, (_373 * 0.04479460045695305f)));
  float _388 = mad(_379, 1.0015000104904175f, mad(_376, 0.004025210160762072f, (_373 * -0.00552588002756238f)));
  float _389 = abs(_382);
  if (_389 > 6.103515625e-05f) {
    float _392 = min(_389, 65504.0f);
    float _394 = floor(log2(_392));
    float _395 = exp2(_394);
    _402 = dot(float3(_394, ((_392 - _395) / _395), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _402 = (_389 * 16777216.0f);
  }
  float _405 = _402 + select((_382 < 0.0f), 32768.0f, 0.0f);
  float _407 = floor(_405 * 0.00024420025874860585f);
  float4 _416 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_405 + 0.5f) - (_407 * 4095.0f)) * 0.000244140625f), ((_407 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _418 = abs(_385);
  if (_418 > 6.103515625e-05f) {
    float _421 = min(_418, 65504.0f);
    float _423 = floor(log2(_421));
    float _424 = exp2(_423);
    _431 = dot(float3(_423, ((_421 - _424) / _424), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _431 = (_418 * 16777216.0f);
  }
  float _434 = _431 + select((_385 < 0.0f), 32768.0f, 0.0f);
  float _436 = floor(_434 * 0.00024420025874860585f);
  float4 _443 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_434 + 0.5f) - (_436 * 4095.0f)) * 0.000244140625f), ((_436 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _445 = abs(_388);
  if (_445 > 6.103515625e-05f) {
    float _448 = min(_445, 65504.0f);
    float _450 = floor(log2(_448));
    float _451 = exp2(_450);
    _458 = dot(float3(_450, ((_448 - _451) / _451), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _458 = (_445 * 16777216.0f);
  }
  float _461 = _458 + select((_388 < 0.0f), 32768.0f, 0.0f);
  float _463 = floor(_461 * 0.00024420025874860585f);
  float4 _470 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_461 + 0.5f) - (_463 * 4095.0f)) * 0.000244140625f), ((_463 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _472 = _416.x * 64.0f;
  float _473 = _443.x * 64.0f;
  float _474 = _470.x * 64.0f;
  float _475 = floor(_472);
  float _476 = floor(_473);
  float _477 = floor(_474);
  float _478 = _472 - _475;
  float _479 = _473 - _476;
  float _480 = _474 - _477;
  float _484 = (_477 + 0.5f) * 0.015384615398943424f;
  float _485 = (_476 + 0.5f) * 0.015384615398943424f;
  float _486 = (_475 + 0.5f) * 0.015384615398943424f;
  float4 _489 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_484, _485, _486), 0.0f);
  float _493 = _484 + 0.015384615398943424f;
  float _494 = _485 + 0.015384615398943424f;
  float _495 = _486 + 0.015384615398943424f;
  float4 _496 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_493, _494, _495), 0.0f);
  if (!(!(_478 >= _479))) {
    if (!(!(_479 >= _480))) {
      float4 _504 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_484, _485, _495), 0.0f);
      float4 _508 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_484, _494, _495), 0.0f);
      float _512 = _478 - _479;
      float _513 = _479 - _480;
      _630 = ((_508.x * _513) + (_504.x * _512));
      _631 = ((_508.y * _513) + (_504.y * _512));
      _632 = ((_508.z * _513) + (_504.z * _512));
      _633 = _478;
      _634 = _480;
    } else {
      if (!(!(_478 >= _480))) {
        float4 _526 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_484, _485, _495), 0.0f);
        float4 _530 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_493, _485, _495), 0.0f);
        float _534 = _478 - _480;
        float _535 = _480 - _479;
        _630 = ((_530.x * _535) + (_526.x * _534));
        _631 = ((_530.y * _535) + (_526.y * _534));
        _632 = ((_530.z * _535) + (_526.z * _534));
        _633 = _478;
        _634 = _479;
      } else {
        float4 _546 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_493, _485, _486), 0.0f);
        float4 _550 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_493, _485, _495), 0.0f);
        float _554 = _480 - _478;
        float _555 = _478 - _479;
        _630 = ((_550.x * _555) + (_546.x * _554));
        _631 = ((_550.y * _555) + (_546.y * _554));
        _632 = ((_550.z * _555) + (_546.z * _554));
        _633 = _480;
        _634 = _479;
      }
    }
  } else {
    if (!(!(_479 <= _480))) {
      float4 _568 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_493, _485, _486), 0.0f);
      float4 _572 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_493, _494, _486), 0.0f);
      float _576 = _480 - _479;
      float _577 = _479 - _478;
      _630 = ((_572.x * _577) + (_568.x * _576));
      _631 = ((_572.y * _577) + (_568.y * _576));
      _632 = ((_572.z * _577) + (_568.z * _576));
      _633 = _480;
      _634 = _478;
    } else {
      if (!(!(_478 >= _480))) {
        float4 _590 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_484, _494, _486), 0.0f);
        float4 _594 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_484, _494, _495), 0.0f);
        float _598 = _479 - _478;
        float _599 = _478 - _480;
        _630 = ((_594.x * _599) + (_590.x * _598));
        _631 = ((_594.y * _599) + (_590.y * _598));
        _632 = ((_594.z * _599) + (_590.z * _598));
        _633 = _479;
        _634 = _480;
      } else {
        float4 _610 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_484, _494, _486), 0.0f);
        float4 _614 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_493, _494, _486), 0.0f);
        float _618 = _479 - _480;
        float _619 = _480 - _478;
        _630 = ((_614.x * _619) + (_610.x * _618));
        _631 = ((_614.y * _619) + (_610.y * _618));
        _632 = ((_614.z * _619) + (_610.z * _618));
        _633 = _479;
        _634 = _478;
      }
    }
  }
  float _635 = 1.0f - _633;

  // _635 = 99999.f;

  OutLUT[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((((_635 * _489.x) + _630) + (_634 * _496.x)), (((_635 * _489.y) + _631) + (_634 * _496.y)), (((_635 * _489.z) + _632) + (_634 * _496.z)), 1.0f);
}

