#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:53:08 2024
Texture2D<float4> t5 : register(t5);  // previous frame?

Texture2D<float4> t4 : register(t4);  // normal

Texture2D<float4> t3 : register(t3);  // depth

Texture2D<float4> t2 : register(t2);  // black

Texture2D<float4> t1 : register(t1);  // motion vectors

Texture2D<float4> t0 : register(t0);  // render

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[5];
}

cbuffer cb12 : register(b12) {
  float4 cb12[53];
}

// 3Dmigoto declarations
#define cmp -

// Convert render input for HDR
float3 convertRenderInput(float3 render) {
  render = renodx::color::pq::EncodeSafe(render, 100.f);
  return render;
}

// Convert render output for HDR
float3 convertRenderOutput(float3 render) {
  render = renodx::color::pq::DecodeSafe(render, 100.f);
  return render;
}

void main(float4 v0: SV_POSITION0, float2 v1: TEXCOORD0, out float4 o0: SV_Target0, out float4 o1: SV_Target1) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, r16;
  uint4 bitmask, uiDest;
  float4 fDest;

  // sample depth textures and various offsets
  r0.xy = -cb2[3].xy + v1.xy;
  r0.z = t3.Sample(s3_s, r0.xy).x;  // depth -
  r1.xy = cb2[3].xy + v1.xy;
  r0.w = t3.Sample(s3_s, r1.xy).x;  // depth +
  r2.xyzw = cb2[3].xyxy * float4(1, 0, 1, -1) + v1.xyxy;
  r1.z = t3.Sample(s3_s, r2.zw).x;  // depth 1, -1
  r0.w = min(r1.z, r0.w);
  r0.w = min(r0.z, r0.w);
  r0.z = cmp(r0.w == r0.z);
  r3.xy = r0.zz ? r0.xy : r1.xy;

  r4.xyz = t0.Sample(s0_s, r0.xy).yxz;  // render - (r4)
  r4.yxz = convertRenderInput(r4.yxz);  // HDR input conversion

  r5.xyz = t0.Sample(s0_s, r1.xy).yxz;  // render + (r5)
  r5.yxz = convertRenderInput(r5.yxz);  // HDR input conversion

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
  r0.xy = r6.xx ? r3.xy : r0.xy;
  r0.z = cmp(r0.w == r0.z);
  r0.w = r0.w * r0.w + -0.949999988;
  r0.w = saturate(20 * r0.w);
  r0.w = 1 + -r0.w;
  r0.xy = r0.zz ? v1.xy : r0.xy;
  r0.xy = t2.Sample(s2_s, r0.xy).xy;
  r6.xy = v1.xy + r0.xy;
  r0.xy = cb12[52].zw * r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = cb12[50].y * r0.x;
  r0.x = min(1, r0.x);
  r7.xyzw = t1.Sample(s1_s, r6.xy).xyzw;  // sample motion vectors
  // Calculate luminance and comparison for TAA
  r5.w = dot(r5.xzy, float3(0.5, 0.25, 0.25));  // r5 luminance
  r0.y = cmp(r5.w < r7.x);
  r4.w = dot(r4.xzy, float3(0.5, 0.25, 0.25));  // r4 luminance

  r8.xyz = t0.Sample(s0_s, r2.zw).yxz;
  r8.yxz = convertRenderInput(r8.yxz);  // HDR input conversion

  r2.xyz = t0.Sample(s0_s, r2.xy).yxz;
  r2.yxz = convertRenderInput(r2.yxz);  // HDR input conversion

  r8.w = dot(r8.xzy, float3(0.5, 0.25, 0.25));  // r8 luminance
  r0.z = cmp(r8.w < r7.x);
  r2.w = dot(r2.xzy, float3(0.5, 0.25, 0.25));  // r7 luminance
  r2.x = cmp(r2.w < r7.x);

  r9.xyz = t0.Sample(s0_s, r1.zw).yxz;
  r9.yxz = convertRenderInput(r9.yxz);  // HDR input conversion

  r1.xyz = t0.Sample(s0_s, r1.xy).yxz;
  r1.yxz = convertRenderInput(r1.yxz);  // HDR input conversion

  r9.w = dot(r9.xzy, float3(0.5, 0.25, 0.25));
  r4.x = cmp(r9.w < r7.x);
  r1.w = dot(r1.xzy, float3(0.5, 0.25, 0.25));
  r5.x = cmp(r1.w < r7.x);

  r10.xyz = t0.Sample(s0_s, r3.zw).yxz;
  r10.yxz = convertRenderInput(r10.yxz);  // HDR input conversion

  r3.xyz = t0.Sample(s0_s, r3.xy).yxz;
  r3.yxz = convertRenderInput(r3.yxz);  // HDR input conversion

  r10.w = dot(r10.xzy, float3(0.5, 0.25, 0.25));
  r6.z = cmp(r10.w < r7.x);
  r11.xyz = cb2[2].zzz * r10.yxz;
  r11.xyz = r1.yxz * cb2[2].www + r11.xyz;
  r11.xyz = r3.yxz * cb2[2].yyy + r11.xyz;
  r3.w = dot(r3.xzy, float3(0.5, 0.25, 0.25));
  r1.x = cmp(r3.w < r7.x);

  r12.xyz = t0.Sample(s0_s, v1.xy).xyz;   // center
  r12.xyz = convertRenderInput(r12.xyz);  // HDR input conversion

  r13.x = dot(r12.yzx, float3(0.5, 0.25, 0.25));  // center luminance
  r3.x = cmp(r13.x < r7.x);
  r13.yz = r12.xz;
  r6.w = cmp(r13.x < 1.00100005);
  r14.xyz = r6.www ? r13.yzx : float3(1.00100005, 1.00100005, 1.00100005);
  r14.xyz = r3.xxx ? float3(1.00100005, 1.00100005, 1.00100005) : r14.xyz;
  r6.w = cmp(r3.w < r14.z);
  r15.xyz = r6.www ? r3.yzw : r14.xyz;
  r14.xyz = r1.xxx ? r14.xyz : r15.xyz;
  r6.w = cmp(r10.w < r14.z);
  r15.xyz = r6.www ? r10.yzw : r14.xyz;
  r14.xyz = r6.zzz ? r14.xyz : r15.xyz;
  r6.w = cmp(r1.w < r14.z);
  r15.xyz = r6.www ? r1.yzw : r14.xyz;
  r14.xyz = r5.xxx ? r14.xyz : r15.xyz;
  r6.w = cmp(r9.w < r14.z);
  r15.xyz = r6.www ? r9.yzw : r14.xyz;
  r14.xyz = r4.xxx ? r14.xyz : r15.xyz;
  r6.w = cmp(r2.w < r14.z);
  r15.xyz = r6.www ? r2.yzw : r14.xyz;
  r14.xyz = r2.xxx ? r14.xyz : r15.xyz;
  r6.w = cmp(r8.w < r14.z);
  r15.xyz = r6.www ? r8.yzw : r14.xyz;
  r14.xyz = r0.zzz ? r14.xyz : r15.xyz;
  r6.w = cmp(r4.w < r14.z);
  r15.xyz = r6.www ? r4.yzw : r14.xyz;
  r6.w = cmp(r4.w < r7.x);
  r14.yzw = r6.www ? r14.xyz : r15.xyz;
  r8.x = cmp(r5.w < r14.w);
  r15.yzw = r8.xxx ? r5.yzw : r14.yzw;
  r8.x = cmp(-0.00100000005 < r13.x);
  r16.xyz = r8.xxx ? r13.yzx : float3(-0.00100000005, -0.00100000005, -0.00100000005);
  r16.xyz = r3.xxx ? r16.xyz : float3(-0.00100000005, -0.00100000005, -0.00100000005);
  r3.x = cmp(r16.z < r3.w);
  r3.xyz = r3.xxx ? r3.yzw : r16.xyz;
  r3.xyz = r1.xxx ? r3.xyz : r16.xyz;
  r1.x = r13.x + -r3.w;
  r1.x = 0.200000003 + -abs(r1.x);
  r3.w = cmp(r3.z < r10.w);
  r10.xyz = r3.www ? r10.yzw : r3.xyz;
  r3.xyz = r6.zzz ? r10.xyz : r3.xyz;
  r3.w = r13.x + -r10.w;
  r3.w = 0.200000003 + -abs(r3.w);
  r3.w = ceil(r3.w);
  r6.z = cmp(r3.z < r1.w);
  r10.xyz = r6.zzz ? r1.yzw : r3.xyz;
  r3.xyz = r5.xxx ? r10.xyz : r3.xyz;
  r1.y = r13.x + -r1.w;
  r1.y = 0.200000003 + -abs(r1.y);
  r1.z = cmp(r3.z < r9.w);
  r9.xyz = r1.zzz ? r9.yzw : r3.xyz;
  r3.xyz = r4.xxx ? r9.xyz : r3.xyz;
  r1.z = r13.x + -r9.w;
  r1.z = 0.200000003 + -abs(r1.z);
  r1.w = cmp(r3.z < r2.w);
  r9.xyz = r1.www ? r2.yzw : r3.xyz;
  r2.xyz = r2.xxx ? r9.xyz : r3.xyz;
  r1.w = r13.x + -r2.w;
  r1.w = 0.200000003 + -abs(r1.w);
  r1.xyzw = ceil(r1.xyzw);
  r2.w = cmp(r2.z < r8.w);
  r3.xyz = r2.www ? r8.yzw : r2.xyz;
  r2.xyz = r0.zzz ? r3.xyz : r2.xyz;
  r0.z = r13.x + -r8.w;
  r0.z = 0.200000003 + -abs(r0.z);
  r2.w = cmp(r2.z < r4.w);
  r3.xyz = r2.www ? r4.yzw : r2.xyz;
  r2.xyz = r6.www ? r3.xyz : r2.xyz;
  r2.w = r13.x + -r4.w;
  r2.w = 0.200000003 + -abs(r2.w);
  r2.w = ceil(r2.w);
  r15.x = r2.y;
  r3.x = cmp(r2.z < r5.w);
  r3.xyz = r3.xxx ? r5.yzw : r2.xyz;
  r4.xw = r0.yy ? r3.xz : r2.xz;
  r14.x = r3.y;
  r8.xyzw = r0.yyyy ? r14.xyzw : r15.xyzw;
  r0.y = r13.x + -r5.w;
  r0.y = 0.200000003 + -abs(r0.y);
  r0.yz = ceil(r0.yz);
  r0.y = 4 + -r0.y;
  r0.y = r0.y + -r2.w;
  r0.y = r0.y + -r0.z;
  r0.y = r0.y + -r1.w;
  r0.y = r0.y + -r1.z;
  r0.y = r0.y + -r1.y;
  r0.y = r0.y + -r3.w;
  r0.y = saturate(r0.y + -r1.x);
  r0.z = cmp(1 < r8.w);
  r1.x = -r8.y * 0.25 + r8.w;
  r1.x = -r8.z * 0.25 + r1.x;
  r1.y = r1.x + r1.x;
  r4.z = r8.x;
  r1.xzw = r8.yzw;
  r2.x = -r4.x * 0.25 + r4.w;
  r2.x = -r8.x * 0.25 + r2.x;
  r4.y = r2.x + r2.x;
  r2.x = cmp(r4.w < 0);
  r2.xyzw = r2.xxxx ? r1.xyzw : r4.xyzw;
  r3.xyzw = r0.zzzz ? r2.xyzw : r1.xyzw;
  r0.z = max(r7.x, r2.w);
  r5.x = min(r0.z, r3.w);
  r5.z = r3.w;
  r5.y = r2.w;
  r8.z = r1.w;
  r8.x = r7.x;
  r8.y = r4.w;
  r0.z = 0.949999988 * r7.y;
  r0.y = r0.y * 0.25 + r0.z;
  r6.zw = -cb2[1].xy + v1.xy;
  r0.z = t4.SampleLevel(s4_s, r6.zw, 0).w;
  r1.w = t5.SampleLevel(s5_s, r6.zw, 0).w;
  r1.w = cmp(r1.w != 0.000000);
  r6.zw = r1.ww ? float2(1, 0.200000003) : 0;
  r0.z = 255 * r0.z;
  r0.z = (uint)r0.z;
  r0.z = cmp((int)r0.z == 1);
  r0.z = r0.z ? 0 : 1;
  r0.y = saturate(r0.y * r0.z);
  r0.z = cmp(r0.y < 0.902499974);
  r5.xyz = r0.zzz ? r5.xyz : r8.xyz;
  r1.w = min(r6.x, r6.y);
  r6.xy = cmp(r6.xy >= float2(1, 1));
  r1.w = cmp(0 >= r1.w);
  r1.w = (int)r6.x | (int)r1.w;
  r1.w = (int)r6.y | (int)r1.w;
  r13.w = 0;
  r5.w = r7.z;
  r2.w = min(r7.w, r6.z);
  r6.w = saturate(r6.w + r2.w);
  r7.xy = r1.ww ? r13.xw : r5.xw;
  r5.xy = r5.zx + -r5.yy;
  r6.z = sqrt(r0.x);
  r0.x = r0.x * r0.x;
  r0.x = -r0.x * r0.x + 1;
  r2.w = r6.z + -r7.y;
  r3.w = r7.x + -r13.x;
  r5.zw = -abs(r2.ww) * float2(20, 100) + float2(1, 1);
  r5.zw = max(float2(0, 0), r5.zw);
  r2.w = -0.800000012 + r6.w;
  r2.w = ceil(r2.w);
  r0.w = -r2.w * r0.w + 1;
  r0.w = r0.w * r5.z;
  r6.y = r5.w * r0.y;
  r0.y = cb2[4].x + -cb2[4].y;
  r0.y = r6.z * r0.y + cb2[4].y;
  o0.yzw = r6.yzw;
  r0.y = min(r0.y, r0.w);
  r2.w = 0.99000001 + -r0.y;
  r0.y = r6.y * r2.w + r0.y;
  r0.x = r0.y * r0.x;
  r0.y = r0.x * r3.w + r13.x;
  r2.w = r0.x * r3.w;
  r2.w = cmp(abs(r2.w) < 0.00999999978);
  o0.x = saturate(r2.w ? r13.x : r0.y);
  r2.xyz = r0.zzz ? r2.xyz : r4.xyz;
  r1.xyz = r0.zzz ? r3.xyz : r1.xyz;
  r1.xyz = r1.xyz + -r2.xyz;
  r0.y = cmp(0.00999999978 < r5.x);
  r0.z = r5.y / r5.x;
  r0.y = r0.y ? r0.z : 0.5;
  r1.xyz = r0.yyy * r1.xyz + r2.xyz;
  r1.xyz = r1.www ? r12.xyz : r1.xyz;
  r2.xyz = r12.xyz * cb2[2].xxx + r11.xyz;
  r2.xyz = r1.www ? r12.xyz : r2.xyz;
  r3.xyz = r12.xyz + -r2.xyz;
  r0.yzw = r0.www * r3.xyz + r2.xyz;
  r1.xyz = r1.xyz + -r0.yzw;
  r0.xyz = saturate(r0.xxx * r1.xyz + r0.yzw);
  r1.xyz = r0.xyz + -r2.xyz;
  r0.xyz = saturate(r1.xyz * cb2[4].zzz + r0.xyz);
  r1.xyz = r2.xyz + -r0.xyz;
  o1.xyz = saturate(cb2[4].www * r1.xyz + r0.xyz);

  o1.xyz = convertRenderOutput(o1.xyz);  // HDR output conversion

  o1.w = 1;
  return;
}
