#include "../../shaders/color.hlsl"
#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:58 2024
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s9_s : register(s9);

SamplerState s8_s : register(s8);

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}

cbuffer cb12 : register(b12)
{
  float4 cb12[53];
}




// 3Dmigoto declarations
#define cmp -

// convert render input for HDR
float3 convertRenderInput(float3 render) {
  render /= injectedData.toneMapGameNits / 80.f;
  render /= injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
  render = pow(saturate(render), 1.f / 2.2f); // apply inverse gamma correction
  return render;
}

// convert render output for HDR
float3 convertRenderOutput(float3 render) {
  render = pow(saturate(render), 2.2f); // apply gamma correction
  render *= injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
  render *= injectedData.toneMapGameNits / 80.f;
  return render;
}


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(0,0);
  r1.xyzw = (int4)v0.xyxy;
  r2.xyzw = (int4)r1.zwzw + int4(1,0,-1,0);
  r0.xy = r2.zw;
  r0.xyzw = t0.Load(r0.xyz).xyzw;
  
  // HDR input conversion
  r0.xyz = convertRenderInput(r0.xyz);

  r2.zw = float2(0,0);
  r2.xyzw = t0.Load(r2.xyz).xyzw;

  // HDR input conversion
  r2.xyz = convertRenderInput(r2.xyz);

  r3.xyzw = min(r2.xyzw, r0.xyzw);
  r0.xyzw = max(r2.xyzw, r0.xyzw);
  r2.zw = float2(0,0);
  r4.xyzw = (int4)r1.zwzw + int4(0,1,0,-1);
  r2.xy = r4.zw;
  r2.xyzw = t0.Load(r2.xyz).xyzw;

  // HDR input conversion
  r2.xyz = convertRenderInput(r2.xyz);

  r4.zw = float2(0,0);
  r4.xyzw = t0.Load(r4.xyz).xyzw;

  // HDR input conversion
  r4.xyz = convertRenderInput(r4.xyz);

  r5.xyzw = t0.SampleLevel(s8_s, v1.xy, 0).xyzw;

  // HDR input conversion
  r5.xyz = convertRenderInput(r5.xyz);

  r6.xyzw = min(r5.xyzw, r4.xyzw);
  r4.xyzw = max(r5.xyzw, r4.xyzw);
  r5.xyzw = saturate(r5.xyzw);
  r4.xyzw = max(r4.xyzw, r2.xyzw);
  r2.xyzw = min(r6.xyzw, r2.xyzw);
  r2.xyzw = min(r2.xyzw, r3.xyzw);
  r0.xyzw = max(r4.xyzw, r0.xyzw);
  r3.xyzw = (int4)r1.xyzw + int4(-1,1,1,1);
  r1.xyzw = (int4)r1.zwzw + int4(-1,-1,1,-1);
  r4.xy = r3.zw;
  r4.zw = float2(0,0);
  r4.xyzw = t0.Load(r4.xyz).xyzw;

  // HDR input conversion
  r4.xyz = convertRenderInput(r4.xyz);
  
  r6.xyzw = min(r4.xyzw, r2.xyzw);
  r4.xyzw = max(r4.xyzw, r0.xyzw);
  r3.zw = float2(0,0);
  r3.xyzw = t0.Load(r3.xyz).xyzw;

  // HDR input conversion
  r3.xyz = convertRenderInput(r3.xyz);

  r7.xy = r1.zw;
  r7.zw = float2(0,0);
  r7.xyzw = t0.Load(r7.xyz).xyzw;

  // HDR input conversion
  r7.xyz = convertRenderInput(r7.xyz);

  r8.xyzw = min(r7.xyzw, r3.xyzw);
  r3.xyzw = max(r7.xyzw, r3.xyzw);
  r1.zw = float2(0,0);
  r1.xyzw = t0.Load(r1.xyz).xyzw;

  // HDR input conversion
  r1.xyz = convertRenderInput(r1.xyz);
  
  r7.xyzw = min(r1.xyzw, r8.xyzw);
  r1.xyzw = max(r1.xyzw, r3.xyzw);
  r1.xyzw = max(r1.xyzw, r4.xyzw);
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = min(r7.xyzw, r6.xyzw);
  r1.xyzw = r1.xyzw + r2.xyzw;
  r2.xyzw = float4(0.5,0.5,0.5,0.5) * r1.xyzw;
  r2.xyzw = r0.xyzw * float4(0.5,0.5,0.5,0.5) + -r2.xyzw;
  r3.xy = t2.SampleLevel(s9_s, v1.xy, 0).xy;
  r3.zw = v1.xy + r3.xy;
  r3.xy = cb12[52].zw * r3.xy;
  r3.x = dot(r3.xy, r3.xy);
  r3.x = cb12[50].y * r3.x;
  r3.x = min(1, r3.x);
  r4.xyzw = t1.SampleLevel(s9_s, r3.zw, 0).xyzw;
  r6.xyzw = r0.xyzw * float4(0.5,0.5,0.5,0.5) + -r4.xyzw;
  r3.y = saturate(r5.w + -r4.w);
  r3.yz = cmp(float2(0.00999999978,0.300000012) < r3.yy);
  r0.xyzw = float4(0.5,0.5,0.5,0.5) * r0.xyzw;
  r2.xyzw = saturate(r6.xyzw / r2.xyzw);
  r1.xyzw = r1.xyzw * float4(0.5,0.5,0.5,0.5) + -r0.xyzw;
  r0.xyzw = r2.xyzw * r1.xyzw + r0.xyzw;
  r1.xyzw = r5.xyzw + -r0.xyzw;
  r2.x = cmp(1.00000001e-007 < r3.x);
  r2.y = -r3.x * r3.x + 1;
  r2.y = cb2[0].x * r2.y;
  r2.x = r2.x ? r3.y : 0;
  r2.x = (int)r3.z | (int)r2.x;
  r2.z = t3.SampleLevel(s9_s, v1.xy, 0).w;
  r2.z = 255 * r2.z;
  r2.z = (uint)r2.z;
  r2.z = cmp((int)r2.z == 2);
  r2.x = (int)r2.z | (int)r2.x;
  r2.z = r2.z ? 1 : 0.899999976;
  r2.x = r2.x ? r2.z : r2.y;
  r0.xyzw = r2.xxxx * r1.xyzw + r0.xyzw;

  // HDR output conversion
  r0.xyz = convertRenderOutput(r0.xyz);

  o0.xyzw = max(float4(0,0,0,0), r0.xyzw);
  return;
}