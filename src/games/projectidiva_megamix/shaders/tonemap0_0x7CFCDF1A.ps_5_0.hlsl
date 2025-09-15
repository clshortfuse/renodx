// ---- Created with 3Dmigoto v1.3.16 on Sat Aug 09 21:11:11 2025
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
SamplerState g_samplers_7__s : register(s7);
Texture2D<float4> g_textures_0_ : register(t0); //color
Texture2D<float4> g_textures_1_ : register(t1); //bloom
Texture2D<float4> g_textures_2_ : register(t2); //512x1 Strip green to red
Texture2D<float4> g_textures_4_ : register(t4); //4x4
Texture2D<float4> g_textures_5_ : register(t5); //4x4
Texture2D<float4> g_textures_7_ : register(t7); //4x4


// 3Dmigoto declarations
#define cmp -

//Color + Bloom + Tonemap + Fade
//Default Future Tone
void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2, 
    //z: bloom threshold
    //y: exposure
    //x: saturation
  float4 v4 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;
  
  float3 colorUntonemapped, colorTonemapped;

  //color
  r0.xyzw = g_textures_0_.Sample(g_samplers_0__s, v1.xy).xyzw;
  
  //bloom
  r1.xyz = g_textures_1_.Sample(g_samplers_1__s, v1.zw).xyz;
  r1 = Tonemap_BloomMultiplier(r1);
  r1.w = cmp(0 < v3.z); //threshold
  r1.xyz = r1.xyz + r0.xyz; //add bloom
  r0.xyz = r1.www ? r1.xyz : r0.xyz; //dont draw if not surpasses threshold

  colorUntonemapped = r0.xyz;
  colorUntonemapped = Tonemap_ExposureComplex(colorUntonemapped, v3.y);

  //is this LUT? 3x sample like lut 3d? idk bro...
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

  //tonemapper
  {
    r0.y = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
    r0.xz = r0.xz + -r0.yy;
    r1.x = v3.y * r0.y; //exposure
    r1.y = 0;
    r1.xy = g_textures_2_.SampleLevel(g_samplers_2__s, r1.xy, 0).yx; //strip tonemap, are they input to output luminance sampling instead of calculating?
    r0.y = v3.x * r1.x; //sat
    r1.xz = r0.yy * r0.xz;
    r0.xz = r0.yy * r0.xz + r1.yy;
    r0.y = dot(r1.xyz, float3(-0.508475006,1,-0.186441004));
    r0.xyz = r0.xyz * g_tone_scale.xyz + g_tone_offset.xyz; //this barely changes from 0, idk cases.
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

  //tonemapped
  colorTonemapped = o0.xyz;
  o0.xyz = Tonemap_Do(colorUntonemapped, colorTonemapped, v1.xy, g_textures_0_);
  //if (CUSTOM_TONEMAP_IDENTIFY == 1) o0.xyz = DrawBinary(0, o0.xyz, v1.xy);
  // if (shader_injection.callback_tonemap_isdrawn == 0.f) o0.xyz *= 0.1; 
  return;
}