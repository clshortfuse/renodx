#include "./output.hlsli"

cbuffer _21_23 : register(b0, space6) {
  float4 _23_m0[21] : packoffset(c0);
};

// SamplerState _8[] : register(s0, space0);
Texture2D<float4> _12 : register(t0, space6);
Texture2D<float4> _13 : register(t1, space6);
Texture2D<float4> _14 : register(t2, space6);
Texture2D<float4> _15 : register(t3, space6);
Texture2D<float4> _16 : register(t4, space6);

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
  uint4 _103 = asuint(_23_m0[20u]);
  uint _104 = _103.x;
  uint _105 = _103.y;

  // float4 _120 = _13.Sample(_8[6u], float2(TEXCOORD.x, TEXCOORD.y));
  float4 _120 = _13.Sample((SamplerState)ResourceDescriptorHeap[6u], float2(TEXCOORD.x, TEXCOORD.y));

  float _139 = (((_23_m0[11u].z * ((TEXCOORD.x * 2.0f) + (-1.0f))) + _23_m0[11u].x) * 0.5f) + 0.5f;
  float _140 = (((_23_m0[11u].w * ((TEXCOORD.y * 2.0f) + (-1.0f))) + _23_m0[11u].y) * 0.5f) + 0.5f;
  float _219;
  float _223;
  float _227;
  if ((_104 & 196608u) == 0u) {
    // float4 _147 = _12.SampleLevel(_8[3u], float2(_139, _140), 0.0f);
    float4 _147 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[3u], float2(_139, _140), 0.0f);

    _219 = _147.x;
    _223 = _147.y;
    _227 = _147.z;
  } else {
    float _155 = TEXCOORD.x + (-0.5f);
    float _157 = TEXCOORD.y + (-0.5f);
    float _164 = (((_23_m0[3u].z * _155) + 0.5f) * 2.0f) + (-1.0f);
    float _165 = (((_23_m0[3u].z * _157) + 0.5f) * 2.0f) + (-1.0f);
    float _166 = _164 * _23_m0[5u].x;
    float _167 = _165 * _23_m0[5u].y;
    float _168 = dot(float2(_166, _167), float2(_166, _167));
    float _171 = _168 * _168;
    float _172 = _23_m0[3u].x * 2.0f;
    float _173 = _23_m0[3u].y * 4.0f;
    float _180 = _23_m0[3u].x * 3.0f;
    float _182 = _23_m0[3u].y * 5.0f;
    float _196 = (dot(1.0f.xx, float2(_172, _173)) + 1.0f) / (dot(1.0f.xx, float2(_180, _182)) + 1.0f);
    float _198 = (dot(float2(_168, _171), float2(_172, _173)) + 1.0f) / (_196 * (dot(float2(_168, _171), float2(_180, _182)) + 1.0f));
    bool _199 = _23_m0[3u].w != 0.0f;
    float _203 = log2(abs(_199 ? _164 : _165));
    float _210 = _23_m0[4u].x * 0.5f;
    float _214 = ((((1.0f - _198) * _210) * (exp2(_203 * _23_m0[4u].z) + exp2(_203 * _23_m0[4u].y))) + _198) * 0.5f;
    float _217 = (_214 * _164) + 0.5f;
    float _218 = (_214 * _165) + 0.5f;
    float frontier_phi_3_2_ladder;
    float frontier_phi_3_2_ladder_1;
    float frontier_phi_3_2_ladder_2;

    if (_105 == 3u) {
      float _233 = _23_m0[6u].x * _23_m0[3u].z;
      float _240 = (((_233 * _155) + 0.5f) * 2.0f) + (-1.0f);
      float _241 = (((_233 * _157) + 0.5f) * 2.0f) + (-1.0f);
      float _242 = _240 * _23_m0[5u].x;
      float _243 = _241 * _23_m0[5u].y;
      float _244 = dot(float2(_242, _243), float2(_242, _243));
      float _247 = _244 * _244;
      float _257 = (dot(float2(_244, _247), float2(_172, _173)) + 1.0f) / ((dot(float2(_244, _247), float2(_180, _182)) + 1.0f) * _196);
      float _260 = log2(abs(_199 ? _240 : _241));
      float _270 = ((((1.0f - _257) * _210) * (exp2(_260 * _23_m0[4u].z) + exp2(_260 * _23_m0[4u].y))) + _257) * 0.5f;
      float _273 = (_270 * _240) + 0.5f;
      float _274 = (_270 * _241) + 0.5f;
      float _275 = _23_m0[6u].y * _23_m0[3u].z;
      float _282 = (((_275 * _155) + 0.5f) * 2.0f) + (-1.0f);
      float _283 = (((_275 * _157) + 0.5f) * 2.0f) + (-1.0f);
      float _284 = _282 * _23_m0[5u].x;
      float _285 = _283 * _23_m0[5u].y;
      float _286 = dot(float2(_284, _285), float2(_284, _285));
      float _289 = _286 * _286;
      float _299 = (dot(float2(_286, _289), float2(_172, _173)) + 1.0f) / ((dot(float2(_286, _289), float2(_180, _182)) + 1.0f) * _196);
      float _302 = log2(abs(_199 ? _282 : _283));
      float _312 = ((((1.0f - _299) * _210) * (exp2(_302 * _23_m0[4u].z) + exp2(_302 * _23_m0[4u].y))) + _299) * 0.5f;
      float _315 = (_312 * _282) + 0.5f;
      float _316 = (_312 * _283) + 0.5f;

      // float4 _335 = _12.SampleLevel(_8[17u], float2((_315 + _273) * 0.5f, (_316 + _274) * 0.5f), 0.0f);
      float4 _335 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_315 + _273) * 0.5f, (_316 + _274) * 0.5f), 0.0f);
      // float4 _339 = _12.SampleLevel(_8[17u], float2((_273 + _217) * 0.5f, (_274 + _218) * 0.5f), 0.0f);
      float4 _339 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_273 + _217) * 0.5f, (_274 + _218) * 0.5f), 0.0f);
      // frontier_phi_3_2_ladder = (_335.x + _12.SampleLevel(_8[17u], float2(_273, _274), 0.0f).x) * 0.5f;
      frontier_phi_3_2_ladder = (_335.x + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_273, _274), 0.0f).x) * 0.5f;
      // frontier_phi_3_2_ladder_1 = (((_339.y + _335.y) * 0.5f) + _12.SampleLevel(_8[17u], float2(_315, _316), 0.0f).y) * 0.5f;
      frontier_phi_3_2_ladder_1 = (((_339.y + _335.y) * 0.5f) + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_315, _316), 0.0f).y) * 0.5f;
      // frontier_phi_3_2_ladder_2 = (_339.z + _12.SampleLevel(_8[17u], float2(_217, _218), 0.0f).z) * 0.5f;
      frontier_phi_3_2_ladder_2 = (_339.z + _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_217, _218), 0.0f).z) * 0.5f;

    } else {
      float frontier_phi_3_2_ladder_5_ladder;
      float frontier_phi_3_2_ladder_5_ladder_1;
      float frontier_phi_3_2_ladder_5_ladder_2;
      if ((_105 & 1u) == 0u) {
        // float4 _417 = _12.SampleLevel(_8[17u], float2(_217, _218), 0.0f);
        float4 _417 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_217, _218), 0.0f);

        frontier_phi_3_2_ladder_5_ladder = _417.x;
        frontier_phi_3_2_ladder_5_ladder_1 = _417.y;
        frontier_phi_3_2_ladder_5_ladder_2 = _417.z;
      } else {
        float _419 = _23_m0[6u].x * _23_m0[3u].z;
        float _426 = (((_419 * _155) + 0.5f) * 2.0f) + (-1.0f);
        float _427 = (((_419 * _157) + 0.5f) * 2.0f) + (-1.0f);
        float _428 = _426 * _23_m0[5u].x;
        float _429 = _427 * _23_m0[5u].y;
        float _430 = dot(float2(_428, _429), float2(_428, _429));
        float _433 = _430 * _430;
        float _443 = (dot(float2(_430, _433), float2(_172, _173)) + 1.0f) / ((dot(float2(_430, _433), float2(_180, _182)) + 1.0f) * _196);
        float _446 = log2(abs(_199 ? _426 : _427));
        float _456 = ((((1.0f - _443) * _210) * (exp2(_446 * _23_m0[4u].z) + exp2(_446 * _23_m0[4u].y))) + _443) * 0.5f;
        float _461 = _23_m0[6u].y * _23_m0[3u].z;
        float _468 = (((_461 * _155) + 0.5f) * 2.0f) + (-1.0f);
        float _469 = (((_461 * _157) + 0.5f) * 2.0f) + (-1.0f);
        float _470 = _468 * _23_m0[5u].x;
        float _471 = _469 * _23_m0[5u].y;
        float _472 = dot(float2(_470, _471), float2(_470, _471));
        float _475 = _472 * _472;
        float _485 = (dot(float2(_472, _475), float2(_172, _173)) + 1.0f) / ((dot(float2(_472, _475), float2(_180, _182)) + 1.0f) * _196);
        float _488 = log2(abs(_199 ? _468 : _469));
        float _498 = ((((1.0f - _485) * _210) * (exp2(_488 * _23_m0[4u].z) + exp2(_488 * _23_m0[4u].y))) + _485) * 0.5f;

        // frontier_phi_3_2_ladder_5_ladder = _12.SampleLevel(_8[17u], float2((_456 * _426) + 0.5f, (_456 * _427) + 0.5f), 0.0f).x;
        frontier_phi_3_2_ladder_5_ladder = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_456 * _426) + 0.5f, (_456 * _427) + 0.5f), 0.0f).x;
        // frontier_phi_3_2_ladder_5_ladder_1 = _12.SampleLevel(_8[17u], float2((_498 * _468) + 0.5f, (_498 * _469) + 0.5f), 0.0f).y;
        frontier_phi_3_2_ladder_5_ladder_1 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((_498 * _468) + 0.5f, (_498 * _469) + 0.5f), 0.0f).y;
        // frontier_phi_3_2_ladder_5_ladder_2 = _12.SampleLevel(_8[17u], float2(_217, _218), 0.0f).z;
        frontier_phi_3_2_ladder_5_ladder_2 = _12.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2(_217, _218), 0.0f).z;
      }
      frontier_phi_3_2_ladder = frontier_phi_3_2_ladder_5_ladder;
      frontier_phi_3_2_ladder_1 = frontier_phi_3_2_ladder_5_ladder_1;
      frontier_phi_3_2_ladder_2 = frontier_phi_3_2_ladder_5_ladder_2;
    }
    _219 = frontier_phi_3_2_ladder;
    _223 = frontier_phi_3_2_ladder_1;
    _227 = frontier_phi_3_2_ladder_2;
  }
  float _350;
  float _352;
  float _354;
  if ((_104 & 8u) == 0u) {
    _350 = _219;
    _352 = _223;
    _354 = _227;
  } else {
    float _367 = (_139 * _23_m0[1u].x) + _23_m0[1u].z;
    float _368 = (_140 * _23_m0[1u].y) + _23_m0[1u].w;
    float _372 = max(min(_367, _23_m0[2u].x), min(max(_367, _23_m0[2u].x), _23_m0[2u].z));
    float _376 = max(min(_368, _23_m0[2u].y), min(max(_368, _23_m0[2u].y), _23_m0[2u].w));
    uint _392 = asuint(_23_m0[0u].z);
    // float _412 = (_14.SampleLevel(_8[17u], float2((float(_392 & 65535u) * 1.52587890625e-05f) + (_23_m0[0u].x * TEXCOORD.x), (float(_392 >> 16u) * 1.52587890625e-05f) + (_23_m0[0u].y * TEXCOORD.y)), 0.0f).y + (-0.5f)) * (((((_372 - _23_m0[2u].x) * (_372 - _23_m0[2u].z)) == 0.0f) || (((_376 - _23_m0[2u].y) * (_376 - _23_m0[2u].w)) == 0.0f)) ? 0.0f : _15.SampleLevel(_8[3u], float2(_372, _376), 0.0f).w);
    float _412 = (_14.SampleLevel((SamplerState)ResourceDescriptorHeap[17u], float2((float(_392 & 65535u) * 1.52587890625e-05f) + (_23_m0[0u].x * TEXCOORD.x), (float(_392 >> 16u) * 1.52587890625e-05f) + (_23_m0[0u].y * TEXCOORD.y)), 0.0f).y + (-0.5f)) * (((((_372 - _23_m0[2u].x) * (_372 - _23_m0[2u].z)) == 0.0f) || (((_376 - _23_m0[2u].y) * (_376 - _23_m0[2u].w)) == 0.0f)) ? 0.0f : _15.SampleLevel((SamplerState)ResourceDescriptorHeap[3u], float2(_372, _376), 0.0f).w);
    _350 = max(_412 + _219, 0.0f);
    _352 = max(_412 + _223, 0.0f);
    _354 = max(_412 + _227, 0.0f);
  }
  float _356 = 1.0f - _120.w;
  float _360 = (_350 * _356) + _120.x;
  float _361 = (_352 * _356) + _120.y;
  float _362 = (_354 * _356) + _120.z;
  uint _363 = uint(int(_23_m0[8u].w));
  float _600;
  float _602;
  float _604;
  if (_363 == 1u) {
    float _519 = exp2(log2(abs(_360)) * _23_m0[8u].x);
    float _520 = exp2(log2(abs(_361)) * _23_m0[8u].x);
    float _521 = exp2(log2(abs(_362)) * _23_m0[8u].x);
    float _601;
    if (_519 < 0.00310000008903443813323974609375f) {
      _601 = _519 * 12.9200000762939453125f;
    } else {
      _601 = (exp2(log2(abs(_519)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _603;
    if (_520 < 0.00310000008903443813323974609375f) {
      _603 = _520 * 12.9200000762939453125f;
    } else {
      _603 = (exp2(log2(abs(_520)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_15_19_ladder;
    float frontier_phi_15_19_ladder_1;
    float frontier_phi_15_19_ladder_2;
    if (_521 < 0.00310000008903443813323974609375f) {
      frontier_phi_15_19_ladder = _601;
      frontier_phi_15_19_ladder_1 = _603;
      frontier_phi_15_19_ladder_2 = _521 * 12.9200000762939453125f;
    } else {
      frontier_phi_15_19_ladder = _601;
      frontier_phi_15_19_ladder_1 = _603;
      frontier_phi_15_19_ladder_2 = (exp2(log2(abs(_521)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    _600 = frontier_phi_15_19_ladder;
    _602 = frontier_phi_15_19_ladder_1;
    _604 = frontier_phi_15_19_ladder_2;
  } else {
    float frontier_phi_15_11_ladder;
    float frontier_phi_15_11_ladder_1;
    float frontier_phi_15_11_ladder_2;
    if (_363 == 2u) {
#if 1
      float cbuffer_diffuse_white = _23_m0[8u].y;
      float cbuffer_PQ_M1 = _23_m0[8u].x;

      PQFromBT709FinalWithGammaCorrection(_360, _361, _362,
                                     cbuffer_PQ_M1, cbuffer_diffuse_white,
                                     frontier_phi_15_11_ladder, frontier_phi_15_11_ladder_1, frontier_phi_15_11_ladder_2);
#else
      float _566 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _362, mad(0.3292830288410186767578125f, _361, _360 * 0.627403914928436279296875f)) * _23_m0[8u].y)) * _23_m0[8u].x);
      float _567 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _362, mad(0.9195404052734375f, _361, _360 * 0.069097287952899932861328125f)) * _23_m0[8u].y)) * _23_m0[8u].x);
      float _568 = exp2(log2(abs(mad(0.895595252513885498046875f, _362, mad(0.08801330626010894775390625f, _361, _360 * 0.01639143936336040496826171875f)) * _23_m0[8u].y)) * _23_m0[8u].x);
      frontier_phi_15_11_ladder = exp2(log2(abs(((_566 * 18.8515625f) + 0.8359375f) / ((_566 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_15_11_ladder_1 = exp2(log2(abs(((_567 * 18.8515625f) + 0.8359375f) / ((_567 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_15_11_ladder_2 = exp2(log2(abs(((_568 * 18.8515625f) + 0.8359375f) / ((_568 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_15_11_ladder = _360;
      frontier_phi_15_11_ladder_1 = _361;
      frontier_phi_15_11_ladder_2 = _362;
    }
    _600 = frontier_phi_15_11_ladder;
    _602 = frontier_phi_15_11_ladder_1;
    _604 = frontier_phi_15_11_ladder_2;
  }
  float _616 = (_16.Load(int3(uint2(uint(int(gl_FragCoord.x)) & 31u, uint(int(gl_FragCoord.y)) & 31u), 0u)).x + (-0.5f)) * _23_m0[10u].x;
  SV_Target.x = _616 + _600;
  SV_Target.y = _616 + _602;
  SV_Target.z = _616 + _604;
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
