#include "./common.hlsli"

// ---- Created with 3Dmigoto v1.4.1 on Sun Jun 21 01:32:58 2026
Texture2D<uint4> t7 : register(t7);

Texture2D<float4> t6 : register(t6);

Texture2D<float4> t5 : register(t5);

Texture2D<float4> t4 : register(t4);

Texture2D<float4> t3 : register(t3);

Texture2D<float4> t2 : register(t2);

Texture3D<float4> t1 : register(t1);

Texture2D<float4> t0 : register(t0);

SamplerState s6_s : register(s6);

SamplerState s5_s : register(s5);

SamplerState s4_s : register(s4);

SamplerState s3_s : register(s3);

SamplerState s2_s : register(s2);

SamplerState s1_s : register(s1);

SamplerState s0_s : register(s0);

cbuffer cb0 : register(b0) {
  float4 cb0[19];
}

// 3Dmigoto declarations
#define cmp -

// This shader is the main post-process color grading pass.
// High-level flow:
// 1. Optionally distort the source UVs.
// 2. Optionally use auxiliary buffers to adjust mip/sample position and reconstruct split channels.
// 3. Composite bloom/glow and lens/vignette style effects into the scene color.
// 4. Apply exposure/contrast-style grading, optional 2D/3D LUTs, and LMS white-balance.
// 5. Output the graded scene color and pass through an auxiliary uint render target from t7.
//
// cb0[0].x is used as a packed feature bitfield. Inferred bits used here:
//   1     = LMS color-temperature / white-balance block
//   2     = 2D colorgrade/ramp LUT block
//   4     = 3D LUT block
//   8     = radial UV distortion block
//   16    = alternate radial distortion formula
//   32    = auxiliary t5 blend/reconstruction block
//   64    = motion/noise offset + mip bias block
//   128   = split-channel reconstruction sampling
//   256   = additive bloom/glow block
//   512   = vignette/falloff block
//   1024  = bloom tint/color modulation block
//   2048  = adaptive 2D LUT strength from scene luminance
//   4096  = alpha/luminance metadata output in o0.w
//   8192  = preserve chroma from t4 LUT instead of using red-only ramp

