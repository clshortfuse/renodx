#include "../common.hlsli"

cbuffer _26_28 : register(b5, space0) {
  float4 _28_m0[13] : packoffset(c0);
};

Texture2D<float4> _8 : register(t0, space0);
Texture2D<float4> _9 : register(t1, space0);
Texture3D<float4> _12 : register(t2, space0);
Texture2D<float4> _13 : register(t3, space0);
Texture2D<float4> _14 : register(t4, space0);
Texture2D<float4> _15 : register(t5, space0);
Buffer<uint4> _19 : register(t6, space0);
RWTexture2D<float4> _22 : register(u0, space0);
SamplerState _31 : register(s4, space0);
SamplerState _32 : register(s6, space0);

static uint3 gl_GlobalInvocationID;
struct SPIRV_Cross_Input {
  uint3 gl_GlobalInvocationID : SV_DispatchThreadID;
};

void comp_main() {
  float _53 = float(int(gl_GlobalInvocationID.x));
  float _54 = float(int(gl_GlobalInvocationID.y));
  float _63 = _28_m0[0u].x * (_53 + 0.5f);
  float _64 = (_54 + 0.5f) * _28_m0[0u].y;
  float4 _78 = _13.SampleLevel(_31, float2((_63 * _28_m0[1u].x) + _28_m0[1u].z, (_64 * _28_m0[1u].y) + _28_m0[1u].w), 0.0f);
  float _83 = _78.z;
  float _84 = _78.w;
  float _91 = (_28_m0[10u].w * _78.x) + _63;
  float _92 = (_28_m0[10u].w * _78.y) + _64;
  float4 _110 = _8.SampleLevel(_31, float2(_91, _92), 0.0f);
  float4 _116 = _9.SampleLevel(_31, float2(_91, _92), 0.0f);
  float _144 = asfloat(_19.Load(5u).x);

  float3 color_bloomed = ScaleBloom(_110.rgb, _116.rgb, _28_m0[9u].x);

  // bloom
  float _145 = (color_bloomed.r * _28_m0[7u].x) * _144;
  float _146 = (color_bloomed.g * _28_m0[7u].y) * _144;
  float _147 = (color_bloomed.b * _28_m0[7u].z) * _144;

  float3 color_combined = float3(_145, _146, _147);

#if 1
  float3 tonemapped = ApplyCustomSimpleReinhardToneMap(color_combined) * _28_m0[10u].y;
  float _159 = tonemapped.r, _160 = tonemapped.g, _161 = tonemapped.b;
#else
  float _159 = clamp((_145 / (_145 + 1.0f)) * _28_m0[10u].y, 0.0f, 1.0f);
  float _160 = clamp((_146 / (_146 + 1.0f)) * _28_m0[10u].y, 0.0f, 1.0f);
  float _161 = clamp((_147 / (_147 + 1.0f)) * _28_m0[10u].y, 0.0f, 1.0f);
#endif

  float _180 = clamp(1.0f - (_28_m0[9u].y * frac(sin((_28_m0[10u].z + floor(_28_m0[9u].z * _53)) + ((_28_m0[10u].z + floor(_28_m0[9u].z * _54)) * 0.0129898004233837127685546875f)) * 43758.546875f)), 0.0f, 1.0f);
  float4 _182 = _14.SampleLevel(_31, float2(_91, _92), 0.0f);
  float _186 = _182.w;
  float4 _208 = _15.SampleLevel(_32, float2(((mad(_28_m0[3u].y + _182.x, 2.0f, -1.0f) * _186) * _28_m0[2u].w) + _91, ((mad(_28_m0[3u].y + _182.y, 2.0f, -1.0f) * _186) * _28_m0[2u].w) + _92), 0.0f);
  float _215 = clamp(_28_m0[3u].z * _186, 0.0f, 1.0f);
  float _227 = clamp(_28_m0[3u].x * _186, 0.0f, 1.0f);

#if 1
  float3 lut_input_preoffset = float3(
      ((((((((_28_m0[5u].x - 0.5f) * _83) + 0.5f) * 2.0f) * _180) * ((_215 * (_208.x - _159)) + _159)) * (((_28_m0[2u].x - 1.0f) * _227) + 1.0f)) + (_28_m0[4u].x * _84)),
      ((((((((_28_m0[5u].y - 0.5f) * _83) + 0.5f) * 2.0f) * _180) * ((_215 * (_208.y - _160)) + _160)) * (((_28_m0[2u].y - 1.0f) * _227) + 1.0f)) + (_28_m0[4u].y * _84)),
      ((((((((_28_m0[5u].z - 0.5f) * _83) + 0.5f) * 2.0f) * _180) * ((_215 * (_208.z - _161)) + _161)) * (((_28_m0[2u].z - 1.0f) * _227) + 1.0f)) + (_28_m0[4u].z * _84)));

  float3 final_color = ToneMapMaxCLLAndSampleLinearLUT16AndFinalizeOutput(lut_input_preoffset, _12, _31, _28_m0[8u].y, _63, _64, _28_m0[11u].x);
  _22[uint2(gl_GlobalInvocationID.xy)] = float4(final_color, 0.0f);
#else
  float4 _277 = _12.SampleLevel(_31, float3((clamp((((((((_28_m0[5u].x + (-0.5f)) * _83) + 0.5f) * 2.0f) * _180) * ((_215 * (_208.x - _159)) + _159)) * (((_28_m0[2u].x + (-1.0f)) * _227) + 1.0f)) + (_28_m0[4u].x * _84), 0.0f, 1.0f) * 0.9375f) + 0.03125f, (clamp((((((((_28_m0[5u].y + (-0.5f)) * _83) + 0.5f) * 2.0f) * _180) * ((_215 * (_208.y - _160)) + _160)) * (((_28_m0[2u].y + (-1.0f)) * _227) + 1.0f)) + (_28_m0[4u].y * _84), 0.0f, 1.0f) * 0.9375f) + 0.03125f, (clamp((((((((_28_m0[5u].z + (-0.5f)) * _83) + 0.5f) * 2.0f) * _180) * ((_215 * (_208.z - _161)) + _161)) * (((_28_m0[2u].z + (-1.0f)) * _227) + 1.0f)) + (_28_m0[4u].z * _84), 0.0f, 1.0f) * 0.9375f) + 0.03125f), 0.0f);
  float _293 = (frac(sin(dot(float2(_63, _64), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f) * 0.0039215688593685626983642578125f) + (-0.00196078442968428134918212890625f);
  _22[uint2(gl_GlobalInvocationID.x, gl_GlobalInvocationID.y)] = float4((_293 + _277.x) * _28_m0[11u].x, (_293 + _277.y) * _28_m0[11u].x, (_293 + _277.z) * _28_m0[11u].x, 0.0f);
#endif
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
