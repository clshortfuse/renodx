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
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (CUSTOM_UI_VISIBLE < 0.5f) {
    o0 = float4(0, 0, 0, 0);
    return;
  }

  r0.xy = -positionClipRect.xw + v5.yz;
  r0.xy = cmp(r0.xy < float2(0,0));
  if (r0.x != 0) discard;
  r0.xz = positionClipRect.yz + -v5.zy;
  r0.xz = cmp(r0.xz < float2(0,0));
  if (r0.x != 0) discard;
  if (r0.z != 0) discard;
  if (r0.y != 0) discard;
  r0.x = texDiffuse.Sample(samDiffuse_s, v2.zw).w;
  r0.y = -vecBlendOP[1].x + r0.x;
  r0.y = cmp(r0.y < 0);
  if (r0.y != 0) discard;
  r0.y = texSubDiffuse.Sample(samSubDiffuse_s, v3.zw).w;
  r0.z = -vecBlendOP[1].y + r0.y;
  r0.z = cmp(r0.z < 0);
  if (r0.z != 0) discard;
  r1.xyzw = texDiffuse.Sample(samDiffuse_s, v2.xy).xyzw;
  r0.x = r0.x * r0.y;
  r0.x = vecBlendOP[0].x * r0.x;
  r0.x = v5.x * r0.x;
  r0.y = r1.w * r0.x;
  r0.x = r1.w * r0.x + -0.00100000005;
  r0.x = cmp(r0.x < 0);
  if (r0.x != 0) discard;
  r0.xzw = log2(r1.xyz);
  r0.xzw = float3(2.20000005,2.20000005,2.20000005) * r0.xzw;
  r0.xzw = exp2(r0.xzw);
  r1.x = cmp(0 < vecBlendOP[3].x);
  if (r1.x != 0) {
    r1.x = min(r0.z, r0.w);
    r1.x = min(r1.x, r0.x);
    r1.y = max(r0.z, r0.w);
    r1.y = max(r1.y, r0.x);
    r1.x = r1.y + -r1.x;
    r1.z = cmp(r1.x != 0.000000);
    r2.y = r1.x / r1.y;
    r3.xyz = r0.zwx + -r0.wxz;
    r3.xyz = r3.xyz / r1.xxx;
    r4.xyz = cmp(r0.xzw == r1.yyy);
    r1.xw = float2(2,4) + r3.yz;
    r1.w = r4.z ? r1.w : 0;
    r1.x = r4.y ? r1.x : r1.w;
    r2.x = r4.x ? r3.x : r1.x;
    r1.xz = r1.zz ? r2.xy : 0;
    r1.x = vecBlendOP[3].x + r1.x;
    r1.w = floor(r1.x);
    r1.x = r1.x + -r1.w;
    r2.x = 1 + -r1.z;
    r2.y = -r1.z * r1.x + 1;
    r1.x = 1 + -r1.x;
    r1.x = -r1.z * r1.x + 1;
    r3.xyzw = cmp(r1.wwww == float4(0,1,2,3));
    r1.w = cmp(r1.w == 4.000000);
    r1.z = 1;
    r2.z = 1;
    r4.xz = r1.ww ? r1.xz : r2.zy;
    r4.y = r2.x;
    r4.xyz = r3.www ? r2.xyz : r4.xyz;
    r2.w = r1.x;
    r1.xzw = r3.zzz ? r2.xzw : r4.xyz;
    r1.xzw = r3.yyy ? r2.yzx : r1.xzw;
    r1.xzw = r3.xxx ? r2.zwx : r1.xzw;
    r0.xzw = r1.xzw * r1.yyy;
  }
  r0.xzw = vecBlendOP[3].zzz + r0.xzw;
  r1.x = dot(r0.xzw, float3(0.300000012,0.589999974,0.109999999));
  r1.y = 1 + vecBlendOP[3].y;
  r0.xzw = -r1.xxx + r0.xzw;
  r0.xzw = r1.yyy * r0.xzw + r1.xxx;
  o0.xyz = min(MaxEffectOutput.xyz, r0.xzw);
  o0.w = r0.y;
  return;
}