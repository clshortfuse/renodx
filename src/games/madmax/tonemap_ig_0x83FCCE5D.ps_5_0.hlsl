#include "./common.hlsl"
#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Fri Jun 20 20:06:03 2025

cbuffer cbInstanceConsts : register(b1)
{
  float4 InstanceConsts[6] : packoffset(c0);
}

SamplerState SceneTexture_s : register(s0);
SamplerState VelocityTexture_s : register(s3);
Texture2D<float4> SceneTexture : register(t0);
Texture2D<float4> VelocityTexture : register(t3);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = SceneTexture.SampleLevel(SceneTexture_s, v1.xy, 0).xyzw;
  r1.xyzw = VelocityTexture.SampleLevel(VelocityTexture_s, v1.xy, 0).xyzw;
  r1.xy = float2(-0.5,-0.5) + r1.xy;
  r1.w = 0.0299999993 * r1.w;
  r1.w = max(InstanceConsts[0].x, r1.w);
  r2.xy = r1.xy * r1.ww;
  r2.z = dot(r2.xy, r2.xy);
  r2.w = cmp(9.99999994e-09 < r2.z);
  if (r2.w != 0) {
    r3.xyzw = float4(-4,-4,-3,-3) * r2.xyxy;
    r4.xyzw = r2.xyxy * float4(-4,-4,-3,-3) + v1.xyxy;
    r5.xyzw = VelocityTexture.SampleLevel(VelocityTexture_s, r4.xy, 0).xyzw;
    r5.xy = float2(-0.5,-0.5) + r5.xy;
    r2.w = 0.0299999993 * r5.w;
    r2.w = max(InstanceConsts[0].x, r2.w);
    r5.xy = r5.xy * r2.ww;
    r2.w = cmp(r5.z >= r1.z);
    r5.x = dot(r5.xy, r5.xy);
    r5.x = 16 * r5.x;
    r3.x = dot(r3.xy, r3.xy);
    r3.x = cmp(r5.x >= r3.x);
    r2.w = (int)r2.w | (int)r3.x;
    if (r2.w != 0) {
      r5.xyzw = SceneTexture.SampleLevel(SceneTexture_s, r4.xy, 0).xyzw;
      r0.xyzw = r5.xyzw + r0.xyzw;
      r2.w = 2;
    } else {
      r2.w = 1;
    }
    r5.xyzw = VelocityTexture.SampleLevel(VelocityTexture_s, r4.zw, 0).xyzw;
    r3.xy = float2(-0.5,-0.5) + r5.xy;
    r4.x = 0.0299999993 * r5.w;
    r4.x = max(InstanceConsts[0].x, r4.x);
    r3.xy = r4.xx * r3.xy;
    r4.x = cmp(r5.z >= r1.z);
    r3.x = dot(r3.xy, r3.xy);
    r3.x = 16 * r3.x;
    r3.y = dot(r3.zw, r3.zw);
    r3.x = cmp(r3.x >= r3.y);
    r3.x = (int)r3.x | (int)r4.x;
    if (r3.x != 0) {
      r3.xyzw = SceneTexture.SampleLevel(SceneTexture_s, r4.zw, 0).xyzw;
      r0.xyzw = r3.xyzw + r0.xyzw;
      r2.w = 1 + r2.w;
    }
    r3.xyzw = float4(-2,-2,3,3) * r2.xyxy;
    r4.xyzw = r2.xyxy * float4(-2,-2,3,3) + v1.xyxy;
    r5.xyzw = VelocityTexture.SampleLevel(VelocityTexture_s, r4.xy, 0).xyzw;
    r5.xy = float2(-0.5,-0.5) + r5.xy;
    r5.w = 0.0299999993 * r5.w;
    r5.w = max(InstanceConsts[0].x, r5.w);
    r5.xy = r5.xy * r5.ww;
    r5.z = cmp(r5.z >= r1.z);
    r5.x = dot(r5.xy, r5.xy);
    r5.x = 16 * r5.x;
    r3.x = dot(r3.xy, r3.xy);
    r3.x = cmp(r5.x >= r3.x);
    r3.x = (int)r3.x | (int)r5.z;
    if (r3.x != 0) {
      r5.xyzw = SceneTexture.SampleLevel(SceneTexture_s, r4.xy, 0).xyzw;
      r0.xyzw = r5.xyzw + r0.xyzw;
      r2.w = 1 + r2.w;
    }
    r3.xy = -r1.xy * r1.ww + v1.xy;
    r5.xyzw = VelocityTexture.SampleLevel(VelocityTexture_s, r3.xy, 0).xyzw;
    r4.xy = float2(-0.5,-0.5) + r5.xy;
    r5.x = 0.0299999993 * r5.w;
    r5.x = max(InstanceConsts[0].x, r5.x);
    r4.xy = r5.xx * r4.xy;
    r5.x = cmp(r5.z >= r1.z);
    r4.x = dot(r4.xy, r4.xy);
    r4.x = 16 * r4.x;
    r4.y = dot(-r2.xy, -r2.xy);
    r4.x = cmp(r4.x >= r4.y);
    r4.x = (int)r4.x | (int)r5.x;
    if (r4.x != 0) {
      r5.xyzw = SceneTexture.SampleLevel(SceneTexture_s, r3.xy, 0).xyzw;
      r0.xyzw = r5.xyzw + r0.xyzw;
      r2.w = 1 + r2.w;
    }
    r1.xy = r1.xy * r1.ww + v1.xy;
    r5.xyzw = VelocityTexture.SampleLevel(VelocityTexture_s, r1.xy, 0).xyzw;
    r3.xy = float2(-0.5,-0.5) + r5.xy;
    r1.w = 0.0299999993 * r5.w;
    r1.w = max(InstanceConsts[0].x, r1.w);
    r3.xy = r3.xy * r1.ww;
    r1.w = cmp(r5.z >= r1.z);
    r3.x = dot(r3.xy, r3.xy);
    r3.x = 16 * r3.x;
    r2.z = cmp(r3.x >= r2.z);
    r1.w = (int)r1.w | (int)r2.z;
    if (r1.w != 0) {
      r5.xyzw = SceneTexture.SampleLevel(SceneTexture_s, r1.xy, 0).xyzw;
      r0.xyzw = r5.xyzw + r0.xyzw;
      r2.w = 1 + r2.w;
    }
    r1.xy = r2.xy + r2.xy;
    r3.xy = r2.xy * float2(2,2) + v1.xy;
    r5.xyzw = VelocityTexture.SampleLevel(VelocityTexture_s, r3.xy, 0).xyzw;
    r4.xy = float2(-0.5,-0.5) + r5.xy;
    r1.w = 0.0299999993 * r5.w;
    r1.w = max(InstanceConsts[0].x, r1.w);
    r4.xy = r4.xy * r1.ww;
    r1.w = cmp(r5.z >= r1.z);
    r2.z = dot(r4.xy, r4.xy);
    r2.z = 16 * r2.z;
    r1.x = dot(r1.xy, r1.xy);
    r1.x = cmp(r2.z >= r1.x);
    r1.x = (int)r1.x | (int)r1.w;
    if (r1.x != 0) {
      r5.xyzw = SceneTexture.SampleLevel(SceneTexture_s, r3.xy, 0).xyzw;
      r0.xyzw = r5.xyzw + r0.xyzw;
      r2.w = 1 + r2.w;
    }
    r5.xyzw = VelocityTexture.SampleLevel(VelocityTexture_s, r4.zw, 0).xyzw;
    r1.xy = float2(-0.5,-0.5) + r5.xy;
    r1.w = 0.0299999993 * r5.w;
    r1.w = max(InstanceConsts[0].x, r1.w);
    r1.xy = r1.xy * r1.ww;
    r1.w = cmp(r5.z >= r1.z);
    r1.x = dot(r1.xy, r1.xy);
    r1.x = 16 * r1.x;
    r1.y = dot(r3.zw, r3.zw);
    r1.x = cmp(r1.x >= r1.y);
    r1.x = (int)r1.x | (int)r1.w;
    if (r1.x != 0) {
      r3.xyzw = SceneTexture.SampleLevel(SceneTexture_s, r4.zw, 0).xyzw;
      r0.xyzw = r3.xyzw + r0.xyzw;
      r2.w = 1 + r2.w;
    }
    r1.xy = float2(4,4) * r2.xy;
    r2.xy = r2.xy * float2(4,4) + v1.xy;
    r3.xyzw = VelocityTexture.SampleLevel(VelocityTexture_s, r2.xy, 0).xyzw;
    r3.xy = float2(-0.5,-0.5) + r3.xy;
    r1.w = 0.0299999993 * r3.w;
    r1.w = max(InstanceConsts[0].x, r1.w);
    r3.xy = r3.xy * r1.ww;
    r1.z = cmp(r3.z >= r1.z);
    r1.w = dot(r3.xy, r3.xy);
    r1.w = 16 * r1.w;
    r1.x = dot(r1.xy, r1.xy);
    r1.x = cmp(r1.w >= r1.x);
    r1.x = (int)r1.x | (int)r1.z;
    if (r1.x != 0) {
      r1.xyzw = SceneTexture.SampleLevel(SceneTexture_s, r2.xy, 0).xyzw;
      r0.xyzw = r1.xyzw + r0.xyzw;
      r2.w = 1 + r2.w;
    }
    r0.xyzw = r0.xyzw / r2.wwww;
    o0.w = r0.w;
  } else {
    o0.w = r0.w;
  }
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = InstanceConsts[0].yyy * r0.xyz;
  // o0.xyz = exp2(r0.xyz);
  o0.rgb = FilmGrain(r0.rgb, v1);
  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);

  return;
}