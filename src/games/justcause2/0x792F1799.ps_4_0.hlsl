// ---- Created with 3Dmigoto v1.3.16 on Wed Sep 09 00:11:08 2026
#include "./common.hlsl"
Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[6];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float4 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.x = r0.x * cb1[2].z + cb1[2].w;
  r0.x = 1 / r0.x;
  r0.y = -cb1[5].x + r0.x;
  r0.x = cb1[5].z + -r0.x;
  r0.xy = saturate(cb1[5].wy * r0.xy);
  r0.x = r0.y + r0.x;
  r0.x = saturate(r0.x * cb1[0].w + cb1[0].z);
  r0.yz = float2(4,4) * v1.zw;
  r1.xyzw = t5.Sample(s5_s, r0.yz).xyzw;
  r0.yz = r1.xy * float2(2,2) + float2(-1,-1);
  r0.yz = r0.yz * cb1[0].xx + v1.xy;
  r1.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.yzw = -r2.xyz + r1.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  r1.xyz = -r0.xyz * float3(2,2,2) + float3(2,2,2);
  r0.xyz = r0.xyz + r0.xyz;
  r2.xyzw = t4.Sample(s4_s, v1.xy).xyzw;
  r3.xyz = float3(-0.5,-0.5,-0.5) + r2.xyz;
  r2.xyz = cmp(r2.xyz < float3(0.5,0.5,0.5));
  r4.xyz = cb1[3].xxx * r3.xyz + float3(0.5,0.5,0.5);
  r3.xyz = cb1[3].yyy * r3.xyz + float3(0.5,0.5,0.5);
  r0.xyz = r3.xyz * r0.xyz;
  r3.xyz = float3(1,1,1) + -r4.xyz;
  r1.xyz = -r1.xyz * r3.xyz + float3(1,1,1);
  r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  r0.w = dot(r0.xyz, float3(0.212500006,0.715399981,0.0720999986));
  r0.xyz = r0.xyz + -r0.www;
  r1.x = r0.w * cb1[4].y + cb1[4].x;
  r1.x = max(cb1[4].z, r1.x);
  r1.x = min(cb1[4].w, r1.x);
  r0.xyz = r1.xxx * r0.xyz + r0.www;
  r1.xyzw = t3.Sample(s3_s, float2(0.5,0.5)).xyzw;
  r0.w = cb1[2].x + r1.x;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = cb1[1].xyz * r0.xyz;
  r1.xy = float2(-0.5,-0.5) + v1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = sqrt(r0.w);
  r0.w = -0.349999994 + r0.w;
  r0.w = saturate(2.20000005 * r0.w);
  r0.w = 1 + -r0.w;
  r0.xyz = r0.xyz * r0.www;
  o0.xyz = sqrt(r0.xyz);
  // Preserve vanilla when live-loaded without the game's injection buffer.
  if (shader_injection.peak_white_nits >= 48.f && shader_injection.resource_upgrade != 0.f) {
    o0.xyz = Jc2CompositeIntermediate(r0.xyz);
  }
  o0.w = 1;
  return;
}