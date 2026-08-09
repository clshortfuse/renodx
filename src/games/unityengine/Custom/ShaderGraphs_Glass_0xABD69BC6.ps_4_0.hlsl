#include "../shared.h"

Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerComparisonState s0_s : register(s0);
cbuffer cb4 : register(b4){
  float4 cb4[12];
}
cbuffer cb3 : register(b3){
  float4 cb3[1313];
}
cbuffer cb2 : register(b2){
  float4 cb2[14];
}
cbuffer cb1 : register(b1){
  float4 cb1[1024];
}
cbuffer cb0 : register(b0){
  float4 cb0[131];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float3 v1 : INTERP2,
  float4 v2 : INTERP3,
  float4 v3 : INTERP4,
  float4 v4 : INTERP5,
  float4 v5 : INTERP6,
  float3 v6 : INTERP7,
  float3 v7 : INTERP8,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 0, 0, 1.000000} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v7.xyz, v7.xyz);
  r0.x = sqrt(r0.x);
  r0.x = 1 / r0.x;
  r0.y = cmp(0 < v3.w);
  r0.z = cmp(cb2[9].w >= 0);
  r0.yz = r0.yz ? float2(1,1) : float2(-1,-1);
  r0.y = r0.y * r0.z;
  r1.xyz = v7.zxy * v3.yzx;
  r1.xyz = v7.yzx * v3.zxy + -r1.xyz;
  r0.yzw = r1.xyz * r0.yyy;
  r1.xyz = v7.xyz * r0.xxx;
  r2.xyz = v3.xyz * r0.xxx;
  r3.xyz = r0.xxx * r0.zwy;
  r0.x = cmp(cb0[25].w == 0.000000);
  r4.xyz = cb0[21].xyz + -v6.xyz;
  r1.w = dot(r4.xyz, r4.xyz);
  r1.w = rsqrt(r1.w);
  r4.xyz = r4.xyz * r1.www;
  r5.x = cb0[66].z;
  r5.y = cb0[67].z;
  r5.z = cb0[68].z;
  r4.xyz = r0.xxx ? r4.xyz : r5.xyz;
  r0.x = cmp(cb0[22].x < 0);
  r1.w = cb0[3].y + -v0.y;
  r5.y = r0.x ? r1.w : v0.y;
  r5.x = v0.x;
  r5.xy = r5.xy / cb0[3].xy;
  r6.xyz = max(float3(5.96046448e-08,5.96046448e-08,5.96046448e-08), abs(r1.xyz));
  r0.x = dot(r6.xyz, float3(1,1,1));
  r6.xyz = r6.xyz / r0.xxx;
  r7.xyzw = t3.SampleBias(s2_s, float2(0,0), cb0[4].x).xyzw;
  r8.xyz = r7.xyz * r6.yyy;
  r6.xyw = r7.xyz * r6.xxx + r8.xyz;
  r6.xyz = saturate(r7.xyz * r6.zzz + r6.xyw);
  r0.x = dot(r1.xyz, r1.xyz);
  r1.w = rsqrt(r0.x);
  r7.xyz = r1.xyz * r1.www;
  r1.w = dot(r4.xyz, r4.xyz);
  r1.w = rsqrt(r1.w);
  r8.xyz = r4.xyz * r1.www;
  r1.w = saturate(dot(r7.xyz, r8.xyz));
  r1.w = 1 + -r1.w;
  r1.w = log2(r1.w);
  r2.w = 3.16000009 * r1.w;
  r2.w = exp2(r2.w);
  r2.w = -0.217637643 + r2.w;
  r2.w = saturate(r2.w * 10 + 0.217637643);
  r2.w = 1 + -r2.w;
  r6.xyz = r6.xyz * r2.www;
  r7.xyz = cb4[2].xyz * r6.xyz;
  r2.w = sin(cb0[19].x);
  r2.w = 1 + r2.w;
  r2.w = 0.5 * r2.w;
  r8.xy = cb4[6].zw * r2.ww;
  r8.xy = v4.xy * cb4[6].xy + r8.xy;
  r8.xyzw = t5.SampleBias(s4_s, r8.xy, cb0[4].x).xyzw;
  r8.x = r8.w * r8.x;
  r8.xy = r8.xy * float2(2,2) + float2(-1,-1);
  r2.w = dot(r8.xy, r8.xy);
  r2.w = min(1, r2.w);
  r2.w = 1 + -r2.w;
  r2.w = sqrt(r2.w);
  r2.w = max(1.00000002e-16, r2.w);
  r8.xy = cb4[5].xx * r8.xy;
  r3.w = saturate(cb4[5].x);
  r2.w = -1 + r2.w;
  r8.z = r3.w * r2.w + 1;
  r0.x = max(1.17549435e-38, r0.x);
  r0.x = rsqrt(r0.x);
  r9.xyz = r1.xyz * r0.xxx;
  r10.xyz = r3.yzx * r1.yzx;
  r10.xyz = r3.xyz * r1.zxy + -r10.xyz;
  r11.xyz = r2.yzx * r1.zxy;
  r11.xyz = r1.yzx * r2.zxy + -r11.xyz;
  r12.xyz = r3.xyz * r2.zxy;
  r3.xyz = r2.yzx * r3.yzx + -r12.xyz;
  r0.x = dot(r2.xyz, r10.xyz);
  r2.x = dot(r10.xyz, r9.xyz);
  r2.y = dot(r11.xyz, r9.xyz);
  r2.z = dot(r3.xyz, r9.xyz);
  r0.x = cmp(r0.x < 0);
  r0.x = r0.x ? -1 : 1;
  r2.xyz = r0.xxx * r2.xyz;
  r0.x = dot(r2.xyz, r2.xyz);
  r0.x = max(1.17549435e-38, r0.x);
  r0.x = rsqrt(r0.x);
  r2.xyz = r2.xyz * r0.xxx;
  r0.x = cmp(0 != cb4[10].z);
  r3.xyz = r0.xxx ? r8.xyz : r2.xyz;
  r9.xyzw = t4.SampleBias(s3_s, v4.xy, cb0[4].x).xyzw;
  r0.x = cmp(0 != cb4[11].x);
  r2.xyzw = r0.xxxx ? r8.xyxy : r2.xyxy;
  r8.xy = cb4[10].yw * r1.ww;
  r8.xy = exp2(r8.xy);
  r10.xyz = ddx(v6.xyz);
  r11.xyz = ddy(v6.zxy);
  r12.xyz = r10.yzx * r1.zxy;
  r12.xyz = r1.yzx * r10.zxy + -r12.xyz;
  r13.xyz = r11.xyz * r1.yzx;
  r11.xyz = r11.zxy * r1.zxy + -r13.xyz;
  r0.x = dot(r10.xyz, r11.xyz);
  r3.w = cmp(r0.x < 0);
  r3.w = r3.w ? -1 : 1;
  r0.x = max(1.19209299e-15, abs(r0.x));
  r0.x = r3.w / r0.x;
  r3.w = ddx(r8.x);
  r4.w = ddy(r8.x);
  r8.xzw = r4.www * r12.xyz;
  r8.xzw = r3.www * r11.xyz + r8.xzw;
  r1.xyz = -r0.xxx * r8.xzw + r1.xyz;
  r0.x = dot(r1.xyz, r1.xyz);
  r0.x = max(1.17549435e-38, r0.x);
  r0.x = rsqrt(r0.x);
  r10.xyzw = r1.xyxy * r0.xxxx;
  r5.z = 1 + -r5.y;
  r5.xyzw = r8.yyyy * r10.xyzw + r5.xzxz;
  r2.xyzw = r5.xyzw + r2.xyzw;
  r5.xyzw = cb4[1].zzzz * float4(0.00100000005,0.00100000005,0.00200000009,0.00200000009) + r2.zwzw;
  r8.xyzw = -cb0[130].xyxy * float4(0.5,0.5,0.5,0.5) + float4(1,1,1,1);
  r5.xyzw = min(r8.xyzw, r5.xyzw);
  r5.xyzw = cb0[28].xyxy * r5.xyzw;
  r10.xyzw = t2.SampleBias(s1_s, r5.xy, cb0[4].x).xyzw;
  r5.xyzw = t2.SampleBias(s1_s, r5.zw, cb0[4].x).xyzw;
  r11.xyzw = cb4[1].zzzz * float4(0.00300000003,0.00300000003,-0.00100000005,-0.00100000005) + r2.zwzw;
  r11.xyzw = min(r11.xyzw, r8.xyzw);
  r11.xyzw = cb0[28].xyxy * r11.xyzw;
  r12.xyzw = t2.SampleBias(s1_s, r11.xy, cb0[4].x).xyzw;
  r11.xyzw = t2.SampleBias(s1_s, r11.zw, cb0[4].x).xyzw;
  r2.xyzw = cb4[1].zzzz * float4(-0.00200000009,-0.00200000009,-0.00300000003,-0.00300000003) + r2.xyzw;
  r2.xyzw = min(r2.xyzw, r8.xyzw);
  r2.xyzw = cb0[28].xyxy * r2.xyzw;
  r8.xyzw = t2.SampleBias(s1_s, r2.xy, cb0[4].x).xyzw;
  r2.xyzw = t2.SampleBias(s1_s, r2.zw, cb0[4].x).xyzw;
  r1.xyz = r8.xyz + r2.xyz;
  r1.xyz = r11.xyz + r1.xyz;
  r1.xyz = r12.xyz + r1.xyz;
  r1.xyz = r5.xyz + r1.xyz;
  r1.xyz = r10.xyz + r1.xyz;
  r1.xyz = cb4[7].xyz * r1.xyz;
  r1.xyz = float3(0.166666672,0.166666672,0.166666672) * r1.xyz;
  r0.x = cb4[8].x * r1.w;
  r0.x = exp2(r0.x);
  r2.xyz = cb4[9].xyz * r0.xxx;
  r2.w = 1 + -r0.x;
  r5.xyz = r0.xxx * cb4[9].xyz + abs(r2.www);
  r2.xyz = cb4[10].xxx * r2.xyz;
  r1.xyz = saturate(r1.xyz * r5.xyz + r2.xyz);
  r0.x = cb4[11].y * r1.w;
  r0.x = exp2(r0.x);
  r0.x = -0.217637643 + r0.x;
  o0.w = saturate(r0.x * cb4[11].z + 0.217637643);
  r0.xyz = r3.yyy * r0.yzw;
  r0.xyz = r3.xxx * v3.xyz + r0.xyz;
  r0.xyz = r3.zzz * v7.xyz + r0.xyz;
  r0.w = dot(r0.xyz, r0.xyz);
  r0.w = rsqrt(r0.w);
  r0.xyz = r0.xyz * r0.www;
  r0.w = cb0[67].z * v6.y;
  r0.w = cb0[66].z * v6.x + r0.w;
  r0.w = cb0[68].z * v6.z + r0.w;
  r0.w = cb0[69].z + r0.w;
  r0.w = -cb0[22].y + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = cb0[60].x * r0.w;
  r2.xy = saturate(cb4[1].xy);
  r1.w = -r2.x * 0.959999979 + 0.959999979;
  r3.xyz = r7.xyz * r1.www;
  r5.xyz = r6.xyz * cb4[2].xyz + float3(-0.0399999991,-0.0399999991,-0.0399999991);
  r2.xzw = r2.xxx * r5.xyz + float3(0.0399999991,0.0399999991,0.0399999991);
  r1.w = 1 + -r2.y;
  r1.w = r1.w * r1.w;
  r1.w = max(0.0078125, r1.w);
  r2.y = r1.w * r1.w;
  r3.w = r1.w * 4 + 2;
  r1.w = r1.w * r1.w + -1;
  r4.w = t0.SampleCmpLevelZero(s0_s, v2.xy, v2.z).x;
  r5.x = 1 + -cb3[27].x;
  r4.w = r4.w * cb3[27].x + r5.x;
  r5.x = cmp(0 >= v2.z);
  r5.y = cmp(v2.z >= 1);
  r5.x = (int)r5.y | (int)r5.x;
  r4.w = r5.x ? 1 : r4.w;
  r5.xyz = -cb0[21].xyz + v6.xyz;
  r5.x = dot(r5.xyz, r5.xyz);
  r5.y = saturate(r5.x * cb3[27].z + cb3[27].w);
  r5.z = 1 + -r4.w;
  r4.w = r5.y * r5.z + r4.w;
  r4.w = cb2[11].z * r4.w;
  r5.y = saturate(dot(r0.xyz, cb0[5].xyz));
  r4.w = r5.y * r4.w;
  r5.yzw = cb0[6].xyz * r4.www;
  r6.xyz = cb0[5].xyz + r4.xyz;
  r4.w = dot(r6.xyz, r6.xyz);
  r4.w = max(1.17549435e-38, r4.w);
  r4.w = rsqrt(r4.w);
  r6.xyz = r6.xyz * r4.www;
  r4.w = saturate(dot(r0.xyz, r6.xyz));
  r6.x = saturate(dot(cb0[5].xyz, r6.xyz));
  r4.w = r4.w * r4.w;
  r4.w = r4.w * r1.w + 1.00001001;
  r6.x = r6.x * r6.x;
  r4.w = r4.w * r4.w;
  r6.x = max(0.100000001, r6.x);
  r4.w = r6.x * r4.w;
  r4.w = r4.w * r3.w;
  r4.w = r2.y / r4.w;
  r6.xyz = r2.xzw * r4.www + r3.xyz;
  r4.w = min(cb2[11].y, cb0[10].x);
  r4.w = (int)r4.w;
  r5.x = saturate(r5.x * cb3[31].x + cb3[31].y);
  r7.xyz = float3(0,0,0);
  r6.w = 0;
  while (true) {
    r7.w = cmp((uint)r6.w >= (uint)r4.w);
    if (r7.w != 0) break;
    r7.w = (uint)r6.w >> 2;
    r8.x = (int)r6.w & 3;
    r7.w = dot(cb2[r7.w+12].xyzw, icb[r8.x+0].xyzw);
    r7.w = (int)r7.w;
    r8.xyz = -v6.xyz * cb1[r7.w+0].www + cb1[r7.w+0].xyz;
    r8.w = dot(r8.xyz, r8.xyz);
    r8.w = max(6.10351562e-05, r8.w);
    r9.w = rsqrt(r8.w);
    r10.xyz = r9.www * r8.xyz;
    r10.w = 1 / r8.w;
    r8.w = cb1[r7.w+512].x * r8.w;
    r8.w = -r8.w * r8.w + 1;
    r8.w = max(0, r8.w);
    r8.w = r8.w * r8.w;
    r8.w = r10.w * r8.w;
    r10.w = dot(cb1[r7.w+768].xyz, r10.xyz);
    r10.w = saturate(r10.w * cb1[r7.w+512].z + cb1[r7.w+512].w);
    r10.w = r10.w * r10.w;
    r8.w = r10.w * r8.w;
    r10.w = (int)cb3[r7.w+33].w;
    r11.x = cmp((int)r10.w >= 0);
    if (r11.x != 0) {
      r11.x = cmp(0 != cb3[r7.w+33].z);
      if (r11.x != 0) {
        r11.xyz = cmp(abs(r10.zzy) >= abs(r10.xyx));
        r11.x = r11.y ? r11.x : 0;
        r12.xyz = cmp(-r10.zyx < float3(0,0,0));
        r11.yw = r12.xy ? float2(5,3) : float2(4,2);
        r12.x = r12.z ? 1.000000 : 0;
        r11.z = r11.z ? r11.w : r12.x;
        r11.x = r11.x ? r11.y : r11.z;
        r11.y = trunc(cb3[r7.w+33].w);
        r11.x = r11.y + r11.x;
        r10.w = (int)r11.x;
      }
      r10.w = (uint)r10.w << 2;
      r11.xyzw = cb3[r10.w+290].xyzw * v6.yyyy;
      r11.xyzw = cb3[r10.w+289].xyzw * v6.xxxx + r11.xyzw;
      r11.xyzw = cb3[r10.w+291].xyzw * v6.zzzz + r11.xyzw;
      r11.xyzw = cb3[r10.w+292].xyzw + r11.xyzw;
      r11.xyz = r11.xyz / r11.www;
      r10.w = t1.SampleCmpLevelZero(s0_s, r11.xy, r11.z).x;
      r11.x = -cb3[r7.w+33].x + 1;
      r10.w = r10.w * cb3[r7.w+33].x + r11.x;
      r11.x = cmp(0 >= r11.z);
      r11.y = cmp(r11.z >= 1);
      r11.x = (int)r11.y | (int)r11.x;
      r10.w = r11.x ? 1 : r10.w;
    } else {
      r10.w = 1;
    }
    r11.x = 1 + -r10.w;
    r10.w = r5.x * r11.x + r10.w;
    r8.w = r10.w * r8.w;
    r10.w = saturate(dot(r0.xyz, r10.xyz));
    r8.w = r10.w * r8.w;
    r11.xyz = cb1[r7.w+256].xyz * r8.www;
    r8.xyz = r8.xyz * r9.www + r4.xyz;
    r7.w = dot(r8.xyz, r8.xyz);
    r7.w = max(1.17549435e-38, r7.w);
    r7.w = rsqrt(r7.w);
    r8.xyz = r8.xyz * r7.www;
    r7.w = saturate(dot(r0.xyz, r8.xyz));
    r8.x = saturate(dot(r10.xyz, r8.xyz));
    r7.w = r7.w * r7.w;
    r7.w = r7.w * r1.w + 1.00001001;
    r8.x = r8.x * r8.x;
    r7.w = r7.w * r7.w;
    r8.x = max(0.100000001, r8.x);
    r7.w = r8.x * r7.w;
    r7.w = r7.w * r3.w;
    r7.w = r2.y / r7.w;
    r8.xyz = r2.xzw * r7.www + r3.xyz;
    r7.xyz = r8.xyz * r11.xyz + r7.xyz;
    r6.w = (int)r6.w + 1;
  }
  r0.xyz = r6.xyz * r5.yzw + r7.xyz;
  r0.xyz = r9.xyz * r1.xyz + r0.xyz;
  r0.w = -r0.w * r0.w;
  r0.w = exp2(r0.w);
  r0.xyz = -cb0[61].xyz + r0.xyz;
  o0.xyz = r0.www * r0.xyz + cb0[61].xyz;
  if(injectedData.isClamped != 0.f){
    o0 = saturate(o0);
  }
  return;
}