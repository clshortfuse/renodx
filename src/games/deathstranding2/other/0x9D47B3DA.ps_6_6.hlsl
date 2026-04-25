#include "../common.hlsli"
#include "../tonemap/tonemap.hlsli"

cbuffer _17_19 : register(b0, space8) {
  float4 _19_m0[7] : packoffset(c0);
};

// SamplerState _8[] : register(s0, space0);
Texture2D<float4> _12 : register(t0, space8);

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  noperspective float4 gl_FragCoord : SV_Position;
  linear float2 TEXCOORD : TEXCOORD0;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  // float4 _68 = _12.Sample(_8[21u], float2(TEXCOORD.x, TEXCOORD.y));
  float4 _68 = _12.Sample((SamplerState)ResourceDescriptorHeap[21u], float2(TEXCOORD.x, TEXCOORD.y));
  // float4 _74 = _12.Sample(_8[21u], float2(TEXCOORD.x, _19_m0[0u].w + TEXCOORD.y));
  float4 _74 = _12.Sample((SamplerState)ResourceDescriptorHeap[21u], float2(TEXCOORD.x, _19_m0[0u].w + TEXCOORD.y));
  float _82 = _19_m0[0u].z + TEXCOORD.x;
  // float4 _87 = _12.Sample(_8[21u], float2(_82, TEXCOORD.y));
  float4 _87 = _12.Sample((SamplerState)ResourceDescriptorHeap[21u], float2(_82, TEXCOORD.y));
  // float4 _96 = _12.Sample(_8[21u], float2(_82, _19_m0[0u].w + TEXCOORD.y));
  float4 _96 = _12.Sample((SamplerState)ResourceDescriptorHeap[21u], float2(_82, _19_m0[0u].w + TEXCOORD.y));
  float _101 = (_87.x + (_68.x + _74.x)) + _96.x;
  float _102 = (_87.y + (_68.y + _74.y)) + _96.y;
  float _103 = (_87.z + (_68.z + _74.z)) + _96.z;
  float _114 = _101 * 0.25f;
  float _116 = _102 * 0.25f;
  float _117 = _103 * 0.25f;
  uint _118 = uint(int(_19_m0[2u].w));
  float _200;
  float _202;
  float _204;
  if (_118 == 1u) {
    float _253;
    if (_114 < 0.040449999272823333740234375f) {
      _253 = _101 * 0.01934984512627124786376953125f;
    } else {
      _253 = exp2(log2(abs((_101 * 0.2369668185710906982421875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
    }
    float _362;
    if (_116 < 0.040449999272823333740234375f) {
      _362 = _102 * 0.01934984512627124786376953125f;
    } else {
      _362 = exp2(log2(abs((_102 * 0.2369668185710906982421875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
    }
    float _379;
    if (_117 < 0.040449999272823333740234375f) {
      _379 = _103 * 0.01934984512627124786376953125f;
    } else {
      _379 = exp2(log2(abs((_103 * 0.2369668185710906982421875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
    }
    float _380 = 1.0f / _19_m0[2u].x;
    _200 = exp2(log2(abs(_253)) * _380);
    _202 = exp2(log2(abs(_362)) * _380);
    _204 = exp2(log2(abs(_379)) * _380);
  } else {
    float frontier_phi_7_3_ladder;
    float frontier_phi_7_3_ladder_1;
    float frontier_phi_7_3_ladder_2;
    if (_118 == 2u) {
#if 1
      BT709FromPQ(
          _114, _116, _117,
          _19_m0[2u].x, _19_m0[2u].y,
          frontier_phi_7_3_ladder,
          frontier_phi_7_3_ladder_1,
          frontier_phi_7_3_ladder_2);
#else
      float _146 = exp2(log2(abs(_114)) * 0.0126833133399486541748046875f);
      float _147 = exp2(log2(abs(_116)) * 0.0126833133399486541748046875f);
      float _148 = exp2(log2(abs(_117)) * 0.0126833133399486541748046875f);
      float _164 = 1.0f / _19_m0[2u].x;
      float _178 = 1.0f / _19_m0[2u].y;
      float _179 = _178 * exp2(log2(abs((_146 + (-0.8359375f)) / (18.8515625f - (_146 * 18.6875f)))) * _164);
      float _180 = _178 * exp2(log2(abs((_147 + (-0.8359375f)) / (18.8515625f - (_147 * 18.6875f)))) * _164);
      float _181 = _178 * exp2(log2(abs((_148 + (-0.8359375f)) / (18.8515625f - (_148 * 18.6875f)))) * _164);
      frontier_phi_7_3_ladder = mad(-0.0728498995304107666015625f, _181, mad(-0.5876410007476806640625f, _180, _179 * 1.6604900360107421875f));
      frontier_phi_7_3_ladder_1 = mad(-0.008349419571459293365478515625f, _181, mad(1.1328999996185302734375f, _180, _179 * (-0.12454999983310699462890625f)));
      frontier_phi_7_3_ladder_2 = mad(1.11872994899749755859375f, _181, mad(-0.100579001009464263916015625f, _180, _179 * (-0.01815080083906650543212890625f)));
#endif
    } else {
      frontier_phi_7_3_ladder = _114;
      frontier_phi_7_3_ladder_1 = _116;
      frontier_phi_7_3_ladder_2 = _117;
    }
    _200 = frontier_phi_7_3_ladder;
    _202 = frontier_phi_7_3_ladder_1;
    _204 = frontier_phi_7_3_ladder_2;
  }
  // itm
  float _212 = (-0.0f) - _19_m0[5u].x;
  float _224 = (_200 < _19_m0[4u].w) ? ((_200 - _19_m0[4u].y) / _19_m0[4u].x) : ((_212 / (_200 - _19_m0[5u].z)) - _19_m0[5u].y);
  float _226 = (_202 < _19_m0[4u].w) ? ((_202 - _19_m0[4u].y) / _19_m0[4u].x) : ((_212 / (_202 - _19_m0[5u].z)) - _19_m0[5u].y);
  float _228 = (_204 < _19_m0[4u].w) ? ((_204 - _19_m0[4u].y) / _19_m0[4u].x) : ((_212 / (_204 - _19_m0[5u].z)) - _19_m0[5u].y);

// tm
#if 1
  float _246;
  float _248;
  float _250;
  ApplyUserGradingAndToneMapAndScale(
      _224, _226, _228,
      _19_m0[4u].x, _19_m0[4u].y,
      _19_m0[4u].z,
      _19_m0[6u].x, _19_m0[6u].y, _19_m0[6u].z,
      _246, _248, _250);
#else
  float _235 = (-0.0f) - _19_m0[6u].x;
  float _246 = (_224 < _19_m0[4u].z) ? ((_224 * _19_m0[4u].x) + _19_m0[4u].y) : ((_235 / (_224 + _19_m0[6u].y)) + _19_m0[6u].z);
  float _248 = (_226 < _19_m0[4u].z) ? ((_226 * _19_m0[4u].x) + _19_m0[4u].y) : ((_235 / (_226 + _19_m0[6u].y)) + _19_m0[6u].z);
  float _250 = (_228 < _19_m0[4u].z) ? ((_228 * _19_m0[4u].x) + _19_m0[4u].y) : ((_235 / (_228 + _19_m0[6u].y)) + _19_m0[6u].z);
#endif
  uint _251 = uint(int(_19_m0[3u].w));
  float _350;
  float _352;
  float _354;
  if (_251 == 1u) {
    float _264 = exp2(log2(abs(_246)) * _19_m0[3u].x);
    float _265 = exp2(log2(abs(_248)) * _19_m0[3u].x);
    float _266 = exp2(log2(abs(_250)) * _19_m0[3u].x);
    float _351;
    if (_264 < 0.00310000008903443813323974609375f) {
      _351 = _264 * 12.9200000762939453125f;
    } else {
      _351 = (exp2(log2(abs(_264)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _353;
    if (_265 < 0.00310000008903443813323974609375f) {
      _353 = _265 * 12.9200000762939453125f;
    } else {
      _353 = (exp2(log2(abs(_265)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_16_24_ladder;
    float frontier_phi_16_24_ladder_1;
    float frontier_phi_16_24_ladder_2;
    if (_266 < 0.00310000008903443813323974609375f) {
      frontier_phi_16_24_ladder = _351;
      frontier_phi_16_24_ladder_1 = _353;
      frontier_phi_16_24_ladder_2 = _266 * 12.9200000762939453125f;
    } else {
      frontier_phi_16_24_ladder = _351;
      frontier_phi_16_24_ladder_1 = _353;
      frontier_phi_16_24_ladder_2 = (exp2(log2(abs(_266)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    _350 = frontier_phi_16_24_ladder;
    _352 = frontier_phi_16_24_ladder_1;
    _354 = frontier_phi_16_24_ladder_2;
  } else {
    float frontier_phi_16_10_ladder;
    float frontier_phi_16_10_ladder_1;
    float frontier_phi_16_10_ladder_2;
    if (_251 == 2u) {
#if 1
      PQFromBT709(
          _246, _248, _250,
          _19_m0[3u].x, _19_m0[3u].y,
          frontier_phi_16_10_ladder,
          frontier_phi_16_10_ladder_1,
          frontier_phi_16_10_ladder_2);
#else
      float _318 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _250, mad(0.3292830288410186767578125f, _248, _246 * 0.627403914928436279296875f)) * _19_m0[3u].y)) * _19_m0[3u].x);
      float _319 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _250, mad(0.9195404052734375f, _248, _246 * 0.069097287952899932861328125f)) * _19_m0[3u].y)) * _19_m0[3u].x);
      float _320 = exp2(log2(abs(mad(0.895595252513885498046875f, _250, mad(0.08801330626010894775390625f, _248, _246 * 0.01639143936336040496826171875f)) * _19_m0[3u].y)) * _19_m0[3u].x);
      frontier_phi_16_10_ladder = exp2(log2(abs(((_318 * 18.8515625f) + 0.8359375f) / ((_318 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_16_10_ladder_1 = exp2(log2(abs(((_319 * 18.8515625f) + 0.8359375f) / ((_319 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_16_10_ladder_2 = exp2(log2(abs(((_320 * 18.8515625f) + 0.8359375f) / ((_320 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_16_10_ladder = _246;
      frontier_phi_16_10_ladder_1 = _248;
      frontier_phi_16_10_ladder_2 = _250;
    }
    _350 = frontier_phi_16_10_ladder;
    _352 = frontier_phi_16_10_ladder_1;
    _354 = frontier_phi_16_10_ladder_2;
  }
  SV_Target.x = _350;
  SV_Target.y = _352;
  SV_Target.z = _354;
  SV_Target.w = 1.0f;
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
