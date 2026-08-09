// ---- Created with 3Dmigoto v1.3.16 on Fri Dec 26 12:55:04 2025
Texture3D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[7];
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

  r0.xy = cb0[5].zw + v1.xy;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r0.xyz = cb0[6].www * r0.xyz;
  r1.xy = -cb0[5].zw + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[6].www + r0.xyz;
  r1.xy = cb0[6].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[6].www + r0.xyz;
  r1.xy = -cb0[6].xy + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[6].www + r0.xyz;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = r1.xyz * cb0[6].zzz + -r0.xyz;
  o0.w = r1.w;
  r1.xyz = float3(0.57735002,0.57735002,0.57735002) * r0.zxy;
  r1.xyz = r0.zxy * float3(0.57735002,0.57735002,0.57735002) + -r1.zxy;
  r0.w = 0.0174532924 * cb0[4].x;
  sincos(r0.w, r2.x, r3.x);
  r1.xyz = r2.xxx * r1.xyz;
  r1.xyz = r0.xyz * r3.xxx + r1.xyz;
  r0.x = dot(float3(0.57735002,0.57735002,0.57735002), r0.xyz);
  r0.x = 0.57735002 * r0.x;
  r0.y = 1 + -r3.x;
  r0.xyz = r0.xxx * r0.yyy + r1.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[4].www + float3(0.5,0.5,0.5);
  r1.xyz = cb0[4].zzz * r0.xyz;
  r0.w = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
  r0.xyz = r0.xyz * cb0[4].zzz + -r0.www;
  r0.xyz = cb0[4].yyy * r0.xyz + r0.www;
  r1.xyz = r0.xyz * cb0[5].xxx + cb0[5].yyy;
  r1.xyzw = t1.Sample(s1_s, r1.xyz).xyzw;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[2].xxx * r1.xyz + r0.xyz;
  o0.xyz = cb0[3].xyz * r0.xyz;
  return;
}