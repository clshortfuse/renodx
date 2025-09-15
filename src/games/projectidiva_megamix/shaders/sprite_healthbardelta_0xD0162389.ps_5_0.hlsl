// ---- Created with 3Dmigoto v1.3.16 on Sun Aug 31 23:31:42 2025
#include "./common.hlsl"

cbuffer Batch : register(b1)
{
  float4 g_combiner : packoffset(c0);
}

Texture2D<float4> g_overlay_dest_texture : register(t2);


// 3Dmigoto declarations
#define cmp -


//TODO is this single use?
void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (!CUSTOM_SPRITES_DRAW) discard;

  r0.x = cmp(g_combiner.x == 1.000000);
  if (r0.x != 0) {
    r0.xyz = float3(-1,-1,-1) + v1.xyz;
    r0.xyz = r0.xyz * v1.www + float3(1,1,1);
  } else {
    r1.x = cmp(g_combiner.x == 2.000000);
    if (r1.x != 0) {
      r1.xy = (int2)v0.xy;
      r1.zw = float2(0,0);
      r1.xyz = g_overlay_dest_texture.Load(r1.xyz).xyz;
      r2.xyz = v1.xyz * r1.xyz;
      r2.xyz = r2.xyz + r2.xyz;
      r3.xyz = v1.xyz + r1.xyz;
      r3.xyz = r3.xyz * float3(2,2,2) + -r2.xyz;
      r3.xyz = float3(-1,-1,-1) + r3.xyz;
      r1.xyz = cmp(r1.xyz < float3(0.5,0.5,0.5));
      r0.xyz = r1.xyz ? r2.xyz : r3.xyz;
    } else {
      r0.xyz = v1.xyz;
    }
  }
  r0.w = v1.w;
  o0.xyzw = r0.xyzw;

  //only after tonemappass, so that we minimize whatever else this shaders draws.
  if (CALLBACK_TONEMAP_ISDRAWN >= 0) o0.xyz *= CUSTOM_HUDBRIGHTNESS_HEALTHBARDELTA;
  return;
}