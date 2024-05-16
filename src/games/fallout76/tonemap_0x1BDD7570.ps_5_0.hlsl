#include "../../shaders/color.hlsl"
#include "../../shaders/tonemap.hlsl"
#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:47 2024
Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);  // depth

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);  // render

SamplerState s8_s : register(s8);

SamplerState s3_s : register(s3);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

/* 
fo76: 2 cbuffers  63 values in all 4 shaders

fo4:  1 cbuffer   5  values in 2 shaders
      1 cbuffer   6  values in 2 shaders

why so different?
*/
cbuffer cb2 : register(b2)
{
  float4 cb2[8];
}

cbuffer cb12 : register(b12)
{
  float4 cb12[55];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;



  /* depth tests */
  r0.xyz = t0.Sample(s0_s, v1.xy).xyz;

  //const float3 renderInput = r0.xyz;

  r0.w = t3.SampleLevel(s3_s, v1.xy, 0).w;  // use LOD level 0

  //const float depthMask = r0.w;

  r0.w = 255 * r0.w;  // scale depth
  // depth stencil test?
  // related to bloom?
  r0.w = (uint)r0.w;
  r0.w = cmp((int)r0.w == 1);
  
  r1.xy = (int2)v0.xy;
  r1.zw = float2(0,0);
  r1.x = t4.Load(r1.xyz).x;
  r1.x = cmp(r1.x < 0.99999994);
  r0.w = r0.w ? r1.x : 0;
  if (r0.w != 0) {
    o0.xyz = r0.xyz;
    o0.w = 1;
    return; // exit shader early based on depth?
  }

  /* various color calculations */
  r0.w = t1.Sample(s1_s, v1.xy).x;
  r1.x = t1.Sample(s1_s, float2(0.5,0.5)).x;
  r1.yz = v1.xy * cb2[7].zw + float2(-0.5,-0.5);
  r2.xy = floor(r1.yz);
  r2.xy = float2(1,1) + r2.xy;
  r2.xy = r2.xy / cb2[7].zw;
  r1.yz = frac(r1.yz);
  r2.xyzw = t2.Gather(s8_s, r2.xy).xyzw;
  r3.xy = float2(1,1) + -r1.yz;
  r2.xyzw = log2(r2.xwyz);
  r2.xy = r3.xx * r2.yx;
  r2.xy = exp2(r2.xy);
  r1.yw = r2.wz * r1.yy;
  r1.yw = exp2(r1.yw);
  r1.yw = r2.xy * r1.yw;
  r1.yw = log2(r1.yw);
  r1.y = r3.y * r1.y;
  r1.y = exp2(r1.y);
  r1.z = r1.z * r1.w;
  r1.z = exp2(r1.z);
  r1.y = r1.y * r1.z;


  /* color adjustments based on parameters */
  r1.zw = cb2[1].xy * r0.ww;
  r1.y = max(r1.y, r1.z);
  r1.y = min(r1.y, r1.w);
  r1.z = 1 + -cb2[1].z;
  r1.y = log2(r1.y);
  r1.y = r1.z * r1.y;
  r1.y = exp2(r1.y);
  r1.x = log2(r1.x);
  r1.x = cb2[1].z * r1.x;
  r1.x = exp2(r1.x);
  r1.x = r1.y * r1.x;
  r1.y = cmp(1.00000001e-010 < cb12[54].x);
  r1.x = max(9.99999975e-005, r1.x);
  r1.x = cb12[54].y / r1.x;
  r1.x = r1.y ? cb12[54].x : r1.x;
  r1.x = max(cb12[54].z, r1.x);
  r1.x = min(cb12[54].w, r1.x);
  r0.w = max(9.99999975e-005, r0.w);
  r0.w = cb12[54].y / r0.w;
  r0.w = r1.y ? cb12[54].x : r0.w;
  r0.w = max(cb12[54].z, r0.w);
  r0.w = min(cb12[54].w, r0.w);
  r0.w = log2(r0.w);
  r0.w = -cb2[1].w * r0.w;
  r0.w = exp2(r0.w);
  r1.x = log2(r1.x);
  r1.x = cb2[1].w * r1.x;
  r1.x = exp2(r1.x);
  r0.w = r1.x * r0.w;
  r0.xyz = r0.xyz * r0.www;
  r0.w = cmp(0.5 < cb2[2].w);

  const float3 untonemapped = r0.xyz;

  /* tone mapping */
  if (injectedData.toneMapType == 0) { // Vanilla tonemapper
    r1.x = max(9.99999975e-005, cb2[2].y);
    r1.y = 0.560000002 / r1.x; // .56 = 11.2 (linear white point) * .5 * .1 (linear angle)?
    r1.y = 2.43000007 + r1.y;
    r1.x = r1.x * r1.x;
    r1.x = 0.140000001 / r1.x;
    r1.x = r1.y + r1.x;
    r1.y = cb2[0].x * cb2[0].x;
    r1.y = -r1.y * 2.43000007 + 0.0299999993; // -r1.y * 2.43 * .03 (linear strength) * .01 (linear toe)?
    r1.z = -0.589999974 + r1.x;
    r1.y = r1.z * cb2[0].x + r1.y;
    r1.xzw = r1.xxx * r0.xyz + float3(0.0299999993,0.0299999993,0.0299999993); // .03 = .3 (linear strength) * .1 (linear angle)?
    r1.xzw = r1.xzw * r0.xyz;
    r2.xyz = r0.xyz * float3(2.43000007,2.43000007,2.43000007) + float3(0.589999974,0.589999974,0.589999974);
    r2.xyz = r0.xyz * r2.xyz + r1.yyy;
    r1.xyz = saturate(r1.xzw / r2.xyz);
    r0.xyz = r0.www ? r1.xyz : r0.xyz;

    // replicate vanilla tonemapper
    //r0.xyz = toneMapCurve(r0.xyz, 0.30f, 0.5f, 0.14f, 0.15f, .02f, 0.30f) / toneMapCurve(5.6f, 0.30f, 0.5f, 0.14f, 0.15f, .02f, 0.30f);
    //o0.xyz = r0.xyz;

  }
  else { // untonemapped
    r0.xyz = untonemapped;
  }
  r1.x = dot(r0.xyz, float3(0.212500006,0.715399981,0.0720999986)); // converting srgb to ycbcr
  r0.w = 0;
  float3 outputColor = r0.xyz; // before scene filter
  r0.xyzw = -r1.xxxx + r0.xyzw;
  r0.xyzw = cb2[3].xxxx * r0.xyzw + r1.xxxx;
  r1.xyzw = r1.xxxx * cb2[4].xyzw + -r0.xyzw;
  r0.xyzw = cb2[4].wwww * r1.xyzw + r0.xyzw;
  r0.w = cb2[3].w * r0.w;
  r0.xyz = cb2[3].www * r0.xyz + -cb2[0].xxx;
  o0.xyz = cb2[3].zzz * r0.xyz + cb2[0].xxx;  // final output color
  o0.w = r0.w;

  o0.xyz = lerp(outputColor, o0.xyz, injectedData.fxSceneFilter);
  return;
}