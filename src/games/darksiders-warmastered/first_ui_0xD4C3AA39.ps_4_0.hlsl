#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Mon Feb 10 03:30:02 2025

cbuffer g_fragment_databuffer : register(b0)
{

  struct
  {
    float4 cxmul;
    float4 cxadd;
  } g_fragment_data : packoffset(c0);

}

SamplerState tex0_sampler_s : register(s0);
Texture2D<float4> tex0_texture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = tex0_texture.Sample(tex0_sampler_s, v1.xy).xyzw;

  // float3 gameOutput = r0.rgb;

  // // game isn't tonemapped, resources unclamp so just use o0.rgb
  // if (RENODX_TONE_MAP_TYPE != 0.f) {
  //   gameOutput = renodx::draw::ToneMapPass(gameOutput);
  //   r0.rgb = renodx::draw::RenderIntermediatePass(gameOutput);
  // } 

  //UI stuff

  r0.xyzw = -v2.xyzw + r0.xyzw;
  r0.xyzw = v3.zzzz * r0.xyzw + v2.xyzw;
  r0.xyzw = r0.xyzw * g_fragment_data.cxmul.xyzw + g_fragment_data.cxadd.xyzw;
  o0.w = v3.w * r0.w;
  o0.xyz = r0.xyz;
  return;
}