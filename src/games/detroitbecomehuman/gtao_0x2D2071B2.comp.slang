// Copyright (C) 2016-2021, Intel Corporation
// SPDX-License-Identifier: MIT
//
// XeGTAO-derived horizon integration adapted to Detroit: Become Human's
// native HBAO resource contract. Based on GameTechDev/XeGTAO and
// "Practical Real-Time Strategies for Accurate Indirect Occlusion".

#version 450
#extension GL_EXT_samplerless_texture_functions : require

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

const float GTAO_PI = 3.14159265358979323846;
const float GTAO_HALF_PI = 1.57079632679489661923;
// Detroit already supplies its scene-tuned world-space HBAO radius. Applying
// XeGTAO's independently auto-tuned 1.457 multiplier a second time produces
// broad, screen-like darkening, so preserve the engine radius here.
const float GTAO_RADIUS_MULTIPLIER = 1.0;
const float GTAO_FALLOFF_RANGE = 0.615;
const float GTAO_SAMPLE_DISTRIBUTION_POWER = 2.0;
// The native lighting pass is authored around an occlusion amount, not the
// standalone XeGTAO sample's display curve. Keep the physically integrated
// visibility linear before converting it to Detroit's 0=open AO convention.
const float GTAO_FINAL_VALUE_POWER = 1.0;
const float GTAO_THIN_OCCLUDER_COMPENSATION = 0.25;
const float GTAO_GOLDEN_RATIO = 0.6180339887498948482;
const int GTAO_SLICE_COUNT = 3;
const int GTAO_STEPS_PER_SLICE = 3; // Paired +/- samples: 3 * 3 * 2 = 18 taps.

const ivec2 QUAD_OFFSETS[4] = ivec2[](
    ivec2(0, 0),
    ivec2(1, 0),
    ivec2(1, 1),
    ivec2(0, 1));

struct POST_PROCESSING_HBAO_COMPUTE_CONSTANT_BUFFER
{
    vec4 _vfProjSetup;
    vec4 _vfProjCoef;
    vec4 _vfScreenRatio;
    ivec4 _viNeoScale;
    float _fDefRadius;
    float _fDefNegInvSqrRadius;
    float _fDefSqrRadius;
    float _fDefMaxRadiusPixel;
    float _fDefAngleBias;
    float _fDefTanAngleBias;
    float _fDefExponent;
    float _fDefContrast;
    vec2 _vfDefFocalLen;
    vec2 _vfDefInvFocalLen;
    vec2 _vfDefResolution;
    vec2 _vfDefInvResolution;
    vec2 _vfDefAOResolution;
    vec2 _vfDefAOInvResolution;
    vec2 _vfDefAORealResolution;
    float _fUpsamplingFactor;
    float _fDefHQDistance;
    float _fFrameIndex;
    float _fMaxRadiusMip0Squared;
    float _fMaxRadiusMip1Squared;
    int _iPadding0;
    int _iMouseX;
    int _iMouseY;
    int _iPadding1;
    int _iPadding2;
};

layout(set = 0, binding = 52, std140) uniform dyn_CONSTANT_BUFFER_BLOCK_0
{
    POST_PROCESSING_HBAO_COMPUTE_CONSTANT_BUFFER g_cbHBAO;
} _gtao;

layout(set = 0, binding = 0) uniform sampler2D sDepthBuffer;
layout(set = 0, binding = 2) uniform sampler2D sDepthBufferLowRes;
layout(set = 0, binding = 3) uniform sampler2D sBlueNoise;
layout(set = 0, binding = 16, r16ui) uniform writeonly uimage2D PackedDepthAndAO;
layout(set = 0, binding = 17, r8ui) uniform writeonly uimage2D OutputTileTexture;

// Private set injected by the add-on. These resources remove Detroit's
// three-bit AO intermediary from temporal accumulation while preserving the
// native packed output for downstream compatibility and safe fallback.
layout(set = 1, binding = 0) Texture2D<float2> GtaoMotionVectors;
layout(set = 1, binding = 1) Texture2D<float> PreviousAoHistory;
layout(set = 1, binding = 2) Texture2D<float> PreviousDepthHistory;
layout(set = 1, binding = 3) Texture2D<uint> GtaoNormalRoughness;
layout(set = 1, binding = 16, r16f) uniform writeonly image2D CurrentAoHistory;
layout(set = 1, binding = 17, r32f) uniform writeonly image2D CurrentDepthHistory;

