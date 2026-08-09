#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[1];
}
cbuffer cb0 : register(b0){
  float4 cb0[4];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r0.w = 0.00277777785 * cb1[0].y;
  r1.x = cmp(r0.w >= -r0.w);
  r0.w = frac(abs(r0.w));
  r0.w = r1.x ? r0.w : -r0.w;
  r1.yz = float2(360,216.000015) * r0.ww;
  r1.x = floor(r1.z);
  r1.z = cos(r1.y);
  r1.w = dot(r1.yy, float2(12.9898005,78.2330017));
  r1.w = sin(r1.w);
  r1.w = 43758.5469 * r1.w;
  r1.w = frac(r1.w);
  r2.x = abs(r1.z) * r1.w;
  r2.xy = float2(100,3.5999999) * r2.xx;
  r1.w = 360 * r1.w;
  r1.w = sin(r1.w);
  r2.z = 0.25 * r1.w;
  r1.w = cmp(r1.w < 0);
  r1.w = r1.w ? 0.125 : r2.z;
  r2.x = v1.y * 100 + -r2.x;
  r2.x = r2.x * r2.x;
  r2.x = -0.0601122938 * r2.x;
  r2.x = exp2(r2.x);
  r3.x = -r1.w * r2.x + v1.x;
  r1.w = cos(r2.y);
  r2.x = 0.5 * r1.w;
  r2.y = cmp(r2.x < v1.y);
  r2.z = dot(r1.xy, float2(12.9898005,78.2330017));
  r2.z = sin(r2.z);
  r2.z = 43758.5469 * r2.z;
  r2.z = frac(r2.z);
  r2.x = r2.z * 0.25 + r2.x;
  r2.x = cmp(v1.y < r2.x);
  r2.x = r2.x ? r2.y : 0;
  if (r2.x != 0) {
    r1.w = 0.0179999992 * r1.w;
    r1.w = cos(r1.w);
    r2.x = 10 * r3.x;
    r2.y = cmp(r2.x >= -r2.x);
    r2.x = frac(abs(r2.x));
    r2.x = r2.y ? r2.x : -r2.x;
    r2.x = 10 * r2.x;
    r2.y = sin(r1.y);
    r2.y = r2.x * r2.y;
    r1.w = 36 * r1.w;
    r1.w = sin(r1.w);
    r1.w = cmp(r1.w < r2.y);
    r2.x = dot(r2.xx, float2(12.9898005,78.2330017));
    r2.x = sin(r2.x);
    r2.x = 43758.5469 * r2.x;
    r2.x = frac(r2.x);
    r2.x = cmp(0.400000006 < r2.x);
    r1.w = (int)r1.w | (int)r2.x;
    if (r1.w != 0) {
      r3.y = v1.y;
      r2.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
      r2.xyz = renodx::color::srgb::EncodeSafe(r2.xyz);
      r1.x = dot(r1.xx, float2(12.9898005,78.2330017));
      r1.x = sin(r1.x);
      r1.x = 43758.5469 * r1.x;
      r1.x = frac(r1.x);
      r2.xyz = r1.xxx * float3(0.75,0.75,0.75) + r2.xyz;
    } else {
      r2.xyz = float3(0,0,0);
    }
  } else {
    r1.x = cmp(v1.y < r1.z);
    r1.z = 20 * r3.x;
    r1.w = cmp(r1.z >= -r1.z);
    r1.z = frac(abs(r1.z));
    r1.z = r1.w ? r1.z : -r1.z;
    r1.z = r1.z + r1.z;
    r4.y = v1.y * r1.y;
    r4.z = r1.y * r1.y;
    r1.w = dot(r4.yz, float2(12.9898005,78.2330017));
    r1.w = sin(r1.w);
    r1.w = 43758.5469 * r1.w;
    r1.w = frac(r1.w);
    r1.z = cmp(r1.w < r1.z);
    r1.x = r1.z ? r1.x : 0;
    r1.z = 6 * v1.y;
    r1.w = cmp(r1.z >= -r1.z);
    r1.z = frac(abs(r1.z));
    r1.z = r1.w ? r1.z : -r1.z;
    r1.z = r1.z + r1.z;
    r3.z = r1.y;
    r1.w = dot(r3.xz, float2(12.9898005,78.2330017));
    r1.w = sin(r1.w);
    r1.w = 43758.5469 * r1.w;
    r1.w = frac(r1.w);
    r1.z = cmp(r1.z < r1.w);
    r1.x = (int)r1.z | (int)r1.x;
    if (r1.x != 0) {
      r5.x = r0.w * 360 + r3.x;
      r5.y = r0.w * 360 + v1.y;
      r0.w = dot(r5.xy, float2(12.9898005,78.2330017));
      r0.w = sin(r0.w);
      r0.w = 43758.5469 * r0.w;
      r0.w = frac(r0.w);
      r0.w = cmp(0.800000012 < r0.w);
      if (r0.w != 0) {
        r4.x = r3.x * r1.y;
        r0.w = dot(r4.xy, float2(12.9898005,78.2330017));
        r0.w = sin(r0.w);
        r0.w = 43758.5469 * r0.w;
        r2.xyz = frac(r0.www);
      } else {
        r3.w = v1.y;
        r1.xyzw = t0.Sample(s0_s, r3.xw).xyzw;
        r2.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
      }
    } else {
      r1.x = r3.z;
      r1.yw = v1.yy;
      r0.w = dot(r1.xy, float2(12.9898005,78.2330017));
      r0.w = sin(r0.w);
      r0.w = 43758.5469 * r0.w;
      r0.w = frac(r0.w);
      r0.w = 0.00870000012 * r0.w;
      r1.x = v1.y + v1.y;
      r1.x = sin(r1.x);
      r1.z = r0.w * r1.x + r3.x;
      r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
      r2.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
    }
  }
  r1.xyz = float3(-0.5,-0.5,-0.5) + r2.xyz;
  r1.xyz = r1.xyz * cb0[2].zzz + cb0[2].yyy;
  r1.xyz = float3(0.5, 0.5, 0.5) + r1.xyz;
  if (injectedData.toneMapType == 0.f) {
    r1.xyz = saturate(r1.xyz);
  }
  r1.xyz = renodx::math::SignPow(r1.xyz, cb0[2].w);
  r0.w = dot(float3(0.298999995,0.587000012,0.114), r1.xyz);
  r1.xyz = r1.xyz + -r0.www;
  r1.xyz = cb0[3].xxx * r1.xyz + r0.www;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = cb0[2].xxx * r1.xyz + r0.xyz;
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}