#include "../../tonemap.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[149];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = -cb0[131].xyxy * float4(0.5,0.5,0.5,0.5) + cb0[28].xyxy;
  r1.xy = min(v1.xy, r0.zw);
  r1.xyzw = t0.SampleBias(s0_s, r1.xy, cb0[4].x).xyzw;
  r2.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.y = dot(r2.zw, r2.zw);
  r2.xyzw = r2.xyzw * r1.yyyy;
  r2.xyzw = cb0[146].xxxx * r2.xyzw * injectedData.fxCA;
  r2.xyzw = r2.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r0.xyzw = min(r2.xyzw, r0.xyzw);
  r2.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r0.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[4].x).xyzw;
  r1.yz = -cb0[137].xy * float2(0.5,0.5) + cb0[28].xy;
  r1.yz = min(v1.xy, r1.yz);
  r3.xyzw = t1.SampleBias(s0_s, r1.yz, cb0[4].x).xyzw;
  r2.xzw = cb0[140].xxx * r3.xyz * injectedData.fxBloom;
  r0.x = r1.x;
  r0.y = r2.y;
  r0.xyz = r2.xzw * cb0[140].yzw + r0.xyz;
  if (cb0[148].z > 0) {
    r1.xy = -cb0[148].xy + v1.xy;
    r1.yz = cb0[148].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[147].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[148].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[147].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[147].xyz;
    r1.xyz = r1.xyz * r0.xyz;
  } else {
    r1.xyz = r0.xyz;
  }
  r2.xyz = cb0[138].www * r1.xyz;
  float3 untonemapped = r2.xyz;
  r0.w = cb0[135].x + -cb0[135].z;
  r2.w = cb0[135].w * r0.w;
  r2.w = r2.w / cb0[135].y;
  r3.xyz = r2.xyz + -cb0[135].zzz;
  r3.xyz = cb0[135].yyy * r3.xyz + cb0[135].zzz;
  r4.xyz = r2.xyz / cb0[135].zzz;
  r5.xyz = log2(r4.xyz);
  r5.xyz = cb0[136].xxx * r5.xyz;
  r5.xyz = exp2(r5.xyz);
  r5.xyz = cb0[135].zzz * r5.xyz + cb0[136].yyy;
  r2.w = cb0[135].z + r2.w;
  r0.w = r0.w * cb0[135].w + cb0[135].z;
  r3.w = cb0[135].y * cb0[135].x;
  r0.w = cb0[135].x + -r0.w;
  r3.w = r3.w / r0.w;
  r1.xyz = r2.xyz + -r2.www;
  r6.xyz = r3.www * r1.xyz;
  r6.xyz = r6.xyz / cb0[135].xxx;
  r6.xyz = float3(-1.44269502,-1.44269502,-1.44269502) * r6.xyz;
  r6.xyz = exp2(r6.xyz);
  r6.xyz = -r0.www * r6.xyz + cb0[135].xxx;
  r7.xyz = cmp(float3(0,0,0) < r2.xyz);
  r8.xyz = cmp(r2.xyz >= cb0[135].zzz);
  r9.xyz = r4.xyz * r4.xyz;
  r4.xyz = -r4.xyz * float3(2,2,2) + float3(3,3,3);
  r4.xyz = r9.xyz * r4.xyz;
  r4.xyz = r8.xyz ? float3(1,1,1) : r4.xyz;
  r4.xyz = r7.xyz ? r4.xyz : 0;
  r4.xyz = float3(1,1,1) + -r4.xyz;
  r7.xyz = cmp(r2.www < r2.xyz);
  r2.xyz = cmp(r2.xyz >= r2.www);
  r1.xyz = float3(1,1,1) * r1.xyz;
  r1.xyz = r2.xyz ? float3(1,1,1) : r1.xyz;
  r1.xyz = r7.xyz ? r1.xyz : 0;
  r2.xyz = float3(1,1,1) + -r4.xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r2.xyz = r3.xyz * r2.xyz;
  r2.xyz = r5.xyz * r4.xyz + r2.xyz;
  r1.xyz = r6.xyz * r1.xyz + r2.xyz;
  if (injectedData.toneMapType == 0.f) {
    r1.xyz = saturate(r1.xyz);
  } else if (injectedData.toneMapType == 1.f) {
    r1.xyz = untonemapped;
  }
  if (cb0[139].w > 0) {
    r2.xyz = fastSrgbEncodeSafe(r1.xyz);
    r3.xyz = handleUserLUT(r1.xyz, t3, s0_s, cb0[139].xyz, 1);
    r3.xyz = r3.xyz + -r2.xyz;
    r2.xyz = cb0[139].www * r3.xyz + r2.xyz;
    r1.xyz = fastSrgbDecodeSafe(r2.xyz);
  }
  r1.xyz = lutShaper(r1.xyz, false, 1);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.w = cb0[138].z * r1.z;
  r0.w = floor(r0.w);
  r1.xy = cb0[138].zz * r1.xy;
  r2.xy = float2(0.5,0.5) * cb0[138].xy;
  r2.yz = r1.xy * cb0[138].xy + r2.xy;
  r2.x = r0.w * cb0[138].y + r2.y;
  r3.xyzw = t2.SampleLevel(s0_s, r2.xz, 0).xyzw;
  r1.x = cb0[138].y;
  r1.y = 0;
  r1.xy = r2.xz + r1.xy;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xy, 0).xyzw;
  r0.w = r1.z * cb0[138].z + -r0.w;
  r1.xyz = r2.xyz + -r3.xyz;
  r1.xyz = r0.www * r1.xyz + r3.xyz;
  r1.w = saturate(r1.w);
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r1.www * r1.xyz + r0.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r1.xyz, cb0[138].z + 1u);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = r1.w;
  return;
}