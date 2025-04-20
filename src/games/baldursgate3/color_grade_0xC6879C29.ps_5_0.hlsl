#include "./shared.h"
Texture3D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[1];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.zw = float2(-1, 0.666666687);
  r1.zw = float2(1, -1);
  r2.xy = (int2)v0.xy;
  r2.zw = float2(0, 0);
  r2.xyz = t0.Load(r2.xyz).xyz;
  r2.w = cmp(r2.y >= r2.z);
  r2.w = r2.w ? 1.000000 : 0;
  r0.xy = r2.zy;
  r1.xy = r2.yz + -r0.xy;
  r0.xyzw = r2.wwww * r1.xywz + r0.xywz;
  r1.z = r0.w;
  r2.w = cmp(r2.x >= r0.x);
  r2.w = r2.w ? 1.000000 : 0;
  r0.w = r2.x;
  r1.xyw = r0.wyx;
  r1.xyzw = r1.xyzw + -r0.xyzw;
  r0.xyzw = r2.wwww * r1.xyzw + r0.xyzw;
  r1.x = min(r0.w, r0.y);
  r1.x = -r1.x + r0.x;
  r1.y = r1.x * 6 + 1.00000001e-10;
  r0.y = r0.w + -r0.y;
  r0.y = r0.y / r1.y;
  r0.y = r0.z + r0.y;
  r0.y = cb0[0].y + abs(r0.y);
  r0.yzw = float3(1, 0.666666687, 0.333333343) + r0.yyy;
  r0.yzw = frac(r0.yzw);
  r0.yzw = r0.yzw * float3(6, 6, 6) + float3(-3, -3, -3);
  r0.yzw = saturate(float3(-1, -1, -1) + abs(r0.yzw));
  r0.yzw = float3(-1, -1, -1) + r0.yzw;
  r1.y = 1.00000001e-10 + r0.x;
  r1.x = r1.x / r1.y;
  r1.x = cb0[0].x * r1.x;
  r0.yzw = r1.xxx * r0.yzw + float3(1, 1, 1);
  r1.xyz = -r0.xxx * r0.yzw + float3(1, 1, 1);
  r0.xyz = r0.xxx * r0.yzw;
  r1.xyz = cb0[0].zzz * r1.xyz + r0.xyz;
  r0.w = 1 + cb0[0].z;
  r0.xyz = r0.xyz * r0.www;
  r0.w = cmp(cb0[0].z < 0);
  r0.xyz = r0.www ? r0.xyz : r1.xyz;
  r0.xyz = r0.xyz + -r2.xyz;
  r0.xyz = cb0[0].www * r0.xyz + r2.xyz;
  // r1.xyz = float3(0.00450450415,0.00450450415,0.00450450415) * r0.xyz;
  // r0.xyz = cmp(r0.xyz == float3(0,0,0));
  // r1.xyz = log2(abs(r1.xyz));
  // r1.xyz = float3(0.159301758,0.159301758,0.159301758) * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r0.xyz = r0.xyz ? float3(0,0,0) : r1.xyz;
  // r1.xyz = r0.xyz * float3(18.8515625,18.8515625,18.8515625) + float3(0.8359375,0.8359375,0.8359375);
  // r0.xyz = r0.xyz * float3(18.6875,18.6875,18.6875) + float3(1,1,1);
  // r0.xyz = r1.xyz / r0.xyz;
  // r0.xyz = log2(r0.xyz);
  // r0.xyz = float3(78.84375,78.84375,78.84375) * r0.xyz;
  // r0.xyz = exp2(r0.xyz);
  // r0.xyz = min(float3(1,1,1), r0.xyz);
  if (RENODX_COLOR_GRADE_STRENGTH != 1.f) {
    float3 ungraded = renodx::color::ap1::from::BT709(r0.rgb);
    r0.rgb = renodx::color::pq::EncodeSafe(r0.rgb, 45.f);  // why 45?
    r0.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
    r0.rgb = lerp(ungraded, r0.rgb, RENODX_COLOR_GRADE_STRENGTH);
  } else {
    r0.rgb = renodx::color::pq::EncodeSafe(r0.rgb, 45.f);  // why 45?
    r0.xyz = t1.SampleLevel(s0_s, r0.xyz, 0).xyz;
  }

  // r0.rgb = renodx::color::ap1::from::BT709(r0.rgb);
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}
