#include "./output.hlsli"

struct S_cbHDRResolve {
  float4 vParams;
  row_major float3x4 mContentToMonitor;
};

Texture2D<float4> mapTPC0 : register(t0);

RWTexture2D<float4> uavHDRResolveOutput : register(u0);

cbuffer _cbHDRResolve : register(b5) {
  S_cbHDRResolve cbHDRResolve : packoffset(c000.x);
};

[numthreads(8, 8, 1)]
void main(uint3 SV_DispatchThreadID : SV_DispatchThreadID) {
  uint2 pixel = SV_DispatchThreadID.xy;
  uavHDRResolveOutput[pixel] = EncodeOutputPQ(mapTPC0.Load(int3(pixel, 0)).rgb, cbHDRResolve.vParams);
}