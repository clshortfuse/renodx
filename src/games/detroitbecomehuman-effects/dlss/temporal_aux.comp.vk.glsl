// Transitional replacement derived from the exact Build 12158144 shader
// 0xB5506A45. DLAA owns b16, while Detroit's b17-b19 history outputs remain
// live until their downstream consumers are fully mapped. A failed DLAA
// evaluation replays the original shader so b16 also falls back natively.
#version 450
#extension GL_EXT_samplerless_texture_functions : require
#extension GL_GOOGLE_include_directive : require
#extension GL_KHR_shader_subgroup_shuffle : require
layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

struct ShaderInjectData_std140
{
    float peak_white_nits;
    float diffuse_white_nits;
    float graphics_white_nits;
    float tone_map_type;
    float output_mode;
    float output_is_hdr;
    float tone_map_exposure;
    float tone_map_highlights;
    float tone_map_shadows;
    float tone_map_contrast;
    float tone_map_saturation;
    float tone_map_highlight_saturation;
    float tone_map_blowout;
    float tone_map_flare;
    float color_grade_strength;
    float cas_mode;
    float cas_strength;
    float scene_path_active;
    float ui_path_active;
    float runtime_flags;
    float psychov_cone_response;
    float psychov_exposure_match;
    float psychov_vanilla_slope;
    float psychov_gamut_mode;
    float psychov17_bleaching;
    float psychov17_hue_restore;
    float psychov22_compression;
    float dof_runtime_mode;
};

layout(push_constant) uniform PushData
{
    ShaderInjectData_std140 shader_injection;
};

#include "../debug/render_debug_common.slang"

bool RenderDebugPushPayloadFinite()
{
    return !isnan(shader_injection.peak_white_nits)
        && !isinf(shader_injection.peak_white_nits)
        && !isnan(shader_injection.diffuse_white_nits)
        && !isinf(shader_injection.diffuse_white_nits)
        && !isnan(shader_injection.graphics_white_nits)
        && !isinf(shader_injection.graphics_white_nits)
        && !isnan(shader_injection.tone_map_type)
        && !isinf(shader_injection.tone_map_type)
        && !isnan(shader_injection.output_mode)
        && !isinf(shader_injection.output_mode)
        && !isnan(shader_injection.output_is_hdr)
        && !isinf(shader_injection.output_is_hdr)
        && !isnan(shader_injection.tone_map_exposure)
        && !isinf(shader_injection.tone_map_exposure)
        && !isnan(shader_injection.tone_map_highlights)
        && !isinf(shader_injection.tone_map_highlights)
        && !isnan(shader_injection.tone_map_shadows)
        && !isinf(shader_injection.tone_map_shadows)
        && !isnan(shader_injection.tone_map_contrast)
        && !isinf(shader_injection.tone_map_contrast)
        && !isnan(shader_injection.tone_map_saturation)
        && !isinf(shader_injection.tone_map_saturation)
        && !isnan(shader_injection.tone_map_highlight_saturation)
        && !isinf(shader_injection.tone_map_highlight_saturation)
        && !isnan(shader_injection.tone_map_blowout)
        && !isinf(shader_injection.tone_map_blowout)
        && !isnan(shader_injection.tone_map_flare)
        && !isinf(shader_injection.tone_map_flare)
        && !isnan(shader_injection.color_grade_strength)
        && !isinf(shader_injection.color_grade_strength)
        && !isnan(shader_injection.cas_mode)
        && !isinf(shader_injection.cas_mode)
        && !isnan(shader_injection.cas_strength)
        && !isinf(shader_injection.cas_strength)
        && !isnan(shader_injection.scene_path_active)
        && !isinf(shader_injection.scene_path_active)
        && !isnan(shader_injection.ui_path_active)
        && !isinf(shader_injection.ui_path_active)
        && !isnan(shader_injection.runtime_flags)
        && !isinf(shader_injection.runtime_flags)
        && !isnan(shader_injection.psychov_cone_response)
        && !isinf(shader_injection.psychov_cone_response)
        && !isnan(shader_injection.psychov_exposure_match)
        && !isinf(shader_injection.psychov_exposure_match)
        && !isnan(shader_injection.psychov_vanilla_slope)
        && !isinf(shader_injection.psychov_vanilla_slope)
        && !isnan(shader_injection.psychov_gamut_mode)
        && !isinf(shader_injection.psychov_gamut_mode)
        && !isnan(shader_injection.psychov17_bleaching)
        && !isinf(shader_injection.psychov17_bleaching)
        && !isnan(shader_injection.psychov17_hue_restore)
        && !isinf(shader_injection.psychov17_hue_restore)
        && !isnan(shader_injection.psychov22_compression)
        && !isinf(shader_injection.psychov22_compression)
        && !isnan(shader_injection.dof_runtime_mode)
        && !isinf(shader_injection.dof_runtime_mode);
}

struct TAA_SPACE_CONV_MATRICES
{
    mat4 mCurrHSpaceToPrevHSpace_CroppedUV;
    mat4 mCurrHSpaceToPrevPrevHSpace_CroppedUV;
};

struct TEMPORAL_AA_CONSTANT_BUFFER
{
    TAA_SPACE_CONV_MATRICES _mSpaceConvMatrices[2];
    vec4 _vfProjSetup;
    vec4 _vfRenderTargetSize_InvSize;
    vec4 _vfSrcTextureSize_InvSize;
    ivec4 _viViewportOrigin_Size;
    ivec4 _viViewportTopLeftMinusOne;
    vec4 _vfViewportOrigin_TopLeftUpsampled;
    float _fHistoryBlendFactor;
    float _fResponsiveBlendFactor;
    float _fRainSlopeDampingFactor;
    float _fDisocclusionDepthThreshold;
    vec4 _vfDejitterWeights0;
    vec4 _vfDejitterWeights1;
    vec4 _vfPixelToClipSpace;
    float _fContourDepthThreshold;
    float _fMinExposure;
    float _fPreviousFrameExposureCompensation;
    int _iPadding0;
    float _fJitterCoordX;
    float _fJitterCoordY;
    float _fUpsamplingFactor;
    float _fInvUpsamplingFactor;
    vec4 _vfResampledUVToRenderedUVScale;
    uint _uDebugFrameIndex;
    uint _uEnableContourAA;
    float _fPrevUpsamplingFactor;
    uint _iPadding1;
    uint _uDebugVisualizeOptions;
    uint _uDebugFeaturesSet;
    uint _uPixelHistoryDebugCoordX;
    uint _uPixelHistoryDebugCoordY;
};

