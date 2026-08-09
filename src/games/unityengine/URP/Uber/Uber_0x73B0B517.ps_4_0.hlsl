#include "../../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[139];
}

// Blue Archive

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.x = dot(r0.zw, r0.zw);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.xyzw = cb0[136].xxxx * r0.xyzw * injectedData.fxCA;
  r1.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[19].x).xyzw;
  r0.xyzw = r0.xyzw * float4(-0.333333343,-0.333333343,-0.666666687,-0.666666687) + v1.xyxy;
  r2.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[19].x).xyzw;
  r0.xyzw = t0.SampleBias(s0_s, r0.zw, cb0[19].x).xyzw;
  if (cb0[138].z > 0) {
    r1.yz = -cb0[138].xy + v1.xy;
    r3.yz = cb0[138].zz * abs(r1.yz) * min(1.f, injectedData.fxVignette);
    r3.x = cb0[137].w * r3.y;
    r0.w = dot(r3.xz, r3.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[138].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.yzw = float3(1,1,1) + -cb0[137].xyz;
    r1.yzw = r0.www * r1.yzw + cb0[137].xyz;
    r0.x = r1.x;
    r0.y = r2.y;
    r0.xyz = r0.xyz * r1.yzw;
  } else {
    r0.x = r1.x;
    r0.y = r2.y;
  }
  r0.xyz = cb0[128].www * r0.zxy;
  if (cb0[129].w > 0) {
    r0.w = max(r0.y, r0.z);
    r0.w = max(r0.w, r0.x);
    r0.w = log2(r0.w);
    r0.w = r0.w * 1 + 0.416924596;
    r0.w = max(0, r0.w);
    r0.w = exp2(r0.w);
    r1.xyz = r0.xyz / r0.www;
    r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);
    if (injectedData.colorGradeLUTSampling == 0.f) {
    r2.xyz = cb0[129].zzz * r1.xyz;
    r1.w = floor(r2.x);
    r2.xw = float2(0.5,0.5) * cb0[129].xy;
    r2.yz = r2.yz * cb0[129].xy + r2.xw;
    r2.x = r1.w * cb0[129].y + r2.y;
    r3.xyzw = t2.SampleLevel(s0_s, r2.xz, 0).xyzw;
    r4.x = cb0[129].y;
    r4.yw = float2(0,0);
    r2.xy = r4.xy + r2.xz;
    r2.xyzw = t2.SampleLevel(s0_s, r2.xy, 0).xyzw;
    r1.w = r1.x * cb0[129].z + -r1.w;
    r2.xyz = r2.zxy + -r3.zxy;
    r2.xyz = r1.www * r2.xyz + r3.zxy;
    } else {
      r2.yzx = renodx::lut::SampleTetrahedral(t2, r1.yzx, cb0[129].z + 1u);
    }
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[129].www * r2.xyz + r1.xyz;
    r1.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
    if (injectedData.colorGradeLUTSampling == 0.f) {
    r1.yzw = cb0[128].zzz * r1.xyz;
    r1.y = floor(r1.y);
    r2.xy = float2(0.5,0.5) * cb0[128].xy;
    r2.yz = r1.zw * cb0[128].xy + r2.xy;
    r2.x = r1.y * cb0[128].y + r2.y;
    r3.xyzw = t1.SampleLevel(s0_s, r2.xz, 0).xyzw;
    r4.z = cb0[128].y;
    r1.zw = r2.xz + r4.zw;
    r2.xyzw = t1.SampleLevel(s0_s, r1.zw, 0).xyzw;
    r1.x = r1.x * cb0[128].z + -r1.y;
    r1.yzw = r2.xyz + -r3.xyz;
    r1.xyz = r1.xxx * r1.yzw + r3.xyz;
    } else {
      r1.xyz = renodx::lut::SampleTetrahedral(t1, r1.yzx, cb0[128].z + 1u);
    }
    r1.xyz = r1.xyz * r0.www;
  } else {
    r2.xyz = max(float3(1,1,1), r0.yzx);
    r3.yzx = handleUserLUT(r0.yzx, t2, s0_s, cb0[129].xyz);
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r5.yw = float2(0,0);
    r3.xyz = r3.xyz + -r0.xyz;
    r0.xyz = cb0[129].www * r3.xyz + r0.xyz;
    r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
    r0.yzx = lutShaper(r0.yzx, false, 1);
    if (injectedData.colorGradeLUTSampling == 0.f) {
    r0.yzw = cb0[128].zzz * r0.xyz;
    r0.y = floor(r0.y);
    r3.xy = float2(0.5,0.5) * cb0[128].xy;
    r3.yz = r0.zw * cb0[128].xy + r3.xy;
    r3.x = r0.y * cb0[128].y + r3.y;
    r4.xyzw = t1.SampleLevel(s0_s, r3.xz, 0).xyzw;
    r5.z = cb0[128].y;
    r0.zw = r3.xz + r5.zw;
    r3.xyzw = t1.SampleLevel(s0_s, r0.zw, 0).xyzw;
    r0.x = r0.x * cb0[128].z + -r0.y;
    r0.yzw = r3.xyz + -r4.xyz;
    r0.xyz = r0.xxx * r0.yzw + r4.xyz;
    } else {
      r0.xyz = renodx::lut::SampleTetrahedral(t1, r0.yzx, cb0[128].z + 1u);
    }
    r1.xyz = r0.xyz * r2.xyz;
  }
  if (injectedData.countOld == injectedData.countNew) {
    r1.xyz = PostToneMapScale(r1.xyz);
  }
  o0.xyz = r1.xyz;
  o0.w = 1;
  return;
}