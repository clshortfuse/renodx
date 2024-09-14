static float _731;
static float _732;
static float _733;
static float _735;
static float _736;
static float _737;

cbuffer _22_24 : register(b0, space0) {
  float4 _24_m0[30] : packoffset(c0);
};

cbuffer _27_29 : register(b12, space0) {
  float4 _29_m0[99] : packoffset(c0);
};

cbuffer _32_34 : register(b6, space0) {
  float4 _34_m0[15] : packoffset(c0);
};

Texture2D<uint4> _8 : register(t51, space0);
Texture2D<float4> _12 : register(t0, space0);
Texture2D<float4> _13 : register(t1, space0);
Texture3D<float4> _18[3] : register(t4, space0);
SamplerState _37 : register(s11, space0);

static float4 gl_FragCoord;
static float2 SYS_TEXCOORD;
static float4 SV_Target;
static float4 SV_Target_1;

struct SPIRV_Cross_Input {
  nointerpolation float2 SYS_TEXCOORD : TEXCOORD1;
  float4 gl_FragCoord : SV_Position;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float4 SV_Target_1 : SV_Target1;
};

void frag_main() {
  uint _59 = uint(int(gl_FragCoord.x));
  uint _60 = uint(int(gl_FragCoord.y));
  float _61 = float(int(_59));
  float _62 = float(int(_60));
  float _63 = _61 + 0.5f;
  float _65 = _62 + 0.5f;
  float4 _74 = _12.Load(int3(uint2(_59, _60), 0u));
  float4 _83 = _13.Sample(_37, float2(_63 * _34_m0[10u].z, _65 * _34_m0[10u].w));
  float _113 = (((_34_m0[0u].x * _83.x) + (_34_m0[0u].w * _74.x)) * _34_m0[11u].w) + _34_m0[11u].x;
  float _114 = (((_34_m0[0u].y * _83.y) + (_34_m0[0u].w * _74.y)) * _34_m0[11u].w) + _34_m0[11u].y;
  float _115 = (((_34_m0[0u].z * _83.z) + (_34_m0[0u].w * _74.z)) * _34_m0[11u].w) + _34_m0[11u].z;
  float _135 = (_34_m0[14u].x * _34_m0[10u].x) * (((_63 * 2.0f) * _34_m0[10u].z) + (-1.0f));
  float _137 = (_34_m0[14u].x * _34_m0[10u].y) * (((_65 * 2.0f) * _34_m0[10u].w) + (-1.0f));
  float _173;
  float _174;
  float _175;
  if (_34_m0[9u].x > 0.0f) {
    float _157 = exp2((-0.0f) - (_34_m0[9u].y * log2(abs((dot(float2(_135, _137), float2(_135, _137)) * _34_m0[9u].x) + 1.0f))));
    _173 = ((_113 - _34_m0[8u].x) * _157) + _34_m0[8u].x;
    _174 = ((_114 - _34_m0[8u].y) * _157) + _34_m0[8u].y;
    _175 = ((_115 - _34_m0[8u].z) * _157) + _34_m0[8u].z;
  } else {
    _173 = _113;
    _174 = _114;
    _175 = _115;
  }
  float _406;
  float _407;
  float _408;
  uint _200;
  float _213;
  float _214;
  float _216;
  float _218;
  float _327;
  float _328;
  float _329;
  float _341;
  float _342;
  float _343;
  float _351;
  float _352;
  float _353;
  uint _360;
  bool _361;
  for (;;) {
    _200 = 1u << (_8.Load(int3(uint2(uint(_29_m0[79u].x * _61), uint(_29_m0[79u].y * _62)), 0u)).y & 31u);
    _213 = frac(_61 * 0.103100001811981201171875f);
    _214 = frac(_62 * 0.10300000011920928955078125f);
    float _215 = frac(float(asuint(_24_m0[28u]).y) * 0.097300000488758087158203125f);
    _216 = _214 + 33.3300018310546875f;
    _218 = _213 + 33.3300018310546875f;
    float _220 = dot(float3(_213, _214, _215), float3(_216, _218, _215 + 33.3300018310546875f));
    float _224 = _220 + _213;
    float _225 = _220 + _214;
    float _227 = _224 + _225;
    float _235 = frac(_227 * (_220 + _215)) + (-0.5f);
    float _237 = frac((_224 * 2.0f) * _225) + (-0.5f);
    float _238 = frac(_227 * _224) + (-0.5f);
    uint4 _251 = asuint(_34_m0[13u]);
    float _255 = float(min((_251.x & _200), 1u));
    float _276 = float(min((_251.y & _200), 1u));
    float _298 = float(min((_251.z & _200), 1u));
    float _320 = float(min((_251.w & _200), 1u));
    _327 = (((((_173 * SYS_TEXCOORD.x) * _34_m0[1u].y) * (((_34_m0[2u].x * _235) * _255) + 1.0f)) * (((_34_m0[3u].x * _235) * _276) + 1.0f)) * (((_34_m0[4u].x * _235) * _298) + 1.0f)) * (((_34_m0[5u].x * _235) * _320) + 1.0f);
    _328 = (((((_174 * SYS_TEXCOORD.x) * _34_m0[1u].y) * (((_34_m0[2u].y * _237) * _255) + 1.0f)) * (((_34_m0[3u].y * _237) * _276) + 1.0f)) * (((_34_m0[4u].y * _237) * _298) + 1.0f)) * (((_34_m0[5u].y * _237) * _320) + 1.0f);
    _329 = (((((_175 * SYS_TEXCOORD.x) * _34_m0[1u].y) * (((_34_m0[2u].z * _238) * _255) + 1.0f)) * (((_34_m0[3u].z * _238) * _276) + 1.0f)) * (((_34_m0[4u].z * _238) * _298) + 1.0f)) * (((_34_m0[5u].z * _238) * _320) + 1.0f);
    _341 = (_34_m0[6u].x * log2(_327)) + _34_m0[6u].y;
    _342 = (_34_m0[6u].x * log2(_328)) + _34_m0[6u].y;
    _343 = (_34_m0[6u].x * log2(_329)) + _34_m0[6u].y;
    float4 _349 = _18[4u].SampleLevel(_37, float3(_341, _342, _343), 0.0f);
    _351 = _349.x;
    _352 = _349.y;
    _353 = _349.z;
    _360 = min((asuint(_34_m0[12u]).x & _200), 1u);
    _361 = _360 == 0u;
    uint _377;
    float _379;
    float _381;
    float _383;
    if (_361) {
      float4 _365 = _18[5u].SampleLevel(_37, float3(_341, _342, _343), 0.0f);
      uint _375 = min((asuint(_34_m0[12u]).y & _200), 1u);
      uint frontier_phi_4_3_ladder;
      float frontier_phi_4_3_ladder_1;
      float frontier_phi_4_3_ladder_2;
      float frontier_phi_4_3_ladder_3;
      if (_375 == 0u) {
        float4 _398 = _18[6u].SampleLevel(_37, float3(_341, _342, _343), 0.0f);
        uint _378 = min((asuint(_34_m0[12u]).z & _200), 1u);
        if (_378 == 0u) {
          _406 = _327;
          _407 = _328;
          _408 = _329;
          break;
        }
        frontier_phi_4_3_ladder = _378;
        frontier_phi_4_3_ladder_1 = _398.z;
        frontier_phi_4_3_ladder_2 = _398.y;
        frontier_phi_4_3_ladder_3 = _398.x;
      } else {
        frontier_phi_4_3_ladder = _375;
        frontier_phi_4_3_ladder_1 = _365.z;
        frontier_phi_4_3_ladder_2 = _365.y;
        frontier_phi_4_3_ladder_3 = _365.x;
      }
      _377 = frontier_phi_4_3_ladder;
      _379 = frontier_phi_4_3_ladder_1;
      _381 = frontier_phi_4_3_ladder_2;
      _383 = frontier_phi_4_3_ladder_3;
    } else {
      _377 = _360;
      _379 = _353;
      _381 = _352;
      _383 = _351;
    }
    float _385 = float(_377);
    _406 = ((_383 - _327) * _385) + _327;
    _407 = ((_381 - _328) * _385) + _328;
    _408 = ((_379 - _329) * _385) + _329;
    break;
  }
  float _641;
  float _642;
  float _643;
  float _439;
  float _440;
  float _441;
  uint _458;
  float _568;
  float _569;
  float _570;
  float _581;
  float _582;
  float _583;
  float _587;
  float _588;
  float _589;
  uint _595;
  bool _596;
  for (;;) {
    float _409 = dot(float3(_406, _407, _408), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
    float _421 = max(9.9999997473787516355514526367188e-05f, dot(float3(_327, _328, _329), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)));
    _439 = ((_34_m0[1u].w * (((_409 * _327) / _421) - _406)) + _406) * _34_m0[1u].z;
    _440 = ((_34_m0[1u].w * (((_409 * _328) / _421) - _407)) + _407) * _34_m0[1u].z;
    _441 = ((_34_m0[1u].w * (((_409 * _329) / _421) - _408)) + _408) * _34_m0[1u].z;
    _458 = 1u << (_8.Load(int3(uint2(uint(_29_m0[79u].x * _61), uint(_29_m0[79u].y * _62)), 0u)).y & 31u);
    float _465 = frac(float(asuint(_24_m0[28u]).y) * 0.097300000488758087158203125f);
    float _467 = dot(float3(_213, _214, _465), float3(_216, _218, _465 + 33.3300018310546875f));
    float _470 = _467 + _213;
    float _471 = _467 + _214;
    float _473 = _470 + _471;
    float _481 = frac(_473 * (_467 + _465)) + (-0.5f);
    float _482 = frac((_470 * 2.0f) * _471) + (-0.5f);
    float _483 = frac(_473 * _470) + (-0.5f);
    uint4 _494 = asuint(_34_m0[13u]);
    float _498 = float(min((_494.x & _458), 1u));
    float _519 = float(min((_494.y & _458), 1u));
    float _540 = float(min((_494.z & _458), 1u));
    float _561 = float(min((_494.w & _458), 1u));
    _568 = ((((_34_m0[1u].y * _113) * (((_34_m0[2u].x * _481) * _498) + 1.0f)) * (((_34_m0[3u].x * _481) * _519) + 1.0f)) * (((_34_m0[4u].x * _481) * _540) + 1.0f)) * (((_34_m0[5u].x * _481) * _561) + 1.0f);
    _569 = ((((_34_m0[1u].y * _114) * (((_34_m0[2u].y * _482) * _498) + 1.0f)) * (((_34_m0[3u].y * _482) * _519) + 1.0f)) * (((_34_m0[4u].y * _482) * _540) + 1.0f)) * (((_34_m0[5u].y * _482) * _561) + 1.0f);
    _570 = ((((_34_m0[1u].y * _115) * (((_34_m0[2u].z * _483) * _498) + 1.0f)) * (((_34_m0[3u].z * _483) * _519) + 1.0f)) * (((_34_m0[4u].z * _483) * _540) + 1.0f)) * (((_34_m0[5u].z * _483) * _561) + 1.0f);
    _581 = (_34_m0[6u].x * log2(_568)) + _34_m0[6u].y;
    _582 = (_34_m0[6u].x * log2(_569)) + _34_m0[6u].y;
    _583 = (_34_m0[6u].x * log2(_570)) + _34_m0[6u].y;
    float4 _585 = _18[4u].SampleLevel(_37, float3(_581, _582, _583), 0.0f);
    _587 = _585.x;
    _588 = _585.y;
    _589 = _585.z;
    _595 = min((asuint(_34_m0[12u]).x & _458), 1u);
    _596 = _595 == 0u;
    uint _612;
    float _614;
    float _616;
    float _618;
    if (_596) {
      float4 _600 = _18[5u].SampleLevel(_37, float3(_581, _582, _583), 0.0f);
      uint _610 = min((asuint(_34_m0[12u]).y & _458), 1u);
      uint frontier_phi_8_7_ladder;
      float frontier_phi_8_7_ladder_1;
      float frontier_phi_8_7_ladder_2;
      float frontier_phi_8_7_ladder_3;
      if (_610 == 0u) {
        float4 _633 = _18[6u].SampleLevel(_37, float3(_581, _582, _583), 0.0f);
        uint _613 = min((asuint(_34_m0[12u]).z & _458), 1u);
        if (_613 == 0u) {
          _641 = _568;
          _642 = _569;
          _643 = _570;
          break;
        }
        frontier_phi_8_7_ladder = _613;
        frontier_phi_8_7_ladder_1 = _633.z;
        frontier_phi_8_7_ladder_2 = _633.y;
        frontier_phi_8_7_ladder_3 = _633.x;
      } else {
        frontier_phi_8_7_ladder = _610;
        frontier_phi_8_7_ladder_1 = _600.z;
        frontier_phi_8_7_ladder_2 = _600.y;
        frontier_phi_8_7_ladder_3 = _600.x;
      }
      _612 = frontier_phi_8_7_ladder;
      _614 = frontier_phi_8_7_ladder_1;
      _616 = frontier_phi_8_7_ladder_2;
      _618 = frontier_phi_8_7_ladder_3;
    } else {
      _612 = _595;
      _614 = _589;
      _616 = _588;
      _618 = _587;
    }
    float _620 = float(_612);
    _641 = ((_618 - _568) * _620) + _568;
    _642 = ((_616 - _569) * _620) + _569;
    _643 = ((_614 - _570) * _620) + _570;
    break;
  }
  float _644 = dot(float3(_641, _642, _643), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
  float _653 = max(9.9999997473787516355514526367188e-05f, dot(float3(_568, _569, _570), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)));
  float _670 = ((_34_m0[1u].w * (((_644 * _568) / _653) - _641)) + _641) * _34_m0[1u].z;
  float _671 = ((_34_m0[1u].w * (((_644 * _569) / _653) - _642)) + _642) * _34_m0[1u].z;
  float _672 = ((_34_m0[1u].w * (((_644 * _570) / _653) - _643)) + _643) * _34_m0[1u].z;
  SV_Target.x = asfloat(asuint(_670) + 65536u);
  SV_Target.y = asfloat(asuint(_671) + 65536u);
  SV_Target.z = asfloat(asuint(_672) + 131072u);
  SV_Target.w = 1.0f;
  SV_Target_1.x = asfloat(asuint(_670 - _439) + 65536u);
  SV_Target_1.y = asfloat(asuint(_671 - _440) + 65536u);
  SV_Target_1.z = asfloat(asuint(_672 - _441) + 131072u);
  SV_Target_1.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  SYS_TEXCOORD = stage_input.SYS_TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
