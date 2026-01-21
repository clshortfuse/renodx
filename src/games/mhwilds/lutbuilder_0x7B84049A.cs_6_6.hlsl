#include "./shared.h"

Texture2D<float4> OCIO_lut1d_0 : register(t0);

Texture3D<float4> OCIO_lut3d_1 : register(t1);

RWTexture3D<float4> OutLUT : register(u0);

cbuffer HDRMapping : register(b0) {
  float whitePaperNits : packoffset(c000.x);
  float configImageAlphaScale : packoffset(c000.y);
  float displayMaxNits : packoffset(c000.z);
  float displayMinNits : packoffset(c000.w);
  float4 displayMaxNitsRect : packoffset(c001.x);
  float4 secondaryDisplayMaxNitsRect : packoffset(c002.x);
  float4 standardMaxNitsRect : packoffset(c003.x);
  float4 secondaryStandardMaxNitsRect : packoffset(c004.x);
  float2 displayMaxNitsRectSize : packoffset(c005.x);
  float2 standardMaxNitsRectSize : packoffset(c005.z);
  float4 mdrOutRangeRect : packoffset(c006.x);
  uint drawMode : packoffset(c007.x);
  float gammaForHDR : packoffset(c007.y);
  float displayMaxNitsST2084 : packoffset(c007.z);
  float displayMinNitsST2084 : packoffset(c007.w);
  uint drawModeOnMDRPass : packoffset(c008.x);
  float saturationForHDR : packoffset(c008.y);
  float2 targetInvSize : packoffset(c008.z);
  float toeEnd : packoffset(c009.x);
  float toeStrength : packoffset(c009.y);
  float blackPoint : packoffset(c009.z);
  float shoulderStartPoint : packoffset(c009.w);
  float shoulderStrength : packoffset(c010.x);
  float whitePaperNitsForOverlay : packoffset(c010.y);
  float saturationOnDisplayMapping : packoffset(c010.z);
  float graphScale : packoffset(c010.w);
  float4 hdrImageRect : packoffset(c011.x);
  float2 hdrImageRectSize : packoffset(c012.x);
  float secondaryDisplayMaxNits : packoffset(c012.z);
  float secondaryDisplayMinNits : packoffset(c012.w);
  float2 secondaryDisplayMaxNitsRectSize : packoffset(c013.x);
  float2 secondaryStandardMaxNitsRectSize : packoffset(c013.z);
  float shoulderAngle : packoffset(c014.x);
  uint enableHDRAdjustmentForOverlay : packoffset(c014.y);
  float brightnessAdjustmentForOverlay : packoffset(c014.z);
  float saturateAdjustmentForOverlay : packoffset(c014.w);
};

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
    uint SV_GroupIndex: SV_GroupIndex
) {
  float displayMaxNits = 1000.f;
  const float toeEnd = 25.f;
  const float toeStrength = 1.f;
  const float blackPoint = 0.f;
  const float shoulderStartPoint = 0.2;
  const float shoulderStrength = 0.f;
  const float saturationOnDisplayMapping = 1.f;
  const float shoulderAngle = 0.5f;

  float _15 = displayMaxNits * 0.009999999776482582f;
  float _18 = _15 * shoulderStartPoint;
  float _19 = float((uint)SV_DispatchThreadID.x);
  float _20 = float((uint)SV_DispatchThreadID.y);
  float _21 = float((uint)SV_DispatchThreadID.z);
  float _22 = _19 * 0.01587301678955555f;
  float _23 = _20 * 0.01587301678955555f;
  float _24 = _21 * 0.01587301678955555f;

  float3 lutInput = float3(_22, _23, _24);

  float _38;
  float _52;
  float _66;
  float _242;
  float _250;
  float _295;
  float _300;
  float _407;
  float _436;
  float _463;
  float _635;
  float _636;
  float _637;
  float _638;
  float _639;

  // ACEScc
  float3 ap1_color = renodx::color::pq::DecodeSafe(lutInput, 100.f);

//   // Doesn't do anything with our hardcoded values
// #if 0
//   if (!(!(_22 <= -0.3013699948787689f))) {
//     _38 = (exp2((_19 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
//   } else {
//     if (_22 < 1.468000054359436f) {
//       _38 = exp2((_19 * 0.2780952751636505f) + -9.720000267028809f);
//     } else {
//       _38 = 65504.0f;
//     }
//   }
//   if (!(!(_23 <= -0.3013699948787689f))) {
//     _52 = (exp2((_20 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
//   } else {
//     if (_23 < 1.468000054359436f) {
//       _52 = exp2((_20 * 0.2780952751636505f) + -9.720000267028809f);
//     } else {
//       _52 = 65504.0f;
//     }
//   }
//   if (!(!(_24 <= -0.3013699948787689f))) {
//     _66 = (exp2((_21 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
//   } else {
//     if (_24 < 1.468000054359436f) {
//       _66 = exp2((_21 * 0.2780952751636505f) + -9.720000267028809f);
//     } else {
//       _66 = 65504.0f;
//     }
//   }

//   _38 = ap1_color.r;
//   _52 = ap1_color.g;
//   _66 = ap1_color.b;

//   float _142 = _38 * 0.000244140625f;
//   float _155 = exp2(log2(mad((round(mad(-0.03579999879002571f, (OCIO_ToXYZMatrix[2].z), mad(0.6976000070571899f, (OCIO_ToXYZMatrix[1].z), ((OCIO_ToXYZMatrix[0].z) * 0.35920000076293945f))) * 4096.0f) * 0.000244140625f), _66, mad((round(mad(-0.03579999879002571f, (OCIO_ToXYZMatrix[2].y), mad(0.6976000070571899f, (OCIO_ToXYZMatrix[1].y), ((OCIO_ToXYZMatrix[0].y) * 0.35920000076293945f))) * 4096.0f) * 0.000244140625f), _52, (_142 * round(mad(-0.03579999879002571f, (OCIO_ToXYZMatrix[2].x), mad(0.6976000070571899f, (OCIO_ToXYZMatrix[1].x), ((OCIO_ToXYZMatrix[0].x) * 0.35920000076293945f))) * 4096.0f)))) * 0.009999999776482582f) * 0.1593017578125f);
//   float _164 = saturate(exp2(log2(((_155 * 18.8515625f) + 0.8359375f) / ((_155 * 18.6875f) + 1.0f)) * 78.84375f));
//   float _168 = exp2(log2(mad((round(mad(0.0754999965429306f, (OCIO_ToXYZMatrix[2].z), mad(1.1003999710083008f, (OCIO_ToXYZMatrix[1].z), ((OCIO_ToXYZMatrix[0].z) * -0.19220000505447388f))) * 4096.0f) * 0.000244140625f), _66, mad((round(mad(0.0754999965429306f, (OCIO_ToXYZMatrix[2].y), mad(1.1003999710083008f, (OCIO_ToXYZMatrix[1].y), ((OCIO_ToXYZMatrix[0].y) * -0.19220000505447388f))) * 4096.0f) * 0.000244140625f), _52, (_142 * round(mad(0.0754999965429306f, (OCIO_ToXYZMatrix[2].x), mad(1.1003999710083008f, (OCIO_ToXYZMatrix[1].x), ((OCIO_ToXYZMatrix[0].x) * -0.19220000505447388f))) * 4096.0f)))) * 0.009999999776482582f) * 0.1593017578125f);
//   float _177 = saturate(exp2(log2(((_168 * 18.8515625f) + 0.8359375f) / ((_168 * 18.6875f) + 1.0f)) * 78.84375f));
//   float _181 = exp2(log2(mad((round(mad(0.8434000015258789f, (OCIO_ToXYZMatrix[2].z), mad(0.07490000128746033f, (OCIO_ToXYZMatrix[1].z), ((OCIO_ToXYZMatrix[0].z) * 0.007000000216066837f))) * 4096.0f) * 0.000244140625f), _66, mad((round(mad(0.8434000015258789f, (OCIO_ToXYZMatrix[2].y), mad(0.07490000128746033f, (OCIO_ToXYZMatrix[1].y), ((OCIO_ToXYZMatrix[0].y) * 0.007000000216066837f))) * 4096.0f) * 0.000244140625f), _52, (_142 * round(mad(0.8434000015258789f, (OCIO_ToXYZMatrix[2].x), mad(0.07490000128746033f, (OCIO_ToXYZMatrix[1].x), ((OCIO_ToXYZMatrix[0].x) * 0.007000000216066837f))) * 4096.0f)))) * 0.009999999776482582f) * 0.1593017578125f);
//   float _190 = saturate(exp2(log2(((_181 * 18.8515625f) + 0.8359375f) / ((_181 * 18.6875f) + 1.0f)) * 78.84375f));
//   float _192 = (_177 + _164) * 0.5f;
//   float _198 = toeEnd * 0.009999999776482582f;
//   float _200 = blackPoint * 0.009999999776482582f;
//   float _205 = exp2(log2(saturate(_192)) * 0.012683313339948654f);
//   float _214 = exp2(log2(max(0.0f, (_205 + -0.8359375f)) / (18.8515625f - (_205 * 18.6875f))) * 6.277394771575928f) * 100.0f;
//   if (!(_198 == 0.0f)) {
//     float _217 = max(_200, 0.0f);
//     float _221 = saturate((_214 - _217) / (_198 - _217));
//     if (!(_214 <= _200)) {
//       if (!(!(_200 >= 0.0f))) {
//         float _232 = -1.0f / (_200 + -1.0f);
//         _242 = ((1.0f - _232) + (_232 * _214));
//       } else {
//         _242 = ((-0.0f - _200) - (_214 * (-1.0f - _200)));
//       }
//     } else {
//       _242 = 0.0f;
//     }
//     _250 = ((((pow(_242, toeStrength)) - _214) * (1.0f - ((_221 * _221) * (3.0f - (_221 * 2.0f))))) + _214);
//   } else {
//     _250 = _214;
//   }
//   if (!((bool)(_18 == _15) && (bool)(_250 > _15))) {
//     float _258 = (1.0f - shoulderStartPoint) * _15;
//     float _259 = _15 - _258;
//     float _260 = exp2(shoulderStrength);
//     float _263 = _259 / _260;
//     float _264 = _15 - _263;
//     float _265 = ((1.0f / _260) * _250) - _15;
//     if (_265 < -0.0f) {
//       float _281 = ((((((shoulderAngle + -0.5f) * min(shoulderStrength, 1.0f)) + 0.5f) * 2.0f) * select((_263 == 0.0f), 1.0f, (_259 / _263))) * _264) / _258;
//       _295 = (-0.0f - exp2(((((log2(-0.0f - _265) * _281) + log2(_258)) * 0.6931471824645996f) + ((_281 * -0.6931471824645996f) * log2(_264))) * 1.4426950216293335f));
//     } else {
//       _295 = -0.0f;
//     }
//     _300 = select((_250 <= _18), _250, (_295 + _15));
//   } else {
//     _300 = _15;
//   }
//   // PQ Encode 100 nits
//   float _304 = exp2(log2(_300 * 0.009999999776482582f) * 0.1593017578125f);
//   float _313 = saturate(exp2(log2(((_304 * 18.8515625f) + 0.8359375f) / ((_304 * 18.6875f) + 1.0f)) * 78.84375f));

//   // custom stuff?
//   float _320 = min((_192 / _313), (_313 / _192));
//   float _321 = ((dot(float3(_164, _177, _190), float3(6610.0f, -13613.0f, 7003.0f)) * 0.000244140625f) * saturationOnDisplayMapping) * _320;
//   float _322 = ((dot(float3(_164, _177, _190), float3(17933.0f, -17390.0f, -543.0f)) * 0.000244140625f) * saturationOnDisplayMapping) * _320;

//   // More matrix and encode back to PQ
//   float _332 = exp2(log2(saturate(mad(0.11100000143051147f, _322, mad(0.008999999612569809f, _321, _313)))) * 0.012683313339948654f);
//   float _340 = exp2(log2(max(0.0f, (_332 + -0.8359375f)) / (18.8515625f - (_332 * 18.6875f))) * 6.277394771575928f);
//   float _344 = exp2(log2(saturate(mad(-0.11100000143051147f, _322, mad(-0.008999999612569809f, _321, _313)))) * 0.012683313339948654f);
//   float _353 = exp2(log2(max(0.0f, (_344 + -0.8359375f)) / (18.8515625f - (_344 * 18.6875f))) * 6.277394771575928f) * 100.0f;
//   float _357 = exp2(log2(saturate(mad(-0.32100000977516174f, _322, mad(0.5600000023841858f, _321, _313)))) * 0.012683313339948654f);
//   float _366 = exp2(log2(max(0.0f, (_357 + -0.8359375f)) / (18.8515625f - (_357 * 18.6875f))) * 6.277394771575928f) * 100.0f;
//   float _369 = mad(0.2070000022649765f, _366, mad(-1.3270000219345093f, _353, (_340 * 207.10000610351562f)));
//   float _372 = mad(-0.04500000178813934f, _366, mad(0.6809999942779541f, _353, (_340 * 36.5f)));
//   float _375 = mad(1.187999963760376f, _366, mad(-0.05000000074505806f, _353, (_340 * -4.900000095367432f)));
//   float _378 = mad((OCIO_XYZToMatrix[0].z), _375, mad((OCIO_XYZToMatrix[0].y), _372, (_369 * (OCIO_XYZToMatrix[0].x))));
//   float _381 = mad((OCIO_XYZToMatrix[1].z), _375, mad((OCIO_XYZToMatrix[1].y), _372, (_369 * (OCIO_XYZToMatrix[1].x))));
//   float _384 = mad((OCIO_XYZToMatrix[2].z), _375, mad((OCIO_XYZToMatrix[2].y), _372, (_369 * (OCIO_XYZToMatrix[2].x))));
//   ap1_color = float3(_378, _381, _384);
// #endif

  float _378 = ap1_color.r;
  float _381 = ap1_color.g;
  float _384 = ap1_color.b;

  // AP1_TO_AP0_MAT
  float _387 = mad(_384, 0.1638689935207367f, mad(_381, 0.1406790018081665f, (_378 * 0.6954519748687744f)));
  float _390 = mad(_384, 0.0955343022942543f, mad(_381, 0.8596709966659546f, (_378 * 0.04479460045695305f)));
  float _393 = mad(_384, 1.0015000104904175f, mad(_381, 0.004025210160762072f, (_378 * -0.00552588002756238f)));
  float _394 = abs(_387);
  if (_394 > 6.103515625e-05f) {
    float _397 = min(_394, 65504.0f);
    float _399 = floor(log2(_397));
    float _400 = exp2(_399);
    _407 = dot(float3(_399, ((_397 - _400) / _400), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _407 = (_394 * 16777216.0f);
  }
  float _410 = _407 + select((_387 > 0.0f), 0.0f, 32768.0f);
  float _412 = floor(_410 * 0.00024420025874860585f);
  float4 _421 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_410 + 0.5f) - (_412 * 4095.0f)) * 0.000244140625f), ((_412 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _423 = abs(_390);
  if (_423 > 6.103515625e-05f) {
    float _426 = min(_423, 65504.0f);
    float _428 = floor(log2(_426));
    float _429 = exp2(_428);
    _436 = dot(float3(_428, ((_426 - _429) / _429), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _436 = (_423 * 16777216.0f);
  }
  float _439 = _436 + select((_390 > 0.0f), 0.0f, 32768.0f);
  float _441 = floor(_439 * 0.00024420025874860585f);
  float4 _448 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_439 + 0.5f) - (_441 * 4095.0f)) * 0.000244140625f), ((_441 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _450 = abs(_393);
  if (_450 > 6.103515625e-05f) {
    float _453 = min(_450, 65504.0f);
    float _455 = floor(log2(_453));
    float _456 = exp2(_455);
    _463 = dot(float3(_455, ((_453 - _456) / _456), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _463 = (_450 * 16777216.0f);
  }
  float _466 = _463 + select((_393 > 0.0f), 0.0f, 32768.0f);
  float _468 = floor(_466 * 0.00024420025874860585f);
  float4 _475 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_466 + 0.5f) - (_468 * 4095.0f)) * 0.000244140625f), ((_468 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _477 = _421.x * 64.0f;
  float _478 = _448.x * 64.0f;
  float _479 = _475.x * 64.0f;
  float _480 = floor(_477);
  float _481 = floor(_478);
  float _482 = floor(_479);
  float _483 = _477 - _480;
  float _484 = _478 - _481;
  float _485 = _479 - _482;
  float _489 = (_482 + 0.5f) * 0.015384615398943424f;
  float _490 = (_481 + 0.5f) * 0.015384615398943424f;
  float _491 = (_480 + 0.5f) * 0.015384615398943424f;
  float4 _494 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _490, _491), 0.0f);
  float _498 = _489 + 0.015384615398943424f;
  float _499 = _490 + 0.015384615398943424f;
  float _500 = _491 + 0.015384615398943424f;
  float4 _501 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _499, _500), 0.0f);
  if (!(!(_483 >= _484))) {
    if (!(!(_484 >= _485))) {
      float4 _509 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _490, _500), 0.0f);
      float4 _513 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _499, _500), 0.0f);
      float _517 = _483 - _484;
      float _518 = _484 - _485;
      _635 = ((_513.x * _518) + (_509.x * _517));
      _636 = ((_513.y * _518) + (_509.y * _517));
      _637 = ((_513.z * _518) + (_509.z * _517));
      _638 = _483;
      _639 = _485;
    } else {
      if (!(!(_483 >= _485))) {
        float4 _531 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _490, _500), 0.0f);
        float4 _535 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _490, _500), 0.0f);
        float _539 = _483 - _485;
        float _540 = _485 - _484;
        _635 = ((_535.x * _540) + (_531.x * _539));
        _636 = ((_535.y * _540) + (_531.y * _539));
        _637 = ((_535.z * _540) + (_531.z * _539));
        _638 = _483;
        _639 = _484;
      } else {
        float4 _551 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _490, _491), 0.0f);
        float4 _555 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _490, _500), 0.0f);
        float _559 = _485 - _483;
        float _560 = _483 - _484;
        _635 = ((_555.x * _560) + (_551.x * _559));
        _636 = ((_555.y * _560) + (_551.y * _559));
        _637 = ((_555.z * _560) + (_551.z * _559));
        _638 = _485;
        _639 = _484;
      }
    }
  } else {
    if (!(!(_484 <= _485))) {
      float4 _573 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _490, _491), 0.0f);
      float4 _577 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _499, _491), 0.0f);
      float _581 = _485 - _484;
      float _582 = _484 - _483;
      _635 = ((_577.x * _582) + (_573.x * _581));
      _636 = ((_577.y * _582) + (_573.y * _581));
      _637 = ((_577.z * _582) + (_573.z * _581));
      _638 = _485;
      _639 = _483;
    } else {
      if (!(!(_483 >= _485))) {
        float4 _595 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _499, _491), 0.0f);
        float4 _599 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _499, _500), 0.0f);
        float _603 = _484 - _483;
        float _604 = _483 - _485;
        _635 = ((_599.x * _604) + (_595.x * _603));
        _636 = ((_599.y * _604) + (_595.y * _603));
        _637 = ((_599.z * _604) + (_595.z * _603));
        _638 = _484;
        _639 = _485;
      } else {
        float4 _615 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_489, _499, _491), 0.0f);
        float4 _619 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_498, _499, _491), 0.0f);
        float _623 = _484 - _485;
        float _624 = _485 - _483;
        _635 = (((_619.x) * _624) + ((_615.x) * _623));
        _636 = (((_619.y) * _624) + ((_615.y) * _623));
        _637 = (((_619.z) * _624) + ((_615.z) * _623));
        _638 = _484;
        _639 = _483;
      }
    }
  }
  float _640 = 1.0f - _638;

  // OutLUT[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4((((_640 * _494.x) + _635) + (_639 * _501.x)), (((_640 * _494.y) + _636) + (_639 * _501.y)), (((_640 * _494.z) + _637) + (_639 * _501.z)), 1.0f);

  float3 final_color = float3((((_640 * (_494.x)) + _635) + (_639 * (_501.x))), (((_640 * (_494.y)) + _636) + (_639 * (_501.y))), (((_640 * (_494.z)) + _637) + (_639 * (_501.z))));

  OutLUT[int3(((uint)(SV_DispatchThreadID.x)), ((uint)(SV_DispatchThreadID.y)), ((uint)(SV_DispatchThreadID.z)))] = float4(final_color, 1.f);
}
