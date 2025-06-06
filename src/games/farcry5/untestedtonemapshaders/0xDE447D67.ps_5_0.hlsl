// ---- Created with 3Dmigoto v1.4.1 on Sun Apr 20 14:50:02 2025

#include "../common.hlsli"

SamplerState Clamp_s : register(s0);
SamplerState PointClamp_s : register(s1);
Texture2D<float4> ColorSampler : register(t0);
Texture2D<float4> ColorAndMaskTexture : register(t1);
Texture2D<float4> CombinedBloomTexture : register(t2);
Texture2D<float> LinearDepthSampler : register(t3);
Texture3D<float4> ColorRemap0VolumeSampler : register(t4);
Texture2D<float4> ColorMaskTexture : register(t5);
Texture2D<float> LocalExposureTexture : register(t6);
Texture2D<float4> NoiseTexture : register(t7);


// 3Dmigoto declarations
#define cmp -


void main(
  float4 v0 : SV_Position0,
  float2 v1 : TEXCOORD0,
  uint v2 : SV_IsFrontFace0,
  out float4 o0 : SV_Target0,
  out float4 o1 : SV_Target1)
{
  float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = LinearDepthSampler.SampleLevel(PointClamp_s, v1.xy, 0).x;
  r0.yzw = ColorSampler.SampleLevel(PointClamp_s, v1.xy, 0, int2(0, 0)).xyz;
  r0.yzw = max(float3(0,0,0), r0.yzw);
  r1.xyzw = ColorAndMaskTexture.SampleLevel(Clamp_s, v1.xy, 0).xyzw;
  r1.xyzw = max(float4(0,0,0,0), r1.xyzw);
  r1.xyzw = min(float4(5000,5000,5000,5000), r1.xyzw);
  r2.xy = r0.xx * FocusDistances.xz + FocusDistances.yw;
  r0.x = cmp(r0.x < FocusPlane);
  r0.x = r0.x ? r2.x : r2.y;
  r0.x = min(1, abs(r0.x));
  r0.x = r0.x * r0.x;
  r0.x = saturate(r0.x * BokehParams.z + -0.5);
  r0.x = max(r0.x, r1.w);
  r0.xyzw = min(float4(1,65000,65000,65000), r0.xyzw);
  r2.xyz = CombinedBloomTexture.SampleLevel(Clamp_s, v1.xy, 0).xyz * CUSTOM_BLOOM;  // Apply Bloom Slider
  r1.xyz = r1.xyz + -r0.yzw;
  r0.xyz = r0.xxx * r1.xyz + r0.yzw;
  r0.w = LocalExposureTexture.SampleLevel(Clamp_s, v1.xy, 0).x;
  r0.w = 11.4157457 + -r0.w;
  r0.w = max(-3, r0.w);
  r0.w = min(3, r0.w);
  r1.x = cmp(0 < r0.w);
  r1.x = r1.x ? LocalAdjustmentShadows : LocalAdjustmentHighlights;
  r0.w = r1.x * r0.w;
  r0.w = exp2(r0.w);
  r0.xyz = r0.xyz * r0.www + r2.xyz;
  r1.xy = float2(-0.5,-0.5) + v1.xy;
  r0.w = dot(r1.xy, r1.xy);
  r0.w = 1 + -r0.w;
  r0.w = max(0, r0.w);
  r0.w = log2(r0.w);
  r0.w = VignetteIntensity * r0.w;
  r0.w = exp2(r0.w);
  r0.xyz = r0.xyz * r0.www;

  float3 lut_input_color = r0.rgb;

  r0.w = dot(float3(0.597180009,0.354579985,0.0482299998), r0.xyz);
  r1.x = dot(float3(0.0759899989,0.908339977,0.0156599991), r0.xyz);
  r0.x = dot(float3(0.0284000002,0.133819997,0.837759972), r0.xyz);
  r0.y = log2(r0.w);
  r2.x = r0.y * 0.0588235296 + 0.527878284;
  r0.y = log2(r1.x);
  r2.y = r0.y * 0.0588235296 + 0.527878284;
  r0.x = log2(r0.x);
  r2.z = r0.x * 0.0588235296 + 0.527878284;
  r0.xyz = r2.xyz * float3(0.96875,0.96875,0.96875) + float3(0.015625,0.015625,0.015625);
  r0.xyz = ColorRemap0VolumeSampler.SampleLevel(Clamp_s, r0.xyz, 0).xyz;

  r0.rgb = ApplyVanillaGammaCorrection(r0.rgb);

  r0.rgb = LogDecodeLUT(r0.rgb);

  r0.rgb = LUTCorrectBlack(lut_input_color, r0.rgb, ColorRemap0VolumeSampler, Clamp_s);


  r1.xy = v1.xy * ColorMaskUVScaleBias.xy + ColorMaskUVScaleBias.zw;
  r1.xyzw = ColorMaskTexture.Sample(Clamp_s, r1.xy).xyzw;
  r2.xyz = ColorMaskColor.xyz * r1.xyz;
  r2.w = saturate(ColorMaskColor.w * r1.w + ColorMaskAlphaOffset);
  r1.xyzw = cmp(ColorMaskBlendMode == int4(2,3,6,4));
  r0.w = (int)r1.y | (int)r1.x;
  r0.w = (int)r1.z | (int)r0.w;
  r3.xyzw = r2.xyzw * r2.wwww;
  r4.xyzw = float4(-1,-1,-1,-1) + r2.xyzw;
  r4.xyzw = r2.wwww * r4.xyzw + float4(1,1,1,1);
  r5.x = cmp(ColorMaskBlendMode == 5);
  r6.xyzw = float4(-0.5,-0.5,-0.5,-0.5) + r2.xyzw;
  r6.xyzw = r2.wwww * r6.xyzw + float4(0.5,0.5,0.5,0.5);
  r2.xyzw = r5.xxxx ? r6.xyzw : r2.xyzw;
  r2.xyzw = r1.wwww ? r4.xyzw : r2.xyzw;
  r2.xyzw = r0.wwww ? r3.xyzw : r2.xyzw;
  r3.xyz = r2.xyz + r0.xyz;
  r4.xyzw = float4(1,1,1,1) + -r2.xyzw;
  r6.xyz = r0.xyz * r4.xyz + r2.xyz;
  r7.xyz = r2.xyz * r0.xyz;
  r8.xyz = r7.xyz + r7.xyz;
  r9.xyz = -r2.xyz + r0.xyz;
  r2.xyz = r2.xyz + -r0.xyz;
  r0.xyz = r2.www * r2.xyz + r0.xyz;
  r0.w = NoiseIntensity * r4.w;
  r9.w = NoiseIntensity;
  r0.xyzw = r1.zzzz ? r9.xyzw : r0.xyzw;
  r8.w = NoiseIntensity;
  r0.xyzw = r5.xxxx ? r8.xyzw : r0.xyzw;
  r7.w = NoiseIntensity;
  r0.xyzw = r1.wwww ? r7.xyzw : r0.xyzw;
  r6.w = NoiseIntensity;
  r0.xyzw = r1.yyyy ? r6.xyzw : r0.xyzw;
  r3.w = NoiseIntensity;
  r0.xyzw = r1.xxxx ? r3.xyzw : r0.xyzw;

    r0.rgb = ApplyUserToneMap(r0.rgb);

  r1.xyz = float3(9.99999975e-05,9.99999975e-05,9.99999975e-05) * r0.xyz;
  r0.xyz = float3(0.0124999993,0.0124999993,0.0124999993) * r0.xyz;
  r0.xyz = SCRGB ? r0.xyz : r1.xyz;
  if (SCRGB != 0) {
    r1.x = dot(float3(1.60475004,-0.531080008,-0.0736699998), r0.xyz);
    r1.y = dot(float3(-0.102080002,1.10812998,-0.00604999997), r0.xyz);
    r1.z = dot(float3(-0.00325999991,-0.0727500021,1.07602), r0.xyz);

    if (RENODX_TONE_MAP_TYPE == 0.f) r1.rgb = max(0, r1.rgb);

  } else {
    r1.w = dot(float3(0.966957986,0.0251869,-0.00181166001), r0.xyz);
    r2.x = dot(float3(0.0168175008,0.981899023,0.00182385999), r0.xyz);
    r0.x = dot(float3(0.0140284002,0.0234305002,0.942865014), r0.xyz);
    r0.y = log2(abs(r1.w));
    r0.y = 0.159301758 * r0.y;
    r0.y = exp2(r0.y);
    r0.yz = r0.yy * float2(18.8515625,18.6875) + float2(0.8359375,1);
    r0.y = r0.y / r0.z;
    r0.y = log2(r0.y);
    r0.y = 78.84375 * r0.y;
    r1.x = exp2(r0.y);
    r0.y = log2(abs(r2.x));
    r0.y = 0.159301758 * r0.y;
    r0.y = exp2(r0.y);
    r0.yz = r0.yy * float2(18.8515625,18.6875) + float2(0.8359375,1);
    r0.y = r0.y / r0.z;
    r0.y = log2(r0.y);
    r0.y = 78.84375 * r0.y;
    r1.y = exp2(r0.y);
    r0.x = log2(abs(r0.x));
    r0.x = 0.159301758 * r0.x;
    r0.x = exp2(r0.x);
    r0.xy = r0.xx * float2(18.8515625,18.6875) + float2(0.8359375,1);
    r0.x = r0.x / r0.y;
    r0.x = log2(r0.x);
    r0.x = 78.84375 * r0.x;
    r1.z = exp2(r0.x);
  }
  r0.xy = (int2)NoiseTextureOffset.xy;
  r0.xy = v0.xy + r0.xy;
  r0.xy = (uint2)r0.xy;
  r2.xy = (uint2)r0.xy % (uint2)NoiseTextureSize.xy;
  r2.zw = float2(0,0);
  r0.xyz = NoiseTexture.Load(r2.xyz).xyz;
  r0.xyz = r0.xyz * float3(2,2,2) + float3(-1,-1,-1);
  r0.xyz = r0.www * r0.xyz + r1.xyz;
  r0.w = dot(r0.xyz, float3(0.212599993,0.715200007,0.0722000003));
  o0.xyzw = r0.xyzw;

  o0.rgb = renodx::color::bt709::clamp::BT2020(o0.rgb);

  o1.x = r0.w;
  o1.yzw = float3(0,0,0);
  return;
}