#include "./shared.h"

cbuffer ConstBuf_passDataUBO : register(b0, space0) {
  float4 ConstBuf_passData_m0[2288] : packoffset(c0);
};

cbuffer ConstBuf_modelDataUBO : register(b1, space0) {
  float4 ConstBuf_modelData_m0[11] : packoffset(c0);
};

cbuffer ConstBuf_viewDataUBO : register(b3, space0) {
  float4 ConstBuf_viewData_m0[81] : packoffset(c0);
};

cbuffer ConstBuf_materialDataUBO : register(b4, space0) {
  float4 ConstBuf_materialData_m0[1] : packoffset(c0);
};

// ResourceDescriptorHeap
// Texture2D<float4> _9[] : register(t0, space0);
// SamplerState _13[] : register(s0, space0);

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float3 NORMAL;
static float4 TANGENT;
static float3 PREV_POSITION_PS;
static uint VERTEX_ID;
static float4 SV_Target;

struct SPIRV_Cross_Input {
  float4 gl_FragCoord : SV_Position;           // Register 0
  float2 TEXCOORD : TEXCOORD0;                 // Register 1
  float3 NORMAL : NORMAL;                      // Register 2
  float4 TANGENT : TANGENT;                    // Register 3
  float3 PREV_POSITION_PS : PREV_POSITION_PS;  // Register 4
  nointerpolation uint VERTEX_ID : VERTEX_ID;  // Register 5
};

struct SPIRV_Cross_Output {
  float4 SV_Target : SV_Target0;
};

static bool discard_state;

void discard_exit() {
  if (discard_state) {
    discard;
  }
}

