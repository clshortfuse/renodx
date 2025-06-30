#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Mon Feb 10 01:29:41 2025

cbuffer g_databuffer : register(b0)
{

  struct
  {
    float strengthx;
    float strengthy;
    float blend;
    float _pad;
  } g_data : packoffset(c0);

}

SamplerState g_source_sampler_s : register(s0);
Texture2D<float4> g_source_texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = -0.5 + v1.x;
  r0.xy = g_data.strengthx * abs(r0.xx);
  r0.xy = r0.xy * r0.xy;
  r0.x = r0.x + r0.y;

  r0.xy *= CUSTOM_CHROMATIC_ABERRATION;

  r0.yz = v1.xy + -r0.xx;
  r0.xw = v1.xy + r0.xx;
  r1.xyzw = g_source_texture.Sample(g_source_sampler_s, r0.xw).xyzw;
  r0.xyzw = g_source_texture.Sample(g_source_sampler_s, r0.yz).xyzw;
  r1.x = r0.x;
  r0.xyzw = g_source_texture.Sample(g_source_sampler_s, v1.xy).xyzw;
  r1.y = r0.y;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = g_data.blend * r1.xyz + r0.xyz;
  r0.xyz = v2.xyz * r0.xyz;
  o0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  o0.xyz = r0.xyz;

  // game isn't tonemapped, resources unclamp so just use o0.rgb
  float4 outputColor = renodx::color::srgb::DecodeSafe(o0.xyzw);
  if (RENODX_TONE_MAP_TYPE > 1.f) {
    outputColor = renodx::draw::ToneMapPass(outputColor);
  }
  outputColor = renodx::draw::RenderIntermediatePass(outputColor);
  o0.xyzw = outputColor;

  return;
}