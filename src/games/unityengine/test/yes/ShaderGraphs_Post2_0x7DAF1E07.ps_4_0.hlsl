#include "../../common.hlsli"

Texture2D<float4> t0 : register(t0);
cbuffer cb1 : register(b1){
  float4 cb1[2];
}
cbuffer cb0 : register(b0){
  float4 cb0[124];
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
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[23].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.x = (uint)r0.x << 2;
  r0.xy = (int2)r0.xy & int2(12,3);
  r0.x = (int)r0.y + (int)r0.x;
  r1.zw = float2(-1,0.666666687);
  r2.zw = float2(1,-1);
  r0.yz = cb1[1].xy * v1.xy;
  r0.yz = floor(r0.yz);
  r0.yz = r0.yz / cb1[1].xy;
  r3.xy = cmp(float2(0,0) != cb1[1].wz);
  r0.yz = r3.xx ? r0.yz : v1.xy;
  r0.yz = cb0[123].xy * r0.yz;
  r4.xy = (uint2)r0.yz;
  r4.zw = float2(0,0);
  r4.xyzw = t0.Load(r4.xyz).xyzw;
  r0.y = cmp(r4.y >= r4.z);
  r0.y = r0.y ? 1.000000 : 0;
  r1.xy = r4.zy;
  r2.xy = r4.yz + -r1.xy;
  r1.xyzw = r0.yyyy * r2.xywz + r1.xywz;
  r0.y = cmp(r4.x >= r1.x);
  r0.y = r0.y ? 1.000000 : 0;
  r2.z = r1.w;
  r1.w = r4.x;
  r2.xyw = r1.wyx;
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r1.xyzw = r0.yyyy * r2.xyzw + r1.xyzw;
  r0.y = r1.w + -r1.y;
  r0.z = min(r1.w, r1.y);
  r0.z = r1.x + -r0.z;
  r0.w = r0.z * 6 + 1.00000001e-010;
  r0.y = r0.y / r0.w;
  r0.y = r1.z + r0.y;
  r2.x = abs(r0.y);
  r0.y = 1.00000001e-010 + r1.x;
  r0.w = cmp(r0.z == 0.000000);
  r2.y = r0.z / r0.y;
  r2.z = r0.w ? r1.x : r0.y;
  r0.y = cmp(0 != cb1[0].w);
  r1.xyz = r0.yyy ? r2.xyz : r4.xyz;
  r0.xzw = r1.xyz * cb1[0].yyy + -icb[r0.x+0].xxx;
  r0.xzw = r0.xzw / cb1[0].yyy;
  r0.xzw = r0.xzw + -r1.xyz;
  r0.xzw = cb1[0].zzz * r0.xzw + r1.xyz;
  r1.xyz = cb1[0].yyy * r1.xyz;
  r1.xyz = floor(r1.xyz);
  r1.xyz = r1.xyz / cb1[0].yyy;
  r0.xzw = r3.yyy ? r0.xzw : r1.xyz;
  r1.xyz = float3(1,0.666666687,0.333333343) + r0.xxx;
  r1.xyz = frac(r1.xyz);
  r1.xyz = r1.xyz * float3(6,6,6) + float3(-3,-3,-3);
  r1.xyz = saturate(float3(-1,-1,-1) + abs(r1.xyz));
  r1.xyz = float3(-1,-1,-1) + r1.xyz;
  r1.xyz = r0.zzz * r1.xyz + float3(1,1,1);
  r1.xyz = r1.xyz * r0.www;
  r0.xyz = r0.yyy ? r1.xyz : r0.xzw;
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}