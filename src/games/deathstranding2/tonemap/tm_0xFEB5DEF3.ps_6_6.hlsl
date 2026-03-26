#include "./tonemap.hlsli"

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

static float2 TEXCOORD;
static float4 SV_Target;
static float SV_Target_1;

struct SPIRV_Cross_Input {
  noperspective float4 SV_Position : SV_Position;
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
  uint4 _64 = asuint(_35_m0[0u]);
  uint4 _142 = asuint(_40_m0[13u]);
  uint4 _189 = asuint(_40_m0[19u]);
  uint _190 = _189.w;
  uint4 _194 = asuint(_40_m0[21u]);
  uint _195 = _194.y;
  float _227 = (((_40_m0[6u].z * ((_40_m0[0u].z + (-0.5f)) + (_40_m0[0u].x * TEXCOORD.x))) + 0.5f) * 2.0f) + (-1.0f);
  float _229 = (((_40_m0[6u].z * ((_40_m0[0u].w + (-0.5f)) + (_40_m0[0u].y * TEXCOORD.y))) + 0.5f) * 2.0f) + (-1.0f);
  float _230 = _227 * _40_m0[8u].x;
  float _231 = _229 * _40_m0[8u].y;
  float _232 = dot(float2(_230, _231), float2(_230, _231));
  float _235 = _232 * _232;
  float _236 = _40_m0[6u].x * 2.0f;
  float _237 = _40_m0[6u].y * 4.0f;
  float _244 = _40_m0[6u].x * 3.0f;
  float _246 = _40_m0[6u].y * 5.0f;
  float _262 = (dot(float2(_232, _235), float2(_236, _237)) + 1.0f) / (((dot(1.0f.xx, float2(_236, _237)) + 1.0f) / (dot(1.0f.xx, float2(_244, _246)) + 1.0f)) * (dot(float2(_232, _235), float2(_244, _246)) + 1.0f));
  float _269 = log2(abs((_40_m0[6u].w != 0.0f) ? _227 : _229));
  float _280 = ((((_40_m0[7u].x * 0.5f) * (1.0f - _262)) * (exp2(_269 * _40_m0[7u].z) + exp2(_269 * _40_m0[7u].y))) + _262) * 0.5f;
  float _283 = (_280 * _227) + 0.5f;
  float _284 = (_280 * _229) + 0.5f;
  uint _287_dummy_parameter;
  uint2 _287 = spvTextureSize(_18, 0u, _287_dummy_parameter);
  float _294 = (1.0f / _40_m0[0u].x) * _283;
  float _295 = _294 * _40_m0[21u].z;
  float _296 = (1.0f / _40_m0[0u].y) * _284;
  float _297 = _296 * _40_m0[21u].w;
  float _298 = _294 * _40_m0[22u].x;
  float _299 = _296 * _40_m0[22u].y;
  float _303 = max(min(_298, _40_m0[15u].x), min(max(_298, _40_m0[15u].x), _40_m0[15u].z));
  float _307 = max(min(_299, _40_m0[15u].y), min(max(_299, _40_m0[15u].y), _40_m0[15u].w));
  float4 _317 = _18.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_295, _297));
  float _319 = _317.x;
  float _320 = _317.y;
  float _321 = _317.z;
  float _324 = float(int(_142.x));
  float _325 = float(int(_142.y));
  float _331 = float(int(uint(int(uint(clamp(_298, 0.0f, 1.0f) * float(int(_287.x)))) >> int(_64.z & 31u))));
  float _332 = float(int(uint(int(uint(clamp(_299, 0.0f, 1.0f) * float(int(_287.y)))) >> int(_64.w & 31u))));
  uint4 _344 = _12.Load(int3(uint2(uint(int(max(min(_331, _324), min(max(_331, _324), float(int(_142.z)))))), uint(int(max(min(_332, _325), min(max(_332, _325), float(int(_142.w))))))), 0u));
  uint _346 = _344.x;
  float _348;
  float _353;
  float _358;
  if (_346 == 0u) {
    _348 = _319;
    _353 = _320;
    _358 = _321;
  } else {
    float frontier_phi_1_2_ladder;
    float frontier_phi_1_2_ladder_1;
    float frontier_phi_1_2_ladder_2;
    if ((_346 & 536870912u) == 0u) {
      float frontier_phi_1_2_ladder_5_ladder;
      float frontier_phi_1_2_ladder_5_ladder_1;
      float frontier_phi_1_2_ladder_5_ladder_2;
      if ((_346 & 268435456u) == 0u) {
        float4 _566 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_298, _299));
        float _568 = _566.x;
        float4 _571 = _17.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_303, _307));
        float _573 = _571.x;
        float _593;
        if ((_190 & 4u) == 0u) {
          _593 = _573;
        } else {
          _593 = max(clamp(_568 * (-4.0f), 0.0f, 1.0f), _573);
        }
        float _599 = clamp((_568 * 4.80000019073486328125f) + (-0.20000000298023223876953125f), 0.0f, 1.0f);
        float _600 = _299 - _35_m0[0u].y;
        float _604 = max(min(_298, _40_m0[14u].x), min(max(_298, _40_m0[14u].x), _40_m0[14u].z));
        float4 _610 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_604, max(min(_600, _40_m0[14u].y), min(max(_600, _40_m0[14u].y), _40_m0[14u].w))));
        float _614 = _298 - _35_m0[0u].x;
        float _622 = max(min(_299, _40_m0[14u].y), min(max(_299, _40_m0[14u].y), _40_m0[14u].w));
        float4 _623 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(max(min(_614, _40_m0[14u].x), min(max(_614, _40_m0[14u].x), _40_m0[14u].z)), _622));
        float _627 = _298 + _35_m0[0u].x;
        float4 _632 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(max(min(_627, _40_m0[14u].x), min(max(_627, _40_m0[14u].x), _40_m0[14u].z)), _622));
        float _636 = _299 + _35_m0[0u].y;
        float4 _641 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_604, max(min(_636, _40_m0[14u].y), min(max(_636, _40_m0[14u].y), _40_m0[14u].w))));
        float _644 = min(min(min(min(_568, _610.x), _623.x), _632.x), _641.x);
        float _865;
        if (_644 < 0.0f) {
          _865 = (-0.0f) - _644;
        } else {
          _865 = max(_644, _568);
        }
        float _866 = _865 * 24.0f;
        float _1157;
        float _1158;
        float _1159;
        if ((_599 < 1.0f) && ((_593 < 1.0f) && (((_190 & 32768u) != 0u) && (_866 > 0.25f)))) {
          float _976 = min(_866 + (-0.25f), 4.0f);
          float _977 = _976 * _35_m0[0u].x;
          float _978 = _976 * _35_m0[0u].y;
          float _986 = _978 + _297;
          float _990 = max(min(_295, _40_m0[14u].x), min(max(_295, _40_m0[14u].x), _40_m0[14u].z));
          float4 _996 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_990, max(min(_986, _40_m0[14u].y), min(max(_986, _40_m0[14u].y), _40_m0[14u].w))), 0.0f);
          float _1010 = _977 * 0.707106769084930419921875f;
          float _1012 = _978 * 0.707106769084930419921875f;
          float _1013 = _1010 + _295;
          float _1014 = _1012 + _297;
          float _1018 = max(min(_1013, _40_m0[14u].x), min(max(_1013, _40_m0[14u].x), _40_m0[14u].z));
          float _1022 = max(min(_1014, _40_m0[14u].y), min(max(_1014, _40_m0[14u].y), _40_m0[14u].w));
          float4 _1023 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1018, _1022), 0.0f);
          float _1037 = _977 + _295;
          float _1045 = max(min(_297, _40_m0[14u].y), min(max(_297, _40_m0[14u].y), _40_m0[14u].w));
          float4 _1046 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(max(min(_1037, _40_m0[14u].x), min(max(_1037, _40_m0[14u].x), _40_m0[14u].z)), _1045), 0.0f);
          float _1060 = _297 - _1012;
          float _1064 = max(min(_1060, _40_m0[14u].y), min(max(_1060, _40_m0[14u].y), _40_m0[14u].w));
          float4 _1065 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1018, _1064), 0.0f);
          float _1079 = _297 - _978;
          float4 _1084 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_990, max(min(_1079, _40_m0[14u].y), min(max(_1079, _40_m0[14u].y), _40_m0[14u].w))), 0.0f);
          float _1098 = _295 - _1010;
          float _1102 = max(min(_1098, _40_m0[14u].x), min(max(_1098, _40_m0[14u].x), _40_m0[14u].z));
          float4 _1103 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1102, _1064), 0.0f);
          float _1117 = _295 - _977;
          float4 _1122 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(max(min(_1117, _40_m0[14u].x), min(max(_1117, _40_m0[14u].x), _40_m0[14u].z)), _1045), 0.0f);
          float4 _1136 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1102, _1022), 0.0f);
          _1157 = exp2(((((((((log2(max(_996.x, 1.0000000133514319600180897396058e-10f)) + log2(max(_319, 1.0000000133514319600180897396058e-10f))) + log2(max(_1023.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1046.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1065.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1084.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1103.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1122.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1136.x, 1.0000000133514319600180897396058e-10f))) * 0.111111111938953399658203125f);
          _1158 = exp2(((((((((log2(max(_996.y, 1.0000000133514319600180897396058e-10f)) + log2(max(_320, 1.0000000133514319600180897396058e-10f))) + log2(max(_1023.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1046.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1065.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1084.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1103.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1122.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1136.y, 1.0000000133514319600180897396058e-10f))) * 0.111111111938953399658203125f);
          _1159 = exp2(((((((((log2(max(_996.z, 1.0000000133514319600180897396058e-10f)) + log2(max(_321, 1.0000000133514319600180897396058e-10f))) + log2(max(_1023.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1046.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1065.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1084.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1103.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1122.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1136.z, 1.0000000133514319600180897396058e-10f))) * 0.111111111938953399658203125f);
        } else {
          _1157 = _319;
          _1158 = _320;
          _1159 = _321;
        }
        float4 _1162 = _20.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_303, _307));
        float _352 = ((_1162.x - _1157) * _599) + _1157;
        float _357 = ((_1162.y - _1158) * _599) + _1158;
        float _362 = ((_1162.z - _1159) * _599) + _1159;
        float4 _1175 = _19.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_303, _307));
        float frontier_phi_1_2_ladder_5_ladder_29_ladder;
        float frontier_phi_1_2_ladder_5_ladder_29_ladder_1;
        float frontier_phi_1_2_ladder_5_ladder_29_ladder_2;
        if ((_1175.z > 0.0f) || ((_1175.x > 0.0f) || (_1175.y > 0.0f))) {
          float4 _1187 = _19.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_303, _307));
          frontier_phi_1_2_ladder_5_ladder_29_ladder = ((_1187.z - _362) * _593) + _362;
          frontier_phi_1_2_ladder_5_ladder_29_ladder_1 = ((_1187.y - _357) * _593) + _357;
          frontier_phi_1_2_ladder_5_ladder_29_ladder_2 = ((_1187.x - _352) * _593) + _352;
        } else {
          frontier_phi_1_2_ladder_5_ladder_29_ladder = _362;
          frontier_phi_1_2_ladder_5_ladder_29_ladder_1 = _357;
          frontier_phi_1_2_ladder_5_ladder_29_ladder_2 = _352;
        }
        frontier_phi_1_2_ladder_5_ladder = frontier_phi_1_2_ladder_5_ladder_29_ladder;
        frontier_phi_1_2_ladder_5_ladder_1 = frontier_phi_1_2_ladder_5_ladder_29_ladder_1;
        frontier_phi_1_2_ladder_5_ladder_2 = frontier_phi_1_2_ladder_5_ladder_29_ladder_2;
      } else {
        float4 _578 = _20.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_303, _307));
        frontier_phi_1_2_ladder_5_ladder = _578.z;
        frontier_phi_1_2_ladder_5_ladder_1 = _578.y;
        frontier_phi_1_2_ladder_5_ladder_2 = _578.x;
      }
      frontier_phi_1_2_ladder = frontier_phi_1_2_ladder_5_ladder;
      frontier_phi_1_2_ladder_1 = frontier_phi_1_2_ladder_5_ladder_1;
      frontier_phi_1_2_ladder_2 = frontier_phi_1_2_ladder_5_ladder_2;
    } else {
      float4 _529 = _19.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_303, _307));
      frontier_phi_1_2_ladder = _529.z;
      frontier_phi_1_2_ladder_1 = _529.y;
      frontier_phi_1_2_ladder_2 = _529.x;
    }
    _348 = frontier_phi_1_2_ladder_2;
    _353 = frontier_phi_1_2_ladder_1;
    _358 = frontier_phi_1_2_ladder;
  }
  float _365 = (_283 - _40_m0[0u].z) / _40_m0[0u].x;
  float _366 = (_284 - _40_m0[0u].w) / _40_m0[0u].y;
  float4 _384 = _26.Load(2u);
  float _385 = _384.x;
  float4 _388 = _21.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(max(min(_365, _40_m0[16u].x), min(max(_365, _40_m0[16u].x), _40_m0[16u].z)), max(min(_366, _40_m0[16u].y), min(max(_366, _40_m0[16u].y), _40_m0[16u].w))));
  float _390 = _388.x;
  float _391 = _388.y;
  float _392 = _388.z;
  float4 _395 = _22.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(max(min(_365, _40_m0[15u].x), min(max(_365, _40_m0[15u].x), _40_m0[15u].z)), max(min(_366, _40_m0[15u].y), min(max(_366, _40_m0[15u].y), _40_m0[15u].w))));
  float _403 = _40_m0[19u].y * 0.25f;
  float _405 = _348 * _403;
  float _406 = _353 * _403;
  float _407 = _358 * _403;
  float _420 = (clamp(dot(float3(_405, _406, _407), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) + 9.9999999747524270787835121154785e-07f, 0.0f, 1.0f) * (1.0f - _40_m0[17u].w)) + _40_m0[17u].w;
  float _436 = (exp2(log2(max(_405, 0.0f)) * _420) / _403) * _40_m0[17u].w;
  float _437 = (exp2(log2(max(_406, 0.0f)) * _420) / _403) * _40_m0[17u].w;
  float _438 = (exp2(log2(max(_407, 0.0f)) * _420) / _403) * _40_m0[17u].w;
  float _439 = (_390 * _390) / _40_m0[19u].z;
  float _440 = (_391 * _391) / _40_m0[19u].z;
  float _441 = (_392 * _392) / _40_m0[19u].z;
  float _444 = (_385 * 4.0f) / (_385 + 0.25f);
  float _448 = max(_385, 1.0000000031710768509710513471353e-30f);
  float _461 = 1.0f / ((_385 + 1.0f) + _444);
  float _475 = (((_440 + _437) + (sqrt((_440 * _437) / _448) * _444)) * _461) + (_395.y * _40_m0[19u].x);
  float _481 = ((_475 * (_40_m0[17u].x - _40_m0[17u].y)) + (((_461 * ((_439 + _436) + (sqrt((_439 * _436) / _448) * _444))) + (_395.x * _40_m0[19u].x)) * _40_m0[17u].x)) * _40_m0[19u].z;
  float _483 = (_40_m0[19u].z * _40_m0[17u].y) * _475;
  float _485 = (_40_m0[19u].z * _40_m0[17u].z) * ((((_441 + _438) + (sqrt((_441 * _438) / _448) * _444)) * _461) + (_395.z * _40_m0[19u].x));
  float _491;
  float _493;
  float _495;
  if ((_195 & 1u) == 0u) {
    _491 = _481;
    _493 = _483;
    _495 = _485;
  } else {
    uint _501 = asuint(_40_m0[11u].z);
    float _520 = (_23.Sample((SamplerState)ResourceDescriptorHeap[17u], float2((_283 * _40_m0[11u].x) + (float(_501 & 65535u) * 1.52587890625e-05f), (_284 * _40_m0[11u].y) + (float(_501 >> 16u) * 1.52587890625e-05f))).y + (-0.5f)) * _388.w;
    _491 = max(_520 + _481, 0.0f);
    _493 = max(_520 + _483, 0.0f);
    _495 = max(_520 + _485, 0.0f);
  }
  float _531;
  float _533;
  float _535;
  if ((_195 & 32u) == 0u) {
    _531 = _491;
    _533 = _493;
    _535 = _495;
  } else {
    float _545 = (_283 * 2.0f) + (-1.0f);
    float _546 = (_284 * 2.0f) + (-1.0f);
    float _553 = clamp((sqrt((_546 * _546) + (_545 * _545)) * _40_m0[10u].x) + _40_m0[10u].y, 0.0f, 1.0f);
    float _555 = (_553 * _553) * _40_m0[1u].w;
    float _556 = 1.0f - _555;
    float _560 = (_461 * _40_m0[19u].z) * _555;
    _531 = (_556 * _491) + (_560 * _40_m0[1u].x);
    _533 = (_556 * _493) + (_560 * _40_m0[1u].y);
    _535 = (_556 * _495) + (_560 * _40_m0[1u].z);
  }
  float _537 = max(_531, 9.9999999747524270787835121154785e-07f);
  float _538 = max(_533, 9.9999999747524270787835121154785e-07f);
  float _539 = max(_535, 9.9999999747524270787835121154785e-07f);
  float _580;
  float _583;
  float _586;
  if ((_195 & 16u) == 0u) {
    _580 = _537;
    _583 = _538;
    _586 = _539;
  } else {
    float frontier_phi_11_12_ladder;
    float frontier_phi_11_12_ladder_1;
    float frontier_phi_11_12_ladder_2;
    if (asuint(_40_m0[12u]).w == 0u) {
#if 1
      ApplyTonemapGamma2LUTAndInverseTonemap(
          (SamplerState)ResourceDescriptorHeap[2u],
          _29,
          _537, _538, _539,
          _40_m0[2u].w,
          _40_m0[2u].x, _40_m0[2u].y, _40_m0[2u].z,
          _40_m0[3u].x, _40_m0[3u].y, _40_m0[3u].z, _40_m0[3u].w,
          _40_m0[10u].z, _40_m0[10u].w,
          frontier_phi_11_12_ladder,
          frontier_phi_11_12_ladder_1,
          frontier_phi_11_12_ladder_2);
#else
      float _683 = (-0.0f) - _40_m0[2u].w;
      float4 _716 = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float3((clamp(sqrt(max((_537 < _40_m0[3u].z) ? ((_537 * _40_m0[2u].y) + _40_m0[2u].z) : ((_683 / (_537 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(sqrt(max((_538 < _40_m0[3u].z) ? ((_538 * _40_m0[2u].y) + _40_m0[2u].z) : ((_683 / (_538 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(sqrt(max((_539 < _40_m0[3u].z) ? ((_539 * _40_m0[2u].y) + _40_m0[2u].z) : ((_683 / (_539 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w), 0.0f);
      float _718 = _716.x;
      float _719 = _716.y;
      float _720 = _716.z;
      float _724 = min(_718 * _718, _40_m0[2u].x);
      float _725 = min(_719 * _719, _40_m0[2u].x);
      float _726 = min(_720 * _720, _40_m0[2u].x);
      frontier_phi_11_12_ladder = (_726 < _40_m0[3u].w) ? ((_726 - _40_m0[2u].z) / _40_m0[2u].y) : ((_683 / (_726 - _40_m0[3u].y)) - _40_m0[3u].x);
      frontier_phi_11_12_ladder_1 = (_725 < _40_m0[3u].w) ? ((_725 - _40_m0[2u].z) / _40_m0[2u].y) : ((_683 / (_725 - _40_m0[3u].y)) - _40_m0[3u].x);
      frontier_phi_11_12_ladder_2 = (_724 < _40_m0[3u].w) ? ((_724 - _40_m0[2u].z) / _40_m0[2u].y) : ((_683 / (_724 - _40_m0[3u].y)) - _40_m0[3u].x);
#endif
    } else {
      float _759 = exp2(log2(abs(_537 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _760 = exp2(log2(abs(_538 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _761 = exp2(log2(abs(_539 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float4 _803 = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float3((clamp(exp2(log2(abs(((_759 * 18.8515625f) + 0.8359375f) / ((_759 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(exp2(log2(abs(((_760 * 18.8515625f) + 0.8359375f) / ((_760 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(exp2(log2(abs(((_761 * 18.8515625f) + 0.8359375f) / ((_761 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w), 0.0f);
      float _818 = exp2(log2(abs(_803.x)) * 0.0126833133399486541748046875f);
      float _819 = exp2(log2(abs(_803.y)) * 0.0126833133399486541748046875f);
      float _820 = exp2(log2(abs(_803.z)) * 0.0126833133399486541748046875f);
      frontier_phi_11_12_ladder = exp2(log2(abs((_820 + (-0.8359375f)) / (18.8515625f - (_820 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_11_12_ladder_1 = exp2(log2(abs((_819 + (-0.8359375f)) / (18.8515625f - (_819 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_11_12_ladder_2 = exp2(log2(abs((_818 + (-0.8359375f)) / (18.8515625f - (_818 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
    }
    _580 = frontier_phi_11_12_ladder_2;
    _583 = frontier_phi_11_12_ladder_1;
    _586 = frontier_phi_11_12_ladder;
  }
  float _649;
  float _651;
  float _653;
  if ((_195 & 2u) == 0u) {
    _649 = _580;
    _651 = _583;
    _653 = _586;
  } else {
#if 1
    ApplyUserGradingAndToneMapAndScale(
        _580, _583, _586,
        _40_m0[2u].y, _40_m0[2u].z,
        _40_m0[3u].z,
        _40_m0[4u].x, _40_m0[4u].y, _40_m0[4u].z,
        _649, _651, _653);
#else
    float _663 = (-0.0f) - _40_m0[4u].x;
    _649 = (_580 < _40_m0[3u].z) ? ((_580 * _40_m0[2u].y) + _40_m0[2u].z) : ((_663 / (_580 + _40_m0[4u].y)) + _40_m0[4u].z);
    _651 = (_583 < _40_m0[3u].z) ? ((_583 * _40_m0[2u].y) + _40_m0[2u].z) : ((_663 / (_583 + _40_m0[4u].y)) + _40_m0[4u].z);
    _653 = (_586 < _40_m0[3u].z) ? ((_586 * _40_m0[2u].y) + _40_m0[2u].z) : ((_663 / (_586 + _40_m0[4u].y)) + _40_m0[4u].z);
#endif
  }
  uint _655 = uint(int(_40_m0[18u].w));
  float _948;
  float _950;
  float _952;
  if (_655 == 1u) {
    float _859 = exp2(log2(abs(_649)) * _40_m0[18u].x);
    float _860 = exp2(log2(abs(_651)) * _40_m0[18u].x);
    float _861 = exp2(log2(abs(_653)) * _40_m0[18u].x);
    float _949;
    if (_859 < 0.00310000008903443813323974609375f) {
      _949 = _859 * 12.9200000762939453125f;
    } else {
      _949 = (exp2(log2(abs(_859)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _951;
    if (_860 < 0.00310000008903443813323974609375f) {
      _951 = _860 * 12.9200000762939453125f;
    } else {
      _951 = (exp2(log2(abs(_860)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_27_34_ladder;
    float frontier_phi_27_34_ladder_1;
    float frontier_phi_27_34_ladder_2;
    if (_861 < 0.00310000008903443813323974609375f) {
      frontier_phi_27_34_ladder = _949;
      frontier_phi_27_34_ladder_1 = _861 * 12.9200000762939453125f;
      frontier_phi_27_34_ladder_2 = _951;
    } else {
      frontier_phi_27_34_ladder = _949;
      frontier_phi_27_34_ladder_1 = (exp2(log2(abs(_861)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_27_34_ladder_2 = _951;
    }
    _948 = frontier_phi_27_34_ladder;
    _950 = frontier_phi_27_34_ladder_2;
    _952 = frontier_phi_27_34_ladder_1;
  } else {
    float frontier_phi_27_22_ladder;
    float frontier_phi_27_22_ladder_1;
    float frontier_phi_27_22_ladder_2;
    if (_655 == 2u) {
#if 1
      float pq_r, pq_g, pq_b;
      PQFromBT709(
          _649, _651, _653,   // BT709 in (r,g,b)
          _40_m0[18u].x,      // cbuffer_PQ_M1
          _40_m0[18u].y,      // cbuffer_diffuse_white
          pq_r, pq_g, pq_b);  // PQ out (r,g,b)

      frontier_phi_27_22_ladder = pq_r;
      frontier_phi_27_22_ladder_1 = pq_b;  // keep existing swapped local mapping
      frontier_phi_27_22_ladder_2 = pq_g;
#else
      float _918 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _653, mad(0.3292830288410186767578125f, _651, _649 * 0.627403914928436279296875f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      float _919 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _653, mad(0.9195404052734375f, _651, _649 * 0.069097287952899932861328125f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      float _920 = exp2(log2(abs(mad(0.895595252513885498046875f, _653, mad(0.08801330626010894775390625f, _651, _649 * 0.01639143936336040496826171875f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      frontier_phi_27_22_ladder = exp2(log2(abs(((_918 * 18.8515625f) + 0.8359375f) / ((_918 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_27_22_ladder_1 = exp2(log2(abs(((_920 * 18.8515625f) + 0.8359375f) / ((_920 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_27_22_ladder_2 = exp2(log2(abs(((_919 * 18.8515625f) + 0.8359375f) / ((_919 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_27_22_ladder = _649;
      frontier_phi_27_22_ladder_1 = _653;
      frontier_phi_27_22_ladder_2 = _651;
    }
    _948 = frontier_phi_27_22_ladder;
    _950 = frontier_phi_27_22_ladder_2;
    _952 = frontier_phi_27_22_ladder_1;
  }
  float _964 = max(((_948 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  float _965 = max(((_950 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  float _966 = max(((_952 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  SV_Target.x = _964;
  SV_Target.y = _965;
  SV_Target.z = _966;
  SV_Target.w = 1.0f;
  SV_Target_1 = dot(float3(_964, _965, _966), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
