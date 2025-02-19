#include "./common.hlsl"
#include "./include/CBuffer_DefaultPSC.hlsl"
#include "./include/CBuffer_DefaultXSC.hlsl"
#include "./include/CBuffer_UbershaderXSC.hlsl"

// 3Dmigoto declarations
#define cmp -

float3 CorrectLightness(float3 incorrect_color, float3 correct_color) {
  float3 incorrect_oklab = renodx::color::oklab::from::BT709(incorrect_color);
  float3 correct_oklab = renodx::color::oklab::from::BT709(correct_color);
  incorrect_oklab.x = correct_oklab.x;  // Adjust L component
  return renodx::color::bt709::from::OkLab(incorrect_oklab);
}

float3 ScaleBloom(float3 original_color, float3 bloom_color, float3 bloomed_color) {
  if (injectedData.fxBloomBlackFloor == 0.f) return bloomed_color;
  // Adjust the combined color's luminance to match the input color
  float3 lightness_adjusted_color = CorrectLightness(bloomed_color, original_color);

  // Calculate luminance of the input and bloom colors
  float original_luminance = renodx::color::y::from::BT709(original_color);
  float bloom_luminance = renodx::color::y::from::BT709(bloom_color);

  // Define nonlinear blending factors based on luminance
  float input_blend_factor = 1.0 - smoothstep(0.0, 0.0025f, original_luminance);
  // Combine the two factors: Reduce blending where bloom is bright or input is dark
  float combined_blend_factor = input_blend_factor * (1.0 - bloom_luminance);

  // Blend between the original combined color and the lightness adjusted color
  float3 adjusted_color = lerp(bloomed_color, lightness_adjusted_color, combined_blend_factor);

  return lerp(bloomed_color, adjusted_color, injectedData.fxBloomBlackFloor);
}

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
  float3 combined_color = input_color + bloom_color * injectedData.fxBloom;

  return ScaleBloom(input_color, bloom_color, combined_color);
}

float3 ApplyBloomType2(
    float3 input_color, float2 tex_coord,
    Texture2D<float4> SamplerBloomMap0_TEX, SamplerState SamplerBloomMap0_SMP_s) {
  float3 bloom_sample = SamplerBloomMap0_TEX.Sample(SamplerBloomMap0_SMP_s, tex_coord).xyz;
  float3 bloom_color = bloom_sample * bloom_sample * HDR_EncodeScale2.z;
  float3 combined_color = input_color * HDR_EncodeScale.w + bloom_color * injectedData.fxBloom;

  return ScaleBloom(input_color * HDR_EncodeScale.w, bloom_color, combined_color);
}

