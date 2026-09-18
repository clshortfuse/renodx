//
// Human-readable reconstruction of the original ps_3_0 shader.
//
// NO HDR / FP16 FIXES HAVE BEEN ADDED.
//
// The goal of this file is to reproduce the original shader logic first.
// Once this behaves correctly, modifications can be made surgically.
//

// ============================================================================
// CONSTANT BUFFERS / CONSTANT REGISTERS
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

float3 fAlbedoColor
    : register(c6);

float3 fLightMapColor
    : register(c7);

float4 Globals__packed8
    : register(c8);

float4 Globals__packed9
    : register(c9);

float4 CBMaterial__packed0
    : register(c10);

float4 CBMaterial__packed1
    : register(c11);

float4 CBAmbient__packed1
    : register(c12);

float4 CBFog__packed0
    : register(c13);

float4 CBFog__packed1
    : register(c14);

float4 CBFog__packed2
    : register(c15);

float4 CBFog__packed4
    : register(c16);


// ============================================================================
// TEXTURES
// ============================================================================

sampler2D SSNormalMap__tNormalMap
    : register(s0);

sampler2D SSAlbedoMap__tAlbedoMap
    : register(s1);

sampler2D SSTransparencyMap__tTransparencyMap
    : register(s2);

sampler2D SSPoint__tLightAccumulationTexture0
    : register(s3);

sampler2D SSLightMap__tLightMap
    : register(s4);

samplerCUBE SSEnvMap__tEnvMap
    : register(s5);

sampler2D SSSpecularMap__tSpecularMap
    : register(s6);


// ============================================================================
// INPUT
// ============================================================================

struct PS_INPUT
{
    // v0.y
    float4 color
        : COLOR0;

    // v1.w
    float4 texcoord0
        : TEXCOORD0;

    // v2
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

    // v7
    float4 texcoord6
        : TEXCOORD6;

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
    // ALBEDO
    //
    // ASM:
    //   texld r0, v6, s1
    // ========================================================================

    float4 albedoSample =
        tex2D(
            SSAlbedoMap__tAlbedoMap,
            input.texcoord5.xy);


    // ========================================================================
    // MATERIAL ALPHA
    //
    // ASM:
    //   mul r0.w, r0.w, v1.w
    // ========================================================================

    float materialAlpha =
        albedoSample.a
        * input.texcoord0.w;


    // ========================================================================
    // TRANSPARENCY MAP
    //
    // ASM:
    //   texld r1, v7.zwzw, s2
    //   add   r1.x, -r1.y, 1
    //   rcp   r1.x, r1.x
    //   mul   r0.w, r0.w, r1.x
    // ========================================================================

    float4 transparencySample =
        tex2D(
            SSTransparencyMap__tTransparencyMap,
            input.texcoord6.zw);


    float inverseTransparency =
        1.0f
        / (1.0f - transparencySample.g);


    materialAlpha *=
        inverseTransparency;


    // ========================================================================
    // OUTPUT ALPHA BASE
    //
    // ASM:
    //   mul r1.x, r0.w, c10.w
    // ========================================================================

    float outputAlphaBase =
        materialAlpha
        * CBMaterial__packed0.w;


    // ========================================================================
    // ALPHA TEST
    //
    // ASM:
    //   mov     r1.w, c10.w
    //   mad     r0.w, r0.w, -r1.w, c3.x
    //   cmp     r2, r0.w, -1, -0
    //   texkill r2
    // ========================================================================

    float alphaTest =
        CBROPTest__packed0.x
        - materialAlpha
        * CBMaterial__packed0.w;


    float killValue =
        (alphaTest >= 0.0f)
            ? -1.0f
            : -0.0f;


    clip(killValue);


    // ========================================================================
    // SCREEN-SPACE UV
    //
    // ASM:
    //   add r1.yz, 0.5, vPos.xxyw
    //   mul r1.yz, r1, c2.xzww
    //
    // Because the destination is .yz:
    //
    //   r1.y uses c2.z
    //   r1.z uses c2.w
    //
    // So the actual screen scale is c2.zw.
    // ========================================================================

