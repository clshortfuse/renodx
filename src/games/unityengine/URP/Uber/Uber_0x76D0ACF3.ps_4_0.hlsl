#include "../../common.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[158];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.x = dot(r0.zw, r0.zw);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = cb0[140].xxxx * r0.xyzw * injectedData.fxCA;
  r1.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  r0.xyzw = r0.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r2.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[5].x).xyzw;
  r0.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[5].x).xyzw;
  r3.xyzw = cb0[147].xyxy * float4(-0.5,-0.5,0.5,-0.5) + v1.xyxy;
  r4.xyzw = t4.SampleBias(s0_s, r3.xy, cb0[5].x).xyzw;
  r3.xyzw = t4.SampleBias(s0_s, r3.zw, cb0[5].x).xyzw;
  r1.yzw = r4.xyz + r3.xyz;
  r3.xyzw = cb0[147].xyxy * float4(-0.5,0.5,0.5,0.5) + v1.xyxy;
  r4.xyzw = t4.SampleBias(s0_s, r3.xy, cb0[5].x).xyzw;
  r1.yzw = r4.xyz + r1.yzw;
  r3.xyzw = t4.SampleBias(s0_s, r3.zw, cb0[5].x).xyzw;
  r1.yzw = r3.xyz + r1.yzw;
  r0.x = r1.x;
  r0.y = r2.y;
  r1.xyz = r1.yzw * float3(0.25,0.25,0.25) + -r0.xyz;
  r0.xyz = cb0[157].xxx * r1.xyz + r0.xyz;
  r1.xyzw = t1.SampleBias(s0_s, v1.xy, cb0[5].x).xyzw;
  if (cb0[135].x > 0) {
    r2.xyz = r1.xyz * r1.www;
    r1.xyz = float3(8,8,8) * r2.xyz;
  }
  r1.xyz = cb0[134].xxx * r1.xyz * injectedData.fxBloom;
  r0.xyz = r1.xyz * cb0[134].yzw + r0.xyz;
  r1.xy = sqrt(v1.xy);
  r1.xy = float2(-0.5,-0.5) + r1.xy;
  r0.w = dot(r1.xy, cb0[150].xy);
  r0.w = 0.5 + r0.w;
  r1.xy = float2(1,1) + -v1.xy;
  r1.xy = sqrt(r1.xy);
  r1.xy = float2(-0.5,-0.5) + r1.xy;
  r1.x = dot(r1.xy, cb0[150].xy);
  r1.x = 0.5 + r1.x;
  r0.w = -cb0[150].z + r0.w;
  r0.w = cb0[150].w + -r0.w;
  r1.y = 0.01 + cb0[150].w;
  r0.w = saturate(r0.w / r1.y);
  r1.yzw = r0.xyz * cb0[152].xyz + -r0.xyz;
  r0.xyz = r0.www * r1.yzw + r0.xyz;
  r0.w = -cb0[151].x + r1.x;
  r0.w = cb0[151].y + -r0.w;
  r1.x = 0.01 + cb0[151].y;
  r0.w = saturate(r0.w / r1.x) * injectedData.fxLens;
  r0.xyz = r0.www * cb0[153].xyz + r0.xyz;
  if (cb0[142].z > 0) {
    r1.xy = -cb0[142].xy + v1.xy;
    r1.yz = cb0[142].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[141].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[142].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[141].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[141].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[132].www * r0.xyz;
  if (cb0[133].w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t3, s0_s, cb0[133].xyz);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[133].www * r2.xyz + r1.xyz;
    r0.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  r0.xyz = lutShaper(r0.xyz, false, 1);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.xyw = cb0[132].zzz * r0.xyz;
  r0.w = floor(r0.w);
  r1.xy = float2(0.5,0.5) * cb0[132].xy;
  r1.yz = r0.xy * cb0[132].xy + r1.xy;
  r1.x = r0.w * cb0[132].y + r1.y;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r0.x = cb0[132].y;
  r0.y = 0;
  r0.xy = r1.xz + r0.xy;
  r1.xyzw = t2.SampleLevel(s0_s, r0.xy, 0).xyzw;
  r0.x = r0.z * cb0[132].z + -r0.w;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r0.xyz, cb0[132].z + 1u);
  }
  if(injectedData.countOld == injectedData.countNew){
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}