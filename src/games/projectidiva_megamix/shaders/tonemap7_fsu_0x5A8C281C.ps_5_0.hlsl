// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 02 15:46:07 2025
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
SamplerState g_samplers_4__s : register(s4);
SamplerState g_samplers_5__s : register(s5);
SamplerState g_samplers_6__s : register(s6);
SamplerState g_samplers_7__s : register(s7);
Texture2D<float4> g_textures_0_ : register(t0);
Texture2D<float4> g_textures_1_ : register(t1);
Texture2D<float4> g_textures_4_ : register(t4);
Texture2D<float4> g_textures_5_ : register(t5);
Texture2D<float4> g_textures_6_ : register(t6);
Texture2D<float4> g_textures_7_ : register(t7);


// 3Dmigoto declarations
#define cmp -


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

  //color + bloom
  r0.xyzw = g_textures_0_.Sample(g_samplers_0__s, v1.xy).xyzw;
  colorUntonemappedMask = r0.w;

  r1.xyz = g_textures_1_.Sample(g_samplers_1__s, v1.zw).xyz;
  r1.w = cmp(0 < v3.z);
  r1.xyz = r1.xyz + r0.xyz;
  r0.xyz = r1.www ? r1.xyz : r0.xyz;

  colorUntonemapped = r0.xyz;

  //idk
  r1.x = cmp(0 < g_texcoord_transforms[0].w);
  if (r1.x != 0) {
    r1.xyz = g_textures_4_.Sample(g_samplers_4__s, v2.xy).xyz;
    r1.xyz = r1.xyz * r1.xyz;
    r0.xyz = r1.xyz * g_texcoord_transforms[0].www + r0.xyz;
  }
  r1.x = cmp(0 < g_texcoord_transforms[2].w);
  if (r1.x != 0) {
    r1.xyz = g_textures_5_.Sample(g_samplers_5__s, v2.zw).xyz;
    r1.xyz = r1.xyz * r1.xyz;
    r0.xyz = r1.xyz * g_texcoord_transforms[2].www + r0.xyz;
  }
  r1.x = cmp(0 < v4.z);
  if (r1.x != 0) {
    r1.xyz = g_textures_7_.Sample(g_samplers_7__s, v4.xy).xyz;
    r0.xyz = r1.xyz + r0.xyz;
  }

  //sprites
  r1.xyz = g_textures_6_.Sample(g_samplers_6__s, v1.xy).xyz;
  r1.xyz = saturate(r1.xyz);
  
  r1.xyz = float3(0.959999979,0.959999979,0.959999979) * r1.xyz;
  r1.w = 0.25 * v3.x; //sprite exposure?
  r0.xyz = r1.www * r0.xyz;

  r0.xyzw = min(float4(0.800000012,0.800000012,0.800000012,1), r0.xyzw); //clamp
  r1.w = 1 + -r0.w;
  r0.xyz = r1.xyz * r1.www + r0.xyz;

  //if not rendered on top by 3d
  Tonemap_SaveSprites(colorUntonemapped, colorUntonemappedMask, r0.xyz, v1.xy);

  //tonemap
  r0.xyz = saturate(r0.xyz * g_tone_scale.xyz + g_tone_offset.xyz);

  //fade + out
  r1.x = cmp(0 < g_fade_color.w);
  r1.yzw = g_fade_color.xyz + -r0.xyz;
  r1.yzw = g_fade_color.www * r1.yzw + r0.xyz;
  r2.xy = cmp(g_tone_scale.ww == float2(0,2));
  r3.xyz = g_fade_color.xyz + r0.xyz;
  r4.xyz = g_fade_color.xyz * r0.xyz;
  r2.yzw = r2.yyy ? r3.xyz : r4.xyz;
  r1.yzw = r2.xxx ? r1.yzw : r2.yzw;
  o0.xyz = r1.xxx ? r1.yzw : r0.xyz;
  o0.w = r0.w;

  //ToneMapPass
  colorTonemapped = o0.xyz;
  o0.xyz = Tonemap_Do(colorUntonemapped,  colorTonemapped, v1.xy, g_textures_0_);
  //if (CUSTOM_TONEMAP_IDENTIFY == 1) o0.xyz = DrawBinary(3, o0.xyz, v1.xy);
  return;
}