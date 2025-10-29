// ---- Created with 3Dmigoto v1.4.1 on Sat Oct 25 03:57:58 2025
// Temporal AA resolve that reprojects previous frame, clamps history, and outputs luma for post passes.

#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4x4 matFroxelViewProj : packoffset(c0);
  float fTextureSampleBias : packoffset(c4) = {0};
  float2 screenSize : packoffset(c4.y);
  float2 invscreenSize : packoffset(c5);
  float2 viewportJitter : packoffset(c5.z);
  float focusDistance : packoffset(c6);
  float2 clipSize : packoffset(c6.y);
  float2 inv_small_size : packoffset(c7);
  float2 velocityDynamicResolution : packoffset(c7.z);
}

cbuffer dynamicResolutionConst : register(b2)
{
  float2 fDynamicResolution : packoffset(c0);
  float2 fDynamicResolutionPrev : packoffset(c0.z);
}

SamplerState PA_POINT_CLAMP_FILTER_s : register(s0);
SamplerState PA_LINEAR_MIRROR_FILTER_s : register(s1);
SamplerState PA_LINEAR_CLAMP_FILTER_s : register(s2);
Texture2D<float4> InputTexture : register(t0);
Texture2D<float4> PrevFrameTexture : register(t1);
Texture2D<float4> VelocityTexture : register(t2);
Texture2D<float4> DiffuseTexture : register(t3);
Texture2D<float4> StencilTexture : register(t4);
Texture2D<float4> DepthTexture : register(t5);
Texture2D<float4> EffectTexture : register(t6);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0,
  out float4 o1 : SV_TARGET1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Apply current jitter and dynamic resolution scaling to fetch from the main color buffers.
  r0.xy = viewportJitter.xy * invscreenSize.xy;
  r0.xy = v1.xy * fDynamicResolution.xy + r0.xy;
  r0.z = DiffuseTexture.SampleLevel(PA_POINT_CLAMP_FILTER_s, r0.xy, 0).w;
  r0.z = 16 * r0.z;
  r0.z = floor(r0.z);
  r1.xyz = InputTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r0.xy, 0).xyz;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  r2.x = dot(r1.xzy, float3(1,1,2));
  r2.y = dot(r1.xz, float2(2,-2));
  r2.z = dot(r1.yxz, float3(2,-1,-1));
  r1.xy = viewportJitter.xy + v0.xy;
  // Search a 3x3 neighborhood for the nearest depth to lock reprojection.
  r3.xyzw = float4(-1,-1,0,-1) + r1.xyxy;
  r3.xyzw = r3.xyzw / screenSize.xyxy;
  r3.xyzw = fDynamicResolution.xyxy * r3.xyzw;
  r0.w = DepthTexture.SampleLevel(PA_POINT_CLAMP_FILTER_s, r3.xy, 0).x;
  r0.w = min(9000000, r0.w);
  r1.z = DepthTexture.SampleLevel(PA_POINT_CLAMP_FILTER_s, r3.zw, 0).x;
  r3.y = cmp(r1.z >= r0.w);
  r3.x = min(r1.z, r0.w);
  r4.xyzw = float4(1,-1,-1,0) + r1.xyxy;
  r4.xyzw = r4.xyzw / screenSize.xyxy;
  r4.xyzw = fDynamicResolution.xyxy * r4.xyzw;
  r5.x = DepthTexture.SampleLevel(PA_POINT_CLAMP_FILTER_s, r4.xy, 0).x;
  r0.w = cmp(r5.x < r3.x);
  r5.yw = float2(1.40129846e-45,0);
  r1.zw = r0.ww ? r5.xy : r3.xy;
  r5.z = DepthTexture.SampleLevel(PA_POINT_CLAMP_FILTER_s, r4.zw, 0).x;
  r0.w = cmp(r5.z < r1.z);
  r3.z = ~(int)r0.w;
  r3.xy = r0.ww ? r5.zw : r1.zw;
  r1.zw = r1.xy / screenSize.xy;
  r1.zw = fDynamicResolution.xy * r1.zw;
  r4.x = DepthTexture.SampleLevel(PA_POINT_CLAMP_FILTER_s, r1.zw, 0).x;
  r0.w = cmp(r4.x < r3.x);
  r4.yz = float2(0,0);
  r3.xyz = r0.www ? r4.xyz : r3.xyz;
  r4.xyzw = float4(1,0,-1,1) + r1.xyxy;
  r4.xyzw = r4.xyzw / screenSize.xyxy;
  r4.xyzw = fDynamicResolution.xyxy * r4.xyzw;
  r5.x = DepthTexture.SampleLevel(PA_POINT_CLAMP_FILTER_s, r4.xy, 0).x;
  r0.w = cmp(r5.x < r3.x);
  r5.yz = float2(1.40129846e-45,0);
  r3.xyz = r0.www ? r5.xyz : r3.xyz;
  r4.x = DepthTexture.SampleLevel(PA_POINT_CLAMP_FILTER_s, r4.zw, 0).x;
  r0.w = cmp(r4.x < r3.x);
  r4.yz = float2(0,1.40129846e-45);
  r3.xyz = r0.www ? r4.xyz : r3.xyz;
  r4.xyzw = float4(0,1,1,1) + r1.xyxy;
  r4.xyzw = r4.xyzw / screenSize.xyxy;
  r4.xyzw = fDynamicResolution.xyxy * r4.xyzw;
  r5.x = DepthTexture.SampleLevel(PA_POINT_CLAMP_FILTER_s, r4.xy, 0).x;
  r0.w = cmp(r5.x < r3.x);
  r5.yz = float2(0,1.40129846e-45);
  r3.xyz = r0.www ? r5.xyz : r3.xyz;
  r4.x = DepthTexture.SampleLevel(PA_POINT_CLAMP_FILTER_s, r4.zw, 0).x;
  r0.w = cmp(r4.x < r3.x);
  r4.yz = float2(1.40129846e-45,1.40129846e-45);
  r3.xyz = r0.www ? r4.xyz : r3.xyz;
  r1.zw = (int2)r3.yz;
  // Combine with per-pixel motion vectors to locate the previous frame sample.
  r1.xy = r1.xy + r1.zw;
  r1.xy = r1.xy / screenSize.xy;
  r1.xy = velocityDynamicResolution.xy * r1.xy;
  r1.xy = VelocityTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r1.xy, 0).xy;
  r1.zw = screenSize.xy * r1.xy;
  r1.xy = -r1.xy * screenSize.xy + v0.xy;
  // Gather a weighted history neighborhood (Catmull-Rom like) to reduce ghosting.
  r3.yzw = float3(0,0,0);
  r0.w = 0;
  r2.w = -1;
  while (true) {
    r4.x = cmp(1 < (int)r2.w);
    if (r4.x != 0) break;
    r4.y = (int)r2.w;
    r5.xyz = r3.yzw;
    r4.z = r0.w;
    r4.w = -1;
    while (true) {
      r5.w = cmp(1 < (int)r4.w);
      if (r5.w != 0) break;
      r4.x = (int)r4.w;
      r6.xy = r4.xy + r1.xy;
      r6.xy = floor(r6.xy);
      r6.xy = float2(0.5,0.5) + r6.xy;
      r6.zw = r6.xy / screenSize.xy;
      r6.zw = fDynamicResolutionPrev.xy * r6.zw;
      r7.xyz = PrevFrameTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r6.zw, 0).xyz;
      r6.xy = r6.xy + -r1.xy;
      r6.zw = abs(r6.xy) * abs(r6.xy);
      r8.xy = r6.zw * abs(r6.xy);
      r8.zw = cmp(abs(r6.xy) < float2(1,1));
      if (r8.z != 0) {
        r4.x = -15 * r6.z;
        r4.x = r8.x * 9 + r4.x;
        r4.x = 6 + r4.x;
      } else {
        r5.w = cmp(2 >= abs(r6.x));
        r6.z = 15 * r6.z;
        r6.z = r8.x * -3 + r6.z;
        r6.x = abs(r6.x) * -24 + r6.z;
        r6.x = 12 + r6.x;
        r4.x = r5.w ? r6.x : 0;
      }
      r4.x = 0.166666672 * r4.x;
      if (r8.w != 0) {
        r5.w = -15 * r6.w;
        r5.w = r8.y * 9 + r5.w;
        r5.w = 6 + r5.w;
      } else {
        r6.x = cmp(2 >= abs(r6.y));
        r6.z = 15 * r6.w;
        r6.z = r8.y * -3 + r6.z;
        r6.y = abs(r6.y) * -24 + r6.z;
        r6.y = 12 + r6.y;
        r5.w = r6.x ? r6.y : 0;
      }
      r4.x = r5.w * r4.x;
      r5.w = 0.166666672 * r4.x;
      r5.xyz = r7.xyz * r5.www + r5.xyz;
      r4.z = r4.x * 0.166666672 + r4.z;
      r4.w = (int)r4.w + 1;
    }
    r3.yzw = r5.xyz;
    r0.w = r4.z;
    r2.w = (int)r2.w + 1;
  }
  r1.xy = v0.xy / screenSize.xy;
  r1.x = StencilTexture.SampleLevel(PA_LINEAR_CLAMP_FILTER_s, r1.xy, 0).x;
  r1.yz = cmp(float2(0,0) < abs(r1.zw));
  r1.y = (int)r1.z | (int)r1.y;
  r1.z = cmp(0.999998987 < r3.x);
  r1.y = (int)r1.z | (int)r1.y;
  r1.x = r1.y ? 1 : r1.x;
  // Normalize the reconstructed history color and build YCoCg style channels.
  r1.yzw = r3.yzw / r0.www;
  r1.yzw = max(float3(0,0,0), r1.yzw);
  r3.x = dot(r1.ywz, float3(1,1,2));
  r3.y = dot(r1.yw, float2(2,-2));
  r3.z = dot(r1.zyw, float3(2,-1,-1));
  r4.xyzw = cmp(r0.zzzz == float4(9,15,14,13));
  r0.z = max(0.5, r1.x);
  r0.z = r4.x ? r0.z : r1.x;
  r0.w = (int)r4.z | (int)r4.y;
  r0.w = (int)r4.w | (int)r0.w;
  r0.z = r0.w ? 1 : r0.z;
  // Bloom/glare mask tempers history weight in very bright regions.
  r0.xyw = EffectTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r0.xy, 0).xyz;
  r0.x = dot(r0.xyw, float3(0.212500006,0.715399981,0.0720999986));
  r0.x = saturate(10 * r0.x);
  r0.y = saturate(r0.z + r0.x);
  r0.zw = -clipSize.xy + v0.xy;
  r1.xy = float2(-1,-1) + screenSize.xy;
  r0.zw = max(float2(0,0), r0.zw);
  r0.zw = min(r0.zw, r1.xy);
  r0.zw = fDynamicResolution.xy * r0.zw;
  r0.zw = r0.zw / screenSize.xy;
  r4.xyz = InputTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r0.zw, 0).xyz;
  r5.x = dot(r4.xzy, float3(1,1,2));
  r5.y = dot(r4.xz, float2(2,-2));
  r5.z = dot(r4.yxz, float3(2,-1,-1));
  // Sample an 9-tap spatial neighborhood around the current pixel for clamp bounds.
  r4.xyzw = clipSize.xyxy * float4(0,-1,1,-1) + v0.xyxy;
  r4.xyzw = max(float4(0,0,0,0), r4.xyzw);
  r4.xyzw = min(r4.xyzw, r1.xyxy);
  r4.xyzw = fDynamicResolution.xyxy * r4.xyzw;
  r4.xyzw = r4.xyzw / screenSize.xyxy;
  r6.xyz = InputTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r4.xy, 0).xyz;
  r7.x = dot(r6.xzy, float3(1,1,2));
  r7.y = dot(r6.xz, float2(2,-2));
  r7.z = dot(r6.yxz, float3(2,-1,-1));
  r6.xyz = r7.xyz + r5.xyz;
  r7.xyz = r7.xyz * r7.xyz;
  r5.xyz = r5.xyz * r5.xyz + r7.xyz;
  r4.xyz = InputTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r4.zw, 0).xyz;
  r7.x = dot(r4.xzy, float3(1,1,2));
  r7.y = dot(r4.xz, float2(2,-2));
  r7.z = dot(r4.yxz, float3(2,-1,-1));
  r4.xyz = r7.xyz + r6.xyz;
  r5.xyz = r7.xyz * r7.xyz + r5.xyz;
  r6.xyzw = clipSize.xyxy * float4(-1,0,1,0) + v0.xyxy;
  r6.xyzw = max(float4(0,0,0,0), r6.xyzw);
  r6.xyzw = min(r6.xyzw, r1.xyxy);
  r6.xyzw = fDynamicResolution.xyxy * r6.xyzw;
  r6.xyzw = r6.xyzw / screenSize.xyxy;
  r7.xyz = InputTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r6.xy, 0).xyz;
  r8.x = dot(r7.xzy, float3(1,1,2));
  r8.y = dot(r7.xz, float2(2,-2));
  r8.z = dot(r7.yxz, float3(2,-1,-1));
  r4.xyz = r8.xyz + r4.xyz;
  r5.xyz = r8.xyz * r8.xyz + r5.xyz;
  r0.zw = max(float2(0,0), v0.xy);
  r0.zw = min(r0.zw, r1.xy);
  r0.zw = fDynamicResolution.xy * r0.zw;
  r0.zw = r0.zw / screenSize.xy;
  r7.xyz = InputTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r0.zw, 0).xyz;
  r8.x = dot(r7.xzy, float3(1,1,2));
  r8.y = dot(r7.xz, float2(2,-2));
  r8.z = dot(r7.yxz, float3(2,-1,-1));
  r4.xyz = r8.xyz + r4.xyz;
  r5.xyz = r8.xyz * r8.xyz + r5.xyz;
  r6.xyz = InputTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r6.zw, 0).xyz;
  r7.x = dot(r6.xzy, float3(1,1,2));
  r7.y = dot(r6.xz, float2(2,-2));
  r7.z = dot(r6.yxz, float3(2,-1,-1));
  r4.xyz = r7.xyz + r4.xyz;
  r5.xyz = r7.xyz * r7.xyz + r5.xyz;
  r6.xyzw = clipSize.xyxy * float4(-1,1,0,1) + v0.xyxy;
  r6.xyzw = max(float4(0,0,0,0), r6.xyzw);
  r6.xyzw = min(r6.xyzw, r1.xyxy);
  r6.xyzw = fDynamicResolution.xyxy * r6.xyzw;
  r6.xyzw = r6.xyzw / screenSize.xyxy;
  r7.xyz = InputTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r6.xy, 0).xyz;
  r8.x = dot(r7.xzy, float3(1,1,2));
  r8.y = dot(r7.xz, float2(2,-2));
  r8.z = dot(r7.yxz, float3(2,-1,-1));
  r4.xyz = r8.xyz + r4.xyz;
  r5.xyz = r8.xyz * r8.xyz + r5.xyz;
  r6.xyz = InputTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r6.zw, 0).xyz;
  r7.x = dot(r6.xzy, float3(1,1,2));
  r7.y = dot(r6.xz, float2(2,-2));
  r7.z = dot(r6.yxz, float3(2,-1,-1));
  r4.xyz = r7.xyz + r4.xyz;
  r5.xyz = r7.xyz * r7.xyz + r5.xyz;
  r0.zw = clipSize.xy + v0.xy;
  r0.zw = max(float2(0,0), r0.zw);
  r0.zw = min(r0.zw, r1.xy);
  r0.zw = fDynamicResolution.xy * r0.zw;
  r0.zw = r0.zw / screenSize.xy;
  r1.xyz = InputTexture.SampleLevel(PA_LINEAR_MIRROR_FILTER_s, r0.zw, 0).xyz;
  r6.x = dot(r1.xzy, float3(1,1,2));
  r6.y = dot(r1.xz, float2(2,-2));
  r6.z = dot(r1.yxz, float3(2,-1,-1));
  r1.xyz = r6.xyz + r4.xyz;
  r4.xyz = r6.xyz * r6.xyz + r5.xyz;
  // Compute neighborhood mean and variance for adaptive clipping of history.
  r5.xyz = float3(0.111111112,0.111111112,0.111111112) * r1.xyz;
  r5.xyz = r5.xyz * r5.xyz;
  r4.xyz = r4.xyz * float3(0.111111112,0.111111112,0.111111112) + -r5.xyz;
  r4.xyz = sqrt(abs(r4.xyz));
  r4.xyz = float3(1.5,1.5,1.5) * r4.xyz;
  r5.xyz = r1.xyz * float3(0.111111112,0.111111112,0.111111112) + -r4.xyz;
  r1.xyz = r1.xyz * float3(0.111111112,0.111111112,0.111111112) + r4.xyz;
  r4.xyz = r1.xyz + r5.xyz;
  r1.xyz = r1.xyz + -r5.xyz;
  r1.xyz = float3(0.5,0.5,0.5) * r1.xyz;
  r5.xyz = -r4.xyz * float3(0.5,0.5,0.5) + r3.xyz;
  r1.xyz = r5.xyz / r1.xyz;
  r0.z = max(abs(r1.y), abs(r1.z));
  r0.z = max(abs(r1.x), r0.z);
  r0.w = cmp(1 < r0.z);
  r1.xyz = r5.xyz / r0.zzz;
  r1.xyz = r4.xyz * float3(0.5,0.5,0.5) + r1.xyz;
  // Clamp history to spatial bounds when variance check fails.
  r1.xyz = r0.www ? r1.xyz : r3.xyz;
  r1.xyz = r1.xyz + -r3.xyz;
  r1.xyz = r0.yyy * r1.xyz + r3.xyz;
  r0.z = -r0.x * 0.0500000007 + 0.899999976;
  r0.w = 1 + -r0.z;
  r1.xyz = r1.xyz * r0.zzz;
  // Mix clamped history with current frame based on luminance and effect mask.
  r1.xyz = r2.xyz * r0.www + r1.xyz;
  r2.xyz = float3(0.25,0.25,0.25) * r1.xyz;
  r0.zw = r2.xx + r2.yz;
  o0.x = -r1.z * 0.25 + r0.z;
  r0.z = r1.x * 0.25 + -r2.y;
  o0.z = -r1.z * 0.25 + r0.z;
  r0.x = 1 + -r0.x;
  r0.x = -r0.x * 0.200000003 + r0.y;
  // Store history blend weight in o1 so later passes can reuse it.
  o1.xyzw = max(float4(0,0,0,0), r0.xxxx);
  o0.y = r0.w;
  o0.w = 1;
  return;
}