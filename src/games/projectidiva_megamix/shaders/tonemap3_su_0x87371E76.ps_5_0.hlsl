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
SamplerState g_samplers_6__s : register(s6);
SamplerState g_samplers_7__s : register(s7);
SamplerState g_scene_depth_sampler_s : register(s10);
Texture2D<float4> g_textures_0_ : register(t0);
Texture2D<float4> g_textures_1_ : register(t1);
Texture2D<float4> g_textures_2_ : register(t2);
Texture2D<float4> g_textures_6_ : register(t6);
Texture2D<float4> g_textures_7_ : register(t7);
Texture2D<float4> g_scene_depth_texture : register(t10);


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

  //color + bloom (sample)
  r0.xyzw = g_textures_0_.Sample(g_samplers_0__s, v1.xy).xyzw; //color
  colorUntonemappedMask = r0.w;
  
  r1.xyz = g_textures_1_.Sample(g_samplers_1__s, v1.zw).xyz; //bloom
  r1 = Tonemap_BloomMultiplier(r1);

  //sprites (complex)
  r2.xyz = g_textures_6_.Sample(g_samplers_6__s, v1.xy).xyz; //sprites
  r2.xyz = saturate(r2.xyz);

  r3.xyz = float3(0.959999979,0.959999979,0.959999979) * r2.xyz;
  r1.w = dot(r3.xyz, float3(0.300000012,0.589999974,0.109999999));

  r2.y = log2(abs(r1.w));
  r2.y = g_tone_offset.w * r2.y;
  r2.y = exp2(r2.y);
  
  r2.y = 1 + -r2.y;
  r2.w = cmp(0 < r2.y);
  r3.x = log2(r2.y);
  r2.y = r2.w ? r3.x : r2.y;
  r3.z = v3.w * r2.y;
  r2.y = r1.w * 2 + -1;
  r2.y = max(0, r2.y);
  r2.y = r2.y * r2.y;
  r2.y = r2.y * r2.y;
  r2.y = r2.y * r2.y;
  r2.y = -r2.y * r2.y + 1;
  r2.xz = r2.xz * float2(0.959999979,0.959999979) + -r1.ww;
  r1.w = r2.y * r1.w;
  r2.y = cmp(r1.w != 0.000000);
  r2.w = 1 / r1.w;
  r1.w = r2.y ? r2.w : r1.w;

  r2.xy = r2.xz * r1.ww + float2(1,1);
  r3.xy = r2.xy * r3.zz;
  r3.w = dot(r3.xzy, float3(-0.508469999,1.69490004,-0.186440006));

  r1.w = cmp(0 < v4.z);
  if (r1.w != 0) {
    r2.xyz = g_textures_7_.Sample(g_samplers_7__s, v4.xy).xyz; //idk 4x4
    r0.xyz = r2.xyz + r0.xyz;
  }
  
  r1.w = g_scene_depth_texture.Sample(g_scene_depth_sampler_s, v1.xy).x; //depth based selection?
  r1.w = cmp(0 >= r1.w); //only pos

  r2.w = min(1, r0.w); //(sprites composite)
  r3.z = 1 + -r2.w; //(sprites composite)

  r4.x = cmp(r2.w >= 0);
  r3.xyz = r3.xwy * r3.zzz + r0.xyz; //(sprites composite)
  r2.xyz = r4.xxx ? r3.xyz : r0.xyz; 
  r0.xyzw = r1.wwww ? r2.xyzw : r0.xyzw; //between idk and normal r0

  
  //color + bloom (delayed composite)
  r1.w = cmp(0 < v3.z);
  r2.x = 0.479999989 * v3.x; //exposure
  r1.xyz = r1.xyz * r2.xxx + r0.xyz;
  r0.xyz = r1.www ? r1.xyz : r0.xyz;
  
  colorUntonemapped = r0.xyz;

  Tonemap_SaveSprites(colorUntonemapped, colorUntonemappedMask, r0.xyz, v1.xy);
  
  //tonemap
  r1.xyz = min(float3(0.959999979,0.959999979,0.959999979), r1.xyz);
  r0.y = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r0.xz = r0.xz + -r0.yy;
  r1.x = v3.y * r0.y; //v3.y exposure
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
  //if (CUSTOM_TONEMAP_IDENTIFY == 1) o0.xyz = DrawBinary(6, o0.xyz, v1.xy);
  return;
}