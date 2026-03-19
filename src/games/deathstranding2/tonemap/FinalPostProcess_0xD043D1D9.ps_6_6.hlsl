cbuffer _33_35 : register(b0, space3) {
  float4 _35_m0[1] : packoffset(c0);
};

cbuffer _38_40 : register(b0, space5) {
  float4 _40_m0[23] : packoffset(c0);
};

// SamplerState _8[] : register(s0, space0);
Texture2D<uint4> _12 : register(t0, space3);
Texture2D<float4> _16 : register(t1, space3);
Texture2D<float4> _17 : register(t2, space3);
Texture2D<float4> _18 : register(t4, space3);
Texture2D<float4> _19 : register(t5, space3);
Texture2D<float4> _20 : register(t6, space3);
Texture2D<float4> _21 : register(t7, space3);
Texture2D<float4> _22 : register(t8, space3);
Texture2D<float4> _23 : register(t9, space3);
Buffer<float4> _26 : register(t0, space5);
Texture3D<float4> _29 : register(t1, space5);

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float4 SV_Target;
static float SV_Target_1;

struct SPIRV_Cross_Input {
  noperspective float4 gl_FragCoord : SV_Position;
  linear float2 TEXCOORD : TEXCOORD;
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
  float SV_Target_1 : SV_Target1;
};

uint2 spvTextureSize(Texture2D<float4> Tex, uint Level, out uint Param) {
  uint2 ret;
  Tex.GetDimensions(Level, ret.x, ret.y, Param);
  return ret;
}

