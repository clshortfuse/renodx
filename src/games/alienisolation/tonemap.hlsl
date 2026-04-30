#include "./common.hlsl"
#include "./include/CBuffer_DefaultPSC.hlsl"
#include "./include/CBuffer_DefaultXSC.hlsl"
#include "./include/CBuffer_UbershaderXSC.hlsl"
#include "./psycho_test17_custom.hlsli"

// 3Dmigoto declarations
#define cmp -

/// EXTRAPOLATION

static const float VANILLA_TM_PIVOT = 0.1f;
static const float VANILLA_TM_LUT_TEXEL_U = 1.f / 128.f;
static const float VANILLA_TM_DELTA = VANILLA_TM_PIVOT * (exp(16.f * VANILLA_TM_LUT_TEXEL_U) - exp(-16.f * VANILLA_TM_LUT_TEXEL_U)) * 0.5f;

struct VanillaToneMapExtrapolation {
  float pivot_x;
  float pivot_y;
  float slope;
};

float SampleVanillaToneMapCurve(
    float value,
    Texture2D<float4> SamplerToneMapCurve_TEX,
    SamplerState SamplerToneMapCurve_SMP_s) {
  float u = saturate((log2(value) * 0.693147182f + 12.f) * 0.0625f);
  return SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, float2(u, 0.25f), 0).x;
}

float SampleVanillaToneMapCurveExtrapolated(
    float value,
    VanillaToneMapExtrapolation extrapolation,
    Texture2D<float4> SamplerToneMapCurve_TEX,
    SamplerState SamplerToneMapCurve_SMP_s) {
  if (value <= extrapolation.pivot_x) {
    return SampleVanillaToneMapCurve(
        value,
        SamplerToneMapCurve_TEX,
        SamplerToneMapCurve_SMP_s);
  }

  return max(0.f, extrapolation.pivot_y + extrapolation.slope * (value - extrapolation.pivot_x));
}

VanillaToneMapExtrapolation GetVanillaToneMapExtrapolation(
    Texture2D<float4> SamplerToneMapCurve_TEX,
    SamplerState SamplerToneMapCurve_SMP_s) {
  VanillaToneMapExtrapolation extrapolation;

  float x_minus = VANILLA_TM_PIVOT - VANILLA_TM_DELTA;
  float x_plus = VANILLA_TM_PIVOT + VANILLA_TM_DELTA;

  float y_minus = SampleVanillaToneMapCurve(
      x_minus,
      SamplerToneMapCurve_TEX,
      SamplerToneMapCurve_SMP_s);
  float y0 = SampleVanillaToneMapCurve(
      VANILLA_TM_PIVOT,
      SamplerToneMapCurve_TEX,
      SamplerToneMapCurve_SMP_s);
  float y_plus = SampleVanillaToneMapCurve(
      x_plus,
      SamplerToneMapCurve_TEX,
      SamplerToneMapCurve_SMP_s);

  extrapolation.pivot_x = VANILLA_TM_PIVOT;
  extrapolation.pivot_y = y0;
  extrapolation.slope = (y_plus - y_minus) / (x_plus - x_minus);

  return extrapolation;
}

float GetVanillaHighlightDesatPower(float mapped_luma) {
  float desat_luma = saturate(mapped_luma);
  return max(10e-6f, 1.f - desat_luma * desat_luma);
}

float3 ApplyVanillaChromaCurveClampedDesat(
    float3 untonemapped,
    float untonemapped_luminance,
    float mapped_luma,
    float branch_mapped_luma) {
  float safe_luma = max(10e-5f, untonemapped_luminance);
  float3 positive_color = max(0.f, untonemapped);

  float3 ratio = positive_color / safe_luma;

  // apply desaturation, but limited to not exceed amount at branching point
  float chroma_power = max(
      GetVanillaHighlightDesatPower(mapped_luma),
      GetVanillaHighlightDesatPower(branch_mapped_luma));

  return pow(ratio, chroma_power) * mapped_luma;
}

