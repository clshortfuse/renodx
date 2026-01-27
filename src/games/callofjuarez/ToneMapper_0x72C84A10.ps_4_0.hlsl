#include "./shared.h"

cbuffer _Globals : register(b0)
{
  float4 CONST_4 : packoffset(c0);
  float fhdrglowthreshold : packoffset(c1);
  float4 RENDER_TARGET_PARAMS : packoffset(c2);
}

SamplerState samColorAVG_s : register(s0);
Texture2D<float4> sColorAVG : register(t0);
Texture2D<float4> sColorHDR : register(t1);

void main(
  float4 v0 : SV_POSITION0,
  out float4 o0 : SV_TARGET0)
{
  float4 r0, r1, r2, r3;
  r0.xy = (int2)v0.xy;                                                 // ftoi r0.xy, v0.xyxx
  r0.zw = float2(0, 0);
  r0.xyzw = sColorHDR.Load(r0.xyz);                                    // r0 is now HDR Color
  r1.xyzw = sColorAVG.Sample(samColorAVG_s, float2(0.5, 0.5)).xyzw;    // Exposure
  r2.xyz = lerp(r0.xyz, r0.xyz * r1.xyz, CUSTOM_EXPOSURE_ADAPTATION);  // Apply Exposure
  r3.xyz = r2.xyz * CONST_4.www + 1;                                   // Brightness
  r2.xyz = r3.xyz * r2.xyz;                                            // Contrast
  r3.xyz = r0.xyz * r1.xyz + 1;                                        // For Glow Threshold
  r0.xyz = -r1.xyz * fhdrglowthreshold + r0.xyz;                       // Subtract Glow Threshold
  r0.xyz = max(r0.xyz, 0.0);
  float3 untonemapped = r2.xyz / r3.xyz;                               // Reinhard,
  float3 untonemapped_sRGB = renodx::color::srgb::Decode(untonemapped);// my
  o0.xyz = saturate(untonemapped);                                     // beloved!
  o0.w = renodx::color::y::from::BT709(o0.rgb);                        // r0.x = dot(float3(0.2125, 0.7154, 0.0721), r0.xyz);
  //o0.w = min(r0.x, 1.0);                                             // Alpha channel clamp
  float4 vanilla = o0.xyzw;
  float3 tonemapped = renodx::tonemap::renodrt::NeutralSDR(untonemapped_sRGB);
  tonemapped = renodx::color::gamma::Encode(tonemapped, 2.2);
  if (RENODX_TONE_MAP_TYPE > 0.f) {
    o0.xyz = renodx::draw::ToneMapPass(untonemapped, vanilla.xyz, tonemapped);
  }
  else {
    o0 = vanilla;
  }
  o0.xyz = renodx::color::srgb::Decode(o0.xyz);
  return;
}