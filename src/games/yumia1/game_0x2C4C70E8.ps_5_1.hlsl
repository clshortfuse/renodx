// Open world tonemap shader
// Rewrite by Miru97

#include "./common.hlsl"

// Constant buffers
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

static const float3 BlurWeights[12] = {
  float3(0, 0, 1), float3(0, 1, 0), float3(1, 0, 0),
  float3(1, 0, 0), float3(0, 1, 0), float3(0, 0, 1),
  float3(0, 1, 0), float3(1, 0, 0), float3(1, 0, 1),
  float3(1, 0, 1), float3(1, 0, 0), float3(0, 1, 0)
};

// Textures and samplers
SamplerState sampleLinear : register(s7);
SamplerState samplePoint : register(s8);
Texture2D<float4> g_tSceneMap : register(t0);
Texture2D<float4> g_tLensFlareMap : register(t1);
Texture2D<float4> g_tExposureScaleInfo : register(t2);
Texture3D<float4> g_tHdrLut : register(t3);
Texture3D<float4> g_tLdrLut : register(t4);
Texture3D<float4> g_tDramaticHdrLut0 : register(t5);
Texture2D<float4> g_tDramaticHdrLutMask0 : register(t6);
Texture3D<float4> g_tDramaticHdrLut1 : register(t9);
Texture2D<float4> g_tDramaticHdrLutMask1 : register(t10);
Texture2D<float4> g_tSceneDepth : register(t11);

// Input structure
struct PS_INPUT {
  float4 Position : SV_Position0;
  float2 TexCoord : TEXCOORD0;
};

// Output structure
struct PS_OUTPUT {
  float4 Color : SV_Target0;
};