float3 ApplyVanillaToneMapDebug(float3 color, float metric) {
  float4 debug_color = 0.f;

  if (metric < ToneMappingDebugParams.x) {
    debug_color = float4(0, 0, 1, 1);
  }

  if (ToneMappingDebugParams.y < metric) {
    debug_color = float4(1, 0, 0, 1);
  }

  return lerp(color, debug_color.rgb, ToneMappingDebugParams.z * debug_color.a);
}

float3 ApplyVanillaTonemapExtrapolated(
    float3 untonemapped,
    float untonemapped_luminance,
    float2 pixel_position,
    Texture2D<float4> SamplerToneMapCurve_TEX,
    SamplerState SamplerToneMapCurve_SMP_s) {
  VanillaToneMapExtrapolation extrapolation =
      GetVanillaToneMapExtrapolation(SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);

  float mapped_luma = SampleVanillaToneMapCurveExtrapolated(
      untonemapped_luminance,
      extrapolation,
      SamplerToneMapCurve_TEX,
      SamplerToneMapCurve_SMP_s);

  float3 luma_tonemap = ApplyVanillaChromaCurveClampedDesat(
      untonemapped,
      untonemapped_luminance,
      mapped_luma,
      extrapolation.pivot_y);

  luma_tonemap = ApplyVanillaToneMapDebug(
      luma_tonemap,
      sqrt(mapped_luma));

  float3 per_channel_tonemap;
  per_channel_tonemap.r = SampleVanillaToneMapCurveExtrapolated(
      untonemapped.r,
      extrapolation,
      SamplerToneMapCurve_TEX,
      SamplerToneMapCurve_SMP_s);
  per_channel_tonemap.g = SampleVanillaToneMapCurveExtrapolated(
      untonemapped.g,
      extrapolation,
      SamplerToneMapCurve_TEX,
      SamplerToneMapCurve_SMP_s);
  per_channel_tonemap.b = SampleVanillaToneMapCurveExtrapolated(
      untonemapped.b,
      extrapolation,
      SamplerToneMapCurve_TEX,
      SamplerToneMapCurve_SMP_s);

  float per_channel_metric =
      sqrt(renodx::color::luma::from::BT601(per_channel_tonemap));

  per_channel_tonemap = ApplyVanillaToneMapDebug(
      per_channel_tonemap,
      per_channel_metric);

  float3 output_color = lerp(luma_tonemap, per_channel_tonemap, ToneMappingDebugParams.w);

#if 0
  renodx::canvas::Context canvas = renodx::canvas::CreateContext(
      pixel_position,
      float2(16.f, 16.f),
      float2(36.f, 36.f),
      output_color,
      0.f,
      float3(0.f, 1.f, 0.25f));

  renodx::canvas::DrawText(canvas, 'p', 'x', ':');
  renodx::canvas::DrawFloat(canvas, extrapolation.pivot_x, 1.f, 4.f);
  renodx::canvas::NewLine(canvas);
  renodx::canvas::DrawText(canvas, 'p', 'y', ':');
  renodx::canvas::DrawFloat(canvas, extrapolation.pivot_y, 1.f, 4.f);
  renodx::canvas::NewLine(canvas);
  renodx::canvas::DrawText(canvas, 's', 'l', 'o', 'p', 'e', ':');
  renodx::canvas::DrawFloat(canvas, extrapolation.slope, 1.f, 4.f);

  output_color = renodx::canvas::GetOutput(canvas).rgb;
#endif

  return output_color;
}

/// END EXTRAPOLATION

// ============================ VANILLA FUNCTIONS ============================
void GetSceneColorAndTexCoord(
    Texture2D<float4> SamplerDistortion_TEX,
    SamplerState SamplerDistortion_SMP_s,
    Texture2D<float4> SamplerFrameBuffer_TEX,
    SamplerState SamplerFrameBuffer_SMP_s,
    float4 v0,
    out float3 scene_color,
    out float2 tex_coord) {
  float4 r0, r1, r3;
  float3 r2;

  r0.xyzw = SamplerDistortion_TEX.Sample(SamplerDistortion_SMP_s, v0.xy).xyzw;
  r0.xy = r0.xy + -r0.zw;
  r0.zw = rp_parameter_ps[1].xy * r0.xy;
  r0.xy = r0.xy * rp_parameter_ps[1].xy + v0.xy;
  r0.xy = min(ScreenResolution[1].xy, r0.xy);
  r1.x = rp_parameter_ps[9].y + rp_parameter_ps[0].z;
  r1.x = cmp(0 < r1.x);
  if (r1.x != 0) {  // chromatic aberration on
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
  } else {  // chromatic aberration off
    r2.xyz = SamplerFrameBuffer_TEX.SampleLevel(SamplerFrameBuffer_SMP_s, r0.xy, 0).xyz;
  }

  scene_color = r2;
  tex_coord = r0.xy;
}

