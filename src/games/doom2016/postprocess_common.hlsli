#include "./shared.h"

#if DOOM2016_TONEMAP_VARIANT == 1
#include "../../shaders/tonemap/psychov/test17.hlsl"
#elif DOOM2016_TONEMAP_VARIANT == 2
#include "../../shaders/tonemap/psychov/test22.hlsl"
#elif DOOM2016_TONEMAP_VARIANT == 3
#include "./psychov_test24.hlsli"
#elif DOOM2016_TONEMAP_VARIANT == 4
#include "../../shaders/tonemap/neutwo.hlsl"
#include "./psychov_test25.hlsli"
#elif DOOM2016_TONEMAP_VARIANT == 5
#include "./psychov_test30.hlsli"
#elif DOOM2016_TONEMAP_VARIANT == 6
#include "../../shaders/tonemap/reno_drt.hlsl"
#endif

float _105;

layout(set = 0, binding = 2, std140) uniform freqHigh_fragmentUniforms_ubo
{
    vec4 renderpositiontoviewtexture;
    vec4 chromaticaberrationvignette;
    vec4 hdrbloomcolorfilter;
    vec4 colorcorrection;
    vec4 tonemapparms;
    vec4 vignettecolor;
    vec4 powerupscreen;
    vec4 poweruppulsemotion;
    vec4 powerupattenuation;
    vec4 screenoverlayparms2;
    vec4 screenoverlaytint2;
    vec4 screenoverlayparms1;
    vec4 screenoverlaytint1;
    vec4 demonvisionenable;
    vec4 gbfvision;
    vec4 gbfoutlinefade;
    vec4 gbfvisioncenter;
    vec4 gbfvisionpingrange;
    vec4 gbffade;
    vec4 gbfvisionpingtilerate;
    vec4 augmentvision;
    vec4 eminterference;
    vec4 doublevision;
    vec4 desaturate;
    vec4 fadecolor;
    vec4 colorcorrectionrange;
    vec4 colorcorrectionsaturation;
    vec4 colorcorrectiongamma;
    vec4 colorcorrectionhighlightscale;
    vec4 colorcorrectionmidtonescale;
    vec4 colorcorrectionshadowscale;
    vec4 colorcorrectioncurve0;
    vec4 colorcorrectioncurve1;
} freqHigh_fragmentUniforms;

layout(set = 0, binding = 3, std140) uniform freqLow_fragmentUniforms_ubo
{
    vec4 resolutionscale;
    vec4 rendermode;
    vec4 time;
    vec4 inversemvpmatrixx;
    vec4 inversemvpmatrixy;
    vec4 inversemvpmatrixz;
    vec4 inversemvpmatrixw;
} freqLow_fragmentUniforms;

layout(set = 0, binding = 4) uniform sampler2D samp_postdistortionmap;
layout(set = 0, binding = 5) uniform sampler2D samp_tex0;
layout(set = 0, binding = 6) uniform sampler2D samp_tex1;
layout(set = 0, binding = 7) uniform sampler2D samp_tex3;
layout(set = 0, binding = 8) uniform sampler2D samp_bloomdustmap;
layout(set = 0, binding = 9) uniform sampler2D samp_lensvignettingmap;
layout(set = 0, binding = 10) uniform sampler2D samp_flowvariation;
layout(set = 0, binding = 11) uniform sampler2D samp_poweruppulse;
layout(set = 0, binding = 12) uniform sampler2D samp_screenoverlaytex2;
layout(set = 0, binding = 13) uniform sampler2D samp_screenoverlaytex1;
layout(set = 0, binding = 14) uniform sampler2D samp_emdistortionmap;
layout(set = 0, binding = 15) uniform sampler2D samp_outlinesmap;
layout(set = 0, binding = 16) uniform sampler2D samp_viewdepthmap;
layout(set = 0, binding = 17) uniform sampler2D samp_cacodemoncolormap;
layout(set = 0, binding = 18) uniform sampler2D samp_cacodemondistortionmap;

layout(location = 2) in vec4 vofi_TexCoord0;
layout(location = 0) out vec4 out_FragColor0;
layout(location = 1) out vec4 out_FragColor1;

vec2 screenPosToTexcoord(vec2 pos, vec4 bias_scale)
{
    return (pos * bias_scale.zw) + bias_scale.xy;
}

vec4 tex2Dlod(sampler2D image, vec4 texcoord)
{
    return textureLod(image, texcoord.xy, texcoord.w);
}

vec4 tex2DlodClamped(sampler2D image, vec4 texcoord, vec4 scalingInfos)
{
    vec2 pixelSize = scalingInfos.zw;
    vec2 clampedTex = clamp(texcoord.xy, vec2(0.0), scalingInfos.xy - (pixelSize / vec2(2.0)));
    vec4 param = vec4(clampedTex, texcoord.zw);
    return tex2Dlod(image, param);
}

vec3 sqr(vec3 x)
{
    return x * x;
}

float saturate(float v)
{
    return clamp(v, 0.0, 1.0);
}

float SRGBlinearApprox(float value)
{
    return value * ((value * ((value * 0.305306017398834228515625) + 0.6821711063385009765625)) + 0.01252287812530994415283203125);
}

vec3 SRGBlinearApprox(vec3 sRGB)
{
    float param = sRGB.x;
    vec3 outLinear;
    outLinear.x = SRGBlinearApprox(param);
    float param_1 = sRGB.y;
    outLinear.y = SRGBlinearApprox(param_1);
    float param_2 = sRGB.z;
    outLinear.z = SRGBlinearApprox(param_2);
    return outLinear;
}

vec4 SRGBlinearApprox(vec4 sRGBA)
{
    vec3 param = sRGBA.xyz;
    vec4 outLinear = vec4(SRGBlinearApprox(param), 1.0);
    float param_1 = sRGBA.w;
    outLinear.w = SRGBlinearApprox(param_1);
    return outLinear;
}

vec3 saturate(vec3 v)
{
    return clamp(v, vec3(0.0), vec3(1.0));
}

