#include "./common.hlsl"

// ---- Created with 3Dmigoto v1.3.16 on Thu Jan 29 11:41:46 2026

cbuffer cbComposite : register(b2) {
  float4 g_vSceneTexSize : packoffset(c0);
  float4 g_vCompositeInfo : packoffset(c1);
  float4 g_vSun2dInfo : packoffset(c2);
  float4 g_vEtcEffect : packoffset(c3);
  float4 g_vBloomInfo : packoffset(c4);
  float4 g_vLimbDarkenningInfo : packoffset(c5);
  float4 g_vFxaaParams : packoffset(c6);
  float4 g_vGammaCorrection : packoffset(c7);
  float4 g_vRadialBlurCenter : packoffset(c8);
  float4 g_vRadialBlurInfo : packoffset(c9);
  float4 g_vFxaaQualityParams : packoffset(c10);
  float4 g_vCompositeLastViewport : packoffset(c11);
  float4 g_vMaxUV : packoffset(c12);
  float4 g_vMinUV : packoffset(c13);
  float4 g_vP2V : packoffset(c14);
  float4x4 g_mV2W : packoffset(c15);
  float4 g_vDramaticHdrLutInfo0[2] : packoffset(c19);
  float4 g_vDramaticHdrLutInfo1[2] : packoffset(c21);
  float4 g_vDrawFixParams : packoffset(c23);
  float4 g_vDistortionParams : packoffset(c24);
  float4 g_vVerticalLimbDarkenningTopInfo : packoffset(c25);
  float4 g_vVerticalLimbDarkenningBottomInfo : packoffset(c26);
}

SamplerState sampleLinear_s : register(s7);
Texture2D<float4> g_tSceneMap : register(t0);
Texture2D<float4> g_tLensFlareMap : register(t1);
Texture2D<float4> g_tExposureScaleInfo : register(t2);
Texture3D<float4> g_tHdrLut : register(t3);
Texture3D<float4> g_tLdrLut : register(t4);

// 3Dmigoto declarations
#define cmp -

