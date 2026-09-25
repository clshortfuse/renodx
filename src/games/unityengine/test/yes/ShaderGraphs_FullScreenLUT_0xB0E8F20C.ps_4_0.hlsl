#include "../../common.hlsli"

Texture2D<float4> t1 : register(t1);
Texture3D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[124];
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : INTERP0,
  float4 v2 : INTERP1,
  out float4 o0 : SV_TARGET0)
{
  float4 r0;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb0[123].xy * v1.xy;
  r0.xy = (uint2)r0.xy;
  r0.zw = float2(0,0);
  r0.xyzw = t1.Load(r0.xyz).xyzw;
  /*r0.xyz = r0.xyz * float3(5.55555582,5.55555582,5.55555582) + float3(0.0479959995,0.0479959995,0.0479959995);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839,0.0734997839,0.0734997839) + float3(0.386036009,0.386036009,0.386036009));*/
  float3 preCG = r0.xyz;
  float max_channel_scale;
  float compression_scale;
  GamutCompression(r0.xyz, compression_scale);
  NeutwoMaxCh(r0.xyz, max_channel_scale);
  r0.xyz = renodx::color::arri::logc::c1000::Encode(r0.xyz, false);
  if (CUSTOM_LUT_SAMPLE == 0.f) {
    r0.xyzw = t0.Sample(s0_s, r0.xyz).xyzw;
  } else {
    r0.xyz = renodx::lut::SampleTetrahedral(t0, r0.xyz);
  }
  if (CUSTOM_USER_LUT_SCALING > 0.f) {
    float3 scalingInput = renodx::color::arri::logc::c1000::Encode(float3(0,0,0), false);
    float3 minBlack = t0.Sample(s0_s, scalingInput).xyz;
    float lutMinY = renodx::color::y::from::BT709(abs(minBlack));
    if (lutMinY > 0) {
      float3 correctedBlack = renodx::lut::CorrectBlack(preCG, r0.xyz, lutMinY, 0.f);
      r0.xyz = lerp(r0.xyz, correctedBlack, CUSTOM_USER_LUT_SCALING);
    }
    scalingInput = renodx::color::arri::logc::c1000::Encode(float3(1,1,1), false);
    float3 maxWhite = t0.Sample(s0_s, scalingInput).xyz;
    float lutMaxY = renodx::color::y::from::BT709(abs(maxWhite));
    if (lutMaxY > 0) {
      float3 correctedWhite = renodx::lut::CorrectWhite(preCG, r0.xyz, lutMaxY, 1.f, 0.f);
      r0.xyz = lerp(r0.xyz, correctedWhite, CUSTOM_USER_LUT_SCALING);
    }
  }
  NeutwoMaxChInverse(r0.xyz, max_channel_scale);
  GamutDecompression(r0.xyz, compression_scale);
  r0.xyz = lerp(preCG, r0.xyz, CUSTOM_USER_LUT_STRENGTH);
  if (CUSTOM_COUNT_OLD_2 == CUSTOM_COUNT_NEW_2) {
    r0.xyz = GradeAndDisplayMap(r0.xyz);
  }
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}