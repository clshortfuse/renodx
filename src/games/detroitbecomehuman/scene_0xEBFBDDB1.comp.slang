#version 450
#extension GL_EXT_samplerless_texture_functions : require
#include "shared.h"
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

struct sCB
{
    vec4 Lift;
    vec4 Gamma;
    vec4 Gain;
    vec4 Shadow;
    vec4 Midtone;
    vec4 Highlight;
    vec4 Offset;
    float LowRange;
    float HighRange;
    float Contrast;
    float Pivot;
    float Saturation;
    float Hue;
    int ColorSpace;
    float Dummy0;
};

struct POSTPROCESSING_VIEWPORT_COMPOSITING_CONSTANT_BUFFER
{
    ivec4 _viScaleNeo4k;
    vec4 _vfInvViewportSize;
    ivec4 _viViewportOffsetSize;
    ivec4 _viMireSrgb;
    vec4 _vfGrainSize;
    vec4 _vfGrainIrregularityU;
    vec4 _vfGrainIrregularityV;
    vec4 _vfGrainIntensity;
    vec4 _vfGrainBlack;
};

vec3 _2625;

layout(set = 0, binding = 53, std140) uniform dyn_CONSTANT_BUFFER_BLOCK_ColorGrading_CB_INDEX
{
    sCB ColorGrading;
} _372;

layout(set = 0, binding = 52, std140) uniform dyn_CONSTANT_BUFFER_BLOCK_0
{
    POSTPROCESSING_VIEWPORT_COMPOSITING_CONSTANT_BUFFER g_cbComposite;
} _541;

layout(set = 0, binding = 4) uniform sampler2D Noise;
layout(set = 0, binding = 1) uniform sampler2D ColorGradingLUTR;
layout(set = 0, binding = 2) uniform sampler2D ColorGradingLUTG;
layout(set = 0, binding = 3) uniform sampler2D ColorGradingLUTB;
layout(set = 0, binding = 0) uniform sampler2D Image;
layout(set = 0, binding = 16, rgba16f) uniform writeonly image2D OutputTexture;

vec3 DecodeSceneInput(vec3 color, bool encoded_srgb)
{
    if (!encoded_srgb)
    {
        return color;
    }
    const vec3 linear_segment = color * 0.077399380505084991455078125;
    const vec3 power_segment = pow(
        (color + vec3(0.054999999701976776123046875))
            * vec3(0.947867333889007568359375),
        vec3(2.400000095367431640625));
    return mix(
        linear_segment,
        power_segment,
        greaterThan(color, vec3(0.040449999272823333740234375)));
}

float SceneLuma(vec3 color)
{
    return dot(max(color, vec3(0.0)),
               vec3(0.2125999927520751953125,
                    0.715200006961822509765625,
                    0.072200000286102294921875));
}

