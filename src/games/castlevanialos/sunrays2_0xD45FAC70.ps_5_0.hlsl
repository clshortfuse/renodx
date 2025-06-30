#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Wed Apr 16 00:59:22 2025
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
  float4 cb4[236];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[77];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD8,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float4 v4 : TEXCOORD9,
  float4 v5 : TEXCOORD0,
  float4 v6 : TEXCOORD1,
  float4 v7 : TEXCOORD2,
  float4 v8 : TEXCOORD3,
  float4 v9 : TEXCOORD4,
  float4 v10 : TEXCOORD5,
  float4 v11 : TEXCOORD6,
  float4 v12 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
  ////r0.xyzw = (int4)r0.xyzw & asint(cb3[44].xyzw);
  ////r0.xyzw = (int4)r0.xyzw | asint(cb3[45].xyzw);

  // Sun Ray Direction
  r1.xy = -v5.xy + cb4[8].xy;


  r2.z = dot(r1.xy, r1.xy);
  /*r1.z = 0 + r2.z;
  r2.y = rsqrt(abs(r1.z));
  r2.x = cmp((int)r2.y == 0x7f800000);
  r1.z = r2.x ? 99999999 : r2.y;
  /*r2.y = cmp(0 < abs(r1.z));
  r2.x = rcp(r1.z);
  r1.z = saturate(r2.y ? r2.x : 99999999);*/
  r1.z = sqrt(r2.z);
  r2.xyzw = r0.xyzw;
  r3.xy = v5.xy;
  r4.xyz = float3(19,0,0);
  r4.xyz = max(int3(0,0,-128), (int3)r4.xyz);
  while (true) {
    if (r4.x == 0) break;

    // Sun Ray Length
    //r3.xy = r1.xy * cb4[8].ww + r3.xy;
    r3.xy = r1.xy * (cb4[8].ww * CUSTOM_SUN_RAY_LENGTH) + r3.xy;

    r5.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
    //r5.xyzw = (int4)r5.xyzw & asint(cb3[44].xyzw);
    //r5.xyzw = (int4)r5.xyzw | asint(cb3[45].xyzw);
    r2.xyzw = r5.xyzw + r2.xyzw;
    r4.x = (int)r4.x + -1;
  }
  r0.x = saturate(1.5 + -r1.z);

  // Sun Ray Intensity
  //r0.x = cb4[8].z * r0.x;
  r0.x = (cb4[8].z * CUSTOM_SUN_RAY_INTENSITY) * r0.x;

  r0.xyzw = r2.xyzw * r0.xxxx;
  o0.xyzw = float4(0.05,0.05,0.05,0.05) * r0.xyzw;
  return;
}