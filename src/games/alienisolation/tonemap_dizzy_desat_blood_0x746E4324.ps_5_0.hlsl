#include "./tonemap.hlsl"

SamplerState SamplerLowResCapture_SMP_s : register(s5);
SamplerState SamplerFrameBuffer_SMP_s : register(s6);
SamplerState SamplerDistortion_SMP_s : register(s7);
SamplerState SamplerBloomMap0_SMP_s : register(s8);
SamplerState SamplerQuarterSizeBlur_SMP_s : register(s9);
SamplerState SamplerColourLUT_SMP_s : register(s10);
SamplerState SamplerNoise_SMP_s : register(s12);
SamplerState SamplerToneMapCurve_SMP_s : register(s14);
SamplerState SamplerOverlay_SMP_s : register(s15);
Texture2D<float4> SamplerLowResCapture_TEX : register(t5);
Texture2D<float4> SamplerFrameBuffer_TEX : register(t6);
Texture2D<float4> SamplerDistortion_TEX : register(t7);
Texture2D<float4> SamplerBloomMap0_TEX : register(t8);
Texture2D<float4> SamplerQuarterSizeBlur_TEX : register(t9);
Texture3D<float4> SamplerColourLUT_TEX : register(t10);
Texture2D<float4> SamplerNoise_TEX : register(t12);
Texture2D<float4> SamplerToneMapCurve_TEX : register(t14);
Texture2D<float4> SamplerOverlay_TEX : register(t15);

// 3Dmigoto declarations
#define cmp -

float3 renderPostFX(float4 v0, float4 v1) {
  float4 r0, r1, r2, r3;

  // motion blur?
  r0.xyzw = SamplerDistortion_TEX.Sample(SamplerDistortion_SMP_s, v0.xy).xyzw;
  r0.xy = r0.xy + -r0.zw;
  r0.zw = rp_parameter_ps[1].xy * r0.xy;
  r0.xy = r0.xy * rp_parameter_ps[1].xy + v0.xy;
  r0.xy = min(ScreenResolution[1].xy, r0.xy);
  r1.x = rp_parameter_ps[9].y + rp_parameter_ps[0].z;
  r1.x = cmp(0 < r1.x);
  if (r1.x != 0) {
    r1.x = 1 + rp_parameter_ps[0].z;
    r1.xy = r0.zw * r1.xx + v0.xy;
    r2.x = 1 + -rp_parameter_ps[0].z;
    r1.zw = r0.zw * r2.xx + v0.xy;
    r0.zw = v0.xy * float2(2, 2) + float2(-1, -1);
    r2.x = dot(r0.zw, r0.zw);
    r2.x = cmp(9.99999975e-005 < r2.x);
    r3.xy = r0.zw * rp_parameter_ps[9].yy + r1.xy;
    r3.zw = -r0.zw * rp_parameter_ps[9].yy + r1.zw;
    r1.xyzw = r2.xxxx ? r3.xyzw : r1.xyzw;
    r2.x = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, r1.xy, 0).x;
    r2.y = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, r0.xy, 0).y;
    r2.z = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, r1.zw, 0).z;
  } else {
    r2.xyz = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, r0.xy, 0).xyz;
  }
  r1.xyz = HDR_EncodeScale.www * r2.xyz;
  r2.xyzw = SamplerQuarterSizeBlur_TEX.Sample(SamplerQuarterSizeBlur_SMP_s, r0.xy).xyzw;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = HDR_EncodeScale2.zzz * r2.xyz;
  r0.z = sqrt(r2.w);
  r0.z = rp_parameter_ps[3].x * r0.z;
  r2.xyz = r2.xyz * float3(4, 4, 4) + -r1.xyz;
  r1.xyz = r0.zzz * r2.xyz + r1.xyz;

  r1.rgb = ApplyBloom(r1.rgb, r0.xy, SamplerBloomMap0_TEX, SamplerBloomMap0_SMP_s);

  // damage dizzy effect
  r0.xyzw = SamplerLowResCapture_TEX.Sample(SamplerLowResCapture_SMP_s, r0.xy).xyzw;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = HDR_EncodeScale2.zzz * r0.xyz;
  r0.xyz = r0.xyz * float3(8, 8, 8) + -r1.xyz;
  r0.xyz = rp_parameter_ps[10].www * r0.xyz + r1.xyz;
  // end damage dizzy

  return r0.xyz;
}