    float2 screenUV =
        input.screenPosition
        + 0.5f;


    screenUV *=
        CBScreen__packed1.zw;


    // ========================================================================
    // FACE-ORIENTED GEOMETRY NORMAL
    //
    // ASM:
    //   cmp r2.xyz, vFace, -v2, v2
    // ========================================================================

    float3 geometryNormal =
        (input.faceDirection >= 0.0f)
            ? -input.texcoord1.xyz
            : input.texcoord1.xyz;


    // ========================================================================
    // NORMALIZE GEOMETRY NORMAL
    //
    // ASM 11-14:
    //
    //   dp3 r0.w, r2, r2
    //   rsq r0.w, r0.w
    //   rcp r1.w, r0.w
    //   add r1.w, -r1.w, 0.000001
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


    // ========================================================================
    // TANGENT LENGTH
    //
    // ASM 15-17
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


    // ========================================================================
    // BITANGENT LENGTH
    //
    // ASM 18-20
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


    // ========================================================================
    // ORIGINAL SMALL-VECTOR TESTS
    //
    // ASM:
    //   add r3.xz, -r3, 0.000001
    // ========================================================================

    float tangentTinyTest =
        0.000001f
        - tangentLength;


    float bitangentTinyTest =
        0.000001f
        - bitangentLength;


    // ========================================================================
    // ORIGINAL GEOMETRY NORMAL FALLBACK
    //
    // ASM:
    //   cmp r0.w, r1.w, 1000000, r0.w
    //   mul r2.xyz, r0.w, r2
    // ========================================================================

    float geometryNormalizeScale =
        (geometryTinyTest >= 0.0f)
            ? 1000000.0f
            : geometryInverseLength;


    geometryNormal *=
        geometryNormalizeScale;


    // ========================================================================
    // ORIGINAL TANGENT FALLBACK
    //
    // ASM:
    //   cmp r0.w, r3.x, 1000000, r2.w
    //   mul r4.xyz, r0.w, v4
    // ========================================================================

    float tangentNormalizeScale =
        (tangentTinyTest >= 0.0f)
            ? 1000000.0f
            : tangentInverseLength;


    float3 tangent =
        input.texcoord3.xyz
        * tangentNormalizeScale;


    // ========================================================================
    // ORIGINAL BITANGENT FALLBACK
    //
    // ASM:
    //   cmp r0.w, r3.z, 1000000, r3.y
    //   mul r3.xyz, r0.w, v5
    // ========================================================================

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
    // ASM:
    //   add r5.xyz, -c5, v3
    //   nrm r6.xyz, r5
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
    // NORMAL MAP
    //
    // ASM:
    //   texld r5, v6, s0
    // ========================================================================

    float4 normalMapSample =
        tex2D(
            SSNormalMap__tNormalMap,
            input.texcoord5.xy);


    // ========================================================================
    // NORMAL MAP X / Y DECODE
    //
    // ASM:
    //   add r5.xy, r5.wyzw, -0.498039216
    //   add r5.xy, r5, r5
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
    // RECONSTRUCT NORMAL Z
    //
    // ASM:
    //   mad r0.w, r5.x, -r5.x, 1
    //   mad r0.w, r5.y, -r5.y, r0.w
    // ========================================================================

    float normalZSquared =
        1.0f
        - normalX * normalX;


    normalZSquared =
        normalZSquared
        - normalY * normalY;


    // ========================================================================
    // ORIGINAL NORMAL-Z FALLBACK TEST
    //
    // ASM:
    //   add r1.w, -r0.w, 0.0001
    // ========================================================================

    float normalZFallbackTest =
        0.0001f
        - normalZSquared;


    // ========================================================================
    // ORIGINAL SQRT IMPLEMENTATION
    //
    // ASM:
    //   rsq r0.w, r0.w
    //   rcp r0.w, r0.w
    // ========================================================================

    float normalZInverse =
        rsqrt(
            normalZSquared);