void main(
    float4 v0: SV_Position0,
    float2 v1: TEXCOORD0,
    out float4 o0: SV_Target0) {
  const float4 icb[] = { { 0, 0, 1.000000, 0 },
                         { 0, 1.000000, 0, 0 },
                         { 1.000000, 0, 0, 0 },
                         { 1.000000, 0, 0, 0 },
                         { 0, 1.000000, 0, 0 },
                         { 0, 0, 1.000000, 0 },
                         { 0, 1.000000, 0, 0 },
                         { 1.000000, 0, 0, 0 },
                         { 1.000000, 0, 1.000000, 0 },
                         { 1.000000, 0, 1.000000, 0 },
                         { 1.000000, 0, 0, 0 },
                         { 0, 1.000000, 0, 0 } };
  float4 r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12;
  uint4 bitmask, uiDest;
  float4 fDest;

  r0.x = cmp(0 < g_vSun2dInfo.z);
  r0.y = cmp(0 < g_vLimbDarkenningInfo.w);
  r0.zw = cmp(float2(0, 0) < g_vDrawFixParams.xy);
  r1.x = cmp(0 < g_vVerticalLimbDarkenningTopInfo.x);
  r1.y = cmp(0 < g_vVerticalLimbDarkenningBottomInfo.x);
  r1.z = cmp(g_vCompositeInfo.z < 0);
  r1.w = g_tExposureScaleInfo.Load(float4(0, 0, 0, 0)).x;
  r2.xy = cmp(float2(0, 0) < g_vCompositeInfo.zy);
  r2.x = r2.x ? g_vCompositeInfo.z : 1;
  r1.z = r1.z ? r1.w : r2.x;
  r2.xz = v1.xy * g_vCompositeLastViewport.zw + g_vCompositeLastViewport.xy;
  r3.xy = cmp(g_vDistortionParams.xy != float2(0, 0));
  r1.w = (int)r3.y | (int)r3.x;
  r3.yz = float2(-0.5, -0.5) + r2.xz;
  r3.x = g_vCompositeInfo.x * r3.y;
  r2.w = dot(r3.xz, r3.xz);
  r3.y = r2.w * r2.w;
  r2.w = g_vDistortionParams.x * r2.w + 1;
  r2.w = g_vDistortionParams.y * r3.y + r2.w;
  r3.yz = r2.ww * r3.xz;
  r3.x = r3.y / g_vCompositeInfo.x;
  r3.xy = r3.xz * g_vDistortionParams.zz + float2(0.5, 0.5);
  r2.xz = r1.ww ? r3.xy : r2.xz;
  r3.xyz = g_tSceneMap.SampleLevel(sampleLinear_s, r2.xz, 0).xyz;
  r3.xyz = min(float3(65024, 65024, 65024), r3.xyz);
  r1.w = cmp(0 < g_vEtcEffect.x);
  if (r1.w != 0) {
    r1.w = (uint)g_vEtcEffect.y;
    r4.xy = r2.xz * float2(2, 2) + float2(-1, -1);
    r2.w = dot(r4.xy, r4.xy);
    r4.xy = r4.xy * r2.ww;
    r4.xy = g_vEtcEffect.xx * r4.xy;
    r4.zw = g_vSceneTexSize.xy * -r4.xy;
    r4.zw = float2(0.5, 0.5) * r4.zw;
    r2.w = dot(r4.zw, r4.zw);
    r2.w = sqrt(r2.w);
    r2.w = (int)r2.w;
    r2.w = max(3, (int)r2.w);
    r2.w = min(16, (int)r2.w);
    r3.w = (int)r2.w;
    r4.xy = -r4.xy / r3.ww;
    r5.xyz = icb[r1.w + 0].xyz * r3.xyz;
    r4.zw = (int2)r1.ww + int2(1, 2);
    r6.xyz = icb[r4.z + 0].xyz + -icb[r1.w + 0].xyz;
    r7.xyz = icb[r4.w + 0].xyz + -icb[r4.z + 0].xyz;
    r8.xyz = r5.xyz;
    r9.xyz = icb[r1.w + 0].xyz;
    r10.xy = r2.xz;
    r4.w = 1;
    while (true) {
      r5.w = cmp((int)r4.w >= (int)r2.w);
      if (r5.w != 0) break;
      r10.xy = r10.xy + r4.xy;
      r11.xyz = g_tSceneMap.SampleLevel(sampleLinear_s, r10.xy, 0).xyz;
      r11.xyz = min(float3(65024, 65024, 65024), r11.xyz);
      r5.w = (int)r4.w;
      r5.w = r5.w / r3.w;
      r6.w = cmp(r5.w < 0.5);
      if (r6.w != 0) {
        r6.w = r5.w + r5.w;
        r12.xyz = r6.www * r6.xyz + icb[r1.w + 0].xyz;
      } else {
        r5.w = r5.w * 2 + -1;
        r12.xyz = r5.www * r7.xyz + icb[r4.z + 0].xyz;
      }
      r8.xyz = r11.xyz * r12.xyz + r8.xyz;
      r9.xyz = r12.xyz + r9.xyz;
      r4.w = (int)r4.w + 1;
    }
    r3.xyz = r8.xyz / r9.xyz;
  }
  r3.xyz = r3.xyz * r1.zzz;
  if (r0.z != 0) {
    r0.z = dot(v0.xy, float2(171, 231));
    r4.xyz = float3(0.00970873795, 0.0140845068, 0.010309278) * r0.zzz;
    r4.xyz = frac(r4.xyz);
    r4.xyz = r4.xyz * float3(0.00392156886, 0.00392156886, 0.00392156886) + r3.xyz;
    r4.xyz = float3(-0.00196078443, -0.00196078443, -0.00196078443) + r4.xyz;
    r3.xyz = max(float3(0, 0, 0), r4.xyz);
  }
  if (r0.x != 0) {
    r4.xyz = g_tSceneMap.SampleLevel(sampleLinear_s, g_vSun2dInfo.xy, 0).xyz;
    r4.xyz = min(float3(65024, 65024, 65024), r4.xyz);
    r4.xyz = r4.xyz * r1.zzz;
    r5.xyz = g_tLensFlareMap.SampleLevel(sampleLinear_s, r2.xz, 0).xyz;
    r5.xyz = min(float3(65024, 65024, 65024), r5.xyz);
    r0.x = dot(r4.xyz, float3(0.222014993, 0.706655025, 0.0713300034));
    r0.x = cmp(g_vEtcEffect.w < r0.x);
    r0.x = r0.x ? g_vEtcEffect.z : 0;
    r4.xyz = r5.xyz * r4.xyz;
    r3.xyz = r4.xyz * r0.xxx + r3.xyz;
  }
  if (r0.y != 0) {
    r0.xz = float2(-0.5, -0.5) + v1.xy;
    r0.y = g_vCompositeInfo.x * r0.x;
    r0.x = dot(r0.yz, r0.yz);
    r0.y = sqrt(r0.x);
    r0.y = -g_vLimbDarkenningInfo.y + r0.y;
    r0.z = cmp(0 < r0.y);
    r0.y = saturate(-r0.y * g_vLimbDarkenningInfo.z + 1);
    r0.y = r0.z ? r0.y : 1;
    r0.z = cmp(0 < r0.y);
    r0.x = g_vLimbDarkenningInfo.x + r0.x;
    r0.x = g_vLimbDarkenningInfo.x / r0.x;
    r0.x = r0.x * r0.x;
    r0.x = r0.z ? r0.x : 1;
    r0.x = r0.x * r0.y;
    r0.y = 1 + -g_vLimbDarkenningInfo.w;
    r0.x = r0.x * g_vLimbDarkenningInfo.w + r0.y;
    r3.xyz = r3.xyz * r0.xxx;
  }
  if (r1.x != 0) {
    r0.x = 1 + -r2.z;
    r0.x = -g_vVerticalLimbDarkenningTopInfo.y + r0.x;
    r0.x = g_vVerticalLimbDarkenningTopInfo.z * r0.x;
    r0.y = cmp(r0.x >= 1);
    if (r0.y != 0) {
      r0.y = 1 + -g_vVerticalLimbDarkenningTopInfo.x;
    } else {
      r0.z = cmp(0 < r0.x);
      r0.x = max(0, r0.x);
      r0.x = log2(r0.x);
      r0.x = g_vVerticalLimbDarkenningTopInfo.w * r0.x;
      r0.x = exp2(r0.x);
      r0.x = 1 + -r0.x;
      r0.x = r0.x * r0.x;
      r1.x = 1 + -g_vVerticalLimbDarkenningTopInfo.x;
      r0.x = r0.x * g_vVerticalLimbDarkenningTopInfo.x + r1.x;
      r0.y = r0.z ? r0.x : 1;
    }
    r3.xyz = r3.xyz * r0.yyy;
  }
  if (r1.y != 0) {
    r0.x = -g_vVerticalLimbDarkenningBottomInfo.y + r2.z;
    r0.x = g_vVerticalLimbDarkenningBottomInfo.z * r0.x;
    r0.y = cmp(r0.x >= 1);
    if (r0.y != 0) {
      r0.y = 1 + -g_vVerticalLimbDarkenningBottomInfo.x;
    } else {
      r0.z = cmp(0 < r0.x);
      r0.x = max(0, r0.x);
      r0.x = log2(r0.x);
      r0.x = g_vVerticalLimbDarkenningBottomInfo.w * r0.x;
      r0.x = exp2(r0.x);
      r0.x = 1 + -r0.x;
      r0.x = r0.x * r0.x;
      r1.x = 1 + -g_vVerticalLimbDarkenningBottomInfo.x;
      r0.x = r0.x * g_vVerticalLimbDarkenningBottomInfo.x + r1.x;
      r0.x = lerp(1.f, r0.x, CUSTOM_VIGNETTE);

      r0.y = r0.z ? r0.x : 1;
    }
    r3.xyz = r3.xyz * r0.yyy;
  }

  float3 untonemapped = r3.rgb;
#if 0
  r0.xyz = r3.xyz * float3(1.00006652, 1.00006652, 1.00006652) + float3(-0.00391646381, -0.00391646381, -0.00391646381);
  r0.xyz = r0.www ? r0.xyz : r3.xyz;
  r0.xyz = r0.xyz * float3(5.55555582, 5.55555582, 5.55555582) + float3(0.0479959995, 0.0479959995, 0.0479959995);
  r0.xyz = log2(r0.xyz);
  r0.xyz = saturate(r0.xyz * float3(0.0734997839, 0.0734997839, 0.0734997839) + float3(0.386036009, 0.386036009, 0.386036009));
  r0.xyz = g_tHdrLut.SampleLevel(sampleLinear_s, r0.xyz, 0).xyz;
#else
  r0.rgb = SampleHDRLUT(untonemapped, sampleLinear_s, g_tHdrLut);
#endif

  if (r2.y != 0) {
    // r1.xyz = saturate(r0.xyz);
    // r1.xyz = log2(r1.xyz);
    // r1.xyz = float3(0.454545468, 0.454545468, 0.454545468) * r1.xyz;
    // r1.xyz = exp2(r1.xyz);
    // r1.xyz = g_tLdrLut.SampleLevel(sampleLinear_s, r1.xyz, 0).xyz;
    // r1.xyz = r1.xyz + -r0.xyz;
    // r0.xyz = g_vCompositeInfo.yyy * r1.xyz + r0.xyz;

    float3 lutOutput = SampleSDRLUT(r0.rgb, sampleLinear_s, g_tLdrLut);
    r0.rgb = lerp(r0.rgb, lutOutput, g_vCompositeInfo.yyy);
  }
  // r0.w = cmp(g_vGammaCorrection.x != 1.000000);
  // r1.xyz = log2(abs(r0.xyz));
  // r1.xyz = g_vGammaCorrection.xxx * r1.xyz;
  // r1.xyz = exp2(r1.xyz);
  // r0.xyz = r0.www ? r1.xyz : r0.xyz;
  o0.xyz = g_vRadialBlurCenter.zzz * r0.xyz;
  o0.w = 1;

  o0 = ProcessColor(o0);
  return;
}
