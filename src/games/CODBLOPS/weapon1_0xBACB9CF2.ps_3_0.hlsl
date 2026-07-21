// Reconstructed ps_3_0 spotlight/model-lighting shader.
//
// Highlight change:
//   Original:
//       outputRGB = sqrt(saturate(finalLighting * hdrControl0.x));
//
//   Unclamped:
//       outputRGB = sqrt(max(finalLighting * hdrControl0.x, 0.0f));
//
// This removes only the final 0.0-1.0 highlight ceiling. Earlier saturations
// used for material modulation, spotlight falloff, NdotL/NdotV/NdotH,
// shadow visibility, and other lighting masks remain intact.
//
// Values above 1.0 require a floating-point destination such as
// R16G16B16A16_FLOAT. A UNORM destination still clamps during storage.

#define UNCLAMP_HIGHLIGHTS 1


// ============================================================================
// Original resources
// ============================================================================

sampler2D attenuationSampler       : register(s3);
sampler2D colorMapSampler          : register(s0);
sampler2D normalMapSampler         : register(s1);
sampler2D shadowmapSamplerSpot     : register(s2);
sampler2D specularMapSampler       : register(s4);
sampler2D colorDetailMapSampler    : register(s5);
sampler3D modelLightingSampler     : register(s11);
samplerCUBE reflectionProbeSampler : register(s15);

float4 lightingLookupScale : register(c5);

float4 lightPosition  : register(c6);
float4 lightDiffuse   : register(c7);
float4 lightSpecular  : register(c8);
float4 lightHeroScale : register(c9);

float4 lightSpotFactors            : register(c10);
float4 lightAttenuation            : register(c11);
float4 lightFallOffA               : register(c20);
float4 lightFallOffB               : register(c21);
float4 lightSpotMatrix0            : register(c22);
float4 lightSpotMatrix1            : register(c23);
float4 lightSpotMatrix2            : register(c24);
float4 lightSpotMatrix3            : register(c25);
float4 lightSpotAABB               : register(c26);
float4 lightConeControl1           : register(c27);
float4 lightConeControl2           : register(c28);
float4 lightSpotCookieSlideControl : register(c29);
float4 spotShadowmapPixelAdjust    : register(c30);

float4 colorDetailScale : register(c31);
float4 hdrControl0      : register(c32);

float4 heroLightingR : register(c33);
float4 heroLightingG : register(c34);
float4 heroLightingB : register(c35);


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
// Reconstructed constants
// ============================================================================

static const float NORMAL_X_SCALE = 4.07999992f;
static const float NORMAL_X_BIAS  = -2.07999992f;

static const float NORMAL_Y_SCALE = 4.06451607f;
static const float NORMAL_Y_BIAS  = -2.06451607f;

static const float SPECULAR_VISIBILITY_SCALE = 0.797884583f;
static const float SPECULAR_DENOM_EPSILON    = 0.0009765625f;

static const float MODEL_LIGHTING_SCALE = 31.875f;
static const float MATERIAL_SPECULAR_F0 = 0.200000003f;
static const float REFLECTION_MIP_SCALE = 8.0f;


// ============================================================================
// Spotlight helpers
// ============================================================================

float4 SampleProjectedSpotShadow(
    float4 shadowCoord,
    float2 projectedOffset
)
{
    float4 adjustedCoord = shadowCoord;

    // The original assembly adds an offset multiplied by projected W before
    // using texldp, so the offset remains constant after perspective divide.
    adjustedCoord.xy +=
        shadowCoord.w * projectedOffset;

    return tex2Dproj(
        shadowmapSamplerSpot,
        adjustedCoord
    );
}


