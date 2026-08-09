#include "../../tonemap.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[6];
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

  r0.xyzw = cb0[5].xyxy * float4(0,-1,-1,0) + v1.xyxy;
  r1.xyzw = t0.SampleLevel(s1_s, r0.xy, 0).xyzw;
  r0.xyzw = t0.SampleLevel(s1_s, r0.zw, 0).xyzw;
  r2.xyzw = t0.SampleLevel(s1_s, v1.xy, 0).xyzw;
  r3.xyzw = cb0[5].xyxy * float4(1,0,0,1) + v1.xyxy;
  r4.xyzw = t0.SampleLevel(s1_s, r3.xy, 0).xyzw;
  r3.xyzw = t0.SampleLevel(s1_s, r3.zw, 0).xyzw;
  r0.w = r1.y * 1.9632107 + r1.x;
  r1.w = r0.y * 1.9632107 + r0.x;
  r2.w = r2.y * 1.9632107 + r2.x;
  r3.w = r4.y * 1.9632107 + r4.x;
  r4.w = r3.y * 1.9632107 + r3.x;
  r5.x = min(r1.w, r0.w);
  r5.y = min(r4.w, r3.w);
  r5.x = min(r5.x, r5.y);
  r5.x = min(r5.x, r2.w);
  r5.y = max(r1.w, r0.w);
  r5.z = max(r4.w, r3.w);
  r5.y = max(r5.y, r5.z);
  r5.y = max(r5.y, r2.w);
  r5.x = r5.y + -r5.x;
  r5.y = 0.125 * r5.y;
  r5.y = max(0.0416666679, r5.y);
  r5.y = cmp(r5.x >= r5.y);
  if (r5.y != 0) {
    r0.xyz = r1.xyz + r0.xyz;
    r0.xyz = r0.xyz + r2.xyz;
    r0.xyz = r0.xyz + r4.xyz;
    r0.xyz = r0.xyz + r3.xyz;
    r1.x = r1.w + r0.w;
    r1.x = r1.x + r3.w;
    r1.x = r1.x + r4.w;
    r1.x = r1.x * 0.25 + -r2.w;
    r1.x = abs(r1.x) / r5.x;
    r1.x = -0.25 + r1.x;
    r1.x = max(0, r1.x);
    r1.x = 1.33333337 * r1.x;
    r1.x = min(0.75, r1.x);
    r1.yz = -cb0[5].xy + v1.xy;
    r5.xyzw = t0.SampleLevel(s1_s, r1.yz, 0).xyzw;
    r6.xyzw = cb0[5].xyxy * float4(1,-1,-1,1) + v1.xyxy;
    r7.xyzw = t0.SampleLevel(s1_s, r6.xy, 0).xyzw;
    r6.xyzw = t0.SampleLevel(s1_s, r6.zw, 0).xyzw;
    r1.yz = cb0[5].xy + v1.xy;
    r8.xyzw = t0.SampleLevel(s1_s, r1.yz, 0).xyzw;
    r3.xyz = r7.xyz + r5.xyz;
    r3.xyz = r3.xyz + r6.xyz;
    r3.xyz = r3.xyz + r8.xyz;
    r0.xyz = r3.xyz + r0.xyz;
    r0.xyz = r0.xyz * r1.xxx;
    r1.y = r5.y * 1.9632107 + r5.x;
    r1.z = r7.y * 1.9632107 + r7.x;
    r3.x = r6.y * 1.9632107 + r6.x;
    r3.y = r8.y * 1.9632107 + r8.x;
    r3.z = -0.5 * r0.w;
    r3.z = r1.y * 0.25 + r3.z;
    r3.z = r1.z * 0.25 + r3.z;
    r4.x = -0.5 * r1.w;
    r4.y = r1.w * 0.5 + -r2.w;
    r4.z = -0.5 * r3.w;
    r4.y = r3.w * 0.5 + r4.y;
    r3.z = abs(r4.y) + abs(r3.z);
    r4.y = -0.5 * r4.w;
    r4.y = r3.x * 0.25 + r4.y;
    r4.y = r3.y * 0.25 + r4.y;
    r3.z = abs(r4.y) + r3.z;
    r1.y = r1.y * 0.25 + r4.x;
    r1.y = r3.x * 0.25 + r1.y;
    r3.x = r0.w * 0.5 + -r2.w;
    r3.x = r4.w * 0.5 + r3.x;
    r1.y = abs(r3.x) + abs(r1.y);
    r1.z = r1.z * 0.25 + r4.z;
    r1.z = r3.y * 0.25 + r1.z;
    r1.y = r1.y + abs(r1.z);
    r1.y = cmp(r1.y >= r3.z);
    r1.z = r1.y ? -cb0[5].y : -cb0[5].x;
    r0.w = r1.y ? r0.w : r1.w;
    r1.w = r1.y ? r4.w : r3.w;
    r3.x = r0.w + -r2.w;
    r3.y = r1.w + -r2.w;
    r0.w = r0.w + r2.w;
    r0.w = 0.5 * r0.w;
    r1.w = r1.w + r2.w;
    r1.w = 0.5 * r1.w;
    r3.z = cmp(abs(r3.x) >= abs(r3.y));
    r0.w = r3.z ? r0.w : r1.w;
    r1.w = r3.z ? abs(r3.x) : abs(r3.y);
    r1.z = r3.z ? r1.z : -r1.z;
    r3.x = 0.5 * r1.z;
    r3.y = r1.y ? 0 : r3.x;
    r3.x = r1.y ? r3.x : 0;
    r4.xy = v1.xy + r3.yx;
    r1.w = 0.25 * r1.w;
    r3.yz = float2(0,0);
    r3.xw = cb0[5].xy;
    r3.xy = r1.yy ? r3.xy : r3.zw;
    r3.zw = r4.xy + -r3.xy;
    r4.xy = r4.xy + r3.xy;
    r4.zw = r3.zw;
    r5.xy = r4.xy;
    r5.zw = r0.ww;
    r6.xyz = float3(0,0,0);
    while (true) {
      r6.w = cmp((int)r6.z >= 16);
      if (r6.w != 0) break;
      if (r6.x == 0) {
        r7.xyzw = t0.SampleLevel(s1_s, r4.zw, 0).xyzw;
        r6.w = r7.y * 1.9632107 + r7.x;
      } else {
        r6.w = r5.z;
      }
      if (r6.y == 0) {
        r7.xyzw = t0.SampleLevel(s1_s, r5.xy, 0).xyzw;
        r7.x = r7.y * 1.9632107 + r7.x;
      } else {
        r7.x = r5.w;
      }
      r7.y = r6.w + -r0.w;
      r7.y = cmp(abs(r7.y) >= r1.w);
      r6.x = (int)r6.x | (int)r7.y;
      r7.y = r7.x + -r0.w;
      r7.y = cmp(abs(r7.y) >= r1.w);
      r6.y = (int)r6.y | (int)r7.y;
      r7.y = (int)r6.y & (int)r6.x;
      if (r7.y != 0) {
        r5.z = r6.w;
        r5.w = r7.x;
        break;
      }
      r7.yz = r4.zw + -r3.xy;
      r4.zw = r6.xx ? r4.zw : r7.yz;
      r7.yz = r5.xy + r3.xy;
      r5.xy = r6.yy ? r5.xy : r7.yz;
      r6.z = (int)r6.z + 1;
      r5.z = r6.w;
      r5.w = r7.x;
    }
    r3.xy = v1.xy + -r4.zw;
    r1.w = r1.y ? r3.x : r3.y;
    r3.xy = -v1.xy + r5.xy;
    r3.x = r1.y ? r3.x : r3.y;
    r3.y = cmp(r1.w < r3.x);
    r3.z = r3.y ? r5.z : r5.w;
    r2.w = r2.w + -r0.w;
    r2.w = cmp(r2.w < 0);
    r0.w = r3.z + -r0.w;
    r0.w = cmp(r0.w < 0);
    r0.w = cmp((int)r0.w == (int)r2.w);
    r0.w = r0.w ? 0 : r1.z;
    r1.z = r3.x + r1.w;
    r1.w = r3.y ? r1.w : r3.x;
    r1.z = -1 / r1.z;
    r1.z = r1.w * r1.z + 0.5;
    r0.w = r1.z * r0.w;
    r1.z = r1.y ? 0 : r0.w;
    r3.x = v1.x + r1.z;
    r0.w = r1.y ? r0.w : 0;
    r3.y = v1.y + r0.w;
    r3.xyzw = t0.SampleLevel(s1_s, r3.xy, 0).xyzw;
    r0.xyz = r0.xyz * float3(0.111111112,0.111111112,0.111111112) + r3.xyz;
    r2.xyz = -r1.xxx * r3.xyz + r0.xyz;
  }
  r0.xyzw = cb0[4].zwzw * float4(-0.00100000005,0.00100000005,0.00100000005,0.00100000005) + v1.xyxy;
  r1.xyzw = t1.Sample(s0_s, r0.xy).xyzw;
  r0.xyzw = t1.Sample(s0_s, r0.zw).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = cb0[4].zwzw * float4(-0.00100000005,-0.00100000005,0.00100000005,-0.00100000005) + v1.xyxy;
  r3.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r0.xyzw = r3.xyzw + r0.xyzw;
  r1.xyzw = t1.Sample(s0_s, r1.zw).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = cb0[4].zwzw * float4(0,0.00100000005,-0.00100000005,0) + v1.xyxy;
  r3.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r0.xyzw = r3.xyzw * float4(2,2,2,2) + r0.xyzw;
  r1.xyzw = t1.Sample(s0_s, r1.zw).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xy = cb0[4].zw * float2(0.00100000005,0) + v1.xy;
  r1.xyzw = t1.Sample(s0_s, r1.xy).xyzw;
  r0.xyzw = r1.xyzw + r0.xyzw;
  r1.xyzw = float4(0.125,0.125,0.125,0.125) * r0.xyzw;
  r3.xyzw = r1.xyzw * r1.xyzw;
  r1.xyzw = r3.xyzw * r1.xyzw;
  r1.xyzw = float4(0.324999988,0.324999988,0.324999988,0.324999988) * r1.xyzw;
  r0.xyzw = r0.xyzw * float4(0.0162499994,0.0162499994,0.0162499994,0.0162499994) + r1.xyzw;
  r1.x = saturate(1 + -r2.x);
  r0.x = r1.x * r0.x;
  r1.xy = float2(1,0) * r0.yy;
  r0.y = 123 * cb0[3].x;
  r0.y = v1.y * 0.100000001 + r0.y;
  r0.y = frac(r0.y);
  r0.y = 2312 * r0.y;
  r0.y = frac(r0.y);
  r0.y = r0.y * 0.25 + 0.5;
  r1.xyz = r1.xxy * r0.yyy;
  r1.xyz = r0.xxx * float3(0,1.60000002,2) + r1.xyz;
  r0.xyz = r0.zzz * float3(0.300000012,0,0) + r1.xyz;
  r1.x = saturate(-r2.y * 1.89999998 + 1.70000005);
  r1.x = r1.x * 3 + 1;
  r0.w = min(0.519999981, r0.w);
  r0.w = r1.x * r0.w;
  r0.xyz = r0.www * float3(0.0799999982,0.129999995,0.159999996) + r0.xyz;
  r0.xyz = r2.xyz + r0.xyz * injectedData.fxBloom;
  if (injectedData.toneMapType == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (injectedData.tonemapCheck == 1.f && (injectedData.count2Old == injectedData.count2New)) {
    r0.xyz = applyUserNoTonemap(r0.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  r0.w = -256 + cb1[6].x;
  r1.x = r0.w / cb1[6].x;
  r1.y = 0;
  r1.xy = v1.xy + -r1.xy;
  r1.xy = cb1[6].xy * r1.xy;
  r1.zw = float2(0.00390625,0.00390625) * r1.xy;
  r2.xyzw = t2.Sample(s2_s, r1.zw).xyzw;
  r1.zw = cmp(float2(0,0) < r1.xy);
  r1.zw = r1.zw ? float2(1,1) : 0;
  r0.w = r2.w * r1.z;
  r0.w = r0.w * r1.w;
  r1.xy = cmp(r1.xy < float2(256,256));
  r1.xy = r1.xy ? float2(1,1) : 0;
  r0.w = r1.x * r0.w;
  r0.w = r0.w * r1.y;
  r1.xyz = r2.xyz + -r0.xyz;
  o0.xyz = r0.www * r1.xyz + r0.xyz;
  o0.w = 1;
  return;
}