// Detroit's resolve uses this as a coarse background/geometry mask. Preserve
// that contract independently from the actual (possibly quantized-to-zero) AO.
shared uint tile_has_geometry;

vec2 ClampDepthUv(vec2 uv)
{
    vec2 edge = max(_gtao.g_cbHBAO._vfDefInvResolution * 0.5, vec2(1.0e-7));
    return clamp(uv, edge, vec2(1.0) - edge);
}

float LinearizeDepth(float hardware_depth)
{
    float denominator = hardware_depth + _gtao.g_cbHBAO._vfProjSetup.x;
    if (abs(denominator) < 1.0e-8)
        denominator = denominator < 0.0 ? -1.0e-8 : 1.0e-8;
    return (_gtao.g_cbHBAO._vfProjSetup.y / denominator)
        * _gtao.g_cbHBAO._vfProjCoef.z;
}

float LoadFullResolutionViewDepth(vec2 uv)
{
    return LinearizeDepth(textureLod(sDepthBuffer, ClampDepthUv(uv), 0.0).x);
}

float LoadSampleViewDepth(vec2 uv, float pixel_distance_squared)
{
    uv = ClampDepthUv(uv);
    // Dishonored 2 explicitly builds a view-depth mip chain before GTAO.
    // Detroit already exposes its native prefiltered linear view depth at b2;
    // preserve the exact HBAO thresholds and scale for distant horizon taps.
    if (pixel_distance_squared >= _gtao.g_cbHBAO._fMaxRadiusMip0Squared)
    {
        float mip = pixel_distance_squared
                >= _gtao.g_cbHBAO._fMaxRadiusMip1Squared
            ? 1.0
            : 0.0;
        return textureLod(sDepthBufferLowRes, uv, mip).x
            * _gtao.g_cbHBAO._vfProjCoef.z;
    }
    return LinearizeDepth(textureLod(sDepthBuffer, uv, 0.0).x);
}

vec3 ReconstructViewPosition(vec2 uv, float view_depth)
{
    vec2 ndc = uv * 2.0 - vec2(1.0);
    vec2 xy = ndc * (vec2(view_depth) * _gtao.g_cbHBAO._vfProjCoef.xy);
    return vec3(xy, view_depth);
}

vec4 CalculateDepthEdges(
    float center_depth,
    float left_depth,
    float right_depth,
    float top_depth,
    float bottom_depth)
{
    vec4 edges = vec4(
        left_depth,
        right_depth,
        top_depth,
        bottom_depth) - vec4(center_depth);
    float slope_lr = (edges.y - edges.x) * 0.5;
    float slope_tb = (edges.w - edges.z) * 0.5;
    vec4 slope_adjusted = edges
        + vec4(slope_lr, -slope_lr, slope_tb, -slope_tb);
    edges = min(abs(edges), abs(slope_adjusted));
    float scale_depth = max(abs(center_depth), 1.0e-4);
    return clamp(vec4(1.25) - edges / (scale_depth * 0.011), 0.0, 1.0);
}

vec3 ReconstructViewNormalFromDepth(vec2 uv, vec3 center_position)
{
    vec2 texel = _gtao.g_cbHBAO._vfDefInvResolution;
    float left_depth = LoadFullResolutionViewDepth(uv - vec2(texel.x, 0.0));
    float right_depth = LoadFullResolutionViewDepth(uv + vec2(texel.x, 0.0));
    float top_depth = LoadFullResolutionViewDepth(uv - vec2(0.0, texel.y));
    float bottom_depth = LoadFullResolutionViewDepth(uv + vec2(0.0, texel.y));
    vec3 left = ReconstructViewPosition(
        uv - vec2(texel.x, 0.0),
        left_depth);
    vec3 right = ReconstructViewPosition(
        uv + vec2(texel.x, 0.0),
        right_depth);
    vec3 top = ReconstructViewPosition(
        uv - vec2(0.0, texel.y),
        top_depth);
    vec3 bottom = ReconstructViewPosition(
        uv + vec2(0.0, texel.y),
        bottom_depth);

    vec4 edges = CalculateDepthEdges(
        center_position.z,
        left_depth,
        right_depth,
        top_depth,
        bottom_depth);
    vec4 weights = max(
        vec4(
            edges.x * edges.z,
            edges.z * edges.y,
            edges.y * edges.w,
            edges.w * edges.x),
        vec4(1.0e-6));
    vec3 delta_left = normalize(left - center_position);
    vec3 delta_right = normalize(right - center_position);
    vec3 delta_top = normalize(top - center_position);
    vec3 delta_bottom = normalize(bottom - center_position);
    vec3 normal_sum =
        weights.x * cross(delta_left, delta_top)
        + weights.y * cross(delta_top, delta_right)
        + weights.z * cross(delta_right, delta_bottom)
        + weights.w * cross(delta_bottom, delta_left);
    vec3 view_vector = normalize(-center_position);
    float normal_length_squared = dot(normal_sum, normal_sum);
    if (normal_length_squared < 1.0e-10
        || isnan(normal_length_squared)
        || isinf(normal_length_squared))
        return view_vector;
    vec3 normal = normal_sum * inversesqrt(normal_length_squared);
    return dot(normal, view_vector) < 0.0 ? -normal : normal;
}

