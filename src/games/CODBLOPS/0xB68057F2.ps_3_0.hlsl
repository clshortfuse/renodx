// Reconstructed ps_3_0 model-lighting shader.
//
// Highlight change:
//   Original:
//       outputRGB = sqrt(saturate(finalLighting * hdrControl0.x));
//
//   Unclamped:
//       outputRGB = sqrt(max(finalLighting * hdrControl0.x, 0.0f));
//
// This removes only the final 0.0-1.0 RGB ceiling. Earlier saturations used
// for normals, material modulation, NdotL/NdotV/NdotH, and shadow blending
// remain intact.
//
// Values above 1.0 require a floating-point destination such as
// R16G16B16A16_FLOAT. A UNORM destination will still clamp during storage.

#define UNCLAMP_HIGHLIGHTS 1


// ============================================================================
// Original resources
// ============================================================================

sampler2D   colorMapSampler        : register(s0);
sampler2D   normalMapSampler       : register(s1);
sampler2D   shadowmapSamplerSun    : register(s2);
sampler2D   specularMapSampler     : register(s3);
sampler2D   colorDetailMapSampler  : register(s4);
sampler2D   occMapSampler          : register(s5);
sampler3D   modelLightingSampler   : register(s11);
samplerCUBE reflectionProbeSampler : register(s15);

float4 shadowmapSwitchPartition : register(c2);

float4 lightingLookupScale : register(c5);
float4 lightHeroScale      : register(c6);
float4 envMapParms         : register(c7);
float4 colorDetailScale    : register(c8);
float4 hdrControl0         : register(c9);

float4 heroLightingR : register(c10);
float4 heroLightingG : register(c11);

float4 sunPosition : register(c17);
float4 sunDiffuse  : register(c18);
float4 sunSpecular : register(c19);

float4 heroLightingB : register(c20);


// ============================================================================
// Pixel input
// ============================================================================

struct PS_INPUT
{
    float3 color     : COLOR0;

    float2 texcoord0 : TEXCOORD0;
    float4 texcoord1 : TEXCOORD1;
    float3 texcoord2 : TEXCOORD2;
    float3 texcoord3 : TEXCOORD3;
    float4 texcoord4 : TEXCOORD4;
    float3 texcoord5 : TEXCOORD5;
    float3 texcoord6 : TEXCOORD6;
    float3 texcoord8 : TEXCOORD8;
};


// ============================================================================
// Constants reconstructed from the original assembly
// ============================================================================

static const float NORMAL_X_SCALE = 4.07999992f;
static const float NORMAL_X_BIAS  = -2.07999992f;

static const float NORMAL_Y_SCALE = 4.06451607f;
static const float NORMAL_Y_BIAS  = -2.06451607f;

static const float SPECULAR_VISIBILITY_SCALE = 0.797884583f;
static const float SPECULAR_DENOM_EPSILON    = 0.0009765625f;

static const float LIGHTING_SCALE = 31.875f;

static const float2 SHADOW_OFFSET_0 =
    float2(-0.00048828125f, 0.000122070312f);

static const float2 SHADOW_OFFSET_1 =
    float2(0.000244140625f, 0.000244140625f);

static const float2 SHADOW_OFFSET_2 =
    float2(-0.000244140625f, -0.000244140625f);

static const float2 SHADOW_OFFSET_3 =
    float2(0.00048828125f, -0.000122070312f);


// ============================================================================
// Shadow helpers
// ============================================================================

float SampleShadowLOD0(float2 uv, float depth)
{
    // For a D3D9 sampler2D, tex2Dlod uses XY as the texture coordinate and W
    // as the explicit mip level. Z is retained to mirror the original input.
    return tex2Dlod(
        shadowmapSamplerSun,
        float4(uv, depth, 0.0f)
    ).x;
}


float SampleShadow4(float2 uv, float depth)
{
    float shadow =
        SampleShadowLOD0(uv + SHADOW_OFFSET_0, depth);

    shadow +=
        SampleShadowLOD0(uv + SHADOW_OFFSET_1, depth);

    shadow +=
        SampleShadowLOD0(uv + SHADOW_OFFSET_2, depth);

    shadow +=
        SampleShadowLOD0(uv + SHADOW_OFFSET_3, depth);

    return shadow * 0.25f;
}


