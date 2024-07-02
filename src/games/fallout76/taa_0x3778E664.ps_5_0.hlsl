#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun May 12 21:52:51 2024
Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

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

// Convert render input for HDR
float3 convertRenderInput(float3 render) {
  render /= injectedData.toneMapGameNits / 80.f;
  render /= injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
  render = pow(saturate(render), 1.f / 2.2f);  // Apply inverse gamma correction
  return render;
}

// Convert render output for HDR
float3 convertRenderOutput(float3 render) {
  render = pow(saturate(render), 2.2f);  // Apply gamma correction
  render *= injectedData.toneMapPeakNits / injectedData.toneMapGameNits;
  render *= injectedData.toneMapGameNits / 80.f;
  return render;
}

// 3Dmigoto declarations
#define cmp -

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
  r4.yxz = convertRenderInput(r4.yxz);  // HDR input conversion

  r5.xyz = t0.Sample(s0_s, r1.xy).yxz;
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
  r0.z = cmp(r0.w == r0.z);
  r0.xy = r6.xx ? r3.xy : r0.xy;
  r0.xy = r0.zz ? v1.xy : r0.xy;
  r0.xy = t2.Sample(s2_s, r0.xy).xy;
  r0.zw = v1.xy + r0.xy;
  r0.xy = cb12[52].zw * r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = cb12[50].y * r0.x;
  r0.x = min(1, r0.x);
  r6.xy = t1.Sample(s1_s, r0.zw).xz;
  r7.xyz = t0.Sample(s0_s, r1.zw).yxz;
  r7.yxz = convertRenderInput(r7.yxz);  // HDR input conversion

  r1.xyz = t0.Sample(s0_s, r1.xy).yxz;
  r1.yxz = convertRenderInput(r1.yxz);  // HDR input conversion

  r7.w = dot(r7.xzy, float3(0.5, 0.25, 0.25));
  r0.y = cmp(r7.w < r6.x);
  r1.w = dot(r1.xzy, float3(0.5, 0.25, 0.25));
  r6.z = cmp(r1.w < r6.x);

  r8.xyz = t0.Sample(s0_s, r3.zw).yxz;
  r8.yxz = convertRenderInput(r8.yxz);  // HDR input conversion

  r3.xyz = t0.Sample(s0_s, r3.xy).yxz;
  r3.yxz = convertRenderInput(r3.yxz);  // HDR input conversion

  r8.w = dot(r8.xzy, float3(0.5, 0.25, 0.25));
  r6.w = cmp(r8.w < r6.x);
  r3.w = dot(r3.xzy, float3(0.5, 0.25, 0.25));
  r7.x = cmp(r3.w < r6.x);

  r9.xyz = t0.Sample(s0_s, v1.xy).xyz;
  r9.xyz = convertRenderInput(r9.xyz);  // HDR input conversion

  r10.x = dot(r9.yzx, float3(0.5, 0.25, 0.25));
  r9.w = cmp(r10.x < r6.x);
  r10.yz = r9.xz;
  r11.x = cmp(r10.x < 1.00100005);
  r11.xyz = r11.xxx ? r10.yzx : float3(1.00100005, 1.00100005, 1.00100005);
  r11.xyz = r9.www ? float3(1.00100005, 1.00100005, 1.00100005) : r11.xyz;
  r11.w = cmp(r3.w < r11.z);
  r12.xyz = r11.www ? r3.yzw : r11.xyz;
  r11.xyz = r7.xxx ? r11.xyz : r12.xyz;
  r12.xyz = cb2[2].zzz * r8.yxz;
  r12.xyz = r1.yxz * cb2[2].www + r12.xyz;
  r12.xyz = r3.yxz * cb2[2].yyy + r12.xyz;
  r12.xyz = r9.xyz * cb2[2].xxx + r12.xyz;
  r1.x = cmp(r8.w < r11.z);
  r13.xyz = r1.xxx ? r8.yzw : r11.xyz;
  r11.xyz = r6.www ? r11.xyz : r13.xyz;
  r1.x = cmp(r1.w < r11.z);
  r13.xyz = r1.xxx ? r1.yzw : r11.xyz;
  r11.xyz = r6.zzz ? r11.xyz : r13.xyz;
  r1.x = cmp(r7.w < r11.z);
  r13.xyz = r1.xxx ? r7.yzw : r11.xyz;
  r11.xyz = r0.yyy ? r11.xyz : r13.xyz;
  r13.xyz = t0.Sample(s0_s, r2.xy).yxz;
  r13.yxz = convertRenderInput(r13.yxz);  // HDR input conversion

  r2.xyz = t0.Sample(s0_s, r2.zw).yxz;
  r2.yxz = convertRenderInput(r2.yxz);  // HDR input conversion

  r13.w = dot(r13.xzy, float3(0.5, 0.25, 0.25));
  r1.x = cmp(r13.w < r11.z);
  r14.xyz = r1.xxx ? r13.yzw : r11.xyz;
  r1.x = cmp(r13.w < r6.x);
  r11.xyz = r1.xxx ? r11.xyz : r14.xyz;
  r2.w = dot(r2.xzy, float3(0.5, 0.25, 0.25));
  r2.x = cmp(r2.w < r11.z);
  r14.xyz = r2.xxx ? r2.yzw : r11.xyz;
  r2.x = cmp(r2.w < r6.x);
  r11.xyz = r2.xxx ? r11.xyz : r14.xyz;
  r4.w = dot(r4.xzy, float3(0.5, 0.25, 0.25));
  r3.x = cmp(r4.w < r11.z);
  r14.xyz = r3.xxx ? r4.yzw : r11.xyz;
  r3.x = cmp(r4.w < r6.x);
  r11.yzw = r3.xxx ? r11.xyz : r14.xyz;
  r5.w = dot(r5.xzy, float3(0.5, 0.25, 0.25));
  r4.x = cmp(r5.w < r11.w);
  r14.yzw = r4.xxx ? r5.yzw : r11.yzw;
  r4.x = cmp(-0.00100000005 < r10.x);
  r15.xyz = r4.xxx ? r10.yzx : float3(-0.00100000005, -0.00100000005, -0.00100000005);
  r15.xyz = r9.www ? r15.xyz : float3(-0.00100000005, -0.00100000005, -0.00100000005);
  r4.x = cmp(r15.z < r3.w);
  r3.yzw = r4.xxx ? r3.yzw : r15.xyz;
  r3.yzw = r7.xxx ? r3.yzw : r15.xyz;
  r4.x = cmp(r3.w < r8.w);
  r8.xyz = r4.xxx ? r8.yzw : r3.yzw;
  r3.yzw = r6.www ? r8.xyz : r3.yzw;
  r4.x = cmp(r3.w < r1.w);
  r1.yzw = r4.xxx ? r1.yzw : r3.yzw;
  r1.yzw = r6.zzz ? r1.yzw : r3.yzw;
  r3.y = cmp(r1.w < r7.w);
  r3.yzw = r3.yyy ? r7.yzw : r1.yzw;
  r1.yzw = r0.yyy ? r3.yzw : r1.yzw;
  r0.y = cmp(r1.w < r13.w);
  r3.yzw = r0.yyy ? r13.yzw : r1.yzw;
  r1.xyz = r1.xxx ? r3.yzw : r1.yzw;
  r0.y = cmp(r1.z < r2.w);
  r2.yzw = r0.yyy ? r2.yzw : r1.xyz;
  r1.xyz = r2.xxx ? r2.yzw : r1.xyz;
  r0.y = cmp(r1.z < r4.w);
  r2.xyz = r0.yyy ? r4.yzw : r1.xyz;
  r1.xyz = r3.xxx ? r2.xyz : r1.xyz;
  r14.x = r1.y;
  r0.y = cmp(r1.z < r5.w);
  r2.xyz = r0.yyy ? r5.yzw : r1.xyz;
  r0.y = cmp(r5.w < r6.x);
  r11.x = r2.y;
  r1.xy = r0.yy ? r2.zx : r1.zx;
  r2.xyzw = r0.yyyy ? r11.xyzw : r14.xyzw;
  r0.y = -r1.y * 0.25 + r1.x;
  r0.y = -r2.x * 0.25 + r0.y;
  r1.z = r0.y + r0.y;
  r0.y = -r2.y * 0.25 + r2.w;
  r0.y = -r2.z * 0.25 + r0.y;
  r3.z = r0.y + r0.y;
  r1.w = r2.x;
  r3.xyw = r2.wyz;
  r0.y = cmp(1 < r2.w);
  r2.x = cmp(r1.x < 0);
  r1.xyzw = r2.xxxx ? r3.xyzw : r1.xyzw;
  r2.xyzw = r0.yyyy ? r1.xyzw : r3.xyzw;
  r0.y = max(r6.x, r1.x);
  r6.x = min(r0.y, r2.x);
  r2.xyzw = r2.xyzw + -r1.xyzw;
  r0.y = min(r0.z, r0.w);
  r0.zw = cmp(r0.zw >= float2(1, 1));
  r0.y = cmp(0 >= r0.y);
  r0.y = (int)r0.z | (int)r0.y;
  r0.y = (int)r0.w | (int)r0.y;
  r10.w = 0;
  r0.zw = r0.yy ? r10.xw : r6.xy;
  r1.x = r6.x + -r1.x;
  r1.x = r1.x / r2.x;
  r0.z = r0.z + -r10.x;
  r3.x = r0.x * r0.x;
  r0.x = sqrt(r0.x);
  r3.x = -r3.x * r3.x + 1;
  r3.y = cb2[4].x + -cb2[4].y;
  r3.y = r0.x * r3.y + cb2[4].y;
  r0.w = r0.x + -r0.w;
  o0.z = r0.x;
  r0.x = -abs(r0.w) * 20 + 1;
  r0.x = max(0, r0.x);
  r0.w = min(r3.y, r0.x);
  r0.w = r0.w * r3.x;
  r3.x = r0.w * r0.z + r10.x;
  r0.z = r0.w * r0.z;
  r0.z = cmp(abs(r0.z) < 0.00999999978);
  o0.x = saturate(r0.z ? r10.x : r3.x);
  o0.yw = float2(0, 0);
  r0.z = cmp(0.00999999978 < r2.x);
  r0.z = r0.z ? r1.x : 0.5;
  r1.xyz = r0.zzz * r2.yzw + r1.yzw;
  r1.xyz = r0.yyy ? r9.xyz : r1.xyz;
  r2.xyz = r0.yyy ? r9.xyz : r12.xyz;
  r3.xyz = r9.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r3.xyz + r2.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = saturate(r0.www * r1.xyz + r0.xyz);
  r1.xyz = r0.xyz + -r2.xyz;
  r0.xyz = saturate(r1.xyz * cb2[4].zzz + r0.xyz);
  r1.xyz = r2.xyz + -r0.xyz;
  o1.xyz = saturate(cb2[4].www * r1.xyz + r0.xyz);

  // HDR output conversion
  o1.xyz = convertRenderOutput(o1.xyz);

  o1.w = 1;
  return;
}