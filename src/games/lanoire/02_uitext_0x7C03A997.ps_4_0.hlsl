// UI Textboxes

#include "./shared.h"

cbuffer RenderStuff2 : register(b2) {
  float4 DAGeomScale : packoffset(c7);
  float4 DOF_Clamp : packoffset(c8);
}

SamplerState Sampler0_s : register(s0);
Texture2D<float4> Texture0 : register(t0);

// 3Dmigoto declarations
#define cmp -

void main(float4 v0 : SV_Position0, float2 v1 : TEXCOORD0, out float4 o0 : SV_Target0) {
  float4 r0, r1, r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.w = 0;
  r1.w = DAGeomScale.w;
  r2.xyzw = Texture0.Sample(Sampler0_s, v1.xy).xyzw;
  r0.xyz = DOF_Clamp.xyz;
  r1.xyz = DAGeomScale.xyz * r2.xyz + -r0.xyz;
  o0.xyzw = r2.wwww * r1.xyzw + r0.xyzw;
  o0.xyzw = saturate(o0);

  o0 = saturate(o0);
  o0 = injectedData.toneMapGammaCorrection
           ? pow(o0, 2.2f)
           : renodx::color::bt709::from::SRGBA(o0);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
