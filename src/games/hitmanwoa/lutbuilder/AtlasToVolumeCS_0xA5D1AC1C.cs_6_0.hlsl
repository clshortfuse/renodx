#include "../common.hlsli"

Texture2D<float4> t0 : register(t0);

RWTexture3D<float4> u0 : register(u0);

[numthreads(4, 4, 4)]
void main(
    uint3 SV_DispatchThreadID: SV_DispatchThreadID,
    uint3 SV_GroupID: SV_GroupID,
    uint3 SV_GroupThreadID: SV_GroupThreadID,
    uint SV_GroupIndex: SV_GroupIndex) {
  uint _6 = (uint)(SV_DispatchThreadID.z) << 4;
  int _7 = _6 & 48;
  uint _8 = _7 + SV_DispatchThreadID.x;
  int _9 = (uint)(SV_DispatchThreadID.z) >> 2;
  uint _10 = _9 << 4;
  uint _11 = _10 + SV_DispatchThreadID.y;

  // LUT input has been changed to sRGB for better bit depth
  float4 color = t0.Load(int3(_8, _11, 0));

  u0[SV_DispatchThreadID] = color;
}