float3 ApplyBloomType3(
    float3 input_color, float2 tex_coord,
    Texture2D<float4> SamplerBloomMap0_TEX, SamplerState SamplerBloomMap0_SMP_s) {
  float3 r1, r2 = input_color;

  r1.xyz = SamplerBloomMap0_TEX.Sample(SamplerBloomMap0_SMP_s, tex_coord).xyz;
  r1.xyz = r1.xyz * r1.xyz;
  float3 bloom_color = HDR_EncodeScale2.zzz * r1.xyz;
  float3 combined_color = r2.xyz * HDR_EncodeScale.www + r1.xyz;

  return ScaleBloom(input_color * HDR_EncodeScale.w, bloom_color, combined_color);
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

  // Luminance calculation
  r0.xyz = untonemapped;
  r0.w = untonemapped_luminance;
  r1.x = log2(r0.w);
  r1.x = r1.x * 0.693147182 + 12;
  r1.x = saturate(0.0625 * r1.x);
  r1.y = 0.25;

  // Sample tone map curve
  r1.x = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r1.xy, 0).x;
  r1.y = -r1.x * r1.x + 1;
  r2.xyz = max(float3(0, 0, 0), r0.xyz);
  r1.z = max(9.99999975e-005, r0.w);
  r2.xyz = r2.xyz / r1.zzz;
  r1.y = max(9.99999975e-006, r1.y);
  r2.xyz = log2(r2.xyz);
  r1.yzw = r2.xyz * r1.yyy;
  r1.yzw = exp2(r1.yzw);
  r2.xyz = r1.yzw * r1.xxx;
  r2.w = sqrt(r1.x);

  // Apply tone mapping based on debug parameters
  r3.x = cmp(ToneMappingDebugParams.y < r2.w);
  r2.w = cmp(r2.w < ToneMappingDebugParams.x);
  r4.xyzw = r2.wwww ? float4(0, 0, 1, 1) : 0;
  r3.xyzw = r3.xxxx ? float4(1, 0, 0, 1) : r4.xyzw;
  r2.w = ToneMappingDebugParams.z * r3.w;
  r1.xyz = -r1.yzw * r1.xxx + r3.xyz;
  r1.xyz = r2.www * r1.xyz + r2.xyz;
  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.693147182, 0.693147182, 0.693147182) + float3(12, 12, 12);

  // Saturate and sample the tone map curve for each channel
  r2.xyz = saturate(float3(0.0625, 0.0625, 0.0625) * r0.xyz);
  r2.w = 0.25;
  r0.x = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.xw, 0).x;
  r0.y = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.yw, 0).x;
  r0.z = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.zw, 0).x;

  // Adjust colors based on incorrect luminance formula (BT.601)
  r1.w = renodx::color::luma::from::BT601(r0.xyz);
  r1.w = sqrt(r1.w);
  r2.x = cmp(ToneMappingDebugParams.y < r1.w);
  r1.w = cmp(r1.w < ToneMappingDebugParams.x);
  r3.xyzw = r1.wwww ? float4(0, 0, 1, 1) : 0;
  r2.xyzw = r2.xxxx ? float4(1, 0, 0, 1) : r3.xyzw;
  r1.w = ToneMappingDebugParams.z * r2.w;
  r2.xyz = r2.xyz + -r0.xyz;
  r0.xyz = r1.www * r2.xyz + r0.xyz;
  r0.xyz = r0.xyz + -r1.xyz;
  r0.xyz = ToneMappingDebugParams.www * r0.xyz + r1.xyz;

  return r0.xyz;
}

float3 ApplyVanillaToneMapType2(
    float3 untonemapped, float untonemapped_lum, Texture2D<float4> SamplerToneMapCurve_TEX,
    SamplerState SamplerToneMapCurve_SMP_s) {
  float4 r0, r1, r2, r3;
  r1.rgb = max(0, untonemapped);
  r0.rgb = untonemapped;
  r0.w = untonemapped_lum;

  r0.xyz = log2(r0.xyz);
  r0.xyz = r0.xyz * float3(0.693147182, 0.693147182, 0.693147182) + float3(12, 12, 12);
  r2.xyz = saturate(float3(0.0625, 0.0625, 0.0625) * r0.xyz);
  r0.x = max(9.99999975e-005, r0.w);
  r0.y = log2(r0.w);
  r0.y = r0.y * 0.693147182 + 12;
  r3.x = saturate(0.0625 * r0.y);
  r0.xyz = r1.xyz / r0.xxx;
  r0.xyz = log2(r0.xyz);
  r3.y = 0.25;
  r0.w = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r3.xy, 0).x;
  r1.x = -r0.w * r0.w + 1;
  r1.x = max(9.99999975e-006, r1.x);
  r0.xyz = r1.xxx * r0.xyz;
  r0.xyz = exp2(r0.xyz);
  r1.x = sqrt(r0.w);
  r1.y = cmp(r1.x < ToneMappingDebugParams.x);
  r1.x = cmp(ToneMappingDebugParams.y < r1.x);
  r3.xyzw = r1.yyyy ? float4(0, 0, 1, 1) : 0;
  r1.xyzw = r1.xxxx ? float4(1, 0, 0, 1) : r3.xyzw;
  r1.xyz = -r0.xyz * r0.www + r1.xyz;
  r0.xyz = r0.xyz * r0.www;
  r0.w = ToneMappingDebugParams.z * r1.w;
  r0.xyz = r0.www * r1.xyz + r0.xyz;
  r2.w = 0.25;
  r1.x = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.xw, 0).x;
  r1.y = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.yw, 0).x;
  r1.z = SamplerToneMapCurve_TEX.SampleLevel(SamplerToneMapCurve_SMP_s, r2.zw, 0).x;
  r0.w = dot(float3(0.298999995, 0.587000012, 0.114), r1.xyz);
  r0.w = sqrt(r0.w);
  r1.w = cmp(r0.w < ToneMappingDebugParams.x);
  r0.w = cmp(ToneMappingDebugParams.y < r0.w);
  r2.xyzw = r1.wwww ? float4(0, 0, 1, 1) : 0;
  r2.xyzw = r0.wwww ? float4(1, 0, 0, 1) : r2.xyzw;
  r2.xyz = r2.xyz + -r1.xyz;
  r0.w = ToneMappingDebugParams.z * r2.w;
  r1.xyz = r0.www * r2.xyz + r1.xyz;
  r1.xyz = r1.xyz + -r0.xyz;
  r0.xyz = ToneMappingDebugParams.www * r1.xyz + r0.xyz;

  return r0.rgb;
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

  r0.rgb = lerp(tonemapped, r0.rgb, injectedData.fxVignette);
  return r0.rgb;
}

