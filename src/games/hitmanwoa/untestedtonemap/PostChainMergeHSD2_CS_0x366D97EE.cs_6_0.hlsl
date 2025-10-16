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

  float3 color_bloomed = ScaleBloom(_162.rgb, _170.rgb, _35_m0[9u].x);

  float _201 = (color_bloomed.r * _35_m0[7u].x) * _200;
  float _202 = (color_bloomed.g * _35_m0[7u].y) * _200;
  float _203 = (color_bloomed.b * _35_m0[7u].z) * _200;

#if 1
  float3 color_combined = float3(_201, _202, _203);
  float3 tonemapped = ApplyCustomHitmanToneMap(color_combined) * _35_m0[10u].y;
  float _239 = tonemapped.r, _240 = tonemapped.g, _241 = tonemapped.b;
#else
  float _204 = _201 * 0.60000002384185791015625f;
  float _218 = _202 * 0.60000002384185791015625f;
  float _227 = _203 * 0.60000002384185791015625f;
  float _239 = clamp((((((_204 + 0.100000001490116119384765625f) * _201) + 0.0040000001899898052215576171875f) / (((_204 + 1.0f) * _201) + 0.060000002384185791015625f)) + (-0.066666662693023681640625f)) * _35_m0[10u].y, 0.0f, 1.0f);
  float _240 = clamp((((((_218 + 0.100000001490116119384765625f) * _202) + 0.0040000001899898052215576171875f) / (((_218 + 1.0f) * _202) + 0.060000002384185791015625f)) + (-0.066666662693023681640625f)) * _35_m0[10u].y, 0.0f, 1.0f);
  float _241 = clamp((((((_227 + 0.100000001490116119384765625f) * _203) + 0.0040000001899898052215576171875f) / (((_227 + 1.0f) * _203) + 0.060000002384185791015625f)) + (-0.066666662693023681640625f)) * _35_m0[10u].y, 0.0f, 1.0f);
#endif

  float _260 = clamp(1.0f - (_35_m0[9u].y * frac(sin((_35_m0[10u].z + floor(_35_m0[9u].z * _79)) + ((_35_m0[10u].z + floor(_35_m0[9u].z * _80)) * 0.0129898004233837127685546875f)) * 43758.546875f)), 0.0f, 1.0f);
  float4 _262 = _15.SampleLevel(_38, float2(_89, _90), 0.0f);
  float _266 = _262.w;
  float4 _284 = _16.SampleLevel(_39, float2(((mad(_35_m0[3u].y + _262.x, 2.0f, -1.0f) * _266) * _35_m0[2u].w) + _89, ((mad(_35_m0[3u].y + _262.y, 2.0f, -1.0f) * _266) * _35_m0[2u].w) + _90), 0.0f);
  float _291 = clamp(_35_m0[3u].z * _266, 0.0f, 1.0f);
  float _303 = clamp(_35_m0[3u].x * _266, 0.0f, 1.0f);

#if 1
  float3 lut_input_preoffset = float3(
      (((((((_35_m0[5u].x - 0.5f) * _135) + 0.5f) * 2.0f) * _260) * ((_291 * (_284.x - _239)) + _239)) * (((_35_m0[2u].x - 1.0f) * _303) + 1.0f)) + (_35_m0[4u].x * _143),
      (((((((_35_m0[5u].y - 0.5f) * _135) + 0.5f) * 2.0f) * _260) * ((_291 * (_284.y - _240)) + _240)) * (((_35_m0[2u].y - 1.0f) * _303) + 1.0f)) + (_35_m0[4u].y * _143),
      (((((((_35_m0[5u].z - 0.5f) * _135) + 0.5f) * 2.0f) * _260) * ((_291 * (_284.z - _241)) + _241)) * (((_35_m0[2u].z - 1.0f) * _303) + 1.0f)) + (_35_m0[4u].z * _143));
  float3 final_color = ToneMapMaxCLLAndSampleGamma2LUT16AndFinalizeOutput(lut_input_preoffset, _14, _38, _35_m0[8u].y, _89, _90, _35_m0[11u].x);
  _24[uint3(_77, _78, _68)] = float4(final_color, 0.f);
#else
  float4 _353 = _14.SampleLevel(_38, float3((sqrt(clamp((((((((_35_m0[5u].x + (-0.5f)) * _135) + 0.5f) * 2.0f) * _260) * ((_291 * (_284.x - _239)) + _239)) * (((_35_m0[2u].x + (-1.0f)) * _303) + 1.0f)) + (_35_m0[4u].x * _143), 0.0f, 1.0f)) * 0.9375f) + 0.03125f, (sqrt(clamp((((((((_35_m0[5u].y + (-0.5f)) * _135) + 0.5f) * 2.0f) * _260) * ((_291 * (_284.y - _240)) + _240)) * (((_35_m0[2u].y + (-1.0f)) * _303) + 1.0f)) + (_35_m0[4u].y * _143), 0.0f, 1.0f)) * 0.9375f) + 0.03125f, (sqrt(clamp((((((((_35_m0[5u].z + (-0.5f)) * _135) + 0.5f) * 2.0f) * _260) * ((_291 * (_284.z - _241)) + _241)) * (((_35_m0[2u].z + (-1.0f)) * _303) + 1.0f)) + (_35_m0[4u].z * _143), 0.0f, 1.0f)) * 0.9375f) + 0.03125f), 0.0f);
  float _368 = (frac(sin(dot(float2(_89, _90), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f) * 0.0039215688593685626983642578125f) + (-0.00196078442968428134918212890625f);
  _24[uint3(_77, _78, _68)] = float4((_368 + _353.x) * _35_m0[11u].x, (_368 + _353.y) * _35_m0[11u].x, (_368 + _353.z) * _35_m0[11u].x, 0.0f);
#endif
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
