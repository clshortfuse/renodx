#include "./shared.h"

// ---- Created with 3Dmigoto v1.3.16 on Sat Oct 24 19:29:32 2026
// FSR1 RCAS (sharpen) final pass, after EASU 0x7194ED7A. Writes the swapchain.

cbuffer _Globals : register(b0)
{
  float4 FSRSourceSize : packoffset(c0);
  float4 FSRSourceRect : packoffset(c1);
  float4 FSRSharpness : packoffset(c2);
  float3 ColorScale : packoffset(c3);
  float4 OverlayColor : packoffset(c4);
}

SamplerState FSRSourceTexture_s : register(s0);
Texture2D<float4> FSRSourceTexture : register(t0);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8;
  uint4 bitmask, uiDest;
  float4 fDest;

  // An unbound injection buffer keeps the exact original shader path.
  bool has_config = shader_injection.layout_version == GEARS_INJECTION_LAYOUT_VERSION
      && RENODX_PEAK_WHITE_NITS > 0.f
      && RENODX_DIFFUSE_WHITE_NITS > 0.f && RENODX_GRAPHICS_WHITE_NITS > 0.f;
  bool use_hdr = has_config && RENODX_TONE_MAP_TYPE != GEARS_TONE_MAP_VANILLA;

  // RCAS limits its negative lobe so the sharpened result stays inside [0, 1].
  // The gamma 2.2 intermediate reaches pow(peak/ui_white, 1/2.2) in HDR, so use
  // that as the upper bound instead. This equals running vanilla RCAS on
  // color/range and scaling back; the lobe weight is otherwise unchanged.
  // RenderIntermediatePass already scales by Game/UI white, as in 0x29CCB91A.
  float range = 1.f;
  [branch]
  if (use_hdr) {
    range = max(1.f, pow(RENODX_PEAK_WHITE_NITS / RENODX_GRAPHICS_WHITE_NITS, 1.f / 2.2f));
  }

  r0.xy = FSRSourceSize.xy * v0.xy;
  r0.xy = floor(r0.xy);
  r0.zw = float2(0.5,1.5) + r0.xy;
  r0.zw = FSRSourceSize.zw * r0.zw;
  r0.zw = max(FSRSourceRect.xy, r0.zw);
  r0.zw = min(FSRSourceRect.zw, r0.zw);
  r1.xyzw = FSRSourceTexture.Sample(FSRSourceTexture_s, r0.zw).xyzw;
  r2.xyzw = float4(0.5,0.5,1.5,0.5) + r0.xyxy;
  r0.xyzw = float4(0.5,-0.5,-0.5,0.5) + r0.xyxy;
  r0.xyzw = FSRSourceSize.zwzw * r0.xyzw;
  r0.xyzw = max(FSRSourceRect.xyxy, r0.xyzw);
  r0.xyzw = min(FSRSourceRect.zwzw, r0.xyzw);
  r2.xyzw = FSRSourceSize.zwzw * r2.xyzw;
  r2.xyzw = max(FSRSourceRect.xyxy, r2.xyzw);
  r2.xyzw = min(FSRSourceRect.zwzw, r2.xyzw);
  r3.xyzw = FSRSourceTexture.Sample(FSRSourceTexture_s, r2.zw).xyzw;
  r2.xyzw = FSRSourceTexture.Sample(FSRSourceTexture_s, r2.xy).xyzw;
  r4.xyz = min(r3.xyz, r1.xyz);
  r5.xyzw = FSRSourceTexture.Sample(FSRSourceTexture_s, r0.xy).xyzw;
  r0.xyzw = FSRSourceTexture.Sample(FSRSourceTexture_s, r0.zw).xyzw;
  r6.xyz = min(r5.xyz, r0.xyz);
  r4.xyz = min(r6.xyz, r4.xyz);
  // Vanilla: r4.xyz * 4 - 4.
  r6.xyz = r4.xyz * float3(4,4,4) - 4.f * range;
  r4.xyz = min(r4.xyz, r2.xyz);
  r6.xyz = min(float3(-3.05175781e-005,-3.05175781e-005,-3.05175781e-005), r6.xyz);
  r7.xyz = max(r3.xyz, r1.xyz);
  r8.xyz = max(r5.xyz, r0.xyz);
  r0.xyz = r5.xyz + r0.xyz;
  r0.xyz = r0.xyz + r1.xyz;
  r0.xyz = r0.xyz + r3.xyz;
  r1.xyz = max(r8.xyz, r7.xyz);
  r3.xyz = max(r1.xyz, r2.xyz);
  r1.xyz = float3(4,4,4) * r1.xyz;
  r1.xyz = max(float3(3.05175781e-005,3.05175781e-005,3.05175781e-005), r1.xyz);
  r1.xyz = r4.xyz / r1.xyz;
  // Vanilla: 1 - max.
  r3.xyz = range - r3.xyz;
  r3.xyz = r3.xyz / r6.xyz;
  r1.xyz = max(r3.xyz, -r1.xyz);
  r0.w = max(r1.y, r1.z);
  r0.w = max(r1.x, r0.w);
  r0.w = min(0, r0.w);
  r0.w = max(-0.1875, r0.w);
  r0.w = FSRSharpness.x * r0.w;
  r0.xyz = r0.www * r0.xyz + r2.xyz;
  r0.w = r0.w * 4 + 1;
  r0.xyz = r0.xyz / r0.www;
  r1.xyz = ColorScale.xyz * r0.xyz;
  r0.xyz = -r0.xyz * ColorScale.xyz + OverlayColor.xyz;
  // Vanilla: saturate(OverlayColor.www * r0.xyz + r1.xyz).
  // Keep the color scale and fade; preserve highlights above UI white in HDR.
  o0.xyz = use_hdr ? max(0.f, OverlayColor.www * r0.xyz + r1.xyz)
                   : saturate(OverlayColor.www * r0.xyz + r1.xyz);
  o0.w = 1;
  return;
}
