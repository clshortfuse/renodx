#include "../../common.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD2,
  float4 v2 : TEXCOORD1,
  float2 v3 : TEXCOORD4,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = t1.Sample(s1_s, v1.xy).xyz;
  r0.xyz = saturate(r0.xyz);
  r2.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = saturate(r2.w);
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r2.xyz = saturate(r2.xyz);
  }
  if (CUSTOM_FILM_GRAIN_TYPE == 0.f) {
  r1.xyz = float3(1,1,1) + -r0.xyz;
  r3.xyz = float3(-0.5,-0.5,-0.5) + r2.xyz;
  r3.xyz = -r3.xyz * float3(2,2,2) + float3(1,1,1);
  r1.xyz = -r3.xyz * r1.xyz + float3(1,1,1);
  r0.xyz = r2.xyz * r0.xyz;
  r0.xyz = r2.xyz >= float3(0.5,0.5,0.5) ? float3(0,0,0) : r0.xyz;
  r2.xyz = r2.xyz >= float3(0.5,0.5,0.5) ? float3(1,1,1) : 0;
  r0.xyz = r0.xyz + r0.xyz;
  r0.xyz = r2.xyz * r1.xyz + r0.xyz;
  } else {
    r2.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::DecodeSafe(r2.xyz) : r2.xyz;
    r0.xyz = applyFilmGrain(r2.xyz, v1);
    r0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::EncodeSafe(r0.xyz) : r0.xyz;
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
    r0.xyz = PostToneMapScale(r0.xyz, CUSTOM_GAMMA_SPACE != 0.f);
  }
  o0.xyz = r0.xyz;
  return;
}