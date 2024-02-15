// Film Grain Generator

#include "../cp2077/cp2077.h"

cbuffer _13_15 : register(b6, space0) {
  float4 _15_m0[1] : packoffset(c0);
}

cbuffer injectedBuffer : register(b14, space0) {
  ShaderInjectData injectedData : packoffset(c0);
}

RWTexture2D<float4> outputTexture : register(u0, space0);

static uint3 gl_GlobalInvocationID;

struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  float _44 = frac(float(gl_GlobalInvocationID.x) * 0.103100001811981201171875f);
  float _45 = frac(float(gl_GlobalInvocationID.y) * 0.10300000011920928955078125f);
  float _46 = frac(float(asuint(_15_m0[0u]).w & 4095u) * 0.097300000488758087158203125f);
  float _50 = _46 + 33.3300018310546875f;
  float _51 = dot(float3(_44, _45, _46), float3(_45 + 33.3300018310546875f, _44 + 33.3300018310546875f, _50));
  float _55 = _51 + _44;
  float _56 = _51 + _45;
  float _58 = _55 + _56;
  float _80 = frac(float(gl_GlobalInvocationID.x & 255u) * 0.103100001811981201171875f);
  float _81 = frac(float((gl_GlobalInvocationID.y + 1u) & 255u) * 0.10300000011920928955078125f);
  float _82 = _81 + 33.3300018310546875f;
  float _83 = _80 + 33.3300018310546875f;
  float _84 = dot(float3(_80, _81, _46), float3(_82, _83, _50));
  float _87 = _84 + _80;
  float _88 = _84 + _81;
  float _90 = _87 + _88;
  float _102 = frac(float((gl_GlobalInvocationID.y + 255u) & 255u) * 0.10300000011920928955078125f);
  float _103 = _102 + 33.3300018310546875f;
  float _104 = dot(float3(_80, _102, _46), float3(_103, _83, _50));
  float _107 = _104 + _80;
  float _108 = _104 + _102;
  float _110 = _107 + _108;
  float _125 = frac(float((gl_GlobalInvocationID.x + 1u) & 255u) * 0.103100001811981201171875f);
  float _126 = frac(float(gl_GlobalInvocationID.y & 255u) * 0.10300000011920928955078125f);
  float _127 = _126 + 33.3300018310546875f;
  float _128 = _125 + 33.3300018310546875f;
  float _129 = dot(float3(_125, _126, _46), float3(_127, _128, _50));
  float _132 = _129 + _125;
  float _133 = _129 + _126;
  float _135 = _132 + _133;
  float _147 = frac(float((gl_GlobalInvocationID.x + 255u) & 255u) * 0.103100001811981201171875f);
  float _148 = _147 + 33.3300018310546875f;
  float _149 = dot(float3(_147, _126, _46), float3(_127, _148, _50));
  float _152 = _149 + _147;
  float _153 = _149 + _126;
  float _155 = _152 + _153;
  float _163 = dot(float3(_125, _81, _46), float3(_82, _128, _50));
  float _166 = _163 + _125;
  float _167 = _163 + _81;
  float _169 = _166 + _167;
  float _177 = dot(float3(_147, _102, _46), float3(_103, _148, _50));
  float _180 = _177 + _147;
  float _181 = _177 + _102;
  float _183 = _180 + _181;
  float _191 = dot(float3(_125, _102, _46), float3(_103, _128, _50));
  float _194 = _191 + _125;
  float _195 = _191 + _102;
  float _197 = _194 + _195;
  float _205 = dot(float3(_147, _81, _46), float3(_82, _148, _50));
  float _208 = _205 + _147;
  float _209 = _205 + _81;
  float _211 = _208 + _209;
  float4 outputColor = float4(
    ((((_15_m0[0u].x * (((frac(_183 * (_177 + _46)) + frac(_169 * (_163 + _46))) + frac(_197 * (_191 + _46))) + frac(_211 * (_205 + _46)))) * 0.5f) + frac(_58 * (_51 + _46))) + ((_15_m0[0u].x * (((frac(_110 * (_104 + _46)) + frac(_90 * (_84 + _46))) + frac(_135 * (_129 + _46))) + frac(_155 * (_149 + _46)))) * 0.75f)) / ((_15_m0[0u].x * 5.0f) + 1.0f),
    ((((_15_m0[0u].y * (((frac((_180 * 2.0f) * _181) + frac((_166 * 2.0f) * _167)) + frac((_194 * 2.0f) * _195)) + frac((_208 * 2.0f) * _209))) * 0.5f) + frac((_55 * 2.0f) * _56)) + ((_15_m0[0u].y * (((frac((_107 * 2.0f) * _108) + frac((_87 * 2.0f) * _88)) + frac((_132 * 2.0f) * _133)) + frac((_152 * 2.0f) * _153))) * 0.75f)) / ((_15_m0[0u].y * 5.0f) + 1.0f),
    ((((_15_m0[0u].z * (((frac(_183 * _180) + frac(_169 * _166)) + frac(_197 * _194)) + frac(_211 * _208))) * 0.5f) + frac(_58 * _55)) + ((_15_m0[0u].z * (((frac(_110 * _107) + frac(_90 * _87)) + frac(_135 * _132)) + frac(_155 * _152))) * 0.75f)) / ((_15_m0[0u].z * 5.0f) + 1.0f),
    0.0f
  );

  outputTexture[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = outputColor;
}

[numthreads(8, 8, 1)] void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
