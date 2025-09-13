// ---- Created with 3Dmigoto v1.3.16 on Tue Sep 02 15:46:09 2025
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
SamplerState g_samplers_2__s : register(s2);
SamplerState g_samplers_7__s : register(s7);
Texture2D<float4> g_textures_0_ : register(t0);
Texture2D<float4> g_textures_1_ : register(t1);
Texture2D<float4> g_textures_2_ : register(t2);
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

  //color + bloom
  r0.xyzw = g_textures_0_.Sample(g_samplers_0__s, v1.xy).xyzw;

  r1.xyz = g_textures_1_.Sample(g_samplers_1__s, v1.zw).xyz;
  r1 = Tonemap_BloomMultiplier(r1);
  
  r1.w = cmp(0 < v4.z);
  if (r1.w != 0) {
    r2.xyz = g_textures_7_.Sample(g_samplers_7__s, v4.xy).xyz; //idk 4x4
    r0.xyz = r2.xyz + r0.xyz;
  }

  r1.w = cmp(0 < v3.z);
  r2.x = 0.479999989 * v3.x; //exposure?
  r1.xyz = r1.xyz * r2.xxx + r0.xyz;
  //r1.xyz = min(float3(0.959999979,0.959999979,0.959999979), r1.xyz); //TODO bypass clamp
  r0.xyz = r1.www ? r1.xyz : r0.xyz;
  
  colorUntonemapped = r0.xyz;

  //tonemap
  r1.xyz = min(float3(0.959999979,0.959999979,0.959999979), r1.xyz); //clamp
  r0.y = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r0.xz = r0.xz + -r0.yy;
  r1.x = v3.y * r0.y; //exposure 
  colorUntonemapped = Tonemap_ExposureComplex(colorUntonemapped, v3.y);

  r1.y = 0;
  r1.xy = g_textures_2_.SampleLevel(g_samplers_2__s, r1.xy, 0).yx;
  r0.y = v3.x * r1.x;
  r1.xz = r0.yy * r0.xz;
  r0.xz = r0.yy * r0.xz + r1.yy;
  r0.y = dot(r1.xyz, float3(-0.508475006,1,-0.186441004));
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
  //if (CUSTOM_TONEMAP_IDENTIFY == 1) o0.xyz = DrawBinary(4, o0.xyz, v1.xy);
  return;
}