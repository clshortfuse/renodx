#include "../common.hlsli"

cbuffer _26_28 : register(b2, space0) {
  float4 _28_m0[154] : packoffset(c0);
};

cbuffer _31_33 : register(b5, space0) {
  float4 _33_m0[13] : packoffset(c0);
};

Texture2DArray<float4> _8 : register(t0, space0);
Texture2D<float4> _11 : register(t1, space0);
Texture3D<float4> _14 : register(t2, space0);
Buffer<uint4> _18 : register(t6, space0);
Buffer<uint4> _19 : register(t7, space0);
RWTexture2DArray<float4> _22 : register(u0, space0);
SamplerState _36 : register(s4, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_WorkGroupID : SV_GroupID;
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

void comp_main() {
  uint4 _58 = _19.Load(gl_WorkGroupID.x);
  uint _59 = _58.x;
  uint _60 = _59 >> 20u;
  uint _62 = _60 & 1023u;
  uint _71 = ((_59 << 3u) & 8184u) + gl_LocalInvocationID.x;
  uint _72 = ((_59 >> 7u) & 8184u) + gl_LocalInvocationID.y;
  float _73 = float(int(_71));
  float _74 = float(int(_72));
  float _83 = (_73 + 0.5f) * _33_m0[0u].x;
  float _84 = (_74 + 0.5f) * _33_m0[0u].y;
  bool _88 = (_60 & 2u) == 0u;
  float _102 = _88 ? _84 : (((_84 + (-0.5f)) * _28_m0[103u].y) + 0.5f);
  float _110 = mad(_88 ? _83 : (((_83 + (-0.5f)) * _28_m0[103u].x) + 0.5f), 2.0f, -1.0f);
  float _113 = mad(_102, 2.0f, -1.0f);
  float _123 = clamp((sqrt((_113 * _113) + (_110 * _110)) - _33_m0[6u].x) / (_33_m0[6u].y - _33_m0[6u].x), 0.0f, 1.0f);
  float _129 = ((_123 * _123) * _33_m0[6u].z) * (3.0f - (_123 * 2.0f));
  float _136 = 1.0f - clamp(_102 * _33_m0[4u].w, 0.0f, 1.0f);
  float _137 = _136 * _136;
  float4 _156 = _8.SampleLevel(_36, float3(_83, _84, float(_62)), 0.0f);
  float4 _164 = _11.SampleLevel(_36, float2(_83, _84), 0.0f);
  float _194 = asfloat(_18.Load(5u).x);

  float3 color_bloomed = ScaleBloom(_156.rgb, _164.rgb, _33_m0[9u].x);

  float _195 = (color_bloomed.r * _33_m0[7u].x) * _194;
  float _196 = (color_bloomed.g * _33_m0[7u].y) * _194;
  float _197 = (color_bloomed.b * _33_m0[7u].z) * _194;

  float3 color_combined = float3(_195, _196, _197);

  float _228 = clamp(1.0f - (_33_m0[9u].y * frac(sin((_33_m0[10u].z + floor(_33_m0[9u].z * _73)) + ((_33_m0[10u].z + floor(_33_m0[9u].z * _74)) * 0.0129898004233837127685546875f)) * 43758.546875f)), 0.0f, 1.0f);

#if 1
  float3 tonemapped = ApplyCustomSimpleReinhardToneMap(color_combined);

  tonemapped = float3(
      (_33_m0[4u].x * _137) + (((((_33_m0[5u].x - 0.5f) * _129) + 0.5f) * 2.0f) * tonemapped.r * _33_m0[10u].y * _228),
      (_33_m0[4u].y * _137) + (((((_33_m0[5u].y - 0.5f) * _129) + 0.5f) * 2.0f) * tonemapped.g * _33_m0[10u].y * _228),
      (_33_m0[4u].z * _137) + (((((_33_m0[5u].z - 0.5f) * _129) + 0.5f) * 2.0f) * tonemapped.b * _33_m0[10u].y * _228));

  float3 final_color = ToneMapMaxCLLAndSampleLinearLUT16AndFinalizeOutput(tonemapped, _14, _36, _33_m0[8u].y, _83, _84, _33_m0[11u].x);
  _22[uint3(_71, _72, _62)] = float4(final_color, 0.f);
#else
  float4 _260 = _14.SampleLevel(_36, float3((clamp((_33_m0[4u].x * _137) + ((((((_33_m0[5u].x + (-0.5f)) * _129) + 0.5f) * 2.0f) * clamp((_195 / (_195 + 1.0f)) * _33_m0[10u].y, 0.0f, 1.0f)) * _228), 0.0f, 1.0f) * 0.9375f) + 0.03125f, (clamp((_33_m0[4u].y * _137) + ((((((_33_m0[5u].y + (-0.5f)) * _129) + 0.5f) * 2.0f) * clamp((_196 / (_196 + 1.0f)) * _33_m0[10u].y, 0.0f, 1.0f)) * _228), 0.0f, 1.0f) * 0.9375f) + 0.03125f, (clamp((_33_m0[4u].z * _137) + ((((((_33_m0[5u].z + (-0.5f)) * _129) + 0.5f) * 2.0f) * clamp((_197 / (_197 + 1.0f)) * _33_m0[10u].y, 0.0f, 1.0f)) * _228), 0.0f, 1.0f) * 0.9375f) + 0.03125f), 0.0f);
  float _275 = (frac(sin(dot(float2(_83, _84), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f) * 0.0039215688593685626983642578125f) + (-0.00196078442968428134918212890625f);
  _22[uint3(_71, _72, _62)] = float4((_275 + _260.x) * _33_m0[11u].x, (_275 + _260.y) * _33_m0[11u].x, (_275 + _260.z) * _33_m0[11u].x, 0.0f);
#endif
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