bool LoadNativeViewNormal(vec2 uv, out vec3 view_normal)
{
    view_normal = vec3(0.0, 0.0, 1.0);
    uint normal_width;
    uint normal_height;
    GtaoNormalRoughness.GetDimensions(normal_width, normal_height);
    ivec2 normal_size = ivec2(normal_width, normal_height);
    if (any(lessThanEqual(normal_size, ivec2(0))))
        return false;

    ivec2 normal_pixel = clamp(
        ivec2(uv * vec2(normal_size)),
        ivec2(0),
        normal_size - ivec2(1));
    uint packed = GtaoNormalRoughness.Load(int3(normal_pixel, 0));
    if ((packed & 0xC0000000u) == 0u)
        return false;

    vec2 encoded = vec2(
        float((packed >> 0u) & 32767u),
        float((packed >> 15u) & 32767u));
    encoded = encoded * (1.0 / 32767.0) * 3.5554 - vec2(1.7777);
    vec3 sphere = vec3(encoded, 1.0);
    float inverse_length = 2.0 / max(dot(sphere, sphere), 1.0e-8);
    view_normal = normalize(vec3(
        sphere.xy * inverse_length,
        inverse_length - 1.0));
    return !any(isnan(view_normal)) && !any(isinf(view_normal));
}

float LoadNoise(ivec2 pixel, ivec2 offset)
{
    ivec2 noise_size = max(textureSize(sBlueNoise, 0), ivec2(1));
    ivec2 coordinate = (pixel + offset) % noise_size;
    coordinate = (coordinate + noise_size) % noise_size;
    return texelFetch(sBlueNoise, coordinate, 0).x;
}

