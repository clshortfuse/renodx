#include "../../common.hlsl"

Texture2D<float4> t4 : register(t4);
Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s4_s : register(s4);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[44];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r0.yzw = renodx::color::srgb::DecodeSafe(r1.xyz);
  r1.xyz = r0.yzw * r0.xxx;
  r0.xyzw = float4(-1,-1,1,1) * cb0[32].xyxy;
  r2.x = 0.5 * cb0[34].x;
  r3.xyzw = saturate(r0.xyzy * r2.xxxx + v1.xyxy);
  r3.xyzw = cb0[26].zzzz * r3.xyzw;
  r4.xyzw = t2.Sample(s2_s, r3.xy).xyzw;
  r3.xyzw = t2.Sample(s2_s, r3.zw).xyzw;
  r3.xyzw = r4.xyzw + r3.xyzw;
  r0.xyzw = saturate(r0.xwzw * r2.xxxx + v1.xyxy);
  r0.xyzw = cb0[26].zzzz * r0.xyzw;
  r2.xyzw = t2.Sample(s2_s, r0.xy).xyzw;
  r2.xyzw = r3.xyzw + r2.xyzw;
  r0.xyzw = t2.Sample(s2_s, r0.zw).xyzw;
  r0.xyzw = r2.xyzw + r0.xyzw;
  r0.xyzw = cb0[34].yyyy * r0.xyzw * injectedData.fxBloom;
  r2.xy = v1.xy * cb0[33].xy + cb0[33].zw;
  r2.xyzw = t3.Sample(s3_s, r2.xy).xyzw;
  r3.xyzw = float4(0.25,0.25,0.25,0.25) * r0.xyzw;
  r2.xyz = cb0[34].zzz * r2.xyz * injectedData.fxLens;
  r2.w = 0;
  r0.xyzw = float4(0.25,0.25,0.25,1) * r0.xyzw;
  r4.xyz = cb0[35].xyz * r0.xyz;
  r4.w = 0.25 * r0.w;
  r0.xyzw = r4.xyzw + r1.xyzw;
  r0.xyzw = r2.xyzw * r3.xyzw + r0.xyzw;
  r0.w = saturate(r0.w);
  r0.yzx = lutShaper(r0.xyz, false, 2);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r1.xyz = cb0[37].zzz * r0.xyz;
  r0.y = floor(r1.x);
  r1.xw = float2(0.5,0.5) * cb0[37].xy;
  r1.yz = r1.yz * cb0[37].xy + r1.xw;
  r1.x = r0.y * cb0[37].y + r1.y;
  r2.xyzw = t4.Sample(s4_s, r1.xz).xyzw;
  r3.x = cb0[37].y;
  r3.y = 0;
  r1.xy = r3.xy + r1.xz;
  r1.xyzw = t4.Sample(s4_s, r1.xy).xyzw;
  r0.x = r0.x * cb0[37].z + -r0.y;
  r1.xyz = r1.xyz + -r2.xyz;
  r0.xyz = r0.xxx * r1.xyz + r2.xyz;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t4, r0.yzx, cb0[37].z + 1u);
  }
  r0.xyz = renodx::color::srgb::DecodeSafe(r0.xyz);
  if (cb0[43].x > 0.5) {
    o0.w = renodx::color::y::from::BT709(saturate(r0.xyz));
  } else {
    o0.w = r0.w;
  }
  if (injectedData.countOld == injectedData.countNew) {
    r0.xyz = PostToneMapScale(r0.xyz, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}