void main(
    float4 v0: SV_Position0,
    float4 v1: TEXCOORD0,
    float2 v2: TEXCOORD1,
    out float4 o0: SV_Target0,
    out uint2 o1: SV_Target1) {
  float4 r0, r1, r2, r3, r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  // Decode the first group of feature toggles from cb0[0].x.
  // r0.x: radial UV distortion, r0.y: offset/mip source, r0.z: split-channel sampling, r0.w: t5 blend.
  r0.xyzw = asint(cb0[0].xxxx) & int4(8, 64, 128, 32);

  // Optional radial lens/film distortion around the center of the screen.
  // The distorted UV is written to r1.xy and used for most texture reads below.
  if (r0.x != 0) {
    r1.xy = float2(-0.5, -0.5) + v2.xy;
    r1.zw = cb0[4].zw * r1.xy;
    r1.zw = r1.zw * r1.zw;
    r0.x = r1.z + r1.w;
    r1.z = asint(cb0[0].x) & 16;
    if (r1.z != 0) {
      // Alternate polynomial radial scale.
      r1.z = r0.x * cb0[2].x + 1;
      r1.z = cb0[2].z * r1.z;
    } else {
      // Default radial scale uses distance plus squared-distance terms.
      r1.w = sqrt(r0.x);
      r1.w = cb0[2].y * r1.w + cb0[2].x;
      r0.x = r0.x * r1.w + 1;
      r1.z = cb0[2].z * r0.x;
    }
    r1.xy = r1.xy * r1.zz + float2(0.5, 0.5);
  } else {
    r1.xy = v2.xy;
  }

  // Optional auxiliary offset/mip selection from t2.
  // t2.rgb appears to carry a UV offset in xy and a blur/mip control in z.
  if (r0.y != 0) {
    r2.xyz = t2.Sample(s2_s, r1.xy).xyz;
    r0.xy = r2.xy * cb0[3].xy + cb0[3].zw;
    r1.xy = r1.xy + r0.xy;
    r0.x = r2.z * r2.z;
    r0.x = r0.x * cb0[2].w + 1;
    r0.x = log2(r0.x);
  } else {
    r0.x = 0;
  }

  // Sample the base scene color from t0 at the final UV and selected mip level.
  r2.xyz = t0.SampleLevel(s0_s, r1.xy, r0.x).xyz;
  r2.xyz = max(float3(0, 0, 0), r2.xyz);

  float3 color_input = r2.rgb;

  // Convert the current UV into integer texel coordinates for t7 and load an auxiliary uint2.
  // This shader passes that value through to o1 at the end.
  t7.GetDimensions(0, uiDest.x, uiDest.y, uiDest.z);
  r1.zw = uiDest.xy;
  r1.zw = (uint2)r1.zw;
  r1.zw = r1.xy * r1.zw;
  r1.zw = floor(r1.zw);
  r3.xy = (uint2)r1.zw;
  r3.zw = float2(0, 0);
  r1.zw = t7.Load(r3.xyz).xy;

  // Optional split-channel reconstruction for t0.
  // Red and green are sampled at separately warped UVs while blue remains from the base sample.
  if (r0.z != 0) {
    r3.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r1.xyxy;
    r3.xyzw = r3.xyzw + r3.xyzw;
    r3.xyzw = r3.xyzw * cb0[13].xyzw + float4(0.5, 0.5, 0.5, 0.5);
    r2.x = t0.SampleLevel(s0_s, r3.xy, r0.x).x;
    r2.y = t0.SampleLevel(s0_s, r3.zw, r0.x).y;
  }

  // Optional t5-driven blend/reconstruction pass.
  // t5.rgb is squared before use, while t5.a acts as the blend amount scaled by cb0[4].x.
  // With split-channel sampling enabled, each channel can use its own warped sample/blend amount.
  if (r0.w != 0) {
    r3.xyzw = t5.Sample(s5_s, r1.xy).xyzw;
    r0.xyw = r3.xyz * r3.xyz;
    r3.x = cb0[4].x * r3.w;
    if (r0.z != 0) {
      r4.xyzw = float4(-0.5, -0.5, -0.5, -0.5) + r1.xyxy;
      r4.xyzw = r4.xyzw + r4.xyzw;
      r4.xyzw = r4.xyzw * cb0[13].xyzw + float4(0.5, 0.5, 0.5, 0.5);
      r3.yz = t5.Sample(s5_s, r4.xy).xw;
      r0.z = r3.y * r3.y;
      r3.y = cb0[4].x * r3.z;
      r3.zw = t5.Sample(s5_s, r4.zw).yw;
      r3.z = r3.z * r3.z;
      r3.w = cb0[4].x * r3.w;
      r0.z = r0.z * cb0[4].y + -r2.x;
      r2.x = r3.y * r0.z + r2.x;
      r0.z = r3.z * cb0[4].y + -r2.y;
      r2.y = r3.w * r0.z + r2.y;
      r0.z = r0.w * cb0[4].y + -r2.z;
      r2.z = r3.x * r0.z + r2.z;
    } else {
      r2.w = r2.z;
      r0.xyz = r0.xyw * cb0[4].yyy + -r2.xyw;
      r2.xyz = r3.xxx * r0.xyz + r2.xyw;
    }
  }

  // Decode the second group of feature toggles.
  // r0.x: additive t3 bloom/glow, r0.y: vignette/falloff, r0.z: 2D LUT/ramp, r0.w: LMS white-balance.
  r0.xyzw = asint(cb0[0].xxxx) & int4(256, 512, 2, 1);

  // Optional additive bloom/glow from t3.
  if (r0.x != 0) {
    r3.xyz = t3.Sample(s3_s, r1.xy).xyz;
    r3.xyz = cb0[5].xyz * r3.xyz;
    r0.x = asint(cb0[0].x) & 1024;
    if (r0.x != 0) {
      // Optional per-pixel bloom modulation from t6, remapped by cb0[16..18].
      r4.xyz = t6.Sample(s6_s, r1.xy).xyz;
      r4.xyz = saturate(r4.xyz);
      r4.xyz = log2(r4.xyz);
      r4.xyz = cb0[16].xyz * r4.xyz;
      r4.xyz = exp2(r4.xyz);
      r4.xyz = r4.xyz * cb0[17].xyz + cb0[18].xyz;
      r3.xyz = r4.xyz * r3.xyz;
    }
    r2.xyz = r3.xyz + r2.xyz;
  }
  // Global color scale/pivot adjustment.
  // This is equivalent to scaling the distance from cb0[7].xyz by cb0[6].xyz.
  r2.xyz = -cb0[7].xyz + r2.xyz;
  r2.xyz = cb0[6].xyz * r2.xyz + cb0[7].xyz;

  // Optional vignette or radial exposure falloff.
  // The mask is built from screen UVs and multiplied into the current scene color.
  if (r0.y != 0) {
    r0.xy = cb0[12].xy + v2.xy;
    r0.xy = cb0[10].xy * r0.xy;
    r0.x = dot(r0.xy, r0.xy);
    r0.x = saturate(-r0.x * cb0[11].w + 1);
    r0.x = log2(r0.x);
    r0.x = cb0[10].z * r0.x;
    r0.x = exp2(r0.x);
    r2.xyz = r2.xyz * r0.xxx;
  }

  // Optional 2D color grading/ramp LUT sampled from t4.
  // This quantizes the current color/luminance into a packed half-float-style coordinate system.
  if (r0.z != 0) {
    r0.xy = v2.xy * cb0[8].xy + cb0[8].zw;
    r0.xyz = t4.Sample(s4_s, r0.xy).xyz;
    r1.xy = asint(cb0[0].xx) & int2(8192, 2048);
    if (r1.x != 0) {
      // Preserve t4 chroma by blending each channel toward its luminance using cb0[14].w.
      r1.x = dot(r0.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
      r3.xyz = -r1.xxx + r0.xyz;
      r3.xyz = cb0[14].www * r3.xyz + r1.xxx;
    } else {
      // Otherwise use t4 red as a monochrome ramp.
      r3.xyz = r0.xxx;
    }
    r0.xyz = float3(-0.5, -0.5, -0.5) + r3.xyz;
    if (r1.y != 0) {
      // Make LUT strength adaptive to current scene luminance.
      r1.x = dot(r2.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
      r1.x = cb0[1].x * r1.x;
      r1.x = f32tof16(r1.x);
      r1.x = (uint)r1.x;
      r1.x = r1.x * cb0[1].y + -cb0[15].x;
      r3.xy = cb0[15].yw + -cb0[15].xz;
      r1.y = 0.00100000005 + r3.x;
      r1.x = saturate(r1.x / r1.y);
      r1.x = r1.x * r3.y + cb0[15].z;
      r3.xyz = cb0[9].xyz * r1.xxx;
    } else {
      r3.xyz = cb0[9].xyz;
    }
    // Convert scene color to the LUT indexing domain, add the graded offset from t4,
    // clamp to the valid LUT range, then convert back from half-float-like encoded values.
    r4.xyz = cb0[1].xxx * r2.xyz;
    r4.xyz = f32tof16(r4.xyz);
    r4.xyz = (uint3)r4.xyz;
    r0.xyz = r3.xyz * r0.xyz;
    r0.xyz = saturate(r4.xyz * cb0[1].yyy + r0.xyz);
    r0.xyz = cb0[1].www * r0.xyz;
    r0.xyz = (uint3)r0.xyz;
    r0.xyz = f16tof32(r0.xyz);
    r2.xyz = cb0[1].zzz * r0.xyz;
  }

  // Optional LMS-domain white balance / color-temperature adjustment.
  // The first matrix converts scene RGB to an LMS-like cone-response space,
  // cb0[14].xyz scales LMS channels, and the second matrix converts back to RGB.
  if (r0.w != 0) {  // LMS color temperature
    r0.x = dot(float3(0.295775771, 0.623078883, 0.0811608657), r2.xyz);
    r0.y = dot(float3(0.156185895, 0.727243543, 0.116516791), r2.xyz);
    r0.z = dot(float3(0.0351171643, 0.156598315, 0.808349252), r2.xyz);
    r0.xyz = cb0[14].xyz * r0.xyz;
    r2.x = dot(float3(6.17299318, -5.32050371, 0.147119075), r0.xyz);
    r2.y = dot(float3(-1.32386422, 2.5601418, -0.236103922), r0.xyz);
    r2.z = dot(float3(-0.0117062014, -0.264827281, 1.27643752), r0.xyz);
  }

  // Clamp negative color before the final LUT/output stages.
  r0.xyz = max(float3(0, 0, 0), r2.xyz);

  // Decode final feature toggles.
  // r1.x: 3D LUT, r1.y: output alpha/luminance metadata.
  r1.xy = asint(cb0[0].xx) & int2(4, 4096);

  // Optional 3D color LUT from t1.
  // Color is transformed into a normalized half-float-like LUT coordinate range before sampling.
  if (r1.x != 0) {
    r2.xyz = cb0[1].xxx * r0.xyz;

    r2.xyz = f32tof16(r2.xyz);
    r2.xyz = (uint3)r2.xyz;
    r2.xyz = cb0[1].yyy * r2.xyz;


    r2.xyz = r2.xyz * float3(0.96875, 0.96875, 0.96875) + float3(0.015625, 0.015625, 0.015625);
    r0.xyz = t1.SampleLevel(s1_s, r2.xyz, 0).xyz;
  }

  // Optional alpha/metadata output derived from graded luminance.
  // When disabled, alpha is forced to 1.
  if (r1.y != 0) {
    r1.x = dot(r0.xyz, float3(0.212599993, 0.715200007, 0.0722000003));
    r1.x = cb0[1].x * r1.x;
    r1.x = f32tof16(r1.x);
    r1.x = (uint)r1.x;
    r0.w = cb0[1].y * r1.x;
  } else {
    r0.w = 1;
  }

  // Output final graded color/metadata and pass through the uint2 value loaded from t7.
  o0.xyzw = r0.xyzw;
  o1.xy = r1.zw;


  return;
}
