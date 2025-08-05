#include "./common.hlsli"

// Hue Weight
static const float _37[10] = { -0.15369999408721923828125f, 0.013500000350177288055419921875f, 0.13120000064373016357421875f, 0.2092899978160858154296875f, 0.2858000099658966064453125f, 0.513000011444091796875f, 0.66879999637603759765625f, 0.745999991893768310546875f, 0.84630000591278076171875f, 1.0134999752044677734375f };

// cbuffer ColorGradingGenerateLUT : register(b0, space5) {
//   struct ColorGradingGenerateLUT_Constants {
//     struct ColorGradingParameters_Constants {} ColorGradingParams;
//     struct TonemapperParams_Constants {
//       struct GTTonemapperParameters {} GTTonemapper;
//       struct LottesTonemapperParameters {} LottesTonemapper;
//       struct GeneralTonemappingParameters {} GeneralTonemapping;
//       struct ACESTonemapperParameters {} ACESTonemapper;
//     } TonemapperParams;
//   } Constants;
// };
cbuffer _19_21 : register(b0, space5) {
  float4 _21_m0[63] : packoffset(c0);
};

Buffer<uint4> _8 : register(t0, space1);
Texture3D<float4> _12 : register(t0, space5);
RWTexture3D<float4> _15 : register(u0, space5);
SamplerState _24 : register(s0, space6);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  float _70 = exp2((float(gl_GlobalInvocationID.x) * 0.64516127109527587890625f) + (-12.47393131256103515625f));
  float _73 = exp2((float(gl_GlobalInvocationID.y) * 0.64516127109527587890625f) + (-12.47393131256103515625f));
  float _76 = exp2((float(gl_GlobalInvocationID.z) * 0.64516127109527587890625f) + (-12.47393131256103515625f));
  uint4 _81 = asuint(_21_m0[0u]);
  uint _82 = _81.x;
  float _85;
  float _87;
  float _89;
  if (_82 == 0u) {
    _85 = _70;
    _87 = _73;
    _89 = _76;
  } else {
    float _216 = asfloat(_8.Load(3u).x);  // not exposure slider
    float _217 = _216 * _70;
    float _218 = _216 * _73;
    float _219 = _216 * _76;
    float _220 = dot(float3(_217, _218, _219), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _228 = log2(_220 * 5464.0f);
    float _267;
    float _269;
    float _271;
    if (_228 < _21_m0[1u].y) {
      float _502;
      if (_228 > _21_m0[1u].x) {
        float _496 = (_228 - _21_m0[1u].x) / (_21_m0[1u].y - _21_m0[1u].x);
        float _497 = _496 * _496;
        _502 = (_497 * 3.0f) - ((_497 * 2.0f) * _496);
      } else {
        _502 = 0.0f;
      }
      float frontier_phi_5_8_ladder;
      float frontier_phi_5_8_ladder_1;
      float frontier_phi_5_8_ladder_2;
      if (_502 < 1.0f) {
        float _504 = 1.0f - _502;
        float _509 = mad(0.180437505245208740234375f, _219, mad(0.3575761020183563232421875f, _218, _217 * 0.41245639324188232421875f));
        float _515 = mad(0.072175003588199615478515625f, _219, mad(0.715152204036712646484375f, _218, _217 * 0.21267290413379669189453125f));
        float _524 = (_515 + _509) + mad(0.950304090976715087890625f, _219, mad(0.119191996753215789794921875f, _218, _217 * 0.01933390088379383087158203125f));
        float _525 = _509 / _524;
        float _526 = _515 / _524;
        float _527 = _21_m0[0u].y - _525;
        float _528 = _21_m0[0u].z - _526;
        float _532 = sqrt((_528 * _528) + (_527 * _527));
        bool _533 = _532 > 0.0f;
        float _539 = min(_21_m0[0u].w, _532);
        float _544 = (((_533 ? (_527 / _532) : 0.0f) * _504) * _539) + _525;
        float _555;
        if (_82 == 1u) {
          _555 = (_504 * ((_218 * 0.845099985599517822265625f) + (_219 * 0.14589999616146087646484375f))) + (_502 * _220);
        } else {
          _555 = _220;
        }
        float _556 = max((((_533 ? (_528 / _532) : 0.0f) * _504) * _539) + _526, 0.001000000047497451305389404296875f);
        float _559 = (_555 * _544) / _556;
        float _563 = (((1.0f - _544) - _556) * _555) / _556;
        frontier_phi_5_8_ladder = mad(-0.498531401157379150390625f, _563, mad(-1.537138462066650390625f, _555, _559 * 3.240454196929931640625f));
        frontier_phi_5_8_ladder_1 = mad(0.04155600070953369140625f, _563, mad(1.87601077556610107421875f, _555, _559 * (-0.969265997409820556640625f)));
        frontier_phi_5_8_ladder_2 = mad(1.05722522735595703125f, _563, mad(-0.2040258944034576416015625f, _555, _559 * 0.0556433983147144317626953125f));
      } else {
        frontier_phi_5_8_ladder = _217;
        frontier_phi_5_8_ladder_1 = _218;
        frontier_phi_5_8_ladder_2 = _219;
      }
      _267 = frontier_phi_5_8_ladder;
      _269 = frontier_phi_5_8_ladder_1;
      _271 = frontier_phi_5_8_ladder_2;
    } else {
      _267 = _217;
      _269 = _218;
      _271 = _219;
    }
    float _275 = asfloat(_8.Load(2u).x);  // not exposure slider
    _85 = _275 * _267;
    _87 = _275 * _269;
    _89 = _275 * _271;
  }

  // blue tint
  // BT.709 -> AP1
  float _118 = (mad(_89, 0.047379501163959503173828125f, mad(_87, 0.3395229876041412353515625f, _85 * 0.613097012042999267578125f)));
  float _119 = (mad(_89, 0.013452400453388690948486328125f, mad(_87, 0.916354000568389892578125f, _85 * 0.070193700492382049560546875f)));
  float _120 = (mad(_89, 0.86981499195098876953125f, mad(_87, 0.1095699965953826904296875f, _85 * 0.020615600049495697021484375f)));

  float3 tint_color = lerp(1.f, _21_m0[2u].rgb, CUSTOM_COLOR_FILTER_STRENGTH);
  _118 *= tint_color.r, _119 *= tint_color.g, _120 *= tint_color.b;

  _118 *= _21_m0[2u].w;
  _119 *= _21_m0[2u].w;
  _120 *= _21_m0[2u].w;

  bool _121 = _119 < _120;
  float _122 = _121 ? _120 : _119;
  float _123 = _121 ? _119 : _120;
  bool _130 = _118 < _122;
  float _131 = _130 ? _122 : _118;
  float _133 = _130 ? _118 : _122;
  float _135 = _131 - min(_133, _123);
  float _148 = abs((_130 ? (_121 ? 0.666666686534881591796875f : (-0.3333333432674407958984375f)) : (_121 ? (-1.0f) : 0.0f)) + ((_133 - _123) / ((_135 * 6.0f) + 1.0000000133514319600180897396058e-10f)));
  float _173 = min(max((_21_m0[16u].x * ((((log2(dot(float3(_118, _119, _120), 0.3333333432674407958984375f.xxx)) * 0.071428574621677398681640625f) + 0.105280816555023193359375f) * _21_m0[3u].x) + 0.5f)) + _21_m0[16u].y, _21_m0[16u].z), _21_m0[16u].w);
  uint _174 = uint(_173);
  uint _177 = _174 + 1u;
  uint _179 = (_177 >> 2u) + 17u;
  float _60[4];
  _60[0u] = _21_m0[_179].x;
  _60[1u] = _21_m0[_179].y;
  _60[2u] = _21_m0[_179].z;
  _60[3u] = _21_m0[_179].w;
  uint _196 = (_174 >> 2u) + 17u;
  float _61[4];
  _61[0u] = _21_m0[_196].x;
  _61[1u] = _21_m0[_196].y;
  _61[2u] = _21_m0[_196].z;
  _61[3u] = _21_m0[_196].w;
  uint _207 = _174 & 3u;
  float _234;
  float _236;
  float _238;
  float _240;
  uint _242;
  _234 = 0.0f;
  _236 = 0.0f;
  _238 = 0.0f;
  _240 = 0.0f;
  _242 = 0u;
  float _235;
  float _237;
  float _239;
  float _241;
  for (;;) {
    float _247 = _37[_242] - _148;
    float _251 = exp2((_247 * _247) * (-128.0f));
    uint _252 = _242 + 4u;
    _235 = (_21_m0[_252].x * _251) + _234;
    _237 = (_21_m0[_252].y * _251) + _236;
    _239 = (_21_m0[_252].z * _251) + _238;
    _241 = _251 + _240;
    uint _243 = _242 + 1u;
    if (_243 == 10u) {
      break;
    } else {
      _234 = _235;
      _236 = _237;
      _238 = _239;
      _240 = _241;
      _242 = _243;
    }
  }
  float _278 = clamp(_21_m0[3u].y * (_135 / (_131 + 1.0000000133514319600180897396058e-10f)), 0.0f, 1.0f);
  float _279 = 1.0f / _241;
  float _283 = sqrt(_278);
  float _292 = frac(((_279 * _235) * _283) + _148);
  float _294 = clamp(((((_279 * _237) + (-1.0f)) * _283) + 1.0f) * _278, 0.0f, 1.0f);
  float _296 = clamp(((((_279 * _239) + (-1.0f)) * _283) + 1.0f) * (((_60[_177 & 3u] - _61[_207]) * (_173 - float(_174))) + _61[_207]), 0.0f, 1.0f);
  float _301 = exp2((_296 * 14.0f) + (-8.47393131256103515625f));
  float _333 = ((min(max(abs((frac(_292 + 1.0f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f) + (-1.0f)) * _294) + 1.0f;
  float _334 = ((min(max(abs((frac(_292 + 0.666666686534881591796875f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f) + (-1.0f)) * _294) + 1.0f;
  float _335 = ((min(max(abs((frac(_292 + 0.3333333432674407958984375f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f) + (-1.0f)) * _294) + 1.0f;
  float _341 = 1.0f / dot(float3(_333, _334, _335), 0.3333333432674407958984375f.xxx);
  float _342 = (_333 * _301) * _341;
  float _343 = (_334 * _301) * _341;
  float _345 = (_341 * _301) * _335;
  float _375 = min(max(abs((frac(_21_m0[14u].z + 1.0f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f);
  float _376 = min(max(abs((frac(_21_m0[14u].z + 0.666666686534881591796875f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f);
  float _377 = min(max(abs((frac(_21_m0[14u].z + 0.3333333432674407958984375f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f);
  float _384 = 1.0f / dot(float3(_375, _376, _377), 0.3333333432674407958984375f.xxx);
  float _409 = min(max(abs((frac(_21_m0[15u].x + 1.0f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f);
  float _410 = min(max(abs((frac(_21_m0[15u].x + 0.666666686534881591796875f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f);
  float _411 = min(max(abs((frac(_21_m0[15u].x + 0.3333333432674407958984375f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f);
  float _418 = 1.0f / dot(float3(_409, _410, _411), 0.3333333432674407958984375f.xxx);
  float _423 = _21_m0[14u].w * 0.75f;
  float _432 = _21_m0[15u].y * 0.75f;
  float _436 = _432 * (((_409 * _301) * _418) - _342);
  float _437 = _432 * (((_410 * _301) * _418) - _343);
  float _438 = _432 * (((_411 * _301) * _418) - _345);
  float _447 = clamp(((_296 - _21_m0[14u].x) * _21_m0[14u].y) + 0.5f, 0.0f, 1.0f);
  float _453 = (_447 * _447) * (3.0f - (_447 * 2.0f));

  float3 final_color = float3(
      (_436 + _342) + (_453 * ((_423 * (((_375 * _301) * _384) - _342)) - _436)),
      (_437 + _343) + (_453 * ((_423 * (((_376 * _301) * _384) - _343)) - _437)),
      (_438 + _345) + (_453 * ((_423 * (((_377 * _301) * _384) - _345)) - _438)));

#if 0
  final_color = renodx::color::bt709::from::AP1(final_color);
  renodx::color::grade::Config cg_config = renodx::color::grade::config::Create(
      RENODX_TONE_MAP_EXPOSURE,
      RENODX_TONE_MAP_HIGHLIGHTS,
      RENODX_TONE_MAP_SHADOWS,
      RENODX_TONE_MAP_CONTRAST,
      0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f),
      RENODX_TONE_MAP_SATURATION,
      RENODX_TONE_MAP_BLOWOUT,
      0.f,
      0,
      renodx::color::grade::config::hue_correction_type::INPUT,
      0.f  // highlight saturation causes artifacts
  );
  final_color = renodx::color::grade::config::ApplyUserColorGrading(
      final_color,
      cg_config);

  final_color = max(0, renodx::color::ap1::from::BT709(final_color));
#else
  final_color = ApplyUserColorGradingAP1(final_color);
#endif

  float3 encoded_color = log2(final_color) * 0.0500000007450580596923828125f + 0.6236965656280517578125f;
  _15[uint3(gl_GlobalInvocationID.rgb)] = float4(_12.SampleLevel(_24, saturate(encoded_color) * 0.96875f + 0.015625f, 0.0f).xyz, 1.0f);
  //   _15[uint3(gl_GlobalInvocationID.xyz)] = float4(_12.SampleLevel(_24, float3((clamp((log2((_436 + _342) + (_453 * ((_423 * (((_375 * _301) * _384) - _342)) - _436))) * 0.0500000007450580596923828125f) + 0.6236965656280517578125f, 0.0f, 1.0f) * 0.96875f) + 0.015625f, (clamp((log2((_437 + _343) + (_453 * ((_423 * (((_376 * _301) * _384) - _343)) - _437))) * 0.0500000007450580596923828125f) + 0.6236965656280517578125f, 0.0f, 1.0f) * 0.96875f) + 0.015625f, (clamp((log2((_438 + _345) + (_453 * ((_423 * (((_377 * _301) * _384) - _345)) - _438))) * 0.0500000007450580596923828125f) + 0.6236965656280517578125f, 0.0f, 1.0f) * 0.96875f) + 0.015625f), 0.0f).xyz, 1.0f);
}

[numthreads(16, 16, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
