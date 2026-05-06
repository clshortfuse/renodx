#version 450

layout(set = 0, binding = 0, std140) uniform support_buffer
{
    uint _m0;
    uint _m1[8];
    vec4 _m2;
    vec4 _m3;
    int _m4;
    float _m5[73];
    ivec4 _m6;
    int _m7;
} support_buffer_1;

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;

layout(location = 0) in vec4 in_uv;
layout(location = 0) out vec4 out_color;

const float KERNEL_WEIGHT = 0.2857142984867095947265625;
const float SPAN_BIAS = 0.03125;
const int SPAN_SCALE_BIAS = 2129690299;
const int NORMALIZE_SCALE_BIAS = 2129764351;

int ResolveSampleCoord(int coord, bool use_vertical_axis)
{
    float coord_scale = support_buffer_1._m5[1];
    if (coord_scale == 1.0)
    {
        return coord;
    }

    if (coord_scale < 0.0)
    {
        float abs_scale = -coord_scale;
        float axis_coord = use_vertical_axis ? gl_FragCoord.y : gl_FragCoord.x;
        return int(float(coord) * abs_scale + mod(axis_coord, abs_scale));
    }

    return int(float(coord) * coord_scale);
}

float ComputeSpanScale(float local_max, float local_min)
{
    return intBitsToFloat(-floatBitsToInt((local_max - local_min) + SPAN_BIAS) + SPAN_SCALE_BIAS);
}

float ComputeStageGain(float span_weight)
{
    uint half_weight_bits = uint(int(uint(floatBitsToInt(span_weight)) >> 1u));
    int gain_bits = int(half_weight_bits) + floatBitsToInt(fp_c1_1._m0[0].x);
    return intBitsToFloat(gain_bits) * fp_c3_1._m0[1].x;
}

float ComputeNormalizationScale(float total_weight)
{
    int normalize_bits = -floatBitsToInt(total_weight) + NORMALIZE_SCALE_BIAS;
    float normalize_bias = fma(total_weight, -intBitsToFloat(normalize_bits), fp_c1_1._m0[0].y);
    return intBitsToFloat(normalize_bits) * normalize_bias;
}

