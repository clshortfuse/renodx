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
  float _145 = (((_28_m0[9u].x * _116.x) + _110.x) * _28_m0[7u].x) * _144;
  float _146 = (((_28_m0[9u].x * _116.y) + _110.y) * _28_m0[7u].y) * _144;
  float _147 = (((_28_m0[9u].x * _116.z) + _110.z) * _28_m0[7u].z) * _144;

#if 1
  float3 color_combined = float3(_145, _146, _147);
  float3 tonemapped = ApplyCustomHitmanToneMap(color_combined) * _28_m0[10u].y;
  float _185 = tonemapped.r, _186 = tonemapped.g, _187 = tonemapped.b;
#else
  float _148 = _145 * 0.60000002384185791015625f;
  float _163 = _146 * 0.60000002384185791015625f;
  float _172 = _147 * 0.60000002384185791015625f;
  float _185 = clamp((((((_148 + 0.100000001490116119384765625f) * _145) + 0.0040000001899898052215576171875f) / (((_148 + 1.0f) * _145) + 0.060000002384185791015625f)) + (-0.066666662693023681640625f)) * _28_m0[10u].y, 0.0f, 1.0f);
  float _186 = clamp((((((_163 + 0.100000001490116119384765625f) * _146) + 0.0040000001899898052215576171875f) / (((_163 + 1.0f) * _146) + 0.060000002384185791015625f)) + (-0.066666662693023681640625f)) * _28_m0[10u].y, 0.0f, 1.0f);
  float _187 = clamp((((((_172 + 0.100000001490116119384765625f) * _147) + 0.0040000001899898052215576171875f) / (((_172 + 1.0f) * _147) + 0.060000002384185791015625f)) + (-0.066666662693023681640625f)) * _28_m0[10u].y, 0.0f, 1.0f);
#endif

  float _206 = clamp(1.0f - (_28_m0[9u].y * frac(sin((_28_m0[10u].z + floor(_28_m0[9u].z * _53)) + ((_28_m0[10u].z + floor(_28_m0[9u].z * _54)) * 0.0129898004233837127685546875f)) * 43758.546875f)), 0.0f, 1.0f);
  float4 _208 = _14.SampleLevel(_31, float2(_91, _92), 0.0f);
  float _212 = _208.w;
  float4 _234 = _15.SampleLevel(_32, float2(((mad(_28_m0[3u].y + _208.x, 2.0f, -1.0f) * _212) * _28_m0[2u].w) + _91, ((mad(_28_m0[3u].y + _208.y, 2.0f, -1.0f) * _212) * _28_m0[2u].w) + _92), 0.0f);
  float _241 = clamp(_28_m0[3u].z * _212, 0.0f, 1.0f);
  float _253 = clamp(_28_m0[3u].x * _212, 0.0f, 1.0f);

#if 1
  float3 lut_input_preoffset = float3(
      (((((((_28_m0[5u].x - 0.5f) * _83) + 0.5f) * 2.0f) * _206) * ((_241 * (_234.x - _185)) + _185)) * (((_28_m0[2u].x - 1.0f) * _253) + 1.0f)) + (_28_m0[4u].x * _84),
      (((((((_28_m0[5u].y - 0.5f) * _83) + 0.5f) * 2.0f) * _206) * ((_241 * (_234.y - _186)) + _186)) * (((_28_m0[2u].y - 1.0f) * _253) + 1.0f)) + (_28_m0[4u].y * _84),
      (((((((_28_m0[5u].z - 0.5f) * _83) + 0.5f) * 2.0f) * _206) * ((_241 * (_234.z - _187)) + _187)) * (((_28_m0[2u].z - 1.0f) * _253) + 1.0f)) + (_28_m0[4u].z * _84));

  float3 final_color = ToneMapMaxCLLAndSampleGamma2LUT16AndFinalizeOutput(lut_input_preoffset, _12, _31, _28_m0[8u].y, _63, _64, _28_m0[11u].x);
  _22[uint2(gl_GlobalInvocationID.xy)] = float4(final_color, 0.f);
#else
  float4 _306 = _12.SampleLevel(_31, float3((sqrt(clamp((((((((_28_m0[5u].x + (-0.5f)) * _83) + 0.5f) * 2.0f) * _206) * ((_241 * (_234.x - _185)) + _185)) * (((_28_m0[2u].x + (-1.0f)) * _253) + 1.0f)) + (_28_m0[4u].x * _84), 0.0f, 1.0f)) * 0.9375f) + 0.03125f, (sqrt(clamp((((((((_28_m0[5u].y + (-0.5f)) * _83) + 0.5f) * 2.0f) * _206) * ((_241 * (_234.y - _186)) + _186)) * (((_28_m0[2u].y + (-1.0f)) * _253) + 1.0f)) + (_28_m0[4u].y * _84), 0.0f, 1.0f)) * 0.9375f) + 0.03125f, (sqrt(clamp((((((((_28_m0[5u].z + (-0.5f)) * _83) + 0.5f) * 2.0f) * _206) * ((_241 * (_234.z - _187)) + _187)) * (((_28_m0[2u].z + (-1.0f)) * _253) + 1.0f)) + (_28_m0[4u].z * _84), 0.0f, 1.0f)) * 0.9375f) + 0.03125f), 0.0f);
  float _322 = (frac(sin(dot(float2(_63, _64), float2(12.98980045318603515625f, 78.233001708984375f))) * 43758.546875f) * 0.0039215688593685626983642578125f) + (-0.00196078442968428134918212890625f);
  _22[uint2(gl_GlobalInvocationID.xy)] = float4((_322 + _306.x) * _28_m0[11u].x, (_322 + _306.y) * _28_m0[11u].x, (_322 + _306.z) * _28_m0[11u].x, 0.0f);
#endif
}

[numthreads(8, 8, 1)]
void main(SPIRV_Cross_Input stage_input) {
  gl_GlobalInvocationID = stage_input.gl_GlobalInvocationID;
  comp_main();
}
