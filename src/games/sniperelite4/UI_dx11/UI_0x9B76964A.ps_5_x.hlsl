#include "../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Jul 13 18:40:40 2025

cbuffer DistanceFieldConstants : register(b1)
{
  float4 g_xOutlineColour : packoffset(c0) = {0,0,0,1};
  float4 g_xOuterGlowColour : packoffset(c1) = {1,0,0,1};
  float2 g_fTextureSize : packoffset(c2) = {512,512};
  float g_fOuterGlowMin : packoffset(c2.z) = {0.300000012};
  float g_fOuterGlowMax : packoffset(c2.w) = {0.5};
  float g_fOutlineHalfThickness : packoffset(c3) = {0.0149999997};
  float g_fAntiAliasDistance : packoffset(c3.y) = {0.100000001};
  float g_fInnerAlpha : packoffset(c3.z) = {1};
  float g_fTolerance : packoffset(c3.w) = {0.5};
  bool g_bOutline : packoffset(c4) = false;
  bool g_bAntiAlias : packoffset(c4.y) = true;
  bool g_bOuterGlow : packoffset(c4.z) = true;
}

SamplerState g_xTrilinearWrap_s : register(s2);
Texture2D<float4> g_xTexture : register(t2);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : Texcoords0,
  float4 v1 : Colour0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = g_xOutlineColour.xyzw * v1.wwww;
  r1.xyzw = g_xOutlineColour.xyzw * v1.wwww + -v1.xyzw;
  r2.xy = g_fTextureSize.xy * v0.xy;
  r2.xy = ddx_coarse(r2.xy);
  r2.x = dot(r2.xy, r2.xy);
  r2.x = sqrt(r2.x);
  r2.x = saturate(g_fAntiAliasDistance * r2.x);
  r2.y = 1 / -r2.x;
  r2.z = g_fOutlineHalfThickness + r2.x;
  r2.z = g_fTolerance + r2.z;
  r2.w = g_xTexture.Sample(g_xTrilinearWrap_s, v0.xy).x;
  r3.x = r2.w + -r2.z;
  r2.z = cmp(r2.z >= r2.w);
  r2.y = saturate(r3.x * r2.y);
  r3.x = r2.y * -2 + 3;
  r2.y = r2.y * r2.y;
  r2.y = r3.x * r2.y;
  r1.xyzw = r2.yyyy * r1.xyzw + v1.xyzw;
  r2.y = cmp(r2.w >= g_fTolerance);
  r0.xyzw = r2.yyyy ? r1.xyzw : r0.xyzw;
  r0.xyzw = r2.zzzz ? r0.xyzw : v1.xyzw;
  r0.xyzw = g_bOutline ? r0.xyzw : v1.xyzw;
  r1.x = g_fOuterGlowMax + -g_fOuterGlowMin;
  r1.x = 1 / r1.x;
  r1.y = -g_fOuterGlowMin + r2.w;
  r1.x = saturate(r1.y * r1.x);
  r1.y = r1.x * -2 + 3;
  r1.x = r1.x * r1.x;
  r1.x = r1.y * r1.x;
  r3.xyzw = g_xOuterGlowColour.xyzw * v1.wwww;
  r3.w = r3.w * r1.x;
  r1.xyzw = r0.xyzw * g_fInnerAlpha + -r3.xyzw;
  r2.y = g_fTolerance + -g_fOutlineHalfThickness;
  r2.y = r2.z ? r2.y : g_fTolerance;
  r2.y = g_bOutline ? r2.y : g_fTolerance;
  r2.z = saturate(r2.y + r2.x);
  r2.x = saturate(r2.y + -r2.x);
  r2.y = cmp(r2.w >= r2.y);
  r2.w = r2.w + -r2.x;
  r2.x = r2.z + -r2.x;
  r2.x = 1 / r2.x;
  r2.x = saturate(r2.w * r2.x);
  r2.y = r2.y ? 1.000000 : 0;
  r2.z = r2.x * -2 + 3;
  r2.x = r2.x * r2.x;
  r2.x = r2.z * r2.x;
  r2.x = g_bAntiAlias ? r2.x : r2.y;
  r1.xyzw = r2.xxxx * r1.xyzw + r3.xyzw;
  r0.w = r2.x * r0.w;
  o0.xyzw = g_bOuterGlow ? r1.xyzw : r0.xyzw;
  
  o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  
  return;
}