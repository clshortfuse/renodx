#include "./antialiasing.hlsli"

// ---- Created with 3Dmigoto v1.3.16 on Sun Sep 22 01:42:57 2024

cbuffer cbDefaultXSC : register(b0) {
  float4x4 ViewProj : packoffset(c0);
  float4x4 ViewMatrix : packoffset(c4);
  float4x4 SecondaryProj : packoffset(c8);
  float4x4 SecondaryViewProj : packoffset(c12);
  float4x4 SecondaryInvViewProj : packoffset(c16);
  float4 ConstantColour : packoffset(c20);
  float4 Time : packoffset(c21);
  float4 CameraPosition : packoffset(c22);
  float4 InvProjectionParams : packoffset(c23);
  float4 SecondaryInvProjectionParams : packoffset(c24);
  float4 ShaderDebugParams : packoffset(c25);
  float4 ToneMappingDebugParams : packoffset(c26);
  float4 HDR_EncodeScale2 : packoffset(c27);
  float4 EmissiveSurfaceMultiplier : packoffset(c28);
  float4 AlphaLight_OffsetScale : packoffset(c29);
  float4 TessellationScaleFactor : packoffset(c30);
  float4 FogNearColour : packoffset(c31);
  float4 FogFarColour : packoffset(c32);
  float4 FogParams : packoffset(c33);
  float4 AdvanceEnvironmentShaderDebugParams : packoffset(c34);
  float4 SMAA_RTMetrics : packoffset(c35);
}

SamplerState LinearSampler_s : register(s0);
Texture2D<float4> colorTex : register(t0);
Texture2D<float4> blendTex : register(t6);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float4 v2: TEXCOORD1,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (CUSTOM_ALIAS_ISOLATION_TAA > 0.f) {
    uint width, height;
    colorTex.GetDimensions(width, height);

    o0.rgb = colorTex.SampleLevel(LinearSampler_s, v1.xy, 0).rgb;
    o0.rgb = renodx::color::gamma::DecodeSafe(o0.rgb);

    if (CUSTOM_SHARPENING > 0.f) {
      Lilium::RCAS::Neighborhood rcasSamples = Lilium::RCAS::SampleNeighborhood(o0.rgb, v1.xy, width, height, colorTex, LinearSampler_s);

      rcasSamples.b = renodx::color::gamma::DecodeSafe(rcasSamples.b);
      rcasSamples.d = renodx::color::gamma::DecodeSafe(rcasSamples.d);
      rcasSamples.f = renodx::color::gamma::DecodeSafe(rcasSamples.f);
      rcasSamples.h = renodx::color::gamma::DecodeSafe(rcasSamples.h);

      o0.rgb = rcasSamples.e;

      float normalization_value = (RENODX_TONE_MAP_TYPE == 0.f) ? 1.f : RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
      o0.rgb = Lilium::RCAS::ApplyCore(rcasSamples, CUSTOM_SHARPENING, normalization_value);
    }

    o0.rgb = ApplyCustomFilmGrain(o0.rgb, v1.xy);

    o0.rgb = renodx::color::gamma::EncodeSafe(o0.rgb);

    o0.w = 0;
    return;
  }

  r0.x = blendTex.Sample(LinearSampler_s, v2.xy).w;
  r0.y = blendTex.Sample(LinearSampler_s, v2.zw).y;
  r1.xy = blendTex.Sample(LinearSampler_s, v1.xy).xz;
  r0.zw = r1.yx;
  r1.z = dot(r0.xyzw, float4(1, 1, 1, 1));
  r1.z = cmp(r1.z < 9.99999975e-006);
  if (r1.z != 0) {
    r2.xyz = SampleLevelWithSRGBDecode(colorTex, LinearSampler_s, v1.xy, 0).rgb;
  } else {
    r1.xy = max(r0.xy, r1.yx);
    r1.x = cmp(r1.y < r1.x);
    r3.xz = r1.xx ? r0.xz : 0;
    r3.yw = r1.xx ? float2(0, 0) : r0.yw;
    r0.xy = r1.xx ? r0.xz : r0.yw;
    r0.z = dot(r0.xy, float2(1, 1));
    r0.xy = r0.xy / r0.zz;
    r1.xyzw = float4(1, 1, -1, -1) * SMAA_RTMetrics.xyxy;
    r1.xyzw = r3.xyzw * r1.xyzw + v1.xyxy;
    r3.xyz = SampleLevelWithSRGBDecode(colorTex, LinearSampler_s, r1.xy, 0).rgb;
    r1.xyz = SampleLevelWithSRGBDecode(colorTex, LinearSampler_s, r1.zw, 0).rgb;
    r0.yzw = r1.xyz * r0.yyy;
    r2.xyz = r0.xxx * r3.xyz + r0.yzw;
  }

  o0.rgb = r2.rgb;

  o0.rgb = ApplyCustomFilmGrain(o0.rgb, v1.xy);

  o0.rgb = WriteWithSRGBEncode(o0.rgb);
  o0.w = 0;
  return;
}
