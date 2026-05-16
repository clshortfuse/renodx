#include "../shared.h"

float cmp(bool value) { return value ? -1.0f : 0.0f; }
float2 cmp(bool2 value) { return float2(cmp(value.x), cmp(value.y)); }
float3 cmp(bool3 value) { return float3(cmp(value.x), cmp(value.y), cmp(value.z)); }
float4 cmp(bool4 value) { return float4(cmp(value.x), cmp(value.y), cmp(value.z), cmp(value.w)); }

float select_nonzero(float condition, float when_true, float when_false) {
  return condition != 0.0f ? when_true : when_false;
}
float2 select_nonzero(float2 condition, float2 when_true, float2 when_false) {
  return float2(select_nonzero(condition.x, when_true.x, when_false.x),
                select_nonzero(condition.y, when_true.y, when_false.y));
}
float3 select_nonzero(float3 condition, float3 when_true, float3 when_false) {
  return float3(select_nonzero(condition.x, when_true.x, when_false.x),
                select_nonzero(condition.y, when_true.y, when_false.y),
                select_nonzero(condition.z, when_true.z, when_false.z));
}
float4 select_nonzero(float4 condition, float4 when_true, float4 when_false) {
  return float4(select_nonzero(condition.x, when_true.x, when_false.x),
                select_nonzero(condition.y, when_true.y, when_false.y),
                select_nonzero(condition.z, when_true.z, when_false.z),
                select_nonzero(condition.w, when_true.w, when_false.w));
}

cbuffer cb0 : register(b0)
{
  float4 cb0[238];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[6];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[5];
}

SamplerState s0_s : register(s0);

SamplerState s1_s : register(s1);

SamplerState s2_s : register(s2);

SamplerComparisonState s3_s : register(s3);

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture2D<uint4> t5 : register(t5);

Texture2D<float4> t6 : register(t6);

Texture3D<float4> t7 : register(t7);

Texture2D<float4> t8 : register(t8);

Texture2D<float4> t9 : register(t9);

RWTexture2D<unorm float4> u0 : register(u0);

RWTexture2D<unorm float4> u1 : register(u1);

RWTexture2D<unorm float4> u2 : register(u2);

