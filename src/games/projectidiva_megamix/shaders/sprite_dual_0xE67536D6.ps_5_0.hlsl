// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 31 23:17:00 2025
#include "./common.hlsl"


cbuffer Batch : register(b1)
{
  float4 g_combiner : packoffset(c0);
}

SamplerState g_sampler_s : register(s0);
Texture2D<float4> g_textures_0_ : register(t0);
Texture2D<float4> g_textures_1_ : register(t1);
Texture2D<float4> g_overlay_dest_texture : register(t2);


// 3Dmigoto declarations
#define cmp -

bool Check() { //TODO upgrade to out float multiplier if needed
  //ignore bg sprites
  if (CALLBACK_TONEMAP_ISDRAWN < 0) return false;

  //size
  float w;
  float h;
  g_textures_0_.GetDimensions(w, h);

  return 
  (
    //progress bar
    (
      (w == 2048.f && h == 64.f) && 
      CheckBlack(g_textures_0_.SampleLevel(g_sampler_s, float2(0,0), 0).x) &&
      !CheckBlack(g_textures_0_.SampleLevel(g_sampler_s, float2(0,0.2f), 0).x) &&
      CheckBlack(g_textures_0_.SampleLevel(g_sampler_s, float2(0,0.1f), 0).x) &&
      !CheckBlack(g_textures_0_.SampleLevel(g_sampler_s, float2(0.87f,0.2f), 0).x) &&
      CheckBlack(g_textures_0_.SampleLevel(g_sampler_s, float2(0.89f,0.2f), 0).x) 
    )
  );
}

//progress bar
//swipe note arrow/clock hand
void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float4 v2 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_SPRITES_DRAW) discard;

  r0.xyz = cmp(g_combiner.yzx == float3(0,0,1));
  if (r0.x != 0) {
    r0.x = g_textures_0_.Sample(g_sampler_s, v2.xy).w;
  } else {
    r0.w = cmp(g_combiner.y == 1.000000);
    if (r0.w != 0) {
      r0.x = g_textures_0_.SampleLevel(g_sampler_s, v2.xy, 0).y;
    } else {
      r0.x = 1;
    }
  }
  if (r0.y != 0) {
    r1.xyzw = g_textures_1_.Sample(g_sampler_s, v2.zw).xyzw;
  } else {
    r0.y = cmp(g_combiner.z == 1.000000);
    if (r0.y != 0) {
      r1.xw = g_textures_1_.SampleLevel(g_sampler_s, v2.zw, 0).xy;
      r0.yw = g_textures_1_.SampleLevel(g_sampler_s, v2.zw, 1).xy;
      r2.xz = r0.wy * float2(1.00392163,1.00392163) + float2(-0.503929257,-0.503929257);
      r2.y = r1.x;
      r1.x = dot(float2(1.57480001,1), r2.xy);
      r1.y = dot(float3(-0.468100011,1,-0.187299997), r2.xyz);
      r1.z = dot(float2(1,1.8556), r2.yz);
    } else {
      r0.y = cmp(g_combiner.z == 2.000000);
      if (r0.y != 0) {
        r2.y = g_textures_1_.SampleLevel(g_sampler_s, v2.zw, 0).x;
        r0.y = g_textures_1_.SampleLevel(g_sampler_s, v2.zw, 1).x;
        r0.w = g_textures_1_.SampleLevel(g_sampler_s, v2.zw, 2).x;
        r2.xz = r0.yw * float2(1.00392163,1.00392163) + float2(-0.503929257,-0.503929257);
        r1.x = dot(float2(1.57480001,1), r2.xy);
        r1.y = dot(float3(-0.468100011,1,-0.187299997), r2.xyz);
        r1.z = dot(float2(1,1.8556), r2.yz);
      } else {
        r1.xyz = float3(1,1,1);
      }
      r1.w = 1;
    }
  }
  r1.w = r1.w * r0.x;
  r2.xyzw = v1.xyzw * r1.xyzw;
  if (r0.z != 0) {
    r0.xyz = r1.xyz * v1.xyz + float3(-1,-1,-1);
    r2.xyz = r0.xyz * r2.www + float3(1,1,1);
  } else {
    r0.x = cmp(g_combiner.x == 2.000000);
    if (r0.x != 0) {
      r0.xy = (int2)v0.xy;
      r0.zw = float2(0,0);
      r0.xyz = g_overlay_dest_texture.Load(r0.xyz).xyz;
      r3.xyz = r0.xyz * r2.xyz;
      r3.xyz = r3.xyz + r3.xyz;
      r1.xyz = r1.xyz * v1.xyz + r0.xyz;
      r1.xyz = r1.xyz * float3(2,2,2) + -r3.xyz;
      r1.xyz = float3(-1,-1,-1) + r1.xyz;
      r0.xyz = cmp(r0.xyz < float3(0.5,0.5,0.5));
      r2.xyz = r0.xyz ? r3.xyz : r1.xyz;
    }
  }
  o0.xyzw = r2.xyzw;

  if (Check()) o0.xyz = max(o0.xyz, (float3)0.01f) * CUSTOM_HUDBRIGHTNESS_PROGRESSBAR;
  return;
}