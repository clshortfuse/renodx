#include "./shared.h"

Texture2D<float4> g_xOcclusionTexture : register(t0);

Texture2D<float4> g_xFlareTexture : register(t1);

cbuffer AnamorphicConstants : register(b1) {
  float4 m_coronaScreenPosition : packoffset(c000.x);
  float4 m_widthMinMax : packoffset(c001.x);
  float4 m_heightMinMax : packoffset(c002.x);
  float4 m_fSampleSizes : packoffset(c003.x);
  float4 m_fColour : packoffset(c004.x);
  float4 mfTextureSize : packoffset(c005.x);
  float4 mfAlphaFallOff : packoffset(c006.x);
};

SamplerState g_xFilteredClamp : register(s7);

float4 main(
  noperspective float4 SV_Position : SV_Position,
  linear float2 TEXCOORD : TEXCOORD,
  linear float TEXCOORD_1 : TEXCOORD1
) : SV_Target {
  float4 SV_Target;
  float4 _8 = g_xOcclusionTexture.Sample(g_xFilteredClamp, float2(TEXCOORD.x, TEXCOORD.y));
  float4 _10 = g_xFlareTexture.Sample(g_xFilteredClamp, float2(TEXCOORD.x, TEXCOORD.y));
  float3 flare_rgb = _10.rgb;
  if (RENODX_TONE_MAP_TYPE != 0.f) {
    // RenoDX: the flare texture is 8-bit, so its dim tail spans only a few code values with
    // one-texel plateaus that show as banding rings. Blur the tail over one texel of the
    // sampled mip (at least 2 screen pixels) to hide them.
    float lod = max(0.f, g_xFlareTexture.CalculateLevelOfDetail(g_xFilteredClamp, TEXCOORD));
    uint width, height;
    g_xFlareTexture.GetDimensions(width, height);
    float2 pixel_uv = float2(length(float2(ddx(TEXCOORD.x), ddy(TEXCOORD.x))), length(float2(ddx(TEXCOORD.y), ddy(TEXCOORD.y))));
    float2 step_uv = max(exp2(lod) / float2(width, height), 2.f * pixel_uv);
    static const float kBlurWeights[5] = {1.f, 4.f, 6.f, 4.f, 1.f};
    float3 blurred = 0.f;
    for (int y = -2; y <= 2; y++) {
      for (int x = -2; x <= 2; x++) {
        blurred += g_xFlareTexture.SampleLevel(g_xFilteredClamp, TEXCOORD + float2(x, y) * step_uv, lod).rgb * (kBlurWeights[x + 2] * kBlurWeights[y + 2]);
      }
    }
    blurred /= 256.f;
    // RenoDX: keep the bright core sharp and smooth only the dim tail.
    float keep_sharp = smoothstep(0.008f, 0.05f, max(blurred.r, max(blurred.g, blurred.b)));
    flare_rgb = lerp(blurred, _10.rgb, keep_sharp);
    // RenoDX: fade to zero before the quad edge so the square border is not visible.
    flare_rgb *= 1.f - smoothstep(0.75f, 1.f, length(TEXCOORD - 0.5f) * 2.f);
  }
  SV_Target.xyz = m_fColour.xyz * flare_rgb;
  SV_Target.w = min(TEXCOORD_1, min(_8.x, _10.w));
  return SV_Target;
}
