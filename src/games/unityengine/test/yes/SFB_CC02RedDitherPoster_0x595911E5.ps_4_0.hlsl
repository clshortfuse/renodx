#include "../../shared.h"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  float4 v1 : SV_POSITION0,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { 0.002824, 0, 0, 0},
                              { -0.006588, 0, 0, 0},
                              { 0.000471, 0, 0, 0},
                              { -0.008940, 0, 0, 0},
                              { -0.011294, 0, 0, 0},
                              { -0.001880, 0, 0, 0},
                              { -0.013647, 0, 0, 0},
                              { -0.004235, 0, 0, 0},
                              { -0.000706, 0, 0, 0},
                              { -0.010118, 0, 0, 0},
                              { 0.001647, 0, 0, 0},
                              { -0.007765, 0, 0, 0},
                              { -0.014824, 0, 0, 0},
                              { -0.005412, 0, 0, 0},
                              { -0.012470, 0, 0, 0},
                              { -0.003059, 0, 0, 0} };
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = (uint2)w0.xy;
  r0.x = (uint)r0.x << 2;
  r0.xy = (int2)r0.xy & int2(12,3);
  r0.x = (int)r0.y + (int)r0.x;
  r1.xyzw = t0.Sample(s0_s, v0.xy).xyzw;
  r0.yzw = float3(1,1,1) + -r1.xyz;
  r2.yzw = -r0.yzw * float3(0.075000003,0.075000003,0.075000003) + r1.xyz;
  o0.w = r1.w;
  r0.y = 0.5 + -r2.y;
  r2.x = r0.y * 0.0299999993 + r2.y;
  r0.xyz = icb[r0.x+0].xxx + r2.xzw;
  r0.xyz = float3(16,16,16) * r0.xyz;
  r0.xyz = floor(r0.xyz);
  r0.xyz = float3(0.0625, 0.0625, 0.0625) * r0.xyz;
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    r0.xyz = saturate(r0.xyz);
  }
  o0.xyz = r0.xyz;
  return;
}