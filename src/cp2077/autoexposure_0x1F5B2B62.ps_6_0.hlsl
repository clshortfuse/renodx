#include "./injectedBuffer.hlsl"

cbuffer _17_19 : register(b0, space0) {
  float4 _19_m0[30] : packoffset(c0);
}

cbuffer _22_24 : register(b12, space0) {
  float4 _24_m0[99] : packoffset(c0);
}

cbuffer _27_29 : register(b6, space0) {
  float4 _29_m0[1] : packoffset(c0);
}

Texture3D<float4> _8 : register(t38, space0);
Texture2D<float4> _11 : register(t68, space0);
Texture2D<float4> _12 : register(t0, space0);
SamplerState _32 : register(s11, space0);

static float4 gl_FragCoord;
static float2 SYS_TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;
  nointerpolation float2 SYS_TEXCOORD : SYS_TEXCOORD;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

static bool discard_state;

void discard_cond(bool _602) {
  if (_602) {
    discard_state = true;
  }
}

void discard_exit() {
  if (discard_state) {
    discard;
  }
}

void frag_main() {
  discard_state = false;
  uint _52 = uint(gl_FragCoord.x);
  uint _53 = uint(gl_FragCoord.y);
  float4 _54 = _12.Load(int3(uint2(_52, _53), 0u));
  float _57 = _54.x;
  float _58 = float(_52);
  float _59 = float(_53);
  float _74 = (((_58 + 0.5f) * 2.0f) * _24_m0[27u].z) + (-1.0f);
  float _77 = (-0.0f) - ((((_59 + 0.5f) * 2.0f) * _24_m0[27u].w) + (-1.0f));
  float _123 = (_24_m0[24u].w + _24_m0[23u].w) + mad(_24_m0[22u].w, _77, _74 * _24_m0[21u].w);
  float _124 = ((mad(_24_m0[22u].x, _77, _74 * _24_m0[21u].x) + _24_m0[23u].x) + _24_m0[24u].x) / _123;
  float _125 = ((_24_m0[24u].y + _24_m0[23u].y) + mad(_24_m0[22u].y, _77, _74 * _24_m0[21u].y)) / _123;
  float _126 = ((_24_m0[24u].z + _24_m0[23u].z) + mad(_24_m0[22u].z, _77, _74 * _24_m0[21u].z)) / _123;
  float _131 = rsqrt(dot(float3(_124, _125, _126), float3(_124, _125, _126)));
  float _132 = _131 * _124;
  float _133 = _131 * _125;
  float _134 = _131 * _126;
  float _222;
  float _224;
  float _226;
  float _228;
  if (_57 == 0.0f) {
    discard_cond((_134 + 0.20000000298023223876953125f) < 0.0f);
    float _147 = max(_24_m0[0u].z, 0.5f);
    float _148 = _147 * 0.001000000047497451305389404296875f;
    float _162 = (sqrt((_132 * _132) + (_133 * _133)) * (_148 + 1592.75f)) / sqrt((_148 * _148) + (_147 * 3.18550014495849609375f));
    float _166 = rsqrt(dot(float3(_132, _133, _162), float3(_132, _133, _162)));
    float _169 = _166 * _162;
    float _183 = clamp((((_169 > _134) ? dot(float3(_166 * _132, _166 * _133, _169), float3(_132, _133, _134)) : 1.0f) - _29_m0[0u].y) / (_29_m0[0u].x - _29_m0[0u].y), 0.0f, 1.0f);
    _222 = _24_m0[0u].x + (_132 * 100000.0f);
    _224 = _24_m0[0u].y + (_133 * 100000.0f);
    _226 = _24_m0[0u].z + (_134 * 100000.0f);
    _228 = ((_183 * _183) * (3.0f - (_183 * 2.0f))) * _29_m0[0u].z;
  } else {
    float frontier_phi_3_2_ladder;
    float frontier_phi_3_2_ladder_1;
    float frontier_phi_3_2_ladder_2;
    float frontier_phi_3_2_ladder_3;
    if ((1.0f / max((((_24_m0[26u].x * _57) + _24_m0[26u].y) * _24_m0[25u].x) + _24_m0[25u].y, 1.0000000116860974230803549289703e-07f)) > _24_m0[40u].z) {
      float _273 = mad(_24_m0[71u].w, _57, mad(_24_m0[70u].w, _59, _24_m0[69u].w * _58)) + _24_m0[72u].w;
      frontier_phi_3_2_ladder = (mad(_24_m0[71u].x, _57, mad(_24_m0[70u].x, _59, _24_m0[69u].x * _58)) + _24_m0[72u].x) / _273;
      frontier_phi_3_2_ladder_1 = (mad(_24_m0[71u].y, _57, mad(_24_m0[70u].y, _59, _24_m0[69u].y * _58)) + _24_m0[72u].y) / _273;
      frontier_phi_3_2_ladder_2 = (mad(_24_m0[71u].z, _57, mad(_24_m0[70u].z, _59, _24_m0[69u].z * _58)) + _24_m0[72u].z) / _273;
      frontier_phi_3_2_ladder_3 = 1.0f;
    } else {
      frontier_phi_3_2_ladder = 0.0f;
      frontier_phi_3_2_ladder_1 = 0.0f;
      frontier_phi_3_2_ladder_2 = 0.0f;
      frontier_phi_3_2_ladder_3 = 0.0f;
    }
    _222 = frontier_phi_3_2_ladder;
    _224 = frontier_phi_3_2_ladder_1;
    _226 = frontier_phi_3_2_ladder_2;
    _228 = frontier_phi_3_2_ladder_3;
  }
  float _390;
  float _392;
  float _394;
  float _396;
  if (_228 > 0.0f) {
    float _278 = _24_m0[0u].x - _222;
    float _279 = _24_m0[0u].y - _224;
    float _294 = clamp((_24_m0[38u].w * sqrt((_278 * _278) + (_279 * _279))) + _24_m0[37u].w, 0.0f, 1.0f);
    float _295 = 1.0f - _294;
    float _299 = rsqrt(dot(float2(_278, _279), float2(_278, _279)));
    float _301 = (_294 * _278) * _299;
    float _303 = (_294 * _279) * _299;
    float _307 = ((_295 * _295) * 0.800000011920928955078125f) + 0.20000000298023223876953125f;
    float _311 = rsqrt(dot(float3(_301, _303, _307), float3(_301, _303, _307)));
    float _315 = (_307 * _311) + 1.0f;
    float4 _327 = _11.SampleLevel(_32, float2(0.5f - (((_301 * _311) / _315) * 0.5f), 0.5f - (((_303 * _311) / _315) * 0.5f)), 4.0f - (_294 * 3.0f));
    float _336 = _294 * _294;
    float _352 = (_327.x * 64.0f) * (((_24_m0[38u].x - _24_m0[37u].x) * _336) + _24_m0[37u].x);
    float _353 = (_327.y * 64.0f) * (((_24_m0[38u].y - _24_m0[37u].y) * _336) + _24_m0[37u].y);
    float _354 = (_327.z * 64.0f) * (((_24_m0[38u].z - _24_m0[37u].z) * _336) + _24_m0[37u].z);
    bool _355 = _57 != 0.0f;
    float _370 = _222 - _24_m0[0u].x;
    float _371 = _224 - _24_m0[0u].y;
    float _372 = _226 - _24_m0[0u].z;
    float _373 = dot(float3(_370, _371, _372), float3(_370, _371, _372));
    float _380 = asfloat(1595932665u - (asuint(_373) >> 1u));
    float _387 = (_380 * 0.703952252864837646484375f) * (2.389244556427001953125f - ((_380 * _380) * _373));
    float _388 = _387 * _373;
    float _426;
    float _427;
    float _428;
    float _429;
    if (_24_m0[40u].z > 0.0f) {
      float _407 = _387 * _24_m0[40u].z;
      float _408 = _407 * _372;
      float _409 = _408 + _24_m0[0u].z;
      _426 = exp2((-0.0f) - max(-127.0f, (_409 - _24_m0[40u].y) * _24_m0[39u].y)) * _24_m0[40u].x;
      _427 = exp2((-0.0f) - max(-127.0f, (_409 - _24_m0[41u].y) * _24_m0[41u].z)) * _24_m0[41u].x;
      _428 = (1.0f - _407) * _388;
      _429 = _372 - _408;
    } else {
      _426 = _24_m0[39u].x;
      _427 = _24_m0[41u].w;
      _428 = _388;
      _429 = _372;
    }
    float _431 = max(-127.0f, _429 * _24_m0[39u].y);
    float _446 = max(-127.0f, _429 * _24_m0[41u].z);
    float _462 = max(clamp(exp2((-0.0f) - (_428 * ((((abs(_446) > 0.00999999977648258209228515625f) ? ((1.0f - exp2((-0.0f) - _446)) / _446) : (0.693147182464599609375f - (_446 * 0.2402265071868896484375f))) * _427) + (((abs(_431) > 0.00999999977648258209228515625f) ? ((1.0f - exp2((-0.0f) - _431)) / _431) : (0.693147182464599609375f - (_431 * 0.2402265071868896484375f))) * _426)))), 0.0f, 1.0f), 0.0f);
    float _467 = (!(isnan(_462) || isinf(_462))) ? _462 : 0.0f;
    _390 = (_355 ? (_352 - (_467 * _352)) : _352) * _228;
    _392 = (_355 ? (_353 - (_467 * _353)) : _353) * _228;
    _394 = (_355 ? (_354 - (_467 * _354)) : _354) * _228;
    _396 = ((_355 ? (_467 + (-1.0f)) : (-1.0f)) * _228) + 1.0f;
  } else {
    _390 = 0.0f;
    _392 = 0.0f;
    _394 = 0.0f;
    _396 = 1.0f;
  }
  float _535;
  float _537;
  float _539;
  float _541;
  if (false && _24_m0[43u].w > 0.0f) {
    float _491 = (float(uint(_58)) + 0.5f) / _19_m0[3u].x;
    float _492 = (float(uint(_59)) + 0.5f) / _19_m0[3u].y;
    float _506 = 1.0f / max((((_24_m0[26u].x * _57) + _24_m0[26u].y) * _24_m0[25u].x) + _24_m0[25u].y, 1.0000000116860974230803549289703e-07f);
    float4 _519 = _8.SampleLevel(_32, float3(_491, _492, exp2(log2(abs(_24_m0[44u].w * _506)) * _24_m0[44u].y)), 0.0f);
    float _524 = _519.w;
    float _525 = _519.x * 64.0f;
    float _526 = _519.y * 64.0f;
    float _527 = _519.z * 64.0f;
    float frontier_phi_10_9_ladder;
    float frontier_phi_10_9_ladder_1;
    float frontier_phi_10_9_ladder_2;
    float frontier_phi_10_9_ladder_3;
    if ((_24_m0[42u].w * _506) > _24_m0[44u].z) {
      float4 _569 = _8.SampleLevel(_32, float3(_491, _492, exp2(log2(abs(((_506 - _24_m0[44u].z) * 0.0500000007450580596923828125f) * _24_m0[44u].w)) * _24_m0[44u].y)), 1.0f);
      float _575 = _524 * 64.0f;
      frontier_phi_10_9_ladder = (_575 * _569.x) + _525;
      frontier_phi_10_9_ladder_1 = (_575 * _569.y) + _526;
      frontier_phi_10_9_ladder_2 = (_575 * _569.z) + _527;
      frontier_phi_10_9_ladder_3 = _569.w * _524;
    } else {
      frontier_phi_10_9_ladder = _525;
      frontier_phi_10_9_ladder_1 = _526;
      frontier_phi_10_9_ladder_2 = _527;
      frontier_phi_10_9_ladder_3 = _524;
    }
    _535 = frontier_phi_10_9_ladder;
    _537 = frontier_phi_10_9_ladder_1;
    _539 = frontier_phi_10_9_ladder_2;
    _541 = frontier_phi_10_9_ladder_3;
  } else {
    _535 = 0.0f;
    _537 = 0.0f;
    _539 = 0.0f;
    _541 = 1.0f;
  }
  SV_Target.x = ((_541 * _390) + _535) * SYS_TEXCOORD.x; // injectedData.debugValue0 SYS_TEXCOORD.x;
  SV_Target.y = ((_541 * _392) + _537) * SYS_TEXCOORD.x; // injectedData.debugValue0 SYS_TEXCOORD.x;
  SV_Target.z = ((_541 * _394) + _539) * SYS_TEXCOORD.x; // injectedData.debugValue0 SYS_TEXCOORD.x;
  SV_Target.w = 1.0f - (_541 * _396);
  discard_exit();
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  SYS_TEXCOORD = stage_input.SYS_TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = 0.f; // SV_Target;
  return stage_output;
}
