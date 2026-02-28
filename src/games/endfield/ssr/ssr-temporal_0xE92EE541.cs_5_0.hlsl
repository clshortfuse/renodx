
#include "../shared.h"

RWTexture2D<unorm float4> u0 : register(u0);
RWTexture2D<unorm float4> u1 : register(u1);
RWTexture2D<unorm float4> u2 : register(u2);

Texture2D<float4> t5 : register(t5);

Texture3D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerComparisonState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[5];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[6];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[234];
}

// 3Dmigoto declarations
#define cmp -

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (int2)vThreadID.xy;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.zw = cb1[0].zw * r0.xy;
  r1.z = t0.SampleLevel(s0_s, r0.zw, 0).x;
  r2.x = cb0[84].z * r1.z + cb0[84].w;
  r1.xy = r0.zw * float2(2,2) + float2(-1,-1);
  r3.xyzw = cb0[13].xyzw * r1.yyyy;
  r3.xyzw = cb0[12].xyzw * r1.xxxx + r3.xyzw;
  r3.xyzw = cb0[14].xyzw * r1.zzzz + r3.xyzw;
  r3.xyzw = cb0[15].xyzw + r3.xyzw;
  r3.xyz = r3.xyz / r3.www;
  r2.yzw = t1.SampleLevel(s0_s, r0.zw, 0).xyz;
  r2.yz = r2.yz * float2(2,2) + float2(-1,-1);
  r4.x = dot(float2(1,1), abs(r2.yz));
  r4.y = 1 + -r4.x;
  r4.w = cmp(r4.y < 0);
  r5.xy = cmp(r2.yz >= float2(0,0));
  r5.zw = float2(1,1) + -abs(r2.zy);
  r5.xy = r5.xy ? float2(1,1) : float2(-1,-1);
  r5.xy = r5.zw * r5.xy;
  r4.xz = r4.ww ? r5.xy : r2.yz;
  r2.y = dot(r4.xyz, r4.xyz);
  r2.y = rsqrt(r2.y);
  r4.xzw = r4.xyz * r2.yyy;
  r5.xy = t5.SampleLevel(s1_s, r0.zw, 0).xy;
  r6.xyz = cb0[5].xyz * -r3.yyy;
  r6.xyz = cb0[4].xyz * r3.xxx + r6.xyz;
  r6.xyz = cb0[6].xyz * r3.zzz + r6.xyz;
  r6.xyz = cb0[7].xyz + r6.xyz;
  r5.zw = cmp(float2(0.5,0.5) < cb0[226].xy);
  if (r5.z != 0) {
    r2.z = abs(r4.x) + abs(r4.z);
    r2.z = r2.z + abs(r4.w);
    r2.z = 1 / r2.z;
    r7.xyz = abs(r4.xzw) * r2.zzz;
    r8.xyzw = float4(0,1,0.707105994,0) * r7.xxyy;
    r7.xyw = r8.xxy + r8.zwz;
    r7.xyz = r7.zzz * float3(1,0,0) + r7.xyw;
    r8.xyz = cb0[229].xxx * r6.xyz;
    r2.z = t4.SampleLevel(s2_s, r8.xyz, 0).x;
    r2.z = r2.z * 2 + -1;
    r7.xyz = r7.xyz * r2.zzz;
    r2.z = abs(r4.z);
    r2.z = -0.699999988 + r2.z;
    r2.z = saturate(4 * r2.z);
    r5.z = r2.z * -2 + 3;
    r2.z = r2.z * r2.z;
    r2.z = r5.z * r2.z;
    r5.z = cb0[229].y + -cb0[229].z;
    r2.z = r2.z * r5.z + cb0[229].z;
    r7.xyz = r7.xyz * r2.zzz;
  } else {
    r7.xyz = float3(0,0,0);
  }
  r2.y = -r4.y * r2.y + -0.200000003;
  if (r5.w != 0) {
    r8.xyz = cb0[233].zzz * r4.xzw;
    r9.xyz = cb0[225].yyy * float3(0,1,0);
    r8.xyz = r8.xyz * cb0[225].xxx + r9.xyz;
    r2.z = max(0, -r4.z);
    r2.z = min(0.899999976, r2.z);
    r2.z = 1 + -r2.z;
    r4.y = saturate(-10 * r2.y);
    r5.z = r4.y * -2 + 3;
    r4.y = r4.y * r4.y;
    r4.y = r5.z * r4.y;
    r4.y = max(0.100000001, r4.y);
    r4.y = min(1, r4.y);
    r2.z = r4.y * r2.z;
    r8.xyz = r8.xyz * r2.zzz + r6.xyz;
    r7.xyz = r8.xyz + r7.xyz;
    r8.xyz = cb2[1].xyz * r7.yyy;
    r7.xyw = cb2[0].xyz * r7.xxx + r8.xyz;
    r7.xyz = cb2[2].xyz * r7.zzz + r7.xyw;
    r7.xyz = cb2[3].xyz + r7.xyz;
    r8.x = r7.x * 0.5 + cb2[4].x;
    r2.z = r7.y * 0.5 + 0.5;
    r8.z = cb2[4].y + -r2.z;
    r5.zw = float2(0.5,1) + r8.xz;
    r2.z = max(0.00048828125, r7.z);
    r2.z = t3.SampleCmpLevelZero(s3_s, r5.zw, r2.z).x;
  } else {
    r2.z = 1;
  }
  r5.zw = -cb0[44].xz + r6.xz;
  r4.y = saturate(r4.z);
  r6.x = -cb0[230].w + 1;
  r4.y = r4.y * r6.x + cb0[230].w;
  r6.x = r4.y * r2.z;
  r6.y = cb0[222].w * 0.0500000119;
  r5.z = max(abs(r5.z), abs(r5.w));
  r5.z = -cb0[222].w * 0.699999988 + r5.z;
  r5.w = 1 / r6.y;
  r5.z = saturate(r5.z * r5.w);
  r5.w = r5.z * -2 + 3;
  r5.z = r5.z * r5.z;
  r5.z = r5.w * r5.z;
  r2.z = -r4.y * r2.z + 1;
  r2.z = r5.z * r2.z + r6.x;
  r2.z = 1 + -r2.z;
  r4.y = r5.x * r2.z;
  r5.z = 1 + -r2.w;
  r5.w = saturate(r5.z * cb0[222].z + cb0[222].y);
  r5.w = r5.w * -0.299999952 + 0.899999976;
  r6.x = sqrt(r5.z);
  r5.w = r6.x + r5.w;
  r5.w = -0.600000024 + r5.w;
  r5.w = min(1, r5.w);
  r5.w = max(r5.w, r5.z);
  r5.w = min(0.99000001, r5.w);
  r6.x = saturate(-cb0[222].x + 2);
  r6.x = cb0[222].x * r6.x;
  r2.y = saturate(3.33333325 * r2.y);
  r6.y = r2.y * -2 + 3;
  r2.y = r2.y * r2.y;
  r2.y = -r6.y * r2.y + 1;
  r2.y = r6.x * r2.y;
  r2.z = -r5.x * r2.z + 1;
  r2.y = r2.y * r2.z;
  r2.z = r5.w + -r5.z;
  r2.y = r2.y * r2.z + r5.z;
  r2.y = 1 + -r2.y;
  r2.z = min(1, r2.y);
  r5.x = min(r5.x, r5.y);
  r2.y = r2.y + -r2.z;
  r2.y = r5.x * r2.y + r2.z;
  r2.z = r2.w + -r2.y;
  r2.y = r4.y * r2.z + r2.y;
  r2.z = r2.y * r2.y;
  r2.z = r2.z * r2.z;
  r5.xyz = cb0[1].xyz * r4.zzz;
  r5.xyz = cb0[0].xyz * r4.xxx + r5.xyz;
  r5.xyz = cb0[2].xyz * r4.www + r5.xyz;
  r6.xy = float2(-0.0700000003,0.0199999996) / r2.xx;
  r4.y = 1.44269502 * r6.x;
  r4.y = exp2(r4.y);
  r4.y = r4.y + r4.y;
  r4.y = max(0.125, r4.y);
  r4.y = min(1, r4.y);
  r4.y = cb1[3].x * r4.y;
  r4.y = ceil(r4.y);
  r4.y = max((shader_injection.improved_ssr >= 0.5f) ? 256 : 32, r4.y);
  r2.w = cmp(r2.w >= 0.300000012);
  r5.w = 0.125 * r4.y;
  r2.w = r2.w ? r5.w : r4.y;
  r3.w = -r3.y;
  r3.y = dot(r3.xzw, r3.xzw);
  r3.y = rsqrt(r3.y);
  r3.xyz = r3.xwz * r3.yyy;
  r3.w = dot(r3.xyz, r5.xyz);
  r4.y = r3.w + r3.w;
  r3.xyz = r5.xyz * -r4.yyy + r3.xyz;
  r5.xyzw = cb0[9].xyzw * r3.yyyy;
  r5.xyzw = cb0[8].xyzw * r3.xxxx + r5.xyzw;
  r5.xyzw = cb0[10].xyzw * r3.zzzz + r5.xyzw;
  r1.w = 1;
  r5.xyzw = r5.xyzw * float4(1,-1,1,1) + r1.xyzw;
  r3.xyz = r5.xyz / r5.www;
  r3.xyz = r3.xyz + -r1.xyz;
  r1.w = dot(r3.xy, r3.xy);
  r1.w = sqrt(r1.w);
  r4.y = 0.5 * r1.w;
  r5.xy = r1.xy * r4.yy + r3.xy;
  r5.xy = -r1.ww * float2(0.5,0.5) + abs(r5.xy);
  r5.xy = max(float2(0,0), r5.xy);
  r5.xy = r5.xy / abs(r3.xy);
  r5.xy = float2(1,1) + -r5.xy;
  r1.w = min(r5.x, r5.y);
  r1.w = r1.w / r4.y;
  r3.xyz = r3.xyz * r1.www;
  r1.w = abs(r3.z) / r2.w;
  r1.w = max(9.99999975e-05, r1.w);
  r4.y = 1 / r2.w;
  r3.xyz = float3(0.5,0.5,1) * r3.xyz;
  r3.xyz = r3.xyz * r4.yyy;
  r5.xy = cb1[0].xy * r3.xy;
  r4.y = max(abs(r5.x), abs(r5.y));
  r5.x = cmp(r4.y < 1);
  r4.y = 0.00100000005 + r4.y;
  r4.y = 1 / r4.y;
  r5.y = trunc(cb1[1].x);
  r0.xy = r5.yy * float2(2.08299994,4.8670001) + r0.xy;
  r0.x = dot(r0.xy, float2(0.0671105608,0.00583714992));
  r0.x = frac(r0.x);
  r0.x = 52.9829178 * r0.x;
  r0.x = frac(r0.x);
  r0.x = r5.x ? r4.y : r0.x;
  r5.xyz = r1.xyz * float3(0.5,0.5,1) + float3(0.5,0.5,0);
  r5.xyz = r3.xyz * r0.xxx + r5.xyz;
  r0.x = t0.SampleLevel(s0_s, r5.xy, 0).x;
  r0.x = r5.z + -r0.x;
  r6.xzw = float3(0,0,0);
  r7.xyz = float3(0,0,0);
  r8.xyz = r5.xyz;
  r0.y = 0;
  r4.y = 0;
  r5.w = r0.x;
  while (true) {
    r7.w = cmp(r4.y < r2.w);
    if (r7.w != 0) {
      r9.xyzw = r3.xyxy * float4(1,1,2,2) + r8.xyxy;
      r10.xyzw = r3.xyxy * float4(3,3,4,4) + r8.xyxy;
      r11.xyzw = r3.zzzz * float4(1,2,3,4) + r8.zzzz;
      r12.x = t0.SampleLevel(s0_s, r9.xy, 0).x;
      r12.y = t0.SampleLevel(s0_s, r9.zw, 0).x;
      r12.z = t0.SampleLevel(s0_s, r10.xy, 0).x;
      r12.w = t0.SampleLevel(s0_s, r10.zw, 0).x;
      r9.xyzw = -r12.xyzw + r11.xyzw;
      r10.xyzw = r9.xyzw + r1.wwww;
      r10.xyzw = cmp(abs(r10.xyzw) < r1.wwww);
      r11.xy = (int2)r10.zw | (int2)r10.xy;
      r7.w = (int)r11.y | (int)r11.x;
      if (r7.w != 0) {
        r11.xy = r10.zz ? r9.zy : r9.wz;
        r9.yz = r10.yy ? r9.yx : r11.xy;
        r7.w = r10.x ? r9.x : r9.y;
        r8.w = r10.x ? r5.w : r9.z;
        r9.x = r10.z ? 2 : 3;
        r9.x = r10.y ? 1 : r9.x;
        r9.x = r10.x ? 0 : r9.x;
        r7.w = r8.w + -r7.w;
        r7.w = saturate(r8.w / r7.w);
        r7.w = r9.x + r7.w;
        r9.xyz = r3.xyz * r7.www + r8.xyz;
        r0.y = -1;
        r7.xyz = r9.xyz;
        break;
      }
      r8.xyz = r3.xyz * float3(4,4,4) + r8.xyz;
      r4.y = 4 + r4.y;
      r6.xzw = r8.xyz;
      r0.y = 0;
      r5.w = r9.w;
      continue;
    } else {
      r7.xyz = r6.xzw;
      r0.y = 0;
      break;
    }
    r0.y = 0;
  }
  if (r0.y != 0) {
    r0.x = max(r7.x, r7.y);
    r0.x = 1 + -r0.x;
    r0.y = min(r7.x, r7.y);
    r0.x = min(r0.x, r0.y);
    r3.xy = t2.SampleLevel(s0_s, r7.xy, 0).xy;
    r5.xy = abs(r3.xy) * float2(2,2) + float2(-1,-1);
    r5.xy = r5.xy * r5.xy;
    r5.xy = r5.xy * r5.xy;
    r3.xy = float2(-0.5,-0.5) + r3.xy;
    r5.zw = cmp(float2(0,0) < r3.xy);
    r3.xy = cmp(r3.xy < float2(0,0));
    r3.xy = (int2)-r5.zw + (int2)r3.xy;
    r3.xy = (int2)r3.xy;
    r3.xy = r5.xy * r3.xy;
    r0.y = -cb1[2].z + 1;
    r5.xy = r3.xy * r0.yy;
    r1.w = cmp(cb1[1].y < r0.x);
    r0.x = saturate(r0.x / cb1[1].y);
    r0.x = r1.w ? 1 : r0.x;
    r1.w = saturate(abs(r3.w) * cb1[1].z + cb1[1].w);
    r1.w = 1 + -r1.w;
    r0.x = r1.w * r0.x;
    r1.w = cmp(r2.y < 0.100000001);
    r2.x = 1 / r2.x;
    r2.x = 100 + -r2.x;
    r2.x = saturate(0.100000001 * r2.x);
    r1.w = r1.w ? 1 : r2.x;
    r0.x = r1.w * r0.x;
    r0.zw = -r3.xy * r0.yy + r7.xy;
  } else {
    r5.xy = float2(0,0);
    r0.x = 0;
  }
  r2.xy = t2.SampleLevel(s0_s, r0.zw, 0).xy;
  r3.xy = abs(r2.xy) * float2(2,2) + float2(-1,-1);
  r3.xy = r3.xy * r3.xy;
  r0.y = 2 / r2.z;
  r0.y = -1 + r0.y;
  r0.y = 1 / r0.y;
  r0.y = -2.03504682 * r0.y;
  r0.y = exp2(r0.y);
  r1.w = 1 + -r0.y;
  r1.w = sqrt(r1.w);
  r2.w = r0.y * -0.0187292993 + 0.0742610022;
  r2.w = r2.w * r0.y + -0.212114394;
  r0.y = r2.w * r0.y + 1.57072878;
  r0.y = r0.y * r1.w;
  r8.xyzw = cb0[25].xyzw * r1.yyyy;
  r8.xyzw = cb0[24].xyzw * r1.xxxx + r8.xyzw;
  r1.xyzw = cb0[26].xyzw * r1.zzzz + r8.xyzw;
  r1.xyzw = cb0[27].xyzw + r1.xyzw;
  r1.xyzw = r1.xyzw / r1.wwww;
  r3.zw = r7.xy * float2(2,2) + float2(-1,-1);
  r8.xyzw = cb0[25].xyzw * r3.wwww;
  r8.xyzw = cb0[24].xyzw * r3.zzzz + r8.xyzw;
  r7.xyzw = cb0[26].xyzw * r7.zzzz + r8.xyzw;
  r7.xyzw = cb0[27].xyzw + r7.xyzw;
  r6.xzw = cb0[44].xyz + -r1.xyz;
  r2.w = dot(r6.xzw, r6.xzw);
  r3.z = rsqrt(r2.w);
  r8.xyz = r6.xzw * r3.zzz;
  r2.w = sqrt(r2.w);
  r3.w = cmp(abs(r4.w) < 0.999000013);
  r9.z = r3.w ? 0 : 1;
  r9.y = r3.w ? 1.000000 : 0;
  r9.x = 0;
  r10.xyz = r9.xyz * r4.xzw;
  r9.xyz = r9.zxy * r4.zwx + -r10.xyz;
  r3.w = dot(r9.xyz, r9.xyz);
  r3.w = rsqrt(r3.w);
  r9.xyz = r9.xyz * r3.www;
  r7.xyzw = r7.xyzw / r7.wwww;
  r1.xyzw = r7.xyzw + -r1.xyzw;
  r1.x = dot(r1.xyzw, r1.xyzw);
  r1.x = sqrt(r1.x);
  r1.yzw = r9.zxy * r8.xyz;
  r1.yzw = r9.yzx * r8.yzx + -r1.yzw;
  sincos(r0.y, r7.x, r10.x);
  r7.yzw = -r8.xyz * r2.www + cb0[44].xyz;
  r10.yzw = r9.xyz * r4.xzw;
  r4.xyz = r4.wxz * r9.yzx + -r10.yzw;
  r9.xyz = r4.xyz * r8.xyz;
  r4.xyz = r4.zxy * r8.yzx + -r9.xyz;
  r0.y = r1.x + r2.w;
  r9.xyz = r8.xyz * r0.yyy;
  r10.yzw = cb0[21].xyw * -r9.yyy;
  r9.xyw = cb0[20].xyw * -r9.xxx + r10.yzw;
  r9.xyz = cb0[22].xyw * -r9.zzz + r9.xyw;
  r9.xyz = cb0[23].xyw + r9.xyz;
  r5.zw = r9.xy / r9.zz;
  r5.zw = r5.zw * float2(0.5,0.5) + float2(0.5,0.5);
  r5.zw = cb1[0].xy * r5.zw;
  r0.y = dot(r1.zwy, -r8.xyz);
  r9.xyz = r1.zwy * r0.yyy;
  r10.yzw = -r6.xzw * r3.zzz + -r9.xyz;
  r9.xyz = r10.xxx * r10.yzw + r9.xyz;
  r10.yzw = r1.yzw * -r8.yzx;
  r1.yzw = r1.wyz * -r8.zxy + -r10.yzw;
  r1.yzw = r1.yzw * r7.xxx + r9.xyz;
  r1.yzw = r1.yzw * r1.xxx + r7.yzw;
  r1.yzw = -cb0[44].xyz + r1.yzw;
  r9.xyz = cb0[21].xyw * r1.zzz;
  r9.xyz = cb0[20].xyw * r1.yyy + r9.xyz;
  r1.yzw = cb0[22].xyw * r1.www + r9.xyz;
  r1.yzw = cb0[23].xyw + r1.yzw;
  r0.y = dot(r4.yzx, -r8.xyz);
  r9.xyz = r4.yzx * r0.yyy;
  r6.xzw = -r6.xzw * r3.zzz + -r9.xyz;
  r6.xzw = r10.xxx * r6.xzw + r9.xyz;
  r9.xyz = r4.xyz * -r8.yzx;
  r4.xyz = r4.zxy * -r8.zxy + -r9.xyz;
  r4.xyz = r4.xyz * r7.xxx + r6.xzw;
  r4.xyz = r4.xyz * r1.xxx + r7.yzw;
  r4.xyz = -cb0[44].xyz + r4.xyz;
  r6.xzw = cb0[21].xyw * r4.yyy;
  r4.xyw = cb0[20].xyw * r4.xxx + r6.xzw;
  r4.xyz = cb0[22].xyw * r4.zzz + r4.xyw;
  r4.xyz = cb0[23].xyw + r4.xyz;
  
  // Write UV coords to u0
  u0[vThreadID.xy] = r0.zwzz;
  
  r0.yz = r3.xy * r3.xy;
  r2.xy = float2(-0.5,-0.5) + r2.xy;
  r3.xy = cmp(float2(0,0) < r2.xy);
  r2.xy = cmp(r2.xy < float2(0,0));
  r2.xy = (int2)-r3.xy + (int2)r2.xy;
  r2.xy = (int2)r2.xy;
  r0.yz = r0.yz * r2.xy + r5.xy;
  r0.yz = cb0[82].xy * r0.yz;
  r0.y = dot(r0.yz, r0.yz);
  r0.y = sqrt(r0.y);
  r0.z = log2(r6.y);
  r0.z = saturate(r0.z * 0.693147182 + 0.00999999978);
  r0.y = -r0.y * r0.z;
  r0.y = 1.44269502 * r0.y;
  r3.xzw = exp2(r0.yyy);
  r0.y = cmp(9.99999975e-05 >= r2.z);
  r0.zw = r1.yz / r1.ww;
  r0.zw = r0.zw * float2(0.5,0.5) + float2(0.5,0.5);
  r0.zw = -r0.zw * cb1[0].xy + r5.zw;
  r0.z = dot(r0.zw, r0.zw);
  r1.xy = r4.xy / r4.zz;
  r1.xy = r1.xy * float2(0.5,0.5) + float2(0.5,0.5);
  r1.xy = -r1.xy * cb1[0].xy + r5.zw;
  r0.w = dot(r1.xy, r1.xy);
  r0.z = r0.z + r0.w;
  r0.z = sqrt(r0.z);
  r0.z = 0.5 * r0.z;
  r0.z = log2(r0.z);
  r0.z = max(0, r0.z);
  r0.z = min(cb1[5].y, r0.z);
  r0.z = r0.z / cb1[5].y;
  r3.y = r0.y ? 0 : r0.z;

  // Write blend weights to u1
  // r3.x, r3.z = temporal confidence (how much history to blend in)
  // r3.y = mip/blur level (controls spatial denoiser blur radius)
  // r3.w = same as r3.x
  //
  // Vanilla:  unchanged
  // Improved: keep temporal confidence for anti-firefly, disable spatial blur
  //           on smooth surfaces but retain it for rough ones (wood, stone)

  if (shader_injection.improved_ssr >= 0.5f) {
    float mip_threshold = 0.25f;
    float adjusted_mip = saturate((r3.y - mip_threshold) / (1.0f - mip_threshold));
    u1[vThreadID.xy] = float4(r3.x, adjusted_mip, r3.z, r3.x);
  } else {
    u1[vThreadID.xy] = r3.xyzw;
  }

  u2[vThreadID.xy] = r0.xxxx;
}