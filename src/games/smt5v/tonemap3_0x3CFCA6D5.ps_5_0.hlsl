// ---- Created with 3Dmigoto v1.3.16 on Tue Jul  9 20:53:56 2024
//unclamps tokyo/gameworld

#include "./shared.h"
#include "../../shaders/colorcorrect.hlsl"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[15];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[3];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[133];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[39];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cb3[12].w + -cb3[12].z;
  r0.x = 1 / r0.x;
  r0.y = cb3[11].z + -cb3[11].w;
  r0.z = 1 + cb1[18].z;
  r0.z = 0.5 * r0.z;
  r0.y = r0.z * r0.y + cb3[11].w;
  r0.z = r0.z * -cb3[14].x + cb3[14].x;
  r1.xy = asuint(cb0[37].xy);
  r1.xy = v0.xy + -r1.xy;
  r0.y = r1.y * cb0[38].w + r0.y;
  r0.y = -0.5 + r0.y;
  r0.y = -cb3[12].z + r0.y;
  r0.x = saturate(r0.y * r0.x);
  r0.y = r0.x * -2 + 3;
  r0.x = r0.x * r0.x;
  r0.x = r0.y * r0.x;
  r0.x = min(1, r0.x);
  r0.y = 1 + -cb3[11].x;
  r0.y = abs(cb1[18].z) * r0.y + cb3[11].x;
  r2.xyzw = cb1[45].xyzw * v0.yyyy;
  r2.xyzw = v0.xxxx * cb1[44].xyzw + r2.xyzw;
  r1.xz = cb0[38].zw * r1.xy;
  r3.xy = r1.xz * cb1[130].xy + cb1[129].xy;
  r1.xz = r1.xz * cb0[5].xy + cb0[4].xy;
  r1.xzw = t2.Sample(s1_s, r1.xz).xyz;
  r3.xy = cb1[132].zw * r3.xy;
  r0.w = t0.SampleLevel(s0_s, r3.xy, 0).x;
  r3.x = t1.SampleLevel(s0_s, r3.xy, 0).x;
  r3.x = 255 * r3.x;
  r3.x = (uint)r3.x;
  r0.w = max(1.00000005e-18, r0.w);
  r2.xyzw = r0.wwww * cb1[46].xyzw + r2.xyzw;
  r2.xyzw = cb1[47].xyzw + r2.xyzw;
  r2.xyz = r2.xyz / r2.www;
  r3.yz = -cb1[70].xy + r2.xy;
  r3.yz = -cb1[67].xy + r3.yz;
  r0.w = dot(r3.yz, r3.yz);
  r0.w = sqrt(r0.w);
  r0.w = -cb3[10].x + r0.w;
  r2.w = cb3[10].y + -cb3[10].x;
  r2.w = 1 / r2.w;
  r0.w = saturate(r2.w * r0.w);
  r2.w = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r2.w * r0.w;
  r3.yzw = r1.xzw * cb3[9].yyy + float3(-0.5,-0.5,-0.5);
  r3.yzw = r0.www * r3.yzw + float3(0.5,0.5,0.5);
  r0.w = saturate(r1.x / cb3[10].w);
  r4.xyz = r0.www * r0.yyy + -r3.yzw;
  r0.xyw = r0.xxx * r4.xyz + r3.yzw;
  r2.w = dot(-r2.xyz, -r2.xyz);
  r2.w = rsqrt(r2.w);
  r2.xyz = -r2.xyz * r2.www;
  r2.x = dot(-cb2[2].xyz, r2.xyz);
  r2.x = cb3[13].y + r2.x;
  r2.x = saturate(r2.x / cb3[13].z);
  r2.yzw = -cb3[5].xyz + cb3[4].xyz;
  r2.xyz = r2.xxx * r2.yzw + cb3[5].xyz;
  r2.xyz = r2.xyz + -r0.xyw;
  r2.w = -r1.y * cb0[38].w + cb3[13].w;
  r1.y = saturate(r1.y * cb0[38].w + -0.5);
  r2.w = 1 + r2.w;
  r0.z = saturate(r2.w + -r0.z);
  r0.xyz = r0.zzz * r2.xyz + r0.xyw;
  r2.xyz = float3(0.5,0.5,0.5) + -r0.xyz;
  r2.xyz = cb3[14].yyy * r2.xyz;
  r0.w = (int)r3.x & 192;
  if (1 == 0) r2.w = 0; else if (1+7 < 32) {   r2.w = (uint)r3.x << (32-(1 + 7)); r2.w = (uint)r2.w >> (32-1);  } else r2.w = (uint)r3.x >> 7;
  r2.w = (uint)r2.w;
  if (1 == 0) r0.w = 0; else if (1+6 < 32) {   r0.w = (uint)r0.w << (32-(1 + 6)); r0.w = (uint)r0.w >> (32-1);  } else r0.w = (uint)r0.w >> 6;
  r0.w = (uint)r0.w;
  r0.w = max(r2.w, r0.w);
  r0.xyz = r0.www * r2.xyz + r0.xyz;
  r2.xyz = float3(1,1,1) + -r0.xyz;
  r0.xyz = r1.xzw * r0.xyz;
  r0.xyz = r0.xyz + r0.xyz;
  r3.xyz = float3(1,1,1) + -r1.xzw;
  r1.xzw = cmp(r1.xzw >= float3(0.5,0.5,0.5));
  r3.xyz = r3.xyz + r3.xyz;
  r2.xyz = -r3.xyz * r2.xyz + float3(1,1,1);
    //unclamp 80 nits
    if (injectedData.toneMapType == 0.f)
    {
        r0.xyz = r1.xzw ? r2.xyz : r0.xyz; //unclamp
    }
  r1.xzw = float3(-1,-1,-1) + cb3[7].xyz;
  r1.xyz = r1.yyy * r1.xzw + float3(1,1,1);
  r2.xyz = r1.xyz * r0.xyz;
  r0.xyz = -r0.xyz * r1.xyz + cb3[8].xyz;
  r0.xyz = cb3[14].zzz * r0.xyz + r2.xyz;
  o0.xyz = max(float3(0,0,0), r0.xyz);
  o0.w = 1;
  
    //add paper white
    
    o0.rgb = sign(o0.rgb) * pow(abs(o0.rgb), 2.2f); // linear to 2.2

    
    o0.xyz *= injectedData.toneMapGameNits / 80.f; //paper white
    
    
  return;
}