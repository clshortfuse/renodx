#include "./shared.h"

// Motion Blur - Reworked, it's different from vanilla
// It's here mostly to increase the sampling count and increase HDR highlights.
sampler2D FillSampler : register(s0);
sampler2D SceneSampler : register(s1);
float gBlurPower : register(c0);

#define SAMPLE_COUNT 24

float luminance(float3 rgb)
{
  return dot(rgb, float3(0.2126, 0.7152, 0.0722));
}

float4 main(float2 uv: TEXCOORD) : COLOR
{
  float4 centerColor = tex2D(SceneSampler, uv);
  float4 fillSample = tex2D(FillSampler, uv);

  // Correct 2D blur vector from ASM
  float2 dir;
  dir.x = -fillSample.y + fillSample.x;
  dir.y = -fillSample.w + fillSample.z;
  dir *= (gBlurPower * 6) * Custom_MotionBlur_Amount;

  float4 colorAccum = float4(0, 0, 0, 0);
  float weightAccum = 0.0;

  // Include center pixel
  float lumCenter = luminance(centerColor.rgb);
  float boost = pow(lumCenter + 0.01, Custom_MotionBlur_HDRBoost * 0.5);  // HDR boost factor
  colorAccum.rgb += centerColor.rgb * boost;
  weightAccum += boost;

  for (int i = 1; i <= SAMPLE_COUNT; ++i)
    {
    float t = (float)i / (SAMPLE_COUNT + 1);
    float2 offset = dir * t * float2(0.25, -0.25);

    // Negative sample
    float4 sNeg = tex2D(SceneSampler, uv - offset);
    float lumNeg = luminance(sNeg.rgb);
    float boostNeg = pow(lumNeg + 0.01, Custom_MotionBlur_HDRBoost * 0.5);
    colorAccum.rgb += sNeg.rgb * boostNeg;
    weightAccum += boostNeg;

    // Positive sample
    float4 sPos = tex2D(SceneSampler, uv + offset);
    float lumPos = luminance(sPos.rgb);
    float boostPos = pow(lumPos + 0.01, Custom_MotionBlur_HDRBoost * 0.5);
    colorAccum.rgb += sPos.rgb * boostPos;
    weightAccum += boostPos;
  }

  float4 finalColor;
  finalColor.rgb = colorAccum.rgb / weightAccum;
  finalColor.a = 1.0;
  return finalColor;
}