    float normalZ =
        1.0f
        / normalZInverse;


    // ========================================================================
    // ORIGINAL FALLBACK
    //
    // ASM:
    //   cmp r0.w, r1.w, 0.01, r0.w
    // ========================================================================

    normalZ =
        (normalZFallbackTest >= 0.0f)
            ? 0.01f
            : normalZ;


    // ========================================================================
    // TANGENT-SPACE NORMAL -> WORLD NORMAL
    //
    // ASM:
    //   mul r3.xyz, r3, r5.y
    //   mad r3.xyz, r4, r5.x, r3
    //   mad r2.xyz, r2, r0.w, r3
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
    // NORMALIZE FINAL NORMAL
    //
    // ASM:
    //   nrm r3.xyz, r2
    // ========================================================================

    float finalNormalInverseLength =
        rsqrt(
            dot(
                reconstructedNormal,
                reconstructedNormal));


    float3 surfaceNormal =
        reconstructedNormal
        * finalNormalInverseLength;


    // ========================================================================
    // REFLECTION VECTOR
    //
    // ASM:
    //   dp3 r0.w, r6, r3
    //   add r0.w, r0.w, r0.w
    //   mad r2.xyz, r3, -r0.w, r6
    // ========================================================================

    float doubledViewNormalDot =
        dot(
            viewDirection,
            surfaceNormal);


    doubledViewNormalDot +=
        doubledViewNormalDot;


    float3 reflectionVector =
        surfaceNormal
        * -doubledViewNormalDot
        + viewDirection;


    // ========================================================================
    // ALBEDO COLOR
    //
    // ASM:
    //   mul r0.xyz, r0, c6
    // ========================================================================

    float3 albedoColor =
        albedoSample.rgb
        * fAlbedoColor;


    // ========================================================================
    // POINT-LIGHT ACCUMULATION
    //
    // ASM:
    //   texld r4, r1.yzzw, s3
    // ========================================================================

    float4 pointLightSample =
        tex2D(
            SSPoint__tLightAccumulationTexture0,
            screenUV);


    // ========================================================================
    // POINT-LIGHT LUMINANCE
    //
    // ASM:
    //   dp3 r0.w, r4, c18.yzww
    //
    // c18.yzw =
    //   0.298911989
    //   0.586610019
    //   0.114478
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
    // ASM:
    //   max r1.y, c12.w, r0.w
    //   rcp r0.w, r1.y
    //   mul r0.w, r0.w, r4.w
    // ========================================================================

    float pointLightNormalizationBase =
        max(
            CBAmbient__packed1.w,
            pointLightLuminance);


    float pointLightScale =
        1.0f
        / pointLightNormalizationBase;


    pointLightScale *=
        pointLightSample.a;


    // ========================================================================
    // NORMALIZED POINT-LIGHT RGB
    //
    // ASM:
    //   mul r1.yzw, r0.w, r4.xxyz
    //
    // Due to the destination .yzw and source .xxyz,
    // this resolves to pointLightSample.rgb.
    // ========================================================================

    float3 normalizedPointLight =
        pointLightSample.rgb
        * pointLightScale;


    // ========================================================================
    // LIGHT MAP
    //
    // ASM:
    //   texld r5, v7, s4
    // ========================================================================

    float4 lightMapSample =
        tex2D(
            SSLightMap__tLightMap,
            input.texcoord6.xy);


    // ========================================================================
    // LIGHT-MAP ALPHA RECIPROCAL
    //
    // ASM:
    //   rcp r0.w, r5.w
    //
    // This is intentionally left exactly as the original shader does it.
    // ========================================================================

    float inverseLightMapAlpha =
        1.0f
        / lightMapSample.a;


    // ========================================================================
    // DECODE LIGHT MAP
    //
    // ASM:
    //   mul r5.xyw, r0.w, r5.xyzz
    //
    // Register result:
    //
    //   r5.x = R / A
    //   r5.y = G / A
    //   r5.w = B / A
    //
    // r5.z still contains the ORIGINAL blue value.
    // ========================================================================

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
    // DIFFUSE LIGHTING
    //
    // ASM:
    //   mad r4.xyz, r5.xyww, c7, r4
    // ========================================================================

