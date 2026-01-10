// ---- Created with 3Dmigoto v1.4.1 on Fri Jan  2 22:25:11 2026
// UI Particle System Pixel Shader
// Renders particle effects with normal mapping, texture animation, and clip-rect culling

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4x4 matFroxelViewProj : packoffset(c0);
  float4x4 matInvViewProjection : packoffset(c4);
  float4x4 matFarCloudShadowProjectionTexScale : packoffset(c8);
  float fTextureSampleBias : packoffset(c12) = {0};
  float2 viewportJitter : packoffset(c12.y);
  float TimeAttachValue : packoffset(c12.w);
  float4x4 matRelativeViewProj : packoffset(c13);
  float4 positionOffset : packoffset(c17);
  float4 positionClipRect : packoffset(c18);
  float3 vecViewPosition : packoffset(c19);
  float4 invScreenSize : packoffset(c20);
  float4 vecViewRight : packoffset(c21);
  float4 vecViewUp : packoffset(c22);
  float4 vecViewFoward : packoffset(c23);
  float4x4 matWorld : packoffset(c24);
  int seaHeightOffsetIndex : packoffset(c28) = {-1};
  float3 vecWindDirection : packoffset(c28.y);
  float4 uvMainSubOffset0 : packoffset(c29);
  float4 uvMainSubOffset1 : packoffset(c30);
  float4 uvMainSubMul0 : packoffset(c31);
  float4 uvMainSubMul1 : packoffset(c32);
  float4x4 matRelativeWorldView : packoffset(c33);
  float4x4 matProjection : packoffset(c37);
  float4x4 matViewProjection : packoffset(c41);
  float4x4 matViewOriginProjection : packoffset(c45);
  bool isUseNormal : packoffset(c49);
  bool bRotateCameraPositionBase : packoffset(c49.y);
  bool isDisableRenderUnderRoof : packoffset(c49.z);
  float4x4 matRelativeWorld : packoffset(c50);
  float3 vecRate : packoffset(c54);
  int bCalcWeatherColor : packoffset(c54.w);
  int ribbonUVType : packoffset(c55);
  float2 vecInvScreenSize : packoffset(c55.y);
  bool debug_flip : packoffset(c55.w);
  float debug_gpuSpawnerCountRatio : packoffset(c56);
  float debug_gpuBufferOffsetRatio : packoffset(c56.y);
  float debug_gpuParticleCountRatio : packoffset(c56.z);
  int gpu_particle_spawnParticleCount : packoffset(c56.w);
  int gpu_particle_accSpawnParticleCount : packoffset(c57);
  int gpuSpawnerClearStartOffset : packoffset(c57.y);
  int gpuSpawnerClearCount : packoffset(c57.z);
  float3x3 editorViewOrigin : packoffset(c58);
  float3 editorViewPosition : packoffset(c61);
  int gpuParticleConstantOffset : packoffset(c61.w);
  int gpuParticleBufferOffset : packoffset(c62);
  int gpuParticleBufferOffsetStore : packoffset(c62.y);
  int batchBufferOffset : packoffset(c62.z);
  int batch_call_count : packoffset(c62.w);
}

cbuffer effectScene : register(b2)
{
  float4 vecBlendOP[4] : packoffset(c0);
}

