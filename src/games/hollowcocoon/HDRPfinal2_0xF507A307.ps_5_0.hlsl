#include "./common.hlsl"

Texture2DArray<float4> t3 : register(t3);
Texture2DArray<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2DArray<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1) {
  float4 cb1[44];
}
cbuffer cb0 : register(b0) {
  float4 cb0[4];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb1[42].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.xy = (uint2)r0.xy;
  r1.xyzw = float4(-1, -1, -1, -1) + cb1[42].xyxy;
  r0.zw = cb0[3].zw * r1.zw;
  r0.xy = r0.xy * cb0[3].xy + r0.zw;
  r0.xy = (uint2)r0.xy;
  r2.xyzw = (int4)r0.xyxy + int4(-1, -1, 1, -1);
  r2.xyzw = (int4)r2.xyzw;
  r2.xyzw = min(r2.xyzw, r1.xyzw);
  r2.xyzw = (int4)r2.zwxy;
  r3.xy = r2.zw;
  r3.zw = float2(0, 0);
  r3.xyzw = t0.Load(r3.xyzw).xyzw;
  r4.xyzw = (int4)r0.xyxy + int4(-1, 1, 1, 1);
  r4.xyzw = (int4)r4.xyzw;
  r1.xyzw = min(r4.xyzw, r1.xyzw);
  r1.xyzw = (int4)r1.zwxy;
  r4.xy = r1.zw;
  r4.zw = float2(0, 0);
  r4.xyzw = t0.Load(r4.xyzw).xyzw;
  r5.x = r4.w + r3.w;
  r2.zw = float2(0, 0);
  r2.xyzw = t0.Load(r2.xyzw).xyzw;
  r1.zw = float2(0, 0);
  r1.xyzw = t0.Load(r1.xyzw).xyzw;
  r5.y = r2.w + r1.w;
  r5.yw = r5.xx + -r5.yy;
  r6.x = r3.w + r2.w;
  r6.y = r4.w + r1.w;
  r6.y = r6.x + -r6.y;
  r6.x = r6.x + r4.w;
  r6.x = r6.x + r1.w;
  r6.x = 0.03125 * r6.x;
  r6.x = max(0.0078125, r6.x);
  r6.z = min(abs(r6.y), abs(r5.w));
  r5.xz = -r6.yy;
  r6.x = r6.z + r6.x;
  r6.x = rcp(r6.x);
  r5.xyzw = r6.xxxx * r5.xyzw;
  r5.xyzw = max(float4(-8, -8, -8, -8), r5.xyzw);
  r5.xyzw = min(float4(8, 8, 8, 8), r5.xyzw);
  r5.xyzw = cb1[42].zwzw * r5.xyzw;
  r6.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r7.xyzw = saturate(r5.zwzw * float4(-0.5, -0.5, -0.166666672, -0.166666672) + r6.xyxy);
  r5.xyzw = saturate(r5.xyzw * float4(0.166666672, 0.166666672, 0.5, 0.5) + r6.xyxy);
  r5.xyzw = cb1[43].xyxy * r5.xyzw;
  r7.xyzw = cb1[43].xyxy * r7.zwxy;
  r8.xy = r7.zw;
  r8.z = 0;
  r6.z = t0.SampleLevel(s2_s, r8.xyz, 0).w;
  r6.z = saturate(r6.z);
  r8.xy = r5.zw;
  r8.z = 0;
  r5.w = t0.SampleLevel(s2_s, r8.xyz, 0).w;
  r5.w = saturate(r5.w);
  r5.w = r6.z + r5.w;
  r7.z = 0;
  r6.z = t0.SampleLevel(s2_s, r7.xyz, 0).w;
  r6.z = saturate(r6.z);
  r5.z = 0;
  r5.x = t0.SampleLevel(s2_s, r5.xyz, 0).w;
  r5.x = saturate(r5.x);
  r5.x = r6.z + r5.x;
  r5.xy = float2(0.5, 0.25) * r5.xx;
  r5.y = r5.w * 0.25 + r5.y;
  r5.z = min(r2.w, r4.w);
  r5.z = min(r5.z, r1.w);
  r0.zw = float2(0, 0);
  r0.xyzw = t0.Load(r0.xyzw).xyzw;
  r5.w = min(r0.w, r3.w);
  r5.z = min(r5.w, r5.z);
  r0.w = max(r0.w, r3.w);
  r3.x = renodx::color::y::from::BT709(r3.rgb);
  r2.w = max(r2.w, r4.w);
  r2.x = renodx::color::y::from::BT709(r2.rgb);
  r1.w = max(r2.w, r1.w);
  r1.x = renodx::color::y::from::BT709(r1.rgb);
  r0.w = max(r1.w, r0.w);
  r1.y = renodx::color::y::from::BT709(r4.rgb);
  r1.z = r3.x + r1.y;
  r1.w = r2.x + r1.x;
  r4.yw = r1.zz + -r1.ww;
  r1.z = r3.x + r2.x;
  r1.w = r1.y + r1.x;
  r1.w = r1.z + -r1.w;
  r1.z = r1.z + r1.y;
  r1.z = r1.z + r1.x;
  r1.z = 0.03125 * r1.z;
  r1.z = max(0.0078125, r1.z);
  r2.y = min(abs(r1.w), abs(r4.w));
  r4.xz = -r1.ww;
  r1.z = r2.y + r1.z;
  r1.z = rcp(r1.z);
  r4.xyzw = r4.xyzw * r1.zzzz;
  r4.xyzw = max(float4(-8, -8, -8, -8), r4.xyzw);
  r4.xyzw = min(float4(8, 8, 8, 8), r4.xyzw);
  r4.xyzw = cb1[42].zwzw * r4.xyzw;
  r7.xyzw = saturate(r4.zwzw * float4(-0.5, -0.5, -0.166666672, -0.166666672) + r6.xyxy);
  r4.xyzw = saturate(r4.xyzw * float4(0.166666672, 0.166666672, 0.5, 0.5) + r6.xyxy);
  r4.xyzw = cb1[43].xyxy * r4.xyzw;
  r7.xyzw = cb1[43].xyxy * r7.zwxy;
  r8.xy = r7.zw;
  r8.z = 0;
  r2.yzw = t0.SampleLevel(s2_s, r8.xyz, 0).xyz;
  r8.xy = r4.zw;
  r8.z = 0;
  r3.yzw = t0.SampleLevel(s2_s, r8.xyz, 0).xyz;
  r2.yzw = r3.yzw + r2.yzw;
  r2.yzw = float3(0.25, 0.25, 0.25) * r2.yzw;
  r7.z = 0;
  r3.yzw = t0.SampleLevel(s2_s, r7.xyz, 0).xyz;
  r4.z = 0;
  r4.xyz = t0.SampleLevel(s2_s, r4.xyz, 0).xyz;
  r3.yzw = r4.xyz + r3.yzw;
  r2.yzw = r3.yzw * float3(0.25, 0.25, 0.25) + r2.yzw;
  r3.yzw = float3(0.5, 0.5, 0.5) * r3.yzw;
  r1.z = renodx::color::y::from::BT709(r2.gba);
  r1.w = cmp(r1.z < r5.z);
  r0.w = cmp(r0.w < r1.z);
  r0.w = (int)r0.w | (int)r1.w;
  r4.w = r0.w ? r5.x : r5.y;
  r0.w = cmp(0 < r4.w);
  r1.w = min(r2.x, r1.y);
  r1.y = max(r2.x, r1.y);
  r1.y = max(r1.y, r1.x);
  r1.x = min(r1.w, r1.x);
  r5.rgb = r0.rgb;
  r1.w = renodx::color::y::from::BT709(r5.rgb);
  r2.x = min(r1.w, r3.x);
  r1.w = max(r1.w, r3.x);
  r1.y = max(r1.w, r1.y);
  r1.x = min(r2.x, r1.x);
  r1.xy = cmp(r1.zy < r1.xz);
  r1.x = (int)r1.y | (int)r1.x;
  r1.xyz = r1.xxx ? r3.yzw : r2.yzw;
  r4.xyz = r0.www ? r1.xyz : r0.xyz;
  r0.xy = r6.xy * cb0[1].xy + cb0[1].zw;
  r0.x = t1.Sample(s1_s, r0.xy).w;
  r0.x = -0.5 + r0.x;
  r0.x = r0.x + r0.x;
  r0.xyz = r4.xyz * r0.xxx;
  r0.xyz = cb0[0].xxx * r0.xyz * injectedData.fxFilmGrain;
  r0.w = renodx::color::y::from::BT709(r4.rgb);
  r0.a = renodx::math::SignSqrt(r0.a);
  r0.w = cb0[0].y * -r0.w + 1;
  if (injectedData.fxFilmGrainType == 0.f) {
    r0.xyz = r0.xyz * r0.www + r4.xyz;
  } else {
    r0.rgb = applyFilmGrain(r4.rgb, v1);
  }
  o0.w = r4.w;
  if (injectedData.fxNoise > 0.f) {
    r0.rgb = renodx::color::srgb::EncodeSafe(r0.rgb);
    r1.xy = cb0[2].xy * r6.xy;
    r2.xy = cb1[43].xy * r6.xy;
    r1.z = cb0[2].z;
    r0.w = t3.Sample(s1_s, r1.xyz).w;
    r0.w = r0.w * 2 + -1;
    r1.x = 1 + -abs(r0.w);
    r0.w = cmp(r0.w >= 0);
    r0.w = r0.w ? 1 : -1;
    r1.x = sqrt(r1.x);
    r1.x = 1 + -r1.x;
    r0.w = r1.x * r0.w;
    r0.xyz = r0.www * float3(0.00392156886, 0.00392156886, 0.00392156886) * injectedData.fxNoise + r0.xyz;
    r0.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);
  }
  r2.z = 0;
  r1.xyzw = t2.SampleLevel(s0_s, r2.xyz, 0).xyzw;
  o0.xyz = r1.www * r0.xyz + r1.xyz;
  o0.rgb = PostToneMapScale(o0.rgb);
  return;
}
