#include "./tonemap.hlsl"

SamplerState SamplerFrameBuffer_SMP_s : register(s6);
SamplerState SamplerDistortion_SMP_s : register(s7);
SamplerState SamplerBloomMap0_SMP_s : register(s8);
SamplerState SamplerQuarterSizeBlur_SMP_s : register(s9);
SamplerState SamplerColourLUT_SMP_s : register(s10);
SamplerState SamplerNoise_SMP_s : register(s12);
SamplerState SamplerToneMapCurve_SMP_s : register(s14);
SamplerState SamplerOverlay_SMP_s : register(s15);
Texture2D<float4> SamplerFrameBuffer_TEX : register(t6);
Texture2D<float4> SamplerDistortion_TEX : register(t7);
Texture2D<float4> SamplerBloomMap0_TEX : register(t8);
Texture2D<float4> SamplerQuarterSizeBlur_TEX : register(t9);
Texture3D<float4> SamplerColourLUT_TEX : register(t10);
Texture2D<float4> SamplerNoise_TEX : register(t12);
Texture2D<float4> SamplerToneMapCurve_TEX : register(t14);
Texture2D<float4> SamplerOverlay_TEX : register(t15);

float3 applyVanillaTonemap(float3 untonemapped, float luminance) {
  float4 r0, r1, r2, r3, r4;

  // Luminance calculation
  r0.xyz = untonemapped;
  r0.w = luminance;
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

  // Adjust colors based on luminance
  r1.w = dot(float3(0.298999995, 0.587000012, 0.114), r0.xyz);
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

  // float3 mainTex = r2.xyz;

  // motion blur
  r1.xyz = HDR_EncodeScale.www * r2.xyz;
  r2.xyzw = SamplerQuarterSizeBlur_TEX.Sample(SamplerQuarterSizeBlur_SMP_s, r0.xy).xyzw;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = r2.xyz * r2.xyz;
  r2.xyz = HDR_EncodeScale2.zzz * r2.xyz;
  r0.z = sqrt(r2.w);
  r0.z = rp_parameter_ps[3].x * r0.z;
  r2.xyz = r2.xyz * float3(4, 4, 4) + -r1.xyz;
  r1.xyz = r0.zzz * r2.xyz + r1.xyz;

  r0.rgb = ApplyBloom(r1.rgb, r0.xy, SamplerBloomMap0_TEX, SamplerBloomMap0_SMP_s);

  float3 untonemapped = r0.xyz;
  const float untonemappedLum = renodx::color::luma::from::BT601(untonemapped);  // save for reuse

  float3 outputColor = ApplyToneMapVignetteLUT(
      untonemapped, untonemappedLum, v1, v2, SamplerToneMapCurve_TEX,
      SamplerToneMapCurve_SMP_s, SamplerColourLUT_TEX, SamplerColourLUT_SMP_s);

  // not present in default tonemap shader
  // related to fog?
  float3x4 fogMatrix = float3x4(rp_parameter_ps[4].xyzw, rp_parameter_ps[5].xyzw, rp_parameter_ps[6].xyzw);
  outputColor = mul(float4(outputColor, 1.0), transpose(fogMatrix));

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
