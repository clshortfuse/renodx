#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 11 12:22:43 2025
Texture2D<float4> t5 : register(t5);

Texture3D<float4> t4 : register(t4);

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

cbuffer cb2 : register(b2)
{
  float4 cb2[1];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[124];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[54];
}




// 3Dmigoto declarations
#define cmp -


void main(
  linear noperspective float2 v0 : TEXCOORD0,
  linear noperspective float2 w0 : TEXCOORD3,
  linear noperspective float4 v1 : TEXCOORD1,
  linear noperspective float4 v2 : TEXCOORD2,
  float2 v3 : TEXCOORD4,
  float4 v4 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t2.Sample(s2_s, v0.xy).xyz;
  r1.xyz = t2.SampleLevel(s2_s, v0.xy, 0, int2(-1, 0)).xyz;
  r2.xyz = t2.SampleLevel(s2_s, v0.xy, 0, int2(1, 0)).xyz;
  r3.xyz = t2.SampleLevel(s2_s, v0.xy, 0, int2(-1, -1)).xyz;
  r4.xyz = t2.SampleLevel(s2_s, v0.xy, 0, int2(-1, 1)).xyz;
  r0.w = dot(r0.xyz, float3(0.300000012,0.589999974,0.109999999));
  r5.x = dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999));
  r5.y = dot(r2.xyz, float3(0.300000012,0.589999974,0.109999999));
  r5.z = dot(r3.xyz, float3(0.300000012,0.589999974,0.109999999));
  r5.w = dot(r4.xyz, float3(0.300000012,0.589999974,0.109999999));
  r5.xyzw = -r5.xyzw + r0.wwww;
  r5.xy = max(abs(r5.xz), abs(r5.yw));
  r0.w = max(r5.x, r5.y);
  r0.w = saturate(-v1.x * r0.w + 1);
  r0.w = cb0[40].y * -r0.w;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = r1.xyz + r3.xyz;
  r1.xyz = r1.xyz + r4.xyz;
  r1.xyz = -r0.xyz * float3(4,4,4) + r1.xyz;
  r0.xyz = r1.xyz * r0.www + r0.xyz;
  r1.xy = max(cb0[44].xy, v0.xy);
  r1.xy = min(cb0[44].zw, r1.xy);
  r1.xyz = t3.Sample(s3_s, r1.xy).xyz;
  r0.w = cmp(cb0[50].x == 1.000000);
  if (r0.w != 0) {
    r2.xy = asuint(cb0[23].xy);
    r2.xy = v4.xy + -r2.xy;
    r2.xy = cb0[22].zw * r2.xy;
    r2.xyz = t1.SampleLevel(s1_s, r2.xy, 0).xyz;
    r2.xyz = cb2[0].xyz * r2.xyz;
  } else {
    r2.xyz = float3(0,0,0);
  }
  r2.xyz = cb0[39].xyz + r2.xyz;
  r1.xyz = r2.xyz * r1.xyz;
  r0.xyz = r0.xyz * cb0[38].xyz + r1.xyz;
  r0.w = cmp(0 < cb0[47].x);
  if (r0.w != 0) {
    r1.xy = cb1[123].yx * cb1[122].wz;
    r1.zw = v0.yx * r1.xy;
    r2.xyzw = cmp(float4(0,0,0,0) < cb0[49].xyzw);
    r1.xy = -v0.yx * r1.xy + float2(1,1);
    r1.xy = r2.yx ? r1.xy : r1.zw;
    r1.xy = float2(-0.5,-0.5) + r1.xy;
    r1.zw = cb0[48].ww * r1.xy;
    r2.x = cb0[47].w * r1.y + -r1.z;
    r2.y = cb0[47].w * r1.x + r1.w;
    r1.xy = float2(0.5,0.5) + r2.xy;
    r1.xyzw = t5.SampleLevel(s5_s, r1.xy, 0).xyzw;
    r0.w = r2.w ? r2.z : 0;
    r2.x = 1 + -r1.w;
    r3.xyz = saturate(r2.xxx);
    r4.xyz = float3(0,0,0);
    r4.w = r1.w;
    r3.w = 1;
    r2.xyzw = r2.wwww ? r4.xyzw : r3.xyzw;
    r1.xyzw = r0.wwww ? r1.xyzw : r2.xyzw;
    r1.xyzw = float4(-0,-0,-0,-1) + r1.xyzw;
    r1.xyzw = cb0[47].yyyy * r1.xyzw + float4(0,0,0,1);
    r0.w = dot(float3(0.300000012,0.400000006,0.300000012), r1.xyz);
    r0.w = saturate(0.00100000005 + r0.w);
    r2.x = log2(r0.w);
    r2.x = cb0[47].z * r2.x;
    r2.x = exp2(r2.x);
    r0.w = 0.00100000005 + r0.w;
    r0.w = r2.x / r0.w;
    r1.xyz = r0.www * r1.xyz;
    r1.xyz = cb0[48].xyz * r1.xyz;
    r0.xyz = r1.www * r0.xyz + r1.xyz;
  }
  r0.w = cmp(cb0[53].x == 1.000000);
  if (r0.w != 0) {
    r0.w = t0.SampleLevel(s0_s, v0.xy, 0).w;
    r0.w = 255 * r0.w;
    r0.w = round(r0.w);
    r0.w = (uint)r0.w;
    r0.w = (int)r0.w & 15;
    r0.w = cmp((uint)r0.w < 11);
    r1.xyz = r0.www ? float3(0,1,1) : float3(1,1,0);
    r1.xyw = r1.xyx;
    o0.w = r1.z;
  } else {
    r0.w = v2.w * 543.309998 + v2.z;
    r0.w = sin(r0.w);
    r0.w = 493013 * r0.w;
    r0.w = frac(r0.w);
    r0.xyz = v1.xxx * r0.xyz;
    r2.xy = cb0[40].xx * v1.yz;
    r1.z = dot(r2.xy, r2.xy);
    r1.z = 1 + r1.z;
    r1.z = rcp(r1.z);
    r1.z = r1.z * r1.z;
    r0.xyz = r0.xyz * r1.zzz + float3(0.00266771927,0.00266771927,0.00266771927);
    r0.xyz = log2(r0.xyz);
    r0.xyz = saturate(r0.xyz * float3(0.0714285746,0.0714285746,0.0714285746) + float3(0.610726953,0.610726953,0.610726953));
    r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r0.xyz = t4.Sample(s4_s, r0.xyz).xyz;
    r2.xyz = float3(1.04999995,1.04999995,1.04999995) * r0.xyz;
    o0.w = saturate(dot(r2.xyz, float3(0.298999995,0.587000012,0.114)));
    r0.w = r0.w * 0.00390625 + -0.001953125;
    r1.xyw = r0.xyz * float3(1.04999995,1.04999995,1.04999995) + r0.www;
  }

  //r0.xyz = log2(r1.xyw);
  //r0.xyz = cb0[50].www * r0.xyz;
  //o0.xyz = exp2(r0.xyz);

  o0.rgb = renodx::math::SignPow(r1.xyw, cb0[50].w);

  return;
}