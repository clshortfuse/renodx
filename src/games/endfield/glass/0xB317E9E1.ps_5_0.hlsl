// ---- Created with 3Dmigoto v1.4.1 on Wed Feb  4 04:05:41 2026
#include "../common.hlsl"

Texture2D<float4> t18 : register(t18);

Texture3D<float4> t17 : register(t17);

Texture3D<float4> t16 : register(t16);

Texture3D<float4> t15 : register(t15);

Texture3D<float4> t14 : register(t14);

Texture3D<float4> t13 : register(t13);

Texture3D<float4> t12 : register(t12);

Texture3D<float4> t11 : register(t11);

Texture2D<float4> t10 : register(t10);

Texture2D<float4> t9 : register(t9);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2DArray<float4> t1 : register(t1);

struct t0_t {
  float val[1];
};
StructuredBuffer<t0_t> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerComparisonState s3_s : register(s3);

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
  float4 cb2[20];
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31,r32,r33,r34,r35;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[82].zw * v0.xy;
  r0.xy = r0.xy * float2(2,2) + float2(-1,-1);
  r1.xyzw = cb0[25].xyzw * -r0.yyyy;
  r0.xyzw = cb0[24].xyzw * r0.xxxx + r1.xyzw;
  r0.xyzw = cb0[26].xyzw * v0.zzzz + r0.xyzw;
  r0.xyzw = cb0[27].xyzw + r0.xyzw;
  r0.xyz = r0.xyz / r0.www;
  r1.x = cmp(0 < v3.w);
  r1.x = r1.x ? 1 : -1;
  r1.y = cmp(0.000000 == cb0[86].w);
  r2.xyz = cb0[44].xyz + -r0.xyz;
  r3.x = cb0[0].z;
  r3.y = cb0[1].z;
  r3.z = cb0[2].z;
  r1.yzw = r1.yyy ? r2.xyz : r3.xyz;
  r2.x = dot(r1.yzw, r1.yzw);
  r2.y = max(9.99999994e-09, r2.x);
  r2.y = rsqrt(r2.y);
  r4.xyz = r2.yyy * r1.yzw;
  r2.x = r2.x * r2.y;
  r2.zw = w1.xy + -v1.xy;
  r5.xy = cb2[3].xx * r2.zw + v1.xy;
  r5.xy = r5.xy * cb2[12].xy + cb2[12].zw;
  r2.zw = cb2[2].ww * r2.zw + v1.xy;
  r2.zw = r2.zw * cb2[11].xy + cb2[11].zw;
  r6.xyzw = t2.SampleBias(s4_s, r2.zw, cb0[108].x).xyzw;
  r2.z = cb2[3].y + cb0[108].x;
  r7.xyz = t3.SampleBias(s5_s, r5.xy, r2.z).xyw;
  r7.x = r7.z * r7.x;
  r2.zw = r7.xy * float2(2,2) + float2(-1,-1);
  r5.zw = cb2[0].xx * r2.zw;
  r7.xyz = t4.SampleBias(s6_s, r5.xy, cb0[108].x).xyz;
  r6.xyzw = cb2[8].xyzw * r6.xyzw;
  r6.xyz = saturate(cb2[4].zzz * r6.xyz);
  r8.xyz = cb2[8].xyz + -r6.xyz;
  r6.xyz = cb2[4].xxx * r8.xyz + r6.xyz;
  r3.w = r6.w * v4.x + -r6.w;
  r8.w = cb2[19].x * r3.w + r6.w;
  r3.w = cb2[0].w + -cb2[0].z;
  r9.w = r7.y * r3.w + cb2[0].z;
  r3.w = saturate(cb2[3].w + -1);
  r4.w = cb2[4].y + -r7.x;
  r3.w = r3.w * r4.w + r7.x;
  r7.xyw = v3.yzx * v2.zxy;
  r7.xyw = v2.yzx * v3.zxy + -r7.xyw;
  r7.xyw = r7.xyw * r1.xxx;
  r5.xyw = r7.xyw * r5.www;
  r5.xyz = v3.xyz * r5.zzz + r5.xyw;
  r1.x = dot(r2.zw, r2.zw);
  r1.x = min(1, r1.x);
  r1.x = 1 + -r1.x;
  r1.x = sqrt(r1.x);
  r1.x = max(1.00000002e-16, r1.x);
  r2.z = cmp(0 < cb2[1].w);
  r2.z = r2.z ? -1 : 1;
  r2.z = v8.x ? 1 : r2.z;
  r1.x = r2.z * r1.x;
  r5.xyz = v2.xyz * r1.xxx + r5.xyz;
  r1.x = dot(r5.xyz, r5.xyz);
  r1.x = rsqrt(r1.x);
  r5.xyz = r5.xyz * r1.xxx;
  r1.x = max(9.99999994e-09, v5.z);
  r2.zw = v5.xy / r1.xx;
  r1.x = max(9.99999994e-09, v6.z);
  r7.xy = v6.xy / r1.xx;
  r10.xy = -r7.xy + r2.zw;
  r1.x = cb2[0].y * 0.0799999982;
  r7.xyw = -r6.xyz * r3.www + r6.xyz;
  r1.x = -r1.x * r3.w + r1.x;
  r6.xyz = r6.xyz * r3.www + r1.xxx;
  r1.x = dot(r5.xyz, r4.xyz);
  r11.xyzw = r9.wwww * float4(-1,-0.0274999999,-0.572000027,0.0219999999) + float4(1,0.0425000004,1.03999996,-0.0399999991);
  r2.z = r11.x * r11.x;
  r1.x = max(0, r1.x);
  r2.w = -9.27999973 * r1.x;
  r2.w = exp2(r2.w);
  r2.z = min(r2.z, r2.w);
  r2.z = r2.z * r11.x + r11.y;
  r2.zw = r2.zz * float2(-1.03999996,1.03999996) + r11.zw;
  r3.w = cmp(1.000000 == cb0[113].y);
  r11.xyzw = cb0[241].xyzw * r0.yyyy;
  r11.xyzw = cb0[240].xyzw * r0.xxxx + r11.xyzw;
  r11.xyzw = cb0[242].xyzw * r0.zzzz + r11.xyzw;
  r11.xyzw = cb0[243].xyzw + r11.xyzw;
  r4.w = 1 / r11.w;
  r11.xyz = float3(1,-1,1) * r11.xyz;
  r11.xyz = r11.xyz * r4.www;
  r11.xy = saturate(r11.xy * float2(0.5,0.5) + float2(0.5,0.5));
  r11.xy = cb0[82].xy * r11.xy;
  r12.xy = (uint2)r11.xy;
  r4.w = cb0[84].z * r11.z + cb0[84].w;
  r12.z = 1 / r4.w;
  r11.xy = (uint2)v0.xy;
  r4.w = cb0[1].z * r0.y;
  r4.w = cb0[0].z * r0.x + r4.w;
  r4.w = cb0[2].z * r0.z + r4.w;
  r4.w = cb0[3].z + r4.w;
  r11.z = abs(r4.w);
  r11.xyz = r3.www ? r12.xyz : r11.xyz;
  r12.xyz = r5.xyz * float3(0.25,0.25,0.25) + r0.xyz;
  r13.xyz = cb0[6].xzy * -cb0[212].www + cb0[210].xzy;
  r13.xyz = -r13.xyz + r12.xzy;
  r3.w = max(abs(r13.x), abs(r13.y));
  r3.w = -464 + r3.w;
  r3.w = saturate(0.03125 * r3.w);
  r4.w = -208 + abs(r13.z);
  r4.w = saturate(0.03125 * r4.w);
  r3.w = max(r4.w, r3.w);
  r4.w = cmp(0.000000 != cb0[210].w);
  r6.w = cmp(r3.w < 1);
  r4.w = r4.w ? r6.w : 0;
  if (r4.w != 0) {
    r13.xyz = cb0[6].xzy * -cb0[212].yyy + cb0[210].xzy;
    r13.xyz = -r13.xyz + r12.xzy;
    r4.w = max(abs(r13.x), abs(r13.y));
    r4.w = -29 + r4.w;
    r4.w = saturate(0.5 * r4.w);
    r6.w = -13 + abs(r13.z);
    r6.w = saturate(0.5 * r6.w);
    r4.w = max(r6.w, r4.w);
    r6.w = cmp(r4.w < 1);
    if (r6.w != 0) {
      r13.xyz = r12.xyz * float3(2,2,2) + float3(0.5,0.5,0.5);
      r14.xyz = cb0[211].xyz * r13.xyz;
      r14.xyz = floor(r14.xyz);
      r13.xyz = r13.xyz * cb0[211].xyz + -r14.xyz;
      r14.xyz = t11.SampleLevel(s1_s, r13.xyz, 0).xyz;
      r6.w = 1 + -r4.w;
      r10.w = cb0[211].y * 0.5;
      r12.w = -cb0[211].y * 0.5 + 1;
      r10.w = max(r13.y, r10.w);
      r10.w = min(r10.w, r12.w);
      r13.w = 0.333333343 * r10.w;
      r15.xyzw = t12.SampleLevel(s0_s, r13.xwz, 0).xyzw;
      r15.xyz = r15.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r16.xyz = r15.xyz * r14.xxx;
      r15.xyz = float3(0,0.333333343,0) + r13.xwz;
      r15.xyz = t12.SampleLevel(s0_s, r15.xyz, 0).xyz;
      r15.xyz = r15.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r17.xyz = r15.xyz * r14.yyy;
      r13.xyz = float3(0,0.666666687,0) + r13.xwz;
      r13.xyz = t12.SampleLevel(s0_s, r13.xyz, 0).xyz;
      r13.xyz = r13.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r13.xyz = r13.xyz * r14.zzz;
      r10.w = r15.w * r6.w + r3.w;
      r13.w = r14.z;
      r13.xyzw = r13.xyzw * r6.wwww;
      r17.w = r14.y;
      r15.xyzw = r17.xyzw * r6.wwww;
      r16.w = r14.x;
      r14.xyzw = r16.xyzw * r6.wwww;
    } else {
      r13.xyzw = float4(0,0,0,0);
      r15.xyzw = float4(0,0,0,0);
      r14.xyzw = float4(0,0,0,0);
      r10.w = r3.w;
    }
    r16.xyz = cb0[6].xzy * -cb0[212].zzz + cb0[210].xzy;
    r16.xyz = -r16.xyz + r12.xzy;
    r6.w = max(abs(r16.x), abs(r16.y));
    r6.w = -116 + r6.w;
    r6.w = saturate(0.125 * r6.w);
    r12.w = -52 + abs(r16.z);
    r12.w = saturate(0.125 * r12.w);
    r6.w = max(r12.w, r6.w);
    r12.w = cmp(r6.w < 1);
    if (r12.w != 0) {
      r16.xyz = r12.xyz * float3(0.5,0.5,0.5) + float3(0.5,0.5,0.5);
      r17.xyz = cb0[211].xyz * r16.xyz;
      r17.xyz = floor(r17.xyz);
      r16.xyz = r16.xyz * cb0[211].xyz + -r17.xyz;
      r17.xyz = t13.SampleLevel(s1_s, r16.xyz, 0).xyz;
      r12.w = 1 + -r6.w;
      r4.w = r12.w * r4.w;
      r12.w = cb0[211].y * 0.5;
      r17.w = -cb0[211].y * 0.5 + 1;
      r12.w = max(r16.y, r12.w);
      r12.w = min(r12.w, r17.w);
      r16.w = 0.333333343 * r12.w;
      r18.xyzw = t14.SampleLevel(s0_s, r16.xwz, 0).xyzw;
      r18.xyz = r18.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r19.xyz = r18.xyz * r17.xxx;
      r18.xyz = float3(0,0.333333343,0) + r16.xwz;
      r18.xyz = t14.SampleLevel(s0_s, r18.xyz, 0).xyz;
      r18.xyz = r18.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r20.xyz = r18.xyz * r17.yyy;
      r16.xyz = float3(0,0.666666687,0) + r16.xwz;
      r16.xyz = t14.SampleLevel(s0_s, r16.xyz, 0).xyz;
      r16.xyz = r16.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r16.xyz = r16.xyz * r17.zzz;
      r10.w = r18.w * r4.w + r10.w;
      r16.w = r17.z;
      r13.xyzw = r16.xyzw * r4.wwww + r13.xyzw;
      r20.w = r17.y;
      r15.xyzw = r20.xyzw * r4.wwww + r15.xyzw;
      r19.w = r17.x;
      r14.xyzw = r19.xyzw * r4.wwww + r14.xyzw;
    }
    r4.w = cmp(0 < r6.w);
    if (r4.w != 0) {
      r12.xyz = r12.xyz * float3(0.125,0.125,0.125) + float3(0.5,0.5,0.5);
      r16.xyz = cb0[211].xyz * r12.xyz;
      r17.xyz = cb0[211].xyz * float3(0.5,0.5,0.5);
      r16.xyz = floor(r16.xyz);
      r12.xyz = r12.xyz * cb0[211].xyz + -r16.xyz;
      r16.xyz = -cb0[211].xyz * float3(0.5,0.5,0.5) + float3(1,1,1);
      r12.xyz = max(r12.xyz, r17.xyz);
      r12.xyz = min(r12.xyz, r16.xyz);
      r18.xyw = t15.SampleLevel(s1_s, r12.xyz, 0).yzx;
      r4.w = 1 + -r3.w;
      r4.w = r6.w * r4.w;
      r6.w = max(r12.y, r17.y);
      r6.w = min(r6.w, r16.y);
      r12.w = 0.333333343 * r6.w;
      r16.xyzw = t16.SampleLevel(s0_s, r12.xwz, 0).xyzw;
      r17.xyz = float3(0,0.666666687,0) + r12.xwz;
      r17.xyz = t16.SampleLevel(s0_s, r17.xyz, 0).xyz;
      r17.xyz = r17.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r17.xyz = r17.xyz * r18.yyy;
      r17.w = r18.y;
      r13.xyzw = r17.xyzw * r4.wwww + r13.xyzw;
      r12.xyz = float3(0,0.333333343,0) + r12.xwz;
      r12.xyz = t16.SampleLevel(s0_s, r12.xyz, 0).xyz;
      r12.xyz = r12.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r12.xyz = r12.xyz * r18.xxx;
      r12.w = r18.x;
      r15.xyzw = r12.xyzw * r4.wwww + r15.xyzw;
      r12.xyz = r16.xyz * float3(4,4,4) + float3(-2,-2,-2);
      r18.xyz = r12.xyz * r18.www;
      r14.xyzw = r18.xyzw * r4.wwww + r14.xyzw;
      r10.w = r16.w * r4.w + r10.w;
    }
    r4.w = saturate(r10.w * 2 + -1);
    r12.x = r4.w + -r3.w;
    r3.w = r4.w + r3.w;
    r12.y = 0.5 * r3.w;
  } else {
    r13.xyzw = float4(0,0,0,0);
    r15.xyzw = float4(0,0,0,0);
    r14.xyzw = float4(0,0,0,0);
    r12.xy = float2(0,1);
  }
  r16.xyzw = cb0[213].xyzw * r12.yyyx;
  r16.y = r16.w * 0.5 + r16.y;
  r12.zw = cb0[213].wy * r12.yx;
  r16.w = r12.w * 0.375 + r12.z;
  r14.xyzw = r16.xyzw + r14.xyzw;
  r16.xyzw = cb0[214].xyzw * r12.yyyx;
  r16.y = r16.w * 0.5 + r16.y;
  r12.zw = cb0[214].wy * r12.yx;
  r16.w = r12.w * 0.375 + r12.z;
  r15.xyzw = r16.xyzw + r15.xyzw;
  r16.xyzw = cb0[215].xyzw * r12.yyyx;
  r16.y = r16.w * 0.5 + r16.y;
  r12.xy = cb0[215].wy * r12.yx;
  r16.w = r12.y * 0.375 + r12.x;
  r12.xyzw = r16.xyzw + r13.xyzw;
  r3.w = dot(r14.xyz, r5.xyz);
  r3.w = r3.w + r14.w;
  r13.x = max(0, r3.w);
  r3.w = dot(r15.xyz, r5.xyz);
  r3.w = r3.w + r15.w;
  r13.y = max(0, r3.w);
  r3.w = dot(r12.xyz, r5.xyz);
  r3.w = r3.w + r12.w;
  r13.z = max(0, r3.w);
  r3.w = dot(-r4.xyz, r5.xyz);
  r3.w = r3.w + r3.w;
  r12.xyz = r5.xyz * -r3.www + -r4.xyz;
  r3.w = cb0[113].x + -1;
  r4.w = max(0.00100000005, r9.w);
  r4.w = log2(r4.w);
  r4.w = -r4.w * 1.20000005 + 1;
  r3.w = -r4.w + r3.w;
  r14.xy = (uint2)r11.xy;
  r14.zw = cb3[0].ww * r14.xy;
  r14.zw = floor(r14.zw);
  r4.w = -cb3[2].y + r11.z;
  r4.w = floor(r4.w);
  r6.w = cb3[1].x + -1;
  r10.w = max(0, r4.w);
  r6.w = min(r10.w, r6.w);
  r4.w = cmp(r6.w >= r4.w);
  r10.w = r14.w * cb3[0].x + r14.z;
  r10.w = (int)r10.w;
  r10.w = (int)r10.w + asint(cb0[110].z);
  r10.w = t0[r10.w].val[0/4];
  r6.w = (int)r6.w;
  r6.w = (int)r6.w + asint(cb0[110].w);
  r6.w = t0[r6.w].val[0/4];
  r6.w = (int)r6.w & (int)r10.w;
  r4.w = r4.w ? r6.w : 0;
  r15.xyz = cb0[111].xxx * r13.xyz;
  r6.w = dot(r15.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.w = 1;
  r5.w = 1;
  r15.xyz = float3(0,0,0);
  r10.w = 1;
  r12.w = r4.w;
  r13.w = 0;
  while (true) {
    r14.z = cmp(0.00999999978 < r10.w);
    r14.w = cmp((int)r12.w != 0);
    r14.w = r14.z ? r14.w : 0;
    if (r14.w != 0) {
      r14.w = firstbitlow((uint)r12.w);
      r15.w = 1 << (int)r14.w;
      r12.w = (int)r12.w ^ (int)r15.w;
      r14.w = (uint)r14.w << 3;
      r16.x = dot(cb3[r14.w+6].xyzw, r0.xyzw);
      r16.y = dot(cb3[r14.w+7].xyzw, r0.xyzw);
      r16.z = dot(cb3[r14.w+8].xyzw, r0.xyzw);
      r17.xyz = cmp(cb3[r14.w+5].xyz >= abs(r16.xyz));
      r15.w = r17.y ? r17.x : 0;
      r15.w = r17.z ? r15.w : 0;
      if (r15.w != 0) {
        r15.w = cb3[r14.w+5].x * 0.100000001;
        r17.xyz = float3(0.100000001,0.100000001,0.100000001) * abs(r16.xyz);
        r17.xy = r17.xy * r17.xy;
        r18.xyz = cb3[r14.w+5].xyz + -abs(r16.xyz);
        r18.xyz = cb3[r14.w+9].xyz * r18.xyz;
        r16.w = cmp(1.000000 == cb3[r14.w+10].x);
        if (r16.w != 0) {
          r19.x = dot(cb3[r14.w+6].xyz, r12.xyz);
          r19.y = dot(cb3[r14.w+7].xyz, r12.xyz);
          r19.z = dot(cb3[r14.w+8].xyz, r12.xyz);
          r20.xyz = cb3[r14.w+5].xyz + -r16.xyz;
          r20.xyz = r20.xyz / r19.xyz;
          r21.xyz = -cb3[r14.w+5].xyz + -r16.xyz;
          r21.xyz = r21.xyz / r19.xyz;
          r22.xyz = cmp(float3(0,0,0) < r19.xyz);
          r20.xyz = r22.xyz ? r20.xyz : r21.xyz;
          r16.w = min(r20.x, r20.y);
          r16.w = min(r16.w, r20.z);
          r16.xyz = r19.xyz * r16.www + r16.xyz;
        } else {
          r16.xyz = r12.xyz;
        }
        r16.w = dot(r16.xyz, r16.xyz);
        r16.w = rsqrt(r16.w);
        r16.xyz = r16.xyz * r16.www;
        r19.xyz = cmp(float3(0,0,0) < r16.xyz);
        r20.xyz = cmp(r16.xyz < float3(0,0,0));
        r19.xyz = (int3)-r19.xyz + (int3)r20.xyz;
        r19.xyz = (int3)r19.xyz;
        r16.w = dot(r16.xyz, r19.xyz);
        r16.xyz = r16.xyz / r16.www;
        r16.z = cmp(r16.z < 0);
        r19.zw = float2(1,1) + -abs(r16.yx);
        r19.xy = r19.xy * r19.zw;
        r16.xy = r16.zz ? r19.xy : r16.xy;
        r16.z = dot(cb3[r14.w+4].xyzw, r5.xyzw);
        r16.z = max(0, r16.z);
        r16.z = max(9.99999975e-05, r16.z);
        r16.w = min(r18.y, r18.z);
        r16.w = min(r18.x, r16.w);
        r17.x = r17.x + r17.y;
        r17.x = r17.z * r17.z + r17.x;
        r15.w = r15.w * r15.w + -r17.x;
        r15.w = cb3[r14.w+9].x * r15.w;
        r15.w = cb3[r14.w+9].x * r15.w;
        r17.x = -cb3[r14.w+10].y + 1;
        r15.w = r17.x * r15.w;
        r15.w = 100 * r15.w;
        r15.w = saturate(r16.w * cb3[r14.w+10].y + r15.w);
        r16.w = cb3[r14.w+10].w * r15.w;
        r16.xy = r16.xy * float2(0.5,0.5) + float2(0.5,0.5);
        r17.xy = r16.xy * cb3[1].ww + cb3[2].ww;
        r17.z = cb3[r14.w+5].w;
        r17.xyz = t1.SampleLevel(s2_s, r17.xyz, r3.w).xyz;
        r17.xyz = cb3[r14.w+9].www * r17.xyz;
        r16.x = r6.w / r16.z;
        r16.x = min(1, abs(r16.x));
        r16.x = r16.x * 2 + r6.w;
        r16.y = 2 + r16.z;
        r16.x = r16.x / r16.y;
        r16.x = -1 + r16.x;
        r16.x = r16.x * cb0[112].w + 1;
        r16.xyz = r17.xyz * r16.xxx;
        r16.xyz = r16.xyz * r16.www;
        r15.xyz = r16.xyz * r10.www + r15.xyz;
        r14.w = -r15.w * cb3[r14.w+10].w + 1;
        r10.w = r14.w * r10.w;
      }
      r13.w = -1;
      continue;
    } else {
      r13.w = r14.z;
      break;
    }
    r13.w = r14.z;
  }
  if (r13.w != 0) {
    r0.w = dot(r12.xyz, r12.xyz);
    r0.w = rsqrt(r0.w);
    r16.xyz = r12.xyz * r0.www;
    r17.xyz = cmp(float3(0,0,0) < r16.xyz);
    r18.xyz = cmp(r16.xyz < float3(0,0,0));
    r17.xyz = (int3)-r17.xyz + (int3)r18.xyz;
    r17.xyz = (int3)r17.xyz;
    r0.w = dot(r16.xyz, r17.xyz);
    r16.xyz = r16.xyz / r0.www;
    r0.w = cmp(r16.z < 0);
    r14.zw = float2(1,1) + -abs(r16.yx);
    r14.zw = r17.xy * r14.zw;
    r14.zw = r0.ww ? r14.zw : r16.xy;
    r5.w = 1;
    r0.w = dot(cb3[3].xyzw, r5.xyzw);
    r0.w = max(0, r0.w);
    r0.w = max(9.99999975e-05, r0.w);
    r14.zw = r14.zw * float2(0.5,0.5) + float2(0.5,0.5);
    r16.xy = r14.zw * cb3[1].ww + cb3[2].ww;
    r16.z = 0;
    r16.xyz = t1.SampleLevel(s2_s, r16.xyz, r3.w).xyz;
    r3.w = r6.w / r0.w;
    r3.w = min(1, abs(r3.w));
    r3.w = r3.w * 2 + r6.w;
    r0.w = 2 + r0.w;
    r0.w = r3.w / r0.w;
    r0.w = -1 + r0.w;
    r0.w = r0.w * cb0[112].w + 1;
    r16.xyz = r16.xyz * r0.www;
    r15.xyz = r16.xyz * r10.www + r15.xyz;
  }
  r13.xyz = r13.xyz * r7.xyw;
  r0.w = -1 + r7.z;
  r0.w = cb2[1].x * r0.w + 1;
  r13.xyz = r13.xyz * r0.www;
  
  // Reduce reflection probe intensity for glass
  if (GLASS_TRANSPARENCY > 0.5f) {
    r15.xyz *= 0.4f;
  }
  
  r15.xyz = cb0[112].zzz * r15.xyz;
  r15.xyz = cb0[111].yyy * r15.xyz;
  r0.w = saturate(50 * r6.y);
  r0.w = r0.w * r2.w;
  r16.xyz = r6.xyz * r2.zzz + r0.www;
  r15.xyz = r16.xyz * r15.xyz;
  r13.xyz = r13.xyz * cb0[111].xxx + r15.xyz;
  r0.w = cmp(cb6[35].w < 0.99000001);
  if (r0.w != 0) {
    r0.w = (int)cb6[35].x;
    r2.z = cmp((int)r0.w == 2);
    r15.xyz = r2.zzz ? cb6[20].xyz : cb0[44].xyz;
    r15.xyz = -r15.xyz + r0.xyz;
    r2.z = dot(r15.xyz, r15.xyz);
    r2.z = cb6[34].w + -r2.z;
    r2.z = saturate(cb6[34].z * r2.z);
    r2.w = cmp(0 < r2.z);
    if (r2.w != 0) {
      r0.w = cmp(0 < (int)r0.w);
      if (r0.w != 0) {
        r15.xyz = -cb6[20].xyz + r0.xyz;
        r16.xyz = -cb6[21].xyz + r0.xyz;
        r17.xyz = -cb6[22].xyz + r0.xyz;
        r18.xyz = -cb6[23].xyz + r0.xyz;
        r15.x = dot(r15.xyz, r15.xyz);
        r15.y = dot(r16.xyz, r16.xyz);
        r15.z = dot(r17.xyz, r17.xyz);
        r15.w = dot(r18.xyz, r18.xyz);
        r16.x = cmp(r15.x < cb6[20].w);
        r16.y = cmp(r15.y < cb6[21].w);
        r16.z = cmp(r15.z < cb6[22].w);
        r16.w = cmp(r15.w < cb6[23].w);
        r17.xyzw = r16.xyzw ? float4(1,1,1,1) : 0;
        r16.xyz = r16.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
        r16.xyz = r17.yzw + r16.xyz;
        r17.yzw = max(float3(0,0,0), r16.xyz);
        r0.w = dot(r17.xyzw, float4(4,3,2,1));
        r0.w = 4 + -r0.w;
        r0.w = max(0, r0.w);
        r0.w = min(3, r0.w);
        r2.w = 1 + r0.w;
        r2.w = min(3, r2.w);
        r2.w = (uint)r2.w;
        r3.w = dot(r15.yzw, icb[r2.w+0].yzw);
        r2.w = r3.w / cb6[r2.w+20].w;
        r3.w = cmp(r2.w >= 0);
        r2.w = cmp(1 >= r2.w);
        r2.w = r2.w ? r3.w : 0;
        if (r2.w != 0) {
          r2.w = (uint)r0.w;
          r14.zw = float2(2.08299994,4.8670001) + r14.xy;
          r3.w = dot(r14.zw, float2(0.0671105608,0.00583714992));
          r3.w = frac(r3.w);
          r3.w = 52.9829178 * r3.w;
          r3.w = frac(r3.w);
          r4.w = dot(r15.xyzw, icb[r2.w+0].xyzw);
          r2.w = r4.w / cb6[r2.w+20].w;
          r2.w = sqrt(r2.w);
          r2.w = -0.899999976 + r2.w;
          r2.w = 12 * r2.w;
          r2.w = cmp(r2.w >= r3.w);
          r2.w = r2.w ? 1.000000 : 0;
          r0.w = r2.w + r0.w;
        }
        r2.w = dot(r5.xyz, cb5[0].xyz);
        r2.w = max(0, r2.w);
        r2.w = min(0.899999976, r2.w);
        r2.w = 1 + -r2.w;
        r3.w = (uint)r0.w;
        r4.w = (uint)r3.w << 2;
        r14.zw = cb6[r3.w+24].xy * r2.ww;
        r2.w = max(0, r14.z);
        r15.xyz = -cb5[0].xyz * r2.www + r0.xyz;
        r15.xyz = r5.xyz * r14.www + r15.xyz;
        r16.xyz = cb6[r4.w+1].xyz * r15.yyy;
        r15.xyw = cb6[r4.w+0].xyz * r15.xxx + r16.xyz;
        r15.xyz = cb6[r4.w+2].xyz * r15.zzz + r15.xyw;
        r15.xyz = cb6[r4.w+3].xyz + r15.xyz;
        r16.xyz = cmp(float3(0,0,0) >= r15.xyz);
        r17.xyz = cmp(r15.xyz >= float3(1,1,1));
        r16.xyz = (int3)r16.xyz | (int3)r17.xyz;
        r2.w = (int)r16.y | (int)r16.x;
        r2.w = (int)r16.z | (int)r2.w;
        r3.w = (int)r15.z & 0x7fffffff;
        r3.w = cmp(0x7f800000 < (uint)r3.w);
        r16.z = (int)r2.w | (int)r3.w;
        r0.w = (int)r0.w;
        r14.zw = r15.xy * cb6[r0.w+28].zw + cb6[r0.w+28].xy;
        r15.xy = r14.zw * cb6[32].zw + float2(0.5,0.5);
        r15.xy = floor(r15.xy);
        r14.zw = r14.zw * cb6[32].zw + -r15.xy;
        r17.xyzw = float4(0.5,1,0.5,1) + r14.zzww;
        r18.xw = r17.xz * r17.xz;
        r17.xz = min(float2(0,0), r14.zw);
        r19.xy = max(float2(0,0), r14.zw);
        r19.zw = r18.xw * float2(0.5,0.5) + -r14.zw;
        r14.zw = float2(1,1) + -r14.zw;
        r14.zw = -r17.xz * r17.xz + r14.zw;
        r17.xy = -r19.xy * r19.xy + r17.yw;
        r20.x = r19.z;
        r20.y = r14.z;
        r20.z = r17.x;
        r20.w = r18.x;
        r20.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r20.xyzw;
        r18.x = r19.w;
        r18.y = r14.w;
        r18.z = r17.y;
        r17.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r18.xyzw;
        r18.xyzw = r20.xzxz + r20.ywyw;
        r19.xyzw = r17.xxzz + r17.yyww;
        r14.zw = r20.yw / r18.zw;
        r14.zw = float2(-1.5,0.5) + r14.zw;
        r20.xy = cb6[32].xx * r14.zw;
        r14.zw = r17.yw / r19.yw;
        r14.zw = float2(-1.5,0.5) + r14.zw;
        r20.zw = cb6[32].yy * r14.zw;
        r17.xyzw = r19.xyzw * r18.xyzw;
        r18.xyzw = r15.xyxy * cb6[32].xyxy + r20.xzyz;
        r0.w = t5.SampleCmpLevelZero(s3_s, r18.xy, r15.z).x;
        r2.w = t5.SampleCmpLevelZero(s3_s, r18.zw, r15.z).x;
        r2.w = r17.y * r2.w;
        r0.w = r17.x * r0.w + r2.w;
        r18.xyzw = r15.xyxy * cb6[32].xyxy + r20.xwyw;
        r2.w = t5.SampleCmpLevelZero(s3_s, r18.xy, r15.z).x;
        r0.w = r17.z * r2.w + r0.w;
        r2.w = t5.SampleCmpLevelZero(s3_s, r18.zw, r15.z).x;
        r0.w = r17.w * r2.w + r0.w;
        r16.x = r16.z ? 1 : r0.w;
      } else {
        r16.xz = float2(1,0);
      }
    } else {
      r16.xz = float2(1,0);
    }
    r0.w = cmp(r2.z < 1);
    if (r0.w != 0) {
      r0.w = dot(r5.xyz, cb5[0].xyz);
      r0.w = max(0, r0.w);
      r0.w = min(0.899999976, r0.w);
      r0.w = 1 + -r0.w;
      r14.zw = cb6[584].xy * r0.ww;
      r15.xyz = -cb5[0].xyz * r14.zzz + r0.xyz;
      r15.xyz = r5.xyz * r14.www + r15.xyz;
      r14.zw = cb6[581].xy * r15.yy;
      r14.zw = cb6[580].xy * r15.xx + r14.zw;
      r14.zw = cb6[582].xy * r15.zz + r14.zw;
      r14.zw = cb6[583].xy + r14.zw;
      r17.xy = cmp(float2(0,0) < r14.zw);
      r0.w = r17.y ? r17.x : 0;
      r17.xy = cmp(r14.zw < float2(1,1));
      r2.w = r17.y ? r17.x : 0;
      r0.w = (int)r0.w & (int)r2.w;
      if (r0.w != 0) {
        r0.w = cb6[585].z * r14.w;
        r0.w = floor(r0.w);
        r0.w = r0.w + r14.z;
        r0.w = cb6[585].y * r0.w;
        r0.w = (uint)r0.w;
        r0.w = min(127, (uint)r0.w);
        r2.w = 0x0000ffff & asint(cb6[r0.w+587].x);
        r17.x = f16tof32(r2.w);
        r2.w = cmp(r17.x >= 0);
        if (r2.w != 0) {
          r18.x = cb6[576].x;
          r18.y = cb6[577].x;
          r18.z = cb6[578].x;
          r18.w = cb6[r0.w+587].y;
          r15.w = 1;
          r18.x = dot(r18.xyzw, r15.xyzw);
          r19.x = cb6[576].y;
          r19.y = cb6[577].y;
          r19.z = cb6[578].y;
          r19.w = cb6[r0.w+587].z;
          r18.y = dot(r19.xyzw, r15.xyzw);
          r19.x = cb6[576].z;
          r19.y = cb6[577].z;
          r19.z = cb6[578].z;
          r19.w = cb6[r0.w+587].w;
          r2.w = dot(r19.xyzw, r15.xyzw);
          r14.zw = cmp(float2(0,0) < r18.xy);
          r3.w = cmp(0 < r2.w);
          r4.w = r14.w ? r14.z : 0;
          r3.w = r3.w ? r4.w : 0;
          r14.zw = cmp(r18.xy < float2(1,1));
          r4.w = cmp(r2.w < 1);
          r5.w = r14.w ? r14.z : 0;
          r4.w = r4.w ? r5.w : 0;
          r3.w = r3.w ? r4.w : 0;
          if (r3.w != 0) {
            r0.w = asuint(cb6[r0.w+587].x) >> 16;
            r17.y = f16tof32(r0.w);
            r14.zw = r18.xy * cb6[584].zw + r17.xy;
            r15.xy = r14.zw * cb6[586].zw + float2(0.5,0.5);
            r15.xy = floor(r15.xy);
            r14.zw = r14.zw * cb6[586].zw + -r15.xy;
            r17.xyzw = float4(0.5,1,0.5,1) + r14.zzww;
            r18.xw = r17.xz * r17.xz;
            r15.zw = min(float2(0,0), r14.zw);
            r17.xz = max(float2(0,0), r14.zw);
            r19.xy = r18.xw * float2(0.5,0.5) + -r14.zw;
            r14.zw = float2(1,1) + -r14.zw;
            r14.zw = -r15.zw * r15.zw + r14.zw;
            r15.zw = -r17.xz * r17.xz + r17.yw;
            r17.x = r19.x;
            r17.y = r14.z;
            r17.z = r15.z;
            r17.w = r18.x;
            r17.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r17.xyzw;
            r18.x = r19.y;
            r18.y = r14.w;
            r18.z = r15.w;
            r18.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r18.xyzw;
            r19.xyzw = r17.xzxz + r17.ywyw;
            r20.xyzw = r18.xxzz + r18.yyww;
            r14.zw = r17.yw / r19.zw;
            r14.zw = float2(-1.5,0.5) + r14.zw;
            r17.xy = cb6[586].xx * r14.zw;
            r14.zw = r18.yw / r20.yw;
            r14.zw = float2(-1.5,0.5) + r14.zw;
            r17.zw = cb6[586].yy * r14.zw;
            r18.xyzw = r20.xyzw * r19.xyzw;
            r19.xyzw = r15.xyxy * cb6[586].xyxy + r17.xzyz;
            r0.w = t8.SampleCmpLevelZero(s3_s, r19.xy, r2.w).x;
            r3.w = t8.SampleCmpLevelZero(s3_s, r19.zw, r2.w).x;
            r3.w = r18.y * r3.w;
            r0.w = r18.x * r0.w + r3.w;
            r15.xyzw = r15.xyxy * cb6[586].xyxy + r17.xwyw;
            r3.w = t8.SampleCmpLevelZero(s3_s, r15.xy, r2.w).x;
            r0.w = r18.z * r3.w + r0.w;
            r2.w = t8.SampleCmpLevelZero(s3_s, r15.zw, r2.w).x;
            r16.y = r18.w * r2.w + r0.w;
          } else {
            r16.y = 1;
          }
        } else {
          r16.y = 1;
        }
      } else {
        r16.y = 1;
      }
      r16.x = r16.z ? r16.y : r16.x;
    } else {
      r16.y = 1;
    }
    r0.w = r16.x + -r16.y;
    r0.w = r2.z * r0.w + r16.y;
    r2.z = cmp(0.00100000005 < r0.w);
    if (r2.z != 0) {
      r15.xyz = -cb0[173].xyz + r0.xyz;
      r2.zw = cb0[176].xz * r15.yy + r15.xz;
      r14.zw = cb0[174].zz * r2.zw;
      r15.yw = cb0[183].ww * cb0[175].xy;
      r2.zw = r2.zw * cb0[174].zz + r15.yw;
      r2.z = t7.SampleLevel(s1_s, r2.zw, 0).x;
      r14.zw = r14.zw * cb0[175].ww + r15.yw;
      r2.w = t7.SampleLevel(s1_s, r14.zw, 0).x;
      r3.w = dot(r15.xz, r15.xz);
      r3.w = sqrt(r3.w);
      r4.w = cb0[174].y + -cb0[174].x;
      r3.w = -cb0[174].x + r3.w;
      r4.w = 1 / r4.w;
      r3.w = saturate(r4.w * r3.w);
      r4.w = r3.w * -2 + 3;
      r3.w = r3.w * r3.w;
      r3.w = r4.w * r3.w;
      r2.w = r2.w + -r2.z;
      r2.z = r3.w * r2.w + r2.z;
      r2.z = -1 + r2.z;
      r2.z = cb0[175].z * r2.z + 1;
      r0.w = r2.z * r0.w;
    }
    r2.z = cb6[35].z + -r0.w;
    r0.w = cb6[35].w * r2.z + r0.w;
  } else {
    r0.w = cb6[35].z;
  }
  r0.w = min(1, r0.w);
  r0.w = -1 + r0.w;
  r15.x = cb6[34].x * r0.w + 1;
  r0.w = cmp(0.00100000005 < r15.x);
  if (r0.w != 0) {
    r0.w = dot(-cb5[0].xyz, r12.xyz);
    r16.xyz = cb5[0].xyz * r0.www + r12.xyz;
    r0.w = cmp(r0.w < cb5[4].z);
    r2.z = dot(r16.xyz, r16.xyz);
    r2.z = max(6.10351562e-05, r2.z);
    r2.z = rsqrt(r2.z);
    r16.xyz = r16.xyz * r2.zzz;
    r16.xyz = cb5[4].yyy * r16.xyz;
    r16.xyz = -cb5[0].xyz * cb5[4].zzz + r16.xyz;
    r2.z = dot(r16.xyz, r16.xyz);
    r2.z = rsqrt(r2.z);
    r16.xyz = r16.xyz * r2.zzz;
    r16.xyz = r0.www ? r16.xyz : r12.xyz;
    r17.xyz = r1.yzw * r2.yyy + r16.xyz;
    r0.w = dot(r17.xyz, r17.xyz);
    r0.w = max(6.10351562e-05, r0.w);
    r0.w = rsqrt(r0.w);
    r17.xyz = r17.xyz * r0.www;
    r9.y = saturate(dot(r16.xyz, r5.xyz));
    r0.w = saturate(dot(r5.xyz, r17.xyz));
    r9.z = min(1, r1.x);
    r2.z = r9.w * r9.w;
    r2.z = r2.z * r2.z;
    r2.w = r0.w * r2.z + -r0.w;
    r0.w = r2.w * r0.w + 1;
    r2.w = saturate(dot(r4.xyz, r17.xyz));
    r2.w = 1 + -r2.w;
    r3.w = r2.w * r2.w;
    r3.w = r3.w * r3.w;
    r4.w = r3.w * r2.w;
    r5.w = 1 + -r9.w;
    r6.w = -r5.w * 0.383026004 + -0.0761947036;
    r6.w = r5.w * r6.w + 1.04997003;
    r5.w = r5.w * r6.w + 0.409254998;
    r5.w = min(0.999000013, r5.w);
    r6.w = 1 + -r5.w;
    r16.xyz = float3(1,1,1) + -r6.xyz;
    r16.xyz = r16.xyz * float3(0.0476190485,0.0476190485,0.0476190485) + r6.xyz;
    r2.w = -r3.w * r2.w + 1;
    r17.xyz = r6.xyz * r2.www + r4.www;
    r0.w = r0.w * r0.w;
    r0.w = r2.z / r0.w;
    r14.zw = -r9.zy * r2.zz + r9.zy;
    r2.zw = r14.zw * r9.zy + r2.zz;
    r2.zw = sqrt(r2.zw);
    r2.zw = r9.yz * r2.zw;
    r2.z = r2.z + r2.w;
    r2.z = 9.99999975e-05 + r2.z;
    r2.z = 0.5 / r2.z;
    r0.w = r2.z * r0.w;
    r17.xyz = r17.xyz * r0.www;
    r17.xyz = min(float3(2048,2048,2048), r17.xyz);
    r18.xyzw = r9.zwyw * float4(0.96875,0.96875,0.96875,0.96875) + float4(0.015625,0.015625,0.015625,0.015625);
    r0.w = t10.SampleLevel(s0_s, r18.xy, 0).x;
    r2.z = t10.SampleLevel(s0_s, r18.zw, 0).x;
    r0.w = r2.z * r0.w;
    r0.w = r0.w * r5.w;
    r0.w = r0.w / r6.w;
    r18.xyz = r16.xyz * r16.xyz;
    r18.xyz = r18.xyz * r0.www;
    r16.xyz = -r16.xyz * r6.www + float3(1,1,1);
    r16.xyz = r18.xyz / r16.xyz;
    r16.xyz = r17.xyz + r16.xyz;
    r16.xyz = cb5[4].xxx * r16.xyz;
    r16.xyz = max(float3(0,0,0), r16.xyz);
    r16.xyz = min(float3(1000,1000,1000), r16.xyz);
    
    // Reduce sun specular intensity on glass
    if (GLASS_TRANSPARENCY > 0.5f) {
      r16.xyz *= 0.5f;
    }
    
    r17.xyz = r9.yyy * r7.xyw;
    r16.xyz = r16.xyz * r9.yyy + r17.xyz;
    r16.xyz = cb5[1].xyz * r16.xyz;
    r15.y = 0.5;
    r15.yzw = t9.SampleBias(s0_s, r15.xy, cb0[108].x).xyz;
    r0.w = 1 + -r15.x;
    r15.xyz = r16.xyz * r15.yzw + -r16.xyz;
    r15.xyz = r0.www * r15.xyz + r16.xyz;
  } else {
    r15.xyz = float3(0,0,0);
  }
  r2.zw = float2(0.03125,0.03125) * r14.xy;
  r2.zw = floor(r2.zw);
  r0.w = r2.w * cb4[1].y + r2.z;
  r0.w = 8 * r0.w;
  r0.w = (int)r0.w;
  r2.z = -cb0[85].y * cb4[2].w + r11.z;
  r2.z = floor(r2.z);
  r2.w = cb4[1].w + -1;
  r3.w = max(0, r2.z);
  r2.w = min(r3.w, r2.w);
  r3.w = 8 * r2.w;
  r3.w = (int)r3.w;
  r2.z = cmp(r2.w >= r2.z);
  r2.w = (int)r3.w + asint(cb0[110].y);
  r3.w = r9.w * r9.w;
  r9.x = min(1, r1.x);
  r1.x = 1 + -r9.w;
  r4.w = -r1.x * 0.383026004 + -0.0761947036;
  r4.w = r1.x * r4.w + 1.04997003;
  r1.x = r1.x * r4.w + 0.409254998;
  r1.x = min(0.999000013, r1.x);
  r4.w = 1 + -r1.x;
  r16.xyz = float3(1,1,1) + -r6.xyz;
  r16.xyz = r16.xyz * float3(0.0476190485,0.0476190485,0.0476190485) + r6.xyz;
  r9.yz = r9.xw * float2(0.96875,0.96875) + float2(0.015625,0.015625);
  r5.w = t10.SampleLevel(s0_s, r9.yz, 0).x;
  r17.xyz = -r16.xyz * r4.www + float3(1,1,1);
  r16.xyz = r16.xyz * r16.xyz;
  r18.w = 1;
  r19.y = 1;
  r20.z = r9.w;
  r21.xyz = float3(0,0,0);
  r6.w = 1;
  r7.z = 0;
  while (true) {
    r9.y = cmp(7 < (int)r7.z);
    if (r9.y != 0) break;
    r9.y = (int)r0.w + (int)r7.z;
    r9.y = t0[r9.y].val[0/4];
    r9.z = (int)r2.w + (int)r7.z;
    r9.z = t0[r9.z].val[0/4];
    r9.y = (int)r9.z & (int)r9.y;
    r9.y = r2.z ? r9.y : 0;
    r9.z = (uint)r7.z << 5;
    r22.xyz = float3(0,0,0);
    r10.w = r6.w;
    r12.w = r9.y;
    while (true) {
      if (r12.w == 0) break;
      r13.w = firstbitlow((uint)r12.w);
      r14.z = 1 << (int)r13.w;
      r14.z = (int)r12.w ^ (int)r14.z;
      r13.w = (int)r9.z + (int)r13.w;
      bitmask.x = ((~(-1 << 29)) << 3) & 0xffffffff;  r23.x = (((uint)r13.w << 3) & bitmask.x) | ((uint)1 & ~bitmask.x);
      bitmask.y = ((~(-1 << 29)) << 3) & 0xffffffff;  r23.y = (((uint)r13.w << 3) & bitmask.y) | ((uint)3 & ~bitmask.y);
      bitmask.z = ((~(-1 << 29)) << 3) & 0xffffffff;  r23.z = (((uint)r13.w << 3) & bitmask.z) | ((uint)5 & ~bitmask.z);
      bitmask.w = ((~(-1 << 29)) << 3) & 0xffffffff;  r23.w = (((uint)r13.w << 3) & bitmask.w) | ((uint)6 & ~bitmask.w);
      bitmask.w = ((~(-1 << 29)) << 3) & 0xffffffff;  r14.w = (((uint)r13.w << 3) & bitmask.w) | ((uint)7 & ~bitmask.w);
      r15.w = (uint)cb5[r23.z+6].w;
      r15.w = cmp((int)r15.w == 1);
      if (r15.w != 0) {
        r18.xyz = -cb5[r23.x+6].xyz + r0.xyz;
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
        r15.w = dot(r18.xyzw, r28.xyzw);
        r26.x = r24.y;
        r26.z = r25.y;
        r26.w = r27.x;
        r16.w = dot(r18.xyzw, r26.xyzw);
        r27.xz = r25.xz;
        r17.w = dot(r18.xyzw, r27.xyzw);
        r15.w = max(abs(r16.w), abs(r15.w));
        r15.w = max(r15.w, abs(r17.w));
        r16.w = cb5[r14.w+6].x * 0.5 + 0.5;
        r15.w = -r16.w + r15.w;
        r16.w = -cb5[r14.w+6].x * 0.5 + 0.5;
        r15.w = saturate(r15.w / r16.w);
        r15.w = 1 + -r15.w;
        r15.w = r15.w * r15.w;
      } else {
        r15.w = 1;
      }
      r16.w = cmp(0.5 < cb5[r23.y+6].z);
      r17.w = cmp(r15.w < 0.00100000005);
      r17.w = (int)r16.w | (int)r17.w;
      if (r17.w != 0) {
        r12.w = r14.z;
        continue;
      }
      r17.w = (uint)r13.w << 3;
      bitmask.w = ((~(-1 << 29)) << 3) & 0xffffffff;  r13.w = (((uint)r13.w << 3) & bitmask.w) | ((uint)2 & ~bitmask.w);
      r18.x = cmp(cb5[r17.w+6].w < 1.5);
      if (r18.x != 0) {
        r18.x = cb5[r13.w+6].y * 0.5 + 0.5;
        r18.x = -abs(cb5[r13.w+6].x) + r18.x;
        r18.y = cb5[r13.w+6].y + -r18.x;
        r19.z = 1 + -abs(r18.x);
        r19.z = r19.z + -abs(r18.y);
        r19.z = max(0.00048828125, r19.z);
        r19.w = cmp(cb5[r13.w+6].x >= 0);
        r18.z = r19.w ? r19.z : -r19.z;
        r19.z = dot(r18.xyz, r18.xyz);
        r19.z = rsqrt(r19.z);
        r18.xyz = r19.zzz * r18.xyz;
        r24.xyz = cb5[r23.x+6].xyz + -r0.xyz;
        r19.z = dot(r24.xyz, r24.xyz);
        r19.w = rsqrt(r19.z);
        r25.xyz = r24.xyz * r19.www;
        r20.w = (int)cb5[r14.w+6].w;
        r26.xyz = cb5[r13.w+6].zzz * r18.xyz;
        r27.xyz = -r26.xyz * float3(0.5,0.5,0.5) + r24.xyz;
        r28.xyz = r26.xyz * float3(0.5,0.5,0.5) + r24.xyz;
        r21.w = (uint)cb5[r17.w+6].w;
        r21.w = (int)r21.w & 1;
        r22.w = cmp((int)r21.w == 0);
        r22.w = ~(int)r22.w;
        r23.z = cmp(0 < cb5[r13.w+6].z);
        r22.w = r22.w ? r23.z : 0;
        r23.z = dot(r27.xyz, r27.xyz);
        r23.z = sqrt(r23.z);
        r24.w = dot(r28.xyz, r28.xyz);
        r24.w = sqrt(r24.w);
        r25.w = dot(r5.xyz, r27.xyz);
        r25.w = r25.w / r23.z;
        r26.w = dot(r5.xyz, r28.xyz);
        r26.w = r26.w / r24.w;
        r25.w = r26.w + r25.w;
        r29.x = saturate(0.5 * r25.w);
        r25.w = dot(r27.xyz, r28.xyz);
        r23.z = r23.z * r24.w + r25.w;
        r23.z = r23.z * 0.5 + 1;
        r29.y = 1 / r23.z;
        r19.x = saturate(dot(r5.xyz, r25.xyz));
        r20.xy = r22.ww ? r29.xy : r19.xy;
        r19.x = cmp(cb5[r23.w+6].w < 0);
        if (r19.x != 0) {
          r19.x = cb5[r23.x+6].w * cb5[r23.x+6].w;
          r19.x = r19.z * r19.x;
          r19.x = -r19.x * r19.x + 1;
          r19.x = max(0, r19.x);
          r19.z = 1 + r19.z;
          r19.z = 1 / r19.z;
          r23.z = r22.w ? 1.000000 : 0;
          r24.w = r20.y + -r19.z;
          r19.z = r23.z * r24.w + r19.z;
          r19.x = r19.x * r19.x;
          r19.x = r19.z * r19.x;
        } else {
          r28.xyz = cb5[r23.x+6].www * r24.xyz;
          r19.z = dot(r28.xyz, r28.xyz);
          r19.z = min(1, r19.z);
          r19.z = 1 + -r19.z;
          r19.z = log2(r19.z);
          r19.z = cb5[r23.w+6].w * r19.z;
          r19.z = exp2(r19.z);
          r19.x = r20.y * r19.z;
        }
        r18.x = dot(r25.xyz, -r18.xyz);
        r18.x = -cb5[r13.w+6].z + r18.x;
        r18.x = saturate(cb5[r13.w+6].w * r18.x);
        r18.x = r18.x * r18.x;
        r18.x = r21.w ? 1 : r18.x;
        r18.x = r19.x * r18.x;
        r18.y = ~(int)r22.w;
        r18.z = cmp((int)r20.w >= 0);
        r18.y = r18.z ? r18.y : 0;
        if (r18.y != 0) {
          if (r21.w == 0) {
            r18.y = (uint)r20.w << 2;
            r28.xyz = cb7[r18.y+33].xyw * r0.yyy;
            r28.xyz = cb7[r18.y+32].xyw * r0.xxx + r28.xyz;
            r28.xyz = cb7[r18.y+34].xyw * r0.zzz + r28.xyz;
            r28.xyz = cb7[r18.y+35].xyw + r28.xyz;
            r18.yz = saturate(r28.xy / r28.zz);
            r18.yz = r18.yz * cb7[r20.w+0].zw + cb7[r20.w+0].xy;
          } else {
            r19.x = (uint)r20.w << 2;
            r28.x = dot(-r24.xyz, cb7[r19.x+32].xyz);
            r28.y = dot(-r24.xyz, cb7[r19.x+33].xyz);
            r28.z = dot(-r24.xyz, cb7[r19.x+34].xyz);
            r19.x = cmp(abs(r28.x) < abs(r28.y));
            r19.x = r19.x ? 0.000000 : 0;
            r19.z = dot(abs(r28.xy), icb[r19.x+0].xy);
            r19.z = cmp(r19.z < abs(r28.z));
            r19.x = r19.z ? 2 : r19.x;
            r19.z = dot(r28.xyz, icb[r19.x+0].xyz);
            r19.z = cmp(r19.z < 0);
            bitmask.x = ((~(-1 << 31)) << 1) & 0xffffffff;  r19.x = (((uint)r19.x << 1) & bitmask.x) | ((uint)r19.z & ~bitmask.x);
            r19.z = (uint)r19.x >> 1;
            r19.z = dot(r28.xyz, icb[r19.z+0].xyz);
            r20.y = 0.000244140625 / cb7[r20.w+0].w;
            r20.y = 0.5 + -r20.y;
            r23.z = (uint)r19.x;
            r24.x = cmp((uint)r19.x < 2);
            r24.x = r24.x ? 0.000000 : 0;
            r24.x = dot(r28.xz, icb[r24.x+0].xz);
            r24.x = icb[r19.x+4].z * r24.x;
            r24.x = r24.x / abs(r19.z);
            r23.z = r24.x * r20.y + r23.z;
            r23.z = 0.5 + r23.z;
            r24.x = saturate(0.166666672 * r23.z);
            r23.z = -1 + (int)icb[r19.x+4].y;
            r23.z = dot(r28.yz, icb[r23.z+0].xy);
            r19.x = icb[r19.x+4].w * r23.z;
            r19.x = r19.x / abs(r19.z);
            r24.y = saturate(-r19.x * r20.y + 0.5);
            r18.yz = r24.xy * cb7[r20.w+0].zw + cb7[r20.w+0].xy;
          }
          r18.y = t18.SampleLevel(s0_s, r18.yz, 0).x;
          r18.x = r18.x * r18.y;
        }
        r18.y = cmp(0 < r18.x);
        if (r18.y != 0) {
          if (r21.w == 0) {
            r18.z = (int)cb5[r23.y+6].x;
          } else {
            r24.xyz = -cb5[r23.x+6].xyz + r0.xyz;
            r28.xyz = cmp(abs(r24.yzz) < abs(r24.xxy));
            r19.x = r28.y ? r28.x : 0;
            r24.xyz = cmp(float3(0,0,0) < r24.xyz);
            r19.z = asuint(cb5[r13.w+6].w) >> 24;
            if (8 == 0) r20.y = 0; else if (8+16 < 32) {             r20.y = (uint)cb5[r13.w+6].w << (32-(8 + 16)); r20.y = (uint)r20.y >> (32-8);            } else r20.y = (uint)cb5[r13.w+6].w >> 16;
            if (8 == 0) r20.w = 0; else if (8+8 < 32) {             r20.w = (uint)cb5[r13.w+6].w << (32-(8 + 8)); r20.w = (uint)r20.w >> (32-8);            } else r20.w = (uint)cb5[r13.w+6].w >> 8;
            r19.z = r24.x ? r19.z : r20.y;
            r20.y = 255 & asint(cb5[r13.w+6].w);
            r20.y = r24.y ? r20.w : r20.y;
            if (8 == 0) r20.w = 0; else if (8+8 < 32) {             r20.w = (uint)cb5[r23.y+6].x << (32-(8 + 8)); r20.w = (uint)r20.w >> (32-8);            } else r20.w = (uint)cb5[r23.y+6].x >> 8;
            r21.w = 255 & asint(cb5[r23.y+6].x);
            r20.w = r24.z ? r20.w : r21.w;
            r20.y = r28.z ? r20.y : r20.w;
            r19.x = r19.x ? r19.z : r20.y;
            r19.z = cmp((int)r19.x < 80);
            r18.z = r19.z ? r19.x : -1;
          }
          r24.xyz = r25.xyz * cb6[r18.z+288].xxx + r0.xyz;
          r19.x = cb6[r18.z+288].y * 5;
          r24.xyz = r5.xyz * r19.xxx + r24.xyz;
          r19.x = (uint)r18.z << 2;
          r28.xyzw = cb6[r19.x+65].xyzw * r24.yyyy;
          r28.xyzw = cb6[r19.x+64].xyzw * r24.xxxx + r28.xyzw;
          r24.xyzw = cb6[r19.x+66].xyzw * r24.zzzz + r28.xyzw;
          r24.xyzw = cb6[r19.x+67].xyzw + r24.xyzw;
          r24.xyz = r24.xyz / r24.www;
          r28.xyz = cmp(float3(0,0,0) >= r24.xyz);
          r29.xyz = cmp(r24.xyz >= float3(1,1,1));
          r19.xz = cb6[r18.z+344].zw + -cb6[r18.z+344].xy;
          r19.xz = r24.xy * r19.xz + cb6[r18.z+344].xy;
          r20.yw = r19.xz * cb6[400].zw + float2(0.5,0.5);
          r20.yw = floor(r20.yw);
          r19.xz = r19.xz * cb6[400].zw + -r20.yw;
          r30.xyzw = float4(0.5,1,0.5,1) + r19.xxzz;
          r31.xyzw = r30.xxzz * r30.xxzz;
          r24.xy = float2(1,1) + -r19.xz;
          r30.xz = min(float2(0,0), r19.xz);
          r32.xy = max(float2(0,0), r19.xz);
          r33.xy = float2(0.159999996,0.159999996) * r24.xy;
          r32.xy = -r32.xy * r32.xy + r30.yw;
          r32.xy = float2(1,1) + r32.xy;
          r32.xy = float2(0.159999996,0.159999996) * r32.xy;
          r31.xz = float2(0.0799999982,0.0799999982) * r31.xz;
          r19.xz = r31.yw * float2(0.5,0.5) + -r19.xz;
          r34.xy = float2(0.159999996,0.159999996) * r19.xz;
          r19.xz = -r30.xz * r30.xz + r24.xy;
          r19.xz = float2(1,1) + r19.xz;
          r35.xy = float2(0.159999996,0.159999996) * r19.xz;
          r19.xz = float2(0.159999996,0.159999996) * r30.yw;
          r34.z = r35.x;
          r34.w = r19.x;
          r33.z = r32.x;
          r33.w = r31.x;
          r30.xyzw = r34.zwxz + r33.zwxz;
          r35.z = r34.y;
          r35.w = r19.z;
          r32.z = r33.y;
          r32.w = r31.z;
          r24.xyw = r35.zyw + r32.zyw;
          r31.xyz = r33.xzw / r30.zwy;
          r31.xyz = float3(-2.5,-0.5,1.5) + r31.xyz;
          r31.xyz = cb6[400].xxx * r31.xyz;
          r32.xyz = r32.zyw / r24.xyw;
          r32.xyz = float3(-2.5,-0.5,1.5) + r32.xyz;
          r32.xyw = cb6[400].yyy * r32.xyz;
          r33.xyzw = r30.zwyz * r24.xxxy;
          r31.w = r32.x;
          r34.xyzw = r20.ywyw * cb6[400].xyxy + r31.xwyw;
          r19.x = t6.SampleCmpLevelZero(s3_s, r34.xy, r24.z).x;
          r19.z = t6.SampleCmpLevelZero(s3_s, r34.zw, r24.z).x;
          r19.z = r33.y * r19.z;
          r19.x = r33.x * r19.x + r19.z;
          r33.xy = r20.yw * cb6[400].xy + r31.zw;
          r19.z = t6.SampleCmpLevelZero(s3_s, r33.xy, r24.z).x;
          r19.x = r33.z * r19.z + r19.x;
          r32.z = r31.x;
          r34.xyzw = r20.ywyw * cb6[400].xyxy + r32.zyzw;
          r19.z = t6.SampleCmpLevelZero(s3_s, r34.xy, r24.z).x;
          r19.x = r33.w * r19.z + r19.x;
          r33.xyzw = r30.xyzw * r24.yyww;
          r32.xz = r31.yz;
          r31.xyzw = r20.ywyw * cb6[400].xyxy + r32.xyzy;
          r19.z = t6.SampleCmpLevelZero(s3_s, r31.xy, r24.z).x;
          r19.x = r33.x * r19.z + r19.x;
          r19.z = t6.SampleCmpLevelZero(s3_s, r31.zw, r24.z).x;
          r19.x = r33.y * r19.z + r19.x;
          r19.z = t6.SampleCmpLevelZero(s3_s, r34.zw, r24.z).x;
          r19.x = r33.z * r19.z + r19.x;
          r19.z = cmp((int)r18.z >= 0);
          r28.xyz = (int3)r28.xyz | (int3)r29.xyz;
          r21.w = (int)r28.y | (int)r28.x;
          r21.w = (int)r28.z | (int)r21.w;
          r23.z = (int)r24.z & 0x7fffffff;
          r23.z = cmp(0x7f800000 < (uint)r23.z);
          r21.w = (int)r21.w | (int)r23.z;
          r28.xyzw = r20.ywyw * cb6[400].xyxy + r32.xwzw;
          r20.y = t6.SampleCmpLevelZero(s3_s, r28.xy, r24.z).x;
          r19.x = r33.w * r20.y + r19.x;
          r20.y = r30.y * r24.w;
          r20.w = t6.SampleCmpLevelZero(s3_s, r28.zw, r24.z).x;
          r19.x = r20.y * r20.w + r19.x;
          r19.x = -1 + r19.x;
          r18.z = cb6[r18.z+288].w * r19.x + 1;
          r18.z = r21.w ? 1 : r18.z;
          r18.z = r19.z ? r18.z : 1;
        } else {
          r18.z = 1;
        }
        if (r22.w != 0) {
          r19.x = dot(r12.xyz, r26.xyz);
          r19.z = saturate(cb5[r13.w+6].z * r19.w);
          r19.z = r19.z * 0.5 + r3.w;
          r19.z = min(1, r19.z);
          r19.z = r3.w / r19.z;
          r24.xyz = r12.xyz * r19.xxx + -r26.xyz;
          r20.y = dot(r27.xyz, r24.xyz);
          r19.x = r19.x * r19.x;
          r19.x = cb5[r13.w+6].z * cb5[r13.w+6].z + -r19.x;
          r19.x = saturate(r20.y / r19.x);
          r24.xyz = r26.xyz * r19.xxx + r27.xyz;
          r19.x = dot(r24.xyz, r24.xyz);
          r19.x = rsqrt(r19.x);
          r25.xyz = r24.xyz * r19.xxx;
        } else {
          r19.z = 1;
        }
        if (r18.y != 0) {
          r18.y = saturate(cb5[r14.w+6].y * r19.w);
          r24.xyz = r1.yzw * r2.yyy + r25.xyz;
          r19.x = dot(r24.xyz, r24.xyz);
          r19.x = max(6.10351562e-05, r19.x);
          r19.x = rsqrt(r19.x);
          r24.xyz = r24.xyz * r19.xxx;
          r19.x = saturate(dot(r5.xyz, r24.xyz));
          r19.w = saturate(dot(r4.xyz, r24.xyz));
          r20.y = cmp(0 < r18.y);
          r18.y = r18.y * r18.y;
          r20.w = r19.w * 3.5999999 + 0.400000006;
          r18.y = r18.y / r20.w;
          r18.y = r9.w * r9.w + r18.y;
          r18.y = min(1, r18.y);
          r18.y = r20.y ? r18.y : r3.w;
          r18.y = r18.y * r18.y;
          r20.y = r19.x * r18.y + -r19.x;
          r19.x = r20.y * r19.x + 1;
          r19.w = 1 + -r19.w;
          r20.y = r19.w * r19.w;
          r20.y = r20.y * r20.y;
          r20.w = r20.y * r19.w;
          r19.w = -r20.y * r19.w + 1;
          r24.xyz = r6.xyz * r19.www + r20.www;
          r19.x = r19.x * r19.x;
          r19.x = r18.y / r19.x;
          r19.x = r19.x * r19.z;
          r19.z = -r9.x * r18.y + r9.x;
          r19.z = r19.z * r9.x + r18.y;
          r19.z = sqrt(r19.z);
          r19.w = -r20.x * r18.y + r20.x;
          r18.y = r19.w * r20.x + r18.y;
          r18.y = sqrt(r18.y);
          r18.y = r18.y * r9.x;
          r18.y = r20.x * r19.z + r18.y;
          r18.y = 9.99999975e-05 + r18.y;
          r18.y = 0.5 / r18.y;
          r18.y = r19.x * r18.y;
          r19.xzw = r24.xyz * r18.yyy;
          r19.xzw = min(float3(2048,2048,2048), r19.xzw);
          r20.yw = r20.xz * float2(0.96875,0.96875) + float2(0.015625,0.015625);
          r18.y = t10.SampleLevel(s0_s, r20.yw, 0).x;
          r18.y = r18.y * r5.w;
          r18.y = r18.y * r1.x;
          r18.y = r18.y / r4.w;
          r24.xyz = r18.yyy * r16.xyz;
          r24.xyz = r24.xyz / r17.xyz;
          r19.xzw = r24.xyz + r19.xzw;
          r19.xzw = cb5[r14.w+6].zzz * r19.xzw;
          r19.xzw = max(float3(0,0,0), r19.xzw);
          r19.xzw = min(float3(1000,1000,1000), r19.xzw);
          r24.xyz = r20.xxx * r7.xyw;
          r19.xzw = r19.xzw * r20.xxx + r24.xyz;
          r20.xyw = cb5[r17.w+6].xyz * r18.xxx;
          r18.xyz = r20.xyw * r18.zzz;
          r18.xyz = r18.xyz * r15.www;
          r18.xyz = r19.xzw * r18.xyz;
        } else {
          r18.xyz = float3(0,0,0);
        }
      } else {
        if (r16.w == 0) {
          r15.w = cb5[r13.w+6].y * 0.5 + 0.5;
          r24.x = -abs(cb5[r13.w+6].x) + r15.w;
          r24.y = cb5[r13.w+6].y + -r24.x;
          r15.w = 1 + -abs(r24.x);
          r15.w = r15.w + -abs(r24.y);
          r15.w = max(0.00048828125, r15.w);
          r16.w = cmp(cb5[r13.w+6].x >= 0);
          r24.z = r16.w ? r15.w : -r15.w;
          r15.w = dot(r24.xyz, r24.xyz);
          r15.w = rsqrt(r15.w);
          r19.xzw = r24.xyz * r15.www;
          r20.xyw = cb5[r23.x+6].xyz + -r0.xyz;
          r15.w = dot(r20.xyw, r20.xyw);
          r16.w = rsqrt(r15.w);
          r24.xyz = r20.xyw * r16.www;
          r14.w = (int)cb5[r14.w+6].w;
          r25.xyz = cb5[r13.w+6].zzz * r19.xzw;
          r26.xyz = -r25.xyz * float3(0.5,0.5,0.5) + r20.xyw;
          r25.xyz = r25.xyz * float3(0.5,0.5,0.5) + r20.xyw;
          r16.w = (uint)cb5[r17.w+6].w;
          r16.w = (int)r16.w & 1;
          r17.w = cmp((int)r16.w == 0);
          r17.w = ~(int)r17.w;
          r21.w = cmp(0 < cb5[r13.w+6].z);
          r17.w = r17.w ? r21.w : 0;
          r21.w = dot(r26.xyz, r26.xyz);
          r21.w = sqrt(r21.w);
          r22.w = dot(r25.xyz, r25.xyz);
          r22.w = sqrt(r22.w);
          r23.z = dot(r26.xyz, r25.xyz);
          r21.w = r21.w * r22.w + r23.z;
          r21.w = r21.w * 0.5 + 1;
          r21.w = 1 / r21.w;
          r21.w = r17.w ? r21.w : 1;
          r22.w = cmp(cb5[r23.w+6].w < 0);
          if (r22.w != 0) {
            r22.w = cb5[r23.x+6].w * cb5[r23.x+6].w;
            r22.w = r22.w * r15.w;
            r22.w = -r22.w * r22.w + 1;
            r22.w = max(0, r22.w);
            r15.w = 1 + r15.w;
            r15.w = 1 / r15.w;
            r23.z = r17.w ? 1.000000 : 0;
            r24.w = r21.w + -r15.w;
            r15.w = r23.z * r24.w + r15.w;
            r22.w = r22.w * r22.w;
            r15.w = r22.w * r15.w;
          } else {
            r25.xyz = cb5[r23.x+6].www * r20.xyw;
            r22.w = dot(r25.xyz, r25.xyz);
            r22.w = min(1, r22.w);
            r22.w = 1 + -r22.w;
            r22.w = log2(r22.w);
            r22.w = cb5[r23.w+6].w * r22.w;
            r22.w = exp2(r22.w);
            r15.w = r22.w * r21.w;
          }
          r19.x = dot(r24.xyz, -r19.xzw);
          r19.x = -cb5[r13.w+6].z + r19.x;
          r19.x = saturate(cb5[r13.w+6].w * r19.x);
          r19.x = r19.x * r19.x;
          r19.x = r16.w ? 1 : r19.x;
          r15.w = r19.x * r15.w;
          r17.w = ~(int)r17.w;
          r19.x = cmp((int)r14.w >= 0);
          r17.w = r17.w ? r19.x : 0;
          if (r17.w != 0) {
            if (r16.w == 0) {
              r17.w = (uint)r14.w << 2;
              r19.xzw = cb7[r17.w+33].xyw * r0.yyy;
              r19.xzw = cb7[r17.w+32].xyw * r0.xxx + r19.xzw;
              r19.xzw = cb7[r17.w+34].xyw * r0.zzz + r19.xzw;
              r19.xzw = cb7[r17.w+35].xyw + r19.xzw;
              r19.xz = saturate(r19.xz / r19.ww);
              r19.xz = r19.xz * cb7[r14.w+0].zw + cb7[r14.w+0].xy;
            } else {
              r17.w = (uint)r14.w << 2;
              r25.x = dot(-r20.xyw, cb7[r17.w+32].xyz);
              r25.y = dot(-r20.xyw, cb7[r17.w+33].xyz);
              r25.z = dot(-r20.xyw, cb7[r17.w+34].xyz);
              r17.w = cmp(abs(r25.x) < abs(r25.y));
              r17.w = r17.w ? 0.000000 : 0;
              r19.w = dot(abs(r25.xy), icb[r17.w+0].xy);
              r19.w = cmp(r19.w < abs(r25.z));
              r17.w = r19.w ? 2 : r17.w;
              r19.w = dot(r25.xyz, icb[r17.w+0].xyz);
              r19.w = cmp(r19.w < 0);
              bitmask.w = ((~(-1 << 31)) << 1) & 0xffffffff;  r17.w = (((uint)r17.w << 1) & bitmask.w) | ((uint)r19.w & ~bitmask.w);
              r19.w = (uint)r17.w >> 1;
              r19.w = dot(r25.xyz, icb[r19.w+0].xyz);
              r20.x = 0.000244140625 / cb7[r14.w+0].w;
              r20.x = 0.5 + -r20.x;
              r20.y = (uint)r17.w;
              r20.w = cmp((uint)r17.w < 2);
              r20.w = r20.w ? 0.000000 : 0;
              r20.w = dot(r25.xz, icb[r20.w+0].xz);
              r20.w = icb[r17.w+4].z * r20.w;
              r20.w = r20.w / abs(r19.w);
              r20.y = r20.w * r20.x + r20.y;
              r20.y = 0.5 + r20.y;
              r26.x = saturate(0.166666672 * r20.y);
              r20.y = -1 + (int)icb[r17.w+4].y;
              r20.y = dot(r25.yz, icb[r20.y+0].xy);
              r17.w = icb[r17.w+4].w * r20.y;
              r17.w = r17.w / abs(r19.w);
              r26.y = saturate(-r17.w * r20.x + 0.5);
              r19.xz = r26.xy * cb7[r14.w+0].zw + cb7[r14.w+0].xy;
            }
            r14.w = t18.SampleLevel(s0_s, r19.xz, 0).x;
            r15.w = r15.w * r14.w;
          }
          r14.w = cmp(0 < r15.w);
          if (r14.w != 0) {
            if (r16.w == 0) {
              r14.w = (int)cb5[r23.y+6].x;
            } else {
              r19.xzw = -cb5[r23.x+6].xyz + r0.xyz;
              r20.xyw = cmp(abs(r19.zww) < abs(r19.xxz));
              r15.w = r20.y ? r20.x : 0;
              r19.xzw = cmp(float3(0,0,0) < r19.xzw);
              r16.w = asuint(cb5[r13.w+6].w) >> 24;
              if (8 == 0) r20.x = 0; else if (8+16 < 32) {               r20.x = (uint)cb5[r13.w+6].w << (32-(8 + 16)); r20.x = (uint)r20.x >> (32-8);              } else r20.x = (uint)cb5[r13.w+6].w >> 16;
              if (8 == 0) r20.y = 0; else if (8+8 < 32) {               r20.y = (uint)cb5[r13.w+6].w << (32-(8 + 8)); r20.y = (uint)r20.y >> (32-8);              } else r20.y = (uint)cb5[r13.w+6].w >> 8;
              r16.w = r19.x ? r16.w : r20.x;
              r13.w = 255 & asint(cb5[r13.w+6].w);
              r13.w = r19.z ? r20.y : r13.w;
              if (8 == 0) r17.w = 0; else if (8+8 < 32) {               r17.w = (uint)cb5[r23.y+6].x << (32-(8 + 8)); r17.w = (uint)r17.w >> (32-8);              } else r17.w = (uint)cb5[r23.y+6].x >> 8;
              r19.x = 255 & asint(cb5[r23.y+6].x);
              r17.w = r19.w ? r17.w : r19.x;
              r13.w = r20.w ? r13.w : r17.w;
              r13.w = r15.w ? r16.w : r13.w;
              r15.w = cmp((int)r13.w < 80);
              r14.w = r15.w ? r13.w : -1;
            }
            r19.xzw = r24.xyz * cb6[r14.w+288].xxx + r0.xyz;
            r13.w = cb6[r14.w+288].y * 5;
            r19.xzw = r5.xyz * r13.www + r19.xzw;
            r13.w = (uint)r14.w << 2;
            r23.xyzw = cb6[r13.w+65].xyzw * r19.zzzz;
            r23.xyzw = cb6[r13.w+64].xyzw * r19.xxxx + r23.xyzw;
            r23.xyzw = cb6[r13.w+66].xyzw * r19.wwww + r23.xyzw;
            r23.xyzw = cb6[r13.w+67].xyzw + r23.xyzw;
            r19.xzw = r23.xyz / r23.www;
            r20.xyw = cmp(float3(0,0,0) >= r19.xzw);
            r23.xyz = cmp(r19.xzw >= float3(1,1,1));
            r24.xy = cb6[r14.w+344].zw + -cb6[r14.w+344].xy;
            r19.xz = r19.xz * r24.xy + cb6[r14.w+344].xy;
            r24.xy = r19.xz * cb6[400].zw + float2(0.5,0.5);
            r24.xy = floor(r24.xy);
            r19.xz = r19.xz * cb6[400].zw + -r24.xy;
            r25.xyzw = float4(0.5,1,0.5,1) + r19.xxzz;
            r26.xyzw = r25.xxzz * r25.xxzz;
            r24.zw = float2(1,1) + -r19.xz;
            r25.xz = min(float2(0,0), r19.xz);
            r27.xy = max(float2(0,0), r19.xz);
            r28.xy = float2(0.159999996,0.159999996) * r24.zw;
            r27.xy = -r27.xy * r27.xy + r25.yw;
            r27.xy = float2(1,1) + r27.xy;
            r27.xy = float2(0.159999996,0.159999996) * r27.xy;
            r26.xz = float2(0.0799999982,0.0799999982) * r26.xz;
            r19.xz = r26.yw * float2(0.5,0.5) + -r19.xz;
            r29.xy = float2(0.159999996,0.159999996) * r19.xz;
            r19.xz = -r25.xz * r25.xz + r24.zw;
            r19.xz = float2(1,1) + r19.xz;
            r30.xy = float2(0.159999996,0.159999996) * r19.xz;
            r19.xz = float2(0.159999996,0.159999996) * r25.yw;
            r29.z = r30.x;
            r29.w = r19.x;
            r28.z = r27.x;
            r28.w = r26.x;
            r25.xyzw = r29.zwxz + r28.zwxz;
            r30.z = r29.y;
            r30.w = r19.z;
            r27.z = r28.y;
            r27.w = r26.z;
            r26.xyz = r30.zyw + r27.zyw;
            r28.xyz = r28.xzw / r25.zwy;
            r28.xyz = float3(-2.5,-0.5,1.5) + r28.xyz;
            r28.xyz = cb6[400].xxx * r28.xyz;
            r27.xyz = r27.zyw / r26.xyz;
            r27.xyz = float3(-2.5,-0.5,1.5) + r27.xyz;
            r27.xyw = cb6[400].yyy * r27.xyz;
            r29.xyzw = r26.xxxy * r25.zwyz;
            r28.w = r27.x;
            r30.xyzw = r24.xyxy * cb6[400].xyxy + r28.xwyw;
            r13.w = t6.SampleCmpLevelZero(s3_s, r30.xy, r19.w).x;
            r15.w = t6.SampleCmpLevelZero(s3_s, r30.zw, r19.w).x;
            r15.w = r29.y * r15.w;
            r13.w = r29.x * r13.w + r15.w;
            r19.xz = r24.xy * cb6[400].xy + r28.zw;
            r15.w = t6.SampleCmpLevelZero(s3_s, r19.xz, r19.w).x;
            r13.w = r29.z * r15.w + r13.w;
            r27.z = r28.x;
            r30.xyzw = r24.xyxy * cb6[400].xyxy + r27.zyzw;
            r15.w = t6.SampleCmpLevelZero(s3_s, r30.xy, r19.w).x;
            r13.w = r29.w * r15.w + r13.w;
            r29.xyzw = r26.yyzz * r25.xyzw;
            r27.xz = r28.yz;
            r28.xyzw = r24.xyxy * cb6[400].xyxy + r27.xyzy;
            r15.w = t6.SampleCmpLevelZero(s3_s, r28.xy, r19.w).x;
            r13.w = r29.x * r15.w + r13.w;
            r15.w = t6.SampleCmpLevelZero(s3_s, r28.zw, r19.w).x;
            r13.w = r29.y * r15.w + r13.w;
            r15.w = t6.SampleCmpLevelZero(s3_s, r30.zw, r19.w).x;
            r13.w = r29.z * r15.w + r13.w;
            r15.w = cmp((int)r14.w >= 0);
            r20.xyw = (int3)r20.xyw | (int3)r23.xyz;
            r16.w = (int)r20.y | (int)r20.x;
            r16.w = (int)r20.w | (int)r16.w;
            r17.w = (int)r19.w & 0x7fffffff;
            r17.w = cmp(0x7f800000 < (uint)r17.w);
            r16.w = (int)r16.w | (int)r17.w;
            r23.xyzw = r24.xyxy * cb6[400].xyxy + r27.xwzw;
            r17.w = t6.SampleCmpLevelZero(s3_s, r23.xy, r19.w).x;
            r13.w = r29.w * r17.w + r13.w;
            r17.w = r26.z * r25.y;
            r19.x = t6.SampleCmpLevelZero(s3_s, r23.zw, r19.w).x;
            r13.w = r17.w * r19.x + r13.w;
            r13.w = -1 + r13.w;
            r13.w = cb6[r14.w+288].w * r13.w + 1;
            r13.w = r16.w ? 1 : r13.w;
            r13.w = r15.w ? r13.w : 1;
          } else {
            r13.w = 1;
          }
        } else {
          r13.w = 1;
        }
        r10.w = r13.w * r10.w;
        r18.xyz = float3(0,0,0);
      }
      r22.xyz = r22.xyz + r18.xyz;
      r12.w = r14.z;
    }
    r6.w = r10.w;
    r21.xyz = r22.xyz + r21.xyz;
    r7.z = (int)r7.z + 1;
  }
  r0.x = dot(r13.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r1.xyz = r13.xyz + -r0.xxx;
  r0.xzw = cb0[184].www * r1.xyz + r0.xxx;
  
  // Reduce clustered light contribution on glass
  if (GLASS_TRANSPARENCY > 0.5f) {
    r21.xyz *= 0.5f;
  }
  
  r1.xyz = r21.xyz * r6.www + r15.xyz;
  r0.xzw = r0.xzw * cb0[184].xyz + r1.xyz;
  
  // Apply glass brightness reduction
  if (GLASS_TRANSPARENCY > 0.5f) {
    r0.xzw *= 0.65f;
  }
  r1.x = r0.y * cb0[156].w + cb0[157].w;
  r1.y = r2.x * cb0[154].w + -cb0[153].w;
  r1.xy = max(float2(0.00999999978,0), r1.xy);
  r1.z = -1.44269502 * r1.x;
  r1.z = exp2(r1.z);
  r1.z = 1 + -r1.z;
  r1.x = r1.z / r1.x;
  r1.z = r0.y * cb0[156].w + cb0[158].w;
  r1.z = 1.44269502 * r1.z;
  r1.z = exp2(r1.z);
  r1.x = r1.x * r1.z;
  r1.x = -r1.y * r1.x;
  r1.xyz = cb0[155].xyz * r1.xxx;
  r1.xyz = float3(1.44269502,1.44269502,1.44269502) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.w = dot(-r4.xyz, cb0[154].xyz);
  r2.y = cb0[155].w * cb0[155].w + 1;
  r2.z = dot(r1.ww, cb0[155].ww);
  r2.y = r2.y + -r2.z;
  r2.z = cmp(0 < cb0[163].z);
  if (r2.z != 0) {
    r11.w = 7 & asint(cb0[108].w);
    r5.xyz = mad((int3)r11.xyw, int3(0x19660d,0x19660d,0x19660d), int3(0x3c6ef35f,0x3c6ef35f,0x3c6ef35f));
    r2.z = mad((int)r5.y, (int)r5.z, (int)r5.x);
    r2.w = mad((int)r5.z, (int)r2.z, (int)r5.y);
    r3.w = mad((int)r2.z, (int)r2.w, (int)r5.z);
    r5.x = mad((int)r2.w, (int)r3.w, (int)r2.z);
    r2.z = dot(-r4.xyz, -r3.xyz);
    r3.x = -cb0[44].y + r0.y;
    r3.y = cmp(5.96046448e-08 < r2.z);
    r2.z = 1 / r2.z;
    r2.z = r3.y ? r2.z : 0;
    r2.z = cb0[163].w * r2.z;
    r3.y = 1 / r2.x;
    r3.z = r3.y * r2.z;
    r4.x = r3.z * r3.x + cb0[44].y;
    r3.x = -r3.z * r3.x + r3.x;
    r3.z = cb0[159].z * r3.x;
    r3.x = cb0[162].x * r3.x;
    r3.xz = max(float2(-127,-127), r3.xz);
    r4.y = -cb0[159].x + r4.x;
    r4.y = cb0[159].z * r4.y;
    r4.y = max(-127, r4.y);
    r4.y = exp2(-r4.y);
    r4.y = cb0[159].y * r4.y;
    r4.z = cmp(5.96046448e-08 < abs(r3.z));
    r4.w = exp2(-r3.z);
    r4.w = 1 + -r4.w;
    r4.w = r4.w / r3.z;
    r3.z = -r3.z * 0.240226507 + 0.693147182;
    r3.z = r4.z ? r4.w : r3.z;
    r4.x = -cb0[162].z + r4.x;
    r4.x = cb0[162].x * r4.x;
    r4.x = max(-127, r4.x);
    r4.x = exp2(-r4.x);
    r4.x = cb0[162].y * r4.x;
    r4.z = cmp(5.96046448e-08 < abs(r3.x));
    r4.w = exp2(-r3.x);
    r4.w = 1 + -r4.w;
    r4.w = r4.w / r3.x;
    r3.x = -r3.x * 0.240226507 + 0.693147182;
    r3.x = r4.z ? r4.w : r3.x;
    r3.x = r4.x * r3.x;
    r3.x = r4.y * r3.z + r3.x;
    r2.z = -r2.z * r3.y + 1;
    r2.z = r2.z * r2.x;
    r2.z = r3.x * r2.z;
    r2.z = exp2(-r2.z);
    r2.z = min(1, r2.z);
    r2.z = max(cb0[161].w, r2.z);
    r3.xy = saturate(r2.xx * cb0[160].yw + cb0[160].xz);
    r2.z = r3.x + r2.z;
    r2.z = r2.z + r3.y;
    r2.z = min(1, r2.z);
    r5.y = mad((int)r3.w, (int)r5.x, (int)r2.w);
    r3.xy = (uint2)r5.xy >> int2(16,16);
    r3.xy = (uint2)r3.xy;
    r3.xy = r3.xy * float2(3.05180438e-05,3.05180438e-05) + float2(-1,-1);
    r3.xy = r3.xy * cb0[167].ww + r14.xy;
    r3.xy = cb0[165].xy * r3.xy;
    r2.w = r11.z * cb0[164].x + cb0[164].y;
    r2.w = log2(r2.w);
    r2.w = cb0[164].z * r2.w;
    r3.z = r2.w / cb0[163].z;
    r3.xyzw = t17.SampleLevel(s0_s, r3.xyz, 0).xyzw;
    r2.w = -cb0[166].z + r11.z;
    r2.w = saturate(1000000 * r2.w);
    r3.xyzw = float4(-0,-0,-0,-1) + r3.xyzw;
    r3.xyzw = r2.wwww * r3.xyzw + float4(0,0,0,1);
    r2.w = 1 + -r2.z;
    r4.xyz = cb0[161].xyz * r2.www;
    r3.xyz = r4.xyz * r3.www + r3.xyz;
    r2.z = r3.w * r2.z;
  } else {
    r0.y = -cb0[44].y + r0.y;
    r2.w = cb0[159].z * r0.y;
    r2.w = max(-127, r2.w);
    r0.y = cb0[162].x * r0.y;
    r0.y = max(-127, r0.y);
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
    r4.y = cmp(5.96046448e-08 < abs(r0.y));
    r4.z = exp2(-r0.y);
    r4.z = 1 + -r4.z;
    r4.z = r4.z / r0.y;
    r0.y = -r0.y * 0.240226507 + 0.693147182;
    r0.y = r4.y ? r4.z : r0.y;
    r0.y = r4.x * r0.y;
    r0.y = r3.w * r2.w + r0.y;
    r0.y = r0.y * r2.x;
    r0.y = exp2(-r0.y);
    r0.y = min(1, r0.y);
    r0.y = max(cb0[161].w, r0.y);
    r2.xw = saturate(r2.xx * cb0[160].yw + cb0[160].xz);
    r0.y = r2.x + r0.y;
    r0.y = r0.y + r2.w;
    r2.z = min(1, r0.y);
    r0.y = 1 + -r2.z;
    r3.xyz = cb0[161].xyz * r0.yyy;
  }
  r4.xyz = r2.zzz * r1.xyz;
  r0.y = r1.w * r1.w + 1;
  r0.y = 0.0596831031 * r0.y;
  r5.xyz = cb0[156].xyz * r0.yyy + cb0[158].xyz;
  r0.y = -cb0[155].w * cb0[155].w + 1;
  r1.w = 12.566371 * r2.y;
  r2.x = sqrt(r2.y);
  r1.w = r2.x * r1.w;
  r1.w = max(0.00100000005, r1.w);
  r0.y = r0.y / r1.w;
  r2.xyw = saturate(cb0[157].xyz * r0.yyy + r5.xyz);
  r2.xyw = float3(255,255,255) * r2.xyw;
  r1.xyz = float3(1,1,1) + -r1.xyz;
  r1.xyz = r2.xyw * r1.xyz;
  r1.xyz = r1.xyz * r2.zzz + r3.xyz;
  
  // Reduce fog/atmospheric contribution
  if (GLASS_TRANSPARENCY > 0.5f) {
    // Boost transmittance to reduce fog density on glass
    float3 boostedTrans = lerp(r4.xyz, float3(1,1,1), 0.5f);
    float3 reducedInscatter = r1.xyz * 0.35f;
    r8.xyz = r0.xzw * boostedTrans + reducedInscatter;
  } else {
    // Vanilla behavior
    r8.xyz = r0.xzw * r4.xyz + r1.xyz;
  }
  r0.xy = float2(0.5,-0.5) * r10.xy;
  r0.xy = sqrt(abs(r0.xy));
  r0.xy = sqrt(r0.xy);
  r10.z = -r10.y;
  r0.zw = cmp(float2(0,0) < r10.xz);
  r1.xy = cmp(r10.xz < float2(0,0));
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
  r0.x = dot(r8.xyz, float3(0.212672904,0.715152204,0.0721750036));
  r0.x = r0.x * r8.w;
  r0.x = max(r0.x, r8.w);
  r0.x = saturate(10 * r0.x);
  r0.x = cmp(0.5 < r0.x);
  o1.z = r0.x ? 1.000000 : 0;
  
  // Modifed Glass Final Output
  if (GLASS_TRANSPARENCY > 0.5f) {
    float3 glassColor = r8.xyz;
    float glassLuma = dot(glassColor, float3(0.2126f, 0.7152f, 0.0722f));
    float maxBrightness = 2.0f;
    if (glassLuma > 0.5f) {
      float compression = 0.5f + (maxBrightness - 0.5f) * (1.0f - exp(-(glassLuma - 0.5f) / (maxBrightness - 0.5f)));
      float scale = compression / max(glassLuma, 0.001f);
      glassColor *= scale;
    }
    
    o0.xyz = glassColor;
    o0.w = r8.w;
  } else {
    // Vanilla output
    o0.xyzw = r8.xyzw;
  }
  o1.w = 0;
  return;
}