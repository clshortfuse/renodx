// ---- Created with 3Dmigoto v1.3.16 on Sat Aug 09 22:32:43 2025
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
SamplerState g_samplers_4__s : register(s4);
SamplerState g_samplers_5__s : register(s5);
SamplerState g_samplers_6__s : register(s6);
SamplerState g_samplers_7__s : register(s7);
Texture2D<float4> g_textures_0_ : register(t0);
Texture2D<float4> g_textures_1_ : register(t1);
Texture2D<float4> g_textures_2_ : register(t2);
Texture2D<float4> g_textures_4_ : register(t4);
Texture2D<float4> g_textures_5_ : register(t5);
Texture2D<float4> g_textures_6_ : register(t6); //prev sprite render target
Texture2D<float4> g_textures_7_ : register(t7);


// 3Dmigoto declarations
#define cmp -

//Color + Bloom + Sprites + Tonemap + Fade
//Default Future Tone w/ Sprites
void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
    //w: sprites exposure?
  float4 v4 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 colorUntonemapped, colorTonemapped;
  float colorUntonemappedMask;

  //color
  r0.xyzw = g_textures_0_.Sample(g_samplers_0__s, v1.xy).xyzw;
  colorUntonemappedMask = r0.w;
  
  //bloom
  r1.xyz = g_textures_1_.Sample(g_samplers_1__s, v1.zw).xyz;
  r1 = Tonemap_BloomMultiplier(r1);
  r1.w = cmp(0 < v3.z); //threshold
  r1.xyz = r1.xyz + r0.xyz; //bloom add
  r0.xyz = r1.www ? r1.xyz : r0.xyz; //dont draw if not surpasses threshold

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

  //composite sprites that was rendered before this (complex)
  {
    r1.xyz = g_textures_6_.Sample(g_samplers_6__s, v1.xy).xyz; //color
    float3 colorSprites = r1.xyz;

    r1.xyz = saturate(r1.xyz); //clamp SDR (a must, else becomes black by compositing onto color)

    r2.xyz = float3(0.959999979,0.959999979,0.959999979) * r1.xyz;
    r1.y = dot(r2.xyz, float3(0.300000012,0.589999974,0.109999999));

    r1.w = log2(abs(r1.y));
    r1.w = g_tone_offset.w * r1.w;
    r1.w = exp2(r1.w);

    r1.w = 1 + -r1.w;
    r2.x = cmp(0 < r1.w);
    r2.y = log2(r1.w);
    r1.w = r2.x ? r2.y : r1.w;

    r2.z = v3.w * r1.w; //sprites exposure?
    r1.w = r1.y * 2 + -1;
    r1.w = max(0, r1.w);

    r1.w = r1.w * r1.w; //bruh
    r1.w = r1.w * r1.w; //bruh
    r1.w = r1.w * r1.w; //bruh
    r1.w = -r1.w * r1.w + 1;

    r1.xz = r1.xz * float2(0.959999979,0.959999979) + -r1.yy;
    r1.y = r1.y * r1.w;
    r1.w = cmp(r1.y != 0.000000);
    r3.x = 1 / r1.y;
    r1.y = r1.w ? r3.x : r1.y;

    r1.xy = r1.xz * r1.yy + float2(1,1);
    r2.xy = r1.xy * r2.zz;
    r2.w = dot(r2.xzy, float3(-0.508469999,1.69490004,-0.186440006));
    
    r0.w = min(1, r0.w);
    r1.x = 1 + -r0.w;
    r0.xyz = r2.xwy * r1.xxx + r0.xyz; //sprite * mask + 3d?

    //if not rendered on top by 3d
    Tonemap_SaveSprites(colorUntonemapped, colorUntonemappedMask, r0.xyz, v1.xy);
  }
  
  //tonemapper
  {
    r0.y = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
    r0.xz = r0.xz + -r0.yy;
    r1.x = v3.y * r0.y; //exposure 
    colorUntonemapped = Tonemap_ExposureComplex(colorUntonemapped, v3.y);

    r1.y = 0;
    r1.xy = g_textures_2_.SampleLevel(g_samplers_2__s, r1.xy, 0).yx;
    r0.y = v3.x * r1.x; //sat
    r1.xz = r0.yy * r0.xz;
    r0.xz = r0.yy * r0.xz + r1.yy;
    r0.y = dot(r1.xyz, float3(-0.508475006,1,-0.186441004));
    r0.xyz = r0.xyz * g_tone_scale.xyz + g_tone_offset.xyz;
    r0.xyz = saturate(r0.xyz);
  }

  //fade
  {
    r1.x = cmp(0 < g_fade_color.w);
    r1.yzw = g_fade_color.xyz + -r0.xyz;
    r1.yzw = g_fade_color.www * r1.yzw + r0.xyz;
    r2.xy = cmp(g_tone_scale.ww == float2(0,2));
    r3.xyz = g_fade_color.xyz + r0.xyz;
    r4.xyz = g_fade_color.xyz * r0.xyz;
    r2.yzw = r2.yyy ? r3.xyz : r4.xyz;
    r1.yzw = r2.xxx ? r1.yzw : r2.yzw;
    r0.xyz = r1.xxx ? r1.yzw : r0.xyz;
  }

  //out
  o0 = r0;

  //ToneMapPass
  colorTonemapped = o0.xyz;
  o0.xyz = Tonemap_Do(colorUntonemapped, colorTonemapped, v1.xy, g_textures_0_);
  //if (CUSTOM_TONEMAP_IDENTIFY == 1) o0.xyz = DrawBinary(1, o0.xyz, v1.xy);
  return;
}