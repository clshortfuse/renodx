#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 16 11:26:48 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[130];
}

// 3Dmigoto declarations
#define cmp -

// -----------------------------------------------------------------------------
// RenoDX UI config
// -----------------------------------------------------------------------------

#ifndef RENODX_UI_WHITE_NITS
#define RENODX_UI_WHITE_NITS RENODX_GRAPHICS_WHITE_NITS
#endif

#ifndef RENODX_DIFFUSE_WHITE_NITS
#define RENODX_DIFFUSE_WHITE_NITS 203.0
#endif

#ifndef RENODX_UI_BRIGHTNESS
#define RENODX_UI_BRIGHTNESS 1.0
#endif

#ifndef RENODX_UI_OPACITY_FIX
#define RENODX_UI_OPACITY_FIX 0
#endif

float3 ApplyRenoDXUIWhitePoint(float3 color)
{
  color = max(color, 0.0);

  // UI white scales relative to diffuse white, not peak white.
  // This lets the RenoDX UI white slider control this pass.
  float uiScale = RENODX_UI_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0);

  color *= uiScale;
  color *= RENODX_UI_BRIGHTNESS;

  return max(color, 0.0);
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  float4 v2 : COLOR0,
  out float4 o0 : SV_Target0)
{
  float4 r0;

  // Original shader logic:
  // texture green channel is used as the mask/alpha source.
  float textureMask = t0.Sample(s0_s, v1.xy).y;

  r0.x = v2.x;
  r0.y = v2.y;
  r0.z = v2.z;
  r0.w = v2.w * textureMask;

  // Original final UI transform.
  float4 uiColor = r0.xyzw * cb0[128].xyzw + cb0[129].xyzw;

  // Keep alpha valid.
  uiColor.w = saturate(uiColor.w);

  // Apply RenoDX UI white point to RGB only.
  uiColor.xyz = ApplyRenoDXUIWhitePoint(uiColor.xyz);

#if RENODX_UI_OPACITY_FIX
  // Enable only if transparent/masked UI edges glow too much.
  uiColor.xyz *= uiColor.w;
#endif

  o0.xyzw = uiColor;
  return;
}