const ivec2 _668[8] = ivec2[](ivec2(1, 0), ivec2(-1, 0), ivec2(0, 1), ivec2(0, -1), ivec2(1), ivec2(1, -1), ivec2(-1), ivec2(-1, 1));
const ivec2 _2055[9] = ivec2[](ivec2(0), ivec2(-1, 1), ivec2(0, 1), ivec2(1), ivec2(1, 0), ivec2(1, -1), ivec2(0, -1), ivec2(-1), ivec2(-1, 0));
vec4 _5658;

layout(set = 0, binding = 52, std140) uniform dyn_CONSTANT_BUFFER_BLOCK_0
{
    TEMPORAL_AA_CONSTANT_BUFFER _TAA;
} _415;

layout(set = 0, binding = 1) uniform sampler2D CurrColorTex;
layout(set = 0, binding = 3) uniform sampler2D CurrZBuffer;
layout(set = 0, binding = 6) uniform usampler2D TAAFlagsTexture;
layout(set = 0, binding = 5) uniform sampler2D AvgLumMap;
layout(set = 0, binding = 4) uniform sampler2D MotionVectorTex;
layout(set = 0, binding = 0) uniform sampler2D PrevAADepthTex;
layout(set = 0, binding = 7) uniform usampler2D PrevSpeedAndFlagsTex;
layout(set = 0, binding = 17, r16f) uniform writeonly image2D OutAADepth;
layout(set = 0, binding = 2) uniform sampler2D PrevColorTex;
layout(set = 0, binding = 16, r32ui) uniform writeonly uimage2D OutColorPass;
layout(set = 0, binding = 18, r16ui) uniform writeonly uimage2D OutPrevSpeedAndFlagsTex;
layout(set = 0, binding = 19, r8ui) uniform writeonly uimage2D HalfResContours;

shared float sharedDepth[64];
shared vec2 sharedMotionVec[64];

float SanitizeRenderDebugChannel(float value)
{
    return isnan(value) || isinf(value)
        ? 0.0
        : clamp(value, 0.0, 65408.0);
}

uint PackRenderDebugRgb9e5(vec3 value)
{
    vec3 color = vec3(
        SanitizeRenderDebugChannel(value.r),
        SanitizeRenderDebugChannel(value.g),
        SanitizeRenderDebugChannel(value.b));
    uint exponent = max(
        0x37800000u,
        floatBitsToUint(max(color.r, max(color.g, color.b)))
            & 0x7F800000u);
    float bias = uintBitsToFloat(exponent + 0x07800000u);
    uint red = floatBitsToUint(
        uintBitsToFloat(floatBitsToUint(color.r) & 0xFFFF8000u) + bias);
    uint green = floatBitsToUint(
        uintBitsToFloat(floatBitsToUint(color.g) & 0xFFFF8000u) + bias);
    uint blue = floatBitsToUint(
        uintBitsToFloat(floatBitsToUint(color.b) & 0xFFFF8000u) + bias);
    return (((red | (green << 9u)) & 0x0003FFFFu) | (blue << 18u))
        | ((exponent - 0x37800000u) << 4u);
}

