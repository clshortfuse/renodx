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

[numthreads(8, 8, 8)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  float _7 = float((uint)SV_DispatchThreadID.x);
  float _8 = float((uint)SV_DispatchThreadID.y);
  float _9 = float((uint)SV_DispatchThreadID.z);
  float _10 = _7 * 0.01587301678955555f;
  float _11 = _8 * 0.01587301678955555f;
  float _12 = _9 * 0.01587301678955555f;
  float _26;
  float _40;
  float _54;
  float _237;
  if (!(!(_10 <= -0.3013699948787689f))) {
    _26 = (exp2((_7 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_10 < 1.468000054359436f) {
      _26 = exp2((_7 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _26 = 65504.0f;
    }
  }
  if (!(!(_11 <= -0.3013699948787689f))) {
    _40 = (exp2((_8 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_11 < 1.468000054359436f) {
      _40 = exp2((_8 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _40 = 65504.0f;
    }
  }
  if (!(!(_12 <= -0.3013699948787689f))) {
    _54 = (exp2((_9 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_12 < 1.468000054359436f) {
      _54 = exp2((_9 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _54 = 65504.0f;
    }
  }
  float _67 = exp2(log2(saturate(mad(_54, 0.047374799847602844f, mad(_40, 0.33951008319854736f, (_26 * 0.6131157279014587f))))) * 0.012683313339948654f);
  float _75 = exp2(log2(max(0.0f, (_67 + -0.8359375f)) / (18.8515625f - (_67 * 18.6875f))) * 6.277394771575928f);
  float _79 = exp2(log2(saturate(mad(_54, 0.013449129648506641f, mad(_40, 0.9163550138473511f, (_26 * 0.07019715756177902f))))) * 0.012683313339948654f);
  float _88 = exp2(log2(max(0.0f, (_79 + -0.8359375f)) / (18.8515625f - (_79 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _92 = exp2(log2(saturate(mad(_54, 0.8698007464408875f, mad(_40, 0.10957999527454376f, (_26 * 0.020619075745344162f))))) * 0.012683313339948654f);
  float _101 = exp2(log2(max(0.0f, (_92 + -0.8359375f)) / (18.8515625f - (_92 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _114 = exp2(log2(mad(0.06396484375f, _101, mad(0.52392578125f, _88, (_75 * 41.2109375f))) * 0.009999999776482582f) * 0.1593017578125f);
  float _123 = saturate(exp2(log2(((_114 * 18.8515625f) + 0.8359375f) / ((_114 * 18.6875f) + 1.0f)) * 78.84375f));
  float _127 = exp2(log2(mad(0.11279296875f, _101, mad(0.720458984375f, _88, (_75 * 16.6748046875f))) * 0.009999999776482582f) * 0.1593017578125f);
  float _136 = saturate(exp2(log2(((_127 * 18.8515625f) + 0.8359375f) / ((_127 * 18.6875f) + 1.0f)) * 78.84375f));
  float _140 = exp2(log2(mad(0.900390625f, _101, mad(0.075439453125f, _88, (_75 * 2.4169921875f))) * 0.009999999776482582f) * 0.1593017578125f);
  float _149 = saturate(exp2(log2(((_140 * 18.8515625f) + 0.8359375f) / ((_140 * 18.6875f) + 1.0f)) * 78.84375f));
  float _151 = (_136 + _123) * 0.5f;
  float _156 = (pow(0.0f, 0.1593017578125f));
  float _165 = saturate(exp2(log2(((_156 * 18.8515625f) + 0.8359375f) / ((_156 * 18.6875f) + 1.0f)) * 78.84375f));
  float _171 = exp2(log2(displayMaxNits * 9.999999747378752e-05f) * 0.1593017578125f);
  float _185 = exp2(log2(displayMinNits * 9.999999747378752e-05f) * 0.1593017578125f);
  float _196 = 1.0f - _165;
  float _197 = (_151 - _165) / _196;
  float _199 = (saturate(exp2(log2(((_171 * 18.8515625f) + 0.8359375f) / ((_171 * 18.6875f) + 1.0f)) * 78.84375f)) - _165) / _196;
  float _202 = _199 * 1.5f;
  float _203 = _202 + -0.5f;
  if (!((bool)(_197 >= 0.0f) && (bool)(_197 < _203))) {
    if ((bool)(_197 <= 1.0f) && (bool)(_203 <= _197)) {
      float _213 = 1.5f - _202;
      float _215 = (_197 - _203) / max(_213, 9.99999993922529e-09f);
      float _218 = (pow(_215, 3.0f));
      float _219 = _218 * 2.0f;
      float _220 = _215 * _215;
      float _221 = _220 * 3.0f;
      _237 = (((((_215 - (_220 * 2.0f)) + _218) * _213) + (((1.0f - _221) + _219) * _203)) + ((_221 - _219) * _199));
    } else {
      _237 = select((_197 <= 0.0f), 0.0f, _199);
    }
  } else {
    _237 = _197;
  }
  float _245 = (((exp2(log2(1.0f - _237) * 4.0f) * ((saturate(exp2(log2(((_185 * 18.8515625f) + 0.8359375f) / ((_185 * 18.6875f) + 1.0f)) * 78.84375f)) - _165) / _196)) + _237) * _196) + _165;
  float _252 = min((_151 / _245), (_245 / _151)) * (saturationOnDisplayMapping * 0.000244140625f);
  float _253 = _252 * dot(float3(_123, _136, _149), float3(6610.0f, -13613.0f, 7003.0f));
  float _254 = _252 * dot(float3(_123, _136, _149), float3(17933.0f, -17390.0f, -543.0f));
  float _264 = exp2(log2(saturate(mad(0.11100000143051147f, _254, mad(0.008999999612569809f, _253, _245)))) * 0.012683313339948654f);
  float _272 = exp2(log2(max(0.0f, (_264 + -0.8359375f)) / (18.8515625f - (_264 * 18.6875f))) * 6.277394771575928f);
  float _276 = exp2(log2(saturate(mad(-0.11100000143051147f, _254, mad(-0.008999999612569809f, _253, _245)))) * 0.012683313339948654f);
  float _285 = exp2(log2(max(0.0f, (_276 + -0.8359375f)) / (18.8515625f - (_276 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _289 = exp2(log2(saturate(mad(-0.32100000977516174f, _254, mad(0.5600000023841858f, _253, _245)))) * 0.012683313339948654f);
  float _298 = exp2(log2(max(0.0f, (_289 + -0.8359375f)) / (18.8515625f - (_289 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _301 = mad(0.2070000022649765f, _298, mad(-1.3270000219345093f, _285, (_272 * 207.10000610351562f)));
  float _304 = mad(-0.04500000178813934f, _298, mad(0.6809999942779541f, _285, (_272 * 36.5f)));
  float _307 = mad(1.187999963760376f, _298, mad(-0.05000000074505806f, _285, (_272 * -4.900000095367432f)));
  float _320 = exp2(log2(mad(-0.25336629152297974f, _307, mad(-0.3556708097457886f, _304, (_301 * 1.716651201248169f))) * 0.009999999776482582f) * 0.1593017578125f);
  float _333 = exp2(log2(mad(0.015768500044941902f, _307, mad(1.6164811849594116f, _304, (_301 * -0.6666843891143799f))) * 0.009999999776482582f) * 0.1593017578125f);
  float _346 = exp2(log2(mad(0.9421030879020691f, _307, mad(-0.04277060180902481f, _304, (_301 * 0.017639899626374245f))) * 0.009999999776482582f) * 0.1593017578125f);

  // _346 = 0;

  OutLUT[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4(saturate(exp2(log2(((_320 * 18.8515625f) + 0.8359375f) / ((_320 * 18.6875f) + 1.0f)) * 78.84375f)), saturate(exp2(log2(((_333 * 18.8515625f) + 0.8359375f) / ((_333 * 18.6875f) + 1.0f)) * 78.84375f)), saturate(exp2(log2(((_346 * 18.8515625f) + 0.8359375f) / ((_346 * 18.6875f) + 1.0f)) * 78.84375f)), 1.0f);
}

