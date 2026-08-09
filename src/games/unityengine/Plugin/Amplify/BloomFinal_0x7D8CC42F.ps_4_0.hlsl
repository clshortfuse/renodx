#include "../../common.hlsl"

Texture2D<float4> t3 : register(t3);
Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s3_s : register(s3);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[59];
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  float4 v3 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s2_s, w1.xy).xyzw;
  r0.xyz = cb0[46].xxx * r0.xyz;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = cb0[48].yyy * r0.xyz;
  r1.xyzw = t0.Sample(s1_s, w1.xy).xyzw;
  r1.xyz = cb0[46].xxx * r1.xyz;
  r1.xyz = r1.xyz * r1.www;
  r0.xyz = cb0[48].xxx * r1.xyz + r0.xyz;
  r1.xyzw = t2.Sample(s3_s, w1.xy).xyzw;
  r1.xyz = cb0[46].xxx * r1.xyz;
  r1.xyz = r1.xyz * r1.www;
  r0.xyz = cb0[48].zzz * r1.xyz + r0.xyz;
  r0.xyz = cb0[57].zzz * r0.xyz;
  r1.xyzw = t3.Sample(s0_s, v3.xy).xyzw;
  if(injectedData.countOld < injectedData.countNew){
    r1.xyz = InvertToneMapScale(r1.xyz, injectedData.gammaSpace != 0.f);
    r1.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::EncodeSafe(r1.xyz) : r1.xyz;
  }
  r1.xyzw = cb0[57].yyyy * r1.xyzw;
  o0.xyz = r0.xyz * cb0[58].xxx * injectedData.fxBloom + r1.xyz;
  o0.w = r1.w;
  if (injectedData.countOld <= injectedData.countNew) {
    o0.xyz = injectedData.gammaSpace != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
    o0.xyz = PostToneMapScale(o0.xyz, injectedData.gammaSpace != 0.f);
  }
  return;
}