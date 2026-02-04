// ---- Created with 3Dmigoto v1.4.1 on Wed Feb  4 06:20:19 2026
#include "../common.hlsl"

Texture2D<float4> t23 : register(t23);

Texture3D<float4> t22 : register(t22);

Texture3D<float4> t21 : register(t21);

Texture3D<float4> t20 : register(t20);

Texture3D<float4> t19 : register(t19);

Texture3D<float4> t18 : register(t18);

Texture3D<float4> t17 : register(t17);

Texture3D<float4> t16 : register(t16);

Texture2D<float4> t15 : register(t15);

Texture2D<float4> t14 : register(t14);

Texture2D<float4> t13 : register(t13);

Texture2D<float4> t12 : register(t12);

Texture2D<float4> t11 : register(t11);

Texture2D<float4> t10 : register(t10);

Texture2D<float4> t9 : register(t9);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2DArray<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

struct t0_t {
  float val[1];
};
StructuredBuffer<t0_t> t0 : register(t0);

SamplerState s9_s : register(s9);

SamplerState s8_s : register(s8);

SamplerState s7_s : register(s7);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerComparisonState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb7 : register(b7)
{
  float4 cb7[160];
}

cbuffer cb6 : register(b6)
{
  float4 cb6[715];
}

cbuffer cb5 : register(b5)
{
  float4 cb5[2054];
}

cbuffer cb4 : register(b4)
{
  float4 cb4[3];
}