float EvaluateGtao(vec2 uv, ivec2 source_pixel, out float center_view_depth)
{
    center_view_depth = LoadFullResolutionViewDepth(uv);
    if (isnan(center_view_depth) || isinf(center_view_depth)
        || abs(center_view_depth) < 1.0e-5)
        return 0.0;

    vec3 unbiased_center = ReconstructViewPosition(uv, center_view_depth);
    vec3 view_normal;
    if (!LoadNativeViewNormal(uv, view_normal))
        view_normal = ReconstructViewNormalFromDepth(uv, unbiased_center);
    // Bias only the horizon-search origin. The unmodified depth must remain in
    // center_view_depth because Detroit's following pass decodes it from the
    // lower 13 bits of PackedDepthAndAO.
    float biased_center_depth = center_view_depth * 0.99999;
    vec3 center_position = ReconstructViewPosition(uv, biased_center_depth);
    vec3 view_vector = normalize(-center_position);

    float effect_radius = max(
        abs(_gtao.g_cbHBAO._fDefRadius) * GTAO_RADIUS_MULTIPLIER,
        1.0e-4);
    float screen_radius = effect_radius
        * abs(_gtao.g_cbHBAO._vfDefFocalLen.y)
        / max(abs(center_view_depth), 1.0e-4);
    screen_radius = min(screen_radius, max(_gtao.g_cbHBAO._fDefMaxRadiusPixel, 1.0));

    if (screen_radius < 1.0)
        return 0.0;

    float falloff_range = max(GTAO_FALLOFF_RANGE * effect_radius, 1.0e-5);
    float falloff_from = effect_radius * (1.0 - GTAO_FALLOFF_RANGE);
    float falloff_mul = -1.0 / falloff_range;
    float falloff_add = falloff_from / falloff_range + 1.0;
    float min_sample_fraction = 1.3 / screen_radius;

    float noise_slice = fract(
        LoadNoise(source_pixel, ivec2(7, 7))
        + _gtao.g_cbHBAO._fFrameIndex * 0.3125);
    float noise_sample = fract(
        LoadNoise(source_pixel, ivec2(0, 0))
        + _gtao.g_cbHBAO._fFrameIndex * 0.0625);

    float visibility = clamp((10.0 - screen_radius) / 100.0, 0.0, 1.0) * 0.5;
    for (int slice = 0; slice < GTAO_SLICE_COUNT; ++slice)
    {
        float phi = (float(slice) + noise_slice)
            * (GTAO_PI / float(GTAO_SLICE_COUNT));
        float cos_phi = cos(phi);
        float sin_phi = sin(phi);
        vec2 omega = vec2(cos_phi, -sin_phi) * screen_radius;
        vec3 direction_vector = vec3(cos_phi, sin_phi, 0.0);
        vec3 ortho_direction = direction_vector
            - dot(direction_vector, view_vector) * view_vector;
        float ortho_length_squared = dot(ortho_direction, ortho_direction);
        if (ortho_length_squared < 1.0e-8)
        {
            visibility += 1.0;
            continue;
        }

        vec3 axis_vector = normalize(cross(ortho_direction, view_vector));
        vec3 projected_normal = view_normal
            - axis_vector * dot(view_normal, axis_vector);
        float projected_length = length(projected_normal);
        if (projected_length < 1.0e-5)
        {
            visibility += 1.0;
            continue;
        }

        float sign_normal = dot(ortho_direction, projected_normal) >= 0.0
            ? 1.0
            : -1.0;
        float cos_normal = clamp(
            dot(projected_normal, view_vector) / projected_length,
            0.0,
            1.0);
        float normal_angle = sign_normal * acos(cos_normal);
        float low_horizon_cos_0 = cos(normal_angle + GTAO_HALF_PI);
        float low_horizon_cos_1 = cos(normal_angle - GTAO_HALF_PI);
        float horizon_cos_0 = low_horizon_cos_0;
        float horizon_cos_1 = low_horizon_cos_1;

        for (int step_index = 0; step_index < GTAO_STEPS_PER_SLICE; ++step_index)
        {
            float sequence = float(slice + step_index * GTAO_STEPS_PER_SLICE)
                * GTAO_GOLDEN_RATIO;
            float step_noise = fract(noise_sample + sequence);
            float sample_fraction = (
                float(step_index) + step_noise)
                / float(GTAO_STEPS_PER_SLICE);
            sample_fraction = pow(
                sample_fraction,
                GTAO_SAMPLE_DISTRIBUTION_POWER);
            sample_fraction += min_sample_fraction;

            vec2 offset_pixels = round(sample_fraction * omega);
            float offset_squared = dot(offset_pixels, offset_pixels);
            if (offset_squared < 0.5)
                continue;

            vec2 offset_uv = offset_pixels
                * _gtao.g_cbHBAO._vfDefAOInvResolution;
            vec2 sample_uv_0 = ClampDepthUv(uv + offset_uv);
            vec2 sample_uv_1 = ClampDepthUv(uv - offset_uv);
            vec3 sample_position_0 = ReconstructViewPosition(
                sample_uv_0,
                LoadSampleViewDepth(sample_uv_0, offset_squared));
            vec3 sample_position_1 = ReconstructViewPosition(
                sample_uv_1,
                LoadSampleViewDepth(sample_uv_1, offset_squared));
            vec3 sample_delta_0 = sample_position_0 - center_position;
            vec3 sample_delta_1 = sample_position_1 - center_position;
            float sample_distance_0 = length(sample_delta_0);
            float sample_distance_1 = length(sample_delta_1);

            if (sample_distance_0 > 1.0e-5)
            {
                float falloff_distance_0 = length(vec3(
                    sample_delta_0.xy,
                    sample_delta_0.z
                        * (1.0 + GTAO_THIN_OCCLUDER_COMPENSATION)));
                float weight_0 = clamp(
                    falloff_distance_0 * falloff_mul + falloff_add,
                    0.0,
                    1.0);
                float sample_horizon_0 = dot(
                    sample_delta_0 / sample_distance_0,
                    view_vector);
                sample_horizon_0 = mix(
                    low_horizon_cos_0,
                    sample_horizon_0,
                    weight_0);
                horizon_cos_0 = max(horizon_cos_0, sample_horizon_0);
            }
            if (sample_distance_1 > 1.0e-5)
            {
                float falloff_distance_1 = length(vec3(
                    sample_delta_1.xy,
                    sample_delta_1.z
                        * (1.0 + GTAO_THIN_OCCLUDER_COMPENSATION)));
                float weight_1 = clamp(
                    falloff_distance_1 * falloff_mul + falloff_add,
                    0.0,
                    1.0);
                float sample_horizon_1 = dot(
                    sample_delta_1 / sample_distance_1,
                    view_vector);
                sample_horizon_1 = mix(
                    low_horizon_cos_1,
                    sample_horizon_1,
                    weight_1);
                horizon_cos_1 = max(horizon_cos_1, sample_horizon_1);
            }
        }

        projected_length = mix(projected_length, 1.0, 0.05);
        float horizon_0 = -acos(clamp(horizon_cos_1, -1.0, 1.0));
        float horizon_1 = acos(clamp(horizon_cos_0, -1.0, 1.0));
        float integral_0 = (
            cos_normal
            + 2.0 * horizon_0 * sin(normal_angle)
            - cos(2.0 * horizon_0 - normal_angle)) * 0.25;
        float integral_1 = (
            cos_normal
            + 2.0 * horizon_1 * sin(normal_angle)
            - cos(2.0 * horizon_1 - normal_angle)) * 0.25;
        // XeGTAO intentionally lets the per-slice visibility overshoot 1.0.
        // The overshoot compensates darker slices before the final average;
        // clamping here creates a systematic dark bias on open surfaces.
        visibility += projected_length * (integral_0 + integral_1);
    }

    visibility = max(visibility / float(GTAO_SLICE_COUNT), 0.0);
    visibility = max(0.03, pow(visibility, GTAO_FINAL_VALUE_POWER));
    return clamp(1.0 - visibility, 0.0, 1.0);
}

