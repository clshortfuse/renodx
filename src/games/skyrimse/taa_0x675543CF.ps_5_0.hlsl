#include "./shared.h"
// ---- Created with 3Dmigoto v1.3.16 on Mon Mar 02 11:09:13 2026
// HDR-enabled version: only PQ encode/decode changes from original, all other logic preserved
Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[6];
}

cbuffer cb12 : register(b12)
{
  float4 cb12[45];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb2[3].xy + v1.xy;
  r0.zw = cb2[3].xy + v1.xy;
  r1.xy = cb12[43].xy * r0.zw;
  r1.xy = max(float2(0,0), r1.xy);
  r2.x = cb12[44].z;
  r2.y = cb12[43].y;
  r1.xy = min(r2.xy, r1.xy);
  r1.z = t3.Sample(s3_s, r1.xy).x;
  r3.xyz = t0.Sample(s0_s, r1.xy).yxz;
  r3.xyz = renodx::color::pq::Encode(renodx::color::gamma::DecodeSafe(r3.xyz), 100.f);
  r4.xyzw = cb2[3].xyxy * float4(1,-1,1,0) + v1.xyxy;
  r5.xyzw = cb12[43].xyxy * r4.xyzw;
  r5.xyzw = max(float4(0,0,0,0), r5.xyzw);
  r5.xyzw = min(r5.xyzw, r2.xyxy);
  r1.x = t3.Sample(s3_s, r5.xy).x;
  r1.y = min(r1.x, r1.z);
  r1.zw = cb12[43].xy * r0.xy;
  r1.zw = max(float2(0,0), r1.zw);
  r1.zw = min(r1.zw, r2.xy);
  r2.z = t3.Sample(s3_s, r1.zw).x;
  r1.y = min(r2.z, r1.y);
  r2.z = cmp(r1.y == r2.z);
  r0.xy = r2.zz ? r0.xy : r0.zw;
  r0.z = cmp(r1.y == r1.x);
  r0.xy = r0.zz ? r4.xy : r0.xy;
  r6.xyzw = cb2[3].xyxy * float4(0,-1,-1,1) + v1.xyxy;
  r7.xyzw = cb12[43].xyxy * r6.xyzw;
  r7.xyzw = max(float4(0,0,0,0), r7.xyzw);
  r7.xyzw = min(r7.xyzw, r2.xyxy);
  r0.z = t3.Sample(s3_s, r7.xy).x;
  r0.w = min(r0.z, r1.y);
  r1.x = t3.Sample(s3_s, r5.zw).x;
  r0.w = min(r1.x, r0.w);
  r1.x = cmp(r0.w == r1.x);
  r0.xy = r1.xx ? r4.zw : r0.xy;
  r0.z = cmp(r0.w == r0.z);
  r0.xy = r0.zz ? r6.xy : r0.xy;
  r4.xyzw = cb2[3].xyxy * float4(-1,0,0,1) + v1.xyxy;
  r8.xyzw = cb12[43].xyxy * r4.xyzw;
  r8.xyzw = max(float4(0,0,0,0), r8.xyzw);
  r8.xyzw = min(r8.xyzw, r2.xyxy);
  r0.z = t3.Sample(s3_s, r8.xy).x;
  r0.w = min(r0.z, r0.w);
  r1.x = t3.Sample(s3_s, r7.zw).x;
  r0.w = min(r1.x, r0.w);
  r1.x = cmp(r0.w == r1.x);
  r0.xy = r1.xx ? r6.zw : r0.xy;
  r0.z = cmp(r0.w == r0.z);
  r0.xy = r0.zz ? r4.xy : r0.xy;
  r1.xy = cb12[43].xy * v1.xy;
  r1.xy = max(float2(0,0), r1.xy);
  r1.xy = min(r1.xy, r2.xy);
  r0.z = t3.Sample(s3_s, r1.xy).x;
  r0.w = min(r0.z, r0.w);
  r2.z = t3.Sample(s3_s, r8.zw).x;
  r0.w = min(r2.z, r0.w);
  r2.z = cmp(r0.w == r2.z);
  r0.z = cmp(r0.w == r0.z);
  r0.xy = r2.zz ? r4.zw : r0.xy;
  r0.xy = r0.zz ? v1.xy : r0.xy;
  r0.xy = cb12[43].xy * r0.xy;
  r0.xy = max(float2(0,0), r0.xy);
  r0.xy = min(r0.xy, r2.xy);
  r0.xy = t2.Sample(s2_s, r0.xy).xy;
  r0.zw = v1.xy + r0.xy;
  r0.x = dot(r0.xy, r0.xy);
  r0.x = sqrt(r0.x);
  r2.xy = cb12[43].zw * r0.zw;
  r2.xy = max(float2(0,0), r2.xy);
  r4.x = min(cb12[44].w, r2.x);
  r4.y = min(cb12[43].w, r2.y);
  r2.xyw = t1.Sample(s1_s, r4.xy).xyz;
  r3.w = dot(r3.xzy, float3(0.5,0.25,0.25));
  r0.y = cmp(r3.w < r2.x);
  r4.xyz = t0.Sample(s0_s, r1.zw).yxz;
  r4.xyz = renodx::color::pq::Encode(renodx::color::gamma::DecodeSafe(r4.xyz), 100.f);
  r1.z = t5.Sample(s5_s, r1.zw).z;
  r1.z = cmp(0 < r1.z);
  r4.w = dot(r4.xzy, float3(0.5,0.25,0.25));
  r1.w = cmp(r4.w < r2.x);
  r6.xyz = t0.Sample(s0_s, r5.xy).yxz;
  r6.xyz = renodx::color::pq::Encode(renodx::color::gamma::DecodeSafe(r6.xyz), 100.f);
  r6.w = dot(r6.xzy, float3(0.5,0.25,0.25));
  r3.x = cmp(r6.w < r2.x);
  r9.xyz = t0.Sample(s0_s, r5.zw).yxz;
  r9.xyz = renodx::color::pq::Encode(renodx::color::gamma::DecodeSafe(r9.xyz), 100.f);
  r9.w = dot(r9.xzy, float3(0.5,0.25,0.25));
  r4.x = cmp(r9.w < r2.x);
  r10.xyz = t0.Sample(s0_s, r7.xy).yxz;
  r10.xyz = renodx::color::pq::Encode(renodx::color::gamma::DecodeSafe(r10.xyz), 100.f);
  r10.w = dot(r10.xzy, float3(0.5,0.25,0.25));
  r6.x = cmp(r10.w < r2.x);
  r11.xyz = t0.Sample(s0_s, r7.zw).yxz;
  r11.xyz = renodx::color::pq::Encode(renodx::color::gamma::DecodeSafe(r11.xyz), 100.f);
  r11.w = dot(r11.xzy, float3(0.5,0.25,0.25));
  r9.x = cmp(r11.w < r2.x);
  r12.xyz = t0.Sample(s0_s, r8.xy).yxz;
  r12.xyz = renodx::color::pq::Encode(renodx::color::gamma::DecodeSafe(r12.xyz), 100.f);
  r12.w = dot(r12.xzy, float3(0.5,0.25,0.25));
  r10.x = cmp(r12.w < r2.x);
  r13.xyz = t0.Sample(s0_s, r8.zw).yxz;
  r13.xyz = renodx::color::pq::Encode(renodx::color::gamma::DecodeSafe(r13.xyz), 100.f);
  r13.w = dot(r13.xzy, float3(0.5,0.25,0.25));
  r14.x = cmp(r13.w < r2.x);
  r14.yzw = t0.Sample(s0_s, r1.xy).xyz;
  r14.yzw = renodx::color::pq::Encode(renodx::color::gamma::DecodeSafe(r14.yzw), 100.f);
  r15.x = dot(r14.zwy, float3(0.5,0.25,0.25));
  r16.x = cmp(r15.x < r2.x);
  r15.yz = r14.yw;
  r16.y = cmp(r15.x < 1.00100005);
  r16.yzw = r16.yyy ? r15.yzx : float3(1.00100005,1.00100005,1.00100005);
  r16.yzw = r16.xxx ? float3(1.00100005,1.00100005,1.00100005) : r16.yzw;
  r17.x = cmp(r13.w < r16.w);
  r17.xyz = r17.xxx ? r13.yzw : r16.yzw;
  r16.yzw = r14.xxx ? r16.yzw : r17.xyz;
  r17.xyz = cb2[2].zzz * r12.yxz;
  r17.xyz = r11.yxz * cb2[2].www + r17.xyz;
  r17.xyz = r13.yxz * cb2[2].yyy + r17.xyz;
  r17.xyz = r14.yzw * cb2[2].xxx + r17.xyz;
  r11.x = cmp(r12.w < r16.w);
  r18.xyz = r11.xxx ? r12.yzw : r16.yzw;
  r16.yzw = r10.xxx ? r16.yzw : r18.xyz;
  r11.x = cmp(r11.w < r16.w);
  r18.xyz = r11.xxx ? r11.yzw : r16.yzw;
  r16.yzw = r9.xxx ? r16.yzw : r18.xyz;
  r11.x = cmp(r10.w < r16.w);
  r18.xyz = r11.xxx ? r10.yzw : r16.yzw;
  r16.yzw = r6.xxx ? r16.yzw : r18.xyz;
  r11.x = cmp(r9.w < r16.w);
  r18.xyz = r11.xxx ? r9.yzw : r16.yzw;
  r16.yzw = r4.xxx ? r16.yzw : r18.xyz;
  r11.x = cmp(r6.w < r16.w);
  r18.xyz = r11.xxx ? r6.yzw : r16.yzw;
  r16.yzw = r3.xxx ? r16.yzw : r18.xyz;
  r11.x = cmp(r4.w < r16.w);
  r18.xyz = r11.xxx ? r4.yzw : r16.yzw;
  r18.yzw = r1.www ? r16.yzw : r18.xyz;
  r11.x = cmp(r3.w < r18.w);
  r19.yzw = r11.xxx ? r3.yzw : r18.yzw;
  r11.x = cmp(-0.00100000005 < r15.x);
  r16.yzw = r11.xxx ? r15.yzx : float3(-0.00100000005,-0.00100000005,-0.00100000005);
  r16.xyz = r16.xxx ? r16.yzw : float3(-0.00100000005,-0.00100000005,-0.00100000005);
  r11.x = cmp(r16.z < r13.w);
  r13.xyz = r11.xxx ? r13.yzw : r16.xyz;
  r13.xyz = r14.xxx ? r13.xyz : r16.xyz;
  r11.x = r15.x + -r13.w;
  r11.x = 0.200000003 + -abs(r11.x);
  r11.x = ceil(r11.x);
  r12.x = cmp(r13.z < r12.w);
  r12.xyz = r12.xxx ? r12.yzw : r13.xyz;
  r12.xyz = r10.xxx ? r12.xyz : r13.xyz;
  r10.x = r15.x + -r12.w;
  r10.x = 0.200000003 + -abs(r10.x);
  r10.x = ceil(r10.x);
  r12.w = cmp(r12.z < r11.w);
  r13.xyz = r12.www ? r11.yzw : r12.xyz;
  r12.xyz = r9.xxx ? r13.xyz : r12.xyz;
  r9.x = r15.x + -r11.w;
  r9.x = 0.200000003 + -abs(r9.x);
  r9.x = ceil(r9.x);
  r11.y = cmp(r12.z < r10.w);
  r11.yzw = r11.yyy ? r10.yzw : r12.xyz;
  r11.yzw = r6.xxx ? r11.yzw : r12.xyz;
  r6.x = r15.x + -r10.w;
  r6.x = 0.200000003 + -abs(r6.x);
  r6.x = ceil(r6.x);
  r10.y = cmp(r11.w < r9.w);
  r10.yzw = r10.yyy ? r9.yzw : r11.yzw;
  r10.yzw = r4.xxx ? r10.yzw : r11.yzw;
  r4.x = r15.x + -r9.w;
  r4.x = 0.200000003 + -abs(r4.x);
  r4.x = ceil(r4.x);
  r9.y = cmp(r10.w < r6.w);
  r9.yzw = r9.yyy ? r6.yzw : r10.yzw;
  r9.yzw = r3.xxx ? r9.yzw : r10.yzw;
  r3.x = r15.x + -r6.w;
  r3.x = 0.200000003 + -abs(r3.x);
  r3.x = ceil(r3.x);
  r6.y = cmp(r9.w < r4.w);
  r6.yzw = r6.yyy ? r4.yzw : r9.yzw;
  r6.yzw = r1.www ? r6.yzw : r9.yzw;
  r1.w = r15.x + -r4.w;
  r1.w = 0.200000003 + -abs(r1.w);
  r1.w = ceil(r1.w);
  r19.x = r6.z;
  r4.y = cmp(r6.w < r3.w);
  r4.yzw = r4.yyy ? r3.yzw : r6.yzw;
  r12.xw = r0.yy ? r4.yw : r6.yw;
  r18.x = r4.z;
  r13.xyzw = r0.yyyy ? r18.xyzw : r19.xyzw;
  r0.y = r15.x + -r3.w;
  r0.y = 0.200000003 + -abs(r0.y);
  r0.y = ceil(r0.y);
  r0.y = 4 + -r0.y;
  r0.y = r0.y + -r1.w;
  r0.y = r0.y + -r3.x;
  r0.y = r0.y + -r4.x;
  r0.y = r0.y + -r6.x;
  r0.y = r0.y + -r9.x;
  r0.y = r0.y + -r10.x;
  r0.y = saturate(r0.y + -r11.x);
  r1.w = cmp(1 < r13.w);
  r3.x = -r13.y * 0.25 + r13.w;
  r3.x = -r13.z * 0.25 + r3.x;
  r3.y = r3.x + r3.x;
  r12.z = r13.x;
  r3.xzw = r13.yzw;
  r4.x = -r12.x * 0.25 + r12.w;
  r4.x = -r13.x * 0.25 + r4.x;
  r12.y = r4.x + r4.x;
  r4.x = cmp(r12.w < 0);
  r4.xyzw = r4.xxxx ? r3.xyzw : r12.xyzw;
  r6.xyzw = r1.wwww ? r4.xyzw : r3.xyzw;
  r1.w = max(r4.w, r2.x);
  r9.x = min(r1.w, r6.w);
  r9.z = r6.w;
  r9.y = r4.w;
  r10.z = r3.w;
  r10.x = r2.x;
  r10.y = r12.w;
  r1.w = 0.949999988 * r2.y;
  r0.y = saturate(r0.y * 0.25 + r1.w);
  r1.w = cmp(r0.y < 0.902499974);
  r2.xyz = r1.www ? r9.xyz : r10.xyz;
  r2.yz = r2.zx + -r2.yy;
  r3.w = cmp(0.00999999978 < r2.y);
  r2.y = r2.z / r2.y;
  r2.y = r3.w ? r2.y : 0.5;
  r4.xyz = r1.www ? r4.xyz : r12.xyz;
  r3.xyz = r1.www ? r6.xyz : r3.xyz;
  r3.xyz = r3.xyz + -r4.xyz;
  r3.xyz = r2.yyy * r3.xyz + r4.xyz;
  r1.w = min(r0.z, r0.w);
  r0.zw = cmp(r0.zw >= float2(1,1));
  r1.w = cmp(0 >= r1.w);
  r0.z = (int)r0.z | (int)r1.w;
  r0.z = (int)r0.w | (int)r0.z;
  r2.yz = t4.Sample(s4_s, r1.xy).xy;
  r0.w = t5.Sample(s5_s, r1.xy).z;
  r0.w = cmp(0 < r0.w);
  r1.x = cmp(cb2[5].w < r2.z);
  r0.z = (int)r0.z | (int)r1.x;
  r1.xyw = r0.zzz ? r14.yzw : r3.xyz;
  r15.w = 0;
  r2.xw = r0.zz ? r15.xw : r2.xw;
  r3.xyz = r0.zzz ? r14.yzw : r17.xyz;
  r4.xyz = r14.yzw + -r3.xyz;
  r0.z = 128 * cb2[0].x;
  r6.z = saturate(r0.x / r0.z);
  r0.x = r6.z + -r2.w;
  r0.z = r2.x + -r15.x;
  r2.xw = -abs(r0.xx) * float2(20,100) + float2(1,1);
  r2.xw = max(float2(0,0), r2.xw);
  r4.yzw = r2.xxx * r4.xyz + r3.xyz;
  r1.xyw = -r4.yzw + r1.xyw;
  r0.x = cb2[4].x + -cb2[4].y;
  r0.x = r6.z * r0.x + cb2[4].y;
  r0.x = min(r0.x, r2.x);
  r6.y = r2.w * r0.y;
  r0.y = 0.99000001 + -r0.x;
  r0.x = r6.y * r0.y + r0.x;
  o1.yz = r6.yz;
  r1.xyw = saturate(r0.xxx * r1.xyw + r4.yzw);
  r6.xyz = r1.xyw + -r3.xyz;
  r1.xyw = saturate(r6.xyz * cb2[4].zzz + r1.xyw);
  r3.xyz = r3.xyz + -r1.xyw;
  r3.yzw = saturate(cb2[4].www * r3.xyz + r1.xyw);
  r0.y = r0.x * r0.z + r15.x;
  r0.x = r0.x * r0.z;
  r0.x = cmp(abs(r0.x) < 0.00999999978);
  r3.x = r0.x ? r15.x : r0.y;
  r4.x = dot(r4.zwy, float3(0.5,0.25,0.25));
  r0.x = t5.Sample(s5_s, r5.xy).z;
  r0.y = t5.Sample(s5_s, r5.zw).z;
  r0.xy = cmp(float2(0,0) < r0.xy);
  r0.x = r0.x ? r1.z : 0;
  r0.x = r0.y ? r0.x : 0;
  r0.y = t5.Sample(s5_s, r7.xy).z;
  r0.z = t5.Sample(s5_s, r7.zw).z;
  r0.yz = cmp(float2(0,0) < r0.yz);
  r0.x = r0.y ? r0.x : 0;
  r0.x = r0.z ? r0.x : 0;
  r0.y = t5.Sample(s5_s, r8.xy).z;
  r0.z = t5.Sample(s5_s, r8.zw).z;
  r0.yz = cmp(float2(0,0) < r0.yz);
  r0.x = r0.y ? r0.x : 0;
  r0.x = r0.z ? r0.x : 0;
  r0.x = r0.w ? r0.x : 0;
  r0.y = cmp(cb2[5].w >= r2.y);
  r0.z = 1 + -r2.z;
  r0.x = r0.y ? r0.x : 0;
  r1.xyzw = r0.xxxx ? r4.xyzw : r3.xyzw;
  r1.yzw = renodx::color::pq::Decode(r1.yzw, 100.f);
  r1.yzw = renodx::color::bt709::from::BT2020(r1.yzw);
  r1.yzw = renodx::color::gamma::EncodeSafe(r1.yzw);
  o0.xyz = r1.yzw;
  o1.x = saturate(r1.x * r0.z);
  o0.w = 1;
  o1.w = 1;
  return;
}
