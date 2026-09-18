//
// Human-readable reconstruction of the original ps_3_0 shader.
//
// One intentional change:
//
//   finalLinearColor = saturate(finalLinearColor);
//
// This restores the original 0-1 UNORM-style range immediately before
// the shader's final HDR-factor / sRGB encoding stage.
//

// ============================================================================
// CONSTANTS
// ============================================================================

float4 CBHDRFactor__packed0
    : register(c1);

float4 CBScreen__packed1
    : register(c2);

float fGlobalTransparency
    : register(c3);

float4 CBViewProjection__packed4
    : register(c4);

float3 fAlbedoColor
    : register(c5);

float3 fLightMapColor
    : register(c6);

float4 Globals__packed8
    : register(c7);

float4 Globals__packed9
    : register(c8);

float4 CBAmbient__packed1
    : register(c9);

float4 CBMaterial__packed0
    : register(c10);

float4 CBMaterial__packed1
    : register(c11);

float4 CBFog__packed0
    : register(c12);

float4 CBFog__packed1
    : register(c13);

float4 CBFog__packed2
    : register(c14);

float4 CBFog__packed4
    : register(c15);


// ============================================================================
// TEXTURES
// ============================================================================

sampler2D SSNormalMap__tNormalMap
    : register(s0);

sampler2D SSAlbedoMap__tAlbedoMap
    : register(s1);

sampler2D SSPoint__tLightAccumulationTexture0
    : register(s2);

sampler2D SSLightMap__tLightMap
    : register(s3);

samplerCUBE SSEnvMap__tEnvMap
    : register(s4);

sampler2D SSSpecularMap__tSpecularMap
    : register(s5);


// ============================================================================
// INPUT
// ============================================================================

struct PS_INPUT
{
    // v0.y
    float4 color
        : COLOR0;

    // v1
    float4 texcoord0
        : TEXCOORD0;

    // v2.xyz
    float4 texcoord1
        : TEXCOORD1;

    // v3.xyz
    float4 texcoord2
        : TEXCOORD2;

    // v4.xyz
    float4 texcoord3
        : TEXCOORD3;

    // v5.xy
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
    // FACE-ORIENTED BASE NORMAL
    //
    // ASM 0:
    //
    // cmp r0.xyz, vFace, -v1, v1
    // ========================================================================

    float3 geometryNormal =
        (input.faceDirection >= 0.0f)
            ? -input.texcoord0.xyz
            : input.texcoord0.xyz;


    // ========================================================================
    // NORMALIZE GEOMETRY NORMAL
    //
    // ASM 1-6
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
    // ASM 7-12
    //
    // v3 = TEXCOORD2
    // ========================================================================

    float tangentLengthSquared =
        dot(
            input.texcoord2.xyz,
            input.texcoord2.xyz);


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
        input.texcoord2.xyz
        * tangentNormalizeScale;


    // ========================================================================
    // NORMALIZE BITANGENT
    //
    // ASM 13-18
    //
    // v4 = TEXCOORD3
    // ========================================================================

    float bitangentLengthSquared =
        dot(
            input.texcoord3.xyz,
            input.texcoord3.xyz);


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
        input.texcoord3.xyz
        * bitangentNormalizeScale;


    // ========================================================================
    // NORMAL MAP
    //
    // ASM 19:
    //
    // texld r3, v5, s0
    // ========================================================================

    float4 normalMapSample =
        tex2D(
            SSNormalMap__tNormalMap,
            input.texcoord4.xy);


    // ========================================================================
    // NORMAL MAP X / Y DECODE
    //
    // ASM 19-20:
    //
    // add r3.xy, r3.wyzw, -0.498039216
    // add r3.xy, r3, r3
    //
    // X comes from alpha.
    // Y comes from green.
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
    // TANGENT + BITANGENT CONTRIBUTION
    //
    // ASM 21-22
    // ========================================================================

    float3 tangentSpaceNormal =
        bitangent
        * normalY;


    tangentSpaceNormal =
        tangent
        * normalX
        + tangentSpaceNormal;


    // ========================================================================
    // RECONSTRUCT NORMAL Z
    //
    // ASM 23-24:
    //
    // 1 - X^2 - Y^2
    // ========================================================================

    float normalZSquared =
        1.0f
        - normalX * normalX;


    normalZSquared =
        normalZSquared
        - normalY * normalY;


