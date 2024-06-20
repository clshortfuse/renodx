#include "./shared.h"

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

cbuffer GFD_PSCONST_ENV_COLORS : register(b5) {
  float4 fogColor : packoffset(c0);
  float4 heightFogColor : packoffset(c1);
  float3 lmapAmbient : packoffset(c2);
  float atestRef : packoffset(c2.w);
}

// 3Dmigoto declarations
#define cmp -

float4 main(float4 v0 : SV_POSITION0, float4 v1 : NORMAL0, float4 v2 : COLOR0, float4 v3 : COLOR1) : SV_TARGET0 {
  if (injectedData.clampState == CLAMP_STATE__MIN_ALPHA) return 1.f;
  if (injectedData.clampState == CLAMP_STATE__MAX_ALPHA) return 0.f;
  float4 r0, r1, r2, o0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = int4(1, 1, 1, 1);
  r1.w = matDiffuse.w * r0.w;
  r0.w = heightFogColor.w * v1.w;
  r2.x = -fogDisable;
  r2.x = 1 + r2.x;
  r0.w = r2.x * r0.w;
  r0.w = max(0, r0.w);
  r0.w = min(1, r0.w);
  r2.xyz = matDiffuse.xyz + matAmbient.xyz;
  r1.xyz = r2.xyz * r0.xyz;
  r1.xyzw = v2.xyzw * r1.xyzw;
  r0.x = -r0.w;
  r0.x = 1 + r0.x;
  r0.yzw = heightFogColor.xyz * r0.www;
  r0.xyz = r0.xxx + r0.yzw;
  r0.xyz = r1.xyz * r0.xyz;
  r0.w = -v3.x;
  r0.w = 1 + r0.w;
  r0.w = fogColor.w * r0.w;
  r1.x = -fogDisable;
  r1.x = 1 + r1.x;
  r0.w = r1.x * r0.w;
  r1.x = -r0.w;
  r1.x = 1 + r1.x;
  r2.xyz = fogColor.xyz * r0.www;
  r1.xyz = r2.xyz + r1.xxx;
  r0.xyz = r1.xyz * r0.xyz;
  o0.xyz = r0.xyz;
  o0.w = r1.w;
  if (injectedData.clampState == CLAMP_STATE__OUTPUT) {
    o0 = saturate(o0);
  }
  return o0;
}
