#include "./shared.h"

Texture2D<float4> pTexture : register(t0);

cbuffer $Globals : register(b0) {
  float4 Curve : packoffset(c000.x);
};

SamplerState pTextureS : register(s0);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD
) : SV_Target {
  float4 SV_Target;
  float4 _11 = pTexture.Sample(pTextureS, float2(TEXCOORD.x, TEXCOORD.y));
  // SV_Target.x = (pow(_11.x, Curve.x));
  // SV_Target.y = (pow(_11.y, Curve.y));
  // SV_Target.z = (pow(_11.z, Curve.z));
  // SV_Target.w = (pow(_11.w, Curve.w));
  // SV_Target.rgb = renodx::color::gamma::DecodeSafe(_11.rgb);
  // SV_Target.w = renodx::color::gamma::DecodeSafe(_11.w);
  SV_Target = _11;
  SV_Target.rgb = renodx::draw::SwapChainPass(SV_Target.rgb);
  return SV_Target;
}