vec3 ApplyDlaaRcas(
    ivec2 coordinate,
    vec3 center,
    bool encoded_srgb,
    float sharpening)
{
    const ivec2 maximum_coordinate =
        max(textureSize(Image, 0) - ivec2(1), ivec2(0));
    const ivec2 north_coordinate =
        clamp(coordinate + ivec2(0, -1), ivec2(0), maximum_coordinate);
    const ivec2 west_coordinate =
        clamp(coordinate + ivec2(-1, 0), ivec2(0), maximum_coordinate);
    const ivec2 east_coordinate =
        clamp(coordinate + ivec2(1, 0), ivec2(0), maximum_coordinate);
    const ivec2 south_coordinate =
        clamp(coordinate + ivec2(0, 1), ivec2(0), maximum_coordinate);

    const vec3 north = DecodeSceneInput(
        texelFetch(Image, north_coordinate, 0).xyz, encoded_srgb);
    const vec3 west = DecodeSceneInput(
        texelFetch(Image, west_coordinate, 0).xyz, encoded_srgb);
    const vec3 east = DecodeSceneInput(
        texelFetch(Image, east_coordinate, 0).xyz, encoded_srgb);
    const vec3 south = DecodeSceneInput(
        texelFetch(Image, south_coordinate, 0).xyz, encoded_srgb);

    // RCAS is scale-covariant, but its limiter expects approximately [0, 1]
    // luma. Normalize only the luma math by the configured HDR headroom and
    // apply the resulting ratio to the original center to preserve hue.
    const float normalization = max(
        RENODX_PEAK_WHITE_NITS / max(RENODX_DIFFUSE_WHITE_NITS, 1.0),
        1.0);
    const float inverse_normalization = 1.0 / normalization;
    const float north_luma = SceneLuma(north) * inverse_normalization;
    const float west_luma = SceneLuma(west) * inverse_normalization;
    const float center_luma = SceneLuma(center) * inverse_normalization;
    const float east_luma = SceneLuma(east) * inverse_normalization;
    const float south_luma = SceneLuma(south) * inverse_normalization;

    const float minimum_ring_luma =
        min(min(north_luma, west_luma), min(east_luma, south_luma));
    const float maximum_ring_luma =
        max(max(north_luma, west_luma), max(east_luma, south_luma));
    const float limited_maximum_luma = min(maximum_ring_luma, 0.99);
    const float epsilon = 1.0e-6;
    const float hit_minimum = minimum_ring_luma
        / max(4.0 * limited_maximum_luma, epsilon);
    float hit_maximum_denominator = 4.0 * minimum_ring_luma - 4.0;
    if (abs(hit_maximum_denominator) < epsilon)
    {
        hit_maximum_denominator =
            hit_maximum_denominator < 0.0 ? -epsilon : epsilon;
    }
    const float hit_maximum =
        (1.0 - limited_maximum_luma) / hit_maximum_denominator;
    float lobe = max(
        -0.1875,
        min(max(-hit_minimum, hit_maximum), 0.0));
    lobe *= clamp(sharpening, 0.0, 1.0);

    // Noise removal prevents film grain and other one-pixel outliers from
    // receiving the full sharpening lobe.
    float noise =
        0.25 * (north_luma + west_luma + east_luma + south_luma)
        - center_luma;
    const float maximum_luma = max(
        max(max(north_luma, west_luma), max(center_luma, east_luma)),
        south_luma);
    const float minimum_luma = min(
        min(min(north_luma, west_luma), min(center_luma, east_luma)),
        south_luma);
    noise = clamp(
        abs(noise) / max(maximum_luma - minimum_luma, epsilon),
        0.0,
        1.0);
    lobe *= 1.0 - 0.5 * noise;

    const float reciprocal_weight = 1.0 / (4.0 * lobe + 1.0);
    const float sharpened_luma =
        ((north_luma + west_luma + east_luma + south_luma) * lobe
         + center_luma)
        * reciprocal_weight;
    const float luma_ratio = center_luma > epsilon
        ? sharpened_luma / center_luma
        : 1.0;
    return max(center * clamp(luma_ratio, 0.0, 4.0), vec3(0.0));
}

