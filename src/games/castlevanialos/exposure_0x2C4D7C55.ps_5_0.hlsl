#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.4.1 on Tue Apr 15 15:21:16 2025
Texture2D<float4> t2 : register(t2);

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb4 : register(b4)
{
  float4 cb4[236];
}

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
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v5.xy).xyzw;
  ////r0.xyzw = (int4)r0.xyzw & asint(cb3[44].xyzw);
  ////r0.xyzw = (int4)r0.xyzw | asint(cb3[45].xyzw);
  r1.xyzw = t2.Sample(s2_s, v5.xy).xyzw;
  ////r1.xyzw = (int4)r1.xyzw & asint(cb3[48].xyzw);
  ////r1.xyzw = (int4)r1.xyzw | asint(cb3[49].xyzw);
  r0.xyz = r0.xyz * cb4[8].xxx + (r1.xyz * CUSTOM_BLOOM);
  r1.xyzw = t1.Sample(s1_s, float2(0.5,0.5)).xyzw;
  ////r1.xyzw = (int4)r1.xyzw & asint(cb3[46].xyzw);
  ////r1.xyzw = (int4)r1.xyzw | asint(cb3[47].xyzw);
  /*r2.y = cmp(0 < abs(r1.x));
  r2.x = rcp(r1.x);
  r0.w = r2.y ? r2.x : 9999999933815812510711506376257961984;*/
  r0.w = renodx::math::DivideSafe(1.f, r1.x);
  r0.w = cb4[9].x * r0.w;

  //r0.xyz = r0.xyz * r0.www;
  r0.xyz = r0.xyz * lerp(1.f, r0.www, CUSTOM_EXPOSURE);

  //r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));
  r0.w = renodx::color::y::from::NTSC1953(r0.xyz);
  r1.xyz = r0.www * cb4[10].xyz + -r0.xyz;
  r0.w = 1 + -r0.w;
  r0.w = saturate(cb4[10].w * r0.w);
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r1.x = 0.5;

  //o0.xyz = saturate(cb4[11].xxx * r0.xyz + r1.xxx);
  o0.xyz = cb4[11].xxx * r0.xyz + r1.xxx;

  if (CUSTOM_SUNSHAFT_CHECK == 0.f) {
  float3 untonemapped = renodx::color::srgb::DecodeSafe(o0.rgb);
  float3 sdr_color = saturate(untonemapped);
  //sdr_color = renodx::tonemap::uncharted2::BT709(untonemapped);
  o0.rgb = CustomTonemap(untonemapped, sdr_color, v5.xy);
  } else {}

  o0.w = 1;
  return;
}