// Applies motion blur type 1
float3 ApplyMotionBlurType1(
    float3 input_color, float2 input_coords, Texture2D<float4> SamplerQuarterSizeBlur_TEX,
    SamplerState SamplerQuarterSizeBlur_SMP_s) {
  float3 r0, r1;
  float4 r2;
  r0.xy = input_coords;
  r2.rgb = input_color;

  r1.xyz = HDR_EncodeScale.www * r2.xyz;
  r2.xyzw = SamplerQuarterSizeBlur_TEX.Sample(SamplerQuarterSizeBlur_SMP_s, r0.xy).xyzw;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = HDR_EncodeScale2.zzz * r2.xyz;
  r0.z = sqrt(r2.w);
  r0.z = rp_parameter_ps[3].x * r0.z;
  r2.xyz = r2.xyz * float3(4, 4, 4) + -r1.xyz;
  r1.xyz = r0.zzz * r2.xyz + r1.xyz;

  return r1.rgb;
}

float3 ApplyMotionBlurType2(
    float3 input_color, float2 input_coords, Texture2D<float4> SamplerQuarterSizeBlur_TEX,
    SamplerState SamplerQuarterSizeBlur_SMP_s) {
  float3 r1, r2 = input_color;

  r1.xyz = HDR_EncodeScale.www * r2.xyz;
  r2.xyz = SamplerQuarterSizeBlur_TEX.Sample(SamplerQuarterSizeBlur_SMP_s, input_coords).xyz;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r2.xyz * HDR_EncodeScale2.zzz + -r1.xyz;
  r1.xyz = rp_parameter_ps[0].www * r2.xyz + r1.xyz;

  return r1;
}

float3 ApplyBloomType1(
    float3 input_color, float2 tex_coord,
    Texture2D<float4> SamplerBloomMap0_TEX, SamplerState SamplerBloomMap0_SMP_s) {
  float3 bloom_sample = SamplerBloomMap0_TEX.Sample(SamplerBloomMap0_SMP_s, tex_coord).xyz;
  float3 bloom_color = bloom_sample * bloom_sample * HDR_EncodeScale2.z;
  float3 combined_color = input_color + bloom_color * CUSTOM_BLOOM;

  return combined_color;
}

float3 ApplyBloomType2(
    float3 input_color, float2 tex_coord,
    Texture2D<float4> SamplerBloomMap0_TEX, SamplerState SamplerBloomMap0_SMP_s) {
  float3 bloom_sample = SamplerBloomMap0_TEX.Sample(SamplerBloomMap0_SMP_s, tex_coord).xyz;
  float3 bloom_color = bloom_sample * bloom_sample * HDR_EncodeScale2.z;
  float3 combined_color = input_color * HDR_EncodeScale.w + bloom_color * CUSTOM_BLOOM;

  return combined_color;
}

float3 ApplyBloomType3(
    float3 input_color, float2 tex_coord,
    Texture2D<float4> SamplerBloomMap0_TEX, SamplerState SamplerBloomMap0_SMP_s) {
  float3 r1, r2 = input_color;

  r1.xyz = SamplerBloomMap0_TEX.Sample(SamplerBloomMap0_SMP_s, tex_coord).xyz;
  r1.xyz = r1.xyz * r1.xyz;
  float3 bloom_color = HDR_EncodeScale2.zzz * r1.xyz;
  float3 combined_color = r2.xyz * HDR_EncodeScale.www + r1.xyz;

  return combined_color;
}

