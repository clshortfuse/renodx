//
// Human-readable reconstruction of the original ps_3_0 shader.
//
// FP16 SPECULAR FIX:
// The original specular response is preserved from 0.0 to 1.0.
// Values above 1.0 are smoothly compressed toward 2.0.
//
// The fix is applied AFTER the complete specular/Fresnel calculation
// and BEFORE specular is combined with diffuse/albedo.
//
// Original location:
//     after ASM 78
//     before ASM 79
//

// ============================================================================
// CONSTANTS
// ============================================================================

float4 CBHDRFactor__packed0
    : register(c1);

float4 CBScreen__packed1
    : register(c2);

float4 CBROPTest__packed0
    : register(c3);

float fGlobalTransparency
    : register(c4);

float4 CBViewProjection__packed4
    : register(c5);

float3 fLightMaskSelector
    : register(c6);

float4 CBAmbient__packed0
    : register(c7);

float4 CBAmbient__packed1
    : register(c8);

float3 fAlbedoColor
    : register(c9);

float4 Globals__packed8
    : register(c10);

float4 Globals__packed9
    : register(c11);

float4 CBMaterial__packed0
    : register(c12);

float4 CBMaterial__packed1
    : register(c13);

float4 CBFog__packed0
    : register(c14);

float4 CBFog__packed1
    : register(c15);

float4 CBFog__packed2
    : register(c16);

float4 CBFog__packed4
    : register(c17);


// ============================================================================
// TEXTURES
// ============================================================================

sampler2D SSPoint__tLightMaskMap
    : register(s0);

sampler2D SSPoint__tLightAccumulationTexture0
    : register(s1);

sampler2D SSNormalMap__tNormalMap
    : register(s2);

sampler2D SSAlbedoMap__tAlbedoMap
    : register(s3);

samplerCUBE SSEnvMap__tEnvMap
    : register(s4);

sampler2D SSSpecularMap__tSpecularMap
    : register(s5);


// ============================================================================
// INPUTS
// ============================================================================

struct PS_INPUT
{
    // v0.y
    float4 color
        : COLOR0;

    // v1.xyz
    float4 texcoord0
        : TEXCOORD0;

    // v2.xyzw
    float4 texcoord1
        : TEXCOORD1;

    // v3.xyz
    float4 texcoord2
        : TEXCOORD2;

    // v4.xyz
    float4 texcoord3
        : TEXCOORD3;

    // v5.xyz
    float4 texcoord4
        : TEXCOORD4;

    // v6.xy
    float4 texcoord5
        : TEXCOORD5;

    float2 screenPosition
        : VPOS;

    float faceDirection
        : VFACE;
};


// ============================================================================
// MAIN
// ============================================================================

