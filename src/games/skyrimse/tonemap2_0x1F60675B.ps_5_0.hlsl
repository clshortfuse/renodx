#include "./shared.h"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);

SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);

cbuffer cb2 : register(b2) {
  float4 cb2[6];  // This variant has 6 elements, extra fade/tint
}

cbuffer cb12 : register(b12) {
  float4 cb12[45];
}

#define cmp -

void main(
    float4 v0: SV_POSITION0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xy = cb12[43].xy * v1.xy;
  r0.xy = max(float2(0, 0), r0.xy);
  r1.x = min(cb12[44].z, r0.x);
  r1.y = min(cb12[43].y, r0.y);
  r0.xyz = t1.Sample(s1_s, r1.xy).xyz;

  r0.w = cmp(0.5 < cb2[0].x);
  if (r0.w != 0) {
    r1.xyz = t0.Sample(s0_s, r1.xy).xyz;
  } else {
    r1.xyz = t0.Sample(s0_s, v1.xy).xyz;
  }

  r2.xy = t2.Sample(s2_s, v1.xy).xy;

  // ===== VANILLA PATH =====
  if (RENODX_TONE_MAP_TYPE == 0.f) {
    // Auto exposure
    float vLum = dot(float3(0.212500006, 0.715399981, 0.0720999986), r0.xyz);
    vLum = max(9.99999975e-006, vLum);
    float vLumAdjusted = vLum * r2.y / r2.x;

    // Two tonemap branches selected by cb2[2].z (filmic vs Reinhard)
    float vMapped;
    if (cb2[2].z > 0.5f) {
      // Filmic (Uncharted/Hable approximation): (x*(6.2x+0.5))/(x*(6.2x+1.7)+0.06), then ^2.2, then * cb2[2].y
      float fx = max(0.0f, vLumAdjusted - 0.00400000019f);
      float fNum = fx * (fx * 6.19999981f + 0.5f);
      float fDen = fx * (fx * 6.19999981f + 1.70000005f) + 0.0599999987f;
      float fRatio = fNum / fDen;
      fRatio = pow(fRatio, 2.20000005f);
      vMapped = cb2[2].y * fRatio;
    } else {
      // Extended Reinhard: x*(x*a+1)/(x+1)
      float rW = vLumAdjusted * cb2[2].y + 1.0f;
      float rNum = vLumAdjusted * rW;
      vMapped = rNum / (vLumAdjusted + 1.0f);
    }

    float scale = vMapped / vLum;
    r0.xyz = r0.xyz * scale;

    // Bloom
    float bloomMix = saturate(cb2[2].x - vMapped);
    r0.xyz = r1.xyz * bloomMix + r0.xyz;

    // Color grading (gamma space, vanilla)
    r1.x = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
    r0.w = 1;
    r0.xyzw = -r1.xxxx + r0.xyzw;
    r0.xyzw = cb2[3].xxxx * r0.xyzw + r1.xxxx;
    r1.xyzw = r1.xxxx * cb2[4].xyzw + -r0.xyzw;
    r0.xyzw = cb2[4].wwww * r1.xyzw + r0.xyzw;
    r0.xyzw = cb2[3].wwww * r0.xyzw + -r2.xxxx;
    r0.xyzw = cb2[3].zzzz * r0.xyzw + r2.xxxx;

    // Vanilla SDR finishing: saturate + gamma scale (cb12[42].x)
    r0.xyz = saturate(r0.xyz);
    r0.xyz = log2(max(r0.xyz, 1e-10));
    r0.xyz = cb12[42].xxx * r0.xyz;
    r0.xyz = exp2(r0.xyz);

    // Vanilla fade/tint blend (cb2[5]) — exclusive to this variant
    r1.xyzw = cb2[5].xyzw - r0.xyzw;
    r0.xyzw = cb2[5].wwww * r1.xyzw + r0.xyzw;

    // Push through swapchain pass for HDR scaling/encoding
    r0.xyz = renodx::color::gamma::DecodeSafe(r0.xyz);
    r0.xyz = renodx::color::bt2020::from::BT709(r0.xyz);
    r0.xyz = max(0, r0.xyz);
    r0.xyz = renodx::draw::RenderIntermediatePass(r0.xyz);

    o0.xyz = r0.xyz;
    o0.w = r0.w;
    return;
  }

  // ===== HDR PATH (RenoDRT / ACES / None) =====
  if (RENODX_TONE_MAP_TYPE == 1.f) {
  // Eye adaptation
  float lum = dot(float3(0.212500006, 0.715399981, 0.0720999986), r0.xyz);
  lum = max(9.99999975e-006, lum);
  float lumAdjusted = lum * r2.y / r2.x;
  r0.xyz = r0.xyz * lumAdjusted / lum;

  // Bloom
  const float bloomStrength = 0.0;
  // Bloom with clamped contribution to prevent black level lift
  float3 bloomColor = r1.xyz * saturate(cb2[2].x - renodx::color::y::from::BT709(r0.xyz));
  bloomColor = min(bloomColor, 0.5);  // TUNE: cap bloom so it can't lift blacks too much
  r0.xyz = bloomColor * bloomStrength + r0.xyz;

  r0.xyz = max(0, r0.xyz);

  // Tonemap
  renodx::draw::Config config = renodx::draw::BuildConfig();
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::HERMITE_SPLINE;
  r0.xyz = renodx::color::gamma::Decode(r0.xyz);
  r0.xyz = renodx::draw::ToneMapPass(r0.xyz, config);
  r0.xyz = renodx::color::gamma::Encode(r0.xyz);

  // Color grading
  r1.x = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
  r0.w = 1;
  float3 outputColor = r0.xyz;
  r0.xyzw = -r1.xxxx + r0.xyzw;
  r0.xyzw = cb2[3].xxxx * r0.xyzw + r1.xxxx;
  r1.xyzw = r1.xxxx * cb2[4].xyzw + -r0.xyzw;
  r0.xyzw = cb2[4].wwww * r1.xyzw + r0.xyzw;
  r0.xyzw = cb2[3].wwww * r0.xyzw + -r2.xxxx;
  r0.xyzw = cb2[3].zzzz * r0.xyzw + r2.xxxx;
  float gradeLuma = renodx::color::y::from::BT709(outputColor);
  float gradeStrength = RENODX_COLOR_GRADE_STRENGTH * saturate(1.0 - (gradeLuma - 0.8) / 0.5);
  r0.xyz = lerp(outputColor, r0.xyz, gradeStrength);

  // Linearize and encode
  r0.xyz = renodx::color::gamma::DecodeSafe(r0.xyz);
  r0.xyz = renodx::color::bt2020::from::BT709(r0.xyz);
  r0.xyz = max(0, r0.xyz);

  // Vanilla fade/tint blend — reduce strength to prevent washout
  float blendStrength = cb2[5].w * 0;  // TUNE: 0 = disable entirely, 1 = full vanilla
  float4 preBlend = float4(r0.xyz, r0.w);
  r1.xyzw = cb2[5].xyzw - preBlend;
  preBlend = blendStrength * r1.xyzw + preBlend;
  r0.xyz = preBlend.xyz;
  r0.w = preBlend.w;

  // Final output
  r0.xyz = renodx::draw::RenderIntermediatePass(r0.xyz);

  o0.xyz = r0.xyz;
  o0.w = r0.w;
  return;}
}