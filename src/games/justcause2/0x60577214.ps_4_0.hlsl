// ---- Created with 3Dmigoto v1.3.16 on Wed Sep 09 00:11:08 2026
#include "./common.hlsl"
Texture2D<float4> t8 : register(t8);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s8_s : register(s8);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[10];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t5.Sample(s5_s, v1.zw).xyzw;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r0.xy = r0.xy * float2(0.00999999978,0.00999999978) + v1.xy;
  r1.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r0.z = r1.x * cb1[2].z + cb1[2].w;
  r0.z = 1 / r0.z;
  r0.w = -cb1[5].x + r0.z;
  r0.z = cb1[5].z + -r0.z;
  r0.zw = saturate(cb1[5].wy * r0.zw);
  r0.z = r0.w + r0.z;
  r0.z = saturate(r0.z * cb1[0].w + cb1[0].z);
  r2.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r3.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.yzw = -r3.xyz + r2.xyz;
  r1.yzw = r0.zzz * r1.yzw + r3.xyz;
  r2.xyz = -r1.yzw * float3(2,2,2) + float3(2,2,2);
  r1.yzw = r1.yzw + r1.yzw;
  r3.xyzw = t4.Sample(s4_s, r0.xy).xyzw;
  r4.xyz = float3(-0.5,-0.5,-0.5) + r3.xyz;
  r3.xyz = cmp(r3.xyz < float3(0.5,0.5,0.5));
  r5.xyz = cb1[3].xxx * r4.xyz + float3(0.5,0.5,0.5);
  r4.xyz = cb1[3].yyy * r4.xyz + float3(0.5,0.5,0.5);
  r1.yzw = r4.xyz * r1.yzw;
  r4.xyz = float3(1,1,1) + -r5.xyz;
  r2.xyz = -r2.xyz * r4.xyz + float3(1,1,1);
  r1.yzw = r3.xyz ? r1.yzw : r2.xyz;
  r0.z = dot(r1.yzw, float3(0.212500006,0.715399981,0.0720999986));
  r1.yzw = r1.yzw + -r0.zzz;
  r0.w = r0.z * cb1[4].y + cb1[4].x;
  r0.w = max(cb1[4].z, r0.w);
  r0.w = min(cb1[4].w, r0.w);
  r1.yzw = r0.www * r1.yzw + r0.zzz;
  r2.xyzw = t3.Sample(s3_s, float2(0.5,0.5)).xyzw;
  r0.z = cb1[2].x + r2.x;
  r1.yzw = r1.yzw * r0.zzz;
  r1.yzw = cb1[1].xyz * r1.yzw;
  r2.xyzw = cb1[7].xyzw * r0.yyyy;
  r0.xyzw = r0.xxxx * cb1[6].xyzw + r2.xyzw;
  r0.xyzw = r1.xxxx * cb1[8].xyzw + r0.xyzw;
  r0.xyzw = cb1[9].xyzw + r0.xyzw;
  r0.xyz = r0.xyz / r0.www;
  r2.xyz = cb0[5].xyz + -r0.xyz;
  r0.w = dot(r2.xyz, r2.xyz);
  r0.w = 0.0700000003 * r0.w;
  r0.w = 1 / r0.w;
  r0.w = min(0.400000006, r0.w);
  r1.x = saturate(200 + -r0.y);
  r0.xy = -r0.yy * float2(0.25,0.25) + r0.xz;
  r0.z = r1.x * r0.w;
  r0.w = 0.200000003 + cb0[6].y;
  r0.w = max(0.100000001, r0.w);
  r0.w = r0.w + r0.w;
  r0.w = min(1, r0.w);
  r2.xy = float2(0.300000012,0.300000012) * r0.xy;
  r0.xy = float2(0.0799999982,0.0799999982) * r0.xy;
  r3.xyzw = t6.Sample(s6_s, r0.xy).xyzw;
  r2.xyzw = t6.Sample(s6_s, r2.xy).xyzw;
  r0.x = r2.w * 0.5 + r3.w;
  r0.x = r0.x + r0.x;
  r0.yz = r0.xz * r0.xw;
  r0.x = r0.x * r0.y;
  r0.x = r0.z * r0.x + 1;
  r0.xyz = r1.yzw * r0.xxx;
  r1.xy = float2(-0.5,-0.5) + v1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = -0.349999994 + r0.w;
  r0.w = saturate(2.20000005 * r0.w);
  r0.w = 1 + -r0.w;
  r1.xy = v1.xy * float2(16,8) + cb1[3].zw;
  r1.xyzw = t8.Sample(s8_s, r1.xy).xyzw;
  r1.x = -0.5 + r1.x;
  r1.x = 0.0179999992 * r1.x;
  r0.xyz = r0.xyz * r0.www + r1.xxx;
  o0.xyz = sqrt(r0.xyz);
  // Preserve vanilla when live-loaded without the game's injection buffer.
  if (shader_injection.peak_white_nits >= 48.f && shader_injection.resource_upgrade != 0.f) {
    o0.xyz = Jc2CompositeIntermediate(r0.xyz);
  }
  o0.w = 1;
  return;
}