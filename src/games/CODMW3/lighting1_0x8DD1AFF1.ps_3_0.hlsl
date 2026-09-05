// Clamped reconstruction of the original ps_3_0 material-lighting shader.
//
// Processing:
//   - Sun-shadow sampling and partition blending
//   - Normal-map decoding
//   - Model/ambient lighting lookup
//   - Direct diffuse lighting
//   - Direct specular lighting
//   - Reflection-probe lighting
//   - Detail-map application
//   - Color-saturation transform
//   - Fog
//
// Change:
//   The final RGB output is clamped to 0.0–1.0 using saturate().
//
// This prevents the shader from writing HDR values above 1.0, even when
// rendering into R16G16B16A16_FLOAT.
//
// Alpha remains fixed at 1.0, matching the original assembly.

sampler2D colorMapSampler             : register(s0);
samplerCUBE reflectionProbeSampler    : register(s1);
sampler3D modelLightingSampler        : register(s4);
sampler2D shadowmapSamplerSun         : register(s5);
sampler2D normalMapSampler            : register(s6);
sampler2D specularMapSampler          : register(s7);
sampler2D detailMapSampler            : register(s8);

float4 fogColorLinear                 : register(c0);
float4 shadowmapSwitchPartition       : register(c2);
float4 lightingLookupScale            : register(c3);
float4 shadowmapScale                 : register(c4);
float4 sunShadowmapPixelAdjust        : register(c5);
float4 envMapParms                    : register(c6);
float4 colorSaturationR               : register(c7);
float4 colorSaturationG               : register(c8);
float4 colorSaturationB               : register(c9);
float4 detailScale                    : register(c11);

float4 lightPosition                  : register(c17);
float4 lightDiffuse                   : register(c18);
float4 lightSpecular                  : register(c19);


// Original shader constants.

static const float4 kMath0 = float4(
    -0.5f,
     1.0f,
     9.3775177f,
     1.41421354f
);

static const float4 kNormalDecode = float4(
     4.07999992f,
     4.06451607f,
    -2.07999992f,
    -2.06451607f
);

static const float4 kMath1 = float4(
    -5.0f,
     4.5f,
     7.0f,
    -0.999249995f
);

static const float4 kMath2 = float4(
    1.44269502f,
    1.0f,
    0.0f,
    0.25f
);

static const float4 kMath3 = float4(
    8.0f,
    0.0f,
    0.0f,
    0.0f
);


struct PS_INPUT
{
    float3 color     : COLOR0;

    float2 texcoord0 : TEXCOORD0;
    float4 texcoord1 : TEXCOORD1;
    float3 texcoord2 : TEXCOORD2;
    float3 texcoord3 : TEXCOORD3;
    float3 texcoord4 : TEXCOORD4;
    float3 texcoord5 : TEXCOORD5;
    float3 texcoord6 : TEXCOORD6;
};


