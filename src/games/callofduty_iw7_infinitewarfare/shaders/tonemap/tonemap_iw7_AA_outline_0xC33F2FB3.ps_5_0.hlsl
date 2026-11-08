// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:13:00 2025
#include "../common.hlsl"
#include "./drawbinary.hlsl"

Buffer<float4> t14 : register(t14);

Texture2D<uint4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture3D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb13 : register(b13)
{
  float4 cb13[3];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[14];
}




// 3Dmigoto declarations
#define cmp -

//AA outline
void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0,
  out float o1 : SV_TARGET1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 colorUntonemapped, colorTonemapped;

  //color + bloom
  r0.xy = cb2[3].xy + v1.xy;
  r1.xyz = t0.Sample(s0_s, r0.xy).xyz;

  r0.zw = cb2[3].wz + r0.yx;
  r2.xy = cb2[2].xy * r0.wz;
  r2.yz = (uint2)r2.xy;
  r2.x = (uint)r2.y >> 1;
  r2.w = 0;
  r1.w = t4.Load(r2.xzw).x;
  r3.x = (int)r2.y & 1;
  r3.y = (uint)r1.w >> 4;
  r1.w = r3.x ? r3.y : r1.w;
  r3.y = (int)r1.w & 4;

  r4.xyz = t1.Sample(s1_s, r0.xy).xyz; Tonemap_BloomScale(r4.xyz);
  r4.xyz = cb2[7].xxx * r4.xyz;
  r1.xyz = cb2[7].yyy * r1.xyz + r4.xyz;

  //colorUntonemapped
  colorUntonemapped = r1.xyz * Tonemap_CalculatePreExposureMultiplier(cb13[0].xyz, cb13[1].xyz, cb13[2].xyz);

  //tonemap (s1)
  r4.xyz = cmp(r1.xyz < cb13[0].xxx);
  r5.xyzw = r4.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
  r0.xy = r5.xy * r1.xx + r5.zw;
  r5.x = saturate(r0.x / r0.y);
  r6.xyzw = r4.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
  r0.xy = r6.xy * r1.yy + r6.zw;
  r5.y = saturate(r0.x / r0.y);
  r4.xyzw = r4.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
  r0.xy = r4.xy * r1.zz + r4.zw;
  r5.z = saturate(r0.x / r0.y);

  //cc
  r1.x = saturate(dot(r5.xyz, cb2[4].xyz));
  r1.y = saturate(dot(r5.xyz, cb2[5].xyz));
  r1.z = saturate(dot(r5.xyz, cb2[6].xyz));

  //srgb
  r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  // r1.xyz = log2(r1.xyz);
  // r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r1.xyz = max(float3(0,0,0), r1.xyz);

  //LUT
  r1.xyz = r1.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r4.xyz = t2.SampleLevel(s2_s, r1.xyz, 0).xyz;

  //outline
  if (r3.y != 0) {
    r0.x = (int)r1.w & 8;
    r1.xy = t3.Load(r2.yzw).xy;
    r1.xy = float2(255.5,255.100006) * r1.yx;
    r1.xy = (uint2)r1.xy;
    r0.y = (uint)r1.x << 11;
    bitmask.y = ((~(-1 << 8)) << 3) & 0xffffffff;  r0.y = (((uint)r1.y << 3) & bitmask.y) | ((uint)r0.y & ~bitmask.y);
    r1.xy = (int2)r0.yy + int2(1,2);
    r1.xz = t14.Load(r1.x).yw;
    r1.yw = t14.Load(r1.y).yz;
    r5.xyzw = t14.Load(r0.y).xyzw;
    r1.yw = cmp(float2(0,0) < r1.yw);
    r0.y = r0.x ? 1 : 0;
    r0.y = r1.y ? r0.y : r1.x;
    r1.x = (uint)cb2[8].w;
    if (r0.x != 0) {
      r0.y = r0.y * r1.z;
      r6.xyzw = float4(-1,-1,-1,-1) + r5.xyzw;
      r6.xyzw = cb2[8].xxxx * r6.xyzw + float4(1,1,1,1);
      r6.xyzw = cb2[11].xyzw * r6.xyzw;
      r5.xyzw = r6.xyzw * r1.zzzz;
      r6.xyzw = cb2[13].xyzw;
      r7.xyzw = cb2[12].xyzw;
    } else {
      r6.xyzw = cb2[9].xyzw;
      r7.xyzw = cb2[10].xyzw;
    }
    r1.y = cb2[0].x + cb2[0].x;
    r1.y = r1.w ? r1.y : 1;
    r5.xyzw = r5.xyzw * r1.yyyy;
    if (r1.x == 0) {
      r1.y = 0;
    } else {
      r8.xy = (int2)-r1.xx + (int2)r2.zy;
      r8.zw = r2.xw;
      r1.z = t4.Load(r8.zxw).x;
      r1.w = (uint)r1.z >> 4;
      r1.z = r3.x ? r1.w : r1.z;
      r1.z = (int)r1.z & 4;
      r1.z = cmp((int)r1.z != 0);
      r9.xy = (int2)r1.xx + (int2)r2.zy;
      r9.zw = r8.zw;
      r1.x = t4.Load(r9.zxw).x;
      r1.w = (uint)r1.x >> 4;
      r1.x = r3.x ? r1.w : r1.x;
      r1.x = (int)r1.x & 4;
      r1.x = cmp((int)r1.x != 0);
      r2.y = (uint)r8.y >> 1;
      r1.w = t4.Load(r2.yzw).x;
      r2.y = (int)r8.y & 1;
      r3.x = (uint)r1.w >> 4;
      r1.w = r2.y ? r3.x : r1.w;
      r1.w = (int)r1.w & 4;
      r1.w = cmp((int)r1.w != 0);
      r2.x = (uint)r9.y >> 1;
      r2.x = t4.Load(r2.xzw).x;
      r2.y = (int)r9.y & 1;
      r2.z = (uint)r2.x >> 4;
      r2.x = r2.y ? r2.z : r2.x;
      r2.x = (int)r2.x & 4;
      r2.x = cmp((int)r2.x != 0);
      r1.x = r1.x ? r1.z : 0;
      r1.x = r1.w ? r1.x : 0;
      r1.x = r2.x ? r1.x : 0;
      r1.y = ~(int)r1.x;
    }
    if (r1.y == 0) {
      r0.zw = cb2[1].yx * r0.zw;
      r1.xyzw = float4(12,12,12,12) * r0.wzwz;
      r1.xyzw = cmp(r1.xyzw >= -r1.zwzw);
      r1.xyzw = r1.xyzw ? float4(12,12,0.0833333358,0.0833333358) : float4(-12,-12,-0.0833333358,-0.0833333358);
      r1.zw = r1.wz * r0.zw;
      r1.zw = frac(r1.zw);
      r1.xy = r1.yx * r1.zw;
      r1.xy = (uint2)r1.xy;
      r1.zw = cmp((int2)r1.yx == int2(0,0));
      r1.xy = (int2)r1.xy & int2(14,14);
      r0.z = (uint)r0.z;
      r1.xy = cmp((int2)r1.xy != int2(6,6));
      r1.xy = r1.xy ? r1.zw : 0;
      r0.w = (int)r1.y | (int)r1.x;
      r0.z = (int)r0.z & 2;
      r0.z = cmp((int)r0.z != 0);
      r0.x = r0.x ? r0.w : r0.z;
      r1.xyzw = r0.xxxx ? r7.xyzw : r6.xyzw;
      r0.xyzw = r1.xyzw * r0.yyyy;
      r5.xyzw = r0.xyzw * r5.xyzw;
    }
    r0.xyz = r5.xyz + -r4.xyz;
    r4.xyz = r5.www * r0.xyz + r4.xyz;
  }

  //out
  r4.w = dot(r4.xyz, float3(0.212599993,0.715200007,0.0722000003));
  o0.xyzw = r4.xyzw;
  o1.x = r4.w;

  //tonemap
  colorTonemapped = o0.xyz;
  o0.xyz = Tonemap_Do(colorUntonemapped, colorTonemapped, v1.xy, t0);
  //o0.xyz = DrawBinary(7, o0.xyz, v1.xy);
  return;
}