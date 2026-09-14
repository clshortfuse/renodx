#include "../shared.h"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[2];
}
cbuffer cb0 : register(b0){
  float4 cb0[132];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float4 v2 : INTERP1,
  out float4 o0 : SV_TARGET0)
{
  const float4 icb[] = { { 0.058824, 0, 0, 0},
                              { 0.529412, 0, 0, 0},
                              { 0.176471, 0, 0, 0},
                              { 0.647059, 0, 0, 0},
                              { 0.764706, 0, 0, 0},
                              { 0.294118, 0, 0, 0},
                              { 0.882353, 0, 0, 0},
                              { 0.411765, 0, 0, 0},
                              { 0.235294, 0, 0, 0},
                              { 0.705882, 0, 0, 0},
                              { 0.117647, 0, 0, 0},
                              { 0.588235, 0, 0, 0},
                              { 0.941176, 0, 0, 0},
                              { 0.470588, 0, 0, 0},
                              { 0.823529, 0, 0, 0},
                              { 0.352941, 0, 0, 0} };
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = dot(v2.xyz, v2.xyz);
  r0.x = rsqrt(r0.x);
  r0.xyz = v2.xyz * r0.xxx;
  r1.xy = cb0[123].xy * v1.xy;
  r1.xy = (uint2)r1.xy;
  r1.zw = float2(0,0);
  r1.xyzw = t2.Load(r1.xyz).xyzw;
  r0.w = cb0[23].y / cb0[23].x;
  r2.y = v1.y * r0.w;
  r2.x = v1.x;
  r0.w = 24 * cb0[19].x;
  r0.w = round(r0.w);
  r0.w = dot(r0.ww, float2(12.9898005,78.2330017));
  r0.w = sin(r0.w);
  r0.w = 43758.5469 * r0.w;
  r0.w = frac(r0.w);
  r2.xy = r2.xy * float2(2,2) + r0.ww;
  r2.xyzw = t1.SampleBias(s1_s, r2.xy, cb0[4].x).xyzw;
  r0.w = -0.5 + r2.x;
  r0.w = cb1[1].y * r0.w + 0.5;
  r1.w = 0.0599999987 * r0.w;
  r0.w = r0.w * 1.89999998 + 0.100000001;
  r2.x = cmp(cb0[25].w == 1.000000);
  if (r2.x != 0) {
    r2.xy = -cb0[131].xy * float2(0.5,0.5) + float2(1,1);
    r2.xy = min(v1.xy, r2.xy);
    r2.xy = cb0[28].xy * r2.xy;
    r2.xyzw = t0.SampleBias(s0_s, r2.xy, cb0[4].x).xyzw;
    r2.yz = v1.xy * float2(2,2) + float2(-1,-1);
    r3.xyzw = cb0[84].xyzw * -r2.zzzz;
    r3.xyzw = cb0[83].xyzw * r2.yyyy + r3.xyzw;
    r2.xyzw = cb0[85].xyzw * r2.xxxx + r3.xyzw;
    r2.xyzw = cb0[86].xyzw + r2.xyzw;
    r2.xyz = r2.xyz / r2.www;
    r2.y = cb0[68].z * r2.y;
    r2.x = cb0[67].z * r2.x + r2.y;
    r2.x = cb0[69].z * r2.z + r2.x;
    r2.x = cb0[70].z + r2.x;
    r2.x = abs(r2.x);
  } else {
    r2.yz = -cb0[131].xy * float2(0.5,0.5) + float2(1,1);
    r2.yz = min(v1.xy, r2.yz);
    r2.yz = cb0[28].xy * r2.yz;
    r3.xyzw = t0.SampleBias(s0_s, r2.yz, cb0[4].x).xyzw;
    r2.y = cb0[24].z * r3.x + cb0[24].w;
    r2.x = 1 / r2.y;
  }
  r3.x = cb0[67].z;
  r3.y = cb0[68].z;
  r3.z = cb0[69].z;
  r2.y = dot(-r3.xyz, -r3.xyz);
  r2.y = rsqrt(r2.y);
  r2.yzw = -r3.xyz * r2.yyy;
  r0.x = dot(r2.yzw, -r0.xyz);
  r0.x = 1 / r0.x;
  r0.x = r2.x * r0.x;
  r0.xy = saturate(r0.xx * float2(-0.00200000009,-0.00999999978) + float2(1,1));
  r0.y = r0.y + -r0.x;
  r0.x = r0.y * 0.200000003 + r0.x;
  r0.y = r0.x * r0.x;
  r0.y = r0.y * r0.y;
  r0.x = r0.x * r0.y;
  r0.xyz = r1.xyz * r0.xxx;
  r0.xyz = r0.www * r0.xyz + r1.www;
  r0.xyz = renodx::math::SignPow(r0.xyz, 0.3);
  r2.xy = cb0[23].xy * v1.xy;
  r2.xy = (uint2)r2.xy;
  r0.w = (uint)r2.x << 2;
  r0.w = (int)r0.w & 12;
  r1.w = (int)r2.y & 3;
  r0.w = (int)r0.w + (int)r1.w;
  r0.w = -icb[r0.w+0].x + 1;
  r0.w = 0.300000012 * r0.w;
  r0.xyz = r0.xyz * float3(6,6,6) + r0.www;
  r0.xyz = round(r0.xyz);
  r0.xyz = float3(0.166666672,0.166666672,0.166666672) * r0.xyz;
  r0.xyz = renodx::math::SignPow(r0.xyz, 10.f / 3.f);
  r0.xyz = r0.xyz + -r1.xyz;
  o0.xyz = cb1[1].xxx * r0.xyz + r1.xyz;
  o0.w = 1;
  return;
}