    float3 diffuseLighting =
        decodedLightMap
        * fLightMapColor
        + pointLightSample.rgb;


    // ========================================================================
    // MATERIAL DIFFUSE COLOR
    //
    // ASM:
    //   mul r4.xyz, r4, c10
    // ========================================================================

    diffuseLighting *=
        CBMaterial__packed0.rgb;


    // ========================================================================
    // VERTEX / MATERIAL LIGHT SCALE
    //
    // ASM:
    //   mul r4.xyz, r4, v2.w
    // ========================================================================

    diffuseLighting *=
        input.texcoord1.w;


    // ========================================================================
    // LIGHT-MAP AVERAGE
    //
    // ASM:
    //   add r2.w, r5.y, r5.x
    //   mad r0.w, r5.z, inverseAlpha, r2.w
    //   mul r0.w, r0.w, v2.w
    //   mul r0.w, r0.w, 1/3
    // ========================================================================

    float lightMapSum =
        decodedLightG
        + decodedLightR;


    lightMapSum =
        lightMapSample.b
        * inverseLightMapAlpha
        + lightMapSum;


    float lightMapAverage =
        lightMapSum
        * input.texcoord1.w;


    lightMapAverage *=
        0.333333343f;


    // ========================================================================
    // ENVIRONMENT MAP
    //
    // ASM:
    //   texld r2, r2, s5
    // ========================================================================

    float4 environmentSample =
        texCUBE(
            SSEnvMap__tEnvMap,
            reflectionVector);


    // ========================================================================
    // ENVIRONMENT ALPHA RECIPROCAL
    //
    // ASM:
    //   rcp r2.w, r2.w
    //
    // Also intentionally left unchanged.
    // ========================================================================

    float inverseEnvironmentAlpha =
        1.0f
        / environmentSample.a;


    // ========================================================================
    // ENVIRONMENT RGB DECODE
    //
    // ASM:
    //   mul r2.xyz, r2.w, r2
    // ========================================================================

    float3 environmentLighting =
        environmentSample.rgb
        * inverseEnvironmentAlpha;


    // ========================================================================
    // MATERIAL ENVIRONMENT / SPECULAR COLOR
    //
    // ASM:
    //   mul r2.xyz, r2, c11
    // ========================================================================

    environmentLighting *=
        CBMaterial__packed1.rgb;


    // ========================================================================
    // COMBINE POINT-LIGHT SPECULAR + ENVIRONMENT
    //
    // ASM:
    //   mad r1.yzw, r1, c9.xxyz, r2.xxyz
    //
    // This resolves to:
    //
    //   normalizedPointLight.rgb * Globals9.rgb
    //   + environmentLighting.rgb
    // ========================================================================

    float3 specularLighting =
        normalizedPointLight
        * Globals__packed9.rgb
        + environmentLighting;


    // ========================================================================
    // SPECULAR MAP
    //
    // ASM:
    //   texld r2, v6, s6
    // ========================================================================

    float4 specularMapSample =
        tex2D(
            SSSpecularMap__tSpecularMap,
            input.texcoord5.xy);


    // ========================================================================
    // SPECULAR STRENGTH
    //
    // ASM:
    //   mul r1.yzw, r1, r2.y
    // ========================================================================

    specularLighting *=
        specularMapSample.g;


    // ========================================================================
    // LIGHT-MAP SPECULAR SCALE
    //
    // ASM:
    //   mul r1.yzw, r0.w, r1
    // ========================================================================

    specularLighting *=
        lightMapAverage;


    // ========================================================================
    // FRESNEL
    //
    // ASM:
    //   dp3 r0.w, r3, -r6
    //   add r0.w, -r0.w, 1
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
    // ASM:
    //   mul r2.x, r0.w, r0.w
    //   mul r2.x, r2.x, r2.x
    //   mul r0.w, r0.w, r2.x
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
    // ASM:
    //   mov r2.x, 1
    //   lrp r3.x, fresnel, 1, c8.x
    //
    // D3D9 lrp:
    //
    //   result = A * B + (1-A) * C
    // ========================================================================