[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0 = 0;
  float4 r1 = 0;
  float4 r2 = 0;
  float4 r3 = 0;
  float4 r4 = 0;
  float4 r5 = 0;
  float4 r6 = 0;
  float4 r7 = 0;
  float4 r8 = 0;
  float4 r9 = 0;
  float4 r10 = 0;
  float4 r11 = 0;
  float4 r12 = 0;
  float4 r13 = 0;
  r0.xy = float2(vThreadID.xy);
  r0.xy = r0.xy + float2(0.500000, 0.500000);
  r0.zw = r0.xy * cb1[0].zw;
  r1.xy = r0.zw * float2(2.000000, 2.000000) + float2(-1.000000, -1.000000);
  r2.x = t0.SampleLevel(s0_s, r0.zw, 0.000000).x;
  r3.xyzw = r1.xxxx * cb0[24].xyzw;
  r4.xyzw = cb0[25].xyzw * -r1.yyyy + r3.xyzw;
  r2.xyzw = cb0[26].xyzw * r2.xxxx + r4.xyzw;
  r2.xyzw = r2.xyzw + cb0[27].xyzw;
  r1.z = t1.SampleLevel(s0_s, r0.zw, 0.000000).x;
  r5.x = cb0[84].z * r1.z + cb0[84].w;
  r4.xyzw = cb0[26].xyzw * r1.zzzz + r4.xyzw;
  r4.xyzw = r4.xyzw + cb0[27].xyzw;
  r6.xyzw = r1.yyyy * cb0[13].xyzw;
  r6.xyzw = cb0[12].xyzw * r1.xxxx + r6.xyzw;
  r6.xyzw = cb0[14].xyzw * r1.zzzz + r6.xyzw;
  r6.xyzw = r6.xyzw + cb0[15].xyzw;
  r6.xyz = r6.xyz / r6.www;
  r5.yzw = t2.SampleLevel(s0_s, r0.zw, 0.000000).xyz;
  r7.xyz = t3.SampleLevel(s0_s, r0.zw, 0.000000).xyz;
  r2.xyz = r2.xyz / r2.www;
  r4.xyz = r4.xyz / r4.www;
  r2.xyz = r2.xyz + -r4.xyz;
  r2.x = dot(r2.xyz, r2.xyz);
  r2.x = sqrt(r2.x);
  r2.x = r2.x * 10.000000;
  r2.x = min(r2.x, 1.000000);
  r2.yzw = -r5.yzw + r7.xyz;
  r2.xyz = r2.xxx * r2.yzw + r5.yzw;
  r2.xy = r2.xy * float2(2.000000, 2.000000) + float2(-1.000000, -1.000000);
  r2.w = dot(float2(1.000000, 1.000000), abs(r2.xy));
  r4.y = -r2.w + 1.000000;
  r2.w = cmp(r4.y < 0.000000);
  r5.yz = cmp(r2.xy >= float2(0.000000, 0.000000));
  r7.xy = -abs(r2.yx) + float2(1.000000, 1.000000);
  r5.yz = select_nonzero(r5.yz, float2(1.000000, 1.000000), float2(-1.000000, -1.000000));
  r5.yz = r5.yz * r7.xy;
  r4.xz = select_nonzero(r2.ww, r5.yz, r2.xy);
  r2.x = dot(r4.xyz, r4.xyz);
  r2.x = rsqrt(r2.x);
  r4.xzw = r2.xxx * r4.xyz;
  r2.yw = t9.SampleLevel(s1_s, r0.zw, 0.000000).xy;
  r5.yzw = -r6.yyy * cb0[5].xyz;
  r5.yzw = cb0[4].xyz * r6.xxx + r5.yzw;
  r5.yzw = cb0[6].xyz * r6.zzz + r5.yzw;
  r5.yzw = r5.yzw + cb0[7].xyz;
  r7.xy = cmp(float2(0.500000, 0.500000) < cb0[230].xy);
  if (r7.x != 0) {
  r7.x = abs(r4.z) + abs(r4.x);
  r7.x = abs(r4.w) + r7.x;
  r7.x = 1.000000 / r7.x;
  r7.xzw = abs(r4.xzw) * r7.xxx;
  r8.xyz = r5.yzw * cb0[233].xxx;
  r8.x = t7.SampleLevel(s2_s, r8.xyz, 0.000000).x;
  r9.xyzw = r7.xxzz * float4(0.000000, 1.000000, 0.707106, 0.000000);
  r8.yzw = r9.zwz + r9.xxy;
  r7.xzw = r7.www * float3(1.000000, 0.000000, 0.000000) + r8.yzw;
  r8.y = r8.x * 2.000000 + -1.000000;
  r7.xzw = r7.xzw * r8.yyy;
  r8.y = abs(r4.z);
  r8.y = r8.y + -0.700000;
  r8.y = saturate(r8.y * 4.000000);
  r8.z = r8.y * -2.000000 + 3.000000;
  r8.y = r8.y * r8.y;
  r8.y = r8.y * r8.z;
  r8.z = -cb0[233].z + cb0[233].y;
  r8.y = r8.y * r8.z + cb0[233].z;
  r7.xzw = r7.xzw * r8.yyy;
  } else {
  r7.xzw = float3(0, 0, 0);
  r8.x = 0;
  }
  if (r7.y != 0) {
  r8.yzw = r4.xzw * cb0[237].zzz;
  r9.xyz = float3(0.000000, 1.000000, 0.000000) * cb0[229].yyy;
  r8.yzw = r8.yzw * cb0[229].xxx + r9.xyz;
  r7.y = max(-r4.z, 0.000000);
  r7.y = min(r7.y, 0.900000);
  r7.y = -r7.y + 1.000000;
  r2.x = -r4.y * r2.x + -0.200000;
  r2.x = saturate(r2.x * -10.000000);
  r4.y = r2.x * -2.000000 + 3.000000;
  r2.x = r2.x * r2.x;
  r2.x = r2.x * r4.y;
  r2.x = max(r2.x, 0.100000);
  r2.x = min(r2.x, 1.000000);
  r2.x = r2.x * r7.y;
  r8.yzw = r8.yzw * r2.xxx + r5.yzw;
  r7.xyz = r7.xzw + r8.yzw;
  r8.yzw = r7.yyy * cb2[1].xyz;
  r7.xyw = cb2[0].xyz * r7.xxx + r8.yzw;
  r7.xyz = cb2[2].xyz * r7.zzz + r7.xyw;
  r7.xyz = r7.xyz + cb2[3].xyz;
  r9.x = r7.x * 0.500000 + cb2[4].x;
  r2.x = r7.y * 0.500000 + 0.500000;
  r9.z = -r2.x + cb2[4].y;
  r7.xy = r9.xz + float2(0.500000, 1.000000);
  r2.x = max(r7.z, 0.000488);
  r2.x = t6.SampleCmpLevelZero(s3_s, r7.xy, r2.x).x;
  } else {
  r2.x = 1.000000;
  }
  r4.y = saturate(r4.z);
  r7.xy = r5.yw + -cb0[44].xz;
  r7.z = 1.000000 + -cb0[234].w;
  r7.z = r4.y * r7.z + cb0[234].w;
  r7.w = r2.x * r7.z;
  r8.y = 0.050000 * cb0[226].w;
  r7.x = max(abs(r7.y), abs(r7.x));
  r7.x = -cb0[226].w * 0.700000 + r7.x;
  r7.y = 1.000000 / r8.y;
  r7.x = saturate(r7.y * r7.x);
  r7.y = r7.x * -2.000000 + 3.000000;
  r7.x = r7.x * r7.x;
  r7.x = r7.x * r7.y;
  r2.x = -r7.z * r2.x + 1.000000;
  r2.x = r7.x * r2.x + r7.w;
  r7.x = -r2.x + 1.000000;
  r7.y = r2.y * r7.x;
  r7.z = cmp(0.000488 < cb0[235].y);
  if (r7.z != 0) {
  r8.yzw = r5.yzw + -cb0[44].xyz;
  r5.z = dot(r8.yzw, r8.yzw);
  r5.z = sqrt(r5.z);
  r5.z = r5.z + -15.000000;
  r5.z = saturate(r5.z * 0.015000);
  r5.z = -r5.z + 1.000000;
  r7.z = min(0.990000, cb0[232].w);
  r7.w = cb0[227].z * 0.300000 + 0.686000;
  r7.w = max(r7.w, 0.970000);
  r8.y = -r7.w + 0.990000;
  r7.w = r4.y + -r7.w;
  r8.y = 1.000000 / r8.y;
  r7.w = saturate(r7.w * r8.y);
  r8.y = r7.w * -2.000000 + 3.000000;
  r7.w = r7.w * r7.w;
  r4.y = r4.y + -0.991000;
  r4.y = r4.y * 111.111069;
  r4.y = max(r4.y, 0.000000);
  r8.z = r4.y * -2.000000 + 3.000000;
  r4.y = r4.y * r4.y;
  r4.y = r4.y * r8.z;
  r8.z = r8.x * 0.200000 + 0.800000;
  r8.z = cmp(r8.z >= 0.618000);
  r8.z = asfloat(asuint(r8.z) & 0x3f800000u);
  r4.y = r4.y * r8.z;
  r4.y = r8.y * r7.w + r4.y;
  r4.y = min(r4.y, 1.000000);
  r7.w = -r7.z + cb0[232].w;
  r4.y = -r7.z + r4.y;
  r7.z = 1.000000 / r7.w;
  r4.y = saturate(r4.y * r7.z);
  r7.z = r4.y * -2.000000 + 3.000000;
  r4.y = r4.y * r4.y;
  r4.y = r4.y * r7.z;
  r7.z = cmp(0.000488 < r4.y);
  if (r7.z != 0) {
  r7.zw = -r5.yw * cb0[232].xy;
  r8.yz = frac(r7.zw);
  r9.xy = cmp(float2(0.000488, 0.000488) < cb0[231].yw);
  if (r9.x != 0) {
  r7.zw = floor(r7.zw);
  r7.zw = r7.zw * float2(0.000977, 0.000977);
  r9.xz = cmp(r7.zw >= -r7.zw);
  r7.zw = frac(abs(r7.zw));
  r7.zw = select_nonzero(r9.xz, r7.zw, -r7.zw);
  r7.zw = r7.zw * float2(1024.000000, 1024.000000);
  r7.z = dot(r7.zw, float2(12.989800, 78.233002));
  r7.z = sin(r7.z);
  r7.z = r7.z * 43758.546875;
  r7.z = frac(r7.z);
  r7.w = r7.z + cb0[231].x;
  r7.w = frac(r7.w);
  r8.w = cb0[232].z * cb0[232].z;
  r7.w = r7.w * r8.w;
  r7.w = floor(r7.w);
  r8.w = 1.000000 / cb0[232].z;
  r7.z = cmp(0.500000 >= r7.z);
  r7.z = asfloat(asuint(r7.z) & 0x3f800000u);
  r9.xz = -r8.yz + r8.zy;
  r8.yz = r7.zz * r9.xz + r8.yz;
  r7.z = r7.w / cb0[232].z;
  r9.x = cmp(r7.z >= -r7.z);
  r7.z = frac(abs(r7.z));
  r7.z = select_nonzero(r9.x, r7.z, -r7.z);
  r7.z = r7.z * cb0[232].z;
  r10.x = r7.z * r8.w;
  r7.z = -1.000000 + cb0[232].z;
  r7.w = r7.w * r8.w;
  r7.w = floor(r7.w);
  r7.z = -r7.w + r7.z;
  r10.y = r7.z * r8.w;
  r7.zw = r8.yz * r8.ww + r10.xy;
  r7.zw = frac(r7.zw);
  r7.zw = t8.SampleLevel(s1_s, r7.zw, 0.000000).xy;
  r7.zw = r7.zw * cb0[231].yy;
  r10.xy = r7.zw * float2(2.000000, 2.000000) + -cb0[231].yy;
  } else {
  r10.xy = float2(0, 0);
  }
  if (r9.y != 0) {
  r9.xw = float2(0, 0.500000);
  r9.y = cb0[231].z;
  r7.zw = -r5.yw * cb0[232].xy + r9.xy;
  r9.z = r8.x * 0.500000;
  r7.zw = r7.zw + r9.zw;
  r7.zw = r7.zw + float2(-0.500000, -0.500000);
  r9.xy = t8.SampleLevel(s2_s, r7.zw, 0.000000).zw;
  r11.xz = cb0[231].zw;
  r11.y = 0;
  r5.yw = -r5.yw * cb0[232].xy + -r11.xy;
  r11.y = -r8.x + 1.000000;
  r11.x = 0.500000;
  r7.zw = float2(1.000000, 0.500000) * r11.xy + float2(-0.500000, -0.500000);
  r5.yw = r5.yw + -r7.zw;
  r9.zw = t8.SampleLevel(s2_s, r5.yw, 0.000000).zw;
  r9.xyzw = r9.xyzw * cb0[231].wwww;
  r9.xyzw = r9.xyzw * float4(2.000000, 2.000000, 2.000000, 2.000000) + -r11.zzzz;
  r9.xyzw = r8.xxxx * r9.xyzw;
  r5.yw = r9.zw + r9.xy;
  r10.xy = r5.yw + r10.xy;
  }
  r5.y = r2.z * 0.300000;
  r5.y = r8.x * 0.700000 + r5.y;
  r5.w = r2.z + -0.100000;
  r5.w = saturate(r5.w * 100.000000);
  r5.y = r5.w * r5.y;
  r5.w = r5.y * 0.618000;
  r5.w = min(r5.w, 0.990000);
  r5.y = saturate(r5.y * 0.618000 + 0.600000);
  r5.y = -r5.w + r5.y;
  r5.w = -r5.w + cb0[232].w;
  r5.y = 1.000000 / r5.y;
  r5.y = saturate(r5.y * r5.w);
  r5.w = r5.y * -2.000000 + 3.000000;
  r5.y = r5.y * r5.y;
  r5.y = r5.y * r5.w;
  r4.y = r4.y * cb0[226].x;
  r5.w = dot(r10.xy, r10.xy);
  r5.w = min(r5.w, 1.000000);
  r5.w = -r5.w + 1.000000;
  r5.w = sqrt(r5.w);
  r10.z = max(r5.w, 0.000488);
  r5.w = dot(r10.xyz, r10.xyz);
  r5.w = rsqrt(r5.w);
  r8.yzw = r5.www * r10.yzx;
  r5.w = r8.z * 1.000000;
  r7.z = r5.y * r4.y;
  r7.z = r2.x * r7.z;
  r7.z = r5.z * r7.z;
  r8.yzw = r8.yzw * float3(1.000000, 1.000000, -1.000000) + -r4.xzw;
  r4.xzw = r7.zzz * r8.yzw + r4.xzw;
  r7.z = -r8.x + 1.000000;
  r7.z = r7.z * cb0[232].w;
  r7.w = r7.z * 0.500000;
  r7.z = -r7.z * 0.500000 + 1.000000;
  r5.y = r5.y * r7.z + r7.w;
  r7.z = -0.600000 + cb0[232].w;
  r7.z = saturate(r7.z * 2.500000);
  r7.w = r7.z * -2.000000 + 3.000000;
  r7.z = r7.z * r7.z;
  r7.z = r7.z * r7.w;
  r5.y = saturate(r7.z * 0.600000 + r5.y);
  r4.y = r4.y * r5.y;
  r4.y = r5.w * r4.y;
  r4.y = saturate(r4.y * 8.090615);
  r5.y = r4.y * -2.000000 + 3.000000;
  r4.y = r4.y * r4.y;
  r4.y = r4.y * r5.y;
  r2.x = r2.x * r4.y;
  r2.x = r5.z * r2.x;
  r2.x = max(r2.x, 0.000000);
  } else {
  r2.x = 0;
  }
  } else {
  r2.x = 0;
  }
  r4.y = -r2.z + 1.000000;
  r5.y = saturate(r4.y * cb0[226].z + cb0[226].y);
  r5.z = r2.z * r2.x;
  r5.y = saturate(r5.z * 0.100000 + r5.y);
  r5.y = r5.y * -0.300000 + 0.900000;
  r5.z = sqrt(r4.y);
  r5.y = r5.z + r5.y;
  r5.y = r5.y + -0.600000;
  r5.y = min(r5.y, 1.000000);
  r5.y = max(r4.y, r5.y);
  r5.y = min(r5.y, 0.990000);
  r5.z = saturate(2.000000 + -cb0[226].x);
  r5.z = r5.z * cb0[226].x;
  r5.w = -r4.z + -0.200000;
  r5.w = saturate(r5.w * 3.333333);
  r7.z = r5.w * -2.000000 + 3.000000;
  r5.w = r5.w * r5.w;
  r5.w = -r7.z * r5.w + 1.000000;
  r5.z = r5.w * r5.z;
  r5.w = -r2.y * r7.x + 1.000000;
  r5.z = r5.w * r5.z;
  r5.y = -r4.y + r5.y;
  r4.y = r5.z * r5.y + r4.y;
  r4.y = -r4.y + 1.000000;
  r2.x = r2.x * -0.900000 + 1.000000;
  r5.y = r2.x * r4.y;
  r5.y = min(r5.y, 1.000000);
  r2.y = min(r2.w, r2.y);
  r2.x = r4.y * r2.x + -r5.y;
  r2.x = r2.y * r2.x + r5.y;
  r2.y = -r2.x + r2.z;
  r2.x = r7.y * r2.y + r2.x;
  r2.y = r2.x * r2.x;
  r2.y = r2.y * r2.y;
  r5.yzw = r4.zzz * cb0[1].xyz;
  r5.yzw = cb0[0].xyz * r4.xxx + r5.yzw;
  r5.yzw = cb0[2].xyz * r4.www + r5.yzw;
  r7.xy = float2(-0.070000, 0.020000) / r5.xx;
  r2.w = r7.x * 1.442695;
  r2.w = exp2(r2.w);
  r2.w = r2.w + r2.w;
  r2.w = max(r2.w, 0.125000);
  r2.w = min(r2.w, 1.000000);
  r2.w = r2.w * cb1[3].x;
  r2.w = ceil(r2.w);
  r2.w = max(r2.w, (shader_injection.improved_ssr >= 0.5f) ? 256.0f : 32.0f);
  r2.z = cmp(r2.z >= 0.300000);
  r4.y = r2.w * 0.125000;
  r2.z = select_nonzero(r2.z, r4.y, r2.w);
  r6.w = -r6.y;
  r2.w = dot(r6.xzw, r6.xzw);
  r2.w = rsqrt(r2.w);
  r6.xyz = r2.www * r6.xwz;
  r2.w = dot(r6.xyz, r5.yzw);
  r4.y = r2.w + r2.w;
  r5.yzw = r5.yzw * -r4.yyy + r6.xyz;
  r6.xyzw = r5.zzzz * cb0[9].xyzw;
  r6.xyzw = cb0[8].xyzw * r5.yyyy + r6.xyzw;
  r6.xyzw = cb0[10].xyzw * r5.wwww + r6.xyzw;
  r1.w = 1.000000;
  r6.xyzw = r6.xyzw * float4(1.000000, -1.000000, 1.000000, 1.000000) + r1.xyzw;
  r5.yzw = r6.xyz / r6.www;
  r5.yzw = -r1.xyz + r5.yzw;
  r1.w = dot(r5.yz, r5.yz);
  r1.w = sqrt(r1.w);
  r4.y = r1.w * 0.500000;
  r6.xy = r1.xy * r4.yy + r5.yz;
  r6.xy = -r1.ww * float2(0.500000, 0.500000) + abs(r6.xy);
  r6.xy = max(r6.xy, float2(0.000000, 0.000000));
  r6.xy = r6.xy / abs(r5.yz);
  r6.xy = -r6.xy + float2(1.000000, 1.000000);
  r1.w = min(r6.y, r6.x);
  r1.w = r1.w / r4.y;
  r5.yzw = r1.www * r5.yzw;
  r1.w = abs(r5.w) / r2.z;
  r1.w = max(r1.w, 0.000100);
  r4.y = 1.000000 / r2.z;
  r5.yzw = r5.yzw * float3(0.500000, 0.500000, 1.000000);
  r5.yzw = r4.yyy * r5.yzw;
  r6.xy = r5.yz * cb1[0].xy;
  r4.y = max(abs(r6.y), abs(r6.x));
  r6.x = cmp(r4.y < 1.000000);
  r4.y = r4.y + 0.001000;
  r4.y = 1.000000 / r4.y;
  r6.y = trunc(cb1[1].x);
  r0.xy = r6.yy * float2(2.083000, 4.867000) + r0.xy;
  r0.x = dot(r0.xy, float2(0.067111, 0.005837));
  r0.x = frac(r0.x);
  r0.x = r0.x * 52.982918;
  r0.x = frac(r0.x);
  r0.x = select_nonzero(r6.x, r4.y, r0.x);
  r6.xyz = r1.xyz * float3(0.500000, 0.500000, 1.000000) + float3(0.500000, 0.500000, 0.000000);
  r6.xyz = r5.yzw * r0.xxx + r6.xyz;
  r0.x = t1.SampleLevel(s0_s, r6.xy, 0.000000).x;
  r0.x = -r0.x + r6.z;
  r7.xzw = float3(0, 0, 0);
  r8.xyz = float3(0, 0, 0);
  r9.xyz = r6.xyz;
  r0.y = 0;
  r1.x = 0;
  r4.y = r0.x;
  while (true) {
  r6.w = cmp(r1.x < r2.z);
  if (r6.w != 0) {
  r10.xyzw = r5.yzyz * float4(1.000000, 1.000000, 2.000000, 2.000000) + r9.xyxy;
  r11.xyzw = r5.yzyz * float4(3.000000, 3.000000, 4.000000, 4.000000) + r9.xyxy;
  r12.xyzw = r5.wwww * float4(1.000000, 2.000000, 3.000000, 4.000000) + r9.zzzz;
  r13.x = t1.SampleLevel(s0_s, r10.xy, 0.000000).x;
  r13.y = t1.SampleLevel(s0_s, r10.zw, 0.000000).x;
  r13.z = t1.SampleLevel(s0_s, r11.xy, 0.000000).x;
  r13.w = t1.SampleLevel(s0_s, r11.zw, 0.000000).x;
  r10.xyzw = r12.xyzw + -r13.xyzw;
  r11.xyzw = r1.wwww + r10.xyzw;
  r11.xyzw = cmp(abs(r11.xyzw) < r1.wwww);
  r12.xy = asfloat(asuint(r11.zw) | asuint(r11.xy));
  r6.w = asfloat(asuint(r12.y) | asuint(r12.x));
  if (r6.w != 0) {
  r12.xy = select_nonzero(r11.zz, r10.zy, r10.wz);
  r10.yz = select_nonzero(r11.yy, r10.yx, r12.xy);
  r6.w = select_nonzero(r11.x, r10.x, r10.y);
  r8.w = select_nonzero(r11.x, r4.y, r10.z);
  r9.w = select_nonzero(r11.z, 2.000000, 3.000000);
  r9.w = select_nonzero(r11.y, 1.000000, r9.w);
  r9.w = select_nonzero(r11.x, 0, r9.w);
  r6.w = -r6.w + r8.w;
  r6.w = saturate(r8.w / r6.w);
  r6.w = r6.w + r9.w;
  r10.xyz = r5.yzw * r6.www + r9.xyz;
  r0.y = -1;
  r8.xyz = r10.xyz;
  break;
  }
  r9.xyz = r5.yzw * float3(4.000000, 4.000000, 4.000000) + r9.xyz;
  r1.x = r1.x + 4.000000;
  r7.xzw = r9.xyz;
  r0.y = 0;
  r4.y = r10.w;
  continue;
  } else {
  r8.xyz = r7.xzw;
  r0.y = 0;
  break;
  }
  r0.y = 0;
  }
  if (r0.y != 0) {
  r0.x = max(r8.y, r8.x);
  r0.x = -r0.x + 1.000000;
  r0.y = min(r8.y, r8.x);
  r0.x = min(r0.y, r0.x);
  r1.xw = t4.SampleLevel(s0_s, r8.xy, 0.000000).xy;
  r5.yz = abs(r1.xw) * float2(2.000000, 2.000000) + float2(-1.000000, -1.000000);
  r5.yz = r5.yz * r5.yz;
  r5.yz = r5.yz * r5.yz;
  r1.xw = r1.xw + float2(-0.500000, -0.500000);
  r6.xy = cmp(float2(0.000000, 0.000000) < r1.xw);
  r1.xw = cmp(r1.xw < float2(0.000000, 0.000000));
  r1.xw = int2(-r6.xy) + int2(r1.xw);
  r1.xw = float2(r1.xw);
  r1.xw = r1.xw * r5.yz;
  r0.y = 1.000000 + -cb1[2].z;
  r5.yz = r0.yy * r1.xw;
  r2.z = cmp(cb1[1].y < r0.x);
  r0.x = saturate(r0.x / cb1[1].y);
  r0.x = select_nonzero(r2.z, 1.000000, r0.x);
  r2.z = saturate(abs(r2.w) * cb1[1].z + cb1[1].w);
  r2.z = -r2.z + 1.000000;
  r0.x = r0.x * r2.z;
  r2.x = cmp(r2.x < 0.100000);
  r2.z = 1.000000 / r5.x;
  r2.z = -r2.z + 100.000000;
  r2.z = saturate(r2.z * 0.100000);
  r2.x = select_nonzero(r2.x, 1.000000, r2.z);
  r0.x = r0.x * r2.x;
  r1.xw = -r1.xw * r0.yy + r8.xy;
  } else {
  r5.yz = float2(0, 0);
  r1.xw = r0.zw;
  r0.x = 0;
  }
  r2.xz = t4.SampleLevel(s0_s, r1.xw, 0.000000).xy;
  r5.xw = abs(r2.xz) * float2(2.000000, 2.000000) + float2(-1.000000, -1.000000);
  r5.xw = r5.xw * r5.xw;
  r0.y = 2.000000 / r2.y;
  r0.y = r0.y + -1.000000;
  r0.y = 1.000000 / r0.y;
  r0.y = r0.y * -2.035047;
  r0.y = exp2(r0.y);
  r2.w = -r0.y + 1.000000;
  r2.w = sqrt(r2.w);
  r4.y = r0.y * -0.018729 + 0.074261;
  r4.y = r4.y * r0.y + -0.212114;
  r0.y = r4.y * r0.y + 1.570729;
  r0.y = r2.w * r0.y;
  r3.xyzw = cb0[25].xyzw * r1.yyyy + r3.xyzw;
  r3.xyzw = cb0[26].xyzw * r1.zzzz + r3.xyzw;
  r3.xyzw = r3.xyzw + cb0[27].xyzw;
  r3.xyzw = r3.xyzw / r3.wwww;
  r1.yz = r8.xy * float2(2.000000, 2.000000) + float2(-1.000000, -1.000000);
  r6.xyzw = r1.zzzz * cb0[25].xyzw;
  r6.xyzw = cb0[24].xyzw * r1.yyyy + r6.xyzw;
  r6.xyzw = cb0[26].xyzw * r8.zzzz + r6.xyzw;
  r6.xyzw = r6.xyzw + cb0[27].xyzw;
  r7.xzw = -r3.xyz + cb0[44].xyz;
  r1.y = dot(r7.xzw, r7.xzw);
  r1.z = rsqrt(r1.y);
  r8.xyz = r1.zzz * r7.xzw;
  r1.y = sqrt(r1.y);
  r2.w = cmp(abs(r4.w) < 0.999000);
  r9.z = select_nonzero(r2.w, 0, 1.000000);
  r9.y = asfloat(asuint(r2.w) & 0x3f800000u);
  r9.x = 0;
  r10.xyz = r4.xzw * r9.xyz;
  r9.xyz = r9.zxy * r4.zwx + -r10.xyz;
  r2.w = dot(r9.xyz, r9.xyz);
  r2.w = rsqrt(r2.w);
  r9.xyz = r2.www * r9.xyz;
  r6.xyzw = r6.xyzw / r6.wwww;
  r3.xyzw = -r3.xyzw + r6.xyzw;
  r2.w = dot(r3.xyzw, r3.xyzw);
  r2.w = sqrt(r2.w);
  r3.xyz = r8.xyz * r9.zxy;
  r3.xyz = r9.yzx * r8.yzx + -r3.xyz;
  r6.x = sin(r0.y);
r10.x = cos(r0.y);
  r6.yzw = -r8.xyz * r1.yyy + cb0[44].xyz;
  r10.yzw = r4.xzw * r9.xyz;
  r4.xyz = r4.wxz * r9.yzx + -r10.yzw;
  r9.xyz = r8.xyz * r4.xyz;
  r4.xyz = r4.zxy * r8.yzx + -r9.xyz;
  r0.y = r1.y + r2.w;
  r9.xyz = r0.yyy * r8.xyz;
  r10.yzw = -r9.yyy * cb0[21].xyw;
  r9.xyw = cb0[20].xyw * -r9.xxx + r10.yzw;
  r9.xyz = cb0[22].xyw * -r9.zzz + r9.xyw;
  r9.xyz = r9.xyz + cb0[23].xyw;
  r9.xy = r9.xy / r9.zz;
  r9.xy = r9.xy * float2(0.500000, 0.500000) + float2(0.500000, 0.500000);
  r9.xy = r9.xy * cb1[0].xy;
  r0.y = dot(r3.yzx, -r8.xyz);
  r10.yzw = r0.yyy * r3.yzx;
  r11.xyz = -r7.xzw * r1.zzz + -r10.yzw;
  r10.yzw = r10.xxx * r11.xyz + r10.yzw;
  r11.xyz = -r8.yzx * r3.xyz;
  r3.xyz = r3.zxy * -r8.zxy + -r11.xyz;
  r3.xyz = r3.xyz * r6.xxx + r10.yzw;
  r3.xyz = r3.xyz * r2.www + r6.yzw;
  r3.xyz = r3.xyz + -cb0[44].xyz;
  r10.yzw = r3.yyy * cb0[21].xyw;
  r3.xyw = cb0[20].xyw * r3.xxx + r10.yzw;
  r3.xyz = cb0[22].xyw * r3.zzz + r3.xyw;
  r3.xyz = r3.xyz + cb0[23].xyw;
  r0.y = dot(r4.yzx, -r8.xyz);
  r10.yzw = r0.yyy * r4.yzx;
  r7.xzw = -r7.xzw * r1.zzz + -r10.yzw;
  r7.xzw = r10.xxx * r7.xzw + r10.yzw;
  r10.xyz = -r8.yzx * r4.xyz;
  r4.xyz = r4.zxy * -r8.zxy + -r10.xyz;
  r4.xyz = r4.xyz * r6.xxx + r7.xzw;
  r4.xyz = r4.xyz * r2.www + r6.yzw;
  r4.xyz = r4.xyz + -cb0[44].xyz;
  r6.xyz = r4.yyy * cb0[21].xyw;
  r4.xyw = cb0[20].xyw * r4.xxx + r6.xyz;
  r4.xyz = cb0[22].xyw * r4.zzz + r4.xyw;
  r4.xyz = r4.xyz + cb0[23].xyw;
  u0[vThreadID.xy] = r1.xwxx;
  r1.xy = r5.xw * r5.xw;
  r1.zw = r2.xz + float2(-0.500000, -0.500000);
  r2.xz = cmp(float2(0.000000, 0.000000) < r1.zw);
  r1.zw = cmp(r1.zw < float2(0.000000, 0.000000));
  r1.zw = int2(-r2.xz) + int2(r1.zw);
  r1.zw = float2(r1.zw);
  r1.xy = r1.xy * r1.zw + r5.yz;
  r1.xy = r1.xy * cb0[82].xy;
  r0.y = dot(r1.xy, r1.xy);
  r0.y = sqrt(r0.y);
  r1.x = log2(r7.y);
  r1.x = saturate(r1.x * 0.693147 + 0.010000);
  r0.y = -r0.y * r1.x;
  r0.y = r0.y * 1.442695;
  r1.xzw = exp2(r0.yyy);
  r0.y = cmp(0.000100 >= r2.y);
  r2.xy = r3.xy / r3.zz;
  r2.xy = r2.xy * float2(0.500000, 0.500000) + float2(0.500000, 0.500000);
  r2.xy = -r2.xy * cb1[0].xy + r9.xy;
  r2.x = dot(r2.xy, r2.xy);
  r2.yz = r4.xy / r4.zz;
  r2.yz = r2.yz * float2(0.500000, 0.500000) + float2(0.500000, 0.500000);
  r2.yz = -r2.yz * cb1[0].xy + r9.xy;
  r2.y = dot(r2.yz, r2.yz);
  r2.x = r2.y + r2.x;
  r2.x = sqrt(r2.x);
  r2.x = r2.x * 0.500000;
  r2.x = log2(r2.x);
  r2.x = max(r2.x, 0.000000);
  r2.x = min(r2.x, cb1[5].y);
  r2.x = r2.x / cb1[5].y;
  r1.y = select_nonzero(r0.y, 0, r2.x);
  if (shader_injection.improved_ssr >= 0.5f) {
    float mip_threshold = 0.25f;
    float adjusted_mip = saturate((r1.y - mip_threshold) / (1.0f - mip_threshold));
    u1[vThreadID.xy] = float4(r1.x, adjusted_mip, r1.z, r1.x);
  } else {
    u1[vThreadID.xy] = r1.xyzw;
  }
  r0.yz = r0.zw * cb0[82].xy;
  r1.xy = float2(r0.yz);
  uint ssr_mask = t5.Load(int3(int2(r1.xy), 0)).y & 4u;
  r0.x = (ssr_mask != 0u) ? 1.000000 : r0.x;
  u2[vThreadID.xy] = r0.xxxx;
  return;
  // Approximately 0 instruction slots used

}
