#include "./shared.h"

cbuffer GFD_PSCONST_SYSTEM : register(b0) {
  float4 clearColor : packoffset(c0);
  float2 resolution : packoffset(c1);
  float2 resolutionRev : packoffset(c1.z);
}

cbuffer GFD_PSCONST_MATERIAL : register(b1) {
  float4 matAmbient : packoffset(c0);
  float4 matDiffuse : packoffset(c1);
  float4 matSpecular : packoffset(c2);
  float4 matEmissive : packoffset(c3);
  float matReflectivity : packoffset(c4);
  float matOutlineIndex : packoffset(c4.y);
  float shadowDisable : packoffset(c4.z);
  float fogDisable : packoffset(c4.w);
}

cbuffer GFD_PSCONST_LIGHT0_PS : register(b2) {
  float4 light0Ambient : packoffset(c0);
  float4 light0Diffuse : packoffset(c1);
  float4 light0Specular : packoffset(c2);
  float3 light0Attenuation : packoffset(c3);
  float2 light0Spot : packoffset(c4);
  float2 _reserved_b2 : packoffset(c4.z);
}

cbuffer GFD_PSCONST_ENV_COLORS : register(b5) {
  float4 fogColor : packoffset(c0);
  float4 heightFogColor : packoffset(c1);
  float3 lmapAmbient : packoffset(c2);
  float atestRef : packoffset(c2.w);
}

SamplerState lbufferSampler_s : register(s14);
Texture2D<float4> lbufferTexture : register(t14);

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float4 v1 : NORMAL0, float4 v2 : TEXCOORD1, float4 v3 : COLOR0, float4 v4 : COLOR1) : SV_TARGET0 {
  if (injectedData.clampState == CLAMP_STATE__MIN_ALPHA) return 1.f;
  if (injectedData.clampState == CLAMP_STATE__MAX_ALPHA) return 0.f;
  float4 r0, r1, r2, r3, o0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = int3(1, 1, 1);
  r0.w = heightFogColor.w * v1.w;
  r1.x = -fogDisable;
  r1.x = 1 + r1.x;
  r0.w = r1.x * r0.w;
  r0.w = max(0, r0.w);
  r0.w = min(1, r0.w);
  r1.x = dot(v1.xyz, v1.xyz);
  r1.x = rsqrt(r1.x);
  r1.xyz = v1.xyz * r1.xxx;
  r2.xy = resolutionRev.xy * v0.xy;
  r2.xyz = lbufferTexture.Sample(lbufferSampler_s, r2.xy).xyz;
  r2.xyz = r2.xyz;
  r2.xyz = r2.xyz;
  r2.xyz = r2.xyz;
  r1.w = dot(v2.xyz, v2.xyz);
  r1.w = rsqrt(r1.w);
  r3.xyz = v2.xyz * r1.www;
  r1.x = dot(r3.xyz, r1.xyz);
  r1.x = max(0, r1.x);
  r1.x = min(1, r1.x);
  r1.yzw = light0Ambient.xyz + r2.xyz;
  r3.xyz = light0Diffuse.xyz * r1.xxx;
  r2.xyz = r3.xyz + r2.xyz;
  r1.xyz = matAmbient.xyz * r1.yzw;
  r2.xyz = matDiffuse.xyz * r2.xyz;
  r1.xyz = r2.xyz + r1.xyz;
  r0.xyz = r1.xyz * r0.xyz;
  r0.xyz = v3.xyz * r0.xyz;
  r1.xyz = -r0.xyz;
  r1.xyz = heightFogColor.xyz + r1.xyz;
  r1.xyz = r1.xyz * r0.www;
  r0.xyz = r1.xyz + r0.xyz;
  r0.w = -v4.x;
  r0.w = 1 + r0.w;
  r0.w = fogColor.w * r0.w;
  r1.x = -fogDisable;
  r1.x = 1 + r1.x;
  r0.w = r1.x * r0.w;
  r1.xyz = -r0.xyz;
  r1.xyz = fogColor.xyz + r1.xyz;
  r1.xyz = r1.xyz * r0.www;
  r0.xyz = r1.xyz + r0.xyz;
  r0.xyz = max(float3(0, 0, 0), r0.xyz);
  r0.w = 1;
  o0.xyz = r0.xyz;
  o0.w = r0.w;
  if (injectedData.clampState == CLAMP_STATE__OUTPUT) {
    o0 = saturate(o0);
  }
  return o0;
}