float LoadPreviousAoBilinear(vec2 previous_uv, ivec2 history_size)
{
    vec2 position = previous_uv * vec2(history_size) - vec2(0.5);
    ivec2 base = ivec2(floor(position));
    vec2 fraction = fract(position);
    ivec2 maximum = history_size - ivec2(1);
    ivec2 p00 = clamp(base, ivec2(0), maximum);
    ivec2 p10 = clamp(base + ivec2(1, 0), ivec2(0), maximum);
    ivec2 p01 = clamp(base + ivec2(0, 1), ivec2(0), maximum);
    ivec2 p11 = clamp(base + ivec2(1, 1), ivec2(0), maximum);
    float row0 = mix(
        PreviousAoHistory.Load(int3(p00, 0)),
        PreviousAoHistory.Load(int3(p10, 0)),
        fraction.x);
    float row1 = mix(
        PreviousAoHistory.Load(int3(p01, 0)),
        PreviousAoHistory.Load(int3(p11, 0)),
        fraction.x);
    return mix(row0, row1, fraction.y);
}

float ResolveTemporalOcclusion(
    ivec2 pixel,
    ivec2 output_size,
    float current_depth,
    float current_occlusion)
{
    uint history_width;
    uint history_height;
    uint depth_history_width;
    uint depth_history_height;
    uint motion_width;
    uint motion_height;
    PreviousAoHistory.GetDimensions(history_width, history_height);
    PreviousDepthHistory.GetDimensions(
        depth_history_width, depth_history_height);
    GtaoMotionVectors.GetDimensions(motion_width, motion_height);
    ivec2 history_size = ivec2(history_width, history_height);
    ivec2 depth_history_size = ivec2(
        depth_history_width, depth_history_height);
    ivec2 motion_size = ivec2(motion_width, motion_height);
    if (any(notEqual(history_size, output_size))
        || any(notEqual(depth_history_size, output_size))
        || any(lessThanEqual(motion_size, ivec2(0))))
        return current_occlusion;

    vec2 current_uv = (vec2(pixel) + vec2(0.5)) / vec2(output_size);
    ivec2 motion_pixel = clamp(
        ivec2(current_uv * vec2(motion_size)),
        ivec2(0),
        motion_size - ivec2(1));
    vec2 motion = GtaoMotionVectors.Load(int3(motion_pixel, 0));
    if (any(isnan(motion)) || any(isinf(motion)))
        return current_occlusion;

    // Exact Detroit TAA contract: previous_uv = current_uv - motion.xy.
    vec2 previous_uv = current_uv - motion;
    if (any(lessThanEqual(previous_uv, vec2(0.0)))
        || any(greaterThanEqual(previous_uv, vec2(1.0))))
        return current_occlusion;

    ivec2 previous_pixel = clamp(
        ivec2(previous_uv * vec2(output_size)),
        ivec2(0),
        output_size - ivec2(1));
    float previous_depth = PreviousDepthHistory.Load(
        int3(previous_pixel, 0));
    if (isnan(previous_depth) || isinf(previous_depth)
        || abs(previous_depth) < 1.0e-5)
        return current_occlusion;

    float depth_threshold = max(0.002, abs(current_depth) * 0.02);
    float depth_error = abs(previous_depth - current_depth);
    if (depth_error >= depth_threshold)
        return current_occlusion;

    float history_occlusion = LoadPreviousAoBilinear(
        previous_uv, history_size);
    if (isnan(history_occlusion) || isinf(history_occlusion))
        return current_occlusion;

    // Neighborhood clipping without an extra pass: limit history to a narrow
    // interval around the current physically evaluated sample. This rejects
    // trails while retaining static sub-pixel contact shadows.
    float clip_radius = mix(
        0.10,
        0.22,
        clamp(length(motion * vec2(output_size)) / 16.0, 0.0, 1.0));
    history_occlusion = clamp(
        history_occlusion,
        max(0.0, current_occlusion - clip_radius),
        min(1.0, current_occlusion + clip_radius));

    float motion_pixels = length(motion * vec2(output_size));
    float motion_factor = clamp(motion_pixels / 16.0, 0.0, 1.0);
    float history_weight = mix(0.92, 0.72, motion_factor);
    history_weight *= 1.0 - smoothstep(
        0.0, depth_threshold, depth_error);
    return mix(current_occlusion, history_occlusion, history_weight);
}