float3 ApplyDizzyEffect(
    float3 input_color, float2 input_coords,
    Texture2D<float4> SamplerLowResCapture_TEX, SamplerState SamplerLowResCapture_SMP_s) {
  float3 r1 = input_color;

  float4 r0 = SamplerLowResCapture_TEX.Sample(SamplerLowResCapture_SMP_s, input_coords).xyzw;
  r0.xyz = r0.xyz * r0.www;
  r0.xyz = HDR_EncodeScale2.zzz * r0.xyz;
  r0.xyz = r0.xyz * float3(8, 8, 8) + -r1.xyz;
  r0.xyz = rp_parameter_ps[10].www * r0.xyz + r1.xyz;
  return r0.rgb;
}

float3 ApplyVanillaTonemap(
    float3 untonemapped, float untonemapped_luminance,
    Texture2D<float4> SamplerToneMapCurve_TEX, SamplerState SamplerToneMapCurve_SMP_s) {
  float4 r0, r1, r2, r3, r4;

  r0.xyz = untonemapped;
  r0.w = untonemapped_luminance;

  // apply shaper and sample tonemap lut by luminance with highlight desaturation
  r1.x = log2(r0.w);
  r1.x = r1.x * 0.693147182 + 12;
  r1.x = saturate(0.0625 * r1.x);
  r1.y = 0.25;
  r1.x = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r1.xy, 0).x;
  r1.y = -r1.x * r1.x + 1;
  r2.xyz = max(0, r0.xyz);
  r1.z = max(10e-5, r0.w);
  r2.xyz = r2.xyz / r1.zzz;
  r1.y = max(10e-6, r1.y);
  r1.yzw = pow(r2.rgb, r1.y);
  r2.xyz = r1.yzw * r1.xxx;

  // Apply debug stuff
  r2.w = sqrt(r1.x);
  r3.x = cmp(ToneMappingDebugParams.y < r2.w);
  r2.w = cmp(r2.w < ToneMappingDebugParams.x);
  r4.xyzw = r2.wwww ? float4(0, 0, 1, 1) : 0;
  r3.xyzw = r3.xxxx ? float4(1, 0, 0, 1) : r4.xyzw;
  r2.w = ToneMappingDebugParams.z * r3.w;
  r1.xyz = -r1.yzw * r1.xxx + r3.xyz;
  r1.xyz = r2.www * r1.xyz + r2.xyz;

  // apply shaper and sample tonemap lut per channel
  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.693147182, 0.693147182, 0.693147182) + float3(12, 12, 12);
  r2.xyz = saturate(float3(0.0625, 0.0625, 0.0625) * r0.xyz);
  r2.w = 0.25;
  r0.x = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.xw, 0).x;
  r0.y = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.yw, 0).x;
  r0.z = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.zw, 0).x;

  // Apply debug stuff based on incorrect luminance formula (BT.601)
  r1.w = renodx::color::luma::from::BT601(r0.xyz);
  r1.w = sqrt(r1.w);
  r2.x = cmp(ToneMappingDebugParams.y < r1.w);
  r1.w = cmp(r1.w < ToneMappingDebugParams.x);
  r3.xyzw = r1.wwww ? float4(0, 0, 1, 1) : 0;
  r2.xyzw = r2.xxxx ? float4(1, 0, 0, 1) : r3.xyzw;
  r1.w = ToneMappingDebugParams.z * r2.w;
  r2.xyz = r2.xyz + -r0.xyz;
  r0.xyz = r1.www * r2.xyz + r0.xyz;

  // lerp luminance and per channel
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = ToneMappingDebugParams.www * r0.xyz + r1.xyz;

  return r0.xyz;
}

