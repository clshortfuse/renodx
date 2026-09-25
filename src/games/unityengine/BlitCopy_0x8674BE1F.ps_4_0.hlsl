#include "./common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  o0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
    if(CUSTOM_BLIT_COPY_HACK >= 1.f){
      if(CUSTOM_GAMMA_SPACE != 0.f){
        o0.xyz = renodx::color::srgb::DecodeSafe(o0.xyz);
      }
      if (CUSTOM_BLIT_COPY_HACK != 2.f && (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2)) {
        o0.xyz = GradeAndDisplayMap(o0.xyz);
      }
      if(CUSTOM_GAMMA_SPACE != 0.f){
      if(CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
        o0.xyz = PostToneMapScale(o0.xyz, true);
      } else {
        o0.xyz = renodx::color::srgb::EncodeSafe(o0.xyz);
      }
    } else if(CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
      o0.xyz = PostToneMapScale(o0.xyz);
    }
    }
  o0.w = saturate(o0.w);
  return;
}