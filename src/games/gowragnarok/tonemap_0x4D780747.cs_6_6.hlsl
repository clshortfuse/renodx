#include "./shared.h"
cbuffer ConstBuf_constantsUBO : register(b0, space0) {
  float4 ConstBuf_constants_m0[11] : packoffset(c0);
};

// ResourceDescriptorHeap
// RWTexture1D<float4> _9[] : register(u0, space0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  RWTexture1D<float4> outputTexture = ResourceDescriptorHeap[asuint(ConstBuf_constants_m0[10u].x)];

  float peak_nits = min(4000.0f, ConstBuf_constants_m0[4u].z);
  float min_nits = max(9.9999997473787516355514526367188e-05f, ConstBuf_constants_m0[3u].w);
  float exposure = ConstBuf_constants_m0[4u].x;  // brightness slider

  if (RENODX_OVERRIDE_PEAK_NITS) {
    peak_nits = RENODX_PEAK_WHITE_NITS;
  }
  if (RENODX_TONE_MAP_TYPE) {
    min_nits = 0.0001f;
    exposure = 8.f * RENODX_TONE_MAP_EXPOSURE;

    if (RENODX_GAMMA_CORRECTION) {
      peak_nits = renodx::color::correct::Gamma(peak_nits / RENODX_DIFFUSE_WHITE_NITS, true) * 100.f;
      min_nits = renodx::color::correct::Gamma(min_nits / RENODX_DIFFUSE_WHITE_NITS, true) * 100.f;
    } else {
      peak_nits = (peak_nits / RENODX_DIFFUSE_WHITE_NITS) * 100.f;
      min_nits = (min_nits / RENODX_DIFFUSE_WHITE_NITS) * 100.f;
    }
  }

  float _44 = log2(min_nits);  // float _44 = log2(max(9.9999997473787516355514526367188e-05f, ConstBuf_constants_m0[3u].w));
  float _51 = clamp((_44 * 0.13082401454448699951171875f) + 1.7383518218994140625f, 0.0f, 1.0f);
  float _58 = exp2((_51 * (-6.5f)) - ((1.0f - _51) * 15.0f));
  float _61 = log2(peak_nits);  // float _61 = log2(max(9.9999997473787516355514526367188e-05f, ConstBuf_constants_m0[3u].w));
  float _66 = clamp((_61 * 0.1298237740993499755859375f) + (-0.725060939788818359375f), 0.0f, 1.0f);
  float _73 = exp2(((1.0f - _66) * 6.5f) + (_66 * 18.0f));
  float _75 = log2(_58 * 0.180000007152557373046875f);
  float _76 = _44 * 0.3010300099849700927734375f;
  float _78 = _75 * 0.077766083180904388427734375f;
  float _80 = _78 + 0.873629271984100341796875f;
  float _82 = 0.48885345458984375f - _78;
  float _88 = clamp((log2(_58) + 15.0f) * 0.117647059261798858642578125f, 0.0f, 1.0f);
  float _97 = ((0.681241333484649658203125f - _76) * (((1.0f - _88) * 0.180000007152557373046875f) + (_88 * 0.3499999940395355224609375f))) + _76;
  float _98 = log2(_73 * 0.180000007152557373046875f);
  float _99 = _98 * 0.077766083180904388427734375f;
  float _100 = 0.48885345458984375f - _99;
  float _101 = _99 + 0.873629271984100341796875f;
  float _102 = _61 * 0.3010300099849700927734375f;
  float _107 = clamp((log2(_73) + (-6.5f)) * 0.086956523358821868896484375f, 0.0f, 1.0f);
  float _117 = ((((1.0f - _107) * 0.88999998569488525390625f) + (_107 * 0.89999997615814208984375f)) * (_102 + (-0.681241333484649658203125f))) + 0.681241333484649658203125f;
  float _120 = log2(exp2(_75));
  float _125 = log2(exp2(_98));
  float _133 = (_97 + _76) * 0.5f;
  float _138 = (_117 + _101) * 0.5f;
  float _144 = log2(max(exposure, 1.0000000133514319600180897396058e-10f)) * 0.3010300099849700927734375f;
  float _157;
  if (_144 > _76) {
    float frontier_phi_5_1_ladder;
    if ((_144 <= 0.681241333484649658203125f) && (_144 > _76)) {
      float _206;
      float _208;
      float _210;
      float _212;
      if ((_144 > ((_44 + _44) * 0.15051500499248504638671875f)) && (_144 <= _133)) {
        _206 = 0.0f;
        _208 = _76;
        _210 = _76;
        _212 = _97;
      } else {
        bool _238 = (_144 > _133) && (_144 <= ((_97 + _80) * 0.5f));
        _206 = _238 ? 1.0f : 2.0f;
        _208 = _238 ? _76 : _97;
        _210 = _238 ? _97 : _80;
        _212 = _238 ? _80 : _82;
      }
      float _214 = _208 * 0.5f;
      float _218 = _210 - _208;
      float _220 = mad(_210, 0.5f, _214) - _144;
      frontier_phi_5_1_ladder = (_120 * 0.3010300099849700927734375f) + ((((_220 * 2.0f) / (((-0.0f) - _218) - sqrt((_218 * _218) - ((mad(_212, 0.5f, mad(_210, -1.0f, _214)) * 4.0f) * _220)))) + _206) * ((-0.24824249744415283203125f) - (_120 * 0.100343339145183563232421875f)));
    } else {
      float frontier_phi_5_1_ladder_4_ladder;
      if ((_144 > 0.681241333484649658203125f) && (_144 < _102)) {
        float _267;
        float _269;
        float _271;
        float _273;
        if ((_144 >= 0.68124139308929443359375f) && (_144 <= _138)) {
          _267 = 0.0f;
          _269 = _100;
          _271 = _101;
          _273 = _117;
        } else {
          bool _294 = (_144 > _138) && (_144 <= ((_117 + _102) * 0.5f));
          _267 = _294 ? 1.0f : 2.0f;
          _269 = _294 ? _101 : _117;
          _271 = _294 ? _117 : _102;
          _273 = _102;
        }
        float _274 = _269 * 0.5f;
        float _277 = _271 - _269;
        float _279 = mad(_271, 0.5f, _274) - _144;
        frontier_phi_5_1_ladder_4_ladder = ((((_279 * 2.0f) / (((-0.0f) - _277) - sqrt((_277 * _277) - ((mad(_273, 0.5f, mad(_271, -1.0f, _274)) * 4.0f) * _279)))) + _267) * ((_125 * 0.100343339145183563232421875f) + 0.24824249744415283203125f)) + (-0.74472749233245849609375f);
      } else {
        frontier_phi_5_1_ladder_4_ladder = _125 * 0.3010300099849700927734375f;
      }
      frontier_phi_5_1_ladder = frontier_phi_5_1_ladder_4_ladder;
    }
    _157 = frontier_phi_5_1_ladder;
  } else {
    _157 = _120 * 0.3010300099849700927734375f;
  }
  float _164 = log2(exp2(_157 * 3.3219280242919921875f));
  float _165 = _164 + 2.4739310741424560546875f;
  float _27[6];
  _27[0u] = _76;
  _27[1u] = _76;
  _27[2u] = _97;
  _27[3u] = _80;
  _27[4u] = _82;
  _27[5u] = _82;
  float _28[6];
  _28[0u] = _100;
  _28[1u] = _101;
  _28[2u] = _117;
  _28[3u] = _102;
  _28[4u] = _102;
  _28[5u] = _102;
  float _201 = log2(max(exp2(((float(gl_GlobalInvocationID.x) * 33.0f) * ConstBuf_constants_m0[10u].y) + (-15.0f)) * 0.180000007152557373046875f, 5.9604644775390625e-08f));  // not brightness slider
  float _202 = _201 * 0.3010300099849700927734375f;
  float _203 = log2(exp2(_75 - _165));
  float _204 = _203 * 0.3010300099849700927734375f;
  float _251;
  if (_202 > _204) {
    float _247 = log2(exp2((-4.947862148284912109375f) - _164));
    float _248 = _247 * 0.3010300099849700927734375f;
    float frontier_phi_11_10_ladder;
    if ((_202 > _204) && (_202 < _248)) {
      float _300 = ((_201 - _203) * 0.903090000152587890625f) / ((_247 - _203) * 0.3010300099849700927734375f);
      uint _301 = uint(int(_300));
      float _303 = _300 - float(int(_301));
      uint _306 = _301 + 1u;
      float _313 = _27[_301] * 0.5f;
      frontier_phi_11_10_ladder = dot(float3(_303 * _303, _303, 1.0f), float3(mad(_27[_301 + 2u], 0.5f, mad(_27[_306], -1.0f, _313)), _27[_306] - _27[_301], mad(_27[_306], 0.5f, _313)));
    } else {
      float _322 = log2(exp2(_98 - _165));
      float frontier_phi_11_10_ladder_15_ladder;
      if ((_202 >= _248) && (_202 < (_322 * 0.3010300099849700927734375f))) {
        float _330 = ((_201 - _247) * 0.903090000152587890625f) / ((_322 - _247) * 0.3010300099849700927734375f);
        uint _331 = uint(int(_330));
        float _333 = _330 - float(int(_331));
        uint _336 = _331 + 1u;
        float _343 = _28[_331] * 0.5f;
        frontier_phi_11_10_ladder_15_ladder = dot(float3(_333 * _333, _333, 1.0f), float3(mad(_28[_331 + 2u], 0.5f, mad(_28[_336], -1.0f, _343)), _28[_336] - _28[_331], mad(_28[_336], 0.5f, _343)));
      } else {
        frontier_phi_11_10_ladder_15_ladder = _102;
      }
      frontier_phi_11_10_ladder = frontier_phi_11_10_ladder_15_ladder;
    }
    _251 = frontier_phi_11_10_ladder;
  } else {
    _251 = _76;
  }
  outputTexture[gl_GlobalInvocationID.x] = (exp2(_251 * 3.3219280242919921875f) * 0.00999999977648258209228515625f).xxxx;  // _9[asuint(ConstBuf_constants_m0[10u]).x][gl_GlobalInvocationID.x] = (exp2(_251 * 3.3219280242919921875f) * 0.00999999977648258209228515625f).xxxx;
}

[numthreads(64, 1, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
