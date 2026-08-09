#include "../../common.hlsl"

Texture2D<float4> t0 : register(t0);
SamplerState s0_s : register(s0);
cbuffer cb0 : register(b0){
  float4 cb0[23];
}

float3 vanillaUC2(float3 input){
static const float A = 0.22;  // Shoulder Strength
static const float B = 0.30;  // Linear Strength
static const float C = 0.10;  // Linear Angle
static const float D = 0.20;  // Toe Strength
static const float E = 0.01;  // Toe Numerator
static const float F = 0.30;  // Toe Denominator
  return renodx::tonemap::ApplyCurve(min(1000.f, input), A, B, C, D, E, F) * cb0[22].yyy;
}

float getLinearWhite(float x) {
static const float A = 0.22;  // Shoulder Strength
static const float B = 0.30;  // Linear Strength
static const float C = 0.10;  // Linear Angle
static const float D = 0.20;  // Toe Strength
static const float E = 0.01;  // Toe Numerator
static const float F = 0.30;  // Toe Denominator
  float part1 = ((B * C * F) - (B * E) - (B * F * x)) /
    (2.f * A * (E + F * x - F));
  float part2 = (sqrt((- (B * C * F) + (B * E) + (B * F * x)) * (- (B * C * F) + (B * E) + (B * F * x)) - (4.f * D * F * F * x * ((A * E) + (A * F * x) - (A * F))))) /
  (2.f * A * (E + F * x - F));
  return part1 - part2;
}

void main(
  float4 v0 : SV_POSITION0,
  float2 v1 : TEXCOORD0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = 0.25 * cb0[21].w;
  r1.xyzw = v1.xyxy * float4(2,2,2,2) + float4(-1,-1,-1,-1);
  r1.xyzw = cb0[20].wwzz * r1.xyzw;
  r0.y = dot(r1.xy, r1.xy);
  r0.z = dot(r1.zw, r1.zw);
  r0.yz = float2(1,1) + -r0.yz;
  r0.yz = max(float2(0,0), r0.yz);
  r0.z = r0.z * r0.z + -1;
  r0.z = cb0[20].y * r0.z + 1;
  r0.y = r0.y * r0.y;
  r0.y = -cb0[7].z * r0.y + cb0[7].z;
  r0.xw = r0.yy * r0.xx + v1.xy;
  r1.xyzw = t0.SampleLevel(s0_s, r0.xw, 0).xyzw;
  r1.xyz = float3(0.5,0.5,0) * r1.xyz;
  r2.xyzw = t0.SampleLevel(s0_s, v1.xy, 0).xyzw;
  r1.xyz = r2.xyz * float3(1,0,0) + r1.xyz;
  r0.x = cb0[21].w * r0.y;
  r0.yw = r0.yy * cb0[21].ww + v1.xy;
  r2.xyzw = t0.SampleLevel(s0_s, r0.yw, 0).xyzw;
  r3.xyzw = r0.xxxx * float4(0.5,0.5,0.75,0.75) + v1.xyxy;
  r4.xyzw = t0.SampleLevel(s0_s, r3.xy, 0).xyzw;
  r3.xyzw = t0.SampleLevel(s0_s, r3.zw, 0).xyzw;
  r0.xyw = r4.xyz * float3(0,1,0) + r1.xyz;
  r0.xyw = r3.xyz * float3(0,0.5,0.5) + r0.xyw;
  r0.xyw = r2.xyz * float3(0,0,1) + r0.xyw;
  r1.xyz = float3(2.0 / 3.0, 0.5, 2.0 / 3.0) * r0.xyw;
  r1.xyz = cb0[21].xyz * r1.xyz;
  r0.xyw = r0.xyw * float3(2.0 / 3.0, 0.5, 2.0 / 3.0) + -r1.xyz;
  r0.xyz = r0.zzz * r0.xyw + r1.xyz;
  r0.w = v1.y * 541.169983 + v1.x;
  r0.w = cb0[22].x + r0.w;
  r0.w = sin(r0.w);
  r0.w = r0.w * 273351.5 + -cb0[22].x;
  r0.w = frac(r0.w);
  r0.w = r0.w * 2 + -1;
  r0.w = cb0[20].x * r0.w;
  r0.xyz = r0.www * r0.xyz + r0.xyz;
  r0.xyz = cb0[17].xxx * r0.xyz;
  float midGray = vanillaUC2(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaUC2(r0.xyz);
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = min(3, injectedData.toneMapType);
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = injectedData.toneMapGammaCorrection;
  config.exposure = injectedData.colorGradeExposure;
  config.highlights = injectedData.colorGradeHighlights;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.saturation = injectedData.colorGradeSaturation;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_highlights = 1.02f;
  config.reno_drt_contrast = 1.12f;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 3.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? getLinearWhite(cb0[22].y) : injectedData.colorGradeClip;
  if (config.type == 0.f) {
    r0.xyz = saturate(hueCorrectionColor);
  }
  r0.xyz = renodx::tonemap::config::Apply(r0.xyz, config);
  if (injectedData.countOld == injectedData.countNew) {
  r0.xyz = PostToneMapScale(r0.xyz);
  }
  o0.xyz = r0.xyz;
  o0.w = 1;
  return;
}