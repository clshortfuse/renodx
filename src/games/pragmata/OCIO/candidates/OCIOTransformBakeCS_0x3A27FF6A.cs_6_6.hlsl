#include "../../common.hlsli"
#include "../CBuffers/HDRMapping.hlsli"

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

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _11 = displayMaxNits * 0.009999999776482582f;
  float _14 = _11 * shoulderStartPoint;
  float _15 = float((uint)SV_DispatchThreadID.x);
  float _16 = float((uint)SV_DispatchThreadID.y);
  float _17 = float((uint)SV_DispatchThreadID.z);
  float _18 = _15 * 0.01587301678955555f;
  float _19 = _16 * 0.01587301678955555f;
  float _20 = _17 * 0.01587301678955555f;
  float _34;
  float _48;
  float _62;
  float _236;
  float _244;
  float _286;
  float _291;
  if (!(!(_18 <= -0.3013699948787689f))) {
    _34 = (exp2((_15 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_18 < 1.468000054359436f) {
      _34 = exp2((_15 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _34 = 65504.0f;
    }
  }
  if (!(!(_19 <= -0.3013699948787689f))) {
    _48 = (exp2((_16 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_19 < 1.468000054359436f) {
      _48 = exp2((_16 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _48 = 65504.0f;
    }
  }
  if (!(!(_20 <= -0.3013699948787689f))) {
    _62 = (exp2((_17 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_20 < 1.468000054359436f) {
      _62 = exp2((_17 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _62 = 65504.0f;
    }
  }
  float _138 = _34 * 0.000244140625f;
  float _151 = exp2(log2(mad((round(mad(-0.03579999879002571f, (OCIO_ToXYZMatrix[2].z), mad(0.6976000070571899f, (OCIO_ToXYZMatrix[1].z), ((OCIO_ToXYZMatrix[0].z) * 0.35920000076293945f))) * 4096.0f) * 0.000244140625f), _62, mad((round(mad(-0.03579999879002571f, (OCIO_ToXYZMatrix[2].y), mad(0.6976000070571899f, (OCIO_ToXYZMatrix[1].y), ((OCIO_ToXYZMatrix[0].y) * 0.35920000076293945f))) * 4096.0f) * 0.000244140625f), _48, (round(mad(-0.03579999879002571f, (OCIO_ToXYZMatrix[2].x), mad(0.6976000070571899f, (OCIO_ToXYZMatrix[1].x), ((OCIO_ToXYZMatrix[0].x) * 0.35920000076293945f))) * 4096.0f) * _138))) * 0.009999999776482582f) * 0.1593017578125f);
  float _160 = saturate(exp2(log2(((_151 * 18.8515625f) + 0.8359375f) / ((_151 * 18.6875f) + 1.0f)) * 78.84375f));
  float _164 = exp2(log2(mad((round(mad(0.0754999965429306f, (OCIO_ToXYZMatrix[2].z), mad(1.1003999710083008f, (OCIO_ToXYZMatrix[1].z), ((OCIO_ToXYZMatrix[0].z) * -0.19220000505447388f))) * 4096.0f) * 0.000244140625f), _62, mad((round(mad(0.0754999965429306f, (OCIO_ToXYZMatrix[2].y), mad(1.1003999710083008f, (OCIO_ToXYZMatrix[1].y), ((OCIO_ToXYZMatrix[0].y) * -0.19220000505447388f))) * 4096.0f) * 0.000244140625f), _48, (round(mad(0.0754999965429306f, (OCIO_ToXYZMatrix[2].x), mad(1.1003999710083008f, (OCIO_ToXYZMatrix[1].x), ((OCIO_ToXYZMatrix[0].x) * -0.19220000505447388f))) * 4096.0f) * _138))) * 0.009999999776482582f) * 0.1593017578125f);
  float _173 = saturate(exp2(log2(((_164 * 18.8515625f) + 0.8359375f) / ((_164 * 18.6875f) + 1.0f)) * 78.84375f));
  float _177 = exp2(log2(mad((round(mad(0.8434000015258789f, (OCIO_ToXYZMatrix[2].z), mad(0.07490000128746033f, (OCIO_ToXYZMatrix[1].z), ((OCIO_ToXYZMatrix[0].z) * 0.007000000216066837f))) * 4096.0f) * 0.000244140625f), _62, mad((round(mad(0.8434000015258789f, (OCIO_ToXYZMatrix[2].y), mad(0.07490000128746033f, (OCIO_ToXYZMatrix[1].y), ((OCIO_ToXYZMatrix[0].y) * 0.007000000216066837f))) * 4096.0f) * 0.000244140625f), _48, (round(mad(0.8434000015258789f, (OCIO_ToXYZMatrix[2].x), mad(0.07490000128746033f, (OCIO_ToXYZMatrix[1].x), ((OCIO_ToXYZMatrix[0].x) * 0.007000000216066837f))) * 4096.0f) * _138))) * 0.009999999776482582f) * 0.1593017578125f);
  float _186 = saturate(exp2(log2(((_177 * 18.8515625f) + 0.8359375f) / ((_177 * 18.6875f) + 1.0f)) * 78.84375f));
  float _188 = (_173 + _160) * 0.5f;
  float _192 = toeEnd * 0.009999999776482582f;
  float _194 = blackPoint * 0.009999999776482582f;
  float _199 = exp2(log2(saturate(_188)) * 0.012683313339948654f);
  float _208 = exp2(log2(max(0.0f, (_199 + -0.8359375f)) / (18.8515625f - (_199 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  if (!(_192 == 0.0f)) {
    float _211 = max(_194, 0.0f);
    float _215 = saturate((_208 - _211) / (_192 - _211));
    do {
      if (!(_208 <= _194)) {
        if (!(!(_194 >= 0.0f))) {
          float _226 = -1.0f / (_194 + -1.0f);
          _236 = ((1.0f - _226) + (_226 * _208));
        } else {
          _236 = ((-0.0f - _194) - (_208 * (-1.0f - _194)));
        }
      } else {
        _236 = 0.0f;
      }
      _244 = ((((pow(_236, toeStrength))-_208) * (1.0f - ((_215 * _215) * (3.0f - (_215 * 2.0f))))) + _208);
    } while (false);
  } else {
    _244 = _208;
  }
  if (!((bool)(_14 == _11) && (bool)(_244 > _11))) {
    float _252 = (1.0f - shoulderStartPoint) * _11;
    float _253 = _11 - _252;
    float _254 = exp2(shoulderStrength);
    float _257 = _253 / _254;
    float _258 = _11 - _257;
    float _259 = ((1.0f / _254) * _244) - _11;
    do {
      if (_259 < -0.0f) {
        float _275 = ((((((shoulderAngle + -0.5f) * min(shoulderStrength, 1.0f)) + 0.5f) * 2.0f) * _258) * select((_257 == 0.0f), 1.0f, (_253 / _257))) / _252;
        _286 = (-0.0f - exp2((log2(_252) - (log2(_258) * _275)) + (log2(-0.0f - _259) * _275)));
      } else {
        _286 = -0.0f;
      }
      _291 = select((_244 <= _14), _244, (_286 + _11));
    } while (false);
  } else {
    _291 = _11;
  }
  float _295 = exp2(log2(_291 * 0.009999999776482582f) * 0.1593017578125f);
  float _304 = saturate(exp2(log2(((_295 * 18.8515625f) + 0.8359375f) / ((_295 * 18.6875f) + 1.0f)) * 78.84375f));
  float _311 = min((_188 / _304), (_304 / _188)) * (saturationOnDisplayMapping * 0.000244140625f);
  float _312 = _311 * dot(float3(_160, _173, _186), float3(6610.0f, -13613.0f, 7003.0f));
  float _313 = _311 * dot(float3(_160, _173, _186), float3(17933.0f, -17390.0f, -543.0f));
  float _323 = exp2(log2(saturate(mad(0.11100000143051147f, _313, mad(0.008999999612569809f, _312, _304)))) * 0.012683313339948654f);
  float _331 = exp2(log2(max(0.0f, (_323 + -0.8359375f)) / (18.8515625f - (_323 * 18.6875f))) * 6.277394771575928f);
  float _335 = exp2(log2(saturate(mad(-0.11100000143051147f, _313, mad(-0.008999999612569809f, _312, _304)))) * 0.012683313339948654f);
  float _344 = exp2(log2(max(0.0f, (_335 + -0.8359375f)) / (18.8515625f - (_335 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _348 = exp2(log2(saturate(mad(-0.32100000977516174f, _313, mad(0.5600000023841858f, _312, _304)))) * 0.012683313339948654f);
  float _357 = exp2(log2(max(0.0f, (_348 + -0.8359375f)) / (18.8515625f - (_348 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _360 = mad(0.2070000022649765f, _357, mad(-1.3270000219345093f, _344, (_331 * 207.10000610351562f)));
  float _363 = mad(-0.04500000178813934f, _357, mad(0.6809999942779541f, _344, (_331 * 36.5f)));
  float _366 = mad(1.187999963760376f, _357, mad(-0.05000000074505806f, _344, (_331 * -4.900000095367432f)));
  float _369 = mad((OCIO_XYZToMatrix[0].z), _366, mad((OCIO_XYZToMatrix[0].y), _363, (_360 * (OCIO_XYZToMatrix[0].x))));
  float _372 = mad((OCIO_XYZToMatrix[1].z), _366, mad((OCIO_XYZToMatrix[1].y), _363, (_360 * (OCIO_XYZToMatrix[1].x))));
  float _375 = mad((OCIO_XYZToMatrix[2].z), _366, mad((OCIO_XYZToMatrix[2].y), _363, (_360 * (OCIO_XYZToMatrix[2].x))));

  // _375 = 999.f;

  OutLUT[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4(mad(_375, 0.047374799847602844f, mad(_372, 0.33951008319854736f, (_369 * 0.6131157279014587f))), mad(_375, 0.013449129648506641f, mad(_372, 0.9163550138473511f, (_369 * 0.07019715756177902f))), mad(_375, 0.8698007464408875f, mad(_372, 0.10957999527454376f, (_369 * 0.020619075745344162f))), 1.0f);
}

