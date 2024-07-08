// ---- Created with 3Dmigoto v1.3.16 on Sun Jul  7 23:09:00 2024
#include "./shared.h"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
    float4 cb4[7];
}

cbuffer cb3 : register(b3)
{
    float4 cb3[3];
}

cbuffer cb2 : register(b2)
{
    float4 cb2[8];
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
    float4 r0, r1, r2, r3, r4;
    uint4 bitmask, uiDest;
    float4 fDest;

    r0.x = cb4[4].z + -cb4[4].y;
    r0.x = 1 / r0.x;
    r1.xyzw = cb1[45].xyzw * v0.yyyy;
    r1.xyzw = v0.xxxx * cb1[44].xyzw + r1.xyzw;
    r0.yz = asuint(cb0[37].xy);
    r0.yz = v0.xy + -r0.yz;
    r0.yw = cb0[38].zw * r0.yz;
    r2.xy = r0.yw * cb1[130].xy + cb1[129].xy;
    r0.yw = r0.yw * cb0[5].xy + cb0[4].xy;
    r3.xyz = t2.Sample(s1_s, r0.yw).xyz;
    r0.yw = cb1[132].zw * r2.xy;
    r2.x = t0.SampleLevel(s0_s, r0.yw, 0).x;
    r0.y = t1.SampleLevel(s0_s, r0.yw, 0).x;
    r0.y = 255 * r0.y;
    r0.y = (uint) r0.y;
    r0.w = max(1.00000005e-18, r2.x);
    r1.xyzw = r0.wwww * cb1[46].xyzw + r1.xyzw;
    r1.xyzw = cb1[47].xyzw + r1.xyzw;
    r1.xyz = r1.xyz / r1.www;
    r2.xyz = -cb1[70].xyz + r1.xyz;
    r2.xyz = -cb1[67].xyz + r2.xyz;
    r0.w = dot(r2.xyz, r2.xyz);
    r0.w = sqrt(r0.w);
    r0.w = -cb4[4].y + r0.w;
    r0.x = saturate(r0.w * r0.x);
    r0.w = r0.x * -2 + 3;
    r0.x = r0.x * r0.x;
    r0.x = -r0.w * r0.x + 1;
    r0.w = (int) r0.y & 192;
    if (1 == 0)
        r0.y = 0;
    else if (1 + 7 < 32)
    {
        r0.y = (uint) r0.y << (32 - (1 + 7));
        r0.y = (uint) r0.y >> (32 - 1);
    }
    else
        r0.y = (uint) r0.y >> 7;
    if (1 == 0)
        r0.w = 0;
    else if (1 + 6 < 32)
    {
        r0.w = (uint) r0.w << (32 - (1 + 6));
        r0.w = (uint) r0.w >> (32 - 1);
    }
    else
        r0.w = (uint) r0.w >> 6;
    r0.yw = (uint2) r0.yw;
    r0.y = max(r0.y, r0.w);
    r0.x = r0.y * r0.x;
    r0.y = 1 + cb1[18].z;
    r0.y = 0.5 * r0.y;
    r0.w = cb4[2].z + -cb4[2].w;
    r0.y = r0.y * r0.w + cb4[2].w;
    r0.y = r0.z * cb0[38].w + r0.y;
    r0.z = -r0.z * cb0[38].w + 1;
    r0.y = -cb4[3].x + r0.y;
    r0.w = cb4[3].y + -cb4[3].x;
//    r0.y = saturate(r0.y / r0.w);
    r0.y = r0.y / r0.w;
    r2.xyz = float3(-0.5, -0.5, -0.5) + r3.xyz;
    r2.xyz = cb4[2].xxx * r2.xyz;
    r2.xyz = r0.yyy * r2.xyz + float3(0.5, 0.5, 0.5);
    r4.xyz = float3(0.5, 0.5, 0.5) + -r2.xyz;
    r4.xyz = cb4[3].zzz * r4.xyz;
    r0.xyw = r0.xxx * r4.xyz + r2.xyz;
    r2.xyz = float3(1, 1, 1) + -r0.xyw;
    r0.xyw = r3.xyz * r0.xyw;
    r0.xyw = r0.xyw + r0.xyw; //maybe brightness
    r4.xyz = float3(1, 1, 1) + -r3.xyz;
    r3.xyz = cmp(r3.xyz >= float3(0.5, 0.5, 0.5));
    r4.xyz = r4.xyz + r4.xyz;
    r2.xyz = -r4.xyz * r2.xyz + float3(1, 1, 1);
    //r0.xyw = r3.xyz ? r2.xyz : r0.xyw; //vanilla tonemapper
    r0.xyw = float3(1, 1, 1) + -r0.xyw;
    r1.w = dot(-r1.xyz, -r1.xyz);
    r1.w = rsqrt(r1.w);
    r1.xyz = -r1.xyz * r1.www;
    r1.x = dot(-cb3[2].xyz, r1.xyz);
    r1.x = cb4[4].w + r1.x;
 //   r1.x = saturate(r1.x / cb4[5].x);
    r1.x = r1.x / cb4[5].x; //removed saturate
    r1.yzw = cb2[6].xyz + -cb2[5].xyz;
    r1.xyz = r1.xxx * r1.yzw + cb2[5].xyz;
//    r2.xy = saturate(cb4[5].yz + r0.zz);
//    r0.z = saturate(cb4[6].x + r0.z);
    r2.xy = cb4[5].yz + r0.zz; //removed saturate
    r0.z = cb4[6].x + r0.z; //removed saturate
    r1.xyz = -r2.xxx * r1.xyz + float3(1, 1, 1);
    r1.w = cb4[5].w * r2.y;
    r0.xyw = -r0.xyw * r1.xyz + float3(1, 1, 1);
    r1.xyz = float3(1, 1, 1) + -r0.xyw;
    r1.xyz = r1.xyz + r1.xyz;
    r0.z = r0.z * cb4[6].y + -r1.w;
 //   r2.x = saturate(cb1[18].z);
 //   r0.z = saturate(r2.x * r0.z + r1.w);
    r2.x = cb1[18].z; //removed saturate
    r0.z = r2.x * r0.z + r1.w; //removed saturate
    r0.z = cb3[1].x * r0.z;
    r2.xyz = float3(-0.5, -0.5, -0.5) + cb2[7].xyz;
    r2.xyz = r0.zzz * r2.xyz + float3(0.5, 0.5, 0.5);
    r3.xyz = float3(1, 1, 1) + -r2.xyz;
    r2.xyz = r2.xyz * r0.xyw;
    r0.xyz = cmp(r0.xyw >= float3(0.5, 0.5, 0.5));
    r2.xyz = r2.xyz + r2.xyz;
    r1.xyz = -r1.xyz * r3.xyz + float3(1, 1, 1);
    r0.xyz = r0.xyz ? r1.xyz : r2.xyz;
    r1.xyz = cb4[1].xyz + -r0.xyz;
    r0.xyz = cb4[6].zzz * r1.xyz + r0.xyz;
    o0.xyz = max(float3(0, 0, 0), r0.xyz); //idk adrian commented it
    o0.w = 1;
    return;
}