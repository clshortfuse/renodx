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
  float4 cb0[85];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[6];
}

SamplerState s0_s : register(s0);

Texture2D<float4> t0 : register(t0);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t4 : register(t4);

Texture2D<uint4> t5 : register(t5);

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
  r5.yzw = cmp(r2.xyz >= float3(0.000000, 0.000000, 0.300000));
  r7.xy = -abs(r2.yx) + float2(1.000000, 1.000000);
  r5.yz = select_nonzero(r5.yz, float2(1.000000, 1.000000), float2(-1.000000, -1.000000));
  r5.yz = r5.yz * r7.xy;
  r4.xz = select_nonzero(r2.ww, r5.yz, r2.xy);
  r2.x = dot(r4.xyz, r4.xyz);
  r2.x = rsqrt(r2.x);
  r2.xyw = r2.xxx * r4.xyz;
  r4.x = r2.z * r2.z;
  r4.x = r4.x * r4.x;
  r4.yzw = r2.yyy * cb0[1].xyz;
  r4.yzw = cb0[0].xyz * r2.xxx + r4.yzw;
  r4.yzw = cb0[2].xyz * r2.www + r4.yzw;
  r5.yz = float2(-0.070000, 0.020000) / r5.xx;
  r5.y = r5.y * 1.442695;
  r5.y = exp2(r5.y);
  r5.y = r5.y + r5.y;
  r5.y = max(r5.y, 0.125000);
  r5.y = min(r5.y, 1.000000);
  r5.y = r5.y * cb1[3].x;
  r5.y = ceil(r5.y);
  r5.y = max(r5.y, (shader_injection.improved_ssr >= 0.5f) ? 256.0f : 32.0f);
  r7.x = r5.y * 0.125000;
  r5.y = select_nonzero(r5.w, r7.x, r5.y);
  r6.w = -r6.y;
  r5.w = dot(r6.xzw, r6.xzw);
  r5.w = rsqrt(r5.w);
  r6.xyz = r5.www * r6.xwz;
  r5.w = dot(r6.xyz, r4.yzw);
  r6.w = r5.w + r5.w;
  r4.yzw = r4.yzw * -r6.www + r6.xyz;
  r6.xyzw = r4.zzzz * cb0[9].xyzw;
  r6.xyzw = cb0[8].xyzw * r4.yyyy + r6.xyzw;
  r6.xyzw = cb0[10].xyzw * r4.wwww + r6.xyzw;
  r1.w = 1.000000;
  r6.xyzw = r6.xyzw * float4(1.000000, -1.000000, 1.000000, 1.000000) + r1.xyzw;
  r4.yzw = r6.xyz / r6.www;
  r4.yzw = -r1.xyz + r4.yzw;
  r1.w = dot(r4.yz, r4.yz);
  r1.w = sqrt(r1.w);
  r6.x = r1.w * 0.500000;
  r6.yz = r1.xy * r6.xx + r4.yz;
  r6.yz = -r1.ww * float2(0.500000, 0.500000) + abs(r6.yz);
  r6.yz = max(r6.yz, float2(0.000000, 0.000000));
  r6.yz = r6.yz / abs(r4.yz);
  r6.yz = -r6.yz + float2(1.000000, 1.000000);
  r1.w = min(r6.z, r6.y);
  r1.w = r1.w / r6.x;
  r4.yzw = r1.www * r4.yzw;
  r1.w = abs(r4.w) / r5.y;
  r1.w = max(r1.w, 0.000100);
  r6.x = 1.000000 / r5.y;
  r4.yzw = r4.yzw * float3(0.500000, 0.500000, 1.000000);
  r4.yzw = r6.xxx * r4.yzw;
  r6.xy = r4.yz * cb1[0].xy;
  r6.x = max(abs(r6.y), abs(r6.x));
  r6.y = cmp(r6.x < 1.000000);
  r6.x = r6.x + 0.001000;
  r6.x = 1.000000 / r6.x;
  r6.z = trunc(cb1[1].x);
  r0.xy = r6.zz * float2(2.083000, 4.867000) + r0.xy;
  r0.x = dot(r0.xy, float2(0.067111, 0.005837));
  r0.x = frac(r0.x);
  r0.x = r0.x * 52.982918;
  r0.x = frac(r0.x);
  r0.x = select_nonzero(r6.y, r6.x, r0.x);
  r6.xyz = r1.xyz * float3(0.500000, 0.500000, 1.000000) + float3(0.500000, 0.500000, 0.000000);
  r6.xyz = r4.yzw * r0.xxx + r6.xyz;
  r0.x = t1.SampleLevel(s0_s, r6.xy, 0.000000).x;
  r0.x = -r0.x + r6.z;
  r7.xyz = float3(0, 0, 0);
  r8.xyz = float3(0, 0, 0);
  r9.xyz = r6.xyz;
  r0.y = 0;
  r1.x = 0;
  r6.w = r0.x;
  while (true) {
  r7.w = cmp(r1.x < r5.y);
  if (r7.w != 0) {
  r10.xyzw = r4.yzyz * float4(1.000000, 1.000000, 2.000000, 2.000000) + r9.xyxy;
  r11.xyzw = r4.yzyz * float4(3.000000, 3.000000, 4.000000, 4.000000) + r9.xyxy;
  r12.xyzw = r4.wwww * float4(1.000000, 2.000000, 3.000000, 4.000000) + r9.zzzz;
  r13.x = t1.SampleLevel(s0_s, r10.xy, 0.000000).x;
  r13.y = t1.SampleLevel(s0_s, r10.zw, 0.000000).x;
  r13.z = t1.SampleLevel(s0_s, r11.xy, 0.000000).x;
  r13.w = t1.SampleLevel(s0_s, r11.zw, 0.000000).x;
  r10.xyzw = r12.xyzw + -r13.xyzw;
  r11.xyzw = r1.wwww + r10.xyzw;
  r11.xyzw = cmp(abs(r11.xyzw) < r1.wwww);
  r12.xy = asfloat(asuint(r11.zw) | asuint(r11.xy));
  r7.w = asfloat(asuint(r12.y) | asuint(r12.x));
  if (r7.w != 0) {
  r12.xy = select_nonzero(r11.zz, r10.zy, r10.wz);
  r10.yz = select_nonzero(r11.yy, r10.yx, r12.xy);
  r7.w = select_nonzero(r11.x, r10.x, r10.y);
  r8.w = select_nonzero(r11.x, r6.w, r10.z);
  r9.w = select_nonzero(r11.z, 2.000000, 3.000000);
  r9.w = select_nonzero(r11.y, 1.000000, r9.w);
  r9.w = select_nonzero(r11.x, 0, r9.w);
  r7.w = -r7.w + r8.w;
  r7.w = saturate(r8.w / r7.w);
  r7.w = r7.w + r9.w;
  r10.xyz = r4.yzw * r7.www + r9.xyz;
  r0.y = -1;
  r8.xyz = r10.xyz;
  break;
  }
  r9.xyz = r4.yzw * float3(4.000000, 4.000000, 4.000000) + r9.xyz;
  r1.x = r1.x + 4.000000;
  r7.xyz = r9.xyz;
  r0.y = 0;
  r6.w = r10.w;
  continue;
  } else {
  r8.xyz = r7.xyz;
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
  r4.yz = abs(r1.xw) * float2(2.000000, 2.000000) + float2(-1.000000, -1.000000);
  r4.yz = r4.yz * r4.yz;
  r4.yz = r4.yz * r4.yz;
  r1.xw = r1.xw + float2(-0.500000, -0.500000);
  r6.xy = cmp(float2(0.000000, 0.000000) < r1.xw);
  r1.xw = cmp(r1.xw < float2(0.000000, 0.000000));
  r1.xw = int2(-r6.xy) + int2(r1.xw);
  r1.xw = float2(r1.xw);
  r1.xw = r1.xw * r4.yz;
  r0.y = 1.000000 + -cb1[2].z;
  r4.yz = r0.yy * r1.xw;
  r4.w = cmp(cb1[1].y < r0.x);
  r0.x = saturate(r0.x / cb1[1].y);
  r0.x = select_nonzero(r4.w, 1.000000, r0.x);
  r4.w = saturate(abs(r5.w) * cb1[1].z + cb1[1].w);
  r4.w = -r4.w + 1.000000;
  r0.x = r0.x * r4.w;
  r2.z = cmp(r2.z < 0.100000);
  r4.w = 1.000000 / r5.x;
  r4.w = -r4.w + 100.000000;
  r4.w = saturate(r4.w * 0.100000);
  r2.z = select_nonzero(r2.z, 1.000000, r4.w);
  r0.x = r0.x * r2.z;
  r1.xw = -r1.xw * r0.yy + r8.xy;
  } else {
  r4.yz = float2(0, 0);
  r1.xw = r0.zw;
  r0.x = 0;
  }
  r5.xy = t4.SampleLevel(s0_s, r1.xw, 0.000000).xy;
  r6.xy = abs(r5.xy) * float2(2.000000, 2.000000) + float2(-1.000000, -1.000000);
  r6.xy = r6.xy * r6.xy;
  r0.y = 2.000000 / r4.x;
  r0.y = r0.y + -1.000000;
  r0.y = 1.000000 / r0.y;
  r0.y = r0.y * -2.035047;
  r0.y = exp2(r0.y);
  r2.z = -r0.y + 1.000000;
  r2.z = sqrt(r2.z);
  r4.w = r0.y * -0.018729 + 0.074261;
  r4.w = r4.w * r0.y + -0.212114;
  r0.y = r4.w * r0.y + 1.570729;
  r0.y = r2.z * r0.y;
  r3.xyzw = cb0[25].xyzw * r1.yyyy + r3.xyzw;
  r3.xyzw = cb0[26].xyzw * r1.zzzz + r3.xyzw;
  r3.xyzw = r3.xyzw + cb0[27].xyzw;
  r3.xyzw = r3.xyzw / r3.wwww;
  r1.yz = r8.xy * float2(2.000000, 2.000000) + float2(-1.000000, -1.000000);
  r7.xyzw = r1.zzzz * cb0[25].xyzw;
  r7.xyzw = cb0[24].xyzw * r1.yyyy + r7.xyzw;
  r7.xyzw = cb0[26].xyzw * r8.zzzz + r7.xyzw;
  r7.xyzw = r7.xyzw + cb0[27].xyzw;
  r8.xyz = -r3.xyz + cb0[44].xyz;
  r1.y = dot(r8.xyz, r8.xyz);
  r1.z = rsqrt(r1.y);
  r9.xyz = r1.zzz * r8.xyz;
  r1.y = sqrt(r1.y);
  r2.z = cmp(abs(r2.w) < 0.999000);
  r10.z = select_nonzero(r2.z, 0, 1.000000);
  r10.y = asfloat(asuint(r2.z) & 0x3f800000u);
  r10.x = 0;
  r11.xyz = r2.xyw * r10.xyz;
  r10.xyz = r10.zxy * r2.ywx + -r11.xyz;
  r2.z = dot(r10.xyz, r10.xyz);
  r2.z = rsqrt(r2.z);
  r10.xyz = r2.zzz * r10.xyz;
  r7.xyzw = r7.xyzw / r7.wwww;
  r3.xyzw = -r3.xyzw + r7.xyzw;
  r2.z = dot(r3.xyzw, r3.xyzw);
  r2.z = sqrt(r2.z);
  r3.xyz = r9.xyz * r10.zxy;
  r3.xyz = r10.yzx * r9.yzx + -r3.xyz;
  r7.x = sin(r0.y);
r11.x = cos(r0.y);
  r7.yzw = -r9.xyz * r1.yyy + cb0[44].xyz;
  r11.yzw = r2.xyw * r10.xyz;
  r2.xyw = r2.wxy * r10.yzx + -r11.yzw;
  r10.xyz = r9.xyz * r2.xyw;
  r2.xyw = r2.wxy * r9.yzx + -r10.xyz;
  r0.y = r1.y + r2.z;
  r10.xyz = r0.yyy * r9.xyz;
  r11.yzw = -r10.yyy * cb0[21].xyw;
  r10.xyw = cb0[20].xyw * -r10.xxx + r11.yzw;
  r10.xyz = cb0[22].xyw * -r10.zzz + r10.xyw;
  r10.xyz = r10.xyz + cb0[23].xyw;
  r6.zw = r10.xy / r10.zz;
  r6.zw = r6.zw * float2(0.500000, 0.500000) + float2(0.500000, 0.500000);
  r6.zw = r6.zw * cb1[0].xy;
  r0.y = dot(r3.yzx, -r9.xyz);
  r10.xyz = r0.yyy * r3.yzx;
  r11.yzw = -r8.xyz * r1.zzz + -r10.xyz;
  r10.xyz = r11.xxx * r11.yzw + r10.xyz;
  r11.yzw = -r9.yzx * r3.xyz;
  r3.xyz = r3.zxy * -r9.zxy + -r11.yzw;
  r3.xyz = r3.xyz * r7.xxx + r10.xyz;
  r3.xyz = r3.xyz * r2.zzz + r7.yzw;
  r3.xyz = r3.xyz + -cb0[44].xyz;
  r10.xyz = r3.yyy * cb0[21].xyw;
  r3.xyw = cb0[20].xyw * r3.xxx + r10.xyz;
  r3.xyz = cb0[22].xyw * r3.zzz + r3.xyw;
  r3.xyz = r3.xyz + cb0[23].xyw;
  r0.y = dot(r2.ywx, -r9.xyz);
  r10.xyz = r0.yyy * r2.ywx;
  r8.xyz = -r8.xyz * r1.zzz + -r10.xyz;
  r8.xyz = r11.xxx * r8.xyz + r10.xyz;
  r10.xyz = -r9.yzx * r2.xyw;
  r2.xyw = r2.wxy * -r9.zxy + -r10.xyz;
  r2.xyw = r2.xyw * r7.xxx + r8.xyz;
  r2.xyz = r2.xyw * r2.zzz + r7.yzw;
  r2.xyz = r2.xyz + -cb0[44].xyz;
  r7.xyz = r2.yyy * cb0[21].xyw;
  r2.xyw = cb0[20].xyw * r2.xxx + r7.xyz;
  r2.xyz = cb0[22].xyw * r2.zzz + r2.xyw;
  r2.xyz = r2.xyz + cb0[23].xyw;
  u0[vThreadID.xy] = r1.xwxx;
  r1.xy = r6.xy * r6.xy;
  r1.zw = r5.xy + float2(-0.500000, -0.500000);
  r5.xy = cmp(float2(0.000000, 0.000000) < r1.zw);
  r1.zw = cmp(r1.zw < float2(0.000000, 0.000000));
  r1.zw = int2(-r5.xy) + int2(r1.zw);
  r1.zw = float2(r1.zw);
  r1.xy = r1.xy * r1.zw + r4.yz;
  r1.xy = r1.xy * cb0[82].xy;
  r0.y = dot(r1.xy, r1.xy);
  r0.y = sqrt(r0.y);
  r1.x = log2(r5.z);
  r1.x = saturate(r1.x * 0.693147 + 0.010000);
  r0.y = -r0.y * r1.x;
  r0.y = r0.y * 1.442695;
  r1.xzw = exp2(r0.yyy);
  r0.y = cmp(0.000100 >= r4.x);
  r3.xy = r3.xy / r3.zz;
  r3.xy = r3.xy * float2(0.500000, 0.500000) + float2(0.500000, 0.500000);
  r3.xy = -r3.xy * cb1[0].xy + r6.zw;
  r2.w = dot(r3.xy, r3.xy);
  r2.xy = r2.xy / r2.zz;
  r2.xy = r2.xy * float2(0.500000, 0.500000) + float2(0.500000, 0.500000);
  r2.xy = -r2.xy * cb1[0].xy + r6.zw;
  r2.x = dot(r2.xy, r2.xy);
  r2.x = r2.x + r2.w;
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
