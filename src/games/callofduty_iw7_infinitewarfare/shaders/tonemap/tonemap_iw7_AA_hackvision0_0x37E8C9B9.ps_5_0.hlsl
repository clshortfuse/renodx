// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:43:39 2025
#include "../common.hlsl"
#include "./drawbinary.hlsl"

Buffer<float4> t14 : register(t14);

Texture2D<uint4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture3D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb13 : register(b13)
{
  float4 cb13[3];
}

cbuffer cb2 : register(b2)
{
  float4 cb2[13];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0,
  out float o1 : SV_TARGET1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 colorUntonemapped, colorTonemapped;

  r0.xy = cb2[3].yx + v1.yx;
  r1.xyz = t0.Sample(s0_s, r0.yx).xyz;
  r0.xy = cb2[3].wz + r0.xy;
  r0.zw = cb2[2].xy * r0.yx;
  r2.yz = (uint2)r0.zw;
  r2.x = (uint)r2.y >> 1;
  r2.w = 0;
  r0.z = t3.Load(r2.xzw).x;
  r0.w = (int)r2.y & 1;
  r1.w = (uint)r0.z >> 4;
  r0.z = r0.w ? r1.w : r0.z;
  r1.w = (int)r0.z & 4;


  //colorUntonemapped
  colorUntonemapped = r1.xyz * Tonemap_CalculatePreExposureMultiplier(cb13[0].xyz, cb13[1].xyz, cb13[2].xyz);

  r3.xyz = cmp(r1.xyz < cb13[0].xxx);
  r4.xyzw = r3.xxxx ? cb13[2].xyzw : cb13[1].xyzw;
  r3.xw = r4.xy * r1.xx + r4.zw;
  r4.x = saturate(r3.x / r3.w);
  r5.xyzw = r3.yyyy ? cb13[2].xyzw : cb13[1].xyzw;
  r1.xy = r5.xy * r1.yy + r5.zw;
  r4.y = saturate(r1.x / r1.y);
  r3.xyzw = r3.zzzz ? cb13[2].xyzw : cb13[1].xyzw;
  r1.xy = r3.xy * r1.zz + r3.zw;
  r4.z = saturate(r1.x / r1.y);

  r1.x = saturate(dot(r4.xyz, cb2[4].xyz));
  r1.y = saturate(dot(r4.xyz, cb2[5].xyz));
  r1.z = saturate(dot(r4.xyz, cb2[6].xyz));

  //to sRGB
  r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  // r1.xyz = log2(r1.xyz);
  // r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  // r1.xyz = max(float3(0,0,0), r1.xyz);

  r1.xyz = r1.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r3.xyz = t1.SampleLevel(s1_s, r1.xyz, 0).xyz;

  if (r1.w != 0) {
    r0.z = (int)r0.z & 8;
    r1.xy = t2.Load(r2.yzw).xy;
    r1.xy = float2(255.5,255.100006) * r1.yx;
    r1.xy = (uint2)r1.xy;
    r1.x = (uint)r1.x << 11;
    bitmask.x = ((~(-1 << 8)) << 3) & 0xffffffff;  r1.x = (((uint)r1.y << 3) & bitmask.x) | ((uint)r1.x & ~bitmask.x);
    r1.yz = (int2)r1.xx + int2(1,2);
    r1.yw = t14.Load(r1.y).yw;
    r4.xy = t14.Load(r1.z).yz;
    r5.xyzw = t14.Load(r1.x).xyzw;
    r1.xz = cmp(float2(0,0) < r4.xy);
    r4.x = r0.z ? 1 : 0;
    r1.x = r1.x ? r4.x : r1.y;
    r1.y = (uint)cb2[7].w;
    if (r0.z != 0) {
      r1.x = r1.x * r1.w;
      r4.xyzw = float4(-1,-1,-1,-1) + r5.xyzw;
      r4.xyzw = cb2[7].xxxx * r4.xyzw + float4(1,1,1,1);
      r4.xyzw = cb2[10].xyzw * r4.xyzw;
      r5.xyzw = r4.xyzw * r1.wwww;
      r4.xyzw = cb2[12].xyzw;
      r6.xyzw = cb2[11].xyzw;
    } else {
      r4.xyzw = cb2[8].xyzw;
      r6.xyzw = cb2[9].xyzw;
    }
    r1.w = cb2[0].x + cb2[0].x;
    r1.z = r1.z ? r1.w : 1;
    r5.xyzw = r5.xyzw * r1.zzzz;
    if (r1.y == 0) {
      r1.z = 0;
    } else {
      r7.xy = (int2)-r1.yy + (int2)r2.zy;
      r7.zw = r2.xw;
      r1.w = t3.Load(r7.zxw).x;
      r7.x = (uint)r1.w >> 4;
      r1.w = r0.w ? r7.x : r1.w;
      r1.w = (int)r1.w & 4;
      r1.w = cmp((int)r1.w != 0);
      r8.xy = (int2)r1.yy + (int2)r2.zy;
      r8.zw = r7.zw;
      r1.y = t3.Load(r8.zxw).x;
      r7.x = (uint)r1.y >> 4;
      r0.w = r0.w ? r7.x : r1.y;
      r0.w = (int)r0.w & 4;
      r0.w = cmp((int)r0.w != 0);
      r2.y = (uint)r7.y >> 1;
      r1.y = t3.Load(r2.yzw).x;
      r2.y = (int)r7.y & 1;
      r7.x = (uint)r1.y >> 4;
      r1.y = r2.y ? r7.x : r1.y;
      r1.y = (int)r1.y & 4;
      r1.y = cmp((int)r1.y != 0);
      r2.x = (uint)r8.y >> 1;
      r2.x = t3.Load(r2.xzw).x;
      r2.y = (int)r8.y & 1;
      r2.z = (uint)r2.x >> 4;
      r2.x = r2.y ? r2.z : r2.x;
      r2.x = (int)r2.x & 4;
      r2.x = cmp((int)r2.x != 0);
      r0.w = r0.w ? r1.w : 0;
      r0.w = r1.y ? r0.w : 0;
      r0.w = r2.x ? r0.w : 0;
      r1.z = ~(int)r0.w;
    }
    if (r1.z == 0) {
      r0.xy = cb2[1].yx * r0.xy;
      r2.xyzw = float4(12,12,12,12) * r0.yxyx;
      r2.xyzw = cmp(r2.xyzw >= -r2.zwzw);
      r2.xyzw = r2.xyzw ? float4(12,12,0.0833333358,0.0833333358) : float4(-12,-12,-0.0833333358,-0.0833333358);
      r0.yw = r2.wz * r0.xy;
      r0.yw = frac(r0.yw);
      r0.yw = r2.yx * r0.yw;
      r0.xyw = (uint3)r0.xyw;
      r1.yz = cmp((int2)r0.wy == int2(0,0));
      r0.xyw = (int3)r0.xyw & int3(2,14,14);
      r0.xyw = cmp((int3)r0.xyw != int3(0,6,6));
      r0.yw = r0.yw ? r1.yz : 0;
      r0.y = (int)r0.w | (int)r0.y;
      r0.x = r0.z ? r0.y : r0.x;
      r0.xyzw = r0.xxxx ? r6.xyzw : r4.xyzw;
      r0.xyzw = r1.xxxx * r0.xyzw;
      r5.xyzw = r0.xyzw * r5.xyzw;
    }
    r0.xyz = r5.xyz + -r3.xyz;
    r3.xyz = r5.www * r0.xyz + r3.xyz;
  }

  r3.w = dot(r3.xyz, float3(0.212599993,0.715200007,0.0722000003));
  o0.xyzw = r3.xyzw;
  o1.x = r3.w;

  //tonemap
  colorTonemapped = o0.xyz;
  o0.xyz = Tonemap_Do(colorUntonemapped, colorTonemapped, v1.xy, t0);
  //o0.xyz = DrawBinary(5, o0.xyz, v1.xy);
  return;
}