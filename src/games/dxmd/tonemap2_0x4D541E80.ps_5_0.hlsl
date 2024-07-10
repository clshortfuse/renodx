// ---- Created with 3Dmigoto v1.3.16 on Tue Jul  9 19:31:08 2024
// unclamps shops and other out of magic world elements

#include "./shared.h"
#include "../../shaders/colorcorrect.hlsl"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[13];
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

  r0.x = 1 + cb1[18].z;
  r0.x = 0.5 * r0.x;
  r0.y = saturate(r0.x);
  r0.z = r0.y * -2 + 3;
  r0.y = r0.y * r0.y;
  r0.y = r0.z * r0.y;
  r0.zw = asuint(cb0[37].xy);
  r0.zw = v0.xy + -r0.zw;
  r1.x = -r0.w * cb0[38].w + 1;
  r1.yz = saturate(cb3[10].xz + r1.xx);
  r1.x = cb3[12].x + r1.x;
  r1.y = cb3[10].y * r1.y;
  r1.z = r1.z * cb3[10].w + -r1.y;
  r0.y = r0.y * r1.z + r1.y;
  r1.y = cb3[8].z + -cb3[8].w;
  r1.y = r0.x * r1.y + cb3[8].w;
  r0.x = r0.x * -cb3[12].y + cb3[12].y;
  r0.x = saturate(r1.x + -r0.x);
  r1.x = r0.w * cb0[38].w + r1.y;
  r0.zw = cb0[38].zw * r0.zw;
  r1.x = -0.5 + r1.x;
  r1.x = -cb3[9].z + r1.x;
  r1.y = cb3[9].w + -cb3[9].z;
  r1.x = saturate(r1.x / r1.y);
  r1.yz = r0.zw * cb0[5].xy + cb0[4].xy;
  r0.zw = r0.zw * cb1[130].xy + cb1[129].xy;
  r0.zw = cb1[132].zw * r0.zw;
  r1.yzw = t2.Sample(s1_s, r1.yz).xyz;
  r2.xyz = float3(-0.5,-0.5,-0.5) + r1.yzw;
  r2.xyz = cb3[8].xxx * r2.xyz;
  r2.xyz = r1.xxx * r2.xyz + float3(0.5,0.5,0.5);
  r3.xyz = cb3[2].xyz + -r2.xyz;
  r2.xyz = r0.yyy * r3.xyz + r2.xyz;
  r0.y = t0.SampleLevel(s0_s, r0.zw, 0).x;
  r0.z = t1.SampleLevel(s0_s, r0.zw, 0).x;
  r0.z = 255 * r0.z;
  r0.z = (uint)r0.z;
  r0.y = max(1.00000005e-18, r0.y);
  r3.xyzw = cb1[45].xyzw * v0.yyyy;
  r3.xyzw = v0.xxxx * cb1[44].xyzw + r3.xyzw;
  r3.xyzw = r0.yyyy * cb1[46].xyzw + r3.xyzw;
  r3.xyzw = cb1[47].xyzw + r3.xyzw;
  r3.xyz = r3.xyz / r3.www;
  r0.y = dot(-r3.xyz, -r3.xyz);
  r0.y = rsqrt(r0.y);
  r3.xyz = -r3.xyz * r0.yyy;
  r0.y = dot(-cb2[2].xyz, r3.xyz);
  r0.y = cb3[11].y + r0.y;
  r0.y = saturate(r0.y / cb3[11].z);
  r0.w = -1 + cb3[11].w;
  r0.w = r0.y * r0.w;
  r0.w = r0.x * r0.w + 1;
  r3.xyz = -r2.xyz * r0.www + float3(0.5,0.5,0.5);
  r2.xyz = r2.xyz * r0.www;
  r3.xyz = cb3[12].zzz * r3.xyz;
  r0.w = (int)r0.z & 192;
  if (1 == 0) r0.z = 0; else if (1+7 < 32) {   r0.z = (uint)r0.z << (32-(1 + 7)); r0.z = (uint)r0.z >> (32-1);  } else r0.z = (uint)r0.z >> 7;
  if (1 == 0) r0.w = 0; else if (1+6 < 32) {   r0.w = (uint)r0.w << (32-(1 + 6)); r0.w = (uint)r0.w >> (32-1);  } else r0.w = (uint)r0.w >> 6;
  r0.zw = (uint2)r0.zw;
  r0.z = max(r0.z, r0.w);
  r2.xyz = r0.zzz * r3.xyz + r2.xyz;
  r3.xyz = float3(1,1,1) + -r2.xyz;
  r2.xyz = r2.xyz * r1.yzw;
  r2.xyz = r2.xyz + r2.xyz;
  r4.xyz = float3(1,1,1) + -r1.yzw;
  r1.xyz = cmp(r1.yzw >= float3(0.5,0.5,0.5));
  r4.xyz = r4.xyz + r4.xyz;
  r3.xyz = -r4.xyz * r3.xyz + float3(1,1,1);
  r1.xyz = r1.xyz ? r3.xyz : r2.xyz; //test unclamp
  r1.xyz = float3(1,1,1) + -r1.xyz;
  r2.xyz = -cb3[6].xyz + cb3[5].xyz;
  r0.yzw = r0.yyy * r2.xyz + cb3[6].xyz;
  r0.xyz = -r0.xxx * r0.yzw + float3(1,1,1);
  r0.xyz = -r1.xyz * r0.xyz + float3(1,1,1);
  r1.xyz = cb3[7].xyz + -r0.xyz;
  r0.xyz = cb3[12].www * r1.xyz + r0.xyz;
  o0.xyz = max(float3(0,0,0), r0.xyz);
  o0.w = 1;
  
    
        //add paper white
    
 //   o0.rgb = sign(o0.rgb) * pow(abs(o0.rgb), 2.2f); // linear

    
 //   o0.xyz *= injectedData.toneMapGameNits / 80.f; //paper white
  
  return;
}