float4 main(PS_INPUT input) : COLOR0
{
    float4 r0 = 0.0f;
    float4 r1 = 0.0f;
    float4 r2 = 0.0f;
    float4 r3 = 0.0f;
    float4 r4 = 0.0f;
    float4 r5 = 0.0f;
    float4 r6 = 0.0f;


    // ---------------------------------------------------------------------
    // First four-tap sun-shadow lookup
    // ---------------------------------------------------------------------

    r0 = input.texcoord4.xyxy - sunShadowmapPixelAdjust.zwxy;

    r1.xy = r0.zw;

    r2 = sunShadowmapPixelAdjust + input.texcoord4.xyxy;

    // Preserve the original r2 values because the assembly writes selected
    // components of r2 while reading other components from the old value.
    float4 oldR2 = r2;

    r3.x = oldR2.x;
    r3.y = oldR2.y;
    r3.w = 0.0f;

    r2.x = oldR2.z;
    r2.y = oldR2.w;
    r2.w = 0.0f;

    r3.z = input.texcoord4.z;

    r1.zw = r3.zw;

    r3 = tex2Dlod(shadowmapSamplerSun, r3);
    r1 = tex2Dlod(shadowmapSamplerSun, r1);

    r3.y = r1.x;

    r2.z = input.texcoord4.z;

    r1 = tex2Dlod(shadowmapSamplerSun, r2);

    r0.zw = r2.zw;

    r3.z = r1.x;

    r1 = tex2Dlod(shadowmapSamplerSun, r0);

    r3.w = r1.x;

    // Average four shadow samples.
    r1.x = dot(r3, kMath2.wwww);


    // ---------------------------------------------------------------------
    // Second four-tap sun-shadow lookup
    // ---------------------------------------------------------------------

    r2.y =
        input.texcoord4.x * shadowmapSwitchPartition.w
        + shadowmapSwitchPartition.x;

    r2.w =
        input.texcoord4.y * shadowmapSwitchPartition.w
        + shadowmapSwitchPartition.y;

    r3 = r2.ywyw + sunShadowmapPixelAdjust.zwxy;

    r0.xy = r3.zw;

    r4 = tex2Dlod(shadowmapSamplerSun, r0);

    r5 = r2.ywyw - sunShadowmapPixelAdjust.zwxy;

    r0.xy = r5.zw;

    r6 = tex2Dlod(shadowmapSamplerSun, r0);

    // Preserve the existing depth and LOD components.
    r3.zw = r0.zw;

    r4.y = r6.x;

    r5.zw = r3.zw;

    r0 = tex2Dlod(shadowmapSamplerSun, r3);
    r4.z = r0.x;

    r0 = tex2Dlod(shadowmapSamplerSun, r5);
    r4.w = r0.x;

    // Average the second group of four shadow samples.
    r0.x = dot(r4, kMath2.wwww);


    // ---------------------------------------------------------------------
    // Normal-map decoding and tangent-space transformation
    // ---------------------------------------------------------------------

    r3 = tex2D(
        normalMapSampler,
        input.texcoord0
    );

    r0.y =
        r3.w * kNormalDecode.x
        + kNormalDecode.z;

    r0.z =
        r3.y * kNormalDecode.y
        + kNormalDecode.w;

    r3.xyz = input.texcoord1.xyz;

    r1.y =
        r0.y * input.texcoord3.x
        + r3.x;

    r1.z =
        r0.y * input.texcoord3.y
        + r3.y;

    r1.w =
        r0.y * input.texcoord3.z
        + r3.z;

    r0.y =
        r0.z * input.texcoord2.x
        + r1.y;

    r0.z =
        r0.z * input.texcoord2.y
        + r1.z;

    r0.w =
        r0.z * input.texcoord2.z
        + r1.w;

    r3.xyz = normalize(
        float3(r0.y, r0.z, r0.w)
    );


    // ---------------------------------------------------------------------
    // Model-lighting lookup
    // ---------------------------------------------------------------------

    r0.y = max(abs(r3.y), abs(r3.z));
    r1.y = max(abs(r3.x), r0.y);

    r0.y = 1.0f / r1.y;

    r1.y = r3.x * lightingLookupScale.x;
    r1.z = r3.y * lightingLookupScale.y;
    r1.w = r3.z * lightingLookupScale.z;

    r0.y =
        r1.y * r0.y
        + input.texcoord6.x;

    r0.z =
        r1.z * r0.y
        + input.texcoord6.y;

    r0.w =
        r1.w * r0.y
        + input.texcoord6.z;

    r4 = tex3D(
        modelLightingSampler,
        r0.yzw
    );


    // ---------------------------------------------------------------------
    // Shadow partition blending
    // ---------------------------------------------------------------------

    r2.x = input.texcoord4.x;
    r2.z = input.texcoord4.y;

    r2 =
        r2 * shadowmapScale.xxyy
        + shadowmapScale.zzzw;

    r0.y = max(abs(r2.x), abs(r2.z));
    r0.z = max(abs(r2.y), abs(r2.w));

    // This is intentionally saturated because it is a shadow transition
    // weight rather than final color.
    r0.yz = saturate(kMath3.xx - r0.yz);

    r1.y = lerp(
        r4.w,
        r0.x,
        r0.z
    );

 // Diagnostic: assume the upgraded lighting lookup is already linear.
r2.xyz = max(r4.xyz, 0.0f);

    r0.x =
        r0.y * (-r0.z)
        + r0.y;

    // Match the original cmp instruction.
    r0.x =
        (-abs(r0.x) >= 0.0f)
        ? r0.y
        : kMath0.y;

    r2.w = lerp(
        r1.y,
        r1.x,
        r0.x
    );


    // ---------------------------------------------------------------------
    // View and reflection vectors
    // ---------------------------------------------------------------------

    r0.xyz = normalize(input.texcoord5.xyz);

    r0.w = dot(r0.xyz, r3.xyz);

    r1.x = r0.w + r0.w;

    r0.w = kMath0.y - abs(r0.w);

    r1.y = pow(
        abs(r0.w),
        envMapParms.z
    );

    r0.w = lerp(
        envMapParms.x,
        envMapParms.y,
        r1.y
    );

    r1.xyz =
        r3.xyz * (-r1.x)
        + r0.xyz;


    // ---------------------------------------------------------------------
    // Direct diffuse lighting
    // ---------------------------------------------------------------------

    r0.x = saturate(
        dot(lightPosition.xyz, r3.xyz)
    );

    r0.xyz =
        r0.x * lightDiffuse.xyz;

    r0.xyz =
        r2.w * r0.xyz
        + r2.xyz;


    // ---------------------------------------------------------------------
    // Direct specular lighting
    // ---------------------------------------------------------------------

    r2.x = dot(
        r1.xyz,
        lightPosition.xyz
    );

    r3 = tex2D(
        specularMapSampler,
        input.texcoord0
    );

    r2.y =
        r3.w * kMath0.z;

    // D3D9 EXP is base 2.
    r2.y = exp2(r2.y);

    r2.x += kMath1.w;
    r2.y += kMath1.z;

    r2.x *= r2.y;
    r2.x *= kMath2.x;

    // Original exp_sat_pp behavior.
    r2.x = saturate(exp2(r2.x));

    r2.xyz =
        r2.x * lightSpecular.xyz;


    // ---------------------------------------------------------------------
    // Reflection probe
    // ---------------------------------------------------------------------

    r1.w =
        r3.w * kMath1.x
        + kMath1.y;

    r3.xyz *= r3.xyz;
    r3.xyz *= r0.w;

    r1 = texCUBElod(
        reflectionProbeSampler,
        r1
    );

    r1.xyz *= kMath0.w;

    // Match D3D9 LOG behavior by using the absolute source.
    r4.x = log2(abs(r1.x));
    r4.y = log2(abs(r1.y));
    r4.z = log2(abs(r1.z));

    r1.xyz =
        r4.xyz * envMapParms.w;

    r4.x = exp2(r1.x);
    r4.y = exp2(r1.y);
    r4.z = exp2(r1.z);

    // Combine shadowed direct specular with the reflection probe.
    r1.xyz =
        r2.w * r2.xyz
        + r4.xyz;

    r1.xyz *= r3.xyz;


    // ---------------------------------------------------------------------
    // Detail map and base texture
    // ---------------------------------------------------------------------

    r2.xy =
        detailScale.xy * input.texcoord0;

    r2 = tex2D(
        detailMapSampler,
        r2.xy
    );

    // Recenter the detail texture from 0–1 to approximately -0.5–0.5.
    r2.xyz += kMath0.xxx;

    r3 = tex2D(
        colorMapSampler,
        input.texcoord0
    );

    // Base alpha controls detail-map intensity.
    r2.xyz =
        r2.xyz * r3.w
        + r3.xyz;

    r2.xyz *= input.color;

    // Original shader squares the material color.
    r2.xyz *= r2.xyz;

    r2.w = kMath0.y;


    // ---------------------------------------------------------------------
    // Color-saturation transform
    // ---------------------------------------------------------------------

    // Preserve the original sequential register behavior.
    r2.x = dot(r2, colorSaturationR);
    r2.y = dot(r2, colorSaturationG);
    r2.z = dot(r2, colorSaturationB);


    // ---------------------------------------------------------------------
    // Final lighting and fog
    // ---------------------------------------------------------------------

    r0.xyz =
        r2.xyz * r0.xyz
        + r1.xyz;

    r0.xyz -= fogColorLinear.xyz;

    float3 outputColor =
        input.texcoord1.w * r0.xyz
        + fogColorLinear.xyz;


    // ---------------------------------------------------------------------
    // CLAMPED CHANGE
    //
    // Prevent negative RGB and values above SDR white.
    // ---------------------------------------------------------------------

    outputColor = saturate(outputColor);


    return float4(
        outputColor,
        1.0f
    );
}