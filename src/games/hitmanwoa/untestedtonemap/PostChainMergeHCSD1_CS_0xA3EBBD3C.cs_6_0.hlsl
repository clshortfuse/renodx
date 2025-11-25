#include "../common.hlsli"

cbuffer _28_30 : register(b2, space0) {
  float4 _30_m0[154] : packoffset(c0);
};

cbuffer _33_35 : register(b5, space0) {
  float4 _35_m0[13] : packoffset(c0);
};

Texture2DArray<float4> _8 : register(t0, space0);
Texture2D<float4> _11 : register(t1, space0);
Texture3D<float4> _14 : register(t2, space0);
Texture2D<float4> _15 : register(t4, space0);
Texture2D<float4> _16 : register(t5, space0);
Buffer<uint4> _20 : register(t6, space0);
Buffer<uint4> _21 : register(t7, space0);
RWTexture2DArray<float4> _24 : register(u0, space0);
SamplerState _38 : register(s4, space0);
SamplerState _39 : register(s6, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_WorkGroupID : SV_GroupID;
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

void comp_main() {
  uint4 _64 = _21.Load(gl_WorkGroupID.x);
  uint _65 = _64.x;
  uint _66 = _65 >> 20u;
  uint _68 = _66 & 1023u;
  uint _77 = ((_65 << 3u) & 8184u) + gl_LocalInvocationID.x;
  uint _78 = ((_65 >> 7u) & 8184u) + gl_LocalInvocationID.y;
  float _79 = float(int(_77));
  float _80 = float(int(_78));
  float _89 = (_79 + 0.5f) * _35_m0[0u].x;
  float _90 = (_80 + 0.5f) * _35_m0[0u].y;
  bool _94 = (_66 & 2u) == 0u;
  float _108 = _94 ? _90 : (((_90 + (-0.5f)) * _30_m0[103u].y) + 0.5f);
  float _116 = mad(_94 ? _89 : (((_89 + (-0.5f)) * _30_m0[103u].x) + 0.5f), 2.0f, -1.0f);
  float _119 = mad(_108, 2.0f, -1.0f);
  float _129 = clamp((sqrt((_119 * _119) + (_116 * _116)) - _35_m0[6u].x) / (_35_m0[6u].y - _35_m0[6u].x), 0.0f, 1.0f);
  float _135 = ((_129 * _129) * _35_m0[6u].z) * (3.0f - (_129 * 2.0f));
  float _142 = 1.0f - clamp(_108 * _35_m0[4u].w, 0.0f, 1.0f);
  float _143 = _142 * _142;
  float4 _162 = _8.SampleLevel(_38, float3(_89, _90, float(_68)), 0.0f);
  float4 _170 = _11.SampleLevel(_38, float2(_89, _90), 0.0f);
  float _200 = asfloat(_20.Load(5u).x);

  float3 bloomed_color = ScaleBloom(_162.rgb, _170.rgb, _35_m0[9u].x);

  float _201 = (bloomed_color.r * _35_m0[7u].x) * _200;
  float _202 = (bloomed_color.g * _35_m0[7u].y) * _200;
  float _203 = (bloomed_color.b * _35_m0[7u].z) * _200;
#if 1
  float3 color_combined = float3(_201, _202, _203);
  float3 tonemapped = ApplyCustomSimpleReinhardToneMap(color_combined) * _35_m0[10u].y;
  float _213 = tonemapped.r, _214 = tonemapped.g, _215 = tonemapped.b;
#else
  float _213 = clamp((_201 / (_201 + 1.0f)) * _35_m0[10u].y, 0.0f, 1.0f);
  float _214 = clamp((_202 / (_202 + 1.0f)) * _35_m0[10u].y, 0.0f, 1.0f);
  float _215 = clamp((_203 / (_203 + 1.0f)) * _35_m0[10u].y, 0.0f, 1.0f);
#endif

  float _234 = clamp(1.0f - (_35_m0[9u].y * frac(sin((_35_m0[10u].z + floor(_35_m0[9u].z * _79)) + ((_35_m0[10u].z + floor(_35_m0[9u].z * _80)) * 0.0129898004233837127685546875f)) * 43758.546875f)), 0.0f, 1.0f);
  float4 _236 = _15.SampleLevel(_38, float2(_89, _90), 0.0f);
  float _240 = _236.w;
  float4 _258 = _16.SampleLevel(_39, float2(((mad(_35_m0[3u].y + _236.x, 2.0f, -1.0f) * _240) * _35_m0[2u].w) + _89, ((mad(_35_m0[3u].y + _236.y, 2.0f, -1.0f) * _240) * _35_m0[2u].w) + _90), 0.0f);
  float _265 = clamp(_35_m0[3u].z * _240, 0.0f, 1.0f);
  float _277 = clamp(_35_m0[3u].x * _240, 0.0f, 1.0f);

#if 1
  float3 lut_input_preoffset = float3(
      (((((((_35_m0[5u].x - 0.5f) * _135) + 0.5f) * 2.0f) * _234) * ((_265 * (_258.x - _213)) + _213)) * (((_35_m0[2u].x - 1.0f) * _277) + 1.0f)) + (_35_m0[4u].x * _143),
      (((((((_35_m0[5u].y - 0.5f) * _135) + 0.5f) * 2.0f) * _234) * ((_265 * (_258.y - _214)) + _214)) * (((_35_m0[2u].y - 1.0f) * _277) + 1.0f)) + (_35_m0[4u].y * _143),
      (((((((_35_m0[5u].z - 0.5f) * _135) + 0.5f) * 2.0f) * _234) * ((_265 * (_258.z - _215)) + _215)) * (((_35_m0[2u].z - 1.0f) * _277) + 1.0f)) + (_35_m0[4u].z * _143));
  float3 final_color = ToneMapMaxCLLAndSampleLinearLUT16AndFinalizeOutput(lut_input_preoffset, _14, _38, _35_m0[8u].y, _89, _90, _35_m0[11u].x);
  _24[uint3(_77, _78, _68)] = float4(final_color, 0.0f);
#else
  float4 _324 = _14.SampleLevel(_38, float3((clamp((((((((_35_m0[5u].x + (-0.5f)) * _135) + 0.5f) * 2.0f) * _234) * ((_265 * (_258.x - _213)) + _213)) * (((_35_m0[2u].x + (-1.0f)) * _277) + 1.0f)) + (_35_m0[4u].x * _143), 0.0f, 1.0f) * 0.9375f) + 0.03125f, (clamp((((((((_35_m0[5u].y + (-0.5f)) * _135) + 0.5f) * 2.0f) * _234) * ((_265 * (_258.y - _214)) + _214)) * (((_35_m0[2u].y + (-1.0f)) * _277) + 1.0f)) + (_35_m0[4u].y * _143), 0.0f, 1.0f) * 0.9375f) + 0.03125f, (clamp((((((((_35_m0[5u].z + (-0.5f)) * _135) + 0.5f) * 2.0f) * _234) * ((_265 * (_258.z - _215)) + _215)) * (((_35_m0[2u].z + (-1.0f)) * _277) + 1.0f)) + (_35_m0[4u].z * _143), 0.0f, 1.0f) * 0.9375f) + 0.03125f), 0.0f);
  float _339 = (frac(sin(dot(float2(_89, _90), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f) * 0.0039215688593685626983642578125f) + (-0.00196078442968428134918212890625f);
  _24[uint3(_77, _78, _68)] = float4((_339 + _324.x) * _35_m0[11u].x, (_339 + _324.y) * _35_m0[11u].x, (_339 + _324.z) * _35_m0[11u].x, 0.0f);
#endif
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
