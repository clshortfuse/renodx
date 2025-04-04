cbuffer c0UBO : register(b0, space0) {
  float4 c0_m0[2] : packoffset(c0);
};

Texture2D<float4> input_texture0 : register(t0, space0);
RWTexture2D<float4> input_texture1 : register(u0, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_WorkGroupID : SV_GroupID;
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

uint spvPackHalf2x16(float2 value) {
  uint2 Packed = f32tof16(value);
  return Packed.x | (Packed.y << 16);
}

float2 spvUnpackHalf2x16(uint value) {
  return f16tof32(uint2(value & 0xffff, value >> 16));
}

void comp_main() {
  uint _46 = ((gl_LocalInvocationID.x >> 1u) & 7u) | (gl_WorkGroupID.x << 4u);
  uint _47 = (((gl_LocalInvocationID.x >> 3u) & 6u) | (gl_LocalInvocationID.x & 1u)) | (gl_WorkGroupID.y << 4u);
  uint _66 = _46 << 16u;
  uint _68 = uint(int(_66) >> int(16u));
  uint _69 = _47 << 16u;
  uint _72 = uint(int(_69 + 4294901760u) >> int(16u));
  float4 _73 = input_texture0.Load(int3(uint2(_68, _72), 0u));
  float _77 = _73.y;
  uint _80 = uint(int(_66 + 4294901760u) >> int(16u));
  uint _81 = uint(int(_69) >> int(16u));
  float4 _82 = input_texture0.Load(int3(uint2(_80, _81), 0u));
  float _85 = _82.y;
  float4 _87 = input_texture0.Load(int3(uint2(_68, _81), 0u));
  float _90 = _87.y;
  uint _94 = uint(int(_66 + 65536u) >> int(16u));
  float4 _95 = input_texture0.Load(int3(uint2(_94, _81), 0u));
  float _98 = _95.y;
  uint _101 = uint(int(_69 + 65536u) >> int(16u));
  float4 _102 = input_texture0.Load(int3(uint2(_68, _101), 0u));
  float _105 = _102.y;
  uint _107 = _46 | 8u;
  float4 _109 = input_texture0.Load(int3(uint2(_107, _72), 0u));
  float _112 = _109.y;
  uint _114 = _107 + 4294967295u;
  float4 _116 = input_texture0.Load(int3(uint2(_114, _81), 0u));
  float _119 = _116.y;
  float4 _121 = input_texture0.Load(int3(uint2(_107, _81), 0u));
  float _124 = _121.y;
  uint _126 = _107 + 1u;
  float4 _127 = input_texture0.Load(int3(uint2(_126, _81), 0u));
  float _130 = _127.y;
  float4 _132 = input_texture0.Load(int3(uint2(_107, _101), 0u));
  float _135 = _132.y;
  float _151 = max(max(_98, _105), max(max(_77, _85), _90));
  float _152 = max(max(_130, _135), max(max(_112, _119), _124));
  float2 _167 = spvUnpackHalf2x16(spvPackHalf2x16(float2((-0.0f) - (1.0f / (8.0f - (clamp(c0_m0[0u].x, 0.0f, 1.0f) * 3.0f))), 0.0f)) & 65535u);
  float _168 = _167.x;
  float _169 = _168 * sqrt(clamp(min(min(min(_98, _105), min(min(_77, _85), _90)), 1.0f - _151) * (1.0f / _151), 0.0f, 1.0f));
  float _170 = _168 * sqrt(clamp(min(min(min(_130, _135), min(min(_112, _119), _124)), 1.0f - _152) * (1.0f / _152), 0.0f, 1.0f));
  float _176 = 1.0f / ((_169 * 4.0f) + 1.0f);
  float _177 = 1.0f / ((_170 * 4.0f) + 1.0f);
  input_texture1[uint2(_46, _47)] = float4(clamp(((_169 * (((_82.x + _73.x) + _95.x) + _102.x)) + _87.x) * _176, 0.0f, 1.0f), clamp(((_169 * (((_85 + _77) + _98) + _105)) + _90) * _176, 0.0f, 1.0f), clamp(((_169 * (((_82.z + _73.z) + _95.z) + _102.z)) + _87.z) * _176, 0.0f, 1.0f), 0.0f);
  uint _222 = _46 | 8u;
  input_texture1[uint2(_222, _47)] = float4(clamp(((_170 * (((_116.x + _109.x) + _127.x) + _132.x)) + _121.x) * _177, 0.0f, 1.0f), clamp(((_170 * (((_119 + _112) + _130) + _135)) + _124) * _177, 0.0f, 1.0f), clamp(((_170 * (((_116.z + _109.z) + _127.z) + _132.z)) + _121.z) * _177, 0.0f, 1.0f), 0.0f);
  uint _225 = _47 | 8u;
  uint _226 = _225 << 16u;
  uint _228 = uint(int(_226 + 4294901760u) >> int(16u));
  float4 _229 = input_texture0.Load(int3(uint2(_68, _228), 0u));
  float _232 = _229.y;
  uint _234 = uint(int(_226) >> int(16u));
  float4 _235 = input_texture0.Load(int3(uint2(_80, _234), 0u));
  float _238 = _235.y;
  float4 _240 = input_texture0.Load(int3(uint2(_68, _234), 0u));
  float _243 = _240.y;
  float4 _245 = input_texture0.Load(int3(uint2(_94, _234), 0u));
  float _248 = _245.y;
  uint _251 = uint(int(_226 + 65536u) >> int(16u));
  float4 _252 = input_texture0.Load(int3(uint2(_68, _251), 0u));
  float _255 = _252.y;
  float4 _257 = input_texture0.Load(int3(uint2(_107, _228), 0u));
  float _260 = _257.y;
  float4 _262 = input_texture0.Load(int3(uint2(_114, _234), 0u));
  float _265 = _262.y;
  float4 _267 = input_texture0.Load(int3(uint2(_107, _234), 0u));
  float _270 = _267.y;
  float4 _272 = input_texture0.Load(int3(uint2(_126, _234), 0u));
  float _275 = _272.y;
  float4 _277 = input_texture0.Load(int3(uint2(_107, _251), 0u));
  float _280 = _277.y;
  float _296 = max(max(_248, _255), max(max(_232, _238), _243));
  float _297 = max(max(_275, _280), max(max(_260, _265), _270));
  float _310 = _168 * sqrt(clamp(min(min(min(_248, _255), min(min(_232, _238), _243)), 1.0f - _296) * (1.0f / _296), 0.0f, 1.0f));
  float _311 = _168 * sqrt(clamp(min(min(min(_275, _280), min(min(_260, _265), _270)), 1.0f - _297) * (1.0f / _297), 0.0f, 1.0f));
  float _316 = 1.0f / ((_310 * 4.0f) + 1.0f);
  float _317 = 1.0f / ((_311 * 4.0f) + 1.0f);
  /* input_texture1[uint2(_46, _225)] = float4(clamp(((_310 * (((_235.x + _229.x) + _245.x) + _252.x)) + _240.x) * _316, 0.0f, 1.0f), clamp(((_310 * (((_238 + _232) + _248) + _255)) + _243) * _316, 0.0f, 1.0f), clamp(((_310 * (((_235.z + _229.z) + _245.z) + _252.z)) + _240.z) * _316, 0.0f, 1.0f), 0.0f);
  input_texture1[uint2(_222, _225)] = float4(clamp(((_311 * (((_262.x + _257.x) + _272.x) + _277.x)) + _267.x) * _317, 0.0f, 1.0f), clamp(((_311 * (((_265 + _260) + _275) + _280)) + _270) * _317, 0.0f, 1.0f), clamp(((_311 * (((_262.z + _257.z) + _272.z) + _277.z)) + _267.z) * _317, 0.0f, 1.0f), 0.0f);
 */
  input_texture1[uint2(_46, _225)] = float4(((_310 * (((_235.x + _229.x) + _245.x) + _252.x)) + _240.x) * _316, (((_310 * (((_238 + _232) + _248) + _255)) + _243) * _316), (((_310 * (((_235.z + _229.z) + _245.z) + _252.z)) + _240.z) * _316), 0.0f);
  input_texture1[uint2(_222, _225)] = float4((((_311 * (((_262.x + _257.x) + _272.x) + _277.x)) + _267.x) * _317), (((_311 * (((_265 + _260) + _275) + _280)) + _270) * _317), (((_311 * (((_262.z + _257.z) + _272.z) + _277.z)) + _267.z) * _317), 0.0f);
}

[numthreads(64, 1, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
