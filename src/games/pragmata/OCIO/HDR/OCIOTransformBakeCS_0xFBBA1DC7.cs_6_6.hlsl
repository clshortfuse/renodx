#include "../CBuffers/HDRMapping.hlsli"
#include "../OCIO.hlsli"

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
  float _500;
#if 0
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
#else
  if (RENODX_LUT_SHAPER == 0.f) {
    _30 = renodx::color::acescc::Decode(_14);
    _44 = renodx::color::acescc::Decode(_15);
    _58 = renodx::color::acescc::Decode(_16);
  } else {
    _30 = renodx::color::pq::Decode(_14, 100.f);
    _44 = renodx::color::pq::Decode(_15, 100.f);
    _58 = renodx::color::pq::Decode(_16, 100.f);
  }
#endif

  // AP1 -> AP0
  float _61 = mad(_58, 0.1638689935207367f, mad(_44, 0.1406790018081665f, (_30 * 0.6954519748687744f)));
  float _64 = mad(_58, 0.0955343022942543f, mad(_44, 0.8596709966659546f, (_30 * 0.04479460045695305f)));
  float _67 = mad(_58, 1.0015000104904175f, mad(_44, 0.004025210160762072f, (_30 * -0.00552588002756238f)));

  // lut sample START
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
  float3 lut_output = float3((((_314 * _168.x) + _309) + (_313 * _175.x)),
                             (((_314 * _168.y) + _310) + (_313 * _175.y)),
                             (((_314 * _168.z) + _311) + (_313 * _175.z)));
  // lut sample end

  if (TONE_MAP_TYPE != 0.f) {
    lut_output = renodx::color::pq::Decode(lut_output, 100.f);

    if (true) {  // scale peak when lut is clamped
      float3 lut_peak_output = renodx::color::pq::Decode(
          min(1.f, SampleOCIO(renodx::math::FLT16_MAX, renodx::math::FLT16_MAX, renodx::math::FLT16_MAX,
                              OCIO_lut1d_0, BilinearClamp, OCIO_lut3d_1, TrilinearClamp)),
          100.f);
      float lut_peak = renodx::color::y::from::BT2020(lut_peak_output);

      float3 lut_input = renodx::color::bt2020::from::AP1(float3(_30, _44, _58));
      float3 lut_input_tonemapped = renodx::tonemap::neutwo::MaxChannel(lut_input, lut_peak);
      float3 lut_output_scaled = UpgradeToneMapMaxChannel(lut_input, lut_input_tonemapped, lut_output, 1.f);

      lut_output = lut_output_scaled;
    }

    if (RENODX_GAMMA_CORRECTION) {
      lut_output = renodx::color::bt709::from::BT2020(lut_output);
      lut_output = renodx::color::correct::GammaSafe(lut_output);
      lut_output = renodx::color::bt2020::from::BT709(lut_output);
    }
    lut_output = renodx::tonemap::neutwo::MaxChannel(lut_output, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
    lut_output = renodx::color::pq::Encode(lut_output, RENODX_DIFFUSE_WHITE_NITS);
    OutLUT[SV_DispatchThreadID] = float4(lut_output, 1.f);
    return;
  }

  float _330 = exp2(log2(saturate(((_314 * _168.x) + _309) + (_313 * _175.x))) * 0.012683313339948654f);
  float _338 = exp2(log2(max(0.0f, (_330 + -0.8359375f)) / (18.8515625f - (_330 * 18.6875f))) * 6.277394771575928f);
  float _342 = exp2(log2(saturate(((_314 * _168.y) + _310) + (_313 * _175.y))) * 0.012683313339948654f);
  float _351 = exp2(log2(max(0.0f, (_342 + -0.8359375f)) / (18.8515625f - (_342 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _355 = exp2(log2(saturate(((_314 * _168.z) + _311) + (_313 * _175.z))) * 0.012683313339948654f);
  float _364 = exp2(log2(max(0.0f, (_355 + -0.8359375f)) / (18.8515625f - (_355 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _377 = exp2(log2(mad(0.06396484375f, _364, mad(0.52392578125f, _351, (_338 * 41.2109375f))) * 0.009999999776482582f) * 0.1593017578125f);
  float _386 = saturate(exp2(log2(((_377 * 18.8515625f) + 0.8359375f) / ((_377 * 18.6875f) + 1.0f)) * 78.84375f));
  float _390 = exp2(log2(mad(0.11279296875f, _364, mad(0.720458984375f, _351, (_338 * 16.6748046875f))) * 0.009999999776482582f) * 0.1593017578125f);
  float _399 = saturate(exp2(log2(((_390 * 18.8515625f) + 0.8359375f) / ((_390 * 18.6875f) + 1.0f)) * 78.84375f));
  float _403 = exp2(log2(mad(0.900390625f, _364, mad(0.075439453125f, _351, (_338 * 2.4169921875f))) * 0.009999999776482582f) * 0.1593017578125f);
  float _412 = saturate(exp2(log2(((_403 * 18.8515625f) + 0.8359375f) / ((_403 * 18.6875f) + 1.0f)) * 78.84375f));
  float _414 = (_399 + _386) * 0.5f;
  float _419 = (pow(0.0f, 0.1593017578125f));
  float _428 = saturate(exp2(log2(((_419 * 18.8515625f) + 0.8359375f) / ((_419 * 18.6875f) + 1.0f)) * 78.84375f));
  float _434 = exp2(log2(displayMaxNits * 9.999999747378752e-05f) * 0.1593017578125f);
  float _448 = exp2(log2(displayMinNits * 9.999999747378752e-05f) * 0.1593017578125f);
  float _459 = 1.0f - _428;
  float _460 = (_414 - _428) / _459;
  float _462 = (saturate(exp2(log2(((_434 * 18.8515625f) + 0.8359375f) / ((_434 * 18.6875f) + 1.0f)) * 78.84375f)) - _428) / _459;
  float _465 = _462 * 1.5f;
  float _466 = _465 + -0.5f;
  if (!((bool)(_460 >= 0.0f) && (bool)(_460 < _466))) {
    if ((bool)(_460 <= 1.0f) && (bool)(_466 <= _460)) {
      float _476 = 1.5f - _465;
      float _478 = (_460 - _466) / max(_476, 9.99999993922529e-09f);
      float _481 = (pow(_478, 3.0f));
      float _482 = _481 * 2.0f;
      float _483 = _478 * _478;
      float _484 = _483 * 3.0f;
      _500 = (((((_478 - (_483 * 2.0f)) + _481) * _476) + (((1.0f - _484) + _482) * _466)) + ((_484 - _482) * _462));
    } else {
      _500 = select((_460 <= 0.0f), 0.0f, _462);
    }
  } else {
    _500 = _460;
  }
  float _508 = (((exp2(log2(1.0f - _500) * 4.0f) * ((saturate(exp2(log2(((_448 * 18.8515625f) + 0.8359375f) / ((_448 * 18.6875f) + 1.0f)) * 78.84375f)) - _428) / _459)) + _500) * _459) + _428;
  float _515 = min((_414 / _508), (_508 / _414)) * (saturationOnDisplayMapping * 0.000244140625f);
  float _516 = _515 * dot(float3(_386, _399, _412), float3(6610.0f, -13613.0f, 7003.0f));
  float _517 = _515 * dot(float3(_386, _399, _412), float3(17933.0f, -17390.0f, -543.0f));
  float _527 = exp2(log2(saturate(mad(0.11100000143051147f, _517, mad(0.008999999612569809f, _516, _508)))) * 0.012683313339948654f);
  float _535 = exp2(log2(max(0.0f, (_527 + -0.8359375f)) / (18.8515625f - (_527 * 18.6875f))) * 6.277394771575928f);
  float _539 = exp2(log2(saturate(mad(-0.11100000143051147f, _517, mad(-0.008999999612569809f, _516, _508)))) * 0.012683313339948654f);
  float _548 = exp2(log2(max(0.0f, (_539 + -0.8359375f)) / (18.8515625f - (_539 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _552 = exp2(log2(saturate(mad(-0.32100000977516174f, _517, mad(0.5600000023841858f, _516, _508)))) * 0.012683313339948654f);
  float _561 = exp2(log2(max(0.0f, (_552 + -0.8359375f)) / (18.8515625f - (_552 * 18.6875f))) * 6.277394771575928f) * 100.0f;
  float _564 = mad(0.2070000022649765f, _561, mad(-1.3270000219345093f, _548, (_535 * 207.10000610351562f)));
  float _567 = mad(-0.04500000178813934f, _561, mad(0.6809999942779541f, _548, (_535 * 36.5f)));
  float _570 = mad(1.187999963760376f, _561, mad(-0.05000000074505806f, _548, (_535 * -4.900000095367432f)));
  float _583 = mad(-0.25336629152297974f, _570, mad(-0.3556708097457886f, _567, (_564 * 1.716651201248169f)));
  float _596 = mad(0.015768500044941902f, _570, mad(1.6164811849594116f, _567, (_564 * -0.6666843891143799f)));
  float _609 = mad(0.9421030879020691f, _570, mad(-0.04277060180902481f, _567, (_564 * 0.017639899626374245f)));

  float3 output = renodx::color::pq::EncodeSafe(float3(_583, _596, _609), 100.f);

  OutLUT[SV_DispatchThreadID] = float4(output, 1.f);
}

