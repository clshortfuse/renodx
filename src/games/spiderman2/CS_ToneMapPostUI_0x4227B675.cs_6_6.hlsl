#include "./shared.h"

cbuffer GlobalViewportCBufferUBO : register(b0, space0) {
  float4 GlobalViewportCBuffer_m0[38] : packoffset(c0);
};

cbuffer ToneMapCBufferUBO : register(b2, space0) {
  float4 ToneMapCBuffer_m0[14] : packoffset(c0);
};

Texture3D<float4> g_TmToneMapLookup : register(t0, space0);
Texture2D<float4> g_TmFilmGrainNoise : register(t7, space0);
Buffer<uint4> g_TmAdaptedLumBuffer : register(t8, space0);
Texture2D<float4> g_TmSrgbOverlayMap : register(t9, space0);
Texture2D<float4> g_TmPreUIMap : register(t6, space0);
RWTexture2D<float4> g_TmOutput : register(u0, space0);
RWTexture2D<float4> g_TmOutputHudless : register(u1, space0);
SamplerState g_LinearClampSampler : register(s2, space0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  uint4 _50 = asuint(ToneMapCBuffer_m0[1u]);
  uint _53 = _50.x + gl_GlobalInvocationID.x;
  uint _54 = _50.y + gl_GlobalInvocationID.y;
  float4 _56 = g_TmPreUIMap.Load(int3(uint2(_53, _54), 0u));
  float _59 = _56.x;
  float _60 = _56.y;
  float _61 = _56.z;
  uint4 _71 = asuint(ToneMapCBuffer_m0[0u]);
  uint _72 = _71.z;
  uint _75 = (_72 != 0u) ? (_72 - _53) : _53;
  float _78 = float(_75) + 0.5f;
  float _80 = float(_54) + 0.5f;
  float _85 = _78 * ToneMapCBuffer_m0[0u].x;
  float _86 = _80 * ToneMapCBuffer_m0[0u].y;
  float _87 = _85 + (-0.5f);
  float _103 = clamp(((abs(_87) * 2.0f) - ToneMapCBuffer_m0[10u].y) / (ToneMapCBuffer_m0[10u].z - ToneMapCBuffer_m0[10u].y), 0.0f, 1.0f);
  float _111;
  float _115;
  float _119;
  if (_103 > 0.0f) {
    uint4 _108 = asuint(ToneMapCBuffer_m0[11u]);
    uint _109 = _108.y;
    float frontier_phi_2_1_ladder;
    float frontier_phi_2_1_ladder_1;
    float frontier_phi_2_1_ladder_2;
    if (_109 == 1u) {
      float _190 = ToneMapCBuffer_m0[10u].w * _103;
      uint _196 = uint(ceil(ToneMapCBuffer_m0[11u].x * _190));
      float frontier_phi_2_1_ladder_3_ladder;
      float frontier_phi_2_1_ladder_3_ladder_1;
      float frontier_phi_2_1_ladder_3_ladder_2;
      if (_196 == 0u) {
        frontier_phi_2_1_ladder_3_ladder = _61;
        frontier_phi_2_1_ladder_3_ladder_1 = _60;
        frontier_phi_2_1_ladder_3_ladder_2 = _59;
      } else {
        uint _334 = uint(int(_78));
        uint _335 = uint(int(_80));
        float _360 = ((float(int(((_335 + _334) + uint(int(GlobalViewportCBuffer_m0[28u].z))) & 1u)) * 0.100000001490116119384765625f) + frac(((GlobalViewportCBuffer_m0[33u].w + float(int(_334))) + (float(int(_335)) * 2.0f)) * 0.20000000298023223876953125f)) * 6.283185482025146484375f;
        float _365 = 1.0f / float(_196);
        float _518;
        float _520;
        float _522;
        float _524;
        float _526;
        float _528;
        uint _530;
        _518 = cos(_360);
        _520 = sin(_360);
        _522 = _365 * 0.5f;
        _524 = 0.0f;
        _526 = 0.0f;
        _528 = 0.0f;
        _530 = 0u;
        float _525;
        float _527;
        float _529;
        for (;;) {
          float _532 = sqrt(_522);
          float4 _544 = g_TmPreUIMap.SampleLevel(g_LinearClampSampler, float2((((_190 * ToneMapCBuffer_m0[0u].x) * _518) * _532) + _85, (((_190 * ToneMapCBuffer_m0[0u].y) * _520) * _532) + _86), 0.0f);
          _525 = _544.x + _524;
          _527 = _544.y + _526;
          _529 = _544.z + _528;
          float _553 = _518 * 0.67549037933349609375f;
          uint _531 = _530 + 1u;
          if (_531 == _196) {
            break;
          } else {
            _518 = (_518 * (-0.7373688220977783203125f)) - (_520 * 0.67549037933349609375f);
            _520 = _553 - (_520 * 0.7373688220977783203125f);
            _522 += _365;
            _524 = _525;
            _526 = _527;
            _528 = _529;
            _530 = _531;
          }
        }
        float _598 = clamp(_190, 0.0f, 1.0f);
        frontier_phi_2_1_ladder_3_ladder = (_598 * ((_529 * _365) - _61)) + _61;
        frontier_phi_2_1_ladder_3_ladder_1 = (_598 * ((_527 * _365) - _60)) + _60;
        frontier_phi_2_1_ladder_3_ladder_2 = (_598 * ((_525 * _365) - _59)) + _59;
      }
      frontier_phi_2_1_ladder = frontier_phi_2_1_ladder_3_ladder;
      frontier_phi_2_1_ladder_1 = frontier_phi_2_1_ladder_3_ladder_1;
      frontier_phi_2_1_ladder_2 = frontier_phi_2_1_ladder_3_ladder_2;
    } else {
      float frontier_phi_2_1_ladder_4_ladder;
      float frontier_phi_2_1_ladder_4_ladder_1;
      float frontier_phi_2_1_ladder_4_ladder_2;
      if (_109 == 2u) {
        float _368 = ToneMapCBuffer_m0[10u].w * _103;
        uint _374 = uint(ceil(ToneMapCBuffer_m0[11u].x * _368));
        float frontier_phi_2_1_ladder_4_ladder_8_ladder;
        float frontier_phi_2_1_ladder_4_ladder_8_ladder_1;
        float frontier_phi_2_1_ladder_4_ladder_8_ladder_2;
        if (_374 == 0u) {
          frontier_phi_2_1_ladder_4_ladder_8_ladder = _61;
          frontier_phi_2_1_ladder_4_ladder_8_ladder_1 = _60;
          frontier_phi_2_1_ladder_4_ladder_8_ladder_2 = _59;
        } else {
          uint _557 = uint(int(_78));
          uint _558 = uint(int(_80));
          float _579 = ((float(int(((_558 + _557) + uint(int(GlobalViewportCBuffer_m0[28u].z))) & 1u)) * 0.100000001490116119384765625f) + frac(((GlobalViewportCBuffer_m0[33u].w + float(int(_557))) + (float(int(_558)) * 2.0f)) * 0.20000000298023223876953125f)) * 6.283185482025146484375f;
          float _583 = _87 * ToneMapCBuffer_m0[10u].y;
          float _584 = (_86 + (-0.5f)) * ToneMapCBuffer_m0[10u].y;
          float _586 = 1.0f / float(_374);
          float _605;
          float _607;
          float _609;
          float _611;
          float _613;
          float _615;
          uint _617;
          _605 = cos(_579);
          _607 = sin(_579);
          _609 = _586 * 0.5f;
          _611 = 0.0f;
          _613 = 0.0f;
          _615 = 0.0f;
          _617 = 0u;
          float _612;
          float _614;
          float _616;
          for (;;) {
            float _619 = sqrt(_609);
            float _633 = (-0.0f) - ToneMapCBuffer_m0[10u].y;
            float4 _645 = g_TmPreUIMap.SampleLevel(g_LinearClampSampler, float2((min(max((_583 + (((_368 * ToneMapCBuffer_m0[0u].x) * _605) * _619)) * 2.0f, _633), ToneMapCBuffer_m0[10u].y) * 0.5f) + 0.5f, (min(max((_584 + (((_368 * ToneMapCBuffer_m0[0u].y) * _607) * _619)) * 2.0f, _633), ToneMapCBuffer_m0[10u].y) * 0.5f) + 0.5f), 0.0f);
            _612 = _645.x + _611;
            _614 = _645.y + _613;
            _616 = _645.z + _615;
            float _652 = _605 * 0.67549037933349609375f;
            uint _618 = _617 + 1u;
            if (_618 == _374) {
              break;
            } else {
              _605 = (_605 * (-0.7373688220977783203125f)) - (_607 * 0.67549037933349609375f);
              _607 = _652 - (_607 * 0.7373688220977783203125f);
              _609 += _586;
              _611 = _612;
              _613 = _614;
              _615 = _616;
              _617 = _618;
            }
          }
          float _658 = clamp(_103, 0.0f, 1.0f);
          frontier_phi_2_1_ladder_4_ladder_8_ladder = (_658 * ((_616 * _586) - _61)) + _61;
          frontier_phi_2_1_ladder_4_ladder_8_ladder_1 = (_658 * ((_614 * _586) - _60)) + _60;
          frontier_phi_2_1_ladder_4_ladder_8_ladder_2 = (_658 * ((_612 * _586) - _59)) + _59;
        }
        frontier_phi_2_1_ladder_4_ladder = frontier_phi_2_1_ladder_4_ladder_8_ladder;
        frontier_phi_2_1_ladder_4_ladder_1 = frontier_phi_2_1_ladder_4_ladder_8_ladder_1;
        frontier_phi_2_1_ladder_4_ladder_2 = frontier_phi_2_1_ladder_4_ladder_8_ladder_2;
      } else {
        float frontier_phi_2_1_ladder_4_ladder_9_ladder;
        float frontier_phi_2_1_ladder_4_ladder_9_ladder_1;
        float frontier_phi_2_1_ladder_4_ladder_9_ladder_2;
        if (_109 == 3u) {
          float _588 = clamp(_103, 0.0f, 1.0f);
          frontier_phi_2_1_ladder_4_ladder_9_ladder = _61 - (_588 * _61);
          frontier_phi_2_1_ladder_4_ladder_9_ladder_1 = _60 - (_588 * _60);
          frontier_phi_2_1_ladder_4_ladder_9_ladder_2 = _59 - (_588 * _59);
        } else {
          frontier_phi_2_1_ladder_4_ladder_9_ladder = _61;
          frontier_phi_2_1_ladder_4_ladder_9_ladder_1 = _60;
          frontier_phi_2_1_ladder_4_ladder_9_ladder_2 = _59;
        }
        frontier_phi_2_1_ladder_4_ladder = frontier_phi_2_1_ladder_4_ladder_9_ladder;
        frontier_phi_2_1_ladder_4_ladder_1 = frontier_phi_2_1_ladder_4_ladder_9_ladder_1;
        frontier_phi_2_1_ladder_4_ladder_2 = frontier_phi_2_1_ladder_4_ladder_9_ladder_2;
      }
      frontier_phi_2_1_ladder = frontier_phi_2_1_ladder_4_ladder;
      frontier_phi_2_1_ladder_1 = frontier_phi_2_1_ladder_4_ladder_1;
      frontier_phi_2_1_ladder_2 = frontier_phi_2_1_ladder_4_ladder_2;
    }
    _111 = frontier_phi_2_1_ladder_2;
    _115 = frontier_phi_2_1_ladder_1;
    _119 = frontier_phi_2_1_ladder;
  } else {
    _111 = _59;
    _115 = _60;
    _119 = _61;
  }
  float _135 = ((ToneMapCBuffer_m0[0u].x * (float(_53) + 0.5f)) * ToneMapCBuffer_m0[7u].x) + ToneMapCBuffer_m0[7u].z;
  float _136 = (ToneMapCBuffer_m0[7u].y * _86) + ToneMapCBuffer_m0[7u].w;
  float _143 = clamp((1.0f - max(abs(_135), abs(_136))) * 4096.0f, 0.0f, 1.0f);
  float4 _152 = g_TmSrgbOverlayMap.SampleLevel(g_LinearClampSampler, float2((_135 * 0.5f) + 0.5f, (_136 * 0.5f) + 0.5f), 0.0f);
  float _173 = ToneMapCBuffer_m0[4u].y * ((_85 * 2.0f) + (-1.0f));
  float _174 = ToneMapCBuffer_m0[4u].z * ((_86 * 2.0f) + (-1.0f));
  float _181 = max(sqrt(dot(float2(_173, _174), float2(_173, _174))) - ToneMapCBuffer_m0[4u].w, 0.0f);
  float _184 = 1.0f / ((_181 * _181) + 1.0f);
  float _185 = _184 * _184;
  float _186 = _185 * _111;
  float _187 = _185 * _115;
  float _188 = _185 * _119;
  float _200;
  float _202;
  float _204;
  if (asuint(ToneMapCBuffer_m0[12u]).y == 0u) {
    _200 = _186;
    _202 = _187;
    _204 = _188;
  } else {
    uint4 _287 = asuint(ToneMapCBuffer_m0[3u]);
    uint _288 = _287.x;
    uint _289 = _287.y;
    uint _290 = _288 + _75;
    uint _291 = _289 + _54;
    uint _292 = _289 ^ _288;
    uint _296 = ((_292 & 2u) != 0u) ? (0u - _290) : _290;
    bool _298 = (_292 & 1u) != 0u;
    float4 _320 = g_TmFilmGrainNoise.Load(int3(uint2(uint(int(ToneMapCBuffer_m0[2u].x * frac((float(int(_298 ? _291 : _296)) + 0.5f) * ToneMapCBuffer_m0[2u].z))), uint(int(ToneMapCBuffer_m0[2u].y * frac((float(int(_298 ? _296 : _291)) + 0.5f) * ToneMapCBuffer_m0[2u].w)))), 0u));
    float _322 = _320.x;
    float _324 = _322 * 2.0f;
    float _333 = ((((_322 >= 0.5f) ? _324 : (1.0f / (2.0f - _324))) + (-1.0f)) * ToneMapCBuffer_m0[3u].z) + 1.0f;
    _200 = _333 * _186;
    _202 = _333 * _187;
    _204 = _333 * _188;
  }
  float _211 = ToneMapCBuffer_m0[4u].x * asfloat(g_TmAdaptedLumBuffer.Load(1u).x);
  float4 _229 = g_TmToneMapLookup.SampleLevel(g_LinearClampSampler, float3((log2(_211 * _200) * 0.0538194440305233001708984375f) + 0.553819477558135986328125f, (log2(_211 * _202) * 0.0538194440305233001708984375f) + 0.553819477558135986328125f, (log2(_211 * _204) * 0.0538194440305233001708984375f) + 0.553819477558135986328125f), 0.0f);
  float _241 = (ToneMapCBuffer_m0[9u].w != 0.0f) ? ToneMapCBuffer_m0[9u].z : 1.0f;
  float _242 = _241 * _229.x;
  float _243 = _241 * _229.y;
  float _244 = _241 * _229.z;
  float _246 = (-0.0f) - (_143 * (_152.w + (-1.0f)));
  float _251 = (_242 * _246) + (_152.x * _143);
  float _252 = (_243 * _246) + (_152.y * _143);
  float _253 = (_244 * _246) + (_152.z * _143);
  float _267 = ((ToneMapCBuffer_m0[8u].x - _251) * ToneMapCBuffer_m0[8u].w) + _251;
  float _268 = ((ToneMapCBuffer_m0[8u].y - _252) * ToneMapCBuffer_m0[8u].w) + _252;
  float _269 = ((ToneMapCBuffer_m0[8u].z - _253) * ToneMapCBuffer_m0[8u].w) + _253;
  float _276 = ((ToneMapCBuffer_m0[8u].x - _242) * ToneMapCBuffer_m0[8u].w) + _242;
  float _277 = ((ToneMapCBuffer_m0[8u].y - _243) * ToneMapCBuffer_m0[8u].w) + _243;
  float _278 = ((ToneMapCBuffer_m0[8u].z - _244) * ToneMapCBuffer_m0[8u].w) + _244;
  float _504;
  float _505;
  float _506;
  float _507;
  float _508;
  float _509;
  if (ToneMapCBuffer_m0[5u].w != 0.0f) {
#if RENODX_ENABLE_GAMMA_ADJUST
    float _386 = exp2(log2(_267) * RENODX_GAMMA_ADJUST_VALUE);
    float _387 = exp2(log2(_268) * RENODX_GAMMA_ADJUST_VALUE);
    float _388 = exp2(log2(_269) * RENODX_GAMMA_ADJUST_VALUE);
#else
    float _386 = exp2(log2(_267) * ToneMapCBuffer_m0[5u].w);
    float _387 = exp2(log2(_268) * ToneMapCBuffer_m0[5u].w);
    float _388 = exp2(log2(_269) * ToneMapCBuffer_m0[5u].w);
#endif
    float _389 = ToneMapCBuffer_m0[10u].x * 9.9999997473787516355514526367188e-05f;
    float _419 = exp2(log2(mad(0.0432999990880489349365234375f, _388, mad(0.329299986362457275390625f, _387, _386 * 0.627399981021881103515625f)) * _389) * 0.1593017578125f);
    float _420 = exp2(log2(mad(0.011400000192224979400634765625f, _388, mad(0.91949999332427978515625f, _387, _386 * 0.069099999964237213134765625f)) * _389) * 0.1593017578125f);
    float _421 = exp2(log2(mad(0.895600020885467529296875f, _388, mad(0.087999999523162841796875f, _387, _386 * 0.01640000008046627044677734375f)) * _389) * 0.1593017578125f);
#if RENODX_ENABLE_GAMMA_ADJUST
    float _456 = exp2(log2(_276) * RENODX_GAMMA_ADJUST_VALUE);
    float _457 = exp2(log2(_277) * RENODX_GAMMA_ADJUST_VALUE);
    float _458 = exp2(log2(_278) * RENODX_GAMMA_ADJUST_VALUE);
#else
    float _456 = exp2(log2(_276) * ToneMapCBuffer_m0[5u].w);
    float _457 = exp2(log2(_277) * ToneMapCBuffer_m0[5u].w);
    float _458 = exp2(log2(_278) * ToneMapCBuffer_m0[5u].w);
#endif
    float _477 = exp2(log2(mad(0.0432999990880489349365234375f, _458, mad(0.329299986362457275390625f, _457, _456 * 0.627399981021881103515625f)) * _389) * 0.1593017578125f);
    float _478 = exp2(log2(mad(0.011400000192224979400634765625f, _458, mad(0.91949999332427978515625f, _457, _456 * 0.069099999964237213134765625f)) * _389) * 0.1593017578125f);
    float _479 = exp2(log2(mad(0.895600020885467529296875f, _458, mad(0.087999999523162841796875f, _457, _456 * 0.01640000008046627044677734375f)) * _389) * 0.1593017578125f);
    _504 = exp2(log2(((_419 * 18.8515625f) + 0.8359375f) / ((_419 * 18.6875f) + 1.0f)) * 78.84375f);
    _505 = exp2(log2(((_420 * 18.8515625f) + 0.8359375f) / ((_420 * 18.6875f) + 1.0f)) * 78.84375f);
    _506 = exp2(log2(((_421 * 18.8515625f) + 0.8359375f) / ((_421 * 18.6875f) + 1.0f)) * 78.84375f);
    _507 = exp2(log2(((_477 * 18.8515625f) + 0.8359375f) / ((_477 * 18.6875f) + 1.0f)) * 78.84375f);
    _508 = exp2(log2(((_478 * 18.8515625f) + 0.8359375f) / ((_478 * 18.6875f) + 1.0f)) * 78.84375f);
    _509 = exp2(log2(((_479 * 18.8515625f) + 0.8359375f) / ((_479 * 18.6875f) + 1.0f)) * 78.84375f);
  } else {
    _504 = _267;
    _505 = _268;
    _506 = _269;
    _507 = _276;
    _508 = _277;
    _509 = _278;
  }
  g_TmOutput[uint2(_53, _54)] = float4(_504, _505, _506, 1.0f);
  if (ToneMapCBuffer_m0[13u].z != 0.0f) {
    g_TmOutputHudless[uint2(_53, _54)] = float4(_507, _508, _509, 1.0f);
  }
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
