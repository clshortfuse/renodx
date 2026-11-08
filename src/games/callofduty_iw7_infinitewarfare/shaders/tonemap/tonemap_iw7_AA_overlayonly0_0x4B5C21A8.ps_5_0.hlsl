// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 20 15:43:50 2025
#include "../common.hlsl"
#include "./drawbinary.hlsl"

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[4];
}




// 3Dmigoto declarations
#define cmp -

//THIS IS WEIRD! It's only applying an overlay on the color.
// - Bot vision 2nd overlay.
// - Explosion lens dirt or flare.
// The algorithm doesn't expect HDR luma, so there will be some chroma loss from saturate.
void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;
  float3 colorUntonemapped, colorTonemapped;

  r0.xy = cb2[1].xy + v1.xy;
  r1.xyzw = cmp(asint(cb2[2].zzww) == int4(1,3,1,3));
  r0.w = (int)r1.y | (int)r1.x;
  if (r1.z != 0) {
    r1.x = -cb2[3].y * 2 + r0.y;
    r1.x = saturate(1 + r1.x);
    r1.x = r1.x * r1.x;
    r2.x = cb2[2].x * cb2[0].x;
    r2.z = -cb2[0].w * cb2[2].y + r0.y;
    r0.z = 1;
    r2.xy = r2.xz + r0.xz;
    r2.zw = t1.Sample(s1_s, r2.xy).xy;
    r2.xy = float2(0.5,0.5) * r2.xy;
    r2.xy = t1.Sample(s1_s, r2.xy).xy;
    r2.xyzw = cb2[0].xxyy * r2.xyzw;
    r2.xy = float2(0.5,0.5) * r2.xy;
    r2.xy = r2.zw * float2(0.5,0.5) + r2.xy;
    r0.z = cb2[3].x * r1.x;
    r1.xz = saturate(r2.xy * r0.zz + r0.xy);
    r2.xy = r0.ww ? r1.xz : r0.xy;
    r2.xyz = t0.Sample(s0_s, r2.xy).xyz;
    r2.xyz = ReinhardScalableCached(r2.xyz);
    r0.xy = r1.xz;
    r0.z = 0;
    r1.x = 0;
    r3.x = 0;
  } else {
    r1.z = cmp(asint(cb2[2].w) == 2);
    if (r1.z != 0) {
      r1.z = cb2[2].y * cb2[0].z;
      r1.z = 15 * r1.z;
      r1.z = floor(r1.z);
      r4.xyz = float3(0.0666666701,5.39166689,1.82500005) * r1.zzz;
      r5.xyz = cmp(r4.yzy >= -r4.yzy);
      r4.yzw = frac(abs(r4.yzy));
      r4.yzw = r5.xyz ? r4.yzw : -r4.wzw;
      r4.yzw = float3(8,8,60.2400017) * r4.yzw;
      r4.yz = r0.xy * float2(0.600000024,0.400000006) + r4.yz;
      r1.z = floor(r4.w);
      r5.x = 0.0166002642 * r1.z;
      r5.y = 0;
      r5.xy = r0.xy * float2(0.25,1) + r5.xy;
      r5.xy = t2.Sample(s2_s, r5.xy).zw;
      r1.z = sin(r4.x);
      r1.z = max(0, r1.z);
      r1.z = r5.y * r1.z;
      r2.w = saturate(cb2[2].x + -r5.x);
      r4.xy = t2.Sample(s2_s, r4.yz).xy;
      r4.xy = r4.xy * float2(2,2) + float2(-1,-1);
      r1.z = r2.w * r1.z;
      r4.zw = r2.ww * float2(0.100000001,0.0329999998) + r1.zz;
      r4.xy = r4.xy * r4.zw;
      r1.z = r4.x * 0.5 + cb2[2].x;
      r1.z = cmp(r5.x < r1.z);
      r4.xy = r1.zz ? r4.xy : 0;
      r4.xy = r4.xy + r0.xy;
      r4.zw = r0.ww ? r4.xy : r0.xy;
      r2.xyz = t0.Sample(s0_s, r4.zw).xyz;
      r2.xyz = ReinhardScalableCached(r2.xyz);
      r0.xy = r4.xy;
      r0.z = 0;
      r1.x = 0;
      r3.x = 0;
    } else {
      r1.z = cmp(asint(cb2[2].w) == 3);
      if (r1.z != 0) {
        r4.xyz = float3(1234,0.333333343,0.200000003) * cb2[0].www;
        r4.xz = frac(r4.xz);
        r1.z = 12345 * r4.x;
        r1.z = r0.y * 100 + r1.z;
        r1.z = 0.103100002 * r1.z;
        r1.z = frac(r1.z);
        r2.w = 19.1900005 + r1.z;
        r2.w = dot(r1.zzz, r2.www);
        r1.z = r2.w + r1.z;
        r2.w = r1.z + r1.z;
        r1.z = r2.w * r1.z;
        r1.z = frac(r1.z);
        r2.w = 123.449997 * r1.z;
        r2.w = frac(r2.w);
        r2.w = cb2[2].y * r2.w;
        r3.w = r2.w + r2.w;
        r4.x = 0.300000012 + -r0.y;
        r4.x = 3 * r4.x;
        r4.x = frac(r4.x);
        r4.w = 2.66666675 * r4.x;
        r4.w = min(1, r4.w);
        r4.w = 1 + -r4.w;
        r5.xy = float2(5,-14.4269505) * r4.ww;
        r4.w = exp2(r5.y);
        r4.w = r5.x * r4.w;
        r4.w = cb2[2].x * r4.w;
        r2.w = 0.00828157365 * r2.w;
        r2.w = r4.w * r1.z + r2.w;
        r4.x = r4.x * 0.333333343 + -0.119999997;
        r4.x = -abs(r4.x) * 20 + 1;
        r4.x = max(0, r4.x);
        r4.x = r4.x * r4.x;
        r4.x = cb2[2].x * r4.x;
        r0.z = r4.x * 0.400000006 + r3.w;
        r5.x = r2.w + r0.x;
        r2.w = floor(r4.y);
        r2.w = cb2[0].w * 0.333333343 + -r2.w;
        r4.xy = float2(-43.2808495,30) * r2.ww;
        r2.w = exp2(r4.x);
        r2.w = saturate(-0.00999999978 + r2.w);
        r3.w = cos(r4.y);
        r2.w = -r3.w * r2.w;
        r2.w = cb2[3].x * r2.w;
        r3.w = 0.600000024 * r2.w;
        r4.x = cmp(0.949999988 < cb2[3].x);
        r2.w = r2.w * 0.600000024 + r4.z;
        r2.w = -0.5 + r2.w;
        r2.w = r4.x ? r2.w : r3.w;
        r2.w = r2.w * 1.0869565 + r0.y;
        r2.w = 0.920000017 * r2.w;
        r2.w = frac(r2.w);
        r3.xyz = float3(262.5,1.0869565,525) * r2.www;
        r3.w = cmp(0.920000017 < r2.w);
        r2.w = r2.w * 1.0869565 + -1;
        r2.w = 12.5 * r2.w;
        r1.x = r3.w ? r2.w : 0;
        r2.w = floor(r3.z);
        r2.w = r2.w * 0.00207039341 + -r3.y;
        r5.y = cb2[3].z * r2.w + r3.y;
        if (r0.w != 0) {
          r0.w = cmp(cb2[3].y == 0.000000);
          r0.w = r0.w ? 0 : r0.z;
          r4.x = r0.w * 4 + cb2[3].y;
          r4.y = 1 + r0.z;
          r4.xyzw = float4(0.00207039341,-0.000517598353,0.00207039341,0.000517598353) * r4.xyxy;
          r2.w = 1 + r1.z;
          r3.yz = -r4.xy * r2.ww + r5.xy;
          r3.yzw = t0.Sample(s0_s, r3.yz).xyz;
          r2.xyz = ReinhardScalableCached(r2.xyz);
          r5.z = 0.289000005 * r3.z;
          r5.z = r3.y * -0.147 + -r5.z;
          r6.yw = r3.ww * float2(0.43599999,0.43599999) + r5.zz;
          r3.z = 0.514999986 * r3.z;
          r3.y = r3.y * 0.61500001 + -r3.z;
          r6.xz = -r3.ww * float2(0.100000001,0.100000001) + r3.yy;
          r3.yz = -r4.zw * r1.zz + r5.xy;
          r3.yzw = t0.Sample(s0_s, r3.yz).xyz;
          r2.xyz = ReinhardScalableCached(r2.xyz);
          r5.z = 0.289000005 * r3.z;
          r5.z = r3.y * -0.147 + -r5.z;
          r7.yw = r3.ww * float2(0.43599999,0.43599999) + r5.zz;
          r3.z = 0.514999986 * r3.z;
          r3.y = r3.y * 0.61500001 + -r3.z;
          r7.xz = -r3.ww * float2(0.100000001,0.100000001) + r3.yy;
          r3.yzw = t0.Sample(s0_s, r5.xy).xyz;
          r2.xyz = ReinhardScalableCached(r2.xyz);
          r5.z = dot(r3.yzw, float3(0.298999995,0.587000012,0.114));
          r5.w = 0.289000005 * r3.z;
          r5.w = r3.y * -0.147 + -r5.w;
          r8.yw = r3.ww * float2(0.43599999,0.43599999) + r5.ww;
          r3.z = 0.514999986 * r3.z;
          r3.y = r3.y * 0.61500001 + -r3.z;
          r8.xz = -r3.ww * float2(0.100000001,0.100000001) + r3.yy;
          r3.yz = r4.xy * r1.zz + r5.xy;
          r3.yzw = t0.Sample(s0_s, r3.yz).xyz;
          r2.xyz = ReinhardScalableCached(r2.xyz);
          r1.z = 0.289000005 * r3.z;
          r1.z = r3.y * -0.147 + -r1.z;
          r9.yw = r3.ww * float2(0.43599999,0.43599999) + r1.zz;
          r1.z = 0.514999986 * r3.z;
          r1.z = r3.y * 0.61500001 + -r1.z;
          r9.xz = -r3.ww * float2(0.100000001,0.100000001) + r1.zz;
          r3.yz = r4.zw * r2.ww + r5.xy;
          r3.yzw = t0.Sample(s0_s, r3.yz).xyz;
          r2.xyz = ReinhardScalableCached(r2.xyz);
          r1.z = 0.289000005 * r3.z;
          r1.z = r3.y * -0.147 + -r1.z;
          r4.yw = r3.ww * float2(0.43599999,0.43599999) + r1.zz;
          r1.z = 0.514999986 * r3.z;
          r1.z = r3.y * 0.61500001 + -r1.z;
          r4.xz = -r3.ww * float2(0.100000001,0.100000001) + r1.zz;
          r0.w = r0.w * 0.200000003 + 0.200000003;
          r6.xyzw = r7.xyzw + r6.xyzw;
          r6.xyzw = r6.xyzw + r8.xyzw;
          r6.xyzw = r6.xyzw + r9.xyzw;
          r4.xyzw = r6.xyzw + r4.xyzw;
          r4.xyzw = r4.xyzw * r0.wwww;
          r0.w = -r4.y * 0.395000011 + r5.z;
          r2.y = -r4.z * 0.58099997 + r0.w;
          r2.xz = r4.xw * float2(1.13999999,2.03200006) + r5.zz;
        } else {
          r2.xyz = t0.Sample(s0_s, r0.xy).xyz;
          r2.xyz = ReinhardScalableCached(r2.xyz);
        }
        r0.xy = r5.xy;
      } else {
        r2.xyz = float3(0,0,0);
        r0.z = 0;
        r1.x = 0;
        r3.x = 0;
      }
    }
  }

  // //colorUntonemapped
  // colorUntonemapped = r2.xyz /* * Tonemap_CalculatePreExposureMultiplier(cb13[0].xyz, cb13[1].xyz, cb13[2].xyz) */;

  r0.w = cmp(asint(cb2[2].z) == 2);
  r0.w = (int)r1.y | (int)r0.w;
  r0.w = r0.w ? r1.w : 0;
  if (r0.w != 0) {
    r0.w = r0.y * 483 + r0.x;
    r1.y = 123.779999 * cb2[0].w;
    r1.y = frac(r1.y);
    r1.y = 12345.5996 * r1.y;
    r0.w = r0.w * 234.5 + r1.y;
    r1.y = floor(r0.w);
    r0.w = frac(r0.w);
    r1.z = 0.103100002 * r1.y;
    r1.z = frac(r1.z);
    r1.yw = float2(1,19.1900005) + r1.yz;
    r1.w = dot(r1.zzz, r1.www);
    r1.z = r1.z + r1.w;
    r1.w = r1.z + r1.z;
    r1.z = r1.w * r1.z;
    r1.y = 0.103100002 * r1.y;
    r1.yz = frac(r1.yz);
    r1.w = 19.1900005 + r1.y;
    r1.w = dot(r1.yyy, r1.www);
    r1.y = r1.y + r1.w;
    r1.w = r1.y + r1.y;
    r1.y = r1.w * r1.y;
    r1.y = frac(r1.y);
    r1.w = 1 + -r0.w;
    r1.z = r1.z * r1.w;
    r0.w = r1.y * r0.w + r1.z;
    r1.y = cb2[3].z * 0.300000012 + 1;
    r1.yzw = r2.xyz * r1.yyy;
    r2.w = -0.699999988 + r1.x;
    r2.w = 4 * abs(r2.w);
    r2.w = min(1, r2.w);
    r2.w = 1 + -r2.w;
    r3.y = cmp(r1.x >= 0.00100000005);
    r3.y = r3.y ? 1.000000 : 0;
    r2.w = r3.y * r2.w;
    r2.w = r2.w * r0.w;
    r1.x = cmp(0 < r1.x);
    r1.xyz = r1.xxx ? r2.www : r1.yzw;
    r0.w = -0.5 + r0.w;
    r0.w = dot(r0.ww, r0.zz);
    r1.xyz = saturate(r1.xyz + r0.www);
    r0.y = r0.y + r0.y;
    r0.x = r0.x * 8 + r0.y;
    r0.x = cb2[0].w * 0.200000003 + r0.x;
    r0.x = 20 * r0.x;
    r0.x = frac(r0.x);
    r0.x = -r0.x * 2 + 1;
    r0.x = cb2[3].z * abs(r0.x);
    r0.y = 0.25 * r0.z;
    r0.x = saturate(r0.x * 0.5 + r0.y);
    r0.y = dot(r1.xyz, float3(0.298999995,0.587000012,0.114));
    r0.yzw = r0.yyy + -r1.xyz;
    r0.xyz = r0.xxx * r0.yzw + r1.xyz;
    r0.w = frac(r3.x);
    r0.w = -r0.w * 2 + 1;
    r0.w = cb2[3].z * abs(r0.w);
    r0.w = -r0.w * 0.75 + 1;
    r2.xyz = saturate(r0.xyz * r0.www);
  }
  o0.xyz = r2.xyz;
  o0.w = 1;

  //tonemap
  o0.xyz = Tonemap2nd_Do(o0.xyz, s0_s, t0, v1);
  //o0.xyz = DrawBinary(3, o0.xyz, v1.xy);
  return;
}