// debug stuff
// maybe has vignette?
float3 applyVignette(
    float3 tonemapped, float4 sv_position,
    float4 texcoord, float luminance) {
  float4 r0, r1, r2;
  r0.xyz = tonemapped;
  r0.w = luminance;

  // Light meter debug and vignette processing
  r1.xy = (uint2)sv_position.xy;
  uint4 uiDest;
  uiDest.xy = (uint2)r1.xy / int2(5, 5);  // Compute vignette grid
  r1.xy = uiDest.xy;
  r1.x = (int)r1.x + (int)r1.y;  // Sum the grid coordinates
  r1.x = (int)r1.x & 1;          // Create a checkerboard pattern for the vignette

  // Apply LightMeterDebugParams threshold checks
  r1.y = cmp(LightMeterDebugParams.y < r0.w);        // Check if brightness exceeds the threshold
  r0.w = cmp(r0.w < LightMeterDebugParams.x);        // Check if brightness is below a threshold
  r2.xyzw = r0.wwww ? float4(0, 0, 1, 1) : 0;        // Set blue if brightness is too low
  r2.xyzw = r1.yyyy ? float4(1, 0, 0, 1) : r2.xyzw;  // Set red if brightness is too high
  r0.w = LightMeterDebugParams.w * r2.w;             // Apply light meter multiplier

  // Final color adjustment based on debug/vignette
  r1.yzw = r2.xyz + -r0.xyz;
  r1.yzw = r0.www * r1.yzw + r0.xyz;
  r0.xyz = r1.xxx ? r1.yzw : r0.xyz;
  r0.xyz = texcoord.zzz * r0.xyz;  // Use v1 (texcoord) for final adjustment

  r0.rgb = lerp(tonemapped, r0.rgb, CUSTOM_VIGNETTE);
  return r0.rgb;
}

// Function to apply the LUT based on input color
float3 ApplyLUT(
    float3 lutInputColor, Texture3D<float4> SamplerColourLUT_TEX,
    SamplerState SamplerColourLUT_SMP_s) {
  float4 r0, r1;
  float3 lutOutputColor;

  // Apply the LUT
  r1.xyz = sqrt(max(0, lutInputColor));                                      // Take square root of the input color and preserve the sign
  r1.xyz = rp_parameter_ps[2].zzz + r1.xyz;                                  // Apply an offset from rp_parameter_ps
  r1.xyz = SamplerColourLUT_TEX.Sample(SamplerColourLUT_SMP_s, r1.xyz).xyz;  // Sample the LUT using the adjusted color
  r0.w = rp_parameter_ps[2].y * rp_parameter_ps[2].x;                        // lerp strength?

  // Apply adjustments to the LUT output
  r1.xyz = r1.xyz * r1.xyz + -lutInputColor;
  lutOutputColor = r0.w * r1.xyz + lutInputColor;

  lutOutputColor = lerp(lutInputColor, lutOutputColor, CUSTOM_LUT_STRENGTH);
  return lutOutputColor;  // Return the adjusted color
}

// apply dual LUTs
float3 applyDualLUT(
    float3 lut_input_color, Texture3D<float4> SamplerColourLUT_TEX,
    SamplerState SamplerColourLUT_SMP_s, Texture3D<float4> SamplerTargetColourLUT_TEX,
    SamplerState SamplerTargetColourLUT_SMP_s, float4 v1) {
  float3 r0, r2, r3, r1 = lut_input_color;

  r2.xyz = sqrt(max(0, r1.xyz));
  r3.xyz = rp_parameter_ps[2].zzz + r2.xyz;
  r3.xyz = SamplerColourLUT_TEX.Sample(SamplerColourLUT_SMP_s, r3.xyz).xyz;
  r3.xyz = r3.xyz * r3.xyz;
  r2.xyz = rp_parameter_ps[2].www + r2.xyz;
  r2.xyz = SamplerTargetColourLUT_TEX.Sample(SamplerTargetColourLUT_SMP_s, r2.xyz).xyz;
  r2.xyz = r2.xyz * r2.xyz + -r3.xyz;
  r2.xyz = rp_parameter_ps[2].yyy * r2.xyz + r3.xyz;
  // (-r0.rgb * v1.z) is just -r1.rgb
  r0.xyz = -r1.rgb + r2.xyz;  // r0.xyz = -r0.xyz * v1.zzz + r2.xyz;
  r0.xyz = rp_parameter_ps[2].xxx * r0.xyz + r1.xyz;

  float3 lut_output_color = lerp(lut_input_color, r0.xyz, CUSTOM_LUT_STRENGTH);

  return lut_output_color;
}

