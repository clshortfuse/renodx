// Film Grain overlay

#include "./colormath.hlsl"
#include "./cp2077.h"
#include "./injectedBuffer.hlsl"

cbuffer _27_29 : register(b0, space0) {
  float4 cb0[30] : packoffset(c0);
};

cbuffer _36_38 : register(b6, space0) {
  float4 cb6[30] : packoffset(c0);
};

cbuffer _32_34 : register(b12, space0) {
  float4 cb12[99] : packoffset(c0);
};

Texture2D<float4> _8 : register(t32, space0);
Texture2D<uint4> _12 : register(t51, space0);
Texture2D<float4> _13 : register(t1, space0);
Texture2D<float4> _14 : register(t2, space0);
Texture2D<float4> _15 : register(t3, space0);
StructuredBuffer<uint> _18 : register(t7, space0);
Texture2D<float4> _19 : register(t10, space0);
RWTexture2D<float4> _22 : register(u0, space0);
RWTexture2D<float4> _23 : register(u1, space0);
SamplerState _41 : register(s0, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;

struct SPIRV_Cross_Input {
  uint3 gl_WorkGroupID : SV_GroupID;
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

void comp_main() {
  uint4 _73 = _18.Load(asuint(cb6[13u]).x + gl_WorkGroupID.x);
  uint _74 = _73.x;
  uint _82 = ((_74 << 4u) & 1048560u) + gl_LocalInvocationID.x;
  uint _83 = ((_74 >> 16u) << 4u) + gl_LocalInvocationID.y;
  float4 _84 = _8.Load(int3(uint2(_82, _83), 0u));
  float _87 = _84.x;
  float _88 = _84.y;
  float _89 = _84.z;
  float _97 = float(_82);
  float _98 = float(_83);
  float _282;
  float _283;
  float _284;
  if (cb6[12u].x > 0.0f) {
    float4 _117 = _13.Load(int3(uint2(_82 & 255u, _83 & 255u), 0u));
    if (injectedData.fxFilmGrain) {
      float3 grainedColor = renodx::effects::ApplyFilmGrain(
          float3(_87, _88, _89),
          _117.xy,
          frac(cb0[0u].x / 1000.f),
          injectedData.fxFilmGrain * 0.03f,
          (cb6[12u].y == 1.f) ? 1.f : (203.f / 100.f)
          // ,injectedData.debugValue02 != 1.f
      );
      _282 = grainedColor.r;
      _283 = grainedColor.g;
      _284 = grainedColor.b;
    } else {
      uint _113 = 1u << (_12.Load(int3(uint2(uint(cb12[79u].x * _97), uint(cb12[79u].y * _98)), 0u)).y & 31u);
      float _119 = _117.x;
      float _120 = _117.y;
      float _121 = _117.z;
      float _124 = ((_119 + _120) + _121) * 0.3333333432674407958984375f;
      float _129 = cb6[12u].x * _87;
      float _130 = cb6[12u].x * _88;
      float _131 = cb6[12u].x * _89;
      float _148 = _119 - _124;
      float _149 = _120 - _124;
      float _150 = _121 - _124;
      float _154 = _124 + (-0.5f);
      uint4 _168 = asuint(cb6[17u]);
      float _172 = float(min((_168.x & _113), 1u));
      float _201 = float(min((_168.y & _113), 1u));
      float _230 = float(min((_168.z & _113), 1u));
      float _259 = float(min((_168.w & _113), 1u));
      float _266 = (((((((_154 + (cb6[18u].w * _148)) * cb6[18u].x) * _172) + 1.0f) * (_129 / max(1.0f - _129, 9.9999999747524270787835121154785e-07f))) * ((((_154 + (cb6[19u].w * _148)) * cb6[19u].x) * _201) + 1.0f)) * ((((_154 + (cb6[20u].w * _148)) * cb6[20u].x) * _230) + 1.0f)) * ((((_154 + (cb6[21u].w * _148)) * cb6[21u].x) * _259) + 1.0f);
      float _267 = (((((((_154 + (cb6[18u].w * _149)) * cb6[18u].y) * _172) + 1.0f) * (_130 / max(1.0f - _130, 9.9999999747524270787835121154785e-07f))) * ((((_154 + (cb6[19u].w * _149)) * cb6[19u].y) * _201) + 1.0f)) * ((((_154 + (cb6[20u].w * _149)) * cb6[20u].y) * _230) + 1.0f)) * ((((_154 + (cb6[21u].w * _149)) * cb6[21u].y) * _259) + 1.0f);
      float _268 = (((((((_154 + (cb6[18u].w * _150)) * cb6[18u].z) * _172) + 1.0f) * (_131 / max(1.0f - _131, 9.9999999747524270787835121154785e-07f))) * ((((_154 + (cb6[19u].w * _150)) * cb6[19u].z) * _201) + 1.0f)) * ((((_154 + (cb6[20u].w * _150)) * cb6[20u].z) * _230) + 1.0f)) * ((((_154 + (cb6[21u].w * _150)) * cb6[21u].z) * _259) + 1.0f);
      _282 = cb6[12u].y * (_266 / max(_266 + 1.0f, 1.0f));
      _283 = cb6[12u].y * (_267 / max(_267 + 1.0f, 1.0f));
      _284 = cb6[12u].y * (_268 / max(_268 + 1.0f, 1.0f));
    }
  } else {
    _282 = _87;
    _283 = _88;
    _284 = _89;
  }
  float _292 = (_97 + 0.5f) / cb6[12u].z;
  float _293 = (_98 + 0.5f) / cb6[12u].w;
  float _308;
  float _310;
  float _312;
  if (((_292 < cb6[9u].y) || (_293 < cb6[9u].z)) || (((1.0f - cb6[9u].y) < _292) || ((1.0f - cb6[9u].z) < _293))) {
    _308 = 0.0f;
    _310 = 0.0f;
    _312 = 0.0f;
  } else {
    float4 _321 = _15.SampleLevel(_41, float2(_292, _293), 0.0f);
    float4 _329 = _14.SampleLevel(_41, float2(_292, _293), 0.0f);
    float _334 = _329.w;
    float _335 = 1.0f - _334;
    float _340 = (_335 * _321.w) + _334;
    _308 = ((_340 * ((_329.x - _282) + (_335 * _321.x))) + _282) * cb6[1u].z;
    _310 = ((_340 * ((_329.y - _283) + (_335 * _321.y))) + _283) * cb6[1u].z;
    _312 = ((_340 * ((_329.z - _284) + (_335 * _321.z))) + _284) * cb6[1u].z;
  }
  float _371;
  float _373;
  float _375;
  if (cb6[14u].w > 0.0f) {
    uint4 _359 = asuint(cb6[10u]);
    uint _360 = _359.x;
    uint _362 = _359.z;
    uint _365 = _359.y;
    uint _368 = _359.w;
    float frontier_phi_6_5_ladder;
    float frontier_phi_6_5_ladder_1;
    float frontier_phi_6_5_ladder_2;
    if ((((_82 >= _360) && (_82 < _362)) && (_83 >= _365)) && (_83 < _368)) {
      float4 _404 = _19.SampleLevel(_41, float2((cb6[11u].z * ((_97 - float(int(_360))) / float(int(_362 - _360)))) + cb6[11u].x, (cb6[11u].w * ((_98 - float(int(_365))) / float(int(_368 - _365)))) + cb6[11u].y), 0.0f);
      frontier_phi_6_5_ladder = _404.x * cb6[14u].w;
      frontier_phi_6_5_ladder_1 = _404.y * cb6[14u].w;
      frontier_phi_6_5_ladder_2 = _404.z * cb6[14u].w;
    } else {
      frontier_phi_6_5_ladder = _308;
      frontier_phi_6_5_ladder_1 = _310;
      frontier_phi_6_5_ladder_2 = _312;
    }
    _371 = frontier_phi_6_5_ladder;
    _373 = frontier_phi_6_5_ladder_1;
    _375 = frontier_phi_6_5_ladder_2;
  } else {
    _371 = _308;
    _373 = _310;
    _375 = _312;
  }
  uint4 _379 = asuint(cb6[13u]);

  // Custom: Use colormath
  /*
  float _409;
  float _415;
  float _421;
  if (_379.y == 0u) {
    _409 = _371;
    _415 = _373;
    _421 = _375;
  } else {
    uint _457 = _379.w;
    float _524;
    float _525;
    float _526;
    if (cb6[14u].z != 1.0f) {
      _524 = exp2(log2(abs(_371)) * cb6[14u].z);
      _525 = exp2(log2(abs(_373)) * cb6[14u].z);
      _526 = exp2(log2(abs(_375)) * cb6[14u].z);
    } else {
      _524 = _371;
      _525 = _373;
      _526 = _375;
    }
    float _536 = frac(_97 * 211.1488037109375f);
    float _537 = frac(_98 * 210.944000244140625f);
    float _538 = frac(cb0[0u].x * 6.227200031280517578125f);
    float _542 = _538 + 33.3300018310546875f;
    float _543 = dot(float3(_536, _537, _538), float3(_537 + 33.3300018310546875f, _536 + 33.3300018310546875f, _542));
    float _547 = _543 + _536;
    float _548 = _543 + _537;
    float _550 = _547 + _548;
    float _556 = frac(_550 * (_543 + _538));
    float _557 = frac((_547 * 2.0f) * _548);
    float _558 = frac(_550 * _547);
    float _564 = frac((_97 + 64.0f) * 211.1488037109375f);
    float _565 = frac((_98 + 64.0f) * 210.944000244140625f);
    float _568 = dot(float3(_564, _565, _538), float3(_565 + 33.3300018310546875f, _564 + 33.3300018310546875f, _542));
    float _571 = _568 + _564;
    float _572 = _568 + _565;
    float _574 = _571 + _572;
    float _579 = frac(_574 * (_568 + _538));
    float _580 = frac((_571 * 2.0f) * _572);
    float _581 = frac(_574 * _571);
    float frontier_phi_8_13_ladder;
    float frontier_phi_8_13_ladder_1;
    float frontier_phi_8_13_ladder_2;
    if (_457 == 0u) {
      float _678 = (_524 <= 0.003130800090730190277099609375f) ? (_524 * 12.9200000762939453125f) : ((exp2(log2(abs(_524)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _679 = (_525 <= 0.003130800090730190277099609375f) ? (_525 * 12.9200000762939453125f) : ((exp2(log2(abs(_525)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _680 = (_526 <= 0.003130800090730190277099609375f) ? (_526 * 12.9200000762939453125f) : ((exp2(log2(abs(_526)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _681 = _678 * 510.0f;
      float _683 = _679 * 510.0f;
      float _684 = _680 * 510.0f;
      frontier_phi_8_13_ladder = (((_556 + (-0.5f)) + (min(min(1.0f, _681), 510.0f - _681) * (_579 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _678;
      frontier_phi_8_13_ladder_1 = (((_557 + (-0.5f)) + (min(min(1.0f, _683), 510.0f - _683) * (_580 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _679;
      frontier_phi_8_13_ladder_2 = (((_558 + (-0.5f)) + (min(min(1.0f, _684), 510.0f - _684) * (_581 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _680;
    } else {
      float frontier_phi_8_13_ladder_19_ladder;
      float frontier_phi_8_13_ladder_19_ladder_1;
      float frontier_phi_8_13_ladder_19_ladder_2;
      if (_457 == 1u) {
        float _770 = mad(0.043306000530719757080078125f, _526, mad(0.329291999340057373046875f, _525, _524 * 0.627402007579803466796875f));
        float _776 = mad(0.011359999887645244598388671875f, _526, mad(0.9195439815521240234375f, _525, _524 * 0.06909500062465667724609375f));
        float _782 = mad(0.89557802677154541015625f, _526, mad(0.08802799880504608154296875f, _525, _524 * 0.0163940005004405975341796875f));
        float _818 = exp2(log2(abs((((clamp(mad(_782, cb6[22u].z, mad(_776, cb6[22u].y, _770 * cb6[22u].x)), 0.0f, 1.0f) - _770) * cb6[16u].x) + _770) * cb6[14u].x)) * 0.1593017578125f);
        float _819 = exp2(log2(abs((((clamp(mad(_782, cb6[23u].z, mad(_776, cb6[23u].y, _770 * cb6[23u].x)), 0.0f, 1.0f) - _776) * cb6[16u].x) + _776) * cb6[14u].x)) * 0.1593017578125f);
        float _820 = exp2(log2(abs((((clamp(mad(_782, cb6[24u].z, mad(_776, cb6[24u].y, _770 * cb6[24u].x)), 0.0f, 1.0f) - _782) * cb6[16u].x) + _782) * cb6[14u].x)) * 0.1593017578125f);
        frontier_phi_8_13_ladder_19_ladder = exp2(log2(abs(((_818 * 18.8515625f) + 0.8359375f) / ((_818 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_8_13_ladder_19_ladder_1 = exp2(log2(abs(((_819 * 18.8515625f) + 0.8359375f) / ((_819 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_8_13_ladder_19_ladder_2 = exp2(log2(abs(((_820 * 18.8515625f) + 0.8359375f) / ((_820 * 18.6875f) + 1.0f))) * 78.84375f);
      } else {
        float frontier_phi_8_13_ladder_19_ladder_23_ladder;
        float frontier_phi_8_13_ladder_19_ladder_23_ladder_1;
        float frontier_phi_8_13_ladder_19_ladder_23_ladder_2;
        if (_457 == 2u) {
          frontier_phi_8_13_ladder_19_ladder_23_ladder = _524 * cb6[14u].x;
          frontier_phi_8_13_ladder_19_ladder_23_ladder_1 = _525 * cb6[14u].x;
          frontier_phi_8_13_ladder_19_ladder_23_ladder_2 = _526 * cb6[14u].x;
        } else {
          float frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder;
          float frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_1;
          float frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_2;
          if (_457 == 3u) {
            float _933 = mad(_526, cb6[22u].z, mad(_525, cb6[22u].y, _524 * cb6[22u].x)) * cb6[14u].x;
            float _934 = mad(_526, cb6[23u].z, mad(_525, cb6[23u].y, _524 * cb6[23u].x)) * cb6[14u].x;
            float _935 = mad(_526, cb6[24u].z, mad(_525, cb6[24u].y, _524 * cb6[24u].x)) * cb6[14u].x;
            float _960 = (_933 <= 0.003130800090730190277099609375f) ? (_933 * 12.9200000762939453125f) : ((exp2(log2(abs(_933)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _961 = (_934 <= 0.003130800090730190277099609375f) ? (_934 * 12.9200000762939453125f) : ((exp2(log2(abs(_934)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _962 = (_935 <= 0.003130800090730190277099609375f) ? (_935 * 12.9200000762939453125f) : ((exp2(log2(abs(_935)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _963 = _960 * 2046.0f;
            float _965 = _961 * 2046.0f;
            float _966 = _962 * 2046.0f;
            frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder = (((_556 + (-0.5f)) + (min(min(1.0f, _963), 2046.0f - _963) * (_579 + (-0.5f)))) * 0.000977517105638980865478515625f) + _960;
            frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_1 = (((_557 + (-0.5f)) + (min(min(1.0f, _965), 2046.0f - _965) * (_580 + (-0.5f)))) * 0.000977517105638980865478515625f) + _961;
            frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_2 = (((_558 + (-0.5f)) + (min(min(1.0f, _966), 2046.0f - _966) * (_581 + (-0.5f)))) * 0.000977517105638980865478515625f) + _962;
          } else {
            frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder = (_524 * cb6[14u].x) + cb6[14u].y;
            frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_1 = (_525 * cb6[14u].x) + cb6[14u].y;
            frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_2 = (_526 * cb6[14u].x) + cb6[14u].y;
          }
          frontier_phi_8_13_ladder_19_ladder_23_ladder = frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder;
          frontier_phi_8_13_ladder_19_ladder_23_ladder_1 = frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_1;
          frontier_phi_8_13_ladder_19_ladder_23_ladder_2 = frontier_phi_8_13_ladder_19_ladder_23_ladder_27_ladder_2;
        }
        frontier_phi_8_13_ladder_19_ladder = frontier_phi_8_13_ladder_19_ladder_23_ladder;
        frontier_phi_8_13_ladder_19_ladder_1 = frontier_phi_8_13_ladder_19_ladder_23_ladder_1;
        frontier_phi_8_13_ladder_19_ladder_2 = frontier_phi_8_13_ladder_19_ladder_23_ladder_2;
      }
      frontier_phi_8_13_ladder = frontier_phi_8_13_ladder_19_ladder;
      frontier_phi_8_13_ladder_1 = frontier_phi_8_13_ladder_19_ladder_1;
      frontier_phi_8_13_ladder_2 = frontier_phi_8_13_ladder_19_ladder_2;
    }
    _409 = frontier_phi_8_13_ladder;
    _415 = frontier_phi_8_13_ladder_1;
    _421 = frontier_phi_8_13_ladder_2;
  }
  float _459;
  float _465;
  float _471;
  if (asuint(cb6[15u]).x == 0u) {
    _459 = _308;
    _465 = _310;
    _471 = _312;
  } else {
    uint _510 = _379.w;
    float _597;
    float _598;
    float _599;
    if (cb6[15u].w != 1.0f) {
      _597 = exp2(log2(abs(_308)) * cb6[15u].w);
      _598 = exp2(log2(abs(_310)) * cb6[15u].w);
      _599 = exp2(log2(abs(_312)) * cb6[15u].w);
    } else {
      _597 = _308;
      _598 = _310;
      _599 = _312;
    }
    float _606 = frac(_97 * 211.1488037109375f);
    float _607 = frac(_98 * 210.944000244140625f);
    float _608 = frac(cb0[0u].x * 6.227200031280517578125f);
    float _611 = _608 + 33.3300018310546875f;
    float _612 = dot(float3(_606, _607, _608), float3(_607 + 33.3300018310546875f, _606 + 33.3300018310546875f, _611));
    float _615 = _612 + _606;
    float _616 = _612 + _607;
    float _618 = _615 + _616;
    float _623 = frac(_618 * (_612 + _608));
    float _624 = frac((_615 * 2.0f) * _616);
    float _625 = frac(_618 * _615);
    float _630 = frac((_97 + 64.0f) * 211.1488037109375f);
    float _631 = frac((_98 + 64.0f) * 210.944000244140625f);
    float _634 = dot(float3(_630, _631, _608), float3(_631 + 33.3300018310546875f, _630 + 33.3300018310546875f, _611));
    float _637 = _634 + _630;
    float _638 = _634 + _631;
    float _640 = _637 + _638;
    float _645 = frac(_640 * (_634 + _608));
    float _646 = frac((_637 * 2.0f) * _638);
    float _647 = frac(_640 * _637);
    float frontier_phi_10_17_ladder;
    float frontier_phi_10_17_ladder_1;
    float frontier_phi_10_17_ladder_2;
    if (_510 == 0u) {
      float _735 = (_597 <= 0.003130800090730190277099609375f) ? (_597 * 12.9200000762939453125f) : ((exp2(log2(abs(_597)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _736 = (_598 <= 0.003130800090730190277099609375f) ? (_598 * 12.9200000762939453125f) : ((exp2(log2(abs(_598)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _737 = (_599 <= 0.003130800090730190277099609375f) ? (_599 * 12.9200000762939453125f) : ((exp2(log2(abs(_599)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _738 = _735 * 510.0f;
      float _739 = _736 * 510.0f;
      float _740 = _737 * 510.0f;
      frontier_phi_10_17_ladder = (((_623 + (-0.5f)) + (min(min(1.0f, _738), 510.0f - _738) * (_645 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _735;
      frontier_phi_10_17_ladder_1 = (((_624 + (-0.5f)) + (min(min(1.0f, _739), 510.0f - _739) * (_646 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _736;
      frontier_phi_10_17_ladder_2 = (((_625 + (-0.5f)) + (min(min(1.0f, _740), 510.0f - _740) * (_647 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _737;
    } else {
      float frontier_phi_10_17_ladder_21_ladder;
      float frontier_phi_10_17_ladder_21_ladder_1;
      float frontier_phi_10_17_ladder_21_ladder_2;
      if (_510 == 1u) {
        float _853 = mad(0.043306000530719757080078125f, _599, mad(0.329291999340057373046875f, _598, _597 * 0.627402007579803466796875f));
        float _856 = mad(0.011359999887645244598388671875f, _599, mad(0.9195439815521240234375f, _598, _597 * 0.06909500062465667724609375f));
        float _859 = mad(0.89557802677154541015625f, _599, mad(0.08802799880504608154296875f, _598, _597 * 0.0163940005004405975341796875f));
        float _893 = exp2(log2(abs((((clamp(mad(_859, cb6[26u].z, mad(_856, cb6[26u].y, _853 * cb6[26u].x)), 0.0f, 1.0f) - _853) * cb6[16u].x) + _853) * cb6[15u].y)) * 0.1593017578125f);
        float _894 = exp2(log2(abs((((clamp(mad(_859, cb6[27u].z, mad(_856, cb6[27u].y, _853 * cb6[27u].x)), 0.0f, 1.0f) - _856) * cb6[16u].x) + _856) * cb6[15u].y)) * 0.1593017578125f);
        float _895 = exp2(log2(abs((((clamp(mad(_859, cb6[28u].z, mad(_856, cb6[28u].y, _853 * cb6[28u].x)), 0.0f, 1.0f) - _859) * cb6[16u].x) + _859) * cb6[15u].y)) * 0.1593017578125f);
        frontier_phi_10_17_ladder_21_ladder = exp2(log2(abs(((_893 * 18.8515625f) + 0.8359375f) / ((_893 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_10_17_ladder_21_ladder_1 = exp2(log2(abs(((_894 * 18.8515625f) + 0.8359375f) / ((_894 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_10_17_ladder_21_ladder_2 = exp2(log2(abs(((_895 * 18.8515625f) + 0.8359375f) / ((_895 * 18.6875f) + 1.0f))) * 78.84375f);
      } else {
        float frontier_phi_10_17_ladder_21_ladder_25_ladder;
        float frontier_phi_10_17_ladder_21_ladder_25_ladder_1;
        float frontier_phi_10_17_ladder_21_ladder_25_ladder_2;
        if (_510 == 2u) {
          frontier_phi_10_17_ladder_21_ladder_25_ladder = _597 * cb6[15u].y;
          frontier_phi_10_17_ladder_21_ladder_25_ladder_1 = _598 * cb6[15u].y;
          frontier_phi_10_17_ladder_21_ladder_25_ladder_2 = _599 * cb6[15u].y;
        } else {
          float frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder;
          float frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_1;
          float frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_2;
          if (_510 == 3u) {
            float _1004 = mad(_599, cb6[26u].z, mad(_598, cb6[26u].y, _597 * cb6[26u].x)) * cb6[15u].y;
            float _1005 = mad(_599, cb6[27u].z, mad(_598, cb6[27u].y, _597 * cb6[27u].x)) * cb6[15u].y;
            float _1006 = mad(_599, cb6[28u].z, mad(_598, cb6[28u].y, _597 * cb6[28u].x)) * cb6[15u].y;
            float _1031 = (_1004 <= 0.003130800090730190277099609375f) ? (_1004 * 12.9200000762939453125f) : ((exp2(log2(abs(_1004)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _1032 = (_1005 <= 0.003130800090730190277099609375f) ? (_1005 * 12.9200000762939453125f) : ((exp2(log2(abs(_1005)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _1033 = (_1006 <= 0.003130800090730190277099609375f) ? (_1006 * 12.9200000762939453125f) : ((exp2(log2(abs(_1006)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _1034 = _1031 * 2046.0f;
            float _1035 = _1032 * 2046.0f;
            float _1036 = _1033 * 2046.0f;
            frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder = (((_623 + (-0.5f)) + (min(min(1.0f, _1034), 2046.0f - _1034) * (_645 + (-0.5f)))) * 0.000977517105638980865478515625f) + _1031;
            frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_1 = (((_624 + (-0.5f)) + (min(min(1.0f, _1035), 2046.0f - _1035) * (_646 + (-0.5f)))) * 0.000977517105638980865478515625f) + _1032;
            frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_2 = (((_625 + (-0.5f)) + (min(min(1.0f, _1036), 2046.0f - _1036) * (_647 + (-0.5f)))) * 0.000977517105638980865478515625f) + _1033;
          } else {
            frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder = (_597 * cb6[15u].y) + cb6[15u].z;
            frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_1 = (_598 * cb6[15u].y) + cb6[15u].z;
            frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_2 = (_599 * cb6[15u].y) + cb6[15u].z;
          }
          frontier_phi_10_17_ladder_21_ladder_25_ladder = frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder;
          frontier_phi_10_17_ladder_21_ladder_25_ladder_1 = frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_1;
          frontier_phi_10_17_ladder_21_ladder_25_ladder_2 = frontier_phi_10_17_ladder_21_ladder_25_ladder_29_ladder_2;
        }
        frontier_phi_10_17_ladder_21_ladder = frontier_phi_10_17_ladder_21_ladder_25_ladder;
        frontier_phi_10_17_ladder_21_ladder_1 = frontier_phi_10_17_ladder_21_ladder_25_ladder_1;
        frontier_phi_10_17_ladder_21_ladder_2 = frontier_phi_10_17_ladder_21_ladder_25_ladder_2;
      }
      frontier_phi_10_17_ladder = frontier_phi_10_17_ladder_21_ladder;
      frontier_phi_10_17_ladder_1 = frontier_phi_10_17_ladder_21_ladder_1;
      frontier_phi_10_17_ladder_2 = frontier_phi_10_17_ladder_21_ladder_2;
    }
    _459 = frontier_phi_10_17_ladder;
    _465 = frontier_phi_10_17_ladder_1;
    _471 = frontier_phi_10_17_ladder_2;
  }
  _22[uint2(_82, _83)] = float4(_409, _415, _421, 1.0f);
  if (!(asuint(cb6[15u]).x == 0u)) {
    _23[uint2(_82, _83)] = float4(_459, _465, _471, 1.0f);
  }
  */
  float3 outputColor1 = float3(_371, _373, _375);
  if (_379.y != 0u) {
    ConvertColorParams params = {
      _379.w,      // outputTypeEnum
      cb6[14u].x,  // paperWhiteScaling
      cb6[14u].y,  // blackFloorAdjust
      cb6[14u].z,  // gammaCorrection
      cb6[16u].x,  // pqSaturation
      float3x3(
          cb6[22u].x, cb6[22u].y, cb6[22u].z,
          cb6[23u].x, cb6[23u].y, cb6[23u].z,
          cb6[24u].x, cb6[24u].y, cb6[24u].z),  // pqMatrix
      float3(_97, _98, cb0[0u].x)               // random3
    };
    outputColor1 = convertColor(outputColor1, params);
  }

  _22[uint2(_82, _83)] = float4(outputColor1.rgb, 1.0f);

  if (asuint(cb6[15u]).x != 0u) {
    ConvertColorParams params = {
      _379.w,      // outputTypeEnum
      cb6[15u].y,  // paperWhiteScaling
      cb6[15u].z,  // blackFloorAdjust
      cb6[15u].w,  // gammaCorrection
      cb6[16u].x,  // pqSaturation
      float3x3(
          cb6[26u].x, cb6[26u].y, cb6[26u].z,
          cb6[27u].x, cb6[27u].y, cb6[27u].z,
          cb6[28u].x, cb6[28u].y, cb6[28u].z),  // pqMatrix
      float3(_97, _98, cb0[0u].x)               // random3
    };

    float3 outputColor2 = float3(_308, _310, _312);
    outputColor2 = convertColor(outputColor2, params);
    _23[uint2(_82, _83)] = float4(outputColor2.rgb, 1.0f);
  }
}

[numthreads(16, 16, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
