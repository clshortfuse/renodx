// ---- Created with 3Dmigoto v1.4.1 on Sat Jan 24 04:33:32 2026
#include "../shared.h"

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
  const float4 icb[] = { { 1.000000, 0, 0, 0},
                              { 0, 1.000000, 0, 0},
                              { 0, 0, 1.000000, 0},
                              { 0, 0, 0, 1.000000},
                              { -0.399656, 0.916665, -0.942016, -0.399062},
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
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(cb2[35].w < 0.99000001);
  if (r0.x != 0) {
    r0.xy = (uint2)v0.xy;
    r0.zw = (uint2)r0.xy;
    r1.xy = cb0[82].zw * r0.zw;
    r1.zw = r1.xy * float2(2,2) + float2(-1,-1);
    r2.xy = float2(0.5,0.5) + r0.zw;
    r2.xy = cb0[82].zw * r2.xy;
    r2.x = t0.SampleLevel(s0_s, r2.xy, 0).x;
    r3.xyzw = cb0[25].xyzw * -r1.wwww;
    r3.xyzw = cb0[24].xyzw * r1.zzzz + r3.xyzw;
    r2.xyzw = cb0[26].xyzw * r2.xxxx + r3.xyzw;
    r2.xyzw = cb0[27].xyzw + r2.xyzw;
    r2.xyz = r2.xyz / r2.www;
    r3.xyz = ddy_coarse(r2.zxy);
    r4.xyz = ddx_coarse(r2.yzx);
    r5.xyz = r4.xyz * r3.xyz;
    r3.xyz = r3.zxy * r4.yzx + -r5.xyz;
    r1.z = dot(r3.xyz, r3.xyz);
    r1.z = max(1.17549435e-38, r1.z);
    r1.z = rsqrt(r1.z);
    r3.xyz = r3.xyz * r1.zzz;
    r1.z = (int)cb2[35].x;
    r1.w = cmp((int)r1.z == 2);
    r4.xyz = r1.www ? cb2[20].xyz : cb0[44].xyz;
    r4.xyz = -r4.xyz + r2.xyz;
    r1.w = dot(r4.xyz, r4.xyz);
    r1.w = cb2[34].w + -r1.w;
    r1.w = saturate(cb2[34].z * r1.w);
    r2.w = cmp(0 < r1.w);
    if (r2.w != 0) {
      r1.z = cmp(0 < (int)r1.z);
      if (r1.z != 0) {
        r1.xy = t5.SampleLevel(s1_s, r1.xy, 0).xy;
        r4.xyz = -cb2[20].xyz + r2.xyz;
        r5.xyz = -cb2[21].xyz + r2.xyz;
        r6.xyz = -cb2[22].xyz + r2.xyz;
        r7.xyz = -cb2[23].xyz + r2.xyz;
        r4.x = dot(r4.xyz, r4.xyz);
        r4.y = dot(r5.xyz, r5.xyz);
        r4.z = dot(r6.xyz, r6.xyz);
        r4.w = dot(r7.xyz, r7.xyz);
        r5.x = cmp(r4.x < cb2[20].w);
        r5.y = cmp(r4.y < cb2[21].w);
        r5.z = cmp(r4.z < cb2[22].w);
        r5.w = cmp(r4.w < cb2[23].w);
        r6.xyzw = r5.xyzw ? float4(1,1,1,1) : 0;
        r5.xyz = r5.xyz ? float3(-1,-1,-1) : float3(-0,-0,-0);
        r5.xyz = r6.yzw + r5.xyz;
        r6.yzw = max(float3(0,0,0), r5.xyz);
        r1.z = dot(r6.xyzw, float4(4,3,2,1));
        r1.z = 4 + -r1.z;
        r1.z = max(0, r1.z);
        r1.z = min(3, r1.z);
        r2.w = 1 + r1.z;
        r2.w = min(3, r2.w);
        r2.w = (uint)r2.w;
        r3.w = dot(r4.yzw, icb[r2.w+0].yzw);
        r2.w = r3.w / cb2[r2.w+20].w;
        r3.w = cmp(r2.w >= 0);
        r2.w = cmp(1 >= r2.w);
        r2.w = r2.w ? r3.w : 0;
        if (r2.w != 0) {
          r2.w = (uint)r1.z;
          r5.xy = float2(2.08299994,4.8670001) + r0.zw;
          r3.w = dot(r5.xy, float2(0.0671105608,0.00583714992));
          r3.w = frac(r3.w);
          r3.w = 52.9829178 * r3.w;
          r3.w = frac(r3.w);
          r4.x = dot(r4.xyzw, icb[r2.w+0].xyzw);
          r2.w = r4.x / cb2[r2.w+20].w;
          r2.w = sqrt(r2.w);
          r2.w = -0.899999976 + r2.w;
          r2.w = 12 * r2.w;
          r2.w = cmp(r2.w >= r3.w);
          r2.w = r2.w ? 1.000000 : 0;
          r1.z = r2.w + r1.z;
        }
        r2.w = dot(r3.xyz, cb1[0].xyz);
        r2.w = max(0, r2.w);
        r2.w = min(0.899999976, r2.w);
        r2.w = 1 + -r2.w;
        r3.w = (uint)r1.z;
        r4.x = (uint)r3.w << 2;
        r4.yz = cb2[r3.w+24].xy * r2.ww;
        r1.x = cmp(r1.x >= 0.999989986);
        r1.x = r1.x ? 1.000000 : 0;
        r1.x = r1.x * r1.y;
        r1.x = 4 * r1.x;
        r1.x = max(r4.y, r1.x);
        r5.xyz = -cb1[0].xyz * r1.xxx + r2.xyz;
        r4.yzw = r3.xyz * r4.zzz + r5.xyz;
        r5.xyz = cb2[r4.x+1].xyz * r4.zzz;
        r5.xyz = cb2[r4.x+0].xyz * r4.yyy + r5.xyz;
        r4.yzw = cb2[r4.x+2].xyz * r4.www + r5.xyz;
        r4.xyz = cb2[r4.x+3].xyz + r4.yzw;
        r5.xyz = cmp(float3(0,0,0) >= r4.xyz);
        r6.xyz = cmp(r4.xyz >= float3(1,1,1));
        r5.xyz = (int3)r5.xyz | (int3)r6.xyz;
        r1.x = (int)r5.y | (int)r5.x;
        r1.x = (int)r5.z | (int)r1.x;
        r1.y = (int)r4.z & 0x7fffffff;
        r1.y = cmp(0x7f800000 < (uint)r1.y);
        r5.z = (int)r1.y | (int)r1.x;
        r0.zw = float2(0.25,0.25) * r0.zw;
        r6.xy = (int2)r0.zw;
        r6.zw = float2(0,0);
        r5.x = t3.Load(r6.xyz).x;
        r0.z = cmp(r5.x < 0.00100000005);
        r0.w = cmp(0.99000001 < r5.x);
        r0.z = (int)r0.w | (int)r0.z;
        if (r0.z == 0) {
          r0.z = (int)r1.z;
          r1.xy = r4.xy * cb2[r0.z+28].zw + cb2[r0.z+28].xy;
          bitmask.x = ((~(-1 << 2)) << 2) & 0xffffffff;  r0.x = (((uint)r0.x << 2) & bitmask.x) | ((uint)0 & ~bitmask.x);
          bitmask.x = ((~(-1 << 2)) << 0) & 0xffffffff;  r0.x = (((uint)r0.y << 0) & bitmask.x) | ((uint)r0.x & ~bitmask.x);
          r0.y = dot(cb2[33].xyzw, icb[r0.z+0].xyzw);
          r0.zw = icb[r0.x+4].xy * float2(1,-1);
          r4.xy = float2(0,0);
          r1.z = 0;
          while (true) {
            r2.w = cmp((uint)r1.z >= 16);
            if (r2.w != 0) break;
            r6.x = dot(icb[r1.z+4].zw, r0.zw);
            r6.y = dot(icb[r1.z+4].wz, icb[r0.x+4].xy);
            r6.xy = r6.xy * r0.yy + r1.xy;
            r6.xyzw = t1.Gather(s1_s, r6.xy).xyzw;
            r6.xyzw = r6.xyzw + -r4.zzzz;
            r7.xyzw = cmp(r6.xyzw >= float4(0,0,0,0));
            r7.xyzw = r7.xyzw ? float4(1,1,1,1) : 0;
            r2.w = dot(r6.xyzw, r7.xyzw);
            r6.x = r4.x + r2.w;
            r2.w = dot(r7.xyzw, float4(1,1,1,1));
            r6.y = r4.y + r2.w;
            r2.w = (int)r1.z + 1;
            r4.xy = r6.xy;
            r1.z = r2.w;
            continue;
          }
          r0.x = r4.y * 0.03125 + -1;
          r0.y = cmp(0 < r0.x);
          r0.z = cmp(r0.x < 0);
          r0.y = (int)-r0.y + (int)r0.z;
          r0.y = (int)r0.y;
          r0.x = -r0.y * r0.x + 1;
          r0.z = r0.x * r0.x;
          r0.w = r0.z * r0.x;
          r1.x = 1 / r4.y;
          r1.x = r4.x * r1.x;
          r1.y = 1 / r4.z;
          r1.x = saturate(r1.x * r1.y);
          r0.x = -r0.z * r0.x + r0.x;
          r0.x = r1.x * r0.x + r0.w;
          r0.x = 1 + -r0.x;
          r0.x = r0.x * r0.y;
          r0.x = -r0.x * 0.5 + 0.5;
          r5.x = r5.z ? 1 : r0.x;
        }
      } else {
        r5.xz = float2(1,0);
      }
    } else {
      r5.xz = float2(1,0);
    }
    r0.x = cmp(r1.w < 1);
    if (r0.x != 0) {
      r0.x = dot(r3.xyz, cb1[0].xyz);
      r0.x = max(0, r0.x);
      r0.x = min(0.899999976, r0.x);
      r0.x = 1 + -r0.x;
      r0.xy = cb2[584].xy * r0.xx;
      r0.xzw = -cb1[0].xyz * r0.xxx + r2.xyz;
      r0.xyz = r3.xyz * r0.yyy + r0.xzw;
      r1.xy = cb2[581].xy * r0.yy;
      r1.xy = cb2[580].xy * r0.xx + r1.xy;
      r1.xy = cb2[582].xy * r0.zz + r1.xy;
      r1.xy = cb2[583].xy + r1.xy;
      r3.xy = cmp(float2(0,0) < r1.xy);
      r1.z = r3.y ? r3.x : 0;
      r3.xy = cmp(r1.xy < float2(1,1));
      r2.w = r3.y ? r3.x : 0;
      r1.z = (int)r1.z & (int)r2.w;
      if (r1.z != 0) {
        r1.y = cb2[585].z * r1.y;
        r1.y = floor(r1.y);
        r1.x = r1.y + r1.x;
        r1.x = cb2[585].y * r1.x;
        r1.x = (uint)r1.x;
        r1.x = min(127, (uint)r1.x);
        r1.y = 0x0000ffff & asint(cb2[r1.x+587].x);
        r3.x = f16tof32(r1.y);
        r1.y = cmp(r3.x >= 0);
        if (r1.y != 0) {
          r4.x = cb2[576].x;
          r4.y = cb2[577].x;
          r4.z = cb2[578].x;
          r4.w = cb2[r1.x+587].y;
          r0.w = 1;
          r4.x = dot(r4.xyzw, r0.xyzw);
          r6.x = cb2[576].y;
          r6.y = cb2[577].y;
          r6.z = cb2[578].y;
          r6.w = cb2[r1.x+587].z;
          r4.y = dot(r6.xyzw, r0.xyzw);
          r6.x = cb2[576].z;
          r6.y = cb2[577].z;
          r6.z = cb2[578].z;
          r6.w = cb2[r1.x+587].w;
          r0.x = dot(r6.xyzw, r0.xyzw);
          r0.yz = cmp(float2(0,0) < r4.xy);
          r0.w = cmp(0 < r0.x);
          r0.y = r0.z ? r0.y : 0;
          r0.y = r0.w ? r0.y : 0;
          r0.zw = cmp(r4.xy < float2(1,1));
          r1.y = cmp(r0.x < 1);
          r0.z = r0.w ? r0.z : 0;
          r0.z = r1.y ? r0.z : 0;
          r0.y = r0.z ? r0.y : 0;
          if (r0.y != 0) {
            r0.y = asuint(cb2[r1.x+587].x) >> 16;
            r3.y = f16tof32(r0.y);
            r0.yz = r4.xy * cb2[584].zw + r3.xy;
            r1.xy = r0.yz * cb2[586].zw + float2(0.5,0.5);
            r1.xy = floor(r1.xy);
            r0.yz = r0.yz * cb2[586].zw + -r1.xy;
            r3.xyzw = float4(0.5,1,0.5,1) + r0.yyzz;
            r4.xw = r3.xz * r3.xz;
            r3.xz = min(float2(0,0), r0.yz);
            r6.xy = max(float2(0,0), r0.yz);
            r6.zw = r4.xw * float2(0.5,0.5) + -r0.yz;
            r0.yz = float2(1,1) + -r0.yz;
            r0.yz = -r3.xz * r3.xz + r0.yz;
            r3.xy = -r6.xy * r6.xy + r3.yw;
            r7.x = r6.z;
            r7.y = r0.y;
            r7.z = r3.x;
            r7.w = r4.x;
            r7.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r7.xyzw;
            r4.x = r6.w;
            r4.y = r0.z;
            r4.z = r3.y;
            r3.xyzw = float4(0.444440007,0.444440007,0.444440007,0.222220004) * r4.xyzw;
            r4.xyzw = r7.xzxz + r7.ywyw;
            r6.xyzw = r3.xxzz + r3.yyww;
            r0.yz = r7.yw / r4.zw;
            r0.yz = float2(-1.5,0.5) + r0.yz;
            r7.xy = cb2[586].xx * r0.yz;
            r0.yz = r3.yw / r6.yw;
            r0.yz = float2(-1.5,0.5) + r0.yz;
            r7.zw = cb2[586].yy * r0.yz;
            r3.xyzw = r6.xyzw * r4.xyzw;
            r4.xyzw = r1.xyxy * cb2[586].xyxy + r7.xzyz;
            r0.y = t4.SampleCmpLevelZero(s3_s, r4.xy, r0.x).x;
            r0.z = t4.SampleCmpLevelZero(s3_s, r4.zw, r0.x).x;
            r0.z = r3.y * r0.z;
            r0.y = r3.x * r0.y + r0.z;
            r4.xyzw = r1.xyxy * cb2[586].xyxy + r7.xwyw;
            r0.z = t4.SampleCmpLevelZero(s3_s, r4.xy, r0.x).x;
            r0.y = r3.z * r0.z + r0.y;
            r0.x = t4.SampleCmpLevelZero(s3_s, r4.zw, r0.x).x;
            r5.y = r3.w * r0.x + r0.y;
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
    r0.x = r5.x + -r5.y;
    r0.x = r1.w * r0.x + r5.y;
    r0.y = cmp(0.00100000005 < r0.x);
    if (r0.y != 0) {
      r0.yzw = -cb0[173].xyz + r2.xyz;
      r1.xy = cb0[176].xz * r0.zz + r0.yw;
      r1.zw = cb0[174].zz * r1.xy;
      r2.xy = cb0[183].ww * cb0[175].xy;
      r1.xy = r1.xy * cb0[174].zz + r2.xy;
      r0.z = t2.SampleLevel(s2_s, r1.xy, 0).x;
      r1.xy = r1.zw * cb0[175].ww + r2.xy;
      r1.x = t2.SampleLevel(s2_s, r1.xy, 0).x;
      r0.y = dot(r0.yw, r0.yw);
      r0.y = sqrt(r0.y);
      r0.w = cb0[174].y + -cb0[174].x;
      r0.y = -cb0[174].x + r0.y;
      r0.w = 1 / r0.w;
      r0.y = saturate(r0.y * r0.w);
      r0.w = r0.y * -2 + 3;
      r0.y = r0.y * r0.y;
      r0.y = r0.w * r0.y;
      r0.w = r1.x + -r0.z;
      r0.y = r0.y * r0.w + r0.z;
      r0.y = -1 + r0.y;
      r0.y = cb0[175].z * r0.y + 1;

      if (AO_INTENSITY >= 1.f) {  
      // Boost AO intensity (hardcoded 4x)
      r0.y = 1.0 + (r0.y - 1.0) * 4.0;
      }
      
      r0.x = r0.x * r0.y;
    }
    r0.y = cb2[35].z + -r0.x;
    r0.x = cb2[35].w * r0.y + r0.x;
  } else {
    r0.x = cb2[35].z;
  }
  r0.x = min(1, r0.x);
  r0.x = -1 + r0.x;
  o0.x = cb2[34].x * r0.x + 1;
  o0.yz = float2(1,0);
  return;
}