// ---- Created with 3Dmigoto v1.4.1 on Tue Oct 28 22:08:02 2025

cbuffer _Globals : register(b4)
{
  bool gUnswizzleTexels : packoffset(c0);
  float2 gTextureWidthHeight : packoffset(c0.y);
  float2 gTextureInvWidthHeight : packoffset(c1);
  float4 gMiddleGreyMax : packoffset(c2);
  float3 gRTransform : packoffset(c3);
  float3 gGTransform : packoffset(c4);
  float3 gBTransform : packoffset(c5);
  bool gDistortionEnabled : packoffset(c5.w);
  bool gColorTransformEnabled : packoffset(c6);
  bool gScreenBlurEnabled : packoffset(c6.y);
  float4 gScreenToViewZParams : packoffset(c7);
  float4 gDOFParams : packoffset(c8);
  float gExponentParams : packoffset(c9);
  float4 gBrightMaskParams : packoffset(c10);
  float4 gReduct4Add[4] : packoffset(c11);
  float4 gReduct1Mul : packoffset(c15);
  float4 gReduct1Add : packoffset(c16);
  float4 gReductAveMul : packoffset(c17);
  float4 gToneMapLimits : packoffset(c18);
  int gReduct1Width : packoffset(c19);
  int gReduct1Height : packoffset(c19.y);
  float4 gBloomFilterTapSamples[32] : packoffset(c20);
  float4 gBloomFilterTapScales[32] : packoffset(c52);
  int gBloomNumSamples : packoffset(c84);
  float4 gFilterAdaptationParams : packoffset(c85);
  float gContrast : packoffset(c86);
  float gGamma : packoffset(c86.y);
  float4 gGaussBlurOffsets[16] : packoffset(c87);
  float4 gGaussBlurWeights[16] : packoffset(c103);
  float4 gRadialBlur : packoffset(c119);
}

SamplerState gPointSampler_s : register(s0);
SamplerState gLinearSampler_s : register(s1);
Texture2D<float4> gTexture0 : register(t0);
Texture2D<float4> gTexture1 : register(t1);
Texture2D<float4> gTexture7 : register(t2);
Texture2D<float4> gTexture2 : register(t3);
Texture2D<float4> gTexture4 : register(t4);
Texture2D<float4> gTexture5 : register(t5);
Texture2D<float4> gTexture6 : register(t6);


// 3Dmigoto declarations
#define cmp -


