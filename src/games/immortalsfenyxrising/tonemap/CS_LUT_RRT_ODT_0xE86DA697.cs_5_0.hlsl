#include "./tonemap.hlsli"

cbuffer cb6_buf : register(b6) {
  float4 cb6_m0 : packoffset(c0);
  float4 cb6_m1 : packoffset(c1);
  float4 cb6_m2 : packoffset(c2);
  uint2 cb6_m3 : packoffset(c3);
  float2 cb6_m4 : packoffset(c3.z);
};

RWTexture3D<float4> u4 : register(u4);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

float dp3_f32(float3 a, float3 b) {
  precise float _93 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _93));
}

void comp_main() {
  bool hdr_enabled = cb6_m3.x != 0u;
  float exposure = cb6_m4.x;
  float peak_nits = cb6_m4.y;
  float tone_map_contrast = cb6_m0.x;       // HDR = 1.30f, SDR = 1.00f
  float tone_map_toe_threshold = cb6_m0.y;  // HDR = 0.50f, SDR = 0.00f
  float tone_map_mid_point = cb6_m0.z;      // HDR = 0.60f, SDR = 0.50f
  float tone_map_toe_slope = cb6_m0.w;      // HDR = 1.05f, SDR = 1.00f
  float tone_map_black_offset = cb6_m1.x;   // HDR = 0.00f, SDR = 1.00f

  float diffuse_white_nits = (exposure / 128.f) * 203.f;
  float target_peak_ratio = peak_nits / diffuse_white_nits;
#if RENODX_GAME_GAMMA_CORRECTION
  target_peak_ratio = renodx::color::correct::GammaSafe(target_peak_ratio, true);
#endif
  float peak_value = (RENODX_TONE_MAP_TYPE != 0.f)
                          ? target_peak_ratio * 100.f
                          : peak_nits;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    exposure = 32.f;  // SDR exposure value, equal to 1.0 after lut decoding
    tone_map_contrast = 1.00f;
    tone_map_toe_threshold = 0.00f;
    tone_map_mid_point = 0.50f;
    tone_map_toe_slope = 1.00f;
    tone_map_black_offset = 1.00f;
    if (!hdr_enabled) {
      peak_nits = diffuse_white_nits;
    }
  }

  float _124 = exp2(mad(float(gl_GlobalInvocationID.x), 0.67741930484771728515625f, -12.97393131256103515625f)) * exposure;
  float _125 = exp2(mad(float(gl_GlobalInvocationID.y), 0.67741930484771728515625f, -12.97393131256103515625f)) * exposure;
  float _126 = exp2(mad(float(gl_GlobalInvocationID.z), 0.67741930484771728515625f, -12.97393131256103515625f)) * exposure;

  float3 untonemapped_ap1 = float3(_124, _125, _126);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    ImmortalsToneMapConfig config = CreateImmortalsToneMapConfig(
        tone_map_contrast, tone_map_toe_threshold, tone_map_mid_point, tone_map_toe_slope, tone_map_black_offset, peak_value);
    float3 tonemapped_ap1 = ApplyImmortalsToneMap(untonemapped_ap1, config) / 100.f;
    float3 tonemapped_bt709 = renodx::color::bt709::from::AP1(tonemapped_ap1);
#if RENODX_GAME_GAMMA_CORRECTION
    tonemapped_bt709 = max(0, tonemapped_bt709);
    tonemapped_bt709 = renodx::color::correct::GammaSafe(tonemapped_bt709);