float3 applyToneMap(float3 untonemapped, float untonemappedLum, float4 v1, float4 v2) {
  float3 r0 = untonemapped;

  float3 outputColor = r0.xyz;
  if (injectedData.toneMapType == 0) {  // tonemap
    r0.xyz = ApplyVanillaTonemap(untonemapped, untonemappedLum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);
    r0.xyz = applyVignette(r0.rgb, v2, v1, untonemappedLum);
    r0.xyz = ApplyLUT(r0.rgb, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);

    outputColor = r0.xyz;
  } else if (injectedData.toneMapType > 1.f) {
    const float vanilla_mid_gray = renodx::color::y::from::BT709(ApplyVanillaTonemap(0.18, untonemappedLum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s));
    renodx::tonemap::config::DualToneMap dual_tone_map = ToneMap(untonemapped, vanilla_mid_gray);

    float3 vignette_hdr = applyVignette(dual_tone_map.color_hdr, v2, v1, untonemappedLum);
    float3 vignette_sdr = applyVignette(dual_tone_map.color_sdr, v2, v1, untonemappedLum);
    float3 lut_output_color = ApplyLUT(vignette_sdr, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);

    outputColor = UpgradeToneMap(vignette_hdr, vignette_sdr, lut_output_color, 1.f);

    if (injectedData.toneMapHueShift || injectedData.toneMapBlend) {
      float3 vanilla_color = ApplyVanillaTonemap(untonemapped, untonemappedLum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);
      vanilla_color = applyVignette(vanilla_color, v2, v1, untonemappedLum);
      vanilla_color = ApplyLUT(vanilla_color, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);
      if (injectedData.toneMapHueShift) {
        outputColor = renodx::color::correct::Hue(outputColor, vanilla_color, injectedData.toneMapHueShift);
      }
      if (injectedData.toneMapBlend) outputColor = ToneMapBlend(outputColor, vanilla_color);
    }
  }

  return outputColor;
}

float3 applyDesaturation(float3 inputColor) {
  float3x4 desatMatrix = float3x4(rp_parameter_ps[4].xyzw, rp_parameter_ps[5].xyzw, rp_parameter_ps[6].xyzw);
  float3 outputColor = mul(float4(inputColor, 1.0), transpose(desatMatrix));
  return max(0, outputColor);  // needed to fix bad gradients
}

float3 applyBloodOverlay(float3 inputColor, float4 v0) {
  float4 r1;
  float4 r0;
  r0.rgb = inputColor;

  r1.xyzw = SamplerOverlay_TEX.Sample(SamplerOverlay_SMP_s, v0.xy).xyzw;
  r0.w = rp_parameter_ps[10].x + -rp_parameter_ps[9].w;
  r0.w = rp_parameter_ps[9].z * r0.w + rp_parameter_ps[9].w;
  r0.w = r1.w + -r0.w;
  r1.w = 1 / rp_parameter_ps[10].y;
  r0.w = saturate(r1.w * r0.w);
  r1.w = r0.w * -2 + 3;
  r0.w = r0.w * r0.w;
  r0.w = r1.w * r0.w;
  r0.w = min(1, r0.w);
  r0.w = rp_parameter_ps[10].z * r0.w;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = r0.www * r1.xyz + r0.xyz;

  return r0.xyz;
}

void main(
    float4 v0: TEXCOORD0,
    float4 v1: TEXCOORD1,
    float4 v2: SV_Position0,
    out float4 o0: SV_Target0) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.xyz = renderPostFX(v0, v1);

  float3 untonemapped = r0.xyz;
  const float untonemappedLum = renodx::color::luma::from::BT601(untonemapped);  // save for reuse

  float3 outputColor = applyToneMap(untonemapped, untonemappedLum, v1, v2);

  outputColor = applyDesaturation(outputColor);
  // ignore user gamma, force 2.2
  r0.xyz = renodx::color::gamma::EncodeSafe(outputColor, 2.2f);  //  r0.xyz = pow(r0.xyz, OutputGamma.xxx);

  // film grain
  r0.rgb = applyFilmGrain(r0.rgb, SamplerNoise_TEX, SamplerNoise_SMP_s, v1);

  r0.xyz = applyBloodOverlay(r0.xyz, v0);

  r0.xyz = (r0.xyz * rp_parameter_ps[0].xxx + rp_parameter_ps[0].yyy);  // r0.xyz = saturate(r0.xyz * rp_parameter_ps[0].xxx + rp_parameter_ps[0].yyy);
  o0.w = dot(r0.xyz, float3(0.298999995, 0.587000012, 0.114));
  o0.xyz = r0.xyz;

  return;
}