uint PackDepthAndOcclusion(float view_depth, float occlusion, float dither)
{
    uint depth_code = (packHalf2x16(vec2(view_depth * -6.5, 0.0)) >> 2u)
        & 8191u;
    uint ao_code = uint(clamp(floor(occlusion * 7.0 + dither), 0.0, 7.0));
    return depth_code | (ao_code << 13u);
}

void main()
{
    if (gl_LocalInvocationIndex == 0u)
        tile_has_geometry = 0u;
    barrier();

    ivec2 output_size = imageSize(PackedDepthAndAO);
    ivec2 output_base = ivec2(gl_GlobalInvocationID.xy) * 2;
    ivec2 source_base = ivec2(gl_GlobalInvocationID.xy)
        * max(_gtao.g_cbHBAO._viNeoScale.zw, ivec2(1));

    for (int quad_index = 0; quad_index < 4; ++quad_index)
    {
        ivec2 quad_offset = QUAD_OFFSETS[quad_index];
        ivec2 output_pixel = output_base + quad_offset;
        if (any(greaterThanEqual(output_pixel, output_size)))
            continue;

        ivec2 source_pixel = source_base + quad_offset;
        vec2 uv = (vec2(source_base) + vec2(0.5))
            * _gtao.g_cbHBAO._vfDefInvResolution
            + vec2(quad_offset) * _gtao.g_cbHBAO._vfDefAOInvResolution;
        float view_depth;
        float occlusion = EvaluateGtao(uv, source_pixel, view_depth);
        bool history_extent_matches =
            all(equal(imageSize(CurrentAoHistory), output_size))
            && all(equal(imageSize(CurrentDepthHistory), output_size));
        if (history_extent_matches)
        {
            occlusion = ResolveTemporalOcclusion(
                output_pixel, output_size, view_depth, occlusion);
            imageStore(
                CurrentAoHistory,
                output_pixel,
                vec4(occlusion, 0.0, 0.0, 0.0));
            imageStore(
                CurrentDepthHistory,
                output_pixel,
                vec4(view_depth, 0.0, 0.0, 0.0));
        }
        float quantization_noise = fract(
            LoadNoise(source_pixel, ivec2(11, 3))
            + _gtao.g_cbHBAO._fFrameIndex * 0.754877666);
        uint packed = PackDepthAndOcclusion(
            view_depth,
            occlusion,
            quantization_noise);
        imageStore(PackedDepthAndAO, output_pixel, uvec4(packed, 0u, 0u, 0u));
        if ((packed & 8191u) != 0u)
            atomicOr(tile_has_geometry, 1u);
    }

    barrier();
    if (gl_LocalInvocationIndex == 0u)
    {
        ivec2 tile_pixel = ivec2(gl_WorkGroupID.xy);
        if (all(lessThan(tile_pixel, imageSize(OutputTileTexture))))
        {
            imageStore(
                OutputTileTexture,
                tile_pixel,
                uvec4(tile_has_geometry != 0u ? 255u : 0u, 0u, 0u, 0u));
        }
    }
}
