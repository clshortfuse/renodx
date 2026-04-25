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

SamplerState BilinearClamp : register(s5, space32);

SamplerState TrilinearClamp : register(s9, space32);

[numthreads(8, 8, 8)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  float _11 = float((uint)SV_DispatchThreadID.x);
  float _12 = float((uint)SV_DispatchThreadID.y);
  float _13 = float((uint)SV_DispatchThreadID.z);
  float _14 = _11 * 0.01587301678955555f;
  float _15 = _12 * 0.01587301678955555f;
  float _16 = _13 * 0.01587301678955555f;
  float _30;
  float _44;
  float _58;
  float _81;
  float _110;
  float _137;
  float _309;
  float _310;
  float _311;
  float _312;
  float _313;
  float _392;
  float _393;
  float _394;
  if (!(!(_14 <= -0.3013699948787689f))) {
    _30 = (exp2((_11 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_14 < 1.468000054359436f) {
      _30 = exp2((_11 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _30 = 65504.0f;
    }
  }
  if (!(!(_15 <= -0.3013699948787689f))) {
    _44 = (exp2((_12 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_15 < 1.468000054359436f) {
      _44 = exp2((_12 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _44 = 65504.0f;
    }
  }
  if (!(!(_16 <= -0.3013699948787689f))) {
    _58 = (exp2((_13 * 0.2780952751636505f) + -8.720000267028809f) + -3.0517578125e-05f);
  } else {
    if (_16 < 1.468000054359436f) {
      _58 = exp2((_13 * 0.2780952751636505f) + -9.720000267028809f);
    } else {
      _58 = 65504.0f;
    }
  }

  // AP1 -> AP0
  float _61 = mad(_58, 0.1638689935207367f, mad(_44, 0.1406790018081665f, (_30 * 0.6954519748687744f)));
  float _64 = mad(_58, 0.0955343022942543f, mad(_44, 0.8596709966659546f, (_30 * 0.04479460045695305f)));
  float _67 = mad(_58, 1.0015000104904175f, mad(_44, 0.004025210160762072f, (_30 * -0.00552588002756238f)));
  float _68 = abs(_61);
  if (_68 > 6.103515625e-05f) {
    float _71 = min(_68, 65504.0f);
    float _73 = floor(log2(_71));
    float _74 = exp2(_73);
    _81 = dot(float3(_73, ((_71 - _74) / _74), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _81 = (_68 * 16777216.0f);
  }
  float _84 = _81 + select((_61 < 0.0f), 32768.0f, 0.0f);
  float _86 = floor(_84 * 0.00024420025874860585f);
  float4 _95 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_84 + 0.5f) - (_86 * 4095.0f)) * 0.000244140625f), ((_86 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _97 = abs(_64);
  if (_97 > 6.103515625e-05f) {
    float _100 = min(_97, 65504.0f);
    float _102 = floor(log2(_100));
    float _103 = exp2(_102);
    _110 = dot(float3(_102, ((_100 - _103) / _103), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _110 = (_97 * 16777216.0f);
  }
  float _113 = _110 + select((_64 < 0.0f), 32768.0f, 0.0f);
  float _115 = floor(_113 * 0.00024420025874860585f);
  float4 _122 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_113 + 0.5f) - (_115 * 4095.0f)) * 0.000244140625f), ((_115 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _124 = abs(_67);
  if (_124 > 6.103515625e-05f) {
    float _127 = min(_124, 65504.0f);
    float _129 = floor(log2(_127));
    float _130 = exp2(_129);
    _137 = dot(float3(_129, ((_127 - _130) / _130), 15.0f), float3(1024.0f, 1024.0f, 1024.0f));
  } else {
    _137 = (_124 * 16777216.0f);
  }
  float _140 = _137 + select((_67 < 0.0f), 32768.0f, 0.0f);
  float _142 = floor(_140 * 0.00024420025874860585f);
  float4 _149 = OCIO_lut1d_0.SampleLevel(BilinearClamp, float2((((_140 + 0.5f) - (_142 * 4095.0f)) * 0.000244140625f), ((_142 + 0.5f) * 0.05882352963089943f)), 0.0f);
  float _151 = _95.x * 64.0f;
  float _152 = _122.x * 64.0f;
  float _153 = _149.x * 64.0f;
  float _154 = floor(_151);
  float _155 = floor(_152);
  float _156 = floor(_153);
  float _157 = _151 - _154;
  float _158 = _152 - _155;
  float _159 = _153 - _156;
  float _163 = (_156 + 0.5f) * 0.015384615398943424f;
  float _164 = (_155 + 0.5f) * 0.015384615398943424f;
  float _165 = (_154 + 0.5f) * 0.015384615398943424f;
  float4 _168 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _164, _165), 0.0f);
  float _172 = _163 + 0.015384615398943424f;
  float _173 = _164 + 0.015384615398943424f;
  float _174 = _165 + 0.015384615398943424f;
  float4 _175 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _173, _174), 0.0f);
  if (!(!(_157 >= _158))) {
    if (!(!(_158 >= _159))) {
      float4 _183 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _164, _174), 0.0f);
      float4 _187 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _173, _174), 0.0f);
      float _191 = _157 - _158;
      float _192 = _158 - _159;
      _309 = ((_187.x * _192) + (_183.x * _191));
      _310 = ((_187.y * _192) + (_183.y * _191));
      _311 = ((_187.z * _192) + (_183.z * _191));
      _312 = _157;
      _313 = _159;
    } else {
      if (!(!(_157 >= _159))) {
        float4 _205 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _164, _174), 0.0f);
        float4 _209 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _164, _174), 0.0f);
        float _213 = _157 - _159;
        float _214 = _159 - _158;
        _309 = ((_209.x * _214) + (_205.x * _213));
        _310 = ((_209.y * _214) + (_205.y * _213));
        _311 = ((_209.z * _214) + (_205.z * _213));
        _312 = _157;
        _313 = _158;
      } else {
        float4 _225 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _164, _165), 0.0f);
        float4 _229 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _164, _174), 0.0f);
        float _233 = _159 - _157;
        float _234 = _157 - _158;
        _309 = ((_229.x * _234) + (_225.x * _233));
        _310 = ((_229.y * _234) + (_225.y * _233));
        _311 = ((_229.z * _234) + (_225.z * _233));
        _312 = _159;
        _313 = _158;
      }
    }
  } else {
    if (!(!(_158 <= _159))) {
      float4 _247 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _164, _165), 0.0f);
      float4 _251 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _173, _165), 0.0f);
      float _255 = _159 - _158;
      float _256 = _158 - _157;
      _309 = ((_251.x * _256) + (_247.x * _255));
      _310 = ((_251.y * _256) + (_247.y * _255));
      _311 = ((_251.z * _256) + (_247.z * _255));
      _312 = _159;
      _313 = _157;
    } else {
      if (!(!(_157 >= _159))) {
        float4 _269 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _173, _165), 0.0f);
        float4 _273 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _173, _174), 0.0f);
        float _277 = _158 - _157;
        float _278 = _157 - _159;
        _309 = ((_273.x * _278) + (_269.x * _277));
        _310 = ((_273.y * _278) + (_269.y * _277));
        _311 = ((_273.z * _278) + (_269.z * _277));
        _312 = _158;
        _313 = _159;
      } else {
        float4 _289 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_163, _173, _165), 0.0f);
        float4 _293 = OCIO_lut3d_1.SampleLevel(TrilinearClamp, float3(_172, _173, _165), 0.0f);
        float _297 = _158 - _159;
        float _298 = _159 - _157;
        _309 = ((_293.x * _298) + (_289.x * _297));
        _310 = ((_293.y * _298) + (_289.y * _297));
        _311 = ((_293.z * _298) + (_289.z * _297));
        _312 = _158;
        _313 = _157;
      }
    }
  }
  float _314 = 1.0f - _312;
  float _324 = ((_314 * _168.x) + _309) + (_313 * _175.x);
  float _325 = ((_314 * _168.y) + _310) + (_313 * _175.y);
  float _326 = ((_314 * _168.z) + _311) + (_313 * _175.z);
  if (!((drawMode & 2) == 0)) {
    float _338 = exp2(log2(saturate(displayMaxNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _347 = saturate(exp2(log2(((_338 * 18.8515625f) + 0.8359375f) / ((_338 * 18.6875f) + 1.0f)) * 78.84375f));
    float _353 = exp2(log2(saturate(displayMinNits * 9.999999747378752e-05f)) * 0.1593017578125f);
    float _363 = _347 - saturate(exp2(log2(((_353 * 18.8515625f) + 0.8359375f) / ((_353 * 18.6875f) + 1.0f)) * 78.84375f));
    float _367 = saturate(_324 / _347);
    float _368 = saturate(_325 / _347);
    float _369 = saturate(_326 / _347);
    _392 = min((((((_367 * -2.0f) + 2.0f) * _363) + (_367 * _347)) * _367), _324);
    _393 = min((((((_368 * -2.0f) + 2.0f) * _363) + (_368 * _347)) * _368), _325);
    _394 = min((((((_369 * -2.0f) + 2.0f) * _363) + (_369 * _347)) * _369), _326);
  } else {
    _392 = _324;
    _393 = _325;
    _394 = _326;
  }

  // _394 = 99999.f;

  OutLUT[int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), (uint)(SV_DispatchThreadID.z))] = float4(_392, _393, _394, 1.0f);
}

