#include "./output.hlsli"

struct S_cbHDRResolve {
  float4 vParams;
  float4 mContentToMonitor[3];
};

Texture2D<float4> mapTPC0 : register(t0);

cbuffer _cbHDRResolve : register(b5) {
  S_cbHDRResolve cbHDRResolve : packoffset(c000.x);
};

struct OutputSignature {
  float4 SV_Target : SV_Target;
  float4 SV_Target_1 : SV_Target1;
};

OutputSignature main(
    noperspective float4 SV_Position: SV_Position) {
  float4 SV_Target;
  float4 SV_Target_1;

  float paper_white = cbHDRResolve.vParams.z * cbHDRResolve.vParams.y * 10000.f;

  if (TONE_MAP_TYPE != 0.f) paper_white = RENODX_GRAPHICS_WHITE_NITS;

  float4 texture = mapTPC0.Load(int3(uint2(SV_Position.xy), 0));

  float3 texture_bt709 = renodx::color::gamma::DecodeSafe(texture.rgb, 2.2f);

  float3 texture_bt2020 = renodx::color::bt2020::from::BT709(texture_bt709);
  float3 texture_pq = renodx::color::pq::EncodeSafe(texture_bt2020, paper_white);
  
  float4 output = float4(texture_pq, 1.f);

  SV_Target = output;
  SV_Target_1 = output;

  OutputSignature output_signature = { SV_Target, SV_Target_1 };
  return output_signature;
}