void main()
{
  vec2 source_size = vec2(
      float(floatBitsToUint(fp_c3_1._m0[4].x)),
      float(floatBitsToUint(fp_c3_1._m0[4].y))
    );
  uvec2 pixel_coord_uint = uvec2(max(trunc(source_size * in_uv.xy), vec2(0.0)));
  vec2 pixel_coord = vec2(pixel_coord_uint);

  vec2 remapped_coord = vec2(
      fma(pixel_coord.x, fp_c3_1._m0[0].x, fp_c3_1._m0[0].z),
      fma(pixel_coord.y, fp_c3_1._m0[0].y, fp_c3_1._m0[0].w)
    );
  ivec2 base_coord = ivec2(floor(remapped_coord));
  ivec2 sample_coord = ivec2(
      ResolveSampleCoord(base_coord.x, false),
      ResolveSampleCoord(base_coord.y, true)
    );

  out_color = texelFetch(fp_t_tcb_8, sample_coord, 0);

    // vec2 source_size = vec2(
    //     float(floatBitsToUint(fp_c3_1._m0[4].x)),
    //     float(floatBitsToUint(fp_c3_1._m0[4].y))
    // );
    // uvec2 pixel_coord_uint = uvec2(max(trunc(source_size * in_uv.xy), vec2(0.0)));
    // vec2 pixel_coord = vec2(pixel_coord_uint);

    // vec2 remapped_coord = vec2(
    //     fma(pixel_coord.x, fp_c3_1._m0[0].x, fp_c3_1._m0[0].z),
    //     fma(pixel_coord.y, fp_c3_1._m0[0].y, fp_c3_1._m0[0].w)
    // );
    // ivec2 base_coord = ivec2(floor(remapped_coord));
    // ivec2 sample_coord = ivec2(
    //     ResolveSampleCoord(base_coord.x, false),
    //     ResolveSampleCoord(base_coord.y, true)
    // );

    // vec3 tap_p0_p1 = texelFetchOffset(fp_t_tcb_8, sample_coord, 0, ivec2(0, 1)).xyz;
    // vec3 tap_m1_p0 = texelFetchOffset(fp_t_tcb_8, sample_coord, 0, ivec2(-1, 0)).xyz;
    // vec3 tap_p0_p0 = texelFetch(fp_t_tcb_8, sample_coord, 0).xyz;
    // vec3 tap_p1_p0 = texelFetchOffset(fp_t_tcb_8, sample_coord, 0, ivec2(1, 0)).xyz;
    // vec3 tap_p0_m1 = texelFetchOffset(fp_t_tcb_8, sample_coord, 0, ivec2(0, -1)).xyz;
    // vec3 tap_p2_p0 = texelFetchOffset(fp_t_tcb_8, sample_coord, 0, ivec2(2, 0)).xyz;
    // vec3 tap_p1_p1 = texelFetchOffset(fp_t_tcb_8, sample_coord, 0, ivec2(1, 1)).xyz;
    // vec3 tap_p1_m1 = texelFetchOffset(fp_t_tcb_8, sample_coord, 0, ivec2(1, -1)).xyz;
    // vec3 tap_m1_p1 = texelFetchOffset(fp_t_tcb_8, sample_coord, 0, ivec2(-1, 1)).xyz;
    // vec3 tap_p0_p2 = texelFetchOffset(fp_t_tcb_8, sample_coord, 0, ivec2(0, 2)).xyz;
    // vec3 tap_p1_p2 = texelFetchOffset(fp_t_tcb_8, sample_coord, 0, ivec2(1, 2)).xyz;
    // vec3 tap_p2_p1 = texelFetchOffset(fp_t_tcb_8, sample_coord, 0, ivec2(2, 1)).xyz;

    // vec3 w_p0_p1 = tap_p0_p1 * KERNEL_WEIGHT;
    // vec3 w_m1_p0 = tap_m1_p0 * KERNEL_WEIGHT;
    // vec3 w_p0_p0 = tap_p0_p0 * KERNEL_WEIGHT;
    // vec3 w_p1_p0 = tap_p1_p0 * KERNEL_WEIGHT;
    // vec3 w_p0_m1 = tap_p0_m1 * KERNEL_WEIGHT;
    // vec3 w_p2_p0 = tap_p2_p0 * KERNEL_WEIGHT;
    // vec3 w_p1_p1 = tap_p1_p1 * KERNEL_WEIGHT;
    // vec3 w_p1_m1 = tap_p1_m1 * KERNEL_WEIGHT;
    // vec3 w_m1_p1 = tap_m1_p1 * KERNEL_WEIGHT;
    // vec3 w_p0_p2 = tap_p0_p2 * KERNEL_WEIGHT;
    // vec3 w_p1_p2 = tap_p1_p2 * KERNEL_WEIGHT;
    // vec3 w_p2_p1 = tap_p2_p1 * KERNEL_WEIGHT;

    // float frac_x = remapped_coord.x - floor(remapped_coord.x);
    // float frac_y = remapped_coord.y - floor(remapped_coord.y);
    // float bilinear_00 = (1.0 - frac_x) * (1.0 - frac_y);
    // float bilinear_10 = frac_x * (1.0 - frac_y);
    // float bilinear_01 = (1.0 - frac_x) * frac_y;
    // float bilinear_11 = frac_x * frac_y;

    // float stage0_local_max = max(max(w_p0_p1.g, w_p1_p0.g), max(w_p0_m1.g, max(w_p0_p0.g, w_m1_p0.g)));
    // float stage0_local_min = min(min(w_p0_p1.g, w_p1_p0.g), min(w_p0_m1.g, min(w_p0_p0.g, w_m1_p0.g)));
    // float stage0_headroom = min(1.0 - stage0_local_max, stage0_local_min);
    // float stage0_span_scale = ComputeSpanScale(stage0_local_max, stage0_local_min);
    // float stage0_weight = clamp(stage0_span_scale * stage0_headroom, 0.0, 1.0);
    // float stage0_gain = ComputeStageGain(stage0_weight);
    // float stage0_sample_weight = stage0_span_scale * bilinear_00;
    // float stage0_combined = stage0_sample_weight * stage0_gain;

    // float stage1_local_max = max(max(w_p2_p0.g, w_p1_p1.g), max(w_p1_m1.g, max(w_p0_p0.g, w_p1_p0.g)));
    // float stage1_local_min = min(min(w_p2_p0.g, w_p1_p1.g), min(w_p1_m1.g, min(w_p0_p0.g, w_p1_p0.g)));
    // float stage1_headroom = min(1.0 - stage1_local_max, stage1_local_min);
    // float stage1_span_scale = ComputeSpanScale(stage1_local_max, stage1_local_min);
    // float stage1_weight = clamp(stage1_span_scale * stage1_headroom, 0.0, 1.0);
    // float stage1_gain = ComputeStageGain(stage1_weight);
    // float stage1_sample_weight = stage1_span_scale * bilinear_10;
    // float stage1_combined = stage1_sample_weight * stage1_gain;

    // float stage2_local_max = max(max(w_p1_p1.g, w_p0_p2.g), max(w_p0_p0.g, max(w_p0_p1.g, w_m1_p1.g)));
    // float stage2_local_min = min(min(w_p1_p1.g, w_p0_p2.g), min(w_p0_p0.g, min(w_p0_p1.g, w_m1_p1.g)));
    // float stage2_headroom = min(1.0 - stage2_local_max, stage2_local_min);
    // float stage2_span_scale = ComputeSpanScale(stage2_local_max, stage2_local_min);
    // float stage2_weight = clamp(stage2_span_scale * stage2_headroom, 0.0, 1.0);
    // float stage2_gain = ComputeStageGain(stage2_weight);
    // float stage2_sample_weight = stage2_span_scale * bilinear_01;
    // float stage2_combined = stage2_sample_weight * stage2_gain;

    // float stage3_local_max = max(max(w_p2_p1.g, w_p1_p2.g), max(w_p1_p0.g, max(w_p0_p1.g, w_p1_p1.g)));
    // float stage3_local_min = min(min(w_p2_p1.g, w_p1_p2.g), min(w_p1_p0.g, min(w_p0_p1.g, w_p1_p1.g)));
    // float stage3_headroom = min(1.0 - stage3_local_max, stage3_local_min);
    // float stage3_span_scale = ComputeSpanScale(stage3_local_max, stage3_local_min);
    // float stage3_weight = clamp(stage3_span_scale * stage3_headroom, 0.0, 1.0);
    // float stage3_gain = ComputeStageGain(stage3_weight);
    // float stage3_sample_weight = stage3_span_scale * bilinear_11;
    // float stage3_combined = stage3_sample_weight * stage3_gain;

    // float red_outer = w_m1_p0.r * stage0_combined;
    // red_outer = fma(w_p0_m1.r, stage0_combined, red_outer);
    // red_outer = fma(w_p1_m1.r, stage1_combined, red_outer);
    // red_outer = fma(w_p2_p0.r, stage1_combined, red_outer);
    // red_outer = fma(w_m1_p1.r, stage2_combined, red_outer);
    // red_outer = fma(w_p0_p2.r, stage2_combined, red_outer);
    // red_outer = fma(w_p2_p1.r, stage3_combined, red_outer);
    // red_outer = fma(w_p1_p2.r, stage3_combined, red_outer);

    // float green_outer = w_p0_p1.g * stage0_combined;
    // green_outer = fma(w_p0_p0.g, stage0_combined, green_outer);
    // green_outer = fma(w_p0_m1.g, stage1_combined, green_outer);
    // green_outer = fma(w_p1_p1.g, stage1_combined, green_outer);
    // green_outer = fma(w_m1_p1.g, stage2_combined, green_outer);
    // green_outer = fma(w_p0_p2.g, stage2_combined, green_outer);
    // green_outer = fma(w_p2_p1.g, stage3_combined, green_outer);
    // green_outer = fma(w_p1_p2.g, stage3_combined, green_outer);

    // float blue_outer = w_m1_p0.b * stage0_combined;
    // blue_outer = fma(w_p0_m1.b, stage0_combined, blue_outer);
    // blue_outer = fma(w_p1_m1.b, stage1_combined, blue_outer);
    // blue_outer = fma(w_p2_p0.b, stage1_combined, blue_outer);
    // blue_outer = fma(w_m1_p1.b, stage2_combined, blue_outer);
    // blue_outer = fma(w_p0_p2.b, stage2_combined, blue_outer);
    // blue_outer = fma(w_p2_p1.b, stage3_combined, blue_outer);
    // blue_outer = fma(w_p1_p2.b, stage3_combined, blue_outer);

    // float stage01_combined = stage0_combined + stage1_combined;
    // float stage12_combined = stage1_combined + stage2_combined;
    // float stage012_combined = stage2_combined + stage01_combined;
    // float center_weight = stage0_sample_weight + stage12_combined;
    // float side_corner_weight = stage0_combined + stage3_combined;
    // float full_ring_weight = stage3_combined + stage012_combined;
    // float right_weight = stage1_sample_weight + side_corner_weight;
    // float interior_weight = fma(full_ring_weight, 2.0, center_weight);
    // float up_weight = stage2_sample_weight + side_corner_weight;
    // float up_right_weight = stage12_combined + stage3_sample_weight;
    // float total_weight = up_weight + (right_weight + interior_weight) + up_right_weight;

    // float red_accum = fma(w_p0_p0.r, center_weight, red_outer);
    // red_accum = fma(w_p1_p0.r, right_weight, red_accum);
    // red_accum = fma(w_p0_p1.r, up_weight, red_accum);
    // red_accum = fma(w_p1_p1.r, up_right_weight, red_accum);

    // float green_accum = fma(w_p0_p0.g, center_weight, green_outer);
    // green_accum = fma(w_p1_p0.g, right_weight, green_accum);
    // green_accum = fma(w_p0_p1.g, up_weight, green_accum);
    // green_accum = fma(w_p1_p1.g, up_right_weight, green_accum);

    // float blue_accum = fma(w_p0_p0.b, center_weight, blue_outer);
    // blue_accum = fma(w_p1_p0.b, right_weight, blue_accum);
    // blue_accum = fma(w_p0_p1.b, up_weight, blue_accum);
    // blue_accum = fma(w_p1_p1.b, up_right_weight, blue_accum);

    // float normalization_scale = ComputeNormalizationScale(total_weight);
    // vec3 filtered_color = clamp(normalization_scale * vec3(red_accum, green_accum, blue_accum), 0.0, 1.0) * 3.5;

    // out_color = vec4(filtered_color, 1.0);
}

