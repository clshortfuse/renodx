#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sun Oct 04 17:16:26 2026

cbuffer _Globals : register(b0)
{
  float4 UMBMotionVectorScaleBias : packoffset(c0);
  float4 UMBVelocityToUV : packoffset(c1);
  float4 UMBUVClamp : packoffset(c2);
  float4 UMBColorScale : packoffset(c3);
  float4 UMBOverlayColor : packoffset(c4);
}

SamplerState UMBColorTexture_s : register(s0);
SamplerState UMBMotionVectorTexture_s : register(s1);
Texture2D<float4> UMBMotionVectorTexture : register(t0);
Texture2D<float4> UMBColorTexture : register(t1);

float4 SampleUpscaledColor(float2 uv, bool linear_dlss) {
  float4 color = UMBColorTexture.Sample(UMBColorTexture_s, uv);
  // Restore the game's gamma domain before averaging its five blur taps.
  [branch]
  if (linear_dlss) color.rgb = renodx::color::gamma::EncodeSafe(color.rgb, 2.2f);
  return color;
}

// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  bool has_config = shader_injection.layout_version == GEARS_INJECTION_LAYOUT_VERSION
      && RENODX_PEAK_WHITE_NITS > 0.f
      && RENODX_DIFFUSE_WHITE_NITS > 0.f && RENODX_GRAPHICS_WHITE_NITS > 0.f;
  bool linear_dlss = has_config && shader_injection.dlss_linear != 0.f;

  r0.xy = v0.xy * UMBMotionVectorScaleBias.xy + UMBMotionVectorScaleBias.zw;
  r0.xyzw = UMBMotionVectorTexture.Sample(UMBMotionVectorTexture_s, r0.xy).xyzw;
  r0.xyzw = UMBVelocityToUV.xyxy * r0.xyxy;
  r0.xyzw = max(-UMBVelocityToUV.zwzw, r0.xyzw);
  r0.xyzw = min(UMBVelocityToUV.zwzw, r0.xyzw);
  r1.xy = r0.zw / UMBVelocityToUV.zw;
  r1.x = dot(r1.xy, r1.xy);
  r0.xyzw = r1.xxxx * r0.xyzw;
  r0.zw = -r0.zw * float2(0.400000006,0.400000006) + v0.xy;
  r1.xy = r0.xy * float2(0.200000003,0.200000003) + r0.zw;
  r0.zw = max(UMBUVClamp.xy, r0.zw);
  r0.zw = min(UMBUVClamp.zw, r0.zw);
  r2.xyzw = SampleUpscaledColor(r0.zw, linear_dlss);
  r0.zw = max(UMBUVClamp.xy, r1.xy);
  r1.xy = r0.xy * float2(0.200000003,0.200000003) + r1.xy;
  r0.zw = min(UMBUVClamp.zw, r0.zw);
  r3.xyzw = SampleUpscaledColor(r0.zw, linear_dlss);
  r2.xyz = r3.xyz + r2.xyz;
  r0.zw = max(UMBUVClamp.xy, r1.xy);
  r1.xy = r0.xy * float2(0.200000003,0.200000003) + r1.xy;
  r0.xy = r0.xy * float2(0.200000003,0.200000003) + r1.xy;
  r1.xy = max(UMBUVClamp.xy, r1.xy);
  r1.xy = min(UMBUVClamp.zw, r1.xy);
  r1.xyzw = SampleUpscaledColor(r1.xy, linear_dlss);
  r0.xy = max(UMBUVClamp.xy, r0.xy);
  r0.xy = min(UMBUVClamp.zw, r0.xy);
  r3.xyzw = SampleUpscaledColor(r0.xy, linear_dlss);
  r0.xy = min(UMBUVClamp.zw, r0.zw);
  r0.xyzw = SampleUpscaledColor(r0.xy, linear_dlss);
  r0.xyz = r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  r0.xyz = r0.xyz + r3.xyz;
  r0.xyz = UMBColorScale.xyz * r0.xyz;
  r1.xyz = float3(0.200000003,0.200000003,0.200000003) * r0.xyz;
  r0.xyz = -r0.xyz * float3(0.200000003,0.200000003,0.200000003) + UMBOverlayColor.xyz;
  // Color is back in the mapped gamma domain. Preserve its highlight range
  // through the original blur/fade; the proxy handles scRGB.
  bool use_hdr = has_config && RENODX_TONE_MAP_TYPE != GEARS_TONE_MAP_VANILLA;
  o0.xyz = use_hdr ? max(0.f, UMBOverlayColor.www * r0.xyz + r1.xyz)
                  : saturate(UMBOverlayColor.www * r0.xyz + r1.xyz);
  [branch]
  if (use_hdr && linear_dlss) {
    // DLSS reconstruction can overshoot the already mapped input. Limit the
    // brightest channel by scaling RGB together, preserving its color ratios.
    // RenderIntermediatePass already scales scene by Game/UI white. The
    // proxy therefore measures this composite against UI white, not Game white.
    float encoded_peak = pow(RENODX_PEAK_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS, 1.f / 2.2f);
    float maximum = max(o0.x, max(o0.y, o0.z));
    o0.xyz *= min(1.f, encoded_peak / max(maximum, 1e-6f));
  }
  o0.w = 1;
  return;
}
