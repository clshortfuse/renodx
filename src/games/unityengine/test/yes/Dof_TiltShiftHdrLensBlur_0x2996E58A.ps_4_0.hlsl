#include "../../common.hlsli"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[6];
}

#define cmp -

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  float2 w1 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  const float4 icb[] = { { -0.326212, -0.405810, 0, 0},
                              { -0.840144, -0.073580, 0, 0},
                              { -0.695914, 0.457137, 0, 0},
                              { -0.203345, 0.620716, 0, 0},
                              { 0.962340, -0.194983, 0, 0},
                              { 0.473434, -0.480026, 0, 0},
                              { 0.519456, 0.767022, 0, 0},
                              { 0.185461, -0.893124, 0, 0},
                              { 0.507431, 0.064425, 0, 0},
                              { 0.896420, 0.412458, 0, 0},
                              { -0.321940, -0.932615, 0, 0},
                              { -0.791559, -0.597710, 0, 0} };
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = v1.xy * cb0[3].xy + cb0[3].zw;
  r0.xyzw = t0.Sample(s0_s, r0.xy).xyzw;
  r1.x = v1.y * 2 + -1;
  r1.x = cb0[5].y * r1.x;
  r1.x = min(cb0[5].x, abs(r1.x));
  r1.y = cmp(r1.x < 0.00999999978);
  if (r1.y != 0) {
    o0.xyzw = r0.xyzw;
    return;
  }
  r1.yz = cb0[2].xy * r1.xx;
  r2.xyz = r0.xyz;
  r0.w = 0;
  while (true) {
    r1.w = cmp((int)r0.w >= 12);
    if (r1.w != 0) break;
    r3.xy = icb[r0.w+0].xy * r1.yz + v1.xy;
    r3.xy = r3.xy * cb0[3].xy + cb0[3].zw;
    r3.xyzw = t0.SampleLevel(s0_s, r3.xy, 1).xyzw;
    r2.xyz = r3.xyz + r2.xyz;
    r0.w = (int)r0.w + 1;
  }
  r1.yzw = float3(0.0769230798,0.0769230798,0.0769230798) * r2.xyz;
  if (CUSTOM_COUNT_OLD == CUSTOM_COUNT_NEW) {
    r1.yzw = CUSTOM_GAMMA_SPACE != 0.f ? renodx::color::srgb::DecodeSafe(r1.yzw) : r1.yzw;
    r1.yzw = PostToneMapScale(r1.yzw, CUSTOM_GAMMA_SPACE != 0.f);
  }
  o0.xyzw = r1.yzwx;
  return;
}