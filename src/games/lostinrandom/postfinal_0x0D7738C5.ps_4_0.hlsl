#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[126];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4, r5, r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(0, 0);
  r1.xy = cb0[125].xy * v1.xy;
  r2.xyzw = (int4)r1.xyxy;
  r1.xy = trunc(r1.xy);
  r1.xy = max(float2(0, 0), r1.xy);
  r3.xyzw = (int4)r2.zwzw + int4(-1, -1, 1, -1);
  r2.xyzw = (int4)r2.xyzw + int4(-1, 1, 1, 1);
  r2.xyzw = (int4)r2.xyzw;
  r2.xyzw = max(float4(0, 0, 0, 0), r2.xyzw);
  r3.xyzw = (int4)r3.xyzw;
  r3.xyzw = max(float4(0, 0, 0, 0), r3.xyzw);
  r4.xyzw = float4(-1, -1, -1, -1) + cb0[125].xyxy;
  r3.xyzw = min(r4.xyzw, r3.xyzw);
  r3.xyzw = (int4)r3.zwxy;
  r0.xy = r3.zw;
  r0.xyzw = t0.Load(r0.xyz).xyzw;
  r0.x = renodx::color::y::from::BT709(r0.rgb);
  r2.xyzw = min(r4.xyzw, r2.xyzw);
  r0.yz = min(r4.xy, r1.xy);
  r1.xy = (int2)r0.yz;
  r2.xyzw = (int4)r2.zwxy;
  r4.xy = r2.zw;
  r4.zw = float2(0, 0);
  r4.xyzw = t0.Load(r4.xyz).xyzw;
  r0.y = renodx::color::y::from::BT709(r4.rgb);
  r0.z = r0.x + r0.y;
  r3.zw = float2(0, 0);
  r3.xyzw = t0.Load(r3.xyz).xyzw;
  r0.w = renodx::color::y::from::BT709(r3.rgb);
  r2.zw = float2(0, 0);
  r2.xyzw = t0.Load(r2.xyz).xyzw;
  r2.x = renodx::color::y::from::BT709(r2.rgb);
  r2.y = r2.x + r0.w;
  r3.yw = -r2.yy + r0.zz;
  r0.z = r0.x + r0.w;
  r2.y = r2.x + r0.y;
  r2.y = -r2.y + r0.z;
  r0.z = r0.z + r0.y;
  r0.z = r0.z + r2.x;
  r0.z = 0.03125 * r0.z;
  r0.z = max(0.0078125, r0.z);
  r2.z = min(abs(r2.y), abs(r3.w));
  r3.xz = -r2.yy;
  r0.z = r2.z + r0.z;
  r0.z = 1 / r0.z;
  r3.xyzw = r3.xyzw * r0.zzzz;
  r3.xyzw = max(float4(-8, -8, -8, -8), r3.xyzw);
  r3.xyzw = min(float4(8, 8, 8, 8), r3.xyzw);
  r3.xyzw = cb0[125].zwzw * r3.xyzw;
  r4.xyzw = r3.zwzw * float4(-0.5, -0.5, -0.166666672, -0.166666672) + v1.xyxy;
  r3.xyzw = r3.xyzw * float4(0.166666672, 0.166666672, 0.5, 0.5) + v1.xyxy;
  r5.xyzw = t0.Sample(s0_s, r4.xy).xyzw;
  r4.xyzw = t0.Sample(s0_s, r4.zw).xyzw;
  r6.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
  r3.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
  r2.yzw = r4.xyz + r3.xyz;
  r3.xyz = r6.xyz + r5.xyz;
  r3.xyz = float3(0.25, 0.25, 0.25) * r3.xyz;
  r3.xyz = r2.yzw * float3(0.25, 0.25, 0.25) + r3.xyz;
  r2.yzw = float3(0.5, 0.5, 0.5) * r2.yzw;
  r0.z = renodx::color::y::from::BT709(r3.rgb);
  r3.w = min(r0.w, r0.y);
  r0.y = max(r0.w, r0.y);
  r0.y = max(r0.y, r2.x);
  r0.w = min(r3.w, r2.x);
  r1.zw = float2(0, 0);
  r1.xyzw = t0.Load(r1.xyz).xyzw;
  r1.x = renodx::color::y::from::BT709(r1.rgb);
  r1.y = min(r1.x, r0.x);
  r0.x = max(r1.x, r0.x);
  r0.x = max(r0.x, r0.y);
  r0.y = min(r1.y, r0.w);
  r0.xy = cmp(r0.xz < r0.zy);
  r0.x = (int)r0.x | (int)r0.y;
  o0.xyz = r0.xxx ? r2.yzw : r3.xyz;
  if (injectedData.fxFilmGrain > 0.f) {
    o0.rgb = applyFilmGrain(o0.rgb, v1, injectedData.fxFilmGrainType != 0.f);
  }
  o0.rgb = PostToneMapScale(o0.rgb);
  o0.w = 1;
  return;
}