float SampleSpotShadow4(float4 shadowCoord)
{
    float shadow0 =
        SampleProjectedSpotShadow(
            shadowCoord,
            spotShadowmapPixelAdjust.xy
        ).x;

    float shadow1 =
        SampleProjectedSpotShadow(
            shadowCoord,
            -spotShadowmapPixelAdjust.xy
        ).x;

    float shadow2 =
        SampleProjectedSpotShadow(
            shadowCoord,
            spotShadowmapPixelAdjust.zw
        ).x;

    float shadow3 =
        SampleProjectedSpotShadow(
            shadowCoord,
            -spotShadowmapPixelAdjust.zw
        ).x;

    return (
        shadow0
        + shadow1
        + shadow2
        + shadow3
    ) * 0.25f;
}


float3 ComputeSpotCookieAttenuation(
    float3 position,
    out float spotDepth
)
{
    float4 position4 =
        float4(
            position,
            1.0f
        );

    float inverseProjectionW =
        rcp(
            dot(
                position4,
                lightSpotMatrix3
            )
        );

    float2 projectedPosition;

    projectedPosition.x =
        dot(
            position4,
            lightSpotMatrix0
        ) * inverseProjectionW;

    projectedPosition.y =
        dot(
            position4,
            lightSpotMatrix1
        ) * inverseProjectionW;

    // Reconstruct the original generalized spotlight boundary calculation.
    float4 spotBoundaryInput =
        float4(
            projectedPosition.x * lightSpotAABB.z,
            projectedPosition.x * lightSpotAABB.w,
            projectedPosition.y * lightSpotAABB.x,
            projectedPosition.y * lightSpotAABB.y
        );

    float4 poweredBoundary =
        exp2(
            log2(
                spotBoundaryInput
            ) * lightConeControl1.x
        );

    float2 combinedBoundary =
        poweredBoundary.xy
        + poweredBoundary.zw;

    combinedBoundary =
        exp2(
            log2(
                combinedBoundary
            ) * lightConeControl1.y
        );

    spotDepth =
        dot(
            position4,
            lightSpotMatrix2
        );

    float conePart0 =
        combinedBoundary.x
        * lightConeControl2.x;

    float coneDenominator =
        combinedBoundary.y
        * lightConeControl2.y
        - conePart0;

    float coneNumerator =
        combinedBoundary.y
        * lightConeControl2.y
        - lightConeControl1.z;

    float coneMask =
        saturate(
            coneNumerator
            / coneDenominator
        );

    float2 absProjectedPosition =
        abs(
            projectedPosition
        );

    float4 falloffInput =
        float4(
            spotDepth,
            absProjectedPosition.y,
            absProjectedPosition.x,
            spotDepth
        );

    float4 falloff =
        saturate(
            falloffInput
            * lightFallOffA
            + lightFallOffB
        );

    float4 shapedFalloff =
        float4(
            falloff.w * falloff.x,
            falloff.x,
            falloff.y,
            coneMask
        );

    float4 shapedFalloffSquared =
        shapedFalloff
        * shapedFalloff;

    shapedFalloffSquared *=
        lightConeControl2.z
        * shapedFalloff
        + lightConeControl2.w;

    float edgeProduct =
        shapedFalloffSquared.z
        * shapedFalloffSquared.y;

    float selectedConeFalloff =
        (abs(lightConeControl1.w) == 0.0f)
        ? edgeProduct
        : shapedFalloffSquared.w;

    float spotDepthSquared =
        spotDepth
        * spotDepth;

    float radialAttenuation =
        dot(
            lightAttenuation.yz,
            float2(
                spotDepth,
                spotDepthSquared
            )
        )
        + lightAttenuation.x;

    float attenuationFactor =
        shapedFalloffSquared.x
        * selectedConeFalloff
        * radialAttenuation;

    float2 cookieUV;

    cookieUV.x =
        dot(
            projectedPosition,
            lightSpotCookieSlideControl.xy
        )
        + lightSpotFactors.x;

    cookieUV.y =
        dot(
            projectedPosition,
            lightSpotCookieSlideControl.zw
        )
        + lightSpotFactors.y;

    float3 cookie =
        tex2D(
            attenuationSampler,
            cookieUV
        ).rgb;

    // Original shader squares the cookie before applying it.
    cookie *= cookie;

    return cookie * attenuationFactor;
}


