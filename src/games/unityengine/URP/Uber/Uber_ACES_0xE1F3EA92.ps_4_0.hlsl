#include "../../tonemap.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[151];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.x = dot(r0.zw, r0.zw);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = cb0[144].xxxx * r0.xyzw * injectedData.fxCA;
  r1.xyzw = -cb0[131].xyxy * float4(0.5,0.5,0.5,0.5) + cb0[28].xyxy;
  r2.xy = min(v1.xy, r1.zw);
  r2.xyzw = t0.SampleBias(s0_s, r2.xy, cb0[4].x).xyzw;
  r0.xyzw = r0.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r0.xyzw = min(r0.xyzw, r1.xyzw);
  r1.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r0.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[4].x).xyzw;
  r1.xz = -cb0[135].xy * float2(0.5,0.5) + cb0[28].xy;
  r1.xz = min(v1.xy, r1.xz);
  r1.xz = r1.xz * cb0[149].zw + float2(0.5,0.5);
  r2.yz = floor(r1.xz);
  r1.xz = frac(r1.xz);
  r3.xyzw = -r1.xzxz * float4(0.5,0.5,0.166666672,0.166666672) + float4(0.5,0.5,0.5,0.5);
  r3.xyzw = r1.xzxz * r3.xyzw + float4(0.5,0.5,-0.5,-0.5);
  r4.xy = r1.xz * float2(0.5,0.5) + float2(-1,-1);
  r4.zw = r1.xz * r1.xz;
  r4.xy = r4.zw * r4.xy + float2(0.666666687,0.666666687);
  r3.xyzw = r1.xzxz * r3.xyzw + float4(0.166666672,0.166666672,0.166666672,0.166666672);
  r1.xz = float2(1,1) + -r4.xy;
  r1.xz = r1.xz + -r3.xy;
  r1.xz = r1.xz + -r3.zw;
  r3.zw = r3.zw + r4.xy;
  r3.xy = r3.xy + r1.xz;
  r4.zw = float2(1,1) / r3.zw;
  r4.zw = r4.xy * r4.zw + float2(-1,-1);
  r5.xy = float2(1,1) / r3.xy;
  r4.xy = r1.xz * r5.xy + float2(1,1);
  r5.xyzw = r4.zwxw + r2.yzyz;
  r5.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r5.xyzw;
  r5.xyzw = cb0[149].xyxy * r5.xyzw;
  r5.xyzw = min(float4(1,1,1,1), r5.xyzw);
  r6.xyzw = t1.SampleLevel(s0_s, r5.xy, 0).xyzw;
  r5.xyzw = t1.SampleLevel(s0_s, r5.zw, 0).xyzw;
  r5.xyzw = r5.xyzw * r3.xxxx;
  r5.xyzw = r3.zzzz * r6.xyzw + r5.xyzw;
  r4.xyzw = r4.zyxy + r2.yzyz;
  r4.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r4.xyzw;
  r4.xyzw = cb0[149].xyxy * r4.xyzw;
  r4.xyzw = min(float4(1,1,1,1), r4.xyzw);
  r6.xyzw = t1.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r4.xyzw = t1.SampleLevel(s0_s, r4.zw, 0).xyzw;
  r4.xyzw = r4.xyzw * r3.xxxx;
  r4.xyzw = r3.zzzz * r6.xyzw + r4.xyzw;
  r4.xyzw = r4.xyzw * r3.yyyy;
  r3.xyzw = r3.wwww * r5.xyzw + r4.xyzw;
  if (cb0[139].x > 0) {
    r1.xzw = r3.xyz * r3.www;
    r3.xyz = float3(8,8,8) * r1.xzw;
  }
  r1.xzw = cb0[138].xxx * r3.xyz * injectedData.fxBloom;
  r0.x = r2.x;
  r0.y = r1.y;
  r0.xyz = r1.xzw * cb0[138].yzw + r0.xyz;
  if (cb0[146].z > 0) {
    r1.xy = -cb0[146].xy + v1.xy;
    r1.yz = cb0[146].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[145].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[146].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[145].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[145].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[136].www * r0.xyz;
  r1.xyz = applyUserTonemapACES(r0.xyz, 2);
  if (cb0[137].w > 0) {
    r0.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
    r2.xyz = handleUserLUT(r1.xyz, t3, s0_s, cb0[137].xyz);
    r2.xyz = r2.xyz + -r0.xyz;
    r0.xyz = cb0[137].www * r2.xyz + r0.xyz;
    r1.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  }
  r1.xyz = lutShaper(r1.xyz, false, 1);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.xyz = cb0[136].zzz * r1.zxy;
  r0.x = floor(r0.x);
  r1.xy = float2(0.5,0.5) * cb0[136].xy;
  r2.yz = r0.yz * cb0[136].xy + r1.xy;
  r2.x = r0.x * cb0[136].y + r2.y;
  r3.xyzw = t2.SampleLevel(s0_s, r2.xz, 0).xyzw;
  r1.x = cb0[136].y;
  r1.y = 0;
  r0.yz = r2.xz + r1.xy;
  r2.xyzw = t2.SampleLevel(s0_s, r0.yz, 0).xyzw;
  r0.x = r1.z * cb0[136].z + -r0.x;
  r0.yzw = r2.xyz + -r3.xyz;
  r0.xyz = r0.xxx * r0.yzw + r3.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r1.xyz, cb0[136].z + 1u);
  }
  float3 newPeak = renodx::lut::Sample(t2, s0_s, lutShaper((injectedData.toneMapPeakNits / injectedData.toneMapGameNits), false, 1), cb0[136].z + 1u) * injectedData.toneMapGameNits;
  float newPeakY = renodx::color::y::from::BT709(newPeak);
    float ratio = renodx::math::DivideSafe(injectedData.toneMapPeakNits / newPeakY, 1.f);
    if(ratio < 0.985f){
      r0.xyz = rolloff(r0.xyz, ratio);
    }
  r1.xy = v1.xy * cb0[150].xy + cb0[150].zw;
  r1.xyzw = t4.SampleBias(s1_s, r1.xy, cb0[4].x).xyzw;
  r0.w = r1.w * 2 + -1;
  r1.x = r0.w >= 0 ? 1 : -1;
  r0.w = 1 + -abs(r0.w);
  r0.w = sqrt(r0.w);
  r0.w = 1 + -r0.w;
  r0.w = r1.x * r0.w;
  r0.xyz = applyDither(r0.xyz, r0.w * (1.0 / 255.0));
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}