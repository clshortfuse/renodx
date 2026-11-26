// ComputeHexDOF_CS: first hex-bokeh pass (vertical + diagonal 1D gathers) on the half-res colour/CoC.

#include "./shared.h"

Texture2D<float4> mapColCoC : register(t0);

RWTexture2D<float4> verticalOutput : register(u0);

RWTexture2D<float4> diagonalOutput : register(u1);

cbuffer _ComputeHexDOF : register(b0) {
  int4 g_vInOutSize : packoffset(c000.x);
  float4 g_vPixelScale : packoffset(c001.x);
  float4 g_vUvScale : packoffset(c002.x);
};

SamplerState MaterialSamplers[1920] : register(s0);

#include "./hex_dof.hlsli"

[numthreads(16, 8, 1)]
void main(
  uint3 SV_DispatchThreadID : SV_DispatchThreadID,
  uint3 SV_GroupID : SV_GroupID,
  uint3 SV_GroupThreadID : SV_GroupThreadID,
  uint SV_GroupIndex : SV_GroupIndex
) {
  if ((bool)((uint)(uint)(SV_DispatchThreadID.x) < (uint)g_vInOutSize.z) && (bool)((uint)(uint)(SV_DispatchThreadID.y) < (uint)g_vInOutSize.w)) {
    float4 _15 = mapColCoC.Load(int3((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y), 0));
    float _21 = _15.w * 2.0f;
    if (_15.w > 0.0f) {
      float _27 = (_15.w * -4.371138828673793e-08f) * g_vPixelScale.x;
      float _28 = g_vPixelScale.y * _15.w;
      float _31 = float((uint)SV_DispatchThreadID.x) + 0.5f;
      float _32 = float((uint)SV_DispatchThreadID.y) + 0.5f;
      float3 vertical = HexGatherAxis(mapColCoC, float2(_31, _32), float2(_27, _28), _15.w);
      verticalOutput[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(vertical, _15.w);
      float _132 = (_15.w * 0.8660253882408142f) * g_vPixelScale.x;
      float _133 = (_15.w * -0.5f) * g_vPixelScale.y;
      float3 diagonal = HexGatherAxis(mapColCoC, float2(_31, _32), float2(_132, _133), _15.w);
      diagonalOutput[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(diagonal + vertical, _21);
    } else {
      verticalOutput[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4(_15.x, _15.y, _15.z, _15.w);
      diagonalOutput[int2((uint)(SV_DispatchThreadID.x), (uint)(SV_DispatchThreadID.y))] = float4((_15.x * 2.0f), (_15.y * 2.0f), (_15.z * 2.0f), _21);
    }
  }
}
