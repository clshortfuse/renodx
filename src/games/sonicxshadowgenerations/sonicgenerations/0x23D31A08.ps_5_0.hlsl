// ---- Created with 3Dmigoto v1.3.16 on Thu Nov 19 05:03:48 2026

cbuffer col_gamma : register(b0)
{
  float4 gammaTable : packoffset(c0);
}

SamplerState tex0_sampler_s : register(s0);
Texture2D<float4> tex0_NedSmpignorenametexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0;
  r0.z = gammaTable.x;
  r1.x = 1;
  r1.yz = gammaTable.xy;
  r2.x = 2;
  r2.yz = gammaTable.yz;
  r3.x = 3;
  r3.yz = gammaTable.zw;
  r4.xyzw = tex0_NedSmpignorenametexture.Sample(tex0_sampler_s, v2.xy).xyzw;
  r4.xyzw = v1.xyzw * r4.xyzw;
  r5.xyzw = cmp(r4.xxxy < float4(0.25,0.5,0.75,0.25));
  r6.xyz = r5.zzz ? r2.xyz : r3.xyz;
  r6.xyz = r5.yyy ? r1.xyz : r6.xyz;
  r5.xyz = r5.xxx ? r0.xxz : r6.xyz;
  r0.y = r4.x * 4 + -r5.x;
  r0.w = r5.z + -r5.y;
  o0.x = r0.y * r0.w + r5.y;
  r6.xyzw = cmp(r4.zwww < float4(0.75,0.25,0.5,0.75));
  r5.xyz = r6.www ? r2.xyz : r3.xyz;
  r5.xyz = r6.zzz ? r1.xyz : r5.xyz;
  r5.xyz = r6.yyy ? r0.xxz : r5.xyz;
  r6.xyz = r6.xxx ? r2.xyz : r3.xyz;
  r0.y = r4.w * 4 + -r5.x;
  r0.w = r5.z + -r5.y;
  o0.w = r0.y * r0.w + r5.y;
  r7.xyzw = cmp(r4.yyzz < float4(0.5,0.75,0.25,0.5));
  r2.xyz = r7.yyy ? r2.xyz : r3.xyz;
  r2.xyz = r7.xxx ? r1.xyz : r2.xyz;
  r1.xyz = r7.www ? r1.xyz : r6.xyz;
  r1.xyz = r7.zzz ? r0.xxz : r1.xyz;
  r0.xyz = r5.www ? r0.xxz : r2.xyz;
  r0.x = r4.y * 4 + -r0.x;
  r0.w = r4.z * 4 + -r1.x;
  r0.z = r0.z + -r0.y;
  o0.y = r0.x * r0.z + r0.y;
  r0.x = r1.z + -r1.y;
  o0.z = r0.w * r0.x + r1.y;
  return;
}