// Main pixel shader
PS_OUTPUT main(PS_INPUT input) {
  PS_OUTPUT output;

  // Initial checks
  bool enableSun = g_vSun2dInfo.z > 0;
  bool enableLimbDarkening = g_vLimbDarkenningInfo.w > 0;
  bool enableDrawFix0 = g_vDrawFixParams.x > 0;
  bool enableDrawFix1 = g_vDrawFixParams.y > 0;
  bool enableTopDarkening = g_vVerticalLimbDarkenningTopInfo.x > 0;
  bool enableBottomDarkening = g_vVerticalLimbDarkenningBottomInfo.x > 0;
  bool useExposureScale = g_vCompositeInfo.z < 0;

  // Exposure scale
  float exposureScale = useExposureScale ? g_tExposureScaleInfo.Load(int3(0, 0, 0)).x : (g_vCompositeInfo.z > 0 ? g_vCompositeInfo.z : 1.0);

  // Distortion coordinates
  float2 uv = input.TexCoord * g_vCompositeLastViewport.zw + g_vCompositeLastViewport.xy;
  bool applyDistortion = any(g_vDistortionParams.xy != 0);
  if (applyDistortion) {
    float2 centeredUV = uv - 0.5;
    centeredUV.x *= g_vCompositeInfo.x;

    // Center strength
    float r2 = dot(centeredUV, centeredUV);
    float r4 = r2 * r2;

    float distortion = 1.0 + g_vDistortionParams.x * r2 + g_vDistortionParams.y * r4;
    centeredUV *= distortion;
    centeredUV.x /= g_vCompositeInfo.x;
    uv = centeredUV * g_vDistortionParams.z + 0.5;
  }

  // Sample scene color
  float3 color = min(g_tSceneMap.SampleLevel(sampleLinear, uv, 0).rgb, 65024.0);

  // Bloom effect
  if (g_vEtcEffect.x > 0) {
    uint steps = (uint)g_vEtcEffect.y;
    float2 normalized_UV = (uv * 2.0 - 1.0);
    normalized_UV *= dot(normalized_UV, normalized_UV);
    normalized_UV = normalized_UV * g_vEtcEffect.x;  // normalize
    float2 blurStep = -normalized_UV * g_vSceneTexSize.xy * 0.5;
    float blurRadius = sqrt(dot(blurStep, blurStep));  // length
    int sampleCount = clamp((int)blurRadius, 3, 16);

    // float invSampleCount = 1.0 / sampleCount;
    normalized_UV = -normalized_UV / sampleCount;

    float3 blurWeight0 = BlurWeights[steps + 1] - BlurWeights[steps];
    float3 blurWeight1 = BlurWeights[steps + 2] - BlurWeights[steps + 1];
    float3 accumColor = color * BlurWeights[steps];
    float3 accumWeight = BlurWeights[steps];
    float3 blurColor, blurWeight;

    float2 currentUV = uv;

    for (int i = 1; i < sampleCount; i++) {
      currentUV += normalized_UV;
      float3 sampleColor = min(g_tSceneMap.SampleLevel(sampleLinear, currentUV, 0).rgb, 65024.0);
      float t = (float)i / sampleCount;
      if (t < 0.5) {
        t *= 2;
        blurWeight = blurWeight0 * t + BlurWeights[steps];
      } else {
        t = t * 2 - 1;
        blurWeight = blurWeight1 * t + BlurWeights[steps + 1];
      }
      accumColor += sampleColor * blurWeight;
      accumWeight += blurWeight;
    }

    color = accumColor / accumWeight;
  }

  color *= exposureScale;

  // Draw fix (dithering)
  if (enableDrawFix0) {
    float dither = dot(input.Position.xy, float2(171.0, 231.0));
    color += frac(dither * float3(0.00970873795, 0.0140845068, 0.010309278)) * 0.00392156886 - 0.00196078443;
    color = max(color, 0);
  }

  // Sun and lens flare
  if (enableSun) {
    float3 sunColor = min(g_tSceneMap.SampleLevel(sampleLinear, g_vSun2dInfo.xy, 0).rgb, 65024.0) * exposureScale;
    float3 flareColor = min(g_tLensFlareMap.SampleLevel(sampleLinear, uv, 0).rgb, 65024.0);
    float luminance = dot(sunColor, float3(0.222014993, 0.706655025, 0.0713300034));
    float flareFactor = (luminance > g_vEtcEffect.w) ? g_vEtcEffect.z : 0;
    color += sunColor * flareColor * flareFactor;
  }

  // Limb darkening
  if (enableLimbDarkening) {
    float2 centeredUV = input.TexCoord - 0.5;
    centeredUV.x *= g_vCompositeInfo.x;
    float r = sqrt(dot(centeredUV, centeredUV));

    float rMinusLimbDarkenning = r - g_vLimbDarkenningInfo.y;
    float darkening;
    darkening = (rMinusLimbDarkenning > 0) ? saturate(1.0 - rMinusLimbDarkenning * g_vLimbDarkenningInfo.z) : 1.0;

    float vignette = g_vLimbDarkenningInfo.x / (dot(centeredUV, centeredUV) + g_vLimbDarkenningInfo.x);
    darkening = (darkening > 0) ? (darkening * vignette * vignette) : darkening;
    darkening = (darkening - 1) * g_vLimbDarkenningInfo.w + 1;  // lerp
    color *= darkening;
  }

  // Vertical limb darkening (top)
  if (enableTopDarkening) {
    float v = 1.0 - uv.y - g_vVerticalLimbDarkenningTopInfo.y;
    v *= g_vVerticalLimbDarkenningTopInfo.z;
    float darkening;
    if (v >= 1.0)
      darkening = 1.0 - g_vVerticalLimbDarkenningTopInfo.x;
    else {
      bool isVPositive = (v > 0.0);
      v = max(v, 0);
      darkening = 1.0 - pow(v, g_vVerticalLimbDarkenningTopInfo.w);
      darkening *= darkening;

      darkening = isVPositive ? lerp(1.0 - g_vVerticalLimbDarkenningTopInfo.x, 1.0, darkening) : 1.0;
    }
    color *= darkening;
  }

  // Vertical limb darkening (bottom)
  if (enableBottomDarkening) {
    float v = uv.y - g_vVerticalLimbDarkenningBottomInfo.y;
    v *= g_vVerticalLimbDarkenningBottomInfo.z;
    float darkening;
    if (v >= 1.0)
      darkening = 1.0 - g_vVerticalLimbDarkenningBottomInfo.x;
    else {
      bool isVPositive = (v > 0.0);
      v = max(v, 0);
      darkening = 1.0 - pow(v, g_vVerticalLimbDarkenningBottomInfo.w);
      darkening *= darkening;

      darkening = isVPositive ? lerp(1.0 - g_vVerticalLimbDarkenningBottomInfo.x, 1.0, darkening) : 1.0;
    }
    color *= darkening;
  }

  float3 untonemapped = color;
  color = RestoreHighlightSaturation(untonemapped);

  // Convert to color LUT space
  float3 lutSpaceColor = (enableDrawFix1) ? (color * 1.00006652 - 0.00391646381) : color;
  lutSpaceColor = lutSpaceColor * 5.55555582 + 0.0479959995;

  // HDR LUT
  float3 lutCoord = saturate(log2(lutSpaceColor) * 0.0734997839 + 0.386036009);
  float3 hdrColor = g_tHdrLut.SampleLevel(sampleLinear, lutCoord, 0).rgb;

  // Dramatic HDR LUTs
  float depth = 0;
  float height = 0;
  // because gpu reads this as float (~= 0.f) we need to read as uint
  if (asuint(g_vDramaticHdrLutInfo0[0].w) != 0) {
    depth = g_tSceneDepth.SampleLevel(samplePoint, uv, 0).x + g_vP2V.x;
    depth = g_vP2V.y / depth;
    bool useDramaticLutWorldPos = (asuint(g_vDramaticHdrLutInfo0[0].w) & 2);
    float3 viewPos;
    viewPos.xy = uv * float2(2, -2) + float2(-1, 1);
    viewPos.xy *= g_vP2V.zw;
    viewPos.xy *= -depth;

    float worldPosY = g_mV2W._m11 * viewPos.y + g_mV2W._m10 * viewPos.x + g_mV2W._m12 * depth + g_mV2W._m13;

    height = useDramaticLutWorldPos ? worldPosY : 0.0;
  }

  // Dramatic HDR LUT Sampling
  float maskIntensity = 0;
  if (g_vDramaticHdrLutInfo0[0].x > 0) {
    if (g_vDramaticHdrLutInfo0[0].y > 0) {
      if ((asuint(g_vDramaticHdrLutInfo0[0].z) & 0x0000ffff) == 0) {
        maskIntensity = g_tDramaticHdrLutMask0.SampleLevel(sampleLinear, uv, 0).x * g_vDramaticHdrLutInfo0[0].x;
      } else {
        uint dramaticLutMode0 = ((asuint(g_vDramaticHdrLutInfo0[0].z) >> 16) & 0x000000ff);
        if (dramaticLutMode0) {
          float depthNormalized = -depth * g_vDramaticHdrLutInfo0[1].x + g_vDramaticHdrLutInfo0[1].y;
          float depthIntensity = (depthNormalized >= 0 && depthNormalized <= 1) ? 1.0 : 0.0;

          float saturatedepthNormalized = saturate(depthNormalized);
          float2 dramaticLutMode0Intensity;
          dramaticLutMode0Intensity.y = 1 - exp2(-1.44269502 * saturatedepthNormalized);
          dramaticLutMode0Intensity.x = 1 - exp2(-1.44269502 * saturatedepthNormalized * saturatedepthNormalized);

          depthIntensity = (dramaticLutMode0 == 1) ? depthIntensity : depthNormalized;
          depthIntensity = (dramaticLutMode0 == 2) ? saturatedepthNormalized : depthIntensity;
          depthIntensity = (dramaticLutMode0 == 3) ? dramaticLutMode0Intensity.y : depthIntensity;
          depthIntensity = (dramaticLutMode0 == 4) ? dramaticLutMode0Intensity.x : depthIntensity;
          maskIntensity = g_vDramaticHdrLutInfo0[0].x * depthIntensity;
        } else {
          maskIntensity = g_vDramaticHdrLutInfo0[0].x;
        }
        uint dramaticLutMode2 = ((asuint(g_vDramaticHdrLutInfo0[0].z) >> 24) & 0x000000ff);
        if (dramaticLutMode2) {
          float heightNormalized = height * g_vDramaticHdrLutInfo0[1].z + g_vDramaticHdrLutInfo0[1].w;
          float heightIntensity = (heightNormalized >= 0 && heightNormalized <= 1) ? 1.0 : 0.0;

          float saturatedheightNormalized = saturate(heightNormalized);
          float2 dramaticLutMode2Intensity;
          dramaticLutMode2Intensity.y = 1 - exp2(-1.44269502 * saturatedheightNormalized);
          dramaticLutMode2Intensity.x = 1 - exp2(-1.44269502 * saturatedheightNormalized * saturatedheightNormalized);

          heightIntensity = (dramaticLutMode2 == 1) ? heightIntensity : heightNormalized;
          heightIntensity = (dramaticLutMode2 == 2) ? saturatedheightNormalized : heightIntensity;
          heightIntensity = (dramaticLutMode2 == 3) ? dramaticLutMode2Intensity.y : heightIntensity;
          heightIntensity = (dramaticLutMode2 == 4) ? dramaticLutMode2Intensity.x : heightIntensity;
          maskIntensity *= heightIntensity;
        }
      }
      maskIntensity = g_vDramaticHdrLutInfo0[0].y * (maskIntensity - g_vDramaticHdrLutInfo0[0].x) + g_vDramaticHdrLutInfo0[0].x;
    } else {
      maskIntensity = g_vDramaticHdrLutInfo0[0].x;
    }
    float3 dramaticColor0 = g_tDramaticHdrLut0.SampleLevel(sampleLinear, lutCoord, 0).rgb;
    hdrColor = lerp(hdrColor, dramaticColor0, maskIntensity);
  }

  if (g_vDramaticHdrLutInfo1[0].x > 0) {
    if (g_vDramaticHdrLutInfo1[0].y > 0) {
      if ((asuint(g_vDramaticHdrLutInfo1[0].z) & 0x0000ffff) == 0) {
        maskIntensity = g_tDramaticHdrLutMask1.SampleLevel(sampleLinear, uv, 0).x * g_vDramaticHdrLutInfo1[0].x;
      } else {
        uint dramaticLutMode0 = ((asuint(g_vDramaticHdrLutInfo1[0].z) >> 16) & 0x000000ff);
        if (dramaticLutMode0) {
          float depthNormalized = -depth * g_vDramaticHdrLutInfo1[1].x + g_vDramaticHdrLutInfo1[1].y;
          float depthIntensity = (depthNormalized >= 0 && depthNormalized <= 1) ? 1.0 : 0.0;

          float saturatedepthNormalized = saturate(depthNormalized);
          float2 dramaticLutMode0Intensity;
          dramaticLutMode0Intensity.y = 1 - exp2(-1.44269502 * saturatedepthNormalized);
          dramaticLutMode0Intensity.x = 1 - exp2(-1.44269502 * saturatedepthNormalized * saturatedepthNormalized);

          depthIntensity = (dramaticLutMode0 == 1) ? depthIntensity : depthNormalized;
          depthIntensity = (dramaticLutMode0 == 2) ? saturatedepthNormalized : depthIntensity;
          depthIntensity = (dramaticLutMode0 == 3) ? dramaticLutMode0Intensity.y : depthIntensity;
          depthIntensity = (dramaticLutMode0 == 4) ? dramaticLutMode0Intensity.x : depthIntensity;
          maskIntensity = g_vDramaticHdrLutInfo1[0].x * depthIntensity;
        } else {
          maskIntensity = g_vDramaticHdrLutInfo1[0].x;
        }
        uint dramaticLutMode2 = ((asuint(g_vDramaticHdrLutInfo1[0].z) >> 24) & 0x000000ff);
        if (dramaticLutMode2) {
          float heightNormalized = height * g_vDramaticHdrLutInfo1[1].z + g_vDramaticHdrLutInfo1[1].w;
          float heightIntensity = (heightNormalized >= 0 && heightNormalized <= 1) ? 1.0 : 0.0;

          float saturatedheightNormalized = saturate(heightNormalized);
          float2 dramaticLutMode2Intensity;
          dramaticLutMode2Intensity.y = 1 - exp2(-1.44269502 * saturatedheightNormalized);
          dramaticLutMode2Intensity.x = 1 - exp2(-1.44269502 * saturatedheightNormalized * saturatedheightNormalized);

          heightIntensity = (dramaticLutMode2 == 1) ? heightIntensity : heightNormalized;
          heightIntensity = (dramaticLutMode2 == 2) ? saturatedheightNormalized : heightIntensity;
          heightIntensity = (dramaticLutMode2 == 3) ? dramaticLutMode2Intensity.y : heightIntensity;
          heightIntensity = (dramaticLutMode2 == 4) ? dramaticLutMode2Intensity.x : heightIntensity;
          maskIntensity *= heightIntensity;
        }
      }
      maskIntensity = g_vDramaticHdrLutInfo1[0].y * (maskIntensity - g_vDramaticHdrLutInfo1[0].x) + g_vDramaticHdrLutInfo1[0].x;
    } else {
      maskIntensity = g_vDramaticHdrLutInfo1[0].x;
    }
    float3 dramaticColor1 = g_tDramaticHdrLut1.SampleLevel(sampleLinear, lutCoord, 0).rgb;
    hdrColor = lerp(hdrColor, dramaticColor1, maskIntensity);
  }

  // LDR LUT
  if (g_vCompositeInfo.y > 0) {
    float3 ldrCoord = pow(saturate(hdrColor), 1 / 2.2);
    float3 ldrColor = g_tLdrLut.SampleLevel(sampleLinear, ldrCoord, 0).rgb;
    hdrColor = lerp(hdrColor, ldrColor, g_vCompositeInfo.y);
  }

  // Gamma correction
  if (g_vGammaCorrection.x != 1.0) {
    hdrColor = pow(abs(hdrColor), g_vGammaCorrection.x);
  }

  // Final output
  output.Color.rgb = hdrColor * g_vRadialBlurCenter.z;
  output.Color.a = 1.0;

  float3 postGamma = output.Color.rgb;

  output.Color = ProcessColor(untonemapped, postGamma);

  return output;
}
