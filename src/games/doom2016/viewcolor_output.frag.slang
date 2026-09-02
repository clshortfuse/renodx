#version 450

#include "./shared.h"

float _131;
float _170;

layout(set = 0, binding = 0, std140) uniform freqHigh_fragmentUniforms_ubo
{
    vec4 positiontoviewtexture;
    vec4 gamma;
    vec4 upsampleparms;
} freqHigh_fragmentUniforms;

layout(set = 0, binding = 1, std140) uniform freqLow_fragmentUniforms_ubo
{
    vec4 resolutionscale;
    vec4 rendermode;
    vec4 randomint;
} freqLow_fragmentUniforms;

layout(set = 0, binding = 2) uniform sampler2D samp_viewcolormap;
layout(set = 0, binding = 3) uniform sampler2D samp_tex0;

layout(location = 0) out vec4 out_FragColor0;

float w0(float a)
{
    return 0.16666667163372039794921875 * ((a * ((a * ((-a) + 3.0)) - 3.0)) + 1.0);
}

float w1(float a)
{
    return 0.16666667163372039794921875 * (((a * a) * ((3.0 * a) - 6.0)) + 4.0);
}

float g0(float a)
{
    float param = a;
    float param_1 = a;
    return w0(param) + w1(param_1);
}

float w2(float a)
{
    return 0.16666667163372039794921875 * ((a * ((a * (((-3.0) * a) + 3.0)) + 3.0)) + 1.0);
}

float w3(float a)
{
    return 0.16666667163372039794921875 * ((a * a) * a);
}

float g1(float a)
{
    float param = a;
    float param_1 = a;
    return w2(param) + w3(param_1);
}

float h0(float a)
{
    float param = a;
    float param_1 = a;
    float param_2 = a;
    return (-1.0) + (w1(param) / (w0(param_1) + w1(param_2)));
}