float GetLuma(vec3 c)
{
    return dot(c, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
}

float linearSRGB(float value)
{
    if (value > 0.003130800090730190277099609375)
    {
        return (pow(value, 0.4166666567325592041015625) * 1.05499994754791259765625) - 0.054999999701976776123046875;
    }
    else
    {
        return value * 12.9200000762939453125;
    }
}

vec3 linearSRGB(vec3 inLinear)
{
    float param = inLinear.x;
    vec3 sRGB;
    sRGB.x = linearSRGB(param);
    float param_1 = inLinear.y;
    sRGB.y = linearSRGB(param_1);
    float param_2 = inLinear.z;
    sRGB.z = linearSRGB(param_2);
    return sRGB;
}

float Doom2016EvalVanillaNeutral(float sceneLinear)
{
    float c = max(sceneLinear, 0.0);
    float shoulderStrength = freqHigh_fragmentUniforms.colorcorrectioncurve0.x;
    float linearStrength = freqHigh_fragmentUniforms.colorcorrectioncurve0.y;
    float toeStrength = 0.20000000298023223876953125;
    float toeDenominator = 0.300000011920928955078125;
    float mapped = ((c * ((c * shoulderStrength) +
                    freqHigh_fragmentUniforms.colorcorrectioncurve1.x) +
                    freqHigh_fragmentUniforms.colorcorrectioncurve1.y) /
                   (c * ((c * shoulderStrength) + linearStrength) +
                    toeStrength * toeDenominator)) -
                   freqHigh_fragmentUniforms.colorcorrectioncurve0.w;
    float result = pow(max(mapped, 0.0),
                       max(freqHigh_fragmentUniforms.colorcorrectiongamma.x,
                           0.000001)) *
                   freqHigh_fragmentUniforms.colorcorrectioncurve1.z;
    return (isnan(result) || isinf(result)) ? 0.0 : max(result, 0.0);
}

vec3 Doom2016EvalVanilla(vec3 sceneLinear)
{
    return vec3(
        Doom2016EvalVanillaNeutral(sceneLinear.x),
        Doom2016EvalVanillaNeutral(sceneLinear.y),
        Doom2016EvalVanillaNeutral(sceneLinear.z));
}

vec3 Doom2016ApplyUserGrade(vec3 color)
{
    color *= max(RENODX_TONE_MAP_EXPOSURE, 0.0);
    float sourceLuminance = max(GetLuma(color), 0.0);
    float targetLuminance = sourceLuminance;
    if (RENODX_TONE_MAP_HIGHLIGHTS != 1.0)
    {
        targetLuminance = renodx::color::grade::Highlights(
            targetLuminance,
            RENODX_TONE_MAP_HIGHLIGHTS,
            0.18);
    }
    if (RENODX_TONE_MAP_SHADOWS != 1.0)
    {
        targetLuminance = renodx::color::grade::Shadows(
            targetLuminance,
            RENODX_TONE_MAP_SHADOWS,
            0.18);
    }
    if (RENODX_TONE_MAP_CONTRAST != 1.0)
    {
        targetLuminance = renodx::color::grade::ContrastSafe(
            targetLuminance,
            RENODX_TONE_MAP_CONTRAST,
            0.18);
    }
    color *= renodx::math::DivideSafe(
        targetLuminance,
        sourceLuminance,
        sourceLuminance == 0.0 ? 0.0 : 1.0);
    if (RENODX_TONE_MAP_SATURATION != 1.0)
    {
        color = renodx::color::grade::Saturation(
            color,
            RENODX_TONE_MAP_SATURATION);
    }
    return color;
}

vec3 Doom2016ResolvePsychoVReference()
{
    const float neutral = 0.18;
    float unmatchedAnchor = Doom2016ApplyUserGrade(vec3(neutral)).x;
    float referenceInput = neutral;
    float referenceOutput = Doom2016EvalVanillaNeutral(referenceInput);

    if (RENODX_PSYCHOV_EXPOSURE_MATCH >= 0.5 ||
        RENODX_PSYCHOV_VANILLA_SLOPE > 0.0)
    {
        float lowerInput = 0.0;
        float upperInput = max(max(unmatchedAnchor, neutral), 0.0001);
        float upperOutput = Doom2016EvalVanillaNeutral(upperInput);
        for (int expansion = 0;
             expansion < 8 && upperOutput < neutral;
             ++expansion)
        {
            upperInput *= 2.0;
            upperOutput = Doom2016EvalVanillaNeutral(upperInput);
        }
        for (int iteration = 0; iteration < 16; ++iteration)
        {
            float middleInput = (lowerInput + upperInput) * 0.5;
            if (Doom2016EvalVanillaNeutral(middleInput) < neutral)
            {
                lowerInput = middleInput;
            }
            else
            {
                upperInput = middleInput;
            }
        }
        referenceInput = upperInput;
        referenceOutput = Doom2016EvalVanillaNeutral(referenceInput);
    }

    float anchorInput = RENODX_PSYCHOV_EXPOSURE_MATCH >= 0.5
                            ? referenceInput
                            : max(unmatchedAnchor, 0.000001);
    float anchorOutput = RENODX_PSYCHOV_EXPOSURE_MATCH >= 0.5
                             ? referenceOutput
                             : max(unmatchedAnchor, 0.000001);
    float localSlope = 1.0;
    if (RENODX_PSYCHOV_VANILLA_SLOPE > 0.0)
    {
        float delta = max(0.005, referenceInput * 0.01);
        float lower = max(0.0, referenceInput - delta);
        float upper = referenceInput + delta;
        float derivative = (Doom2016EvalVanillaNeutral(upper) -
                            Doom2016EvalVanillaNeutral(lower)) /
                           max(upper - lower, 0.000001);
        float candidate = referenceOutput == 0.0
                              ? 1.0
                              : referenceInput * max(derivative, 0.0) /
                                    referenceOutput;
        if (!(isnan(candidate) || isinf(candidate)))
        {
            localSlope = max(candidate, 0.0);
        }
    }
    return vec3(anchorInput, anchorOutput, localSlope);
}

vec3 Doom2016BoundBt2020(vec3 signedBt709, float peakRelative)
{
    vec3 bt2020 = renodx::color::bt2020::from::BT709(
        renodx::math::ZeroNaN(signedBt709));
    bt2020 = max(bt2020, vec3(0.0));
    float safePeak = max(peakRelative, 0.000001);
    // Keep non-finite stress inputs bounded without imposing a channel-wise
    // clamp at the visible peak. The latter produced a flat PsychoV ceiling
    // and hue shifts in saturated emissives.
    bt2020 = min(bt2020, vec3(safePeak * 65536.0));
    return bt2020;
}

vec3 Doom2016ApplyHighlightSaturation(vec3 bt709, float peakRelative)
{
    if (RENODX_TONE_MAP_HIGHLIGHT_SATURATION == 1.0)
    {
        return bt709;
    }
    float luminance = max(GetLuma(bt709), 0.0);
    float weight = smoothstep(
        1.0,
        max(peakRelative, 1.000001),
        luminance);
    vec3 adjusted = renodx::color::grade::Saturation(
        bt709,
        RENODX_TONE_MAP_HIGHLIGHT_SATURATION);
    return mix(bt709, adjusted, vec3(weight));
}

vec3 Doom2016ToneMapScene(vec3 linearHDR)
{
    float peakRelative = max(
        RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0),
        1.0);

#if DOOM2016_TONEMAP_VARIANT == 0
    vec3 displayBt709 = Doom2016EvalVanilla(
        max(Doom2016ApplyUserGrade(linearHDR), vec3(0.0)));
    displayBt709 = Doom2016ApplyHighlightSaturation(
        displayBt709,
        peakRelative);
    return max(displayBt709, vec3(0.0)) *
           (RENODX_DIFFUSE_WHITE_NITS / 100.0);
#elif DOOM2016_TONEMAP_VARIANT >= 1 && DOOM2016_TONEMAP_VARIANT <= 5
    vec3 vanillaReference = Doom2016ResolvePsychoVReference();
    float coneResponse = max(RENODX_PSYCHOV_CONE_RESPONSE, 0.0) *
                         mix(
                             1.0,
                             vanillaReference.z,
                             clamp(RENODX_PSYCHOV_VANILLA_SLOPE, 0.0, 1.0));
    vec3 displayBt709;
#if DOOM2016_TONEMAP_VARIANT == 1
    displayBt709 = renodx::tonemap::psychov::psychotm_test17(
        linearHDR, peakRelative,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        1.0, 100.0, 1.0, 1.0, 0,
        coneResponse,
        vec3(vanillaReference.x),
        vec3(vanillaReference.y),
        1.0, 1, 1.0);
#elif DOOM2016_TONEMAP_VARIANT == 2
    displayBt709 = renodx::tonemap::psychov::psychotm_test22(
        linearHDR, peakRelative,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        1.0, 100.0, 1.0, 1.0, 0,
        coneResponse,
        vec3(vanillaReference.x),
        vec3(vanillaReference.y),
        1.0, 1, 1.0, 1.0);
#elif DOOM2016_TONEMAP_VARIANT == 3
    displayBt709 = renodx::tonemap::psychov::psychotm_test24(
        linearHDR, peakRelative,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        1.0, 100.0, 1.0, 1.0, 0,
        coneResponse,
        vec3(vanillaReference.x),
        vec3(vanillaReference.y),
        1.0, 1, 1.0, 1.0,
        RENODX_TONE_MAP_HIGHLIGHT_SATURATION,
        0.0);
#elif DOOM2016_TONEMAP_VARIANT == 4
    displayBt709 = renodx::tonemap::psychov::psychotm_test25(
        linearHDR, peakRelative,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        1.0, 100.0, 1.0, 1.0, 0,
        coneResponse,
        vec3(vanillaReference.x),
        vec3(vanillaReference.y),
        1.0, 1, 1.0, 0.0);
#elif DOOM2016_TONEMAP_VARIANT == 5
    // The supplied PsychoV-30 source defines 0 as its auto-compression
    // sentinel. Keep this argument explicit so later API changes cannot turn
    // the selected behavior into a different manual response.
    displayBt709 = renodx::tonemap::psychov::psychotm_test30(
        linearHDR, peakRelative,
        RENODX_TONE_MAP_EXPOSURE,
        RENODX_TONE_MAP_HIGHLIGHTS,
        RENODX_TONE_MAP_SHADOWS,
        RENODX_TONE_MAP_CONTRAST,
        RENODX_TONE_MAP_SATURATION,
        1.0, 100.0, 1.0, 1.0, 0,
        coneResponse,
        vec3(vanillaReference.x),
        vec3(vanillaReference.y),
        1.0, 1, 1.0,
        0.0);
#endif
    displayBt709 = Doom2016ApplyHighlightSaturation(
        displayBt709,
        peakRelative);
    return Doom2016BoundBt2020(displayBt709, peakRelative) *
           (RENODX_DIFFUSE_WHITE_NITS / 100.0);
#elif DOOM2016_TONEMAP_VARIANT == 6
    renodx::tonemap::renodrt::Config config =
        renodx::tonemap::renodrt::config::Create();
    config.nits_peak = RENODX_PEAK_WHITE_NITS;
    config.mid_gray_value = 0.18;
    config.mid_gray_nits = 0.18 * RENODX_DIFFUSE_WHITE_NITS;
    config.exposure = RENODX_TONE_MAP_EXPOSURE;
    config.highlights = RENODX_TONE_MAP_HIGHLIGHTS;
    config.shadows = RENODX_TONE_MAP_SHADOWS;
    config.contrast = RENODX_TONE_MAP_CONTRAST;
    config.saturation = RENODX_TONE_MAP_SATURATION;
    config.dechroma = 0.0;
    config.blowout = -(RENODX_TONE_MAP_HIGHLIGHT_SATURATION - 1.0);
    config.flare = 0.0;
    config.hue_correction_strength = 1.0;
    config.tone_map_method =
        renodx::tonemap::renodrt::config::tone_map_method::DANIELE;
    config.working_color_space =
        renodx::color::convert::COLOR_SPACE_BT709;
    config.clamp_color_space =
        renodx::color::convert::COLOR_SPACE_BT2020;
    config.clamp_peak =
        renodx::color::convert::COLOR_SPACE_BT2020;
    config.scaling_method =
        renodx::tonemap::renodrt::config::scaling_method::LUMINANCE;
    return max(
        renodx::tonemap::renodrt::BT709(linearHDR, config),
        vec3(0.0));
#endif
}