    // ========================================================================
    // NORMAL Z FALLBACK TEST
    //
    // ASM 25
    // ========================================================================

    float normalZFallbackTest =
        0.0001f
        - normalZSquared;


    // ========================================================================
    // ORIGINAL SQRT
    //
    // ASM 26-27:
    //
    // rsq
    // rcp
    // ========================================================================

    float normalZInverse =
        rsqrt(
            normalZSquared);


    float normalZ =
        1.0f
        / normalZInverse;


    // ========================================================================
    // ORIGINAL 0.01 FALLBACK
    //
    // ASM 28
    // ========================================================================

    normalZ =
        (normalZFallbackTest >= 0.0f)
            ? 0.01f
            : normalZ;


    // ========================================================================
    // BUILD WORLD-SPACE NORMAL
    //
    // ASM 29
    // ========================================================================

    float3 reconstructedNormal =
        geometryNormal
        * normalZ
        + tangentSpaceNormal;


    // ========================================================================
    // NORMALIZE FINAL SURFACE NORMAL
    //
    // ASM 30
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
    // VIEW DIRECTION
    //
    // ASM 33-34:
    //
    // add r0.xyz, -c4, v2
    // nrm r2.xyz, r0
    //
    // v2 = TEXCOORD1
    // ========================================================================

    float3 viewVector =
        input.texcoord1.xyz
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
    // REFLECTION VECTOR
    //
    // ASM 37-39
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
    // FRESNEL BASE
    //
    // ASM 40-41:
    //
    // dot(N, -V)
    // 1 - dot
    // ========================================================================

    float fresnelBase =
        dot(
            surfaceNormal,
            -viewDirection);


    fresnelBase =
        1.0f
        - fresnelBase;


    // ========================================================================
    // ENVIRONMENT MAP
    //
    // ASM 42
    // ========================================================================

    float4 environmentSample =
        texCUBE(
            SSEnvMap__tEnvMap,
            reflectionVector);


    // ========================================================================
    // ENVIRONMENT HDR DECODE
    //
    // ASM 42-44:
    //
    // RGB / Alpha
    // then material environment/specular color
    //
    // Left exactly like the original shader.
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
    // SCREEN-SPACE LIGHT UV
    //
    // ASM 45-46:
    //
    // add r1.xy, 0.5, vPos
    // mul r1.xy, r1, c2.zw
    // ========================================================================

    float2 screenUV =
        input.screenPosition
        + 0.5f;


    screenUV *=
        CBScreen__packed1.zw;


    // ========================================================================
    // POINT-LIGHT ACCUMULATION
    //
    // ASM 47
    // ========================================================================

    float4 pointLightSample =
        tex2D(
            SSPoint__tLightAccumulationTexture0,
            screenUV);


    // ========================================================================
    // POINT-LIGHT LUMINANCE
    //
    // ASM 47
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
    // ASM 48-51
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
    // POINT SPECULAR + ENVIRONMENT
    //
    // ASM 52:
    //
    // mad r0.xyz, r2, c8, r0
    // ========================================================================

    float3 specularLighting =
        normalizedPointLight
        * Globals__packed9.rgb
        + environmentLighting;


    // ========================================================================
    // SPECULAR MAP
    //
    // ASM 53
    // ========================================================================

    float4 specularMapSample =
        tex2D(
            SSSpecularMap__tSpecularMap,
            input.texcoord4.xy);


    specularLighting *=
        specularMapSample.g;


    // ========================================================================
    // LIGHT MAP
    //
    // ASM 54
    // ========================================================================

    float4 lightMapSample =
        tex2D(
            SSLightMap__tLightMap,
            input.texcoord5.xy);


    // ========================================================================
    // LIGHT-MAP HDR DECODE
    //
    // ASM 54-55:
    //
    // R / A
    // G / A
    // B / A
    //
    // Again, deliberately preserved.
    // ========================================================================

    float inverseLightMapAlpha =
        1.0f
        / lightMapSample.a;


    float decodedLightR =
        lightMapSample.r
        * inverseLightMapAlpha;


    float decodedLightG =
        lightMapSample.g
        * inverseLightMapAlpha;


    float decodedLightB =
        lightMapSample.b
        * inverseLightMapAlpha;


    float3 decodedLightMap =
        float3(
            decodedLightR,
            decodedLightG,
            decodedLightB);


