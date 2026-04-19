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

static float4 gl_FragCoord;
static float2 TEXCOORD;
static float4 SV_Target;
static float SV_Target_1;

struct SPIRV_Cross_Input {
  noperspective float4 gl_FragCoord : SV_Position;
  linear float2 TEXCOORD : TEXCOORD0;
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
  float _59[5];
  float _60[5];
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
  float _321 = (_318 * _288) + 0.5f;
  float _322 = (_318 * _289) + 0.5f;
  _59[1u] = _321;
  _60[1u] = _322;
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
  float _363 = (_360 * _330) + 0.5f;
  float _364 = (_360 * _331) + 0.5f;
  _59[2u] = _363;
  _60[2u] = _364;
  _59[3u] = (_363 + _321) * 0.5f;
  _60[3u] = (_364 + _322) * 0.5f;
  _59[4u] = (_321 + _275) * 0.5f;
  _60[4u] = (_322 + _276) * 0.5f;
  uint _379_dummy_parameter;
  uint2 _379 = spvTextureSize(_18, 0u, _379_dummy_parameter);
  float _381 = float(int(_379.x));
  float _383 = float(int(_379.y));
  float _384 = 1.0f / _40_m0[0u].x;
  float _385 = 1.0f / _40_m0[0u].y;
  uint _391;
  float _61[5];
  float _62[5];
  float _63[5];
  float _386 = _276;
  float _388 = _275;
  uint _390 = 0u;
  float _393;
  float _395;
  float _396;
  float _397;
  float _401;
  float _405;
  float _417;
  float _418;
  float _419;
  uint _444;
  bool _445;
  for (;;) {
    float _392 = _388 * _384;
    _393 = _392 * _40_m0[21u].z;
    float _394 = _386 * _385;
    _395 = _394 * _40_m0[21u].w;
    _396 = _392 * _40_m0[22u].x;
    _397 = _394 * _40_m0[22u].y;
    _401 = max(min(_396, _40_m0[15u].x), min(max(_396, _40_m0[15u].x), _40_m0[15u].z));
    _405 = max(min(_397, _40_m0[15u].y), min(max(_397, _40_m0[15u].y), _40_m0[15u].w));
    // float4 _415 = _18.Sample(_8[2u], float2(_393, _395));
    float4 _415 = _18.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_393, _395));
    _417 = _415.x;
    _418 = _415.y;
    _419 = _415.z;
    float _422 = float(int(_143));
    float _423 = float(int(_144));
    float _429 = float(int(uint(int(uint(clamp(_396, 0.0f, 1.0f) * _381)) >> int(_73 & 31u))));
    float _430 = float(int(uint(int(uint(clamp(_397, 0.0f, 1.0f) * _383)) >> int(_74 & 31u))));
    _444 = _12.Load(int3(uint2(uint(int(max(min(_429, _422), min(max(_429, _422), float(int(_145)))))), uint(int(max(min(_430, _423), min(max(_430, _423), float(int(_146))))))), 0u)).x;
    _445 = _444 == 0u;
    float _446;
    float _451;
    float _456;
    if (_445) {
      _446 = _417;
      _451 = _418;
      _456 = _419;
    } else {
      float frontier_phi_2_3_ladder;
      float frontier_phi_2_3_ladder_1;
      float frontier_phi_2_3_ladder_2;
      if ((_444 & 536870912u) == 0u) {
        float frontier_phi_2_3_ladder_6_ladder;
        float frontier_phi_2_3_ladder_6_ladder_1;
        float frontier_phi_2_3_ladder_6_ladder_2;
        if ((_444 & 268435456u) == 0u) {
          // float4 _681 = _16.Sample(_8[0u], float2(_396, _397));
          float4 _681 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_396, _397));
          float _683 = _681.x;
          // float4 _686 = _17.Sample(_8[2u], float2(_401, _405));
          float4 _686 = _17.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_401, _405));
          float _688 = _686.x;
          float _728;
          if ((_182 & 4u) == 0u) {
            _728 = _688;
          } else {
            _728 = max(clamp(_683 * (-4.0f), 0.0f, 1.0f), _688);
          }
          float _734 = clamp((_683 * 4.80000019073486328125f) + (-0.20000000298023223876953125f), 0.0f, 1.0f);
          float _735 = _397 - _35_m0[0u].y;
          float _739 = max(min(_396, _40_m0[14u].x), min(max(_396, _40_m0[14u].x), _40_m0[14u].z));
          // float4 _745 = _16.Sample(_8[0u], float2(_739, max(min(_735, _40_m0[14u].y), min(max(_735, _40_m0[14u].y), _40_m0[14u].w))));
          float4 _745 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_739, max(min(_735, _40_m0[14u].y), min(max(_735, _40_m0[14u].y), _40_m0[14u].w))));
          float _749 = _396 - _35_m0[0u].x;
          float _757 = max(min(_397, _40_m0[14u].y), min(max(_397, _40_m0[14u].y), _40_m0[14u].w));
          // float4 _758 = _16.Sample(_8[0u], float2(max(min(_749, _40_m0[14u].x), min(max(_749, _40_m0[14u].x), _40_m0[14u].z)), _757));
          float4 _758 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(max(min(_749, _40_m0[14u].x), min(max(_749, _40_m0[14u].x), _40_m0[14u].z)), _757));
          float _762 = _396 + _35_m0[0u].x;
          // float4 _767 = _16.Sample(_8[0u], float2(max(min(_762, _40_m0[14u].x), min(max(_762, _40_m0[14u].x), _40_m0[14u].z)), _757));
          float4 _767 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(max(min(_762, _40_m0[14u].x), min(max(_762, _40_m0[14u].x), _40_m0[14u].z)), _757));
          float _771 = _397 + _35_m0[0u].y;
          // float4 _776 = _16.Sample(_8[0u], float2(_739, max(min(_771, _40_m0[14u].y), min(max(_771, _40_m0[14u].y), _40_m0[14u].w))));
          float4 _776 = _16.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_739, max(min(_771, _40_m0[14u].y), min(max(_771, _40_m0[14u].y), _40_m0[14u].w))));
          float _779 = min(min(min(min(_683, _745.x), _758.x), _767.x), _776.x);
          float _998;
          if (_779 < 0.0f) {
            _998 = (-0.0f) - _779;
          } else {
            _998 = max(_779, _683);
          }
          float _999 = _998 * 24.0f;
          float _1208;
          float _1209;
          float _1210;
          if ((_734 < 1.0f) && ((_728 < 1.0f) && (((_182 & 32768u) != 0u) && (_999 > 0.25f)))) {
            float _1027 = min(_999 + (-0.25f), 4.0f);
            float _1028 = _1027 * _35_m0[0u].x;
            float _1029 = _1027 * _35_m0[0u].y;
            float _1037 = _1029 + _395;
            float _1041 = max(min(_393, _40_m0[14u].x), min(max(_393, _40_m0[14u].x), _40_m0[14u].z));
            // float4 _1047 = _18.SampleLevel(_8[2u], float2(_1041, max(min(_1037, _40_m0[14u].y), min(max(_1037, _40_m0[14u].y), _40_m0[14u].w))), 0.0f);
            float4 _1047 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1041, max(min(_1037, _40_m0[14u].y), min(max(_1037, _40_m0[14u].y), _40_m0[14u].w))), 0.0f);
            float _1061 = _1028 * 0.707106769084930419921875f;
            float _1063 = _1029 * 0.707106769084930419921875f;
            float _1064 = _1061 + _393;
            float _1065 = _1063 + _395;
            float _1069 = max(min(_1064, _40_m0[14u].x), min(max(_1064, _40_m0[14u].x), _40_m0[14u].z));
            float _1073 = max(min(_1065, _40_m0[14u].y), min(max(_1065, _40_m0[14u].y), _40_m0[14u].w));
            // float4 _1074 = _18.SampleLevel(_8[2u], float2(_1069, _1073), 0.0f);
            float4 _1074 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1069, _1073), 0.0f);
            float _1088 = _1028 + _393;
            float _1096 = max(min(_395, _40_m0[14u].y), min(max(_395, _40_m0[14u].y), _40_m0[14u].w));
            // float4 _1097 = _18.SampleLevel(_8[2u], float2(max(min(_1088, _40_m0[14u].x), min(max(_1088, _40_m0[14u].x), _40_m0[14u].z)), _1096), 0.0f);
            float4 _1097 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(max(min(_1088, _40_m0[14u].x), min(max(_1088, _40_m0[14u].x), _40_m0[14u].z)), _1096), 0.0f);
            float _1111 = _395 - _1063;
            float _1115 = max(min(_1111, _40_m0[14u].y), min(max(_1111, _40_m0[14u].y), _40_m0[14u].w));
            // float4 _1116 = _18.SampleLevel(_8[2u], float2(_1069, _1115), 0.0f);
            float4 _1116 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1069, _1115), 0.0f);
            float _1130 = _395 - _1029;
            // float4 _1135 = _18.SampleLevel(_8[2u], float2(_1041, max(min(_1130, _40_m0[14u].y), min(max(_1130, _40_m0[14u].y), _40_m0[14u].w))), 0.0f);
            float4 _1135 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1041, max(min(_1130, _40_m0[14u].y), min(max(_1130, _40_m0[14u].y), _40_m0[14u].w))), 0.0f);
            float _1149 = _393 - _1061;
            float _1153 = max(min(_1149, _40_m0[14u].x), min(max(_1149, _40_m0[14u].x), _40_m0[14u].z));
            // float4 _1154 = _18.SampleLevel(_8[2u], float2(_1153, _1115), 0.0f);
            float4 _1154 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1153, _1115), 0.0f);
            float _1168 = _393 - _1028;
            // float4 _1173 = _18.SampleLevel(_8[2u], float2(max(min(_1168, _40_m0[14u].x), min(max(_1168, _40_m0[14u].x), _40_m0[14u].z)), _1096), 0.0f);
            float4 _1173 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(max(min(_1168, _40_m0[14u].x), min(max(_1168, _40_m0[14u].x), _40_m0[14u].z)), _1096), 0.0f);
            // float4 _1187 = _18.SampleLevel(_8[2u], float2(_1153, _1073), 0.0f);
            float4 _1187 = _18.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float2(_1153, _1073), 0.0f);
            _1208 = exp2(((((((((log2(max(_1047.x, 1.0000000133514319600180897396058e-10f)) + log2(max(_417, 1.0000000133514319600180897396058e-10f))) + log2(max(_1074.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1097.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1116.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1135.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1154.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1173.x, 1.0000000133514319600180897396058e-10f))) + log2(max(_1187.x, 1.0000000133514319600180897396058e-10f))) * 0.111111111938953399658203125f);
            _1209 = exp2(((((((((log2(max(_1047.y, 1.0000000133514319600180897396058e-10f)) + log2(max(_418, 1.0000000133514319600180897396058e-10f))) + log2(max(_1074.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1097.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1116.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1135.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1154.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1173.y, 1.0000000133514319600180897396058e-10f))) + log2(max(_1187.y, 1.0000000133514319600180897396058e-10f))) * 0.111111111938953399658203125f);
            _1210 = exp2(((((((((log2(max(_1047.z, 1.0000000133514319600180897396058e-10f)) + log2(max(_419, 1.0000000133514319600180897396058e-10f))) + log2(max(_1074.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1097.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1116.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1135.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1154.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1173.z, 1.0000000133514319600180897396058e-10f))) + log2(max(_1187.z, 1.0000000133514319600180897396058e-10f))) * 0.111111111938953399658203125f);
          } else {
            _1208 = _417;
            _1209 = _418;
            _1210 = _419;
          }
          // float4 _1213 = _20.Sample(_8[2u], float2(_401, _405));
          float4 _1213 = _20.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_401, _405));
          float _450 = ((_1213.x - _1208) * _734) + _1208;
          float _455 = ((_1213.y - _1209) * _734) + _1209;
          float _460 = ((_1213.z - _1210) * _734) + _1210;
          // float4 _1226 = _19.Sample(_8[0u], float2(_401, _405));
          float4 _1226 = _19.Sample((SamplerState)ResourceDescriptorHeap[0u], float2(_401, _405));
          float frontier_phi_2_3_ladder_6_ladder_28_ladder;
          float frontier_phi_2_3_ladder_6_ladder_28_ladder_1;
          float frontier_phi_2_3_ladder_6_ladder_28_ladder_2;
          if ((_1226.z > 0.0f) || ((_1226.x > 0.0f) || (_1226.y > 0.0f))) {
            // float4 _1334 = _19.Sample(_8[2u], float2(_401, _405));
            float4 _1334 = _19.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_401, _405));
            frontier_phi_2_3_ladder_6_ladder_28_ladder = ((_1334.z - _460) * _728) + _460;
            frontier_phi_2_3_ladder_6_ladder_28_ladder_1 = ((_1334.y - _455) * _728) + _455;
            frontier_phi_2_3_ladder_6_ladder_28_ladder_2 = ((_1334.x - _450) * _728) + _450;
          } else {
            frontier_phi_2_3_ladder_6_ladder_28_ladder = _460;
            frontier_phi_2_3_ladder_6_ladder_28_ladder_1 = _455;
            frontier_phi_2_3_ladder_6_ladder_28_ladder_2 = _450;
          }
          frontier_phi_2_3_ladder_6_ladder = frontier_phi_2_3_ladder_6_ladder_28_ladder;
          frontier_phi_2_3_ladder_6_ladder_1 = frontier_phi_2_3_ladder_6_ladder_28_ladder_1;
          frontier_phi_2_3_ladder_6_ladder_2 = frontier_phi_2_3_ladder_6_ladder_28_ladder_2;
        } else {
          // float4 _693 = _20.Sample(_8[2u], float2(_401, _405));
          float4 _693 = _20.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_401, _405));
          frontier_phi_2_3_ladder_6_ladder = _693.z;
          frontier_phi_2_3_ladder_6_ladder_1 = _693.y;
          frontier_phi_2_3_ladder_6_ladder_2 = _693.x;
        }
        frontier_phi_2_3_ladder = frontier_phi_2_3_ladder_6_ladder;
        frontier_phi_2_3_ladder_1 = frontier_phi_2_3_ladder_6_ladder_1;
        frontier_phi_2_3_ladder_2 = frontier_phi_2_3_ladder_6_ladder_2;
      } else {
        // float4 _642 = _19.Sample(_8[2u], float2(_401, _405));
        float4 _642 = _19.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(_401, _405));
        frontier_phi_2_3_ladder = _642.z;
        frontier_phi_2_3_ladder_1 = _642.y;
        frontier_phi_2_3_ladder_2 = _642.x;
      }
      _446 = frontier_phi_2_3_ladder_2;
      _451 = frontier_phi_2_3_ladder_1;
      _456 = frontier_phi_2_3_ladder;
    }
    _61[_390] = _446;
    _62[_390] = _451;
    _63[_390] = _456;
    _391 = _390 + 1u;
    if (_391 == 5u) {
      break;
    }
    _386 = _60[_391];
    _388 = _59[_391];
    _390 = _391;
    continue;
  }
  uint _488 = _186.y;
  float _510 = (_275 - _40_m0[0u].z) / _40_m0[0u].x;
  float _511 = (_276 - _40_m0[0u].w) / _40_m0[0u].y;
  float4 _529 = _26.Load(2u);
  float _530 = _529.x;
  // float4 _533 = _21.Sample(_8[2u], float2(max(min(_510, _40_m0[16u].x), min(max(_510, _40_m0[16u].x), _40_m0[16u].z)), max(min(_511, _40_m0[16u].y), min(max(_511, _40_m0[16u].y), _40_m0[16u].w))));
  float4 _533 = _21.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(max(min(_510, _40_m0[16u].x), min(max(_510, _40_m0[16u].x), _40_m0[16u].z)), max(min(_511, _40_m0[16u].y), min(max(_511, _40_m0[16u].y), _40_m0[16u].w))));
  float _535 = _533.x;
  float _536 = _533.y;
  float _537 = _533.z;
  // float4 _540 = _22.Sample(_8[2u], float2(max(min(_510, _40_m0[15u].x), min(max(_510, _40_m0[15u].x), _40_m0[15u].z)), max(min(_511, _40_m0[15u].y), min(max(_511, _40_m0[15u].y), _40_m0[15u].w))));
  float4 _540 = _22.Sample((SamplerState)ResourceDescriptorHeap[2u], float2(max(min(_510, _40_m0[15u].x), min(max(_510, _40_m0[15u].x), _40_m0[15u].z)), max(min(_511, _40_m0[15u].y), min(max(_511, _40_m0[15u].y), _40_m0[15u].w))));
  float _548 = _40_m0[19u].y * 0.125f;
  float _550 = (_61[3u] + _61[1u]) * _548;
  float _551 = (((_62[4u] + _62[3u]) * 0.5f) + _62[2u]) * _548;
  float _552 = (_63[4u] + _63[0u]) * _548;
  float _565 = (clamp(dot(float3(_550, _551, _552), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f)) + 9.9999999747524270787835121154785e-07f, 0.0f, 1.0f) * (1.0f - _40_m0[17u].w)) + _40_m0[17u].w;
  float _578 = _40_m0[19u].y * 0.25f;
  float _583 = (exp2(log2(max(_550, 0.0f)) * _565) / _578) * _40_m0[17u].w;
  float _584 = (exp2(log2(max(_551, 0.0f)) * _565) / _578) * _40_m0[17u].w;
  float _585 = (exp2(log2(max(_552, 0.0f)) * _565) / _578) * _40_m0[17u].w;
  float _586 = (_535 * _535) / _40_m0[19u].z;
  float _587 = (_536 * _536) / _40_m0[19u].z;
  float _588 = (_537 * _537) / _40_m0[19u].z;
  float _591 = (_530 * 4.0f) / (_530 + 0.25f);
  float _595 = max(_530, 1.0000000031710768509710513471353e-30f);
  float _608 = 1.0f / ((_530 + 1.0f) + _591);
  float _622 = (((_587 + _584) + (sqrt((_587 * _584) / _595) * _591)) * _608) + (_540.y * _40_m0[19u].x);
  float _628 = ((_622 * (_40_m0[17u].x - _40_m0[17u].y)) + (((_608 * ((_586 + _583) + (sqrt((_586 * _583) / _595) * _591))) + (_540.x * _40_m0[19u].x)) * _40_m0[17u].x)) * _40_m0[19u].z;
  float _630 = (_40_m0[19u].z * _40_m0[17u].y) * _622;
  float _632 = (_40_m0[19u].z * _40_m0[17u].z) * ((((_588 + _585) + (sqrt((_588 * _585) / _595) * _591)) * _608) + (_540.z * _40_m0[19u].x));
  float _644;
  float _646;
  float _648;
  if ((_488 & 1u) == 0u) {
    _644 = _628;
    _646 = _630;
    _648 = _632;
  } else {
    uint _656 = asuint(_40_m0[11u].z);
    // float _675 = (_23.Sample(_8[17u], float2((_275 * _40_m0[11u].x) + (float(_656 & 65535u) * 1.52587890625e-05f), (_276 * _40_m0[11u].y) + (float(_656 >> 16u) * 1.52587890625e-05f))).y + (-0.5f)) * _533.w;
    float _675 = (_23.Sample((SamplerState)ResourceDescriptorHeap[17u], float2((_275 * _40_m0[11u].x) + (float(_656 & 65535u) * 1.52587890625e-05f), (_276 * _40_m0[11u].y) + (float(_656 >> 16u) * 1.52587890625e-05f))).y + (-0.5f)) * _533.w;
    _644 = max(_675 + _628, 0.0f);
    _646 = max(_675 + _630, 0.0f);
    _648 = max(_675 + _632, 0.0f);
  }
  float _695;
  float _697;
  float _699;
  if ((_488 & 32u) == 0u) {
    _695 = _644;
    _697 = _646;
    _699 = _648;
  } else {
    float _709 = (_275 * 2.0f) + (-1.0f);
    float _710 = (_276 * 2.0f) + (-1.0f);
    float _717 = clamp((sqrt((_710 * _710) + (_709 * _709)) * _40_m0[10u].x) + _40_m0[10u].y, 0.0f, 1.0f);
    float _719 = (_717 * _717) * _40_m0[1u].w;
    float _720 = 1.0f - _719;
    float _724 = (_608 * _40_m0[19u].z) * _719;
    _695 = (_720 * _644) + (_724 * _40_m0[1u].x);
    _697 = (_720 * _646) + (_724 * _40_m0[1u].y);
    _699 = (_720 * _648) + (_724 * _40_m0[1u].z);
  }
  float _701 = max(_695, 9.9999999747524270787835121154785e-07f);
  float _702 = max(_697, 9.9999999747524270787835121154785e-07f);
  float _703 = max(_699, 9.9999999747524270787835121154785e-07f);
  float _784;
  float _787;
  float _790;
  if ((_488 & 16u) == 0u) {
    _784 = _701;
    _787 = _702;
    _790 = _703;
  } else {
    float frontier_phi_16_17_ladder;
    float frontier_phi_16_17_ladder_1;
    float frontier_phi_16_17_ladder_2;
    if (asuint(_40_m0[12u]).w == 0u) {
#if 1
      ApplyTonemapGamma2LUTAndInverseTonemap(
          (SamplerState)ResourceDescriptorHeap[2u],
          _29,
          _701, _702, _703,
          _40_m0[2u].w,
          _40_m0[2u].x, _40_m0[2u].y, _40_m0[2u].z,
          _40_m0[3u].x, _40_m0[3u].y, _40_m0[3u].z, _40_m0[3u].w,
          _40_m0[10u].z, _40_m0[10u].w,
          frontier_phi_16_17_ladder,
          frontier_phi_16_17_ladder_1,
          frontier_phi_16_17_ladder_2);
#else
      float _833 = (-0.0f) - _40_m0[2u].w;
      // float4 _866 = _29.SampleLevel(_8[2u], float3((clamp(sqrt(max((_701 < _40_m0[3u].z) ? ((_701 * _40_m0[2u].y) + _40_m0[2u].z) : ((_833 / (_701 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(sqrt(max((_702 < _40_m0[3u].z) ? ((_702 * _40_m0[2u].y) + _40_m0[2u].z) : ((_833 / (_702 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(sqrt(max((_703 < _40_m0[3u].z) ? ((_703 * _40_m0[2u].y) + _40_m0[2u].z) : ((_833 / (_703 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w), 0.0f);
      float4 _866 = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float3((clamp(sqrt(max((_701 < _40_m0[3u].z) ? ((_701 * _40_m0[2u].y) + _40_m0[2u].z) : ((_833 / (_701 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(sqrt(max((_702 < _40_m0[3u].z) ? ((_702 * _40_m0[2u].y) + _40_m0[2u].z) : ((_833 / (_702 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(sqrt(max((_703 < _40_m0[3u].z) ? ((_703 * _40_m0[2u].y) + _40_m0[2u].z) : ((_833 / (_703 + _40_m0[3u].x)) + _40_m0[3u].y), 0.0f)), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w), 0.0f);
      float _868 = _866.x;
      float _869 = _866.y;
      float _870 = _866.z;
      float _874 = min(_868 * _868, _40_m0[2u].x);
      float _875 = min(_869 * _869, _40_m0[2u].x);
      float _876 = min(_870 * _870, _40_m0[2u].x);
      frontier_phi_16_17_ladder = (_876 < _40_m0[3u].w) ? ((_876 - _40_m0[2u].z) / _40_m0[2u].y) : ((_833 / (_876 - _40_m0[3u].y)) - _40_m0[3u].x);
      frontier_phi_16_17_ladder_1 = (_875 < _40_m0[3u].w) ? ((_875 - _40_m0[2u].z) / _40_m0[2u].y) : ((_833 / (_875 - _40_m0[3u].y)) - _40_m0[3u].x);
      frontier_phi_16_17_ladder_2 = (_874 < _40_m0[3u].w) ? ((_874 - _40_m0[2u].z) / _40_m0[2u].y) : ((_833 / (_874 - _40_m0[3u].y)) - _40_m0[3u].x);
#endif
    } else {
      float _909 = exp2(log2(abs(_701 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _910 = exp2(log2(abs(_702 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      float _911 = exp2(log2(abs(_703 * 0.00999999977648258209228515625f)) * 0.1470947265625f);
      // float4 _953 = _29.SampleLevel(_8[2u], float3((clamp(exp2(log2(abs(((_909 * 18.8515625f) + 0.8359375f) / ((_909 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(exp2(log2(abs(((_910 * 18.8515625f) + 0.8359375f) / ((_910 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(exp2(log2(abs(((_911 * 18.8515625f) + 0.8359375f) / ((_911 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w), 0.0f);
      float4 _953 = _29.SampleLevel((SamplerState)ResourceDescriptorHeap[2u], float3((clamp(exp2(log2(abs(((_909 * 18.8515625f) + 0.8359375f) / ((_909 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(exp2(log2(abs(((_910 * 18.8515625f) + 0.8359375f) / ((_910 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w, (clamp(exp2(log2(abs(((_911 * 18.8515625f) + 0.8359375f) / ((_911 * 18.6875f) + 1.0f))) * 78.84375f), 0.0f, 1.0f) * _40_m0[10u].z) + _40_m0[10u].w), 0.0f);
      float _968 = exp2(log2(abs(_953.x)) * 0.0126833133399486541748046875f);
      float _969 = exp2(log2(abs(_953.y)) * 0.0126833133399486541748046875f);
      float _970 = exp2(log2(abs(_953.z)) * 0.0126833133399486541748046875f);
      frontier_phi_16_17_ladder = exp2(log2(abs((_970 + (-0.8359375f)) / (18.8515625f - (_970 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_16_17_ladder_1 = exp2(log2(abs((_969 + (-0.8359375f)) / (18.8515625f - (_969 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
      frontier_phi_16_17_ladder_2 = exp2(log2(abs((_968 + (-0.8359375f)) / (18.8515625f - (_968 * 18.6875f)))) * 6.798340320587158203125f) * 100.0f;
    }
    _784 = frontier_phi_16_17_ladder_2;
    _787 = frontier_phi_16_17_ladder_1;
    _790 = frontier_phi_16_17_ladder;
  }
  float _800;
  float _802;
  float _804;
  if ((_488 & 2u) == 0u) {
    _800 = _784;
    _802 = _787;
    _804 = _790;
  } else {
#if 1
    ApplyUserGradingAndToneMapAndScale(
        _784, _787, _790,
        _40_m0[2u].y, _40_m0[2u].z,
        _40_m0[3u].z,
        _40_m0[4u].x, _40_m0[4u].y, _40_m0[4u].z,
        _800, _802, _804);
#else
    float _814 = (-0.0f) - _40_m0[4u].x;
    _800 = (_784 < _40_m0[3u].z) ? ((_784 * _40_m0[2u].y) + _40_m0[2u].z) : ((_814 / (_784 + _40_m0[4u].y)) + _40_m0[4u].z);
    _802 = (_787 < _40_m0[3u].z) ? ((_787 * _40_m0[2u].y) + _40_m0[2u].z) : ((_814 / (_787 + _40_m0[4u].y)) + _40_m0[4u].z);
    _804 = (_790 < _40_m0[3u].z) ? ((_790 * _40_m0[2u].y) + _40_m0[2u].z) : ((_814 / (_790 + _40_m0[4u].y)) + _40_m0[4u].z);
#endif
  }
  uint _806 = uint(int(_40_m0[18u].w));
  float _1307;
  float _1309;
  float _1311;
  if (_806 == 1u) {
    float _1019 = exp2(log2(abs(_800)) * _40_m0[18u].x);
    float _1020 = exp2(log2(abs(_802)) * _40_m0[18u].x);
    float _1021 = exp2(log2(abs(_804)) * _40_m0[18u].x);
    float _1308;
    if (_1019 < 0.00310000008903443813323974609375f) {
      _1308 = _1019 * 12.9200000762939453125f;
    } else {
      _1308 = (exp2(log2(abs(_1019)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float _1310;
    if (_1020 < 0.00310000008903443813323974609375f) {
      _1310 = _1020 * 12.9200000762939453125f;
    } else {
      _1310 = (exp2(log2(abs(_1020)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
    }
    float frontier_phi_32_37_ladder;
    float frontier_phi_32_37_ladder_1;
    float frontier_phi_32_37_ladder_2;
    if (_1021 < 0.00310000008903443813323974609375f) {
      frontier_phi_32_37_ladder = _1308;
      frontier_phi_32_37_ladder_1 = _1021 * 12.9200000762939453125f;
      frontier_phi_32_37_ladder_2 = _1310;
    } else {
      frontier_phi_32_37_ladder = _1308;
      frontier_phi_32_37_ladder_1 = (exp2(log2(abs(_1021)) * 0.4166666567325592041015625f) * 1.05499994754791259765625f) + (-0.054999999701976776123046875f);
      frontier_phi_32_37_ladder_2 = _1310;
    }
    _1307 = frontier_phi_32_37_ladder;
    _1309 = frontier_phi_32_37_ladder_2;
    _1311 = frontier_phi_32_37_ladder_1;
  } else {
    float frontier_phi_32_26_ladder;
    float frontier_phi_32_26_ladder_1;
    float frontier_phi_32_26_ladder_2;
    if (_806 == 2u) {
#if 1
      float pq_r, pq_g, pq_b;
      PQFromBT709(
          _800, _802, _804,
          _40_m0[18u].x, _40_m0[18u].y,
          pq_r, pq_g, pq_b);

      frontier_phi_32_26_ladder = pq_r;
      frontier_phi_32_26_ladder_1 = pq_b;
      frontier_phi_32_26_ladder_2 = pq_g;
#else
      float _1277 = exp2(log2(abs(mad(0.0433130674064159393310546875f, _804, mad(0.3292830288410186767578125f, _802, _800 * 0.627403914928436279296875f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      float _1278 = exp2(log2(abs(mad(0.01136231608688831329345703125f, _804, mad(0.9195404052734375f, _802, _800 * 0.069097287952899932861328125f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      float _1279 = exp2(log2(abs(mad(0.895595252513885498046875f, _804, mad(0.08801330626010894775390625f, _802, _800 * 0.01639143936336040496826171875f)) * _40_m0[18u].y)) * _40_m0[18u].x);
      frontier_phi_32_26_ladder = exp2(log2(abs(((_1277 * 18.8515625f) + 0.8359375f) / ((_1277 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_32_26_ladder_1 = exp2(log2(abs(((_1279 * 18.8515625f) + 0.8359375f) / ((_1279 * 18.6875f) + 1.0f))) * 78.84375f);
      frontier_phi_32_26_ladder_2 = exp2(log2(abs(((_1278 * 18.8515625f) + 0.8359375f) / ((_1278 * 18.6875f) + 1.0f))) * 78.84375f);
#endif
    } else {
      frontier_phi_32_26_ladder = _800;
      frontier_phi_32_26_ladder_1 = _804;
      frontier_phi_32_26_ladder_2 = _802;
    }
    _1307 = frontier_phi_32_26_ladder;
    _1309 = frontier_phi_32_26_ladder_2;
    _1311 = frontier_phi_32_26_ladder_1;
  }
  float _1323 = max(((_1307 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  float _1324 = max(((_1309 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  float _1325 = max(((_1311 + (-0.5f)) * _40_m0[5u].x) + 0.5f, 0.0f);
  SV_Target.x = _1323;
  SV_Target.y = _1324;
  SV_Target.z = _1325;
  SV_Target.w = 1.0f;
  SV_Target_1 = dot(float3(_1323, _1324, _1325), float3(0.2125999927520751953125f, 0.715200006961822509765625f, 0.072200000286102294921875f));
}

SPIRV_Cross_Output main(SPIRV_Cross_Input stage_input) {
  gl_FragCoord = stage_input.gl_FragCoord;
  gl_FragCoord.w = 1.0 / gl_FragCoord.w;
  TEXCOORD = stage_input.TEXCOORD;
  frag_main();
  SPIRV_Cross_Output stage_output;
  stage_output.SV_Target = SV_Target;
  stage_output.SV_Target_1 = SV_Target_1;
  return stage_output;
}