float h1(float a)
{
    float param = a;
    float param_1 = a;
    float param_2 = a;
    return 1.0 + (w3(param) / (w2(param_1) + w3(param_2)));
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

vec4 tex2DBicubicClamped(sampler2D image, inout vec2 uv, vec2 res, vec4 scalingInfos)
{
    uv = (uv * res) + vec2(0.5);
    vec2 iuv = floor(uv);
    vec2 fuv = fract(uv);
    float param = fuv.x;
    float g0x = g0(param);
    float param_1 = fuv.x;
    float g1x = g1(param_1);
    float param_2 = fuv.x;
    float h0x = h0(param_2);
    float param_3 = fuv.x;
    float h1x = h1(param_3);
    float param_4 = fuv.y;
    float h0y = h0(param_4);
    float param_5 = fuv.y;
    float h1y = h1(param_5);
    vec2 p0 = (vec2(iuv.x + h0x, iuv.y + h0y) - vec2(0.5)) / res;
    vec2 p1 = (vec2(iuv.x + h1x, iuv.y + h0y) - vec2(0.5)) / res;
    vec2 p2 = (vec2(iuv.x + h0x, iuv.y + h1y) - vec2(0.5)) / res;
    vec2 p3 = (vec2(iuv.x + h1x, iuv.y + h1y) - vec2(0.5)) / res;
    vec4 param_6 = vec4(p0, 0.0, 0.0);
    vec4 param_7 = scalingInfos;
    vec4 t0 = tex2DlodClamped(image, param_6, param_7);
    vec4 param_8 = vec4(p1, 0.0, 0.0);
    vec4 param_9 = scalingInfos;
    vec4 t1 = tex2DlodClamped(image, param_8, param_9);
    vec4 param_10 = vec4(p2, 0.0, 0.0);
    vec4 param_11 = scalingInfos;
    vec4 t2 = tex2DlodClamped(image, param_10, param_11);
    vec4 param_12 = vec4(p3, 0.0, 0.0);
    vec4 param_13 = scalingInfos;
    vec4 t3 = tex2DlodClamped(image, param_12, param_13);
    float param_14 = fuv.y;
    float param_15 = fuv.y;
    return (((t0 * g0x) + (t1 * g1x)) * g0(param_14)) + (((t2 * g0x) + (t3 * g1x)) * g1(param_15));
}

vec3 saturate(vec3 v)
{
    return clamp(v, vec3(0.0), vec3(1.0));
}

float SRGBlinear(float value)
{
    if (value <= 0.040449999272823333740234375)
    {
        return value / 12.9200000762939453125;
    }
    else
    {
        return pow((value / 1.05499994754791259765625) + 0.0521326996386051177978515625, 2.400000095367431640625);
    }
}

vec3 SRGBlinear(vec3 sRGB)
{
    float param = sRGB.x;
    vec3 outLinear;
    outLinear.x = SRGBlinear(param);
    float param_1 = sRGB.y;
    outLinear.y = SRGBlinear(param_1);
    float param_2 = sRGB.z;
    outLinear.z = SRGBlinear(param_2);
    return outLinear;
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

float saturate(float v)
{
    return clamp(v, 0.0, 1.0);
}

vec3 MatrixMul(mat3 m, vec3 v)
{
    return m * v;
}

void main()
{
    vec2 texcoord = gl_FragCoord.xy * freqHigh_fragmentUniforms.positiontoviewtexture.zw;
    vec4 scalingInfos = vec4(freqLow_fragmentUniforms.resolutionscale.xy, vec2(vec2(1.0) / freqHigh_fragmentUniforms.positiontoviewtexture.xy));
    vec3 linearColor;
    if (freqLow_fragmentUniforms.rendermode.x < 3.0)
    {
        vec2 param = texcoord;
        vec2 param_1 = freqHigh_fragmentUniforms.positiontoviewtexture.xy;
        vec4 param_2 = scalingInfos;
        vec4 _538 = tex2DBicubicClamped(samp_viewcolormap, param, param_1, param_2);
        vec3 linearColorLowPass = _538.xyz;
        vec4 param_3 = vec4(texcoord, 0.0, 0.0);
        vec4 param_4 = scalingInfos;
        vec3 param_5 = mix(linearColorLowPass, tex2DlodClamped(samp_viewcolormap, param_3, param_4).xyz, freqLow_fragmentUniforms.resolutionscale.www);
        if (shader_injection.scene_path_active >= 0.5)
        {
            // The replacement post-process shader writes display-linear light
            // into DOOM's existing full-resolution R11G11B10_FLOAT carrier.
            linearColor = max(param_5, vec3(0.0));
        }
        else
        {
            vec3 param_6 = saturate(param_5);
            linearColor = SRGBlinear(param_6);
        }
        if (freqLow_fragmentUniforms.rendermode.x == 2.0)
        {
            bool _571 = texcoord.y < (0.0500000007450580596923828125 * freqLow_fragmentUniforms.resolutionscale.y);
            bool _582;
            if (!_571)
            {
                _582 = texcoord.y > (0.949999988079071044921875 * freqLow_fragmentUniforms.resolutionscale.y);
            }
            else
            {
                _582 = _571;
            }
            float _564;
            if (_582)
            {
                _564 = 0.0;
            }
            else
            {
                _564 = 1.0;
            }
            linearColor *= _564;
        }
    }
    else
    {
        vec2 classic_scale = vec2(320.0, 240.0);
        vec4 param_7 = vec4(floor((texcoord * classic_scale) + vec2(0.5)) / classic_scale, 0.0, 0.0);
        vec4 param_8 = scalingInfos;
        vec3 param_9 = tex2DlodClamped(samp_viewcolormap, param_7, param_8).xyz;
        if (shader_injection.scene_path_active >= 0.5)
        {
            linearColor = max(param_9, vec3(0.0));
        }
        else
        {
            linearColor = SRGBlinear(param_9);
            linearColor = floor(linearColor * 512.0) / vec3(512.0);
        }
    }
    vec4 param_10 = vec4(texcoord / freqLow_fragmentUniforms.resolutionscale.xy, 0.0, 0.0);
    vec4 guiColor = tex2Dlod(samp_tex0, param_10);
    vec3 param_11 = guiColor.xyz;
    vec3 _633 = SRGBlinear(param_11);
    guiColor = vec4(_633.x, _633.y, _633.z, guiColor.w);
    float _637;
    if (freqLow_fragmentUniforms.rendermode.x == 0.0)
    {
        _637 = 1.0;
    }
    else
    {
        _637 = 0.89999997615814208984375;
    }
    float guiSaturation = _637;
    float _647;
    if (freqLow_fragmentUniforms.rendermode.x == 0.0)
    {
        _647 = 1.0;
    }
    else
    {
        _647 = 0.89999997615814208984375;
    }
    float guiBlendScale = _647;
    vec3 param_12 = guiColor.xyz;
    vec3 _666 = mix(vec3(GetLuma(param_12)), guiColor.xyz, vec3(guiSaturation)) * guiBlendScale;
    guiColor = vec4(_666.x, _666.y, _666.z, guiColor.w);
    bool hdrOutput = shader_injection.output_mode >= 0.5;
    bool customScene = shader_injection.scene_path_active >= 0.5;
    bool bt2020Scene = customScene &&
                       shader_injection.scene_bt2020 >= 0.5;
    if (hdrOutput)
    {
        if (!bt2020Scene)
        {
            linearColor = renodx::color::bt2020::from::BT709(linearColor);
        }
        if (!customScene)
        {
            linearColor *= RENODX_DIFFUSE_WHITE_NITS / 100.0;
        }
        guiColor = vec4(
            renodx::color::bt2020::from::BT709(guiColor.xyz) *
                (RENODX_GRAPHICS_WHITE_NITS / 100.0),
            guiColor.w);
    }
    else if (customScene)
    {
        if (bt2020Scene)
        {
            linearColor = renodx::color::bt709::from::BT2020(linearColor);
        }
        linearColor *= 100.0 / max(RENODX_DIFFUSE_WHITE_NITS, 1.0);
    }
    vec3 finalColor = (linearColor * (1.0 - guiColor.w)) + guiColor.xyz;
    vec3 param_13 = finalColor;
    vec3 _682 = linearSRGB(param_13);
    out_FragColor0 = vec4(_682.x, _682.y, _682.z, out_FragColor0.w);
    if (freqHigh_fragmentUniforms.gamma.x != 1.0)
    {
        vec3 _695 = pow(out_FragColor0.xyz, freqHigh_fragmentUniforms.gamma.xxx);
        out_FragColor0 = vec4(_695.x, _695.y, _695.z, out_FragColor0.w);
    }
    if (freqHigh_fragmentUniforms.upsampleparms.w > 0.0)
    {
        vec2 grain_tc = texcoord + (vec2(ivec2(freqLow_fragmentUniforms.randomint.xy) & ivec2(1023)) / vec2(1023.0));
        float grain = (fract(sin(grain_tc.x + (grain_tc.y * 521.0)) * 493013.0) * 2.0) - 1.0;
        vec3 param_14 = out_FragColor0.xyz;
        float param_15 = 1.0 - GetLuma(param_14);
        vec3 param_16 = out_FragColor0.xyz + ((vec3(grain) * saturate(param_15)) * freqHigh_fragmentUniforms.upsampleparms.w);
        vec3 _750 = hdrOutput ? max(param_16, vec3(0.0)) : saturate(param_16);
        out_FragColor0 = vec4(_750.x, _750.y, _750.z, out_FragColor0.w);
    }
    mat3 RGBtoOpponentMat = mat3(vec3(0.2813999950885772705078125, -0.097099997103214263916015625, -0.093000002205371856689453125), vec3(0.6937999725341796875, 0.14579999446868896484375, -0.25290000438690185546875), vec3(0.063799999654293060302734375, -0.02500000037252902984619140625, 0.4665000140666961669921875));
    mat3 OpponentToRGBMat = mat3(vec3(1.1677000522613525390625, 0.901400029659271240234375, 0.7214000225067138671875), vec3(-6.431499958038330078125, 2.5969998836517333984375, 0.1256999969482421875), vec3(-0.5044000148773193359375, 0.01590000092983245849609375, 2.051700115203857421875));
    if (freqHigh_fragmentUniforms.upsampleparms.x == 1.0)
    {
        vec3 blindVisionR = vec3(0.20000000298023223876953125, 0.9900000095367431640625, -0.189999997615814208984375);
        vec3 blindVisionG = vec3(0.1599999964237213134765625, 0.790000021457672119140625, 0.039999999105930328369140625);
        vec3 blindVisionB = vec3(0.00999999977648258209228515625, -0.00999999977648258209228515625, 1.0);
        mat3 param_17 = RGBtoOpponentMat;
        vec3 param_18 = out_FragColor0.xyz;
        vec3 opponentColor = MatrixMul(param_17, param_18);
        opponentColor.x -= (opponentColor.y * 1.5);
        mat3 param_19 = OpponentToRGBMat;
        vec3 param_20 = opponentColor;
        vec3 _819 = MatrixMul(param_19, param_20);
        out_FragColor0 = vec4(_819.x, _819.y, _819.z, out_FragColor0.w);
        vec3 _834 = vec3(dot(out_FragColor0.xyz, blindVisionR), dot(out_FragColor0.xyz, blindVisionG), dot(out_FragColor0.xyz, blindVisionB));
        out_FragColor0 = vec4(_834.x, _834.y, _834.z, out_FragColor0.w);
    }
    else
    {
        if (freqHigh_fragmentUniforms.upsampleparms.x == 2.0)
        {
            vec3 blindVisionR_1 = vec3(0.430000007152557373046875, 0.7200000286102294921875, -0.1500000059604644775390625);
            vec3 blindVisionG_1 = vec3(0.3400000035762786865234375, 0.569999992847442626953125, 0.0900000035762786865234375);
            vec3 blindVisionB_1 = vec3(-0.0199999995529651641845703125, 0.02999999932944774627685546875, 1.0);
            mat3 param_21 = RGBtoOpponentMat;
            vec3 param_22 = out_FragColor0.xyz;
            vec3 opponentColor_1 = MatrixMul(param_21, param_22);
            opponentColor_1.x -= (opponentColor_1.y * 1.5);
            mat3 param_23 = OpponentToRGBMat;
            vec3 param_24 = opponentColor_1;
            vec3 _875 = MatrixMul(param_23, param_24);
            out_FragColor0 = vec4(_875.x, _875.y, _875.z, out_FragColor0.w);
            vec3 _890 = vec3(dot(out_FragColor0.xyz, blindVisionR_1), dot(out_FragColor0.xyz, blindVisionG_1), dot(out_FragColor0.xyz, blindVisionB_1));
            out_FragColor0 = vec4(_890.x, _890.y, _890.z, out_FragColor0.w);
        }
        else
        {
            if (freqHigh_fragmentUniforms.upsampleparms.x == 3.0)
            {
                vec3 blindVisionR_2 = vec3(0.9700000286102294921875, 0.10999999940395355224609375, -0.07999999821186065673828125);
                vec3 blindVisionG_2 = vec3(0.0199999995529651641845703125, 0.819999992847442626953125, 0.1599999964237213134765625);
                vec3 blindVisionB_2 = vec3(-0.0599999986588954925537109375, 0.87999999523162841796875, 0.180000007152557373046875);
                mat3 param_25 = RGBtoOpponentMat;
                vec3 param_26 = out_FragColor0.xyz;
                vec3 opponentColor_2 = MatrixMul(param_25, param_26);
                opponentColor_2.x -= (((3.0 * opponentColor_2.z) - opponentColor_2.y) * 0.25);
                mat3 param_27 = OpponentToRGBMat;
                vec3 param_28 = opponentColor_2;
                vec3 _936 = MatrixMul(param_27, param_28);
                out_FragColor0 = vec4(_936.x, _936.y, _936.z, out_FragColor0.w);
                vec3 _951 = vec3(dot(out_FragColor0.xyz, blindVisionR_2), dot(out_FragColor0.xyz, blindVisionG_2), dot(out_FragColor0.xyz, blindVisionB_2));
                out_FragColor0 = vec4(_951.x, _951.y, _951.z, out_FragColor0.w);
            }
        }
    }
    if (hdrOutput)
    {
        // The original gamma, grain and color-vision operations above work in
        // the game's encoded carrier. Decode back to display-linear BT.2020,
        // apply the final peak gate, then publish ST.2084 code values.
        vec3 displayLightBt2020 = renodx::color::srgb::DecodeSafe(
            max(out_FragColor0.xyz, vec3(0.0)));
        displayLightBt2020 = max(
            renodx::math::ZeroNaN(displayLightBt2020),
            vec3(0.0));
        float peakRelative100 = max(
            RENODX_PEAK_WHITE_NITS / 100.0,
            0.000001);
        displayLightBt2020 = min(
            displayLightBt2020,
            vec3(peakRelative100 * 65536.0));
        float channelMaximum = max(
            displayLightBt2020.x,
            max(displayLightBt2020.y, displayLightBt2020.z));
        float peakKnee = peakRelative100 * 0.9;
        if (channelMaximum > peakKnee)
        {
            float normalizedOvershoot =
                (channelMaximum - peakKnee) /
                max(peakRelative100 - peakKnee, 0.000001);
            float compressedMaximum = peakKnee +
                (peakRelative100 - peakKnee) *
                (1.0 - exp(-normalizedOvershoot));
            displayLightBt2020 *=
                compressedMaximum / channelMaximum;
        }
        out_FragColor0 = vec4(
            renodx::color::pq::EncodeSafe(displayLightBt2020, 100.0),
            1.0);
    }
    else
    {
        out_FragColor0.xyz = saturate(out_FragColor0.xyz);
        out_FragColor0.w = 1.0;
    }
}
