#include "../shared.h"

#ifdef SSR_FULL_TRACE_VARIANT
Texture2D<float4> t5 : register(t5);
#endif

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

StructuredBuffer<uint> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
#ifdef SSR_FULL_TRACE_VARIANT
  float4 cb2[6];
#else
  float4 cb2[7];
#endif
}

cbuffer cb1 : register(b1)
{
  float4 cb1[3];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[65];
}

RWTexture2D<unorm float4> u0 : register(u0);
RWTexture2D<unorm float4> u1 : register(u1);
RWTexture2D<unorm float4> u2 : register(u2);


#define cmp -


[numthreads(8, 8, 1)]
void main(uint3 vThreadGroupID : SV_GroupID, uint3 vThreadIDInGroup : SV_GroupThreadID)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13;
  uint4 bitmask, uiDest;
  float4 fDest;

#ifdef SSR_FULL_TRACE_VARIANT
  uint dispatch_index = vThreadGroupID.x;
#else
  uint dispatch_index = (uint)cb2[6].z + vThreadGroupID.x;
#endif
  uint packed_dispatch = t0[dispatch_index];
  uint2 packed_group = uint2(packed_dispatch >> 16, packed_dispatch & 0x0000ffff);
  r0.xy = mad((int2)packed_group, int2(8,8), (int2)vThreadIDInGroup.xy);
  r1.xy = (uint2)cb2[0].xy;
  r1.xy = cmp((uint2)r0.xy >= (uint2)r1.xy);
  r1.x = (int)r1.y | (int)r1.x;
  if (r1.x == 0) {
    r1.x = u2[(uint2)r0.xy].x;
    r1.yz = (int2)r0.xy;
    r1.yz = float2(0.5,0.5) + r1.yz;
    r2.xy = cb2[0].zw * r1.yz;
    r1.w = cmp(0.00100000005 < r1.x);
    if (r1.w != 0) {
#ifdef SSR_FULL_TRACE_VARIANT
      r2.zw = (uint2)r0.xy;
      r2.zw = float2(0.5,0.5) + r2.zw;
      r2.zw = cb2[0].zw * r2.zw;
      bool use_full_trace = t4.SampleLevel(s0_s, r2.zw, 0).x > 0.5;
      float low_trace_count = max(ceil(cb2[3].x * 0.125), 4.0f);
      r1.w = use_full_trace ? cb2[3].x : low_trace_count;
      if (shader_injection.improved_ssr >= 0.5f) {
        r1.w = max(r1.w, use_full_trace ? 256.0f : 32.0f);
      }
#else
      r1.w = cb2[3].x * 0.125;
      r1.w = ceil(r1.w);
      r1.w = max(r1.w, (shader_injection.improved_ssr >= 0.5f) ? 32.0f : 4.0f);
#endif
      r3.z = t2.SampleLevel(s0_s, r2.xy, 0).x;
      r3.xy = r2.xy * float2(2,2) + float2(-1,-1);
      r4.xyzw = cb0[13].xyzw * r3.yyyy;
      r4.xyzw = cb0[12].xyzw * r3.xxxx + r4.xyzw;
      r4.xyzw = cb0[14].xyzw * r3.zzzz + r4.xyzw;
      r4.xyzw = cb0[15].xyzw + r4.xyzw;
      r4.xyz = r4.xyz / r4.www;
      r0.zw = float2(0,0);
#ifdef SSR_FULL_TRACE_VARIANT
      r5.xyz = t5.Load(r0.xyz).xyz;
#else
      r5.xyz = t4.Load(r0.xyz).xyz;
#endif
      r0.zw = r5.xy * float2(2,2) + float2(-1,-1);
      r2.z = dot(float2(1,1), abs(r0.zw));
      r6.y = 1 + -r2.z;
      r2.z = cmp(r6.y < 0);
      r5.xy = cmp(r0.zw >= float2(0,0));
      r7.xy = float2(1,1) + -abs(r0.wz);
      r5.xy = r5.xy ? float2(1,1) : float2(-1,-1);
      r5.xy = r7.xy * r5.xy;
      r6.xz = r2.zz ? r5.xy : r0.zw;
      r0.z = dot(r6.xyz, r6.xyz);
      r0.z = rsqrt(r0.z);
      r5.xyw = r6.xyz * r0.zzz;
      r0.z = r5.z * r5.z;
      r0.z = r0.z * r0.z;
      r4.w = -r4.y;
      r0.w = dot(r4.xzw, r4.xzw);
      r0.w = rsqrt(r0.w);
      r4.xyz = r4.xwz * r0.www;
      r6.xyz = cb0[1].xyz * r5.yyy;
      r6.xyz = cb0[0].xyz * r5.xxx + r6.xyz;
      r6.xyz = cb0[2].xyz * r5.www + r6.xyz;
      r0.w = dot(r4.xyz, r6.xyz);
      r0.w = r0.w + r0.w;
      r4.xyz = r6.xyz * -r0.www + r4.xyz;
      r6.xyzw = cb0[9].xyzw * r4.yyyy;
      r6.xyzw = cb0[8].xyzw * r4.xxxx + r6.xyzw;
      r4.xyzw = cb0[10].xyzw * r4.zzzz + r6.xyzw;
      r3.w = 1;
      r4.xyzw = r4.xyzw * float4(1,-1,1,1) + r3.xyzw;
      r4.xyz = r4.xyz / r4.www;
      r4.xyz = r4.xyz + -r3.xyz;
      r0.w = dot(r4.xy, r4.xy);
      r0.w = sqrt(r0.w);
      r2.z = 0.5 * r0.w;
      r6.xy = r3.xy * r2.zz + r4.xy;
      r6.xy = -r0.ww * float2(0.5,0.5) + abs(r6.xy);
      r6.xy = max(float2(0,0), r6.xy);
      r6.xy = r6.xy / abs(r4.xy);
      r6.xy = float2(1,1) + -r6.xy;
      r0.w = min(r6.x, r6.y);
      r0.w = r0.w / r2.z;
      r4.xyz = r4.xyz * r0.www;
      r0.w = abs(r4.z) / r1.w;
      r0.w = max(9.99999975e-005, r0.w);
      r2.z = 1 / r1.w;
      r4.xyz = float3(0.5,0.5,1) * r4.xyz;
      r4.xyz = r4.xyz * r2.zzz;
      r2.zw = cb2[0].xy * r4.xy;
      r2.z = max(abs(r2.z), abs(r2.w));
      r2.w = cmp(r2.z < 1);
      r2.z = 0.00100000005 + r2.z;
      r2.z = 1 / r2.z;
      r3.w = trunc(cb2[1].x);
      r1.yz = r3.ww * float2(2.08299994,4.8670001) + r1.yz;
      r1.y = dot(r1.yz, float2(0.0671105608,0.00583714992));
      r1.y = frac(r1.y);
      r1.y = 52.9829178 * r1.y;
      r1.y = frac(r1.y);
      r1.y = r2.w ? r2.z : r1.y;
      r6.xyz = r3.xyz * float3(0.5,0.5,1) + float3(0.5,0.5,0);
      r6.xyz = r4.xyz * r1.yyy + r6.xyz;
      r1.y = t2.SampleLevel(s0_s, r6.xy, 0).x;
      r1.y = r6.z + -r1.y;
      r7.xyz = float3(0,0,0);
      r8.xyz = float3(0,0,0);
      r9.xyz = r6.xyz;
      r1.z = 0;
      r2.z = 0;
      r2.w = r1.y;
      while (true) {
        r3.w = cmp(r2.z < r1.w);
        if (r3.w != 0) {
          r10.xyzw = r4.xyxy * float4(1,1,2,2) + r9.xyxy;
          r11.xyzw = r4.xyxy * float4(3,3,4,4) + r9.xyxy;
          r12.xyzw = r4.zzzz * float4(1,2,3,4) + r9.zzzz;
          r13.x = t2.SampleLevel(s0_s, r10.xy, 0).x;
          r13.y = t2.SampleLevel(s0_s, r10.zw, 0).x;
          r13.z = t2.SampleLevel(s0_s, r11.xy, 0).x;
          r13.w = t2.SampleLevel(s0_s, r11.zw, 0).x;
          r10.xyzw = -r13.xyzw + r12.xyzw;
          r11.xyzw = r10.xyzw + r0.wwww;
          r11.xyzw = cmp(abs(r11.xyzw) < r0.wwww);
          r12.xy = (int2)r11.zw | (int2)r11.xy;
          r3.w = (int)r12.y | (int)r12.x;
          if (r3.w != 0) {
            r12.xy = r11.zz ? r10.zy : r10.wz;
            r10.yz = r11.yy ? r10.yx : r12.xy;
            r3.w = r11.x ? r10.x : r10.y;
            r4.w = r11.x ? r2.w : r10.z;
            r5.z = r11.z ? 2 : 3;
            r5.z = r11.y ? 1 : r5.z;
            r5.z = r11.x ? 0 : r5.z;
            r3.w = r4.w + -r3.w;
            r3.w = saturate(r4.w / r3.w);
            r3.w = r5.z + r3.w;
            r10.xyz = r4.xyz * r3.www + r9.xyz;
            r1.z = -1;
            r8.xyz = r10.xyz;
            break;
          }
          r9.xyz = r4.xyz * float3(4,4,4) + r9.xyz;
          r2.z = 4 + r2.z;
          r7.xyz = r9.xyz;
          r1.z = 0;
          r2.w = r10.w;
          continue;
        } else {
          r8.xyz = r7.xyz;
          r1.z = 0;
          break;
        }
        r1.z = 0;
      }
      if (r1.z != 0) {
        r0.w = max(r8.x, r8.y);
        r0.w = 1 + -r0.w;
        r1.y = min(r8.x, r8.y);
        r0.w = min(r1.y, r0.w);
        r1.y = cmp(cb2[1].y < r0.w);
        r0.w = saturate(r0.w / cb2[1].y);
        r0.w = r1.y ? 1 : r0.w;
        r0.w = r1.x * r0.w;
        r1.yz = t3.SampleLevel(s0_s, r8.xy, 0).xy;
        r2.zw = abs(r1.yz) * float2(2,2) + float2(-1,-1);
        r2.zw = r2.zw * r2.zw;
        r2.zw = r2.zw * r2.zw;
        r1.yz = float2(-0.5,-0.5) + r1.yz;
        r4.xy = cmp(float2(0,0) < r1.yz);
        r1.yz = cmp(r1.yz < float2(0,0));
        r1.yz = (int2)-r4.xy + (int2)r1.yz;
        r1.yz = (int2)r1.yz;
        r1.yz = r2.zw * r1.yz;
        r1.w = -cb2[2].z + 1;
        r2.zw = r1.yz * r1.ww;
        r2.xy = -r1.yz * r1.ww + r8.xy;
        r1.y = t1.SampleLevel(s0_s, r2.xy, 0).x;
        r1.z = cmp(0 < r1.y);
        r1.w = cmp(cb2[2].z < 0.5);
        r1.z = r1.w ? r1.z : 0;
        r4.xy = r2.xy * float2(2,2) + float2(-1,-1);
        r6.xyzw = cb0[62].xyzw * -r4.yyyy;
        r4.xyzw = cb0[61].xyzw * r4.xxxx + r6.xyzw;
        r4.xyzw = cb0[63].xyzw * r1.yyyy + r4.xyzw;
        r4.xyzw = cb0[64].xyzw + r4.xyzw;
        r1.yw = r8.xy * float2(2,2) + float2(-1,-1);
        r6.xyzw = cb0[25].xyzw * -r1.wwww;
        r6.xyzw = cb0[24].xyzw * r1.yyyy + r6.xyzw;
        r6.xyzw = cb0[26].xyzw * r8.zzzz + r6.xyzw;
        r6.xyzw = cb0[27].xyzw + r6.xyzw;
        r1.y = cb1[2].z * r8.z + cb1[2].w;
        r1.y = 1 / r1.y;
        r4.xyz = r4.xyz / r4.www;
        r6.xyz = r6.xyz / r6.www;
        r4.xyz = -r6.xyz + r4.xyz;
        r1.w = dot(r4.xyz, r4.xyz);
        r1.w = sqrt(r1.w);
        r1.y = r1.y * r1.y;
        r1.y = 0.00999999978 * r1.y;
        r1.y = cmp(r1.y < r1.w);
        r1.y = r1.y ? 0 : r0.w;
        r1.x = r1.z ? r1.y : r0.w;
      } else {
        r2.zw = float2(0,0);
        r1.x = 0;
      }
      r1.yz = t3.SampleLevel(s0_s, r2.xy, 0).xy;
      r4.xy = abs(r1.yz) * float2(2,2) + float2(-1,-1);
      r4.xy = r4.xy * r4.xy;
      r0.w = 2 / r0.z;
      r0.w = -1 + r0.w;
      r0.w = 1 / r0.w;
      r0.w = -2.03504682 * r0.w;
      r0.w = exp2(r0.w);
      r1.w = 1 + -r0.w;
      r1.w = sqrt(r1.w);
      r3.w = r0.w * -0.0187292993 + 0.0742610022;
      r3.w = r3.w * r0.w + -0.212114394;
      r0.w = r3.w * r0.w + 1.57072878;
      r0.w = r0.w * r1.w;
      r6.xyzw = cb0[25].xyzw * r3.yyyy;
      r6.xyzw = cb0[24].xyzw * r3.xxxx + r6.xyzw;
      r6.xyzw = cb0[26].xyzw * r3.zzzz + r6.xyzw;
      r6.xyzw = cb0[27].xyzw + r6.xyzw;
      r6.xyzw = r6.xyzw / r6.wwww;
      r3.xy = r8.xy * float2(2,2) + float2(-1,-1);
      r7.xyzw = cb0[25].xyzw * r3.yyyy;
      r7.xyzw = cb0[24].xyzw * r3.xxxx + r7.xyzw;
      r7.xyzw = cb0[26].xyzw * r8.zzzz + r7.xyzw;
      r7.xyzw = cb0[27].xyzw + r7.xyzw;
      r3.xyw = cb0[44].xyz + -r6.xyz;
      r1.w = dot(r3.xyw, r3.xyw);
      r4.z = rsqrt(r1.w);
      r8.xyz = r4.zzz * r3.xyw;
      r1.w = sqrt(r1.w);
      r4.w = cmp(abs(r5.w) < 0.999000013);
      r9.z = r4.w ? 0 : 1;
      r9.y = r4.w ? 1.000000 : 0;
      r9.x = 0;
      r10.xyz = r9.xyz * r5.xyw;
      r9.xyz = r9.zxy * r5.ywx + -r10.xyz;
      r4.w = dot(r9.xyz, r9.xyz);
      r4.w = rsqrt(r4.w);
      r9.xyz = r9.xyz * r4.www;
      r7.xyzw = r7.xyzw / r7.wwww;
      r6.xyzw = r7.xyzw + -r6.xyzw;
      r4.w = dot(r6.xyzw, r6.xyzw);
      r4.w = sqrt(r4.w);
      r6.xyz = r9.zxy * r8.xyz;
      r6.xyz = r9.yzx * r8.yzx + -r6.xyz;
      sincos(r0.w, r7.x, r10.x);
      r7.yzw = -r8.xyz * r1.www + cb0[44].xyz;
      r10.yzw = r9.xyz * r5.xyw;
      r5.xyz = r5.wxy * r9.yzx + -r10.yzw;
      r9.xyz = r5.xyz * r8.xyz;
      r5.xyz = r5.zxy * r8.yzx + -r9.xyz;
      r0.w = r4.w + r1.w;
      r9.xyz = r8.xyz * r0.www;
      r10.yzw = cb0[21].xyw * -r9.yyy;
      r9.xyw = cb0[20].xyw * -r9.xxx + r10.yzw;
      r9.xyz = cb0[22].xyw * -r9.zzz + r9.xyw;
      r9.xyz = cb0[23].xyw + r9.xyz;
      r9.xy = r9.xy / r9.zz;
      r9.xy = r9.xy * float2(0.5,0.5) + float2(0.5,0.5);
      r9.xy = cb2[0].xy * r9.xy;
      r0.w = dot(r6.yzx, -r8.xyz);
      r10.yzw = r6.yzx * r0.www;
      r11.xyz = -r3.xyw * r4.zzz + -r10.yzw;
      r10.yzw = r10.xxx * r11.xyz + r10.yzw;
      r11.xyz = r6.xyz * -r8.yzx;
      r6.xyz = r6.zxy * -r8.zxy + -r11.xyz;
      r6.xyz = r6.xyz * r7.xxx + r10.yzw;
      r6.xyz = r6.xyz * r4.www + r7.yzw;
      r6.xyz = -cb0[44].xyz + r6.xyz;
      r10.yzw = cb0[21].xyw * r6.yyy;
      r6.xyw = cb0[20].xyw * r6.xxx + r10.yzw;
      r6.xyz = cb0[22].xyw * r6.zzz + r6.xyw;
      r6.xyz = cb0[23].xyw + r6.xyz;
      r0.w = dot(r5.yzx, -r8.xyz);
      r10.yzw = r5.yzx * r0.www;
      r3.xyw = -r3.xyw * r4.zzz + -r10.yzw;
      r3.xyw = r10.xxx * r3.xyw + r10.yzw;
      r10.xyz = r5.xyz * -r8.yzx;
      r5.xyz = r5.zxy * -r8.zxy + -r10.xyz;
      r3.xyw = r5.xyz * r7.xxx + r3.xyw;
      r3.xyw = r3.xyw * r4.www + r7.yzw;
      r3.xyw = -cb0[44].xyz + r3.xyw;
      r5.xyz = cb0[21].xyw * r3.yyy;
      r5.xyz = cb0[20].xyw * r3.xxx + r5.xyz;
      r3.xyw = cb0[22].xyw * r3.www + r5.xyz;
      r3.xyw = cb0[23].xyw + r3.xyw;
      r4.xy = r4.xy * r4.xy;
      r1.yz = float2(-0.5,-0.5) + r1.yz;
      r4.zw = cmp(float2(0,0) < r1.yz);
      r1.yz = cmp(r1.yz < float2(0,0));
      r1.yz = (int2)-r4.zw + (int2)r1.yz;
      r1.yz = (int2)r1.yz;
      r1.yz = r4.xy * r1.yz + r2.zw;
      r1.yz = cb1[0].xy * r1.yz;
      r0.w = dot(r1.yz, r1.yz);
      r0.w = sqrt(r0.w);
      r1.y = cb1[2].z * r3.z + cb1[2].w;
      r1.y = 0.0199999996 / r1.y;
      r1.y = log2(r1.y);
      r1.y = saturate(r1.y * 0.693147182 + 0.00999999978);
      r0.w = r1.y * -r0.w;
      r0.w = 1.44269502 * r0.w;
      r4.x = exp2(r0.w);
      r0.z = cmp(9.99999975e-005 >= r0.z);
      r1.yz = r6.xy / r6.zz;
      r1.yz = r1.yz * float2(0.5,0.5) + float2(0.5,0.5);
      r1.yz = -r1.yz * cb2[0].xy + r9.xy;
      r0.w = dot(r1.yz, r1.yz);
      r1.yz = r3.xy / r3.ww;
      r1.yz = r1.yz * float2(0.5,0.5) + float2(0.5,0.5);
      r1.yz = -r1.yz * cb2[0].xy + r9.xy;
      r1.y = dot(r1.yz, r1.yz);
      r0.w = r1.y + r0.w;
      r0.w = sqrt(r0.w);
      r0.w = 0.5 * r0.w;
      r0.w = log2(r0.w);
      r0.w = max(0, r0.w);
      r0.w = min(cb2[5].y, r0.w);
      r0.w = r0.w / cb2[5].y;
      r4.y = r0.z ? 0 : r0.w;
    } else {
      r4.xy = float2(0,0);
    }
    if (shader_injection.improved_ssr >= 0.5f) {
      float mip_threshold = 0.25f;
      r4.y = saturate((r4.y - mip_threshold) / (1.0f - mip_threshold));
    }
    u0[(uint2)r0.xy] = r2.xyxx;
    u1[(uint2)r0.xy] = r4.xyxx;
    u2[(uint2)r0.xy] = r1.xxxx;
  }
  return;
  // Approximately 0 instruction slots used
}
