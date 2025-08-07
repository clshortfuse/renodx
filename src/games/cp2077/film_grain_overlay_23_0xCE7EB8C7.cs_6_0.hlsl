// Film Grain overlay

#include "./colormath.hlsl"
#include "./cp2077.h"
#include "./injectedBuffer.hlsl"

cbuffer _26_28 : register(b0, space0) {
  float4 cb0[30] : packoffset(c0);
};

cbuffer _36_38 : register(b6, space0) {
  float4 cb6[34] : packoffset(c0);
};

cbuffer _31_33 : register(b12, space0) {
  float4 cb12[99] : packoffset(c0);
};

Texture2D<float4> _8 : register(t32, space0);
Texture2D<uint4> _12 : register(t51, space0);
Texture2D<float4> _13 : register(t1, space0);
Texture2D<float4> _14 : register(t2, space0);
Texture2D<float4> _15 : register(t3, space0);
StructuredBuffer<uint> _18 : register(t7, space0);
RWTexture2D<float4> _21 : register(u0, space0);
RWTexture2D<float4> _22 : register(u1, space0);
SamplerState _41 : register(s0, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_WorkGroupID : SV_GroupID;
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

void comp_main() {
  uint4 _72 = _18.Load(asuint(cb6[17u]).x + gl_WorkGroupID.x);
  uint _73 = _72.x;
  uint _81 = ((_73 << 4u) & 1048560u) + gl_LocalInvocationID.x;
  uint _82 = ((_73 >> 16u) << 4u) + gl_LocalInvocationID.y;
  float4 _83 = _8.Load(int3(uint2(_81, _82), 0u));
  float _86 = _83.x;
  float _87 = _83.y;
  float _88 = _83.z;
  float _95 = float(_81);
  float _96 = float(_82);
  float _280;
  float _281;
  float _282;
  if (cb6[16u].x > 0.0f) {
    float4 _115 = _13.Load(int3(uint2(_81 & 255u, _82 & 255u), 0u));
    if (injectedData.fxFilmGrain) {
      float3 grainedColor = renodx::effects::ApplyFilmGrain(
          float3(_86, _87, _88),
          _115.xy,
          frac(cb0[0u].x / 1000.f),
          injectedData.fxFilmGrain * 0.03f,
          (cb6[16u].y == 1.f) ? 1.f : (203.f / 100.f)
          // ,injectedData.debugValue02 != 1.f
      );
      _280 = grainedColor.r;
      _281 = grainedColor.g;
      _282 = grainedColor.b;
    } else {
      uint _111 = 1u << (_12.Load(int3(uint2(uint(cb12[79u].x * _95), uint(cb12[79u].y * _96)), 0u)).y & 31u);
      float _117 = _115.x;
      float _118 = _115.y;
      float _119 = _115.z;
      float _122 = ((_117 + _118) + _119) * 0.3333333432674407958984375f;
      float _127 = cb6[16u].x * _86;
      float _128 = cb6[16u].x * _87;
      float _129 = cb6[16u].x * _88;
      float _146 = _117 - _122;
      float _147 = _118 - _122;
      float _148 = _119 - _122;
      float _152 = _122 + (-0.5f);
      uint4 _166 = asuint(cb6[21u]);
      float _170 = float(min((_166.x & _111), 1u));
      float _199 = float(min((_166.y & _111), 1u));
      float _228 = float(min((_166.z & _111), 1u));
      float _257 = float(min((_166.w & _111), 1u));
      float _264 = (((((((_152 + (cb6[22u].w * _146)) * cb6[22u].x) * _170) + 1.0f) * (_127 / max(1.0f - _127, 9.9999999747524270787835121154785e-07f))) * ((((_152 + (cb6[23u].w * _146)) * cb6[23u].x) * _199) + 1.0f)) * ((((_152 + (cb6[24u].w * _146)) * cb6[24u].x) * _228) + 1.0f)) * ((((_152 + (cb6[25u].w * _146)) * cb6[25u].x) * _257) + 1.0f);
      float _265 = (((((((_152 + (cb6[22u].w * _147)) * cb6[22u].y) * _170) + 1.0f) * (_128 / max(1.0f - _128, 9.9999999747524270787835121154785e-07f))) * ((((_152 + (cb6[23u].w * _147)) * cb6[23u].y) * _199) + 1.0f)) * ((((_152 + (cb6[24u].w * _147)) * cb6[24u].y) * _228) + 1.0f)) * ((((_152 + (cb6[25u].w * _147)) * cb6[25u].y) * _257) + 1.0f);
      float _266 = (((((((_152 + (cb6[22u].w * _148)) * cb6[22u].z) * _170) + 1.0f) * (_129 / max(1.0f - _129, 9.9999999747524270787835121154785e-07f))) * ((((_152 + (cb6[23u].w * _148)) * cb6[23u].z) * _199) + 1.0f)) * ((((_152 + (cb6[24u].w * _148)) * cb6[24u].z) * _228) + 1.0f)) * ((((_152 + (cb6[25u].w * _148)) * cb6[25u].z) * _257) + 1.0f);
      _280 = cb6[16u].y * (_264 / max(_264 + 1.0f, 1.0f));
      _281 = cb6[16u].y * (_265 / max(_265 + 1.0f, 1.0f));
      _282 = cb6[16u].y * (_266 / max(_266 + 1.0f, 1.0f));
    }
  } else {
    _280 = _86;
    _281 = _87;
    _282 = _88;
  }
  float _290 = (_95 + 0.5f) / cb6[16u].z;
  float _291 = (_96 + 0.5f) / cb6[16u].w;
  float _306;
  float _308;
  float _310;
  if (((_290 < cb6[9u].y) || (_291 < cb6[9u].z)) || (((1.0f - cb6[9u].y) < _290) || ((1.0f - cb6[9u].z) < _291))) {
    _306 = 0.0f;
    _308 = 0.0f;
    _310 = 0.0f;
  } else {
    float4 _319 = _15.SampleLevel(_41, float2(_290, _291), 0.0f);
    float4 _327 = _14.SampleLevel(_41, float2(_290, _291), 0.0f);
    float _332 = _327.w;
    float _333 = 1.0f - _332;
    float _338 = (_333 * _319.w) + _332;
    _306 = ((_338 * ((_327.x - _280) + (_333 * _319.x))) + _280) * cb6[1u].z;
    _308 = ((_338 * ((_327.y - _281) + (_333 * _319.y))) + _281) * cb6[1u].z;
    _310 = ((_338 * ((_327.z - _282) + (_333 * _319.z))) + _282) * cb6[1u].z;
  }
  uint4 _314 = asuint(cb6[17u]);

  // Custom: Use colormath
  /*
  float _354;
  float _360;
  float _366;
  if (_314.y == 0u) {
    _354 = _306;
    _360 = _308;
    _366 = _310;
  } else {
    uint _406 = _314.w;
    float _471;
    float _472;
    float _473;
    if (cb6[18u].z != 1.0f) {
      _471 = exp2(log2(abs(_306)) * cb6[18u].z);
      _472 = exp2(log2(abs(_308)) * cb6[18u].z);
      _473 = exp2(log2(abs(_310)) * cb6[18u].z);
    } else {
      _471 = _306;
      _472 = _308;
      _473 = _310;
    }
    float _483 = frac(_95 * 211.1488037109375f);
    float _484 = frac(_96 * 210.944000244140625f);
    float _485 = frac(cb0[0u].x * 6.227200031280517578125f);
    float _489 = _485 + 33.3300018310546875f;
    float _490 = dot(float3(_483, _484, _485), float3(_484 + 33.3300018310546875f, _483 + 33.3300018310546875f, _489));
    float _494 = _490 + _483;
    float _495 = _490 + _484;
    float _497 = _494 + _495;
    float _503 = frac(_497 * (_490 + _485));
    float _504 = frac((_494 * 2.0f) * _495);
    float _505 = frac(_497 * _494);
    float _511 = frac((_95 + 64.0f) * 211.1488037109375f);
    float _512 = frac((_96 + 64.0f) * 210.944000244140625f);
    float _515 = dot(float3(_511, _512, _485), float3(_512 + 33.3300018310546875f, _511 + 33.3300018310546875f, _489));
    float _518 = _515 + _511;
    float _519 = _515 + _512;
    float _521 = _518 + _519;
    float _526 = frac(_521 * (_515 + _485));
    float _527 = frac((_518 * 2.0f) * _519);
    float _528 = frac(_521 * _518);
    float frontier_phi_5_10_ladder;
    float frontier_phi_5_10_ladder_1;
    float frontier_phi_5_10_ladder_2;
    if (_406 == 0u) {
      float _625 = (_471 <= 0.003130800090730190277099609375f) ? (_471 * 12.9200000762939453125f) : ((exp2(log2(abs(_471)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _626 = (_472 <= 0.003130800090730190277099609375f) ? (_472 * 12.9200000762939453125f) : ((exp2(log2(abs(_472)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _627 = (_473 <= 0.003130800090730190277099609375f) ? (_473 * 12.9200000762939453125f) : ((exp2(log2(abs(_473)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _628 = _625 * 510.0f;
      float _630 = _626 * 510.0f;
      float _631 = _627 * 510.0f;
      frontier_phi_5_10_ladder = (((_503 + (-0.5f)) + (min(min(1.0f, _628), 510.0f - _628) * (_526 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _625;
      frontier_phi_5_10_ladder_1 = (((_504 + (-0.5f)) + (min(min(1.0f, _630), 510.0f - _630) * (_527 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _626;
      frontier_phi_5_10_ladder_2 = (((_505 + (-0.5f)) + (min(min(1.0f, _631), 510.0f - _631) * (_528 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _627;
    } else {
      float frontier_phi_5_10_ladder_16_ladder;
      float frontier_phi_5_10_ladder_16_ladder_1;
      float frontier_phi_5_10_ladder_16_ladder_2;
      if (_406 == 1u) {
        float _717 = mad(0.043306000530719757080078125f, _473, mad(0.329291999340057373046875f, _472, _471 * 0.627402007579803466796875f));
        float _723 = mad(0.011359999887645244598388671875f, _473, mad(0.9195439815521240234375f, _472, _471 * 0.06909500062465667724609375f));
        float _729 = mad(0.89557802677154541015625f, _473, mad(0.08802799880504608154296875f, _472, _471 * 0.0163940005004405975341796875f));
        float _765 = exp2(log2(abs((((clamp(mad(_729, cb6[26u].z, mad(_723, cb6[26u].y, _717 * cb6[26u].x)), 0.0f, 1.0f) - _717) * cb6[20u].x) + _717) * cb6[18u].x)) * 0.1593017578125f);
        float _766 = exp2(log2(abs((((clamp(mad(_729, cb6[27u].z, mad(_723, cb6[27u].y, _717 * cb6[27u].x)), 0.0f, 1.0f) - _723) * cb6[20u].x) + _723) * cb6[18u].x)) * 0.1593017578125f);
        float _767 = exp2(log2(abs((((clamp(mad(_729, cb6[28u].z, mad(_723, cb6[28u].y, _717 * cb6[28u].x)), 0.0f, 1.0f) - _729) * cb6[20u].x) + _729) * cb6[18u].x)) * 0.1593017578125f);
        frontier_phi_5_10_ladder_16_ladder = exp2(log2(abs(((_765 * 18.8515625f) + 0.8359375f) / ((_765 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_5_10_ladder_16_ladder_1 = exp2(log2(abs(((_766 * 18.8515625f) + 0.8359375f) / ((_766 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_5_10_ladder_16_ladder_2 = exp2(log2(abs(((_767 * 18.8515625f) + 0.8359375f) / ((_767 * 18.6875f) + 1.0f))) * 78.84375f);
      } else {
        float frontier_phi_5_10_ladder_16_ladder_20_ladder;
        float frontier_phi_5_10_ladder_16_ladder_20_ladder_1;
        float frontier_phi_5_10_ladder_16_ladder_20_ladder_2;
        if (_406 == 2u) {
          frontier_phi_5_10_ladder_16_ladder_20_ladder = _471 * cb6[18u].x;
          frontier_phi_5_10_ladder_16_ladder_20_ladder_1 = _472 * cb6[18u].x;
          frontier_phi_5_10_ladder_16_ladder_20_ladder_2 = _473 * cb6[18u].x;
        } else {
          float frontier_phi_5_10_ladder_16_ladder_20_ladder_24_ladder;
          float frontier_phi_5_10_ladder_16_ladder_20_ladder_24_ladder_1;
          float frontier_phi_5_10_ladder_16_ladder_20_ladder_24_ladder_2;
          if (_406 == 3u) {
            float _880 = mad(_473, cb6[26u].z, mad(_472, cb6[26u].y, _471 * cb6[26u].x)) * cb6[18u].x;
            float _881 = mad(_473, cb6[27u].z, mad(_472, cb6[27u].y, _471 * cb6[27u].x)) * cb6[18u].x;
            float _882 = mad(_473, cb6[28u].z, mad(_472, cb6[28u].y, _471 * cb6[28u].x)) * cb6[18u].x;
            float _907 = (_880 <= 0.003130800090730190277099609375f) ? (_880 * 12.9200000762939453125f) : ((exp2(log2(abs(_880)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _908 = (_881 <= 0.003130800090730190277099609375f) ? (_881 * 12.9200000762939453125f) : ((exp2(log2(abs(_881)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _909 = (_882 <= 0.003130800090730190277099609375f) ? (_882 * 12.9200000762939453125f) : ((exp2(log2(abs(_882)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _910 = _907 * 2046.0f;
            float _912 = _908 * 2046.0f;
            float _913 = _909 * 2046.0f;
            frontier_phi_5_10_ladder_16_ladder_20_ladder_24_ladder = (((_503 + (-0.5f)) + (min(min(1.0f, _910), 2046.0f - _910) * (_526 + (-0.5f)))) * 0.000977517105638980865478515625f) + _907;
            frontier_phi_5_10_ladder_16_ladder_20_ladder_24_ladder_1 = (((_504 + (-0.5f)) + (min(min(1.0f, _912), 2046.0f - _912) * (_527 + (-0.5f)))) * 0.000977517105638980865478515625f) + _908;
            frontier_phi_5_10_ladder_16_ladder_20_ladder_24_ladder_2 = (((_505 + (-0.5f)) + (min(min(1.0f, _913), 2046.0f - _913) * (_528 + (-0.5f)))) * 0.000977517105638980865478515625f) + _909;
          } else {
            frontier_phi_5_10_ladder_16_ladder_20_ladder_24_ladder = (_471 * cb6[18u].x) + cb6[18u].y;
            frontier_phi_5_10_ladder_16_ladder_20_ladder_24_ladder_1 = (_472 * cb6[18u].x) + cb6[18u].y;
            frontier_phi_5_10_ladder_16_ladder_20_ladder_24_ladder_2 = (_473 * cb6[18u].x) + cb6[18u].y;
          }
          frontier_phi_5_10_ladder_16_ladder_20_ladder = frontier_phi_5_10_ladder_16_ladder_20_ladder_24_ladder;
          frontier_phi_5_10_ladder_16_ladder_20_ladder_1 = frontier_phi_5_10_ladder_16_ladder_20_ladder_24_ladder_1;
          frontier_phi_5_10_ladder_16_ladder_20_ladder_2 = frontier_phi_5_10_ladder_16_ladder_20_ladder_24_ladder_2;
        }
        frontier_phi_5_10_ladder_16_ladder = frontier_phi_5_10_ladder_16_ladder_20_ladder;
        frontier_phi_5_10_ladder_16_ladder_1 = frontier_phi_5_10_ladder_16_ladder_20_ladder_1;
        frontier_phi_5_10_ladder_16_ladder_2 = frontier_phi_5_10_ladder_16_ladder_20_ladder_2;
      }
      frontier_phi_5_10_ladder = frontier_phi_5_10_ladder_16_ladder;
      frontier_phi_5_10_ladder_1 = frontier_phi_5_10_ladder_16_ladder_1;
      frontier_phi_5_10_ladder_2 = frontier_phi_5_10_ladder_16_ladder_2;
    }
    _354 = frontier_phi_5_10_ladder;
    _360 = frontier_phi_5_10_ladder_1;
    _366 = frontier_phi_5_10_ladder_2;
  }
  float _408;
  float _414;
  float _420;
  if (asuint(cb6[19u]).x == 0u) {
    _408 = _306;
    _414 = _308;
    _420 = _310;
  } else {
    uint _457 = _314.w;
    float _544;
    float _545;
    float _546;
    if (cb6[19u].w != 1.0f) {
      _544 = exp2(log2(abs(_306)) * cb6[19u].w);
      _545 = exp2(log2(abs(_308)) * cb6[19u].w);
      _546 = exp2(log2(abs(_310)) * cb6[19u].w);
    } else {
      _544 = _306;
      _545 = _308;
      _546 = _310;
    }
    float _553 = frac(_95 * 211.1488037109375f);
    float _554 = frac(_96 * 210.944000244140625f);
    float _555 = frac(cb0[0u].x * 6.227200031280517578125f);
    float _558 = _555 + 33.3300018310546875f;
    float _559 = dot(float3(_553, _554, _555), float3(_554 + 33.3300018310546875f, _553 + 33.3300018310546875f, _558));
    float _562 = _559 + _553;
    float _563 = _559 + _554;
    float _565 = _562 + _563;
    float _570 = frac(_565 * (_559 + _555));
    float _571 = frac((_562 * 2.0f) * _563);
    float _572 = frac(_565 * _562);
    float _577 = frac((_95 + 64.0f) * 211.1488037109375f);
    float _578 = frac((_96 + 64.0f) * 210.944000244140625f);
    float _581 = dot(float3(_577, _578, _555), float3(_578 + 33.3300018310546875f, _577 + 33.3300018310546875f, _558));
    float _584 = _581 + _577;
    float _585 = _581 + _578;
    float _587 = _584 + _585;
    float _592 = frac(_587 * (_581 + _555));
    float _593 = frac((_584 * 2.0f) * _585);
    float _594 = frac(_587 * _584);
    float frontier_phi_7_14_ladder;
    float frontier_phi_7_14_ladder_1;
    float frontier_phi_7_14_ladder_2;
    if (_457 == 0u) {
      float _682 = (_544 <= 0.003130800090730190277099609375f) ? (_544 * 12.9200000762939453125f) : ((exp2(log2(abs(_544)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _683 = (_545 <= 0.003130800090730190277099609375f) ? (_545 * 12.9200000762939453125f) : ((exp2(log2(abs(_545)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _684 = (_546 <= 0.003130800090730190277099609375f) ? (_546 * 12.9200000762939453125f) : ((exp2(log2(abs(_546)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _685 = _682 * 510.0f;
      float _686 = _683 * 510.0f;
      float _687 = _684 * 510.0f;
      frontier_phi_7_14_ladder = (((_570 + (-0.5f)) + (min(min(1.0f, _685), 510.0f - _685) * (_592 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _682;
      frontier_phi_7_14_ladder_1 = (((_571 + (-0.5f)) + (min(min(1.0f, _686), 510.0f - _686) * (_593 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _683;
      frontier_phi_7_14_ladder_2 = (((_572 + (-0.5f)) + (min(min(1.0f, _687), 510.0f - _687) * (_594 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _684;
    } else {
      float frontier_phi_7_14_ladder_18_ladder;
      float frontier_phi_7_14_ladder_18_ladder_1;
      float frontier_phi_7_14_ladder_18_ladder_2;
      if (_457 == 1u) {
        float _800 = mad(0.043306000530719757080078125f, _546, mad(0.329291999340057373046875f, _545, _544 * 0.627402007579803466796875f));
        float _803 = mad(0.011359999887645244598388671875f, _546, mad(0.9195439815521240234375f, _545, _544 * 0.06909500062465667724609375f));
        float _806 = mad(0.89557802677154541015625f, _546, mad(0.08802799880504608154296875f, _545, _544 * 0.0163940005004405975341796875f));
        float _840 = exp2(log2(abs((((clamp(mad(_806, cb6[30u].z, mad(_803, cb6[30u].y, _800 * cb6[30u].x)), 0.0f, 1.0f) - _800) * cb6[20u].x) + _800) * cb6[19u].y)) * 0.1593017578125f);
        float _841 = exp2(log2(abs((((clamp(mad(_806, cb6[31u].z, mad(_803, cb6[31u].y, _800 * cb6[31u].x)), 0.0f, 1.0f) - _803) * cb6[20u].x) + _803) * cb6[19u].y)) * 0.1593017578125f);
        float _842 = exp2(log2(abs((((clamp(mad(_806, cb6[32u].z, mad(_803, cb6[32u].y, _800 * cb6[32u].x)), 0.0f, 1.0f) - _806) * cb6[20u].x) + _806) * cb6[19u].y)) * 0.1593017578125f);
        frontier_phi_7_14_ladder_18_ladder = exp2(log2(abs(((_840 * 18.8515625f) + 0.8359375f) / ((_840 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_7_14_ladder_18_ladder_1 = exp2(log2(abs(((_841 * 18.8515625f) + 0.8359375f) / ((_841 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_7_14_ladder_18_ladder_2 = exp2(log2(abs(((_842 * 18.8515625f) + 0.8359375f) / ((_842 * 18.6875f) + 1.0f))) * 78.84375f);
      } else {
        float frontier_phi_7_14_ladder_18_ladder_22_ladder;
        float frontier_phi_7_14_ladder_18_ladder_22_ladder_1;
        float frontier_phi_7_14_ladder_18_ladder_22_ladder_2;
        if (_457 == 2u) {
          frontier_phi_7_14_ladder_18_ladder_22_ladder = _544 * cb6[19u].y;
          frontier_phi_7_14_ladder_18_ladder_22_ladder_1 = _545 * cb6[19u].y;
          frontier_phi_7_14_ladder_18_ladder_22_ladder_2 = _546 * cb6[19u].y;
        } else {
          float frontier_phi_7_14_ladder_18_ladder_22_ladder_26_ladder;
          float frontier_phi_7_14_ladder_18_ladder_22_ladder_26_ladder_1;
          float frontier_phi_7_14_ladder_18_ladder_22_ladder_26_ladder_2;
          if (_457 == 3u) {
            float _951 = mad(_546, cb6[30u].z, mad(_545, cb6[30u].y, _544 * cb6[30u].x)) * cb6[19u].y;
            float _952 = mad(_546, cb6[31u].z, mad(_545, cb6[31u].y, _544 * cb6[31u].x)) * cb6[19u].y;
            float _953 = mad(_546, cb6[32u].z, mad(_545, cb6[32u].y, _544 * cb6[32u].x)) * cb6[19u].y;
            float _978 = (_951 <= 0.003130800090730190277099609375f) ? (_951 * 12.9200000762939453125f) : ((exp2(log2(abs(_951)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _979 = (_952 <= 0.003130800090730190277099609375f) ? (_952 * 12.9200000762939453125f) : ((exp2(log2(abs(_952)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _980 = (_953 <= 0.003130800090730190277099609375f) ? (_953 * 12.9200000762939453125f) : ((exp2(log2(abs(_953)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _981 = _978 * 2046.0f;
            float _982 = _979 * 2046.0f;
            float _983 = _980 * 2046.0f;
            frontier_phi_7_14_ladder_18_ladder_22_ladder_26_ladder = (((_570 + (-0.5f)) + (min(min(1.0f, _981), 2046.0f - _981) * (_592 + (-0.5f)))) * 0.000977517105638980865478515625f) + _978;
            frontier_phi_7_14_ladder_18_ladder_22_ladder_26_ladder_1 = (((_571 + (-0.5f)) + (min(min(1.0f, _982), 2046.0f - _982) * (_593 + (-0.5f)))) * 0.000977517105638980865478515625f) + _979;
            frontier_phi_7_14_ladder_18_ladder_22_ladder_26_ladder_2 = (((_572 + (-0.5f)) + (min(min(1.0f, _983), 2046.0f - _983) * (_594 + (-0.5f)))) * 0.000977517105638980865478515625f) + _980;
          } else {
            frontier_phi_7_14_ladder_18_ladder_22_ladder_26_ladder = (_544 * cb6[19u].y) + cb6[19u].z;
            frontier_phi_7_14_ladder_18_ladder_22_ladder_26_ladder_1 = (_545 * cb6[19u].y) + cb6[19u].z;
            frontier_phi_7_14_ladder_18_ladder_22_ladder_26_ladder_2 = (_546 * cb6[19u].y) + cb6[19u].z;
          }
          frontier_phi_7_14_ladder_18_ladder_22_ladder = frontier_phi_7_14_ladder_18_ladder_22_ladder_26_ladder;
          frontier_phi_7_14_ladder_18_ladder_22_ladder_1 = frontier_phi_7_14_ladder_18_ladder_22_ladder_26_ladder_1;
          frontier_phi_7_14_ladder_18_ladder_22_ladder_2 = frontier_phi_7_14_ladder_18_ladder_22_ladder_26_ladder_2;
        }
        frontier_phi_7_14_ladder_18_ladder = frontier_phi_7_14_ladder_18_ladder_22_ladder;
        frontier_phi_7_14_ladder_18_ladder_1 = frontier_phi_7_14_ladder_18_ladder_22_ladder_1;
        frontier_phi_7_14_ladder_18_ladder_2 = frontier_phi_7_14_ladder_18_ladder_22_ladder_2;
      }
      frontier_phi_7_14_ladder = frontier_phi_7_14_ladder_18_ladder;
      frontier_phi_7_14_ladder_1 = frontier_phi_7_14_ladder_18_ladder_1;
      frontier_phi_7_14_ladder_2 = frontier_phi_7_14_ladder_18_ladder_2;
    }
    _408 = frontier_phi_7_14_ladder;
    _414 = frontier_phi_7_14_ladder_1;
    _420 = frontier_phi_7_14_ladder_2;
  }
  _21[uint2(_81, _82)] = float4(_354, _360, _366, 1.0f);
  if (!(asuint(cb6[19u]).x == 0u)) {
    _22[uint2(_81, _82)] = float4(_408, _414, _420, 1.0f);
  }
  */

  float3 outputColor1 = float3(_306, _308, _310);
  if (_314.y != 0u) {
    ConvertColorParams params = {
      _314.w,      // outputTypeEnum
      cb6[18u].x,  // paperWhiteScaling
      cb6[18u].y,  // blackFloorAdjust
      cb6[18u].z,  // gammaCorrection
      cb6[20u].x,  // pqSaturation
      float3x3(
          cb6[26u].x, cb6[26u].y, cb6[26u].z,
          cb6[27u].x, cb6[27u].y, cb6[27u].z,
          cb6[28u].x, cb6[28u].y, cb6[28u].z),  // pqMatrix
      float3(_81, _82, cb0[0u].x)               // random3
    };
    outputColor1 = convertColor(outputColor1, params);
  }

  _21[uint2(_81, _82)] = float4(outputColor1.rgb, 1.0f);

  if (asuint(cb6[19u]).x != 0u) {
    ConvertColorParams params = {
      _314.w,      // outputTypeEnum
      cb6[19u].y,  // paperWhiteScaling
      cb6[19u].z,  // blackFloorAdjust
      cb6[19u].w,  // gammaCorrection
      cb6[20u].x,  // pqSaturation
      float3x3(
          cb6[30u].x, cb6[30u].y, cb6[30u].z,
          cb6[31u].x, cb6[31u].y, cb6[31u].z,
          cb6[32u].x, cb6[32u].y, cb6[32u].z),  // pqMatrix
      float3(_81, _82, cb0[0u].x)               // random3
    };

    float3 outputColor2 = float3(_306, _308, _310);
    outputColor2 = convertColor(outputColor2, params);
    _22[uint2(_81, _82)] = float4(outputColor2.rgb, 1.0f);
  }
}

[numthreads(16, 16, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