float ResolveSunShadow(
    float4 shadowCoord,
    float modelLightingAlpha
)
{
    // First partition.
    if (shadowCoord.w <= 1.0f)
    {
        float shadow0 =
            SampleShadow4(
                shadowCoord.xy,
                shadowCoord.z
            );

        // Blend to the switched partition between W = 0.75 and W = 1.0.
        if (shadowCoord.w > 0.75f)
        {
            float2 switchedUV =
                shadowCoord.xy
                * shadowmapSwitchPartition.w
                + shadowmapSwitchPartition.xy;

            float shadow1 =
                SampleShadow4(
                    switchedUV,
                    shadowCoord.z
                );

            float partitionBlend =
                shadowCoord.w * 4.0f - 3.0f;

            shadow0 =
                lerp(
                    shadow0,
                    shadow1,
                    partitionBlend
                );
        }

        return shadow0;
    }

    // Later partition/fallback region.
    if (shadowCoord.w < 4.0f)
    {
        float2 switchedUV =
            shadowCoord.xy
            * shadowmapSwitchPartition.w
            + shadowmapSwitchPartition.xy;

        float shadow =
            SampleShadow4(
                switchedUV,
                shadowCoord.z
            );

        float fallbackBlend =
            saturate(
                shadowCoord.w - 3.0f
            );

        return lerp(
            shadow,
            modelLightingAlpha,
            fallbackBlend
        );
    }

    return modelLightingAlpha;
}


// ============================================================================
// Main shader
// ============================================================================

