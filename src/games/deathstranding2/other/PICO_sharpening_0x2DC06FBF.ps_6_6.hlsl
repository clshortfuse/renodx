#include "../common.hlsli"

cbuffer _19_21 : register(b0, space5) {
  float4 _21_m0[3] : packoffset(c0);
};

// SamplerState _8[] : register(s0, space0);
Texture2D<float4> _12 : register(t0, space5);
Texture2D<float4> _13 : register(t1, space5);
Texture2D<float4> _14 : register(t2, space5);

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  noperspective float4 gl_FragCoord : SV_Position;
  linear float2 TEXCOORD : TEXCOORD;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

void frag_main() {
  float4 _64 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(0, -1));
  float4 _71 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, 0));
  float4 _77 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(TEXCOORD.x, TEXCOORD.y), 0.0f);
  float4 _83 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, 0));
  float4 _89 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(0, 1));
  float _96 = sqrt(_64.x);
  float _97 = sqrt(_64.y);
  float _98 = sqrt(_64.z);
  float _104 = ((_98 + _96) * 0.25f) + (_97 * 0.5f);
  float _108 = sqrt(_71.x);
  float _109 = sqrt(_71.y);
  float _110 = sqrt(_71.z);
  float _114 = ((_110 + _108) * 0.25f) + (_109 * 0.5f);
  float _118 = sqrt(_77.x);
  float _120 = sqrt(_77.z);
  float _121 = sqrt(_77.y) * 0.5f;
  float _124 = ((_120 + _118) * 0.25f) + _121;
  float _127 = ((_118 - _120) * 0.5f) + 0.5f;
  float _132 = ((0.5f - (_118 * 0.25f)) + _121) - (_120 * 0.25f);
  float _133 = sqrt(_83.x);
  float _134 = sqrt(_83.y);
  float _135 = sqrt(_83.z);
  float _139 = ((_135 + _133) * 0.25f) + (_134 * 0.5f);
  float _142 = sqrt(_89.x);
  float _143 = sqrt(_89.y);
  float _144 = sqrt(_89.z);
  float _148 = ((_144 + _142) * 0.25f) + (_143 * 0.5f);
  float _153 = max(_104, max(_114, max(_124, max(_139, _148))));
  float _185;
  if (_21_m0[2u].x > 0.0f) {
    _185 = (_21_m0[2u].x * 1.10000002384185791015625f) * min(0.0625f, 0.5f - (((((_14.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(-1, 0)).x + _14.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(0, -1)).x) + _14.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(TEXCOORD.x, TEXCOORD.y), 0.0f).x) + _14.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(1, 0)).x) + _14.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(TEXCOORD.x, TEXCOORD.y), 0.0f, int2(0, 1)).x) * 0.20000000298023223876953125f));
  } else {
    _185 = 0.0f;
  }
  float _189 = _142 + _133;
  float _214 = 1.0f - (_185 * 4.0f);
  float _222 = (_214 * _124) + (_185 * (((_114 + _104) + _139) + _148));
  float _223 = (_214 * _127) + (_185 * (((((2.0f - (_98 * 0.5f)) - (_110 * 0.5f)) - (_135 * 0.5f)) + (((_189 + _96) + _108) * 0.5f)) - (_144 * 0.5f)));
  float _224 = (_214 * _132) + (_185 * (((((((2.0f - (_96 * 0.25f)) - (_98 * 0.25f)) - (_108 * 0.25f)) - (_110 * 0.25f)) - (_135 * 0.25f)) + ((((_109 + _97) + _134) + _143) * 0.5f)) - ((_189 + _144) * 0.25f)));
  float _240 = _153 * 0.100000001490116119384765625f;
  float _246 = (_21_m0[2u].x * _21_m0[2u].x) * max(min(0.0f, _240), min(max(0.0f, _240), clamp(_153 - max(abs(_114 - _124), max(abs(_124 - _139), max(abs(_104 - _124), abs(_124 - _148)))), 0.0f, 1.0f) * 0.25f));
  float _247 = _246 * 0.5f;
  float _251 = _246 + _124;
  float _252 = _247 + _127;
  float _253 = _247 + _132;
  float _257 = max(min(_222, _251), min(max(_222, _251), _124 - _246));
  float _261 = max(min(_223, _252), min(max(_223, _252), _127 - _247));
  float _265 = max(min(_224, _253), min(max(_224, _253), _132 - _247));
  float _267 = (_261 + _257) - _265;
  float _270 = (_257 + (-0.5f)) + _265;
  float _273 = ((_257 + 1.0f) - _261) - _265;
  float _274 = _267 * _267;
  float _275 = _270 * _270;
  float _276 = _273 * _273;
  float4 _278 = _13.Load(int3(uint2(uint(int(_21_m0[0u].x * TEXCOORD.x)), uint(int(_21_m0[0u].y * TEXCOORD.y))), 0u));
  uint _285 = uint(int(_21_m0[1u].w));
  bool _286 = _285 == 1u;
  float _364;
  float _366;
  float _368;
  if (_286) {
    float _377;
    if (_274 < 0.040449999272823333740234375f) {
      _377 = _274 * 0.077399380505084991455078125f;
    } else {
      _377 = exp2(log2(abs((_274 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
    }
    float _486;
    if (_275 < 0.040449999272823333740234375f) {
      _486 = _275 * 0.077399380505084991455078125f;
    } else {
      _486 = exp2(log2(abs((_275 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
    }
    float _503;
    if (_276 < 0.040449999272823333740234375f) {
      _503 = _276 * 0.077399380505084991455078125f;
    } else {
      _503 = exp2(log2(abs((_276 * 0.94786727428436279296875f) + 0.0521326996386051177978515625f)) * 2.400000095367431640625f);
    }
    float _504 = 1.0f / _21_m0[1u].x;
    _364 = exp2(log2(abs(_377)) * _504);
    _366 = exp2(log2(abs(_486)) * _504);
    _368 = exp2(log2(abs(_503)) * _504);
  } else {
    float frontier_phi_8_4_ladder;
    float frontier_phi_8_4_ladder_1;
    float frontier_phi_8_4_ladder_2;
    if (_285 == 2u) {
#if 1
      BT709FromPQ(
          _274, _275, _276,
          _21_m0[1u].x, _21_m0[1u].y,
          frontier_phi_8_4_ladder,
          frontier_phi_8_4_ladder_1,
          frontier_phi_8_4_ladder_2);
#else
      float _311 = exp2(log2(abs(_274)) * 0.0126833133399486541748046875f);
      float _312 = exp2(log2(abs(_275)) * 0.0126833133399486541748046875f);
      float _313 = exp2(log2(abs(_276)) * 0.0126833133399486541748046875f);
      float _329 = 1.0f / _21_m0[1u].x;
      float _342 = 1.0f / _21_m0[1u].y;
      float _343 = _342 * exp2(log2(abs((_311 + (-0.8359375f)) / (18.8515625f - (_311 * 18.6875f)))) * _329);
      float _344 = _342 * exp2(log2(abs((_312 + (-0.8359375f)) / (18.8515625f - (_312 * 18.6875f)))) * _329);
      float _345 = _342 * exp2(log2(abs((_313 + (-0.8359375f)) / (18.8515625f - (_313 * 18.6875f)))) * _329);
      frontier_phi_8_4_ladder = mad(-0.0728498995304107666015625f, _345, mad(-0.5876410007476806640625f, _344, _343 * 1.6604900360107421875f));
      frontier_phi_8_4_ladder_1 = mad(-0.008349419571459293365478515625f, _345, mad(1.1328999996185302734375f, _344, _343 * (-0.12454999983310699462890625f)));
      frontier_phi_8_4_ladder_2 = mad(1.11872994899749755859375f, _345, mad(-0.100579001009464263916015625f, _344, _343 * (-0.01815080083906650543212890625f)));
#endif
    } else {
      frontier_phi_8_4_ladder = _274;
      frontier_phi_8_4_ladder_1 = _275;
      frontier_phi_8_4_ladder_2 = _276;
    }
    _364 = frontier_phi_8_4_ladder;
    _366 = frontier_phi_8_4_ladder_1;
    _368 = frontier_phi_8_4_ladder_2;
  }
  float _370 = 1.0f - _278.w;
  float _374 = (_364 * _370) + _278.x;
  float _375 = (_366 * _370) + _278.y;
  float _376 = (_368 * _370) + _278.z;
  float _474;
  float _476;
  float _478;
  if (_286) {
    float _388 = exp2(log2(abs(_374)) * _21_m0[1u].x);
    float _389 = exp2(log2(abs(_375)) * _21_m0[1u].x);
    float _390 = exp2(log2(abs(_376)) * _21_m0[1u].x);
    float _475;
    if (_388 < 0.00310000008903443813323974609375f) {
      _475 = _388 * 12.9200000762939453125f;
    } else {
      _475 = (exp2(log2(abs(_388)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _477;
    if (_389 < 0.00310000008903443813323974609375f) {
      _477 = _389 * 12.9200000762939453125f;
    } else {
      _477 = (exp2(log2(abs(_389)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_17_25_ladder;
    float frontier_phi_17_25_ladder_1;
    float frontier_phi_17_25_ladder_2;
    if (_390 < 0.00310000008903443813323974609375f) {
      frontier_phi_17_25_ladder = _475;
      frontier_phi_17_25_ladder_1 = _477;
      frontier_phi_17_25_ladder_2 = _390 * 12.9200000762939453125f;
    } else {
      frontier_phi_17_25_ladder = _475;
      frontier_phi_17_25_ladder_1 = _477;
      frontier_phi_17_25_ladder_2 = (exp2(log2(abs(_390)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    _474 = frontier_phi_17_25_ladder;
    _476 = frontier_phi_17_25_ladder_1;
    _478 = frontier_phi_17_25_ladder_2;
  } else {
    float frontier_phi_17_11_ladder;
    float frontier_phi_17_11_ladder_1;
    float frontier_phi_17_11_ladder_2;
    if (_285 == 2u) {
#if 1
      PQFromBT709(
          _374, _375, _376,
          _21_m0[1u].x, _21_m0[1u].y,
          frontier_phi_17_11_ladder,
          frontier_phi_17_11_ladder_1,
          frontier_phi_17_11_ladder_2);
#else
      float _442 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _376, mad(0.3292830288410186767578125f, _375, _374 * 0.627403914928436279296875f)) * _21_m0[1u].y)) * _21_m0[1u].x);
      float _443 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _376, mad(0.9195404052734375f, _375, _374 * 0.069097287952899932861328125f)) * _21_m0[1u].y)) * _21_m0[1u].x);
      float _444 = exp2(log2(abs(mad(0.895595252513885498046875f, _376, mad(0.08801330626010894775390625f, _375, _374 * 0.01639143936336040496826171875f)) * _21_m0[1u].y)) * _21_m0[1u].x);
      frontier_phi_17_11_ladder = exp2(log2(abs(((_442 * 18.8515625f) + 0.8359375f) / ((_442 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_17_11_ladder_1 = exp2(log2(abs(((_443 * 18.8515625f) + 0.8359375f) / ((_443 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_17_11_ladder_2 = exp2(log2(abs(((_444 * 18.8515625f) + 0.8359375f) / ((_444 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_17_11_ladder = _374;
      frontier_phi_17_11_ladder_1 = _375;
      frontier_phi_17_11_ladder_2 = _376;
    }
    _474 = frontier_phi_17_11_ladder;
    _476 = frontier_phi_17_11_ladder_1;
    _478 = frontier_phi_17_11_ladder_2;
  }
  SV_Target.x = _474;
  SV_Target.y = _476;
  SV_Target.z = _478;
  SV_Target.w = 0.0f;
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
