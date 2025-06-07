#include "./common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[1];
}

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  float2 v1 : TEXCOORD2,
  float2 w1 : TEXCOORD3,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, w0.xy).xyzw;
  r0.xyzw = float4(0.487427473,0.487427473,0.487427473,0.487427473) * r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.147913605,0.147913605,0.147913605,0.147913605) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.328026086,0.328026086,0.328026086,0.328026086) + r0.xyzw;
  r1.xyzw = t0.Sample(s0_s, w1.xy).xyzw;
  r0.xyzw = r1.xyzw * float4(0.036632847,0.036632847,0.036632847,0.036632847) + r0.xyzw;
  o0.xyz = cb0[0].www * r0.xyz;
  o0.w = r0.w;
  if (injectedData.toneMapType == 0.f) {
    o0 = saturate(o0);
  } else {
    float old_y = renodx::color::y::from::BT709(o0.rgb);
    float new_y = renodx::color::y::from::BT709(saturate(o0.rgb));
    o0 = max(0.f, o0) * renodx::math::DivideSafe(new_y, old_y);
  }
  return;
}