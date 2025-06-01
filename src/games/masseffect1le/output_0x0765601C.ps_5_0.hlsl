#include "./shared.h"

// ---- Created with 3Dmigoto v1.4.1 on Sat May 31 19:45:35 2025

cbuffer HDRParamsIn : register(b0) {
  struct
  {
    float MaxReconstructedNits;          // 1000
    float ReconstructedColorSaturation;  // 0
    float PaperWhiteNits;                // 250
    float UIBrightnessScale;             // 1/2.77777
    float DisplayGamma;                  // 2.2
    float HDRGamma;                      // 1.25
    float SoftShoulderStart2084;         // 0.5080784
    float MaxBrightnessOfDisplay2084;    // 0.7275278
    float MaxBrightnessOfScene2084;      // 0.7896337
    int bIsHDR10;                        // 0
    int bUseGamutExpansion;              // 1
    int Pad0;                            // 0
  }
HDRParameters:
  packoffset(c0);
}

//

SamplerState SourceTextureSampler_s : register(s0);
Texture2D<float4> SourceTexture : register(t0);

Texture2D<float4> RenderTexture : register(t3);

// 3Dmigoto declarations
#define cmp -

void main(
    float2 v0: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = HDRParameters.MaxReconstructedNits / HDRParameters.PaperWhiteNits;
  r0.xy = float2(9.99999975e-05, -0.999899983) + r0.xx;
  r0.x = r0.x / r0.y;
  r0.y = 0.5 * r0.x;
  r0.z = -0.5 + r0.x;
  r0.y = r0.y / r0.z;
  r0.y = 1 + -r0.y;
  r1.xyzw = SourceTexture.Sample(SourceTextureSampler_s, v0.xy).xyzw;

  if (RENODX_TONE_MAP_TYPE != 0.f) {
    o0 = float4(renodx::color::gamma::DecodeSafe(r1.rgb) * RENODX_GRAPHICS_WHITE_NITS / 80.f, 1.f);
    return;
  }

  r1.xyz = max(float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05), abs(r1.xyz));
  o0.w = r1.w;

  r1.xyz = log2(r1.xyz);
  r1.xyz = HDRParameters.DisplayGamma * r1.xyz;
  r1.xyz = exp2(r1.xyz);

  r1.w = dot(r1.xyz, float3(0.212670997, 0.715160012, 0.0721689984));
  r2.xyzw = r1.xyzw * r0.xxxx;
  r3.xyzw = -r1.xyzw + r0.xxxx;
  r2.xyzw = r2.xyzw / r3.xyzw;
  r0.xyzw = r2.xyzw + r0.yyyy;
  r2.xyzw = float4(1.00010002, 1.00010002, 1.00010002, 1.00010002) + -r1.xyzw;
  r2.xyzw = r1.xyzw / r2.xyzw;
  r3.xyzw = cmp(float4(0.5, 0.5, 0.5, 0.5) < r1.xyzw);
  r1.w = 9.99999975e-05 + r1.w;
  r1.xyz = r1.xyz / r1.www;
  r0.xyzw = r3.xyzw ? r0.xyzw : r2.xyzw;
  r1.xyz = r1.xyz * r0.www;
  r0.xyz = HDRParameters.ReconstructedColorSaturation * r0.xyz;
  r0.w = 1 + -HDRParameters.ReconstructedColorSaturation;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r0.w = max(r0.x, r0.y);
  r0.w = max(r0.w, r0.z);
  r0.w = -2 + r0.w;
  r0.w = saturate(0.125 * r0.w);
  r1.x = dot(float3(0.753844976, 0.198593006, 0.0475619994), r0.xyz);
  r1.y = dot(float3(0.0457456, 0.941776991, 0.0124771995), r0.xyz);
  r1.z = dot(float3(-0.00121054996, 0.0176040996, 0.983606994), r0.xyz);
  r1.xyz = r1.xyz * r0.www;
  r0.w = 1 + -r0.w;
  r2.x = dot(float3(0.627403975, 0.329281986, 0.0433136001), r0.xyz);
  r2.y = dot(float3(0.0457456, 0.941776991, 0.0124771995), r0.xyz);
  r2.z = dot(float3(-0.00121054996, 0.0176040996, 0.983606994), r0.xyz);
  r1.xyz = r0.www * r2.xyz + r1.xyz;
  r2.xy = HDRParameters.bUseGamutExpansion ? float2(1, 0) : float2(0, 1);
  r1.xyz = r2.xxx * r1.xyz;
  r3.x = dot(float3(0.627403975, 0.329281986, 0.0433136001), r0.xyz);
  r3.y = dot(float3(0.0690969974, 0.919539988, 0.0113612004), r0.xyz);
  r3.z = dot(float3(0.0163915996, 0.088013202, 0.895595014), r0.xyz);
  r0.xyz = r2.yyy * r3.xyz + r1.xyz;
  r1.xyz = log2(abs(r0.xyz));
  r1.xyz = HDRParameters.HDRGamma * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = float3(2, 2, 2) + -r0.xyz;
  r3.xyz = r2.xyz * r2.xyz;
  r2.xyz = saturate(r3.xyz * r2.xyz);
  r3.xyz = r2.xyz * r1.xyz;
  r2.xyz = float3(1, 1, 1) + -r2.xyz;
  r0.xyz = r0.xyz * r2.xyz + r3.xyz;
  r0.w = cmp(HDRParameters.HDRGamma >= 1);
  r0.xyz = r0.www ? r1.xyz : r0.xyz;
  r0.xyz = HDRParameters.PaperWhiteNits * r0.xyz;
  r0.xyz = float3(9.99999975e-05, 9.99999975e-05, 9.99999975e-05) * r0.xyz;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = float3(0.159301758, 0.159301758, 0.159301758) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = r0.xyz * float3(18.8515625, 18.8515625, 18.8515625) + float3(0.8359375, 0.8359375, 0.8359375);
  r0.xyz = r0.xyz * float3(18.6875, 18.6875, 18.6875) + float3(1, 1, 1);
  r0.xyz = r1.xyz / r0.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = float3(78.84375, 78.84375, 78.84375) * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.xyz = -HDRParameters.SoftShoulderStart2084 + r0.xyz;
  r0.w = HDRParameters.MaxBrightnessOfScene2084 + -HDRParameters.SoftShoulderStart2084;
  r1.xyz = saturate(r1.xyz / r0.www);
  r2.xyz = HDRParameters.MaxBrightnessOfDisplay2084 * r1.xyz;
  r3.xyz = float3(1, 1, 1) + -r1.xyz;
  r4.xyz = HDRParameters.MaxBrightnessOfDisplay2084 * r3.xyz + r2.xyz;
  r2.xyz = HDRParameters.SoftShoulderStart2084 * r3.xyz + r2.xyz;
  r1.xyz = r4.xyz * r1.xyz;
  r1.xyz = r2.xyz * r3.xyz + r1.xyz;
  r1.xyz = min(r1.xyz, r0.xyz);
  r2.xyz = cmp(HDRParameters.SoftShoulderStart2084 < r0.xyz);
  r0.xyz = r2.xyz ? r1.xyz : r0.xyz;
  r1.xyz = log2(abs(r0.xyz));
  r1.xyz = float3(0.0126833133, 0.0126833133, 0.0126833133) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r2.xyz = float3(-0.8359375, -0.8359375, -0.8359375) + r1.xyz;
  r1.xyz = -r1.xyz * float3(18.6875, 18.6875, 18.6875) + float3(18.8515625, 18.8515625, 18.8515625);
  r2.xyz = max(float3(0, 0, 0), r2.xyz);
  r1.xyz = r2.xyz / r1.xyz;
  r1.xyz = log2(abs(r1.xyz));
  r1.xyz = float3(6.27739477, 6.27739477, 6.27739477) * r1.xyz;
  r1.xyz = exp2(r1.xyz);
  r1.xyz = float3(125, 125, 125) * r1.xyz;
  r2.x = dot(float3(1.66049099, -0.58764112, -0.0728498995), r1.xyz);
  r2.y = dot(float3(-0.124550499, 1.13289988, -0.00834940001), r1.xyz);
  r2.z = dot(float3(-0.0181508008, -0.100578897, 1.11872971), r1.xyz);
  o0.xyz = HDRParameters.bIsHDR10 ? r0.xyz : r2.xyz;
  return;
}
