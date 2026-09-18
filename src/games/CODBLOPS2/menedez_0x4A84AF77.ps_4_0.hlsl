// ---- Created with 3Dmigoto v1.3.16 on Sat Aug 01 16:42:02 2026
//
// HDR-safe fix for black highlights.
//
// The original shader computes pow(1 - sceneAverage, GhostPower) through
// log2/exp2. HDR values can make (1 - sceneAverage) negative, producing NaN.
// This version clamps only that control mask, not the HDR scene output.

cbuffer _Globals : register(b2)
{
  float4 gameTime : packoffset(c0);
  float GhostIntensity : packoffset(c1);
  float GhostPower : packoffset(c1.y);
  float OverlayAmount : packoffset(c1.z);
  float Falloff : packoffset(c1.w);
  float Boost : packoffset(c2);
  float Brightness : packoffset(c2.y);
  float Transition : packoffset(c2.z);
}

cbuffer PerObjectConsts : register(b1)
{
  float4x4 worldViewMatrix : packoffset(c0);
  float4x4 worldViewProjectionMatrix : packoffset(c4);
  float4x4 inverseTransposeWorldViewMatrix : packoffset(c8);
  float4x4 inverseWorldViewMatrix : packoffset(c12);
  float4 clipSpaceLookupScale : packoffset(c16);
  float4 clipSpaceLookupOffset : packoffset(c17);
  float4 particleCloudColor : packoffset(c18);
  float4 particleCloudMatrix : packoffset(c19);
  float4 particleCloudVelWorld : packoffset(c20);
  float4 codeMeshArg[2] : packoffset(c21);
  float4 scriptVector0 : packoffset(c23);
  float4 scriptVector1 : packoffset(c24);
  float4 scriptVector2 : packoffset(c25);
  float4 scriptVector3 : packoffset(c26);
  float4 scriptVector4 : packoffset(c27);
  float4 scriptVector5 : packoffset(c28);
  float4 scriptVector6 : packoffset(c29);
  float4 scriptVector7 : packoffset(c30);
  float4 weaponParam0 : packoffset(c31);
  float4 weaponParam1 : packoffset(c32);
  float4 weaponParam2 : packoffset(c33);
  float4 weaponParam3 : packoffset(c34);
  float4 weaponParam4 : packoffset(c35);
  float4 weaponParam5 : packoffset(c36);
  float4 weaponParam6 : packoffset(c37);
  float4 weaponParam7 : packoffset(c38);
  float4 weaponParam8 : packoffset(c39);
  float4 weaponParam9 : packoffset(c40);
  float4 flagParams : packoffset(c41);
  float3 occlusionAmount : packoffset(c42);
  float4 colorObjMin : packoffset(c43);
  float4 colorObjMax : packoffset(c44);
  float colorObjMinBaseBlend : packoffset(c45);
  float colorObjMaxBaseBlend : packoffset(c45.y);
  float2 uvScroll : packoffset(c45.z);
  float4 featherParms : packoffset(c46);
  float4 falloffParms : packoffset(c47);
  float4 falloffBeginColor : packoffset(c48);
  float4 falloffEndColor : packoffset(c49);
  float4 eyeOffsetParms : packoffset(c50);
  float4 alphaDissolveParms : packoffset(c51);
  float4 spotLightWeight : packoffset(c52);
  float4 detailScale : packoffset(c53);
  float4 detailScale1 : packoffset(c54);
  float4 detailScale2 : packoffset(c55);
  float4 detailScale3 : packoffset(c56);
  float4 detailScale4 : packoffset(c57);
  float4 alphaRevealParms : packoffset(c58);
  float4 alphaRevealParms1 : packoffset(c59);
  float4 alphaRevealParms2 : packoffset(c60);
  float4 alphaRevealParms3 : packoffset(c61);
  float4 alphaRevealParms4 : packoffset(c62);
  float4 colorDetailScale : packoffset(c63);
  float4 colorTint : packoffset(c64);
}

SamplerState OverlayMap_s : register(s1);
SamplerState GhostMap1_s : register(s2);
SamplerState ResolvedPostSun_Sampler_C1_P0_s : register(s3);
Texture2D<float4> GhostMap1 : register(t0);
Texture2D<float4> OverlayMap : register(t1);
Texture2D<float4> ResolvedPostSun_Sampler_C1_P0 : register(t2);

float SafeFinite(float value, float fallback)
{
    if (isnan(value))
        return fallback;

    if (isinf(value))
        return value > 0.0f ? 65504.0f : fallback;

    return value;
}

float3 SafePositiveHDR(float3 color)
{
    color.r = SafeFinite(color.r, 0.0f);
    color.g = SafeFinite(color.g, 0.0f);
    color.b = SafeFinite(color.b, 0.0f);

    // Preserve HDR values above 1.0.
    return min(max(color, 0.0f), 65504.0f);
}

float SafeAlpha(float value)
{
    return saturate(SafeFinite(value, 0.0f));
}

