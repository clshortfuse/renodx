// ---- Created with 3Dmigoto v1.3.16 on Mon Aug 11 22:54:38 2025
#include "./common.hlsl"

SamplerState g_sampler_s : register(s0);
Texture2D<float4> g_texture : register(t0);


// 3Dmigoto declarations
#define cmp -

bool Check() { //TODO upgrade to out float multiplier if needed
  //ignore bg sprites
  if (CALLBACK_TONEMAP_ISDRAWN < 0) return false;

  //size
  float w;
  float h;
  g_texture.GetDimensions(w, h);

  return 
  (
    //hit response 1
    (
      (w == 1024.f && h == 1024.f) && 
      CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(0,0), 0).xyz) &&
      CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(190/1024.f, 290/1024.f), 0).xyz) &&
      !CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(195/1024.f, 318/1024.f), 0).xyz) &&
      CheckWhite(g_texture.SampleLevel(g_sampler_s, float2(215/1024.f, 788/1024.f), 0).xyz) &&
      CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(206/1024.f, 922/1024.f), 0).xyz)
    )
    ||
    //hit response 2
    (
      (w == 2048.f && h == 1024.f) && 
      CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(0,0), 0).xyz) &&
      CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(112/2048.f, 168/1024.f), 0).xyz) &&
      !CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(107/2048.f, 193/1024.f), 0).xyz) &&
      CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(103/2048.f, 217/1024.f), 0).xyz) &&
      CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(129/2048.f, 366/1024.f), 0).xyz) &&
      !CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(105/2048.f, 372/1024.f), 0).xyz)
    )
  );
}

//notes spawn and hit
void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_SPRITES_DRAW) discard;

  r0.xyzw = g_texture.Sample(g_sampler_s, v2.xy).xyzw;
  r0.xyzw = v1.xyzw * r0.xyzw;
  o0.xyzw = r0.xyzw;

  if (Check()) o0.xyzw *= CUSTOM_HUDBRIGHTNESS_NOTERESPONSE;
  return;
}