cbuffer cb3 : register(b3)
{
  float4 cb3[259];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[24];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[4085];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[244];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  float4 v2 : TEXCOORD2,
  float4 v3 : TEXCOORD3,
  float4 v4 : TEXCOORD4,
  float4 v5 : TEXCOORD5,
  float4 v6 : TEXCOORD6,
  nointerpolation uint v7 : TEXCOORD7,
  uint v8 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 0, 0, 1.000000},
                              { 2, 1, -1.000000, 1.000000},
                              { 2, 1, 1.000000, 1.000000},
                              { 0, 2, 1.000000, -1.000000},
                              { 0, 2, 1.000000, 1.000000},
                              { 0, 1, 1.000000, 1.000000},
                              { 0, 1, -1.000000, 1.000000} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31,r32,r33,r34,r35,r36;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[82].zw * v0.xy;
  r0.zw = r0.xy * float2(2,2) + float2(-1,-1);
  r1.xyzw = cb0[25].xyzw * -r0.wwww;
  r1.xyzw = cb0[24].xyzw * r0.zzzz + r1.xyzw;
  r1.xyzw = cb0[26].xyzw * v0.zzzz + r1.xyzw;
  r1.xyzw = cb0[27].xyzw + r1.xyzw;
  r1.xyz = r1.xyz / r1.www;
  r0.z = cb0[1].z * r1.y;
  r0.z = cb0[0].z * r1.x + r0.z;
  r0.z = cb0[2].z * r1.z + r0.z;
  r0.z = cb0[3].z + r0.z;
  r2.z = abs(r0.z);
  r0.z = cmp(0 < v3.w);
  r0.z = r0.z ? 1 : -1;
  r0.w = cmp(0.000000 == cb0[86].w);
  r3.xyz = cb0[44].xyz + -r1.xyz;
  r4.x = cb0[0].z;
  r4.y = cb0[1].z;
  r4.z = cb0[2].z;
  r3.xyz = r0.www ? r3.xyz : r4.xyz;
  r0.w = dot(r3.xyz, r3.xyz);
  r2.w = max(9.99999994e-09, r0.w);
  r2.w = rsqrt(r2.w);
  r5.xyz = r3.xyz * r2.www;
  r0.w = r2.w * r0.w;
  r6.xy = w1.xy + -v1.xy;
  r6.zw = cb2[3].xx * r6.xy + v1.xy;
  r6.zw = r6.zw * cb2[12].xy + cb2[12].zw;
  r6.xy = cb2[2].ww * r6.xy + v1.xy;
  r6.xy = r6.xy * cb2[11].xy + cb2[11].zw;
  r7.xyzw = t5.SampleBias(s5_s, r6.xy, cb0[108].x).xyzw;
  r3.w = cb2[3].y + cb0[108].x;
  r8.xyz = t6.SampleBias(s6_s, r6.zw, r3.w).xyw;
  r8.x = r8.z * r8.x;
  r6.xy = r8.xy * float2(2,2) + float2(-1,-1);
  r8.xy = cb2[0].xx * r6.xy;
  r9.xyz = t7.SampleBias(s7_s, r6.zw, cb0[108].x).xyz;
  r7.xyzw = cb2[8].xyzw * r7.xyzw;
  r7.xyz = saturate(cb2[4].zzz * r7.xyz);
  r10.xyz = cb2[8].xyz + -r7.xyz;
  r7.xyz = cb2[4].xxx * r10.xyz + r7.xyz;
  r3.w = r7.w * v4.x + -r7.w;
  r10.w = cb2[23].x * r3.w + r7.w;
  r3.w = cb2[0].w + -cb2[0].z;
  r11.w = r9.y * r3.w + cb2[0].z;
  r3.w = saturate(cb2[3].w + -1);
  r4.w = cb2[4].y + -r9.x;
  r3.w = r3.w * r4.w + r9.x;
  r9.xyw = v3.yzx * v2.zxy;
  r9.xyw = v2.yzx * v3.zxy + -r9.xyw;
  r9.xyw = r9.xyw * r0.zzz;
  r8.yzw = r9.xyw * r8.yyy;
  r8.xyz = v3.xyz * r8.xxx + r8.yzw;
  r0.z = dot(r6.xy, r6.xy);
  r0.z = min(1, r0.z);
  r0.z = 1 + -r0.z;
  r0.z = sqrt(r0.z);
  r0.z = max(1.00000002e-16, r0.z);
  r4.w = cmp(0 < cb2[1].w);
  r4.w = r4.w ? -1 : 1;
  r4.w = v8.x ? 1 : r4.w;
  r0.z = r4.w * r0.z;
  r6.xyz = v2.xyz * r0.zzz + r8.xyz;
  r0.z = dot(r6.xyz, r6.xyz);
  r0.z = rsqrt(r0.z);
  r6.xyz = r6.xyz * r0.zzz;
  r0.z = dot(r6.xyz, r5.xyz);
  r4.w = dot(-r5.xyz, r6.xyz);
  r5.w = cb2[19].z * cb2[19].z;
  r7.w = -r4.w * r4.w + 1;
  r5.w = -r5.w * r7.w + 1;
  r7.w = sqrt(r5.w);
  r7.w = cb2[19].z * r4.w + r7.w;
  r5.w = cmp(r5.w >= 0);
  r8.xyz = r7.www * r6.xyz;
  r8.xyz = cb2[19].zzz * -r5.xyz + -r8.xyz;
  r8.xyz = r5.www ? r8.xyz : 0;
  r5.w = v0.z * r0.z;
  r5.w = max(0.5, r5.w);
  r5.w = cb2[19].w / r5.w;
  r5.w = -cb2[19].w + r5.w;
  r5.w = cb2[20].x * r5.w + cb2[19].w;
  r8.xyz = r8.xyz * r5.www;
  r8.yw = cb0[1].xy * r8.yy;
  r8.xy = cb0[0].xy * r8.xx + r8.yw;
  r8.xy = cb0[2].xy * r8.zz + r8.xy;
  r8.zw = v1.xy * cb2[22].xy + cb2[22].zw;
  r8.zw = t9.SampleBias(s8_s, r8.zw, cb0[108].x).xy;
  r8.zw = r8.zw * float2(2,2) + float2(-1,-1);
  r8.zw = r8.zw * cb2[19].yy + -r8.xy;
  r8.xy = cb2[19].xx * r8.zw + r8.xy;
  r8.zw = v0.xy * cb0[82].zw + r8.xy;
  r8.xy = float2(0.25,0.25) * r8.xy;
  r9.xy = v0.xy * cb0[82].zw + r8.xy;
  r5.w = t1.SampleBias(s0_s, r8.zw, cb0[108].x).x;
  r7.w = t1.SampleBias(s0_s, r9.xy, cb0[108].x).x;
  r7.w = cb0[84].z * r7.w + cb0[84].w;
  r7.w = 1 / r7.w;
  r7.w = cmp(r7.w >= r2.z);
  r7.w = r7.w ? 1.000000 : 0;
  r8.xy = r7.ww * r8.xy + r0.xy;
  r5.w = cb0[84].z * r5.w + cb0[84].w;
  r5.w = 1 / r5.w;
  r5.w = cmp(r5.w >= r2.z);
  r5.w = r5.w ? 1.000000 : 0;
  r8.zw = r8.zw + -r8.xy;
  r8.xy = r5.ww * r8.zw + r8.xy;
  r8.xyz = t8.SampleBias(s9_s, r8.xy, cb0[108].x).xyz;
  r5.w = max(9.99999994e-09, v5.z);
  r9.xy = v5.xy / r5.ww;
  r5.w = max(9.99999994e-09, v6.z);
  r12.xy = v6.xy / r5.ww;
  r12.xy = -r12.xy + r9.xy;
  r5.w = cb2[0].y * 0.0799999982;
  r9.xyw = -r7.xyz * r3.www + r7.xyz;
  r5.w = -r5.w * r3.w + r5.w;
  r7.xyz = r7.xyz * r3.www + r5.www;
  r13.xyzw = r11.wwww * float4(-1,-0.0274999999,-0.572000027,0.0219999999) + float4(1,0.0425000004,1.03999996,-0.0399999991);
  r3.w = r13.x * r13.x;
  r0.z = max(0, r0.z);
  r5.w = -9.27999973 * r0.z;
  r5.w = exp2(r5.w);
  r3.w = min(r5.w, r3.w);
  r3.w = r3.w * r13.x + r13.y;
  r13.xy = r3.ww * float2(-1.03999996,1.03999996) + r13.zw;
  r3.w = cmp(1.000000 == cb0[113].y);
  r14.xyzw = cb0[241].xyzw * r1.yyyy;
  r14.xyzw = cb0[240].xyzw * r1.xxxx + r14.xyzw;
  r14.xyzw = cb0[242].xyzw * r1.zzzz + r14.xyzw;
  r14.xyzw = cb0[243].xyzw + r14.xyzw;
  r5.w = 1 / r14.w;
  r14.xyz = float3(1,-1,1) * r14.xyz;
  r14.xyz = r14.xyz * r5.www;
  r13.zw = saturate(r14.xy * float2(0.5,0.5) + float2(0.5,0.5));
  r13.zw = cb0[82].xy * r13.zw;
  r15.xy = (uint2)r13.zw;
  r5.w = cb0[84].z * r14.z + cb0[84].w;
  r15.z = 1 / r5.w;
  r2.xy = (uint2)v0.xy;
  r14.xyz = r3.www ? r15.xyz : r2.xyz;
  r2.xyz = r6.xyz * float3(0.25,0.25,0.25) + r1.xyz;
  r15.xyz = cb0[6].xzy * -cb0[212].www + cb0[210].xzy;
  r15.xyz = -r15.xyz + r2.xzy;
  r3.w = max(abs(r15.x), abs(r15.y));
  r3.w = -464 + r3.w;
  r3.w = saturate(0.03125 * r3.w);
  r5.w = -208 + abs(r15.z);
  r5.w = saturate(0.03125 * r5.w);
  r3.w = max(r5.w, r3.w);
  r5.w = cmp(0.000000 != cb0[210].w);
  r7.w = cmp(r3.w < 1);
  r5.w = r5.w ? r7.w : 0;
  if (r5.w != 0) {
    r15.xyz = cb0[6].xzy * -cb0[212].yyy + cb0[210].xzy;
    r15.xyz = -r15.xyz + r2.xzy;
    r5.w = max(abs(r15.x), abs(r15.y));
    r5.w = -29 + r5.w;
    r5.w = saturate(0.5 * r5.w);
    r7.w = -13 + abs(r15.z);
    r7.w = saturate(0.5 * r7.w);
    r5.w = max(r7.w, r5.w);
    r7.w = cmp(r5.w < 1);
    if (r7.w != 0) {
      r15.xyz = r2.xyz * float3(2,2,2) + float3(0.5,0.5,0.5);
      r16.xyz = cb0[211].xyz * r15.xyz;
      r16.xyz = floor(r16.xyz);
      r15.xyz = r15.xyz * cb0[211].xyz + -r16.xyz;
      r16.xyz = t16.SampleLevel(s2_s, r15.xyz, 0).xyz;
      r7.w = 1 + -r5.w;
      r8.w = cb0[211].y * 0.5;
      r12.w = -cb0[211].y * 0.5 + 1;
      r8.w = max(r15.y, r8.w);
      r8.w = min(r8.w, r12.w);
      r15.w = 0.333333343 * r8.w;
      r17.xyzw = t17.SampleLevel(s1_s, r15.xwz, 0).xyzw;
      r17.xyz = r17.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r18.xyz = r17.xyz * r16.xxx;
      r17.xyz = float3(0,0.333333343,0) + r15.xwz;
      r17.xyz = t17.SampleLevel(s1_s, r17.xyz, 0).xyz;
      r17.xyz = r17.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r19.xyz = r17.xyz * r16.yyy;
      r15.xyz = float3(0,0.666666687,0) + r15.xwz;
      r15.xyz = t17.SampleLevel(s1_s, r15.xyz, 0).xyz;
      r15.xyz = r15.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r15.xyz = r15.xyz * r16.zzz;
      r8.w = r17.w * r7.w + r3.w;
      r15.w = r16.z;
      r15.xyzw = r15.xyzw * r7.wwww;
      r19.w = r16.y;
      r17.xyzw = r19.xyzw * r7.wwww;
      r18.w = r16.x;
      r16.xyzw = r18.xyzw * r7.wwww;
    } else {
      r15.xyzw = float4(0,0,0,0);
      r17.xyzw = float4(0,0,0,0);
      r16.xyzw = float4(0,0,0,0);
      r8.w = r3.w;
    }
    r18.xyz = cb0[6].xzy * -cb0[212].zzz + cb0[210].xzy;
    r18.xyz = -r18.xyz + r2.xzy;
    r7.w = max(abs(r18.x), abs(r18.y));
    r7.w = -116 + r7.w;
    r7.w = saturate(0.125 * r7.w);
    r12.w = -52 + abs(r18.z);
    r12.w = saturate(0.125 * r12.w);
    r7.w = max(r12.w, r7.w);
    r12.w = cmp(r7.w < 1);
    if (r12.w != 0) {
      r18.xyz = r2.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
      r19.xyz = cb0[211].xyz * r18.xyz;
      r19.xyz = floor(r19.xyz);
      r18.xyz = r18.xyz * cb0[211].xyz + -r19.xyz;
      r19.xyz = t18.SampleLevel(s2_s, r18.xyz, 0).xyz;
      r12.w = 1 + -r7.w;
      r5.w = r12.w * r5.w;
      r12.w = cb0[211].y * 0.5;
      r13.z = -cb0[211].y * 0.5 + 1;
      r12.w = max(r18.y, r12.w);
      r12.w = min(r12.w, r13.z);
      r18.w = 0.333333343 * r12.w;
      r20.xyzw = t19.SampleLevel(s1_s, r18.xwz, 0).xyzw;
      r20.xyz = r20.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r21.xyz = r20.xyz * r19.xxx;
      r20.xyz = float3(0,0.333333343,0) + r18.xwz;
      r20.xyz = t19.SampleLevel(s1_s, r20.xyz, 0).xyz;
      r20.xyz = r20.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r22.xyz = r20.xyz * r19.yyy;
      r18.xyz = float3(0,0.666666687,0) + r18.xwz;
      r18.xyz = t19.SampleLevel(s1_s, r18.xyz, 0).xyz;
      r18.xyz = r18.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r18.xyz = r18.xyz * r19.zzz;
      r8.w = r20.w * r5.w + r8.w;
      r18.w = r19.z;
      r15.xyzw = r18.xyzw * r5.wwww + r15.xyzw;
      r22.w = r19.y;
      r17.xyzw = r22.xyzw * r5.wwww + r17.xyzw;
      r21.w = r19.x;
      r16.xyzw = r21.xyzw * r5.wwww + r16.xyzw;
    }
    r5.w = cmp(0 < r7.w);
    if (r5.w != 0) {
      r2.xyz = r2.xyz * float3(0.125,0.125,0.125) + float3(0.5,0.5,0.5);
      r18.xyz = cb0[211].xyz * r2.xyz;
      r19.xyz = cb0[211].xyz * float3(0.5,0.5,0.5);
      r18.xyz = floor(r18.xyz);
      r2.xyz = r2.xyz * cb0[211].xyz + -r18.xyz;
      r18.xyz = -cb0[211].xyz * float3(0.5,0.5,0.5) + float3(1,1,1);
      r2.xyz = max(r2.xyz, r19.xyz);
      r20.xyz = min(r2.xyz, r18.xyz);
      r21.xyw = t20.SampleLevel(s2_s, r20.xyz, 0).yzx;
      r2.x = 1 + -r3.w;
      r2.x = r7.w * r2.x;
      r2.y = max(r20.y, r19.y);
      r2.y = min(r2.y, r18.y);
      r20.w = 0.333333343 * r2.y;
      r18.xyzw = t21.SampleLevel(s1_s, r20.xwz, 0).xyzw;
      r19.xyz = float3(0,0.666666687,0) + r20.xwz;
      r19.xyz = t21.SampleLevel(s1_s, r19.xyz, 0).xyz;
      r19.xyz = r19.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r19.xyz = r19.xyz * r21.yyy;
      r19.w = r21.y;
      r15.xyzw = r19.xyzw * r2.xxxx + r15.xyzw;
      r19.xyz = float3(0,0.333333343,0) + r20.xwz;
      r19.xyz = t21.SampleLevel(s1_s, r19.xyz, 0).xyz;
      r19.xyz = r19.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r19.xyz = r19.xyz * r21.xxx;
      r19.w = r21.x;
      r17.xyzw = r19.xyzw * r2.xxxx + r17.xyzw;
      r18.xyz = r18.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r21.xyz = r18.xyz * r21.www;
      r16.xyzw = r21.xyzw * r2.xxxx + r16.xyzw;
      r8.w = r18.w * r2.x + r8.w;
    }
    r2.x = saturate(r8.w * 2 + -1);
    r18.x = r2.x + -r3.w;
    r2.x = r2.x + r3.w;
    r18.y = 0.5 * r2.x;
  } else {
    r15.xyzw = float4(0,0,0,0);
    r17.xyzw = float4(0,0,0,0);
    r16.xyzw = float4(0,0,0,0);
    r18.xy = float2(0,1);
  }
  r19.xyzw = cb0[213].xyzw * r18.yyyx;
  r19.y = r19.w * 0.5 + r19.y;
  r2.xy = cb0[213].wy * r18.yx;
  r19.w = r2.y * 0.375 + r2.x;
  r16.xyzw = r19.xyzw + r16.xyzw;
  r19.xyzw = cb0[214].xyzw * r18.yyyx;
  r19.y = r19.w * 0.5 + r19.y;
  r2.xy = cb0[214].wy * r18.yx;
  r19.w = r2.y * 0.375 + r2.x;
  r17.xyzw = r19.xyzw + r17.xyzw;
  r19.xyzw = cb0[215].xyzw * r18.yyyx;
  r19.y = r19.w * 0.5 + r19.y;
  r2.xy = cb0[215].wy * r18.yx;
  r19.w = r2.y * 0.375 + r2.x;
  r15.xyzw = r19.xyzw + r15.xyzw;
  r2.x = dot(r16.xyz, r6.xyz);
  r2.x = r2.x + r16.w;
  r2.x = max(0, r2.x);
  r3.w = dot(r17.xyz, r6.xyz);
  r3.w = r3.w + r17.w;
  r2.y = max(0, r3.w);
  r3.w = dot(r15.xyz, r6.xyz);
  r3.w = r3.w + r15.w;
  r2.z = max(0, r3.w);
  r3.w = r4.w + r4.w;
  r15.xyz = r6.xyz * -r3.www + -r5.xyz;
  r3.w = cb0[113].x + -1;
  r4.w = max(0.00100000005, r11.w);
  r4.w = log2(r4.w);
  r4.w = -r4.w * 1.20000005 + 1;
  r3.w = -r4.w + r3.w;
  r13.zw = (uint2)r14.xy;
  r16.xy = cb3[0].ww * r13.zw;
  r16.xy = floor(r16.xy);
  r4.w = -cb3[2].y + r14.z;
  r4.w = floor(r4.w);
  r5.w = cb3[1].x + -1;
  r7.w = max(0, r4.w);
  r5.w = min(r7.w, r5.w);
  r4.w = cmp(r5.w >= r4.w);
  r7.w = r16.y * cb3[0].x + r16.x;
  r7.w = (int)r7.w;
  r7.w = (int)r7.w + asint(cb0[110].z);
  r7.w = t0[r7.w].val[0/4];
  r5.w = (int)r5.w;
  r5.w = (int)r5.w + asint(cb0[110].w);
  r5.w = t0[r5.w].val[0/4];
  r5.w = (int)r5.w & (int)r7.w;
  r4.w = r4.w ? r5.w : 0;
  r16.xyz = cb0[111].xxx * r2.xyz;
  r5.w = dot(r16.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r1.w = 1;
  r6.w = 1;
  r16.xyz = float3(0,0,0);
  r7.w = 1;
  r8.w = r4.w;
  r12.w = 0;
  while (true) {
    r15.w = cmp(0.00999999978 < r7.w);
    r16.w = cmp((int)r8.w != 0);
    r16.w = r15.w ? r16.w : 0;
    if (r16.w != 0) {
      r16.w = firstbitlow((uint)r8.w);
      r17.x = 1 << (int)r16.w;
      r8.w = (int)r8.w ^ (int)r17.x;
      r16.w = (uint)r16.w << 3;
      r17.x = dot(cb3[r16.w+6].xyzw, r1.xyzw);
      r17.y = dot(cb3[r16.w+7].xyzw, r1.xyzw);
      r17.z = dot(cb3[r16.w+8].xyzw, r1.xyzw);
      r18.xyz = cmp(cb3[r16.w+5].xyz >= abs(r17.xyz));
      r17.w = r18.y ? r18.x : 0;
      r17.w = r18.z ? r17.w : 0;
      if (r17.w != 0) {
        r17.w = cb3[r16.w+5].x * 0.100000001;
        r18.xyz = float3(0.100000001,0.100000001,0.100000001) * abs(r17.xyz);
        r18.xy = r18.xy * r18.xy;
        r19.xyz = cb3[r16.w+5].xyz + -abs(r17.xyz);
        r19.xyz = cb3[r16.w+9].xyz * r19.xyz;
        r18.w = cmp(1.000000 == cb3[r16.w+10].x);
        if (r18.w != 0) {
          r20.x = dot(cb3[r16.w+6].xyz, r15.xyz);
          r20.y = dot(cb3[r16.w+7].xyz, r15.xyz);
          r20.z = dot(cb3[r16.w+8].xyz, r15.xyz);
          r21.xyz = cb3[r16.w+5].xyz + -r17.xyz;
          r21.xyz = r21.xyz / r20.xyz;
          r22.xyz = -cb3[r16.w+5].xyz + -r17.xyz;
          r22.xyz = r22.xyz / r20.xyz;
          r23.xyz = cmp(float3(0,0,0) < r20.xyz);
          r21.xyz = r23.xyz ? r21.xyz : r22.xyz;
          r18.w = min(r21.x, r21.y);
          r18.w = min(r18.w, r21.z);
          r17.xyz = r20.xyz * r18.www + r17.xyz;
        } else {
          r17.xyz = r15.xyz;
        }
        r18.w = dot(r17.xyz, r17.xyz);
        r18.w = rsqrt(r18.w);
        r17.xyz = r18.www * r17.xyz;
        r20.xyz = cmp(float3(0,0,0) < r17.xyz);
        r21.xyz = cmp(r17.xyz < float3(0,0,0));
        r20.xyz = (int3)-r20.xyz + (int3)r21.xyz;
        r20.xyz = (int3)r20.xyz;
        r18.w = dot(r17.xyz, r20.xyz);
        r17.xyz = r17.xyz / r18.www;
        r17.z = cmp(r17.z < 0);
        r20.zw = float2(1,1) + -abs(r17.yx);
        r20.xy = r20.xy * r20.zw;
        r17.xy = r17.zz ? r20.xy : r17.xy;
        r17.z = dot(cb3[r16.w+4].xyzw, r6.xyzw);
        r17.z = max(0, r17.z);
        r17.z = max(9.99999975e-05, r17.z);
        r18.w = min(r19.y, r19.z);
        r18.w = min(r19.x, r18.w);
        r18.x = r18.x + r18.y;
        r18.x = r18.z * r18.z + r18.x;
        r17.w = r17.w * r17.w + -r18.x;
        r17.w = cb3[r16.w+9].x * r17.w;
        r17.w = cb3[r16.w+9].x * r17.w;
        r18.x = -cb3[r16.w+10].y + 1;
        r17.w = r18.x * r17.w;
        r17.w = 100 * r17.w;
        r17.w = saturate(r18.w * cb3[r16.w+10].y + r17.w);
        r18.x = cb3[r16.w+10].w * r17.w;
        r17.xy = r17.xy * float2(0.5,0.5) + float2(0.5,0.5);
        r19.xy = r17.xy * cb3[1].ww + cb3[2].ww;
        r19.z = cb3[r16.w+5].w;
        r18.yzw = t4.SampleLevel(s3_s, r19.xyz, r3.w).xyz;
        r18.yzw = cb3[r16.w+9].www * r18.yzw;
        r17.x = r5.w / r17.z;
        r17.x = min(1, abs(r17.x));
        r17.x = r17.x * 2 + r5.w;
        r17.y = 2 + r17.z;
        r17.x = r17.x / r17.y;
        r17.x = -1 + r17.x;
        r17.x = r17.x * cb0[112].w + 1;
        r17.xyz = r18.yzw * r17.xxx;
        r17.xyz = r17.xyz * r18.xxx;
        r16.xyz = r17.xyz * r7.www + r16.xyz;
        r16.w = -r17.w * cb3[r16.w+10].w + 1;
        r7.w = r16.w * r7.w;
      }
      r12.w = -1;
      continue;
    } else {
      r12.w = r15.w;
      break;
    }
    r12.w = r15.w;
  }
  if (r12.w != 0) {
    r1.w = dot(r15.xyz, r15.xyz);
    r1.w = rsqrt(r1.w);
    r17.xyz = r15.xyz * r1.www;
    r18.xyz = cmp(float3(0,0,0) < r17.xyz);
    r19.xyz = cmp(r17.xyz < float3(0,0,0));
    r18.xyz = (int3)-r18.xyz + (int3)r19.xyz;
    r18.xyz = (int3)r18.xyz;
    r1.w = dot(r17.xyz, r18.xyz);
    r17.xyz = r17.xyz / r1.www;
    r1.w = cmp(r17.z < 0);
    r17.zw = float2(1,1) + -abs(r17.yx);
    r17.zw = r18.xy * r17.zw;
    r17.xy = r1.ww ? r17.zw : r17.xy;
    r6.w = 1;
    r1.w = dot(cb3[3].xyzw, r6.xyzw);
    r1.w = max(0, r1.w);
    r1.w = max(9.99999975e-05, r1.w);
    r17.xy = r17.xy * float2(0.5,0.5) + float2(0.5,0.5);
    r17.xy = r17.xy * cb3[1].ww + cb3[2].ww;
    r17.z = 0;
    r17.xyz = t4.SampleLevel(s3_s, r17.xyz, r3.w).xyz;
    r3.w = r5.w / r1.w;
    r3.w = min(1, abs(r3.w));
    r3.w = r3.w * 2 + r5.w;
    r1.w = 2 + r1.w;
    r1.w = r3.w / r1.w;
    r1.w = -1 + r1.w;
    r1.w = r1.w * cb0[112].w + 1;
    r17.xyz = r17.xyz * r1.www;
    r16.xyz = r17.xyz * r7.www + r16.xyz;
  }
  
  // Reduce reflection probe intensity for glass
  if (GLASS_TRANSPARENCY > 0.5f) {
    r16.xyz *= 0.4f;
  }
  
  r16.xyz = cb0[112].zzz * r16.xyz;
  r16.xyz = cb0[111].yyy * r16.xyz;
  r1.w = cmp(0.000000 != cb0[112].y);
  if (r1.w != 0) {
    r1.w = t3.SampleBias(s1_s, r0.xy, cb0[108].x).x;
    r17.xyz = t2.SampleBias(s1_s, r0.xy, cb0[108].x).xyz;
    r0.x = 1 + -r1.w;
    r18.xyz = r16.xyz * r0.xxx;
    r16.xyz = r17.xyz * r1.www + r18.xyz;
  }
  r2.xyz = r2.xyz * r9.xyw;
  r0.x = -1 + r9.z;
  r0.x = cb2[1].x * r0.x + 1;
  r2.xyz = r2.xyz * r0.xxx;
  r0.x = saturate(50 * r7.y);
  r0.x = r0.x * r13.y;
  r17.xyz = r7.xyz * r13.xxx + r0.xxx;
  r16.xyz = r17.xyz * r16.xyz;
  r2.xyz = r2.xyz * cb0[111].xxx + r16.xyz;
  r0.x = cmp(cb6[35].w < 0.99000001);
  if (r0.x != 0) {
    r0.x = (int)cb6[35].x;
    r0.y = cmp((int)r0.x == 2);
    r16.xyz = r0.yyy ? cb6[20].xyz : cb0[44].xyz;
    r16.xyz = -r16.xyz + r1.xyz;
    r0.y = dot(r16.xyz, r16.xyz);
    r0.y = cb6[34].w + -r0.y;
    r0.y = saturate(cb6[34].z * r0.y);
    r1.w = cmp(0 < r0.y);
    if (r1.w != 0) {
      r0.x = cmp(0 < (int)r0.x);
      if (r0.x != 0) {
        r16.xyz = -cb6[20].xyz + r1.xyz;
        r17.xyz = -cb6[21].xyz + r1.xyz;
        r18.xyz = -cb6[22].xyz + r1.xyz;
        r19.xyz = -cb6[23].xyz + r1.xyz;
        r16.x = dot(r16.xyz, r16.xyz);
        r16.y = dot(r17.xyz, r17.xyz);
        r16.z = dot(r18.xyz, r18.xyz);
        r16.w = dot(r19.xyz, r19.xyz);
        r17.x = cmp(r16.x < cb6[20].w);
        r17.y = cmp(r16.y < cb6[21].w);
        r17.z = cmp(r16.z < cb6[22].w);
        r17.w = cmp(r16.w < cb6[23].w);
        r18.xyzw = r17.xyzw ? float4(1,1,1,1) : 0;
        r17.xyz = r17.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
        r17.xyz = r18.yzw + r17.xyz;
        r18.yzw = max(float3(0,0,0), r17.xyz);
        r0.x = dot(r18.xyzw, float4(4,3,2,1));
        r0.x = 4 + -r0.x;
        r0.x = max(0, r0.x);
        r0.x = min(3, r0.x);
        r1.w = 1 + r0.x;
        r1.w = min(3, r1.w);
        r1.w = (uint)r1.w;
        r3.w = dot(r16.yzw, icb[r1.w+0].yzw);
        r1.w = r3.w / cb6[r1.w+20].w;
        r3.w = cmp(r1.w >= 0);
        r1.w = cmp(1 >= r1.w);
        r1.w = r1.w ? r3.w : 0;
        if (r1.w != 0) {
          r1.w = (uint)r0.x;
          r13.xy = float2(2.08299994,4.8670001) + r13.zw;
          r3.w = dot(r13.xy, float2(0.0671105608,0.00583714992));
          r3.w = frac(r3.w);
          r3.w = 52.9829178 * r3.w;
          r3.w = frac(r3.w);
          r4.w = dot(r16.xyzw, icb[r1.w+0].xyzw);
          r1.w = r4.w / cb6[r1.w+20].w;
          r1.w = sqrt(r1.w);
          r1.w = -0.899999976 + r1.w;
          r1.w = 12 * r1.w;
          r1.w = cmp(r1.w >= r3.w);
          r1.w = r1.w ? 1.000000 : 0;
          r0.x = r1.w + r0.x;
        }
        r1.w = dot(r6.xyz, cb5[0].xyz);
        r1.w = max(0, r1.w);
        r1.w = min(0.899999976, r1.w);
        r1.w = 1 + -r1.w;
        r3.w = (uint)r0.x;
        r4.w = (uint)r3.w << 2;
        r13.xy = cb6[r3.w+24].xy * r1.ww;
        r1.w = max(0, r13.x);
        r16.xyz = -cb5[0].xyz * r1.www + r1.xyz;
        r16.xyz = r6.xyz * r13.yyy + r16.xyz;
        r17.xyz = cb6[r4.w+1].xyz * r16.yyy;
        r16.xyw = cb6[r4.w+0].xyz * r16.xxx + r17.xyz;
        r16.xyz = cb6[r4.w+2].xyz * r16.zzz + r16.xyw;
        r16.xyz = cb6[r4.w+3].xyz + r16.xyz;
        r17.xyz = cmp(float3(0,0,0) >= r16.xyz);
        r18.xyz = cmp(r16.xyz >= float3(1,1,1));
        r17.xyz = (int3)r17.xyz | (int3)r18.xyz;
        r1.w = (int)r17.y | (int)r17.x;
        r1.w = (int)r17.z | (int)r1.w;
        r3.w = (int)r16.z & 0x7fffffff;
        r3.w = cmp(0x7f800000 < (uint)r3.w);
        r17.z = (int)r1.w | (int)r3.w;
        r0.x = (int)r0.x;
        r13.xy = r16.xy * cb6[r0.x+28].zw + cb6[r0.x+28].xy;
        r16.xy = r13.xy * cb6[32].zw + float2(0.5,0.5);
        r16.xy = floor(r16.xy);
        r13.xy = r13.xy * cb6[32].zw + -r16.xy;
        r18.xyzw = float4(0.5,1,0.5,1) + r13.xxyy;
        r19.xw = r18.xz * r18.xz;
        r18.xz = min(float2(0,0), r13.xy);
        r20.xy = max(float2(0,0), r13.xy);
        r20.zw = r19.xw * float2(0.5,0.5) + -r13.xy;
        r13.xy = float2(1,1) + -r13.xy;
        r13.xy = -r18.xz * r18.xz + r13.xy;
        r18.xy = -r20.xy * r20.xy + r18.yw;
        r21.x = r20.z;
        r21.y = r13.x;
        r21.z = r18.x;
        r21.w = r19.x;
        r21.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r21.xyzw;
        r19.x = r20.w;
        r19.y = r13.y;
        r19.z = r18.y;
        r18.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r19.xyzw;
        r19.xyzw = r21.xzxz + r21.ywyw;
        r20.xyzw = r18.xxzz + r18.yyww;
        r13.xy = r21.yw / r19.zw;
        r13.xy = float2(-1.5,0.5) + r13.xy;
        r21.xy = cb6[32].xx * r13.xy;
        r13.xy = r18.yw / r20.yw;
        r13.xy = float2(-1.5,0.5) + r13.xy;
        r21.zw = cb6[32].yy * r13.xy;
        r18.xyzw = r20.xyzw * r19.xyzw;
        r19.xyzw = r16.xyxy * cb6[32].xyxy + r21.xzyz;
        r0.x = t10.SampleCmpLevelZero(s4_s, r19.xy, r16.z).x;
        r1.w = t10.SampleCmpLevelZero(s4_s, r19.zw, r16.z).x;
        r1.w = r18.y * r1.w;
        r0.x = r18.x * r0.x + r1.w;
        r19.xyzw = r16.xyxy * cb6[32].xyxy + r21.xwyw;
        r1.w = t10.SampleCmpLevelZero(s4_s, r19.xy, r16.z).x;
        r0.x = r18.z * r1.w + r0.x;
        r1.w = t10.SampleCmpLevelZero(s4_s, r19.zw, r16.z).x;
        r0.x = r18.w * r1.w + r0.x;
        r17.x = r17.z ? 1 : r0.x;
      } else {
        r17.xz = float2(1,0);
      }
    } else {
      r17.xz = float2(1,0);
    }
    r0.x = cmp(r0.y < 1);
    if (r0.x != 0) {
      r0.x = dot(r6.xyz, cb5[0].xyz);
      r0.x = max(0, r0.x);
      r0.x = min(0.899999976, r0.x);
      r0.x = 1 + -r0.x;
      r13.xy = cb6[584].xy * r0.xx;
      r16.xyz = -cb5[0].xyz * r13.xxx + r1.xyz;
      r16.xyz = r6.xyz * r13.yyy + r16.xyz;
      r13.xy = cb6[581].xy * r16.yy;
      r13.xy = cb6[580].xy * r16.xx + r13.xy;
      r13.xy = cb6[582].xy * r16.zz + r13.xy;
      r13.xy = cb6[583].xy + r13.xy;
      r18.xy = cmp(float2(0,0) < r13.xy);
      r0.x = r18.y ? r18.x : 0;
      r18.xy = cmp(r13.xy < float2(1,1));
      r1.w = r18.y ? r18.x : 0;
      r0.x = (int)r0.x & (int)r1.w;
      if (r0.x != 0) {
        r0.x = cb6[585].z * r13.y;
        r0.x = floor(r0.x);
        r0.x = r0.x + r13.x;
        r0.x = cb6[585].y * r0.x;
        r0.x = (uint)r0.x;
        r0.x = min(127, (uint)r0.x);
        r1.w = 0x0000ffff & asint(cb6[r0.x+587].x);
        r13.x = f16tof32(r1.w);
        r1.w = cmp(r13.x >= 0);
        if (r1.w != 0) {
          r18.x = cb6[576].x;
          r18.y = cb6[577].x;
          r18.z = cb6[578].x;
          r18.w = cb6[r0.x+587].y;
          r16.w = 1;
          r18.x = dot(r18.xyzw, r16.xyzw);
          r19.x = cb6[576].y;
          r19.y = cb6[577].y;
          r19.z = cb6[578].y;
          r19.w = cb6[r0.x+587].z;
          r18.y = dot(r19.xyzw, r16.xyzw);
          r19.x = cb6[576].z;
          r19.y = cb6[577].z;
          r19.z = cb6[578].z;
          r19.w = cb6[r0.x+587].w;
          r1.w = dot(r19.xyzw, r16.xyzw);
          r16.xy = cmp(float2(0,0) < r18.xy);
          r3.w = cmp(0 < r1.w);
          r4.w = r16.y ? r16.x : 0;
          r3.w = r3.w ? r4.w : 0;
          r16.xy = cmp(r18.xy < float2(1,1));
          r4.w = cmp(r1.w < 1);
          r5.w = r16.y ? r16.x : 0;
          r4.w = r4.w ? r5.w : 0;
          r3.w = r3.w ? r4.w : 0;
          if (r3.w != 0) {
            r0.x = asuint(cb6[r0.x+587].x) >> 16;
            r13.y = f16tof32(r0.x);
            r13.xy = r18.xy * cb6[584].zw + r13.xy;
            r16.xy = r13.xy * cb6[586].zw + float2(0.5,0.5);
            r16.xy = floor(r16.xy);
            r13.xy = r13.xy * cb6[586].zw + -r16.xy;
            r18.xyzw = float4(0.5,1,0.5,1) + r13.xxyy;
            r19.xw = r18.xz * r18.xz;
            r16.zw = min(float2(0,0), r13.xy);
            r18.xz = max(float2(0,0), r13.xy);
            r20.xy = r19.xw * float2(0.5,0.5) + -r13.xy;
            r13.xy = float2(1,1) + -r13.xy;
            r13.xy = -r16.zw * r16.zw + r13.xy;
            r16.zw = -r18.xz * r18.xz + r18.yw;
            r18.x = r20.x;
            r18.y = r13.x;
            r18.z = r16.z;
            r18.w = r19.x;
            r18.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r18.xyzw;
            r19.x = r20.y;
            r19.y = r13.y;
            r19.z = r16.w;
            r19.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r19.xyzw;
            r20.xyzw = r18.xzxz + r18.ywyw;
            r21.xyzw = r19.xxzz + r19.yyww;
            r13.xy = r18.yw / r20.zw;
            r13.xy = float2(-1.5,0.5) + r13.xy;
            r18.xy = cb6[586].xx * r13.xy;
            r13.xy = r19.yw / r21.yw;
            r13.xy = float2(-1.5,0.5) + r13.xy;
            r18.zw = cb6[586].yy * r13.xy;
            r19.xyzw = r21.xyzw * r20.xyzw;
            r20.xyzw = r16.xyxy * cb6[586].xyxy + r18.xzyz;
            r0.x = t13.SampleCmpLevelZero(s4_s, r20.xy, r1.w).x;
            r3.w = t13.SampleCmpLevelZero(s4_s, r20.zw, r1.w).x;
            r3.w = r19.y * r3.w;
            r0.x = r19.x * r0.x + r3.w;
            r16.xyzw = r16.xyxy * cb6[586].xyxy + r18.xwyw;
            r3.w = t13.SampleCmpLevelZero(s4_s, r16.xy, r1.w).x;
            r0.x = r19.z * r3.w + r0.x;
            r1.w = t13.SampleCmpLevelZero(s4_s, r16.zw, r1.w).x;
            r17.y = r19.w * r1.w + r0.x;
          } else {
            r17.y = 1;
          }
        } else {
          r17.y = 1;
        }
      } else {
        r17.y = 1;
      }
      r17.x = r17.z ? r17.y : r17.x;
    } else {
      r17.y = 1;
    }
    r0.x = r17.x + -r17.y;
    r0.x = r0.y * r0.x + r17.y;
    r0.y = cmp(0.00100000005 < r0.x);
    if (r0.y != 0) {
      r16.xyz = -cb0[173].xyz + r1.xyz;
      r13.xy = cb0[176].xz * r16.yy + r16.xz;
      r16.yw = cb0[174].zz * r13.xy;
      r17.xy = cb0[183].ww * cb0[175].xy;
      r13.xy = r13.xy * cb0[174].zz + r17.xy;
      r0.y = t12.SampleLevel(s2_s, r13.xy, 0).x;
      r13.xy = r16.yw * cb0[175].ww + r17.xy;
      r1.w = t12.SampleLevel(s2_s, r13.xy, 0).x;
      r3.w = dot(r16.xz, r16.xz);
      r3.w = sqrt(r3.w);
      r4.w = cb0[174].y + -cb0[174].x;
      r3.w = -cb0[174].x + r3.w;
      r4.w = 1 / r4.w;
      r3.w = saturate(r4.w * r3.w);
      r4.w = r3.w * -2 + 3;
      r3.w = r3.w * r3.w;
      r3.w = r4.w * r3.w;
      r1.w = r1.w + -r0.y;
      r0.y = r3.w * r1.w + r0.y;
      r0.y = -1 + r0.y;
      r0.y = cb0[175].z * r0.y + 1;
      r0.x = r0.x * r0.y;
    }
    r0.y = cb6[35].z + -r0.x;
    r0.x = cb6[35].w * r0.y + r0.x;
  } else {
    r0.x = cb6[35].z;
  }
  r0.x = min(1, r0.x);
  r0.x = -1 + r0.x;
  r0.x = cb6[34].x * r0.x + 1;
  r1.w = cmp(0.00100000005 < r0.x);
  if (r1.w != 0) {
    r1.w = dot(-cb5[0].xyz, r15.xyz);
    r16.xyz = cb5[0].xyz * r1.www + r15.xyz;
    r1.w = cmp(r1.w < cb5[4].z);
    r3.w = dot(r16.xyz, r16.xyz);
    r3.w = max(6.10351562e-05, r3.w);
    r3.w = rsqrt(r3.w);
    r16.xyz = r16.xyz * r3.www;
    r16.xyz = cb5[4].yyy * r16.xyz;
    r16.xyz = -cb5[0].xyz * cb5[4].zzz + r16.xyz;
    r3.w = dot(r16.xyz, r16.xyz);
    r3.w = rsqrt(r3.w);
    r16.xyz = r16.xyz * r3.www;
    r16.xyz = r1.www ? r16.xyz : r15.xyz;
    r17.xyz = r3.xyz * r2.www + r16.xyz;
    r1.w = dot(r17.xyz, r17.xyz);
    r1.w = max(6.10351562e-05, r1.w);
    r1.w = rsqrt(r1.w);
    r17.xyz = r17.xyz * r1.www;
    r11.y = saturate(dot(r16.xyz, r6.xyz));
    r1.w = saturate(dot(r6.xyz, r17.xyz));
    r11.z = min(1, r0.z);
    r3.w = r11.w * r11.w;
    r3.w = r3.w * r3.w;
    r4.w = r1.w * r3.w + -r1.w;
    r1.w = r4.w * r1.w + 1;
    r4.w = saturate(dot(r5.xyz, r17.xyz));
    r4.w = 1 + -r4.w;
    r5.w = r4.w * r4.w;
    r5.w = r5.w * r5.w;
    r6.w = r5.w * r4.w;
    r7.w = 1 + -r11.w;
    r8.w = -r7.w * 0.383026004 + -0.0761947036;
    r8.w = r7.w * r8.w + 1.04997003;
    r7.w = r7.w * r8.w + 0.409254998;
    r7.w = min(0.999000013, r7.w);
    r8.w = 1 + -r7.w;
    r16.xyz = float3(1,1,1) + -r7.xyz;
    r16.xyz = r16.xyz * float3(0.0476190485,0.0476190485,0.0476190485) + r7.xyz;
    r4.w = -r5.w * r4.w + 1;
    r17.xyz = r7.xyz * r4.www + r6.www;
    r1.w = r1.w * r1.w;
    r1.w = r3.w / r1.w;
    r13.xy = -r11.zy * r3.ww + r11.zy;
    r13.xy = r13.xy * r11.zy + r3.ww;
    r13.xy = sqrt(r13.xy);
    r13.xy = r13.xy * r11.yz;
    r3.w = r13.x + r13.y;
    r3.w = 9.99999975e-05 + r3.w;
    r3.w = 0.5 / r3.w;
    r1.w = r3.w * r1.w;
    r17.xyz = r17.xyz * r1.www;
    r17.xyz = min(float3(2048,2048,2048), r17.xyz);
    r18.xyzw = r11.zwyw * float4(0.96875,0.96875,0.96875,0.96875) + float4(0.015625,0.015625,0.015625,0.015625);
    r1.w = t15.SampleLevel(s1_s, r18.xy, 0).x;
    r3.w = t15.SampleLevel(s1_s, r18.zw, 0).x;
    r1.w = r3.w * r1.w;
    r1.w = r1.w * r7.w;
    r1.w = r1.w / r8.w;
    r18.xyz = r16.xyz * r16.xyz;
    r18.xyz = r18.xyz * r1.www;
    r16.xyz = -r16.xyz * r8.www + float3(1,1,1);
    r16.xyz = r18.xyz / r16.xyz;
    r16.xyz = r17.xyz + r16.xyz;
    r16.xyz = cb5[4].xxx * r16.xyz;
    r16.xyz = max(float3(0,0,0), r16.xyz);
    r16.xyz = min(float3(1000,1000,1000), r16.xyz);
    
    // Reduce sun specular intensity on glass
    if (GLASS_TRANSPARENCY > 0.5f) {
      r16.xyz *= 0.5f;
    }
    
    r1.w = max(0.00999999978, r10.w);
    r16.xyz = r16.xyz / r1.www;
    r16.xyz = min(float3(1000,1000,1000), r16.xyz);
    r17.xyz = r11.yyy * r9.xyw;
    r16.xyz = r16.xyz * r11.yyy + r17.xyz;
    r16.xyz = cb5[1].xyz * r16.xyz;
    r0.y = 0.5;
    r17.xyz = t14.SampleBias(s1_s, r0.xy, cb0[108].x).xyz;
    r0.x = 1 + -r0.x;
    r17.xyz = r16.xyz * r17.xyz + -r16.xyz;
    r16.xyz = r0.xxx * r17.xyz + r16.xyz;
  } else {
    r16.xyz = float3(0,0,0);
  }
  r0.xy = float2(0.03125,0.03125) * r13.zw;
  r0.xy = floor(r0.xy);
  r0.x = r0.y * cb4[1].y + r0.x;
  r0.x = 8 * r0.x;
  r0.x = (int)r0.x;
  r0.y = -cb0[85].y * cb4[2].w + r14.z;
  r0.y = floor(r0.y);
  r1.w = cb4[1].w + -1;
  r3.w = max(0, r0.y);
  r1.w = min(r3.w, r1.w);
  r3.w = 8 * r1.w;
  r3.w = (int)r3.w;
  r0.y = cmp(r1.w >= r0.y);
  r1.w = (int)r3.w + asint(cb0[110].y);
  r3.w = r11.w * r11.w;
  r11.x = min(1, r0.z);
  r0.z = 1 + -r11.w;
  r4.w = -r0.z * 0.383026004 + -0.0761947036;
  r4.w = r0.z * r4.w + 1.04997003;
  r0.z = r0.z * r4.w + 0.409254998;
  r0.z = min(0.999000013, r0.z);
  r4.w = 1 + -r0.z;
  r17.xyz = float3(1,1,1) + -r7.xyz;
  r17.xyz = r17.xyz * float3(0.0476190485,0.0476190485,0.0476190485) + r7.xyz;
  r11.yz = r11.xw * float2(0.96875,0.96875) + float2(0.015625,0.015625);
  r5.w = t15.SampleLevel(s1_s, r11.yz, 0).x;
  r18.xyz = -r17.xyz * r4.www + float3(1,1,1);
  r17.xyz = r17.xyz * r17.xyz;
  r19.w = 1;
  r13.y = 1;
  r20.z = r11.w;
  r21.xyz = float3(0,0,0);
  r6.w = 1;
  r7.w = 0;
  while (true) {
    r8.w = cmp(7 < (int)r7.w);
    if (r8.w != 0) break;
    r8.w = (int)r0.x + (int)r7.w;
    r8.w = t0[r8.w].val[0/4];
    r9.z = (int)r1.w + (int)r7.w;
    r9.z = t0[r9.z].val[0/4];
    r8.w = (int)r8.w & (int)r9.z;
    r8.w = r0.y ? r8.w : 0;
    r9.z = (uint)r7.w << 5;
    r22.xyz = float3(0,0,0);
    r11.y = r6.w;
    r11.z = r8.w;
    while (true) {
      if (r11.z == 0) break;
      r12.w = firstbitlow((uint)r11.z);
      r15.w = 1 << (int)r12.w;
      r15.w = (int)r11.z ^ (int)r15.w;
      r12.w = (int)r9.z + (int)r12.w;
      bitmask.x = ((~(-1 << 29)) << 3) & 0xffffffff;  r23.x = (((uint)r12.w << 3) & bitmask.x) | ((uint)1 & ~bitmask.x);
      bitmask.y = ((~(-1 << 29)) << 3) & 0xffffffff;  r23.y = (((uint)r12.w << 3) & bitmask.y) | ((uint)3 & ~bitmask.y);
      bitmask.z = ((~(-1 << 29)) << 3) & 0xffffffff;  r23.z = (((uint)r12.w << 3) & bitmask.z) | ((uint)5 & ~bitmask.z);
      bitmask.w = ((~(-1 << 29)) << 3) & 0xffffffff;  r23.w = (((uint)r12.w << 3) & bitmask.w) | ((uint)6 & ~bitmask.w);
      bitmask.w = ((~(-1 << 29)) << 3) & 0xffffffff;  r16.w = (((uint)r12.w << 3) & bitmask.w) | ((uint)7 & ~bitmask.w);
      r17.w = (uint)cb5[r23.z+6].w;
      r17.w = cmp((int)r17.w == 1);
      if (r17.w != 0) {
        r19.xyz = -cb5[r23.x+6].xyz + r1.xyz;
        r24.xyz = int3(0xffff,0xffff,0xffff) & asint(cb5[r23.z+6].xzy);
        r25.xyz = int3(0xffff,0xffff,0xffff) & asint(cb5[r23.w+6].yxz);
        r26.xyz = asuint(cb5[r23.z+6].xzy) >> int3(16,16,16);
        r27.xyz = asuint(cb5[r23.w+6].yxz) >> int3(16,16,16);
        r24.xyz = f16tof32(r24.xyz);
        r25.xyz = f16tof32(r25.xyz);
        r26.xyz = f16tof32(r26.xyz);
        r27.xyw = f16tof32(r27.yxz);
        r28.xz = r24.xz;
        r28.yw = r26.xz;
        r17.w = dot(r19.xyzw, r28.xyzw);
        r26.x = r24.y;
        r26.z = r25.y;
        r26.w = r27.x;
        r18.w = dot(r19.xyzw, r26.xyzw);
        r27.xz = r25.xz;
        r19.x = dot(r19.xyzw, r27.xyzw);
        r17.w = max(abs(r18.w), abs(r17.w));
        r17.w = max(r17.w, abs(r19.x));
        r18.w = cb5[r16.w+6].x * 0.5 + 0.5;
        r17.w = -r18.w + r17.w;
        r18.w = -cb5[r16.w+6].x * 0.5 + 0.5;
        r17.w = saturate(r17.w / r18.w);
        r17.w = 1 + -r17.w;
        r17.w = r17.w * r17.w;
      } else {
        r17.w = 1;
      }
      r18.w = cmp(0.5 < cb5[r23.y+6].z);
      r19.x = cmp(r17.w < 0.00100000005);
      r19.x = (int)r18.w | (int)r19.x;
      if (r19.x != 0) {
        r11.z = r15.w;
        continue;
      }
      r19.x = (uint)r12.w << 3;
      bitmask.w = ((~(-1 << 29)) << 3) & 0xffffffff;  r12.w = (((uint)r12.w << 3) & bitmask.w) | ((uint)2 & ~bitmask.w);
      r19.y = cmp(cb5[r19.x+6].w < 1.5);
      if (r19.y != 0) {
        r19.y = cb5[r12.w+6].y * 0.5 + 0.5;
        r24.x = -abs(cb5[r12.w+6].x) + r19.y;
        r24.y = cb5[r12.w+6].y + -r24.x;
        r19.y = 1 + -abs(r24.x);
        r19.y = r19.y + -abs(r24.y);
        r19.y = max(0.00048828125, r19.y);
        r19.z = cmp(cb5[r12.w+6].x >= 0);
        r24.z = r19.z ? r19.y : -r19.y;
        r19.y = dot(r24.xyz, r24.xyz);
        r19.y = rsqrt(r19.y);
        r24.xyz = r24.xyz * r19.yyy;
        r25.xyz = cb5[r23.x+6].xyz + -r1.xyz;
        r19.y = dot(r25.xyz, r25.xyz);
        r19.z = rsqrt(r19.y);
        r26.xyz = r25.xyz * r19.zzz;
        r20.w = (int)cb5[r16.w+6].w;
        r27.xyz = cb5[r12.w+6].zzz * r24.xyz;
        r28.xyz = -r27.xyz * float3(0.5,0.5,0.5) + r25.xyz;
        r29.xyz = r27.xyz * float3(0.5,0.5,0.5) + r25.xyz;
        r21.w = (uint)cb5[r19.x+6].w;
        r21.w = (int)r21.w & 1;
        r22.w = cmp((int)r21.w == 0);
        r22.w = ~(int)r22.w;
        r23.z = cmp(0 < cb5[r12.w+6].z);
        r22.w = r22.w ? r23.z : 0;
        r23.z = dot(r28.xyz, r28.xyz);
        r23.z = sqrt(r23.z);
        r24.w = dot(r29.xyz, r29.xyz);
        r24.w = sqrt(r24.w);
        r25.w = dot(r6.xyz, r28.xyz);
        r25.w = r25.w / r23.z;
        r26.w = dot(r6.xyz, r29.xyz);
        r26.w = r26.w / r24.w;
        r25.w = r26.w + r25.w;
        r30.x = saturate(0.5 * r25.w);
        r25.w = dot(r28.xyz, r29.xyz);
        r23.z = r23.z * r24.w + r25.w;
        r23.z = r23.z * 0.5 + 1;
        r30.y = 1 / r23.z;
        r13.x = saturate(dot(r6.xyz, r26.xyz));
        r20.xy = r22.ww ? r30.xy : r13.xy;
        r13.x = cmp(cb5[r23.w+6].w < 0);
        if (r13.x != 0) {
          r13.x = cb5[r23.x+6].w * cb5[r23.x+6].w;
          r13.x = r19.y * r13.x;
          r13.x = -r13.x * r13.x + 1;
          r13.x = max(0, r13.x);
          r19.y = 1 + r19.y;
          r19.y = 1 / r19.y;
          r23.z = r22.w ? 1.000000 : 0;
          r24.w = r20.y + -r19.y;
          r19.y = r23.z * r24.w + r19.y;
          r13.x = r13.x * r13.x;
          r13.x = r19.y * r13.x;
        } else {
          r29.xyz = cb5[r23.x+6].www * r25.xyz;
          r19.y = dot(r29.xyz, r29.xyz);
          r19.y = min(1, r19.y);
          r19.y = 1 + -r19.y;
          r19.y = log2(r19.y);
          r19.y = cb5[r23.w+6].w * r19.y;
          r19.y = exp2(r19.y);
          r13.x = r20.y * r19.y;
        }
        r19.y = dot(r26.xyz, -r24.xyz);
        r19.y = -cb5[r12.w+6].z + r19.y;
        r19.y = saturate(cb5[r12.w+6].w * r19.y);
        r19.y = r19.y * r19.y;
        r19.y = r21.w ? 1 : r19.y;
        r13.x = r19.y * r13.x;
        r19.y = ~(int)r22.w;
        r20.y = cmp((int)r20.w >= 0);
        r19.y = r20.y ? r19.y : 0;
        if (r19.y != 0) {
          if (r21.w == 0) {
            r19.y = (uint)r20.w << 2;
            r24.xyz = cb7[r19.y+33].xyw * r1.yyy;
            r24.xyz = cb7[r19.y+32].xyw * r1.xxx + r24.xyz;
            r24.xyz = cb7[r19.y+34].xyw * r1.zzz + r24.xyz;
            r24.xyz = cb7[r19.y+35].xyw + r24.xyz;
            r24.xy = saturate(r24.xy / r24.zz);
            r24.xy = r24.xy * cb7[r20.w+0].zw + cb7[r20.w+0].xy;
          } else {
            r19.y = (uint)r20.w << 2;
            r29.x = dot(-r25.xyz, cb7[r19.y+32].xyz);
            r29.y = dot(-r25.xyz, cb7[r19.y+33].xyz);
            r29.z = dot(-r25.xyz, cb7[r19.y+34].xyz);
            r19.y = cmp(abs(r29.x) < abs(r29.y));
            r19.y = r19.y ? 0.000000 : 0;
            r20.y = dot(abs(r29.xy), icb[r19.y+0].xy);
            r20.y = cmp(r20.y < abs(r29.z));
            r19.y = r20.y ? 2 : r19.y;
            r20.y = dot(r29.xyz, icb[r19.y+0].xyz);
            r20.y = cmp(r20.y < 0);
            bitmask.y = ((~(-1 << 31)) << 1) & 0xffffffff;  r19.y = (((uint)r19.y << 1) & bitmask.y) | ((uint)r20.y & ~bitmask.y);
            r20.y = (uint)r19.y >> 1;
            r20.y = dot(r29.xyz, icb[r20.y+0].xyz);
            r23.z = 0.000244140625 / cb7[r20.w+0].w;
            r23.z = 0.5 + -r23.z;
            r24.z = (uint)r19.y;
            r24.w = cmp((uint)r19.y < 2);
            r24.w = r24.w ? 0.000000 : 0;
            r24.w = dot(r29.xz, icb[r24.w+0].xz);
            r24.w = icb[r19.y+4].z * r24.w;
            r24.w = r24.w / abs(r20.y);
            r24.z = r24.w * r23.z + r24.z;
            r24.z = 0.5 + r24.z;
            r25.x = saturate(0.166666672 * r24.z);
            r24.z = -1 + (int)icb[r19.y+4].y;
            r24.z = dot(r29.yz, icb[r24.z+0].xy);
            r19.y = icb[r19.y+4].w * r24.z;
            r19.y = r19.y / abs(r20.y);
            r25.y = saturate(-r19.y * r23.z + 0.5);
            r24.xy = r25.xy * cb7[r20.w+0].zw + cb7[r20.w+0].xy;
          }
          r19.y = t23.SampleLevel(s1_s, r24.xy, 0).x;
          r13.x = r19.y * r13.x;
        }
        r19.y = cmp(0 < r13.x);
        if (r19.y != 0) {
          if (r21.w == 0) {
            r20.y = (int)cb5[r23.y+6].x;
          } else {
            r24.xyz = -cb5[r23.x+6].xyz + r1.xyz;
            r25.xyz = cmp(abs(r24.yzz) < abs(r24.xxy));
            r20.w = r25.y ? r25.x : 0;
            r24.xyz = cmp(float3(0,0,0) < r24.xyz);
            r21.w = asuint(cb5[r12.w+6].w) >> 24;
            if (8 == 0) r25.x = 0; else if (8+16 < 32) {             r25.x = (uint)cb5[r12.w+6].w << (32-(8 + 16)); r25.x = (uint)r25.x >> (32-8);            } else r25.x = (uint)cb5[r12.w+6].w >> 16;
            if (8 == 0) r25.y = 0; else if (8+8 < 32) {             r25.y = (uint)cb5[r12.w+6].w << (32-(8 + 8)); r25.y = (uint)r25.y >> (32-8);            } else r25.y = (uint)cb5[r12.w+6].w >> 8;
            r21.w = r24.x ? r21.w : r25.x;
            r23.z = 255 & asint(cb5[r12.w+6].w);
            r23.z = r24.y ? r25.y : r23.z;
            if (8 == 0) r24.x = 0; else if (8+8 < 32) {             r24.x = (uint)cb5[r23.y+6].x << (32-(8 + 8)); r24.x = (uint)r24.x >> (32-8);            } else r24.x = (uint)cb5[r23.y+6].x >> 8;
            r24.y = 255 & asint(cb5[r23.y+6].x);
            r24.x = r24.z ? r24.x : r24.y;
            r23.z = r25.z ? r23.z : r24.x;
            r20.w = r20.w ? r21.w : r23.z;
            r21.w = cmp((int)r20.w < 80);
            r20.y = r21.w ? r20.w : -1;
          }
          r24.xyz = r26.xyz * cb6[r20.y+288].xxx + r1.xyz;
          r20.w = cb6[r20.y+288].y * 5;
          r24.xyz = r6.xyz * r20.www + r24.xyz;
          r20.w = (uint)r20.y << 2;
          r25.xyzw = cb6[r20.w+65].xyzw * r24.yyyy;
          r25.xyzw = cb6[r20.w+64].xyzw * r24.xxxx + r25.xyzw;
          r24.xyzw = cb6[r20.w+66].xyzw * r24.zzzz + r25.xyzw;
          r24.xyzw = cb6[r20.w+67].xyzw + r24.xyzw;
          r24.xyz = r24.xyz / r24.www;
          r25.xyz = cmp(float3(0,0,0) >= r24.xyz);
          r29.xyz = cmp(r24.xyz >= float3(1,1,1));
          r30.xy = cb6[r20.y+344].zw + -cb6[r20.y+344].xy;
          r24.xy = r24.xy * r30.xy + cb6[r20.y+344].xy;
          r30.xy = r24.xy * cb6[400].zw + float2(0.5,0.5);
          r30.xy = floor(r30.xy);
          r24.xy = r24.xy * cb6[400].zw + -r30.xy;
          r31.xyzw = float4(0.5,1,0.5,1) + r24.xxyy;
          r32.xyzw = r31.xxzz * r31.xxzz;
          r30.zw = float2(1,1) + -r24.xy;
          r31.xz = min(float2(0,0), r24.xy);
          r33.xy = max(float2(0,0), r24.xy);
          r34.xy = float2(0.159999996,0.159999996) * r30.zw;
          r33.xy = -r33.xy * r33.xy + r31.yw;
          r33.xy = float2(1,1) + r33.xy;
          r33.xy = float2(0.159999996,0.159999996) * r33.xy;
          r32.xz = float2(0.0799999982,0.0799999982) * r32.xz;
          r24.xy = r32.yw * float2(0.5,0.5) + -r24.xy;
          r35.xy = float2(0.159999996,0.159999996) * r24.xy;
          r24.xy = -r31.xz * r31.xz + r30.zw;
          r24.xy = float2(1,1) + r24.xy;
          r36.xy = float2(0.159999996,0.159999996) * r24.xy;
          r24.xy = float2(0.159999996,0.159999996) * r31.yw;
          r35.z = r36.x;
          r35.w = r24.x;
          r34.z = r33.x;
          r34.w = r32.x;
          r31.xyzw = r35.zwxz + r34.zwxz;
          r36.z = r35.y;
          r36.w = r24.y;
          r33.z = r34.y;
          r33.w = r32.z;
          r24.xyw = r36.zyw + r33.zyw;
          r32.xyz = r34.xzw / r31.zwy;
          r32.xyz = float3(-2.5,-0.5,1.5) + r32.xyz;
          r32.xyz = cb6[400].xxx * r32.xyz;
          r33.xyz = r33.zyw / r24.xyw;
          r33.xyz = float3(-2.5,-0.5,1.5) + r33.xyz;
          r33.xyw = cb6[400].yyy * r33.xyz;
          r34.xyzw = r31.zwyz * r24.xxxy;
          r32.w = r33.x;
          r35.xyzw = r30.xyxy * cb6[400].xyxy + r32.xwyw;
          r20.w = t11.SampleCmpLevelZero(s4_s, r35.xy, r24.z).x;
          r21.w = t11.SampleCmpLevelZero(s4_s, r35.zw, r24.z).x;
          r21.w = r34.y * r21.w;
          r20.w = r34.x * r20.w + r21.w;
          r30.zw = r30.xy * cb6[400].xy + r32.zw;
          r21.w = t11.SampleCmpLevelZero(s4_s, r30.zw, r24.z).x;
          r20.w = r34.z * r21.w + r20.w;
          r33.z = r32.x;
          r35.xyzw = r30.xyxy * cb6[400].xyxy + r33.zyzw;
          r21.w = t11.SampleCmpLevelZero(s4_s, r35.xy, r24.z).x;
          r20.w = r34.w * r21.w + r20.w;
          r34.xyzw = r31.xyzw * r24.yyww;
          r33.xz = r32.yz;
          r32.xyzw = r30.xyxy * cb6[400].xyxy + r33.xyzy;
          r21.w = t11.SampleCmpLevelZero(s4_s, r32.xy, r24.z).x;
          r20.w = r34.x * r21.w + r20.w;
          r21.w = t11.SampleCmpLevelZero(s4_s, r32.zw, r24.z).x;
          r20.w = r34.y * r21.w + r20.w;
          r21.w = t11.SampleCmpLevelZero(s4_s, r35.zw, r24.z).x;
          r20.w = r34.z * r21.w + r20.w;
          r21.w = cmp((int)r20.y >= 0);
          r25.xyz = (int3)r25.xyz | (int3)r29.xyz;
          r23.z = (int)r25.y | (int)r25.x;
          r23.z = (int)r25.z | (int)r23.z;
          r24.x = (int)r24.z & 0x7fffffff;
          r24.x = cmp(0x7f800000 < (uint)r24.x);
          r23.z = (int)r23.z | (int)r24.x;
          r25.xyzw = r30.xyxy * cb6[400].xyxy + r33.xwzw;
          r24.x = t11.SampleCmpLevelZero(s4_s, r25.xy, r24.z).x;
          r20.w = r34.w * r24.x + r20.w;
          r24.x = r31.y * r24.w;
          r24.y = t11.SampleCmpLevelZero(s4_s, r25.zw, r24.z).x;
          r20.w = r24.x * r24.y + r20.w;
          r20.w = -1 + r20.w;
          r20.y = cb6[r20.y+288].w * r20.w + 1;
          r20.y = r23.z ? 1 : r20.y;
          r20.y = r21.w ? r20.y : 1;
        } else {
          r20.y = 1;
        }
        if (r22.w != 0) {
          r20.w = dot(r15.xyz, r27.xyz);
          r21.w = saturate(cb5[r12.w+6].z * r19.z);
          r21.w = r21.w * 0.5 + r3.w;
          r21.w = min(1, r21.w);
          r21.w = r3.w / r21.w;
          r24.xyz = r15.xyz * r20.www + -r27.xyz;
          r22.w = dot(r28.xyz, r24.xyz);
          r20.w = r20.w * r20.w;
          r20.w = cb5[r12.w+6].z * cb5[r12.w+6].z + -r20.w;
          r20.w = saturate(r22.w / r20.w);
          r24.xyz = r27.xyz * r20.www + r28.xyz;
          r20.w = dot(r24.xyz, r24.xyz);
          r20.w = rsqrt(r20.w);
          r26.xyz = r24.xyz * r20.www;
        } else {
          r21.w = 1;
        }
        if (r19.y != 0) {
          r19.y = saturate(cb5[r16.w+6].y * r19.z);
          r24.xyz = r3.xyz * r2.www + r26.xyz;
          r19.z = dot(r24.xyz, r24.xyz);
          r19.z = max(6.10351562e-05, r19.z);
          r19.z = rsqrt(r19.z);
          r24.xyz = r24.xyz * r19.zzz;
          r19.z = saturate(dot(r6.xyz, r24.xyz));
          r20.w = saturate(dot(r5.xyz, r24.xyz));
          r22.w = cmp(0 < r19.y);
          r19.y = r19.y * r19.y;
          r23.z = r20.w * 3.5999999 + 0.400000006;
          r19.y = r19.y / r23.z;
          r19.y = r11.w * r11.w + r19.y;
          r19.y = min(1, r19.y);
          r19.y = r22.w ? r19.y : r3.w;
          r19.y = r19.y * r19.y;
          r22.w = r19.z * r19.y + -r19.z;
          r19.z = r22.w * r19.z + 1;
          r20.w = 1 + -r20.w;
          r22.w = r20.w * r20.w;
          r22.w = r22.w * r22.w;
          r23.z = r22.w * r20.w;
          r20.w = -r22.w * r20.w + 1;
          r24.xyz = r7.xyz * r20.www + r23.zzz;
          r19.z = r19.z * r19.z;
          r19.z = r19.y / r19.z;
          r19.z = r19.z * r21.w;
          r20.w = -r11.x * r19.y + r11.x;
          r20.w = r20.w * r11.x + r19.y;
          r20.w = sqrt(r20.w);
          r21.w = -r20.x * r19.y + r20.x;
          r19.y = r21.w * r20.x + r19.y;
          r19.y = sqrt(r19.y);
          r19.y = r19.y * r11.x;
          r19.y = r20.x * r20.w + r19.y;
          r19.y = 9.99999975e-05 + r19.y;
          r19.y = 0.5 / r19.y;
          r19.y = r19.z * r19.y;
          r24.xyz = r24.xyz * r19.yyy;
          r24.xyz = min(float3(2048,2048,2048), r24.xyz);
          r19.yz = r20.xz * float2(0.96875,0.96875) + float2(0.015625,0.015625);
          r19.y = t15.SampleLevel(s1_s, r19.yz, 0).x;
          r19.y = r19.y * r5.w;
          r19.y = r19.y * r0.z;
          r19.y = r19.y / r4.w;
          r25.xyz = r19.yyy * r17.xyz;
          r25.xyz = r25.xyz / r18.xyz;
          r24.xyz = r25.xyz + r24.xyz;
          r24.xyz = cb5[r16.w+6].zzz * r24.xyz;
          r24.xyz = max(float3(0,0,0), r24.xyz);
          r24.xyz = min(float3(1000,1000,1000), r24.xyz);
          r25.xyz = r20.xxx * r9.xyw;
          r24.xyz = r24.xyz * r20.xxx + r25.xyz;
          r25.xyz = cb5[r19.x+6].xyz * r13.xxx;
          r20.xyw = r25.xyz * r20.yyy;
          r20.xyw = r20.xyw * r17.www;
          r20.xyw = r24.xyz * r20.xyw;
        } else {
          r20.xyw = float3(0,0,0);
        }
      } else {
        if (r18.w == 0) {
          r13.x = cb5[r12.w+6].y * 0.5 + 0.5;
          r24.x = -abs(cb5[r12.w+6].x) + r13.x;
          r24.y = cb5[r12.w+6].y + -r24.x;
          r13.x = 1 + -abs(r24.x);
          r13.x = r13.x + -abs(r24.y);
          r13.x = max(0.00048828125, r13.x);
          r17.w = cmp(cb5[r12.w+6].x >= 0);
          r24.z = r17.w ? r13.x : -r13.x;
          r13.x = dot(r24.xyz, r24.xyz);
          r13.x = rsqrt(r13.x);
          r24.xyz = r24.xyz * r13.xxx;
          r25.xyz = cb5[r23.x+6].xyz + -r1.xyz;
          r13.x = dot(r25.xyz, r25.xyz);
          r17.w = rsqrt(r13.x);
          r26.xyz = r25.xyz * r17.www;
          r16.w = (int)cb5[r16.w+6].w;
          r27.xyz = cb5[r12.w+6].zzz * r24.xyz;
          r28.xyz = -r27.xyz * float3(0.5,0.5,0.5) + r25.xyz;
          r27.xyz = r27.xyz * float3(0.5,0.5,0.5) + r25.xyz;
          r17.w = (uint)cb5[r19.x+6].w;
          r17.w = (int)r17.w & 1;
          r18.w = cmp((int)r17.w == 0);
          r18.w = ~(int)r18.w;
          r19.x = cmp(0 < cb5[r12.w+6].z);
          r18.w = r18.w ? r19.x : 0;
          r19.x = dot(r28.xyz, r28.xyz);
          r19.y = dot(r27.xyz, r27.xyz);
          r19.xy = sqrt(r19.xy);
          r19.z = dot(r28.xyz, r27.xyz);
          r19.x = r19.x * r19.y + r19.z;
          r19.x = r19.x * 0.5 + 1;
          r19.x = 1 / r19.x;
          r19.x = r18.w ? r19.x : 1;
          r19.y = cmp(cb5[r23.w+6].w < 0);
          if (r19.y != 0) {
            r19.y = cb5[r23.x+6].w * cb5[r23.x+6].w;
            r19.y = r19.y * r13.x;
            r19.y = -r19.y * r19.y + 1;
            r19.y = max(0, r19.y);
            r13.x = 1 + r13.x;
            r13.x = 1 / r13.x;
            r19.z = r18.w ? 1.000000 : 0;
            r21.w = r19.x + -r13.x;
            r13.x = r19.z * r21.w + r13.x;
            r19.y = r19.y * r19.y;
            r13.x = r19.y * r13.x;
          } else {
            r27.xyz = cb5[r23.x+6].www * r25.xyz;
            r19.y = dot(r27.xyz, r27.xyz);
            r19.y = min(1, r19.y);
            r19.y = 1 + -r19.y;
            r19.y = log2(r19.y);
            r19.y = cb5[r23.w+6].w * r19.y;
            r19.y = exp2(r19.y);
            r13.x = r19.x * r19.y;
          }
          r19.x = dot(r26.xyz, -r24.xyz);
          r19.x = -cb5[r12.w+6].z + r19.x;
          r19.x = saturate(cb5[r12.w+6].w * r19.x);
          r19.x = r19.x * r19.x;
          r19.x = r17.w ? 1 : r19.x;
          r13.x = r19.x * r13.x;
          r18.w = ~(int)r18.w;
          r19.x = cmp((int)r16.w >= 0);
          r18.w = r18.w ? r19.x : 0;
          if (r18.w != 0) {
            if (r17.w == 0) {
              r18.w = (uint)r16.w << 2;
              r19.xyz = cb7[r18.w+33].xyw * r1.yyy;
              r19.xyz = cb7[r18.w+32].xyw * r1.xxx + r19.xyz;
              r19.xyz = cb7[r18.w+34].xyw * r1.zzz + r19.xyz;
              r19.xyz = cb7[r18.w+35].xyw + r19.xyz;
              r19.xy = saturate(r19.xy / r19.zz);
              r19.xy = r19.xy * cb7[r16.w+0].zw + cb7[r16.w+0].xy;
            } else {
              r18.w = (uint)r16.w << 2;
              r24.x = dot(-r25.xyz, cb7[r18.w+32].xyz);
              r24.y = dot(-r25.xyz, cb7[r18.w+33].xyz);
              r24.z = dot(-r25.xyz, cb7[r18.w+34].xyz);
              r18.w = cmp(abs(r24.x) < abs(r24.y));
              r18.w = r18.w ? 0.000000 : 0;
              r19.z = dot(abs(r24.xy), icb[r18.w+0].xy);
              r19.z = cmp(r19.z < abs(r24.z));
              r18.w = r19.z ? 2 : r18.w;
              r19.z = dot(r24.xyz, icb[r18.w+0].xyz);
              r19.z = cmp(r19.z < 0);
              bitmask.w = ((~(-1 << 31)) << 1) & 0xffffffff;  r18.w = (((uint)r18.w << 1) & bitmask.w) | ((uint)r19.z & ~bitmask.w);
              r19.z = (uint)r18.w >> 1;
              r19.z = dot(r24.xyz, icb[r19.z+0].xyz);
              r21.w = 0.000244140625 / cb7[r16.w+0].w;
              r21.w = 0.5 + -r21.w;
              r22.w = (uint)r18.w;
              r23.z = cmp((uint)r18.w < 2);
              r23.z = r23.z ? 0.000000 : 0;
              r23.z = dot(r24.xz, icb[r23.z+0].xz);
              r23.z = icb[r18.w+4].z * r23.z;
              r23.z = r23.z / abs(r19.z);
              r22.w = r23.z * r21.w + r22.w;
              r22.w = 0.5 + r22.w;
              r25.x = saturate(0.166666672 * r22.w);
              r22.w = -1 + (int)icb[r18.w+4].y;
              r22.w = dot(r24.yz, icb[r22.w+0].xy);
              r18.w = icb[r18.w+4].w * r22.w;
              r18.w = r18.w / abs(r19.z);
              r25.y = saturate(-r18.w * r21.w + 0.5);
              r19.xy = r25.xy * cb7[r16.w+0].zw + cb7[r16.w+0].xy;
            }
            r16.w = t23.SampleLevel(s1_s, r19.xy, 0).x;
            r13.x = r16.w * r13.x;
          }
          r13.x = cmp(0 < r13.x);
          if (r13.x != 0) {
            if (r17.w == 0) {
              r13.x = (int)cb5[r23.y+6].x;
            } else {
              r19.xyz = -cb5[r23.x+6].xyz + r1.xyz;
              r23.xzw = cmp(abs(r19.yzz) < abs(r19.xxy));
              r16.w = r23.z ? r23.x : 0;
              r19.xyz = cmp(float3(0,0,0) < r19.xyz);
              r17.w = asuint(cb5[r12.w+6].w) >> 24;
              if (8 == 0) r23.x = 0; else if (8+16 < 32) {               r23.x = (uint)cb5[r12.w+6].w << (32-(8 + 16)); r23.x = (uint)r23.x >> (32-8);              } else r23.x = (uint)cb5[r12.w+6].w >> 16;
              if (8 == 0) r23.z = 0; else if (8+8 < 32) {               r23.z = (uint)cb5[r12.w+6].w << (32-(8 + 8)); r23.z = (uint)r23.z >> (32-8);              } else r23.z = (uint)cb5[r12.w+6].w >> 8;
              r17.w = r19.x ? r17.w : r23.x;
              r12.w = 255 & asint(cb5[r12.w+6].w);
              r12.w = r19.y ? r23.z : r12.w;
              if (8 == 0) r18.w = 0; else if (8+8 < 32) {               r18.w = (uint)cb5[r23.y+6].x << (32-(8 + 8)); r18.w = (uint)r18.w >> (32-8);              } else r18.w = (uint)cb5[r23.y+6].x >> 8;
              r19.x = 255 & asint(cb5[r23.y+6].x);
              r18.w = r19.z ? r18.w : r19.x;
              r12.w = r23.w ? r12.w : r18.w;
              r12.w = r16.w ? r17.w : r12.w;
              r16.w = cmp((int)r12.w < 80);
              r13.x = r16.w ? r12.w : -1;
            }
            r19.xyz = r26.xyz * cb6[r13.x+288].xxx + r1.xyz;
            r12.w = cb6[r13.x+288].y * 5;
            r19.xyz = r6.xyz * r12.www + r19.xyz;
            r12.w = (uint)r13.x << 2;
            r23.xyzw = cb6[r12.w+65].xyzw * r19.yyyy;
            r23.xyzw = cb6[r12.w+64].xyzw * r19.xxxx + r23.xyzw;
            r23.xyzw = cb6[r12.w+66].xyzw * r19.zzzz + r23.xyzw;
            r23.xyzw = cb6[r12.w+67].xyzw + r23.xyzw;
            r19.xyz = r23.xyz / r23.www;
            r23.xyz = cmp(float3(0,0,0) >= r19.xyz);
            r24.xyz = cmp(r19.xyz >= float3(1,1,1));
            r25.xy = cb6[r13.x+344].zw + -cb6[r13.x+344].xy;
            r19.xy = r19.xy * r25.xy + cb6[r13.x+344].xy;
            r25.xy = r19.xy * cb6[400].zw + float2(0.5,0.5);
            r25.xy = floor(r25.xy);
            r19.xy = r19.xy * cb6[400].zw + -r25.xy;
            r26.xyzw = float4(0.5,1,0.5,1) + r19.xxyy;
            r27.xyzw = r26.xxzz * r26.xxzz;
            r25.zw = float2(1,1) + -r19.xy;
            r26.xz = min(float2(0,0), r19.xy);
            r28.xy = max(float2(0,0), r19.xy);
            r29.xy = float2(0.159999996,0.159999996) * r25.zw;
            r28.xy = -r28.xy * r28.xy + r26.yw;
            r28.xy = float2(1,1) + r28.xy;
            r28.xy = float2(0.159999996,0.159999996) * r28.xy;
            r27.xz = float2(0.0799999982,0.0799999982) * r27.xz;
            r19.xy = r27.yw * float2(0.5,0.5) + -r19.xy;
            r30.xy = float2(0.159999996,0.159999996) * r19.xy;
            r19.xy = -r26.xz * r26.xz + r25.zw;
            r19.xy = float2(1,1) + r19.xy;
            r31.xy = float2(0.159999996,0.159999996) * r19.xy;
            r19.xy = float2(0.159999996,0.159999996) * r26.yw;
            r30.z = r31.x;
            r30.w = r19.x;
            r29.z = r28.x;
            r29.w = r27.x;
            r26.xyzw = r30.zwxz + r29.zwxz;
            r31.z = r30.y;
            r31.w = r19.y;
            r28.z = r29.y;
            r28.w = r27.z;
            r27.xyz = r31.zyw + r28.zyw;
            r29.xyz = r29.xzw / r26.zwy;
            r29.xyz = float3(-2.5,-0.5,1.5) + r29.xyz;
            r29.xyz = cb6[400].xxx * r29.xyz;
            r28.xyz = r28.zyw / r27.xyz;
            r28.xyz = float3(-2.5,-0.5,1.5) + r28.xyz;
            r28.xyw = cb6[400].yyy * r28.xyz;
            r30.xyzw = r27.xxxy * r26.zwyz;
            r29.w = r28.x;
            r31.xyzw = r25.xyxy * cb6[400].xyxy + r29.xwyw;
            r12.w = t11.SampleCmpLevelZero(s4_s, r31.xy, r19.z).x;
            r16.w = t11.SampleCmpLevelZero(s4_s, r31.zw, r19.z).x;
            r16.w = r30.y * r16.w;
            r12.w = r30.x * r12.w + r16.w;
            r19.xy = r25.xy * cb6[400].xy + r29.zw;
            r16.w = t11.SampleCmpLevelZero(s4_s, r19.xy, r19.z).x;
            r12.w = r30.z * r16.w + r12.w;
            r28.z = r29.x;
            r31.xyzw = r25.xyxy * cb6[400].xyxy + r28.zyzw;
            r16.w = t11.SampleCmpLevelZero(s4_s, r31.xy, r19.z).x;
            r12.w = r30.w * r16.w + r12.w;
            r30.xyzw = r27.yyzz * r26.xyzw;
            r28.xz = r29.yz;
            r29.xyzw = r25.xyxy * cb6[400].xyxy + r28.xyzy;
            r16.w = t11.SampleCmpLevelZero(s4_s, r29.xy, r19.z).x;
            r12.w = r30.x * r16.w + r12.w;
            r16.w = t11.SampleCmpLevelZero(s4_s, r29.zw, r19.z).x;
            r12.w = r30.y * r16.w + r12.w;
            r16.w = t11.SampleCmpLevelZero(s4_s, r31.zw, r19.z).x;
            r12.w = r30.z * r16.w + r12.w;
            r16.w = cmp((int)r13.x >= 0);
            r23.xyz = (int3)r23.xyz | (int3)r24.xyz;
            r17.w = (int)r23.y | (int)r23.x;
            r17.w = (int)r23.z | (int)r17.w;
            r18.w = (int)r19.z & 0x7fffffff;
            r18.w = cmp(0x7f800000 < (uint)r18.w);
            r17.w = (int)r17.w | (int)r18.w;
            r23.xyzw = r25.xyxy * cb6[400].xyxy + r28.xwzw;
            r18.w = t11.SampleCmpLevelZero(s4_s, r23.xy, r19.z).x;
            r12.w = r30.w * r18.w + r12.w;
            r18.w = r27.z * r26.y;
            r19.x = t11.SampleCmpLevelZero(s4_s, r23.zw, r19.z).x;
            r12.w = r18.w * r19.x + r12.w;
            r12.w = -1 + r12.w;
            r12.w = cb6[r13.x+288].w * r12.w + 1;
            r12.w = r17.w ? 1 : r12.w;
            r12.w = r16.w ? r12.w : 1;
          } else {
            r12.w = 1;
          }
        } else {
          r12.w = 1;
        }
        r11.y = r12.w * r11.y;
        r20.xyw = float3(0,0,0);
      }
      r22.xyz = r22.xyz + r20.xyw;
      r11.z = r15.w;
    }
    r6.w = r11.y;
    r21.xyz = r22.xyz + r21.xyz;
    r7.w = (int)r7.w + 1;
  }
  r0.x = dot(r2.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r1.xzw = r2.xyz + -r0.xxx;
  r0.xyz = cb0[184].www * r1.xzw + r0.xxx;
  
  // Reduce clustered light contribution on glass
  if (GLASS_TRANSPARENCY > 0.5f) {
    r21.xyz *= 0.5f;
  }
  
  r1.xzw = r21.xyz * r6.www + r16.xyz;
  r2.xyz = cb2[21].xyz * cb2[20].zzz;
  r2.w = 1 + -r10.w;
  r3.x = -cb2[20].y + 1;
  r3.x = max(0.00999999978, r3.x);
  r2.w = saturate(r2.w / r3.x);
  r2.xyz = r8.xyz * r2.xyz + -r1.xzw;
  r1.xzw = r2.www * r2.xyz + r1.xzw;
  r0.xyz = r0.xyz * cb0[184].xyz + r1.xzw;
  
  // Apply glass brightness reduction
  if (GLASS_TRANSPARENCY > 0.5f) {
    r0.xyz *= 0.65f;
  }
  r1.x = r1.y * cb0[156].w + cb0[157].w;
  r1.z = r0.w * cb0[154].w + -cb0[153].w;
  r1.xz = max(float2(0.00999999978,0), r1.xz);
  r1.w = -1.44269502 * r1.x;
  r1.w = exp2(r1.w);
  r1.w = 1 + -r1.w;
  r1.x = r1.w / r1.x;
  r1.w = r1.y * cb0[156].w + cb0[158].w;
  r1.w = 1.44269502 * r1.w;
  r1.w = exp2(r1.w);
  r1.x = r1.x * r1.w;
  r1.x = -r1.z * r1.x;
  r1.xzw = cb0[155].xyz * r1.xxx;
  r1.xzw = float3(1.44269502,1.44269502,1.44269502) * r1.xzw;
  r1.xzw = exp2(r1.xzw);
  r2.x = dot(-r5.xyz, cb0[154].xyz);
  r2.y = cb0[155].w * cb0[155].w + 1;
  r2.z = dot(r2.xx, cb0[155].ww);
  r2.y = r2.y + -r2.z;
  r2.z = cmp(0 < cb0[163].z);
  if (r2.z != 0) {
    r14.w = 7 & asint(cb0[108].w);
    r3.xyz = mad((int3)r14.xyw, int3(0x19660d,0x19660d,0x19660d), int3(0x3c6ef35f,0x3c6ef35f,0x3c6ef35f));
    r2.z = mad((int)r3.y, (int)r3.z, (int)r3.x);
    r2.w = mad((int)r3.z, (int)r2.z, (int)r3.y);
    r3.x = mad((int)r2.z, (int)r2.w, (int)r3.z);
    r6.x = mad((int)r2.w, (int)r3.x, (int)r2.z);
    r2.z = dot(-r5.xyz, -r4.xyz);
    r3.y = -cb0[44].y + r1.y;
    r3.z = cmp(5.96046448e-08 < r2.z);
    r2.z = 1 / r2.z;
    r2.z = r3.z ? r2.z : 0;
    r2.z = cb0[163].w * r2.z;
    r3.z = 1 / r0.w;
    r3.w = r3.z * r2.z;
    r4.x = r3.w * r3.y + cb0[44].y;
    r3.y = -r3.w * r3.y + r3.y;
    r3.w = cb0[159].z * r3.y;
    r3.y = cb0[162].x * r3.y;
    r3.yw = max(float2(-127,-127), r3.yw);
    r4.y = -cb0[159].x + r4.x;
    r4.y = cb0[159].z * r4.y;
    r4.y = max(-127, r4.y);
    r4.y = exp2(-r4.y);
    r4.y = cb0[159].y * r4.y;
    r4.z = cmp(5.96046448e-08 < abs(r3.w));
    r4.w = exp2(-r3.w);
    r4.w = 1 + -r4.w;
    r4.w = r4.w / r3.w;
    r3.w = -r3.w * 0.240226507 + 0.693147182;
    r3.w = r4.z ? r4.w : r3.w;
    r4.x = -cb0[162].z + r4.x;
    r4.x = cb0[162].x * r4.x;
    r4.x = max(-127, r4.x);
    r4.x = exp2(-r4.x);
    r4.x = cb0[162].y * r4.x;
    r4.z = cmp(5.96046448e-08 < abs(r3.y));
    r4.w = exp2(-r3.y);
    r4.w = 1 + -r4.w;
    r4.w = r4.w / r3.y;
    r3.y = -r3.y * 0.240226507 + 0.693147182;
    r3.y = r4.z ? r4.w : r3.y;
    r3.y = r4.x * r3.y;
    r3.y = r4.y * r3.w + r3.y;
    r2.z = -r2.z * r3.z + 1;
    r2.z = r2.z * r0.w;
    r2.z = r3.y * r2.z;
    r2.z = exp2(-r2.z);
    r2.z = min(1, r2.z);
    r2.z = max(cb0[161].w, r2.z);
    r3.yz = saturate(r0.ww * cb0[160].yw + cb0[160].xz);
    r2.z = r3.y + r2.z;
    r2.z = r2.z + r3.z;
    r2.z = min(1, r2.z);
    r6.y = mad((int)r3.x, (int)r6.x, (int)r2.w);
    r3.xy = (uint2)r6.xy >> int2(16,16);
    r3.xy = (uint2)r3.xy;
    r3.xy = r3.xy * float2(3.05180438e-05,3.05180438e-05) + float2(-1,-1);
    r3.xy = r3.xy * cb0[167].ww + r13.zw;
    r3.xy = cb0[165].xy * r3.xy;
    r2.w = r14.z * cb0[164].x + cb0[164].y;
    r2.w = log2(r2.w);
    r2.w = cb0[164].z * r2.w;
    r3.z = r2.w / cb0[163].z;
    r3.xyzw = t22.SampleLevel(s1_s, r3.xyz, 0).xyzw;
    r2.w = -cb0[166].z + r14.z;
    r2.w = saturate(1000000 * r2.w);
    r3.xyzw = float4(-0,-0,-0,-1) + r3.xyzw;
    r3.xyzw = r2.wwww * r3.xyzw + float4(0,0,0,1);
    r2.w = 1 + -r2.z;
    r4.xyz = cb0[161].xyz * r2.www;
    r3.xyz = r4.xyz * r3.www + r3.xyz;
    r2.z = r3.w * r2.z;
  } else {
    r1.y = -cb0[44].y + r1.y;
    r2.w = cb0[159].z * r1.y;
    r2.w = max(-127, r2.w);
    r1.y = cb0[162].x * r1.y;
    r1.y = max(-127, r1.y);
    r3.w = -cb0[159].x + cb0[44].y;
    r3.w = cb0[159].z * r3.w;
    r3.w = max(-127, r3.w);
    r3.w = exp2(-r3.w);
    r3.w = cb0[159].y * r3.w;
    r4.x = cmp(5.96046448e-08 < abs(r2.w));
    r4.y = exp2(-r2.w);
    r4.y = 1 + -r4.y;
    r4.y = r4.y / r2.w;
    r2.w = -r2.w * 0.240226507 + 0.693147182;
    r2.w = r4.x ? r4.y : r2.w;
    r4.x = -cb0[162].z + cb0[44].y;
    r4.x = cb0[162].x * r4.x;
    r4.x = max(-127, r4.x);
    r4.x = exp2(-r4.x);
    r4.x = cb0[162].y * r4.x;
    r4.y = cmp(5.96046448e-08 < abs(r1.y));
    r4.z = exp2(-r1.y);
    r4.z = 1 + -r4.z;
    r4.z = r4.z / r1.y;
    r1.y = -r1.y * 0.240226507 + 0.693147182;
    r1.y = r4.y ? r4.z : r1.y;
    r1.y = r4.x * r1.y;
    r1.y = r3.w * r2.w + r1.y;
    r1.y = r1.y * r0.w;
    r1.y = exp2(-r1.y);
    r1.y = min(1, r1.y);
    r1.y = max(cb0[161].w, r1.y);
    r4.xy = saturate(r0.ww * cb0[160].yw + cb0[160].xz);
    r0.w = r4.x + r1.y;
    r0.w = r0.w + r4.y;
    r2.z = min(1, r0.w);
    r0.w = 1 + -r2.z;
    r3.xyz = cb0[161].xyz * r0.www;
  }
  r4.xyz = r2.zzz * r1.xzw;
  r0.w = r2.x * r2.x + 1;
  r0.w = 0.0596831031 * r0.w;
  r5.xyz = cb0[156].xyz * r0.www + cb0[158].xyz;
  r0.w = -cb0[155].w * cb0[155].w + 1;
  r1.y = 12.566371 * r2.y;
  r2.x = sqrt(r2.y);
  r1.y = r2.x * r1.y;
  r1.y = max(0.00100000005, r1.y);
  r0.w = r0.w / r1.y;
  r2.xyw = saturate(cb0[157].xyz * r0.www + r5.xyz);
  r2.xyw = float3(255,255,255) * r2.xyw;
  r1.xyz = float3(1,1,1) + -r1.xzw;
  r1.xyz = r2.xyw * r1.xyz;
  r1.xyz = r1.xyz * r2.zzz + r3.xyz;
  
  // Reduce fog/atmospheric contributin
  if (GLASS_TRANSPARENCY > 0.5f) {
    // Boost transmittance to reduce fog density on glass
    float3 boostedTrans = lerp(r4.xyz, float3(1,1,1), 0.5f);
    float3 reducedInscatter = r1.xyz * 0.35f;
    r10.xyz = r0.xyz * boostedTrans + reducedInscatter;
  } else {
    // Vanilla behavior
    r10.xyz = r0.xyz * r4.xyz + r1.xyz;
  }
  r0.xy = float2(0.5,-0.5) * r12.xy;
  r0.xy = sqrt(abs(r0.xy));
  r0.xy = sqrt(r0.xy);
  r12.z = -r12.y;
  r0.zw = cmp(float2(0,0) < r12.xz);
  r1.xy = cmp(r12.xz < float2(0,0));
  r0.zw = (int2)-r0.zw + (int2)r1.xy;
  r0.zw = (int2)r0.zw;
  r0.xy = r0.xy * r0.zw;
  r0.xy = r0.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r0.z = (uint)v7.x << 4;
  r0.z = max(cb1[r0.z+4].y, cb1[r0.z+4].z);
  r0.z = -0.100000024 + r0.z;
  r0.w = cmp(0 < r0.z);
  r0.z = cmp(r0.z < 0);
  r0.z = (int)-r0.w + (int)r0.z;
  r0.z = (int)r0.z;
  r0.z = saturate(r0.z);
  r1.xy = float2(0.5,0.5) + -r0.xy;
  r0.xy = r0.zz * r1.xy + r0.xy;
  o1.xy = min(float2(1,1), r0.xy);
  r0.x = dot(r10.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.x = r0.x * r10.w;
  r0.x = max(r0.x, r10.w);
  r0.x = saturate(10 * r0.x);
  r0.x = cmp(0.5 < r0.x);
  o1.z = r0.x ? 1.000000 : 0;
  
  // Modifed Glass Final Output
  if (GLASS_TRANSPARENCY > 0.5f) {
    float3 glassColor = r10.xyz;
    float glassLuma = dot(glassColor, float3(0.2126f, 0.7152f, 0.0722f));   
    float maxBrightness = 2.0f;
    if (glassLuma > 0.5f) {
      float compression = 0.5f + (maxBrightness - 0.5f) * (1.0f - exp(-(glassLuma - 0.5f) / (maxBrightness - 0.5f)));
      float scale = compression / max(glassLuma, 0.001f);
      glassColor *= scale;
    }
    
    o0.xyz = glassColor;
    o0.w = r10.w;
  } else {
    // Vanilla output
    o0.xyzw = r10.xyzw;
  }
  o1.w = 0;
  return;
}