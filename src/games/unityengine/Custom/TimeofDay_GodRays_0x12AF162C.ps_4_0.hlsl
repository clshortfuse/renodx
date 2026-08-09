#include "../common.hlsl"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[47];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[46].xy + cb0[46].zw;
  r0.xyzw = t1.Sample(s1_s, r0.xy).xyzw;
  r0.xyzw = saturate(cb0[43].xyzw * r0.xyzw);
  r1.xy = v1.xy * cb0[45].xy + cb0[45].zw;
  r1.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
  if(injectedData.toneMapType == 0.f){
  r0.xyzw = float4(1,1,1,1) + -r0.xyzw;
  r1.xyzw = float4(1,1,1,1) + -r1.xyzw;
  o0.xyzw = -r1.xyzw * r0.xyzw + float4(1,1,1,1);
  } else {
    r0.w = 1.f + -r0.w;
    r1.w = 1.f + -r1.w;
    o0.w = -r1.w * r0.w + 1.f;
    o0.xyz = r1.xyz + (r0.xyz / (1 + r1.xyz));
  }
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}