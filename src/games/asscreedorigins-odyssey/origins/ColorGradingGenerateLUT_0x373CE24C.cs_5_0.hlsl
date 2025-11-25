#include "../common.hlsli"

static const float _102[11] = { -0.15369999408721923828125f, 0.013500000350177288055419921875f, 0.13120000064373016357421875f, 0.2092899978160858154296875f, 0.2858000099658966064453125f, 0.513000011444091796875f, 0.66879999637603759765625f, 0.745999991893768310546875f, 0.84630000591278076171875f, 1.0134999752044677734375f, 0.0f };

cbuffer cb6_buf : register(b6) {
  float4 cb6_m[4096] : packoffset(c0);
};

SamplerState ColorGradingGenerateLUT_lutSampler_s : register(s13);
Texture3D<float4> ColorGradingGenerateLUT_Aces2OutputLUT : register(t99);
RWTexture3D<float4> ColorGradingGenerateLUT_Output : register(u1);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

float dp3_f32(float3 a, float3 b) {
  precise float _117 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _117));
}

void comp_main() {
  float3 _144 = float3(exp2(mad(float(gl_GlobalInvocationID.x), 0.548387050628662109375f, -8.97393131256103515625f)), exp2(mad(float(gl_GlobalInvocationID.y), 0.548387050628662109375f, -8.97393131256103515625f)), exp2(mad(float(gl_GlobalInvocationID.z), 0.548387050628662109375f, -8.97393131256103515625f)));

  float Exposure = asfloat(cb6_m[1u].w);
  uint UseRec2020 = asuint(cb6_m[0u].x);
  bool hdr_enabled = UseRec2020 != 0u;
  float WhiteScale = asfloat(cb6_m[0u].y);
  float MaxNitsHDRTV = asfloat(cb6_m[0u].z);

  if (RENODX_TONE_MAP_TYPE != 0.f && hdr_enabled) {
    Exposure *= CalculatePaperWhiteExposureCompensation(WhiteScale);
  }

  float3 WhitePointScale = float3(asfloat(cb6_m[1u].x),
                                  asfloat(cb6_m[1u].y),
                                  asfloat(cb6_m[1u].z));
  WhitePointScale = lerp(1.f, WhitePointScale, CUSTOM_COLOR_FILTER_STRENGTH);

  float _161 = (dp3_f32(_144, float3(0.613097012042999267578125f, 0.3395229876041412353515625f, 0.047379501163959503173828125f)) * WhitePointScale.r) * Exposure;
  float _162 = (dp3_f32(_144, float3(0.070193700492382049560546875f, 0.916354000568389892578125f, 0.013452400453388690948486328125f)) * WhitePointScale.g) * Exposure;
  float _163 = (dp3_f32(_144, float3(0.020615600049495697021484375f, 0.1095699965953826904296875f, 0.86981499195098876953125f)) * WhitePointScale.b) * Exposure;
  bool _164 = _162 < _163;
  float _166 = _164 ? _163 : _162;
  float _167 = _164 ? _162 : _163;
  bool _170 = _161 < _166;
  float _171 = _170 ? _166 : _161;
  float _173 = _170 ? _161 : _166;
  float _175 = _171 - min(_167, _173);
  float _181 = ((_173 - _167) / mad(_175, 6.0f, 1.0000000133514319600180897396058e-10f)) + (_170 ? (_164 ? 0.666666686534881591796875f : (-0.3333333432674407958984375f)) : (_164 ? (-1.0f) : 0.0f));

  float Contrast = asfloat(cb6_m[2u].x);
  if (RENODX_TONE_MAP_TYPE != 0.f && hdr_enabled) {
    Contrast *= CalculatePaperWhiteContrastCompensation(WhiteScale);
  }

  float _189 = max(mad(Contrast, mad(log2(dp3_f32(float3(_161, _162, _163), 0.3333333432674407958984375f.xxx)), 0.0588235296308994293212890625f, 0.027878284454345703125f), 0.5f), 0.0f);
  float _190 = _189 - 0.5f;
  float _199 = mad(max(mad(abs(_190 * _190), -4.0f, 1.0f), 0.0f), mad(cb6_m[3u].z, _189, -_189), _189);
  float _201 = clamp(1.0f - _199, 0.0f, 1.0f);
  float _210 = mad(_201 * _201, exp2(cb6_m[3u].w * log2(abs(_199))) - _199, _199);
  float _211 = _210 - 0.85000002384185791015625f;
  float _234 = mad(exp2((_211 * _211) * (-12.49999904632568359375f)) * abs(cb6_m[2u].z), ((cb6_m[2u].z > 0.0f) ? exp2(log2(abs(_210)) * 0.125f) : abs(_210 * (_210 * _210))) - _210, _210);
  float _235 = _234 - 0.100000001490116119384765625f;
  float _242 = _234 * _234;
  float _243 = _242 * _242;
  float _252 = mad(exp2((_235 * _235) * (-49.999996185302734375f)) * abs(cb6_m[2u].w), ((cb6_m[2u].w > 0.0f) ? (1.0f / rsqrt(abs(_234))) : abs(_243 * _243)) - _234, _234);
  float _253 = _252 - 1.0f;
  float _276 = mad(exp2((_253 * _253) * (-19.53125f)) * abs(cb6_m[3u].x), ((cb6_m[3u].x > 0.0f) ? exp2(log2(abs(_252)) * 0.00390625f) : abs((_252 * _252) * _252)) - _252, _252);
  float _281 = log2(abs(_276));
  float _296 = clamp((_175 / (_171 + 1.0000000133514319600180897396058e-10f)) * cb6_m[2u].y, 0.0f, 1.0f);
  float _298;
  float _301;
  float _303;
  float _305;
  _298 = 0.0f;
  _301 = 0.0f;
  _303 = 0.0f;
  _305 = 0.0f;
  float _299;
  float _302;
  float _304;
  float _306;
  uint _308;
  uint _307 = 0u;
  for (;;) {
    if (int(_307) >= 10) {
      break;
    }
    float _322 = _102[min(_307, 10u)] - abs(_181);
    float _325 = exp2((_322 * _322) * (-128.0f));
    uint _326 = _307 + 4u;
    _306 = mad(_325, cb6_m[_326].x, _305);
    _304 = mad(cb6_m[_326].y, _325, _303);
    _302 = mad(_325, cb6_m[_326].z, _301);
    _299 = _325 + _298;
    _308 = _307 + 1u;
    _298 = _299;
    _301 = _302;
    _303 = _304;
    _305 = _306;
    _307 = _308;
    continue;
  }
  float _332 = 1.0f / _298;
  float _333 = sqrt(_296);
  float _342 = frac(mad(_333, mad(_332, _305, -0.0f), 0.0f) + abs(_181));
  float _344 = clamp(_296 * mad(_333, mad(_332, _303, -1.0f), 1.0f), 0.0f, 1.0f);
  float _346 = clamp(mad(exp2((_276 * _276) * (-49.999996185302734375f)) * abs(cb6_m[3u].y), ((cb6_m[3u].y > 0.0f) ? exp2(_281 * 0.60000002384185791015625f) : exp2(_281 * 32.0f)) - _276, _276) * mad(_333, mad(_332, _301, -1.0f), 1.0f), 0.0f, 1.0f);
  float _348 = exp2(mad(_346, 17.0f, -8.97393131256103515625f));
  float _370 = mad(_344, clamp(abs(mad(frac(_342 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
  float _371 = mad(_344, clamp(abs(mad(frac(_342 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
  float _372 = mad(_344, clamp(abs(mad(frac(_342 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
  float _378 = 1.0f / dp3_f32(float3(_370, _371, _372), 0.3333333432674407958984375f.xxx);
  float _379 = (_348 * _370) * _378;
  float _380 = _378 * (_348 * _371);
  float _381 = _378 * (_348 * _372);
  float _399 = clamp(abs(mad(frac(cb6_m[14u].z + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f);
  float _400 = clamp(abs(mad(frac(cb6_m[14u].z + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f);
  float _401 = clamp(abs(mad(frac(cb6_m[14u].z + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f);
  float _424 = clamp(abs(mad(frac(cb6_m[15u].x + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f);
  float _425 = clamp(abs(mad(frac(cb6_m[15u].x + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f);
  float _426 = clamp(abs(mad(frac(cb6_m[15u].x + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f);
  float _432 = 1.0f / dp3_f32(float3(_399, _400, _401), 0.3333333432674407958984375f.xxx);
  float _433 = 1.0f / dp3_f32(float3(_424, _425, _426), 0.3333333432674407958984375f.xxx);
  float _436 = cb6_m[14u].w * 0.75f;
  float _451 = cb6_m[15u].y * 0.75f;
  float _461 = _379 + (_451 * ((_433 * (_348 * _424)) - _379));
  float _462 = (((_433 * (_348 * _425)) - _380) * _451) + _380;
  float _463 = (((_433 * (_348 * _426)) - _381) * _451) + _381;
  float _470 = clamp(mad(cb6_m[14u].y, _346 - cb6_m[14u].x, 0.5f), 0.0f, 1.0f);
  float _473 = (_470 * _470) * mad(_470, -2.0f, 3.0f);
  float3 graded_color;
  graded_color.x = mad(_473, (_379 + (_436 * (((_348 * _399) * _432) - _379))) - _461, _461);
  graded_color.y = mad((((((_348 * _400) * _432) - _380) * _436) + _380) - _462, _473, _462);
  graded_color.z = mad((((((_348 * _401) * _432) - _381) * _436) + _381) - _463, _473, _463);

  float3 log_encoded = mad(log2(graded_color), 0.0588235296308994293212890625f, 0.527878284454345703125f);

  float3 pq_encoded = graded_color;
  if (RENODX_TONE_MAP_TYPE == 0.f || !hdr_enabled) {  // Vanilla
    float3 log_encoded = mad(log2(graded_color), 0.0588235296, 0.527878284);
    pq_encoded = ColorGradingGenerateLUT_Aces2OutputLUT.SampleLevel(ColorGradingGenerateLUT_lutSampler_s, mad(saturate(log_encoded), 0.96875f, 0.015625f), 0.0f).rgb;
  } else {  // ACES/Customized ACES
    pq_encoded = ApplyToneMapEncodePQ(graded_color, RENODX_PEAK_WHITE_NITS, RENODX_DIFFUSE_WHITE_NITS, RENODX_TONE_MAP_TYPE);
  }

  ColorGradingGenerateLUT_Output[gl_GlobalInvocationID] = float4(pq_encoded, 1.f);
}

[numthreads(16, 16, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