float4 main(PS_INPUT input) : COLOR0
{
    // ========================================================================
    // ALPHA / ROP TEST
    //
    // ASM 0-3:
    //
    //   mov r0.x, -1
    //   add r0.y, r0.x, c3.x
    //   cmp r1, r0.y, -1, -0
    //   texkill r1
    //
    // Discard when CBROPTest.x >= 1.
    // ========================================================================

    float ropTest =
        -1.0f
        + CBROPTest__packed0.x;


    float killValue =
        (ropTest >= 0.0f)
            ? -1.0f
            : -0.0f;


    clip(killValue);


    // ========================================================================
    // SCREEN-SPACE UV
    //
    // ASM 4 + 27:
    //
    //   add r0.yz, 0.5, vPos.xy
    //   mul r0.yz, r0, c2.xzww
    //
    // Destination .yz makes this resolve to c2.zw.
    // ========================================================================

    float2 screenUV =
        input.screenPosition
        + 0.5f;


    screenUV *=
        CBScreen__packed1.zw;


    // ========================================================================
    // FACE-ORIENTED GEOMETRY NORMAL
    //
    // ASM 5
    // ========================================================================

    float3 geometryNormal =
        (input.faceDirection >= 0.0f)
            ? -input.texcoord1.xyz
            : input.texcoord1.xyz;


    // ========================================================================
    // NORMALIZE GEOMETRY NORMAL
    //
    // ASM 6-9 + 17-18
    // ========================================================================

    float geometryLengthSquared =
        dot(
            geometryNormal,
            geometryNormal);


    float geometryInverseLength =
        rsqrt(
            geometryLengthSquared);


    float geometryLength =
        1.0f
        / geometryInverseLength;


    float geometryTinyTest =
        0.000001f
        - geometryLength;


    float geometryNormalizeScale =
        (geometryTinyTest >= 0.0f)
            ? 1000000.0f
            : geometryInverseLength;


    geometryNormal *=
        geometryNormalizeScale;


    // ========================================================================
    // NORMALIZE TANGENT
    //
    // ASM 10-12 + 16 + 19-20
    //
    // v4 = TEXCOORD3
    // ========================================================================

    float tangentLengthSquared =
        dot(
            input.texcoord3.xyz,
            input.texcoord3.xyz);


    float tangentInverseLength =
        rsqrt(
            tangentLengthSquared);


    float tangentLength =
        1.0f
        / tangentInverseLength;


    float tangentTinyTest =
        0.000001f
        - tangentLength;


    float tangentNormalizeScale =
        (tangentTinyTest >= 0.0f)
            ? 1000000.0f
            : tangentInverseLength;


    float3 tangent =
        input.texcoord3.xyz
        * tangentNormalizeScale;


    // ========================================================================
    // NORMALIZE BITANGENT
    //
    // ASM 13-16 + 21-22
    //
    // v5 = TEXCOORD4
    // ========================================================================

    float bitangentLengthSquared =
        dot(
            input.texcoord4.xyz,
            input.texcoord4.xyz);


    float bitangentInverseLength =
        rsqrt(
            bitangentLengthSquared);


    float bitangentLength =
        1.0f
        / bitangentInverseLength;


    float bitangentTinyTest =
        0.000001f
        - bitangentLength;


    float bitangentNormalizeScale =
        (bitangentTinyTest >= 0.0f)
            ? 1000000.0f
            : bitangentInverseLength;


    float3 bitangent =
        input.texcoord4.xyz
        * bitangentNormalizeScale;


    // ========================================================================
    // VIEW DIRECTION
    //
    // ASM 23-24
    //
    //   worldPosition - cameraPosition
    // ========================================================================

    float3 viewVector =
        input.texcoord2.xyz
        - CBViewProjection__packed4.xyz;


    float viewInverseLength =
        rsqrt(
            dot(
                viewVector,
                viewVector));


    float3 viewDirection =
        viewVector
        * viewInverseLength;


    // ========================================================================
    // LIGHT MASK
    //
    // ASM 28
    // ========================================================================

    float4 lightMaskSample =
        tex2D(
            SSPoint__tLightMaskMap,
            screenUV);


    // ========================================================================
    // LIGHT MASK CHANNEL REARRANGEMENT
    //
    // ASM 28:
    //
    //   max r6, r4.zwxy, c8.yzyz
    //
    // r4.zwxy =
    //
    //   B A R G
    //
    // c8.yzyz =
    //
    //   Y Z Y Z
    // ========================================================================

    float4 processedLightMask =
        max(
            lightMaskSample.zwxy,
            CBAmbient__packed1.yzyz);


    // ========================================================================
    // LIGHT MASK SELECTOR
    //
    // ASM 29
    //
    //   mul r4, r6, c6.xyxy
    // ========================================================================

    processedLightMask *=
        fLightMaskSelector.xyxy;


    // ========================================================================
    // SELECT LIGHT MASK PAIR
    //
    // ASM 30:
    //
    //   cmp r4.xy, -c6.z, r4.xy, r4.zw
    //
    // If selector.z <= 0:
    //     use XY
    //
    // Otherwise:
    //     use ZW
    // ========================================================================

    float2 selectedLightMask =
        (-fLightMaskSelector.z >= 0.0f)
            ? processedLightMask.xy
            : processedLightMask.zw;


    // ========================================================================
    // NORMAL MAP
    //
    // ASM 31
    // ========================================================================

    float4 normalMapSample =
        tex2D(
            SSNormalMap__tNormalMap,
            input.texcoord5.xy);


    // ========================================================================
    // NORMAL MAP X/Y DECODE
    //
    // ASM 31-32:
    //
    // X = alpha
    // Y = green
    // ========================================================================

    float normalX =
        normalMapSample.a
        - 0.498039216f;


    float normalY =
        normalMapSample.g
        - 0.498039216f;


    normalX += normalX;
    normalY += normalY;


    // ========================================================================
    // NORMAL Z RECONSTRUCTION
    //
    // ASM 33-38
    // ========================================================================

    float normalZSquared =
        1.0f
        - normalX * normalX;


    normalZSquared -=
        normalY * normalY;


    float normalZFallbackTest =
        0.0001f
        - normalZSquared;


    float normalZInverse =
        rsqrt(
            normalZSquared);


    float normalZ =
        1.0f
        / normalZInverse;


    normalZ =
        (normalZFallbackTest >= 0.0f)
            ? 0.01f
            : normalZ;


    // ========================================================================
    // BUILD TANGENT-SPACE NORMAL
    //
    // ASM 39-41
    // ========================================================================

    float3 reconstructedNormal =
        bitangent
        * normalY;


    reconstructedNormal =
        tangent
        * normalX
        + reconstructedNormal;


    reconstructedNormal =
        geometryNormal
        * normalZ
        + reconstructedNormal;


    // ========================================================================
    // NORMALIZE SURFACE NORMAL
    //
    // ASM 42
    // ========================================================================

    float surfaceNormalInverseLength =
        rsqrt(
            dot(
                reconstructedNormal,
                reconstructedNormal));


    float3 surfaceNormal =
        reconstructedNormal
        * surfaceNormalInverseLength;


    // ========================================================================
    // REFLECTION VECTOR
    //
    // ASM 45-47
    // ========================================================================

    float viewNormalDot =
        dot(
            viewDirection,
            surfaceNormal);


    float doubledViewNormalDot =
        viewNormalDot
        + viewNormalDot;


    float3 reflectionVector =
        surfaceNormal
        * -doubledViewNormalDot
        + viewDirection;


    // ========================================================================
    // ALBEDO MAP
    //
    // ASM 48
    // ========================================================================

    float4 albedoSample =
        tex2D(
            SSAlbedoMap__tAlbedoMap,
            input.texcoord5.xy);


    float3 albedoColor =
        albedoSample.rgb
        * fAlbedoColor;


    // ========================================================================
    // POINT-LIGHT ACCUMULATION
    //
    // ASM 49
    // ========================================================================

    float4 pointLightSample =
        tex2D(
            SSPoint__tLightAccumulationTexture0,
            screenUV);


    // ========================================================================
    // POINT-LIGHT LUMINANCE
    //
    // ASM 49
    // ========================================================================

    float pointLightLuminance =
        dot(
            pointLightSample.rgb,
            float3(
                0.298911989f,
                0.586610019f,
                0.114478f));


    // ========================================================================
    // POINT-LIGHT NORMALIZATION
    //
    // ASM 50-53
    // ========================================================================

    float pointLightNormalizationBase =
        max(
            CBAmbient__packed1.w,
            pointLightLuminance);


    float inversePointLightNormalization =
        1.0f
        / pointLightNormalizationBase;


    float normalizedPointLightAlpha =
        pointLightSample.a
        * inversePointLightNormalization;


    float3 normalizedPointLight =
        pointLightSample.rgb
        * normalizedPointLightAlpha;


    // ========================================================================
    // LIGHT MASK STRENGTH
    //
    // ASM 54
    // ========================================================================

    float lightMaskStrength =
        max(
            selectedLightMask.x,
            selectedLightMask.y);


    // ========================================================================
    // AMBIENT BLEND STRENGTH
    //
    // ASM 55
    // ========================================================================

    float ambientBlend =
        lightMaskStrength
        * CBAmbient__packed0.w;


    // ========================================================================
    // AMBIENT / VERTEX LIGHTING
    //
    // ASM 56:
    //
    // lrp r4.xyz, ambientBlend, c7, v1
    //
    // D3D9 LRP:
    //
    // ambientBlend * c7
    // +
    // (1 - ambientBlend) * v1
    // ========================================================================

    float3 diffuseLighting =
        ambientBlend
        * CBAmbient__packed0.rgb
        + (1.0f - ambientBlend)
        * input.texcoord0.xyz;


    // ========================================================================
    // ADD POINT LIGHT
    //
    // ASM 57
    // ========================================================================

    diffuseLighting +=
        pointLightSample.rgb;


    // ========================================================================
    // MATERIAL DIFFUSE COLOR
    //
    // ASM 58
    // ========================================================================

    diffuseLighting *=
        CBMaterial__packed0.rgb;


    // ========================================================================
    // VERTEX LIGHT SCALE
    //
    // ASM 59
    // ========================================================================

    diffuseLighting *=
        input.texcoord1.w;


    // ========================================================================
    // AVERAGE VERTEX LIGHT INTENSITY
    //
    // ASM 60-63
    // ========================================================================

    float vertexLightAverage =
        input.texcoord0.r
        + input.texcoord0.g
        + input.texcoord0.b;


    vertexLightAverage *=
        input.texcoord1.w;


    vertexLightAverage *=
        0.333333343f;


    // ========================================================================
    // ENVIRONMENT MAP
    //
    // ASM 64
    // ========================================================================

    float4 environmentSample =
        texCUBE(
            SSEnvMap__tEnvMap,
            reflectionVector);


    // ========================================================================
    // ENVIRONMENT HDR DECODE
    //
    // ASM 64-66:
    //
    // RGB / Alpha
    //
    // Left exactly as the original shader.
    // ========================================================================

    float inverseEnvironmentAlpha =
        1.0f
        / environmentSample.a;


    float3 environmentLighting =
        environmentSample.rgb
        * inverseEnvironmentAlpha;


    environmentLighting *=
        CBMaterial__packed1.rgb;


    // ========================================================================
    // ENVIRONMENT ATTENUATION
    //
    // ASM 67:
    //
    //   1 - CBAmbient1.x * pointLightNormalizationBase
    // ========================================================================

    float environmentAttenuation =
        1.0f
        - CBAmbient__packed1.x
        * pointLightNormalizationBase;


    // ========================================================================
    // APPLY ENVIRONMENT ATTENUATION
    //
    // ASM 68
    // ========================================================================

    environmentLighting *=
        environmentAttenuation;


    // ========================================================================
    // COMBINE POINT SPECULAR + ENVIRONMENT SPECULAR
    //
    // ASM 69
    // ========================================================================

    float3 specularLighting =
        normalizedPointLight
        * Globals__packed9.rgb
        + environmentLighting;


    // ========================================================================
    // SPECULAR MAP
    //
    // ASM 70
    // ========================================================================

    float4 specularMapSample =
        tex2D(
            SSSpecularMap__tSpecularMap,
            input.texcoord5.xy);


    specularLighting *=
        specularMapSample.g;


    // ========================================================================
    // VERTEX LIGHT INTENSITY -> SPECULAR
    //
    // ASM 71
    // ========================================================================

    specularLighting *=
        vertexLightAverage;


    // ========================================================================
    // FRESNEL BASE
    //
    // ASM 72-73
    //
    //   1 - dot(N, -V)
    // ========================================================================

    float fresnelBase =
        dot(
            surfaceNormal,
            -viewDirection);


    fresnelBase =
        1.0f
        - fresnelBase;


    // ========================================================================
    // FRESNEL ^ 5
    //
    // ASM 74-76
    // ========================================================================

    float fresnelSquared =
        fresnelBase
        * fresnelBase;


    float fresnelFourth =
        fresnelSquared
        * fresnelSquared;


    float fresnelPower5 =
        fresnelBase
        * fresnelFourth;


    // ========================================================================
    // FRESNEL RESPONSE
    //
    // ASM 77
    //
    // lrp fresnel, 1, Globals8.x
    // ========================================================================

    float fresnelFactor =
        fresnelPower5
        + (1.0f - fresnelPower5)
        * Globals__packed8.x;


    // ========================================================================
    // APPLY FRESNEL
    //
    // ASM 78
    // ========================================================================

    specularLighting *=
        fresnelFactor;


specularLighting =
    min(specularLighting, 1.0f);


    float3 specularOverRange =
        max(
            specularLighting - 1.0f,
            0.0f);


    specularOverRange =
        specularOverRange
        / (1.0f + specularOverRange);


    specularLighting =
        min(
            specularLighting,
            1.0f)
        + specularOverRange;


    // ========================================================================
    // DIFFUSE + SPECULAR
    //
    // ASM 79
    //
    // albedo * diffuse + specular
    // ========================================================================

    float3 litColor =
        albedoColor
        * diffuseLighting
        + specularLighting;


    // ========================================================================
    // FOG #1
    //
    // ASM 80-82
    // ========================================================================

    float fogAmount0 =
        input.color.y
        - CBFog__packed1.z;


    fogAmount0 =
        saturate(
            fogAmount0
            * CBFog__packed1.w);


    fogAmount0 *=
        CBFog__packed0.w;


    // ========================================================================
    // FOG #1 BLEND
    //
    // ASM 83
    // ========================================================================

    float fogBlend0 =
        fogAmount0
        * CBFog__packed4.y;


    // ========================================================================
    // FOG #1 COLOR
    //
    // ASM 84
    // ========================================================================

    float3 fogColor0 =
        fogBlend0
        * CBFog__packed0.rgb;


    // ========================================================================
    // FOG #1 REMAINING
    //
    // ASM 85
    // ========================================================================

    float fogRemaining0 =
        1.0f
        - fogAmount0
        * CBFog__packed4.y;


    // ========================================================================
    // FOG #2
    //
    // ASM 86-88
    // ========================================================================

    float fogAmount1 =
        input.texcoord2.y
        - CBFog__packed1.x;


    fogAmount1 =
        saturate(
            fogAmount1
            * CBFog__packed1.y);


    fogAmount1 *=
        CBFog__packed2.w;


    // ========================================================================
    // FOG #2 BLEND
    //
    // ASM 89
    // ========================================================================

    float fogBlend1 =
        fogAmount1
        * CBFog__packed4.z;


    // ========================================================================
    // FOG #2 REMAINING
    //
    // ASM 90
    // ========================================================================

    float fogRemaining1 =
        1.0f
        - fogAmount1
        * CBFog__packed4.z;


    // ========================================================================
    // COMBINE FOG COLORS
    //
    // ASM 91
    // ========================================================================

    float3 finalFogColor =
        fogBlend1
        * CBFog__packed2.rgb
        + (1.0f - fogBlend1)
        * fogColor0;


    // ========================================================================
    // FOG LIGHTING SCALE
    //
    // ASM 92
    // ========================================================================

    float fogLightingScale =
        CBFog__packed4.w
        * CBFog__packed4.x;


    // ========================================================================
    // FOG LIGHTING
    //
    // ASM 93
    // ========================================================================

    float3 fogLighting =
        diffuseLighting
        * fogLightingScale;


    // ========================================================================
    // ADD REMAINING FOG
    //
    // ASM 94
    // ========================================================================

    float remainingFog =
        fogRemaining0
        * fogRemaining1;


    fogLighting +=
        remainingFog;


    // ========================================================================
    // ORIGINAL FOG UPPER CLAMP
    //
    // ASM 95
    // ========================================================================

    float3 fogAttenuation =
        min(
            fogLighting,
            1.0f);


    // ========================================================================
    // FINAL LINEAR COLOR
    //
    // ASM 96
    //
    // IMPORTANT:
    // There is NO full final 0-1 clamp here.
    //
    // HDR brightness from diffuse/fog is therefore still preserved.
    // ========================================================================

    float3 finalLinearColor =
        litColor
        * fogAttenuation
        + finalFogColor;


    // ========================================================================
    // HDR FACTOR
    //
    // ASM 97
    // ========================================================================

    float3 srgbInput =
        finalLinearColor
        * CBHDRFactor__packed0.x;


    // ========================================================================
    // sRGB THRESHOLD
    //
    // ASM 98-99
    // ========================================================================

    float3 srgbThresholdTest =
        0.00313100009f
        - srgbInput;


    // ========================================================================
    // LINEAR sRGB BRANCH
    //
    // ASM 100
    // ========================================================================

    float3 srgbLinear =
        srgbInput
        * 12.9200001f;


    // ========================================================================
    // RED GAMMA BRANCH
    //
    // ASM 101-105
    // ========================================================================

    float gammaRed =
        pow(
            srgbInput.r,
            0.416666657f);


    gammaRed =
        gammaRed
        * 1.05499995f
        - 0.0549999997f;


    float outputRed =
        (srgbThresholdTest.r >= 0.0f)
            ? srgbLinear.r
            : gammaRed;


    // ========================================================================
    // GREEN GAMMA BRANCH
    //
    // ASM 106-110
    // ========================================================================

    float gammaGreen =
        pow(
            srgbInput.g,
            0.416666657f);


    gammaGreen =
        gammaGreen
        * 1.05499995f
        - 0.0549999997f;


    float outputGreen =
        (srgbThresholdTest.g >= 0.0f)
            ? srgbLinear.g
            : gammaGreen;


    // ========================================================================
    // BLUE GAMMA BRANCH
    //
    // ASM 111-115
    // ========================================================================

    float gammaBlue =
        pow(
            srgbInput.b,
            0.416666657f);


    gammaBlue =
        gammaBlue
        * 1.05499995f
        - 0.0549999997f;


    float outputBlue =
        (srgbThresholdTest.b >= 0.0f)
            ? srgbLinear.b
            : gammaBlue;


    // ========================================================================
    // OUTPUT ALPHA
    //
    // ASM 116:
    //
    //   mov oC0.w, c4.x
    // ========================================================================

    float outputAlpha =
        fGlobalTransparency;


    // ========================================================================
    // FINAL OUTPUT
    // ========================================================================

    return float4(
        outputRed,
        outputGreen,
        outputBlue,
        outputAlpha);
}