    float fresnelFactor =
        fresnelPower5 * 1.0f
        + (1.0f - fresnelPower5)
        * Globals__packed8.x;


    // ========================================================================
    // APPLY FRESNEL TO SPECULAR
    //
    // ASM:
    //   mul r1.yzw, r1, r3.x
    // ========================================================================

    specularLighting *=
        fresnelFactor;


specularLighting =
    min(specularLighting, 1.0f);
    // ========================================================================
    // DIFFUSE + SPECULAR
    //
    // ASM:
    //   mad r0.xyz, r0, r4, r1.yzww
    // ========================================================================

    float3 litColor =
        albedoColor
        * diffuseLighting
        + specularLighting;


    // ========================================================================
    // OUTPUT ALPHA
    //
    // ASM:
    //   mul oC0.w, r1.x, c4.x
    // ========================================================================

    float outputAlpha =
        outputAlphaBase
        * fGlobalTransparency;


    // ========================================================================
    // FOG TERM #1
    //
    // ASM:
    //   add     r0.w, -c14.z, v0.y
    //   mul_sat r0.w, r0.w, c14.w
    //   mul     r0.w, r0.w, c13.w
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
    // FOG TERM #1 COLOR
    //
    // ASM:
    //   mul r1.x, r0.w, c16.y
    //   mul r1.xyz, r1.x, c13
    // ========================================================================

    float fogBlend0 =
        fogAmount0
        * CBFog__packed4.y;


    float3 fogColor0 =
        fogBlend0
        * CBFog__packed0.rgb;


    // ========================================================================
    // REMAINING FOG #1
    //
    // ASM:
    //   mad r0.w, r0.w, -c16.y, 1
    // ========================================================================

    float fogRemaining0 =
        fogAmount0
        * -CBFog__packed4.y
        + 1.0f;


    // ========================================================================
    // FOG TERM #2
    //
    // ASM:
    //   add     r1.w, -c14.x, v3.y
    //   mul_sat r1.w, r1.w, c14.y
    //   mul     r1.w, r1.w, c15.w
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
    // FOG TERM #2 BLEND
    //
    // ASM:
    //   mul r2.y, r1.w, c16.z
    // ========================================================================

    float fogBlend1 =
        fogAmount1
        * CBFog__packed4.z;


    // ========================================================================
    // REMAINING FOG #2
    //
    // ASM:
    //   mad r1.w, r1.w, -c16.z, 1
    // ========================================================================

    float fogRemaining1 =
        fogAmount1
        * -CBFog__packed4.z
        + 1.0f;


    // ========================================================================
    // FOG COLOR COMBINATION
    //
    // ASM:
    //   lrp r3.xyz, r2.y, c15, r1
    //
    // result =
    //   fogBlend1 * CBFog2.rgb
    //   + (1-fogBlend1) * fogColor0
    // ========================================================================

    float3 finalFogColor =
        fogBlend1
        * CBFog__packed2.rgb
        + (1.0f - fogBlend1)
        * fogColor0;


    // ========================================================================
    // FOG LIGHTING SCALE
    //
    // ASM:
    //   mul r1.x, c16.w, c16.x
    // ========================================================================

    float fogLightingScale =
        CBFog__packed4.w
        * CBFog__packed4.x;


    // ========================================================================
    // FOG-LIGHT ATTENUATION
    //
    // ASM:
    //   mul r1.xyz, r1.x, r4
    // ========================================================================

    float3 fogLighting =
        diffuseLighting
        * fogLightingScale;


    // ========================================================================
    // ADD REMAINING FOG
    //
    // ASM:
    //   mad r1.xyz, r0.w, r1.w, r1
    //
    // r0.w and r1.w are scalars, so the same value is added to RGB.
    // ========================================================================

