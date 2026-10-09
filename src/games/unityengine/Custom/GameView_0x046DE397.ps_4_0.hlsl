#include "../common.hlsli"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[21];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float2 v2 : TEXCOORD0,
  float2 w2 : TEXCOORD2,
  float4 v3 : TEXCOORD5,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v3.xy / v3.ww;
  r0.xy = r0.xy * cb0[13].zw + cb0[14].xy;
  r0.xyzw = t2.Sample(s0_s, r0.xy).xyzw;
  r0.x = r0.w * 2 + -1;
  r0.y = sign(r0.x);
  r0.x = 1 + -abs(r0.x);
  r0.x = sqrt(r0.x);
  r0.x = 1 + -r0.x;
  r0.x = r0.y * r0.x;
  r1.xyzw = t1.Sample(s2_s, w2.xy).xyzw;
  r2.xyzw = t0.Sample(s1_s, v2.xy).xyzw;
  r0.yzw = r2.xyz * r1.xyz + -r2.xyz;
  r0.yzw = cb0[20].yyy * r0.yzw + r2.xyz;
  r0.yzw = renodx::color::srgb::DecodeSafe(r0.yzw);
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    r0.yzw = applyDither(r0.yzw, r0.x * (1.0 / 255.0));
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.yzw, true);
  } else {
    r0.xyz = renodx::color::srgb::EncodeSafe(r0.yzw);
  }
  o0.xyz = r0.xyz;
  o0.w = cb0[16].x;
  return;
}