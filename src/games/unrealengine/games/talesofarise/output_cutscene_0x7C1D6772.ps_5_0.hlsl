#include "../../common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 11 12:24:15 2025
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
  float4 cb0[56];
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
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v2.w * 543.309998 + v2.z;
  r0.x = sin(r0.x);
  r0.x = 493013 * r0.x;
  r0.x = frac(r0.x);
  r0.y = -r0.x * r0.x + 1;
  r0.y = cb0[42].z * r0.y;
  r1.xyzw = v2.xyxy + -v0.xyxy;
  r2.xyzw = r1.xyzw * r0.yyyy;
  r0.yz = r0.yy * r1.zw + v0.xy;
  r1.xyzw = cmp(float4(0,0,0,0) < w0.xyxy);
  r3.xyzw = cmp(w0.xyxy < float4(0,0,0,0));
  r1.xyzw = (int4)-r1.xyzw + (int4)r3.xyzw;
  r1.xyzw = (int4)r1.xyzw;
  r3.xyzw = saturate(-cb0[55].zzzz + abs(w0.xyxy));
  r1.xyzw = r3.xyzw * r1.xyzw;
  r1.xyzw = -r1.xyzw * cb0[55].xxyy + w0.xyxy;
  r1.xyzw = r1.xyzw * cb0[45].xyxy + cb0[45].zwzw;
  r1.xyzw = r1.xyzw * cb0[0].zwzw + r2.xyzw;
  r1.xyzw = max(cb0[43].xyxy, r1.xyzw);
  r1.xyzw = min(cb0[43].zwzw, r1.xyzw);
  r2.x = t2.Sample(s2_s, r1.xy).x;
  r2.y = t2.Sample(s2_s, r1.zw).y;
  r1.xy = max(cb0[43].xy, r0.yz);
  r1.xy = min(cb0[43].zw, r1.xy);
  r2.z = t2.Sample(s2_s, r1.xy).z;
  r1.xyz = t2.SampleLevel(s2_s, r0.yz, 0, int2(-1, 0)).xyz;
  r3.xyz = t2.SampleLevel(s2_s, r0.yz, 0, int2(1, 0)).xyz;
  r4.xyz = t2.SampleLevel(s2_s, r0.yz, 0, int2(-1, -1)).xyz;
  r5.xyz = t2.SampleLevel(s2_s, r0.yz, 0, int2(-1, 1)).xyz;
  r0.w = dot(r2.xyz, float3(0.300000012,0.589999974,0.109999999));
  r6.x = dot(r1.xyz, float3(0.300000012,0.589999974,0.109999999));
  r6.y = dot(r3.xyz, float3(0.300000012,0.589999974,0.109999999));
  r6.z = dot(r4.xyz, float3(0.300000012,0.589999974,0.109999999));
  r6.w = dot(r5.xyz, float3(0.300000012,0.589999974,0.109999999));
  r6.xyzw = -r6.xyzw + r0.wwww;
  r6.xy = max(abs(r6.xz), abs(r6.yw));
  r0.w = max(r6.x, r6.y);
  r0.w = saturate(-v1.x * r0.w + 1);
  r0.w = cb0[40].y * -r0.w;
  r1.xyz = r3.xyz + r1.xyz;
  r1.xyz = r1.xyz + r4.xyz;
  r1.xyz = r1.xyz + r5.xyz;
  r1.xyz = -r2.xyz * float3(4,4,4) + r1.xyz;
  r1.xyz = r1.xyz * r0.www + r2.xyz;
  r2.xy = max(cb0[44].xy, v0.xy);
  r2.xy = min(cb0[44].zw, r2.xy);
  r2.xyz = t3.Sample(s3_s, r2.xy).xyz;
  r0.w = cmp(cb0[50].x == 1.000000);
  if (r0.w != 0) {
    r3.xy = asuint(cb0[23].xy);
    r3.xy = v4.xy + -r3.xy;
    r3.xy = cb0[22].zw * r3.xy;
    r3.xyz = t1.SampleLevel(s1_s, r3.xy, 0).xyz;
    r3.xyz = cb2[0].xyz * r3.xyz;
  } else {
    r3.xyz = float3(0,0,0);
  }
  r3.xyz = cb0[39].xyz + r3.xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r1.xyz = r1.xyz * cb0[38].xyz + r2.xyz;
  r0.w = cmp(0 < cb0[47].x);
  if (r0.w != 0) {
    r2.xy = cb1[123].yx * cb1[122].wz;
    r2.zw = r2.xy * r0.zy;
    r3.xyzw = cmp(float4(0,0,0,0) < cb0[49].xyzw);
    r2.xy = -r0.zy * r2.xy + float2(1,1);
    r2.xy = r3.yx ? r2.xy : r2.zw;
    r2.xy = float2(-0.5,-0.5) + r2.xy;
    r2.zw = cb0[48].ww * r2.xy;
    r3.x = cb0[47].w * r2.y + -r2.z;
    r3.y = cb0[47].w * r2.x + r2.w;
    r2.xy = float2(0.5,0.5) + r3.xy;
    r2.xyzw = t5.SampleLevel(s5_s, r2.xy, 0).xyzw;
    r0.w = r3.w ? r3.z : 0;
    r1.w = 1 + -r2.w;
    r4.xyz = saturate(r1.www);
    r5.xyz = float3(0,0,0);
    r5.w = r2.w;
    r4.w = 1;
    r3.xyzw = r3.wwww ? r5.xyzw : r4.xyzw;
    r2.xyzw = r0.wwww ? r2.xyzw : r3.xyzw;
    r2.xyzw = float4(-0,-0,-0,-1) + r2.xyzw;
    r2.xyzw = cb0[47].yyyy * r2.xyzw + float4(0,0,0,1);
    r0.w = dot(float3(0.300000012,0.400000006,0.300000012), r2.xyz);
    r0.w = saturate(0.00100000005 + r0.w);
    r1.w = log2(r0.w);
    r1.w = cb0[47].z * r1.w;
    r1.w = exp2(r1.w);
    r0.w = 0.00100000005 + r0.w;
    r0.w = r1.w / r0.w;
    r2.xyz = r0.www * r2.xyz;
    r2.xyz = cb0[48].xyz * r2.xyz;
    r1.xyz = r2.www * r1.xyz + r2.xyz;
  }
  r0.w = cmp(cb0[53].x == 1.000000);
  if (r0.w != 0) {
    r0.y = t0.SampleLevel(s0_s, r0.yz, 0).w;
    r0.y = 255 * r0.y;
    r0.y = round(r0.y);
    r0.y = (uint)r0.y;
    r0.y = (int)r0.y & 15;
    r0.y = cmp((uint)r0.y < 11);
    r0.yzw = r0.yyy ? float3(0,1,1) : float3(1,1,0);
    r2.xyz = r0.yzy;
    o0.w = r0.w;
  } else {
    r0.yzw = v1.xxx * r1.xyz;
    r1.xy = cb0[40].xx * v1.yz;
    r1.x = dot(r1.xy, r1.xy);
    r1.x = 1 + r1.x;
    r1.x = rcp(r1.x);
    r1.x = r1.x * r1.x;
    r0.yzw = r1.xxx * r0.yzw;
    r1.x = r0.x * cb0[42].x + cb0[42].y;
    r0.yzw = r0.yzw * r1.xxx + float3(0.00266771927,0.00266771927,0.00266771927);
    r0.yzw = log2(r0.yzw);
    r0.yzw = saturate(r0.yzw * float3(0.0714285746,0.0714285746,0.0714285746) + float3(0.610726953,0.610726953,0.610726953));
    r0.yzw = r0.yzw * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
    r0.yzw = t4.Sample(s4_s, r0.yzw).xyz;
    r1.xyz = float3(1.04999995,1.04999995,1.04999995) * r0.yzw;
    o0.w = saturate(dot(r1.xyz, float3(0.298999995,0.587000012,0.114)));
    r0.x = r0.x * 0.00390625 + -0.001953125;
    r2.xyz = r0.yzw * float3(1.04999995,1.04999995,1.04999995) + r0.xxx;
  }
  
  //r0.xyz = log2(r2.xyz);
  //r0.xyz = cb0[50].www * r0.xyz;
  //o0.xyz = exp2(r0.xyz);

  o0.rgb = renodx::math::SignPow(r2.xyz, cb0[50].w);

  return;
}