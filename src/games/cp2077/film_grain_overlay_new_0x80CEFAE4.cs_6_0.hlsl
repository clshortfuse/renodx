// Film Grain overlay (broken in Vanilla)

#include "./colormath.hlsl"
#include "./cp2077.h"
#include "./injectedBuffer.hlsl"

cbuffer _23_25 : register(b0, space0) {
  float4 cb0[30] : packoffset(c0);
};

cbuffer _27_29 : register(b6, space0) {
  float4 cb6[30] : packoffset(c0);
};

cbuffer _cb12 : register(b12, space0) {  // Added back
  float4 cb12[99] : packoffset(c0);
}

Texture2D<float4> _8 : register(t32, space0);
Texture2D<uint2> t51 : register(t51, space0);  // Added back
Texture2D<float4> t1 : register(t1, space0);   // Added back
Texture2D<float4> _9 : register(t2, space0);
Texture2D<float4> _10 : register(t3, space0);
StructuredBuffer<uint> _14 : register(t7, space0);
Texture2D<float4> _15 : register(t10, space0);
RWTexture2D<float4> _18 : register(u0, space0);
RWTexture2D<float4> _19 : register(u1, space0);
SamplerState _32 : register(s0, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;

struct SPIRV_Cross_Input {
  uint3 gl_WorkGroupID : SV_GroupID;
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

void comp_main() {
  uint4 _62 = _14.Load(asuint(cb6[13u]).x + gl_WorkGroupID.x);
  uint _63 = _62.x;
  uint _71 = ((_63 << 4u) & 1048560u) + gl_LocalInvocationID.x;
  uint _72 = ((_63 >> 16u) << 4u) + gl_LocalInvocationID.y;
  float4 _73 = _8.Load(int3(uint2(_71, _72), 0u));
  float _76 = _73.x;
  float _77 = _73.y;
  float _78 = _73.z;
  float _79 = float(_71);
  float _80 = float(_72);
  float _89 = (_79 + 0.5f) / cb6[12u].z;
  float _90 = (_80 + 0.5f) / cb6[12u].w;
  float _107;
  float _110;
  float _112;

  // Custom: Add back film grain
  if (cb6[12u].x > 0.0f) {
    if (injectedData.fxFilmGrain) {
      // float3 grainColor = _13.Load(int3(uint2(_82 & 255u, _83 & 255u), 0u)).rgb;
      float3 grainedColor = renodx::effects::ApplyFilmGrain(
          _73.rgb,
          float2(_71, _72),
          frac(cb0[0u].x / 1000.f),
          injectedData.fxFilmGrain * 0.03f,
          (cb6[12u].y == 1.f) ? 1.f : (203.f / 100.f)
          // ,injectedData.debugValue02 != 1.f
      );
      _76 = grainedColor.r;
      _77 = grainedColor.g;
      _78 = grainedColor.b;
    } else {
      // Add back Vanilla
      uint _113 = 1u << (t51.Load(int3(uint2(uint(cb12[79u].x * _79), uint(cb12[79u].y * _80)), 0u)).y & 31u);
      float3 grainStrengthAdjusted = _73.rgb * cb6[12u].x;

      float3 grainColor = t1.Load(int3(uint2(_71 & 255u, _72 & 255u), 0u)).rgb;

      float averageChannel = (grainColor.r + grainColor.g + grainColor.z) / 3.f;
      float3 distanceFromAverage = grainColor - averageChannel;

      float _129 = grainStrengthAdjusted.r;
      float _130 = grainStrengthAdjusted.g;
      float _131 = grainStrengthAdjusted.b;

      float _148 = distanceFromAverage.r;
      float _149 = distanceFromAverage.g;
      float _150 = distanceFromAverage.b;

      float _154 = averageChannel - 0.5f;
      uint4 _168 = asuint(cb6[17u]);

      float _172 = float(min((_168.x & _113), 1u));
      float _201 = float(min((_168.y & _113), 1u));
      float _230 = float(min((_168.z & _113), 1u));
      float _259 = float(min((_168.w & _113), 1u));
      float _266 = (((((((_154 + (cb6[18u].w * _148)) * cb6[18u].x) * _172) + 1.0f)
                      * (_129 / max(1.0f - _129, 9.9999999747524270787835121154785e-07f)))
                     * ((((_154 + (cb6[19u].w * _148)) * cb6[19u].x) * _201) + 1.0f))
                    * ((((_154 + (cb6[20u].w * _148)) * cb6[20u].x) * _230) + 1.0f))
                   * ((((_154 + (cb6[21u].w * _148)) * cb6[21u].x) * _259) + 1.0f);

      float _267 = (((((((_154 + (cb6[18u].w * _149)) * cb6[18u].y) * _172) + 1.0f) * (_130 / max(1.0f - _130, 9.9999999747524270787835121154785e-07f))) * ((((_154 + (cb6[19u].w * _149)) * cb6[19u].y) * _201) + 1.0f)) * ((((_154 + (cb6[20u].w * _149)) * cb6[20u].y) * _230) + 1.0f)) * ((((_154 + (cb6[21u].w * _149)) * cb6[21u].y) * _259) + 1.0f);
      float _268 = (((((((_154 + (cb6[18u].w * _150)) * cb6[18u].z) * _172) + 1.0f) * (_131 / max(1.0f - _131, 9.9999999747524270787835121154785e-07f))) * ((((_154 + (cb6[19u].w * _150)) * cb6[19u].z) * _201) + 1.0f)) * ((((_154 + (cb6[20u].w * _150)) * cb6[20u].z) * _230) + 1.0f)) * ((((_154 + (cb6[21u].w * _150)) * cb6[21u].z) * _259) + 1.0f);
      _76 = cb6[12u].y * (_266 / max(_266 + 1.0f, 1.0f));
      _77 = cb6[12u].y * (_267 / max(_267 + 1.0f, 1.0f));
      _78 = cb6[12u].y * (_268 / max(_268 + 1.0f, 1.0f));
    }
  }

  if (((_89 < cb6[9u].y) || (_90 < cb6[9u].z)) || (((1.0f - cb6[9u].y) < _89) || ((1.0f - cb6[9u].z) < _90))) {
    _107 = 0.0f;
    _110 = 0.0f;
    _112 = 0.0f;
  } else {
    float4 _121 = _10.SampleLevel(_32, float2(_89, _90), 0.0f);
    float4 _129 = _9.SampleLevel(_32, float2(_89, _90), 0.0f);
    float _134 = _129.w;
    float _135 = 1.0f - _134;
    float _140 = (_135 * _121.w) + _134;
    _107 = ((_140 * ((_129.x - _76) + (_135 * _121.x))) + _76) * cb6[1u].z;
    _110 = ((_140 * ((_129.y - _77) + (_135 * _121.y))) + _77) * cb6[1u].z;
    _112 = ((_140 * ((_129.z - _78) + (_135 * _121.z))) + _78) * cb6[1u].z;
  }
  float _171;
  float _173;
  float _175;
  if (cb6[14u].w > 0.0f) {
    uint4 _159 = asuint(cb6[10u]);
    uint _160 = _159.x;
    uint _162 = _159.z;
    uint _165 = _159.y;
    uint _168 = _159.w;
    float frontier_phi_4_3_ladder;
    float frontier_phi_4_3_ladder_1;
    float frontier_phi_4_3_ladder_2;
    if ((((_71 >= _160) && (_71 < _162)) && (_72 >= _165)) && (_72 < _168)) {
      float4 _204 = _15.SampleLevel(_32, float2((cb6[11u].z * ((_79 - float(int(_160))) / float(int(_162 - _160)))) + cb6[11u].x, (cb6[11u].w * ((_80 - float(int(_165))) / float(int(_168 - _165)))) + cb6[11u].y), 0.0f);
      frontier_phi_4_3_ladder = _204.x * cb6[14u].w;
      frontier_phi_4_3_ladder_1 = _204.y * cb6[14u].w;
      frontier_phi_4_3_ladder_2 = _204.z * cb6[14u].w;
    } else {
      frontier_phi_4_3_ladder = _107;
      frontier_phi_4_3_ladder_1 = _110;
      frontier_phi_4_3_ladder_2 = _112;
    }
    _171 = frontier_phi_4_3_ladder;
    _173 = frontier_phi_4_3_ladder_1;
    _175 = frontier_phi_4_3_ladder_2;
  } else {
    _171 = _107;
    _173 = _110;
    _175 = _112;
  }
  uint4 _179 = asuint(cb6[13u]);
  // Custom: Use colormath
  /*
  float _209;
  float _215;
  float _221;
  if (_179.y == 0u) {
    _209 = _171;
    _215 = _173;
    _221 = _175;
  } else {
    uint _257 = _179.w;
    float _325;
    float _326;
    float _327;
    if (cb6[14u].z != 1.0f) {
      _325 = exp2(log2(abs(_171)) * cb6[14u].z);
      _326 = exp2(log2(abs(_173)) * cb6[14u].z);
      _327 = exp2(log2(abs(_175)) * cb6[14u].z);
    } else {
      _325 = _171;
      _326 = _173;
      _327 = _175;
    }
    float _337 = frac(_79 * 211.1488037109375f);
    float _338 = frac(_80 * 210.944000244140625f);
    float _339 = frac(cb0[0u].x * 6.227200031280517578125f);
    float _343 = _339 + 33.3300018310546875f;
    float _344 = dot(float3(_337, _338, _339), float3(_338 + 33.3300018310546875f, _337 + 33.3300018310546875f, _343));
    float _348 = _344 + _337;
    float _349 = _344 + _338;
    float _351 = _348 + _349;
    float _357 = frac(_351 * (_344 + _339));
    float _358 = frac((_348 * 2.0f) * _349);
    float _359 = frac(_351 * _348);
    float _365 = frac((_79 + 64.0f) * 211.1488037109375f);
    float _366 = frac((_80 + 64.0f) * 210.944000244140625f);
    float _369 = dot(float3(_365, _366, _339), float3(_366 + 33.3300018310546875f, _365 + 33.3300018310546875f, _343));
    float _372 = _369 + _365;
    float _373 = _369 + _366;
    float _375 = _372 + _373;
    float _380 = frac(_375 * (_369 + _339));
    float _381 = frac((_372 * 2.0f) * _373);
    float _382 = frac(_375 * _372);
    float frontier_phi_6_11_ladder;
    float frontier_phi_6_11_ladder_1;
    float frontier_phi_6_11_ladder_2;
    if (_257 == 0u) {
      float _479 = (_325 <= 0.003130800090730190277099609375f) ? (_325 * 12.9200000762939453125f) : ((exp2(log2(abs(_325)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _480 = (_326 <= 0.003130800090730190277099609375f) ? (_326 * 12.9200000762939453125f) : ((exp2(log2(abs(_326)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _481 = (_327 <= 0.003130800090730190277099609375f) ? (_327 * 12.9200000762939453125f) : ((exp2(log2(abs(_327)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _482 = _479 * 510.0f;
      float _484 = _480 * 510.0f;
      float _485 = _481 * 510.0f;
      frontier_phi_6_11_ladder = (((_357 + (-0.5f)) + (min(min(1.0f, _482), 510.0f - _482) * (_380 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _479;
      frontier_phi_6_11_ladder_1 = (((_358 + (-0.5f)) + (min(min(1.0f, _484), 510.0f - _484) * (_381 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _480;
      frontier_phi_6_11_ladder_2 = (((_359 + (-0.5f)) + (min(min(1.0f, _485), 510.0f - _485) * (_382 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _481;
    } else {
      float frontier_phi_6_11_ladder_17_ladder;
      float frontier_phi_6_11_ladder_17_ladder_1;
      float frontier_phi_6_11_ladder_17_ladder_2;
      if (_257 == 1u) {
        float _572 = mad(0.043306000530719757080078125f, _327, mad(0.329291999340057373046875f, _326, _325 * 0.627402007579803466796875f));
        float _578 = mad(0.011359999887645244598388671875f, _327, mad(0.9195439815521240234375f, _326, _325 * 0.06909500062465667724609375f));
        float _584 = mad(0.89557802677154541015625f, _327, mad(0.08802799880504608154296875f, _326, _325 * 0.0163940005004405975341796875f));
        float _620 = exp2(log2(abs((((clamp(mad(_584, cb6[22u].z, mad(_578, cb6[22u].y, _572 * cb6[22u].x)), 0.0f, 1.0f) - _572) * cb6[16u].x) + _572) * cb6[14u].x)) * 0.1593017578125f);
        float _621 = exp2(log2(abs((((clamp(mad(_584, cb6[23u].z, mad(_578, cb6[23u].y, _572 * cb6[23u].x)), 0.0f, 1.0f) - _578) * cb6[16u].x) + _578) * cb6[14u].x)) * 0.1593017578125f);
        float _622 = exp2(log2(abs((((clamp(mad(_584, cb6[24u].z, mad(_578, cb6[24u].y, _572 * cb6[24u].x)), 0.0f, 1.0f) - _584) * cb6[16u].x) + _584) * cb6[14u].x)) * 0.1593017578125f);
        frontier_phi_6_11_ladder_17_ladder = exp2(log2(abs(((_620 * 18.8515625f) + 0.8359375f) / ((_620 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_6_11_ladder_17_ladder_1 = exp2(log2(abs(((_621 * 18.8515625f) + 0.8359375f) / ((_621 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_6_11_ladder_17_ladder_2 = exp2(log2(abs(((_622 * 18.8515625f) + 0.8359375f) / ((_622 * 18.6875f) + 1.0f))) * 78.84375f);
      } else {
        float frontier_phi_6_11_ladder_17_ladder_21_ladder;
        float frontier_phi_6_11_ladder_17_ladder_21_ladder_1;
        float frontier_phi_6_11_ladder_17_ladder_21_ladder_2;
        if (_257 == 2u) {
          frontier_phi_6_11_ladder_17_ladder_21_ladder = _325 * cb6[14u].x;
          frontier_phi_6_11_ladder_17_ladder_21_ladder_1 = _326 * cb6[14u].x;
          frontier_phi_6_11_ladder_17_ladder_21_ladder_2 = _327 * cb6[14u].x;
        } else {
          float frontier_phi_6_11_ladder_17_ladder_21_ladder_25_ladder;
          float frontier_phi_6_11_ladder_17_ladder_21_ladder_25_ladder_1;
          float frontier_phi_6_11_ladder_17_ladder_21_ladder_25_ladder_2;
          if (_257 == 3u) {
            float _735 = mad(_327, cb6[22u].z, mad(_326, cb6[22u].y, _325 * cb6[22u].x)) * cb6[14u].x;
            float _736 = mad(_327, cb6[23u].z, mad(_326, cb6[23u].y, _325 * cb6[23u].x)) * cb6[14u].x;
            float _737 = mad(_327, cb6[24u].z, mad(_326, cb6[24u].y, _325 * cb6[24u].x)) * cb6[14u].x;
            float _762 = (_735 <= 0.003130800090730190277099609375f) ? (_735 * 12.9200000762939453125f) : ((exp2(log2(abs(_735)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _763 = (_736 <= 0.003130800090730190277099609375f) ? (_736 * 12.9200000762939453125f) : ((exp2(log2(abs(_736)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _764 = (_737 <= 0.003130800090730190277099609375f) ? (_737 * 12.9200000762939453125f) : ((exp2(log2(abs(_737)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _765 = _762 * 2046.0f;
            float _767 = _763 * 2046.0f;
            float _768 = _764 * 2046.0f;
            frontier_phi_6_11_ladder_17_ladder_21_ladder_25_ladder = (((_357 + (-0.5f)) + (min(min(1.0f, _765), 2046.0f - _765) * (_380 + (-0.5f)))) * 0.000977517105638980865478515625f) + _762;
            frontier_phi_6_11_ladder_17_ladder_21_ladder_25_ladder_1 = (((_358 + (-0.5f)) + (min(min(1.0f, _767), 2046.0f - _767) * (_381 + (-0.5f)))) * 0.000977517105638980865478515625f) + _763;
            frontier_phi_6_11_ladder_17_ladder_21_ladder_25_ladder_2 = (((_359 + (-0.5f)) + (min(min(1.0f, _768), 2046.0f - _768) * (_382 + (-0.5f)))) * 0.000977517105638980865478515625f) + _764;
          } else {
            frontier_phi_6_11_ladder_17_ladder_21_ladder_25_ladder = (_325 * cb6[14u].x) + cb6[14u].y;
            frontier_phi_6_11_ladder_17_ladder_21_ladder_25_ladder_1 = (_326 * cb6[14u].x) + cb6[14u].y;
            frontier_phi_6_11_ladder_17_ladder_21_ladder_25_ladder_2 = (_327 * cb6[14u].x) + cb6[14u].y;
          }
          frontier_phi_6_11_ladder_17_ladder_21_ladder = frontier_phi_6_11_ladder_17_ladder_21_ladder_25_ladder;
          frontier_phi_6_11_ladder_17_ladder_21_ladder_1 = frontier_phi_6_11_ladder_17_ladder_21_ladder_25_ladder_1;
          frontier_phi_6_11_ladder_17_ladder_21_ladder_2 = frontier_phi_6_11_ladder_17_ladder_21_ladder_25_ladder_2;
        }
        frontier_phi_6_11_ladder_17_ladder = frontier_phi_6_11_ladder_17_ladder_21_ladder;
        frontier_phi_6_11_ladder_17_ladder_1 = frontier_phi_6_11_ladder_17_ladder_21_ladder_1;
        frontier_phi_6_11_ladder_17_ladder_2 = frontier_phi_6_11_ladder_17_ladder_21_ladder_2;
      }
      frontier_phi_6_11_ladder = frontier_phi_6_11_ladder_17_ladder;
      frontier_phi_6_11_ladder_1 = frontier_phi_6_11_ladder_17_ladder_1;
      frontier_phi_6_11_ladder_2 = frontier_phi_6_11_ladder_17_ladder_2;
    }
    _209 = frontier_phi_6_11_ladder;
    _215 = frontier_phi_6_11_ladder_1;
    _221 = frontier_phi_6_11_ladder_2;
  }
  float _259;
  float _265;
  float _271;
  if (asuint(cb6[15u]).x == 0u) {
    _259 = _107;
    _265 = _110;
    _271 = _112;
  } else {
    uint _310 = _179.w;
    float _398;
    float _399;
    float _400;
    if (cb6[15u].w != 1.0f) {
      _398 = exp2(log2(abs(_107)) * cb6[15u].w);
      _399 = exp2(log2(abs(_110)) * cb6[15u].w);
      _400 = exp2(log2(abs(_112)) * cb6[15u].w);
    } else {
      _398 = _107;
      _399 = _110;
      _400 = _112;
    }
    float _407 = frac(_79 * 211.1488037109375f);
    float _408 = frac(_80 * 210.944000244140625f);
    float _409 = frac(cb0[0u].x * 6.227200031280517578125f);
    float _412 = _409 + 33.3300018310546875f;
    float _413 = dot(float3(_407, _408, _409), float3(_408 + 33.3300018310546875f, _407 + 33.3300018310546875f, _412));
    float _416 = _413 + _407;
    float _417 = _413 + _408;
    float _419 = _416 + _417;
    float _424 = frac(_419 * (_413 + _409));
    float _425 = frac((_416 * 2.0f) * _417);
    float _426 = frac(_419 * _416);
    float _431 = frac((_79 + 64.0f) * 211.1488037109375f);
    float _432 = frac((_80 + 64.0f) * 210.944000244140625f);
    float _435 = dot(float3(_431, _432, _409), float3(_432 + 33.3300018310546875f, _431 + 33.3300018310546875f, _412));
    float _438 = _435 + _431;
    float _439 = _435 + _432;
    float _441 = _438 + _439;
    float _446 = frac(_441 * (_435 + _409));
    float _447 = frac((_438 * 2.0f) * _439);
    float _448 = frac(_441 * _438);
    float frontier_phi_8_15_ladder;
    float frontier_phi_8_15_ladder_1;
    float frontier_phi_8_15_ladder_2;
    if (_310 == 0u) {
      float _537 = (_398 <= 0.003130800090730190277099609375f) ? (_398 * 12.9200000762939453125f) : ((exp2(log2(abs(_398)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _538 = (_399 <= 0.003130800090730190277099609375f) ? (_399 * 12.9200000762939453125f) : ((exp2(log2(abs(_399)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _539 = (_400 <= 0.003130800090730190277099609375f) ? (_400 * 12.9200000762939453125f) : ((exp2(log2(abs(_400)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
      float _540 = _537 * 510.0f;
      float _541 = _538 * 510.0f;
      float _542 = _539 * 510.0f;
      frontier_phi_8_15_ladder = (((_424 + (-0.5f)) + (min(min(1.0f, _540), 510.0f - _540) * (_446 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _537;
      frontier_phi_8_15_ladder_1 = (((_425 + (-0.5f)) + (min(min(1.0f, _541), 510.0f - _541) * (_447 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _538;
      frontier_phi_8_15_ladder_2 = (((_426 + (-0.5f)) + (min(min(1.0f, _542), 510.0f - _542) * (_448 + (-0.5f)))) * 0.0039215688593685626983642578125f) + _539;
    } else {
      float frontier_phi_8_15_ladder_19_ladder;
      float frontier_phi_8_15_ladder_19_ladder_1;
      float frontier_phi_8_15_ladder_19_ladder_2;
      if (_310 == 1u) {
        float _655 = mad(0.043306000530719757080078125f, _400, mad(0.329291999340057373046875f, _399, _398 * 0.627402007579803466796875f));
        float _658 = mad(0.011359999887645244598388671875f, _400, mad(0.9195439815521240234375f, _399, _398 * 0.06909500062465667724609375f));
        float _661 = mad(0.89557802677154541015625f, _400, mad(0.08802799880504608154296875f, _399, _398 * 0.0163940005004405975341796875f));
        float _695 = exp2(log2(abs((((clamp(mad(_661, cb6[26u].z, mad(_658, cb6[26u].y, _655 * cb6[26u].x)), 0.0f, 1.0f) - _655) * cb6[16u].x) + _655) * cb6[15u].y)) * 0.1593017578125f);
        float _696 = exp2(log2(abs((((clamp(mad(_661, cb6[27u].z, mad(_658, cb6[27u].y, _655 * cb6[27u].x)), 0.0f, 1.0f) - _658) * cb6[16u].x) + _658) * cb6[15u].y)) * 0.1593017578125f);
        float _697 = exp2(log2(abs((((clamp(mad(_661, cb6[28u].z, mad(_658, cb6[28u].y, _655 * cb6[28u].x)), 0.0f, 1.0f) - _661) * cb6[16u].x) + _661) * cb6[15u].y)) * 0.1593017578125f);
        frontier_phi_8_15_ladder_19_ladder = exp2(log2(abs(((_695 * 18.8515625f) + 0.8359375f) / ((_695 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_8_15_ladder_19_ladder_1 = exp2(log2(abs(((_696 * 18.8515625f) + 0.8359375f) / ((_696 * 18.6875f) + 1.0f))) * 78.84375f);
        frontier_phi_8_15_ladder_19_ladder_2 = exp2(log2(abs(((_697 * 18.8515625f) + 0.8359375f) / ((_697 * 18.6875f) + 1.0f))) * 78.84375f);
      } else {
        float frontier_phi_8_15_ladder_19_ladder_23_ladder;
        float frontier_phi_8_15_ladder_19_ladder_23_ladder_1;
        float frontier_phi_8_15_ladder_19_ladder_23_ladder_2;
        if (_310 == 2u) {
          frontier_phi_8_15_ladder_19_ladder_23_ladder = _398 * cb6[15u].y;
          frontier_phi_8_15_ladder_19_ladder_23_ladder_1 = _399 * cb6[15u].y;
          frontier_phi_8_15_ladder_19_ladder_23_ladder_2 = _400 * cb6[15u].y;
        } else {
          float frontier_phi_8_15_ladder_19_ladder_23_ladder_27_ladder;
          float frontier_phi_8_15_ladder_19_ladder_23_ladder_27_ladder_1;
          float frontier_phi_8_15_ladder_19_ladder_23_ladder_27_ladder_2;
          if (_310 == 3u) {
            float _806 = mad(_400, cb6[26u].z, mad(_399, cb6[26u].y, _398 * cb6[26u].x)) * cb6[15u].y;
            float _807 = mad(_400, cb6[27u].z, mad(_399, cb6[27u].y, _398 * cb6[27u].x)) * cb6[15u].y;
            float _808 = mad(_400, cb6[28u].z, mad(_399, cb6[28u].y, _398 * cb6[28u].x)) * cb6[15u].y;
            float _833 = (_806 <= 0.003130800090730190277099609375f) ? (_806 * 12.9200000762939453125f) : ((exp2(log2(abs(_806)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _834 = (_807 <= 0.003130800090730190277099609375f) ? (_807 * 12.9200000762939453125f) : ((exp2(log2(abs(_807)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _835 = (_808 <= 0.003130800090730190277099609375f) ? (_808 * 12.9200000762939453125f) : ((exp2(log2(abs(_808)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
            float _836 = _833 * 2046.0f;
            float _837 = _834 * 2046.0f;
            float _838 = _835 * 2046.0f;
            frontier_phi_8_15_ladder_19_ladder_23_ladder_27_ladder = (((_424 + (-0.5f)) + (min(min(1.0f, _836), 2046.0f - _836) * (_446 + (-0.5f)))) * 0.000977517105638980865478515625f) + _833;
            frontier_phi_8_15_ladder_19_ladder_23_ladder_27_ladder_1 = (((_425 + (-0.5f)) + (min(min(1.0f, _837), 2046.0f - _837) * (_447 + (-0.5f)))) * 0.000977517105638980865478515625f) + _834;
            frontier_phi_8_15_ladder_19_ladder_23_ladder_27_ladder_2 = (((_426 + (-0.5f)) + (min(min(1.0f, _838), 2046.0f - _838) * (_448 + (-0.5f)))) * 0.000977517105638980865478515625f) + _835;
          } else {
            frontier_phi_8_15_ladder_19_ladder_23_ladder_27_ladder = (_398 * cb6[15u].y) + cb6[15u].z;
            frontier_phi_8_15_ladder_19_ladder_23_ladder_27_ladder_1 = (_399 * cb6[15u].y) + cb6[15u].z;
            frontier_phi_8_15_ladder_19_ladder_23_ladder_27_ladder_2 = (_400 * cb6[15u].y) + cb6[15u].z;
          }
          frontier_phi_8_15_ladder_19_ladder_23_ladder = frontier_phi_8_15_ladder_19_ladder_23_ladder_27_ladder;
          frontier_phi_8_15_ladder_19_ladder_23_ladder_1 = frontier_phi_8_15_ladder_19_ladder_23_ladder_27_ladder_1;
          frontier_phi_8_15_ladder_19_ladder_23_ladder_2 = frontier_phi_8_15_ladder_19_ladder_23_ladder_27_ladder_2;
        }
        frontier_phi_8_15_ladder_19_ladder = frontier_phi_8_15_ladder_19_ladder_23_ladder;
        frontier_phi_8_15_ladder_19_ladder_1 = frontier_phi_8_15_ladder_19_ladder_23_ladder_1;
        frontier_phi_8_15_ladder_19_ladder_2 = frontier_phi_8_15_ladder_19_ladder_23_ladder_2;
      }
      frontier_phi_8_15_ladder = frontier_phi_8_15_ladder_19_ladder;
      frontier_phi_8_15_ladder_1 = frontier_phi_8_15_ladder_19_ladder_1;
      frontier_phi_8_15_ladder_2 = frontier_phi_8_15_ladder_19_ladder_2;
    }
    _259 = frontier_phi_8_15_ladder;
    _265 = frontier_phi_8_15_ladder_1;
    _271 = frontier_phi_8_15_ladder_2;
  }
  _18[uint2(_71, _72)] = float4(_209, _215, _221, 1.0f);
  if (!(asuint(cb6[15u]).x == 0u)) {
    _19[uint2(_71, _72)] = float4(_259, _265, _271, 1.0f);
  }
  */
  float3 outputColor1 = float3(_171, _173, _175);
  if (_179.y != 0u) {
    ConvertColorParams params = {
        _179.w,      // outputTypeEnum
        cb6[14u].x,  // paperWhiteScaling
        cb6[14u].y,  // blackFloorAdjust
        cb6[14u].z,  // gammaCorrection
        cb6[16u].x,  // pqSaturation
        float3x3(
            cb6[22u].x, cb6[22u].y, cb6[22u].z,
            cb6[23u].x, cb6[23u].y, cb6[23u].z,
            cb6[24u].x, cb6[24u].y, cb6[24u].z),  // pqMatrix
        float3(_79, _80, cb0[0u].x)               // random3
    };
    outputColor1 = convertColor(outputColor1, params);
  }

  _18[uint2(_71, _72)] = float4(outputColor1.rgb, 1.0f);

  if (asuint(cb6[15u]).x != 0u) {
    ConvertColorParams params = {
        _179.w,      // outputTypeEnum
        cb6[15u].y,  // paperWhiteScaling
        cb6[15u].z,  // blackFloorAdjust
        cb6[15u].w,  // gammaCorrection
        cb6[16u].x,  // pqSaturation
        float3x3(
            cb6[26u].x, cb6[26u].y, cb6[26u].z,
            cb6[27u].x, cb6[27u].y, cb6[27u].z,
            cb6[28u].x, cb6[28u].y, cb6[28u].z),  // pqMatrix
        float3(_79, _80, cb0[0u].x)               // random3
    };

    float3 outputColor2 = float3(_107, _110, _112);
    outputColor2 = convertColor(outputColor2, params);
    _19[uint2(_71, _72)] = float4(outputColor2.rgb, 1.0f);
  }
}

[numthreads(16, 16, 1)] void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
