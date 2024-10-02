#include "./colormath.hlsl"
#include "./cp2077.h"
#include "./injectedBuffer.hlsl"

cbuffer _31_33 : register(b0, space0) {
  float4 cb0[30] : packoffset(c0);
}

cbuffer _40_42 : register(b6, space0) {
  float4 cb6[30] : packoffset(c0);
}

cbuffer _36_38 : register(b12, space0) {
  float4 cb12[99] : packoffset(c0);
}

Texture2D<float4> _8 : register(t32, space0);
Texture2D<uint2> _12 : register(t51, space0);
Texture2D<float4> _13 : register(t0, space0);
Texture2D<float4> _14 : register(t1, space0);
Texture2D<float4> _15 : register(t2, space0);
Texture2D<float4> _16 : register(t3, space0);
Texture2D<float4> _17 : register(t5, space0);
Texture2D<float4> _18 : register(t6, space0);
Texture2D<float4> _19 : register(t8, space0);
StructuredBuffer<float> _22 : register(t9, space0);
Texture2D<float4> _23 : register(t10, space0);
RWTexture2D<float4> _26 : register(u0, space0);
RWTexture2D<float4> _27 : register(u1, space0);
SamplerState _45 : register(s0, space0);

static uint3 gl_GlobalInvocationID;

struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  float _70 = float(gl_GlobalInvocationID.x);
  float _71 = float(gl_GlobalInvocationID.y);
  float _80 = float(asuint(cb6[12u].z));
  float _81 = float(asuint(cb6[12u].w));
  float _84 = (_70 + 0.5f) / _80;
  float _86 = (_71 + 0.5f) / _81;
  bool _93;
  if (_84 < cb6[9u].y) {
    _93 = true;
  } else {
    bool frontier_phi_1_2_ladder;
    if ((_86 < cb6[9u].z) || ((1.0f - cb6[9u].y) < _84)) {
      frontier_phi_1_2_ladder = true;
    } else {
      frontier_phi_1_2_ladder = (1.0f - cb6[9u].z) < _86;
    }
    _93 = frontier_phi_1_2_ladder;
  }
  float _102;
  float _106;
  float _109;
  if (_93) {
    _102 = 0.0f;
    _106 = 0.0f;
    _109 = 0.0f;
  } else {
    bool _121 = cb6[0u].x > 0.0f;
    float _122 = _84 + (-0.5f);
    float _124 = _86 + (-0.5f);
    float _126 = cb6[0u].y + 0.119999997317790985107421875f;
    float _131 = max(_126 + abs(_122), 0.0f);
    float _134 = max(abs(_124) + _126, 0.0f);
    float _142 = min(max(sqrt((_134 * _134) + (_131 * _131)) * 20.0f, 0.0f), 1.0f);
    float _149 = ((_142 * _142) * cb6[0u].x) * (3.0f - (_142 * 2.0f));
    float _150 = _149 * 0.699999988079071044921875f;
    float _153 = ceil(_150) - _150;
    float _156 = (_153 * 50.0f) + 1.0f;
    float _165 = (((cos(cb0[0u].x) * 2.0f) + 200.0f) * _153) + 1.0f;
    float _170 = frac(floor(_156 * _84) * 0.103100001811981201171875f);
    float _174 = frac(floor(_165 * _86) * 0.103100001811981201171875f);
    float _175 = _174 + 33.3300018310546875f;
    float _177 = _170 + 33.3300018310546875f;
    float _178 = dot(float3(_170, _174, _170), float3(_175, _177, _177));
    float _182 = _174 + _170;
    float _187 = frac(((_178 * 2.0f) + _182) * (_178 + _170));
    float _192 = abs(sin((_149 * 0.1680000126361846923828125f) * cb0[0u].x));
    float _195 = (_149 * 0.14000000059604644775390625f) + 1.0f;
    float _196 = dot(float3(_174, _170, _174), float3(_177, _175, _175));
    float _222 = ((1.0f / (((cos(cb0[0u].x * frac(abs(sin(cb0[0u].x * 5000.0f)) + _187)) * 0.0199999995529651641845703125f) + 1.0f) * _165)) * floor(frac(frac(((_196 * 2.0f) + _182) * (_196 + _174)) + _192) * _195)) + _86;
    float _223 = _222 * _81;
    float _229 = frac(round((_149 * 0.125f) * _223) * 0.103100001811981201171875f);
    float _233 = frac((_149 * 2.0620000362396240234375f) * cb0[0u].x);
    float _234 = _233 + 33.3300018310546875f;
    float _235 = _229 + 33.3300018310546875f;
    float _236 = dot(float3(_229, _233, _229), float3(_234, _235, _235));
    float _244 = frac(round((_149 * 0.012500000186264514923095703125f) * _223) * 0.103100001811981201171875f);
    float _245 = _244 + 33.3300018310546875f;
    float _246 = dot(float3(_244, _233, _244), float3(_234, _245, _245));
    float _308;
    if (_121) {
      _308 = ((((((1.0f / (((sin(cb0[0u].x * frac(abs(sin(cb0[0u].x * 100.0f)) + _187)) * 0.0199999995529651641845703125f) + 1.0f) * _156)) * floor(frac(_192 + _187) * _195)) + _84) * _80) + 2.0f) + ((((_149 * _149) * 960.0f) * frac(((_233 + _229) + (_236 * 2.0f)) * (_236 + _229))) * frac(((_244 + _233) + (_246 * 2.0f)) * (_246 + _244)))) / _80;
    } else {
      _308 = _84;
    }
    float _309 = _121 ? _222 : _86;
    bool _310 = cb6[0u].y > 0.0f;
    bool _312 = cb6[12u].x > 0.0f;
    float _1155;
    float _1158;
    float _1161;
    float _1164;
    float _1165;
    if (_310) {
      float _532 = floor(_308 * 2.5f) * 0.4000000059604644775390625f;
      float _537 = floor(_309 * 10.0f) * 0.100000001490116119384765625f;
      float _539 = _532 + 0.20000000298023223876953125f;
      float _541 = _537 + 0.0500000007450580596923828125f;
      float _546 = floor((cb6[0u].y * 20.0f) + (cb0[0u].x * 2.0f));
      float _547 = _546 * 0.00999999977648258209228515625f;
      float _556 = (((_547 + 1.0f) - (floor(_546 * 9.9999997473787516355514526367188e-05f) * 100.0f)) * 0.00999999977648258209228515625f) + _539;
      float _562 = (((_546 + 1.0f) - (floor(_547) * 100.0f)) * 0.00999999977648258209228515625f) + _541;
      float _564 = frac(_556 * 0.103100001811981201171875f);
      float _566 = frac(_562 * 0.103100001811981201171875f);
      float _567 = _564 + 33.3300018310546875f;
      float _569 = dot(float3(_564, _566, _564), float3(_566 + 33.3300018310546875f, _567, _567));
      float _577 = frac(((_566 + _564) + (_569 * 2.0f)) * (_569 + _564));
      float _584 = (((cb6[0u].y * 0.75f) + (-0.100000001490116119384765625f)) * (1.0f - _577)) + _577;
      float _590 = round(_584 - (_584 * (0.5f - (cb6[0u].y * 0.375f))));
      float _592 = _308 - _539;
      float _593 = _309 - _541;
      float _594 = _556 * _539;
      float _595 = _562 * _541;
      float _598 = _556 * (_532 + 0.300000011920928955078125f);
      float _601 = _562 * (_537 + 0.1500000059604644775390625f);
      float _603 = frac(_594 * 0.103100001811981201171875f);
      float _605 = frac(_595 * 0.103100001811981201171875f);
      float _606 = _603 + 33.3300018310546875f;
      float _608 = dot(float3(_603, _605, _603), float3(_605 + 33.3300018310546875f, _606, _606));
      float _613 = frac((_594 + 0.100000001490116119384765625f) * 0.103100001811981201171875f);
      float _616 = frac((_595 + 0.100000001490116119384765625f) * 0.103100001811981201171875f);
      float _617 = _613 + 33.3300018310546875f;
      float _619 = dot(float3(_613, _616, _613), float3(_616 + 33.3300018310546875f, _617, _617));
      float _631 = floor(frac(((_605 + _603) + (_608 * 2.0f)) * (_608 + _603)) * 3.25f) * 0.100000001490116119384765625f;
      float _640 = floor(frac(((_616 + _613) + (_619 * 2.0f)) * (_619 + _613)) * 3.25f) * 0.02500000037252902984619140625f;
      float _642 = _631 + (-0.20000000298023223876953125f);
      float _644 = _640 + (-0.0500000007450580596923828125f);
      float _647 = frac(_598 * 0.103100001811981201171875f);
      float _649 = frac(_601 * 0.103100001811981201171875f);
      float _650 = _647 + 33.3300018310546875f;
      float _652 = dot(float3(_647, _649, _647), float3(_649 + 33.3300018310546875f, _650, _650));
      float _657 = frac((_598 + 0.100000001490116119384765625f) * 0.103100001811981201171875f);
      float _660 = frac((_601 + 0.100000001490116119384765625f) * 0.103100001811981201171875f);
      float _661 = _657 + 33.3300018310546875f;
      float _663 = dot(float3(_657, _660, _657), float3(_660 + 33.3300018310546875f, _661, _661));
      float _674 = floor(frac(((_649 + _647) + (_652 * 2.0f)) * (_652 + _647)) * 3.25f) * 0.100000001490116119384765625f;
      float _683 = floor(frac(((_660 + _657) + (_663 * 2.0f)) * (_663 + _657)) * 3.25f) * 0.02500000037252902984619140625f;
      float _684 = _674 + (-0.20000000298023223876953125f);
      float _685 = _683 + (-0.0500000007450580596923828125f);
      float _686 = _592 - _642;
      float _687 = _593 - _644;
      float _688 = (-0.0250000059604644775390625f) - _592;
      float _690 = _631 + _688;
      float _691 = (-0.006250001490116119384765625f) - _593;
      float _693 = _640 + _691;
      uint _717 = (((((uint(_690 > 0.0f) + ((_690 < 0.0f) ? 4294967295u : 0u)) + ((_686 < 0.0f) ? 4294967295u : 0u)) + uint(_686 > 0.0f)) + ((_687 < 0.0f) ? 4294967295u : 0u)) + uint(_687 > 0.0f)) + (uint(_693 > 0.0f) - uint(_693 < 0.0f));
      float _725 = min(float(int(uint(int(_717) > int(3u)) - uint(int(_717) < int(3u)))), 0.0f);
      float _726 = _592 - _684;
      float _727 = _593 - _685;
      float _728 = _674 + _688;
      float _729 = _683 + _691;
      uint _752 = (((((uint(_728 > 0.0f) + ((_728 < 0.0f) ? 4294967295u : 0u)) + ((_726 < 0.0f) ? 4294967295u : 0u)) + uint(_726 > 0.0f)) + ((_727 < 0.0f) ? 4294967295u : 0u)) + uint(_727 > 0.0f)) + (uint(_729 > 0.0f) - uint(_729 < 0.0f));
      float _759 = min(float(int(uint(int(_752) > int(3u)) - uint(int(_752) < int(3u)))), 0.0f);
      float _765 = (_590 * _590) * 1.2000000476837158203125f;
      float _768 = (_765 * ((_759 * (_642 - _684)) + ((_684 - _642) * _725))) + _308;
      float _775 = (_765 * (((_644 - _685) * _759) + ((_685 - _644) * _725))) + _309;
      uint _776 = uint(_84);
      uint _777 = uint(_86);
      float4 _778 = _8.Load(int3(uint2(_776, _777), 0u));
      float _780 = _778.y;
      float _968;
      if (_312) {
        uint _884 = 1u << (_12.Load(int3(uint2(uint(cb12[79u].x * float(_776)), uint(cb12[79u].y * float(_777))), 0u)).y & 31u);
        float4 _887 = _14.Load(int3(uint2(_776 & 255u, _777 & 255u), 0u));
        float _890 = _887.y;
        float _894 = ((_887.x + _890) + _887.z) * 0.3333333432674407958984375f;
        float _895 = cb6[12u].x * _780;
        float _896 = _890 - _894;
        float _897 = _894 + (-0.5f);
        float _962 = ((((((float(min((asuint(cb6[17u].x) & _884), 1u)) * cb6[18u].y) * ((_896 * cb6[18u].w) + _897)) + 1.0f) * (_895 / max(1.0f - _895, 9.9999999747524270787835121154785e-07f))) * (((((cb6[19u].w * _896) + _897) * cb6[19u].y) * float(min((asuint(cb6[17u].y) & _884), 1u))) + 1.0f)) * (((((cb6[20u].w * _896) + _897) * cb6[20u].y) * float(min((asuint(cb6[17u].z) & _884), 1u))) + 1.0f)) * (((((cb6[21u].w * _896) + _897) * cb6[21u].y) * float(min((asuint(cb6[17u].w) & _884), 1u))) + 1.0f);
        _968 = (_962 / max(_962 + 1.0f, 1.0f)) * cb6[12u].y;
      } else {
        _968 = _780;
      }
      float _969 = cb6[0u].y * _968;
      float _971 = (_768 + (-0.5f)) + _969;
      float _973 = _969 + (0.5f - _775);
      float _975 = atan(_973 / _971);
      bool _976 = _971 < 0.0f;
      bool _977 = _971 == 0.0f;
      bool _978 = _973 >= 0.0f;
      bool _979 = _973 < 0.0f;
      float _983 = sqrt((_971 * _971) + (_973 * _973));
      float _1271;
      if (_977 && _978) {
        _1271 = 1.57079637050628662109375f;
      } else {
        float frontier_phi_28_29_ladder;
        if (_977 && _979) {
          frontier_phi_28_29_ladder = -1.57079637050628662109375f;
        } else {
          float frontier_phi_28_29_ladder_39_ladder;
          if (_976 && _979) {
            frontier_phi_28_29_ladder_39_ladder = _975 + (-3.1415927410125732421875f);
          } else {
            frontier_phi_28_29_ladder_39_ladder = (_976 && _978) ? (_975 + 3.1415927410125732421875f) : _975;
          }
          frontier_phi_28_29_ladder = frontier_phi_28_29_ladder_39_ladder;
        }
        _1271 = frontier_phi_28_29_ladder;
      }
      float _1280 = min(max((_968 * 0.5f) * cb6[0u].y, 0.0f), 1.0f) + _1271;
      uint _1286 = uint(frac((cos(_1280) * _983) + 0.5f) * _80);
      uint _1292 = uint(frac(0.5f - (sin(_1280) * _983)) * _81);
      float4 _1293 = _8.Load(int3(uint2(_1286, _1292), 0u));
      float _1163 = _1293.x;
      float _1160 = _1293.y;
      float _1157 = _1293.z;
      float frontier_phi_23_28_ladder;
      float frontier_phi_23_28_ladder_1;
      float frontier_phi_23_28_ladder_2;
      float frontier_phi_23_28_ladder_3;
      float frontier_phi_23_28_ladder_4;
      if (_312) {
        uint _1455 = 1u << (_12.Load(int3(uint2(uint(cb12[79u].x * float(_1286)), uint(cb12[79u].y * float(_1292))), 0u)).y & 31u);
        float4 _1458 = _14.Load(int3(uint2(_1286 & 255u, _1292 & 255u), 0u));
        float _1460 = _1458.x;
        float _1461 = _1458.y;
        float _1462 = _1458.z;
        float _1465 = ((_1460 + _1461) + _1462) * 0.3333333432674407958984375f;
        float _1466 = cb6[12u].x * _1163;
        float _1467 = cb6[12u].x * _1160;
        float _1468 = cb6[12u].x * _1157;
        float _1469 = _1460 - _1465;
        float _1470 = _1461 - _1465;
        float _1471 = _1462 - _1465;
        float _1472 = _1465 + (-0.5f);
        float _1485 = float(min((asuint(cb6[17u].x) & _1455), 1u));
        float _1488 = float(min((asuint(cb6[17u].y) & _1455), 1u));
        float _1491 = float(min((asuint(cb6[17u].z) & _1455), 1u));
        float _1494 = float(min((asuint(cb6[17u].w) & _1455), 1u));
        float _1537 = ((((((cb6[18u].x * _1485) * ((cb6[18u].w * _1469) + _1472)) + 1.0f) * (_1466 / max(1.0f - _1466, 9.9999999747524270787835121154785e-07f))) * (((cb6[19u].x * _1488) * ((cb6[19u].w * _1469) + _1472)) + 1.0f)) * (((cb6[20u].x * _1491) * ((cb6[20u].w * _1469) + _1472)) + 1.0f)) * (((cb6[21u].x * _1494) * ((cb6[21u].w * _1469) + _1472)) + 1.0f);
        float _1568 = ((((((cb6[18u].y * _1485) * ((cb6[18u].w * _1470) + _1472)) + 1.0f) * (_1467 / max(1.0f - _1467, 9.9999999747524270787835121154785e-07f))) * (((cb6[19u].y * _1488) * ((cb6[19u].w * _1470) + _1472)) + 1.0f)) * (((cb6[20u].y * _1491) * ((cb6[20u].w * _1470) + _1472)) + 1.0f)) * (((cb6[21u].y * _1494) * ((cb6[21u].w * _1470) + _1472)) + 1.0f);
        float _1599 = ((((((cb6[18u].z * _1485) * ((cb6[18u].w * _1471) + _1472)) + 1.0f) * (_1468 / max(1.0f - _1468, 9.9999999747524270787835121154785e-07f))) * (((cb6[19u].z * _1488) * ((cb6[19u].w * _1471) + _1472)) + 1.0f)) * (((cb6[20u].z * _1491) * ((cb6[20u].w * _1471) + _1472)) + 1.0f)) * (((cb6[21u].z * _1494) * ((cb6[21u].w * _1471) + _1472)) + 1.0f);
        frontier_phi_23_28_ladder = _768;
        frontier_phi_23_28_ladder_1 = _775;
        frontier_phi_23_28_ladder_2 = (_1537 / max(_1537 + 1.0f, 1.0f)) * cb6[12u].y;
        frontier_phi_23_28_ladder_3 = (_1568 / max(_1568 + 1.0f, 1.0f)) * cb6[12u].y;
        frontier_phi_23_28_ladder_4 = (_1599 / max(_1599 + 1.0f, 1.0f)) * cb6[12u].y;
      } else {
        frontier_phi_23_28_ladder = _768;
        frontier_phi_23_28_ladder_1 = _775;
        frontier_phi_23_28_ladder_2 = _1163;
        frontier_phi_23_28_ladder_3 = _1160;
        frontier_phi_23_28_ladder_4 = _1157;
      }
      _1155 = frontier_phi_23_28_ladder_4;
      _1158 = frontier_phi_23_28_ladder_3;
      _1161 = frontier_phi_23_28_ladder_2;
      _1164 = frontier_phi_23_28_ladder_1;
      _1165 = frontier_phi_23_28_ladder;
    } else {
      float4 _781 = _8.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
      float _783 = _781.x;
      float _784 = _781.y;
      float _785 = _781.z;
      float frontier_phi_23_15_ladder;
      float frontier_phi_23_15_ladder_1;
      float frontier_phi_23_15_ladder_2;
      float frontier_phi_23_15_ladder_3;
      float frontier_phi_23_15_ladder_4;
      if (_312) {
        uint _997 = 1u << (_12.Load(int3(uint2(uint(cb12[79u].x * _70), uint(cb12[79u].y * _71)), 0u)).y & 31u);
        float4 _1000 = _14.Load(int3(uint2(gl_GlobalInvocationID.x & 255u, gl_GlobalInvocationID.y & 255u), 0u));
        float _1002 = _1000.x;
        float _1003 = _1000.y;
        float _1004 = _1000.z;
        float _1007 = ((_1002 + _1003) + _1004) * 0.3333333432674407958984375f;
        float _1008 = cb6[12u].x * _783;
        float _1009 = cb6[12u].x * _784;
        float _1010 = cb6[12u].x * _785;
        float _1011 = _1002 - _1007;
        float _1012 = _1003 - _1007;
        float _1013 = _1004 - _1007;
        float _1014 = _1007 + (-0.5f);
        float _1027 = float(min((asuint(cb6[17u].x) & _997), 1u));
        float _1030 = float(min((asuint(cb6[17u].y) & _997), 1u));
        float _1033 = float(min((asuint(cb6[17u].z) & _997), 1u));
        float _1036 = float(min((asuint(cb6[17u].w) & _997), 1u));
        float _1079 = ((((((cb6[18u].x * _1027) * ((cb6[18u].w * _1011) + _1014)) + 1.0f) * (_1008 / max(1.0f - _1008, 9.9999999747524270787835121154785e-07f))) * (((cb6[19u].x * _1030) * ((cb6[19u].w * _1011) + _1014)) + 1.0f)) * (((cb6[20u].x * _1033) * ((cb6[20u].w * _1011) + _1014)) + 1.0f)) * (((cb6[21u].x * _1036) * ((cb6[21u].w * _1011) + _1014)) + 1.0f);
        float _1110 = ((((((cb6[18u].y * _1027) * ((cb6[18u].w * _1012) + _1014)) + 1.0f) * (_1009 / max(1.0f - _1009, 9.9999999747524270787835121154785e-07f))) * (((cb6[19u].y * _1030) * ((cb6[19u].w * _1012) + _1014)) + 1.0f)) * (((cb6[20u].y * _1033) * ((cb6[20u].w * _1012) + _1014)) + 1.0f)) * (((cb6[21u].y * _1036) * ((cb6[21u].w * _1012) + _1014)) + 1.0f);
        float _1141 = ((((((cb6[18u].z * _1027) * ((cb6[18u].w * _1013) + _1014)) + 1.0f) * (_1010 / max(1.0f - _1010, 9.9999999747524270787835121154785e-07f))) * (((cb6[19u].z * _1030) * ((cb6[19u].w * _1013) + _1014)) + 1.0f)) * (((cb6[20u].z * _1033) * ((cb6[20u].w * _1013) + _1014)) + 1.0f)) * (((cb6[21u].z * _1036) * ((cb6[21u].w * _1013) + _1014)) + 1.0f);
        frontier_phi_23_15_ladder = _308;
        frontier_phi_23_15_ladder_1 = _309;
        frontier_phi_23_15_ladder_2 = (_1079 / max(_1079 + 1.0f, 1.0f)) * cb6[12u].y;
        frontier_phi_23_15_ladder_3 = (_1110 / max(_1110 + 1.0f, 1.0f)) * cb6[12u].y;
        frontier_phi_23_15_ladder_4 = (_1141 / max(_1141 + 1.0f, 1.0f)) * cb6[12u].y;
      } else {
        frontier_phi_23_15_ladder = _308;
        frontier_phi_23_15_ladder_1 = _309;
        frontier_phi_23_15_ladder_2 = _783;
        frontier_phi_23_15_ladder_3 = _784;
        frontier_phi_23_15_ladder_4 = _785;
      }
      _1155 = frontier_phi_23_15_ladder_4;
      _1158 = frontier_phi_23_15_ladder_3;
      _1161 = frontier_phi_23_15_ladder_2;
      _1164 = frontier_phi_23_15_ladder_1;
      _1165 = frontier_phi_23_15_ladder;
    }
    bool _1169 = cb6[1u].z > 0.0f;
    float _1304;
    if (_1169 && (asuint(cb6[13u].z) != 0u)) {
      _1304 = ((asfloat(_22.Load(6u).x) + (-1.0f)) * cb6[1u].z) + 1.0f;
    } else {
      _1304 = 1.0f;
    }
    float _1305 = _1165 + (-0.5f);
    float _1307 = (_1164 + (-0.5f)) * 2.0f;
    float _1314 = _1165 - (((_1307 * _1307) * _1305) * cb6[3u].x);
    float _1320 = _1164 - ((((_1305 * _1305) * 2.0f) * _1307) * cb6[3u].y);
    float _1322 = (_1314 + (-0.5f)) * 2.0f;
    float _1324 = (_1320 + (-0.5f)) * 2.0f;
    float _1325 = cb0[0u].x * 0.004999999888241291046142578125f;
    float _1330 = (min(max(_1320, 0.0f), 1.0f) + 1.0f) - _1325;
    float _1336 = min(max(abs(cos(_1330 * 650.0f)), 0.0f), 1.0f);
    float _1339 = min(max(_1314, 0.0f), 1.0f) + 1.0f;
    float _1340 = _1339 - _1325;
    float _1341 = sin(cb0[0u].x);
    float _1342 = _1339 + _1325;
    float _1368 = min(max((((_1341 * 0.20000000298023223876953125f) + 0.540000021457672119140625f) + ((min(max(abs(cos(_1340 * 250.0f)), 0.0f), 1.0f) + min(max(abs(cos(_1342 * 550.0f)), 0.0f), 1.0f)) * 0.1799999773502349853515625f)) * ((_1336 * 0.39999997615814208984375f) + 0.60000002384185791015625f), 0.0f), 1.0f);
    float _1640;
    float _1642;
    float _1644;
    if (cb6[1u].w > 0.0f) {
      float4 _1612 = _18.SampleLevel(_45, float2(_84, _86), 0.0f);
      float _1624 = (min(max(abs(cos(_1330 * 250.0f)), 0.0f), 1.0f) * 0.0007999999797903001308441162109375f) + 0.00120000005699694156646728515625f;
      float _1628 = (_1336 * 0.001199999940581619739532470703125f) + 0.001800000085495412349700927734375f;
      float _1631 = (_1612.x - _1628) + _1624;
      float _1633 = (_1612.y - _1628) + _1624;
      float _1635 = (_1612.z - _1628) + _1624;
      float _1801;
      float _1802;
      float _1803;
      if (cb6[6u].x > 0.0f) {
        float _1791 = min(max((sqrt((_124 * _124) + (_122 * _122)) - cb6[5u].z) / (cb6[5u].w - cb6[5u].z), 0.0f), 1.0f);
        float _1797 = 1.0f - (((_1791 * _1791) * (3.0f - (_1791 * 2.0f))) * cb6[6u].x);
        _1801 = _1797 * _1631;
        _1802 = _1797 * _1633;
        _1803 = _1797 * _1635;
      } else {
        _1801 = _1631;
        _1802 = _1633;
        _1803 = _1635;
      }
      float _1804 = dot(float3(_1801, _1802, _1803), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      _1640 = ((cb6[6u].y * (_1801 - _1804)) + _1804) * cb6[1u].w;
      _1642 = ((cb6[6u].y * (_1802 - _1804)) + _1804) * cb6[1u].w;
      _1644 = ((cb6[6u].y * (_1803 - _1804)) + _1804) * cb6[1u].w;
    } else {
      _1640 = 0.0f;
      _1642 = 0.0f;
      _1644 = 0.0f;
    }
    float _1833;
    float _1834;
    float _1835;
    if (cb6[2u].x > 0.0f) {
      float4 _1822 = _17.SampleLevel(_45, float2(_1314, 1.0f - _1320), 0.0f);

      // Custom
      if (injectedData.toneMapGammaCorrection == 1.f) {
        _1822 = pow(renodx::color::srgb::Encode(max(0, _1822)), 2.2f);
      }

      _1833 = (cb6[2u].x * _1822.x) + _1640;
      _1834 = (cb6[2u].x * _1822.y) + _1642;
      _1835 = (cb6[2u].x * _1822.z) + _1644;
    } else {
      _1833 = _1640;
      _1834 = _1642;
      _1835 = _1644;
    }
    float _1978;
    float _1979;
    float _1980;
    if (_1169) {
      float4 _1941 = _16.SampleLevel(_45, float2(_1165, _1164), 0.0f);
      float4 _1948 = _15.SampleLevel(_45, float2(_1165, _1164), 0.0f);
      float _1953 = _1948.w;
      float _1954 = 1.0f - _1953;
      float _1956 = (_1954 * _1941.w) + _1953;
      _1978 = (((_1956 * ((_1948.x - _1161) + (_1954 * _1941.x))) + _1161) * cb6[1u].z) + _1833;
      _1979 = (((_1956 * ((_1948.y - _1158) + (_1954 * _1941.y))) + _1158) * cb6[1u].z) + _1834;
      _1980 = (((_1956 * ((_1948.z - _1155) + (_1954 * _1941.z))) + _1155) * cb6[1u].z) + _1835;
    } else {
      _1978 = _1833;
      _1979 = _1834;
      _1980 = _1835;
    }
    float _2121;
    float _2123;
    float _2125;
    if (cb6[1u].x > 0.0f) {
      float _2028 = cb6[6u].w * _1322;
      float _2029 = cb6[6u].w * _1324;
      float4 _2033 = _13.SampleLevel(_45, float2(_2028 + _1314, _2029 + _1320), 0.0f);
      float4 _2037 = _13.SampleLevel(_45, float2(_1314, _1320), 0.0f);
      float4 _2043 = _13.SampleLevel(_45, float2(_1314 - _2028, _1320 - _2029), 0.0f);
      float4 _2056 = _13.SampleLevel(_45, float2((cb6[7u].x * _1322) + _1314, (cb6[7u].y * _1324) + _1320), 1.0f);
      float4 _2067 = _13.SampleLevel(_45, float2((cb6[7u].z * _1322) + _1314, (cb6[7u].w * _1324) + _1320), 2.0f);
      float4 _2082 = _13.SampleLevel(_45, float2((cb6[8u].x * _1322) + _1314, (cb6[8u].y * _1324) + _1320), 4.0f);

      // Custom
      if (injectedData.toneMapGammaCorrection == 1.f) {
        _2033 = pow(renodx::color::srgb::Encode(max(0, _2033)), 2.2f);
        _2037 = pow(renodx::color::srgb::Encode(max(0, _2037)), 2.2f);
        _2043 = pow(renodx::color::srgb::Encode(max(0, _2043)), 2.2f);
        _2056 = pow(renodx::color::srgb::Encode(max(0, _2056)), 2.2f);
        _2067 = pow(renodx::color::srgb::Encode(max(0, _2067)), 2.2f);
        _2082 = pow(renodx::color::srgb::Encode(max(0, _2082)), 2.2f);
      }

      float _2090 = 1.0f - (((_2037.w + _2033.w) + _2043.w) * 0.3333333432674407958984375f);
      float _2102 = min(max((((cb6[8u].z * _2056.x) + (cb6[8u].w * _2067.x)) + (cb6[9u].x * _2082.x)) * _1368, 0.0f), 1.0f) * _2090;
      float _2111 = min(max((((cb6[8u].z * _2056.y) + (cb6[8u].w * _2067.y)) + (cb6[9u].x * _2082.y)) * _1368, 0.0f), 1.0f) * _2090;
      float _2120 = min(max((((cb6[8u].z * _2056.z) + (cb6[8u].w * _2067.z)) + (cb6[9u].x * _2082.z)) * _1368, 0.0f), 1.0f) * _2090;
      float _2188;
      float _2189;
      float _2190;
      if (_1169) {
        float _2184 = 1.0f - (dot(float3(cb6[1u].z * _1161, cb6[1u].z * _1158, cb6[1u].z * _1155), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) * 0.699999988079071044921875f);
        _2188 = _2184 * _2102;
        _2189 = _2184 * _2111;
        _2190 = _2184 * _2120;
      } else {
        _2188 = _2102;
        _2189 = _2111;
        _2190 = _2120;
      }
      float _2191 = dot(float3(_2188, _2189, _2190), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      float _2194 = cb6[1u].x * _1304;
      float _2196 = _1314 - cb6[3u].z;
      float _2198 = _1320 - cb6[3u].w;
      float4 _2200 = _13.SampleLevel(_45, float2(_2196, _2198), 0.0f);
      float _2202 = _2200.w;
      float _2227 = _1341 * 0.00999999977648258209228515625f;
      float _2258 = ((((_2227 + 0.540000021457672119140625f) + (_1341 * 0.100000001490116119384765625f)) + ((min(max(abs(cos(_1340 * 350.0f)), 0.0f), 1.0f) + min(max(abs(cos(_1342 * 350.0f)), 0.0f), 1.0f)) * 0.1799999773502349853515625f)) * ((min(max((cos((_2227 + _1320) * 1700.0f) + 1.0f) * 0.75f, 0.0f), 1.0f) * 0.00850000046193599700927734375f) + 0.00150000001303851604461669921875f)) + 0.9900000095367431640625f;
      float _2261 = (_2033.x * 2.0f) * _2258;
      float _2263 = (_2037.y * 2.0f) * _2258;
      float _2265 = (_2043.z * 2.0f) * _2258;
      float _2266 = dot(float3(_2261, _2263, _2265), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
      float _2272 = cb6[5u].x * _1304;
      float4 _2274 = _19.SampleLevel(_45, float2(_1314, _1320), cb6[5u].y);
      float _2289 = (1.0f - (min(max(exp2(log2(abs(((_19.SampleLevel(_45, float2(_2196, _2198), cb6[4u].y + (-1.0f)).w - _2202) * min(max(cb6[4u].y, 0.0f), 1.0f)) + _2202)) * 0.819999992847442626953125f), 0.0f), 1.0f) * cb6[4u].x)) * _2090;
      _2121 = ((((cb6[6u].z * (_2261 - _2266)) + _2266) * _1304) + (_2274.x * _2272)) + (_2289 * ((((cb6[6u].z * (_2188 - _2191)) + _2191) * _2194) + _1978));
      _2123 = ((((cb6[6u].z * (_2263 - _2266)) + _2266) * _1304) + (_2274.y * _2272)) + (_2289 * ((((cb6[6u].z * (_2189 - _2191)) + _2191) * _2194) + _1979));
      _2125 = ((((cb6[6u].z * (_2265 - _2266)) + _2266) * _1304) + (_2274.z * _2272)) + (_2289 * ((((cb6[6u].z * (_2190 - _2191)) + _2191) * _2194) + _1980));
    } else {
      _2121 = _1978;
      _2123 = _1979;
      _2125 = _1980;
    }
    float _105;
    float _108;
    float _111;
    if (cb6[1u].y > 0.0f) {
      float4 _2317 = _13.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
      float _2323 = (_1304 * 2.0f) * cb6[1u].y;
      _111 = (_2323 * _2317.x) + _2121;
      _108 = (_2323 * _2317.y) + _2123;
      _105 = (_2323 * _2317.z) + _2125;
    } else {
      _111 = _2121;
      _108 = _2123;
      _105 = _2125;
    }
    float frontier_phi_3_82_ladder;
    float frontier_phi_3_82_ladder_1;
    float frontier_phi_3_82_ladder_2;
    if (_310) {
      float _2352 = ((_70 / _80) * 0.800000011920928955078125f) * (_80 / _81);
      float _2354 = (_71 / _81) * 5.0f;
      float _2402;
      float _2404;
      float _2406;
      float _2408;
      float _2410;
      float _2412;
      uint _2414;
      _2402 = 1.0f;
      _2404 = 1.0f;
      _2406 = 1.0f;
      _2408 = _2352;
      _2410 = _2354;
      _2412 = 1.0f;
      _2414 = 1u;
      float _2403;
      float _2405;
      float _2407;
      uint _2415;
      float _2417;
      float _2418;
      float _2445;
      float _2448;
      float _2451;
      float _2462;
      for (;;) {
        float _2416 = float(int(_2414));
        _2417 = _2416 + _2408;
        _2418 = _2416 + _2410;
        float _2419 = floor(_2417);
        float _2420 = floor(_2418);
        float _2422 = frac(_2419 * 0.103100001811981201171875f);
        float _2425 = frac(_2420 * 0.10300000011920928955078125f);
        float _2428 = frac(_2419 * 0.097300000488758087158203125f);
        float _2431 = frac(_2420 * 0.109899997711181640625f);
        float _2436 = dot(float4(_2422, _2425, _2428, _2431), float4(_2431 + 33.3300018310546875f, _2428 + 33.3300018310546875f, _2422 + 33.3300018310546875f, _2425 + 33.3300018310546875f));
        float _2439 = _2436 + _2422;
        float _2440 = _2436 + _2425;
        float _2441 = _2436 + _2428;
        float _2442 = _2436 + _2431;
        _2445 = frac((_2439 + _2440) * _2441);
        _2448 = frac((_2439 + _2441) * _2440);
        _2451 = frac((_2440 + _2441) * _2442);
        bool _2455 = frac((_2441 + _2442) * _2439) > 0.5f;
        _2403 = (_2455 ? _2445 : 1.0f) * _2402;
        _2405 = (_2455 ? _2448 : 1.0f) * _2404;
        _2407 = (_2455 ? _2451 : 1.0f) * _2406;
        _2415 = _2414 + 1u;
        _2462 = cb0[0u].x;
        if (_2415 == 15u) {
          break;
        } else {
          _2402 = _2403;
          _2404 = _2405;
          _2406 = _2407;
          _2408 = (((_2451 * 0.20000000298023223876953125f) * (frac(_2417) - _2412)) * frac(floor(((_2462 * 0.1500000059604644775390625f) + 300.0f) / _2445) * _2445)) + _2408;
          _2410 = ((_2451 * _2448) * (frac(_2418) - _2412)) + _2410;
          _2412 *= (-2.0f);
          _2414 = _2415;
          continue;
        }
      }
      float _2502 = floor((_2462 * 2.0f) + cb6[0u].y);
      float _2503 = _2502 * 0.00999999977648258209228515625f;
      float _2509 = ((_2503 + 1.0f) - (floor(_2502 * 9.9999997473787516355514526367188e-05f) * 100.0f)) * 0.00999999977648258209228515625f;
      float _2514 = ((_2502 + 1.0f) - (floor(_2503) * 100.0f)) * 0.00999999977648258209228515625f;
      float _2516 = 0.5f - (cb6[0u].y * 0.375f);
      float _2518 = (cb6[0u].y * 0.75f) + (-0.100000001490116119384765625f);
      float _2525 = frac(((_2509 + 0.0500000007450580596923828125f) + (floor(_1165 * 10.0f) * 0.100000001490116119384765625f)) * 0.103100001811981201171875f);
      float _2535 = frac(((_2514 + 0.014999999664723873138427734375f) + (floor(_1164 * 33.33333587646484375f) * 0.02999999932944774627685546875f)) * 0.103100001811981201171875f);
      float _2536 = _2525 + 33.3300018310546875f;
      float _2538 = dot(float3(_2525, _2535, _2525), float3(_2535 + 33.3300018310546875f, _2536, _2536));
      float _2546 = frac(((_2535 + _2525) + (_2538 * 2.0f)) * (_2538 + _2525));
      float _2549 = ((1.0f - _2546) * _2518) + _2546;
      float _2559 = frac(((_2509 + 0.04500000178813934326171875f) + (floor(_1165 * 11.111110687255859375f) * 0.0900000035762786865234375f)) * 0.103100001811981201171875f);
      float _2568 = frac(((_2514 + 0.0199999995529651641845703125f) + (floor(_1164 * 25.0f) * 0.039999999105930328369140625f)) * 0.103100001811981201171875f);
      float _2569 = _2559 + 33.3300018310546875f;
      float _2571 = dot(float3(_2559, _2568, _2559), float3(_2568 + 33.3300018310546875f, _2569, _2569));
      float _2579 = frac(((_2568 + _2559) + (_2571 * 2.0f)) * (_2571 + _2559));
      float _2582 = ((1.0f - _2579) * _2518) + _2579;
      float _2583 = max(0.0f, _2403);
      float _2584 = max(0.0f, _2405);
      float _2585 = max(0.0f, _2407);
      float _2587 = max(_2583, max(_2584, _2585));
      float _2588 = _2587 * _2587;
      float _2589 = _2583 * 2.0f;
      float _2590 = _2584 * 0.100000001490116119384765625f;
      float _2591 = _2585 * 0.25f;
      float _2603 = min(max((round(_2549 - (_2549 * _2516)) * 5.0f) * round(_2582 - (_2582 * _2516)), 0.0f), 1.0f) * 3.0f;
      frontier_phi_3_82_ladder = (_2603 * ((_2589 - _111) + (_2588 * _2589))) + _111;
      frontier_phi_3_82_ladder_1 = (_2603 * ((_2590 - _108) + (_2588 * _2590))) + _108;
      frontier_phi_3_82_ladder_2 = (_2603 * ((_2591 - _105) + (_2588 * _2591))) + _105;
    } else {
      frontier_phi_3_82_ladder = _111;
      frontier_phi_3_82_ladder_1 = _108;
      frontier_phi_3_82_ladder_2 = _105;
    }
    _102 = frontier_phi_3_82_ladder_2;
    _106 = frontier_phi_3_82_ladder_1;
    _109 = frontier_phi_3_82_ladder;
  }
  bool _117 = asuint(cb6[15u].x) == 0u;
  float _250;
  float _252;
  float _254;
  if (_117) {
    _250 = 0.0f;
    _252 = 0.0f;
    _254 = 0.0f;
  } else {
    float4 _261 = _8.Load(int3(uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y), 0u));
    float _264 = _261.x;
    float _265 = _261.y;
    float _266 = _261.z;
    float _526;
    float _527;
    float _528;
    if (cb6[12u].x > 0.0f) {
      uint _360 = 1u << (_12.Load(int3(uint2(uint(cb12[79u].x * _70), uint(cb12[79u].y * _71)), 0u)).y & 31u);
      float4 _364 = _14.Load(int3(uint2(gl_GlobalInvocationID.x & 255u, gl_GlobalInvocationID.y & 255u), 0u));
      float _366 = _364.x;
      float _367 = _364.y;
      float _368 = _364.z;
      float _371 = ((_366 + _367) + _368) * 0.3333333432674407958984375f;
      float _373 = cb6[12u].x * _264;
      float _374 = cb6[12u].x * _265;
      float _375 = cb6[12u].x * _266;
      float _376 = _366 - _371;
      float _377 = _367 - _371;
      float _378 = _368 - _371;
      float _379 = _371 + (-0.5f);
      float _393 = float(min((asuint(cb6[17u].x) & _360), 1u));
      float _396 = float(min((asuint(cb6[17u].y) & _360), 1u));
      float _399 = float(min((asuint(cb6[17u].z) & _360), 1u));
      float _402 = float(min((asuint(cb6[17u].w) & _360), 1u));
      float _450 = ((((((cb6[18u].x * _393) * ((cb6[18u].w * _376) + _379)) + 1.0f) * (_373 / max(1.0f - _373, 9.9999999747524270787835121154785e-07f))) * (((cb6[19u].x * _396) * ((cb6[19u].w * _376) + _379)) + 1.0f)) * (((cb6[20u].x * _399) * ((cb6[20u].w * _376) + _379)) + 1.0f)) * (((cb6[21u].x * _402) * ((cb6[21u].w * _376) + _379)) + 1.0f);
      float _481 = ((((((cb6[18u].y * _393) * ((cb6[18u].w * _377) + _379)) + 1.0f) * (_374 / max(1.0f - _374, 9.9999999747524270787835121154785e-07f))) * (((cb6[19u].y * _396) * ((cb6[19u].w * _377) + _379)) + 1.0f)) * (((cb6[20u].y * _399) * ((cb6[20u].w * _377) + _379)) + 1.0f)) * (((cb6[21u].y * _402) * ((cb6[21u].w * _377) + _379)) + 1.0f);
      float _512 = ((((((cb6[18u].z * _393) * ((cb6[18u].w * _378) + _379)) + 1.0f) * (_375 / max(1.0f - _375, 9.9999999747524270787835121154785e-07f))) * (((cb6[19u].z * _396) * ((cb6[19u].w * _378) + _379)) + 1.0f)) * (((cb6[20u].z * _399) * ((cb6[20u].w * _378) + _379)) + 1.0f)) * (((cb6[21u].z * _402) * ((cb6[21u].w * _378) + _379)) + 1.0f);
      _526 = (_450 / max(_450 + 1.0f, 1.0f)) * cb6[12u].y;
      _527 = (_481 / max(_481 + 1.0f, 1.0f)) * cb6[12u].y;
      _528 = (_512 / max(_512 + 1.0f, 1.0f)) * cb6[12u].y;
    } else {
      _526 = _264;
      _527 = _265;
      _528 = _266;
    }
    float frontier_phi_6_13_ladder;
    float frontier_phi_6_13_ladder_1;
    float frontier_phi_6_13_ladder_2;
    if (_93) {
      frontier_phi_6_13_ladder = 0.0f;
      frontier_phi_6_13_ladder_1 = 0.0f;
      frontier_phi_6_13_ladder_2 = 0.0f;
    } else {
      float4 _836 = _16.SampleLevel(_45, float2(_84, _86), 0.0f);
      float4 _843 = _15.SampleLevel(_45, float2(_84, _86), 0.0f);
      float _848 = _843.w;
      float _849 = 1.0f - _848;
      float _851 = (_849 * _836.w) + _848;
      frontier_phi_6_13_ladder = ((_851 * ((_843.y - _527) + (_849 * _836.y))) + _527) * cb6[1u].z;
      frontier_phi_6_13_ladder_1 = ((_851 * ((_843.z - _528) + (_849 * _836.z))) + _528) * cb6[1u].z;
      frontier_phi_6_13_ladder_2 = ((_851 * ((_843.x - _526) + (_849 * _836.x))) + _526) * cb6[1u].z;
    }
    _250 = frontier_phi_6_13_ladder_2;
    _252 = frontier_phi_6_13_ladder;
    _254 = frontier_phi_6_13_ladder_1;
  }
  float _331;
  float _333;
  float _335;
  if (cb6[14u].w > 0.0f) {
    uint _320 = asuint(cb6[10u].x);
    uint _321 = asuint(cb6[10u].y);
    uint _322 = asuint(cb6[10u].z);
    uint _323 = asuint(cb6[10u].w);
    float frontier_phi_11_10_ladder;
    float frontier_phi_11_10_ladder_1;
    float frontier_phi_11_10_ladder_2;
    if ((gl_GlobalInvocationID.y < _323) && ((gl_GlobalInvocationID.y >= _321) && ((gl_GlobalInvocationID.x >= _320) && (gl_GlobalInvocationID.x < _322)))) {
      float4 _809 = _23.SampleLevel(_45, float2(cb6[11u].x + (cb6[11u].z * ((_70 - float(int(_320))) / float(int(_322 - _320)))), cb6[11u].y + (cb6[11u].w * ((_71 - float(int(_321))) / float(int(_323 - _321))))), 0.0f);
      frontier_phi_11_10_ladder = cb6[14u].w * _809.z;
      frontier_phi_11_10_ladder_1 = cb6[14u].w * _809.y;
      frontier_phi_11_10_ladder_2 = cb6[14u].w * _809.x;
    } else {
      frontier_phi_11_10_ladder = _102;
      frontier_phi_11_10_ladder_1 = _106;
      frontier_phi_11_10_ladder_2 = _109;
    }
    _331 = frontier_phi_11_10_ladder_2;
    _333 = frontier_phi_11_10_ladder_1;
    _335 = frontier_phi_11_10_ladder;
  } else {
    _331 = _109;
    _333 = _106;
    _335 = _102;
  }

  uint _343 = asuint(cb6[13u].w);

  float3 outputColor1 = float3(_331, _333, _335);
  if (asuint(cb6[13u].y) != 0u) {
    ConvertColorParams params = {
        _343,        // outputTypeEnum
        cb6[14u].x,  // paperWhiteScaling
        cb6[14u].y,  // blackFloorAdjust
        cb6[14u].z,  // gammaCorrection
        cb6[16u].x,  // pqSaturation
        float3x3(
            cb6[22u].x, cb6[22u].y, cb6[22u].z,
            cb6[23u].x, cb6[23u].y, cb6[23u].z,
            cb6[24u].x, cb6[24u].y, cb6[24u].z),  // pqMatrix
        float3(_70, _71, cb0[0u].x)               // random3
    };
    outputColor1 = convertColor(outputColor1, params);
  }

  _26[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(outputColor1.rgb, 1.0f);

  if (!_117) {
    float3 outputColor2 = float3(_250, _252, _254);
    ConvertColorParams params = {
        _343,        // outputTypeEnum
        cb6[15u].y,  // paperWhiteScaling
        cb6[15u].z,  // blackFloorAdjust
        cb6[15u].w,  // gammaCorrection
        cb6[16u].x,  // pqSaturation
        float3x3(
            cb6[26u].x, cb6[26u].y, cb6[26u].z,
            cb6[27u].x, cb6[27u].y, cb6[27u].z,
            cb6[28u].x, cb6[28u].y, cb6[28u].z),  // pqMatrix
        float3(_70, _71, cb0[0u].x)               // random3
    };

    outputColor2 = convertColor(outputColor2, params);
    _27[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4(outputColor2.rgb, 1.0f);
  }
}

[numthreads(16, 16, 1)] void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