void frag_main() {
  uint4 _60 = asuint(_35_m0[0u]);
  uint4 _138 = asuint(_40_m0[13u]);
  uint4 _165 = asuint(_40_m0[21u]);
  uint _166 = _165.y;
  float _198 = (((_40_m0[6u].z * ((_40_m0[0u].z + (-0.5f)) + (_40_m0[0u].x * TEXCOORD.x))) + 0.5f) * 2.0f) + (-1.0f);
  float _200 = (((_40_m0[6u].z * ((_40_m0[0u].w + (-0.5f)) + (_40_m0[0u].y * TEXCOORD.y))) + 0.5f) * 2.0f) + (-1.0f);
  float _201 = _198 * _40_m0[8u].x;
  float _202 = _200 * _40_m0[8u].y;
  float _203 = dot(float2(_201, _202), float2(_201, _202));
  float _206 = _203 * _203;
  float _207 = _40_m0[6u].x * 2.0f;
  float _208 = _40_m0[6u].y * 4.0f;
  float _215 = _40_m0[6u].x * 3.0f;
  float _217 = _40_m0[6u].y * 5.0f;
  float _233 = (dot(float2(_203, _206), float2(_207, _208)) + 1.0f) / (((dot(1.0f.xx, float2(_207, _208)) + 1.0f) / (dot(1.0f.xx, float2(_215, _217)) + 1.0f)) * (dot(float2(_203, _206), float2(_215, _217)) + 1.0f));
  float _240 = log2(abs((_40_m0[6u].w != 0.0f) ? _198 : _200));
  float _251 = ((((_40_m0[7u].x * 0.5f) * (1.0f - _233)) * (exp2(_240 * _40_m0[7u].z) + exp2(_240 * _40_m0[7u].y))) + _233) * 0.5f;
  float _254 = (_251 * _198) + 0.5f;
  float _255 = (_251 * _200) + 0.5f;
  uint _258_dummy_parameter;
  uint2 _258 = spvTextureSize(_18, 0u, _258_dummy_parameter);
  float _265 = (1.0f / _40_m0[0u].x) * _254;
  float _267 = (1.0f / _40_m0[0u].y) * _255;
  float _269 = _265 * _40_m0[22u].x;
  float _270 = _267 * _40_m0[22u].y;
  float4 _280 = _18.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_265 * _40_m0[21u].z, _267 * _40_m0[21u].w));
  float _282 = _280.x;
  float _283 = _280.y;
  float _284 = _280.z;
  float _287 = float(int(_138.x));
  float _288 = float(int(_138.y));
  float _294 = float(int(uint(int(uint(clamp(_269, 0.0f, 1.0f) * float(int(_258.x)))) >> int(_60.z & 31u))));
  float _295 = float(int(uint(int(uint(clamp(_270, 0.0f, 1.0f) * float(int(_258.y)))) >> int(_60.w & 31u))));
  uint4 _307 = _12.Load(int3(uint2(uint(int(max(min(_294, _287), min(max(_294, _287), float(int(_138.z)))))), uint(int(max(min(_295, _288), min(max(_295, _288), float(int(_138.w))))))), 0u));
  uint _309 = _307.x;
  float _311;
  float _316;
  float _321;
  if (_309 == 0u) {
    _311 = _282;
    _316 = _283;
    _321 = _284;
  } else {
    float frontier_phi_1_2_ladder;
    float frontier_phi_1_2_ladder_1;
    float frontier_phi_1_2_ladder_2;
    if ((_309 & 536870912u) == 0u) {
      float4 _477 = _20.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_269, _270));
      float _315 = _477.x;
      float _320 = _477.y;
      float _325 = _477.z;
      float frontier_phi_1_2_ladder_5_ladder;
      float frontier_phi_1_2_ladder_5_ladder_1;
      float frontier_phi_1_2_ladder_5_ladder_2;
      if ((_309 & 268435456u) == 0u) {
        float4 _518 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_269, _270));
        float4 _523 = _17.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_269, _270));
        float _525 = _523.x;
        float _530 = clamp((_518.x * 4.80000019073486328125f) + (-0.20000000298023223876953125f), 0.0f, 1.0f);
        float _314 = (_530 * (_315 - _282)) + _282;
        float _319 = (_530 * (_320 - _283)) + _283;
        float _324 = (_530 * (_325 - _284)) + _284;
        float4 _539 = _19.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_269, _270));
        float frontier_phi_1_2_ladder_5_ladder_9_ladder;
        float frontier_phi_1_2_ladder_5_ladder_9_ladder_1;
        float frontier_phi_1_2_ladder_5_ladder_9_ladder_2;
        if ((_539.z > 0.0f) || ((_539.x > 0.0f) || (_539.y > 0.0f))) {
          float4 _563 = _19.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_269, _270));
          frontier_phi_1_2_ladder_5_ladder_9_ladder = ((_563.z - _324) * _525) + _324;
          frontier_phi_1_2_ladder_5_ladder_9_ladder_1 = ((_563.y - _319) * _525) + _319;
          frontier_phi_1_2_ladder_5_ladder_9_ladder_2 = ((_563.x - _314) * _525) + _314;
        } else {
          frontier_phi_1_2_ladder_5_ladder_9_ladder = _324;
          frontier_phi_1_2_ladder_5_ladder_9_ladder_1 = _319;
          frontier_phi_1_2_ladder_5_ladder_9_ladder_2 = _314;
        }
        frontier_phi_1_2_ladder_5_ladder = frontier_phi_1_2_ladder_5_ladder_9_ladder;
        frontier_phi_1_2_ladder_5_ladder_1 = frontier_phi_1_2_ladder_5_ladder_9_ladder_1;
        frontier_phi_1_2_ladder_5_ladder_2 = frontier_phi_1_2_ladder_5_ladder_9_ladder_2;
      } else {
        frontier_phi_1_2_ladder_5_ladder = _325;
        frontier_phi_1_2_ladder_5_ladder_1 = _320;
        frontier_phi_1_2_ladder_5_ladder_2 = _315;
      }
      frontier_phi_1_2_ladder = frontier_phi_1_2_ladder_5_ladder;
      frontier_phi_1_2_ladder_1 = frontier_phi_1_2_ladder_5_ladder_1;
      frontier_phi_1_2_ladder_2 = frontier_phi_1_2_ladder_5_ladder_2;
    } else {
      float4 _481 = _19.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_269, _270));
      frontier_phi_1_2_ladder = _481.z;
      frontier_phi_1_2_ladder_1 = _481.y;
      frontier_phi_1_2_ladder_2 = _481.x;
    }
    _311 = frontier_phi_1_2_ladder_2;
    _316 = frontier_phi_1_2_ladder_1;
    _321 = frontier_phi_1_2_ladder;
  }
  float _328 = (_254 - _40_m0[0u].z) / _40_m0[0u].x;
  float _329 = (_255 - _40_m0[0u].w) / _40_m0[0u].y;
  float4 _331 = _26.Load(2u);
  float _332 = _331.x;
  float4 _335 = _21.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_328, _329));
  float _337 = _335.x;
  float _338 = _335.y;
  float _339 = _335.z;
  float4 _342 = _22.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_328, _329));
  float _350 = _40_m0[19u].y * 0.25f;
  float _352 = _311 * _350;
  float _353 = _316 * _350;
  float _354 = _321 * _350;
  float _367 = (clamp(dot(float3(_352, _353, _354), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) + 9.9999999747524270787835121154785e-07f, 0.0f, 1.0f) * (1.0f - _40_m0[17u].w)) + _40_m0[17u].w;
  float _383 = (exp2(log2(max(_352, 0.0f)) * _367) / _350) * _40_m0[17u].w;
  float _384 = (exp2(log2(max(_353, 0.0f)) * _367) / _350) * _40_m0[17u].w;
  float _385 = (exp2(log2(max(_354, 0.0f)) * _367) / _350) * _40_m0[17u].w;
  float _386 = (_337 * _337) / _40_m0[19u].z;
  float _387 = (_338 * _338) / _40_m0[19u].z;
  float _388 = (_339 * _339) / _40_m0[19u].z;
  float _391 = (_332 * 4.0f) / (_332 + 0.25f);
  float _395 = max(_332, 1.0000000031710768509710513471353e-30f);
  float _408 = 1.0f / ((_332 + 1.0f) + _391);
  float _422 = (((_387 + _384) + (sqrt((_387 * _384) / _395) * _391)) * _408) + (_342.y * _40_m0[19u].x);
  float _428 = ((_422 * (_40_m0[17u].x - _40_m0[17u].y)) + (((_408 * ((_386 + _383) + (sqrt((_386 * _383) / _395) * _391))) + (_342.x * _40_m0[19u].x)) * _40_m0[17u].x)) * _40_m0[19u].z;
  float _430 = (_40_m0[19u].z * _40_m0[17u].y) * _422;
  float _432 = (_40_m0[19u].z * _40_m0[17u].z) * ((((_388 + _385) + (sqrt((_388 * _385) / _395) * _391)) * _408) + (_342.z * _40_m0[19u].x));
  float _438;
  float _440;
  float _442;
  if ((_166 & 1u) == 0u) {
    _438 = _428;
    _440 = _430;
    _442 = _432;
  } else {
    uint _448 = asuint(_40_m0[11u].z);
    float _468 = (_23.Sample((SamplerState)ResourceDescriptorHeap[17u], float2((_254 * _40_m0[11u].x) + (float(_448 & 65535u) * 1.52587890625e-05f), (_255 * _40_m0[11u].y) + (float(_448 >> 16u) * 1.52587890625e-05f))).y + (-0.5f)) * _335.w;
    _438 = max(_468 + _428, 0.0f);
    _440 = max(_468 + _430, 0.0f);
    _442 = max(_468 + _432, 0.0f);
  }
  float _483;
  float _485;
  float _487;
  if ((_166 & 32u) == 0u) {
    _483 = _438;
    _485 = _440;
    _487 = _442;
  } else {
    float _497 = (_254 * 2.0f) + (-1.0f);
    float _498 = (_255 * 2.0f) + (-1.0f);
    float _505 = clamp((sqrt((_498 * _498) + (_497 * _497)) * _40_m0[10u].x) + _40_m0[10u].y, 0.0f, 1.0f);
    float _507 = (_505 * _505) * _40_m0[1u].w;
    float _508 = 1.0f - _507;
    float _512 = (_408 * _40_m0[19u].z) * _507;
    _483 = (_508 * _438) + (_512 * _40_m0[1u].x);
    _485 = (_508 * _440) + (_512 * _40_m0[1u].y);
    _487 = (_508 * _442) + (_512 * _40_m0[1u].z);
  }
  float _489 = max(_483, 9.9999999747524270787835121154785e-07f);
  float _490 = max(_485, 9.9999999747524270787835121154785e-07f);
  float _491 = max(_487, 9.9999999747524270787835121154785e-07f);
  float _549;
  float _552;
  float _555;
  if ((_166 & 16u) == 0u) {
    _549 = _489;
    _552 = _490;
    _555 = _491;
  } else {
    float frontier_phi_10_11_ladder;
    float frontier_phi_10_11_ladder_1;
    float frontier_phi_10_11_ladder_2;
    if (asuint(_40_m0[12u]).w == 0u) {
      float _608 = (-0.0f) - _40_m0[2u].w;
      float4 _641 = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float3((clamp(sqrt(max((_489 < _40_m0[3u].z) ? ((_489 * _40_m0[2u].y) + _40_m0[2u].z) : ((_608 / (_489 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(sqrt(max((_490 < _40_m0[3u].z) ? ((_490 * _40_m0[2u].y) + _40_m0[2u].z) : ((_608 / (_490 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(sqrt(max((_491 < _40_m0[3u].z) ? ((_491 * _40_m0[2u].y) + _40_m0[2u].z) : ((_608 / (_491 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w), 0.0f);
      float _643 = _641.x;
      float _644 = _641.y;
      float _645 = _641.z;
      float _649 = min(_643 * _643, _40_m0[2u].x);
      float _650 = min(_644 * _644, _40_m0[2u].x);
      float _651 = min(_645 * _645, _40_m0[2u].x);
      frontier_phi_10_11_ladder = (_651 < _40_m0[3u].w) ? ((_651 - _40_m0[2u].z) / _40_m0[2u].y) : ((_608 / (_651 - _40_m0[3u].y)) - _40_m0[3u].x);
      frontier_phi_10_11_ladder_1 = (_650 < _40_m0[3u].w) ? ((_650 - _40_m0[2u].z) / _40_m0[2u].y) : ((_608 / (_650 - _40_m0[3u].y)) - _40_m0[3u].x);
      frontier_phi_10_11_ladder_2 = (_649 < _40_m0[3u].w) ? ((_649 - _40_m0[2u].z) / _40_m0[2u].y) : ((_608 / (_649 - _40_m0[3u].y)) - _40_m0[3u].x);
    } else {
      float _684 = exp2(log2(abs(_489 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _685 = exp2(log2(abs(_490 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _686 = exp2(log2(abs(_491 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float4 _728 = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float3((clamp(exp2(log2(abs(((_684 * 18.8515625f) + 0.8359375f) / ((_684 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(exp2(log2(abs(((_685 * 18.8515625f) + 0.8359375f) / ((_685 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(exp2(log2(abs(((_686 * 18.8515625f) + 0.8359375f) / ((_686 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w), 0.0f);
      float _743 = exp2(log2(abs(_728.x)) * 0.0126833133399486541748046875f);
      float _744 = exp2(log2(abs(_728.y)) * 0.0126833133399486541748046875f);
      float _745 = exp2(log2(abs(_728.z)) * 0.0126833133399486541748046875f);
      frontier_phi_10_11_ladder = exp2(log2(abs((_745 + (-0.8359375f)) / (18.8515625f - (_745 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_1 = exp2(log2(abs((_744 + (-0.8359375f)) / (18.8515625f - (_744 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_10_11_ladder_2 = exp2(log2(abs((_743 + (-0.8359375f)) / (18.8515625f - (_743 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
    }
    _549 = frontier_phi_10_11_ladder_2;
    _552 = frontier_phi_10_11_ladder_1;
    _555 = frontier_phi_10_11_ladder;
  }
  float _574;
  float _576;
  float _578;
  if ((_166 & 2u) == 0u) {
    _574 = _549;
    _576 = _552;
    _578 = _555;
  } else {
    float _588 = (-0.0f) - _40_m0[4u].x;
    _574 = (_549 < _40_m0[3u].z) ? ((_549 * _40_m0[2u].y) + _40_m0[2u].z) : ((_588 / (_549 + _40_m0[4u].y)) + _40_m0[4u].z);
    _576 = (_552 < _40_m0[3u].z) ? ((_552 * _40_m0[2u].y) + _40_m0[2u].z) : ((_588 / (_552 + _40_m0[4u].y)) + _40_m0[4u].z);
    _578 = (_555 < _40_m0[3u].z) ? ((_555 * _40_m0[2u].y) + _40_m0[2u].z) : ((_588 / (_555 + _40_m0[4u].y)) + _40_m0[4u].z);
  }
  uint _580 = uint(int(_40_m0[18u].w));
  float _859;
  float _861;
  float _863;
  if (_580 == 1u) {
    float _782 = exp2(log2(abs(_574)) * _40_m0[18u].x);
    float _783 = exp2(log2(abs(_576)) * _40_m0[18u].x);
    float _784 = exp2(log2(abs(_578)) * _40_m0[18u].x);
    float _860;
    if (_782 < 0.00310000008903443813323974609375f) {
      _860 = _782 * 12.9200000762939453125f;
    } else {
      _860 = (exp2(log2(abs(_782)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _862;
    if (_783 < 0.00310000008903443813323974609375f) {
      _862 = _783 * 12.9200000762939453125f;
    } else {
      _862 = (exp2(log2(abs(_783)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_22_26_ladder;
    float frontier_phi_22_26_ladder_1;
    float frontier_phi_22_26_ladder_2;
    if (_784 < 0.00310000008903443813323974609375f) {
      frontier_phi_22_26_ladder = _860;
      frontier_phi_22_26_ladder_1 = _784 * 12.9200000762939453125f;
      frontier_phi_22_26_ladder_2 = _862;
    } else {
      frontier_phi_22_26_ladder = _860;
      frontier_phi_22_26_ladder_1 = (exp2(log2(abs(_784)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_22_26_ladder_2 = _862;
    }
    _859 = frontier_phi_22_26_ladder;
    _861 = frontier_phi_22_26_ladder_2;
    _863 = frontier_phi_22_26_ladder_1;
  } else {
    float frontier_phi_22_18_ladder;
    float frontier_phi_22_18_ladder_1;
    float frontier_phi_22_18_ladder_2;
    if (_580 == 2u) {
      float _829 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _578, mad(0.3292830288410186767578125f, _576, _574 * 0.627403914928436279296875f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      float _830 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _578, mad(0.9195404052734375f, _576, _574 * 0.069097287952899932861328125f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      float _831 = exp2(log2(abs(mad(0.895595252513885498046875f, _578, mad(0.08801330626010894775390625f, _576, _574 * 0.01639143936336040496826171875f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      frontier_phi_22_18_ladder = exp2(log2(abs(((_829 * 18.8515625f) + 0.8359375f) / ((_829 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_22_18_ladder_1 = exp2(log2(abs(((_831 * 18.8515625f) + 0.8359375f) / ((_831 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_22_18_ladder_2 = exp2(log2(abs(((_830 * 18.8515625f) + 0.8359375f) / ((_830 * 18.6875f) + 1.0f))) * 78.84375f);
    } else {
      frontier_phi_22_18_ladder = _574;
      frontier_phi_22_18_ladder_1 = _578;
      frontier_phi_22_18_ladder_2 = _576;
    }
    _859 = frontier_phi_22_18_ladder;
    _861 = frontier_phi_22_18_ladder_2;
    _863 = frontier_phi_22_18_ladder_1;
  }
  float _875 = max(((_859 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  float _876 = max(((_861 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  float _877 = max(((_863 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  SV_Target.x = _875;
  SV_Target.y = _876;
  SV_Target.z = _877;
  SV_Target.w = 1.0f;
  SV_Target_1 = dot(float3(_875, _876, _877), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
