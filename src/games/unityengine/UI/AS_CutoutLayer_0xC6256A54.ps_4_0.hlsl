#include "../common.hlsl"

Texture3D<float4> t7 : register(t7);
TextureCube<float4> t6 : register(t6);
TextureCube<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s6_s : register(s6);
SamplerState s5_s : register(s5);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb4 : register(b4){
  float4 cb4[7];
}
cbuffer cb3 : register(b3){
  float4 cb3[8];
}
cbuffer cb2 : register(b2){
  float4 cb2[47];
}
cbuffer cb1 : register(b1){
  float4 cb1[5];
}
cbuffer cb0 : register(b0){
  float4 cb0[10];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD2,
  float4 v4 : TEXCOORD3,
  float4 v5 : TEXCOORD4,
  float4 v6 : TEXCOORD5,
  float4 v7 : TEXCOORD7,
  float4 v8 : TEXCOORD8,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = v3.w;
  r0.y = v4.w;
  r0.z = v5.w;
  r1.xyz = cb1[4].xyz + -r0.xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = rsqrt(r0.w);
  r2.xyz = r1.xyz * r0.www;
  r3.xyzw = t0.Sample(s6_s, v1.xy).xyzw;
  r3.xyzw = cb0[7].xyzw * r3.xyzw;
  r1.w = cmp(r3.w < cb0[9].x);
  if (r1.w != 0) {
    r4.xyzw = t1.Sample(s3_s, v1.zw).xyzw;
    r4.xy = cb0[4].xy * r4.xw;
    r5.xyzw = t2.Sample(s4_s, v2.xy).xyzw;
    r5.x = r5.x * r5.w;
    r4.zw = r5.xy * float2(2,2) + float2(-1,-1);
    r5.xy = cb0[6].xx * r4.zw;
    r1.w = dot(r5.xy, r5.xy);
    r1.w = min(1, r1.w);
    r1.w = 1 + -r1.w;
    r5.z = sqrt(r1.w);
    r6.xyzw = t3.Sample(s2_s, v1.xy).xyzw;
    r3.xyz = cb0[5].xyz * r6.xyz;
    r6.xyz = float3(0,0,0);
  } else {
    r7.xyzw = t4.Sample(s5_s, v2.zw).xyzw;
    r7.x = r7.x * r7.w;
    r4.zw = r7.xy * float2(2,2) + float2(-1,-1);
    r5.xy = cb0[8].ww * r4.zw;
    r1.w = dot(r5.xy, r5.xy);
    r1.w = min(1, r1.w);
    r1.w = 1 + -r1.w;
    r5.z = sqrt(r1.w);
    r6.xyz = cb0[8].xxx * r3.xyz;
    r4.xy = cb0[8].yz;
  }
  r1.w = cmp(cb4[0].x == 1.000000);
  if (r1.w != 0) {
    r2.w = cmp(cb4[0].y == 1.000000);
    r7.xyz = cb4[2].xyz * v4.www;
    r7.xyz = cb4[1].xyz * v3.www + r7.xyz;
    r7.xyz = cb4[3].xyz * v5.www + r7.xyz;
    r7.xyz = cb4[4].xyz + r7.xyz;
    r7.xyz = r2.www ? r7.xyz : r0.xyz;
    r7.xyz = -cb4[6].xyz + r7.xyz;
    r7.yzw = cb4[5].xyz * r7.xyz;
    r2.w = r7.y * 0.25 + 0.75;
    r3.w = cb4[0].z * 0.5 + 0.75;
    r7.x = max(r3.w, r2.w);
    r7.xyzw = t7.Sample(s1_s, r7.xzw).xyzw;
  } else {
    r7.xyzw = float4(1,1,1,1);
  }
  r2.w = saturate(dot(r7.xyzw, cb2[46].xyzw));
  r7.x = dot(v3.xyz, r5.xyz);
  r7.y = dot(v4.xyz, r5.xyz);
  r7.z = dot(v5.xyz, r5.xyz);
  r3.w = dot(r7.xyz, r7.xyz);
  r3.w = rsqrt(r3.w);
  r5.xyz = r7.xyz * r3.www;
  r3.w = 1 + -r4.y;
  r4.z = dot(-r2.xyz, r5.xyz);
  r4.z = r4.z + r4.z;
  r7.xyz = r5.xyz * -r4.zzz + -r2.xyz;
  r8.xyz = cb0[2].xyz * r2.www;
  if (r1.w != 0) {
    r1.w = cmp(cb4[0].y == 1.000000);
    r9.xyz = cb4[2].xyz * v4.www;
    r9.xyz = cb4[1].xyz * v3.www + r9.xyz;
    r9.xyz = cb4[3].xyz * v5.www + r9.xyz;
    r9.xyz = cb4[4].xyz + r9.xyz;
    r9.xyz = r1.www ? r9.xyz : r0.xyz;
    r9.xyz = -cb4[6].xyz + r9.xyz;
    r9.yzw = cb4[5].xyz * r9.xyz;
    r1.w = 0.25 * r9.y;
    r2.w = 0.5 * cb4[0].z;
    r4.z = -cb4[0].z * 0.5 + 0.25;
    r1.w = max(r2.w, r1.w);
    r9.x = min(r1.w, r4.z);
    r10.xyzw = t7.Sample(s1_s, r9.xzw).xyzw;
    r11.xyz = float3(0.25,0,0) + r9.xzw;
    r11.xyzw = t7.Sample(s1_s, r11.xyz).xyzw;
    r9.xyz = float3(0.5,0,0) + r9.xzw;
    r9.xyzw = t7.Sample(s1_s, r9.xyz).xyzw;
    r5.w = 1;
    r10.x = dot(r10.xyzw, r5.xyzw);
    r10.y = dot(r11.xyzw, r5.xyzw);
    r10.z = dot(r9.xyzw, r5.xyzw);
  } else {
    r5.w = 1;
    r10.x = dot(cb2[39].xyzw, r5.xyzw);
    r10.y = dot(cb2[40].xyzw, r5.xyzw);
    r10.z = dot(cb2[41].xyzw, r5.xyzw);
  }
  r9.xyz = v6.xyz + r10.xyz;
  r9.xyz = max(float3(0,0,0), r9.xyz);
  r1.w = cmp(0 < cb3[2].w);
  if (r1.w != 0) {
    r1.w = dot(r7.xyz, r7.xyz);
    r1.w = rsqrt(r1.w);
    r10.xyz = r7.xyz * r1.www;
    r11.xyz = cb3[0].xyz + -r0.xyz;
    r11.xyz = r11.xyz / r10.xyz;
    r12.xyz = cb3[1].xyz + -r0.xyz;
    r12.xyz = r12.xyz / r10.xyz;
    r13.xyz = cmp(float3(0,0,0) < r10.xyz);
    r11.xyz = r13.xyz ? r11.xyz : r12.xyz;
    r1.w = min(r11.x, r11.y);
    r1.w = min(r1.w, r11.z);
    r11.xyz = -cb3[2].xyz + r0.xyz;
    r10.xyz = r10.xyz * r1.www + r11.xyz;
  } else {
    r10.xyz = r7.xyz;
  }
  r1.w = -r3.w * 0.699999988 + 1.70000005;
  r1.w = r3.w * r1.w;
  r1.w = 6 * r1.w;
  r10.xyzw = t5.SampleLevel(s0_s, r10.xyz, r1.w).xyzw;
  r2.w = -1 + r10.w;
  r2.w = cb3[3].w * r2.w + 1;
  r2.w = log2(r2.w);
  r2.w = cb3[3].y * r2.w;
  r2.w = exp2(r2.w);
  r2.w = cb3[3].x * r2.w;
  r11.xyz = r2.www * r10.xyz;
  r4.z = cmp(cb3[1].w < 0.999989986);
  if (r4.z != 0) {
    r4.z = cmp(0 < cb3[6].w);
    if (r4.z != 0) {
      r4.z = dot(r7.xyz, r7.xyz);
      r4.z = rsqrt(r4.z);
      r12.xyz = r7.xyz * r4.zzz;
      r13.xyz = cb3[4].xyz + -r0.xyz;
      r13.xyz = r13.xyz / r12.xyz;
      r14.xyz = cb3[5].xyz + -r0.xyz;
      r14.xyz = r14.xyz / r12.xyz;
      r15.xyz = cmp(float3(0,0,0) < r12.xyz);
      r13.xyz = r15.xyz ? r13.xyz : r14.xyz;
      r4.z = min(r13.x, r13.y);
      r4.z = min(r4.z, r13.z);
      r0.xyz = -cb3[6].xyz + r0.xyz;
      r7.xyz = r12.xyz * r4.zzz + r0.xyz;
    }
    r7.xyzw = t6.SampleLevel(s0_s, r7.xyz, r1.w).xyzw;
    r0.x = -1 + r7.w;
    r0.x = cb3[7].w * r0.x + 1;
    r0.x = log2(r0.x);
    r0.x = cb3[7].y * r0.x;
    r0.x = exp2(r0.x);
    r0.x = cb3[7].x * r0.x;
    r0.xyz = r0.xxx * r7.xyz;
    r7.xyz = r2.www * r10.xyz + -r0.xyz;
    r11.xyz = cb3[1].www * r7.xyz + r0.xyz;
  }
  r0.xyz = float3(-0.0399999991,-0.0399999991,-0.0399999991) + r3.xyz;
  r0.xyz = r4.xxx * r0.xyz + float3(0.0399999991,0.0399999991,0.0399999991);
  r1.w = -r4.x * 0.959999979 + 0.959999979;
  r3.xyz = r3.xyz * r1.www;
  r1.xyz = r1.xyz * r0.www + cb2[0].xyz;
  r0.w = dot(r1.xyz, r1.xyz);
  r0.w = max(0.00100000005, r0.w);
  r0.w = rsqrt(r0.w);
  r1.xyz = r1.xyz * r0.www;
  r0.w = dot(r5.xyz, r2.xyz);
  r2.x = saturate(dot(r5.xyz, cb2[0].xyz));
  r2.y = saturate(dot(r5.xyz, r1.xyz));
  r1.x = saturate(dot(cb2[0].xyz, r1.xyz));
  r1.y = r1.x * r1.x;
  r1.y = dot(r1.yy, r3.ww);
  r1.y = -0.5 + r1.y;
  r1.z = 1 + -r2.x;
  r2.z = r1.z * r1.z;
  r2.z = r2.z * r2.z;
  r1.z = r2.z * r1.z;
  r1.z = r1.y * r1.z + 1;
  r2.z = 1 + -abs(r0.w);
  r2.w = r2.z * r2.z;
  r2.w = r2.w * r2.w;
  r2.z = r2.w * r2.z;
  r1.y = r1.y * r2.z + 1;
  r1.y = r1.z * r1.y;
  r1.y = r1.y * r2.x;
  r1.z = r3.w * r3.w;
  r1.z = max(0.00200000009, r1.z);
  r2.w = 1 + -r1.z;
  r3.w = abs(r0.w) * r2.w + r1.z;
  r2.w = r2.x * r2.w + r1.z;
  r0.w = r2.w * abs(r0.w);
  r0.w = r2.x * r3.w + r0.w;
  r0.w = 9.99999975e-06 + r0.w;
  r0.w = 0.5 / r0.w;
  r2.w = r1.z * r1.z;
  r3.w = r2.y * r2.w + -r2.y;
  r2.y = r3.w * r2.y + 1;
  r2.w = 0.318309873 * r2.w;
  r2.y = r2.y * r2.y + 1.00000001e-07;
  r2.y = r2.w / r2.y;
  r0.w = r2.y * r0.w;
  r0.w = 3.14159274 * r0.w;
  r0.w = r0.w * r2.x;
  r0.w = max(0, r0.w);
  r1.z = r1.z * r1.z + 1;
  r1.z = 1 / r1.z;
  r2.x = dot(r0.xyz, r0.xyz);
  r2.x = cmp(r2.x != 0.000000);
  r2.x = r2.x ? 1.000000 : 0;
  r0.w = r2.x * r0.w;
  r1.w = r4.y + -r1.w;
  r1.w = saturate(1 + r1.w);
  r2.xyw = r8.xyz * r1.yyy + r9.xyz;
  r4.xyz = r0.www * r8.xyz;
  r0.w = 1 + -r1.x;
  r1.x = r0.w * r0.w;
  r1.x = r1.x * r1.x;
  r0.w = r1.x * r0.w;
  r5.xyz = float3(1,1,1) + -r0.xyz;
  r5.xyz = r5.xyz * r0.www + r0.xyz;
  r4.xyz = r5.xyz * r4.xyz;
  r2.xyw = r3.xyz * r2.xyw + r4.xyz;
  r1.xyz = r1.zzz * r11.xyz;
  r3.xyz = r1.www + -r0.xyz;
  r0.xyz = r2.zzz * r3.xyz + r0.xyz;
  r0.xyz = r1.xyz * r0.xyz + r2.xyw;
  o0.xyz = r0.xyz + r6.xyz;
  o0.w = 1;
  if(injectedData.rolloffUI == 1.f){
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = rolloff(o0.xyz, 0.85f, true);
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
  } else if(injectedData.rolloffUI == 2.f){
    o0.xyz = saturate(o0.xyz);
  }
  return;
}