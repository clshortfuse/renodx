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
cbuffer cb5 : register(b5){
  float4 cb5[14];
}
cbuffer cb4 : register(b4){
  float4 cb4[1];
}
cbuffer cb3 : register(b3){
  float4 cb3[7];
}
cbuffer cb2 : register(b2){
  float4 cb2[8];
}
cbuffer cb1 : register(b1){
  float4 cb1[47];
}
cbuffer cb0 : register(b0){
  float4 cb0[11];
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
  nointerpolation uint v8 : SV_InstanceID0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s4_s, v1.xy).xyzw;
  r1.xyzw = t0.Sample(s2_s, v1.xy).xyzw;
  r2.xyz = cb0[4].xyz * r1.xyz;
  r1.xyz = cb0[4].xyz * r1.xyz + float3(-0.0399999991,-0.0399999991,-0.0399999991);
  r1.xyz = r0.xxx * r1.xyz + float3(0.0399999991,0.0399999991,0.0399999991);
  r0.x = -r0.x * 0.959999979 + 0.959999979;
  r2.xyz = r2.xyz * r0.xxx;
  r3.xyzw = t2.Sample(s3_s, v1.xy).xyzw;
  r3.x = r3.x * r3.w;
  r0.yz = r3.xy * float2(2,2) + float2(-1,-1);
  r0.yz = cb0[8].xx * r0.yz;
  r1.w = dot(r0.yz, r0.yz);
  r1.w = min(1, r1.w);
  r1.w = 1 + -r1.w;
  r1.w = sqrt(r1.w);
  r3.xyz = v4.xyz * r0.zzz;
  r3.xyz = v3.xyz * r0.yyy + r3.xyz;
  r3.xyz = v5.xyz * r1.www + r3.xyz;
  r0.y = dot(r3.xyz, r3.xyz);
  r0.y = rsqrt(r0.y);
  r3.xyz = r3.xyz * r0.yyy;
  r0.y = dot(v2.xyz, v2.xyz);
  r0.y = rsqrt(r0.y);
  r4.xyz = v2.xyz * r0.yyy;
  r0.z = (int)v8.x + asint(cb4[0].x);
  r0.z = (int)r0.z * 7;
  r1.w = cmp(cb3[0].x == 1.000000);
  if (r1.w != 0) {
    r2.w = cmp(cb3[0].y == 1.000000);
    r5.xyz = cb3[2].xyz * v4.www;
    r5.xyz = cb3[1].xyz * v3.www + r5.xyz;
    r5.xyz = cb3[3].xyz * v5.www + r5.xyz;
    r5.xyz = cb3[4].xyz + r5.xyz;
    r6.y = v3.w;
    r6.z = v4.w;
    r6.w = v5.w;
    r5.xyz = r2.www ? r5.xyz : r6.yzw;
    r5.xyz = -cb3[6].xyz + r5.xyz;
    r5.yzw = cb3[5].xyz * r5.xyz;
    r2.w = r5.y * 0.25 + 0.75;
    r4.w = cb3[0].z * 0.5 + 0.75;
    r5.x = max(r4.w, r2.w);
    r5.xyzw = t7.Sample(s1_s, r5.xzw).xyzw;
  } else {
    r5.xyzw = cb5[r0.z+6].wwww;
  }
  r2.w = saturate(dot(r5.xyzw, cb1[46].xyzw));
  r5.xyzw = t3.Sample(s5_s, v1.xy).xyzw;
  r4.w = 1 + -cb0[9].y;
  r4.w = r5.y * cb0[9].y + r4.w;
  r5.x = -r0.w * cb0[9].x + 1;
  r5.y = dot(r4.xyz, r3.xyz);
  r5.y = r5.y + r5.y;
  r5.yzw = r3.xyz * -r5.yyy + r4.xyz;
  r6.xyz = cb0[2].xyz * r2.www;
  if (r1.w != 0) {
    r1.w = cmp(cb3[0].y == 1.000000);
    r7.xyz = cb3[2].xyz * v4.www;
    r7.xyz = cb3[1].xyz * v3.www + r7.xyz;
    r7.xyz = cb3[3].xyz * v5.www + r7.xyz;
    r7.xyz = cb3[4].xyz + r7.xyz;
    r8.y = v3.w;
    r8.z = v4.w;
    r8.w = v5.w;
    r7.xyz = r1.www ? r7.xyz : r8.yzw;
    r7.xyz = -cb3[6].xyz + r7.xyz;
    r7.yzw = cb3[5].xyz * r7.xyz;
    r1.w = 0.25 * r7.y;
    r2.w = 0.5 * cb3[0].z;
    r6.w = -cb3[0].z * 0.5 + 0.25;
    r1.w = max(r2.w, r1.w);
    r7.x = min(r1.w, r6.w);
    r8.xyzw = t7.Sample(s1_s, r7.xzw).xyzw;
    r9.xyz = float3(0.25,0,0) + r7.xzw;
    r9.xyzw = t7.Sample(s1_s, r9.xyz).xyzw;
    r7.xyz = float3(0.5,0,0) + r7.xzw;
    r7.xyzw = t7.Sample(s1_s, r7.xyz).xyzw;
    r3.w = 1;
    r8.x = dot(r8.xyzw, r3.xyzw);
    r8.y = dot(r9.xyzw, r3.xyzw);
    r8.z = dot(r7.xyzw, r3.xyzw);
  } else {
    r3.w = 1;
    r8.x = dot(cb5[r0.z+0].xyzw, r3.xyzw);
    r8.y = dot(cb5[r0.z+1].xyzw, r3.xyzw);
    r8.z = dot(cb5[r0.z+2].xyzw, r3.xyzw);
  }
  r7.xyz = v6.xyz + r8.xyz;
  r7.xyz = max(float3(0,0,0), r7.xyz);
  r0.z = cmp(0 < cb2[2].w);
  if (r0.z != 0) {
    r0.z = dot(r5.yzw, r5.yzw);
    r0.z = rsqrt(r0.z);
    r8.xyz = r5.yzw * r0.zzz;
    r9.x = v3.w;
    r9.y = v4.w;
    r9.z = v5.w;
    r10.xyz = cb2[0].xyz + -r9.xyz;
    r10.xyz = r10.xyz / r8.xyz;
    r11.xyz = cb2[1].xyz + -r9.xyz;
    r11.xyz = r11.xyz / r8.xyz;
    r12.xyz = cmp(float3(0,0,0) < r8.xyz);
    r10.xyz = r12.xyz ? r10.xyz : r11.xyz;
    r0.z = min(r10.x, r10.y);
    r0.z = min(r0.z, r10.z);
    r9.xyz = -cb2[2].xyz + r9.xyz;
    r8.xyz = r8.xyz * r0.zzz + r9.xyz;
  } else {
    r8.xyz = r5.yzw;
  }
  r0.z = -r5.x * 0.699999988 + 1.70000005;
  r0.z = r5.x * r0.z;
  r0.z = 6 * r0.z;
  r8.xyzw = t5.SampleLevel(s0_s, r8.xyz, r0.z).xyzw;
  r1.w = -1 + r8.w;
  r1.w = cb2[3].w * r1.w + 1;
  r1.w = log2(r1.w);
  r1.w = cb2[3].y * r1.w;
  r1.w = exp2(r1.w);
  r1.w = cb2[3].x * r1.w;
  r9.xyz = r1.www * r8.xyz;
  r2.w = cmp(cb2[1].w < 0.999989986);
  if (r2.w != 0) {
    r2.w = cmp(0 < cb2[6].w);
    if (r2.w != 0) {
      r2.w = dot(r5.yzw, r5.yzw);
      r2.w = rsqrt(r2.w);
      r10.xyz = r5.yzw * r2.www;
      r11.x = v3.w;
      r11.y = v4.w;
      r11.z = v5.w;
      r12.xyz = cb2[4].xyz + -r11.xyz;
      r12.xyz = r12.xyz / r10.xyz;
      r13.xyz = cb2[5].xyz + -r11.xyz;
      r13.xyz = r13.xyz / r10.xyz;
      r14.xyz = cmp(float3(0,0,0) < r10.xyz);
      r12.xyz = r14.xyz ? r12.xyz : r13.xyz;
      r2.w = min(r12.x, r12.y);
      r2.w = min(r2.w, r12.z);
      r11.xyz = -cb2[6].xyz + r11.xyz;
      r5.yzw = r10.xyz * r2.www + r11.xyz;
    }
    r10.xyzw = t6.SampleLevel(s0_s, r5.yzw, r0.z).xyzw;
    r0.z = -1 + r10.w;
    r0.z = cb2[7].w * r0.z + 1;
    r0.z = log2(r0.z);
    r0.z = cb2[7].y * r0.z;
    r0.z = exp2(r0.z);
    r0.z = cb2[7].x * r0.z;
    r5.yzw = r0.zzz * r10.xyz;
    r8.xyz = r1.www * r8.xyz + -r5.yzw;
    r9.xyz = cb2[1].www * r8.xyz + r5.yzw;
  }
  r5.yzw = r9.xyz * r4.www;
  r8.xyz = -v2.xyz * r0.yyy + cb1[0].xyz;
  r0.y = dot(r8.xyz, r8.xyz);
  r0.y = max(0.00100000005, r0.y);
  r0.y = rsqrt(r0.y);
  r8.xyz = r8.xyz * r0.yyy;
  r0.y = dot(r3.xyz, -r4.xyz);
  r0.z = saturate(dot(r3.xyz, cb1[0].xyz));
  r1.w = saturate(dot(r3.xyz, r8.xyz));
  r2.w = saturate(dot(cb1[0].xyz, r8.xyz));
  r3.x = r2.w * r2.w;
  r3.x = dot(r3.xx, r5.xx);
  r3.x = -0.5 + r3.x;
  r3.y = 1 + -r0.z;
  r3.z = r3.y * r3.y;
  r3.z = r3.z * r3.z;
  r3.y = r3.z * r3.y;
  r3.y = r3.x * r3.y + 1;
  r3.z = 1 + -abs(r0.y);
  r3.w = r3.z * r3.z;
  r3.w = r3.w * r3.w;
  r3.z = r3.w * r3.z;
  r3.x = r3.x * r3.z + 1;
  r3.x = r3.y * r3.x;
  r3.x = r3.x * r0.z;
  r3.y = r5.x * r5.x;
  r3.y = max(0.00200000009, r3.y);
  r3.w = 1 + -r3.y;
  r4.x = abs(r0.y) * r3.w + r3.y;
  r3.w = r0.z * r3.w + r3.y;
  r0.y = r3.w * abs(r0.y);
  r0.y = r0.z * r4.x + r0.y;
  r0.y = 9.99999975e-06 + r0.y;
  r0.y = 0.5 / r0.y;
  r3.w = r3.y * r3.y;
  r4.x = r1.w * r3.w + -r1.w;
  r1.w = r4.x * r1.w + 1;
  r3.w = 0.318309873 * r3.w;
  r1.w = r1.w * r1.w + 1.00000001e-07;
  r1.w = r3.w / r1.w;
  r0.y = r1.w * r0.y;
  r0.y = 3.14159274 * r0.y;
  r0.y = r0.y * r0.z;
  r0.y = max(0, r0.y);
  r0.z = r3.y * r3.y + 1;
  r0.z = 1 / r0.z;
  r1.w = dot(r1.xyz, r1.xyz);
  r1.w = cmp(r1.w != 0.000000);
  r1.w = r1.w ? 1.000000 : 0;
  r0.y = r1.w * r0.y;
  r0.x = r0.w * cb0[9].x + -r0.x;
  r0.x = saturate(1 + r0.x);
  r3.xyw = r6.xyz * r3.xxx;
  r3.xyw = r7.xyz * r4.www + r3.xyw;
  r4.xyz = r0.yyy * r6.xyz;
  r0.y = 1 + -r2.w;
  r0.w = r0.y * r0.y;
  r0.w = r0.w * r0.w;
  r0.y = r0.w * r0.y;
  r6.xyz = float3(1,1,1) + -r1.xyz;
  r6.xyz = r6.xyz * r0.yyy + r1.xyz;
  r4.xyz = r6.xyz * r4.xyz;
  r2.xyz = r2.xyz * r3.xyw + r4.xyz;
  r0.yzw = r0.zzz * r5.yzw;
  r3.xyw = r0.xxx + -r1.xyz;
  r1.xyz = r3.zzz * r3.xyw + r1.xyz;
  r0.xyz = r0.yzw * r1.xyz + r2.xyz;
  r1.xyzw = t4.Sample(s6_s, v1.xy).xyzw;
  o0.xyz = r1.xyz * cb0[10].xyz + r0.xyz;
  o0.w = 1;
  if (injectedData.countOld == injectedData.countNew) {
    if(injectedData.rolloffUI == 1.f){
      o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
      o0.xyz = rolloff(o0.xyz, 0.85f, true);
      o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
    } else if(injectedData.rolloffUI == 2.f){
      o0.xyz = saturate(o0.xyz);
    }
  }
  return;
}