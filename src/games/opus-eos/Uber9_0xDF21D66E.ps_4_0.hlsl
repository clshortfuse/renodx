#include "./common.hlsl"

// short scene in penultimate chapter
// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 15 15:15:15 2025
Texture3D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[37];
}

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    float2 w1: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t1.Sample(s1_s, w1.xy).xyzw;

  r1.rgb = renodx::color::srgb::DecodeSafe(r0.rgb);

  r2.xyzw = t2.Sample(s2_s, v1.xy).xyzw;
  r0.xyz = r2.xxx * r1.xyz;
  r0.xyzw = cb0[36].zzzz * r0.xyzw;

  float3 ungraded = r0.rgb;

  renodx::lut::Config lut_config = renodx::lut::config::Create();
  lut_config.type_input = renodx::lut::config::type::ARRI_C1000_NO_CUT;
  lut_config.type_output = renodx::lut::config::type::LINEAR;
  lut_config.lut_sampler = s3_s;
  lut_config.strength = CUSTOM_LUT_STRENGTH;
  lut_config.scaling = CUSTOM_LUT_SCALING;
  lut_config.precompute = cb0[36].xyz;
  lut_config.tetrahedral = CUSTOM_LUT_TETRAHEDRAL == 1.f;
  float3 output;
  
  //following vanilla sampling otherwise blue becomes orange
  output = renodx::lut::Sample( 
      saturate(ungraded),
      lut_config,
      t3);

  if (RENODX_TONE_MAP_TYPE == 0.f) {
    output = Dither(output, v1.xy, t0, s0_s, cb0[30]);
  } else {
    output = renodx::draw::ToneMapPass(ungraded, output);
  }
  o0.rgb = renodx::draw::RenderIntermediatePass(renodx::color::bt709::clamp::BT2020(output));
  o0.w = 1;
  return;
}
