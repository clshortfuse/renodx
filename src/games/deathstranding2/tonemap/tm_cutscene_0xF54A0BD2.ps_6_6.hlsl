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
  uint4 _72 = asuint(_35_m0[0u]);
  uint _73 = _72.z;
  uint _74 = _72.w;
  uint4 _142 = asuint(_40_m0[13u]);
  uint _143 = _142.x;
  uint _144 = _142.y;
  uint _145 = _142.z;
  uint _146 = _142.w;
  uint4 _181 = asuint(_40_m0[19u]);
  uint _182 = _181.w;
  uint4 _186 = asuint(_40_m0[21u]);
  float _59[3];
  float _60[3];
  float _208 = ((_40_m0[0u].x * TEXCOORD.x) + _40_m0[0u].z) + (-0.5f);
  float _210 = ((_40_m0[0u].y * TEXCOORD.y) + _40_m0[0u].w) + (-0.5f);
  float _219 = (((_40_m0[6u].z * _208) + 0.5f) * 2.0f) + (-1.0f);
  float _221 = (((_40_m0[6u].z * _210) + 0.5f) * 2.0f) + (-1.0f);
  float _222 = _219 * _40_m0[8u].x;
  float _223 = _221 * _40_m0[8u].y;
  float _224 = dot(float2(_222, _223), float2(_222, _223));
  float _227 = _224 * _224;
  float _228 = _40_m0[6u].x * 2.0f;
  float _229 = _40_m0[6u].y * 4.0f;
  float _236 = _40_m0[6u].x * 3.0f;
  float _238 = _40_m0[6u].y * 5.0f;
  float _252 = (dot(1.0f.xx, float2(_228, _229)) + 1.0f) / (dot(1.0f.xx, float2(_236, _238)) + 1.0f);
  float _254 = (dot(float2(_224, _227), float2(_228, _229)) + 1.0f) / (_252 * (dot(float2(_224, _227), float2(_236, _238)) + 1.0f));
  bool _256 = _40_m0[6u].w != 0.0f;
  float _261 = log2(abs(_256 ? _219 : _221));
  float _268 = _40_m0[7u].x * 0.5f;
  float _272 = ((((1.0f - _254) * _268) * (exp2(_261 * _40_m0[7u].z) + exp2(_261 * _40_m0[7u].y))) + _254) * 0.5f;
  float _275 = (_272 * _219) + 0.5f;
  float _276 = (_272 * _221) + 0.5f;
  _59[0u] = _275;
  _60[0u] = _276;
  float _281 = _40_m0[9u].x * _40_m0[6u].z;
  float _288 = (((_281 * _208) + 0.5f) * 2.0f) + (-1.0f);
  float _289 = (((_281 * _210) + 0.5f) * 2.0f) + (-1.0f);
  float _290 = _288 * _40_m0[8u].x;
  float _291 = _289 * _40_m0[8u].y;
  float _292 = dot(float2(_290, _291), float2(_290, _291));
  float _295 = _292 * _292;
  float _305 = (dot(float2(_292, _295), float2(_228, _229)) + 1.0f) / ((dot(float2(_292, _295), float2(_236, _238)) + 1.0f) * _252);
  float _308 = log2(abs(_256 ? _288 : _289));
  float _318 = ((((1.0f - _305) * _268) * (exp2(_308 * _40_m0[7u].z) + exp2(_308 * _40_m0[7u].y))) + _305) * 0.5f;
  _59[1u] = (_318 * _288) + 0.5f;
  _60[1u] = (_318 * _289) + 0.5f;
  float _323 = _40_m0[9u].y * _40_m0[6u].z;
  float _330 = (((_323 * _208) + 0.5f) * 2.0f) + (-1.0f);
  float _331 = (((_323 * _210) + 0.5f) * 2.0f) + (-1.0f);
  float _332 = _330 * _40_m0[8u].x;
  float _333 = _331 * _40_m0[8u].y;
  float _334 = dot(float2(_332, _333), float2(_332, _333));
  float _337 = _334 * _334;
  float _347 = (dot(float2(_334, _337), float2(_228, _229)) + 1.0f) / ((dot(float2(_334, _337), float2(_236, _238)) + 1.0f) * _252);
  float _350 = log2(abs(_256 ? _330 : _331));
  float _360 = ((((1.0f - _347) * _268) * (exp2(_350 * _40_m0[7u].z) + exp2(_350 * _40_m0[7u].y))) + _347) * 0.5f;
  _59[2u] = (_360 * _330) + 0.5f;
  _60[2u] = (_360 * _331) + 0.5f;
  uint _367_dummy_parameter;
  uint2 _367 = spvTextureSize(_18, 0u, _367_dummy_parameter);
  float _369 = float(int(_367.x));
  float _371 = float(int(_367.y));
  float _372 = 1.0f / _40_m0[0u].x;
  float _373 = 1.0f / _40_m0[0u].y;
  uint _379;
  float _61[3];
  float _62[3];
  float _63[3];
  float _374 = _276;
  float _376 = _275;
  uint _378 = 0u;
  float _381;
  float _383;
  float _384;
  float _385;
  float _389;
  float _393;
  float _405;
  float _406;
  float _407;
  uint _432;
  bool _433;
  for (;;) {
    float _380 = _376 * _372;
    _381 = _380 * _40_m0[21u].z;
    float _382 = _374 * _373;
    _383 = _382 * _40_m0[21u].w;
    _384 = _380 * _40_m0[22u].x;
    _385 = _382 * _40_m0[22u].y;
    _389 = max(min(_384, _40_m0[15u].x), min(max(_384, _40_m0[15u].x), _40_m0[15u].z));
    _393 = max(min(_385, _40_m0[15u].y), min(max(_385, _40_m0[15u].y), _40_m0[15u].w));
    float4 _403 = _18.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_381, _383));
    _405 = _403.x;
    _406 = _403.y;
    _407 = _403.z;
    float _410 = float(int(_143));
    float _411 = float(int(_144));
    float _417 = float(int(uint(int(uint(clamp(_384, 0.0f, 1.0f) * _369)) >> int(_73 & 31u))));
    float _418 = float(int(uint(int(uint(clamp(_385, 0.0f, 1.0f) * _371)) >> int(_74 & 31u))));
    _432 = _12.Load(int3(uint2(uint(int(max(min(_417, _410), min(max(_417, _410), float(int(_145)))))), uint(int(max(min(_418, _411), min(max(_418, _411), float(int(_146))))))), 0u)).x;
    _433 = _432 == 0u;
    float _434;
    float _439;
    float _444;
    if (_433) {
      _434 = _405;
      _439 = _406;
      _444 = _407;
    } else {
      float frontier_phi_2_3_ladder;
      float frontier_phi_2_3_ladder_1;
      float frontier_phi_2_3_ladder_2;
      if ((_432 & 536870912u) == 0u) {
        float frontier_phi_2_3_ladder_6_ladder;
        float frontier_phi_2_3_ladder_6_ladder_1;
        float frontier_phi_2_3_ladder_6_ladder_2;
        if ((_432 & 268435456u) == 0u) {
          float4 _654 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_384, _385));
          float _656 = _654.x;
          float4 _659 = _17.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_389, _393));
          float _661 = _659.x;
          float _701;
          if ((_182 & 4u) == 0u) {
            _701 = _661;
          } else {
            _701 = max(clamp(_656 * (-4.0f), 0.0f, 1.0f), _661);
          }
          float _707 = clamp((_656 * 4.80000019073486328125f) + (-0.20000000298023223876953125f), 0.0f, 1.0f);
          float _708 = _385 - _35_m0[0u].y;
          float _712 = max(min(_384, _40_m0[14u].x), min(max(_384, _40_m0[14u].x), _40_m0[14u].z));
          float4 _718 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_712, max(min(_708, _40_m0[14u].y), min(max(_708, _40_m0[14u].y), _40_m0[14u].w))));
          float _722 = _384 - _35_m0[0u].x;
          float _730 = max(min(_385, _40_m0[14u].y), min(max(_385, _40_m0[14u].y), _40_m0[14u].w));
          float4 _731 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(max(min(_722, _40_m0[14u].x), min(max(_722, _40_m0[14u].x), _40_m0[14u].z)), _730));
          float _735 = _384 + _35_m0[0u].x;
          float4 _740 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(max(min(_735, _40_m0[14u].x), min(max(_735, _40_m0[14u].x), _40_m0[14u].z)), _730));
          float _744 = _385 + _35_m0[0u].y;
          float4 _749 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_712, max(min(_744, _40_m0[14u].y), min(max(_744, _40_m0[14u].y), _40_m0[14u].w))));
          float _752 = min(min(min(min(_656, _718.x), _731.x), _740.x), _749.x);
          float _971;
          if (_752 < 0.0f) {
            _971 = (-0.0f) - _752;
          } else {
            _971 = max(_752, _656);
          }
          float _972 = _971 * 24.0f;
          float _1181;
          float _1182;
          float _1183;
          if ((_707 < 1.0f) && ((_701 < 1.0f) && (((_182 & 32768u) != 0u) && (_972 > 0.25f)))) {
            float _1000 = min(_972 + (-0.25f), 4.0f);
            float _1001 = _1000 * _35_m0[0u].x;
            float _1002 = _1000 * _35_m0[0u].y;
            float _1010 = _1002 + _383;
            float _1014 = max(min(_381, _40_m0[14u].x), min(max(_381, _40_m0[14u].x), _40_m0[14u].z));
            float4 _1020 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1014, max(min(_1010, _40_m0[14u].y), min(max(_1010, _40_m0[14u].y), _40_m0[14u].w))), 0.0f);
            float _1034 = _1001 * 0.707106769084930419921875f;
            float _1036 = _1002 * 0.707106769084930419921875f;
            float _1037 = _1034 + _381;
            float _1038 = _1036 + _383;
            float _1042 = max(min(_1037, _40_m0[14u].x), min(max(_1037, _40_m0[14u].x), _40_m0[14u].z));
            float _1046 = max(min(_1038, _40_m0[14u].y), min(max(_1038, _40_m0[14u].y), _40_m0[14u].w));
            float4 _1047 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1042, _1046), 0.0f);
            float _1061 = _1001 + _381;
            float _1069 = max(min(_383, _40_m0[14u].y), min(max(_383, _40_m0[14u].y), _40_m0[14u].w));
            float4 _1070 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(max(min(_1061, _40_m0[14u].x), min(max(_1061, _40_m0[14u].x), _40_m0[14u].z)), _1069), 0.0f);
            float _1084 = _383 - _1036;
            float _1088 = max(min(_1084, _40_m0[14u].y), min(max(_1084, _40_m0[14u].y), _40_m0[14u].w));
            float4 _1089 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1042, _1088), 0.0f);
            float _1103 = _383 - _1002;
            float4 _1108 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1014, max(min(_1103, _40_m0[14u].y), min(max(_1103, _40_m0[14u].y), _40_m0[14u].w))), 0.0f);
            float _1122 = _381 - _1034;
            float _1126 = max(min(_1122, _40_m0[14u].x), min(max(_1122, _40_m0[14u].x), _40_m0[14u].z));
            float4 _1127 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1126, _1088), 0.0f);
            float _1141 = _381 - _1001;
            float4 _1146 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(max(min(_1141, _40_m0[14u].x), min(max(_1141, _40_m0[14u].x), _40_m0[14u].z)), _1069), 0.0f);
            float4 _1160 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1126, _1046), 0.0f);
            _1181 = exp2(((((((((log2(max(_1020.x, 1.0000000133514319600180897396058e-10f)) + log2(max(_405, 1.0000000133514319600180897396058e-10f))) + log2(max(_1047.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1070.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1089.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1108.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1127.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1146.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1160.x, 1.0000000133514319600180897396058e-10f))) * 0.111111111938953399658203125f);
            _1182 = exp2(((((((((log2(max(_1020.y, 1.0000000133514319600180897396058e-10f)) + log2(max(_406, 1.0000000133514319600180897396058e-10f))) + log2(max(_1047.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1070.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1089.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1108.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1127.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1146.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1160.y, 1.0000000133514319600180897396058e-10f))) * 0.111111111938953399658203125f);
            _1183 = exp2(((((((((log2(max(_1020.z, 1.0000000133514319600180897396058e-10f)) + log2(max(_407, 1.0000000133514319600180897396058e-10f))) + log2(max(_1047.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1070.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1089.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1108.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1127.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1146.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1160.z, 1.0000000133514319600180897396058e-10f))) * 0.111111111938953399658203125f);
          } else {
            _1181 = _405;
            _1182 = _406;
            _1183 = _407;
          }
          float4 _1186 = _20.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_389, _393));
          float _438 = ((_1186.x - _1181) * _707) + _1181;
          float _443 = ((_1186.y - _1182) * _707) + _1182;
          float _448 = ((_1186.z - _1183) * _707) + _1183;
          float4 _1199 = _19.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_389, _393));
          float frontier_phi_2_3_ladder_6_ladder_28_ladder;
          float frontier_phi_2_3_ladder_6_ladder_28_ladder_1;
          float frontier_phi_2_3_ladder_6_ladder_28_ladder_2;
          if ((_1199.z > 0.0f) || ((_1199.x > 0.0f) || (_1199.y > 0.0f))) {
            float4 _1307 = _19.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_389, _393));
            frontier_phi_2_3_ladder_6_ladder_28_ladder = ((_1307.z - _448) * _701) + _448;
            frontier_phi_2_3_ladder_6_ladder_28_ladder_1 = ((_1307.y - _443) * _701) + _443;
            frontier_phi_2_3_ladder_6_ladder_28_ladder_2 = ((_1307.x - _438) * _701) + _438;
          } else {
            frontier_phi_2_3_ladder_6_ladder_28_ladder = _448;
            frontier_phi_2_3_ladder_6_ladder_28_ladder_1 = _443;
            frontier_phi_2_3_ladder_6_ladder_28_ladder_2 = _438;
          }
          frontier_phi_2_3_ladder_6_ladder = frontier_phi_2_3_ladder_6_ladder_28_ladder;
          frontier_phi_2_3_ladder_6_ladder_1 = frontier_phi_2_3_ladder_6_ladder_28_ladder_1;
          frontier_phi_2_3_ladder_6_ladder_2 = frontier_phi_2_3_ladder_6_ladder_28_ladder_2;
        } else {
          float4 _666 = _20.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_389, _393));
          frontier_phi_2_3_ladder_6_ladder = _666.z;
          frontier_phi_2_3_ladder_6_ladder_1 = _666.y;
          frontier_phi_2_3_ladder_6_ladder_2 = _666.x;
        }
        frontier_phi_2_3_ladder = frontier_phi_2_3_ladder_6_ladder;
        frontier_phi_2_3_ladder_1 = frontier_phi_2_3_ladder_6_ladder_1;
        frontier_phi_2_3_ladder_2 = frontier_phi_2_3_ladder_6_ladder_2;
      } else {
        float4 _615 = _19.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_389, _393));
        frontier_phi_2_3_ladder = _615.z;
        frontier_phi_2_3_ladder_1 = _615.y;
        frontier_phi_2_3_ladder_2 = _615.x;
      }
      _434 = frontier_phi_2_3_ladder_2;
      _439 = frontier_phi_2_3_ladder_1;
      _444 = frontier_phi_2_3_ladder;
    }
    _61[_378] = _434;
    _62[_378] = _439;
    _63[_378] = _444;
    _379 = _378 + 1u;
    if (_379 == 3u) {
      break;
    }
    _374 = _60[_379];
    _376 = _59[_379];
    _378 = _379;
    continue;
  }
  uint _476 = _186.y;
  float _485 = (_275 - _40_m0[0u].z) / _40_m0[0u].x;
  float _486 = (_276 - _40_m0[0u].w) / _40_m0[0u].y;
  float4 _504 = _26.Load(2u);
  float _505 = _504.x;
  float4 _508 = _21.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(max(min(_485, _40_m0[16u].x), min(max(_485, _40_m0[16u].x), _40_m0[16u].z)), max(min(_486, _40_m0[16u].y), min(max(_486, _40_m0[16u].y), _40_m0[16u].w))));
  float _510 = _508.x;
  float _511 = _508.y;
  float _512 = _508.z;
  float4 _515 = _22.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(max(min(_485, _40_m0[15u].x), min(max(_485, _40_m0[15u].x), _40_m0[15u].z)), max(min(_486, _40_m0[15u].y), min(max(_486, _40_m0[15u].y), _40_m0[15u].w))));
  float _523 = _40_m0[19u].y * 0.25f;
  float _525 = _61[1u] * _523;
  float _526 = _62[2u] * _523;
  float _527 = _63[0u] * _523;
  float _540 = (clamp(dot(float3(_525, _526, _527), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) + 9.9999999747524270787835121154785e-07f, 0.0f, 1.0f) * (1.0f - _40_m0[17u].w)) + _40_m0[17u].w;
  float _556 = (exp2(log2(max(_525, 0.0f)) * _540) / _523) * _40_m0[17u].w;
  float _557 = (exp2(log2(max(_526, 0.0f)) * _540) / _523) * _40_m0[17u].w;
  float _558 = (exp2(log2(max(_527, 0.0f)) * _540) / _523) * _40_m0[17u].w;
  float _559 = (_510 * _510) / _40_m0[19u].z;
  float _560 = (_511 * _511) / _40_m0[19u].z;
  float _561 = (_512 * _512) / _40_m0[19u].z;
  float _564 = (_505 * 4.0f) / (_505 + 0.25f);
  float _568 = max(_505, 1.0000000031710768509710513471353e-30f);
  float _581 = 1.0f / ((_505 + 1.0f) + _564);
  float _595 = (((_560 + _557) + (sqrt((_560 * _557) / _568) * _564)) * _581) + (_515.y * _40_m0[19u].x);
  float _601 = ((_595 * (_40_m0[17u].x - _40_m0[17u].y)) + (((_581 * ((_559 + _556) + (sqrt((_559 * _556) / _568) * _564))) + (_515.x * _40_m0[19u].x)) * _40_m0[17u].x)) * _40_m0[19u].z;
  float _603 = (_40_m0[19u].z * _40_m0[17u].y) * _595;
  float _605 = (_40_m0[19u].z * _40_m0[17u].z) * ((((_561 + _558) + (sqrt((_561 * _558) / _568) * _564)) * _581) + (_515.z * _40_m0[19u].x));
  float _617;
  float _619;
  float _621;
  if ((_476 & 1u) == 0u) {
    _617 = _601;
    _619 = _603;
    _621 = _605;
  } else {
    uint _629 = asuint(_40_m0[11u].z);
    float _648 = (_23.Sample((SamplerState)ResourceDescriptorHeap[17u], float2((_275 * _40_m0[11u].x) + (float(_629 & 65535u) * 1.52587890625e-05f), (_276 * _40_m0[11u].y) + (float(_629 >> 16u) * 1.52587890625e-05f))).y + (-0.5f)) * _508.w;
    _617 = max(_648 + _601, 0.0f);
    _619 = max(_648 + _603, 0.0f);
    _621 = max(_648 + _605, 0.0f);
  }
  float _668;
  float _670;
  float _672;
  if ((_476 & 32u) == 0u) {
    _668 = _617;
    _670 = _619;
    _672 = _621;
  } else {
    float _682 = (_275 * 2.0f) + (-1.0f);
    float _683 = (_276 * 2.0f) + (-1.0f);
    float _690 = clamp((sqrt((_683 * _683) + (_682 * _682)) * _40_m0[10u].x) + _40_m0[10u].y, 0.0f, 1.0f);
    float _692 = (_690 * _690) * _40_m0[1u].w;
    float _693 = 1.0f - _692;
    float _697 = (_581 * _40_m0[19u].z) * _692;
    _668 = (_693 * _617) + (_697 * _40_m0[1u].x);
    _670 = (_693 * _619) + (_697 * _40_m0[1u].y);
    _672 = (_693 * _621) + (_697 * _40_m0[1u].z);
  }
  float _674 = max(_668, 9.9999999747524270787835121154785e-07f);
  float _675 = max(_670, 9.9999999747524270787835121154785e-07f);
  float _676 = max(_672, 9.9999999747524270787835121154785e-07f);
  float _757;
  float _760;
  float _763;
  if ((_476 & 16u) == 0u) {
    _757 = _674;
    _760 = _675;
    _763 = _676;
  } else {
    float frontier_phi_16_17_ladder;
    float frontier_phi_16_17_ladder_1;
    float frontier_phi_16_17_ladder_2;
    if (asuint(_40_m0[12u]).w == 0u) {
#if 1
      ApplyTonemapGamma2LUTAndInverseTonemap(
          _29,
          _674, _675, _676,
          _40_m0[2u].w,
          _40_m0[2u].x, _40_m0[2u].y, _40_m0[2u].z,
          _40_m0[3u].x, _40_m0[3u].y, _40_m0[3u].z, _40_m0[3u].w,
          _40_m0[10u].z, _40_m0[10u].w,
          frontier_phi_16_17_ladder,
          frontier_phi_16_17_ladder_1,
          frontier_phi_16_17_ladder_2);
#else
      float _806 = (-0.0f) - _40_m0[2u].w;
      float4 _839 = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float3((clamp(sqrt(max((_674 < _40_m0[3u].z) ? ((_674 * _40_m0[2u].y) + _40_m0[2u].z) : ((_806 / (_674 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(sqrt(max((_675 < _40_m0[3u].z) ? ((_675 * _40_m0[2u].y) + _40_m0[2u].z) : ((_806 / (_675 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(sqrt(max((_676 < _40_m0[3u].z) ? ((_676 * _40_m0[2u].y) + _40_m0[2u].z) : ((_806 / (_676 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w), 0.0f);
      float _841 = _839.x;
      float _842 = _839.y;
      float _843 = _839.z;
      float _847 = min(_841 * _841, _40_m0[2u].x);
      float _848 = min(_842 * _842, _40_m0[2u].x);
      float _849 = min(_843 * _843, _40_m0[2u].x);
      frontier_phi_16_17_ladder = (_849 < _40_m0[3u].w) ? ((_849 - _40_m0[2u].z) / _40_m0[2u].y) : ((_806 / (_849 - _40_m0[3u].y)) - _40_m0[3u].x);
      frontier_phi_16_17_ladder_1 = (_848 < _40_m0[3u].w) ? ((_848 - _40_m0[2u].z) / _40_m0[2u].y) : ((_806 / (_848 - _40_m0[3u].y)) - _40_m0[3u].x);
      frontier_phi_16_17_ladder_2 = (_847 < _40_m0[3u].w) ? ((_847 - _40_m0[2u].z) / _40_m0[2u].y) : ((_806 / (_847 - _40_m0[3u].y)) - _40_m0[3u].x);
#endif
    } else {
      float _882 = exp2(log2(abs(_674 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _883 = exp2(log2(abs(_675 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _884 = exp2(log2(abs(_676 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float4 _926 = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float3((clamp(exp2(log2(abs(((_882 * 18.8515625f) + 0.8359375f) / ((_882 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(exp2(log2(abs(((_883 * 18.8515625f) + 0.8359375f) / ((_883 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(exp2(log2(abs(((_884 * 18.8515625f) + 0.8359375f) / ((_884 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w), 0.0f);
      float _941 = exp2(log2(abs(_926.x)) * 0.0126833133399486541748046875f);
      float _942 = exp2(log2(abs(_926.y)) * 0.0126833133399486541748046875f);
      float _943 = exp2(log2(abs(_926.z)) * 0.0126833133399486541748046875f);
      frontier_phi_16_17_ladder = exp2(log2(abs((_943 + (-0.8359375f)) / (18.8515625f - (_943 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_16_17_ladder_1 = exp2(log2(abs((_942 + (-0.8359375f)) / (18.8515625f - (_942 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_16_17_ladder_2 = exp2(log2(abs((_941 + (-0.8359375f)) / (18.8515625f - (_941 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
    }
    _757 = frontier_phi_16_17_ladder_2;
    _760 = frontier_phi_16_17_ladder_1;
    _763 = frontier_phi_16_17_ladder;
  }
  float _773;
  float _775;
  float _777;
  if ((_476 & 2u) == 0u) {
    _773 = _757;
    _775 = _760;
    _777 = _763;
  } else {
#if 1
    ApplyUserGradingAndToneMapAndScale(
        _757, _760, _763,
        _40_m0[2u].y, _40_m0[2u].z,
        _40_m0[3u].z,
        _40_m0[4u].x, _40_m0[4u].y, _40_m0[4u].z,
        _773, _775, _777);
#else
    float _787 = (-0.0f) - _40_m0[4u].x;
    _773 = (_757 < _40_m0[3u].z) ? ((_757 * _40_m0[2u].y) + _40_m0[2u].z) : ((_787 / (_757 + _40_m0[4u].y)) + _40_m0[4u].z);
    _775 = (_760 < _40_m0[3u].z) ? ((_760 * _40_m0[2u].y) + _40_m0[2u].z) : ((_787 / (_760 + _40_m0[4u].y)) + _40_m0[4u].z);
    _777 = (_763 < _40_m0[3u].z) ? ((_763 * _40_m0[2u].y) + _40_m0[2u].z) : ((_787 / (_763 + _40_m0[4u].y)) + _40_m0[4u].z);
#endif
  }
  uint _779 = uint(int(_40_m0[18u].w));
  float _1280;
  float _1282;
  float _1284;
  if (_779 == 1u) {
    float _992 = exp2(log2(abs(_773)) * _40_m0[18u].x);
    float _993 = exp2(log2(abs(_775)) * _40_m0[18u].x);
    float _994 = exp2(log2(abs(_777)) * _40_m0[18u].x);
    float _1281;
    if (_992 < 0.00310000008903443813323974609375f) {
      _1281 = _992 * 12.9200000762939453125f;
    } else {
      _1281 = (exp2(log2(abs(_992)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _1283;
    if (_993 < 0.00310000008903443813323974609375f) {
      _1283 = _993 * 12.9200000762939453125f;
    } else {
      _1283 = (exp2(log2(abs(_993)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_32_37_ladder;
    float frontier_phi_32_37_ladder_1;
    float frontier_phi_32_37_ladder_2;
    if (_994 < 0.00310000008903443813323974609375f) {
      frontier_phi_32_37_ladder = _1281;
      frontier_phi_32_37_ladder_1 = _994 * 12.9200000762939453125f;
      frontier_phi_32_37_ladder_2 = _1283;
    } else {
      frontier_phi_32_37_ladder = _1281;
      frontier_phi_32_37_ladder_1 = (exp2(log2(abs(_994)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_32_37_ladder_2 = _1283;
    }
    _1280 = frontier_phi_32_37_ladder;
    _1282 = frontier_phi_32_37_ladder_2;
    _1284 = frontier_phi_32_37_ladder_1;
  } else {
    float frontier_phi_32_26_ladder;
    float frontier_phi_32_26_ladder_1;
    float frontier_phi_32_26_ladder_2;
    if (_779 == 2u) {
      float _1250 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _777, mad(0.3292830288410186767578125f, _775, _773 * 0.627403914928436279296875f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      float _1251 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _777, mad(0.9195404052734375f, _775, _773 * 0.069097287952899932861328125f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      float _1252 = exp2(log2(abs(mad(0.895595252513885498046875f, _777, mad(0.08801330626010894775390625f, _775, _773 * 0.01639143936336040496826171875f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      frontier_phi_32_26_ladder = exp2(log2(abs(((_1250 * 18.8515625f) + 0.8359375f) / ((_1250 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_32_26_ladder_1 = exp2(log2(abs(((_1252 * 18.8515625f) + 0.8359375f) / ((_1252 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_32_26_ladder_2 = exp2(log2(abs(((_1251 * 18.8515625f) + 0.8359375f) / ((_1251 * 18.6875f) + 1.0f))) * 78.84375f);
    } else {
      frontier_phi_32_26_ladder = _773;
      frontier_phi_32_26_ladder_1 = _777;
      frontier_phi_32_26_ladder_2 = _775;
    }
    _1280 = frontier_phi_32_26_ladder;
    _1282 = frontier_phi_32_26_ladder_2;
    _1284 = frontier_phi_32_26_ladder_1;
  }
  float _1296 = max(((_1280 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  float _1297 = max(((_1282 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  float _1298 = max(((_1284 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  SV_Target.x = _1296;
  SV_Target.y = _1297;
  SV_Target.z = _1298;
  SV_Target.w = 1.0f;

  SV_Target_1 = dot(float3(_1296, _1297, _1298), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
