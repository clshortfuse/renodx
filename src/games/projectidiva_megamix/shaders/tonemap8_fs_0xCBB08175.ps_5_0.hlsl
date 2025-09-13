// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 02 15:46:11 2025
#include "./common.hlsl"

cbuffer ToneMap : register(b1)
{
  float4 g_exposure : packoffset(c0);
  float4 g_fade_color : packoffset(c1);
  float4 g_tone_scale : packoffset(c2);
  float4 g_tone_offset : packoffset(c3);
  float4 g_texcoord_transforms[4] : packoffset(c4);
}

SamplerState g_samplers_0__s : register(s0);
SamplerState g_samplers_1__s : register(s1);
SamplerState g_samplers_6__s : register(s6);
SamplerState g_scene_depth_sampler_s : register(s10);
Texture2D<float4> g_textures_0_ : register(t0);
Texture2D<float4> g_textures_1_ : register(t1);
Texture2D<float4> g_textures_6_ : register(t6);
Texture2D<float4> g_scene_depth_texture : register(t10);


// 3Dmigoto declarations
#define cmp -

//Color + Bloom + Sprites (Depth based select) + Tonemap (Simple) + Fade
//Catch the Wave: to not bloom bg
void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 colorUntonemapped, colorTonemapped;
  float colorUntonemappedMask;

  r0.w = g_scene_depth_texture.Sample(g_scene_depth_sampler_s, v1.xy).x; //depth
  r0.w = cmp(0 >= r0.w);

  r0.xyz = g_textures_6_.Sample(g_samplers_6__s, v1.xy).xyz; //sprites (eww, it's shifted because )
  r0.xyz = saturate(r0.xyz); //fix

  r1.xyzw = g_textures_0_.Sample(g_samplers_0__s, v1.xy).xyzw; //color
  colorUntonemappedMask = r1.w;

  r2.x = min(1, r1.w);
  r2.y = 1 + -r2.x;
  r2.x = cmp(r2.x >= 0);
  r2.z = 0.479999989 * v3.x; //exposure?
  r1.xyz = r2.zzz * r1.xyz;

  o0.w = r1.w; //out w

  r0.xyz = r0.xyz * r2.yyy + r1.xyz; //sprites * color + color
  r0.xyz = r2.xxx ? r0.xyz : r1.xyz;
  r0.xyz = r0.www ? r0.xyz : r1.xyz;

  r1.xyz = g_textures_1_.Sample(g_samplers_1__s, v1.zw).xyz; //bloom
  r1 = Tonemap_BloomMultiplier(r1);

  r1.xyz = r1.xyz * r2.zzz + r0.xyz;

  colorUntonemapped = r1.xyz;

  Tonemap_SaveSprites(colorUntonemapped, colorUntonemappedMask, r0.xyz, v1.xy);

  //tonemap
  r1.xyz = min(float3(0.959999979,0.959999979,0.959999979), r1.xyz); //clamp
  r0.w = cmp(0 < v3.z);
  r0.xyz = r0.www ? r1.xyz : r0.xyz;
  r0.xyz = saturate(r0.xyz * g_tone_scale.xyz + g_tone_offset.xyz); //clamp

  //fade + out
  r1.xyz = g_fade_color.xyz + -r0.xyz;
  r1.xyz = g_fade_color.www * r1.xyz + r0.xyz;
  r2.xyz = g_fade_color.xyz + r0.xyz;
  r3.xyz = g_fade_color.xyz * r0.xyz;
  r4.xy = cmp(g_tone_scale.ww == float2(0,2));
  r2.xyz = r4.yyy ? r2.xyz : r3.xyz;
  r1.xyz = r4.xxx ? r1.xyz : r2.xyz;
  r0.w = cmp(0 < g_fade_color.w);
  o0.xyz = r0.www ? r1.xyz : r0.xyz;

  //ToneMapPass
  colorTonemapped = o0.xyz;
  o0.xyz = Tonemap_Do(colorUntonemapped, colorTonemapped, v1.xy, g_textures_0_);
  //if (CUSTOM_TONEMAP_IDENTIFY == 1) o0.xyz = DrawBinary(8, o0.xyz, v1.xy);
  return;
}