#include "../../common.hlsli"

Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  o0.w = r0.w;
  r0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::DecodeSafe(r0.xyz) : r0.xyz;
  float3 preCG = r0.xyz;
  float compression_scale;
  float max_channel_scale;
  GamutCompression(r0.xyz, compression_scale);
  NeutwoMaxCh(r0.xyz, max_channel_scale);
  r0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::Encode(saturate(r0.xyz)) : r0.xyz;
  r1.xyzw = t1.Sample(s1_s, r0.xx).xyzw;
  o0.x = r1.x;
  r1.xyzw = t1.Sample(s1_s, r0.yy).xyzw;
  o0.y = r1.y;
  r1.xyzw = t1.Sample(s1_s, r0.zz).xyzw;
  o0.z = r1.z;
  o0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::DecodeSafe(o0.xyz) : o0.xyz;
  NeutwoMaxChInverse(o0.xyz, max_channel_scale);
  GamutDecompression(o0.xyz, compression_scale);
  o0.xyz = lerp(preCG, o0.xyz, CUSTOM_USER_LUT_STRENGTH);
  o0.xyz = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::EncodeSafe(o0.xyz) : o0.xyz;
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    o0.xyz = GradeAndDisplayMap(o0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    o0.xyz = PostToneMapScale(o0.xyz, CUSTOM_GAMMA_SPACE != 0.f);
  } else if(CUSTOM_GAMMA_SPACE != 0.f){
    o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
  }
  return;
}