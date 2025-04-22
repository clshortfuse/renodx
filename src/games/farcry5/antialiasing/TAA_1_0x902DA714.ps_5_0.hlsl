#include "../shared.h"
// ---- Created with 3Dmigoto v1.4.1 on Sun Apr 20 14:49:46 2025

cbuffer CTemporalEffectsProvider : register(b0) {
  float4 QuadParams : packoffset(c0);
  float4x4 CurrentToPrevMatrix : packoffset(c1);
  float4 JitterParameters : packoffset(c5);
  float4 LinearDepthTextureSize : packoffset(c6);
  float4 SceneTextureSize : packoffset(c7);
  float4 FinalTextureSize : packoffset(c8);
  float4 SceneTextureScale : packoffset(c9);
  float4 TemporalParameters : packoffset(c10);
}

SamplerState Clamp_s : register(s0);
SamplerState PointClampNoMip_s : register(s1);
Texture2D<float2> MotionVectorsTexture : register(t0);
Texture2D<float2> MotionVectorsHistoryTexture : register(t1);
Texture2D<float4> SceneColorTexture : register(t2);
Texture2D<float4> SceneColorPreviousFrameTexture : register(t3);
Texture2D<float4> SceneColorAccumulationTexture : register(t4);

// 3Dmigoto declarations
#define cmp -
// clang-format off
#define INFINITY +1.#INF
// clang-format on

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    uint v2: SV_IsFrontFace0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = MotionVectorsTexture.SampleLevel(PointClampNoMip_s, v1.xy, 0).xy;
  r0.xyzw = float4(-0.498039216, -0.498039216, -0.498039216, -0.498039216) + r0.xxyy;
  r1.xy = r0.yw + r0.yw;
  r1.xy = r1.xy * r1.xy;
  r1.xy = r1.xy * r1.xy;
  r2.xyzw = r0.yyyw * float4(INFINITY, 4.83004713, 4.83004713, 4.83004713) + float4(0.5, 1.41502368, -1.41502368, 1.41502368);
  r2.x = saturate(r2.x);
  r1.z = r2.x * 2 + -1;
  r1.x = r1.x * r1.z;
  r3.xyzw = cmp(r0.xyzw < float4(-0.334370166, 0.334370166, -0.334370166, 0.334370166));
  r0.xy = r0.ww * float2(INFINITY, 4.83004713) + float2(0.5, -1.41502368);
  r0.z = r3.y ? r1.x : r2.z;
  r0.z = r3.x ? r2.y : r0.z;
  r0.x = saturate(r0.x);
  r0.x = r0.x * 2 + -1;
  r0.x = r1.y * r0.x;
  r0.x = r3.w ? r0.x : r0.y;
  r0.x = r3.z ? r2.w : r0.x;
  r2.xy = float2(0.100000001, 0.100000001) * r0.zx;
  r0.xy = v1.xy + r2.xy;
  r0.zw = MotionVectorsHistoryTexture.SampleLevel(Clamp_s, r0.xy, 0).xy;
  r1.xyzw = float4(-0.498039216, -0.498039216, -0.498039216, -0.498039216) + r0.zzww;
  r0.zw = r1.yw + r1.yw;
  r0.zw = r0.zw * r0.zw;
  r0.zw = r0.zw * r0.zw;
  r3.xyzw = r1.yyyw * float4(INFINITY, 4.83004713, 4.83004713, 4.83004713) + float4(0.5, 1.41502368, -1.41502368, 1.41502368);
  r3.x = saturate(r3.x);
  r2.z = r3.x * 2 + -1;
  r0.z = r2.z * r0.z;
  r4.xyzw = cmp(r1.xyzw < float4(-0.334370166, 0.334370166, -0.334370166, 0.334370166));
  r1.xy = r1.ww * float2(INFINITY, 4.83004713) + float2(0.5, -1.41502368);
  r0.z = r4.y ? r0.z : r3.z;
  r0.z = r4.x ? r3.y : r0.z;
  r3.x = 0.100000001 * r0.z;
  r1.x = saturate(r1.x);
  r0.z = r1.x * 2 + -1;
  r0.z = r0.w * r0.z;
  r0.z = r4.w ? r0.z : r1.y;
  r0.z = r4.z ? r3.w : r0.z;
  r3.y = 0.100000001 * r0.z;
  r0.zw = r3.xy + -r2.xy;
  r0.z = dot(r0.zw, r0.zw);
  r0.z = sqrt(r0.z);
  r0.z = -r0.z * 32 + 1;
  r1.xy = cmp(float2(1, 1) < r0.xy);
  r1.zw = cmp(r0.xy < float2(0, 0));
  r0.w = (int)r1.z | (int)r1.x;
  r0.w = (int)r1.y | (int)r0.w;
  r0.w = (int)r1.w | (int)r0.w;
  r1.xyz = SceneColorAccumulationTexture.SampleLevel(Clamp_s, r0.xy, 0).xyz;
  r2.xyz = SceneColorPreviousFrameTexture.SampleLevel(Clamp_s, r0.xy, 0).xyz;
  r3.xyz = SceneColorTexture.SampleLevel(PointClampNoMip_s, v1.xy, 0, int2(0, 1)).xyz;
  r4.xyz = SceneColorTexture.SampleLevel(PointClampNoMip_s, v1.xy, 0, int2(1, 1)).xyz;
  r5.xyz = min(r4.xyz, r3.xyz);
  r3.xyz = max(r4.xyz, r3.xyz);
  r4.xyz = SceneColorTexture.SampleLevel(PointClampNoMip_s, v1.xy, 0, int2(-1, 1)).xyz;
  r5.xyz = min(r4.xyz, r5.xyz);
  r3.xyz = max(r4.xyz, r3.xyz);
  r4.xyz = SceneColorTexture.SampleLevel(PointClampNoMip_s, v1.xy, 0, int2(1, 0)).xyz;
  r5.xyz = min(r4.xyz, r5.xyz);
  r3.xyz = max(r4.xyz, r3.xyz);
  r4.xyz = SceneColorTexture.SampleLevel(PointClampNoMip_s, v1.xy, 0, int2(0, 0)).xyz;
  r5.xyz = min(r4.xyz, r5.xyz);
  r6.xyz = SceneColorTexture.SampleLevel(PointClampNoMip_s, v1.xy, 0, int2(-1, 0)).xyz;
  r5.xyz = min(r6.xyz, r5.xyz);
  r7.xyz = SceneColorTexture.SampleLevel(PointClampNoMip_s, v1.xy, 0, int2(1, -1)).xyz;
  r5.xyz = min(r7.xyz, r5.xyz);
  r8.xyz = SceneColorTexture.SampleLevel(PointClampNoMip_s, v1.xy, 0, int2(0, -1)).xyz;
  r5.xyz = min(r8.xyz, r5.xyz);
  r9.xyz = SceneColorTexture.SampleLevel(PointClampNoMip_s, v1.xy, 0, int2(-1, -1)).xyz;
  r5.xyz = min(r9.xyz, r5.xyz);
  r3.xyz = max(r4.xyz, r3.xyz);
  r3.xyz = max(r6.xyz, r3.xyz);
  r3.xyz = max(r7.xyz, r3.xyz);
  r3.xyz = max(r8.xyz, r3.xyz);
  r3.xyz = max(r9.xyz, r3.xyz);
  r6.xyz = r3.xyz + -r5.xyz;
  r7.xyz = -TemporalParameters.xxx * r6.xyz + r5.xyz;
  r6.xyz = TemporalParameters.xxx * r6.xyz + r3.xyz;

  r6.xyz = saturate(-r6.xyz + r1.xyz);
  r7.xyz = max(float3(0, 0, 0), r7.xyz);
  r7.xyz = saturate(r7.xyz + -r1.xyz);

  r6.xyz = r7.xyz + r6.xyz;
  r0.x = dot(r6.xyz, r6.xyz);
  r0.x = renodx::math::SignSqrt(r0.x);
  r0.x = TemporalParameters.w * r0.x;
  r6.xyz = r4.xyz + -r1.xyz;
  r1.xyz = max(r5.xyz, r1.xyz);
  r2.xyz = max(r5.xyz, r2.xyz);
  r2.xyz = min(r3.xyz, r2.xyz);
  r1.xyz = min(r3.xyz, r1.xyz);

  // unclamp bt709 when using scRGB
  r1.xyz = sign(r1.rgb) * (r1.xyz * r1.xyz);  //   r1.xyz = r1.xyz * r1.xyz;
  r3.xyz = sign(r4.rgb) * (r4.xyz * r4.xyz);  // r3.xyz = r4.xyz * r4.xyz;

  r0.y = dot(abs(r6.xyz), abs(r6.xyz));
  r0.y = sqrt(r0.y);
  r0.x = TemporalParameters.z * r0.y + -r0.x;
  r0.xz = max(float2(0, 0), r0.xz);
  r0.x = 0.00100000005 + r0.x;
  r0.x = 1 / r0.x;
  r0.x = min(1, r0.x);
  r0.x = max(TemporalParameters.y, r0.x);
  r0.x = 1 + r0.x;
  r0.x = r0.w ? 2 : r0.x;
  r0.x = r0.x + -r0.z;
  r0.y = 0.5 * r0.z;
  r0.y = r0.w ? 0 : r0.y;
  r0.x = min(1, r0.x);
  r0.z = 1 + -r0.x;
  r1.xyz = r1.xyz * r0.zzz;

  // unclamp bt709 when using scRGB
  r2.xyz = sign(r2.rgb) * (r2.xyz * r2.xyz) + -r3.xyz;  // r2.xyz = r2.xyz * r2.xyz + -r3.xyz;
  r0.yzw = r0.yyy * r2.xyz + r3.xyz;
  r0.xyz = r0.yzw * r0.xxx + r1.xyz;

  // unclamp bt709 when using scRGB
  o0.xyz = renodx::math::SignSqrt(r0.xyz);  // sqrt(r0.xyz);

  o0.w = 1;
  return;
}
