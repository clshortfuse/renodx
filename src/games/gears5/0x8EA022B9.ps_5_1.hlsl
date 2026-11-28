#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Mon Nov 23 17:45:28 2026
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


void main(
  float4 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Native tactical palettes/outlines represent UI white, not scene peak.
  float tactical_white_scale = 1.f;
  if (GEARS5_CUSTOM_HDR_ENABLED) {
    tactical_white_scale = GEARS5_HDR_UI_NITS / GEARS5_HDR_PEAK_NITS;
  }

  r0.xy = v0.xy * cb0[32].zw + cb0[32].xy;
  r1.xyz = t1.SampleLevel(s1_s, v0.xy, 0).xyz;
  r1.xyz = r1.xyz * r1.xyz;
  r0.zw = -cb0[35].zw + r0.xy;
  r0.zw = cb0[35].xy * r0.zw;
  r0.zw = trunc(r0.zw);
  r2.xy = (int2)r0.zw;
  r2.zw = float2(0,0);
  r0.z = t3.Load(r2.xyz).y;
  r3.xyzw = (int4)r2.xyxy + int4(1,1,1,0);
  r4.xy = r3.zw;
  r4.zw = float2(0,0);
  r0.w = t3.Load(r4.xyz).y;
  r3.zw = float2(0,0);
  r1.w = t3.Load(r3.xyz).y;
  r2.xy = (int2)r2.xy + int2(0,1);
  r2.zw = float2(0,0);
  r2.x = t3.Load(r2.xyz).y;
  r2.y = max((uint)r0.z, (uint)r0.w);
  r2.z = max((uint)r2.x, (uint)r1.w);
  r2.y = max((uint)r2.y, (uint)r2.z);
  r2.z = (int)r2.y & 248;
  r3.xy = cmp((int2)r2.zz == int2(168,16));
  r2.w = (int)r3.y | (int)r3.x;
  r3.y = cmp(cb0[34].z != 0.000000);
  r3.z = (int)r2.w | (int)r3.y;
  if (r3.z != 0) {
    r3.z = t4.SampleLevel(s0_s, r0.xy, 0).x;
    r3.w = cmp(r3.z != 0.000000);
    r3.z = r3.z * cb1[51].z + -cb1[51].w;
    r3.z = 1 / r3.z;
    if (r2.w != 0) {
      r2.w = t0.SampleLevel(s0_s, r0.xy, 0).x;
      r2.w = r2.w * cb1[51].z + -cb1[51].w;
      r2.w = 1 / r2.w;
      r4.x = -5 + r3.z;
      r2.w = cmp(r2.w < r4.x);
      r2.w = r2.w ? r3.w : 0;
      r2.w = ~(int)r2.w;
    } else {
      r2.w = -1;
    }
  } else {
    r2.w = -1;
    r3.z = 0;
  }
  r3.w = r3.x ? r2.w : 0;
  if (r3.w != 0) {
    r2.z = 0;
  }
  if (r3.w == 0) {
    r3.z = -cb0[34].x + r3.z;
    r3.z = saturate(cb0[34].z * r3.z);
    r3.w = -1 + cb0[34].y;
    r3.z = r3.z * r3.w + 1;
    r3.y = r3.y ? r3.z : 1;
    r2.w = (int)r3.x | (int)r2.w;
    if (r2.w != 0) {
      r3.xz = cb0[35].xy * r0.xy;
      r3.xz = trunc(r3.xz);
      r4.xy = (int2)r3.xz;
      r4.zw = float2(0,0);
      r2.w = t3.Load(r4.xyz).y;
      r5.xyzw = (int4)r4.xyxy + int4(1,1,1,0);
      r6.xy = r5.zw;
      r6.zw = float2(0,0);
      r3.x = t3.Load(r6.xyz).y;
      r5.zw = float2(0,0);
      r3.z = t3.Load(r5.xyz).y;
      r4.xy = (int2)r4.xy + int2(0,1);
      r4.zw = float2(0,0);
      r3.w = t3.Load(r4.xyz).y;
      r4.x = (int)r2.w + (int)-r3.x;
      r4.y = (int)-r3.w + (int)r3.z;
      r4.xy = (uint2)r4.xy;
      r3.x = (int)-r3.z + (int)r3.x;
      r3.x = (uint)r3.x;
      r2.w = (int)r2.w + (int)-r3.w;
      r2.w = (uint)r2.w;
      r3.z = max(r4.x, r4.y);
      r3.x = max(r3.z, r3.x);
      r2.w = max(r3.x, r2.w);
      r2.w = min(1, r2.w);
      r3.x = (int)-r0.w + (int)r0.z;
      r3.z = (int)r1.w + (int)-r2.x;
      r3.xz = (uint2)r3.xz;
      r0.w = (int)r0.w + (int)-r1.w;
      r0.z = (int)r0.z + (int)-r2.x;
      r0.zw = (uint2)r0.zw;
      r1.w = max(r3.x, r3.z);
      r0.w = max(r1.w, r0.w);
      r0.z = max(r0.w, r0.z);
      r0.z = min(1, r0.z);
      r3.xzw = max(r2.www, r0.zzz);
    } else {
      r0.xyzw = t1.Gather(s1_s, r0.xy).xyzw;
      r0.xyzw = r0.xzyx + -r0.ywzw;
      r0.xyzw = -cb0[40].yyyy + abs(r0.xyzw);
      r0.xyzw = saturate(cb0[40].xxxx * r0.xyzw);
      r0.x = max(r0.x, r0.y);
      r0.x = max(r0.x, r0.z);
      r0.x = max(r0.x, r0.w);
      r3.xzw = cb0[40].zzz * r0.xxx;
    }
    r0.xyz = r3.yyy * r3.xzw;
  } else {
    r0.xyz = float3(0,0,0);
  }
  r0.w = cmp((int)r2.z == 32);
  if (r0.w != 0) {
    r2.xw = cb0[1].xy * v0.xy;
    r0.w = dot(float2(0.5,-0.5), r2.xw);
    r1.w = dot(float2(0.5,0.5), r2.xw);
    r2.x = 0.5 * r1.w;
    r2.x = floor(r2.x);
    r2.x = r2.x + r2.x;
    r2.w = floor(r1.w);
    r3.x = (uint)r2.w;
    r3.x = (int)r3.x & 1;
    r3.y = 0.5 * r0.w;
    r3.y = floor(r3.y);
    r3.y = r3.y * 2 + r2.x;
    r3.z = r0.w * 0.5 + 0.5;
    r3.z = floor(r3.z);
    r2.x = r3.z * 2 + r2.x;
    r3.y = r3.x ? r2.x : r3.y;
    r2.x = floor(r0.w);
    r4.z = r2.w + -r2.x;
    r5.x = frac(r1.w);
    r5.y = frac(-r0.w);
    r2.xw = float2(-0.5,-0.5) + r5.xy;
    r3.zw = float2(-0.5,-0.5) + abs(r2.xw);
    r0.w = min(-r3.z, -r3.w);
    r5.x = r2.x + -r2.w;
    r5.y = r2.x + r2.w;
    r2.xw = abs(r5.xy) * float2(0.707000017,0.707000017) + float2(-0.5,-0.5);
    r0.w = min(abs(r2.x), r0.w);
    r3.x = min(r0.w, abs(r2.w));
    r2.xw = cmp(r5.xy < float2(-0.707000017,-0.707000017));
    r6.y = -1 + r3.y;
    r7.xy = float2(0.707000017,-0.707000017) + r5.xx;
    r6.x = -r7.x;
    r3.xy = r2.xx ? r6.xy : r3.xy;
    r3.zw = cmp(float2(0.707000017,0.707000017) < r5.xy);
    r7.z = 1 + r3.y;
    r4.xy = r3.zz ? r7.yz : r3.xy;
    r5.xy = float2(0.707000017,-0.707000017) + r5.yy;
    r3.x = -r5.x;
    r3.z = -1 + r4.z;
    r0.w = (uint)r3.z;
    r0.w = (int)r0.w & 1;
    r6.xy = float2(1,-1) + r4.yy;
    r3.y = r0.w ? r6.y : r6.x;
    r3.xyz = r2.www ? r3.xyz : r4.xyz;
    r4.xyz = float3(1,1,-1) + r3.zyy;
    r0.w = (uint)r4.x;
    r0.w = (int)r0.w & 1;
    r5.z = r0.w ? r4.z : r4.y;
    r5.w = r4.x;
    r3.xyz = r3.www ? r5.yzw : r3.xyz;
    r2.xw = r3.yz / cb0[1].xy;
    r3.yzw = t2.SampleLevel(s2_s, r2.xw, 0).xyz;
    r3.yzw = r3.yzw + r3.yzw;
    r3.yzw = sqrt(r3.yzw);
    r0.w = dot(float3(0.300000012,0.600000024,0.100000001), r3.yzw);
    r0.w = min(1, r0.w);
    r1.w = saturate(-cb0[33].y + r0.w);
    r1.w = 0.0199999996 + r1.w;
    r2.x = cb0[33].z + -cb0[33].y;
    r1.w = r1.w / r2.x;
    r0.w = max(cb0[33].y, r0.w);
    r0.w = min(cb0[33].z, r0.w);
    r2.x = -r3.x * 2 + 1;
    r0.w = r2.x + -r0.w;
    r2.x = 10 * abs(r0.w);
    r2.x = min(1, r2.x);
    r2.x = 1 + -r2.x;
    r0.w = saturate(r0.w);
    r0.w = 10 * r0.w;
    r0.w = min(1, r0.w);
    r0.w = 1 + -r0.w;
    r0.w = r2.x * 3 + r0.w;
    r0.w = r0.w * r1.w;
    r3.xyz = r0.www * cb0[33].xxx * tactical_white_scale + r1.xyz;
  } else {
    r4.xyz = cb0[37].xyz * r1.yyy;
    r1.xyw = cb0[36].xyz * r1.xxx + r4.xyz;
    r1.xyz = cb0[38].xyz * r1.zzz + r1.xyw;
    r3.xyz = saturate(cb0[39].xyz * tactical_white_scale + r1.xyz);
  }
  r0.w = (uint)r2.z >> 3;
  r0.w = 1 << (int)r0.w;
  r1.xy = (int2)r0.ww & int2(0xaaa60,0x355580);
  if (r1.x != 0) {
    r0.w = (uint)r2.z >> 3;
    r1.xzw = cb0[r0.w+41].xyz * tactical_white_scale + -r3.xyz;
    r1.xzw = r1.xzw * float3(0.5,0.5,0.5) + r3.xyz;
  } else {
    r0.w = cmp((int)r2.z == 24);
    r4.xyz = r3.xyz * float3(0.5,0.5,0.5) + 0.5f * tactical_white_scale;
    r5.xyz = float3(0.300000012,0.300000012,0.300000012) * r0.xyz;
    r0.xyz = r0.www ? r5.xyz : r0.xyz;
    r1.xzw = r0.www ? r4.xyz : r3.xyz;
  }
  if (r1.y != 0) {
    r0.w = (uint)r2.z >> 3;
    r3.xyz = cb0[r0.w+41].xyz * tactical_white_scale + -r1.xzw;
    r3.xyz = r0.xyz * r3.xyz + r1.xzw;
  } else {
    r0.w = cmp((int)r2.y != 0);
    r1.y = cmp((int)r2.z != 0);
    r0.w = r0.w ? r1.y : 0;
    r0.xyz = r1.xzw + r0.xyz * tactical_white_scale;
    r3.xyz = r0.www ? r0.xyz : r1.xzw;
  }
  r0.xyz = sqrt(r3.xyz);
  o0.w = dot(r0.xyz, float3(0.300000012,0.600000024,0.100000001));
  o0.xyz = r0.xyz;
  return;
}
