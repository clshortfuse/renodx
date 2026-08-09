#include "../../common.hlsl"

Texture2D<float4> t5 : register(t5);
Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[145];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.SampleBias(s0_s, v1.xy, cb0[19].x).xyzw;
  r1.xyzw = float4(1,1,-1,0) * cb0[141].xyxy;
  r2.xyzw = -r1.xywy * cb0[143].xxxx + v1.xyxy;
  r3.xyzw = t4.SampleBias(s0_s, r2.xy, cb0[19].x).xyzw;
  r2.xyzw = t4.SampleBias(s0_s, r2.zw, cb0[19].x).xyzw;
  r2.xyz = r2.xyz * float3(2,2,2) + r3.xyz;
  r3.xy = -r1.zy * cb0[143].xx + v1.xy;
  r3.xyzw = t4.SampleBias(s0_s, r3.xy, cb0[19].x).xyzw;
  r2.xyz = r3.xyz + r2.xyz;
  r3.xyzw = r1.zwxw * cb0[143].xxxx + v1.xyxy;
  r4.xyzw = t4.SampleBias(s0_s, r3.xy, cb0[19].x).xyzw;
  r2.xyz = r4.xyz * float3(2,2,2) + r2.xyz;
  r4.xyzw = t4.SampleBias(s0_s, v1.xy, cb0[19].x).xyzw;
  r2.xyz = r4.xyz * float3(4,4,4) + r2.xyz;
  r3.xyzw = t4.SampleBias(s0_s, r3.zw, cb0[19].x).xyzw;
  r2.xyz = r3.xyz * float3(2,2,2) + r2.xyz;
  r3.xyzw = r1.zywy * cb0[143].xxxx + v1.xyxy;
  r4.xyzw = t4.SampleBias(s0_s, r3.xy, cb0[19].x).xyzw;
  r2.xyz = r4.xyz + r2.xyz;
  r3.xyzw = t4.SampleBias(s0_s, r3.zw, cb0[19].x).xyzw;
  r2.xyz = r3.xyz * float3(2,2,2) + r2.xyz;
  r1.xy = r1.xy * cb0[143].xx + v1.xy;
  r1.xyzw = t4.SampleBias(s0_s, r1.xy, cb0[19].x).xyzw;
  r1.xyz = r2.xyz + r1.xyz;
  r1.xyz = cb0[143].yyy * r1.xyz * injectedData.fxBloom;
  r2.xy = v1.xy * cb0[142].xy + cb0[142].zw;
  r2.xyzw = t5.SampleBias(s0_s, r2.xy, cb0[19].x).xyzw;
  r1.xyz = float3(0.0625,0.0625,0.0625) * r1.xyz;
  r2.xyz = cb0[143].zzz * r2.xyz * injectedData.fxLens;
  r0.xyz = r1.xyz * cb0[144].xyz + r0.xyz;
  r0.xyz = r2.xyz * r1.xyz + r0.xyz;
  if (cb0[136].z > 0) {
    r1.xy = -cb0[136].xy + v1.xy;
    r1.yz = cb0[136].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[135].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[136].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[135].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[135].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[128].www * r0.zxy;
  r0.yzx = lutShaper(r0.yzx);
  if (injectedData.colorGradeLUTSampling == 0.f) {
  r0.yzw = cb0[128].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[128].xy;
  r1.yz = r0.zw * cb0[128].xy + r1.xy;
  r1.x = r0.y * cb0[128].y + r1.y;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[128].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t2.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r0.x = r0.x * cb0[128].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r0.yzx, cb0[128].z + 1u);
  }
  if (cb0[129].w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t3, s0_s, cb0[129].xyz);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[129].www * r2.xyz + r1.xyz;
    r0.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  if (injectedData.fxFilmGrainType == 0.f) {
  r1.xy = v1.xy * cb0[138].xy + cb0[138].zw;
  r1.xyzw = t1.SampleBias(s1_s, r1.xy, cb0[19].x).xyzw;
  r0.w = -0.5 + r1.w;
  r0.w = r0.w + r0.w;
  r1.x = renodx::color::y::from::BT709(saturate(r0.xyz));
  r1.x = sqrt(r1.x);
  r1.x = cb0[137].y * -r1.x + 1;
  r1.yzw = r0.xyz * r0.www;
  r1.yzw = cb0[137].xxx * r1.yzw * injectedData.fxFilmGrain;
  r0.xyz = r1.yzw * r1.xxx + r0.xyz;
  } else {
    r0.xyz = applyFilmGrain(r0.xyz, v1);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}