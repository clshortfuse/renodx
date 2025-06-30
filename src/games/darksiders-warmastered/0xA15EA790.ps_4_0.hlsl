#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Mon Feb 10 01:39:43 2025

cbuffer g_databuffer : register(b0)
{

  struct
  {
    float4 projectionParams;
    float4 blurParams;
    float4 tintColor;
  } g_data : packoffset(c0);

}

SamplerState BlurredFrameBuffer_sampler_s : register(s0);
SamplerState FrameBuffer_sampler_s : register(s6);
SamplerState DepthBuffer_sampler_s : register(s7);
Texture2D<float4> BlurredFrameBuffer_texture : register(t0);
Texture2D<float4> FrameBuffer_texture : register(t6);
Texture2D<float4> DepthBuffer_texture : register(t7);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = DepthBuffer_texture.Sample(DepthBuffer_sampler_s, v1.xy).xyzw;
  r0.y = g_data.projectionParams.y * g_data.projectionParams.x;
  r0.x = g_data.projectionParams.x + r0.x;
  r0.x = r0.y / r0.x;
  r0.x = -g_data.projectionParams.z + r0.x;
  r0.x = -g_data.blurParams.x + abs(r0.x);
  r0.x = max(0, r0.x);
  r0.x = saturate(g_data.blurParams.y * r0.x);
  r0.x = g_data.blurParams.w * r0.x;
  r0.y = cmp(r0.x < 0.00999999978);


  if (r0.y != 0) {
    o0.xyzw = FrameBuffer_texture.Sample(FrameBuffer_sampler_s, v1.xy).xyzw;
    //return;
  } else {
    r1.xyzw = FrameBuffer_texture.Sample(FrameBuffer_sampler_s, v1.xy).xyzw;
    r2.xyzw = BlurredFrameBuffer_texture.Sample(BlurredFrameBuffer_sampler_s, v1.xy).xyzw;
    r2.xyzw = r2.xyzw + -r1.xyzw; //Depth blur
    o0.xyzw = r0.xxxx * r2.xyzw + r1.xyzw;
    //return;
  }

  // float3 outputColor;
  // if (RENODX_TONE_MAP_TYPE == 0.f) {
  //   outputColor = o0.rgb;
  // } else {
  //   outputColor = renodx::draw::ToneMapPass(ungraded);
  // }
  // outputColor += float3(1, 1, 1);
  //o0.rgb = renodx::draw::RenderIntermediatePass(outputColor);
  //o0.rgb = ungraded;
  return;
}