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
  OutputSignature output;
  output.SV_Target = EncodeOutputPQ(mapTPC0.Load(int3(uint2(SV_Position.xy), 0)).rgb, cbHDRResolve.vParams);
  output.SV_Target_1 = output.SV_Target;
  return output;
}