    // ========================================================================
    // LIGHT-MAP RGB SUM
    //
    // ASM 56
    // ========================================================================

    float lightMapSum =
        decodedLightG
        + decodedLightR;


    // ========================================================================
    // DIFFUSE LIGHTING
    //
    // ASM 57:
    //
    // point light RGB
    // +
    // decoded lightmap * fLightMapColor
    // ========================================================================

    float3 diffuseLighting =
        decodedLightMap
        * fLightMapColor
        + pointLightSample.rgb;


    // ========================================================================
    // MATERIAL DIFFUSE COLOR
    //
    // ASM 58
    // ========================================================================

    diffuseLighting *=
        CBMaterial__packed0.rgb;


    // ========================================================================
    // COMPLETE LIGHT-MAP SUM
    //
    // ASM 59
    //
    // Notice the original register still contains raw B in r2.z.
    // ========================================================================

    lightMapSum =
        lightMapSample.b
        * inverseLightMapAlpha
        + lightMapSum;


    // ========================================================================
    // VERTEX/MATERIAL LIGHT SCALE
    //
    // ASM 60:
    //
    // mul r1, r1, v1.w
    //
    // Both diffuse RGB and the lightmap average accumulator are scaled.
    // ========================================================================

    diffuseLighting *=
        input.texcoord0.w;


    lightMapSum *=
        input.texcoord0.w;


    // ========================================================================
    // LIGHT-MAP AVERAGE
    //
    // ASM 61
    // ========================================================================

    float lightMapAverage =
        lightMapSum
        * 0.333333343f;


    // ========================================================================
    // APPLY LIGHT-MAP INTENSITY TO SPECULAR
    //
    // ASM 62
    // ========================================================================

    specularLighting *=
        lightMapAverage;


    // ========================================================================
    // FRESNEL ^ 5
    //
    // ASM 63-65
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
    // ORIGINAL FRESNEL LERP
    //
    // ASM 66-67:
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
    // ASM 68
    // ========================================================================

    specularLighting *=
        fresnelFactor;


specularLighting =
    min(specularLighting, 1.0f);
    // ========================================================================
    // ALBEDO MAP
    //
    // ASM 69
    // ========================================================================

    float4 albedoSample =
        tex2D(
            SSAlbedoMap__tAlbedoMap,
            input.texcoord4.xy);


    // ========================================================================
    // ALBEDO COLOR
    //
    // ASM 69:
    //
    // r2.yzw becomes:
    //
    //   albedo.r * fAlbedoColor.r
    //   albedo.g * fAlbedoColor.g
    //   albedo.b * fAlbedoColor.b
    // ========================================================================

    float3 albedoColor =
        albedoSample.rgb
        * fAlbedoColor;


    // ========================================================================
    // DIFFUSE + SPECULAR
    //
    // ASM 70:
    //
    // mad r0.xyz, albedoColor, diffuseLighting, specularLighting
    // ========================================================================

    float3 litColor =
        albedoColor
        * diffuseLighting
        + specularLighting;


    // ========================================================================
    // FOG #1
    //
    // ASM 71-73
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
    // ASM 74
    // ========================================================================

    float fogBlend0 =
        fogAmount0
        * CBFog__packed4.y;


    // ========================================================================
    // FOG #1 REMAINING
    //
    // ASM 75
    // ========================================================================

    float fogRemaining0 =
        fogAmount0
        * -CBFog__packed4.y
        + 1.0f;


    // ========================================================================
    // FOG #1 COLOR
    //
    // ASM 76
    // ========================================================================

    float3 fogColor0 =
        fogBlend0
        * CBFog__packed0.rgb;


    // ========================================================================
    // FOG #2
    //
    // ASM 77-79
    //
    // Uses world/view position Y from TEXCOORD1.
    // ========================================================================

    float fogAmount1 =
        input.texcoord1.y
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
    // ASM 80
    // ========================================================================

    float fogBlend1 =
        fogAmount1
        * CBFog__packed4.z;


    // ========================================================================
    // FOG #2 REMAINING
    //
    // ASM 81
    // ========================================================================

    float fogRemaining1 =
        fogAmount1
        * -CBFog__packed4.z
        + 1.0f;


    // ========================================================================
    // COMBINE FOG COLORS
    //
    // ASM 82
    // ========================================================================

    float3 finalFogColor =
        fogBlend1
        * CBFog__packed2.rgb
        + (1.0f - fogBlend1)
        * fogColor0;


