// ---- Created with 3Dmigoto v1.2.45 on Mon Apr 27 20:42:06 2026
#include "../shared.h"
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb1 : register(b1)
{
  float4 cb1[1];
}

cbuffer cb0 : register(b0)
{
  float4 cb0[11];
}

// 3Dmigoto declarations
#define cmp -
Texture1D<float4> IniParams : register(t120);
Texture2D<float4> StereoParams : register(t125);


void main( 
  float4 v0 : SV_POSITION0,
  float4 v1 : COLOR0,
  float v2 : TEXCOORD0,
  float2 w2 : TEXCOORD1,
  float w2Scalar : TEXCOORD5,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(asint(cb0[10].y) == 1);
  r1.xyzw = t0.Sample(s0_s, w2.xy).xyzw;
  r1.xyzw = cb0[5].xyzw * r1.xyzw;
  r0.yzw = r1.xyz * v1.xyz + -cb1[0].xyz;
  r1.xyzw = v1.xyzw * r1.xyzw;
  r2.x = saturate(w2Scalar);
  r0.yzw = r2.xxx * r0.yzw + cb1[0].xyz;
  r1.xyz = r2.xxx * r1.xyz;
  o0.w = r1.w;
  o0.xyz = r0.xxx ? r1.xyz : r0.yzw;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    float highlight_strength = 1.33f;
    o0.rgb = float3(
        renodx::color::grade::Highlights(o0.r, highlight_strength),
        renodx::color::grade::Highlights(o0.g, highlight_strength),
        renodx::color::grade::Highlights(o0.b, highlight_strength)
    );
  };

  return;
}