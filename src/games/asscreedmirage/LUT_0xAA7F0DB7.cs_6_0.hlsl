#include "./common.hlsl"

static const float _38[10] = { -0.15369999408721923828125f, 0.013500000350177288055419921875f, 0.13120000064373016357421875f, 0.2092899978160858154296875f, 0.2858000099658966064453125f, 0.513000011444091796875f, 0.66879999637603759765625f, 0.745999991893768310546875f, 0.84630000591278076171875f, 1.0134999752044677734375f };

cbuffer _19_21 : register(b0, space6) {
  float4 _21_m0[63] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space6);
Texture3D<float4> _11 : register(t1, space6);
RWTexture3D<float4> _14 : register(u0, space6);
SamplerState _24 : register(s0, space99);
SamplerState _25 : register(s0, space7);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  float4 _67 = _8.SampleLevel(_24, 0.0f.xx, 0.0f);
  float _70 = _67.x;
  float _73 = (_70 > 0.0f) ? _70 : 9.9999999392252902907785028219223e-09f;
  float _83 = exp2((float(gl_GlobalInvocationID.x) * 0.64516127109527587890625f) + (-12.47393131256103515625f));
  float _86 = exp2((float(gl_GlobalInvocationID.y) * 0.64516127109527587890625f) + (-12.47393131256103515625f));
  float _89 = exp2((float(gl_GlobalInvocationID.z) * 0.64516127109527587890625f) + (-12.47393131256103515625f));
  float _97;
  float _99;
  float _101;
  if (asuint(_21_m0[0u]).x == 0u) {
    _97 = _83;
    _99 = _86;
    _101 = _89;
  } else {
    float _225 = _83 / _73;
    float _226 = _86 / _73;
    float _227 = _89 / _73;
    float _228 = dot(float3(_225, _226, _227), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _236 = log2(_228 * 5464.0f);
    float _275;
    float _277;
    float _279;
    if (_236 < _21_m0[1u].y) {
      float _507;
      if (_236 > _21_m0[1u].x) {
        float _501 = (_236 - _21_m0[1u].x) / (_21_m0[1u].y - _21_m0[1u].x);
        float _502 = _501 * _501;
        _507 = (_502 * 3.0f) - ((_502 * 2.0f) * _501);
      } else {
        _507 = 0.0f;
      }
      float frontier_phi_5_8_ladder;
      float frontier_phi_5_8_ladder_1;
      float frontier_phi_5_8_ladder_2;
      if (_507 < 1.0f) {
        float _509 = 1.0f - _507;
        float _519 = mad(0.180437505245208740234375f, _227, mad(0.3575761020183563232421875f, _226, _225 * 0.41245639324188232421875f));
        float _525 = mad(0.072175003588199615478515625f, _227, mad(0.715152204036712646484375f, _226, _225 * 0.21267290413379669189453125f));
        float _534 = (_525 + _519) + mad(0.950304090976715087890625f, _227, mad(0.119191996753215789794921875f, _226, _225 * 0.01933390088379383087158203125f));
        float _535 = _519 / _534;
        float _536 = _525 / _534;
        float _537 = _21_m0[0u].y - _535;
        float _538 = _21_m0[0u].z - _536;
        float _542 = sqrt((_538 * _538) + (_537 * _537));
        bool _543 = _542 > 0.0f;
        float _549 = min(_21_m0[0u].w, _542);
        float _554 = (((_543 ? (_537 / _542) : 0.0f) * _509) * _549) + _535;
        float _558 = (_509 * ((_227 * 0.14589999616146087646484375f) + (_226 * 0.845099985599517822265625f))) + (_507 * _228);
        float _559 = max((((_543 ? (_538 / _542) : 0.0f) * _509) * _549) + _536, 0.001000000047497451305389404296875f);
        float _562 = (_554 * _558) / _559;
        float _566 = (((1.0f - _559) - _554) * _558) / _559;
        frontier_phi_5_8_ladder = mad(-0.498531401157379150390625f, _566, mad(-1.537138462066650390625f, _558, _562 * 3.240454196929931640625f));
        frontier_phi_5_8_ladder_1 = mad(0.04155600070953369140625f, _566, mad(1.87601077556610107421875f, _558, _562 * (-0.969265997409820556640625f)));
        frontier_phi_5_8_ladder_2 = mad(1.05722522735595703125f, _566, mad(-0.2040258944034576416015625f, _558, _562 * 0.0556433983147144317626953125f));
      } else {
        frontier_phi_5_8_ladder = _225;
        frontier_phi_5_8_ladder_1 = _226;
        frontier_phi_5_8_ladder_2 = _227;
      }
      _275 = frontier_phi_5_8_ladder;
      _277 = frontier_phi_5_8_ladder_1;
      _279 = frontier_phi_5_8_ladder_2;
    } else {
      _275 = _225;
      _277 = _226;
      _279 = _227;
    }
    _97 = _275 * _73;
    _99 = _277 * _73;
    _101 = _279 * _73;
  }

  float3 color_filter_strength = lerp(1.f, _21_m0[2u].rgb, CUSTOM_COLOR_FILTER_STRENGTH);

  float _130 = (color_filter_strength.x * mad(_101, 0.047379501163959503173828125f, mad(_99, 0.3395229876041412353515625f, _97 * 0.613097012042999267578125f))) * _21_m0[2u].w;
  float _131 = (color_filter_strength.y * mad(_101, 0.013452400453388690948486328125f, mad(_99, 0.916354000568389892578125f, _97 * 0.070193700492382049560546875f))) * _21_m0[2u].w;
  float _132 = (color_filter_strength.z * mad(_101, 0.86981499195098876953125f, mad(_99, 0.1095699965953826904296875f, _97 * 0.020615600049495697021484375f))) * _21_m0[2u].w;
  bool _133 = _131 < _132;
  float _134 = _133 ? _132 : _131;
  float _135 = _133 ? _131 : _132;
  bool _141 = _130 < _134;
  float _142 = _141 ? _134 : _130;
  float _144 = _141 ? _130 : _134;
  float _146 = _142 - min(_144, _135);
  float _159 = abs((_141 ? (_133 ? 0.666666686534881591796875f : (-0.3333333432674407958984375f)) : (_133 ? (-1.0f) : 0.0f)) + ((_144 - _135) / ((_146 * 6.0f) + 1.0000000133514319600180897396058e-10f)));
  float _184 = min(max((_21_m0[16u].x * ((((log2(dot(float3(_130, _131, _132), 0.3333333432674407958984375f.xxx)) * 0.071428574621677398681640625f) + 0.105280816555023193359375f) * _21_m0[3u].x) + 0.5f)) + _21_m0[16u].y, _21_m0[16u].z), _21_m0[16u].w);
  uint _185 = uint(_184);
  uint _188 = _185 + 1u;
  uint _190 = (_188 >> 2u) + 17u;
  float _62[4];
  _62[0u] = _21_m0[_190].x;
  _62[1u] = _21_m0[_190].y;
  _62[2u] = _21_m0[_190].z;
  _62[3u] = _21_m0[_190].w;
  uint _207 = (_185 >> 2u) + 17u;
  float _63[4];
  _63[0u] = _21_m0[_207].x;
  _63[1u] = _21_m0[_207].y;
  _63[2u] = _21_m0[_207].z;
  _63[3u] = _21_m0[_207].w;
  uint _218 = _185 & 3u;
  float _242;
  float _244;
  float _246;
  float _248;
  uint _250;
  _242 = 0.0f;
  _244 = 0.0f;
  _246 = 0.0f;
  _248 = 0.0f;
  _250 = 0u;
  float _243;
  float _245;
  float _247;
  float _249;
  for (;;) {
    float _255 = _38[_250] - _159;
    float _259 = exp2((_255 * _255) * (-128.0f));
    uint _260 = _250 + 4u;
    _243 = (_21_m0[_260].x * _259) + _242;
    _245 = (_21_m0[_260].y * _259) + _244;
    _247 = (_21_m0[_260].z * _259) + _246;
    _249 = _259 + _248;
    uint _251 = _250 + 1u;
    if (_251 == 10u) {
      break;
    } else {
      _242 = _243;
      _244 = _245;
      _246 = _247;
      _248 = _249;
      _250 = _251;
    }
  }
  float _283 = clamp(_21_m0[3u].y * (_146 / (_142 + 1.0000000133514319600180897396058e-10f)), 0.0f, 1.0f);
  float _284 = 1.0f / _249;
  float _288 = sqrt(_283);
  float _297 = frac(((_284 * _243) * _288) + _159);
  float _299 = clamp(((((_284 * _245) + (-1.0f)) * _288) + 1.0f) * _283, 0.0f, 1.0f);
  float _301 = clamp(((((_284 * _247) + (-1.0f)) * _288) + 1.0f) * (((_62[_188 & 3u] - _63[_218]) * (_184 - float(_185))) + _63[_218]), 0.0f, 1.0f);
  float _306 = exp2((_301 * 14.0f) + (-8.47393131256103515625f));
  float _338 = ((min(max(abs((frac(_297 + 1.0f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f) + (-1.0f)) * _299) + 1.0f;
  float _339 = ((min(max(abs((frac(_297 + 0.666666686534881591796875f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f) + (-1.0f)) * _299) + 1.0f;
  float _340 = ((min(max(abs((frac(_297 + 0.3333333432674407958984375f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f) + (-1.0f)) * _299) + 1.0f;
  float _346 = 1.0f / dot(float3(_338, _339, _340), 0.3333333432674407958984375f.xxx);
  float _347 = (_338 * _306) * _346;
  float _348 = (_339 * _306) * _346;
  float _350 = (_346 * _306) * _340;

  float _380 = min(max(abs((frac(_21_m0[14u].z + 1.0f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f);
  float _381 = min(max(abs((frac(_21_m0[14u].z + 0.666666686534881591796875f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f);
  float _382 = min(max(abs((frac(_21_m0[14u].z + 0.3333333432674407958984375f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f);
  float _389 = 1.0f / dot(float3(_380, _381, _382), 0.3333333432674407958984375f.xxx);
  float _414 = min(max(abs((frac(_21_m0[15u].x + 1.0f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f);
  float _415 = min(max(abs((frac(_21_m0[15u].x + 0.666666686534881591796875f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f);
  float _416 = min(max(abs((frac(_21_m0[15u].x + 0.3333333432674407958984375f) * 6.0f) + (-3.0f)) + (-1.0f), 0.0f), 1.0f);
  float _423 = 1.0f / dot(float3(_414, _415, _416), 0.3333333432674407958984375f.xxx);
  float _428 = _21_m0[14u].w * 0.75f;
  float _437 = _21_m0[15u].y * 0.75f;
  float _441 = _437 * (((_414 * _306) * _423) - _347);
  float _442 = _437 * (((_415 * _306) * _423) - _348);
  float _443 = _437 * (((_416 * _306) * _423) - _350);
  float _452 = clamp(((_301 - _21_m0[14u].x) * _21_m0[14u].y) + 0.5f, 0.0f, 1.0f);
  float _458 = (_452 * _452) * (3.0f - (_452 * 2.0f));

  // Final HDR linear color before encoding
  float3 final_color = float3(
      (_441 + _347) + (_458 * ((_428 * (((_380 * _306) * _389) - _347)) - _441)),
      (_442 + _348) + (_458 * ((_428 * (((_381 * _306) * _389) - _348)) - _442)),
      (_443 + _350) + (_458 * ((_428 * (((_382 * _306) * _389) - _350)) - _443)));

#if 0
  float3 untonemapped_ap1 = finalColor;
  const float diffuse_white_nits = 203.f;
  const float peak_nits = 400.f;

  _14[uint3(gl_GlobalInvocationID)] = float4(ApplyToneMapEncodePQ(untonemapped_ap1, peak_nits, diffuse_white_nits), 1.f);
  return;
#endif

#if 1
  if (RENODX_TONE_MAP_EXPOSURE != 1.f || RENODX_TONE_MAP_HIGHLIGHTS != 1.f || RENODX_TONE_MAP_SHADOWS != 1.f || RENODX_TONE_MAP_CONTRAST != 1.f || RENODX_TONE_MAP_SATURATION != 1.f || RENODX_TONE_MAP_BLOWOUT != 0.f) {
    final_color = renodx::color::bt709::from::AP1(final_color);
    final_color = renodx::color::grade::UserColorGrading(
        final_color,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        RENODX_TONE_MAP_BLOWOUT);

    final_color = renodx::color::ap1::from::BT709(final_color);
  }
#endif

  float3 encoded_color = log2(final_color) * 0.0500000007450580596923828125f + 0.6236965656280517578125f;
  _14[gl_GlobalInvocationID] = float4(_11.SampleLevel(_25, saturate(encoded_color) * 0.96875f + 0.015625f, 0.0f).rgb, 1.0f);
  // _14[uint3(gl_GlobalInvocationID.xyz)] = float4(_11.SampleLevel(_25, float3((clamp((log2((_441 + _347) + (_458 * ((_428 * (((_380 * _306) * _389) - _347)) - _441))) * 0.0500000007450580596923828125f) + 0.6236965656280517578125f, 0.0f, 1.0f) * 0.96875f) + 0.015625f, (clamp((log2((_442 + _348) + (_458 * ((_428 * (((_381 * _306) * _389) - _348)) - _442))) * 0.0500000007450580596923828125f) + 0.6236965656280517578125f, 0.0f, 1.0f) * 0.96875f) + 0.015625f, (clamp((log2((_443 + _350) + (_458 * ((_428 * (((_382 * _306) * _389) - _350)) - _443))) * 0.0500000007450580596923828125f) + 0.6236965656280517578125f, 0.0f, 1.0f) * 0.96875f) + 0.015625f), 0.0f).xyz, 1.0f);
}

[numthreads(16, 16, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
