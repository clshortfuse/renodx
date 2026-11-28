// Reconstructed from D3DX9 ps_3_0 assembly.
//
// Purpose:
//   Preserve the original shader math while restoring the implicit clamp that
//   the original UNORM render target applied to the completed pixel.
//
// This is intended for RenoDX/resource-upgrade testing where the target has
// been changed from UNORM to a floating-point format and this material/LOD
// becomes much brighter than vanilla.
//
// Original parameter/register layout:
//   fogColor                 c0
//   lightingLookupScale      c5
//   treeCanopyScatterColor   c6
//   treeCanopyLightingAmount c7
//   treeCanopyParms          c8
//   sunPosition              c17
//   sunDiffuse               c18
//   sunSpecular              c19
//   colorMapSampler          s0
//   modelLightingSampler     s4
//   normalMapSampler         s5
//   specularMapSampler       s6

sampler2D colorMapSampler      : register(s0);
sampler3D modelLightingSampler : register(s4);
sampler2D normalMapSampler     : register(s5);
sampler2D specularMapSampler   : register(s6);

float4 fogColor                 : register(c0);
float4 lightingLookupScale      : register(c5);
float4 treeCanopyScatterColor   : register(c6);
float4 treeCanopyLightingAmount : register(c7);
float4 treeCanopyParms          : register(c8);
float4 sunPosition              : register(c17);
float4 sunDiffuse               : register(c18);
float4 sunSpecular              : register(c19);

struct PixelInput
{
    float4 texCoord0 : TEXCOORD0;
    float3 texCoord1 : TEXCOORD1;
    float4 texCoord2 : TEXCOORD2;
    float4 texCoord3 : TEXCOORD3;
};

float4 main(PixelInput input) : COLOR0
{
    // 0: texld_pp r2, v0, s0
    float4 baseColor = tex2D(colorMapSampler, input.texCoord0.xy);

    // 1: nrm_pp r3.xyz, v2
    float3 normal = normalize(input.texCoord2.xyz);

    // 3,5,6: calculate reciprocal of the largest absolute normal component.
    // This is part of the game's 3D model-lighting lookup addressing.
    float largestNormalComponent = max(abs(normal.x), max(abs(normal.y), abs(normal.z)));
    float reciprocalLargestNormalComponent = rcp(largestNormalComponent);

    // 4: mul_pp r0.x, r2.w, v0.w
    float rawAlpha = baseColor.a * input.texCoord0.w;

    // 7,9,10: build and sample the 3D model-lighting lookup coordinate.
    float3 lightingLookupCoord =
        normal * lightingLookupScale.xyz * reciprocalLargestNormalComponent
        + input.texCoord3.xyz;

    float4 modelLighting = tex3D(modelLightingSampler, lightingLookupCoord);

    // 8: dp3_sat_pp r0.z, c17, r3
    float sunNdotL = saturate(dot(sunPosition.xyz, normal));

    // 10-14: sample the secondary map and build the narrow specular mask.
    float4 normalMap = tex2D(normalMapSampler, input.texCoord0.xy);

    float2 specularDelta;
    specularDelta.x = input.texCoord1.x - normalMap.w;
    specularDelta.y = input.texCoord1.y - normalMap.y;

    float specularMask = dot(specularDelta, specularDelta);
    specularMask = saturate(1.0 - specularMask * 32.0);

    // 13: add_pp r4.xyz, r1, r1
    // Deliberately preserve the game's 2x model-lighting term. On the original
    // UNORM path, any resulting over-range final pixel was clipped when stored.
    float3 doubledModelLighting = modelLighting.rgb * 2.0;

    // 15,17,18:
    // sunDiffuse * (1 + amount * (NdotL - 1))
    // = lerp(sunDiffuse, sunDiffuse * NdotL, amount)
    float3 canopySunDiffuse =
        sunDiffuse.rgb
        + treeCanopyLightingAmount.x
        * (sunDiffuse.rgb * sunNdotL - sunDiffuse.rgb);

    // 16,19,20,22: model-lighting alpha gates the specular response.
    float3 specularLighting =
        specularMask
        * sunSpecular.rgb
        * modelLighting.a;

    float3 specularTexture = tex2D(specularMapSampler, input.texCoord0.xy).rgb;

    float3 specular =
        specularLighting
        * specularTexture
        * input.texCoord2.w;

    // 21: model lighting + canopy sun diffuse.
    float3 totalLighting =
        doubledModelLighting
        + modelLighting.a * canopySunDiffuse;

    // 23: lit base color plus specular.
    float3 litColor = baseColor.rgb * totalLighting + specular;

    // 24-29: canopy scattering blend.
    float3 canopyScatterTarget =
        sunSpecular.rgb
        * treeCanopyScatterColor.rgb
        * treeCanopyParms.x;

    float canopyScatterAmount = modelLighting.a * input.texCoord1.z;

    float3 canopyColor =
        litColor
        + canopyScatterAmount * (canopyScatterTarget - litColor);

    // 31,33: original fog/fade expression.
    // Equivalent to:
    // fogColor + v3.w * (canopyColor * v0.z - fogColor)
    float3 finalColor =
        fogColor.rgb
        + input.texCoord3.w
        * (canopyColor * input.texCoord0.z - fogColor.rgb);

    // 32: texkill r0
    // At this point r0.xyzw all contain rawAlpha in the assembly, so this is
    // equivalent to killing pixels when rawAlpha is negative.
    clip(rawAlpha);

    // IMPORTANT FIX:
    // The original shader wrote to a UNORM target, which clamped the completed
    // RGB/A pixel to [0,1] during storage. A float upgrade removes that implicit
    // clamp and lets the 2x lookup lighting, sun, specular and scatter escape
    // above 1.0, causing this material/LOD to become much too bright.
    //
    // Restoring the clamp here reproduces the original target behavior without
    // changing any of the upstream lighting equations.
    finalColor = saturate(finalColor);
    float finalAlpha = saturate(rawAlpha);

    return float4(finalColor, finalAlpha);
}
