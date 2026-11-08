#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Sun Oct 04 16:29:30 2026

cbuffer _Globals : register(b0)
{
  float4 PackedParameters : packoffset(c0);
  float2 MinMaxBlurClamp : packoffset(c1);
  float4 SceneShadowsAndDesaturation : packoffset(c2);
  float4 SceneInverseHighLights : packoffset(c3);
  float4 SceneMidTones : packoffset(c4);
  float4 SceneScaledLuminanceWeights : packoffset(c5);
  float4 GammaColorScaleAndInverse : packoffset(c6);
  float4 GammaOverlayColor : packoffset(c7);
}

SamplerState SceneColorTexture_s : register(s0);
SamplerState BlurredImage_s : register(s1);
Texture2D<float4> SceneColorTexture : register(t0);
Texture2D<float4> BlurredImage : register(t1);


// 3Dmigoto declarations
#define cmp -


void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  // An unbound injection buffer keeps the exact original shader path.
  bool has_config = shader_injection.layout_version == GEARS_INJECTION_LAYOUT_VERSION
      && RENODX_PEAK_WHITE_NITS > 0.f
      && RENODX_DIFFUSE_WHITE_NITS > 0.f && RENODX_GRAPHICS_WHITE_NITS > 0.f;
  bool use_hdr = has_config && RENODX_TONE_MAP_TYPE != GEARS_TONE_MAP_VANILLA;

  r0.xyzw = SceneColorTexture.Sample(SceneColorTexture_s, w0.xy).xyzw;
  r0.w = -PackedParameters.x + r0.w;
  r1.x = saturate(PackedParameters.y * abs(r0.w));
  r0.w = cmp(r0.w < 0);
  r0.w = r0.w ? MinMaxBlurClamp.x : MinMaxBlurClamp.y;
  r1.x = max(9.99999975e-005, r1.x);
  r1.x = log2(r1.x);
  r1.x = PackedParameters.z * r1.x;
  r1.x = exp2(r1.x);
  r0.w = min(r1.x, r0.w);
  r0.w = saturate(1 + -r0.w);
  r1.xyzw = BlurredImage.Sample(BlurredImage_s, v0.xy).xyzw;
  r1.xyz = float3(4,4,4) * r1.xyz;
  r1.w = r1.w * 4 + r0.w;
  r0.xyz = r0.xyz * r0.www + r1.xyz;
  r0.xyz = r0.xyz / r1.www;
  float3 ungraded_color = r0.xyz;
  [branch]
  if (use_hdr && RENODX_COLOR_GRADE_STRENGTH == 0.f) {
    // The authored grade has no contribution at zero strength. Keep the
    // fade overlay and color/gamma scale, which are presentation effects.
    r0.xyz = ungraded_color + GammaOverlayColor.xyz;
  } else {
    // Vanilla: saturate(-SceneShadowsAndDesaturation.xyz + r0.xyz).
    // Retain the shadow offset, but preserve values above SDR white for HDR.
    r0.xyz = use_hdr ? max(0.f, -SceneShadowsAndDesaturation.xyz + r0.xyz)
                    : saturate(-SceneShadowsAndDesaturation.xyz + r0.xyz);
    r0.xyz = SceneInverseHighLights.xyz * r0.xyz;
    r0.xyz = max(float3(9.99999975e-005,9.99999975e-005,9.99999975e-005), abs(r0.xyz));
    r0.xyz = log2(r0.xyz);
    r0.xyz = SceneMidTones.xyz * r0.xyz;
    r0.xyz = exp2(r0.xyz);
    r0.w = dot(r0.xyz, SceneScaledLuminanceWeights.xyz);
    if (use_hdr) {
      // Blend only the authored shadow/highlight/midtone/desaturation grade.
      // The game's fade overlay and gamma/color scale still apply at full strength.
      r0.xyz = lerp(ungraded_color,
          r0.xyz * SceneShadowsAndDesaturation.www + r0.www,
          RENODX_COLOR_GRADE_STRENGTH) + GammaOverlayColor.xyz;
    } else {
      r0.xyz = r0.xyz * SceneShadowsAndDesaturation.www + GammaOverlayColor.xyz;
      r0.xyz = r0.xyz + r0.www;
    }
  }
  // Vanilla: saturate(GammaColorScaleAndInverse.xyz * r0.xyz).
  r0.xyz = use_hdr ? max(0.f, GammaColorScaleAndInverse.xyz * r0.xyz)
                  : saturate(GammaColorScaleAndInverse.xyz * r0.xyz);
  r0.xyz = max(float3(9.99999975e-005,9.99999975e-005,9.99999975e-005), r0.xyz);
  r0.xyz = log2(r0.xyz);
  r0.xyz = GammaColorScaleAndInverse.www * r0.xyz;
  [branch]
  if (has_config) {
    // Preserve game gamma/brightness, then map the unclipped linear signal.
    // Encode for the original motion-blur pass; the proxy converts to scRGB/HDR10.
    // exp2(log_color) is positive; combine its gamma-2.2 decode into this
    // exponent instead of evaluating another exp and sign-preserving pow.
    o0.xyz = renodx::draw::RenderIntermediatePass(
        GearsToneMap(exp2(r0.xyz * 2.2f)));
  } else {
    o0.xyz = exp2(r0.xyz);
  }
  o0.w = 0;
  return;
}
