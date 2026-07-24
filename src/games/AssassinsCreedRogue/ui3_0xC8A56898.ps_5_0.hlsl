#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat May 16 11:26:48 2026
Texture2D<float4> t0 : register(t0);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0)
{
  float4 cb0[137];
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

  // UI white point is relative to diffuse white, not peak white.
  // This lets the RenoDX UI white slider control this pass.
  float uiScale = RENODX_UI_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0);

  color *= uiScale;
  color *= RENODX_UI_BRIGHTNESS;

  return max(color, 0.0);
}

void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(cb0[132].x == -1.000000);

  if (r0.x != 0)
  {
    r0.y = t0.Sample(s0_s, v1.xy).w;
    r0.x = 1;

    float4 uiColor = r0.xxxy * cb0[131].xyzw + cb0[129].xyzw;

    uiColor.w = saturate(uiColor.w);
    uiColor.xyz = ApplyRenoDXUIWhitePoint(uiColor.xyz);

#if RENODX_UI_OPACITY_FIX
    uiColor.xyz *= uiColor.w;
#endif

    o0.xyzw = uiColor;
    return;
  }

  r0.x = t0.Sample(s0_s, v1.xy).w;
  r0.x = 1 + -r0.x;

  r0.y = cmp(cb0[133].x != -1.000000);

  if (r0.y != 0)
  {
    r0.yz = cmp(cb0[133].zw != float2(0, 0));
    r0.y = (int)r0.z | (int)r0.y;

    if (r0.y != 0)
    {
      r0.yz = cb0[133].zw + v1.xy;
      r0.y = t0.Sample(s0_s, r0.yz).w;
      r0.y = 1 + -r0.y;
    }
    else
    {
      r0.y = r0.x;
    }

    r0.z = cmp(r0.y >= cb0[133].x);
    r0.w = cmp(r0.y < cb0[133].y);

    r1.x = cb0[133].y + -cb0[133].x;
    r0.y = -cb0[133].x + r0.y;
    r1.x = 1 / r1.x;

    r0.y = saturate(r1.x * r0.y);
    r1.x = r0.y * -2 + 3;
    r0.y = r0.y * r0.y;
    r0.y = r1.x * r0.y;

    r0.y = r0.w ? r0.y : 1;

    r1.xyz = cb0[135].xyz + -cb0[128].xyz;
    r1.xyz = r0.yyy * r1.xyz + cb0[128].xyz;
    r1.xyz = r0.zzz ? r1.xyz : cb0[128].xyz;
  }
  else
  {
    r1.xyz = cb0[128].xyz;
  }

  r0.y = cmp(cb0[132].x != cb0[132].y);
  r0.z = cb0[132].x + -cb0[132].y;
  r0.w = -cb0[132].y + r0.x;
  r0.z = 1 / r0.z;
  r0.z = saturate(r0.w * r0.z);

  r0.w = r0.z * -2 + 3;
  r0.z = r0.z * r0.z;
  r0.z = r0.w * r0.z;

  r0.w = cmp(cb0[132].y >= r0.x);
  r0.w = r0.w ? 1.000000 : 0;

  r1.w = r0.y ? r0.z : r0.w;

  r0.y = cmp(cb0[134].x != -1.000000);

  if (r0.y != 0)
  {
    r0.yz = cmp(cb0[134].zw != float2(0, 0));
    r0.y = (int)r0.z | (int)r0.y;

    if (r0.y != 0)
    {
      r0.yz = cb0[134].zw + v1.xy;
      r0.y = t0.Sample(s0_s, r0.yz).w;
      r0.x = 1 + -r0.y;
    }

    r0.y = cmp(cb0[134].y >= r0.x);
    r0.z = cmp(cb0[134].x < r0.x);

    r0.w = cb0[134].x + -cb0[134].y;
    r0.x = -cb0[134].y + r0.x;
    r0.w = 1 / r0.w;

    r0.x = saturate(r0.x * r0.w);
    r0.w = r0.x * -2 + 3;
    r0.x = r0.x * r0.x;
    r0.x = r0.w * r0.x;

    r2.w = r0.z ? r0.x : 1;
    r2.xyz = cb0[136].xyz;

    r3.xyzw = -r2.xyzw + r1.xyzw;
    r2.xyzw = r1.wwww * r3.xyzw + r2.xyzw;
    r1.xyzw = r0.yyyy ? r2.xyzw : r1.xyzw;
  }

  // Original final output.
  float4 uiColor = r1.xyzw * cb0[131].xyzw + cb0[129].xyzw;

  // Keep alpha valid.
  uiColor.w = saturate(uiColor.w);

  // Apply RenoDX UI white point to RGB only.
  uiColor.xyz = ApplyRenoDXUIWhitePoint(uiColor.xyz);

#if RENODX_UI_OPACITY_FIX
  // Enable only if this pass has glowing transparent edges.
  uiColor.xyz *= uiColor.w;
#endif

  o0.xyzw = uiColor;
  return;
}