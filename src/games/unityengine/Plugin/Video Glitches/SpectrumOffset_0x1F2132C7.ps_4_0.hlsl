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
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r0.w = 0.03125 * cb1[0].y;
  r0.w = r0.w >= -r0.w ? frac(abs(r0.w)) : -frac(abs(r0.w));
  r1.x = saturate(cb0[3].y);
  r2.yw = float2(32,192) * r0.ww;
  r1.y = floor(r2.w);
  r1.y = 0.166666672 * r1.y;
  r1.y = dot(r1.yy, float2(12.9898005,78.2330017));
  r1.y = sin(r1.y);
  r1.y = 43758.5469 * r1.y;
  r1.y = frac(r1.y);
  r1.z = 1 + -r1.x;
  r1.z = r1.z * 0.699999988 + r1.y;
  r1.z = min(1, r1.z);
  r1.z = 10 * r1.z;
  r3.xy = v1.xy * r1.zz;
  r3.xy = floor(r3.xy);
  r2.xz = r3.xy / r1.zz;
  r1.z = dot(r2.xy, float2(12.9898005,78.2330017));
  r1.z = sin(r1.z);
  r1.z = 43758.5469 * r1.z;
  r1.z = frac(r1.z);
  r1.x = -r1.x * 0.5 + r1.z;
  r1.x = 0.5 + r1.x;
  r1.x = 40 * r1.x;
  r1.z = v1.y * r1.x;
  r1.z = floor(r1.z);
  r2.x = r1.z / r1.x;
  r1.x = dot(r2.xy, float2(12.9898005,78.2330017));
  r1.x = sin(r1.x);
  r1.x = 43758.5469 * r1.x;
  r1.z = dot(r2.zy, float2(12.9898005,78.2330017));
  r1.z = sin(r1.z);
  r1.z = 43758.5469 * r1.z;
  r1.xz = frac(r1.xz);
  r1.z = 0.800000012 + r1.z;
  r1.z = min(1, r1.z);
  r1.z = 0.899999976 + -r1.z;
  r2.xy = r0.ww * float2(32,32) + v1.xy;
  r0.w = dot(r2.xy, float2(12.9898005,78.2330017));
  r0.w = sin(r0.w);
  r0.w = 43758.5469 * r0.w;
  r0.w = frac(r0.w);
  r1.x = cb0[3].y * r1.x;
  r1.x = 0.0500000007 * r1.x;
  r1.y = r1.y > 0.5 ? 1 : -1;
  r1.x = r1.x * r1.y;
  r0.w = r1.x * r0.w;
  r0.w = r0.w * 0.5 + r1.x;
  r1.x = cb0[3].y * r1.z;
  r1.y = r1.x * 0.100000001 + v1.y;
  r1.z = asint(cb0[3].z);
  r1.z = 1 / r1.z;
  r2.x = 0.00313080009;
  r3.y = 1;
  r5.xyz = float3(0,0,0);
  r1.x = v1.x;
  r4.xyzw = float4(0,0,0,0);
  r1.w = 0;
  while (true) {
    r2.y = cmp((int)r1.w >= asint(cb0[3].z));
    if (r2.y != 0) break;
    r2.y = (int)r1.w;
    r2.z = r2.y * r1.z;
    r1.x = saturate(r0.w * r2.z + r1.x);
    r6.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
    r2.w = r6.w;
    r6.xyzw = renodx::color::srgb::EncodeSafe(r6.xyzw);
    r3.x = r2.z <= 0.5 ? 1.000000 : 0;
    r3.z = r2.z <= 0.5 ? 0 : 1;
    r2.y = r2.y * r1.z + -0.166666672;
    r2.y = saturate(1.50000012 * r2.y);
    r2.y = r2.y * 2 + -1;
    r7.y = 1 + -abs(r2.y);
    r7.xz = float2(1,1) + -r7.yy;
    r2.yzw = r7.xyz * r3.xyz;
    r2.yzw = renodx::color::gamma::EncodeSafe(r2.yzw, 2.2f);
    r6.xyz = r6.xyz * r2.yzw;
    r4.xyzw = r6.xyzw + r4.xyzw;
    r5.xyz = r5.xyz + r2.yzw;
    r1.w = (int)r1.w + 1;
  }
  r1.xyw = r4.xyz / r5.xyz;
  r2.w = r4.w * r1.z;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyw;
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
  r2.xyz = float3(0.0404482,0.0404482,0.0404482);
  r0.w = r2.w;
  r0.xyzw = renodx::color::srgb::DecodeSafe(r0.xyzw);
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  r0.w = saturate(r0.w);
  o0.xyzw = r0.xyzw;
  return;
}