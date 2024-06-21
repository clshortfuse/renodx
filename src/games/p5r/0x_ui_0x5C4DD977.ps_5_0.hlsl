#include "./shared.h"

cbuffer GFD_PSCONST_DEFERRED_LIGHT : register(b10) {
  float4 invProjParams : packoffset(c0);
  float3 lightPosition : packoffset(c1);
  float _reserve0 : packoffset(c1.w);
  float3 lightDirection : packoffset(c2);
  float _reserve1 : packoffset(c2.w);
  float3 lightColor : packoffset(c3);
  float _reserve2 : packoffset(c3.w);
  float4 lightPrams : packoffset(c4);
}

SamplerState depthSampler_s : register(s0);
SamplerState gbufferSampler_s : register(s13);
Texture2D<float4> depthTexture : register(t0);
Texture2D<uint2> powerTexture : register(t1);
Texture2D<float4> gbufferTexture : register(t13);

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float4 v1 : TEXCOORD0) : SV_TARGET0 {
  if (injectedData.clampState == CLAMP_STATE__MIN_ALPHA) return 1.f;
  if (injectedData.clampState == CLAMP_STATE__MAX_ALPHA) return 0.f;
  float4 r0, r1, r2, r3, o0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy / v1.ww;
  r0.x = 0.5 * r0.x;
  r1.x = 0.5 + r0.x;
  r0.x = 0.5 * r0.y;
  r0.x = 0.5 + r0.x;
  r0.x = -r0.x;
  r1.y = 1 + r0.x;
  r0.x = depthTexture.Sample(depthSampler_s, r1.xy).x;
  r0.x = r0.x;
  powerTexture.GetDimensions(0, fDest.x, fDest.y, fDest.z);
  r0.yz = fDest.xy;
  r0.y = r0.y;
  r0.z = r0.z;
  r0.y = r1.x * r0.y;
  r0.z = r1.y * r0.z;
  r2.x = (int)r0.y;
  r2.y = (int)r0.z;
  r2.zw = float2(0, 0);
  r0.y = powerTexture.Load(r2.xyz).y;
  r0.y = r0.y;
  r0.y = (uint)r0.y;
  r0.zw = float2(2, 2) * r1.xy;
  r1.zw = float2(-1, -1);
  r0.zw = r1.zw + r0.zw;
  r0.x = r0.x;
  r0.x = invProjParams.z + r0.x;
  r2.z = invProjParams.w / r0.x;
  r0.xz = invProjParams.xy * r0.zw;
  r1.zw = -r2.zz;
  r2.xy = r1.zw * r0.xz;
  r0.xzw = -r2.xyz;
  r0.xzw = lightPosition.xyz + r0.xzw;
  r1.z = dot(r0.xzw, r0.xzw);
  r1.z = sqrt(r1.z);
  r0.xzw = r0.xzw / r1.zzz;
  r1.xyw = gbufferTexture.Sample(gbufferSampler_s, r1.xy).xyz;
  r1.xyw = r1.xyw;
  r1.xyw = float3(2, 2, 2) * r1.xyw;
  r3.xyz = float3(-1, -1, -1);
  r1.xyw = r3.xyz + r1.xyw;
  r2.w = dot(r1.xyw, r1.xyw);
  r2.w = rsqrt(r2.w);
  r1.xyw = r2.www * r1.xyw;
  r2.w = dot(lightDirection.xyz, r0.xzw);
  r2.w = -r2.w;
  r2.w = 1 + r2.w;
  r3.x = -lightPrams.z;
  r3.y = lightPrams.w + r3.x;
  r2.w = r3.x + r2.w;
  r3.x = 1 / r3.y;
  r2.w = r3.x * r2.w;
  r2.w = max(0, r2.w);
  r2.w = min(1, r2.w);
  r3.x = -2 * r2.w;
  r3.x = 3 + r3.x;
  r2.w = r2.w * r2.w;
  r2.w = r3.x * r2.w;
  r2.w = -r2.w;
  r2.w = 1 + r2.w;
  r3.x = -lightPrams.x;
  r3.y = lightPrams.y + r3.x;
  r1.z = r3.x + r1.z;
  r3.x = 1 / r3.y;
  r1.z = r3.x * r1.z;
  r1.z = max(0, r1.z);
  r1.z = min(1, r1.z);
  r3.x = -2 * r1.z;
  r3.x = 3 + r3.x;
  r1.z = r1.z * r1.z;
  r1.z = r3.x * r1.z;
  r1.z = -r1.z;
  r1.z = 1 + r1.z;
  r3.x = dot(r0.xzw, r1.xyw);
  r3.x = max(0, r3.x);
  r3.x = min(1, r3.x);
  r3.xyz = lightColor.xyz * r3.xxx;
  r3.xyz = r3.xyz * r1.zzz;
  r3.xyz = r3.xyz * r2.www;
  r3.w = dot(r2.xyz, r2.xyz);
  r3.w = rsqrt(r3.w);
  r2.xyz = r3.www * r2.xyz;
  r2.xyz = -r2.xyz;
  r0.xzw = r2.xyz + r0.xzw;
  r2.x = dot(r0.xzw, r0.xzw);
  r2.x = rsqrt(r2.x);
  r0.xzw = r2.xxx * r0.xzw;
  r0.x = dot(r0.xzw, r1.xyw);
  r0.x = max(0, r0.x);
  r0.x = log2(r0.x);
  r0.x = r0.y * r0.x;
  r0.x = exp2(r0.x);
  r0.x = r0.x * r1.z;
  r0.x = r0.x * r2.w;
  r0.x = max(0, r0.x);
  r0.x = min(1, r0.x);
  o0.xyz = r3.xyz;
  o0.w = r0.x;
  if (injectedData.clampState == CLAMP_STATE__OUTPUT) {
    o0 = saturate(o0);
  }
  return o0;
}
