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
// used for material modulation, spotlight falloff, local-light attenuation,
// NdotL/NdotV/NdotH, and other lighting masks remain intact.
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
sampler2D occMapSampler            : register(s6);
sampler3D modelLightingSampler     : register(s11);
samplerCUBE reflectionProbeSampler : register(s15);

float4 lightingLookupScale : register(c5);

float4 glightPosXs    : register(c6);
float4 glightPosYs    : register(c7);
float4 glightPosZs    : register(c8);
float4 glightFallOffs : register(c9);
float4 glightReds     : register(c10);
float4 glightGreens   : register(c11);
float4 glightBlues    : register(c20);

float4 lightPosition  : register(c21);
float4 lightDiffuse   : register(c22);
float4 lightSpecular  : register(c23);
float4 lightHeroScale : register(c24);

float4 lightSpotFactors            : register(c25);
float4 lightAttenuation            : register(c26);
float4 lightFallOffA                : register(c27);
float4 lightFallOffB                : register(c28);
float4 lightSpotMatrix0             : register(c29);
float4 lightSpotMatrix1             : register(c30);
float4 lightSpotMatrix2             : register(c31);
float4 lightSpotMatrix3             : register(c32);
float4 lightSpotAABB                : register(c33);
float4 lightConeControl1            : register(c34);
float4 lightConeControl2            : register(c35);
float4 lightSpotCookieSlideControl  : register(c36);
float4 spotShadowmapPixelAdjust     : register(c37);

float4 envMapParms     : register(c38);
float4 colorDetailScale : register(c39);
float4 hdrControl0      : register(c40);

float4 heroLightingR : register(c41);
float4 heroLightingG : register(c42);
float4 heroLightingB : register(c43);


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

    // Select between model-lighting alpha and projected spotlight shadow.
    float lightVisibility =
        lerp(
            modelLightingSample.a,
            projectedSpotShadow,
            lightSpotFactors.w
        );

    // ------------------------------------------------------------------------
    // Direct spotlight direction and geometric terms
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
    // View vector and specular terms
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

    float oneMinusHalfDotLight =
        1.0f - halfDotLight;

    float specularDistribution =
        pow(
            normalDotHalf,
            specularExponent
        );

    float fresnelPower =
        oneMinusHalfDotLight
        * oneMinusHalfDotLight;

    fresnelPower *=
        fresnelPower;

    fresnelPower *=
        oneMinusHalfDotLight;

    float specularNormalization =
        specularExponent * 0.125f
        + 0.25f;

    specularDistribution *=
        specularNormalization;

    float3 specularSquared =
        specularSample.rgb
        * specularSample.rgb;

    float3 oneMinusSpecularSquared =
        1.0f
        - specularSquared;

    float directSpecularFactor =
        normalDotLight
        / specularDenominator
        * specularDistribution;

    float3 directFresnel =
        oneMinusSpecularSquared
        * fresnelPower
        + specularSquared;

    float4 occlusionSample =
        tex2D(
            occMapSampler,
            input.texcoord0
        );

    float3 directSpecular =
        directFresnel
        * directSpecularFactor
        * envMapParms.w
        * occlusionSample.a;

    directSpecular *=
        lightHeroScale.y
        * lightSpecular.rgb;

    directSpecular *=
        directLightAttenuation;

    // ------------------------------------------------------------------------
    // Direct diffuse and model lighting
    // ------------------------------------------------------------------------

    modelLighting *=
        envMapParms.y
        * occlusionSample.a
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

    float3 diffuseColorLinear =
        diffuseColor
        * diffuseColor;

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

    float3 reflectionSample =
        texCUBElod(
            reflectionProbeSampler,
            float4(
                reflectionVector,
                0.0f
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
        oneMinusSpecularSquared
        * grazingTerm
        + specularSquared;

    float3 environmentSpecular =
        reflectionLighting
        * secondaryModelLighting
        * MODEL_LIGHTING_SCALE
        * viewFresnel
        * envMapParms.x;

    // ------------------------------------------------------------------------
    // Existing spotlight/model-lighting result
    // ------------------------------------------------------------------------

    float3 litColor =
        diffuseColorLinear
        * combinedLighting
        + directSpecular;

    litColor +=
        environmentSpecular
        * occlusionSample.rgb;

    // ------------------------------------------------------------------------
    // Four local/glight contributions
    // ------------------------------------------------------------------------

    float4 deltaX =
        glightPosXs
        - input.texcoord5.x;

    float4 deltaY =
        glightPosYs
        - input.texcoord5.y;

    float4 deltaZ =
        glightPosZs
        - input.texcoord5.z;

    float4 localLightDistanceSquared =
        deltaX * deltaX
        + deltaY * deltaY
        + deltaZ * deltaZ;

    float4 inverseLocalLightDistance =
        rsqrt(
            localLightDistanceSquared
        );

    float4 localNormalDotLight =
        saturate(
            deltaX
            * inverseLocalLightDistance
            * worldNormal.x
            + deltaY
            * inverseLocalLightDistance
            * worldNormal.y
            + deltaZ
            * inverseLocalLightDistance
            * worldNormal.z
        );

    float4 localAttenuation =
        saturate(
            localLightDistanceSquared
            * glightFallOffs
            + 1.0f
        );

    float4 localWeights =
        localAttenuation
        * localNormalDotLight;

    float3 localDiffuseLighting;

    localDiffuseLighting.r =
        dot(
            glightReds,
            localWeights
        );

    localDiffuseLighting.g =
        dot(
            glightGreens,
            localWeights
        );

    localDiffuseLighting.b =
        dot(
            glightBlues,
            localWeights
        );

    litColor +=
        diffuseColorLinear
        * localDiffuseLighting;

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

    // ------------------------------------------------------------------------
    // Final output
    // ------------------------------------------------------------------------

#if UNCLAMP_HIGHLIGHTS

    // Preserve highlights above 1.0 while keeping the square-root input
    // nonnegative.
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