void main()
{
    ivec2 _1477 = ivec2(gl_GlobalInvocationID.xy);
    int _1480 = _1477.x;
    bool _1483 = _1480 >= _415._TAA._viViewportOrigin_Size.z;
    bool _1492;
    if (!_1483)
    {
        _1492 = _1477.y >= _415._TAA._viViewportOrigin_Size.w;
    }
    else
    {
        _1492 = _1483;
    }
    int _1552 = int(texelFetch(TAAFlagsTexture, ivec2(vec2(_1477) * 1.0), 0).x);
    float _1558 = float(_1552 & 15) * 0.066666670143604278564453125;
    bool _1561 = (_1552 & 16) != 0;
    ivec2 _1571 = _1477 + _415._TAA._viViewportOrigin_Size.xy;
    vec2 _1574 = vec2(_1571);
    ivec2 _1576 = ivec2(_1574 * 1.0);
    vec2 _1589 = (_1574 + vec2(0.5)) * _415._TAA._vfRenderTargetSize_InvSize.zw;
    vec2 _2352 = (vec2(_1576) + vec2(0.5)) * _415._TAA._vfSrcTextureSize_InvSize.zw;
    vec4 _2355 = textureGather(CurrZBuffer, _2352);
    vec4 _2362 = textureGather(CurrZBuffer, _2352 - _415._TAA._vfSrcTextureSize_InvSize.zw);
    ivec2 _2365 = _1576 + ivec2(1, -1);
    ivec2 _2398 = ivec2(clamp(_2365.x, _415._TAA._viViewportOrigin_Size.x, _415._TAA._viViewportTopLeftMinusOne.x), clamp(_2365.y, _415._TAA._viViewportOrigin_Size.y, _415._TAA._viViewportTopLeftMinusOne.y));
    vec4 _2371 = texelFetch(CurrZBuffer, _2398, 0);
    float _2372 = _2371.x;
    ivec2 _2375 = _1576 + ivec2(-1, 1);
    ivec2 _2414 = ivec2(clamp(_2375.x, _415._TAA._viViewportOrigin_Size.x, _415._TAA._viViewportTopLeftMinusOne.x), clamp(_2375.y, _415._TAA._viViewportOrigin_Size.y, _415._TAA._viViewportTopLeftMinusOne.y));
    vec4 _2381 = texelFetch(CurrZBuffer, _2414, 0);
    float _2382 = _2381.x;
    float _1604 = max(_415._TAA._fMinExposure, texelFetch(AvgLumMap, ivec2(0), 0).y);
    float _2430 = _2355.w;
    float _2532 = _415._TAA._vfProjSetup.y / (_2430 + _415._TAA._vfProjSetup.x);
    ivec2 _5730;
    float _5766;
    int _5793;
    float _6001;
    int _2686;
    int _2688;
    for (;;)
    {
        _2686 = _668[0].x;
        _2688 = _668[0].y;
        float _5668;
        for (;;)
        {
            bool _2698 = _2686 == 0;
            bool _2700 = _2688 == 0;
            if (_2698 && _2700)
            {
                _5668 = _2430;
                break;
            }
            bool _2707 = _2686 == 1;
            if (_2707 && _2700)
            {
                _5668 = _2355.z;
                break;
            }
            bool _2716 = _2686 == (-1);
            if (_2716 && _2700)
            {
                _5668 = _2362.x;
                break;
            }
            bool _2727 = _2688 == 1;
            if (_2698 && _2727)
            {
                _5668 = _2355.x;
                break;
            }
            bool _2736 = _2688 == (-1);
            if (_2698 && _2736)
            {
                _5668 = _2362.z;
                break;
            }
            if (_2716 && _2727)
            {
                _5668 = _2382;
                break;
            }
            if (_2707 && _2727)
            {
                _5668 = _2355.y;
                break;
            }
            if (_2707 && _2736)
            {
                _5668 = _2372;
                break;
            }
            if (_2716 && _2736)
            {
                _5668 = _2362.w;
                break;
            }
            if (_2686 == 2)
            {
                _5668 = 0.0;
                break;
            }
            if (_2686 == (-2))
            {
                _5668 = 0.0;
                break;
            }
            if (_2688 == 2)
            {
                _5668 = 0.0;
                break;
            }
            if (_2688 == (-2))
            {
                _5668 = 0.0;
                break;
            }
            _5668 = -1.0;
            break;
        }
        float _5673;
        for (;;)
        {
            bool _2813 = _668[1].x == 0;
            bool _2815 = _668[1].y == 0;
            if (_2813 && _2815)
            {
                _5673 = _2430;
                break;
            }
            bool _2822 = _668[1].x == 1;
            if (_2822 && _2815)
            {
                _5673 = _2355.z;
                break;
            }
            bool _2831 = _668[1].x == (-1);
            if (_2831 && _2815)
            {
                _5673 = _2362.x;
                break;
            }
            bool _2842 = _668[1].y == 1;
            if (_2813 && _2842)
            {
                _5673 = _2355.x;
                break;
            }
            bool _2851 = _668[1].y == (-1);
            if (_2813 && _2851)
            {
                _5673 = _2362.z;
                break;
            }
            if (_2831 && _2842)
            {
                _5673 = _2382;
                break;
            }
            if (_2822 && _2842)
            {
                _5673 = _2355.y;
                break;
            }
            if (_2822 && _2851)
            {
                _5673 = _2372;
                break;
            }
            if (_2831 && _2851)
            {
                _5673 = _2362.w;
                break;
            }
            if (_668[1].x == 2)
            {
                _5673 = 0.0;
                break;
            }
            if (_668[1].x == (-2))
            {
                _5673 = 0.0;
                break;
            }
            if (_668[1].y == 2)
            {
                _5673 = 0.0;
                break;
            }
            if (_668[1].y == (-2))
            {
                _5673 = 0.0;
                break;
            }
            _5673 = -1.0;
            break;
        }
        float _5678;
        for (;;)
        {
            bool _2928 = _668[2].x == 0;
            bool _2930 = _668[2].y == 0;
            if (_2928 && _2930)
            {
                _5678 = _2430;
                break;
            }
            bool _2937 = _668[2].x == 1;
            if (_2937 && _2930)
            {
                _5678 = _2355.z;
                break;
            }
            bool _2946 = _668[2].x == (-1);
            if (_2946 && _2930)
            {
                _5678 = _2362.x;
                break;
            }
            bool _2957 = _668[2].y == 1;
            if (_2928 && _2957)
            {
                _5678 = _2355.x;
                break;
            }
            bool _2966 = _668[2].y == (-1);
            if (_2928 && _2966)
            {
                _5678 = _2362.z;
                break;
            }
            if (_2946 && _2957)
            {
                _5678 = _2382;
                break;
            }
            if (_2937 && _2957)
            {
                _5678 = _2355.y;
                break;
            }
            if (_2937 && _2966)
            {
                _5678 = _2372;
                break;
            }
            if (_2946 && _2966)
            {
                _5678 = _2362.w;
                break;
            }
            if (_668[2].x == 2)
            {
                _5678 = 0.0;
                break;
            }
            if (_668[2].x == (-2))
            {
                _5678 = 0.0;
                break;
            }
            if (_668[2].y == 2)
            {
                _5678 = 0.0;
                break;
            }
            if (_668[2].y == (-2))
            {
                _5678 = 0.0;
                break;
            }
            _5678 = -1.0;
            break;
        }
        float _5683;
        for (;;)
        {
            bool _3043 = _668[3].x == 0;
            bool _3045 = _668[3].y == 0;
            if (_3043 && _3045)
            {
                _5683 = _2430;
                break;
            }
            bool _3052 = _668[3].x == 1;
            if (_3052 && _3045)
            {
                _5683 = _2355.z;
                break;
            }
            bool _3061 = _668[3].x == (-1);
            if (_3061 && _3045)
            {
                _5683 = _2362.x;
                break;
            }
            bool _3072 = _668[3].y == 1;
            if (_3043 && _3072)
            {
                _5683 = _2355.x;
                break;
            }
            bool _3081 = _668[3].y == (-1);
            if (_3043 && _3081)
            {
                _5683 = _2362.z;
                break;
            }
            if (_3061 && _3072)
            {
                _5683 = _2382;
                break;
            }
            if (_3052 && _3072)
            {
                _5683 = _2355.y;
                break;
            }
            if (_3052 && _3081)
            {
                _5683 = _2372;
                break;
            }
            if (_3061 && _3081)
            {
                _5683 = _2362.w;
                break;
            }
            if (_668[3].x == 2)
            {
                _5683 = 0.0;
                break;
            }
            if (_668[3].x == (-2))
            {
                _5683 = 0.0;
                break;
            }
            if (_668[3].y == 2)
            {
                _5683 = 0.0;
                break;
            }
            if (_668[3].y == (-2))
            {
                _5683 = 0.0;
                break;
            }
            _5683 = -1.0;
            break;
        }
        float _5688;
        for (;;)
        {
            bool _3158 = _668[4].x == 0;
            bool _3160 = _668[4].y == 0;
            if (_3158 && _3160)
            {
                _5688 = _2430;
                break;
            }
            bool _3167 = _668[4].x == 1;
            if (_3167 && _3160)
            {
                _5688 = _2355.z;
                break;
            }
            bool _3176 = _668[4].x == (-1);
            if (_3176 && _3160)
            {
                _5688 = _2362.x;
                break;
            }
            bool _3187 = _668[4].y == 1;
            if (_3158 && _3187)
            {
                _5688 = _2355.x;
                break;
            }
            bool _3196 = _668[4].y == (-1);
            if (_3158 && _3196)
            {
                _5688 = _2362.z;
                break;
            }
            if (_3176 && _3187)
            {
                _5688 = _2382;
                break;
            }
            if (_3167 && _3187)
            {
                _5688 = _2355.y;
                break;
            }
            if (_3167 && _3196)
            {
                _5688 = _2372;
                break;
            }
            if (_3176 && _3196)
            {
                _5688 = _2362.w;
                break;
            }
            if (_668[4].x == 2)
            {
                _5688 = 0.0;
                break;
            }
            if (_668[4].x == (-2))
            {
                _5688 = 0.0;
                break;
            }
            if (_668[4].y == 2)
            {
                _5688 = 0.0;
                break;
            }
            if (_668[4].y == (-2))
            {
                _5688 = 0.0;
                break;
            }
            _5688 = -1.0;
            break;
        }
        float _5693;
        for (;;)
        {
            bool _3273 = _668[5].x == 0;
            bool _3275 = _668[5].y == 0;
            if (_3273 && _3275)
            {
                _5693 = _2430;
                break;
            }
            bool _3282 = _668[5].x == 1;
            if (_3282 && _3275)
            {
                _5693 = _2355.z;
                break;
            }
            bool _3291 = _668[5].x == (-1);
            if (_3291 && _3275)
            {
                _5693 = _2362.x;
                break;
            }
            bool _3302 = _668[5].y == 1;
            if (_3273 && _3302)
            {
                _5693 = _2355.x;
                break;
            }
            bool _3311 = _668[5].y == (-1);
            if (_3273 && _3311)
            {
                _5693 = _2362.z;
                break;
            }
            if (_3291 && _3302)
            {
                _5693 = _2382;
                break;
            }
            if (_3282 && _3302)
            {
                _5693 = _2355.y;
                break;
            }
            if (_3282 && _3311)
            {
                _5693 = _2372;
                break;
            }
            if (_3291 && _3311)
            {
                _5693 = _2362.w;
                break;
            }
            if (_668[5].x == 2)
            {
                _5693 = 0.0;
                break;
            }
            if (_668[5].x == (-2))
            {
                _5693 = 0.0;
                break;
            }
            if (_668[5].y == 2)
            {
                _5693 = 0.0;
                break;
            }
            if (_668[5].y == (-2))
            {
                _5693 = 0.0;
                break;
            }
            _5693 = -1.0;
            break;
        }
        float _5698;
        for (;;)
        {
            bool _3388 = _668[6].x == 0;
            bool _3390 = _668[6].y == 0;
            if (_3388 && _3390)
            {
                _5698 = _2430;
                break;
            }
            bool _3397 = _668[6].x == 1;
            if (_3397 && _3390)
            {
                _5698 = _2355.z;
                break;
            }
            bool _3406 = _668[6].x == (-1);
            if (_3406 && _3390)
            {
                _5698 = _2362.x;
                break;
            }
            bool _3417 = _668[6].y == 1;
            if (_3388 && _3417)
            {
                _5698 = _2355.x;
                break;
            }
            bool _3426 = _668[6].y == (-1);
            if (_3388 && _3426)
            {
                _5698 = _2362.z;
                break;
            }
            if (_3406 && _3417)
            {
                _5698 = _2382;
                break;
            }
            if (_3397 && _3417)
            {
                _5698 = _2355.y;
                break;
            }
            if (_3397 && _3426)
            {
                _5698 = _2372;
                break;
            }
            if (_3406 && _3426)
            {
                _5698 = _2362.w;
                break;
            }
            if (_668[6].x == 2)
            {
                _5698 = 0.0;
                break;
            }
            if (_668[6].x == (-2))
            {
                _5698 = 0.0;
                break;
            }
            if (_668[6].y == 2)
            {
                _5698 = 0.0;
                break;
            }
            if (_668[6].y == (-2))
            {
                _5698 = 0.0;
                break;
            }
            _5698 = -1.0;
            break;
        }
        float _5703;
        for (;;)
        {
            bool _3503 = _668[7].x == 0;
            bool _3505 = _668[7].y == 0;
            if (_3503 && _3505)
            {
                _5703 = _2430;
                break;
            }
            bool _3512 = _668[7].x == 1;
            if (_3512 && _3505)
            {
                _5703 = _2355.z;
                break;
            }
            bool _3521 = _668[7].x == (-1);
            if (_3521 && _3505)
            {
                _5703 = _2362.x;
                break;
            }
            bool _3532 = _668[7].y == 1;
            if (_3503 && _3532)
            {
                _5703 = _2355.x;
                break;
            }
            bool _3541 = _668[7].y == (-1);
            if (_3503 && _3541)
            {
                _5703 = _2362.z;
                break;
            }
            if (_3521 && _3532)
            {
                _5703 = _2382;
                break;
            }
            if (_3512 && _3532)
            {
                _5703 = _2355.y;
                break;
            }
            if (_3512 && _3541)
            {
                _5703 = _2372;
                break;
            }
            if (_3521 && _3541)
            {
                _5703 = _2362.w;
                break;
            }
            if (_668[7].x == 2)
            {
                _5703 = 0.0;
                break;
            }
            if (_668[7].x == (-2))
            {
                _5703 = 0.0;
                break;
            }
            if (_668[7].y == 2)
            {
                _5703 = 0.0;
                break;
            }
            if (_668[7].y == (-2))
            {
                _5703 = 0.0;
                break;
            }
            _5703 = -1.0;
            break;
        }
        float _2537[8] = float[](_5668, _5673, _5678, _5683, _5688, _5693, _5698, _5703);
        if (max(abs((_2537[0] - _2430) - (_2430 - _2537[1])), abs((_2537[2] - _2430) - (_2430 - _2537[3]))) <= 1.9999999494757503271102905273438e-05)
        {
            if (max(abs((_2537[4] - _2430) - (_2430 - _2537[5])), abs((_2537[6] - _2430) - (_2430 - _2537[7]))) <= (1.9999999494757503271102905273438e-05 * length(vec2(_668[4]))))
            {
                _6001 = _1558;
                _5793 = 0;
                _5766 = _2532;
                _5730 = _1576;
                break;
            }
        }
        int _5705;
        float _5724;
        ivec2 _5725;
        float _6021;
        _5725 = _1576;
        _5724 = _2430;
        _5705 = 0;
        _6021 = _1558;
        bool _2652;
        float _6023;
        float _6217;
        ivec2 _6219;
        for (int _5704 = 0; _5704 < 8; _5725 = _6219, _5724 = _6217, _5705 = _2652 ? 32768 : _5705, _5704++, _6021 = _6023)
        {
            _2652 = abs(floatBitsToInt(_2537[_5704]) - floatBitsToInt(_2430)) > int(_415._TAA._fContourDepthThreshold * length(vec2(_668[_5704])));
            if (_2652)
            {
                bool _2661 = _2537[_5704] > _5724;
                ivec2 _6220;
                if (_2661)
                {
                    ivec2 _2669 = _1576 + _668[_5704];
                    _6220 = ivec2(clamp(_2669.x, _415._TAA._viViewportOrigin_Size.x, _415._TAA._viViewportTopLeftMinusOne.x), clamp(_2669.y, _415._TAA._viViewportOrigin_Size.y, _415._TAA._viViewportTopLeftMinusOne.y));
                }
                else
                {
                    _6220 = _5725;
                }
                _6219 = _6220;
                _6217 = _2661 ? _2537[_5704] : _5724;
                _6023 = (!_1561) ? 1.0 : _6021;
            }
            else
            {
                _6219 = _5725;
                _6217 = _5724;
                _6023 = _6021;
            }
        }
        if (_5705 != 0)
        {
            _6001 = _6021;
            _5793 = _5705;
            _5766 = _415._TAA._vfProjSetup.y / (_5724 + _415._TAA._vfProjSetup.x);
            _5730 = _5725;
            break;
        }
        _6001 = _6021;
        _5793 = _5705;
        _5766 = _2532;
        _5730 = _1576;
        break;
    }
    vec4 _1639 = vec4(fma(float(_1480), _415._TAA._vfPixelToClipSpace.x, _415._TAA._vfPixelToClipSpace.y), fma(float(_1477.y), _415._TAA._vfPixelToClipSpace.z, _415._TAA._vfPixelToClipSpace.w), _2430, 1.0);
    mat4 _1644 = _415._TAA._mSpaceConvMatrices[0].mCurrHSpaceToPrevHSpace_CroppedUV;
    _1644[3].z = 0.0;
    vec4 _1649 = _1644 * _1639;
    float _1652 = _1649.w;
    vec2 _5731;
    if (_1652 <= 0.0)
    {
        _5731 = _1639.xy;
    }
    else
    {
        _5731 = _1649.xy / vec2(_1652);
    }
    mat4 _1669 = _415._TAA._mSpaceConvMatrices[0].mCurrHSpaceToPrevPrevHSpace_CroppedUV;
    _1669[3].z = 0.0;
    vec4 _1674 = _1669 * _1639;
    float _1677 = _1674.w;
    vec2 _5732;
    if (_1677 <= 0.0)
    {
        _5732 = _5731;
    }
    else
    {
        _5732 = _1674.xy / vec2(_1677);
    }
    vec4 _1704 = texelFetch(MotionVectorTex, _5730, 0);
    vec2 _1705 = _1704.xy;
    vec2 _1711 = _415._TAA._vfRenderTargetSize_InvSize.xy * (_1589 - _5731);
    vec2 _1717 = _415._TAA._vfRenderTargetSize_InvSize.xy * _1705;
    vec2 _1723 = _415._TAA._vfRenderTargetSize_InvSize.xy * (_5731 - _5732);
    float _3756 = length(_1717);
    vec2 _1740 = _1589 - _1705;
    vec4 _1745 = textureLod(PrevAADepthTex, _1740, 0.0);
    float _1746 = _1745.x;
    float _3785 = _415._TAA._vfProjSetup.y / (_1746 + _415._TAA._vfProjSetup.x);
    uvec4 _1756 = textureGather(PrevSpeedAndFlagsTex, _1740 * 1.0);
    uint _1767 = _1756.w;
    int _1772 = int((((_1756.x | _1756.y) | _1756.z) | _1767) & 32768u);
    float _1809 = max(_3756, 0.17000000178813934326171875);
    float _1816 = sqrt(max(dot(_1711, _1711), 0.0289000011980533599853515625) * (1.0 / max(dot(_1723, _1723), 0.0289000011980533599853515625))) * max(unpackHalf2x16(_1767 & 32767u).x, 0.17000000178813934326171875);
    float _1828 = clamp(abs(_1809 - _1816) * (1.0 / max(max(0.100000001490116119384765625, _1816), _1809)), 0.0, 1.0);
    float _5789;
    if (_1828 >= 0.1500000059604644775390625)
    {
        _5789 = _415._TAA._fHistoryBlendFactor * (1.0 - pow(_1828, 4.0));
    }
    else
    {
        _5789 = _415._TAA._fHistoryBlendFactor;
    }
    float _6047;
    if (_3756 > min((abs(_5766) * _415._TAA._vfProjSetup.w) * 0.1500000059604644775390625, 2.5))
    {
        float _3804 = _415._TAA._vfProjSetup.y / ((_1649.z / _1652) + _415._TAA._vfProjSetup.x);
        float _6048;
        if ((_5789 != 0.0) && (_5793 == 0))
        {
            _6048 = ((abs(_3804 - _3785) / max(9.9999997473787516355514526367188e-06, max(_3804, _3785))) > _415._TAA._fDisocclusionDepthThreshold) ? 0.0 : _5789;
        }
        else
        {
            _6048 = _5789;
        }
        _6047 = _6048;
    }
    else
    {
        _6047 = _5789;
    }
    bool _1893 = _5793 == 0;
    float _6046;
    if (_1893 && (_1772 != 0))
    {
        _6046 = (_3756 > 1.0) ? 0.0 : _6047;
    }
    else
    {
        _6046 = _6047;
    }
    float _1906 = abs(_1717.x);
    float _1907 = min(1.0, _1906);
    float _1911 = abs(_1717.y);
    float _1912 = min(1.0, _1911);
    bool _5833;
    for (;;)
    {
        vec2 _3828 = _415._TAA._vfRenderTargetSize_InvSize.xy * _1740;
        float _3830 = _3828.x;
        bool _3836 = _3830 < (_415._TAA._vfViewportOrigin_TopLeftUpsampled.x + _1907);
        bool _3848;
        if (!_3836)
        {
            _3848 = _3828.y < (_415._TAA._vfViewportOrigin_TopLeftUpsampled.y + _1912);
        }
        else
        {
            _3848 = _3836;
        }
        bool _3860;
        if (!_3848)
        {
            _3860 = _3830 > (_415._TAA._vfViewportOrigin_TopLeftUpsampled.z - _1907);
        }
        else
        {
            _3860 = _3848;
        }
        bool _3872;
        if (!_3860)
        {
            _3872 = _3828.y > (_415._TAA._vfViewportOrigin_TopLeftUpsampled.w - _1912);
        }
        else
        {
            _3872 = _3860;
        }
        if (_3872)
        {
            _5833 = false;
            break;
        }
        _5833 = true;
        break;
    }
    bool _1919 = !_5833;
    float _6228 = _1919 ? 0.0 : _6046;
    float _3900 = _2355.z;
    float _4025 = _2355.x;
    float _4141 = _2362.z;
    float _4230 = _2362.x;
    bool _1980 = !_1492;
    if (_1980)
    {
        imageStore(OutAADepth, _1571, vec4(mix(clamp(_1746, min(min(min(min(_2430, _3900), _4025), _4141), _4230), max(max(max(max(_2430, _3900), _4025), _4141), _4230)), _2430, 0.1500000059604644775390625), 0.0, 0.0, 0.0));
    }
    sharedDepth[gl_LocalInvocationIndex] = _5766;
    barrier();
    memoryBarrierShared();
    float _6092;
    if ((_6001 != 1.0) && (!_1561))
    {
        _6092 = mix(_6001, 1.0, clamp(max(abs(sharedDepth[gl_LocalInvocationIndex | 1u] - sharedDepth[gl_LocalInvocationIndex & 4294967294u]), abs(sharedDepth[gl_LocalInvocationIndex | 8u] - sharedDepth[gl_LocalInvocationIndex & 4294967287u])) * _415._TAA._fRainSlopeDampingFactor, 0.0, 1.0));
    }
    else
    {
        _6092 = _6001;
    }
    bool _2036 = (_1552 & 64) != 0;
    float _6104;
    if (_2036)
    {
        sharedMotionVec[gl_LocalInvocationIndex] = _1705;
        barrier();
        memoryBarrierShared();
        uint _4359 = gl_LocalInvocationIndex & 54u;
        uint _4360 = _4359 | 0u;
        vec2 _4385 = sharedMotionVec[_4359 | 1u] + vec2(_415._TAA._vfRenderTargetSize_InvSize.z, 0.0);
        vec2 _4391 = sharedMotionVec[_4359 | 8u] + vec2(0.0, _415._TAA._vfRenderTargetSize_InvSize.w);
        vec2 _4399 = sharedMotionVec[_4359 | 9u] + vec2(_415._TAA._vfRenderTargetSize_InvSize.zw);
        vec2 _4426 = (max(max(max(sharedMotionVec[_4360], _4385), _4391), _4399) - min(min(min(sharedMotionVec[_4360], _4385), _4391), _4399)) * _415._TAA._vfRenderTargetSize_InvSize.xy;
        _6104 = _4426.x * _4426.y;
    }
    else
    {
        _6104 = 0.0;
    }
    vec3 _6122;
    if (_6228 < 0.100000001490116119384765625)
    {
        vec3 HDRSample[9];
        HDRSample[0] = texelFetch(CurrColorTex, _1576 + _2055[0], 0).xyz;
        for (int _6119 = 1; _6119 < 9; )
        {
            ivec2 _2097 = _1576 + _2055[_6119];
            HDRSample[_6119] = texelFetch(CurrColorTex, ivec2(clamp(_2097.x, _415._TAA._viViewportOrigin_Size.x, _415._TAA._viViewportTopLeftMinusOne.x), clamp(_2097.y, _415._TAA._viViewportOrigin_Size.y, _415._TAA._viViewportTopLeftMinusOne.y)), 0).xyz;
            _6119++;
            continue;
        }
        vec3 _6121;
        _6121 = vec3(0.0);
        for (int _6120 = 0; _6120 < 9; )
        {
            float _5233 = max(0.001000000047497451305389404296875, _1604);
            _6121 += (HDRSample[_6120] * (_5233 * (1.0 / (1.0 + (max(max(HDRSample[_6120].x, HDRSample[_6120].y), HDRSample[_6120].z) * _5233)))));
            _6120++;
            continue;
        }
        _6122 = _6121 * 0.111111111938953399658203125;
    }
    else
    {
        vec3 _2139 = texelFetch(CurrColorTex, _1576, 0).xyz;
        vec3 _4517 = textureLod(PrevColorTex, _1740, 0.0).xyz * _415._TAA._fPreviousFrameExposureCompensation;
        ivec2 _4835 = _1576 + ivec2(1);
        vec3 _4841 = texelFetch(CurrColorTex, ivec2(clamp(_4835.x, _415._TAA._viViewportOrigin_Size.x, _415._TAA._viViewportTopLeftMinusOne.x), clamp(_4835.y, _415._TAA._viViewportOrigin_Size.y, _415._TAA._viViewportTopLeftMinusOne.y)), 0).xyz;
        vec3 _4871 = texelFetch(CurrColorTex, _2398, 0).xyz;
        ivec2 _4895 = _1576 + ivec2(-1);
        vec3 _4901 = texelFetch(CurrColorTex, ivec2(clamp(_4895.x, _415._TAA._viViewportOrigin_Size.x, _415._TAA._viViewportTopLeftMinusOne.x), clamp(_4895.y, _415._TAA._viViewportOrigin_Size.y, _415._TAA._viViewportTopLeftMinusOne.y)), 0).xyz;
        vec3 _4931 = texelFetch(CurrColorTex, _2414, 0).xyz;
        vec3 _6073;
        if ((_5793 & _1772) == 0)
        {
            _6073 = ((((_2139 * _415._TAA._vfDejitterWeights0.x) + (_4841 * _415._TAA._vfDejitterWeights0.y)) + (_4871 * _415._TAA._vfDejitterWeights0.z)) + (_4901 * _415._TAA._vfDejitterWeights0.w)) + (_4931 * _415._TAA._vfDejitterWeights1.x);
        }
        else
        {
            _6073 = _2139;
        }
        vec3 _4607 = min(min(min(_4841, _4871), _4901), _4931);
        vec3 _4618 = max(max(max(_4841, _4871), _4901), _4931);
        vec3 _6078;
        if (_1561)
        {
            _6078 = clamp(_6073, _4607, _4618);
        }
        else
        {
            _6078 = _6073;
        }
        vec3 _4629 = min(_2139, _4607);
        vec3 _4633 = max(_2139, _4618);
        float _4962 = max(0.001000000047497451305389404296875, _1604);
        vec3 _4637 = _4517.xyz;
        vec3 _4985 = clamp(_4637, _4629, _4633);
        float _4644 = _4517.x;
        float _4650 = _4517.y;
        float _4657 = _4517.z;
        vec3 _6079;
        vec3 _6080;
        if (min(min(abs(_4985.x - _4644), abs(_4985.y - _4650)), abs(_4985.z - _4657)) > 0.004999999888241291046142578125)
        {
            ivec2 _4992 = _1576 + ivec2(1, 0);
            vec3 _4998 = texelFetch(CurrColorTex, ivec2(clamp(_4992.x, _415._TAA._viViewportOrigin_Size.x, _415._TAA._viViewportTopLeftMinusOne.x), clamp(_4992.y, _415._TAA._viViewportOrigin_Size.y, _415._TAA._viViewportTopLeftMinusOne.y)), 0).xyz;
            ivec2 _5022 = _1576 + ivec2(-1, 0);
            vec3 _5028 = texelFetch(CurrColorTex, ivec2(clamp(_5022.x, _415._TAA._viViewportOrigin_Size.x, _415._TAA._viViewportTopLeftMinusOne.x), clamp(_5022.y, _415._TAA._viViewportOrigin_Size.y, _415._TAA._viViewportTopLeftMinusOne.y)), 0).xyz;
            ivec2 _5052 = _1576 + ivec2(0, 1);
            vec3 _5058 = texelFetch(CurrColorTex, ivec2(clamp(_5052.x, _415._TAA._viViewportOrigin_Size.x, _415._TAA._viViewportTopLeftMinusOne.x), clamp(_5052.y, _415._TAA._viViewportOrigin_Size.y, _415._TAA._viViewportTopLeftMinusOne.y)), 0).xyz;
            ivec2 _5082 = _1576 + ivec2(0, -1);
            vec3 _5088 = texelFetch(CurrColorTex, ivec2(clamp(_5082.x, _415._TAA._viViewportOrigin_Size.x, _415._TAA._viViewportTopLeftMinusOne.x), clamp(_5082.y, _415._TAA._viViewportOrigin_Size.y, _415._TAA._viViewportTopLeftMinusOne.y)), 0).xyz;
            _6080 = max(max(max(max(_4998, _5028), _5058), _5088), _4633);
            _6079 = min(min(min(min(_4998, _5028), _5058), _5088), _4629);
        }
        else
        {
            _6080 = _4633;
            _6079 = _4629;
        }
        float _5121 = 1.0 - (1.0 / fma(max(max(_6079.x, _6079.y), _6079.z), _1604, 1.0));
        float _5140 = 1.0 - (1.0 / fma(max(max(_6080.x, _6080.y), _6080.z), _1604, 1.0));
        float _5159 = 1.0 - (1.0 / fma(max(max(_4644, _4650), _4657), _1604, 1.0));
        float _6086;
        if (_6228 > 0.100000001490116119384765625)
        {
            float _4742 = 1.0 - _6228;
            float _4751 = min(abs(_5121 - _5159), abs(_5140 - _5159));
            float _4756 = (_4751 * _4742) + _4742;
            float _4766 = clamp((_1906 + _1911) * 2.0, 0.0, 1.0);
            _6086 = clamp(1.0 - clamp(((_5159 * _4756) * (1.0 + ((_4766 * _4756) * 4.0))) * (1.0 / (_4751 + (_5140 - _5121))), 0.0, 1.0), mix(0.60000002384185791015625, 0.5, _4766), 0.9900000095367431640625);
        }
        else
        {
            _6086 = _6228;
        }
        vec3 _5175 = clamp(_4637, _6079, _6080);
        float _2178 = _6086 * _6092;
        float _6093;
        if (_1561)
        {
            _6093 = _2178 * 0.5555555820465087890625;
        }
        else
        {
            _6093 = _2178;
        }
        float _6116;
        if (_2036)
        {
            float _6117;
            if (_6093 != 0.0)
            {
                float _6118;
                if (_1893 && (_1772 == 0))
                {
                    float _6105;
                    if (_6104 <= 1.0)
                    {
                        _6105 = _6093 * clamp(1.0 - (16.0 * (1.0 - _6104)), 0.0, 1.0);
                    }
                    else
                    {
                        _6105 = _6093 / ((16.0 * (_6104 - 1.0)) + 1.0);
                    }
                    _6118 = clamp(_6105, 0.0, 1.0);
                }
                else
                {
                    _6118 = _6093;
                }
                _6117 = _6118;
            }
            else
            {
                _6117 = _6093;
            }
            _6116 = _6117;
        }
        else
        {
            _6116 = _6093;
        }
        _6122 = mix(_6078 * (_4962 * (1.0 / (1.0 + (max(max(_6078.x, _6078.y), _6078.z) * _4962)))), _5175 * (_4962 * (1.0 / (1.0 + (max(max(_5175.x, _5175.y), _5175.z) * _4962)))), vec3(_6116));
    }
    vec3 _5266 = _6122 * (1.0 / (max(0.001000000047497451305389404296875, _1604) * (1.0 - max(max(_6122.x, _6122.y), _6122.z))));
    vec4 _2238 = vec4(_5266.x, _5266.y, _5266.z, _5658.w);
    _2238.w = 1.0;
    if (_1980)
    {
        vec3 _5283 = max(vec3(0.0), _2238.xyz);
        float _5285 = _5283.x;
        float _5287 = _5283.y;
        float _5290 = _5283.z;
        int _5296 = max(931135488, (floatBitsToInt(max(max(_5285, _5287), _5290)) & 2139095040));
        float _5301 = uintBitsToFloat(uint(_5296 + 125829120));
        // Native Render Debug uses this exact TAA output as the normal image
        // outside temporal panels. In DLAA mode b16 is still owned by the
        // later adapter pack, and the scene pass reports temporal panels as
        // unavailable instead of interfering with that output.
        if (!RenderDebugTemporalUnavailable()
            && RenderDebugAnySourceAtPass(RENDER_DEBUG_PASS_TEMPORAL)
            && RenderDebugPushPayloadFinite())
        {
            ivec2 debugPixel = _1477;
            ivec2 debugSize = _415._TAA._viViewportOrigin_Size.zw;
            uint debugSource = RenderDebugSourceAtPixel(
                debugPixel, debugSize);
            vec3 debugOutput = _5266;
            if (RenderDebugGenerateAtPass(
                debugSource, RENDER_DEBUG_PASS_TEMPORAL))
            {
                vec4 debugValue = vec4(0.0);
                if (debugSource == RENDER_DEBUG_SOURCE_TAA_DEPTH)
                {
                    debugValue = vec4(vec3(_2532), 1.0);
                }
                else if (debugSource == RENDER_DEBUG_SOURCE_TAA_MOTION)
                {
                    debugValue = vec4(_1717 / vec2(32.0), 0.0, 1.0);
                }
                else if (debugSource == RENDER_DEBUG_SOURCE_TAA_HISTORY)
                {
                    debugValue = vec4(
                        textureLod(PrevColorTex, _1740, 0.0).xyz
                            * _415._TAA._fPreviousFrameExposureCompensation,
                        1.0);
                }
                debugOutput = RenderDebugBlend(
                    _5266,
                    RenderDebugMap(debugValue, debugSource));
            }
            imageStore(
                OutColorPass,
                _1571,
                uvec4(PackRenderDebugRgb9e5(debugOutput), 0u, 0u, 0u));
        }
    }
    if (_1980)
    {
        imageStore(OutPrevSpeedAndFlagsTex, _1576, uvec4(packHalf2x16(vec2(_3756, 0.0)) | uint(_5793), 0u, 0u, 0u));
    }
    int _2279 = subgroupShuffleXor(_5793, 1u);
    int _2280 = _5793 | _2279;
    int _2283 = subgroupShuffleXor(_2280, 8u);
    if ((((_1571.x | _1571.y) & 1) == 0) && _1980)
    {
        imageStore(HalfResContours, _1571 >> ivec2(1), uvec4(uint(((_2280 | _2283) != 0) ? 255 : 0), 0u, 0u, 0u));
    }
}
