#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[7];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  r1.xy = cb1[6].xy * v1.xy;
  r1.xy = r1.xy * float2(2,2) + -cb1[6].xy;
  r1.xy = r1.xy / cb1[6].xx;
  r2.yw = float2(39.9450645,8.06345081);
  r3.yw = float2(36.0128288,94.0993729);
  r4.xyzw = float4(1000,1000,10000,10000);
  r0.w = 0;
  while (true) {
    r1.z = cmp((int)r0.w >= asint(cb0[3].w));
    if (r1.z != 0) break;
    r1.z = (int)r0.w;
    r2.xz = float2(0.103100002,0.103100002) * r1.zz;
    r5.xyzw = frac(r2.xyzw);
    r6.xyz = float3(19.1900005,19.1900005,19.1900005) + r5.yxx;
    r1.w = dot(r5.xyx, r6.xyz);
    r2.xz = r5.xy + r1.ww;
    r1.w = r2.x + r2.z;
    r1.w = r1.w * r2.x;
    r1.w = frac(r1.w);
    r1.w = r1.w * 2 + -1;
    r1.w = 16 * r1.w;
    r1.w = floor(r1.w);
    r1.w = r1.w * 1.25660002 + -0.5;
    r6.xyz = float3(19.1900005,19.1900005,19.1900005) + r5.wzz;
    r2.x = dot(r5.zwz, r6.xyz);
    r2.xz = r5.zw + r2.xx;
    r2.z = r2.x + r2.z;
    r2.x = r2.z * r2.x;
    r2.x = frac(r2.x);
    r2.x = r2.x * 2 + -1;
    r2.x = r2.x * r2.x;
    r2.x = 0.5 * r2.x;
    sincos(r1.w, r5.x, r6.x);
    r1.w = r6.x * r2.x + cb0[3].y;
    r3.xz = float2(0.103100002,0.103100002) * r1.zz;
    r6.xyzw = frac(r3.xyzw);
    r5.yzw = float3(19.1900005,19.1900005,19.1900005) + r6.yxx;
    r1.z = dot(r6.xyx, r5.yzw);
    r3.xz = r6.xy + r1.zz;
    r1.z = r3.x + r3.z;
    r1.z = r1.z * r3.x;
    r1.z = frac(r1.z);
    r1.z = r1.z * 2 + -1;
    r7.x = r1.z * 0.00700000022 + r1.w;
    r1.z = r5.x * r2.x + cb0[3].z;
    r5.xyz = float3(19.1900005,19.1900005,19.1900005) + r6.wzz;
    r1.w = dot(r6.zwz, r5.xyz);
    r2.xz = r6.zw + r1.ww;
    r1.w = r2.x + r2.z;
    r1.w = r1.w * r2.x;
    r1.w = frac(r1.w);
    r1.w = r1.w * 2 + -1;
    r7.y = r1.w * 0.00700000022 + r1.z;
    r1.zw = r7.xy + -r1.xy;
    r1.z = dot(r1.zw, r1.zw);
    r2.xz = r4.xy + -r1.xy;
    r1.w = dot(r2.xz, r2.xz);
    r1.zw = sqrt(r1.zw);
    r1.w = cmp(r1.z < r1.w);
    r2.xz = r4.zw + -r1.xy;
    r2.x = dot(r2.xz, r2.xz);
    r2.x = sqrt(r2.x);
    r1.z = cmp(r1.z < r2.x);
    r5.zw = r1.zz ? r7.xy : r4.zw;
    r7.zw = r4.xy;
    r5.xy = r7.zw;
    r4.xyzw = r1.wwww ? r7.xyzw : r5.xyzw;
    r0.w = (int)r0.w + 1;
  }
  r1.zw = -r4.xy + r1.xy;
  r2.xy = r4.xy + -r4.zw;
  r0.w = dot(r2.xy, r2.xy);
  r2.z = rsqrt(r0.w);
  r2.xy = r2.xy * r2.zz;
  r1.z = dot(r1.zw, r2.xy);
  r2.zw = -r4.zw + r1.xy;
  r1.w = dot(r2.zw, r2.xy);
  r1.z = abs(r1.z) + -abs(r1.w);
  r1.xy = -cb0[3].yz + r1.xy;
  r1.x = dot(r1.xy, r1.xy);
  r1.x = sqrt(r1.x);
  r1.x = r1.x * 0.00200000009 + abs(r1.z);
  r1.x = 400 * r1.x;
  r0.w = sqrt(r0.w);
  r0.w = r0.w < 0.0004 ? 0 : r1.x;
  r1.xy = float2(0.103100002,0.103100002) * r4.xy;
  r1.xy = frac(r1.xy);
  r2.xyz = float3(19.1900005,19.1900005,19.1900005) + r1.yxx;
  r1.z = dot(r1.xyx, r2.xyz);
  r1.xy = r1.xy + r1.zz;
  r1.y = r1.x + r1.y;
  r1.x = r1.y * r1.x;
  r1.x = frac(r1.x);
  r1.x = r1.x * 2 + -1;
  r1.xy = r1.xx * cb0[6].xx + v1.xy;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
  r2.xyz = cb0[5].xyz * r1.xyz;
  r1.xyz = r0.w < cb0[4].x ? r2.xyz : r1.xyz;
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
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