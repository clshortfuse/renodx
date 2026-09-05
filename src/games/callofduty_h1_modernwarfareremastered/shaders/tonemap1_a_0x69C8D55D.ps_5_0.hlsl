// ---- Created with 3Dmigoto v1.3.16 on Wed Aug 06 11:29:00 2025

#include "./common.hlsl"

Texture2D<float4> t4 : register(t4); //Color

Texture3D<float4> t2 : register(t2); //LUT

SamplerState s4_s : register(s4);

SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2)
{
  float4 cb2[4];
}




// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_TARGET0)
{
  //declare
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  float3 colorUntonemapped, colorTonemapped, colorSDRNeutral;

  //color
  r0.xyzw = t4.Sample(s4_s, v1.xy).xyzw;

  // if (RENODX_TONE_MAP_TYPE > 0)
  // {
  //   r0.xyz = renodx::color::srgb::Encode(r0.xyz);
  //   r0.xyz = renodx::lut::Sample(t2, s0_s, r0.xyz, 32);
  //   r0.xyz = renodx::color::srgb::Decode(r0.xyz);
  //   r0.xyz = renodx::draw::ToneMapPass(r0.xyz);
  //   r0.xyz = renodx::draw::RenderIntermediatePass(r0.xyz);
  //   o0.xyz = r0.xyz;
  //   o0.w = 1;
  //   return;
  // }

#ifdef DEBUG_MODE
  if (RENODX_TONE_MAP_TYPE == 1) {
    o0.xyz = r0.xyz;
    o0.xyz = renodx::draw::ToneMapPass(o0.xyz);
    o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
    o0.w = 1;
    return;
  }
#endif

  //colorUntonemapped
  colorUntonemapped = r0.xyz;

  //recover r0 from Tonemap0
  Tonemap_RecoverYFromW(r0);

#ifdef DEBUG_MODE
  if (RENODX_TONE_MAP_TYPE == 2) {
    o0.xyz = colorUntonemapped.xyz;
    o0.xyz = renodx::draw::RenderIntermediatePass(o0.xyz);
    o0.w = 1;
    return;
  }
#endif

  //color clamp
  r0.xyz = saturate(r0.xyz);

  //colorSDRNeutral
  colorSDRNeutral = r0.xyz;

  ///to srgb
  r0.xyz = renodx::color::srgb::EncodeSafe(r0.xyz);
  // {  r1.xyz = log2(r0.xyz);
  //   r1.xyz = float3(0.416666657,0.416666657,0.416666657) * r1.xyz; //2.4
  //   r1.xyz = exp2(r1.xyz);

  //   r1.xyz = r1.xyz * float3(1.05499995,1.05499995,1.05499995) + float3(-0.0549999997,-0.0549999997,-0.0549999997);
  //   r2.xyz = cmp(float3(0.00313080009,0.00313080009,0.00313080009) >= r0.xyz);
  //   r0.xyz = float3(12.9200001,12.9200001,12.9200001) * r0.xyz;
  //   r0.xyz = r2.xyz ? r0.xyz : r1.xyz;
  // }

  //LUT
  r0.xyz = r0.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625); //some shifting before lut idk
  r0.xyz = t2.Sample(s0_s, r0.xyz).xyz;

  //r0.w
  r0.w = dot(r0.xyz, float3(0.298999995,0.587000012,0.114));

  //More color correct tied to Game Brightness
  {
    //saturation
    r1.x = cb2[1].w * r0.w + cb2[0].w;
    r0.w = saturate(r0.w);
    r1.yzw = r0.www + -r0.xyz;
    r0.xyz = r1.xxx * r1.yzw + r0.xyz;
    
    //tint + Game Brightness
    r1.xyz = cb2[2].xyz * r0.www + cb2[1].xyz;
    r1.xyz = r1.xyz * r0.www + cb2[0].xyz;
    r0.xyz = r0.xyz * r1.xyz + cb2[3].xyz;
  }

  //colorTonemapped
  colorTonemapped = r0.xyz;
  
  //do tonemap
  Tonemap_Do(r0, colorUntonemapped, colorTonemapped/* , colorSDRNeutral */, v1, t4);

  //out
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}