#include "../../common.hlsl"

Texture2D<float4> t2 : register(t2);
Texture2D<float4> t1 : register(t1);
Texture2D<float4> t0 : register(t0);
SamplerState s2_s : register(s2);
SamplerState s1_s : register(s1);
SamplerState s0_s : register(s0);
cbuffer cb1 : register(b1){
  float4 cb1[7];
}
cbuffer cb0 : register(b0){
  float4 cb0[21];
}

float3 vanillaNarkACES(float3 color) {
  const float a = 2.51f;
  const float b = 0.03f;
  const float c = 2.43f;
  const float d = 0.59f;
  const float e = 0.14f;
  float3 exposed_color = cb0[6].xxx * color;
  return (exposed_color * (a * exposed_color + b)) / (exposed_color * (c * exposed_color + d) + e);
}

void main(
  float4 v0 : SV_POSITION0,
  float4 v1 : TEXCOORD0,
  float4 v2 : TEXCOORD1,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4,r5;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
  r1.xw = float2(0,0);
  r1.yz = cb0[2].yx;
  r2.xyz = v2.xyw + -r1.xyx;
  r2.xyzw = t1.SampleLevel(s1_s, r2.xy, r2.z).xyzw;
  r2.x = 1 + -r2.x;
  r2.yzw = v2.xyw + -r1.zww;
  r3.xyzw = t1.SampleLevel(s1_s, r2.yz, r2.w).xyzw;
  r2.y = 1 + -r3.x;
  r3.xyz = v2.xyw + r1.zww;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xy, r3.z).xyzw;
  r2.z = 1 + -r3.x;
  r3.xyz = v2.xyw + r1.xyx;
  r3.xyzw = t1.SampleLevel(s1_s, r3.xy, r3.z).xyzw;
  r2.w = 1 + -r3.x;
  r3.x = max(r2.w, r2.x);
  r3.x = max(r3.x, r2.y);
  r3.x = max(r3.x, r2.z);
  r2.x = min(r2.w, r2.x);
  r2.x = min(r2.x, r2.y);
  r2.x = min(r2.x, r2.z);
  r2.x = r3.x + -r2.x;
  r2.x = 9.99999975e-06 + r2.x;
  if (r2.x > cb0[20].y) {
    r3.xyzw = v1.xyxy + -r1.xyzw;
    r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
    r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
    r1.xyzw = v1.xyxy + r1.zwxy;
    r5.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
    r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
    r1.x = renodx::color::y::from::NTSC1953(r1.xyz);
    r1.y = renodx::color::y::from::NTSC1953(r5.xyz);
    r1.z = renodx::color::y::from::NTSC1953(r3.xyz);
    r1.w = renodx::color::y::from::NTSC1953(r4.xyz);
    r2.x = max(r1.x, r1.w);
    r2.x = max(r2.x, r1.z);
    r2.x = max(r2.x, r1.y);
    r2.z = min(r1.x, r1.w);
    r2.z = min(r2.z, r1.z);
    r2.z = min(r2.z, r1.y);
    r2.z = -9.99999997e-07 + r2.z;
    r3.xyzw = r1.wzwz + -r1.xyxy;
    r1.xyzw = cb0[20].xxxx * cb0[2].xyxy;
    r1.xyzw = r3.xyzw * r1.xyzw;
    r3.xyzw = r1.zwzw * float4(-0.166666672,-0.166666672,0.166666672,0.166666672) + v1.xyxy;
    r4.xyzw = t0.Sample(s0_s, r3.xy).xyzw;
    r3.xyzw = t0.Sample(s0_s, r3.zw).xyzw;
    r3.xyz = r4.xyz + r3.xyz;
    r4.xyz = float3(0.5,0.5,0.5) * r3.xyz;
    r1.xyzw = r1.xyzw * float4(-0.5,-0.5,0.5,0.5) + v1.xyxy;
    r5.xyzw = t0.Sample(s0_s, r1.xy).xyzw;
    r1.xyzw = t0.Sample(s0_s, r1.zw).xyzw;
    r1.xyz = r5.xyz + r1.xyz;
    r1.xyz = float3(0.25,0.25,0.25) * r1.xyz;
    r1.xyz = r3.xyz * float3(0.25,0.25,0.25) + r1.xyz;
    r1.w = renodx::color::y::from::NTSC1953(r1.xyz);
    r0.xyz = (r1.w < r2.z) || (r1.w > r2.x) ? r4.xyz : r1.xyz;
  }
  float midGray = vanillaNarkACES(float3(0.18f, 0.18f, 0.18f)).x;
  float3 hueCorrectionColor = vanillaNarkACES(r0.xyz);
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
  config.mid_gray_value = midGray;
  config.mid_gray_nits = midGray * 100;
  config.reno_drt_contrast = 1.6f;
  config.reno_drt_dechroma = injectedData.colorGradeDechroma;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.hue_correction_type = injectedData.toneMapPerChannel != 0.f ? renodx::tonemap::config::hue_correction_type::INPUT
                                                                     : renodx::tonemap::config::hue_correction_type::CUSTOM;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.hue_correction_color = lerp(r0.xyz, hueCorrectionColor, injectedData.toneMapHueShift);
  config.reno_drt_hue_correction_method = injectedData.toneMapHueProcessor;
  config.reno_drt_tone_map_method = injectedData.toneMapType == 4.f ? renodx::tonemap::renodrt::config::tone_map_method::REINHARD
                                                                    : renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
  config.reno_drt_working_color_space = 0;
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0.f;
  config.reno_drt_blowout = 1.f - injectedData.colorGradeBlowout;
  config.reno_drt_white_clip = injectedData.colorGradeClip == 0.f ? 8.0f / cb0[6].x : injectedData.colorGradeClip;
  if(injectedData.toneMapType == 0.f){
    r0.xyz = hueCorrectionColor;
  }
  if (injectedData.colorGradeUserLUTStrength == 0.f || config.type == 1.f) {
    r2.xzw = renodx::tonemap::config::Apply(r0.xyz, config);
  } else {
    renodx::tonemap::config::DualToneMap tone_maps = renodx::tonemap::config::ApplyToneMaps(r0.xyz, config);
    float3 sdrColor = tone_maps.color_sdr;
    float3 hdrColor = tone_maps.color_hdr;
  r0.xyz = sdrColor;
  r0.xyz = fastSrgbEncode(r0.xyz);
  r1.yzw = min(float3(1,1,1), r0.xyz);
  if(injectedData.colorGradeLUTSampling == 0.f){
  r1.x = -1 + cb0[4].w;
  r2.x = r1.w * r1.x;
  r1.yz = r1.yz * r1.xx + float2(0.5,0.5);
  r3.zw = cb0[4].xy * r1.yz;
  r1.y = floor(r2.x);
  r3.y = r1.y * cb0[4].y + r3.z;
  r3.x = cb0[4].y + r3.y;
  r4.xyzw = t2.Sample(s2_s, r3.yw).xyzw;
  r3.xyzw = t2.Sample(s2_s, r3.xw).xyzw;
  r1.x = r1.w * r1.x + -r1.y;
  r1.yzw = r3.xyz + -r4.xyz;
  r1.xyz = r1.xxx * r1.yzw + r4.xyz;
  } else {
    r1.xyz = renodx::lut::SampleTetrahedral(t2, r1.yzw, cb0[4].w);
  }
  if(injectedData.toneMapType == 0.f){
    r0.xyz = lerp(r0.xyz, r1.xyz, injectedData.colorGradeUserLUTStrength * cb0[9].w);
    r2.xzw = fastSrgbDecode(r0.xyz);
  } else {
    r1.xyz = fastSrgbDecodeSafe(r1.xyz);
    r1.xyz = RestoreSaturationLoss(sdrColor, r1.xyz);
    r1.xyz = renodx::tonemap::UpgradeToneMap(hdrColor, sdrColor, r1.xyz, injectedData.colorGradeUserLUTStrength);
    r1.xyz = lerp(renodx::color::srgb::EncodeSafe(hdrColor), renodx::color::srgb::EncodeSafe(r1.xyz), cb0[9].w);
    r2.xzw = renodx::color::srgb::DecodeSafe(r1.xyz);
  }
  }
  // vibrance
  r1.w = max(r2.z, r2.w);
  r1.w = max(r2.x, r1.w);
  r3.x = min(r2.z, r2.w);
  r3.x = min(r3.x, r2.x);
  if(injectedData.toneMapType != 0.f){
    r3.x = max(0.f, r3.x);
  }
  r1.w = saturate(-r3.x + r1.w);
  r1.w = 1 + -r1.w;
  r1.w = cb0[6].z * r1.w;
  r3.x = renodx::color::y::from::NTSC1953(r2.xzw);
  r0.xyz = r2.xzw + -r3.xxx;
  r0.xyz = r1.www * r0.xyz + float3(1,1,1);
  r0.xyz = r2.xzw * r0.xyz;
  // Tint
  r1.xyz = r0.xyz * cb0[10].xyz + -r0.xyz;
  r0.xyz = cb0[10].www * r1.xyz + r0.xyz;
  // contrast
  r0.xyz = float3(-0.5,-0.5,-0.5) + r0.xyz;
  r0.xyz = r0.xyz * cb0[6].yyy + float3(0.5,0.5,0.5);
  // dither
  r1.xy = cb1[6].xy * v1.xy;
  r1.x = dot(float2(171,231), r1.xy);
  r1.xyz = float3(0.00970873795,0.0140845068,0.010309278) * r1.xxx;
  r1.xyz = frac(r1.xyz);
  r1.xyz = float3(-0.5,-0.5,-0.5) + r1.xyz;
  r1.w = step(cb0[8].y, r2.y);
  r1.w = cb0[8].x * r1.w * injectedData.fxNoise;
  r1.xyz = r1.www * r1.xyz + float3(1,1,1);
  o0.xyz = r1.xyz * r0.xyz;
  if (injectedData.countOld == injectedData.countNew) {
    o0.xyz = PostToneMapScale(o0.xyz);
  }
  o0.w = saturate(r0.w);
  return;
}