// ============================================================================
// Main shader
// ============================================================================

float4 main(PS_INPUT input) : COLOR0
{
    // ------------------------------------------------------------------------
    // Spotlight cookie, attenuation, and projected shadow
    // ------------------------------------------------------------------------

    float spotDepth;

    float3 spotCookieAttenuation =
        ComputeSpotCookieAttenuation(
            input.texcoord5,
            spotDepth
        );

    float projectedSpotShadow =
        SampleSpotShadow4(
            input.texcoord4
        );

    // ------------------------------------------------------------------------
    // Normal-map reconstruction
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

    // Blend the model-lighting visibility with the four-tap spotlight shadow.
    float lightVisibility =
        lerp(
            modelLightingSample.a,
            projectedSpotShadow,
            lightSpotFactors.w
        );

    // ------------------------------------------------------------------------
    // Spotlight direction and geometric lighting terms
    // ------------------------------------------------------------------------

    float3 lightVector =
        lightPosition.xyz
        - input.texcoord5;

    float lightDistanceSquared =
        dot(
            lightVector,
            lightVector
        );

    float inverseLightDistance =
        rsqrt(
            lightDistanceSquared
        );

    float3 lightDirection =
        lightVector
        * inverseLightDistance;

    float normalDotLight =
        saturate(
            dot(
                worldNormal,
                lightDirection
            )
        );

    float3 directLightAttenuation =
        spotCookieAttenuation
        * lightVisibility;

    // ------------------------------------------------------------------------
    // View and specular terms
    // ------------------------------------------------------------------------

    float3 viewDirection =
        normalize(
            input.texcoord5
        );

    float normalDotView =
        saturate(
            dot(
                worldNormal,
                -viewDirection
            )
        );

    float4 specularSample =
        tex2D(
            specularMapSampler,
            input.texcoord0
        );

    // R controls the diffuse/specular material split.
    // G controls specular/model-lighting strength.
    // A controls gloss/exponent and reflection-probe mip level.
    float diffuseMaterialScale =
        specularSample.r;

    float specularStrength =
        specularSample.g;

    float specularVisibilityBias =
        specularSample.a
        * SPECULAR_VISIBILITY_SCALE;

    float specularVisibilityScale =
        1.0f
        - specularVisibilityBias;

    float lightVisibilityTerm =
        normalDotLight
        * specularVisibilityScale
        + specularVisibilityBias;

    float viewVisibilityTerm =
        normalDotView
        * specularVisibilityScale
        + specularVisibilityBias;

    float specularDenominator =
        lightVisibilityTerm
        * viewVisibilityTerm
        + SPECULAR_DENOM_EPSILON;

    float3 halfVector =
        normalize(
            lightDirection
            - viewDirection
        );

    float normalDotHalf =
        saturate(
            dot(
                worldNormal,
                halfVector
            )
        );

    float halfDotLight =
        saturate(
            dot(
                halfVector,
                lightDirection
            )
        );

    float specularNormalizationDenominator =
        specularSample.a * 3.5f
        + 1.0f;

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

    float directSpecularFactor =
        normalDotLight
        * specularDistribution
        / specularDenominator;

    float oneMinusHalfDotLight =
        1.0f - halfDotLight;

    float directFresnelPower =
        oneMinusHalfDotLight
        * oneMinusHalfDotLight;

    directFresnelPower *=
        directFresnelPower;

    directFresnelPower *=
        oneMinusHalfDotLight;

    // ------------------------------------------------------------------------
    // Base color, detail map, and material split
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

    float3 baseColor =
        saturate(
            detailColor
            * colorSample.a
            + colorSample.rgb
        );

    // The original shader blends colored material reflectance toward a
    // neutral 0.2 F0 according to specularSample.r.
    float3 materialSpecularColor =
        lerp(
            baseColor,
            MATERIAL_SPECULAR_F0.xxx,
            diffuseMaterialScale
        );

    float3 materialSpecularColorLinear =
        materialSpecularColor
        * materialSpecularColor;

    float3 oneMinusMaterialSpecular =
        1.0f
        - materialSpecularColorLinear;

    // Diffuse is scaled by the same material control before vertex color.
    float3 diffuseColor =
        baseColor
        * diffuseMaterialScale
        * input.color;

    float3 diffuseColorLinear =
        diffuseColor
        * diffuseColor;

    // ------------------------------------------------------------------------
    // Direct spotlight specular
    // ------------------------------------------------------------------------

    float3 directFresnel =
        oneMinusMaterialSpecular
        * directFresnelPower
        + materialSpecularColorLinear;

    float3 directSpecular =
        directFresnel
        * directSpecularFactor
        * specularStrength;

    directSpecular *=
        lightHeroScale.y
        * lightSpecular.rgb;

    directSpecular *=
        directLightAttenuation;

    // ------------------------------------------------------------------------
    // Direct diffuse and model lighting
    // ------------------------------------------------------------------------

    modelLighting *=
        specularStrength
        * MODEL_LIGHTING_SCALE;

    float3 directDiffuse =
        normalDotLight
        * lightHeroScale.x
        * lightDiffuse.rgb;

    float3 combinedLighting =
        directLightAttenuation
        * directDiffuse
        + modelLighting;

    // ------------------------------------------------------------------------
    // Reflection-probe lighting
    // ------------------------------------------------------------------------

    float viewDotNormal =
        dot(
            viewDirection,
            worldNormal
        );

    float3 reflectionVector =
        viewDirection
        - 2.0f
        * viewDotNormal
        * worldNormal;

    float reflectionMip =
        specularSample.a
        * REFLECTION_MIP_SCALE;

    float3 reflectionSample =
        texCUBElod(
            reflectionProbeSampler,
            float4(
                reflectionVector,
                reflectionMip
            )
        ).rgb;

    reflectionSample *=
        reflectionSample;

    float3 reflectionLighting =
        reflectionSample
        * 8.0f;

    float3 secondaryModelLighting =
        tex3D(
            modelLightingSampler,
            input.texcoord6
        ).rgb;

    secondaryModelLighting *=
        secondaryModelLighting;

    float grazingTerm =
        1.0f
        - normalDotView;

    grazingTerm *=
        grazingTerm;

    grazingTerm *=
        grazingTerm;

    grazingTerm /=
        specularNormalizationDenominator;

    float3 viewFresnel =
        oneMinusMaterialSpecular
        * grazingTerm
        + materialSpecularColorLinear;

    float3 environmentSpecular =
        reflectionLighting
        * secondaryModelLighting
        * MODEL_LIGHTING_SCALE
        * viewFresnel
        * specularStrength;

    // ------------------------------------------------------------------------
    // Final lighting before hero grading
    // ------------------------------------------------------------------------

    float3 litColor =
        diffuseColorLinear
        * combinedLighting;

    litColor +=
        directSpecular;

    litColor +=
        environmentSpecular;

    // ------------------------------------------------------------------------
    // Original hero-lighting matrix and blend
    // ------------------------------------------------------------------------

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

    float3 finalLighting =
        lerp(
            input.texcoord8,
            heroLitColor,
            input.texcoord1.w
        );

    float3 scaledLighting =
        finalLighting
        * hdrControl0.x;

    // Original assembly:
    //
    //   mul_sat_pp r0.xyz, r0, c32.x
    //
    // UNCLAMP_HIGHLIGHTS removes only the upper 1.0 clamp. Negative values
    // are still rejected before the original square-root encoding.

    // ------------------------------------------------------------------------
    // Final output
    // ------------------------------------------------------------------------

#if UNCLAMP_HIGHLIGHTS

    float3 outputColor =
        sqrt(
            max(
                scaledLighting,
                0.0f
            )
        );

#else

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