float4 main(PS_INPUT input) : COLOR0
{
    // ------------------------------------------------------------------------
    // View and half-vector reconstruction
    // ------------------------------------------------------------------------

    float inverseViewLength =
        rsqrt(
            dot(
                input.texcoord5,
                input.texcoord5
            )
        );

    float3 viewVector =
        input.texcoord5
        * inverseViewLength;

    float3 halfVector =
        normalize(
            sunPosition.xyz
            - viewVector
        );

    float halfDotSun =
        saturate(
            dot(
                halfVector,
                sunPosition.xyz
            )
        );

    float oneMinusHalfDotSun =
        1.0f - halfDotSun;

    float fresnelPower =
        oneMinusHalfDotSun
        * oneMinusHalfDotSun;

    fresnelPower *=
        fresnelPower;

    fresnelPower *=
        oneMinusHalfDotSun;

    // ------------------------------------------------------------------------
    // Normal map reconstruction
    // ------------------------------------------------------------------------

    float4 normalSample =
        tex2D(
            normalMapSampler,
            input.texcoord0
        );

    float normalX =
        normalSample.a
        * NORMAL_X_SCALE
        + NORMAL_X_BIAS;

    float normalY =
        normalSample.g
        * NORMAL_Y_SCALE
        + NORMAL_Y_BIAS;

    float3 worldNormal =
        normalize(
            input.texcoord1.xyz
            + normalX * input.texcoord3
            + normalY * input.texcoord2
        );

    float normalDotHalf =
        saturate(
            dot(
                worldNormal,
                halfVector
            )
        );

    float normalDotView =
        saturate(
            dot(
                worldNormal,
                -viewVector
            )
        );

    float normalDotLight =
        saturate(
            dot(
                worldNormal,
                sunPosition.xyz
            )
        );

    // ------------------------------------------------------------------------
    // Base color and detail map
    // ------------------------------------------------------------------------

    float3 detailColor =
        tex2D(
            colorDetailMapSampler,
            input.texcoord0
            * colorDetailScale.xy
        ).rgb
        - 0.5f;

    float4 colorSample =
        tex2D(
            colorMapSampler,
            input.texcoord0
        );

    float3 diffuseColor =
        saturate(
            detailColor
            * colorSample.a
            + colorSample.rgb
        );

    diffuseColor *=
        input.color;

    // The original shader squares this value before lighting.
    float3 diffuseColorLinear =
        diffuseColor
        * diffuseColor;

    // ------------------------------------------------------------------------
    // Specular map and direct specular BRDF
    // ------------------------------------------------------------------------

    float4 specularSample =
        tex2D(
            specularMapSampler,
            input.texcoord0
        );

    float3 specularSquared =
        specularSample.rgb
        * specularSample.rgb;

    float3 oneMinusSpecularSquared =
        1.0f - specularSquared;

    float visibilityScale =
        1.0f
        - specularSample.a
        * SPECULAR_VISIBILITY_SCALE;

    float visibilityBias =
        specularSample.a
        * SPECULAR_VISIBILITY_SCALE;

    float viewVisibility =
        normalDotView
        * visibilityScale
        + visibilityBias;

    float lightVisibility =
        normalDotLight
        * visibilityScale
        + visibilityBias;

    float specularExponent =
        exp2(
            specularSample.a * -13.0f
            + 13.0f
        );

    float specularDistribution =
        pow(
            normalDotHalf,
            specularExponent
        );

    specularDistribution *=
        specularExponent * 0.125f
        + 0.25f;

    float specularDenominator =
        lightVisibility
        * viewVisibility
        + SPECULAR_DENOM_EPSILON;

    float directSpecularFactor =
        specularDistribution
        * normalDotLight
        / specularDenominator;

    float3 halfVectorFresnel =
        oneMinusSpecularSquared
        * fresnelPower
        + specularSquared;

    float4 occlusionSample =
        tex2D(
            occMapSampler,
            input.texcoord0
        );

    float3 directSpecular =
        halfVectorFresnel
        * directSpecularFactor
        * envMapParms.w
        * occlusionSample.a;

    directSpecular *=
        lightHeroScale.y
        * sunSpecular.rgb;

    // ------------------------------------------------------------------------
    // Model-lighting lookup
    // ------------------------------------------------------------------------

    float3 absNormal =
        abs(
            worldNormal
        );

    float largestNormalComponent =
        max(
            absNormal.x,
            max(
                absNormal.y,
                absNormal.z
            )
        );

    float inverseLargestNormalComponent =
        rcp(
            largestNormalComponent
        );

    float3 lightingLookupCoordinate =
        worldNormal
        * lightingLookupScale.xyz
        * inverseLargestNormalComponent
        + input.texcoord6;

    float4 modelLightingSample =
        tex3D(
            modelLightingSampler,
            lightingLookupCoordinate
        );

    float3 modelLighting =
        modelLightingSample.rgb
        * modelLightingSample.rgb;

    modelLighting *=
        envMapParms.y
        * occlusionSample.a
        * LIGHTING_SCALE;

    // ------------------------------------------------------------------------
    // Sun shadow and diffuse lighting
    // ------------------------------------------------------------------------

    float shadow =
        ResolveSunShadow(
            input.texcoord4,
            modelLightingSample.a
        );

    float3 sunDiffuseLighting =
        normalDotLight
        * lightHeroScale.x
        * sunDiffuse.rgb;

    float3 diffuseLighting =
        shadow
        * sunDiffuseLighting
        + modelLighting;

    // ------------------------------------------------------------------------
    // Reflection-probe specular
    // ------------------------------------------------------------------------

    float viewDotNormal =
        dot(
            viewVector,
            worldNormal
        );

    float3 reflectionVector =
        worldNormal
        - 2.0f
        * viewDotNormal
        * viewVector;

    float3 reflectionSample =
        texCUBElod(
            reflectionProbeSampler,
            float4(
                reflectionVector,
                0.0f
            )
        ).rgb;

    float3 reflectionLighting =
        reflectionSample
        * reflectionSample
        * 8.0f;

    float3 secondaryModelLighting =
        tex3D(
            modelLightingSampler,
            input.texcoord6
        ).rgb;

    secondaryModelLighting *=
        secondaryModelLighting;

    float grazingTerm =
        1.0f - normalDotView;

    grazingTerm =
        grazingTerm
        * grazingTerm
        * grazingTerm;

    grazingTerm /=
        specularSample.a * 3.5f
        + 1.0f;

    float3 viewFresnel =
        oneMinusSpecularSquared
        * grazingTerm
        + specularSquared;

    float3 environmentSpecular =
        reflectionLighting
        * secondaryModelLighting
        * LIGHTING_SCALE
        * viewFresnel
        * envMapParms.x;

    // ------------------------------------------------------------------------
    // Final lighting combination
    // ------------------------------------------------------------------------

    float3 litColor =
        environmentSpecular
        * occlusionSample.rgb;

    litColor +=
        diffuseColorLinear
        * diffuseLighting;

    litColor +=
        directSpecular
        * shadow;

    // Original hero-lighting matrix.
    float4 litColorWithBias =
        float4(
            litColor,
            1.0f
        );

    float3 heroLitColor;

    heroLitColor.r =
        dot(
            litColorWithBias,
            heroLightingR
        );

    heroLitColor.g =
        dot(
            litColorWithBias,
            heroLightingG
        );

    heroLitColor.b =
        dot(
            litColorWithBias,
            heroLightingB
        );

    // The original assembly uses TEXCOORD1.w as this blend factor.
    float3 finalLighting =
        lerp(
            input.texcoord8,
            heroLitColor,
            input.texcoord1.w
        );

    float3 scaledLighting =
        finalLighting
        * hdrControl0.x;

    // ------------------------------------------------------------------------
    // Output
    // ------------------------------------------------------------------------

#if UNCLAMP_HIGHLIGHTS

    // Preserve values above 1.0 while preventing invalid sqrt inputs.
    float3 outputColor =
        sqrt(
            max(
                scaledLighting,
                0.0f
            )
        );

#else

    // Exact original final highlight clamp.
    float3 outputColor =
        sqrt(
            saturate(
                scaledLighting
            )
        );

#endif

    return float4(
        outputColor,
        1.0f
    );
}
