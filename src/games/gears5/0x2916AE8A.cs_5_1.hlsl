#include "./common.hlsl"

RWTexture2D<float4> u0 : register(u0);
// ---- Created with 3Dmigoto v1.3.16 on Sun Nov 22 10:45:42 2026
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[24];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[13];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[33];
}




// 3Dmigoto declarations
#define cmp -


[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = (int4)vThreadID.xyyy + asint(cb0[32].xyyy);
  r1.xy = (int2)r0.xw;
  r1.xy = float2(0.5,0.5) + r1.xy;
  r1.zw = asuint(cb0[32].xy);
  r1.xy = r1.xy + -r1.zw;
  r1.zw = cb0[30].zw * r1.xy;
  r1.xy = r1.xy * cb0[30].zw + float2(-0.5,-0.5);
  r2.x = max(abs(r1.x), abs(r1.y));
  r2.x = cmp(r2.x >= 0.5);
  if (r2.x != 0) {
    return;
  }
  r2.x = 0.0500000007 * cb1[12].z;
  sincos(r2.x, r2.x, r3.x);
  r4.x = -r2.x;
  r4.y = r3.x;
  r3.x = dot(r4.yx, r1.xy);
  r4.z = r2.x;
  r3.y = dot(r4.zy, r1.xy);
  r2.xy = float2(0.5,0.5) + r3.xy;
  r2.x = t0.SampleLevel(s0_s, r2.xy, 0).x;
  r2.y = r2.x * -0.199999988 + 1;
  r2.zw = r1.zw / cb2[4].xy;
  r2.zw = float2(0.5,0.5) + r2.zw;
  r3.xy = float2(0.5,0.5) / cb2[4].xy;
  r2.zw = -r3.xy + r2.zw;
  r3.xy = r2.xx * float2(0.00300000003,0.00300000003) + r2.zw;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xy, 0).xyzw;
  r3.yz = r3.yz + -r3.xw;
  r3.xy = cb2[16].ww * r3.yz + r3.xw;
  r2.x = r3.x * 0.5 + 0.5;
  r3.zw = r1.zw / cb2[6].xy;
  r3.zw = float2(0.5,0.5) + r3.zw;
  r4.xy = float2(0.5,0.5) / cb2[6].xy;
  r3.zw = -r4.xy + r3.zw;
  r4.xyz = t2.SampleLevel(s2_s, r3.zw, 0).xyw;
  r4.xz = float2(1,1) + -r4.xz;
  r4.z = r4.z + -r4.x;
  r4.x = cb2[17].z * r4.z + r4.x;
  r3.zw = float2(-0.5,-0.5) + r3.zw;
  r4.z = dot(r3.zw, r3.zw);
  r4.z = sqrt(r4.z);
  r4.z = 1 + -r4.z;
  r4.y = 0.75 * r4.y;
  r4.y = cb2[17].z * -r4.y + r4.y;
  r4.x = r4.x * r4.z + r4.y;
  r4.y = 6.28318548 * cb2[17].w;
  r5.xy = -r3.zw;
  r5.z = 0;
  r4.zw = r5.zx + -r5.yz;
  sincos(r4.y, r5.x, r6.x);
  r5.xy = r5.xx * r4.zw;
  r5.xy = r3.zw * r6.xx + r5.xy;
  r5.xy = float2(0.5,0.5) + r5.xy;
  r4.y = 6.28318548 * cb2[18].z;
  r5.zw = cb2[18].xx * float2(1.04999995,0.11500001) + float2(0.100000001,1);
  r5.xy = r5.xy / r5.zw;
  r5.xy = float2(0.5,0.5) + r5.xy;
  r5.zw = float2(0.5,0.5) / r5.zw;
  r5.xy = r5.xy + -r5.zw;
  r5.x = t2.SampleLevel(s2_s, r5.xy, 0).z;
  r5.x = cb2[18].y * r5.x;
  r5.x = 0.5 * r5.x;
  sincos(r4.y, r6.x, r7.x);
  r5.yz = r6.xx * r4.zw;
  r5.yz = r3.zw * r7.xx + r5.yz;
  r5.yz = float2(0.5,0.5) + r5.yz;
  r6.xy = cb2[18].ww * float2(1.04999995,0.11500001) + float2(0.100000001,1);
  r5.yz = r5.yz / r6.xy;
  r5.yz = float2(0.5,0.5) + r5.yz;
  r6.xy = float2(0.5,0.5) / r6.xy;
  r5.yz = -r6.xy + r5.yz;
  r4.y = t2.SampleLevel(s2_s, r5.yz, 0).z;
  r4.y = cb2[19].x * r4.y;
  r4.y = 0.5 * r4.y;
  r4.y = max(r5.x, r4.y);
  r5.x = 6.28318548 * cb2[19].y;
  sincos(r5.x, r5.x, r6.x);
  r5.xy = r5.xx * r4.zw;
  r5.xy = r3.zw * r6.xx + r5.xy;
  r5.xy = float2(0.5,0.5) + r5.xy;
  r5.zw = cb2[19].zz * float2(1.04999995,0.11500001) + float2(0.100000001,1);
  r5.xy = r5.xy / r5.zw;
  r5.xy = float2(0.5,0.5) + r5.xy;
  r5.zw = float2(0.5,0.5) / r5.zw;
  r5.xy = r5.xy + -r5.zw;
  r5.x = t2.SampleLevel(s2_s, r5.xy, 0).z;
  r5.x = cb2[19].w * r5.x;
  r5.x = 0.5 * r5.x;
  r4.y = max(r5.x, r4.y);
  r5.x = 6.28318548 * cb2[20].x;
  sincos(r5.x, r5.x, r6.x);
  r4.zw = r5.xx * r4.zw;
  r3.zw = r3.zw * r6.xx + r4.zw;
  r3.zw = float2(0.5,0.5) + r3.zw;
  r5.xyz = cb2[20].yyw * float3(1.04999995,0.11500001,-3) + float3(0.100000001,1,4);
  r3.zw = r3.zw / r5.xy;
  r3.zw = float2(0.5,0.5) + r3.zw;
  r4.zw = float2(0.5,0.5) / r5.xy;
  r3.zw = -r4.zw + r3.zw;
  r3.z = t2.SampleLevel(s2_s, r3.zw, 0).z;
  r3.z = cb2[20].z * r3.z;
  r3.z = 0.5 * r3.z;
  r3.z = max(r4.y, r3.z);
  r3.w = r4.x * r3.z;
  r4.yz = r1.zw / cb2[10].xy;
  r4.yz = float2(0.5,0.5) + r4.yz;
  r5.xy = float2(0.5,0.5) / cb2[10].xy;
  r4.yz = -r5.xy + r4.yz;
  r4.yz = t1.SampleLevel(s1_s, r4.yz, 0).xy;
  r4.z = r4.z + -r4.y;
  r4.y = cb2[16].w * r4.z + r4.y;
  r2.zw = float2(-0.5,-0.5) + r2.zw;
  r2.z = dot(r2.zw, r2.zw);
  r2.z = sqrt(r2.z);
  r2.w = -0.449999988 + r2.z;
  r2.w = -2.22222233 * r2.w;
  r2.w = max(0, r2.w);
  r4.z = r2.w * -2 + 3;
  r2.w = r2.w * r2.w;
  r2.w = r4.z * r2.w;
  r4.zw = cb2[21].xx * float2(-0.75,0.099999994) + float2(1,0.300000012);
  r5.xy = float2(0.100000001,0.300000012) + -r4.zw;
  r4.zw = cb2[20].ww * r5.xy + r4.zw;
  r2.w = r4.z * r2.w;
  r2.w = r4.y * r5.z + r2.w;
  r2.z = -r4.w + r2.z;
  r4.y = 1 / -r4.w;
  r2.z = saturate(r4.y * r2.z);
  r4.y = r2.z * -2 + 3;
  r2.z = r2.z * r2.z;
  r2.z = r4.y * r2.z;
  r2.z = r2.w * r2.z;
  r2.w = cb2[21].x * r4.x;
  r2.z = r2.z * r2.w;
  r2.w = r3.w * 0.300000012 + r2.z;
  r2.x = r2.y * r2.x + r2.w;
  r4.yzw = -cb2[14].xyz + cb2[13].xyz;
  r4.yzw = r3.yyy * r4.yzw + cb2[14].xyz;
  r2.xyw = r2.xxx * r4.yzw + cb2[15].xyz;
  r3.x = cb2[20].w * r3.x;
  r2.z = r2.z * 3 + r3.x;
  r2.z = cb2[21].w * r2.z;
  r5.xyzw = cb2[22].xxzx * float4(-1.25,-1.10000002,-0.0600000024,-0.149999991) + float4(0.75,1,0.50999999,0.349999994);
  r3.x = dot(r1.xy, r1.xy);
  r3.x = sqrt(r3.x);
  r3.y = r5.y + -r5.x;
  r3.x = r3.x + -r5.x;
  r3.y = 1 / r3.y;
  r3.x = saturate(r3.x * r3.y);
  r3.y = r3.x * -2 + 3;
  r3.x = r3.x * r3.x;
  r3.x = r3.y * r3.x;
  r3.x = cb2[20].w * r3.x;
  r3.y = 0.600000024 + -r5.z;
  r1.xy = -r5.zz + abs(r1.xy);
  r3.y = 1 / r3.y;
  r1.xy = saturate(r3.yy * r1.xy);
  r3.yw = r1.xy * float2(-2,-2) + float2(3,3);
  r1.xy = r1.xy * r1.xy;
  r1.xy = r3.yw * r1.xy;
  r3.x = max(r3.x, r1.y);
  r1.x = max(r1.x, r1.y);
  r1.x = 0.5 * r1.x;
  r3.x = r3.x * cb2[22].w + r1.x;
  r3.x = r4.x * cb2[21].x + r3.x;
  r3.yw = cb2[23].xx * float2(-1.25,-1.10000002) + float2(0.75,1);
  r1.zw = r1.zw * float2(0.349999994,1) + float2(-0.174999997,-0.5);
  r1.z = dot(r1.zw, r1.zw);
  r1.z = sqrt(r1.z);
  r1.w = r3.w + -r3.y;
  r1.z = r1.z + -r3.y;
  r1.w = 1 / r1.w;
  r1.z = saturate(r1.z * r1.w);
  r1.w = r1.z * -2 + 3;
  r1.z = r1.z * r1.z;
  r1.z = r1.w * r1.z;
  r1.z = cb2[20].w * r1.z;
  r1.y = max(r1.z, r1.y);
  r1.x = r1.y * r5.w + r1.x;
  r1.x = 1 + -r1.x;
  r1.y = -r4.x * r3.z + 1;
  r1.x = r1.x * r1.y;
  r1.x = r2.z * r3.x + -r1.x;
  r1.x = 1 + r1.x;
  r1.x = saturate(cb2[23].y * r1.x);
  r1.w = saturate(cb2[23].w * r1.x);
  r1.xyz = max(float3(0,0,0), r2.xyw);
  if (GEARS5_CUSTOM_HDR_ENABLED) {
    // This HUD is blended after the scene LUT, directly into the gamma-2
    // carrier. Native SDR colors must represent UI white rather than HDR peak.
    r1.rgb = sqrt(renodx::color::srgb::Decode(saturate(r1.rgb))
        * (GEARS5_HDR_UI_NITS / GEARS5_HDR_PEAK_NITS));
  }
u0[uint2(r0.xy)] = r1;
  return;
}
