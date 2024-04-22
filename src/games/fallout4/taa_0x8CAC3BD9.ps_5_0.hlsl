#include "../../shaders/color.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);  // render
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t3 : register(t3);

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);

cbuffer cb2 : register(b2) {
  float4 cb2[6];
}

// 3Dmigoto declarations
#define cmp -

float3 convertRenderInput(float3 render) {
  render = mul(BT709_2_BT2020_MAT, render);
  render = max(0, render);
  render = pqFromLinear((render * 80.f) / 10000.f);
  return render;
}

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_Target0, out float4 o1 : SV_Target1) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb2[3].xy + v1.xy;
  r0.z = t3.Sample(s3_s, r0.xy).x;
  r1.xy = cb2[3].xy + v1.xy;
  r0.w = t3.Sample(s3_s, r1.xy).x;
  r2.xyzw = cb2[3].xyxy * float4(1, 0, 1, -1) + v1.xyxy;
  r1.z = t3.Sample(s3_s, r2.zw).x;
  r0.w = min(r1.z, r0.w);
  r0.w = min(r0.z, r0.w);
  r0.z = cmp(r0.w == r0.z);
  r3.xy = r0.zz ? r0.xy : r1.xy;
  r4.xyz = t0.Sample(s0_s, r0.xy).yxz;
  r4.xyz = convertRenderInput(r4.xyz);

  r5.xyz = t0.Sample(s0_s, r1.xy).yxz;
  r5.xyz = convertRenderInput(r5.xyz);

  r0.x = cmp(r0.w == r1.z);
  r0.xy = r0.xx ? r2.zw : r3.xy;
  r1.xyzw = cb2[3].xyxy * float4(-1, 1, 0, -1) + v1.xyxy;
  r0.z = t3.Sample(s3_s, r1.zw).x;
  r0.w = min(r0.z, r0.w);
  r3.x = t3.Sample(s3_s, r2.xy).x;
  r0.w = min(r3.x, r0.w);
  r3.x = cmp(r0.w == r3.x);
  r0.xy = r3.xx ? r2.xy : r0.xy;
  r0.z = cmp(r0.w == r0.z);
  r0.xy = r0.zz ? r1.zw : r0.xy;
  r3.xyzw = cb2[3].xyxy * float4(0, 1, -1, 0) + v1.xyxy;
  r0.z = t3.Sample(s3_s, r3.zw).x;
  r0.w = min(r0.z, r0.w);
  r6.x = t3.Sample(s3_s, r1.xy).x;
  r0.w = min(r6.x, r0.w);
  r6.x = cmp(r0.w == r6.x);
  r0.xy = r6.xx ? r1.xy : r0.xy;
  r0.z = cmp(r0.w == r0.z);
  r0.xy = r0.zz ? r3.zw : r0.xy;
  r0.z = t3.Sample(s3_s, v1.xy).x;
  r0.w = min(r0.z, r0.w);
  r6.x = t3.Sample(s3_s, r3.xy).x;
  r0.w = min(r6.x, r0.w);
  r6.x = cmp(r0.w == r6.x);
  r0.z = cmp(r0.w == r0.z);
  r0.xy = r6.xx ? r3.xy : r0.xy;
  r0.xy = r0.zz ? v1.xy : r0.xy;
  r0.xy = t2.Sample(s2_s, r0.xy).xy;
  r0.zw = cb2[5].zw * r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.yz = cb2[0].zw * r0.zw;
  r0.yz = v1.xy * cb2[5].zw + r0.yz;
  r6.xy = t1.Sample(s1_s, r0.yz).xz;
  r7.xyz = t0.Sample(s0_s, r2.xy).yxz;
  r7.xyz = convertRenderInput(r7.xyz);

  r2.xyz = t0.Sample(s0_s, r2.zw).yxz;
  r2.xyz = convertRenderInput(r2.xyz);

  r7.w = dot(r7.xzy, float3(0.5, 0.25, 0.25));
  r0.w = cmp(r7.w < r6.x);
  r8.xyz = t0.Sample(s0_s, r1.zw).yxz;
  r8.xyz = convertRenderInput(r8.xyz);

  r1.xyz = t0.Sample(s0_s, r1.xy).yxz;
  r1.xyz = convertRenderInput(r1.xyz);

  r8.w = dot(r8.xzy, float3(0.5, 0.25, 0.25));
  r6.z = cmp(r8.w < r6.x);
  r1.w = dot(r1.xzy, float3(0.5, 0.25, 0.25));
  r6.w = cmp(r1.w < r6.x);
  r9.xyz = t0.Sample(s0_s, r3.zw).yxz;
  r9.xyz = convertRenderInput(r9.xyz);

  r3.xyz = t0.Sample(s0_s, r3.xy).yxz;
  r3.xyz = convertRenderInput(r3.xyz);

  r9.w = dot(r9.xzy, float3(0.5, 0.25, 0.25));
  r7.x = cmp(r9.w < r6.x);
  r3.w = dot(r3.xzy, float3(0.5, 0.25, 0.25));
  r8.x = cmp(r3.w < r6.x);
  r10.xyz = t0.Sample(s0_s, v1.xy).xyz;
  r10.xyz = convertRenderInput(r10.xyz);

  r11.x = dot(r10.yzx, float3(0.5, 0.25, 0.25));
  r10.w = cmp(r11.x < r6.x);
  r11.yz = r10.xz;
  r12.x = cmp(r11.x < 1.00100005);
  r12.xyz = r12.xxx ? r11.yzx : float3(1.00100005, 1.00100005, 1.00100005);
  r12.xyz = r10.www ? float3(1.00100005, 1.00100005, 1.00100005) : r12.xyz;
  r12.w = cmp(r3.w < r12.z);
  r13.xyz = r12.www ? r3.yzw : r12.xyz;
  r12.xyz = r8.xxx ? r12.xyz : r13.xyz;
  r12.w = cmp(r9.w < r12.z);
  r13.xyz = cb2[2].zzz * r9.yxz;
  r13.xyz = r1.yxz * cb2[2].www + r13.xyz;
  r13.xyz = r3.yxz * cb2[2].yyy + r13.xyz;
  r13.xyz = r10.xyz * cb2[2].xxx + r13.xyz;
  r14.xyz = r12.www ? r9.yzw : r12.xyz;
  r12.xyz = r7.xxx ? r12.xyz : r14.xyz;
  r1.x = cmp(r1.w < r12.z);
  r14.xyz = r1.xxx ? r1.yzw : r12.xyz;
  r12.xyz = r6.www ? r12.xyz : r14.xyz;
  r1.x = cmp(r8.w < r12.z);
  r14.xyz = r1.xxx ? r8.yzw : r12.xyz;
  r12.xyz = r6.zzz ? r12.xyz : r14.xyz;
  r1.x = cmp(r7.w < r12.z);
  r14.xyz = r1.xxx ? r7.yzw : r12.xyz;
  r12.xyz = r0.www ? r12.xyz : r14.xyz;
  r2.w = dot(r2.xzy, float3(0.5, 0.25, 0.25));
  r1.x = cmp(r2.w < r12.z);
  r14.xyz = r1.xxx ? r2.yzw : r12.xyz;
  r1.x = cmp(r2.w < r6.x);
  r12.xyz = r1.xxx ? r12.xyz : r14.xyz;
  r4.w = dot(r4.xzy, float3(0.5, 0.25, 0.25));
  r2.x = cmp(r4.w < r12.z);
  r14.xyz = r2.xxx ? r4.yzw : r12.xyz;
  r2.x = cmp(r4.w < r6.x);
  r12.yzw = r2.xxx ? r12.xyz : r14.xyz;
  r5.w = dot(r5.xzy, float3(0.5, 0.25, 0.25));
  r3.x = cmp(r5.w < r12.w);
  r14.yzw = r3.xxx ? r5.yzw : r12.yzw;
  r3.x = cmp(-0.00100000005 < r11.x);
  r15.xyz = r3.xxx ? r11.yzx : float3(-0.00100000005, -0.00100000005, -0.00100000005);
  r15.xyz = r10.www ? r15.xyz : float3(-0.00100000005, -0.00100000005, -0.00100000005);
  r3.x = cmp(r15.z < r3.w);
  r3.xyz = r3.xxx ? r3.yzw : r15.xyz;
  r3.xyz = r8.xxx ? r3.xyz : r15.xyz;
  r3.w = cmp(r3.z < r9.w);
  r9.xyz = r3.www ? r9.yzw : r3.xyz;
  r3.xyz = r7.xxx ? r9.xyz : r3.xyz;
  r3.w = cmp(r3.z < r1.w);
  r1.yzw = r3.www ? r1.yzw : r3.xyz;
  r1.yzw = r6.www ? r1.yzw : r3.xyz;
  r3.x = cmp(r1.w < r8.w);
  r3.xyz = r3.xxx ? r8.yzw : r1.yzw;
  r1.yzw = r6.zzz ? r3.xyz : r1.yzw;
  r3.x = cmp(r1.w < r7.w);
  r3.xyz = r3.xxx ? r7.yzw : r1.yzw;
  r1.yzw = r0.www ? r3.xyz : r1.yzw;
  r0.w = cmp(r1.w < r2.w);
  r2.yzw = r0.www ? r2.yzw : r1.yzw;
  r1.xyz = r1.xxx ? r2.yzw : r1.yzw;
  r0.w = cmp(r1.z < r4.w);
  r2.yzw = r0.www ? r4.yzw : r1.xyz;
  r1.xyz = r2.xxx ? r2.yzw : r1.xyz;
  r14.x = r1.y;
  r0.w = cmp(r1.z < r5.w);
  r2.xyz = r0.www ? r5.yzw : r1.xyz;
  r0.w = cmp(r5.w < r6.x);
  r12.x = r2.y;
  r1.xy = r0.ww ? r2.zx : r1.zx;
  r2.xyzw = r0.wwww ? r12.xyzw : r14.xyzw;
  r0.w = -r1.y * 0.25 + r1.x;
  r0.w = -r2.x * 0.25 + r0.w;
  r1.z = r0.w + r0.w;
  r0.w = -r2.y * 0.25 + r2.w;
  r0.w = -r2.z * 0.25 + r0.w;
  r3.z = r0.w + r0.w;
  r1.w = r2.x;
  r3.xyw = r2.wyz;
  r0.w = cmp(1 < r2.w);
  r2.x = cmp(r1.x < 0);
  r1.xyzw = r2.xxxx ? r3.xyzw : r1.xyzw;
  r2.xyzw = r0.wwww ? r1.xyzw : r3.xyzw;
  r0.w = max(r6.x, r1.x);
  r6.x = min(r0.w, r2.x);
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r0.w = min(r0.y, r0.z);
  r0.yz = cmp(r0.yz >= cb2[0].zw);
  r0.w = cmp(0 >= r0.w);
  r0.y = (int)r0.y | (int)r0.w;
  r0.y = (int)r0.z | (int)r0.y;
  r11.w = 0;
  r0.zw = r0.yy ? r11.xw : r6.xy;
  r1.x = r6.x + -r1.x;
  r1.x = r1.x / r2.x;
  r0.z = r0.z + -r11.x;
  r3.x = 128 * cb2[0].x;
  r0.x = saturate(r0.x / r3.x);
  r3.x = cb2[4].x + -cb2[4].y;
  r3.x = r0.x * r3.x + cb2[4].y;
  r0.w = r0.x + -r0.w;
  o0.z = r0.x;
  r0.x = -abs(r0.w) * 20 + 1;
  r0.x = max(0, r0.x);
  r0.w = min(r3.x, r0.x);
  r3.x = r0.w * r0.z + r11.x;
  r0.z = r0.w * r0.z;
  r0.z = cmp(abs(r0.z) < 0.00999999978);
  o0.x = saturate(r0.z ? r11.x : r3.x);
  o0.yw = float2(0, 0);
  r0.z = cmp(0.00999999978 < r2.x);
  r0.z = r0.z ? r1.x : 0.5;
  r1.xyz = r0.zzz * r2.yzw + r1.yzw;
  r1.xyz = r0.yyy ? r10.xyz : r1.xyz;
  r2.xyz = r0.yyy ? r10.xyz : r13.xyz;
  r3.xyz = r10.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r3.xyz + r2.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = saturate(r0.www * r1.xyz + r0.xyz);
  r1.xyz = r0.xyz + -r2.xyz;
  r0.xyz = saturate(r1.xyz * cb2[4].zzz + r0.xyz);
  r1.xyz = r2.xyz + -r0.xyz;
  o1.xyz = saturate(cb2[4].www * r1.xyz + r0.xyz);

  o1.xyz = linearFromPQ(o1.xyz) * 10000.f / 80.f;
  o1.xyz = mul(BT2020_2_BT709_MAT, o1.xyz);

  o1.w = 1;
  return;
}