SamplerState samDiffuseHH_s : register(s10);
SamplerState samNormal_s : register(s11);
Texture2D<float4> texDiffuse : register(t7);
Texture2D<float4> texNormal : register(t8);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,      // Screen position
  float4 v1 : TEXCOORD0,          // UV coordinates (xy) + normal intensity (w) + alpha threshold (z)
  float4 v2 : TEXCOORD1,          // Additional UV data + UV animation offset (w)
  float4 v3 : COLOR0,             // Vertex color/tint (rgb) + alpha multiplier (w)
  float2 v4 : TEXCOORD2,          // Screen-space position for clipping
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  // ============================================================================
  // CLIP RECTANGLE TEST - Discard pixels outside the defined UI region
  // ============================================================================
  // Test left and top edges
  r0.xy = -positionClipRect.xw + v4.xy;
  r0.xy = cmp(r0.xy < float2(0,0));
  if (r0.x != 0) discard;
  if (r0.y != 0) discard;
  
  // Test right and bottom edges
  r0.xy = positionClipRect.yz + -v4.yx;
  r0.xy = cmp(r0.xy < float2(0,0));
  if (r0.x != 0) discard;
  if (r0.y != 0) discard;
  
  // ============================================================================
  // UV SETUP & NORMAL MAP SAMPLING
  // ============================================================================
  // Prepare base UV coordinates
  r0.y = v1.y;
  // Apply optional UV animation offset based on time or particle age
  r0.z = v2.w + v1.x;
  
  // Check blend operation flags to determine UV behavior
  r1.xy = cmp(vecBlendOP[1].yy == float2(2,1));
  r0.x = r1.x ? r0.z : v1.x;  // Use animated UV if flag is set
  
  // Sample normal map for lighting/distortion effects
  r0.xyz = texNormal.Sample(samNormal_s, r0.xy).xyz;
  
  // Convert normal from 0-1 range to -1 to 1 range
  r1.zw = r0.xy * float2(2,2) + float2(-1,-1);
  
  // Apply normal intensity multiplier (v1.w)
  r0.xyz = v1.www * r0.xyz;
  
  // Conditionally apply normal contribution based on blend mode
  r0.xyz = r1.yyy ? r0.xyz : 0;
  
  // Apply normal distortion to UVs for refraction/displacement effect
  r1.zw = r1.zw * v1.ww + v1.xy;
  
  // Select final UV coordinates based on blend flags
  r1.xz = r1.xx ? r1.zw : v1.xy;
  r1.xy = r1.yy ? v1.xy : r1.xz;
  
  // ============================================================================
  // DIFFUSE TEXTURE SAMPLING & GAMMA CORRECTION
  // ============================================================================
  // Sample the particle's diffuse texture with final UV coordinates
  r1.xyzw = texDiffuse.Sample(samDiffuseHH_s, r1.xy).xyzw;
  
  // Convert from gamma 2.2 (sRGB-like) to linear space for correct color math
  r1.xyz = log2(r1.xyz);
  r1.xyz = float3(2.20000005,2.20000005,2.20000005) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  
  // ============================================================================
  // COLOR COMPOSITION
  // ============================================================================
  // Combine diffuse color with vertex color tint and add normal contribution
  r0.xyz = r1.xyz * v3.xyz + r0.xyz;
  
  // ============================================================================
  // ALPHA TESTING
  // ============================================================================
  // Apply vertex alpha multiplier and check against alpha threshold
  r0.w = r1.w * v3.w + -v1.z;
  r0.w = cmp(r0.w < 0);
  if (r0.w != 0) discard;  // Discard transparent pixels
  
  // ============================================================================
  // FINAL OUTPUT - PREMULTIPLIED ALPHA
  // ============================================================================
  // Calculate final alpha with blend operation offset
  r0.w = saturate(r1.w * v3.w + vecBlendOP[0].z);
  r1.x = v3.w * r1.w;
  o0.w = r1.x;
  
  // Output premultiplied color (color * alpha) for proper alpha blending
  o0.xyz = r0.xyz * r0.www;
  
  // ============================================================================
  // UI VISIBILITY & HDR OUTPUT
  // ============================================================================
  if (CUSTOM_UI_VISIBLE < 0.5f) {
    o0 = float4(0, 0, 0, 0);
    return;
  }
  
  // Clamp brightness to 1000 nits maximum per-pixel (absolute nit clamp)
  // Convert to nits, clamp, convert back, then encode.
  const float ui_max_nits = 1000.f;
  float3 color_nits = o0.xyz * RENODX_GRAPHICS_WHITE_NITS;
  color_nits = min(color_nits, ui_max_nits);
  o0.xyz = color_nits / RENODX_GRAPHICS_WHITE_NITS;

  // Re-encode for the rest of the pipeline
  o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
  
  return;
}