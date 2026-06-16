#include "./tonemap.hlsli"

static const float _153[11] = { -0.15369999408721923828125f, 0.013500000350177288055419921875f, 0.13120000064373016357421875f, 0.2092899978160858154296875f, 0.2858000099658966064453125f, 0.513000011444091796875f, 0.66879999637603759765625f, 0.745999991893768310546875f, 0.84630000591278076171875f, 1.0134999752044677734375f, 0.0f };

cbuffer cb6_buf : register(b6) {
  uint4 cb6_m[4096] : packoffset(c0);
};

SamplerState s0 : register(s0);
SamplerState s13 : register(s13);
Texture2D<float4> t101 : register(t101);
Texture3D<float4> t102 : register(t102);  // 32x32x32
RWTexture3D<float4> u4 : register(u4);    // 32x32x32

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

float dp3_f32(float3 a, float3 b) {
  precise float _181 = a.x * b.x;
  return mad(a.z, b.z, mad(a.y, b.y, _181));
}

float dp2_f32(float2 a, float2 b) {
  precise float _169 = a.x * b.x;
  return mad(a.y, b.y, _169);
}

void comp_main() {
  float _204 = exp2(mad(float(gl_GlobalInvocationID.x), 0.67741930484771728515625f, -12.97393131256103515625f));
  float _205 = exp2(mad(float(gl_GlobalInvocationID.y), 0.67741930484771728515625f, -12.97393131256103515625f));
  float _206 = exp2(mad(float(gl_GlobalInvocationID.z), 0.67741930484771728515625f, -12.97393131256103515625f));

  float3 input_color = float3(_204, _205, _206);

  float _310;
  float _311;
  float _312;
  if (cb6_m[0u].x != 0u) {
    float4 _219 = t101.SampleLevel(s0, 0.0f.xx, 0.0f);
    float _221 = _219.x;
    float _223 = (_221 > 0.0f) ? _221 : 9.9999999392252902907785028219223e-09f;
    float _224 = _204 / _223;
    float _225 = _205 / _223;
    float _226 = _206 / _223;
    float3 _227 = float3(_224, _225, _226);
    float _228 = dp3_f32(_227, float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _230 = log2(_228 * 5464.0f);
    float _233 = asfloat(cb6_m[1u].y);
    float _304;
    float _305;
    float _306;
    if (_230 < _233) {
      float _239 = asfloat(cb6_m[1u].x);
      float _243 = (_230 - _239) / (_233 - _239);
      float _244 = _243 * _243;
      float _250 = (_230 > _239) ? mad(_244, 3.0f, -dp2_f32(_244.xx, _243.xx)) : 0.0f;
      bool _251 = _250 < 1.0f;
      float _252 = 1.0f - _250;
      float _253 = dp3_f32(float3(0.41245639324188232421875f, 0.3575761020183563232421875f, 0.180437505245208740234375f), _227);
      float _254 = dp3_f32(float3(0.21267290413379669189453125f, 0.715152204036712646484375f, 0.072175003588199615478515625f), _227);
      float _257 = dp3_f32(float3(0.01933390088379383087158203125f, 0.119191996753215789794921875f, 0.950304090976715087890625f), _227) + (_253 + _254);
      float _258 = _253 / _257;
      float _259 = _254 / _257;
      float _267 = asfloat(cb6_m[0u].y) - _258;
      float _268 = asfloat(cb6_m[0u].z) - _259;
      float2 _269 = float2(_267, _268);
      float _270 = dp2_f32(_269, _269);
      float _271 = rsqrt(_270);
      float _278 = min(sqrt(_270), asfloat(cb6_m[0u].w));
      float _281 = mad(_252 * (_267 * _271), _278, _258);
      float _289 = (cb6_m[0u].x == 1u) ? ((_228 * _250) + (_252 * dp2_f32(float2(_225, _226), float2(0.845099985599517822265625f, 0.14589999616146087646484375f)))) : _228;
      float _290 = max(mad(_278, _252 * (_268 * _271), _259), 0.001000000047497451305389404296875f);
      float3 _297 = float3((_281 * _289) / _290, _289, (((1.0f - _281) - _290) * _289) / _290);
      _304 = _251 ? dp3_f32(float3(0.0556433983147144317626953125f, -0.2040258944034576416015625f, 1.05722522735595703125f), _297) : _226;
      _305 = _251 ? dp3_f32(float3(-0.969265997409820556640625f, 1.87601077556610107421875f, 0.04155600070953369140625f), _297) : _225;
      _306 = _251 ? dp3_f32(float3(3.240454196929931640625f, -1.537138462066650390625f, -0.498531401157379150390625f), _297) : _224;
    } else {
      _304 = _226;
      _305 = _225;
      _306 = _224;
    }
    _310 = _304 * _223;
    _311 = _305 * _223;
    _312 = _306 * _223;
  } else {
    _310 = _206;
    _311 = _205;
    _312 = _204;
  }
  float3 _313 = float3(_312, _311, _310);
  float _330 = asfloat(cb6_m[2u].w);
  float _331 = _330 * (dp3_f32(_313, float3(0.070193700492382049560546875f, 0.916354000568389892578125f, 0.013452400453388690948486328125f)) * asfloat(cb6_m[2u].y));
  float _332 = _330 * (dp3_f32(_313, float3(0.020615600049495697021484375f, 0.1095699965953826904296875f, 0.86981499195098876953125f)) * asfloat(cb6_m[2u].z));
  float _333 = (dp3_f32(_313, float3(0.613097012042999267578125f, 0.3395229876041412353515625f, 0.047379501163959503173828125f)) * asfloat(cb6_m[2u].x)) * _330;
  bool _334 = _331 < _332;
  float _335 = _334 ? _332 : _331;
  float _336 = _334 ? _331 : _332;
  bool _339 = _335 > _333;
  float _340 = _339 ? _335 : _333;
  float _342 = _339 ? _333 : _335;
  float _344 = _340 - min(_336, _342);
  float _348 = ((_342 - _336) / mad(_344, 6.0f, 9.9999999392252902907785028219223e-09f)) + (_339 ? (_334 ? 0.666666686534881591796875f : (-0.3333333432674407958984375f)) : (_334 ? (-1.0f) : 0.0f));
  float _357 = max(mad(mad(log2(_340), 0.0476190485060214996337890625f, 0.117806255817413330078125f), asfloat(cb6_m[3u].x), 0.5f), 0.0f);
  float _389 = _357 - 0.5f;
  float _399 = mad(max(mad(abs(_389 * _389), -4.0f, 1.0f), 0.0f), mad(_357, asfloat(cb6_m[4u].z), -_357), _357);
  float _401 = clamp(1.0f - _399, 0.0f, 1.0f);
  float _411 = mad(_401 * _401, exp2(log2(abs(_399)) * asfloat(cb6_m[4u].w)) - _399, _399);
  float _412 = _411 - 0.85000002384185791015625f;
  float _438 = mad(exp2((_412 * _412) * (-12.49999904632568359375f)) * abs(asfloat(cb6_m[3u].z)), ((asfloat(cb6_m[3u].z) > 0.0f) ? exp2(log2(abs(_411)) * 0.125f) : abs(_411 * (_411 * _411))) - _411, _411);
  float _439 = _438 - 0.2249999940395355224609375f;
  float _446 = _438 * _438;
  float _447 = _446 * _446;
  float _457 = mad(exp2((_439 * _439) * (-49.999996185302734375f)) * abs(asfloat(cb6_m[3u].w)), ((asfloat(cb6_m[3u].w) > 0.0f) ? (1.0f / rsqrt(abs(_438))) : abs(_447 * _447)) - _438, _438);
  float _458 = _457 - 1.0f;
  float _484 = mad(exp2((_458 * _458) * (-19.53125f)) * abs(asfloat(cb6_m[4u].x)), ((asfloat(cb6_m[4u].x) > 0.0f) ? exp2(log2(abs(_457)) * 0.00390625f) : abs((_457 * _457) * _457)) - _457, _457);
  float _485 = _484 - 0.185000002384185791015625f;
  float _490 = log2(abs(_484));
  float _507 = clamp((((_344 / (_340 + 9.9999999392252902907785028219223e-09f)) * mad(asfloat(cb6_m[5u].x) - 1.0f, clamp((_357 - asfloat(cb6_m[5u].y)) / (1.0f - asfloat(cb6_m[5u].z)), 0.0f, 1.0f), 1.0f)) * mad(clamp((asfloat(cb6_m[6u].x) - _357) / asfloat(cb6_m[6u].y), 0.0f, 1.0f), asfloat(cb6_m[5u].w) - 1.0f, 1.0f)) * asfloat(cb6_m[3u].y), 0.0f, 1.0f);
  float _509;
  float _512;
  float _514;
  float _516;
  _509 = 0.0f;
  _512 = 0.0f;
  _514 = 0.0f;
  _516 = 0.0f;
  float _510;
  float _513;
  float _515;
  float _517;
  uint _519;
  uint _518 = 0u;
  for (;;) {
    if (int(_518) >= 10) {
      break;
    }
    float _533 = _153[min(_518, 10u)] - abs(_348);
    float _536 = exp2((_533 * _533) * (-128.0f));
    uint _537 = _518 + 7u;
    _517 = mad(_536, asfloat(cb6_m[_537].x), _516);
    _515 = mad(_536, asfloat(cb6_m[_537].y), _514);
    _513 = mad(_536, asfloat(cb6_m[_537].z), _512);
    _510 = _536 + _509;
    _519 = _518 + 1u;
    _509 = _510;
    _512 = _513;
    _514 = _515;
    _516 = _517;
    _518 = _519;
    continue;
  }
  float _546 = 1.0f / _509;
  float _547 = sqrt(_507);
  float _556 = frac(mad(_547, mad(_546, _516, -0.0f), 0.0f) + abs(_348));
  float _558 = clamp(_507 * mad(_547, mad(_546, _514, -1.0f), 1.0f), 0.0f, 1.0f);
  float _560 = clamp(mad(exp2((_485 * _485) * (-49.999996185302734375f)) * abs(asfloat(cb6_m[4u].y)), ((asfloat(cb6_m[4u].y) > 0.0f) ? exp2(_490 * 0.60000002384185791015625f) : exp2(_490 * 32.0f)) - _484, _484) * mad(_547, mad(_546, _512, -1.0f), 1.0f), 0.0f, 1.0f);
  float _562 = exp2(mad(_560, 21.0f, -12.97393131256103515625f));
  float _587 = _562 * mad(_558, clamp(abs(mad(frac(_556 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
  float _588 = _562 * mad(_558, clamp(abs(mad(frac(_556 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
  float _589 = _562 * mad(_558, clamp(abs(mad(frac(_556 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f) - 1.0f, 1.0f);
  float _592 = asfloat(cb6_m[17u].z);
  float _613 = asfloat(cb6_m[18u].x);
  float _635 = asfloat(cb6_m[17u].w) * 0.75f;
  float _651 = asfloat(cb6_m[18u].y) * 0.75f;
  float _661 = _587 + (_651 * ((_562 * clamp(abs(mad(frac(_613 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f)) - _587));
  float _662 = (((_562 * clamp(abs(mad(frac(_613 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f)) - _588) * _651) + _588;
  float _663 = (((_562 * clamp(abs(mad(frac(_613 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f)) - _589) * _651) + _589;
  float _672 = clamp(mad(_560 - asfloat(cb6_m[17u].x), asfloat(cb6_m[17u].y), 0.5f), 0.0f, 1.0f);
  float _675 = (_672 * _672) * mad(_672, -2.0f, 3.0f);
  float3 untonemapped_ap1 = float3(
      mad(_675, (_587 + (_635 * ((_562 * clamp(abs(mad(frac(_592 + 1.0f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f)) - _587))) - _661, _661),
      mad(((((_562 * clamp(abs(mad(frac(_592 + 0.666666686534881591796875f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f)) - _588) * _635) + _588) - _662, _675, _662),
      mad(((((_562 * clamp(abs(mad(frac(_592 + 0.3333333432674407958984375f), 6.0f, -3.0f)) - 1.0f, 0.0f, 1.0f)) - _589) * _635) + _589) - _663, _675, _663));

#if 1
  float untonemapped_lum = renodx::color::yf::from::AP1(untonemapped_ap1);
  renodx_custom::tonemap::psycho::config17::Config psycho17_config = CreatePsycho17Config();
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    untonemapped_ap1 = renodx::color::ap1::from::BT2020(
        renodx_custom::tonemap::psycho::ApplyPreToneMapColorGradeBT2020(renodx::color::bt2020::from::AP1(untonemapped_ap1), psycho17_config));
  }
#endif

  const float MID_GRAY = 0.18f;
  const float LUT_LOG2_RANGE = 21.0f;
  float3 encoded_color = log2(untonemapped_ap1 / MID_GRAY) / LUT_LOG2_RANGE + 0.5f;

  float3 final_color_encoded = t102.SampleLevel(s13, saturate(encoded_color) * 0.96875f + 0.015625f, 0.0f).xyz;

  float peak_nits = asfloat(cb6_m[22u].w);
  float exposure = asfloat(cb6_m[22u].z);
  float diffuse_white_nits = (exposure / 128.f) * 203.f;

#if 1
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float3 final_color_bt2020 = renodx::color::pq::DecodeSafe(final_color_encoded, diffuse_white_nits);

    final_color_bt2020 = renodx_custom::tonemap::psycho::ApplyPostToneMapColorGradeBT2020(
        final_color_bt2020, final_color_bt2020, untonemapped_lum, psycho17_config);

    final_color_encoded = renodx::color::pq::EncodeSafe(final_color_bt2020, diffuse_white_nits);
  }
#endif

  u4[gl_GlobalInvocationID] = float4(final_color_encoded, 1.f);
}

[numthreads(16, 16, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
