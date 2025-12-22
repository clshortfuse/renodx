// ---- Created with 3Dmigoto v1.4.1 on Sun Oct 26 21:03:05 2025

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

cbuffer HDRConst : register(b2)
{
  float4 MaxEffectOutput : packoffset(c0);
  float MaxEffectColorBrightness : packoffset(c1);
  float hdrEncodeMulti : packoffset(c1.y);
  float hdrEncodeMulti_Effect : packoffset(c1.z);
  float gammaConst : packoffset(c1.w);
}

cbuffer effectScene : register(b3)
{
  float4 vecBlendOP[4] : packoffset(c0);
}

SamplerState samDiffuse_s : register(s10);
SamplerState samSubDiffuse_s : register(s14);
Texture2D<float4> texDiffuse : register(t7);
Texture2D<float4> texSubDiffuse : register(t8);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  float3 v7 : TEXCOORD6,
  float3 v8 : COLOR0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (CUSTOM_UI_VISIBLE < 0.5f) {
    o0 = float4(0, 0, 0, 0);
    return;
  }

  r0.x = texDiffuse.Sample(samDiffuse_s, v2.zw).w;
  r0.y = -vecBlendOP[1].x + r0.x;
  r0.y = cmp(r0.y < 0);
  if (r0.y != 0) discard;
  r0.y = texSubDiffuse.Sample(samSubDiffuse_s, v3.zw).w;
  r0.z = -vecBlendOP[1].y + r0.y;
  r0.x = r0.x * r0.y;
  r0.y = cmp(r0.z < 0);
  if (r0.y != 0) discard;
  r0.yz = -positionClipRect.xw + v5.yz;
  r0.yz = cmp(r0.yz < float2(0,0));
  if (r0.y != 0) discard;
  if (r0.z != 0) discard;
  r0.yz = positionClipRect.yz + -v5.zy;
  r0.yz = cmp(r0.yz < float2(0,0));
  if (r0.y != 0) discard;
  if (r0.z != 0) discard;
  r0.yzw = texSubDiffuse.Sample(samSubDiffuse_s, v3.xy).xyz;
  r0.yzw = r0.yzw * r0.xxx;
  r0.yzw = vecBlendOP[1].zzz * r0.yzw;
  r1.xyz = texDiffuse.Sample(samDiffuse_s, v2.xy).xyz;
  r1.xyz = r1.xyz * r0.xxx;
  r0.x = 1 + -vecBlendOP[1].z;
  r0.xyz = r1.xyz * r0.xxx + r0.yzw;
  r0.xyz = r0.xyz * v8.xyz + vecBlendOP[0].zzz;
  r0.xyz = vecBlendOP[0].xxx * abs(r0.xyz);
  o0.xyz = min(MaxEffectOutput.xyz, r0.xyz);
  o0.w = vecBlendOP[0].y;
  return;
}