    // ========================================================================
    // FOG LIGHTING SCALE
    //
    // ASM 83
    // ========================================================================

    float fogLightingScale =
        CBFog__packed4.w
        * CBFog__packed4.x;


    // ========================================================================
    // APPLY FOG LIGHT SCALE TO DIFFUSE
    //
    // ASM 84
    // ========================================================================

    float3 fogLighting =
        diffuseLighting
        * fogLightingScale;


    // ========================================================================
    // ADD REMAINING FOG
    //
    // ASM 85
    // ========================================================================

    float remainingFog =
        fogRemaining0
        * fogRemaining1;


    fogLighting +=
        remainingFog;


    // ========================================================================
    // ORIGINAL UPPER CLAMP
    //
    // ASM 86:
    //
    // min r2.xyz, r1, 1
    //
    // This is already part of the original shader.
    // ========================================================================

    float3 fogAttenuation =
        min(
            fogLighting,
            1.0f);


    // ========================================================================
    // FINAL LIGHTING + FOG
    //
    // ASM 87:
    //
    // mad r0.xyz, r0, r2, r4
    // ========================================================================

    float3 finalLinearColor =
        litColor
        * fogAttenuation
        + finalFogColor;




    // ========================================================================
    // ORIGINAL ASM 88
    //
    // mov r1.x, c1.x
    //
    // CBHDRFactor.x is about to be used for the final output conversion.
    // ========================================================================

    float hdrFactor =
        CBHDRFactor__packed0.x;


    // ========================================================================
    // sRGB THRESHOLD TEST
    //
    // ASM 89:
    //
    // mad r1.xyz, r0, -c1.x, 0.003131
    //
    // =
    //
    // 0.003131 - finalLinearColor * hdrFactor
    // ========================================================================

    float3 srgbThresholdTest =
        0.00313100009f
        - finalLinearColor
        * hdrFactor;


    // ========================================================================
    // APPLY HDR FACTOR
    //
    // ASM 90
    // ========================================================================

    float3 srgbInput =
        finalLinearColor
        * hdrFactor;


    // ========================================================================
    // GAMMA CURVE - RED
    //
    // ASM 91 + 94
    // ========================================================================

    float gammaRed =
        pow(
            srgbInput.r,
            0.416666657f);


    gammaRed =
        gammaRed
        * 1.05499995f
        - 0.0549999997f;


    // ========================================================================
    // LINEAR sRGB BRANCH
    //
    // ASM 95
    // ========================================================================

    float3 linearSRGB =
        srgbInput
        * 12.9200001f;


    // ========================================================================
    // OUTPUT RED
    //
    // ASM 96
    // ========================================================================

    float outputRed =
        (srgbThresholdTest.r >= 0.0f)
            ? linearSRGB.r
            : gammaRed;


    // ========================================================================
    // GAMMA CURVE - GREEN
    //
    // ASM 97
    // ========================================================================

    float gammaGreen =
        pow(
            srgbInput.g,
            0.416666657f);


    // ========================================================================
    // GAMMA CURVE - BLUE
    //
    // ASM 100
    // ========================================================================

    float gammaBlue =
        pow(
            srgbInput.b,
            0.416666657f);


    // ========================================================================
    // FINISH BLUE GAMMA
    //
    // ASM 103
    // ========================================================================

    gammaBlue =
        gammaBlue
        * 1.05499995f
        - 0.0549999997f;


    // ========================================================================
    // OUTPUT BLUE
    //
    // ASM 104
    // ========================================================================

    float outputBlue =
        (srgbThresholdTest.b >= 0.0f)
            ? linearSRGB.b
            : gammaBlue;


    // ========================================================================
    // FINISH GREEN GAMMA
    //
    // ASM 105
    // ========================================================================

    gammaGreen =
        gammaGreen
        * 1.05499995f
        - 0.0549999997f;


    // ========================================================================
    // OUTPUT GREEN
    //
    // ASM 106
    // ========================================================================

    float outputGreen =
        (srgbThresholdTest.g >= 0.0f)
            ? linearSRGB.g
            : gammaGreen;


    // ========================================================================
    // OUTPUT ALPHA
    //
    // ASM 107:
    //
    // mov oC0.w, c3.x
    //
    // Unlike the previous shader, alpha here is simply the global
    // transparency constant.
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