float3 ApplyDesaturation(float3 input_color) {
  float4x3 grayscale_matrix = transpose(
      float3x4(rp_parameter_ps[4],
               rp_parameter_ps[5],
               rp_parameter_ps[6]));
  float3 desaturated_color = mul(float4(input_color, 1.0), (grayscale_matrix));

  return max(0, desaturated_color);  // fixes bad gradients
}

float3 EncodeGamma(float3 linear_color) {
  // ignore user gamma, force 2.2
  // return pow(linear_color, OutputGamma.x);
  return renodx::color::gamma::EncodeSafe(linear_color, 2.2f);
}

float3 ApplyFilmGrain(float3 input_color, Texture2D<float4> SamplerNoise_TEX,
                      SamplerState SamplerNoise_SMP_s, float4 v1) {
  float3 output_color = input_color;
  if (CUSTOM_GRAIN_TYPE == 0.f) {  // Noise
    float4 r0, r2;
    float3 r1, r3;
    r0.rgb = input_color;

    r1.xyz = SamplerNoise_TEX.Sample(SamplerNoise_SMP_s, v1.xy).xyz;
    r1.xyz = float3(-0.5, -0.5, -0.5) + r1.xyz;
    r0.w = dot(float3(0.298999995, 0.587000012, 0.114), r0.xyz);
    r2.xyz = float3(0, 0.5, 1) + -r0.www;
    r2.xyz = saturate(rp_parameter_ps[7].xyz + -abs(r2.xyz));
    r2.xyz = r2.xyz / rp_parameter_ps[7].xyz;
    r2.xyz = rp_parameter_ps[8].xyz * r2.xyz;
    r3.xyz = r2.yyy * r1.xyz;
    r2.xyw = r1.xyz * r2.xxx + r3.xyz;
    r1.xyz = r1.xyz * r2.zzz + r2.xyw;
    r0.xyz = CUSTOM_GRAIN_STRENGTH * r1.xyz + r0.xyz;

    output_color = r0.rgb;
  }
  return output_color;
}