float SafePowNonNegative(float baseValue, float exponentValue)
{
    baseValue = max(SafeFinite(baseValue, 0.0f), 0.0f);
    exponentValue = max(SafeFinite(exponentValue, 1.0f), 0.0f);

    if (baseValue <= 0.0f)
        return exponentValue <= 0.0f ? 1.0f : 0.0f;

    float result = exp2(log2(baseValue) * exponentValue);
    return min(max(SafeFinite(result, 0.0f), 0.0f), 65504.0f);
}

void main(
  float2 v0 : TEXCOORD0,
  float2 w0 : TEXCOORD1,
  float4 v1 : TEXCOORD2,
  float3 v2 : TEXCOORD3,
  out float4 o0 : SV_Target0)
{
    const float3 LUMA_601 =
        float3(0.300000012f, 0.589999974f, 0.109999999f);

    const float3 AVERAGE_RGB =
        float3(0.333299994f, 0.333299994f, 0.333299994f);

    float4 ghostSample =
        GhostMap1.Sample(GhostMap1_s, w0.xy);

    ghostSample.rgb = SafePositiveHDR(ghostSample.rgb);
    ghostSample.a = SafeAlpha(ghostSample.a);

    float ghostLuminance =
        dot(ghostSample.rgb, LUMA_601);

    float3 ghostColor =
        lerp(
            ghostSample.rgb,
            ghostLuminance.xxx,
            SafeFinite(scriptVector1.x, 0.0f)
        );

    ghostColor =
        SafePositiveHDR(
            ghostColor
            * ghostSample.a
            * SafeFinite(GhostIntensity, 0.0f)
            * SafeFinite(scriptVector0.y, 0.0f)
        );

    float4 sceneSample =
        ResolvedPostSun_Sampler_C1_P0.Sample(
            ResolvedPostSun_Sampler_C1_P0_s,
            v0.xy
        );

    float3 sceneColor =
        SafePositiveHDR(sceneSample.rgb);

    float sceneAverage =
        max(dot(sceneColor, AVERAGE_RGB), 0.0f);

    // Critical HDR fix:
    // In the original shader this value was sent directly to log2().
    // HDR sceneAverage > 1 made it negative and generated NaN.
    float ghostMaskBase =
        saturate(1.0f - sceneAverage);

    float ghostMask =
        SafePowNonNegative(
            ghostMaskBase,
            GhostPower
        );

    float3 color =
        SafePositiveHDR(
            sceneColor + ghostColor * ghostMask
        );

    float4 overlaySample =
        OverlayMap.Sample(OverlayMap_s, v0.xy);

    overlaySample.r = SafeFinite(overlaySample.r, 1.0f);
    overlaySample.g = SafeFinite(overlaySample.g, 1.0f);
    overlaySample.b = SafeFinite(overlaySample.b, 1.0f);
    overlaySample.a = SafeAlpha(overlaySample.a);

    float overlayEnable =
        saturate(SafeFinite(scriptVector0.x, 0.0f) * 2.0f);

    float overlayWeight =
        SafeFinite(OverlayAmount, 0.0f)
        * overlaySample.a
        * overlayEnable;

    float3 overlayMultiplier =
        1.0f.xxx
        + overlayWeight
        * (overlaySample.rgb - 1.0f.xxx);

    color =
        SafePositiveHDR(color * overlayMultiplier);

    float3 modulation =
        1.0f.xxx
        + SafeFinite(v1.x, 0.0f)
        * (
            float3(
                SafeFinite(v2.x, 1.0f),
                SafeFinite(v2.y, 1.0f),
                SafeFinite(v2.z, 1.0f)
            )
            - 1.0f.xxx
        );

    color =
        SafePositiveHDR(color * modulation);

    float colorLuminance =
        max(dot(color, LUMA_601), 0.0f);

    float inverseLuminance =
        1.0f - colorLuminance;

    float luminanceSquared =
        colorLuminance * colorLuminance;

    float brightness =
        SafeFinite(Brightness, 0.0f);

    float curveX =
        1.0f
        - inverseLuminance * inverseLuminance * brightness
        - luminanceSquared * brightness;

    float curveY =
        brightness * luminanceSquared;

    float highlightTransition =
        saturate(10.0f * (colorLuminance - 1.0f));

    float shapedLuminance =
        highlightTransition * curveX
        + curveY;

    // Protect the shader's second log2/exp2 power operation.
    shapedLuminance =
        max(SafeFinite(shapedLuminance, 0.0f), 0.0f);

    float falloffValue =
        SafePowNonNegative(
            shapedLuminance,
            Falloff
        );

    float boostedRed =
        saturate(
            SafeFinite(Boost, 0.0f)
            * falloffValue
        );

    float3 effectColor =
        shapedLuminance.xxx
        + boostedRed * float3(1.0f, 0.0f, 0.0f);

    effectColor =
        SafePositiveHDR(effectColor * effectColor);

    float effectBlend =
        SafeFinite(v1.y, 0.0f);

    float3 outputColor =
        color
        + effectBlend
        * (effectColor - color);

    // Remove invalid and negative values only.
    // Do not saturate the final HDR output.
    o0.rgb = SafePositiveHDR(outputColor);
    o0.a = 0.0f;
}