#endif
    if (hdr_enabled) {
      u4[gl_GlobalInvocationID] = float4(renodx::color::pq::EncodeSafe(renodx::color::bt2020::from::BT709(tonemapped_bt709), diffuse_white_nits), 1.f);
    } else {
      u4[gl_GlobalInvocationID] = float4(renodx::color::srgb::EncodeSafe(tonemapped_bt709), 1.f);
    }
    return;
  }

  float _472;
  float _473;
  float _474;
  switch (cb6_m3.y) {
    case 2u: {
      float _143 = peak_nits * 0.00999999977648258209228515625f;
      float _147 = mad(peak_nits, 0.00999999977648258209228515625f, -cb6_m0.y);
      float _154 = abs(_124 * 0.00999999977648258209228515625f);
      float _155 = abs(_125 * 0.00999999977648258209228515625f);
      float _156 = abs(_126 * 0.00999999977648258209228515625f);
      bool _163 = cb6_m0.y > 9.9999997473787516355514526367188e-06f;
      float _165 = _154 / cb6_m0.y;
      float _166 = _155 / cb6_m0.y;
      float _167 = _156 / cb6_m0.y;
      float _190 = ((_147 * cb6_m0.z) / cb6_m0.x) + cb6_m0.y;
      float _194 = mad(peak_nits, 0.00999999977648258209228515625f, -mad(_147, cb6_m0.z, cb6_m0.y));
      float _195 = (_143 * cb6_m0.x) / _194;
      float _217 = clamp(_165, 0.0f, 1.0f);
      float _218 = clamp(_166, 0.0f, 1.0f);
      float _219 = clamp(_167, 0.0f, 1.0f);
      float _220 = _217 * _217;
      float _221 = _218 * _218;
      float _222 = _219 * _219;
      float _223 = mad(_217, -2.0f, 3.0f);
      float _224 = mad(_218, -2.0f, 3.0f);
      float _225 = mad(_219, -2.0f, 3.0f);
      bool _232 = _154 > _190;
      bool _233 = _155 > _190;
      bool _234 = _156 > _190;
      _472 = mad(float(_234), mad(peak_nits, 0.00999999977648258209228515625f, -(_194 / (((_195 * (_156 - _190)) / _143) + 1.0f))), (mad(-_225, _222, 1.0f) * (_163 ? mad(cb6_m0.y, exp2(cb6_m0.w * log2(abs(_167))), cb6_m1.x) : cb6_m1.x)) + (((_234 ? (-1.0f) : (-0.0f)) + (mad(_225, _222, -1.0f) + 1.0f)) * mad(cb6_m0.x, _156 - cb6_m0.y, cb6_m0.y))) * 100.0f;
      _473 = mad(float(_233), mad(peak_nits, 0.00999999977648258209228515625f, -(_194 / (((_195 * (_155 - _190)) / _143) + 1.0f))), (mad(-_224, _221, 1.0f) * (_163 ? mad(cb6_m0.y, exp2(cb6_m0.w * log2(abs(_166))), cb6_m1.x) : cb6_m1.x)) + (((_233 ? (-1.0f) : (-0.0f)) + (mad(_224, _221, -1.0f) + 1.0f)) * mad(_155 - cb6_m0.y, cb6_m0.x, cb6_m0.y))) * 100.0f;
      _474 = mad(mad(peak_nits, 0.00999999977648258209228515625f, -(_194 / (((_195 * (_154 - _190)) / _143) + 1.0f))), float(_232), (mad(_154 - cb6_m0.y, cb6_m0.x, cb6_m0.y) * ((mad(_220, _223, -1.0f) + 1.0f) + (_232 ? (-1.0f) : (-0.0f)))) + (mad(-_220, _223, 1.0f) * (_163 ? mad(exp2(log2(abs(_165)) * cb6_m0.w), cb6_m0.y, cb6_m1.x) : cb6_m1.x))) * 100.0f;
      break;
    }
    case 3u: {
      float _267 = abs(peak_nits);
      float _274 = log2(abs(cb6_m2.x));
      float _281 = cb6_m2.z * cb6_m2.w;
      float _283 = exp2(_274 * _281);
      float _284 = log2(_267);
      float _286 = exp2(_284 * cb6_m2.z);
      float _288 = exp2(_281 * _284);
      float _292 = (_288 - _283) * cb6_m2.y;
      float _295 = mad(_286, cb6_m2.y, -exp2(_274 * cb6_m2.z)) / _292;
      float _300 = ((_283 * _288) - ((_283 * _286) * cb6_m2.y)) / _292;
      float _307 = log2(abs(_124 / _267)) * cb6_m2.z;
      float _308 = log2(abs(_125 / _267)) * cb6_m2.z;
      float _309 = log2(abs(_126 / _267)) * cb6_m2.z;
      _472 = (exp2(_309) / mad(_295, exp2(_309 * cb6_m2.w), _300)) * peak_nits;
      _473 = (exp2(_308) / mad(_295, exp2(_308 * cb6_m2.w), _300)) * peak_nits;
      _474 = (exp2(_307) / mad(_295, exp2(_307 * cb6_m2.w), _300)) * peak_nits;
      break;
    }
    case 4u: {
      _472 = _126 / ((_126 / peak_nits) + 1.0f);
      _473 = _125 / ((_125 / peak_nits) + 1.0f);
      _474 = _124 / ((_124 / peak_nits) + 1.0f);
      break;
    }
    case 5u: {
      _472 = _126;
      _473 = _125;
      _474 = _124;
      break;
    }
    case 6u: {
      _472 = min(_126, peak_nits);
      _473 = min(_125, peak_nits);
      _474 = min(_124, peak_nits);
      break;
    }
    case 1u: {
      ImmortalsToneMapConfig config = CreateImmortalsToneMapConfig(tone_map_contrast, tone_map_toe_threshold, tone_map_mid_point, tone_map_toe_slope, tone_map_black_offset, peak_nits);
      float3 tonemapped_ap1 = ApplyImmortalsToneMap(float3(_124, _125, _126), config);
      _472 = tonemapped_ap1.z, _473 = tonemapped_ap1.y, _474 = tonemapped_ap1.x;
      break;
    }
    default: {
      _472 = 0.0f;
      _473 = 0.0f;
      _474 = 0.0f;
      break;
    }
  }
  float _551;
  float _552;
  float _553;
  if (cb6_m3.x != 0u) {
    float3 _481 = float3(_474, _473, _472);
    float _489 = exp2(log2(abs(dp3_f32(_481, float3(1.02582466602325439453125f, -0.020053170621395111083984375f, -0.0057715452276170253753662109375f)) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
    float _500 = exp2(log2(abs(dp3_f32(_481, float3(-0.00223436788655817508697509765625f, 1.00458621978759765625f, -0.00235217227600514888763427734375f)) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
    float _511 = exp2(log2(abs(dp3_f32(_481, float3(-0.005013366229832172393798828125f, -0.0252900607883930206298828125f, 1.030303478240966796875f)) * 9.9999997473787516355514526367188e-05f)) * 0.1593017578125f);
    _551 = exp2(log2(mad(_511, 18.8515625f, 0.8359375f) / mad(_511, 18.6875f, 1.0f)) * 78.84375f);
    _552 = exp2(log2(mad(_500, 18.8515625f, 0.8359375f) / mad(_500, 18.6875f, 1.0f)) * 78.84375f);
    _553 = exp2(log2(mad(_489, 18.8515625f, 0.8359375f) / mad(_489, 18.6875f, 1.0f)) * 78.84375f);
  } else {
    float3 _518 = float3(_474, _473, _472);
    float _527 = clamp(dp3_f32(_518, float3(1.70505106449127197265625f, -0.621791899204254150390625f, -0.083258844912052154541015625f)) / peak_nits, 0.0f, 1.0f);
    float _528 = clamp(dp3_f32(_518, float3(-0.1302564442157745361328125f, 1.14080417156219482421875f, -0.01054835133254528045654296875f)) / peak_nits, 0.0f, 1.0f);
    float _529 = clamp(dp3_f32(_518, float3(-0.024003379046916961669921875f, -0.12896890938282012939453125f, 1.15297257900238037109375f)) / peak_nits, 0.0f, 1.0f);
    _551 = (_529 <= 0.003130800090730190277099609375f) ? (_529 * 12.9200000762939453125f) : mad(exp2(log2(_529) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _552 = (_528 <= 0.003130800090730190277099609375f) ? (_528 * 12.9200000762939453125f) : mad(exp2(log2(_528) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
    _553 = (_527 <= 0.003130800090730190277099609375f) ? (_527 * 12.9200000762939453125f) : mad(exp2(log2(_527) * 0.4166666567325592041015625f), 1.05499994754791259765625f, -0.054999999701976776123046875f);
  }
  u4[uint3(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y, gl_GlobalInvocationID.z)] = float4(_553, _552, _551, 1.0f);
}

[numthreads(16, 16, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