void frag_main() {
  discard_state = false;
  float _77 = ConstBuf_viewData_m0[48u].w * gl_FragCoord.y;

  uint texIndex = asuint(ConstBuf_materialData_m0[0u]).x + asuint(ConstBuf_viewData_m0[47u]).w;
  uint samplerIndex = asuint(ConstBuf_viewData_m0[78u]).w;
  Texture2D<float4> tex = ResourceDescriptorHeap[texIndex];
  SamplerState samp = ResourceDescriptorHeap[samplerIndex];
  float4 _97 = tex.Sample(samp, TEXCOORD);
  // float4 _97 = _9[asuint(ConstBuf_materialData_m0[0u]).x + asuint(ConstBuf_viewData_m0[47u]).w].Sample(_13[asuint(ConstBuf_viewData_m0[78u]).w], float2(TEXCOORD.x, TEXCOORD.y));

  float _106 = ConstBuf_modelData_m0[2u].y * _97.x;
  float _107 = ConstBuf_modelData_m0[2u].y * _97.y;
  float _108 = ConstBuf_modelData_m0[2u].y * _97.z;
  float _117;

  float peak_nits = min(4000.0f, ConstBuf_passData_m0[2271u].z);
  float min_nits = max(9.9999997473787516355514526367188e-05f, ConstBuf_passData_m0[2270u].w);
  float exposure = ConstBuf_passData_m0[2271u].x;  // brightness slider

  if (RENODX_OVERRIDE_PEAK_NITS) {
    peak_nits = RENODX_PEAK_WHITE_NITS;
  }
  if (RENODX_TONE_MAP_TYPE) {
    min_nits = 0.0001f;
    exposure = 8.f * RENODX_TONE_MAP_EXPOSURE;
    float scale = 100.f / RENODX_DIFFUSE_WHITE_NITS;
    peak_nits *= scale;
    min_nits *= scale;

    float invDiffuseWhite = 1.0f / RENODX_DIFFUSE_WHITE_NITS;
    peak_nits = renodx::color::correct::Gamma(peak_nits * invDiffuseWhite, true) * RENODX_DIFFUSE_WHITE_NITS;
    min_nits = renodx::color::correct::Gamma(min_nits * invDiffuseWhite, true) * RENODX_DIFFUSE_WHITE_NITS;
  }

  if ((asuint(ConstBuf_modelData_m0[0u]).x & 512u) == 0u) {
    _117 = 1.0f;
  } else {
    float frontier_phi_1_2_ladder;
    if ((ConstBuf_modelData_m0[7u].w > 0.0f) || ((ConstBuf_modelData_m0[7u].z > 0.0f) || ((ConstBuf_modelData_m0[7u].x > 0.0f) || (ConstBuf_modelData_m0[7u].y > 0.0f)))) {
      float _153 = ConstBuf_viewData_m0[48u].z * gl_FragCoord.x;
      float _175 = ((clamp((_77 - ConstBuf_modelData_m0[6u].y) / ConstBuf_modelData_m0[7u].y, 0.0f, 1.0f) * clamp((_153 - ConstBuf_modelData_m0[6u].x) / ConstBuf_modelData_m0[7u].x, 0.0f, 1.0f)) * clamp((ConstBuf_modelData_m0[6u].z - _153) / ConstBuf_modelData_m0[7u].z, 0.0f, 1.0f)) * clamp((ConstBuf_modelData_m0[6u].w - _77) / ConstBuf_modelData_m0[7u].w, 0.0f, 1.0f);
      float _119 = clamp((asuint(ConstBuf_modelData_m0[8u]).x == 0u) ? _175 : (_175 * _175), 0.0f, 1.0f);
      float frontier_phi_1_2_ladder_5_ladder;
      if (_119 > 0.0f) {
        frontier_phi_1_2_ladder_5_ladder = _119;
      } else {
        discard_state = true;
        frontier_phi_1_2_ladder_5_ladder = _119;
      }
      frontier_phi_1_2_ladder = frontier_phi_1_2_ladder_5_ladder;
    } else {
      frontier_phi_1_2_ladder = 1.0f;
    }
    _117 = frontier_phi_1_2_ladder;
  }
  if (_117 < 9.9999997473787516355514526367188e-05f) {
    discard_state = true;
  }
  uint _143 = asuint(ConstBuf_modelData_m0[0u]).x >> 28u;
  float _185;
  float _187;
  float _189;
  if (((1u << _143) & asuint(ConstBuf_viewData_m0[60u]).x) == 0u) {
    _185 = _106;
    _187 = _107;
    _189 = _108;
  } else {
    uint _308 = _143 + 61u;
    float _315 = dot(float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f), float3(_106, _107, _108));
    _185 = _315 * ConstBuf_viewData_m0[_308].x;
    _187 = _315 * ConstBuf_viewData_m0[_308].y;
    _189 = _315 * ConstBuf_viewData_m0[_308].z;
  }
  float _208 = log2(max(9.9999997473787516355514526367188e-05f, ConstBuf_passData_m0[2270u].w));  //   float _208 = log2(max(9.9999997473787516355514526367188e-05f, ConstBuf_passData_m0[2270u].w));
  float _213 = clamp((_208 * 0.13082401454448699951171875f) + 1.7383518218994140625f, 0.0f, 1.0f);
  float _220 = exp2((_213 * (-6.5f)) - ((1.0f - _213) * 15.0f));
  float _223 = log2(peak_nits);  //   float _223 = log2(min(4000.0f, ConstBuf_passData_m0[2271u].z));
  float _228 = clamp((_223 * 0.1298237740993499755859375f) + (-0.725060939788818359375f), 0.0f, 1.0f);
  float _235 = exp2(((1.0f - _228) * 6.5f) + (_228 * 18.0f));
  float _237 = log2(_220 * 0.180000007152557373046875f);
  float _238 = _208 * 0.3010300099849700927734375f;
  float _240 = _237 * 0.077766083180904388427734375f;
  float _242 = _240 + 0.873629271984100341796875f;
  float _244 = 0.48885345458984375f - _240;
  float _250 = clamp((log2(_220) + 15.0f) * 0.117647059261798858642578125f, 0.0f, 1.0f);
  float _259 = ((0.681241333484649658203125f - _238) * (((1.0f - _250) * 0.180000007152557373046875f) + (_250 * 0.3499999940395355224609375f))) + _238;
  float _260 = log2(_235 * 0.180000007152557373046875f);
  float _261 = _260 * 0.077766083180904388427734375f;
  float _262 = 0.48885345458984375f - _261;
  float _263 = _261 + 0.873629271984100341796875f;
  float _264 = _223 * 0.3010300099849700927734375f;
  float _269 = clamp((log2(_235) + (-6.5f)) * 0.086956523358821868896484375f, 0.0f, 1.0f);
  float _279 = ((((1.0f - _269) * 0.88999998569488525390625f) + (_269 * 0.89999997615814208984375f)) * (_264 + (-0.681241333484649658203125f))) + 0.681241333484649658203125f;
  float _282 = log2(exp2(_237));
  float _287 = log2(exp2(_260));
  float _295 = (_259 + _238) * 0.5f;
  float _300 = (_279 + _263) * 0.5f;
  float _306 = log2(max(exposure, 1.0000000133514319600180897396058e-10f)) * 0.3010300099849700927734375f;  // exposure
  float _331;
  if (_306 > _238) {
    float frontier_phi_13_9_ladder;
    if ((_306 <= 0.681241333484649658203125f) && (_306 > _238)) {
      float _389;
      float _391;
      float _393;
      float _395;
      if ((_306 > ((_208 + _208) * 0.15051500499248504638671875f)) && (_306 <= _295)) {
        _389 = 0.0f;
        _391 = _238;
        _393 = _238;
        _395 = _259;
      } else {
        bool _421 = (_306 > _295) && (_306 <= ((_259 + _242) * 0.5f));
        _389 = _421 ? 1.0f : 2.0f;
        _391 = _421 ? _238 : _259;
        _393 = _421 ? _259 : _242;
        _395 = _421 ? _242 : _244;
      }
      float _397 = _391 * 0.5f;
      float _401 = _393 - _391;
      float _403 = mad(_393, 0.5f, _397) - _306;
      frontier_phi_13_9_ladder = (_282 * 0.3010300099849700927734375f) + ((((_403 * 2.0f) / (((-0.0f) - _401) - sqrt((_401 * _401) - ((mad(_395, 0.5f, mad(_393, -1.0f, _397)) * 4.0f) * _403)))) + _389) * ((-0.24824249744415283203125f) - (_282 * 0.100343339145183563232421875f)));
    } else {
      float frontier_phi_13_9_ladder_12_ladder;
      if ((_306 > 0.681241333484649658203125f) && (_306 < _264)) {
        float _440;
        float _442;
        float _444;
        float _446;
        if ((_306 >= 0.68124139308929443359375f) && (_306 <= _300)) {
          _440 = 0.0f;
          _442 = _262;
          _444 = _263;
          _446 = _279;
        } else {
          bool _467 = (_306 > _300) && (_306 <= ((_279 + _264) * 0.5f));
          _440 = _467 ? 1.0f : 2.0f;
          _442 = _467 ? _263 : _279;
          _444 = _467 ? _279 : _264;
          _446 = _264;
        }
        float _447 = _442 * 0.5f;
        float _450 = _444 - _442;
        float _452 = mad(_444, 0.5f, _447) - _306;
        frontier_phi_13_9_ladder_12_ladder = ((((_452 * 2.0f) / (((-0.0f) - _450) - sqrt((_450 * _450) - ((mad(_446, 0.5f, mad(_444, -1.0f, _447)) * 4.0f) * _452)))) + _440) * ((_287 * 0.100343339145183563232421875f) + 0.24824249744415283203125f)) + (-0.74472749233245849609375f);
      } else {
        frontier_phi_13_9_ladder_12_ladder = _287 * 0.3010300099849700927734375f;
      }
      frontier_phi_13_9_ladder = frontier_phi_13_9_ladder_12_ladder;
    }
    _331 = frontier_phi_13_9_ladder;
  } else {
    _331 = _282 * 0.3010300099849700927734375f;
  }
  float _338 = log2(exp2(_331 * 3.3219280242919921875f));
  float _339 = _338 + 2.4739310741424560546875f;
  float _345 = exp2((-4.947862148284912109375f) - _338);
  float _347 = exp2(_260 - _339);
  float _59[6];
  _59[0u] = _238;
  _59[1u] = _238;
  _59[2u] = _259;
  _59[3u] = _242;
  _59[4u] = _244;
  _59[5u] = _244;
  float _60[6];
  _60[0u] = _262;
  _60[1u] = _263;
  _60[2u] = _279;
  _60[3u] = _264;
  _60[4u] = _264;
  _60[5u] = _264;
  float _384 = log2(max(mad(0.04823090136051177978515625f, _189, mad(0.3545829951763153076171875f, _187, _185 * 0.597186982631683349609375f)), 5.9604644775390625e-08f));
  float _385 = _384 * 0.3010300099849700927734375f;
  float _386 = log2(exp2(_237 - _339));
  float _387 = _386 * 0.3010300099849700927734375f;
  float _431;
  if (_385 > _387) {
    float _427 = log2(_345);
    float _428 = _427 * 0.3010300099849700927734375f;
    float frontier_phi_19_18_ladder;
    if ((_385 > _387) && (_385 < _428)) {
      float _473 = ((_384 - _386) * 0.903090000152587890625f) / ((_427 - _386) * 0.3010300099849700927734375f);
      uint _474 = uint(int(_473));
      float _476 = _473 - float(int(_474));
      uint _479 = _474 + 1u;
      float _486 = _59[_474] * 0.5f;
      frontier_phi_19_18_ladder = dot(float3(_476 * _476, _476, 1.0f), float3(mad(_59[_474 + 2u], 0.5f, mad(_59[_479], -1.0f, _486)), _59[_479] - _59[_474], mad(_59[_479], 0.5f, _486)));
    } else {
      float _494 = log2(_347);
      float frontier_phi_19_18_ladder_23_ladder;
      if ((_385 >= _428) && (_385 < (_494 * 0.3010300099849700927734375f))) {
        float _516 = ((_384 - _427) * 0.903090000152587890625f) / ((_494 - _427) * 0.3010300099849700927734375f);
        uint _517 = uint(int(_516));
        float _519 = _516 - float(int(_517));
        uint _522 = _517 + 1u;
        float _529 = _60[_517] * 0.5f;
        frontier_phi_19_18_ladder_23_ladder = dot(float3(_519 * _519, _519, 1.0f), float3(mad(_60[_517 + 2u], 0.5f, mad(_60[_522], -1.0f, _529)), _60[_522] - _60[_517], mad(_60[_522], 0.5f, _529)));
      } else {
        frontier_phi_19_18_ladder_23_ladder = _264;
      }
      frontier_phi_19_18_ladder = frontier_phi_19_18_ladder_23_ladder;
    }
    _431 = frontier_phi_19_18_ladder;
  } else {
    _431 = _238;
  }
  float _435 = exp2(_431 * 3.3219280242919921875f);
  float _437 = log2(max(mad(0.0156609006226062774658203125f, _189, mad(0.908339977264404296875f, _187, _185 * 0.075998999178409576416015625f)), 5.9604644775390625e-08f));
  float _438 = _437 * 0.3010300099849700927734375f;
  float _503;
  if (_438 > _387) {
    float _499 = log2(_345);
    float _500 = _499 * 0.3010300099849700927734375f;
    float frontier_phi_25_24_ladder;
    if ((_438 > _387) && (_438 < _500)) {
      float _540 = ((_437 - _386) * 0.903090000152587890625f) / ((_499 - _386) * 0.3010300099849700927734375f);
      uint _541 = uint(int(_540));
      float _543 = _540 - float(int(_541));
      uint _546 = _541 + 1u;
      float _553 = _59[_541] * 0.5f;
      frontier_phi_25_24_ladder = dot(float3(_543 * _543, _543, 1.0f), float3(mad(_59[_541 + 2u], 0.5f, mad(_59[_546], -1.0f, _553)), _59[_546] - _59[_541], mad(_59[_546], 0.5f, _553)));
    } else {
      float _561 = log2(_347);
      float frontier_phi_25_24_ladder_28_ladder;
      if ((_438 >= _500) && (_438 < (_561 * 0.3010300099849700927734375f))) {
        float _605 = ((_437 - _499) * 0.903090000152587890625f) / ((_561 - _499) * 0.3010300099849700927734375f);
        uint _606 = uint(int(_605));
        float _608 = _605 - float(int(_606));
        uint _611 = _606 + 1u;
        float _618 = _60[_606] * 0.5f;
        frontier_phi_25_24_ladder_28_ladder = dot(float3(_608 * _608, _608, 1.0f), float3(mad(_60[_606 + 2u], 0.5f, mad(_60[_611], -1.0f, _618)), _60[_611] - _60[_606], mad(_60[_611], 0.5f, _618)));
      } else {
        frontier_phi_25_24_ladder_28_ladder = _264;
      }
      frontier_phi_25_24_ladder = frontier_phi_25_24_ladder_28_ladder;
    }
    _503 = frontier_phi_25_24_ladder;
  } else {
    _503 = _238;
  }
  float _507 = exp2(_503 * 3.3219280242919921875f);
  float _509 = log2(max(mad(0.837768971920013427734375f, _189, mad(0.1338270008563995361328125f, _187, _185 * 0.02840399928390979766845703125f)), 5.9604644775390625e-08f));
  float _510 = _509 * 0.3010300099849700927734375f;
  float _570;
  if (_510 > _387) {
    float _566 = log2(_345);
    float _567 = _566 * 0.3010300099849700927734375f;
    float frontier_phi_30_29_ladder;
    if ((_510 > _387) && (_510 < _567)) {
      float _629 = ((_509 - _386) * 0.903090000152587890625f) / ((_566 - _386) * 0.3010300099849700927734375f);
      uint _630 = uint(int(_629));
      float _632 = _629 - float(int(_630));
      uint _635 = _630 + 1u;
      float _642 = _59[_630] * 0.5f;
      frontier_phi_30_29_ladder = dot(float3(_632 * _632, _632, 1.0f), float3(mad(_59[_630 + 2u], 0.5f, mad(_59[_635], -1.0f, _642)), _59[_635] - _59[_630], mad(_59[_635], 0.5f, _642)));
    } else {
      float _650 = log2(_347);
      float frontier_phi_30_29_ladder_33_ladder;
      if ((_510 >= _567) && (_510 < (_650 * 0.3010300099849700927734375f))) {
        float _825 = ((_509 - _566) * 0.903090000152587890625f) / ((_650 - _566) * 0.3010300099849700927734375f);
        uint _826 = uint(int(_825));
        float _828 = _825 - float(int(_826));
        uint _831 = _826 + 1u;
        float _838 = _60[_826] * 0.5f;
        frontier_phi_30_29_ladder_33_ladder = dot(float3(_828 * _828, _828, 1.0f), float3(mad(_60[_826 + 2u], 0.5f, mad(_60[_831], -1.0f, _838)), _60[_831] - _60[_826], mad(_60[_831], 0.5f, _838)));
      } else {
        frontier_phi_30_29_ladder_33_ladder = _264;
      }
      frontier_phi_30_29_ladder = frontier_phi_30_29_ladder_33_ladder;
    }
    _570 = frontier_phi_30_29_ladder;
  } else {
    _570 = _238;
  }
  float _574 = exp2(_570 * 3.3219280242919921875f);

  // AP1 -> BT.709
  float _579 = mad(-0.0832588970661163330078125f, _574, mad(-0.621792018413543701171875f, _507, _435 * 1.705049991607666015625f));
  float _585 = mad(-0.010548300109803676605224609375f, _574, mad(1.140799999237060546875f, _507, _435 * (-0.130255997180938720703125f)));
  float _591 = mad(1.15296995639801025390625f, _574, mad(-0.12896899878978729248046875f, _507, _435 * (-0.02400339953601360321044921875f)));
  float _593 = _579 * 0.00999999977648258209228515625f;
  float _595 = _585 * 0.00999999977648258209228515625f;
  float _596 = _591 * 0.00999999977648258209228515625f;
  float _598 = log2(_593);
  float _599 = log2(_595);
  float _600 = log2(_596);
  float _845;
  float _846;
  float _847;
  if (ConstBuf_passData_m0[2270u].z != 0.0f) {
    float _695, _701, _707;
    if (!RENODX_TONE_MAP_TYPE) {
      float _683 = exp2(log2(0.0f) * 0.4166666567325592041015625f);
      float _684 = 1.0f - _683;
      float _688 = exp2(log2(_684) * 2.400000095367431640625f);
      float _689 = _683 / _684;
      _695 = exp2(log2(max(_689 + ((_593 < 0.017999999225139617919921875f) ? (_579 * 0.0449999980628490447998046875f) : ((exp2(_598 * 0.449999988079071044921875f) * 1.09899997711181640625f) + (-0.098999999463558197021484375f))), 0.0f)) * 2.400000095367431640625f) * _688;
      _701 = exp2(log2(max(_689 + ((_595 < 0.017999999225139617919921875f) ? (_585 * 0.0449999980628490447998046875f) : ((exp2(_599 * 0.449999988079071044921875f) * 1.09899997711181640625f) + (-0.098999999463558197021484375f))), 0.0f)) * 2.400000095367431640625f) * _688;
      _707 = exp2(log2(max(_689 + ((_596 < 0.017999999225139617919921875f) ? (_591 * 0.0449999980628490447998046875f) : ((exp2(_600 * 0.449999988079071044921875f) * 1.09899997711181640625f) + (-0.098999999463558197021484375f))), 0.0f)) * 2.400000095367431640625f) * _688;
    } else {
      float3 corrected = renodx::color::correct::GammaSafe(float3(_593, _595, _596));
      _695 = corrected.r, _701 = corrected.g, _707 = corrected.b;
    }

    float _726 = mad(0.0433130674064159393310546875f, _707, mad(0.3292830288410186767578125f, _701, _695 * 0.627403914928436279296875f));
    float _727 = mad(0.01136231608688831329345703125f, _707, mad(0.9195404052734375f, _701, _695 * 0.069097287952899932861328125f));
    float _728 = mad(0.895595252513885498046875f, _707, mad(0.08801330626010894775390625f, _701, _695 * 0.01639143936336040496826171875f));

    float scalar;
    if (!RENODX_TONE_MAP_TYPE) {
      scalar = ConstBuf_passData_m0[2269u].y;
    } else {
      scalar = RENODX_DIFFUSE_WHITE_NITS / 100.f;
    }
    _726 *= scalar, _727 *= scalar, _728 *= scalar;  // 1.f at slider = 50

    if (!RENODX_USE_PQ_ENCODING) {
      _845 = ((((((((((_726 * 533095.75f) + 47438308.0f) * _726) + 29063622.0f) * _726) + 575216.75f) * _726) + 383.091033935546875f) * _726) + 0.000487781013362109661102294921875f) / ((((((((_726 * 66391356.0f) + 81884528.0f) * _726) + 4182885.0f) * _726) + 10668.404296875f) * _726) + 1.0f);
      _846 = ((((((((((_727 * 533095.75f) + 47438308.0f) * _727) + 29063622.0f) * _727) + 575216.75f) * _727) + 383.091033935546875f) * _727) + 0.000487781013362109661102294921875f) / ((((((((_727 * 66391356.0f) + 81884528.0f) * _727) + 4182885.0f) * _727) + 10668.404296875f) * _727) + 1.0f);
      _847 = ((((((((((_728 * 533095.75f) + 47438308.0f) * _728) + 29063622.0f) * _728) + 575216.75f) * _728) + 383.091033935546875f) * _728) + 0.000487781013362109661102294921875f) / ((((((((_728 * 66391356.0f) + 81884528.0f) * _728) + 4182885.0f) * _728) + 10668.404296875f) * _728) + 1.0f);
    } else {
      float3 pq_color = renodx::color::pq::EncodeSafe(float3(_726, _727, _728), 100.f);
      _845 = pq_color.r, _846 = pq_color.g, _847 = pq_color.b;
    }
  } else {
    _845 = (_593 < 0.003130800090730190277099609375f) ? (_579 * 0.12919999659061431884765625f) : ((exp2(_598 * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
    _846 = (_595 < 0.003130800090730190277099609375f) ? (_585 * 0.12919999659061431884765625f) : ((exp2(_599 * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
    _847 = (_596 < 0.003130800090730190277099609375f) ? (_591 * 0.12919999659061431884765625f) : ((exp2(_600 * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f));
  }
  float _857 = dot(float3(0.300000011920928955078125f, 0.60000002384185791015625f, 0.114000000059604644775390625f), float3(_845, _846, _847)) * 0.300000011920928955078125f;
  SV_Target.x = (((_857 - _845) * ConstBuf_modelData_m0[2u].z) + _845) * ConstBuf_modelData_m0[2u].x;
  SV_Target.y = (((_857 - _846) * ConstBuf_modelData_m0[2u].z) + _846) * ConstBuf_modelData_m0[2u].x;
  SV_Target.z = (((_857 - _847) * ConstBuf_modelData_m0[2u].z) + _847) * ConstBuf_modelData_m0[2u].x;

  SV_Target.w = ConstBuf_modelData_m0[2u].x;

  discard_exit();
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  NORMAL = stage_input.NORMAL;
  TANGENT = stage_input.TANGENT;
  PREV_POSITION_PS = stage_input.PREV_POSITION_PS;
  VERTEX_ID = stage_input.VERTEX_ID;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  return stage_output;
}