// Function to apply the LUT based on input color
float3 ApplyLUT(
    float3 lutInputColor, Texture3D<float4> SamplerColourLUT_TEX,
    SamplerState SamplerColourLUT_SMP_s) {
  float4 r0, r1;
  float3 lutOutputColor;

  // Apply the LUT
  r1.xyz = sign(lutInputColor) * sqrt(abs(lutInputColor));                   // Take square root of the input color and preserve the sign
  r1.xyz = rp_parameter_ps[2].zzz + r1.xyz;                                  // Apply an offset from rp_parameter_ps
  r1.xyz = SamplerColourLUT_TEX.Sample(SamplerColourLUT_SMP_s, r1.xyz).xyz;  // Sample the LUT using the adjusted color
  r0.w = rp_parameter_ps[2].y * rp_parameter_ps[2].x;                        // lerp strength?

  // Apply adjustments to the LUT output
  r1.xyz = r1.xyz * r1.xyz + -lutInputColor;
  lutOutputColor = r0.w * r1.xyz + lutInputColor;

  lutOutputColor = lerp(lutInputColor, lutOutputColor, injectedData.colorGradeLUTStrength);
  return lutOutputColor;  // Return the adjusted color
}

// apply dual LUTs
float3 applyDualLUT(
    float3 lut_input_color, Texture3D<float4> SamplerColourLUT_TEX,
    SamplerState SamplerColourLUT_SMP_s, Texture3D<float4> SamplerTargetColourLUT_TEX,
    SamplerState SamplerTargetColourLUT_SMP_s, float4 v1) {
  float3 r0, r2, r3, r1 = lut_input_color;

  r2.xyz = renodx::math::SignSqrt(r1.xyz);
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

  float3 lut_output_color = lerp(lut_input_color, r0.xyz, injectedData.colorGradeLUTStrength);

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
  float3 grained_color;
  if (injectedData.fxFilmGrainType == 0.f) {  // Noise
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
    r0.xyz = injectedData.fxFilmGrain * r1.xyz + r0.xyz;

    grained_color = r0.rgb;
  } else {  // Film Grain, applied in linear space
    float3 linear_color = renodx::color::gamma::DecodeSafe(input_color, 2.2f);
    if (injectedData.fxFilmGrainType == 1.f) {  // B&W
      float random_seed = SamplerNoise_TEX.Sample(SamplerNoise_SMP_s, v1.xy).y;
      grained_color = renodx::effects::ApplyFilmGrain(
          linear_color,
          v1.xy,        // Screen-space coordinates
          random_seed,  // Sample noise tex for random seed
          injectedData.fxFilmGrain * .02f);
    } else {  // Colored
      float3 random_seed = SamplerNoise_TEX.Sample(SamplerNoise_SMP_s, v1.xy).rgb;
      grained_color = renodx::effects::ApplyFilmGrainColored(
          linear_color,
          v1.xy,        // Screen-space coordinates
          random_seed,  // Sample noise tex for random seed
          injectedData.fxFilmGrain * .02f);
    }
    grained_color = renodx::color::gamma::EncodeSafe(grained_color, 2.2f);
  }
  return grained_color;
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

float4 FinalizeToneMapOutput(float3 input_color) {
  float4 output_color;

  output_color.rgb = input_color * rp_parameter_ps[0].x + rp_parameter_ps[0].y;  // remove saturate
  output_color.w = renodx::color::y::from::BT709(max(0, input_color));
  return GameScale(output_color);
}

// ============================= CUSTOM FUNCTIONS =============================
float UpgradeToneMapRatio(float color_hdr, float color_sdr, float post_process_color) {
  [branch]
  if (color_hdr < color_sdr) {
    // If subtracting (user contrast or paperwhite) scale down instead
    // Should only apply on mismatched HDR
    return color_hdr / color_sdr;
  } else {
    float delta = color_hdr - color_sdr;
    delta = max(0, delta);  // Cleans up NaN
    const float ap1_new = post_process_color + delta;

    const bool ap1_valid = (post_process_color > 0);  // Cleans up NaN and ignore black
    return ap1_valid ? (ap1_new / post_process_color) : 0;
  }
}

float3 UpgradeToneMapPerChannel(
    float3 color_hdr, float3 color_sdr,
    float3 post_process_color, float post_process_strength,
    uint working_color_space = 2u, uint hue_processor = 2u) {
  // float ratio = 1.f;

  float3 working_hdr, working_sdr, working_post_process;

  [branch]
  if (working_color_space == 2u) {
    working_hdr = max(0, renodx::color::ap1::from::BT709(color_hdr));
    working_sdr = max(0, renodx::color::ap1::from::BT709(color_sdr));
    working_post_process = max(0, renodx::color::ap1::from::BT709(post_process_color));
  } else
    [branch] if (working_color_space == 1u) {
      working_hdr = max(0, renodx::color::bt2020::from::BT709(color_hdr));
      working_sdr = max(0, renodx::color::bt2020::from::BT709(color_sdr));
      working_post_process = max(0, renodx::color::bt2020::from::BT709(post_process_color));
    }
  else {
    working_hdr = max(0, color_hdr);
    working_sdr = max(0, color_sdr);
    working_post_process = max(0, post_process_color);
  }

  float3 ratio = float3(
      UpgradeToneMapRatio(working_hdr.r, working_sdr.r, working_post_process.r),
      UpgradeToneMapRatio(working_hdr.g, working_sdr.g, working_post_process.g),
      UpgradeToneMapRatio(working_hdr.b, working_sdr.b, working_post_process.b));

  float3 color_scaled = max(0, working_post_process * ratio);

  [branch]
  if (working_color_space == 2u) {
    color_scaled = renodx::color::bt709::from::AP1(color_scaled);
  } else
    [branch] if (working_color_space == 1u) {
      color_scaled = renodx::color::bt709::from::BT2020(color_scaled);
    }

  float peak_correction;
  [branch]
  if (working_color_space == 2u) {
    peak_correction = saturate(1.f - renodx::color::y::from::AP1(working_post_process));
  } else
    [branch] if (working_color_space == 1u) {
      peak_correction = saturate(1.f - renodx::color::y::from::BT2020(working_post_process));
    }
  else {
    peak_correction = saturate(1.f - renodx::color::y::from::BT709(working_post_process));
  }

  [branch]
  if (hue_processor == 2u) {
    color_scaled = renodx::color::correct::HuedtUCS(color_scaled, post_process_color, peak_correction);
  } else
    [branch] if (hue_processor == 1u) {
      color_scaled = renodx::color::correct::HueICtCp(color_scaled, post_process_color, peak_correction);
    }
  else {
    color_scaled = renodx::color::correct::HueOKLab(color_scaled, post_process_color, peak_correction);
  }
  return lerp(color_hdr, color_scaled, post_process_strength);
}

float3 UpgradeToneMapPerceptual(
    float3 untonemapped, float3 tonemapped,
    float3 post_processed, float strength) {
  float3 lab_untonemapped = renodx::color::ictcp::from::BT709(untonemapped);
  float3 lab_tonemapped = renodx::color::ictcp::from::BT709(tonemapped);
  float3 lab_post_processed = renodx::color::ictcp::from::BT709(post_processed);

  float3 lch_untonemapped = renodx::color::oklch::from::OkLab(lab_untonemapped);
  float3 lch_tonemapped = renodx::color::oklch::from::OkLab(lab_tonemapped);
  float3 lch_post_processed = renodx::color::oklch::from::OkLab(lab_post_processed);

  float3 lch_upgraded = lch_untonemapped;
  lch_upgraded.xz *= renodx::math::DivideSafe(lch_post_processed.xz, lch_tonemapped.xz, 0.f);

  float3 lab_upgraded = renodx::color::oklab::from::OkLCh(lch_upgraded);

  float c_untonemapped = length(lab_untonemapped.yz);
  float c_tonemapped = length(lab_tonemapped.yz);
  float c_post_processed = length(lab_post_processed.yz);

  if (c_untonemapped > 0) {
    float new_chrominance = c_untonemapped;
    new_chrominance = min(max(c_untonemapped, 0.25f), c_untonemapped * (c_post_processed / c_tonemapped));
    if (new_chrominance > 0) {
      lab_upgraded.yz *= new_chrominance / c_untonemapped;
    }
  }

  float3 upgraded = renodx::color::bt709::from::ICtCp(lab_upgraded);
  return lerp(untonemapped, upgraded, strength);
}

float3 UpgradeToneMap(
    float3 color_hdr, float3 color_sdr,
    float3 post_process_color, float post_process_strength) {
  if (RENODX_COLOR_GRADE_RESTORATION_METHOD == 1u) {
    return UpgradeToneMapPerChannel(color_hdr, color_sdr, post_process_color, post_process_strength);
  } else if (RENODX_COLOR_GRADE_RESTORATION_METHOD == 2u) {
    return UpgradeToneMapPerceptual(color_hdr, color_sdr, post_process_color, post_process_strength);
  } else {
    return renodx::tonemap::UpgradeToneMap(color_hdr, color_sdr, post_process_color, post_process_strength);
  }
}

float3 ApplySingleToneMap(float3 color, float3 exposure_bias) {
  color *= exposure_bias / 0.18f;  // high mid gray values break tonemapping

  const float mid_gray = RENODX_TONE_MAP_MID_GRAY;
  color *= 0.18f / mid_gray;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = 0.f;
  config.mid_gray_value = mid_gray;
  config.mid_gray_nits = config.mid_gray_value * 100.f;
  config.exposure = injectedData.colorGradeExposure;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.highlights = injectedData.colorGradeHighlights;
  config.saturation = injectedData.colorGradeSaturation;
  config.hue_correction_type = renodx::tonemap::config::hue_correction_type::INPUT;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.reno_drt_white_clip = RENODX_RENO_DRT_WHITE_CLIP;

  // RenoDRT Settings
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0;
  config.reno_drt_highlights = 1.04f;
  config.reno_drt_shadows = 1.f;
  config.reno_drt_contrast = 1.f;
  config.reno_drt_saturation = 1.f;
  config.reno_drt_blowout = -1.f * (injectedData.colorGradeHighlightSaturation - 1.f);
  config.reno_drt_dechroma = injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.reno_drt_working_color_space = 0u;
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
  config.reno_drt_hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::OKLAB;

  // ToneMap Blend
  if (injectedData.toneMapBlend) {
    config.exposure = 1.f;
    config.shadows = 1.f;
    config.contrast = 1.f;
    config.saturation = 1.f;
    config.reno_drt_flare = 0.f;
    config.reno_drt_blowout = -1.f * (injectedData.colorGradeHighlightSaturation - 1.f);
    config.reno_drt_dechroma = 0.5f;
    config.reno_drt_highlights *= 1.04f;
  }

  return renodx::tonemap::config::Apply(color, config);
}

renodx::tonemap::config::DualToneMap ApplyDualToneMap(float3 color, float exposure_bias) {
  color *= exposure_bias / 0.18f;  // high mid gray values break tonemapping

  const float mid_gray = RENODX_TONE_MAP_MID_GRAY;
  color *= 0.18f / mid_gray;
  renodx::tonemap::Config config = renodx::tonemap::config::Create();
  config.type = injectedData.toneMapType;
  config.peak_nits = injectedData.toneMapPeakNits;
  config.game_nits = injectedData.toneMapGameNits;
  config.gamma_correction = 0.f;
  config.mid_gray_value = mid_gray;
  config.mid_gray_nits = config.mid_gray_value * 100.f;
  config.exposure = injectedData.colorGradeExposure;
  config.shadows = injectedData.colorGradeShadows;
  config.contrast = injectedData.colorGradeContrast;
  config.highlights = injectedData.colorGradeHighlights;
  config.saturation = injectedData.colorGradeSaturation;
  config.hue_correction_type = renodx::tonemap::config::hue_correction_type::INPUT;
  config.hue_correction_strength = injectedData.toneMapHueCorrection;
  config.reno_drt_white_clip = RENODX_RENO_DRT_WHITE_CLIP;

  // RenoDRT Settings
  config.reno_drt_per_channel = injectedData.toneMapPerChannel != 0;
  config.reno_drt_highlights = 1.04f;
  config.reno_drt_shadows = 1.f;
  config.reno_drt_contrast = 1.f;
  config.reno_drt_saturation = 1.f;
  config.reno_drt_blowout = -1.f * (injectedData.colorGradeHighlightSaturation - 1.f);
  config.reno_drt_dechroma = injectedData.colorGradeBlowout;
  config.reno_drt_flare = 0.10f * pow(injectedData.colorGradeFlare, 10.f);
  config.reno_drt_working_color_space = 0u;
  config.reno_drt_tone_map_method = renodx::tonemap::renodrt::config::tone_map_method::REINHARD;
  config.reno_drt_hue_correction_method = renodx::tonemap::renodrt::config::hue_correction_method::OKLAB;

  // ToneMap Blend
  if (injectedData.toneMapBlend) {
    config.exposure = 1.f;
    config.shadows = 1.f;
    config.contrast = 1.f;
    config.saturation = 1.f;
    config.reno_drt_flare = 0.f;
    config.reno_drt_blowout = -1.f * (injectedData.colorGradeHighlightSaturation - 1.f);
    config.reno_drt_dechroma = 0.5f;
    config.reno_drt_highlights *= 1.04f;
  }

  renodx::tonemap::config::DualToneMap dual_tone_map =
      renodx::tonemap::config::ApplyToneMaps(color, config);

  return dual_tone_map;
}

float3 ToneMapBlend(float3 hdr_color, float3 sdr_color) {
  float3 negHDR = min(0, hdr_color);  // save WCG
  float3 blended_color = lerp(sdr_color, max(0, hdr_color), saturate(sdr_color));
  blended_color += negHDR;  // add back WCG

  return blended_color;
}

float3 ApplyToneMapVignetteLUT(
    float3 untonemapped, float untonemapped_lum, float4 v1, float4 v2,
    Texture2D<float4> SamplerToneMapCurve_TEX, SamplerState SamplerToneMapCurve_SMP_s,
    Texture3D<float4> SamplerColourLUT_TEX, SamplerState SamplerColourLUT_SMP_s) {
  float3 r0 = untonemapped;

  float3 output_color = r0.xyz;
  if (injectedData.toneMapType == 0) {  // vanilla tonemap
    r0.xyz = ApplyVanillaTonemap(untonemapped, untonemapped_lum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);
    r0.xyz = applyVignette(r0.rgb, v2, v1, untonemapped_lum);
    r0.xyz = ApplyLUT(r0.rgb, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);

    output_color = r0.xyz;
  } else if (injectedData.toneMapType > 1.f) {
    const float exposure_bias = renodx::color::y::from::BT709(ApplyVanillaTonemap(0.18, untonemapped_lum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s));
    renodx::tonemap::config::DualToneMap dual_tone_map = ApplyDualToneMap(untonemapped, exposure_bias);

    float3 vignette_hdr = applyVignette(dual_tone_map.color_hdr, v2, v1, untonemapped_lum);
    float3 vignette_sdr = applyVignette(dual_tone_map.color_sdr, v2, v1, untonemapped_lum);
    float3 lut_output_color = ApplyLUT(vignette_sdr, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);

    output_color = UpgradeToneMap(vignette_hdr, vignette_sdr, lut_output_color, 1.f);

    if (injectedData.toneMapHueShift || injectedData.toneMapBlend) {
      float3 vanilla_color = ApplyVanillaTonemap(untonemapped, untonemapped_lum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);
      vanilla_color = applyVignette(vanilla_color, v2, v1, untonemapped_lum);
      vanilla_color = ApplyLUT(vanilla_color, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);
      if (injectedData.toneMapHueShift) {
        output_color = renodx::color::correct::Hue(output_color, vanilla_color, injectedData.toneMapHueShift);
      }
      if (injectedData.toneMapBlend) output_color = ToneMapBlend(output_color, vanilla_color);
    }
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
  if (injectedData.toneMapType == 0) {  // vanilla tonemap
    r0.xyz = ApplyVanillaTonemap(untonemapped, untonemapped_lum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);
    r0.xyz = applyVignette(r0.rgb, v2, v1, untonemapped_lum);
    r0.xyz = ApplyLUT(r0.rgb, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);

    output_color = r0.xyz;
  } else if (injectedData.toneMapType > 1.f) {
    const float exposure_bias = renodx::color::y::from::BT709(ApplyVanillaTonemap(0.18, untonemapped_lum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s));
    renodx::tonemap::config::DualToneMap dual_tone_map = ApplyDualToneMap(untonemapped, exposure_bias);

    float3 vignette_hdr = applyVignette(dual_tone_map.color_hdr, v2, v1, untonemapped_lum);
    float3 vignette_sdr = applyVignette(dual_tone_map.color_sdr, v2, v1, untonemapped_lum);
    float3 lut_output_color = applyDualLUT(
        vignette_sdr, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s,
        SamplerTargetColourLUT_TEX, SamplerTargetColourLUT_SMP_s, v1);

    output_color = UpgradeToneMap(vignette_hdr, vignette_sdr, lut_output_color, 1.f);

    if (injectedData.toneMapHueShift || injectedData.toneMapBlend) {
      float3 vanilla_color = ApplyVanillaTonemap(untonemapped, untonemapped_lum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);
      vanilla_color = applyVignette(vanilla_color, v2, v1, untonemapped_lum);
      vanilla_color = applyDualLUT(
          vanilla_color, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s,
          SamplerTargetColourLUT_TEX, SamplerTargetColourLUT_SMP_s, v1);
      if (injectedData.toneMapHueShift) {
        output_color = renodx::color::correct::Hue(output_color, vanilla_color, injectedData.toneMapHueShift);
      }
      if (injectedData.toneMapBlend) output_color = ToneMapBlend(output_color, vanilla_color);
    }
  }

  return output_color;
}

float3 ApplyToneMapVignette(
    float3 untonemapped, float untonemapped_lum, float4 v1, float4 v2,
    Texture2D<float4> SamplerToneMapCurve_TEX, SamplerState SamplerToneMapCurve_SMP_s) {
  float3 r0 = untonemapped;

  float3 output_color = r0.xyz;
  if (injectedData.toneMapType == 0) {  // vanilla tonemap
    r0.xyz = ApplyVanillaTonemap(untonemapped, untonemapped_lum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);
    r0.xyz = applyVignette(r0.rgb, v2, v1, untonemapped_lum);

    output_color = r0.xyz;
  } else if (injectedData.toneMapType > 1.f) {  // ACES & RenoDRT
    const float exposure_bias = renodx::color::y::from::BT709(ApplyVanillaTonemap(0.18, untonemapped_lum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s));
    float3 tonemapped = ApplySingleToneMap(untonemapped, exposure_bias);

    float3 vignette_hdr = applyVignette(tonemapped, v2, v1, untonemapped_lum);
    if (injectedData.toneMapHueShift || injectedData.toneMapBlend) {
      float3 vanilla_color = ApplyVanillaTonemap(untonemapped, untonemapped_lum, SamplerToneMapCurve_TEX, SamplerToneMapCurve_SMP_s);
      vanilla_color = applyVignette(vanilla_color, v2, v1, untonemapped_lum);
      if (injectedData.toneMapHueShift) {
        output_color = renodx::color::correct::Hue(output_color, vanilla_color, injectedData.toneMapHueShift);
      }
      if (injectedData.toneMapBlend) output_color = ToneMapBlend(output_color, vanilla_color);
    }
  }

  return output_color;
}
