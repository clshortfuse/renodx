// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 24 04:33:32 2026
#include "../shared.h"

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

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
  float4 cb2[715];
}

cbuffer cb1 : register(b1)
{
  float4 cb1[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[184];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float3 o0 : SV_Target0)
{
  const float4 icb[] = { { -0.399656, 0.916665, -0.942016, -0.399062},
                              { 0.124512, -0.992218, 0.945586, -0.768907},
                              { 0.852354, 0.522965, -0.094184, -0.929389},
                              { -0.229312, 0.973353, 0.344959, 0.293878},
                              { -0.772406, 0.635129, -0.915886, 0.457714},
                              { 0.792753, -0.609544, -0.815442, -0.879125},
                              { -0.578050, 0.816002, -0.382775, 0.276768},
                              { -0.831130, -0.556079, 0.974844, 0.756484},
                              { 0.807795, 0.589464, 0.443233, -0.975116},
                              { 0.471415, 0.881911, 0.537430, -0.473734},
                              { -0.313974, -0.949432, -0.264969, -0.418930},
                              { -0.945007, -0.327051, 0.791975, 0.190902},
                              { -0.185037, -0.982732, -0.241888, 0.997065},
                              { -0.933756, 0.357911, -0.814100, 0.914376},
                              { -0.997614, 0.069036, 0.199841, 0.786414},
                              { 0.306128, 0.951990, 0.143832, -0.141008} };
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (uint2)v0.xy;
  r0.zw = float2(0,0);
  r1.xyzw = t5.Load(r0.xyw).xyzw;
  r2.xy = (uint2)r0.xy;
  r2.zw = cb0[82].zw * r2.xy;
  r2.zw = r2.zw * float2(2,2) + float2(-1,-1);
  r2.xy = float2(0.5,0.5) + r2.xy;
  r2.xy = cb0[82].zw * r2.xy;
  r2.x = t0.SampleLevel(s0_s, r2.xy, 0).x;
  r3.xyzw = cb0[25].xyzw * -r2.wwww;
  r3.xyzw = cb0[24].xyzw * r2.zzzz + r3.xyzw;
  r2.xyzw = cb0[26].xyzw * r2.xxxx + r3.xyzw;
  r2.xyzw = cb0[27].xyzw + r2.xyzw;
  r2.xyz = r2.xyz / r2.www;
  r0.zw = t6.Load(r0.xyz).xy;
  r0.zw = r0.zw * float2(2,2) + float2(-1,-1);
  r2.w = dot(float2(1,1), abs(r0.zw));
  r3.y = 1 + -r2.w;
  r2.w = cmp(r3.y < 0);
  r4.xy = cmp(r0.zw >= float2(0,0));
  r4.zw = float2(1,1) + -abs(r0.wz);
  r4.xy = r4.xy ? float2(1,1) : float2(-1,-1);
  r4.xy = r4.zw * r4.xy;
  r3.xz = r2.ww ? r4.xy : r0.zw;
  r0.z = dot(r3.xyz, r3.xyz);
  r0.z = rsqrt(r0.z);
  r3.xyz = r3.xyz * r0.zzz;
  r0.z = cmp(cb2[35].w < 0.99000001);
  if (r0.z != 0) {
    r0.z = (int)cb2[35].x;
    r0.w = cmp((int)r0.z == 2);
    r4.xyz = r0.www ? cb2[20].xyz : cb0[44].xyz;
    r4.xyz = -r4.xyz + r2.xyz;
    r0.w = dot(r4.xyz, r4.xyz);
    r0.w = cb2[34].w + -r0.w;
    r0.w = saturate(cb2[34].z * r0.w);
    r2.w = cmp(0 < r0.w);
    if (r2.w != 0) {
      r0.z = cmp(0 < (int)r0.z);
      if (r0.z != 0) {
        r4.xyz = -cb2[20].xyz + r2.xyz;
        r5.xyz = -cb2[21].xyz + r2.xyz;
        r6.xyz = -cb2[22].xyz + r2.xyz;
        r7.xyz = -cb2[23].xyz + r2.xyz;
        r0.z = dot(r4.xyz, r4.xyz);
        r2.w = dot(r5.xyz, r5.xyz);
        r3.w = dot(r6.xyz, r6.xyz);
        r4.x = dot(r7.xyz, r7.xyz);
        r5.x = cmp(r0.z < cb2[20].w);
        r5.y = cmp(r2.w < cb2[21].w);
        r5.z = cmp(r3.w < cb2[22].w);
        r5.w = cmp(r4.x < cb2[23].w);
        r4.xyzw = r5.xyzw ? float4(1,1,1,1) : 0;
        r5.xyz = r5.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
        r5.xyz = r5.xyz + r4.yzw;
        r4.yzw = max(float3(0,0,0), r5.xyz);
        r0.z = dot(r4.xyzw, float4(4,3,2,1));
        r0.z = 4 + -r0.z;
        r0.z = max(0, r0.z);
        r0.z = min(3, r0.z);
        r0.z = max(cb2[34].y, r0.z);
        r2.w = (uint)r0.z;
        r3.w = (uint)r2.w << 2;
        r4.x = dot(r3.xyz, cb1[0].xyz);
        r4.x = max(0, r4.x);
        r4.x = min(0.899999976, r4.x);
        r4.x = 1 + -r4.x;
        r2.w = cb2[r2.w+24].x * r4.x;
        r2.w = max(0, r2.w);
        r4.xyz = -cb1[0].xyz * r2.www + r2.xyz;
        r5.xyz = cb2[r3.w+1].xyz * r4.yyy;
        r4.xyw = cb2[r3.w+0].xyz * r4.xxx + r5.xyz;
        r4.xyz = cb2[r3.w+2].xyz * r4.zzz + r4.xyw;
        r4.xyz = cb2[r3.w+3].xyz + r4.xyz;
        r5.xyz = cmp(float3(0,0,0) >= r4.xyz);
        r6.xyz = cmp(r4.xyz >= float3(1,1,1));
        r5.xyz = (int3)r5.xyz | (int3)r6.xyz;
        r2.w = (int)r5.y | (int)r5.x;
        r2.w = (int)r5.z | (int)r2.w;
        r3.w = (int)r4.z & 0x7fffffff;
        r3.w = cmp(0x7f800000 < (uint)r3.w);
        r5.z = (int)r2.w | (int)r3.w;
        r0.z = (int)r0.z;
        r4.xy = r4.xy * cb2[r0.z+28].zw + cb2[r0.z+28].xy;
        r6.xy = r4.xy * cb2[32].zw + float2(0.5,0.5);
        r6.xy = floor(r6.xy);
        r4.xy = r4.xy * cb2[32].zw + -r6.xy;
        r7.xyzw = float4(0.5,1,0.5,1) + r4.xxyy;
        r8.xw = r7.xz * r7.xz;
        r6.zw = min(float2(0,0), r4.xy);
        r7.xz = max(float2(0,0), r4.xy);
        r9.xy = r8.xw * float2(0.5,0.5) + -r4.xy;
        r4.xy = float2(1,1) + -r4.xy;
        r4.xy = -r6.zw * r6.zw + r4.xy;
        r6.zw = -r7.xz * r7.xz + r7.yw;
        r7.x = r9.x;
        r7.y = r4.x;
        r7.z = r6.z;
        r7.w = r8.x;
        r7.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r7.xyzw;
        r8.x = r9.y;
        r8.y = r4.y;
        r8.z = r6.w;
        r8.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r8.xyzw;
        r9.xyzw = r7.xzxz + r7.ywyw;
        r10.xyzw = r8.xxzz + r8.yyww;
        r4.xy = r7.yw / r9.zw;
        r4.xy = float2(-1.5,0.5) + r4.xy;
        r7.xy = cb2[32].xx * r4.xy;
        r4.xy = r8.yw / r10.yw;
        r4.xy = float2(-1.5,0.5) + r4.xy;
        r7.zw = cb2[32].yy * r4.xy;
        r8.xyzw = r10.xyzw * r9.xyzw;
        r9.xyzw = r6.xyxy * cb2[32].xyxy + r7.xzyz;
        r0.z = t1.SampleCmpLevelZero(s3_s, r9.xy, r4.z).x;
        r2.w = t1.SampleCmpLevelZero(s3_s, r9.zw, r4.z).x;
        r2.w = r8.y * r2.w;
        r0.z = r8.x * r0.z + r2.w;
        r6.xyzw = r6.xyxy * cb2[32].xyxy + r7.xwyw;
        r2.w = t1.SampleCmpLevelZero(s3_s, r6.xy, r4.z).x;
        r0.z = r8.z * r2.w + r0.z;
        r2.w = t1.SampleCmpLevelZero(s3_s, r6.zw, r4.z).x;
        r0.z = r8.w * r2.w + r0.z;
        r5.x = r5.z ? 1 : r0.z;
      } else {
        r5.xz = float2(1,0);
      }
    } else {
      r5.xz = float2(1,0);
    }
    r0.z = cmp(r0.w < 1);
    if (r0.z != 0) {
      r0.z = dot(r3.xyz, cb1[0].xyz);
      r0.z = max(0, r0.z);
      r0.z = min(0.899999976, r0.z);
      r0.z = 1 + -r0.z;
      r4.xy = cb2[584].xy * r0.zz;
      r4.xzw = -cb1[0].xyz * r4.xxx + r2.xyz;
      r4.xyz = r3.xyz * r4.yyy + r4.xzw;
      r6.xy = cb2[581].xy * r4.yy;
      r6.xy = cb2[580].xy * r4.xx + r6.xy;
      r6.xy = cb2[582].xy * r4.zz + r6.xy;
      r6.xy = cb2[583].xy + r6.xy;
      r6.zw = cmp(float2(0,0) < r6.xy);
      r0.z = r6.w ? r6.z : 0;
      r6.zw = cmp(r6.xy < float2(1,1));
      r2.w = r6.w ? r6.z : 0;
      r0.z = (int)r0.z & (int)r2.w;
      if (r0.z != 0) {
        r0.z = cb2[585].z * r6.y;
        r0.z = floor(r0.z);
        r0.z = r0.z + r6.x;
        r0.z = cb2[585].y * r0.z;
        r0.z = (uint)r0.z;
        r0.z = min(127, (uint)r0.z);
        r2.w = 0x0000ffff & asint(cb2[r0.z+587].x);
        r6.x = f16tof32(r2.w);
        r2.w = cmp(r6.x >= 0);
        if (r2.w != 0) {
          r7.x = cb2[576].x;
          r7.y = cb2[577].x;
          r7.z = cb2[578].x;
          r7.w = cb2[r0.z+587].y;
          r4.w = 1;
          r7.x = dot(r7.xyzw, r4.xyzw);
          r8.x = cb2[576].y;
          r8.y = cb2[577].y;
          r8.z = cb2[578].y;
          r8.w = cb2[r0.z+587].z;
          r7.y = dot(r8.xyzw, r4.xyzw);
          r8.x = cb2[576].z;
          r8.y = cb2[577].z;
          r8.z = cb2[578].z;
          r8.w = cb2[r0.z+587].w;
          r2.w = dot(r8.xyzw, r4.xyzw);
          r4.xy = cmp(float2(0,0) < r7.xy);
          r3.w = cmp(0 < r2.w);
          r4.x = r4.y ? r4.x : 0;
          r3.w = r3.w ? r4.x : 0;
          r4.xy = cmp(r7.xy < float2(1,1));
          r4.z = cmp(r2.w < 1);
          r4.x = r4.y ? r4.x : 0;
          r4.x = r4.z ? r4.x : 0;
          r3.w = r3.w ? r4.x : 0;
          if (r3.w != 0) {
            r0.z = asuint(cb2[r0.z+587].x) >> 16;
            r6.y = f16tof32(r0.z);
            r4.xy = r7.xy * cb2[584].zw + r6.xy;
            r4.zw = r4.xy * cb2[586].zw + float2(0.5,0.5);
            r4.zw = floor(r4.zw);
            r4.xy = r4.xy * cb2[586].zw + -r4.zw;
            r6.xyzw = float4(0.5,1,0.5,1) + r4.xxyy;
            r7.xw = r6.xz * r6.xz;
            r6.xz = min(float2(0,0), r4.xy);
            r8.xy = max(float2(0,0), r4.xy);
            r8.zw = r7.xw * float2(0.5,0.5) + -r4.xy;
            r4.xy = float2(1,1) + -r4.xy;
            r4.xy = -r6.xz * r6.xz + r4.xy;
            r6.xy = -r8.xy * r8.xy + r6.yw;
            r9.x = r8.z;
            r9.y = r4.x;
            r9.z = r6.x;
            r9.w = r7.x;
            r9.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r9.xyzw;
            r7.x = r8.w;
            r7.y = r4.y;
            r7.z = r6.y;
            r6.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r7.xyzw;
            r7.xyzw = r9.xzxz + r9.ywyw;
            r8.xyzw = r6.xxzz + r6.yyww;
            r4.xy = r9.yw / r7.zw;
            r4.xy = float2(-1.5,0.5) + r4.xy;
            r9.xy = cb2[586].xx * r4.xy;
            r4.xy = r6.yw / r8.yw;
            r4.xy = float2(-1.5,0.5) + r4.xy;
            r9.zw = cb2[586].yy * r4.xy;
            r6.xyzw = r8.xyzw * r7.xyzw;
            r7.xyzw = r4.zwzw * cb2[586].xyxy + r9.xzyz;
            r0.z = t4.SampleCmpLevelZero(s3_s, r7.xy, r2.w).x;
            r3.w = t4.SampleCmpLevelZero(s3_s, r7.zw, r2.w).x;
            r3.w = r6.y * r3.w;
            r0.z = r6.x * r0.z + r3.w;
            r4.xyzw = r4.zwzw * cb2[586].xyxy + r9.xwyw;
            r3.w = t4.SampleCmpLevelZero(s3_s, r4.xy, r2.w).x;
            r0.z = r6.z * r3.w + r0.z;
            r2.w = t4.SampleCmpLevelZero(s3_s, r4.zw, r2.w).x;
            r5.y = r6.w * r2.w + r0.z;
          } else {
            r5.y = 1;
          }
        } else {
          r5.y = 1;
        }
      } else {
        r5.y = 1;
      }
      r5.x = r5.z ? r5.y : r5.x;
    } else {
      r5.y = 1;
    }
    r0.z = r5.x + -r5.y;
    r0.z = r0.w * r0.z + r5.y;
    r0.w = cmp(0.00100000005 < r0.z);
    if (r0.w != 0) {
      r4.xyz = -cb0[173].xyz + r2.xyz;
      r4.yw = cb0[176].xz * r4.yy + r4.xz;
      r5.xy = cb0[174].zz * r4.yw;
      r5.zw = cb0[183].ww * cb0[175].xy;
      r4.yw = r4.yw * cb0[174].zz + r5.zw;
      r0.w = t3.SampleLevel(s2_s, r4.yw, 0).x;
      r4.yw = r5.xy * cb0[175].ww + r5.zw;
      r2.w = t3.SampleLevel(s2_s, r4.yw, 0).x;
      r3.w = dot(r4.xz, r4.xz);
      r3.w = sqrt(r3.w);
      r4.x = cb0[174].y + -cb0[174].x;
      r3.w = -cb0[174].x + r3.w;
      r4.x = 1 / r4.x;
      r3.w = saturate(r4.x * r3.w);
      r4.x = r3.w * -2 + 3;
      r3.w = r3.w * r3.w;
      r3.w = r4.x * r3.w;
      r2.w = r2.w + -r0.w;
      r0.w = r3.w * r2.w + r0.w;
      r0.w = -1 + r0.w;
      r0.w = cb0[175].z * r0.w + 1;
      
      if (AO_INTENSITY >= 1.f) {
        // Boost AO intensity (hardcoded 4x)
        r0.w = 1.0 + (r0.w - 1.0) * 4.0;
      }
      
      r0.z = r0.z * r0.w;
    }
    r0.w = cb2[35].z + -r0.z;
    r0.z = cb2[35].w * r0.w + r0.z;
  } else {
    r0.z = cb2[35].z;
  }
  r1.xyzw = r1.wzyx * float4(3,1023,1023,1023) + float4(0.5,0.5,0.5,0.5);
  r1.xyzw = (uint4)r1.xyzw;
  r1.xyz = (uint3)r1.xyz << int3(30,20,10);
  r0.w = (int)r1.y | (int)r1.x;
  r0.w = (int)r1.z | (int)r0.w;
  r0.w = (int)r1.w | (int)r0.w;
  r0.w = (uint)r0.w;
  r0.w = log2(r0.w);
  r0.w = -8 + r0.w;
  r1.x = cmp(r0.w >= 0);
  r1.y = cmp(r0.w < cb2[554].z);
  r1.x = r1.y ? r1.x : 0;
  if (r1.x != 0) {
    r0.w = (int)r0.w;
    r1.x = dot(r3.xyz, cb2[r0.w+523].xyz);
    r1.x = max(0, r1.x);
    r1.x = min(0.899999976, r1.x);
    r1.x = 1 + -r1.x;
    r1.y = (uint)r0.w << 2;
    r1.xz = cb2[r0.w+508].xy * r1.xx;
    r2.xyz = -cb2[r0.w+523].xyz * r1.xxx + r2.xyz;
    r1.xzw = r3.xyz * r1.zzz + r2.xyz;
    r2.xyz = cb2[r1.y+449].xyz * r1.zzz;
    r2.xyz = cb2[r1.y+448].xyz * r1.xxx + r2.xyz;
    r1.xzw = cb2[r1.y+450].xyz * r1.www + r2.xyz;
    r1.xyz = cb2[r1.y+451].xyz + r1.xzw;
    r1.z = max(0.00999999978, r1.z);
    r2.xy = cmp(float2(0,0) >= r1.xy);
    r2.zw = cmp(r1.xy >= float2(1,1));
    r1.w = cmp(r1.z >= 1);
    r2.xy = (int2)r2.zw | (int2)r2.xy;
    r2.x = (int)r2.y | (int)r2.x;
    r1.w = (int)r1.w | (int)r2.x;
    if (r1.w == 0) {
      r2.x = cb2[553].x * 4;
      r1.xy = r1.xy * cb2[r0.w+538].zw + cb2[r0.w+538].xy;
      bitmask.x = ((~(-1 << 2)) << 2) & 0xffffffff;  r0.x = (((uint)r0.x << 2) & bitmask.x) | ((uint)0 & ~bitmask.x);
      bitmask.x = ((~(-1 << 2)) << 0) & 0xffffffff;  r0.x = (((uint)r0.y << 0) & bitmask.x) | ((uint)r0.x & ~bitmask.x);
      r0.yw = icb[r0.x+0].xy * float2(1,-1);
      r2.yzw = float3(0,0,0);
      while (true) {
        r3.x = cmp((uint)r2.w >= 16);
        if (r3.x != 0) break;
        r3.x = dot(icb[r2.w+0].zw, r0.yw);
        r3.y = dot(icb[r2.w+0].wz, icb[r0.x+0].xy);
        r3.xy = r3.xy * r2.xx + r1.xy;
        r3.xyzw = t2.Gather(s1_s, r3.xy).xyzw;
        r3.xyzw = r3.xyzw + -r1.zzzz;
        r4.xyzw = cmp(r3.xyzw >= float4(0,0,0,0));
        r4.xyzw = r4.xyzw ? float4(1,1,1,1) : 0;
        r3.x = dot(r3.xyzw, r4.xyzw);
        r3.z = dot(r4.xyzw, float4(1,1,1,1));
        r3.xy = r3.xz + r2.yz;
        r3.z = (int)r2.w + 1;
        r2.yzw = r3.xyz;
        continue;
      }
      r0.x = r2.z * 0.03125 + -1;
      r0.y = cmp(0 < r0.x);
      r0.w = cmp(r0.x < 0);
      r0.y = (int)-r0.y + (int)r0.w;
      r0.y = (int)r0.y;
      r0.x = -r0.y * r0.x + 1;
      r0.w = r0.x * r0.x;
      r1.x = r0.w * r0.x;
      r1.y = 1 / r2.z;
      r1.y = r2.y * r1.y;
      r1.z = 1 / r1.z;
      r1.y = saturate(r1.y * r1.z);
      r0.x = -r0.w * r0.x + r0.x;
      r0.x = r1.y * r0.x + r1.x;
      r0.x = 1 + -r0.x;
      r0.x = r0.x * r0.y;
      r0.x = -r0.x * 0.5 + 0.5;
      r0.x = min(1, r0.x);
    }
    r0.y = 1;
  } else {
    r0.x = 1;
    r1.w = 0;
  }
  o0.y = r1.w ? r0.y : r0.x;
  r0.x = min(1, r0.z);
  r0.x = -1 + r0.x;
  o0.x = cb2[34].x * r0.x + 1;
  o0.z = 0;
  return;
}