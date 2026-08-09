#include "../shared.h"

Texture2D<float4> t6 : register(t6);
Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
TextureCube<float4> t2 : register(t2);
TextureCube<float4> t1 : register(t1);
TextureCube<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerComparisonState s4_s : register(s4);
SamplerComparisonState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb5 : register(b5){
  float4 cb5[5];
}
cbuffer cb4 : register(b4){
  float4 cb4[1286];
}
cbuffer cb3 : register(b3){
  float4 cb3[31];
}
cbuffer cb2 : register(b2){
  float4 cb2[32];
}
cbuffer cb1 : register(b1){
  float4 cb1[1024];
}
cbuffer cb0 : register(b0){
  float4 cb0[77];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float3 v1 : INTERP0,
  float3 v2 : INTERP1,
  float4 v3 : INTERP2,
  float4 v4 : INTERP3,
  float3 v5 : INTERP4,
  float2 v6 : INTERP5,
  float2 w6 : INTERP6,
  float3 v7 : INTERP7,
  float4 v8 : INTERP8,
  float4 v9 : INTERP9,
  out float4 o0 : SV_TARGET0)
{
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 0, 0, 1.000000} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v2.xyz, v2.xyz);
  r0.y = sqrt(r0.x);
  r0.y = 1 / r0.y;
  r0.z = cmp(0 < v3.w);
  r0.w = cmp(cb2[9].w >= 0);
  r0.zw = r0.zw ? float2(1,1) : float2(-1,-1);
  r0.z = r0.z * r0.w;
  r1.xyz = v3.yzx * v2.zxy;
  r1.xyz = v2.yzx * v3.zxy + -r1.xyz;
  r1.xyz = r1.xyz * r0.zzz;
  r2.xyz = v2.xyz * r0.yyy;
  r3.xyz = v3.xyz * r0.yyy;
  r0.yzw = r1.xyz * r0.yyy;
  r1.x = dot(v5.xyz, v5.xyz);
  r1.y = rsqrt(r1.x);
  r1.yzw = v5.xyz * r1.yyy;
  r4.xyz = cb0[74].xyw * v1.yyy;
  r4.xyz = cb0[73].xyw * v1.xxx + r4.xyz;
  r4.xyz = cb0[75].xyw * v1.zzz + r4.xyz;
  r4.xyz = cb0[76].xyw + r4.xyz;
  r4.xyz = float3(0.5,0.5,0.5) * r4.xyz;
  r4.w = cb0[17].x * r4.y;
  r4.xy = r4.xw + r4.zz;
  r5.xyzw = t6.SampleBias(s6_s, v4.xy, cb0[19].x).xyzw;
  r6.xyz = t5.SampleBias(s5_s, v4.xy, cb0[19].x).xyw;
  r6.x = r6.z * r6.x;
  r6.xy = r6.xy * float2(2,2) + float2(-1,-1);
  r2.w = dot(r6.xy, r6.xy);
  r2.w = min(1, r2.w);
  r2.w = 1 + -r2.w;
  r2.w = sqrt(r2.w);
  r6.z = max(1.00000002e-16, r2.w);
  r7.xyz = cb5[0].www * r6.xyz;
  r6.xyz = -r6.xyz * cb5[0].www + float3(0,0,0.5);
  r6.xyz = cb5[0].www * r6.xyz + r7.xyz;
  r0.yzw = r6.yyy * r0.yzw;
  r0.yzw = r3.xyz * r6.xxx + r0.yzw;
  r0.yzw = r2.xyz * r6.zzz + r0.yzw;
  r2.x = dot(r0.yzw, r0.yzw);
  r2.x = rsqrt(r2.x);
  r0.yzw = r2.xxx * r0.yzw;
  r0.y = saturate(dot(r0.yzw, r1.yzw));
  r0.y = 1 + -r0.y;
  r0.y = log2(r0.y);
  r0.y = cb5[1].y * r0.y;
  r0.y = exp2(r0.y);
  r0.y = r5.w * r0.y;
  r1.yzw = r5.xyz * cb5[0].yyy + -cb5[3].xyz;
  r1.yzw = cb5[0].zzz * r1.yzw + cb5[3].xyz;
  r2.xyz = cb5[3].xyz * r1.yzw;
  r0.zw = cb0[15].xx * cb5[4].xy + r4.xy;
  r0.zw = cb5[1].xx * r0.zw;
  r0.zw = sin(r0.zw);
  r0.zw = r0.zw * r0.zw;
  r2.w = cmp(0 != cb5[1].z);
  r0.z = r2.w ? r0.z : r0.w;
  r0.w = v1.z / cb5[0].x;
  r0.w = cb0[15].x * 0.100000001 + r0.w;
  r0.w = frac(r0.w);
  r0.w = r0.w * r0.w;
  r0.w = r0.w * r0.w;
  r0.w = r0.w * r0.w;
  r0.w = r0.w * 3.20000005 + 0.800000012;
  r0.z = r0.z * r0.w;
  o0.w = saturate(r0.y * r0.z);
  r0.x = rsqrt(r0.x);
  r0.xyz = v2.xyz * r0.xxx;
  r1.x = max(1.17549435e-38, r1.x);
  r1.x = rsqrt(r1.x);
  r3.xyz = v5.xyz * r1.xxx;
  r4.xyz = -cb3[20].xyz + v1.xyz;
  r5.xyz = -cb3[21].xyz + v1.xyz;
  r6.xyz = -cb3[22].xyz + v1.xyz;
  r7.xyz = -cb3[23].xyz + v1.xyz;
  r4.x = dot(r4.xyz, r4.xyz);
  r4.y = dot(r5.xyz, r5.xyz);
  r4.z = dot(r6.xyz, r6.xyz);
  r4.w = dot(r7.xyz, r7.xyz);
  r4.xyzw = cmp(r4.xyzw < cb3[24].xyzw);
  r5.xyzw = r4.xyzw ? float4(1,1,1,1) : 0;
  r4.xyz = r4.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
  r4.xyz = r5.yzw + r4.xyz;
  r5.yzw = max(float3(0,0,0), r4.xyz);
  r2.w = dot(r5.xyzw, float4(4,3,2,1));
  r2.w = 4 + -r2.w;
  r2.w = (uint)r2.w;
  r2.w = (uint)r2.w << 2;
  r4.xyz = cb3[r2.w+1].xyz * v1.yyy;
  r4.xyz = cb3[r2.w+0].xyz * v1.xxx + r4.xyz;
  r4.xyz = cb3[r2.w+2].xyz * v1.zzz + r4.xyz;
  r4.xyz = cb3[r2.w+3].xyz + r4.xyz;
  r0.w = 1;
  r5.x = dot(cb2[25].xyzw, r0.xyzw);
  r5.y = dot(cb2[26].xyzw, r0.xyzw);
  r5.z = dot(cb2[27].xyzw, r0.xyzw);
  r6.xyzw = r0.xyzz * r0.yzzx;
  r7.x = dot(cb2[28].xyzw, r6.xyzw);
  r7.y = dot(cb2[29].xyzw, r6.xyzw);
  r7.z = dot(cb2[30].xyzw, r6.xyzw);
  r0.w = r0.y * r0.y;
  r0.w = r0.x * r0.x + -r0.w;
  r6.xyz = cb2[31].xyz * r0.www + r7.xyz;
  r5.xyz = r6.xyz + r5.xyz;
  r5.xyz = max(float3(0,0,0), r5.xyz);
  r2.xyz = float3(0.959999979,0.959999979,0.959999979) * r2.xyz;
  r0.w = cmp(cb3[29].y != 0.000000);
  if (r0.w != 0) {
    r6.xy = r4.xy * cb3[30].zw + float2(0.5,0.5);
    r6.xy = floor(r6.xy);
    r6.zw = r4.xy * cb3[30].zw + -r6.xy;
    r7.xyzw = float4(0.5,1,0.5,1) + r6.zzww;
    r8.xyzw = r7.xxzz * r7.xxzz;
    r7.xz = float2(0.0799999982,0.0799999982) * r8.yw;
    r8.xy = r8.xz * float2(0.5,0.5) + -r6.zw;
    r8.zw = float2(1,1) + -r6.zw;
    r9.xy = min(float2(0,0), r6.zw);
    r9.xy = -r9.xy * r9.xy + r8.zw;
    r6.zw = max(float2(0,0), r6.zw);
    r6.zw = -r6.zw * r6.zw + r7.yw;
    r9.xy = float2(1,1) + r9.xy;
    r6.zw = float2(1,1) + r6.zw;
    r10.xy = float2(0.159999996,0.159999996) * r8.xy;
    r8.xy = float2(0.159999996,0.159999996) * r8.zw;
    r9.xy = float2(0.159999996,0.159999996) * r9.xy;
    r11.xy = float2(0.159999996,0.159999996) * r6.zw;
    r6.zw = float2(0.159999996,0.159999996) * r7.yw;
    r10.z = r9.x;
    r10.w = r6.z;
    r8.z = r11.x;
    r8.w = r7.x;
    r12.xyzw = r10.zwxz + r8.zwxz;
    r9.z = r10.y;
    r9.w = r6.w;
    r11.z = r8.y;
    r11.w = r7.z;
    r7.xyz = r11.zyw + r9.zyw;
    r8.xyz = r8.xzw / r12.zwy;
    r8.xyz = float3(-2.5,-0.5,1.5) + r8.xyz;
    r9.xyz = r11.zyw / r7.xyz;
    r9.xyz = float3(-2.5,-0.5,1.5) + r9.xyz;
    r8.xyz = cb3[30].xxx * r8.yxz;
    r9.xyz = cb3[30].yyy * r9.xyz;
    r8.w = r9.x;
    r10.xyzw = r6.xyxy * cb3[30].xyxy + r8.ywxw;
    r6.zw = r6.xy * cb3[30].xy + r8.zw;
    r9.w = r8.y;
    r8.yw = r9.yz;
    r11.xyzw = r6.xyxy * cb3[30].xyxy + r8.xyzy;
    r9.xyzw = r6.xyxy * cb3[30].xyxy + r9.wywz;
    r8.xyzw = r6.xyxy * cb3[30].xyxy + r8.xwzw;
    r13.xyzw = r12.zwyz * r7.xxxy;
    r14.xyzw = r12.xyzw * r7.yyzz;
    r0.w = r12.y * r7.z;
    r2.w = t3.SampleCmpLevelZero(s3_s, r10.xy, r4.z).x;
    r3.w = t3.SampleCmpLevelZero(s3_s, r10.zw, r4.z).x;
    r3.w = r13.y * r3.w;
    r2.w = r13.x * r2.w + r3.w;
    r3.w = t3.SampleCmpLevelZero(s3_s, r6.zw, r4.z).x;
    r2.w = r13.z * r3.w + r2.w;
    r3.w = t3.SampleCmpLevelZero(s3_s, r9.xy, r4.z).x;
    r2.w = r13.w * r3.w + r2.w;
    r3.w = t3.SampleCmpLevelZero(s3_s, r11.xy, r4.z).x;
    r2.w = r14.x * r3.w + r2.w;
    r3.w = t3.SampleCmpLevelZero(s3_s, r11.zw, r4.z).x;
    r2.w = r14.y * r3.w + r2.w;
    r3.w = t3.SampleCmpLevelZero(s3_s, r9.zw, r4.z).x;
    r2.w = r14.z * r3.w + r2.w;
    r3.w = t3.SampleCmpLevelZero(s3_s, r8.xy, r4.z).x;
    r2.w = r14.w * r3.w + r2.w;
    r3.w = t3.SampleCmpLevelZero(s3_s, r8.zw, r4.z).x;
    r0.w = r0.w * r3.w + r2.w;
  } else {
    r0.w = t3.SampleCmpLevelZero(s3_s, r4.xy, r4.z).x;
  }
  r2.w = 1 + -cb3[29].x;
  r0.w = r0.w * cb3[29].x + r2.w;
  r2.w = cmp(0 >= r4.z);
  r3.w = cmp(r4.z >= 1);
  r2.w = (int)r2.w | (int)r3.w;
  r0.w = r2.w ? 1 : r0.w;
  r4.xyz = -cb0[16].xyz + v1.xyz;
  r2.w = dot(r4.xyz, r4.xyz);
  r3.w = saturate(r2.w * cb3[29].z + cb3[29].w);
  r4.x = 1 + -r0.w;
  r0.w = r3.w * r4.x + r0.w;
  r3.w = dot(-r3.xyz, r0.xyz);
  r3.w = r3.w + r3.w;
  r4.xyz = r0.xyz * -r3.www + -r3.xyz;
  r3.w = saturate(dot(r0.xyz, r3.xyz));
  r3.w = 1 + -r3.w;
  r3.w = r3.w * r3.w;
  r3.w = r3.w * r3.w;
  r6.xyz = -cb2[18].xyz + cb2[17].xyz;
  r4.w = dot(r6.xyz, r6.xyz);
  r6.xyz = -cb2[21].xyz + cb2[20].xyz;
  r5.w = dot(r6.xyz, r6.xyz);
  r4.w = -r5.w + r4.w;
  r5.w = cmp(0 < cb2[21].w);
  r6.x = cmp(cb2[21].w == 0.000000);
  r6.y = cmp(r4.w < -9.99999975e-05);
  r6.y = r6.y ? r6.x : 0;
  r5.w = (int)r5.w | (int)r6.y;
  r6.y = cmp(cb2[21].w < 0);
  r4.w = cmp(9.99999975e-05 < r4.w);
  r4.w = r4.w ? r6.x : 0;
  r4.w = (int)r4.w | (int)r6.y;
  r6.xyz = -cb2[18].xyz + v1.xyz;
  r7.xyz = cb2[17].xyz + -v1.xyz;
  r6.xyz = min(r7.xyz, r6.xyz);
  r6.xyz = r6.xyz / cb2[17].www;
  r6.y = min(r6.y, r6.z);
  r6.x = saturate(min(r6.x, r6.y));
  r6.yzw = -cb2[21].xyz + v1.xyz;
  r7.xyz = cb2[20].xyz + -v1.xyz;
  r6.yzw = min(r7.xyz, r6.yzw);
  r6.yzw = r6.yzw / cb2[20].www;
  r6.z = min(r6.z, r6.w);
  r6.y = saturate(min(r6.y, r6.z));
  r6.z = 1 + -r6.y;
  r6.z = min(r6.x, r6.z);
  r4.w = r4.w ? r6.z : r6.x;
  r6.x = 1 + -r6.x;
  r6.x = min(r6.y, r6.x);
  r5.w = r5.w ? r6.x : r6.y;
  r6.x = r5.w + r4.w;
  r6.y = max(1, r6.x);
  r4.w = r4.w / r6.y;
  r5.w = r5.w / r6.y;
  r6.y = cmp(0.00999999978 < r4.w);
  if (r6.y != 0) {
    r6.y = cmp(0 < cb2[19].w);
    r7.xyz = cmp(float3(0,0,0) < r4.xyz);
    r7.xyz = r7.xyz ? cb2[17].xyz : cb2[18].xyz;
    r7.xyz = -v1.xyz + r7.xyz;
    r7.xyz = r7.xyz / r4.xyz;
    r6.z = min(r7.x, r7.y);
    r6.z = min(r6.z, r7.z);
    r7.xyz = -cb2[19].xyz + v1.xyz;
    r7.xyz = r4.xyz * r6.zzz + r7.xyz;
    r6.yzw = r6.yyy ? r7.xyz : r4.xyz;
    r7.xyzw = t1.SampleLevel(s1_s, r6.yzw, 4.05000019).xyzw;
    r6.y = -1 + r7.w;
    r6.y = cb2[15].w * r6.y + 1;
    r6.y = max(0, r6.y);
    r6.y = log2(r6.y);
    r6.y = cb2[15].y * r6.y;
    r6.y = exp2(r6.y);
    r6.y = cb2[15].x * r6.y;
    r6.yzw = r6.yyy * r7.xyz;
    r6.yzw = r6.yzw * r4.www;
  } else {
    r6.yzw = float3(0,0,0);
  }
  r4.w = cmp(0.00999999978 < r5.w);
  if (r4.w != 0) {
    r4.w = cmp(0 < cb2[22].w);
    r7.xyz = cmp(float3(0,0,0) < r4.xyz);
    r7.xyz = r7.xyz ? cb2[20].xyz : cb2[21].xyz;
    r7.xyz = -v1.xyz + r7.xyz;
    r7.xyz = r7.xyz / r4.xyz;
    r7.x = min(r7.x, r7.y);
    r7.x = min(r7.x, r7.z);
    r7.yzw = -cb2[22].xyz + v1.xyz;
    r7.xyz = r4.xyz * r7.xxx + r7.yzw;
    r7.xyz = r4.www ? r7.xyz : r4.xyz;
    r7.xyzw = t2.SampleLevel(s2_s, r7.xyz, 4.05000019).xyzw;
    r4.w = -1 + r7.w;
    r4.w = cb2[16].w * r4.w + 1;
    r4.w = max(0, r4.w);
    r4.w = log2(r4.w);
    r4.w = cb2[16].y * r4.w;
    r4.w = exp2(r4.w);
    r4.w = cb2[16].x * r4.w;
    r7.xyz = r4.www * r7.xyz;
    r6.yzw = r5.www * r7.xyz + r6.yzw;
  }
  r4.w = cmp(r6.x < 0.99000001);
  if (r4.w != 0) {
    r4.xyzw = t0.SampleLevel(s0_s, r4.xyz, 4.05000019).xyzw;
    r5.w = 1 + -r6.x;
    r4.w = -1 + r4.w;
    r4.w = cb0[3].w * r4.w + 1;
    r4.w = max(0, r4.w);
    r4.w = log2(r4.w);
    r4.w = cb0[3].y * r4.w;
    r4.w = exp2(r4.w);
    r4.w = cb0[3].x * r4.w;
    r4.xyz = r4.www * r4.xyz;
    r6.yzw = r5.www * r4.xyz + r6.yzw;
  }
  r3.w = r3.w * 0.5 + 0.0399999991;
  r3.w = 0.941176474 * r3.w;
  r4.xyz = r6.yzw * r3.www;
  r4.xyz = r5.xyz * r2.xyz + r4.xyz;
  r0.w = cb2[11].z * r0.w;
  r3.w = saturate(dot(r0.xyz, cb0[5].xyz));
  r0.w = r3.w * r0.w;
  r5.xyz = cb0[6].xyz * r0.www;
  r6.xyz = v5.xyz * r1.xxx + cb0[5].xyz;
  r0.w = dot(r6.xyz, r6.xyz);
  r0.w = max(1.17549435e-38, r0.w);
  r0.w = rsqrt(r0.w);
  r6.xyz = r6.xyz * r0.www;
  r0.w = saturate(dot(r0.xyz, r6.xyz));
  r1.x = saturate(dot(cb0[5].xyz, r6.xyz));
  r0.w = r0.w * r0.w;
  r0.w = r0.w * -0.9375 + 1.00001001;
  r1.x = r1.x * r1.x;
  r0.w = r0.w * r0.w;
  r1.x = max(0.100000001, r1.x);
  r0.w = r1.x * r0.w;
  r0.w = 3 * r0.w;
  r0.w = 0.0625 / r0.w;
  r6.xyz = r0.www * float3(0.0399999991,0.0399999991,0.0399999991) + r2.xyz;
  r0.w = min(cb2[11].y, cb0[10].x);
  r0.w = (int)r0.w;
  r1.x = saturate(r2.w * cb4[1284].x + cb4[1284].y);
  r7.xyz = float3(0,0,0);
  r2.w = 0;
  while (true) {
    r3.w = cmp((uint)r2.w >= (uint)r0.w);
    if (r3.w != 0) break;
    r3.w = (uint)r2.w >> 2;
    r4.w = (int)r2.w & 3;
    r3.w = dot(cb2[r3.w+12].xyzw, icb[r4.w+0].xyzw);
    r3.w = (int)r3.w;
    r8.xyz = -v1.xyz * cb1[r3.w+0].www + cb1[r3.w+0].xyz;
    r4.w = dot(r8.xyz, r8.xyz);
    r4.w = max(6.10351562e-05, r4.w);
    r5.w = rsqrt(r4.w);
    r9.xyz = r8.xyz * r5.www;
    r6.w = rcp(r4.w);
    r4.w = cb1[r3.w+512].x * r4.w;
    r4.w = -r4.w * r4.w + 1;
    r4.w = max(0, r4.w);
    r4.w = r4.w * r4.w;
    r4.w = r6.w * r4.w;
    r6.w = dot(cb1[r3.w+768].xyz, r9.xyz);
    r6.w = saturate(r6.w * cb1[r3.w+512].z + cb1[r3.w+512].w);
    r6.w = r6.w * r6.w;
    r4.w = r6.w * r4.w;
    r6.w = (int)cb4[r3.w+0].w;
    r7.w = cmp((int)r6.w >= 0);
    if (r7.w != 0) {
      r7.w = cmp(0 != cb4[r3.w+0].z);
      if (r7.w != 0) {
        r10.xyz = cmp(abs(r9.zzy) >= abs(r9.xyx));
        r7.w = r10.y ? r10.x : 0;
        r10.xyw = cmp(-r9.zyx < float3(0,0,0));
        r10.xy = r10.xy ? float2(5,3) : float2(4,2);
        r8.w = r10.w ? 1.000000 : 0;
        r8.w = r10.z ? r10.y : r8.w;
        r7.w = r7.w ? r10.x : r8.w;
        r8.w = trunc(cb4[r3.w+0].w);
        r7.w = r8.w + r7.w;
        r6.w = (int)r7.w;
      }
      r6.w = (uint)r6.w << 2;
      r10.xyzw = cb4[r6.w+257].xyzw * v1.yyyy;
      r10.xyzw = cb4[r6.w+256].xyzw * v1.xxxx + r10.xyzw;
      r10.xyzw = cb4[r6.w+258].xyzw * v1.zzzz + r10.xyzw;
      r10.xyzw = cb4[r6.w+259].xyzw + r10.xyzw;
      r10.xyz = r10.xyz / r10.www;
      r6.w = cmp(0.000000 != cb4[r3.w+0].y);
      if (r6.w != 0) {
        r11.xy = r10.xy * cb4[1285].zw + float2(0.5,0.5);
        r11.xy = floor(r11.xy);
        r11.zw = r10.xy * cb4[1285].zw + -r11.xy;
        r12.xyzw = float4(0.5,1,0.5,1) + r11.zzww;
        r13.xyzw = r12.xxzz * r12.xxzz;
        r12.xz = float2(0.0799999982,0.0799999982) * r13.yw;
        r13.xy = r13.xz * float2(0.5,0.5) + -r11.zw;
        r13.zw = float2(1,1) + -r11.zw;
        r14.xy = min(float2(0,0), r11.zw);
        r14.xy = -r14.xy * r14.xy + r13.zw;
        r11.zw = max(float2(0,0), r11.zw);
        r11.zw = -r11.zw * r11.zw + r12.yw;
        r14.xy = float2(1,1) + r14.xy;
        r11.zw = float2(1,1) + r11.zw;
        r15.xy = float2(0.159999996,0.159999996) * r13.xy;
        r13.xy = float2(0.159999996,0.159999996) * r13.zw;
        r14.xy = float2(0.159999996,0.159999996) * r14.xy;
        r16.xy = float2(0.159999996,0.159999996) * r11.zw;
        r11.zw = float2(0.159999996,0.159999996) * r12.yw;
        r15.z = r14.x;
        r15.w = r11.z;
        r13.z = r16.x;
        r13.w = r12.x;
        r17.xyzw = r15.zwxz + r13.zwxz;
        r14.z = r15.y;
        r14.w = r11.w;
        r16.z = r13.y;
        r16.w = r12.z;
        r12.xyz = r16.zyw + r14.zyw;
        r13.xyz = r13.xzw / r17.zwy;
        r13.xyz = float3(-2.5,-0.5,1.5) + r13.xyz;
        r14.xyz = r16.zyw / r12.xyz;
        r14.xyz = float3(-2.5,-0.5,1.5) + r14.xyz;
        r13.xyz = cb4[1285].xxx * r13.yxz;
        r14.xyz = cb4[1285].yyy * r14.xyz;
        r13.w = r14.x;
        r15.xyzw = r11.xyxy * cb4[1285].xyxy + r13.ywxw;
        r11.zw = r11.xy * cb4[1285].xy + r13.zw;
        r14.w = r13.y;
        r13.yw = r14.yz;
        r16.xyzw = r11.xyxy * cb4[1285].xyxy + r13.xyzy;
        r14.xyzw = r11.xyxy * cb4[1285].xyxy + r14.wywz;
        r13.xyzw = r11.xyxy * cb4[1285].xyxy + r13.xwzw;
        r18.xyzw = r17.zwyz * r12.xxxy;
        r19.xyzw = r17.xyzw * r12.yyzz;
        r6.w = r17.y * r12.z;
        r7.w = t4.SampleCmpLevelZero(s4_s, r15.xy, r10.z).x;
        r8.w = t4.SampleCmpLevelZero(s4_s, r15.zw, r10.z).x;
        r8.w = r18.y * r8.w;
        r7.w = r18.x * r7.w + r8.w;
        r8.w = t4.SampleCmpLevelZero(s4_s, r11.zw, r10.z).x;
        r7.w = r18.z * r8.w + r7.w;
        r8.w = t4.SampleCmpLevelZero(s4_s, r14.xy, r10.z).x;
        r7.w = r18.w * r8.w + r7.w;
        r8.w = t4.SampleCmpLevelZero(s4_s, r16.xy, r10.z).x;
        r7.w = r19.x * r8.w + r7.w;
        r8.w = t4.SampleCmpLevelZero(s4_s, r16.zw, r10.z).x;
        r7.w = r19.y * r8.w + r7.w;
        r8.w = t4.SampleCmpLevelZero(s4_s, r14.zw, r10.z).x;
        r7.w = r19.z * r8.w + r7.w;
        r8.w = t4.SampleCmpLevelZero(s4_s, r13.xy, r10.z).x;
        r7.w = r19.w * r8.w + r7.w;
        r8.w = t4.SampleCmpLevelZero(s4_s, r13.zw, r10.z).x;
        r6.w = r6.w * r8.w + r7.w;
      } else {
        r6.w = t4.SampleCmpLevelZero(s4_s, r10.xy, r10.z).x;
      }
      r7.w = -cb4[r3.w+0].x + 1;
      r6.w = r6.w * cb4[r3.w+0].x + r7.w;
      r7.w = cmp(0 >= r10.z);
      r8.w = cmp(r10.z >= 1);
      r7.w = (int)r7.w | (int)r8.w;
      r6.w = r7.w ? 1 : r6.w;
    } else {
      r6.w = 1;
    }
    r7.w = 1 + -r6.w;
    r6.w = r1.x * r7.w + r6.w;
    r4.w = r6.w * r4.w;
    r6.w = saturate(dot(r0.xyz, r9.xyz));
    r4.w = r6.w * r4.w;
    r10.xyz = cb1[r3.w+256].xyz * r4.www;
    r8.xyz = r8.xyz * r5.www + r3.xyz;
    r3.w = dot(r8.xyz, r8.xyz);
    r3.w = max(1.17549435e-38, r3.w);
    r3.w = rsqrt(r3.w);
    r8.xyz = r8.xyz * r3.www;
    r3.w = saturate(dot(r0.xyz, r8.xyz));
    r4.w = saturate(dot(r9.xyz, r8.xyz));
    r3.w = r3.w * r3.w;
    r3.w = r3.w * -0.9375 + 1.00001001;
    r4.w = r4.w * r4.w;
    r3.w = r3.w * r3.w;
    r4.w = max(0.100000001, r4.w);
    r3.w = r4.w * r3.w;
    r3.w = 3 * r3.w;
    r3.w = 0.0625 / r3.w;
    r8.xyz = r3.www * float3(0.0399999991,0.0399999991,0.0399999991) + r2.xyz;
    r7.xyz = r8.xyz * r10.xyz + r7.xyz;
    r2.w = (int)r2.w + 1;
  }
  r0.xyz = r6.xyz * r5.xyz + r4.xyz;
  r0.xyz = r0.xyz + r7.xyz;
  o0.xyz = cb5[3].xyz * r1.yzw + r0.xyz;
  if(injectedData.isClamped != 0.f){
  o0 = saturate(o0);
  }
  return;
}