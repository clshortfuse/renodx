#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Wed Apr 16 00:10:52 2025
Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb3 : register(b3)
{
  float4 cb3[77];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD8,
  float4 v2 : COLOR0,
  float4 v3 : COLOR1,
  float4 v4 : TEXCOORD9,
  float4 v5 : TEXCOORD0,
  float4 v6 : TEXCOORD1,
  float4 v7 : TEXCOORD2,
  float4 v8 : TEXCOORD3,
  float4 v9 : TEXCOORD4,
  float4 v10 : TEXCOORD5,
  float4 v11 : TEXCOORD6,
  float4 v12 : TEXCOORD7,
  out float4 o0 : SV_TARGET0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
  //r0.xyzw = (int4)r0.xyzw & asint(cb3[44].xyzw);
  //r0.xyzw = (int4)r0.xyzw | asint(cb3[45].xyzw);
  r1.xyzw = t1.Sample(s1_s, v5.xy).xyzw;
  ////r1.xyzw = (int4)r1.xyzw & asint(cb3[46].xyzw);
  ////r1.xyzw = (int4)r1.xyzw | asint(cb3[47].xyzw);

  //r1.xyz = renodx::draw::InvertIntermediatePass(r1.xyz);
  //r1.xyz = renodx::color::srgb::EncodeSafe(r1.xyz);

  o0.xyzw = r1.xyzw + r0.xyzw;
  if (CUSTOM_SUNSHAFT_CHECK == CUSTOM_SUNSHAFT_COUNT) {
    float3 untonemapped = renodx::color::srgb::DecodeSafe(o0.rgb);
    float3 sdr_color = saturate(untonemapped);
    // sdr_color = renodx::tonemap::uncharted2::BT709(untonemapped);
    o0.rgb = CustomTonemap(untonemapped, sdr_color, v5.xy);
  } else {}
  /*if (RENODX_TONE_MAP_TYPE == 0.f) {
    o0.rgb = renodx::color::srgb::DecodeSafe(o0.rgb);
  }
  else {
    o0.rgb = renodx::tonemap::ExponentialRollOff(renodx::color::srgb::DecodeSafe(o0.rgb), 0.2f, RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS);
  }

  o0.rgb = renodx::draw::RenderIntermediatePass(o0.rgb);*/
  return;
}