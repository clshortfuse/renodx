// booklet

#include "./shared.h"

Texture2D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[5];
}

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
              float2 v1 : TEXCOORD0,
                          float2 w1 : TEXCOORD1,
                                      out float4 o0 : SV_Target0
) {
  const float4 icb[] = {
    { 0.624630,  0.543370, 0.827900, 0},
    {-0.134140, -0.944880, 0.954350, 0},
    { 0.387720, -0.434750, 0.582530, 0},
    { 0.121260, -0.192820, 0.227780, 0},
    {-0.203880,  0.111330, 0.232300, 0},
    { 0.831140, -0.292180, 0.881000, 0},
    { 0.107590, -0.578390, 0.588310, 0},
    { 0.282850,  0.790360, 0.839450, 0},
    {-0.366220,  0.395160, 0.538760, 0},
    { 0.755910,  0.219160, 0.787040, 0},
    {-0.526100,  0.023860, 0.526640, 0},
    {-0.882160, -0.244710, 0.915470, 0},
    {-0.488880, -0.293300, 0.570110, 0},
    { 0.440140, -0.085580, 0.448380, 0},
    { 0.211790,  0.513730, 0.555670, 0},
    { 0.054830,  0.957010, 0.958580, 0},
    {-0.590010, -0.705090, 0.919380, 0},
    {-0.800650,  0.246310, 0.837680, 0},
    {-0.194240, -0.184020, 0.267570, 0},
    {-0.436670,  0.767510, 0.883040, 0},
    { 0.216660,  0.116020, 0.245770, 0},
    { 0.156960, -0.856000, 0.870270, 0},
    {-0.758210,  0.583630, 0.956820, 0},
    { 0.992840, -0.029040, 0.993270, 0},
    {-0.222340, -0.579070, 0.620290, 0},
    { 0.550520, -0.669840, 0.867040, 0},
    { 0.464310,  0.281150, 0.542800, 0},
    {-0.072140,  0.605540, 0.609820, 0}
  };
  float4 r0, r1, r2, r3, r4, r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s1_s, w1.xy).xyzw;
  r1.xyzw = t1.Sample(s0_s, w1.xy).xyzw;
  r2.xy = cb0[3].xy * r1.ww;
  r2.xy = cb0[4].ww * r2.xy;
  r0.w = 0.25 * r1.w;
  r0.w = max(0.100000001, r0.w);
  r3.xyz = r1.xyz * r0.www;
  r4.xyz = r3.xyz;
  r2.z = r0.w;
  r2.w = 0;
  while (true) {
    r3.w = cmp((int)r2.w >= 28);
    if (r3.w != 0) break;
    r5.xy = icb[r2.w + 0].xy * r2.xy + w1.xy;
    r5.xyzw = t1.Sample(s0_s, r5.xy).xyzw;
    r3.w = -r1.w * icb[r2.w + 0].z + r5.w;
    r3.w = 0.264999986 + r3.w;
    r3.w = saturate(3.77358508 * r3.w);
    r4.w = r3.w * -2 + 3;
    r3.w = r3.w * r3.w;
    r5.w = r4.w * r3.w;
    r4.xyz = r5.xyz * r5.www + r4.xyz;
    r2.z = r4.w * r3.w + r2.z;
    r2.w = (int)r2.w + 1;
  }
  r0.w = 9.99999975e-06 + r2.z;
  r2.xyz = r4.xyz / r0.www;
  r0.w = -0.649999976 + r1.w;
  r0.w = saturate(4.99999905 * r0.w);
  r2.w = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r2.w * r0.w;
  r0.xyz = -r2.xyz + r0.xyz;
  r0.xyz = r0.www * r0.xyz + r2.xyz;
  r2.x = cmp(r1.w < 0.00999999978);
  r0.w = r1.w;
  o0.xyzw = r2.xxxx ? r1.xyzw : r0.xyzw;

  o0.rgb = pow(saturate(o0.rgb), 2.2f);
  o0.rgb *= injectedData.toneMapUINits / 80.f;
  return;
}
