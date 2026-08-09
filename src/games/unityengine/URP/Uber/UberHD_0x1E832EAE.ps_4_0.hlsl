#include "../../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[149];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[131].xy * float2(0.5,0.5) + cb0[28].xy;
  r0.xy = min(v1.xy, r0.xy);
  r0.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r1.xy = -cb0[135].xy * float2(0.5,0.5) + cb0[28].xy;
  r1.xy = min(v1.xy, r1.xy);
  r1.xy = r1.xy * cb0[148].zw + float2(0.5,0.5);
  r1.zw = floor(r1.xy);
  r1.xy = frac(r1.xy);
  r2.xyzw = -r1.xyxy * float4(0.5,0.5,0.166666672,0.166666672) + float4(0.5,0.5,0.5,0.5);
  r2.xyzw = r1.xyxy * r2.xyzw + float4(0.5,0.5,-0.5,-0.5);
  r3.xy = r1.xy * float2(0.5,0.5) + float2(-1,-1);
  r3.zw = r1.xy * r1.xy;
  r3.xy = r3.zw * r3.xy + float2(0.666666687,0.666666687);
  r2.xyzw = r1.xyxy * r2.xyzw + float4(0.166666672,0.166666672,0.166666672,0.166666672);
  r1.xy = float2(1,1) + -r3.xy;
  r1.xy = r1.xy + -r2.xy;
  r1.xy = r1.xy + -r2.zw;
  r2.zw = r2.zw + r3.xy;
  r2.xy = r2.xy + r1.xy;
  r3.zw = float2(1,1) / r2.zw;
  r3.zw = r3.xy * r3.zw + float2(-1,-1);
  r4.xy = float2(1,1) / r2.xy;
  r3.xy = r1.xy * r4.xy + float2(1,1);
  r4.xyzw = r3.zwxw + r1.zwzw;
  r4.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r4.xyzw;
  r4.xyzw = cb0[148].xyxy * r4.xyzw;
  r4.xyzw = min(float4(1,1,1,1), r4.xyzw);
  r5.xyzw = t1.SampleLevel(s0_s, r4.xy, 0).xyzw;
  r4.xyzw = t1.SampleLevel(s0_s, r4.zw, 0).xyzw;
  r4.xyz = r4.xyz * r2.xxx;
  r4.xyz = r2.zzz * r5.xyz + r4.xyz;
  r1.xyzw = r3.zyxy + r1.zwzw;
  r1.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r1.xyzw;
  r1.xyzw = cb0[148].xyxy * r1.xyzw;
  r1.xyzw = min(float4(1,1,1,1), r1.xyzw);
  r3.xyzw = t1.SampleLevel(s0_s, r1.xy, 0).xyzw;
  r1.xyzw = t1.SampleLevel(s0_s, r1.zw, 0).xyzw;
  r1.xyz = r2.xxx * r1.xyz;
  r1.xyz = r2.zzz * r3.xyz + r1.xyz;
  r1.xyz = r2.yyy * r1.xyz;
  r1.xyz = r2.www * r4.xyz + r1.xyz;
  r1.xyz = cb0[138].xxx * r1.xyz * injectedData.fxBloom;
  r0.xyz = r1.xyz * cb0[138].yzw + r0.xyz;
  if (cb0[145].z > 0) {
    r1.xy = -cb0[145].xy + v1.xy;
    r1.yz = cb0[145].zz * abs(r1.xy) * min(1.f, injectedData.fxVignette);
    r1.x = cb0[144].w * r1.y;
    r0.w = dot(r1.xz, r1.xz);
    r0.w = 1 + -r0.w;
    r0.w = max(0, r0.w);
    r0.w = log2(r0.w);
    r0.w = cb0[145].w * r0.w * max(1.f, injectedData.fxVignette);
    r0.w = exp2(r0.w);
    r1.xyz = float3(1,1,1) + -cb0[144].xyz;
    r1.xyz = r0.www * r1.xyz + cb0[144].xyz;
    r0.xyz = r1.xyz * r0.xyz;
  }
  r0.xyz = cb0[136].www * r0.zxy;
  r0.yzx = lutShaper(r0.yzx);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r0.yzw = cb0[136].zzz * r0.xyz;
  r0.y = floor(r0.y);
  r1.xy = float2(0.5,0.5) * cb0[136].xy;
  r1.yz = r0.zw * cb0[136].xy + r1.xy;
  r1.x = r0.y * cb0[136].y + r1.y;
  r2.xyzw = t2.SampleLevel(s0_s, r1.xz, 0).xyzw;
  r3.x = cb0[136].y;
  r3.y = 0;
  r0.zw = r3.xy + r1.xz;
  r1.xyzw = t2.SampleLevel(s0_s, r0.zw, 0).xyzw;
  r0.x = r0.x * cb0[136].z + -r0.y;
  r0.yzw = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r0.yzw + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t2, r0.yzx, cb0[136].z + 1u);
  }
  if (cb0[137].w > 0) {
    r1.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
    r2.xyz = handleUserLUT(r0.xyz, t3, s0_s, cb0[137].xyz);
    r2.xyz = r2.xyz + -r1.xyz;
    r1.xyz = cb0[137].www * r2.xyz + r1.xyz;
    r0.xyz = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}