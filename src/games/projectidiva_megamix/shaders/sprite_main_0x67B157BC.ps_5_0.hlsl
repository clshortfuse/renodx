// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 31 23:17:54 2025
#include "./common.hlsl"

SamplerState g_sampler_s : register(s0);
Texture2D<float4> g_texture : register(t0);


// 3Dmigoto declarations
#define cmp -

float Check(float2 uv) {
  //ignore bg sprites
  if (CALLBACK_TONEMAP_ISDRAWN < 0) return 1;

  //size
  float w;
  float h;
  g_texture.GetDimensions(w, h);

  //health bar
  if (
    (w == 2048.f && h == 512.f) && 
    CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(0,0), 0).x) &&
    CheckWhite(g_texture.SampleLevel(g_sampler_s, float2(0.2021f,0.1836f), 0).x) && 
    CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(0.4868f,0.8496f), 0).x) &&
    CheckWhite(g_texture.SampleLevel(g_sampler_s, float2(0.4331f,0.2168f), 0).x) 
  ) { return CUSTOM_HUDBRIGHTNESS_HEALTHBAR; }

  //held notes combo bg
  else if (
    (w == 1024.f && h == 2048.f) && 
    (uv.x >= 0 && uv.x <= 515.01f/1024.f) && (uv.y >= 1984/2048.f && uv.x <= 1) &&
    CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(0/1024.f, 0/2048.f), 0).x) &&
    CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(0/1024.f, 2/2048.f), 0).x) &&
    CheckWhite(g_texture.SampleLevel(g_sampler_s, float2(0/1024.f, 5/2048.f), 0).x) &&
    !CheckBlack(g_texture.SampleLevel(g_sampler_s, float2(0/1024.f, 8/2048.f), 0).x)
  ) { return CUSTOM_HUDBRIGHTNESS_HOLDCOMBOBG; }
 
  else return 1.f;
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  if (!CUSTOM_SPRITES_DRAW) discard;

  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = g_texture.SampleLevel(g_sampler_s, v2.xy, 0).yx;  
  r1.w = r0.x;
  r2.xy = g_texture.SampleLevel(g_sampler_s, v2.xy, 1).xy;
  r0.xz = r2.yx * float2(1.00392163,1.00392163) + float2(-0.503929257,-0.503929257);

  r1.x = dot(float2(1.57480001,1), r0.xy);
  r1.y = dot(float3(-0.468100011,1,-0.187299997), r0.xyz);
  r1.z = dot(float2(1,1.8556), r0.yz);

  o0.xyzw = v1.xyzw * r1.xyzw;
  
  o0.xyz *= Check(v2.xy);
  return;
}