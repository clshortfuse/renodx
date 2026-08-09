#include "../../common.hlsl"

Texture2D<uint4> t5 : register(t5);
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

// starsand island

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = -cb0[131].xy * float2(0.5,0.5) + cb0[28].xy;
  r0.xy = min(v1.xy, r0.xy);
  r0.xyzw = t0.SampleBias(s0_s, r0.xy, cb0[4].x).xyzw;
  r1.xy = (int2)v0.xy;
  r1.zw = float2(0,0);
  r1.xyzw = t5.Load(r1.xyz).xyzw;
  r1.x = (int)r1.x & 4;
  r1.yz = -cb0[136].xy * float2(0.5,0.5) + cb0[28].xy;
  r1.yz = min(v1.xy, r1.yz);
  r2.xyzw = t1.SampleBias(s0_s, r1.yz, cb0[4].x).xyzw;
  r1.yzw = cb0[139].xxx * r2.xyz * injectedData.fxBloom;
  r0.xyz = r1.yzw * cb0[139].yzw + r0.xyz;
  if (cb0[146].z > 0) {
    r1.yz = -cb0[146].xy + v1.xy;
    r2.yz = cb0[146].zz * abs(r1.yz) * min(1.f, injectedData.fxVignette);
    r2.x = cb0[145].w * r2.y;
    r1.y = dot(r2.xz, r2.xz);
    r1.y = 1 + -r1.y;
    r1.y = max(0, r1.y);
    r1.y = log2(r1.y);
    r1.y = cb0[146].w * r1.y * max(1.f, injectedData.fxVignette);
    r1.y = exp2(r1.y);
    r2.xyz = float3(1,1,1) + -cb0[145].xyz;
    r1.yzw = r1.yyy * r2.xyz + cb0[145].xyz;
    r1.yzw = r1.yzw * r0.xyz;
  } else {
    r1.yzw = r0.xyz;
  }
  r2.xyz = cb0[137].www * r1.wyz;
  r2.yzx = lutShaper(r2.yzx);
    if(injectedData.colorGradeLUTSampling == 0.f){
  r2.yzw = cb0[137].zzz * r2.xyz;
  r2.y = floor(r2.y);
  r3.xy = float2(0.5,0.5) * cb0[137].xy;
  r3.yz = r2.zw * cb0[137].xy + r3.xy;
  r3.x = r2.y * cb0[137].y + r3.y;
  r4.xyzw = t2.SampleLevel(s0_s, r3.xz, 0).xyzw;
  r5.x = cb0[137].y;
  r5.y = 0;
  r2.zw = r5.xy + r3.xz;
  r3.xyzw = t2.SampleLevel(s0_s, r2.zw, 0).xyzw;
  r2.x = r2.x * cb0[137].z + -r2.y;
  r2.yzw = r3.xyz + -r4.xyz;
  r2.xyz = r2.xxx * r2.yzw + r4.xyz;
  } else {
    r2.xyz = renodx::lut::SampleTetrahedral(t2, r2.yzx, cb0[137].z + 1u);
  }
  if (cb0[138].w > 0) {
    r3.xyz = renodx::color::srgb::EncodeSafe(r2.xyz);
    r4.xyz = handleUserLUT(r2.xyz, t3, s0_s, cb0[138].xyz);
    r4.xyz = r4.xyz + -r3.xyz;
    r3.xyz = cb0[138].www * r4.xyz + r3.xyz;
    r2.xyz = renodx::color::srgb::DecodeSafe(r3.xyz);
  }
  r1.x = r1.x ? 0 : 1;
  r1.x = saturate(cb0[144].y + r1.x);
  r2.xyz = r2.xyz + -r1.yzw;
  r1.xyz = r1.xxx * r2.xyz + r1.yzw;
  r2.xy = v1.xy * cb0[150].xy + cb0[150].zw;
  r2.xyzw = t4.SampleBias(s1_s, r2.xy, cb0[4].x).xyzw;
  r1.w = r2.w * 2 + -1;
  r2.x = r1.w >= 0 ? 1 : -1;
  r1.w = 1 + -abs(r1.w);
  r1.w = sqrt(r1.w);
  r1.w = 1 + -r1.w;
  r1.w = r2.x * r1.w;
  r1.xyz = applyDither(r1.xyz, r1.w * (1.0 / 255.0));
  r0.w = saturate(r0.w);
  r1.xyz = r1.xyz + -r0.xyz;
  o0.xyz = r0.www * r1.xyz + r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  o0.w = r0.w;
  return;
}