float3 ApplyBloodOverlay(
    float3 inputColor, float4 v0,
    Texture2D<float4> SamplerOverlay_TEX, SamplerState SamplerOverlay_SMP_s) {
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

float3 ApplyToneMapVignetteLUT(
    float3 untonemapped, float untonemapped_lum, float4 v1, float4 v2,
    Texture2D<float4> SamplerToneMapCurve_TEX, SamplerState SamplerToneMapCurve_SMP_s,
    Texture3D<float4> SamplerColourLUT_TEX, SamplerState SamplerColourLUT_SMP_s) {
  float3 r0 = untonemapped;

  float3 output_color = r0.xyz;
  if (RENODX_TONE_MAP_TYPE == 0) {  // vanilla tonemap
    r0.xyz = ApplyVanillaTonemap(untonemapped, untonemapped_lum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);
    r0.xyz = applyVignette(r0.rgb, v2, v1, untonemapped_lum);
    r0.xyz = ApplyLUT(r0.rgb, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);

    output_color = r0.xyz;
  } else {
    r0.rgb = ApplyVanillaTonemapExtrapolated(untonemapped, untonemapped_lum, v2.xy, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);

    r0.xyz = applyVignette(r0.rgb, v2, v1, untonemapped_lum);
    float maxch_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(r0.rgb);
    r0.rgb *= maxch_scale;
    r0.xyz = ApplyLUT(r0.rgb, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);
    r0.rgb /= maxch_scale;

    output_color = r0.xyz;
  }

  return output_color;
}

float3 ApplyToneMapVignetteDualLUTs(
    float3 untonemapped, float untonemapped_lum, float4 v1, float4 v2,
    Texture2D<float4> SamplerToneMapCurve_TEX, SamplerState SamplerToneMapCurve_SMP_s,
    Texture3D<float4> SamplerColourLUT_TEX, SamplerState SamplerColourLUT_SMP_s,
    Texture3D<float4> SamplerTargetColourLUT_TEX, SamplerState SamplerTargetColourLUT_SMP_s) {
  float3 r0 = untonemapped;

  float3 output_color = r0.xyz;
  if (RENODX_TONE_MAP_TYPE == 0) {  // vanilla tonemap
    r0.xyz = ApplyVanillaTonemap(untonemapped, untonemapped_lum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);
    r0.xyz = applyVignette(r0.rgb, v2, v1, untonemapped_lum);
    r0.xyz = ApplyLUT(r0.rgb, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);

    output_color = r0.xyz;
  } else {
    r0.rgb = ApplyVanillaTonemapExtrapolated(untonemapped, untonemapped_lum, v2.xy, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);

    r0.xyz = applyVignette(r0.rgb, v2, v1, untonemapped_lum);

    float maxch_scale = renodx::tonemap::neutwo::ComputeMaxChannelScale(r0.rgb);
    r0.rgb *= maxch_scale;
    r0.xyz = ApplyLUT(r0.rgb, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);
    float3 lut_output_color = applyDualLUT(
        r0.rgb, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s,
        SamplerTargetColourLUT_TEX, SamplerTargetColourLUT_SMP_s, v1);
    r0.rgb /= maxch_scale;

    output_color = r0.xyz;
  }

  return output_color;
}

float3 ApplyToneMapVignette(
    float3 untonemapped, float untonemapped_lum, float4 v1, float4 v2,
    Texture2D<float4> SamplerToneMapCurve_TEX, SamplerState SamplerToneMapCurve_SMP_s) {
  float3 r0 = untonemapped;

  float3 output_color = r0.xyz;
  if (RENODX_TONE_MAP_TYPE == 0) {  // vanilla tonemap
    r0.xyz = ApplyVanillaTonemap(untonemapped, untonemapped_lum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);
    r0.xyz = applyVignette(r0.rgb, v2, v1, untonemapped_lum);

    output_color = r0.xyz;
  } else {  // Extrapolated
    r0.rgb = ApplyVanillaTonemapExtrapolated(untonemapped, untonemapped_lum, v2.xy, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);
    r0.xyz = applyVignette(r0.rgb, v2, v1, untonemapped_lum);

    output_color = r0.rgb;
  }

  return output_color;
}

float4 FinalizeToneMapOutput(float3 input_color) {
  float4 output_color;

  output_color.rgb = input_color * rp_parameter_ps[0].x + rp_parameter_ps[0].y;  // remove saturate

  if (RENODX_TONE_MAP_TYPE != 0) {
    output_color.rgb = renodx::color::gamma::DecodeSafe(output_color.rgb);
    output_color.rgb = renodx::color::bt2020::from::BT709(output_color.rgb);
    output_color.rgb = max(0, output_color.rgb);

    renodx_custom::tonemap::psycho::config17::Config psycho17_config =
        renodx_custom::tonemap::psycho::config17::Create();
    psycho17_config.peak_value = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;
    psycho17_config.clip_point = 100.f;
    psycho17_config.exposure = RENODX_TONE_MAP_EXPOSURE;
    psycho17_config.gamma = 1.f;
    psycho17_config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
    psycho17_config.shadows = RENODX_TONE_MAP_SHADOWS;
    psycho17_config.contrast = RENODX_TONE_MAP_CONTRAST;
    psycho17_config.flare = 0.10f * pow(RENODX_TONE_MAP_FLARE, 10.f);
    psycho17_config.contrast_highlights = 1.f;
    psycho17_config.contrast_shadows = 1.f;
    psycho17_config.purity_scale = RENODX_TONE_MAP_SATURATION;
    psycho17_config.purity_highlights = -1.f * (RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.f);
    psycho17_config.dechroma = RENODX_TONE_MAP_DECHROMA;
    psycho17_config.adaptation_contrast = 1.f;
    psycho17_config.bleaching_intensity = 0.f;
    psycho17_config.hue_emulation = 0.f;
    psycho17_config.pre_gamut_compress = false;
    psycho17_config.post_gamut_compress = true;
    output_color.rgb = renodx_custom::tonemap::psycho::ApplyTest17BT2020(output_color.rgb, output_color.rgb, psycho17_config);

    output_color.rgb = renodx::color::bt709::from::BT2020(output_color.rgb);
    output_color.rgb = renodx::color::gamma::EncodeSafe(output_color.rgb);
  } else {
    output_color = max(0, output_color);
  }

  output_color.w = max(0, renodx::color::y::from::BT709(output_color.rgb));
  return output_color;
}