void main()
{
    for (;;)
    {
        ivec2 _1043 = ivec2(gl_GlobalInvocationID.xy);
        int _1045 = _1043.x;
        bool _1048 = _1045 >= _541.g_cbComposite._viViewportOffsetSize.z;
        bool _1057;
        if (!_1048)
        {
            _1057 = _1043.y >= _541.g_cbComposite._viViewportOffsetSize.w;
        }
        else
        {
            _1057 = _1048;
        }
        if (_1057)
        {
            break;
        }
        vec4 _1066 = texelFetch(Image, _1043, 0);
        vec3 _2630;
        if (_541.g_cbComposite._viMireSrgb.y == 1)
        {
            float _1125 = _1066.x;
            float _2621;
            if (_1125 <= 0.040449999272823333740234375)
            {
                _2621 = _1125 * 0.077399380505084991455078125;
            }
            else
            {
                _2621 = pow((_1125 + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
            }
            vec3 _2439;
            _2439.x = _2621;
            float _1141 = _1066.y;
            float _2626;
            if (_1141 <= 0.040449999272823333740234375)
            {
                _2626 = _1141 * 0.077399380505084991455078125;
            }
            else
            {
                _2626 = pow((_1141 + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
            }
            _2439.y = _2626;
            float _1157 = _1066.z;
            float _2628;
            if (_1157 <= 0.040449999272823333740234375)
            {
                _2628 = _1157 * 0.077399380505084991455078125;
            }
            else
            {
                _2628 = pow((_1157 + 0.054999999701976776123046875) * 0.947867333889007568359375, 2.400000095367431640625);
            }
            _2439.z = _2628;
            _2630 = _2439;
        }
        else
        {
            _2630 = _1066.xyz;
        }
        if (CUSTOM_DLSS_ACTIVE
            && CUSTOM_DLAA_SHARPENING > 0.0
            && _541.g_cbComposite._viMireSrgb.x == 0)
        {
            _2630 = ApplyDlaaRcas(
                _1043,
                _2630,
                _541.g_cbComposite._viMireSrgb.y == 1,
                CUSTOM_DLAA_SHARPENING);
        }
        vec2 _1228 = vec2(_1043) * _541.g_cbComposite._vfGrainIrregularityU.w;
        vec4 _1240 = vec4(_1228 / vec2(_541.g_cbComposite._vfGrainSize.x), _541.g_cbComposite._vfGrainIrregularityU.x, _541.g_cbComposite._vfGrainIrregularityV.x);
        vec4 _1252 = vec4(_1228 / vec2(_541.g_cbComposite._vfGrainSize.y), _541.g_cbComposite._vfGrainIrregularityU.y, _541.g_cbComposite._vfGrainIrregularityV.y);
        vec4 _1264 = vec4(_1228 / vec2(_541.g_cbComposite._vfGrainSize.z), _541.g_cbComposite._vfGrainIrregularityU.z, _541.g_cbComposite._vfGrainIrregularityV.z);
        vec3 _2631;
        if (_541.g_cbComposite._viMireSrgb.x == 1)
        {
            _2631 = vec3(float(_1045) / float(_541.g_cbComposite._viViewportOffsetSize.z));
        }
        else
        {
            vec3 _2632;
            if (_541.g_cbComposite._viMireSrgb.x == 2)
            {
                _2632 = vec3(float(int((float(_1045) / (float(_541.g_cbComposite._viViewportOffsetSize.z) * 0.975609719753265380859375)) * 40.0)) * 0.02500000037252902984619140625);
            }
            else
            {
                _2632 = max(_2630 + ((vec3(_541.g_cbComposite._vfGrainIntensity.w) * vec3((2.0 * textureLod(Noise, _1240.xy + _1240.zw, 0.0).x) - 1.0, (2.0 * textureLod(Noise, _1252.xy + _1252.zw, 0.0).x) - 1.0, (2.0 * textureLod(Noise, _1264.xy + _1264.zw, 0.0).x) - 1.0)) * (_2630 * (_541.g_cbComposite._vfGrainIntensity.xyz + _541.g_cbComposite._vfGrainBlack.xyz))), vec3(0.0));
            }
            _2631 = _2632;
        }
        float _1330 = dot(_2631, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875));
        bool _1332 = _372.ColorGrading.ColorSpace == 2;
        vec3 _2633;
        if (_1332)
        {
            _2633 = vec3(_1330);
        }
        else
        {
            _2633 = _2631;
        }
        vec3 _1674 = log((_2633 * 10.0) + vec3(1.0)) * 0.1447438895702362060546875;
        vec4 _1347 = textureLod(ColorGradingLUTR, vec2(_1674.x, 0.0), 0.0);
        float _1348 = _1347.x;
        vec3 _2454 = _1674;
        _2454.x = _1348;
        _2454.y = textureLod(ColorGradingLUTG, vec2(_1674.y, 0.0), 0.0).x;
        _2454.z = textureLod(ColorGradingLUTB, vec2(_1674.z, 0.0), 0.0).x;
        vec3 _2634;
        if (_1332)
        {
            _2634 = (_2631 * _1348) / vec3(_1330);
        }
        else
        {
            _2634 = _2454;
        }
        vec3 _2636;
        if (_372.ColorGrading.ColorSpace != 3)
        {
            vec3 _1696 = vec3(dot(_2634, vec3(0.2125999927520751953125, 0.715200006961822509765625, 0.072200000286102294921875)));
            vec3 _1704 = _1696 + (vec3(_372.ColorGrading.Saturation) * (_2634 - _1696));
            vec3 _2635;
            if (_372.ColorGrading.Hue != 0.0)
            {
                float _1729 = _1704.z;
                float _1730 = _1704.y;
                vec4 _1749 = mix(vec4(_1729, _1730, -1.0, 0.666666686534881591796875), vec4(_1730, _1729, 0.0, -0.3333333432674407958984375), vec4(step(_1729, _1730)));
                float _1753 = _1704.x;
                float _1754 = _1749.x;
                vec4 _1772 = mix(vec4(_1754, _1749.yw, _1753), vec4(_1753, _1749.yz, _1754), vec4(step(_1754, _1753)));
                float _1774 = _1772.x;
                float _1776 = _1772.w;
                float _1778 = _1772.y;
                float _1780 = _1774 - min(_1776, _1778);
                float _1794 = abs(_1772.z + ((_1776 - _1778) / ((6.0 * _1780) + 1.0000000133514319600180897396058e-10)));
                float _1800 = _1780 / (_1774 + 1.0000000133514319600180897396058e-10);
                vec3 _1803 = vec3(_1794, _1800, _1774);
                _1803.x = _1794 + _372.ColorGrading.Hue;
                _2635 = mix(vec3(1.0), clamp(abs((fract(_1803.xxx + vec3(1.0, 0.666666686534881591796875, 0.3333333432674407958984375)) * 6.0) - vec3(3.0)) - vec3(1.0), vec3(0.0), vec3(1.0)), vec3(_1800)) * _1774;
            }
            else
            {
                _2635 = _1704;
            }
            _2636 = _2635;
        }
        else
        {
            _2636 = _2634;
        }
        vec3 _1389 = max(_2636, vec3(0.0));
        vec3 _2647;
        if (_541.g_cbComposite._viMireSrgb.z == 1)
        {
            float _1839 = _1389.x;
            float _2637;
            for (;;)
            {
                if (_1839 <= 0.5)
                {
                    _2637 = _1839;
                    break;
                }
                if (_1839 >= 1.89999997615814208984375)
                {
                    _2637 = (0.044551424682140350341796875 * _1839) + 0.84530413150787353515625;
                    break;
                }
                _2637 = 0.949999988079071044921875 - (0.449999988079071044921875 * exp((0.5 - _1839) * 2.22222232818603515625));
                break;
            }
            vec3 _2483 = _1389;
            _2483.x = _2637;
            float _1843 = _1389.y;
            float _2640;
            for (;;)
            {
                if (_1843 <= 0.5)
                {
                    _2640 = _1843;
                    break;
                }
                if (_1843 >= 1.89999997615814208984375)
                {
                    _2640 = (0.044551424682140350341796875 * _1843) + 0.84530413150787353515625;
                    break;
                }
                _2640 = 0.949999988079071044921875 - (0.449999988079071044921875 * exp((0.5 - _1843) * 2.22222232818603515625));
                break;
            }
            _2483.y = _2640;
            float _1847 = _1389.z;
            float _2643;
            for (;;)
            {
                if (_1847 <= 0.5)
                {
                    _2643 = _1847;
                    break;
                }
                if (_1847 >= 1.89999997615814208984375)
                {
                    _2643 = (0.044551424682140350341796875 * _1847) + 0.84530413150787353515625;
                    break;
                }
                _2643 = 0.949999988079071044921875 - (0.449999988079071044921875 * exp((0.5 - _1847) * 2.22222232818603515625));
                break;
            }
            _2483.z = _2643;
            _2647 = _2483;
        }
        else
        {
            _2647 = _1389;
        }
        const bool renodx_custom_active =
            CUSTOM_HDR_ACTIVE &&
            (RENODX_TONE_MAP_TYPE != 0.0 ||
            RENODX_COLOR_GRADE_STRENGTH != 1.0 ||
            RENODX_TONE_MAP_EXPOSURE != 1.0 ||
            RENODX_TONE_MAP_HIGHLIGHTS != 1.0 ||
            RENODX_TONE_MAP_SHADOWS != 1.0 ||
            RENODX_TONE_MAP_CONTRAST != 1.0 ||
            RENODX_TONE_MAP_SATURATION != 1.0 ||
            RENODX_TONE_MAP_HIGHLIGHT_SATURATION != 1.0 ||
            RENODX_TONE_MAP_BLOWOUT != 0.0 ||
            RENODX_TONE_MAP_FLARE != 0.0);
        if (renodx_custom_active && _541.g_cbComposite._viMireSrgb.x == 0)
        {
            const vec3 renodx_untonemapped = max(_2631, vec3(0.0));
            const vec3 renodx_vanilla_graded_linear = _2647;
            const vec3 renodx_tonemapped = renodx::draw::ToneMapPass(
                renodx_untonemapped,
                renodx_vanilla_graded_linear);
            // ToneMapPass emits a gamma-2.2 intermediate where 1.0 represents
            // Game Brightness. Detroit's native OETF instead maps 1.0 to
            // 300 nits, so adapt in display-light space before the unchanged
            // native Rec.2020/PQ path. This maps both 203-nit diffuse white and
            // the configured peak to their actual output luminance.
            const float renodx_game_scale =
                max(RENODX_DIFFUSE_WHITE_NITS, 0.0) / 300.0;
            _2647 = pow(
                pow(max(renodx_tonemapped, vec3(0.0)), vec3(2.2))
                    * renodx_game_scale,
                vec3(1.0 / 2.2));
        }
        bool _1398 = _372.ColorGrading.ColorSpace == 0;
        bool _1404;
        if (!_1398)
        {
            _1404 = _1332;
        }
        else
        {
            _1404 = _1398;
        }
        vec3 _2677;
        if (_1404)
        {
            float _2648;
            if (_2647.x <= 0.003130800090730190277099609375)
            {
                _2648 = 12.9200000762939453125 * _2647.x;
            }
            else
            {
                _2648 = (1.05499994754791259765625 * pow(_2647.x, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
            }
            vec3 _2494;
            _2494.x = _2648;
            float _2670;
            if (_2647.y <= 0.003130800090730190277099609375)
            {
                _2670 = 12.9200000762939453125 * _2647.y;
            }
            else
            {
                _2670 = (1.05499994754791259765625 * pow(_2647.y, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
            }
            _2494.y = _2670;
            float _2672;
            if (_2647.z <= 0.003130800090730190277099609375)
            {
                _2672 = 12.9200000762939453125 * _2647.z;
            }
            else
            {
                _2672 = (1.05499994754791259765625 * pow(_2647.z, 0.4166666567325592041015625)) - 0.054999999701976776123046875;
            }
            _2494.z = _2672;
            _2677 = _2494;
        }
        else
        {
            _2677 = _2647;
        }
        vec3 _2706;
        if (_541.g_cbComposite._viMireSrgb.x == 3)
        {
            int _1416 = _541.g_cbComposite._viViewportOffsetSize.z / 5;
            int _1418 = _1416 / 2;
            int _1420 = _1416 / 4;
            ivec2 _1422 = ivec2(_1416);
            ivec2 _1423 = _1422 * ivec2(1);
            ivec2 _1425 = ivec2(_1420, 0);
            ivec2 _1427 = ivec2(0) * _1425;
            ivec2 _1428 = _1423 + _1427;
            int _2077 = _1428.x;
            bool _2078 = _1045 >= _2077;
            bool _2089;
            if (_2078)
            {
                _2089 = _1045 <= (_2077 + _1420);
            }
            else
            {
                _2089 = _2078;
            }
            bool _2097;
            if (_2089)
            {
                _2097 = _1043.y >= _1428.y;
            }
            else
            {
                _2097 = _2089;
            }
            bool _2108;
            if (_2097)
            {
                _2108 = _1043.y <= (_1428.y + _1416);
            }
            else
            {
                _2108 = _2097;
            }
            ivec2 _1447 = ivec2(1) * _1425;
            ivec2 _1448 = _1423 + _1447;
            int _2113 = _1448.x;
            bool _2114 = _1045 >= _2113;
            bool _2125;
            if (_2114)
            {
                _2125 = _1045 <= (_2113 + _1420);
            }
            else
            {
                _2125 = _2114;
            }
            bool _2133;
            if (_2125)
            {
                _2133 = _1043.y >= _1448.y;
            }
            else
            {
                _2133 = _2125;
            }
            bool _2144;
            if (_2133)
            {
                _2144 = _1043.y <= (_1448.y + _1416);
            }
            else
            {
                _2144 = _2133;
            }
            ivec2 _1467 = ivec2(2) * _1425;
            ivec2 _1468 = _1423 + _1467;
            int _2149 = _1468.x;
            bool _2150 = _1045 >= _2149;
            bool _2161;
            if (_2150)
            {
                _2161 = _1045 <= (_2149 + _1420);
            }
            else
            {
                _2161 = _2150;
            }
            bool _2169;
            if (_2161)
            {
                _2169 = _1043.y >= _1468.y;
            }
            else
            {
                _2169 = _2161;
            }
            bool _2180;
            if (_2169)
            {
                _2180 = _1043.y <= (_1468.y + _1416);
            }
            else
            {
                _2180 = _2169;
            }
            ivec2 _1487 = ivec2(3) * _1425;
            ivec2 _1488 = _1423 + _1487;
            int _2185 = _1488.x;
            bool _2186 = _1045 >= _2185;
            bool _2197;
            if (_2186)
            {
                _2197 = _1045 <= (_2185 + _1420);
            }
            else
            {
                _2197 = _2186;
            }
            bool _2205;
            if (_2197)
            {
                _2205 = _1043.y >= _1488.y;
            }
            else
            {
                _2205 = _2197;
            }
            bool _2216;
            if (_2205)
            {
                _2216 = _1043.y <= (_1488.y + _1416);
            }
            else
            {
                _2216 = _2205;
            }
            ivec2 _1503 = _1422 * ivec2(2, 1);
            int _2221 = _1503.x;
            bool _2222 = _1045 >= _2221;
            bool _2233;
            if (_2222)
            {
                _2233 = _1045 <= (_2221 + _1416);
            }
            else
            {
                _2233 = _2222;
            }
            bool _2241;
            if (_2233)
            {
                _2241 = _1043.y >= _1503.y;
            }
            else
            {
                _2241 = _2233;
            }
            bool _2252;
            if (_2241)
            {
                _2252 = _1043.y <= (_1503.y + _1416);
            }
            else
            {
                _2252 = _2241;
            }
            vec3 _2690;
            if (_2252)
            {
                _2690 = vec3(bvec3((((_1045 / 2) + (_1043.y / 2)) & 1) == 0));
            }
            else
            {
                _2690 = mix(mix(mix(mix(_2677, vec3(0.847058832645416259765625), bvec3(_2108)), vec3(0.89803922176361083984375), bvec3(_2144)), vec3(0.949019610881805419921875), bvec3(_2180)), vec3(1.0), bvec3(_2216));
            }
            ivec2 _1537 = _1503 + (ivec2(_1418) / ivec2(2));
            int _2257 = _1537.x;
            bool _2258 = _1045 >= _2257;
            bool _2269;
            if (_2258)
            {
                _2269 = _1045 <= (_2257 + _1418);
            }
            else
            {
                _2269 = _2258;
            }
            bool _2277;
            if (_2269)
            {
                _2277 = _1043.y >= _1537.y;
            }
            else
            {
                _2277 = _2269;
            }
            bool _2288;
            if (_2277)
            {
                _2288 = _1043.y <= (_1537.y + _1418);
            }
            else
            {
                _2288 = _2277;
            }
            ivec2 _1552 = _1422 * ivec2(3, 1);
            ivec2 _1557 = _1552 + _1427;
            int _2293 = _1557.x;
            bool _2294 = _1045 >= _2293;
            bool _2305;
            if (_2294)
            {
                _2305 = _1045 <= (_2293 + _1420);
            }
            else
            {
                _2305 = _2294;
            }
            bool _2313;
            if (_2305)
            {
                _2313 = _1043.y >= _1557.y;
            }
            else
            {
                _2313 = _2305;
            }
            bool _2324;
            if (_2313)
            {
                _2324 = _1043.y <= (_1557.y + _1416);
            }
            else
            {
                _2324 = _2313;
            }
            ivec2 _1577 = _1552 + _1447;
            int _2329 = _1577.x;
            bool _2330 = _1045 >= _2329;
            bool _2341;
            if (_2330)
            {
                _2341 = _1045 <= (_2329 + _1420);
            }
            else
            {
                _2341 = _2330;
            }
            bool _2349;
            if (_2341)
            {
                _2349 = _1043.y >= _1577.y;
            }
            else
            {
                _2349 = _2341;
            }
            bool _2360;
            if (_2349)
            {
                _2360 = _1043.y <= (_1577.y + _1416);
            }
            else
            {
                _2360 = _2349;
            }
            ivec2 _1597 = _1552 + _1467;
            int _2365 = _1597.x;
            bool _2366 = _1045 >= _2365;
            bool _2377;
            if (_2366)
            {
                _2377 = _1045 <= (_2365 + _1420);
            }
            else
            {
                _2377 = _2366;
            }
            bool _2385;
            if (_2377)
            {
                _2385 = _1043.y >= _1597.y;
            }
            else
            {
                _2385 = _2377;
            }
            bool _2396;
            if (_2385)
            {
                _2396 = _1043.y <= (_1597.y + _1416);
            }
            else
            {
                _2396 = _2385;
            }
            ivec2 _1617 = _1552 + _1487;
            int _2401 = _1617.x;
            bool _2402 = _1045 >= _2401;
            bool _2413;
            if (_2402)
            {
                _2413 = _1045 <= (_2401 + _1420);
            }
            else
            {
                _2413 = _2402;
            }
            bool _2421;
            if (_2413)
            {
                _2421 = _1043.y >= _1617.y;
            }
            else
            {
                _2421 = _2413;
            }
            bool _2432;
            if (_2421)
            {
                _2432 = _1043.y <= (_1617.y + _1416);
            }
            else
            {
                _2432 = _2421;
            }
            _2706 = mix(mix(mix(mix(mix(_2690, vec3(0.729411780834197998046875), bvec3(_2288)), vec3(0.0), bvec3(_2324)), vec3(0.0470588244497776031494140625), bvec3(_2360)), vec3(0.098039217293262481689453125), bvec3(_2396)), vec3(0.14901961386203765869140625), bvec3(_2432));
        }
        else
        {
            _2706 = _2677;
        }
        imageStore(OutputTexture, _1043 + _541.g_cbComposite._viViewportOffsetSize.xy, vec4(_2706, 1.0));
        break;
    }
}
