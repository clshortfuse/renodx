#include "./common.hlsl"

cbuffer g_constantsbuffer : register(b0) {
  struct
  {
    float4 transition_amounts;
    float4 raw_uv_adjust;
    float4 color_transition;
    float4 brightness_factor;
  }
g_constants:
  packoffset(c0);
}
SamplerState g_correctionSampler0_sampler_s : register(s0);
SamplerState g_correctionSampler1_sampler_s : register(s1);
SamplerState g_correctionSampler2_sampler_s : register(s2);
SamplerState g_correctionSampler3_sampler_s : register(s3);
Texture3D<float4> g_correctionSampler0_texture : register(t0);
Texture3D<float4> g_correctionSampler1_texture : register(t1);
Texture3D<float4> g_correctionSampler2_texture : register(t2);
Texture3D<float4> g_correctionSampler3_texture : register(t3);

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = frac(v1.xy);
  r0.w = v1.x + -r0.x;
  r0.z = r0.w * g_constants.raw_uv_adjust.x + g_constants.raw_uv_adjust.y;
  r1.xyzw = g_correctionSampler3_texture.Sample(g_correctionSampler3_sampler_s, r0.xyz).xyzw;
  r2.xyzw = g_correctionSampler2_texture.Sample(g_correctionSampler2_sampler_s, r0.xyz).xyzw;
  r1.xyz = -r2.xyz + r1.xyz;
  r1.xyz = g_constants.transition_amounts.xxx * r1.xyz + r2.xyz;
  r2.xyzw = g_correctionSampler1_texture.Sample(g_correctionSampler1_sampler_s, r0.xyz).xyzw;
  r0.xyzw = g_correctionSampler0_texture.Sample(g_correctionSampler0_sampler_s, r0.xyz).xyzw;
  r2.xyz = r2.xyz + -r0.xyz;
  r0.xyz = g_constants.transition_amounts.xxx * r2.xyz + r0.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = g_constants.transition_amounts.yyy * r1.xyz + r0.xyz;
  r0.w = renodx::color::y::from::BT709(r0.rgb);
  float3 preFlash = r0.rgb;
  r0.xyz = g_constants.color_transition.www * r0.xyz;
  r0.w = r0.w * g_constants.brightness_factor.y + g_constants.brightness_factor.z;
  r0.xyz = r0.www * g_constants.color_transition.xyz + r0.xyz;
  r0.rgb = lerp(preFlash, r0.rgb, injectedData.fxFlash);
  o0.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  o0.xyz = r0.xyz;
  return;
}