// Post-process composite pass that rebuilds the final HDR buffer with optional distortion,
// tile unswizzle, depth-of-field focus blend, bloom contribution, and color transform.
void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  float4 v1 : SV_Position0,
  out float4 o0 : SV_Target0)
{
  float4 r0,r1,r2,r3,r4;
  uint4 bitmask, uiDest;
  float4 fDest;

  float4 x0[16];
  // Precomputed Morton order remap used when the scene color buffer was swizzled into 4x4 tiles.
  x0[0].xy = float2(0,0);
  x0[1].xy = float2(2,0);
  x0[2].xy = float2(1,0);
  x0[3].xy = float2(3,0);
  x0[4].xy = float2(0,2);
  x0[5].xy = float2(2,2);
  x0[6].xy = float2(1,2);
  x0[7].xy = float2(3,2);
  x0[8].xy = float2(0,1);
  x0[9].xy = float2(2,1);
  x0[10].xy = float2(1,1);
  x0[11].xy = float2(3,1);
  x0[12].xy = float2(0,3);
  x0[13].xy = float2(2,3);
  x0[14].xy = float2(1,3);
  x0[15].xy = float2(3,3);
  // Start with base UVs from two texture coordinate sets.
  r0.xy = v0;
  r0.zw = w0;
  if (gDistortionEnabled != 0) {
    // Apply refraction/distortion UV offset before sampling any screen-space textures.
    float2 distortion = gTexture4.Sample(gLinearSampler_s, r0.xy).xy;
    r0.xy += distortion;
    r0.zw += distortion;
  }
  if (gUnswizzleTexels != 0) {
    // Walk the 4x4 swizzle pattern and convert back to linear UV addressing.
    r1.xy = gTextureWidthHeight.xy * r0.xy;
    r1.xy = floor(r1.xy);
  r2.xyzw = float4(4,4,0.25,0.25) * r1.xyxy;
  float4 positiveScale = float4(4,4,0.25,0.25);
  float4 negativeScale = float4(-4,-4,-0.25,-0.25);
  float4 selectMask = step(0.0, r2.xyxy);
  r3.xyzw = lerp(negativeScale, positiveScale, selectMask);
    r1.xy = r3.zw * r1.xy;
    r1.xy = frac(r1.xy);
    r1.xy = r3.xy * r1.xy;
    r1.zw = floor(r2.zw);
  r1.xy = (uint2)r1.xy;
  r1.y = (uint)r1.y << 2;
  r1.x = (int)r1.x + (int)r1.y;
  uint tileIndex = (uint)r1.x;
  r1.xy = x0[tileIndex].xy;
    r1.xy = r1.zw * float2(4,4) + r1.xy;
    r1.zw = float2(0.5,0.5) * gTextureInvWidthHeight.xy;
    r1.xy = r1.xy * gTextureInvWidthHeight.xy + r1.zw;
  } else {
    r1.xy = r0.xy;
  }
  // Scene color sampled either through the unswizzled UV or the original UVs.
  r1.xyz = gTexture0.Sample(gPointSampler_s, r1.xy).xyz;
  r1.xyz = max(float3(0,0,0), r1.xyz);
  // gTexture5/6 hold blurred variants used for dof/bloom blending.
  r2.xyz = gTexture5.Sample(gLinearSampler_s, r0.zw).xyz;
  r3.xyz = gTexture6.Sample(gLinearSampler_s, r0.zw).xyz;
  // Reconstruct linear depth to drive focus blending.
  float depthSample = gTexture7.Sample(gPointSampler_s, r0.xy).x;
  float linearDepth = 1.0 / (depthSample * gScreenToViewZParams.x + gScreenToViewZParams.y);
  float focusPlane = gScreenToViewZParams.z;
  float nearBlur = gDOFParams.y * (focusPlane - linearDepth);
  float farBlur = gDOFParams.z * (linearDepth - focusPlane);
  float focusAmount = saturate((linearDepth < focusPlane) ? nearBlur : farBlur);
  r0.x = focusAmount;
  r0.y = min(1.0, focusAmount * 2.0);
  // Blend between near and far blur taps using the depth-derived weights.
  r4.xyz = r3.xyz + -r2.xyz;
  r2.xyz = r0.yyy * r4.xyz + r2.xyz;
  r2.xyz = r2.xyz + -r1.xyz;
  r1.xyz = r0.xxx * r2.xyz + r1.xyz;
  r2.xyz = r3.xyz + -r1.xyz;
  r2.xyz = gMiddleGreyMax.zzz * r2.xyz + r1.xyz;
  // Optional fullscreen blur toggle (screen-space bloom/AA accumulation).
  r1.xyz = gScreenBlurEnabled ? r2.xyz : r1.xyz;
  // Exposure statistics fetched from reduction buffers.
  r0.xy = gTexture1.Sample(gPointSampler_s, float2(0.5,0.5)).xy;
  r1.w = dot(r1.xyz, float3(0.213,0.714999974,0.0719999969));
  r2.x = gMiddleGreyMax.x * r1.w;
  r0.x = 9.99999975e-06 + r0.x;
  r0.x = r2.x / r0.x;
  r0.y = r0.y * r0.y + 9.99999975e-06;
  r0.y = r0.x / r0.y;
  r0.y = 1 + r0.y;
  r0.y = r0.x * r0.y;
  r0.x = 1 + r0.x;
  r0.x = r0.y / r0.x;
  // Re-apply exposure so that the scene matches the ACES-style auto exposure curve.
  r1.xyz = r1.xyz * r0.xxx;
  r0.x = 9.99999975e-06 + r1.w;
  r1.xyz = r1.xyz / r0.xxx;
  // Bloom contribution gets added before the color transform.
  r0.xyz = gTexture2.Sample(gLinearSampler_s, r0.zw).xyz;
  r0.xyz = r1.xyz + r0.xyz;
  // Optional color space conversion controlled by three channel transform vectors.
  r1.x = dot(r0.xyz, gRTransform.xyz);
  r1.y = dot(r0.xyz, gGTransform.xyz);
  r1.z = dot(r0.xyz, gBTransform.xyz);
  r1.xyz = r1.xyz + -r0.xyz;
  r1.xyz = gMiddleGreyMax.yyy * r1.xyz + r0.xyz;
  r0.xyz = gColorTransformEnabled ? r1.xyz : r0.xyz;
  // Apply gamma/exponent curve before writing the tonemapped output.
  r0.w = 1 / gExponentParams;
  r0.xyz = float3(0.000244140625,0.000244140625,0.000244140625) + r0.xyz;
  r0.xyz = log2(abs(r0.xyz));
  r0.xyz = r0.www * r0.xyz;
  o0.xyz = exp2(r0.xyz);
  o0.w = 1;
  return;
}