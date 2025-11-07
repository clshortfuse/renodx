#include "../common.hlsli"

static const float _147[11] = { -0.15369999408721923828125f, 0.013500000350177288055419921875f, 0.13120000064373016357421875f, 0.2092899978160858154296875f, 0.2858000099658966064453125f, 0.513000011444091796875f, 0.66879999637603759765625f, 0.745999991893768310546875f, 0.84630000591278076171875f, 1.0134999752044677734375f, 0.0f };

cbuffer cb7_buf : register(b7) {
  uint4 cb7_m[4096] : packoffset(c0);
};

SamplerState s0 : register(s0);
SamplerState s13 : register(s13);
Texture2D<float4> t100 : register(t100);
Texture3D<float4> t101 : register(t101);
RWTexture3D<float4> ColorGradingGenerateLUT_Output : register(u1);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

float dp3_f32(float3 a, float3 b) {
  precise float _175 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _175));
}

float dp2_f32(float2 a, float2 b) {
  precise float _163 = a.x * b.x;
  return mad(a.y, b.y, _163);
}

void comp_main() {
  float _198 = exp2(mad(float(gl_GlobalInvocationID.x), 0.67741930484771728515625f, -12.97393131256103515625f));
  float _199 = exp2(mad(float(gl_GlobalInvocationID.y), 0.67741930484771728515625f, -12.97393131256103515625f));
  float _200 = exp2(mad(float(gl_GlobalInvocationID.z), 0.67741930484771728515625f, -12.97393131256103515625f));
  float _302;
  float _303;
  float _304;
  if (cb7_m[0u].w != 0u) {
    float4 _213 = t100.SampleLevel(s0, 0.0f.xx, 0.0f);
    float _215 = _213.x;
    float _217 = (_215 > 0.0f) ? _215 : 9.9999999392252902907785028219223e-09f;
    float _218 = _198 / _217;
    float _219 = _199 / _217;
    float _220 = _200 / _217;
    float3 _221 = float3(_218, _219, _220);
    float _222 = dp3_f32(_221, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _224 = log2(_222 * 5464.0f);
    float _227 = asfloat(cb7_m[2u].y);
    float _296;
    float _297;
    float _298;
    if (_224 < _227) {
      float _233 = asfloat(cb7_m[2u].x);
      float _237 = (_224 - _233) / (_227 - _233);
      float _238 = _237 * _237;
      float _244 = (_224 > _233) ? mad(_238, 3.0f, -dp2_f32(_238.xx, _237.xx)) : 0.0f;
      bool _245 = _244 < 1.0f;
      float _246 = 1.0f - _244;
      float _249 = dp3_f32(float3(0.41245639324188232421875f, 0.3575761020183563232421875f, 0.180437505245208740234375f), _221);
      float _250 = dp3_f32(float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f), _221);
      float _253 = dp3_f32(float3(0.01933390088379383087158203125f, 0.119191996753215789794921875f, 0.950304090976715087890625f), _221) + (_249 + _250);
      float _254 = _249 / _253;
      float _255 = _250 / _253;
      float _263 = asfloat(cb7_m[1u].x) - _254;
      float _264 = asfloat(cb7_m[1u].y) - _255;
      float2 _265 = float2(_263, _264);
      float _266 = dp2_f32(_265, _265);
      float _267 = rsqrt(_266);
      float _274 = min(sqrt(_266), asfloat(cb7_m[1u].z));
      float _277 = mad(_246 * (_263 * _267), _274, _254);
      float _281 = (_222 * _244) + (_246 * dp2_f32(float2(_219, _220), float2(0.845099985599517822265625f, 0.14589999616146087646484375f)));
      float _282 = max(mad(_274, _246 * (_264 * _267), _255), 0.001000000047497451305389404296875f);
      float3 _289 = float3((_277 * _281) / _282, _281, (_281 * ((1.0f - _277) - _282)) / _282);
      _296 = _245 ? dp3_f32(float3(0.0556433983147144317626953125f, -0.2040258944034576416015625f, 1.05722522735595703125f), _289) : _220;
      _297 = _245 ? dp3_f32(float3(-0.969265997409820556640625f, 1.87601077556610107421875f, 0.04155600070953369140625f), _289) : _219;
      _298 = _245 ? dp3_f32(float3(3.240454196929931640625f, -1.537138462066650390625f, -0.498531401157379150390625f), _289) : _218;
    } else {
      _296 = _220;
      _297 = _219;
      _298 = _218;
    }
    _302 = _296 * _217;
    _303 = _297 * _217;
    _304 = _298 * _217;
  } else {
    _302 = _200;
    _303 = _199;
    _304 = _198;
  }
  float3 _305 = float3(_304, _303, _302);
  uint UseRec2020 = cb7_m[0u].x;
  bool hdr_enabled = UseRec2020 != 0u;
  float WhiteScale = asfloat(cb7_m[0u].y);
  float MaxNitsHDRTV = asfloat(cb7_m[0u].z);

  float Exposure = asfloat(cb7_m[3u].w);
  if (RENODX_TONE_MAP_TYPE != 0.f && hdr_enabled) {
    Exposure *= CalculatePaperWhiteExposureCompensation(WhiteScale);
  }

  float3 WhitePointScale = float3(asfloat(cb7_m[3u].x),
                                  asfloat(cb7_m[3u].y),
                                  asfloat(cb7_m[3u].z));
  WhitePointScale = lerp(1.f, WhitePointScale, CUSTOM_COLOR_FILTER_STRENGTH);

  float _323 = Exposure * (dp3_f32(_305, float3(0.613097012042999267578125f, 0.3395229876041412353515625f, 0.047379501163959503173828125f)) * WhitePointScale.x);
  float _324 = Exposure * (dp3_f32(_305, float3(0.070193700492382049560546875f, 0.916354000568389892578125f, 0.013452400453388690948486328125f)) * WhitePointScale.y);
  float _325 = Exposure * (dp3_f32(_305, float3(0.020615600049495697021484375f, 0.1095699965953826904296875f, 0.86981499195098876953125f)) * WhitePointScale.z);

  bool _326 = _325 > _324;
  float _327 = _326 ? _325 : _324;
  float _328 = _326 ? _324 : _325;
  bool _331 = _323 < _327;
  float _332 = _331 ? _327 : _323;
  float _334 = _331 ? _323 : _327;
  float _336 = _332 - min(_328, _334);
  float _342 = ((_334 - _328) / mad(_336, 6.0f, 1.0000000133514319600180897396058e-10f)) + (_331 ? (_326 ? 0.666666686534881591796875f : (-0.3333333432674407958984375f)) : (_326 ? (-1.0f) : 0.0f));

  float Contrast = asfloat(cb7_m[4u].x);
  if (RENODX_TONE_MAP_TYPE != 0.f && hdr_enabled) {
    Contrast *= CalculatePaperWhiteContrastCompensation(WhiteScale);
  }

  float _351 = max(mad(mad(log2(dp3_f32(float3(_323, _324, _325), 0.3333333432674407958984375f.xxx)), 0.0476190485060214996337890625f, 0.117806255817413330078125f), Contrast, 0.5f), 0.0f);
  float _352 = _351 - 0.5f;
  float _362 = mad(max(mad(abs(_352 * _352), -4.0f, 1.0f), 0.0f), mad(_351, asfloat(cb7_m[5u].z), -_351), _351);
  float _364 = clamp(1.0f - _362, 0.0f, 1.0f);
  float _374 = mad(_364 * _364, exp2(log2(abs(_362)) * asfloat(cb7_m[5u].w)) - _362, _362);
  float _375 = _374 - 0.85000002384185791015625f;
  float _401 = mad(exp2((_375 * _375) * (-12.49999904632568359375f)) * abs(asfloat(cb7_m[4u].z)), ((asfloat(cb7_m[4u].z) > 0.0f) ? exp2(log2(abs(_374)) * 0.125f) : abs(_374 * (_374 * _374))) - _374, _374);
  float _402 = _401 - 0.2249999940395355224609375f;
  float _409 = _401 * _401;
  float _410 = _409 * _409;
  float _420 = mad(exp2((_402 * _402) * (-49.999996185302734375f)) * abs(asfloat(cb7_m[4u].w)), ((asfloat(cb7_m[4u].w) > 0.0f) ? (1.0f / rsqrt(abs(_401))) : abs(_410 * _410)) - _401, _401);
  float _421 = _420 - 1.0f;
  float _447 = mad(exp2((_421 * _421) * (-19.53125f)) * abs(asfloat(cb7_m[5u].x)), ((asfloat(cb7_m[5u].x) > 0.0f) ? exp2(log2(abs(_420)) * 0.00390625f) : abs((_420 * _420) * _420)) - _420, _420);
  float _448 = _447 - 0.185000002384185791015625f;
  float _453 = log2(abs(_447));
  float _470 = clamp((_336 / (_332 + 1.0000000133514319600180897396058e-10f)) * asfloat(cb7_m[4u].y), 0.0f, 1.0f);
  float _472;
  float _475;
  float _477;
  float _479;
  _472 = 0.0f;
  _475 = 0.0f;
  _477 = 0.0f;
  _479 = 0.0f;
  float _473;
  float _476;
  float _478;
  float _480;
  uint _482;
  uint _481 = 0u;
  for (;;) {
    if (int(_481) >= 10) {
      break;
    }
    float _496 = _147[min(_481, 10u)] - abs(_342);
    float _499 = exp2((_496 * _496) * (-128.0f));
    uint _500 = _481 + 6u;
    _480 = mad(_499, asfloat(cb7_m[_500].x), _479);
    _478 = mad(_499, asfloat(cb7_m[_500].y), _477);
    _476 = mad(_499, asfloat(cb7_m[_500].z), _475);
    _473 = _499 + _472;
    _482 = _481 + 1u;
    _472 = _473;
    _475 = _476;
    _477 = _478;
    _479 = _480;
    _481 = _482;
    continue;
  }
  float _509 = 1.0f / _472;
  float _510 = sqrt(_470);
  float _519 = frac(mad(_510, mad(_509, _479, -0.0f), 0.0f) + abs(_342));
  float _521 = clamp(_470 * mad(_510, mad(_509, _477, -1.0f), 1.0f), 0.0f, 1.0f);
  float _523 = clamp(mad(exp2((_448 * _448) * (-49.999996185302734375f)) * abs(asfloat(cb7_m[5u].y)), ((asfloat(cb7_m[5u].y) > 0.0f) ? exp2(_453 * 0.60000002384185791015625f) : exp2(_453 * 32.0f)) - _447, _447) * mad(_510, mad(_509, _475, -1.0f), 1.0f), 0.0f, 1.0f);
  float _525 = exp2(mad(_523, 21.0f, -12.97393131256103515625f));
  float _547 = mad(_521, clamp(abs(mad(frac(_519 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
  float _548 = mad(_521, clamp(abs(mad(frac(_519 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
  float _549 = mad(_521, clamp(abs(mad(frac(_519 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
  float _555 = 1.0f / dp3_f32(float3(_547, _548, _549), 0.3333333432674407958984375f.xxx);
  float _556 = (_525 * _547) * _555;
  float _557 = _555 * (_525 * _548);
  float _558 = _555 * (_525 * _549);
  float _561 = asfloat(cb7_m[16u].z);
  float _577 = clamp(abs(mad(frac(_561 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f);
  float _578 = clamp(abs(mad(frac(_561 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f);
  float _579 = clamp(abs(mad(frac(_561 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f);
  float _587 = asfloat(cb7_m[17u].x);
  float _603 = clamp(abs(mad(frac(_587 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f);
  float _604 = clamp(abs(mad(frac(_587 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f);
  float _605 = clamp(abs(mad(frac(_587 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f);
  float _611 = 1.0f / dp3_f32(float3(_577, _578, _579), 0.3333333432674407958984375f.xxx);
  float _612 = 1.0f / dp3_f32(float3(_603, _604, _605), 0.3333333432674407958984375f.xxx);
  float _616 = asfloat(cb7_m[16u].w) * 0.75f;
  float _632 = asfloat(cb7_m[17u].y) * 0.75f;
  float _642 = _556 + (_632 * ((_612 * (_525 * _603)) - _556));
  float _643 = (((_612 * (_525 * _604)) - _557) * _632) + _557;
  float _644 = (((_612 * (_525 * _605)) - _558) * _632) + _558;
  float _653 = clamp(mad(_523 - asfloat(cb7_m[16u].x), asfloat(cb7_m[16u].y), 0.5f), 0.0f, 1.0f);
  float _656 = (_653 * _653) * mad(_653, -2.0f, 3.0f);
  float3 graded_color;
  graded_color.r = mad(_656, (_556 + (_616 * (((_525 * _577) * _611) - _556))) - _642, _642);
  graded_color.g = mad((((((_525 * _578) * _611) - _557) * _616) + _557) - _643, _656, _643);
  graded_color.b = mad((((((_525 * _579) * _611) - _558) * _616) + _558) - _644, _656, _644);

  float3 pq_encoded = graded_color;
  if (RENODX_TONE_MAP_TYPE == 0.f || !hdr_enabled) {  // Vanilla
    float3 log_encoded = mad(log2(graded_color), 0.0476190485060214996337890625f, 0.617806255817413330078125f);
    pq_encoded = t101.SampleLevel(s13, mad(saturate(log_encoded), 0.96875f, 0.015625f), 0.0f).rgb;
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
