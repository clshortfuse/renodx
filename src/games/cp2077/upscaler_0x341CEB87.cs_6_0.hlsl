// Upscaler

#include "./cp2077.h"

cbuffer _16_18 : register(b6, space0) { float4 _18_m0[1] : packoffset(c0); }

Texture2D<float4> _8 : register(t0, space0);
RWTexture2D<float4> _11 : register(u0, space0);

static uint3 gl_WorkGroupID;
static uint3 gl_LocalInvocationID;

struct SPIRV_Cross_Input {
  uint3 gl_WorkGroupID : SV_GroupID;
  uint3 gl_LocalInvocationID : SV_GroupThreadID;
};

void comp_main() {
  uint _44 = ((gl_LocalInvocationID.x >> 1u) & 7u) | (gl_WorkGroupID.x << 3u);
  uint _45 = (((gl_LocalInvocationID.x >> 3u) & 6u) | (gl_LocalInvocationID.x & 1u)) | (gl_WorkGroupID.y << 3u);
  float4 _54 = _8.Load(int3(uint2(_44, _45 + 4294967295u), 0u));
  float4 _61 = _8.Load(int3(uint2(_44 + 4294967295u, _45), 0u));
  float4 _66 = _8.Load(int3(uint2(_44, _45), 0u));
  float4 _72 = _8.Load(int3(uint2(_44 + 1u, _45), 0u));
  float4 _78 = _8.Load(int3(uint2(_44, _45 + 1u), 0u));

  // Keep BT2020 colors

  _54.rgb = renodx::color::ap1::from::BT709(_54.rgb);
  _61.rgb = renodx::color::ap1::from::BT709(_61.rgb);
  _66.rgb = renodx::color::ap1::from::BT709(_66.rgb);
  _72.rgb = renodx::color::ap1::from::BT709(_72.rgb);
  _78.rgb = renodx::color::ap1::from::BT709(_78.rgb);

  float _86 = sqrt(max(0.0f, _54.x));
  float _88 = sqrt(max(0.0f, _54.y));
  float _90 = sqrt(max(0.0f, _54.z));
  float _92 = sqrt(max(0.0f, _61.x));
  float _94 = sqrt(max(0.0f, _61.y));
  float _96 = sqrt(max(0.0f, _61.z));
  float _104 = sqrt(max(0.0f, _72.x));
  float _106 = sqrt(max(0.0f, _72.y));
  float _108 = sqrt(max(0.0f, _72.z));
  float _110 = sqrt(max(0.0f, _78.x));
  float _112 = sqrt(max(0.0f, _78.y));
  float _114 = sqrt(max(0.0f, _78.z));

  float _117 = min(min(_86, min(_92, _104)), _110);
  float _120 = min(min(_88, min(_94, _106)), _112);
  float _123 = min(min(_90, min(_96, _108)), _114);
  float _126 = max(max(_86, max(_92, _104)), _110);
  float _129 = max(max(_88, max(_94, _106)), _112);
  float _132 = max(max(_90, max(_96, _108)), _114);
  float _171 = max(
                   -0.1875f,
                   min(
                       max(
                           max((-0.0f) - (_117 * (0.25f / _126)), (1.0f / ((_117 * 4.0f) + (-4.0f))) * (1.0f - _126)),
                           max(
                               max((-0.0f) - (_120 * (0.25f / _129)), (1.0f / ((_120 * 4.0f) + (-4.0f))) * (1.0f - _129)),
                               max((-0.0f) - (_123 * (0.25f / _132)), (1.0f / ((_123 * 4.0f) + (-4.0f))) * (1.0f - _132)))),
                       0.0f))
               * asfloat(asuint(_18_m0[0u]).x);
  float _173 = (_171 * 4.0f) + 1.0f;
  float _177 = asfloat(2129764351u - asuint(_173));
  float _181 = (2.0f - (_177 * _173)) * _177;
  float _187 = _181 * ((_171 * (((_92 + _86) + _104) + _110)) + sqrt(max(0.0f, _66.x)));
  float _193 = _181 * ((_171 * (((_94 + _88) + _106) + _112)) + sqrt(max(0.0f, _66.y)));
  float _199 = _181 * ((_171 * (((_96 + _90) + _108) + _114)) + sqrt(max(0.0f, _66.z)));
  float3 outputColor = float3(_187 * _187, _193 * _193, _199 * _199);
  outputColor = renodx::color::bt709::from::AP1(outputColor);

  _11[uint2(_44, _45)] = float4(outputColor.rgb, 1.0f);
}

[numthreads(64, 1, 1)] void main(SPIRV_Cross_Input stage_input) {
  gl_WorkGroupID = stage_input.gl_WorkGroupID;
  gl_LocalInvocationID = stage_input.gl_LocalInvocationID;
  comp_main();
}
