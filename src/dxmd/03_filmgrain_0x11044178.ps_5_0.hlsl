// Film Grain

#include "../common/Open_DRT.hlsl"
#include "../common/aces.hlsl"
#include "../common/colorgrade.hlsl"
#include "../common/filmgrain.hlsl"
#include "./shared.h"

Texture2D<float4> t0 : register(t0);  // Render
Texture2D<float4> t1 : register(t1);  // Grain

SamplerState s0_s : register(s0);
SamplerState s1_s : register(s1);

cbuffer cb11 : register(b11) {
  float4 cb11[122];
}

// 3Dmigoto declarations
#define cmp -

void main(
  float4 v0 : SV_POSITION0,
              float4 v1 : TEXCOORD0,
                          float4 v2 : COLOR0,
                                      out float4 o0 : SV_TARGET0
) {
  float4 r0, r1;
  uint4 bitmask, uiDest;
  float4 fDest;

  if (injectedData.toneMapType == 0.f) {
    r0.xyzw = float4(-1, -1, -0.5, -0.5) + v1.xyyx;
    r0.xy = v1.yx * r0.yx;
    r0.xy = r0.xy * r0.wz;
    r0.xy = r0.xy * cb11[121].xy + v1.xy;
    r0.xyzw = t0.Sample(s1_s, r0.xy).xyzw;
    r1.x = dot(r0.xyz, float3(0.298038989, 0.588235974, 0.113724999));
    r1.x = -cb11[84].y + r1.x;
    r1.y = cb11[84].z + -cb11[84].y;
    r1.x = saturate(r1.x / r1.y);
    r1.x = 1 + -r1.x;
    r1.x = cb11[84].x * r1.x;
    r1.y = t1.Sample(s0_s, v1.zw).x;
    r1.x = saturate(-r1.y * r1.x + 1);
    r1.x = 0.5 * r1.x;
    r0.xyz = sqrt(r0.xyz);
    o0.w = r0.w;
    r0.xyz = r0.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
    r1.yzw = float3(1, 1, 1) + -abs(r0.xyz);
    r0.xyz = max(float3(0, 0, 0), r0.xyz);
    r0.xyz = r1.xxx * r1.yzw + r0.xyz;
    r0.xyz = v2.xyz * r0.xyz;
    r0.xyz = r0.xyz + r0.xyz;
    o0.xyz = sign(r0.xyz) * max(0, cb11[95].xyz * v2.www * injectedData.fxFilmGrain + abs(r0.xyz));
    o0.xyz = sign(o0.xyz) * pow(abs(o0.xyz), 2.2f);
    o0.xyz = applyUserColorGrading(
      o0.xyz,
      injectedData.colorGradeExposure,
      injectedData.colorGradeSaturation,
      injectedData.colorGradeShadows,
      injectedData.colorGradeHighlights,
      injectedData.colorGradeContrast
    );
  } else {
    r0.xyzw = t0.Sample(s1_s, v1.xy).xyzw;

    float3 outputColor = max(0, sqrt(r0.rgb));

    // Input is in gamma
    outputColor = pow(outputColor, 2.2f);

    outputColor = applyUserColorGrading(
      outputColor,
      injectedData.colorGradeExposure,
      injectedData.colorGradeSaturation,
      injectedData.colorGradeShadows,
      injectedData.colorGradeHighlights,
      injectedData.colorGradeContrast
    );

    const float vanillaMidGray = 0.18f;
    if (injectedData.toneMapType == 2.f) {
      const float ACES_MID_GRAY = 0.10f;
      float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / ACES_MID_GRAY);
      float hdrScale = (injectedData.toneMapPeakNits / paperWhite);
      outputColor = aces_rgc_rrt_odt(
        outputColor,
        0.0001f / (paperWhite / 48.f),
        48.f * hdrScale
      );
      outputColor /= 48.f;
      outputColor *= (vanillaMidGray / ACES_MID_GRAY);
    } else if (injectedData.toneMapType == 3.f) {
      const float OPENDRT_MID_GRAY = 11.696f / 100.f;
      float paperWhite = injectedData.toneMapGameNits * (vanillaMidGray / OPENDRT_MID_GRAY);
      float hdrScale = (injectedData.toneMapPeakNits / paperWhite);
      outputColor = mul(BT709_2_DISPLAYP3_MAT, outputColor);
      outputColor = max(0, outputColor);
      outputColor = open_drt_transform_bt709(
        outputColor,
        100.f * hdrScale,
        0,
        1.f,
        0
      );
      outputColor = mul(DISPLAYP3_2_BT709_MAT, outputColor);
      outputColor *= hdrScale;
      outputColor *= (vanillaMidGray / OPENDRT_MID_GRAY);
    }

    float3 grainedColor = computeFilmGrain(
      outputColor,
      v1.xy,
      frac(t1.Sample(s0_s, v1.zw).x / 1000.f),
      injectedData.fxFilmGrain * 0.03f,
      1.f
    );
    o0.xyz = grainedColor;
  }

  o0.xyz *= injectedData.toneMapGameNits / injectedData.toneMapUINits;
  o0.xyz = sign(o0.xyz) * pow(abs(o0.xyz), 1.f / 2.2f);

  o0.w = r0.w;
  return;
}
