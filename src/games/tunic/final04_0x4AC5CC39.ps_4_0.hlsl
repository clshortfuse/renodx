// After glow effect

#include "./shared.h"
#include "../../shaders/color.hlsl"


Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[10];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[7];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[6];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb1[6].y * v1.y;
  r0.x = 0.268999994 * r0.x;
  r0.y = cmp(cb2[6].x == 0.000000);
  r0.zw = float2(1,1) + -v1.xy;
  r1.x = r0.y ? v1.x : r0.z;
  r0.y = saturate(cb2[0].x * r0.w);
  r0.z = cb1[6].x * r1.x;
  r0.x = r0.z * 0.615999997 + r0.x;
  r0.z = 1.10000002 * r0.x;
  r0.z = cmp(r0.z >= -r0.z);
  r0.zw = r0.zz ? float2(1.10000002,0.909090877) : float2(-1.10000002,-0.909090877);
  r0.x = r0.x * r0.w;
  r0.x = frac(r0.x);
  r0.x = r0.z * r0.x + -0.550000012;
  r0.x = 0.0350000001 * r0.x;
  r0.z = v1.y + r1.x;
  r0.z = -1 + r0.z;
  r0.w = cmp(0 < r0.z);
  r1.z = cmp(r0.z < 0);
  r0.z = log2(abs(r0.z));
  r0.z = cb2[8].x * r0.z;
  r0.z = exp2(r0.z);
  r0.w = (int)-r0.w + (int)r1.z;
  r0.w = (int)r0.w;
  r0.x = r0.w * r0.z + r0.x;
  r0.z = saturate(r0.x);
  r0.x = saturate(-r0.x);
  r2.xyz = cb2[4].xyz * r0.zzz;
  r0.xzw = r0.xxx * cb2[5].xyz + r2.xyz;
  r1.z = saturate(cb2[0].x * v1.y);
  r0.y = min(r1.z, r0.y);
  r0.y = 1 + -r0.y;
  r1.z = cb2[2].w * cb2[2].z;
  r1.z = max(0, r1.z);
  r0.y = -r0.y * r1.z + 1;
  r1.y = v1.y;
  r1.xy = r1.xy * cb0[4].xy + cb0[4].zw;

  const float4 inputColor = t0.Sample(s0_s, r1.xy).xyzw;
  // Expects the frame buffer to be in gamma
  r1.xyzw = inputColor;
  r0.xyz = r0.yyy * r1.xyz + r0.xzw;
  r1.xy = float2(-0.5,-0.5) + v1.xy;
  r1.xy = r1.xy * r1.xy;
  r0.w = r1.x + r1.y;
  r0.w = log2(r0.w);
  r0.w = cb2[2].y * r0.w; // cb2[2].y
  r0.w = exp2(r0.w);
  r1.x = saturate(cb2[2].x);

  const float3 colorFilter = cb2[1].xyz;

  r1.xyz = colorFilter * r1.xxx;
  r2.xyz = r1.xyz * r0.www + -r0.xyz;
  r1.w = r1.x * r0.w;
  r0.xyz = r1.www * r2.xyz + r0.xyz;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  
  //r1.xyz = saturate(r0.xyz);
  r1.xyz = r0.xyz;
  
  r0.w = yFromBT709(abs(r1.xyz));
  
  r2.xyz = r0.www + -r1.xyz;
  r1.xyz = r2.xyz * float3(0.879999995,0.879999995,0.879999995) + r1.xyz;
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = r1.xyz * r1.xyz;
  r1.xyz = r1.xyz * cb2[7].xyz + -r0.xyz;
  r1.xyz = cb2[3].xxx * r1.xyz + r0.xyz;
  r0.xyz = cb2[9].xyz + r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  // r0.xyz = saturate(cb2[8].yyy * r0.xyz + r1.xyz);
  r0.xyz = cb2[8].yyy * r0.xyz + r1.xyz;
  r0.xyz = cb2[3].yyy + r0.xyz;
  r0.xyz = -cb2[3].zzz + r0.xyz;
  r1.xy = v1.xy * cb0[5].xy + cb0[5].zw;
  
  
  
  float4 t1Color = t1.Sample(s1_s, r1.xy).xyzw; // last frame
  r1.xyzw = t1Color;
  t1Color *= 80.f / injectedData.toneMapGameNits; // reduce paperwhite sclaing
  r1.xyzw = sign(t1Color) * pow(abs(t1Color), 1.f / 2.2f); // Convert raw framebuffer to gamma

  r1.xyz = r1.xyz - r0.xyz; // delta
  float scaleStrength = saturate(cb2[6].y); // scaler?

  o0.xyz = scaleStrength * r1.xyz + r0.xyz;
  o0.w = 1;

  o0.rgb = lerp(inputColor.rgb, o0.rgb, injectedData.fxScreenGlow);

  o0.rgb = sign(o0.rgb) * pow(abs(o0.rgb), 2.2f); // linear
  o0.rgb *= injectedData.toneMapGameNits / 80.f;

  // Clamp needed before effects happen after tone mapping...
  o0.rgb = min(o0.rgb, injectedData.toneMapPeakNits / 80.f);
  return;
}