void main()
{
    float autoExposure = vofi_TexCoord0.x;
    vec2 param = gl_FragCoord.xy;
    vec4 param_1 = freqHigh_fragmentUniforms.renderpositiontoviewtexture;
    vec2 texcoord = screenPosToTexcoord(param, param_1);
    vec2 unscaledTexcoord = texcoord / freqLow_fragmentUniforms.resolutionscale.xy;
    vec4 param_2 = vec4(unscaledTexcoord, 0.0, 0.0);
    vec2 distortion = tex2Dlod(samp_postdistortionmap, param_2).xy - vec2(0.4980392158031463623046875);
    texcoord += (distortion * 0.100000001490116119384765625);
    vec2 texcoordD = unscaledTexcoord - vec2(0.5);
    float directionLen = length(texcoordD);
    texcoordD *= (freqLow_fragmentUniforms.resolutionscale.xy * ((freqHigh_fragmentUniforms.chromaticaberrationvignette.x * pow(directionLen, freqHigh_fragmentUniforms.chromaticaberrationvignette.y)) / directionLen));
    vec2 texcoordR2 = texcoord - texcoordD;
    vec2 texcoordR = texcoord - (texcoordD * 0.5);
    vec2 texcoordG = texcoord;
    vec2 texcoordB = texcoord + (texcoordD * 0.5);
    vec2 texcoordB2 = texcoord + texcoordD;
    vec4 resScalingInfo = vec4(freqLow_fragmentUniforms.resolutionscale.xy, freqHigh_fragmentUniforms.renderpositiontoviewtexture.zw);
    vec4 param_3 = vec4(texcoordR2, 0.0, 0.0);
    vec4 param_4 = resScalingInfo;
    vec4 param_5 = vec4(texcoordR, 0.0, 0.0);
    vec4 param_6 = resScalingInfo;
    vec4 param_7 = vec4(texcoordG, 0.0, 0.0);
    vec4 param_8 = resScalingInfo;
    vec4 param_9 = vec4(texcoordB, 0.0, 0.0);
    vec4 param_10 = resScalingInfo;
    vec4 param_11 = vec4(texcoordB2, 0.0, 0.0);
    vec4 param_12 = resScalingInfo;
    vec3 linearHDR = ((((vec3(0.5, 0.0, 0.0) * tex2DlodClamped(samp_tex0, param_3, param_4).xyz) + (vec3(0.300000011920928955078125, 0.25, 0.0) * tex2DlodClamped(samp_tex0, param_5, param_6).xyz)) + (vec3(0.20000000298023223876953125, 0.5, 0.20000000298023223876953125) * tex2DlodClamped(samp_tex0, param_7, param_8).xyz)) + (vec3(0.0, 0.25, 0.300000011920928955078125) * tex2DlodClamped(samp_tex0, param_9, param_10).xyz)) + (vec3(0.0, 0.0, 0.5) * tex2DlodClamped(samp_tex0, param_11, param_12).xyz);
    vec4 param_13 = vec4(unscaledTexcoord, 0.0, 0.0);
    vec3 bloom = tex2Dlod(samp_tex1, param_13).xyz * freqHigh_fragmentUniforms.hdrbloomcolorfilter.xyz;
    vec4 param_14 = vec4(texcoord, 0.0, 0.0);
    vec3 flares = tex2Dlod(samp_tex3, param_14).xyz * freqHigh_fragmentUniforms.colorcorrection.z;
    float vignetting = 1.0 - ((pow(directionLen, freqHigh_fragmentUniforms.chromaticaberrationvignette.w) / directionLen) * freqHigh_fragmentUniforms.chromaticaberrationvignette.z);
    vec4 param_15 = vec4(((texcoord / freqLow_fragmentUniforms.resolutionscale.xy) * 1.39999997615814208984375) * vec2(1.0, freqHigh_fragmentUniforms.tonemapparms.z), 0.0, 0.0);
    vec3 lensDirt = tex2Dlod(samp_bloomdustmap, param_15).xyz;
    if (freqLow_fragmentUniforms.rendermode.x == 2.0)
    {
        vec4 l1_ck = vec4(0.0341422520577907562255859375, 0.0590788163244724273681640625, 0.07175086438655853271484375, 0.89999997615814208984375);
        vec4 l2_ck = vec4(0.0498269908130168914794921875, 0.094585157930850982666015625, 0.09766089916229248046875, 0.85000002384185791015625);
        vec2 tc1 = ((unscaledTexcoord - vec2(0.5)) * (-0.100000001490116119384765625)) + vec2(0.5);
        vec2 tc2 = ((unscaledTexcoord - vec2(0.5)) * (-0.300000011920928955078125)) + vec2(0.5);
        vec4 param_16 = vec4(((unscaledTexcoord - vec2(0.5)) * 0.800000011920928955078125) + vec2(0.5), 0.0, 0.0);
        vec3 param_17 = tex2Dlod(samp_lensvignettingmap, param_16).xyz;
        vec3 lensVignetting = sqr(param_17);
        vec4 param_18 = vec4(((unscaledTexcoord - vec2(0.5)) * 0.800000011920928955078125) + vec2(0.5), 0.0, 3.0);
        vec3 param_19 = tex2Dlod(samp_lensvignettingmap, param_18).xyz;
        lensVignetting = sqr(param_19) * (vec3(1.0) - lensVignetting);
        vec4 param_20 = vec4(tc1, 0.0, 0.0);
        vec4 param_21 = vec4(tc1, 0.0, 0.0);
        vec3 lensRefl = ((lensVignetting * mix(tex2Dlod(samp_tex0, param_20).xyz, tex2Dlod(samp_tex1, param_21).xyz, l1_ck.www)) * l1_ck.xyz) * 0.75;
        vec4 param_22 = vec4(tc2, 0.0, 0.0);
        vec4 param_23 = vec4(tc2, 0.0, 0.0);
        lensRefl += (((lensVignetting * mix(tex2Dlod(samp_tex0, param_22).xyz, tex2Dlod(samp_tex1, param_23).xyz, l2_ck.www)) * l2_ck.xyz) * 0.75);
        bloom += ((lensRefl * freqHigh_fragmentUniforms.hdrbloomcolorfilter.xyz) * freqHigh_fragmentUniforms.colorcorrection.z);
    }
    linearHDR += (flares + ((flares + (bloom * lensDirt)) * freqHigh_fragmentUniforms.tonemapparms.w));
    linearHDR = ((linearHDR * freqHigh_fragmentUniforms.tonemapparms.x) + (bloom * freqHigh_fragmentUniforms.tonemapparms.y)) * autoExposure;
    vec3 _604;
    if (freqLow_fragmentUniforms.rendermode.x == 0.0)
    {
        _604 = mix(linearHDR, freqHigh_fragmentUniforms.vignettecolor.xyz, vec3(1.0 - vignetting));
    }
    else
    {
        _604 = linearHDR * vignetting;
    }
    linearHDR = _604;
    uvec2 idxPix = uvec2(gl_FragCoord.xy) & uvec2(3u);
    uvec2 bayerMat = uvec2(2068378560u, 1500172770u);
    float dither = float(((bayerMat[idxPix.y >> uint(1)] >> ((idxPix.x + ((idxPix.y & 1u) * 4u)) * 4u)) & 15u) + 1u) / 4335.0;
    vec2 unscaledTC = texcoord / freqLow_fragmentUniforms.resolutionscale.xy;
    if (freqHigh_fragmentUniforms.powerupscreen.w != 0.0)
    {
        float pulse = (sin(freqLow_fragmentUniforms.time.x * 5.0) * 0.100000001490116119384765625) + 0.89999997615814208984375;
        float mask = ((unscaledTC.x * (1.0 - unscaledTC.x)) * unscaledTC.y) * (1.0 - unscaledTC.y);
        float param_24 = 1.0 - mask;
        mask = saturate(param_24);
        mask = pow(mask, 20.0);
        mask = 1.0 - mask;
        vec4 param_25 = vec4((unscaledTexcoord * vec2(freqHigh_fragmentUniforms.poweruppulsemotion.x, freqHigh_fragmentUniforms.poweruppulsemotion.y)) + vec2(freqLow_fragmentUniforms.time.x * freqHigh_fragmentUniforms.poweruppulsemotion.z, freqLow_fragmentUniforms.time.x * freqHigh_fragmentUniforms.poweruppulsemotion.w), 0.0, 0.0);
        vec4 flowMap = tex2Dlod(samp_flowvariation, param_25);
        vec2 _733 = (flowMap.xy * 2.0) - vec2(1.0);
        flowMap = vec4(_733.x, _733.y, flowMap.z, flowMap.w);
        vec2 uvFlowDirection = vec2(flowMap.x * 0.25, flowMap.y * 0.550000011920928955078125);
        flowMap = vec4(unscaledTC, unscaledTC) + vec4(uvFlowDirection, uvFlowDirection);
        vec2 _765 = mix(unscaledTC, flowMap.xy, vec2(mask));
        flowMap = vec4(_765.x, _765.y, flowMap.z, flowMap.w);
        vec4 param_26 = vec4(flowMap.xy, 0.0, 0.0);
        vec4 powerUpPulse = tex2Dlod(samp_poweruppulse, param_26);
        vec4 param_27 = vec4(unscaledTC, 0.0, 0.0);
        vec4 powerUpPulseStatic = tex2Dlod(samp_poweruppulse, param_27);
        vec4 param_28 = powerUpPulseStatic;
        powerUpPulseStatic = SRGBlinearApprox(param_28);
        vec4 param_29 = powerUpPulse;
        powerUpPulse = SRGBlinearApprox(param_29);
        powerUpPulse = mix(powerUpPulse, pow(powerUpPulse, vec4(5.0)), vec4(freqHigh_fragmentUniforms.powerupattenuation.x));
        vec3 _803 = powerUpPulse.xyz * powerUpPulseStatic.xyz;
        powerUpPulse = vec4(_803.x, _803.y, _803.z, powerUpPulse.w);
        vec3 inColor = linearHDR;
        linearHDR = mix(linearHDR, linearHDR + ((powerUpPulse.xyz * freqHigh_fragmentUniforms.powerupscreen.xyz) * pulse), vec3(powerUpPulse.w));
        linearHDR = mix(inColor, linearHDR, vec3(freqHigh_fragmentUniforms.powerupscreen.w));
    }
    float overlayWeight = freqHigh_fragmentUniforms.screenoverlayparms2.z;
    if (overlayWeight > 0.0)
    {
        bool bottomOnly = freqHigh_fragmentUniforms.screenoverlayparms2.w > 0.0;
        vec2 dimensions = vec2(freqHigh_fragmentUniforms.screenoverlayparms2.x, freqHigh_fragmentUniforms.screenoverlayparms2.y);
        bvec2 mirrorTiles = bvec2(dimensions.x >= 0.0, dimensions.y >= 0.0);
        dimensions = abs(dimensions);
        bvec2 tiled = bvec2(dimensions.x <= 0.5, dimensions.y <= 0.5);
        dimensions = min(dimensions, vec2(0.5));
        if (abs(0.5 - unscaledTC.x) >= (0.5 - dimensions.x))
        {
            bool _887 = abs(0.5 - unscaledTC.y) >= (0.5 - dimensions.y);
            bool _899;
            if (_887)
            {
                bool _891 = !bottomOnly;
                bool _898;
                if (!_891)
                {
                    _898 = unscaledTC.y <= 0.5;
                }
                else
                {
                    _898 = _891;
                }
                _899 = _898;
            }
            else
            {
                _899 = _887;
            }
            if (_899)
            {
                vec2 overlayTexcoord = unscaledTC;
                if (tiled.x)
                {
                    float _908;
                    if (unscaledTC.x <= 0.5)
                    {
                        _908 = unscaledTC.x / dimensions.x;
                    }
                    else
                    {
                        _908 = ((unscaledTC.x + dimensions.x) - 1.0) / dimensions.x;
                    }
                    overlayTexcoord.x = _908;
                    if (mirrorTiles.x)
                    {
                        float _935;
                        if (unscaledTC.x <= 0.5)
                        {
                            _935 = overlayTexcoord.x;
                        }
                        else
                        {
                            _935 = 1.0 - overlayTexcoord.x;
                        }
                        overlayTexcoord.x = _935;
                    }
                }
                if (tiled.y)
                {
                    float _953;
                    if (unscaledTC.y <= 0.5)
                    {
                        _953 = unscaledTC.y / dimensions.y;
                    }
                    else
                    {
                        _953 = ((unscaledTC.y + dimensions.y) - 1.0) / dimensions.y;
                    }
                    overlayTexcoord.y = _953;
                    if (mirrorTiles.y)
                    {
                        float _980;
                        if (unscaledTC.y <= 0.5)
                        {
                            _980 = overlayTexcoord.y;
                        }
                        else
                        {
                            _980 = 1.0 - overlayTexcoord.y;
                        }
                        overlayTexcoord.y = _980;
                    }
                }
                vec4 param_30 = vec4(overlayTexcoord, 0.0, 0.0);
                vec4 overlayColor = tex2Dlod(samp_screenoverlaytex2, param_30);
                overlayColor *= freqHigh_fragmentUniforms.screenoverlaytint2;
                linearHDR = mix(linearHDR, overlayColor.xyz, vec3(overlayColor.w * overlayWeight));
            }
        }
    }
    float overlayWeight_1 = freqHigh_fragmentUniforms.screenoverlayparms1.z;
    if (overlayWeight_1 > 0.0)
    {
        bool bottomOnly_1 = freqHigh_fragmentUniforms.screenoverlayparms1.w > 0.0;
        vec2 dimensions_1 = vec2(freqHigh_fragmentUniforms.screenoverlayparms1.x, freqHigh_fragmentUniforms.screenoverlayparms1.y);
        bvec2 mirrorTiles_1 = bvec2(dimensions_1.x >= 0.0, dimensions_1.y >= 0.0);
        dimensions_1 = abs(dimensions_1);
        bvec2 tiled_1 = bvec2(dimensions_1.x <= 0.5, dimensions_1.y <= 0.5);
        dimensions_1 = min(dimensions_1, vec2(0.5));
        if (abs(0.5 - unscaledTC.x) >= (0.5 - dimensions_1.x))
        {
            bool _1071 = abs(0.5 - unscaledTC.y) >= (0.5 - dimensions_1.y);
            bool _1083;
            if (_1071)
            {
                bool _1075 = !bottomOnly_1;
                bool _1082;
                if (!_1075)
                {
                    _1082 = unscaledTC.y <= 0.5;
                }
                else
                {
                    _1082 = _1075;
                }
                _1083 = _1082;
            }
            else
            {
                _1083 = _1071;
            }
            if (_1083)
            {
                vec2 overlayTexcoord_1 = unscaledTC;
                if (tiled_1.x)
                {
                    float _1092;
                    if (unscaledTC.x <= 0.5)
                    {
                        _1092 = unscaledTC.x / dimensions_1.x;
                    }
                    else
                    {
                        _1092 = ((unscaledTC.x + dimensions_1.x) - 1.0) / dimensions_1.x;
                    }
                    overlayTexcoord_1.x = _1092;
                    if (mirrorTiles_1.x)
                    {
                        float _1119;
                        if (unscaledTC.x <= 0.5)
                        {
                            _1119 = overlayTexcoord_1.x;
                        }
                        else
                        {
                            _1119 = 1.0 - overlayTexcoord_1.x;
                        }
                        overlayTexcoord_1.x = _1119;
                    }
                }
                if (tiled_1.y)
                {
                    float _1137;
                    if (unscaledTC.y <= 0.5)
                    {
                        _1137 = unscaledTC.y / dimensions_1.y;
                    }
                    else
                    {
                        _1137 = ((unscaledTC.y + dimensions_1.y) - 1.0) / dimensions_1.y;
                    }
                    overlayTexcoord_1.y = _1137;
                    if (mirrorTiles_1.y)
                    {
                        float _1164;
                        if (unscaledTC.y <= 0.5)
                        {
                            _1164 = overlayTexcoord_1.y;
                        }
                        else
                        {
                            _1164 = 1.0 - overlayTexcoord_1.y;
                        }
                        overlayTexcoord_1.y = _1164;
                    }
                }
                vec4 param_31 = vec4(overlayTexcoord_1, 0.0, 0.0);
                vec4 overlayColor_1 = tex2Dlod(samp_screenoverlaytex1, param_31);
                overlayColor_1 *= freqHigh_fragmentUniforms.screenoverlaytint1;
                linearHDR = mix(linearHDR, overlayColor_1.xyz, vec3(overlayColor_1.w * overlayWeight_1));
            }
        }
    }
    if (freqHigh_fragmentUniforms.demonvisionenable.x > 0.0)
    {
        vec4 param_32 = vec4((texcoord * vec2(0.5, 100.0)) + (floor(vec2(freqLow_fragmentUniforms.time.x * 15.0, freqLow_fragmentUniforms.time.x * 20.0)) * 0.300000011920928955078125), 0.0, 0.0);
        vec4 scanlineTex = tex2Dlod(samp_emdistortionmap, param_32);
        float colorBlend = (linearHDR.x + (0.33329999446868896484375 * linearHDR.y)) + (0.6665999889373779296875 * linearHDR.z);
        float param_33 = (freqHigh_fragmentUniforms.demonvisionenable.y * 0.5) * (1.0 - colorBlend);
        linearHDR = mix(linearHDR, mix(vec3(colorBlend), vec3(colorBlend) * vec3(0.300000011920928955078125, 0.60000002384185791015625, 0.0), vec3(scanlineTex.x)), vec3(saturate(param_33)));
        if (freqHigh_fragmentUniforms.demonvisionenable.x >= 2.0)
        {
            vec4 param_34 = vec4(unscaledTC, 0.0, 0.0);
            vec4 outlineTex = tex2Dlod(samp_outlinesmap, param_34);
            float param_35 = dot(outlineTex.xyz, vec3(1.0));
            float mask_1 = saturate(param_35);
            linearHDR = mix(linearHDR, outlineTex.xyz, vec3(mask_1));
        }
    }
    bool _1292 = freqHigh_fragmentUniforms.gbfvision.x == 1.0;
    bool _1298;
    if (_1292)
    {
        _1298 = freqHigh_fragmentUniforms.demonvisionenable.x == 0.0;
    }
    else
    {
        _1298 = _1292;
    }
    if (_1298)
    {
        float grayscale = ((0.20999999344348907470703125 * linearHDR.x) + (0.7200000286102294921875 * linearHDR.y)) + (0.070000000298023223876953125 * linearHDR.z);
        vec4 param_36 = vec4(unscaledTC, 0.0, 0.0);
        vec4 outlineTex_1 = tex2Dlod(samp_outlinesmap, param_36);
        vec3 infraRedWorld = vec3(grayscale);
        vec3 playerInitialOutline = vec3(outlineTex_1.x * 0.62000000476837158203125, 0.00999999977648258209228515625, 0.0);
        vec3 demonInitialOutline = vec3(outlineTex_1.y * 0.62000000476837158203125, 0.12999999523162841796875, 0.0);
        vec3 initialOutline = mix(playerInitialOutline, demonInitialOutline, vec3(outlineTex_1.y));
        vec3 outlines = mix(vec3(0.0), initialOutline * (linearHDR.x * 60.5), vec3(freqHigh_fragmentUniforms.gbfoutlinefade.x));
        float gridPowerValue = 30.0;
        float gridSinScalar = 0.3333333432674407958984375;
        float gridNearFade = 600.0;
        float gridDistanceFadeValue = 1000.0;
        vec3 baseGridColor = vec3(1.0, 0.319999992847442626953125, 0.0);
        vec2 param_37 = gl_FragCoord.xy;
        vec4 param_38 = freqHigh_fragmentUniforms.renderpositiontoviewtexture;
        vec2 texcoordGrid = screenPosToTexcoord(param_37, param_38);
        vec2 scaledTCGrid = vec2(texcoordGrid.x / freqLow_fragmentUniforms.resolutionscale.x, texcoordGrid.y / freqLow_fragmentUniforms.resolutionscale.y);
        vec4 param_39 = vec4(scaledTCGrid, 0.0, 0.0);
        float ndcZ = tex2Dlod(samp_viewdepthmap, param_39).x;
        vec4 device = vec4((scaledTCGrid.x * 2.0) - 1.0, (scaledTCGrid.y * 2.0) - 1.0, ndcZ, 1.0);
        vec4 globalPos;
        globalPos.x = dot(device, freqLow_fragmentUniforms.inversemvpmatrixx);
        globalPos.y = dot(device, freqLow_fragmentUniforms.inversemvpmatrixy);
        globalPos.z = dot(device, freqLow_fragmentUniforms.inversemvpmatrixz);
        globalPos.w = dot(device, freqLow_fragmentUniforms.inversemvpmatrixw);
        globalPos /= vec4(globalPos.w);
        float _distance = length(globalPos.xyz - freqHigh_fragmentUniforms.gbfvisioncenter.xyz);
        float maxPingRange = freqHigh_fragmentUniforms.gbfvisionpingrange.x;
        float minPingRange = max(0.0, freqHigh_fragmentUniforms.gbfvisionpingrange.x - freqHigh_fragmentUniforms.gbfvisionpingrange.y);
        float maxVisionDistance = freqHigh_fragmentUniforms.gbfvisionpingrange.z;
        float pingPowerExponent = freqHigh_fragmentUniforms.gbfvisionpingrange.w;
        vec3 param_40 = pow(sin(globalPos.xyz * gridSinScalar), vec3(gridPowerValue, gridPowerValue, gridPowerValue));
        vec3 grid = saturate(param_40);
        float gridVal = max(max(grid.x, grid.y), grid.z);
        float _1484;
        if (_distance < gridNearFade)
        {
            _1484 = (gridVal * _distance) / gridNearFade;
        }
        else
        {
            _1484 = gridVal;
        }
        gridVal = _1484;
        float param_41 = (gridDistanceFadeValue * gridDistanceFadeValue) / (_distance * _distance);
        float distanceFade = saturate(param_41);
        gridVal = mix(0.100000001490116119384765625, gridVal, distanceFade);
        float scalarAlongPing = (_distance - minPingRange) / (maxPingRange - minPingRange);
        float _1520;
        if (scalarAlongPing > 1.0)
        {
            _1520 = 0.0;
        }
        else
        {
            _1520 = scalarAlongPing;
        }
        float param_42 = _1520;
        float pingScalar = saturate(param_42);
        pingScalar = pow(pingScalar, pingPowerExponent);
        pingScalar *= freqHigh_fragmentUniforms.gbfoutlinefade.x;
        float scalarOfMaxDistance = _distance / maxVisionDistance;
        float param_43 = (scalarOfMaxDistance - 1.0) * 10.0;
        float maxDistanceFalloffScalar = 1.0 - saturate(param_43);
        float param_44 = pingScalar * maxDistanceFalloffScalar;
        pingScalar = saturate(param_44);
        vec3 gridColor = mix(linearHDR, baseGridColor, vec3(gridVal));
        float param_45 = outlines.x * 2.0;
        vec3 outlinedColor = mix(linearHDR, mix(infraRedWorld, outlines, vec3(saturate(param_45))), vec3(freqHigh_fragmentUniforms.gbffade.x));
        linearHDR = mix(outlinedColor, gridColor, vec3(pingScalar));
    }
    bool _1583 = freqHigh_fragmentUniforms.gbfvision.x == 1.0;
    bool _1589;
    if (_1583)
    {
        _1589 = freqHigh_fragmentUniforms.demonvisionenable.x == 1.0;
    }
    else
    {
        _1589 = _1583;
    }
    if (_1589)
    {
        vec4 param_46 = vec4(unscaledTC, 0.0, 0.0);
        vec4 outlineTex_2 = tex2Dlod(samp_outlinesmap, param_46);
        vec3 playerInitialOutline_1 = vec3(outlineTex_2.x * 0.62000000476837158203125, 0.00999999977648258209228515625, 0.62000000476837158203125);
        vec3 playerTargetedInitialOutline = vec3(0.62000000476837158203125, 0.02999999932944774627685546875, 0.0);
        vec3 initialOutline_1 = mix(playerInitialOutline_1, playerTargetedInitialOutline, vec3(outlineTex_2.y));
        vec3 outlines_1 = mix(vec3(0.0), initialOutline_1 * (linearHDR.x * 60.5), vec3(freqHigh_fragmentUniforms.gbfoutlinefade.x));
        vec2 param_47 = gl_FragCoord.xy;
        vec4 param_48 = freqHigh_fragmentUniforms.renderpositiontoviewtexture;
        vec2 texcoordGrid_1 = screenPosToTexcoord(param_47, param_48);
        vec2 scaledTCGrid_1 = vec2(texcoordGrid_1.x / freqLow_fragmentUniforms.resolutionscale.x, texcoordGrid_1.y / freqLow_fragmentUniforms.resolutionscale.y);
        vec4 param_49 = vec4(scaledTCGrid_1, 0.0, 0.0);
        float ndcZ_1 = tex2Dlod(samp_viewdepthmap, param_49).x;
        vec4 device_1 = vec4((scaledTCGrid_1.x * 2.0) - 1.0, (scaledTCGrid_1.y * 2.0) - 1.0, ndcZ_1, 1.0);
        vec4 globalPos_1;
        globalPos_1.x = dot(device_1, freqLow_fragmentUniforms.inversemvpmatrixx);
        globalPos_1.y = dot(device_1, freqLow_fragmentUniforms.inversemvpmatrixy);
        globalPos_1.z = dot(device_1, freqLow_fragmentUniforms.inversemvpmatrixz);
        globalPos_1.w = dot(device_1, freqLow_fragmentUniforms.inversemvpmatrixw);
        globalPos_1 /= vec4(globalPos_1.w);
        float _distance_1 = length(globalPos_1.xyz - freqHigh_fragmentUniforms.gbfvisioncenter.xyz);
        float maxPingRange_1 = freqHigh_fragmentUniforms.gbfvisionpingrange.x;
        float minPingRange_1 = freqHigh_fragmentUniforms.gbfvisionpingrange.x - freqHigh_fragmentUniforms.gbfvisionpingrange.y;
        float maxVisionDistance_1 = freqHigh_fragmentUniforms.gbfvisionpingrange.z;
        float maxDistance = min(maxPingRange_1, maxVisionDistance_1);
        float waveNearFade = 600.0;
        float waveMinDist = 50.0;
        float _1717;
        if ((_distance_1 > maxDistance) || (_distance_1 <= minPingRange_1))
        {
            _1717 = 0.0;
        }
        else
        {
            _1717 = 1.0;
        }
        float waveVal = _1717;
        float _1732;
        if (_distance_1 < (waveNearFade + waveMinDist))
        {
            _1732 = waveVal * ((_distance_1 - waveMinDist) / waveNearFade);
        }
        else
        {
            _1732 = waveVal;
        }
        waveVal = step(waveMinDist, _distance_1) * _1732;
        float param_50 = (_distance_1 - minPingRange_1) / (maxPingRange_1 - minPingRange_1);
        float waveDepth = 1.0 - saturate(param_50);
        vec4 param_51 = vec4(waveDepth, 0.0, 0.0, 0.0);
        vec4 waveColor = tex2Dlod(samp_cacodemoncolormap, param_51);
        vec2 direction = globalPos_1.xy - freqHigh_fragmentUniforms.gbfvisioncenter.xy;
        float radial = atan(direction.x, direction.y) / 3.141592502593994140625;
        float depthNoiseLookup = mod((_distance_1 - (maxPingRange_1 / 4.0)) / freqHigh_fragmentUniforms.gbfvisionpingtilerate.x, 1.0);
        float heightNoiseLookup = mod(globalPos_1.z / freqHigh_fragmentUniforms.gbfvisionpingtilerate.y, 1.0);
        vec4 param_52 = vec4(radial, depthNoiseLookup, 0.0, 0.0);
        float depthNoise = tex2Dlod(samp_cacodemondistortionmap, param_52).x;
        vec4 param_53 = vec4(radial, heightNoiseLookup, 0.0, 0.0);
        float heightNoise = tex2Dlod(samp_cacodemondistortionmap, param_53).y;
        float param_54 = (2.0 * (depthNoise - 0.5)) + (2.0 * (heightNoise - 0.5));
        float noiseValue = saturate(param_54);
        vec3 _1829 = waveColor.xyz * waveVal;
        waveColor = vec4(_1829.x, _1829.y, _1829.z, waveColor.w);
        float param_55 = outlines_1.x * 2.0;
        vec3 outlinedColor_1 = mix(linearHDR, outlines_1, vec3(saturate(param_55)));
        float waveScale = waveColor.w * noiseValue;
        float pingPowerExponent_1 = freqHigh_fragmentUniforms.gbfvisionpingrange.w;
        linearHDR = outlinedColor_1 + ((waveColor.xyz * waveScale) * pingPowerExponent_1);
    }
    bool _1861 = freqHigh_fragmentUniforms.augmentvision.x > 0.0;
    bool _1867;
    if (_1861)
    {
        _1867 = freqHigh_fragmentUniforms.gbfvision.x == 0.0;
    }
    else
    {
        _1867 = _1861;
    }
    bool _1873;
    if (_1867)
    {
        _1873 = freqHigh_fragmentUniforms.demonvisionenable.x == 0.0;
    }
    else
    {
        _1873 = _1867;
    }
    if (_1873)
    {
        vec4 param_56 = vec4(unscaledTC, 0.0, 0.0);
        vec4 outlineTex_3 = tex2Dlod(samp_outlinesmap, param_56);
        linearHDR += outlineTex_3.xyz;
    }
    if (freqHigh_fragmentUniforms.eminterference.x > 0.0)
    {
        vec4 param_57 = vec4((texcoord * vec2(1.2999999523162841796875)) + (floor(vec2(freqLow_fragmentUniforms.time.x * 15.0, freqLow_fragmentUniforms.time.x * 20.0)) * 0.300000011920928955078125), 0.0, 0.0);
        vec4 emiTex = tex2Dlod(samp_emdistortionmap, param_57);
        float param_58 = freqHigh_fragmentUniforms.eminterference.x;
        linearHDR = mix(linearHDR, emiTex.xyz, vec3(saturate(param_58))) * vec3(1.0, 0.20000000298023223876953125, 0.100000001490116119384765625);
    }
    if (freqHigh_fragmentUniforms.doublevision.x > 0.0)
    {
        float eyeCrossX = mix(1.0, 0.89999997615814208984375, freqHigh_fragmentUniforms.doublevision.x);
        float eyeCrossOffset = mix(0.0, 0.100000001490116119384765625, freqHigh_fragmentUniforms.doublevision.x);
        float eyeCrossOffsetR = eyeCrossOffset * 0.5;
        vec4 param_59 = vec4(((texcoord * vec2(eyeCrossX, 1.0)) + vec2(eyeCrossOffset, 0.0)) - vec2(eyeCrossOffsetR, 0.0), 0.0, 0.0);
        vec4 eyeR = tex2Dlod(samp_tex0, param_59);
        vec4 param_60 = vec4((texcoord * vec2(eyeCrossX, 1.0)) + vec2(eyeCrossOffset, 0.0), 0.0, 0.0);
        vec4 eyeL = tex2Dlod(samp_tex0, param_60);
        vec3 doubleVision = mix(eyeR.xyz, eyeL.xyz, vec3(0.5));
        linearHDR = mix(linearHDR, doubleVision, vec3(freqHigh_fragmentUniforms.doublevision.x));
    }
    if (freqHigh_fragmentUniforms.desaturate.x > 0.0)
    {
        vec3 param_61 = linearHDR;
        float desaturated = GetLuma(param_61);
        linearHDR = vec3(desaturated);
    }
    if (freqHigh_fragmentUniforms.fadecolor.w > 0.0)
    {
        linearHDR = mix(linearHDR, freqHigh_fragmentUniforms.fadecolor.xyz, vec3(freqHigh_fragmentUniforms.fadecolor.w));
    }
    vec3 param_62 = linearHDR;
    float lum = GetLuma(param_62);
    float param_63 = (lum * freqHigh_fragmentUniforms.colorcorrectionrange.x) + freqHigh_fragmentUniforms.colorcorrectionrange.y;
    float shadow2Mid = saturate(param_63);
    float param_64 = (lum * freqHigh_fragmentUniforms.colorcorrectionrange.z) + freqHigh_fragmentUniforms.colorcorrectionrange.w;
    float mid2High = saturate(param_64);
    float saturation = ((freqHigh_fragmentUniforms.colorcorrectionsaturation.z * mid2High) + (freqHigh_fragmentUniforms.colorcorrectionsaturation.y * shadow2Mid)) + freqHigh_fragmentUniforms.colorcorrectionsaturation.x;
    float gamma = ((freqHigh_fragmentUniforms.colorcorrectiongamma.z * mid2High) + (freqHigh_fragmentUniforms.colorcorrectiongamma.y * shadow2Mid)) + freqHigh_fragmentUniforms.colorcorrectiongamma.x;
    vec4 color = ((freqHigh_fragmentUniforms.colorcorrectionhighlightscale * mid2High) + (freqHigh_fragmentUniforms.colorcorrectionmidtonescale * shadow2Mid)) + freqHigh_fragmentUniforms.colorcorrectionshadowscale;
    linearHDR = mix(vec3(lum), linearHDR, vec3(saturation));
    linearHDR = (linearHDR * color.xyz) + vec3(color.w);
    vec3 outputColor = Doom2016ToneMapScene(linearHDR);
    if (freqHigh_fragmentUniforms.colorcorrection.x > 2.0)
    {
        vec3 debugSrgb = vec3(
            saturate(1.0 - shadow2Mid),
            saturate(shadow2Mid - mid2High),
            mid2High);
        outputColor = renodx::color::srgb::DecodeSafe(debugSrgb) *
                      (RENODX_DIFFUSE_WHITE_NITS / 100.0);
    }
    out_FragColor0 = vec4(outputColor.x, outputColor.y, outputColor.z, out_FragColor0.w);
    out_FragColor1 = vec4(outputColor.x, outputColor.y, outputColor.z, out_FragColor1.w);
}
