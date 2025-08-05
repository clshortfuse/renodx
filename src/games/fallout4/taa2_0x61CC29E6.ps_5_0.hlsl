#include "./shared.h"

Texture2D<float4> t0 : register(t0);  // render
Texture2D<float4> t1 : register(t1);  // motion
Texture2D<float4> t2 : register(t2);  // black
Texture2D<float4> t3 : register(t3);  // depth
Texture2D<float4> t4 : register(t4);  // normal

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);
SamplerState s2_s : register(s2);
SamplerState s3_s : register(s3);
SamplerState s4_s : register(s4);

cbuffer cb2 : register(b2) {
  float4 cb2[6];
}

// 3Dmigoto declarations
#define cmp -

float3 convertRenderInput(float3 render) {
  render = renodx::draw::InvertIntermediatePass(render);
  render /= RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  render = pow(saturate(render), 1.f / 2.2f);
  return render;
}

float3 convertRenderOutput(float3 render) {
  render = pow(saturate(render), 2.2f);
  render *= RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
  render = renodx::draw::RenderIntermediatePass(render);
  return render;
}

void main(float4 v0 : SV_POSITION0, float2 v1 : TEXCOORD0, out float4 o0 : SV_Target0, out float4 o1 : SV_Target1) {
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy - cb2[3].xy;
  r0.z = t3.Sample(s3_s, r0.xy).x;  // depth -
  r1.xy = v1.xy + cb2[3].xy;
  r0.w = t3.Sample(s3_s, r1.xy).x;  // depth +
  r2.xyzw = v1.xyxy + cb2[3].xyxy * float4(1, 0, 1, -1);
  r1.z = t3.Sample(s3_s, r2.zw).x;  // depth 1, -1
  r0.w = min(r1.z, r0.w);
  r0.w = min(r0.z, r0.w);
  r0.z = cmp(r0.w == r0.z);
  r3.xy = r0.zz ? r0.xy : r1.xy;
  r4.xyz = t0.Sample(s0_s, r0.xy).yxz;  // render - (r4)
  r4.yxz = convertRenderInput(r4.yxz);

  r5.xyz = t0.Sample(s0_s, r1.xy).yxz;  // render + (r5)
  r5.yxz = convertRenderInput(r5.yxz);

  r0.x = cmp(r0.w == r1.z);
  r0.xy = r0.xx ? r2.zw : r3.xy;
  r1.xyzw = v1.xyxy + cb2[3].xyxy * float4(-1, 1, 0, -1);
  r0.z = t3.Sample(s3_s, r1.zw).x;  // depth 0, -1
  r0.w = min(r0.z, r0.w);
  r3.x = t3.Sample(s3_s, r2.xy).x;  // depth 1, -1
  r0.w = min(r3.x, r0.w);
  r3.x = cmp(r0.w == r3.x);
  r0.xy = r3.xx ? r2.xy : r0.xy;
  r0.z = cmp(r0.w == r0.z);
  r0.xy = r0.zz ? r1.zw : r0.xy;
  r3.xyzw = v1.xyxy + cb2[3].xyxy * float4(0, 1, -1, 0);
  r0.z = t3.Sample(s3_s, r3.zw).x;  // depth -1, 0
  r0.w = min(r0.z, r0.w);
  r6.x = t3.Sample(s3_s, r1.xy).x;  // depth -1, 1
  r0.w = min(r6.x, r0.w);
  r6.x = cmp(r0.w == r6.x);
  r0.xy = r6.xx ? r1.xy : r0.xy;
  r0.z = cmp(r0.w == r0.z);
  r0.xy = r0.zz ? r3.zw : r0.xy;
  r0.z = t3.Sample(s3_s, v1.xy).x;  // depth 0, 0
  r0.w = min(r0.z, r0.w);
  r6.x = t3.Sample(s3_s, r3.xy).x;  // depth 0, 1
  r0.w = min(r6.x, r0.w);
  r6.x = cmp(r0.w == r6.x);
  r0.xy = r6.xx ? r3.xy : r0.xy;
  r0.z = cmp(r0.w == r0.z);
  r0.w = r0.w * r0.w + -0.949999988;
  r0.w = saturate(20 * r0.w);
  r0.w = 1 + -r0.w;
  r0.xy = r0.zz ? v1.xy : r0.xy;
  r0.xy = t2.Sample(s2_s, r0.xy).xy;  // black ? ?
  r6.xy = cb2[5].zw * r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r0.yz = cb2[0].zw * r6.xy;
  r0.yz = v1.xy * cb2[5].zw + r0.yz;
  r6.xyzw = t1.Sample(s1_s, r0.yz).xyzw;
  r5.w = dot(r5.xzy, float3(0.5, 0.25, 0.25));  // r5 luminance
  r5.x = cmp(r5.w < r6.x);
  r4.w = dot(r4.xzy, float3(0.5, 0.25, 0.25));  // r4 luminance
  r7.xyz = t0.Sample(s0_s, r2.zw).yxz;
  r7.yxz = convertRenderInput(r7.yxz);

  r2.xyz = t0.Sample(s0_s, r2.xy).yxz;
  r2.yxz = convertRenderInput(r2.yxz);

  r7.w = dot(r7.xzy, float3(0.5, 0.25, 0.25));  // r7 luminance
  r4.x = cmp(r7.w < r6.x);
  r2.w = dot(r2.xzy, float3(0.5, 0.25, 0.25));  //
  r2.x = cmp(r2.w < r6.x);
  r8.xyz = t0.Sample(s0_s, r1.zw).yxz;
  r8.yxz = convertRenderInput(r8.yxz);

  r1.xyz = t0.Sample(s0_s, r1.xy).yxz;
  r1.yxz = convertRenderInput(r1.yxz);

  r8.w = dot(r8.xzy, float3(0.5, 0.25, 0.25));
  r7.x = cmp(r8.w < r6.x);
  r1.w = dot(r1.xzy, float3(0.5, 0.25, 0.25));
  r8.x = cmp(r1.w < r6.x);
  r9.xyz = t0.Sample(s0_s, r3.zw).yxz;
  r9.yxz = convertRenderInput(r9.yxz);

  r3.xyz = t0.Sample(s0_s, r3.xy).yxz;
  r3.yxz = convertRenderInput(r3.yxz);

  r9.w = dot(r9.xzy, float3(0.5, 0.25, 0.25));
  r10.x = cmp(r9.w < r6.x);
  r10.yzw = cb2[2].zzz * r9.yxz;
  r10.yzw = r1.yxz * cb2[2].www + r10.yzw;
  r10.yzw = r3.yxz * cb2[2].yyy + r10.yzw;
  r3.w = dot(r3.xzy, float3(0.5, 0.25, 0.25));
  r1.x = cmp(r3.w < r6.x);
  r11.xyz = t0.Sample(s0_s, v1.xy).xyz;  // center
  r11.xyz = convertRenderInput(r11.xyz);

  r12.x = dot(r11.yzx, float3(0.5, 0.25, 0.25));  // center luminance
  r3.x = cmp(r12.x < r6.x);
  r12.yz = r11.xz;
  r9.x = cmp(r12.x < 1.00100005);
  r13.xyz = r9.xxx ? r12.yzx : float3(1.00100005, 1.00100005, 1.00100005);
  r13.xyz = r3.xxx ? float3(1.00100005, 1.00100005, 1.00100005) : r13.xyz;
  r9.x = cmp(r3.w < r13.z);
  r14.xyz = r9.xxx ? r3.yzw : r13.xyz;
  r13.xyz = r1.xxx ? r13.xyz : r14.xyz;
  r9.x = cmp(r9.w < r13.z);
  r14.xyz = r9.xxx ? r9.yzw : r13.xyz;
  r13.xyz = r10.xxx ? r13.xyz : r14.xyz;
  r9.x = cmp(r1.w < r13.z);
  r14.xyz = r9.xxx ? r1.yzw : r13.xyz;
  r13.xyz = r8.xxx ? r13.xyz : r14.xyz;
  r9.x = cmp(r8.w < r13.z);
  r14.xyz = r9.xxx ? r8.yzw : r13.xyz;
  r13.xyz = r7.xxx ? r13.xyz : r14.xyz;
  r9.x = cmp(r2.w < r13.z);
  r14.xyz = r9.xxx ? r2.yzw : r13.xyz;
  r13.xyz = r2.xxx ? r13.xyz : r14.xyz;
  r9.x = cmp(r7.w < r13.z);
  r14.xyz = r9.xxx ? r7.yzw : r13.xyz;
  r13.xyz = r4.xxx ? r13.xyz : r14.xyz;
  r9.x = cmp(r4.w < r13.z);
  r14.xyz = r9.xxx ? r4.yzw : r13.xyz;
  r9.x = cmp(r4.w < r6.x);
  r13.yzw = r9.xxx ? r13.xyz : r14.xyz;
  r11.w = cmp(r5.w < r13.w);
  r14.yzw = r11.www ? r5.yzw : r13.yzw;
  r11.w = cmp(-0.00100000005 < r12.x);
  r15.xyz = r11.www ? r12.yzx : float3(-0.00100000005, -0.00100000005, -0.00100000005);
  r15.xyz = r3.xxx ? r15.xyz : float3(-0.00100000005, -0.00100000005, -0.00100000005);
  r3.x = cmp(r15.z < r3.w);
  r3.xyz = r3.xxx ? r3.yzw : r15.xyz;
  r3.xyz = r1.xxx ? r3.xyz : r15.xyz;
  r1.x = r12.x + -r3.w;
  r1.x = 0.200000003 + -abs(r1.x);
  r3.w = cmp(r3.z < r9.w);
  r15.xyz = r3.www ? r9.yzw : r3.xyz;
  r3.xyz = r10.xxx ? r15.xyz : r3.xyz;
  r3.w = r12.x + -r9.w;
  r3.w = 0.200000003 + -abs(r3.w);
  r9.y = cmp(r3.z < r1.w);
  r9.yzw = r9.yyy ? r1.yzw : r3.xyz;
  r3.xyz = r8.xxx ? r9.yzw : r3.xyz;
  r1.y = r12.x + -r1.w;
  r1.y = 0.200000003 + -abs(r1.y);
  r1.z = cmp(r3.z < r8.w);
  r8.xyz = r1.zzz ? r8.yzw : r3.xyz;
  r3.xyz = r7.xxx ? r8.xyz : r3.xyz;
  r1.z = r12.x + -r8.w;
  r1.z = 0.200000003 + -abs(r1.z);
  r1.w = cmp(r3.z < r2.w);
  r8.xyz = r1.www ? r2.yzw : r3.xyz;
  r2.xyz = r2.xxx ? r8.xyz : r3.xyz;
  r1.w = r12.x + -r2.w;
  r1.w = 0.200000003 + -abs(r1.w);
  r1.xyzw = ceil(r1.xyzw);
  r2.w = cmp(r2.z < r7.w);
  r3.xyz = r2.www ? r7.yzw : r2.xyz;
  r2.xyz = r4.xxx ? r3.xyz : r2.xyz;
  r2.w = r12.x + -r7.w;
  r2.w = 0.200000003 + -abs(r2.w);
  r3.x = cmp(r2.z < r4.w);
  r3.xyz = r3.xxx ? r4.yzw : r2.xyz;
  r2.xyz = r9.xxx ? r3.xyz : r2.xyz;
  r3.x = r12.x + -r4.w;
  r3.x = 0.200000003 + -abs(r3.x);
  r3.xw = ceil(r3.xw);
  r14.x = r2.y;
  r3.y = cmp(r2.z < r5.w);
  r4.xyz = r3.yyy ? r5.yzw : r2.xyz;
  r7.xw = r5.xx ? r4.xz : r2.xz;
  r13.x = r4.y;
  r4.xyzw = r5.xxxx ? r13.xyzw : r14.xyzw;
  r2.x = r12.x + -r5.w;
  r2.x = 0.200000003 + -abs(r2.x);
  r2.xw = ceil(r2.xw);
  r2.x = 4 + -r2.x;
  r2.x = r2.x + -r3.x;
  r2.x = r2.x + -r2.w;
  r1.w = r2.x + -r1.w;
  r1.z = r1.w + -r1.z;
  r1.y = r1.z + -r1.y;
  r1.y = r1.y + -r3.w;
  r1.x = saturate(r1.y + -r1.x);
  r1.y = cmp(1 < r4.w);
  r1.z = -r4.y * 0.25 + r4.w;
  r1.z = -r4.z * 0.25 + r1.z;
  r2.y = r1.z + r1.z;
  r7.z = r4.x;
  r2.xzw = r4.yzw;
  r1.z = -r7.x * 0.25 + r7.w;
  r1.z = -r4.x * 0.25 + r1.z;
  r7.y = r1.z + r1.z;
  r1.z = cmp(r7.w < 0);
  r3.xyzw = r1.zzzz ? r2.xyzw : r7.xyzw;
  r4.xyzw = r1.yyyy ? r3.xyzw : r2.xyzw;
  r1.y = max(r6.x, r3.w);
  r5.x = min(r1.y, r4.w);
  r5.z = r4.w;
  r5.y = r3.w;
  r8.z = r2.w;
  r8.x = r6.x;
  r8.y = r7.w;
  r1.y = 0.949999988 * r6.y;
  r1.x = r1.x * 0.25 + r1.y;
  r1.yz = -cb2[1].xy + v1.xy;
  r1.y = t4.Sample(s4_s, r1.yz).w;
  r1.z = r1.y * 255 + -4;
  r1.y = -0.00980392192 + r1.y;
  r1.y = 0.00294117653 + -abs(r1.y);
  r1.y = ceil(r1.y);
  r1.z = cmp(abs(r1.z) < 0.25);
  r1.z = r1.z ? 0 : 1;
  r1.x = saturate(r1.x * r1.z);
  r1.z = cmp(r1.x < 0.902499974);
  r5.xyz = r1.zzz ? r5.xyz : r8.xyz;
  r1.w = min(r0.y, r0.z);
  r0.yz = cmp(r0.yz >= cb2[0].zw);
  r1.w = cmp(0 >= r1.w);
  r0.y = (int)r0.y | (int)r1.w;
  r0.y = (int)r0.z | (int)r0.y;
  r12.w = 0;
  r5.w = r6.z;
  r0.z = min(r6.w, r1.y);
  r6.w = saturate(r1.y * 0.200000003 + r0.z);
  r1.yw = r0.yy ? r12.xw : r5.xw;
  r5.xy = r5.zx + -r5.yy;
  r0.z = 128 * cb2[0].x;
  r6.z = saturate(r0.x / r0.z);
  r0.x = r6.z + -r1.w;
  r0.z = r1.y + -r12.x;
  r1.yw = -abs(r0.xx) * float2(20, 100) + float2(1, 1);
  r1.yw = max(float2(0, 0), r1.yw);
  r0.x = -0.800000012 + r6.w;
  r0.x = ceil(r0.x);
  r0.x = -r0.x * r0.w + 1;
  r0.x = r0.x * r1.y;
  r6.y = r1.x * r1.w;
  r0.w = cb2[4].x + -cb2[4].y;
  r0.w = r6.z * r0.w + cb2[4].y;
  o0.yzw = r6.yzw;
  r0.w = min(r0.w, r0.x);
  r1.x = 0.99000001 + -r0.w;
  r0.w = r6.y * r1.x + r0.w;
  r1.x = r0.w * r0.z + r12.x;
  r0.z = r0.w * r0.z;
  r0.z = cmp(abs(r0.z) < 0.00999999978);
  o0.x = saturate(r0.z ? r12.x : r1.x);
  r1.xyw = r1.zzz ? r3.xyz : r7.xyz;
  r2.xyz = r1.zzz ? r4.xyz : r2.xyz;
  r2.xyz = r2.xyz + -r1.xyw;
  r0.z = cmp(0.00999999978 < r5.x);
  r1.z = r5.y / r5.x;
  r0.z = r0.z ? r1.z : 0.5;
  r1.xyz = r0.zzz * r2.xyz + r1.xyw;
  r1.xyz = r0.yyy ? r11.xyz : r1.xyz;
  r2.xyz = r11.xyz * cb2[2].xxx + r10.yzw;
  r2.xyz = r0.yyy ? r11.xyz : r2.xyz;
  r3.xyz = r11.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r3.xyz + r2.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = saturate(r0.www * r1.xyz + r0.xyz);
  r1.xyz = r0.xyz + -r2.xyz;
  r0.xyz = saturate(r1.xyz * cb2[4].zzz + r0.xyz);
  r1.xyz = r2.xyz + -r0.xyz;
  o1.xyz = saturate(cb2[4].www * r1.xyz + r0.xyz);

  o1.xyz = convertRenderOutput(o1.xyz);

  o1.w = 1;
  return;
}
