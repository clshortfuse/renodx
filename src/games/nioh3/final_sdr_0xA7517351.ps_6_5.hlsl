#include "./common.hlsl"

Texture2D<float4> sScreen : register(t0);

cbuffer Globals : register(b0) {
  float4 vConfigParam : packoffset(c000.x);
};

SamplerState __smpsScreen : register(s0);

float4 main(noperspective float4 SV_Position: SV_Position,
            linear float2 TEXCOORD: TEXCOORD)
    : SV_Target {
  float4 SV_Target;
  float4 _6 = sScreen.Sample(__smpsScreen, float2(TEXCOORD.x, TEXCOORD.y));
  // _6.rgb = renodx::color::gamma::DecodeSafe(_6.rgb);
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.swap_chain_output_preset = renodx::draw::SWAP_CHAIN_OUTPUT_PRESET_SDR;
  SV_Target = renodx::draw::SwapChainPass(_6);
  return SV_Target;
  // SV_Target.x = (pow(_6.x, vConfigParam.x));
  // SV_Target.y = (pow(_6.y, vConfigParam.x));
  // SV_Target.z = (pow(_6.z, vConfigParam.x));
  // SV_Target.w = _6.w;
  // return SV_Target;
}
