#include "../common.hlsli"

cbuffer _21_23 : register(b0, space5) {
  float4 _23_m0[9] : packoffset(c0);
};

Texture2D<float4> _12 : register(t0, space6);
Texture2D<float4> _13 : register(t1, space6);
RWTexture2D<float4> _16 : register(u0, space6);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_WorkGroupID : SV_GroupID;
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

uint spvPackHalf2x16(float2 value) {
  uint2 Packed = f32tof16(value);
  return Packed.x | (Packed.y << 16);
}

float2 spvUnpackHalf2x16(uint value) {
  return f16tof32(uint2(value & 0xffff, value >> 16));
}

void comp_main() {
  uint _72 = ((gl_LocalInvocationID.x >> 1u) & 7u) | (gl_WorkGroupID.x << 4u);
  uint _73 = (((gl_LocalInvocationID.x >> 3u) & 6u) | (gl_LocalInvocationID.x & 1u)) | (gl_WorkGroupID.y << 4u);
  uint16_t _76 = uint16_t(_72);
  uint16_t _77 = uint16_t(_73);
  float _85 = (float(_76) + 0.5f) * _23_m0[1u].x;
  float _86 = (float((_77 + 65535u)) + 0.5f) * _23_m0[1u].y;
  float4 _95 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_85, _86), 0.0f);
  half _102 = half(_95.x);
  half _103 = half(_95.y);
  half _104 = half(_95.z);
  float _110 = (float((_76 + 65535u)) + 0.5f) * _23_m0[1u].x;
  float _111 = (float(_77) + 0.5f) * _23_m0[1u].y;
  float4 _112 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_110, _111), 0.0f);
  half _117 = half(_112.x);
  half _118 = half(_112.y);
  half _119 = half(_112.z);
  float4 _120 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_85, _111), 0.0f);
  float _132 = (float((_76 + 1u)) + 0.5f) * _23_m0[1u].x;
  float4 _133 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_132, _111), 0.0f);
  half _138 = half(_133.x);
  half _139 = half(_133.y);
  half _140 = half(_133.z);
  float _144 = (float((_77 + 1u)) + 0.5f) * _23_m0[1u].y;
  float4 _145 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_85, _144), 0.0f);
  half _150 = half(_145.x);
  half _151 = half(_145.y);
  half _152 = half(_145.z);
  half _156 = min(min(_102, min(_117, _138)), _150);
  half _159 = min(min(_103, min(_118, _139)), _151);
  half _162 = min(min(_104, min(_119, _140)), _152);
  half _165 = max(max(_102, max(_117, _138)), _150);
  half _168 = max(max(_103, max(_118, _139)), _151);
  half _171 = max(max(_104, max(_119, _140)), _152);
  half _214 = half(spvUnpackHalf2x16(asuint(_23_m0[0u].y) & 65535u).x);
  half _215 = _214 * max(half(-0.1875), min(max(max(half(-0.0) - (_156 * (half(0.25) / _165)), (half(1.0) / ((_156 * half(4.0)) + half(-4.0))) * (half(1.0) - _165)), max(max(half(-0.0) - (_159 * (half(0.25) / _168)), (half(1.0) / ((_159 * half(4.0)) + half(-4.0))) * (half(1.0) - _168)), max(half(-0.0) - (_162 * (half(0.25) / _171)), (half(1.0) / ((_162 * half(4.0)) + half(-4.0))) * (half(1.0) - _171)))), half(0.0)));
  half _217 = (_215 * half(4.0)) + half(1.0);
  half _226 = half(spvUnpackHalf2x16((30605u - spvPackHalf2x16(float2(float(_217), 0.0f))) & 65535u).x);
  half _230 = (half(2.0) - (_217 * _226)) * _226;
  half _249 = half(_23_m0[4u].z);
  half _250 = min(_230 * ((_215 * (((_117 + _102) + _138) + _150)) + half(_120.x)), _249);
  half _251 = min(_230 * ((_215 * (((_118 + _103) + _139) + _151)) + half(_120.y)), _249);
  half _252 = min(_230 * ((_215 * (((_119 + _104) + _140) + _152)) + half(_120.z)), _249);
  bool _255 = uint(int(_23_m0[8u].x)) == 0u;
  half _256;
  half _258;
  half _260;
  if (_255) {
    _256 = _250;
    _258 = _251;
    _260 = _252;
  } else {
    float4 _410 = _13.Load(int3(uint2(_72, _73), 0u));
    float _412 = _410.x;
    float _413 = _410.y;
    float _414 = _410.z;
    float _415 = _410.w;
    half frontier_phi_1_2_ladder;
    half frontier_phi_1_2_ladder_1;
    half frontier_phi_1_2_ladder_2;
    if ((max(_412, max(_413, _414)) + _415) > 0.0f) {
      float _582 = float(_250);
      float _583 = float(_251);
      float _584 = float(_252);
      uint _585 = uint(int(_23_m0[7u].w));
      float _848;
      float _850;
      float _852;
      if (_585 == 1u) {
        float _942;
        if (_582 < 0.040449999272823333740234375f) {
          _942 = _582 * 0.077399380505084991455078125f;
        } else {
          _942 = exp2(log2(abs((_582 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
        }
        float _1296;
        if (_583 < 0.040449999272823333740234375f) {
          _1296 = _583 * 0.077399380505084991455078125f;
        } else {
          _1296 = exp2(log2(abs((_583 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
        }
        float _1493;
        if (_584 < 0.040449999272823333740234375f) {
          _1493 = _584 * 0.077399380505084991455078125f;
        } else {
          _1493 = exp2(log2(abs((_584 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
        }
        float _1494 = 1.0f / _23_m0[7u].x;
        _848 = exp2(log2(abs(_942)) * _1494);
        _850 = exp2(log2(abs(_1296)) * _1494);
        _852 = exp2(log2(abs(_1493)) * _1494);
      } else {
        float frontier_phi_19_10_ladder;
        float frontier_phi_19_10_ladder_1;
        float frontier_phi_19_10_ladder_2;
        if (_585 == 2u) {
#if 1
          BT709FromPQ(
              _582, _583, _584,
              _23_m0[7u].x, _23_m0[7u].y,
              frontier_phi_19_10_ladder_2, frontier_phi_19_10_ladder_1, frontier_phi_19_10_ladder);
#else
          float _795 = exp2(log2(abs(_582)) * 0.0126833133399486541748046875f);
          float _796 = exp2(log2(abs(_583)) * 0.0126833133399486541748046875f);
          float _797 = exp2(log2(abs(_584)) * 0.0126833133399486541748046875f);
          float _813 = 1.0f / _23_m0[7u].x;
          float _826 = 1.0f / _23_m0[7u].y;
          float _827 = _826 * exp2(log2(abs((_795 + (-0.8359375f)) / (18.8515625f - (_795 * 18.6875f)))) * _813);
          float _828 = _826 * exp2(log2(abs((_796 + (-0.8359375f)) / (18.8515625f - (_796 * 18.6875f)))) * _813);
          float _829 = _826 * exp2(log2(abs((_797 + (-0.8359375f)) / (18.8515625f - (_797 * 18.6875f)))) * _813);
          frontier_phi_19_10_ladder = mad(1.11872994899749755859375f, _829, mad(-0.100579001009464263916015625f, _828, _827 * (-0.01815080083906650543212890625f)));
          frontier_phi_19_10_ladder_1 = mad(-0.008349419571459293365478515625f, _829, mad(1.1328999996185302734375f, _828, _827 * (-0.12454999983310699462890625f)));
          frontier_phi_19_10_ladder_2 = mad(-0.0728498995304107666015625f, _829, mad(-0.5876410007476806640625f, _828, _827 * 1.6604900360107421875f));
#endif
        } else {
          frontier_phi_19_10_ladder = _584;
          frontier_phi_19_10_ladder_1 = _583;
          frontier_phi_19_10_ladder_2 = _582;
        }
        _848 = frontier_phi_19_10_ladder_2;
        _850 = frontier_phi_19_10_ladder_1;
        _852 = frontier_phi_19_10_ladder;
      }
      float _854 = 1.0f - _415;
      float _858 = (_848 * _854) + _412;
      float _859 = (_850 * _854) + _413;
      float _860 = (_852 * _854) + _414;
      uint _861 = uint(int(_23_m0[4u].w));
      float _1129;
      float _1131;
      float _1133;
      if (_861 == 1u) {
        float _953 = exp2(log2(abs(_858)) * _23_m0[4u].x);
        float _954 = exp2(log2(abs(_859)) * _23_m0[4u].x);
        float _955 = exp2(log2(abs(_860)) * _23_m0[4u].x);
        float _1130;
        if (_953 < 0.00310000008903443813323974609375f) {
          _1130 = _953 * 12.9200000762939453125f;
        } else {
          _1130 = (exp2(log2(abs(_953)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        float _1132;
        if (_954 < 0.00310000008903443813323974609375f) {
          _1132 = _954 * 12.9200000762939453125f;
        } else {
          _1132 = (exp2(log2(abs(_954)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        float frontier_phi_44_88_ladder;
        float frontier_phi_44_88_ladder_1;
        float frontier_phi_44_88_ladder_2;
        if (_955 < 0.00310000008903443813323974609375f) {
          frontier_phi_44_88_ladder = _955 * 12.9200000762939453125f;
          frontier_phi_44_88_ladder_1 = _1132;
          frontier_phi_44_88_ladder_2 = _1130;
        } else {
          frontier_phi_44_88_ladder = (exp2(log2(abs(_955)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
          frontier_phi_44_88_ladder_1 = _1132;
          frontier_phi_44_88_ladder_2 = _1130;
        }
        _1129 = frontier_phi_44_88_ladder_2;
        _1131 = frontier_phi_44_88_ladder_1;
        _1133 = frontier_phi_44_88_ladder;
      } else {
        float frontier_phi_44_29_ladder;
        float frontier_phi_44_29_ladder_1;
        float frontier_phi_44_29_ladder_2;
        if (_861 == 2u) {
#if 1
          PQFromBT709(
              _858, _859, _860,
              _23_m0[4u].x, _23_m0[4u].y,
              frontier_phi_44_29_ladder_2, frontier_phi_44_29_ladder_1, frontier_phi_44_29_ladder);
#else
          float _1097 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _860, mad(0.3292830288410186767578125f, _859, _858 * 0.627403914928436279296875f)) * _23_m0[4u].y)) * _23_m0[4u].x);
          float _1098 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _860, mad(0.9195404052734375f, _859, _858 * 0.069097287952899932861328125f)) * _23_m0[4u].y)) * _23_m0[4u].x);
          float _1099 = exp2(log2(abs(mad(0.895595252513885498046875f, _860, mad(0.08801330626010894775390625f, _859, _858 * 0.01639143936336040496826171875f)) * _23_m0[4u].y)) * _23_m0[4u].x);
          frontier_phi_44_29_ladder = exp2(log2(abs(((_1099 * 18.8515625f) + 0.8359375f) / ((_1099 * 18.6875f) + 1.0f))) * 78.84375f);
          frontier_phi_44_29_ladder_1 = exp2(log2(abs(((_1098 * 18.8515625f) + 0.8359375f) / ((_1098 * 18.6875f) + 1.0f))) * 78.84375f);
          frontier_phi_44_29_ladder_2 = exp2(log2(abs(((_1097 * 18.8515625f) + 0.8359375f) / ((_1097 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
        } else {
          frontier_phi_44_29_ladder = _860;
          frontier_phi_44_29_ladder_1 = _859;
          frontier_phi_44_29_ladder_2 = _858;
        }
        _1129 = frontier_phi_44_29_ladder_2;
        _1131 = frontier_phi_44_29_ladder_1;
        _1133 = frontier_phi_44_29_ladder;
      }
      frontier_phi_1_2_ladder = half(_1129);
      frontier_phi_1_2_ladder_1 = half(_1131);
      frontier_phi_1_2_ladder_2 = half(_1133);
    } else {
      frontier_phi_1_2_ladder = _250;
      frontier_phi_1_2_ladder_1 = _251;
      frontier_phi_1_2_ladder_2 = _252;
    }
    _256 = frontier_phi_1_2_ladder;
    _258 = frontier_phi_1_2_ladder_1;
    _260 = frontier_phi_1_2_ladder_2;
  }
  _16[uint2(_72, _73)] = float4(float(_256), float(_258), float(_260), 1.0f);
  uint _270 = _72 | 8u;
  uint16_t _271 = uint16_t(_270);
  float _274 = (float(_271) + 0.5f) * _23_m0[1u].x;
  float4 _277 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_274, _86), 0.0f);
  half _282 = half(_277.x);
  half _283 = half(_277.y);
  half _284 = half(_277.z);
  float _288 = (float((_271 + 65535u)) + 0.5f) * _23_m0[1u].x;
  float4 _289 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_288, _111), 0.0f);
  half _294 = half(_289.x);
  half _295 = half(_289.y);
  half _296 = half(_289.z);
  float4 _297 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_274, _111), 0.0f);
  float _308 = (float((_271 + 1u)) + 0.5f) * _23_m0[1u].x;
  float4 _309 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_308, _111), 0.0f);
  half _314 = half(_309.x);
  half _315 = half(_309.y);
  half _316 = half(_309.z);
  float4 _317 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_274, _144), 0.0f);
  half _322 = half(_317.x);
  half _323 = half(_317.y);
  half _324 = half(_317.z);
  half _327 = min(min(_282, min(_294, _314)), _322);
  half _330 = min(min(_283, min(_295, _315)), _323);
  half _333 = min(min(_284, min(_296, _316)), _324);
  half _336 = max(max(_282, max(_294, _314)), _322);
  half _339 = max(max(_283, max(_295, _315)), _323);
  half _342 = max(max(_284, max(_296, _316)), _324);
  half _374 = max(half(-0.1875), min(max(max(half(-0.0) - (_327 * (half(0.25) / _336)), (half(1.0) / ((_327 * half(4.0)) + half(-4.0))) * (half(1.0) - _336)), max(max(half(-0.0) - (_330 * (half(0.25) / _339)), (half(1.0) / ((_330 * half(4.0)) + half(-4.0))) * (half(1.0) - _339)), max(half(-0.0) - (_333 * (half(0.25) / _342)), (half(1.0) / ((_333 * half(4.0)) + half(-4.0))) * (half(1.0) - _342)))), half(0.0))) * _214;
  half _376 = (_374 * half(4.0)) + half(1.0);
  half _384 = half(spvUnpackHalf2x16((30605u - spvPackHalf2x16(float2(float(_376), 0.0f))) & 65535u).x);
  half _387 = (half(2.0) - (_376 * _384)) * _384;
  half _406 = min(_387 * ((_374 * (((_294 + _282) + _314) + _322)) + half(_297.x)), _249);
  half _407 = min(_387 * ((_374 * (((_295 + _283) + _315) + _323)) + half(_297.y)), _249);
  half _408 = min(_387 * ((_374 * (((_296 + _284) + _316) + _324)) + half(_297.z)), _249);
  half _420;
  half _422;
  half _424;
  if (_255) {
    _420 = _406;
    _422 = _407;
    _424 = _408;
  } else {
    float4 _572 = _13.Load(int3(uint2(_270, _73), 0u));
    float _574 = _572.x;
    float _575 = _572.y;
    float _576 = _572.z;
    float _577 = _572.w;
    half frontier_phi_3_4_ladder;
    half frontier_phi_3_4_ladder_1;
    half frontier_phi_3_4_ladder_2;
    if ((max(_574, max(_575, _576)) + _577) > 0.0f) {
      float _736 = float(_406);
      float _737 = float(_407);
      float _738 = float(_408);
      uint _739 = uint(int(_23_m0[7u].w));
      float _927;
      float _929;
      float _931;
      if (_739 == 1u) {
        float _1033;
        if (_736 < 0.040449999272823333740234375f) {
          _1033 = _736 * 0.077399380505084991455078125f;
        } else {
          _1033 = exp2(log2(abs((_736 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
        }
        float _1387;
        if (_737 < 0.040449999272823333740234375f) {
          _1387 = _737 * 0.077399380505084991455078125f;
        } else {
          _1387 = exp2(log2(abs((_737 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
        }
        float _1522;
        if (_738 < 0.040449999272823333740234375f) {
          _1522 = _738 * 0.077399380505084991455078125f;
        } else {
          _1522 = exp2(log2(abs((_738 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
        }
        float _1523 = 1.0f / _23_m0[7u].x;
        _927 = exp2(log2(abs(_1033)) * _1523);
        _929 = exp2(log2(abs(_1387)) * _1523);
        _931 = exp2(log2(abs(_1522)) * _1523);
      } else {
        float frontier_phi_26_15_ladder;
        float frontier_phi_26_15_ladder_1;
        float frontier_phi_26_15_ladder_2;
        if (_739 == 2u) {
#if 1
          BT709FromPQ(
              _736, _737, _738,
              _23_m0[7u].x, _23_m0[7u].y,
              frontier_phi_26_15_ladder_2, frontier_phi_26_15_ladder_1, frontier_phi_26_15_ladder);
#else
          float _886 = exp2(log2(abs(_736)) * 0.0126833133399486541748046875f);
          float _887 = exp2(log2(abs(_737)) * 0.0126833133399486541748046875f);
          float _888 = exp2(log2(abs(_738)) * 0.0126833133399486541748046875f);
          float _901 = 1.0f / _23_m0[7u].x;
          float _914 = 1.0f / _23_m0[7u].y;
          float _915 = _914 * exp2(log2(abs((_886 + (-0.8359375f)) / (18.8515625f - (_886 * 18.6875f)))) * _901);
          float _916 = _914 * exp2(log2(abs((_887 + (-0.8359375f)) / (18.8515625f - (_887 * 18.6875f)))) * _901);
          float _917 = _914 * exp2(log2(abs((_888 + (-0.8359375f)) / (18.8515625f - (_888 * 18.6875f)))) * _901);
          frontier_phi_26_15_ladder = mad(1.11872994899749755859375f, _917, mad(-0.100579001009464263916015625f, _916, _915 * (-0.01815080083906650543212890625f)));
          frontier_phi_26_15_ladder_1 = mad(-0.008349419571459293365478515625f, _917, mad(1.1328999996185302734375f, _916, _915 * (-0.12454999983310699462890625f)));
          frontier_phi_26_15_ladder_2 = mad(-0.0728498995304107666015625f, _917, mad(-0.5876410007476806640625f, _916, _915 * 1.6604900360107421875f));
#endif
        } else {
          frontier_phi_26_15_ladder = _738;
          frontier_phi_26_15_ladder_1 = _737;
          frontier_phi_26_15_ladder_2 = _736;
        }
        _927 = frontier_phi_26_15_ladder_2;
        _929 = frontier_phi_26_15_ladder_1;
        _931 = frontier_phi_26_15_ladder;
      }
      float _933 = 1.0f - _577;
      float _937 = (_927 * _933) + _574;
      float _938 = (_929 * _933) + _575;
      float _939 = (_931 * _933) + _576;
      uint _940 = uint(int(_23_m0[4u].w));
      float _1289;
      float _1291;
      float _1293;
      if (_940 == 1u) {
        float _1044 = exp2(log2(abs(_937)) * _23_m0[4u].x);
        float _1045 = exp2(log2(abs(_938)) * _23_m0[4u].x);
        float _1046 = exp2(log2(abs(_939)) * _23_m0[4u].x);
        float _1290;
        if (_1044 < 0.00310000008903443813323974609375f) {
          _1290 = _1044 * 12.9200000762939453125f;
        } else {
          _1290 = (exp2(log2(abs(_1044)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        float _1292;
        if (_1045 < 0.00310000008903443813323974609375f) {
          _1292 = _1045 * 12.9200000762939453125f;
        } else {
          _1292 = (exp2(log2(abs(_1045)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        float frontier_phi_57_96_ladder;
        float frontier_phi_57_96_ladder_1;
        float frontier_phi_57_96_ladder_2;
        if (_1046 < 0.00310000008903443813323974609375f) {
          frontier_phi_57_96_ladder = _1046 * 12.9200000762939453125f;
          frontier_phi_57_96_ladder_1 = _1292;
          frontier_phi_57_96_ladder_2 = _1290;
        } else {
          frontier_phi_57_96_ladder = (exp2(log2(abs(_1046)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
          frontier_phi_57_96_ladder_1 = _1292;
          frontier_phi_57_96_ladder_2 = _1290;
        }
        _1289 = frontier_phi_57_96_ladder_2;
        _1291 = frontier_phi_57_96_ladder_1;
        _1293 = frontier_phi_57_96_ladder;
      } else {
        float frontier_phi_57_38_ladder;
        float frontier_phi_57_38_ladder_1;
        float frontier_phi_57_38_ladder_2;
        if (_940 == 2u) {
#if 1
          PQFromBT709(
              _937, _938, _939,
              _23_m0[4u].x, _23_m0[4u].y,
              frontier_phi_57_38_ladder_2, frontier_phi_57_38_ladder_1, frontier_phi_57_38_ladder);
#else
          float _1259 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _939, mad(0.3292830288410186767578125f, _938, _937 * 0.627403914928436279296875f)) * _23_m0[4u].y)) * _23_m0[4u].x);
          float _1260 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _939, mad(0.9195404052734375f, _938, _937 * 0.069097287952899932861328125f)) * _23_m0[4u].y)) * _23_m0[4u].x);
          float _1261 = exp2(log2(abs(mad(0.895595252513885498046875f, _939, mad(0.08801330626010894775390625f, _938, _937 * 0.01639143936336040496826171875f)) * _23_m0[4u].y)) * _23_m0[4u].x);
          frontier_phi_57_38_ladder = exp2(log2(abs(((_1261 * 18.8515625f) + 0.8359375f) / ((_1261 * 18.6875f) + 1.0f))) * 78.84375f);
          frontier_phi_57_38_ladder_1 = exp2(log2(abs(((_1260 * 18.8515625f) + 0.8359375f) / ((_1260 * 18.6875f) + 1.0f))) * 78.84375f);
          frontier_phi_57_38_ladder_2 = exp2(log2(abs(((_1259 * 18.8515625f) + 0.8359375f) / ((_1259 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
        } else {
          frontier_phi_57_38_ladder = _939;
          frontier_phi_57_38_ladder_1 = _938;
          frontier_phi_57_38_ladder_2 = _937;
        }
        _1289 = frontier_phi_57_38_ladder_2;
        _1291 = frontier_phi_57_38_ladder_1;
        _1293 = frontier_phi_57_38_ladder;
      }
      frontier_phi_3_4_ladder = half(_1289);
      frontier_phi_3_4_ladder_1 = half(_1293);
      frontier_phi_3_4_ladder_2 = half(_1291);
    } else {
      frontier_phi_3_4_ladder = _406;
      frontier_phi_3_4_ladder_1 = _408;
      frontier_phi_3_4_ladder_2 = _407;
    }
    _420 = frontier_phi_3_4_ladder;
    _422 = frontier_phi_3_4_ladder_2;
    _424 = frontier_phi_3_4_ladder_1;
  }
  _16[uint2(_270, _73)] = float4(float(_420), float(_422), float(_424), 1.0f);
  uint _432 = _73 | 8u;
  uint16_t _433 = uint16_t(_432);
  float _437 = (float((_433 + 65535u)) + 0.5f) * _23_m0[1u].y;
  float4 _440 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_274, _437), 0.0f);
  half _445 = half(_440.x);
  half _446 = half(_440.y);
  half _447 = half(_440.z);
  float _450 = (float(_433) + 0.5f) * _23_m0[1u].y;
  float4 _451 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_288, _450), 0.0f);
  half _456 = half(_451.x);
  half _457 = half(_451.y);
  half _458 = half(_451.z);
  float4 _459 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_274, _450), 0.0f);
  float4 _467 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_308, _450), 0.0f);
  half _472 = half(_467.x);
  half _473 = half(_467.y);
  half _474 = half(_467.z);
  float _478 = (float((_433 + 1u)) + 0.5f) * _23_m0[1u].y;
  float4 _479 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_274, _478), 0.0f);
  half _484 = half(_479.x);
  half _485 = half(_479.y);
  half _486 = half(_479.z);
  half _489 = min(min(_445, min(_456, _472)), _484);
  half _492 = min(min(_446, min(_457, _473)), _485);
  half _495 = min(min(_447, min(_458, _474)), _486);
  half _498 = max(max(_445, max(_456, _472)), _484);
  half _501 = max(max(_446, max(_457, _473)), _485);
  half _504 = max(max(_447, max(_458, _474)), _486);
  half _536 = max(half(-0.1875), min(max(max(half(-0.0) - (_489 * (half(0.25) / _498)), (half(1.0) / ((_489 * half(4.0)) + half(-4.0))) * (half(1.0) - _498)), max(max(half(-0.0) - (_492 * (half(0.25) / _501)), (half(1.0) / ((_492 * half(4.0)) + half(-4.0))) * (half(1.0) - _501)), max(half(-0.0) - (_495 * (half(0.25) / _504)), (half(1.0) / ((_495 * half(4.0)) + half(-4.0))) * (half(1.0) - _504)))), half(0.0))) * _214;
  half _538 = (_536 * half(4.0)) + half(1.0);
  half _546 = half(spvUnpackHalf2x16((30605u - spvPackHalf2x16(float2(float(_538), 0.0f))) & 65535u).x);
  half _549 = (half(2.0) - (_538 * _546)) * _546;
  half _568 = min(_549 * ((_536 * (((_456 + _445) + _472) + _484)) + half(_459.x)), _249);
  half _569 = min(_549 * ((_536 * (((_457 + _446) + _473) + _485)) + half(_459.y)), _249);
  half _570 = min(_549 * ((_536 * (((_458 + _447) + _474) + _486)) + half(_459.z)), _249);
  half _587;
  half _589;
  half _591;
  if (_255) {
    _587 = _568;
    _589 = _569;
    _591 = _570;
  } else {
    float4 _726 = _13.Load(int3(uint2(_270, _432), 0u));
    float _728 = _726.x;
    float _729 = _726.y;
    float _730 = _726.z;
    float _731 = _726.w;
    half frontier_phi_6_7_ladder;
    half frontier_phi_6_7_ladder_1;
    half frontier_phi_6_7_ladder_2;
    if ((max(_728, max(_729, _730)) + _731) > 0.0f) {
      float _767 = float(_568);
      float _768 = float(_569);
      float _769 = float(_570);
      uint _770 = uint(int(_23_m0[7u].w));
      float _1018;
      float _1020;
      float _1022;
      if (_770 == 1u) {
        float _1208;
        if (_767 < 0.040449999272823333740234375f) {
          _1208 = _767 * 0.077399380505084991455078125f;
        } else {
          _1208 = exp2(log2(abs((_767 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
        }
        float _1476;
        if (_768 < 0.040449999272823333740234375f) {
          _1476 = _768 * 0.077399380505084991455078125f;
        } else {
          _1476 = exp2(log2(abs((_768 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
        }
        float _1553;
        if (_769 < 0.040449999272823333740234375f) {
          _1553 = _769 * 0.077399380505084991455078125f;
        } else {
          _1553 = exp2(log2(abs((_769 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
        }
        float _1554 = 1.0f / _23_m0[7u].x;
        _1018 = exp2(log2(abs(_1208)) * _1554);
        _1020 = exp2(log2(abs(_1476)) * _1554);
        _1022 = exp2(log2(abs(_1553)) * _1554);
      } else {
        float frontier_phi_35_22_ladder;
        float frontier_phi_35_22_ladder_1;
        float frontier_phi_35_22_ladder_2;
        if (_770 == 2u) {
#if 1
          BT709FromPQ(
              _767, _768, _769,
              _23_m0[7u].x, _23_m0[7u].y,
              frontier_phi_35_22_ladder_2, frontier_phi_35_22_ladder_1, frontier_phi_35_22_ladder);
#else
          float _977 = exp2(log2(abs(_767)) * 0.0126833133399486541748046875f);
          float _978 = exp2(log2(abs(_768)) * 0.0126833133399486541748046875f);
          float _979 = exp2(log2(abs(_769)) * 0.0126833133399486541748046875f);
          float _992 = 1.0f / _23_m0[7u].x;
          float _1005 = 1.0f / _23_m0[7u].y;
          float _1006 = _1005 * exp2(log2(abs((_977 + (-0.8359375f)) / (18.8515625f - (_977 * 18.6875f)))) * _992);
          float _1007 = _1005 * exp2(log2(abs((_978 + (-0.8359375f)) / (18.8515625f - (_978 * 18.6875f)))) * _992);
          float _1008 = _1005 * exp2(log2(abs((_979 + (-0.8359375f)) / (18.8515625f - (_979 * 18.6875f)))) * _992);
          frontier_phi_35_22_ladder = mad(1.11872994899749755859375f, _1008, mad(-0.100579001009464263916015625f, _1007, _1006 * (-0.01815080083906650543212890625f)));
          frontier_phi_35_22_ladder_1 = mad(-0.008349419571459293365478515625f, _1008, mad(1.1328999996185302734375f, _1007, _1006 * (-0.12454999983310699462890625f)));
          frontier_phi_35_22_ladder_2 = mad(-0.0728498995304107666015625f, _1008, mad(-0.5876410007476806640625f, _1007, _1006 * 1.6604900360107421875f));
#endif
        } else {
          frontier_phi_35_22_ladder = _769;
          frontier_phi_35_22_ladder_1 = _768;
          frontier_phi_35_22_ladder_2 = _767;
        }
        _1018 = frontier_phi_35_22_ladder_2;
        _1020 = frontier_phi_35_22_ladder_1;
        _1022 = frontier_phi_35_22_ladder;
      }
      float _1024 = 1.0f - _731;
      float _1028 = (_1018 * _1024) + _728;
      float _1029 = (_1020 * _1024) + _729;
      float _1030 = (_1022 * _1024) + _730;
      uint _1031 = uint(int(_23_m0[4u].w));
      float _1380;
      float _1382;
      float _1384;
      if (_1031 == 1u) {
        float _1219 = exp2(log2(abs(_1028)) * _23_m0[4u].x);
        float _1220 = exp2(log2(abs(_1029)) * _23_m0[4u].x);
        float _1221 = exp2(log2(abs(_1030)) * _23_m0[4u].x);
        float _1381;
        if (_1219 < 0.00310000008903443813323974609375f) {
          _1381 = _1219 * 12.9200000762939453125f;
        } else {
          _1381 = (exp2(log2(abs(_1219)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        float _1383;
        if (_1220 < 0.00310000008903443813323974609375f) {
          _1383 = _1220 * 12.9200000762939453125f;
        } else {
          _1383 = (exp2(log2(abs(_1220)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        float frontier_phi_68_104_ladder;
        float frontier_phi_68_104_ladder_1;
        float frontier_phi_68_104_ladder_2;
        if (_1221 < 0.00310000008903443813323974609375f) {
          frontier_phi_68_104_ladder = _1221 * 12.9200000762939453125f;
          frontier_phi_68_104_ladder_1 = _1383;
          frontier_phi_68_104_ladder_2 = _1381;
        } else {
          frontier_phi_68_104_ladder = (exp2(log2(abs(_1221)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
          frontier_phi_68_104_ladder_1 = _1383;
          frontier_phi_68_104_ladder_2 = _1381;
        }
        _1380 = frontier_phi_68_104_ladder_2;
        _1382 = frontier_phi_68_104_ladder_1;
        _1384 = frontier_phi_68_104_ladder;
      } else {
        float frontier_phi_68_51_ladder;
        float frontier_phi_68_51_ladder_1;
        float frontier_phi_68_51_ladder_2;
        if (_1031 == 2u) {
#if 1
          PQFromBT709(
              _1028, _1029, _1030,
              _23_m0[4u].x, _23_m0[4u].y,
              frontier_phi_68_51_ladder_2, frontier_phi_68_51_ladder_1, frontier_phi_68_51_ladder);
#else
          float _1350 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _1030, mad(0.3292830288410186767578125f, _1029, _1028 * 0.627403914928436279296875f)) * _23_m0[4u].y)) * _23_m0[4u].x);
          float _1351 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _1030, mad(0.9195404052734375f, _1029, _1028 * 0.069097287952899932861328125f)) * _23_m0[4u].y)) * _23_m0[4u].x);
          float _1352 = exp2(log2(abs(mad(0.895595252513885498046875f, _1030, mad(0.08801330626010894775390625f, _1029, _1028 * 0.01639143936336040496826171875f)) * _23_m0[4u].y)) * _23_m0[4u].x);
          frontier_phi_68_51_ladder = exp2(log2(abs(((_1352 * 18.8515625f) + 0.8359375f) / ((_1352 * 18.6875f) + 1.0f))) * 78.84375f);
          frontier_phi_68_51_ladder_1 = exp2(log2(abs(((_1351 * 18.8515625f) + 0.8359375f) / ((_1351 * 18.6875f) + 1.0f))) * 78.84375f);
          frontier_phi_68_51_ladder_2 = exp2(log2(abs(((_1350 * 18.8515625f) + 0.8359375f) / ((_1350 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
        } else {
          frontier_phi_68_51_ladder = _1030;
          frontier_phi_68_51_ladder_1 = _1029;
          frontier_phi_68_51_ladder_2 = _1028;
        }
        _1380 = frontier_phi_68_51_ladder_2;
        _1382 = frontier_phi_68_51_ladder_1;
        _1384 = frontier_phi_68_51_ladder;
      }
      frontier_phi_6_7_ladder = half(_1380);
      frontier_phi_6_7_ladder_1 = half(_1382);
      frontier_phi_6_7_ladder_2 = half(_1384);
    } else {
      frontier_phi_6_7_ladder = _568;
      frontier_phi_6_7_ladder_1 = _569;
      frontier_phi_6_7_ladder_2 = _570;
    }
    _587 = frontier_phi_6_7_ladder;
    _589 = frontier_phi_6_7_ladder_1;
    _591 = frontier_phi_6_7_ladder_2;
  }
  _16[uint2(_270, _432)] = float4(float(_587), float(_589), float(_591), 1.0f);
  float4 _601 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_85, _437), 0.0f);
  half _606 = half(_601.x);
  half _607 = half(_601.y);
  half _608 = half(_601.z);
  float4 _609 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_110, _450), 0.0f);
  half _614 = half(_609.x);
  half _615 = half(_609.y);
  half _616 = half(_609.z);
  float4 _617 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_85, _450), 0.0f);
  float4 _625 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_132, _450), 0.0f);
  half _630 = half(_625.x);
  half _631 = half(_625.y);
  half _632 = half(_625.z);
  float4 _633 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2], float2(_85, _478), 0.0f);
  half _638 = half(_633.x);
  half _639 = half(_633.y);
  half _640 = half(_633.z);
  half _643 = min(min(_606, min(_614, _630)), _638);
  half _646 = min(min(_607, min(_615, _631)), _639);
  half _649 = min(min(_608, min(_616, _632)), _640);
  half _652 = max(max(_606, max(_614, _630)), _638);
  half _655 = max(max(_607, max(_615, _631)), _639);
  half _658 = max(max(_608, max(_616, _632)), _640);
  half _690 = max(half(-0.1875), min(max(max(half(-0.0) - (_643 * (half(0.25) / _652)), (half(1.0) / ((_643 * half(4.0)) + half(-4.0))) * (half(1.0) - _652)), max(max(half(-0.0) - (_646 * (half(0.25) / _655)), (half(1.0) / ((_646 * half(4.0)) + half(-4.0))) * (half(1.0) - _655)), max(half(-0.0) - (_649 * (half(0.25) / _658)), (half(1.0) / ((_649 * half(4.0)) + half(-4.0))) * (half(1.0) - _658)))), half(0.0))) * _214;
  half _692 = (_690 * half(4.0)) + half(1.0);
  half _700 = half(spvUnpackHalf2x16((30605u - spvPackHalf2x16(float2(float(_692), 0.0f))) & 65535u).x);
  half _703 = (half(2.0) - (_692 * _700)) * _700;
  half _722 = min(_703 * ((_690 * (((_614 + _606) + _630) + _638)) + half(_617.x)), _249);
  half _723 = min(_703 * ((_690 * (((_615 + _607) + _631) + _639)) + half(_617.y)), _249);
  half _724 = min(_703 * ((_690 * (((_616 + _608) + _632) + _640)) + half(_617.z)), _249);
  half _744;
  half _746;
  half _748;
  if (_255) {
    _744 = _722;
    _746 = _723;
    _748 = _724;
  } else {
    float4 _757 = _13.Load(int3(uint2(_72, _432), 0u));
    float _759 = _757.x;
    float _760 = _757.y;
    float _761 = _757.z;
    float _762 = _757.w;
    half frontier_phi_11_12_ladder;
    half frontier_phi_11_12_ladder_1;
    half frontier_phi_11_12_ladder_2;
    if ((max(_759, max(_760, _761)) + _762) > 0.0f) {
      float _863 = float(_722);
      float _864 = float(_723);
      float _865 = float(_724);
      uint _866 = uint(int(_23_m0[7u].w));
      float _1193;
      float _1195;
      float _1197;
      if (_866 == 1u) {
        float _1299;
        if (_863 < 0.040449999272823333740234375f) {
          _1299 = _863 * 0.077399380505084991455078125f;
        } else {
          _1299 = exp2(log2(abs((_863 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
        }
        float _1505;
        if (_864 < 0.040449999272823333740234375f) {
          _1505 = _864 * 0.077399380505084991455078125f;
        } else {
          _1505 = exp2(log2(abs((_864 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
        }
        float _1570;
        if (_865 < 0.040449999272823333740234375f) {
          _1570 = _865 * 0.077399380505084991455078125f;
        } else {
          _1570 = exp2(log2(abs((_865 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
        }
        float _1571 = 1.0f / _23_m0[7u].x;
        _1193 = exp2(log2(abs(_1299)) * _1571);
        _1195 = exp2(log2(abs(_1505)) * _1571);
        _1197 = exp2(log2(abs(_1570)) * _1571);
      } else {
        float frontier_phi_48_31_ladder;
        float frontier_phi_48_31_ladder_1;
        float frontier_phi_48_31_ladder_2;
        if (_866 == 2u) {
#if 1
          BT709FromPQ(
              _863, _864, _865,
              _23_m0[7u].x, _23_m0[7u].y,
              frontier_phi_48_31_ladder_2, frontier_phi_48_31_ladder_1, frontier_phi_48_31_ladder);
#else
          float _1152 = exp2(log2(abs(_863)) * 0.0126833133399486541748046875f);
          float _1153 = exp2(log2(abs(_864)) * 0.0126833133399486541748046875f);
          float _1154 = exp2(log2(abs(_865)) * 0.0126833133399486541748046875f);
          float _1167 = 1.0f / _23_m0[7u].x;
          float _1180 = 1.0f / _23_m0[7u].y;
          float _1181 = _1180 * exp2(log2(abs((_1152 + (-0.8359375f)) / (18.8515625f - (_1152 * 18.6875f)))) * _1167);
          float _1182 = _1180 * exp2(log2(abs((_1153 + (-0.8359375f)) / (18.8515625f - (_1153 * 18.6875f)))) * _1167);
          float _1183 = _1180 * exp2(log2(abs((_1154 + (-0.8359375f)) / (18.8515625f - (_1154 * 18.6875f)))) * _1167);
          frontier_phi_48_31_ladder = mad(1.11872994899749755859375f, _1183, mad(-0.100579001009464263916015625f, _1182, _1181 * (-0.01815080083906650543212890625f)));
          frontier_phi_48_31_ladder_1 = mad(-0.008349419571459293365478515625f, _1183, mad(1.1328999996185302734375f, _1182, _1181 * (-0.12454999983310699462890625f)));
          frontier_phi_48_31_ladder_2 = mad(-0.0728498995304107666015625f, _1183, mad(-0.5876410007476806640625f, _1182, _1181 * 1.6604900360107421875f));
#endif
        } else {
          frontier_phi_48_31_ladder = _865;
          frontier_phi_48_31_ladder_1 = _864;
          frontier_phi_48_31_ladder_2 = _863;
        }
        _1193 = frontier_phi_48_31_ladder_2;
        _1195 = frontier_phi_48_31_ladder_1;
        _1197 = frontier_phi_48_31_ladder;
      }
      float _1199 = 1.0f - _762;
      float _1203 = (_1193 * _1199) + _759;
      float _1204 = (_1195 * _1199) + _760;
      float _1205 = (_1197 * _1199) + _761;
      uint _1206 = uint(int(_23_m0[4u].w));
      float _1469;
      float _1471;
      float _1473;
      if (_1206 == 1u) {
        float _1310 = exp2(log2(abs(_1203)) * _23_m0[4u].x);
        float _1311 = exp2(log2(abs(_1204)) * _23_m0[4u].x);
        float _1312 = exp2(log2(abs(_1205)) * _23_m0[4u].x);
        float _1470;
        if (_1310 < 0.00310000008903443813323974609375f) {
          _1470 = _1310 * 12.9200000762939453125f;
        } else {
          _1470 = (exp2(log2(abs(_1310)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        float _1472;
        if (_1311 < 0.00310000008903443813323974609375f) {
          _1472 = _1311 * 12.9200000762939453125f;
        } else {
          _1472 = (exp2(log2(abs(_1311)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
        }
        float frontier_phi_80_108_ladder;
        float frontier_phi_80_108_ladder_1;
        float frontier_phi_80_108_ladder_2;
        if (_1312 < 0.00310000008903443813323974609375f) {
          frontier_phi_80_108_ladder = _1312 * 12.9200000762939453125f;
          frontier_phi_80_108_ladder_1 = _1472;
          frontier_phi_80_108_ladder_2 = _1470;
        } else {
          frontier_phi_80_108_ladder = (exp2(log2(abs(_1312)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
          frontier_phi_80_108_ladder_1 = _1472;
          frontier_phi_80_108_ladder_2 = _1470;
        }
        _1469 = frontier_phi_80_108_ladder_2;
        _1471 = frontier_phi_80_108_ladder_1;
        _1473 = frontier_phi_80_108_ladder;
      } else {
        float frontier_phi_80_62_ladder;
        float frontier_phi_80_62_ladder_1;
        float frontier_phi_80_62_ladder_2;
        if (_1206 == 2u) {
#if 1
          PQFromBT709(
              _1203, _1204, _1205,
              _23_m0[4u].x, _23_m0[4u].y,
              frontier_phi_80_62_ladder_2, frontier_phi_80_62_ladder_1, frontier_phi_80_62_ladder);
#else
          float _1439 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _1205, mad(0.3292830288410186767578125f, _1204, _1203 * 0.627403914928436279296875f)) * _23_m0[4u].y)) * _23_m0[4u].x);
          float _1440 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _1205, mad(0.9195404052734375f, _1204, _1203 * 0.069097287952899932861328125f)) * _23_m0[4u].y)) * _23_m0[4u].x);
          float _1441 = exp2(log2(abs(mad(0.895595252513885498046875f, _1205, mad(0.08801330626010894775390625f, _1204, _1203 * 0.01639143936336040496826171875f)) * _23_m0[4u].y)) * _23_m0[4u].x);
          frontier_phi_80_62_ladder = exp2(log2(abs(((_1441 * 18.8515625f) + 0.8359375f) / ((_1441 * 18.6875f) + 1.0f))) * 78.84375f);
          frontier_phi_80_62_ladder_1 = exp2(log2(abs(((_1440 * 18.8515625f) + 0.8359375f) / ((_1440 * 18.6875f) + 1.0f))) * 78.84375f);
          frontier_phi_80_62_ladder_2 = exp2(log2(abs(((_1439 * 18.8515625f) + 0.8359375f) / ((_1439 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
        } else {
          frontier_phi_80_62_ladder = _1205;
          frontier_phi_80_62_ladder_1 = _1204;
          frontier_phi_80_62_ladder_2 = _1203;
        }
        _1469 = frontier_phi_80_62_ladder_2;
        _1471 = frontier_phi_80_62_ladder_1;
        _1473 = frontier_phi_80_62_ladder;
      }
      frontier_phi_11_12_ladder = half(_1469);
      frontier_phi_11_12_ladder_1 = half(_1473);
      frontier_phi_11_12_ladder_2 = half(_1471);
    } else {
      frontier_phi_11_12_ladder = _722;
      frontier_phi_11_12_ladder_1 = _724;
      frontier_phi_11_12_ladder_2 = _723;
    }
    _744 = frontier_phi_11_12_ladder;
    _746 = frontier_phi_11_12_ladder_2;
    _748 = frontier_phi_11_12_ladder_1;
  }
  _16[uint2(_72, _432)] = float4(float(_744), float(_746), float(_748), 1.0f);
}

[numthreads(64, 1, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}