    float remainingFog =
        fogRemaining0
        * fogRemaining1;


    fogLighting +=
        remainingFog;


    // ========================================================================
    // ORIGINAL UPPER CLAMP
    //
    // ASM:
    //   min r2.xyz, r1, 1
    //
    // IMPORTANT:
    //
    // This is ONLY an upper clamp.
    // There is no max(..., 0) here in the original shader.
    // ========================================================================

    float3 fogAttenuation =
        min(
            fogLighting,
            1.0f);


    // ========================================================================
    // APPLY FOG
    //
    // ASM:
    //   mad r0.xyz, r0, r2, r3
    // ========================================================================

    float3 finalLinearColor =
        litColor
        * fogAttenuation
        + finalFogColor;

    // ========================================================================
    // HDR FACTOR
    //
    // ASM:
    //   mul r1.xyz, r0, c1.x
    // ========================================================================

    float3 srgbInput =
        finalLinearColor
        * CBHDRFactor__packed0.x;


    // ========================================================================
    // sRGB THRESHOLD TEST
    //
    // ASM:
    //   mov r2.y, 0.003131
    //   mad r0.xyz, r0, -c1.x, r2.y
    //
    // equivalent to:
    //
    //   0.003131 - srgbInput
    // ========================================================================

    float3 srgbThresholdTest =
        0.00313100009f
        - srgbInput;


    // ========================================================================
    // LINEAR PORTION OF sRGB CURVE
    //
    // ASM:
    //   mul r2.xyz, r1, 12.92
    // ========================================================================

    float3 srgbLinearResult =
        srgbInput
        * 12.9200001f;


    // ========================================================================
    // GAMMA PORTION - RED
    //
    // ASM:
    //   pow r0.w, r1.x, 0.416666657
    //   mad r0.w, r0.w, 1.055, -0.055
    // ========================================================================

    float srgbGammaRed =
        pow(
            srgbInput.r,
            0.416666657f);


    srgbGammaRed =
        srgbGammaRed
        * 1.05499995f
        - 0.0549999997f;


    // ========================================================================
    // OUTPUT RED
    //
    // ASM:
    //   cmp oC0.x, r0.x, r2.x, r0.w
    // ========================================================================

    float outputRed =
        (srgbThresholdTest.r >= 0.0f)
            ? srgbLinearResult.r
            : srgbGammaRed;


    // ========================================================================
    // GAMMA PORTION - GREEN
    //
    // ASM:
    //   pow r0.x, r1.y, 0.416666657
    //   mad r0.x, r0.x, 1.055, -0.055
    // ========================================================================

    float srgbGammaGreen =
        pow(
            srgbInput.g,
            0.416666657f);


    srgbGammaGreen =
        srgbGammaGreen
        * 1.05499995f
        - 0.0549999997f;


    // ========================================================================
    // OUTPUT GREEN
    //
    // ASM:
    //   cmp oC0.y, r0.y, r2.y, r0.x
    // ========================================================================

    float outputGreen =
        (srgbThresholdTest.g >= 0.0f)
            ? srgbLinearResult.g
            : srgbGammaGreen;


    // ========================================================================
    // GAMMA PORTION - BLUE
    //
    // ASM:
    //   pow r0.x, r1.z, 0.416666657
    //   mad r0.x, r0.x, 1.055, -0.055
    // ========================================================================

    float srgbGammaBlue =
        pow(
            srgbInput.b,
            0.416666657f);


    srgbGammaBlue =
        srgbGammaBlue
        * 1.05499995f
        - 0.0549999997f;


    // ========================================================================
    // OUTPUT BLUE
    //
    // ASM:
    //   cmp oC0.z, r0.z, r2.z, r0.x
    // ========================================================================

    float outputBlue =
        (srgbThresholdTest.b >= 0.0f)
            ? srgbLinearResult.b
            : srgbGammaBlue;


    // ========================================================================
    // FINAL OUTPUT
    // ========================================================================

    return float4(
        outputRed,
        outputGreen,
        outputBlue,
        outputAlpha);
}