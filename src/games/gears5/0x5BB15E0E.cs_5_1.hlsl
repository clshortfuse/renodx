#include "./common.hlsl"

RWTexture2D<float4> u0 : register(u0);
// ---- Created with 3Dmigoto v1.3.16 on Sat Nov 21 21:15:37 2026
Texture2D<float4> t4 : register(t4);

Texture2D<uint4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[52];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[63];
}




// 3Dmigoto declarations
#define cmp -


[numthreads(8, 8, 1)]
void main(uint3 vThreadID : SV_DispatchThreadID)
{
// Needs manual fix for instruction:
// unknown dcl_: dcl_uav_typed_texture2d (float,float,float,float) u0
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

// Needs manual fix for instruction:
// unknown dcl_: dcl_thread_group 8, 8, 1
  // Scene values are peak-relative here. Native tactical palettes and
  // additive outlines are SDR-white-relative, so give those contributions
  // their own scale instead of treating white as the scene's HDR peak.
  float tactical_white_scale = 1.f;
  if (GEARS5_CUSTOM_HDR_ENABLED) {
    tactical_white_scale = GEARS5_HDR_UI_NITS / GEARS5_HDR_PEAK_NITS;
  }

  r0.xy = (uint2)vThreadID.xy;
  r0.xy = float2(0.5,0.5) + r0.xy;
  r0.xy = cb0[22].zw * r0.xy;
  r1.xyzw = (int4)vThreadID.xyyy + asint(cb0[24].xyyy);
  r0.zw = r0.xy * cb0[32].zw + cb0[32].xy;
  r2.xyz = t1.SampleLevel(s1_s, r0.xy, 0).xyz;
  r2.xyz = r2.xyz * r2.xyz;
  r3.xy = -cb0[35].zw + r0.zw;
  r3.xy = cb0[35].xy * r3.xy;
  r3.xy = trunc(r3.xy);
  r3.xy = (int2)r3.xy;
  r3.zw = float2(0,0);
  r2.w = t3.Load(r3.xyz).y;
  r4.xyzw = (int4)r3.xyxy + int4(1,1,1,0);
  r5.xy = r4.zw;
  r5.zw = float2(0,0);
  r3.z = t3.Load(r5.xyz).y;
  r4.zw = float2(0,0);
  r3.w = t3.Load(r4.xyz).y;
  r4.xy = (int2)r3.xy + int2(0,1);
  r4.zw = float2(0,0);
  r3.x = t3.Load(r4.xyz).y;
  r3.y = max((uint)r3.z, (uint)r2.w);
  r4.x = max((uint)r3.w, (uint)r3.x);
  r3.y = max((uint)r4.x, (uint)r3.y);
  r4.x = (int)r3.y & 248;
  r4.yz = cmp((int2)r4.xx == int2(168,16));
  r4.z = (int)r4.z | (int)r4.y;
  r4.w = cmp(cb0[34].z != 0.000000);
  r5.x = (int)r4.w | (int)r4.z;
  if (r5.x != 0) {
    r5.x = t4.SampleLevel(s0_s, r0.zw, 0).x;
    r5.y = cmp(r5.x != 0.000000);
    r5.x = r5.x * cb1[51].z + -cb1[51].w;
    r5.x = 1 / r5.x;
    if (r4.z != 0) {
      r4.z = t0.SampleLevel(s0_s, r0.zw, 0).x;
      r4.z = r4.z * cb1[51].z + -cb1[51].w;
      r4.z = 1 / r4.z;
      r5.z = -5 + r5.x;
      r4.z = cmp(r4.z < r5.z);
      r4.z = r4.z ? r5.y : 0;
      r4.z = ~(int)r4.z;
    } else {
      r4.z = -1;
    }
  } else {
    r4.z = -1;
    r5.x = 0;
  }
  r5.y = r4.y ? r4.z : 0;
  if (r5.y != 0) {
    r4.x = 0;
  }
  if (r5.y == 0) {
    r5.x = -cb0[34].x + r5.x;
    r5.x = saturate(cb0[34].z * r5.x);
    r5.y = -1 + cb0[34].y;
    r5.x = r5.x * r5.y + 1;
    r4.w = r4.w ? r5.x : 1;
    r4.y = (int)r4.y | (int)r4.z;
    if (r4.y != 0) {
      r4.yz = cb0[35].xy * r0.zw;
      r4.yz = trunc(r4.yz);
      r5.xy = (int2)r4.yz;
      r5.zw = float2(0,0);
      r4.y = t3.Load(r5.xyz).y;
      r6.xyzw = (int4)r5.xyxy + int4(1,1,1,0);
      r7.xy = r6.zw;
      r7.zw = float2(0,0);
      r4.z = t3.Load(r7.xyz).y;
      r6.zw = float2(0,0);
      r5.z = t3.Load(r6.xyz).y;
      r6.xy = (int2)r5.xy + int2(0,1);
      r6.zw = float2(0,0);
      r5.x = t3.Load(r6.xyz).y;
      r5.y = (int)-r4.z + (int)r4.y;
      r5.w = (int)-r5.x + (int)r5.z;
      r5.yw = (uint2)r5.yw;
      r4.yz = (int2)r4.yz + (int2)-r5.xz;
      r4.yz = (uint2)r4.yz;
      r5.x = max(r5.y, r5.w);
      r4.z = max(r5.x, r4.z);
      r4.y = max(r4.z, r4.y);
      r4.y = min(1, r4.y);
      r4.z = (int)r2.w + (int)-r3.z;
      r4.z = (uint)r4.z;
      r5.x = (int)-r3.x + (int)r3.w;
      r5.x = (uint)r5.x;
      r3.z = (int)-r3.w + (int)r3.z;
      r3.z = (uint)r3.z;
      r2.w = (int)r2.w + (int)-r3.x;
      r2.w = (uint)r2.w;
      r3.x = max(r5.x, r4.z);
      r3.x = max(r3.x, r3.z);
      r2.w = max(r3.x, r2.w);
      r2.w = min(1, r2.w);
      r3.xzw = max(r4.yyy, r2.www);
    } else {
      r5.xyzw = t1.Gather(s1_s, r0.zw).xyzw;
      r5.xyzw = r5.xzyx + -r5.ywzw;
      r5.xyzw = -cb0[40].yyyy + abs(r5.xyzw);
      r5.xyzw = saturate(cb0[40].xxxx * r5.xyzw);
      r0.z = max(r5.x, r5.y);
      r0.z = max(r0.z, r5.z);
      r0.z = max(r0.z, r5.w);
      r3.xzw = cb0[40].zzz * r0.zzz;
    }
    r3.xzw = r4.www * r3.xzw;
  } else {
    r3.xzw = float3(0,0,0);
  }
  r0.z = cmp((int)r4.x == 32);
  if (r0.z != 0) {
    r0.xy = cb0[1].xy * r0.xy;
    r0.z = dot(float2(0.5,-0.5), r0.xy);
    r0.x = dot(float2(0.5,0.5), r0.xy);
    r0.y = 0.5 * r0.x;
    r0.yw = floor(r0.yx);
    r0.y = r0.y + r0.y;
    r2.w = (uint)r0.w;
    r2.w = (int)r2.w & 1;
    r4.y = 0.5 * r0.z;
    r4.y = floor(r4.y);
    r4.y = r4.y * 2 + r0.y;
    r4.z = r0.z * 0.5 + 0.5;
    r4.z = floor(r4.z);
    r0.y = r4.z * 2 + r0.y;
    r5.y = r2.w ? r0.y : r4.y;
    r0.y = floor(r0.z);
    r6.z = r0.w + -r0.y;
    r0.x = frac(r0.x);
    r0.y = frac(-r0.z);
    r0.xy = float2(-0.5,-0.5) + r0.xy;
    r0.zw = float2(-0.5,-0.5) + abs(r0.xy);
    r0.z = min(-r0.z, -r0.w);
    r7.x = r0.x + -r0.y;
    r7.y = r0.x + r0.y;
    r0.xy = abs(r7.xy) * float2(0.707000017,0.707000017) + float2(-0.5,-0.5);
    r0.x = min(r0.z, abs(r0.x));
    r5.x = min(r0.x, abs(r0.y));
    r0.xy = cmp(r7.xy < float2(-0.707000017,-0.707000017));
    r8.y = -1 + r5.y;
    r9.xy = float2(0.707000017,-0.707000017) + r7.xx;
    r8.x = -r9.x;
    r0.xz = r0.xx ? r8.xy : r5.xy;
    r4.yz = cmp(float2(0.707000017,0.707000017) < r7.xy);
    r9.z = 1 + r0.z;
    r6.xy = r4.yy ? r9.yz : r0.xz;
    r5.xy = float2(0.707000017,-0.707000017) + r7.yy;
    r7.x = -r5.x;
    r7.z = -1 + r6.z;
    r0.x = (uint)r7.z;
    r0.x = (int)r0.x & 1;
    r0.zw = float2(1,-1) + r6.yy;
    r7.y = r0.x ? r0.w : r0.z;
    r0.xyz = r0.yyy ? r7.xyz : r6.xyz;
    r6.xyz = float3(1,1,-1) + r0.zyy;
    r0.w = (uint)r6.x;
    r0.w = (int)r0.w & 1;
    r5.z = r0.w ? r6.z : r6.y;
    r5.w = r6.x;
    r0.xyz = r4.zzz ? r5.yzw : r0.xyz;
    r0.yz = r0.yz / cb0[1].xy;
    r0.yzw = t2.SampleLevel(s2_s, r0.yz, 0).xyz;
    r0.yzw = r0.yzw + r0.yzw;
    r0.yzw = sqrt(r0.yzw);
    r0.y = dot(float3(0.300000012,0.600000024,0.100000001), r0.yzw);
    r0.y = min(1, r0.y);
    r0.z = saturate(-cb0[33].y + r0.y);
    r0.z = 0.0199999996 + r0.z;
    r0.w = cb0[33].z + -cb0[33].y;
    r0.z = r0.z / r0.w;
    r0.y = max(cb0[33].y, r0.y);
    r0.y = min(cb0[33].z, r0.y);
    r0.x = -r0.x * 2 + 1;
    r0.x = r0.x + -r0.y;
    r0.y = 10 * abs(r0.x);
    r0.y = min(1, r0.y);
    r0.x = saturate(r0.x);
    r0.x = 10 * r0.x;
    r0.x = min(1, r0.x);
    r0.xy = float2(1,1) + -r0.xy;
    r0.x = r0.y * 3 + r0.x;
    r0.x = r0.x * r0.z;
    r0.xyz = r0.xxx * cb0[33].xxx * tactical_white_scale + r2.xyz;
  } else {
    r4.yzw = cb0[37].xyz * r2.yyy;
    r2.xyw = cb0[36].xyz * r2.xxx + r4.yzw;
    r2.xyz = cb0[38].xyz * r2.zzz + r2.xyw;
    r0.xyz = saturate(cb0[39].xyz * tactical_white_scale + r2.xyz);
  }
  r0.w = (uint)r4.x >> 3;
  r0.w = 1 << (int)r0.w;
  r2.xy = (int2)r0.ww & int2(0xaaa60,0x355580);
  if (r2.x != 0) {
    r0.w = (uint)r4.x >> 3;
    r2.xzw = cb0[r0.w+41].xyz * tactical_white_scale + -r0.xyz;
    r2.xzw = r2.xzw * float3(0.5,0.5,0.5) + r0.xyz;
  } else {
    r0.w = cmp((int)r4.x == 24);
    r4.yzw = r0.xyz * float3(0.5,0.5,0.5) + 0.5f * tactical_white_scale;
    r5.xyz = float3(0.300000012,0.300000012,0.300000012) * r3.xzw;
    r3.xzw = r0.www ? r5.xyz : r3.xzw;
    r2.xzw = r0.www ? r4.yzw : r0.xyz;
  }
  if (r2.y != 0) {
    r0.x = (uint)r4.x >> 3;
    r0.xyz = cb0[r0.x+41].xyz * tactical_white_scale + -r2.xzw;
    r0.xyz = r3.xzw * r0.xyz + r2.xzw;
  } else {
    r0.w = cmp((int)r3.y != 0);
    r2.y = cmp((int)r4.x != 0);
    r0.w = r0.w ? r2.y : 0;
    r3.xyz = r2.xzw + r3.xzw * tactical_white_scale;
    r0.xyz = r0.www ? r3.xyz : r2.xzw;
  }
  r0.xyz = sqrt(r0.xyz);
  r0.w = dot(r0.xyz, float3(0.300000012,0.600000024,0.100000001));
// No code for instruction (needs manual fix):
u0[int2(r1.xy)] = r0;
  return;
}
