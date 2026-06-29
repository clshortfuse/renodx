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

layout(set = 0, binding = 23, std140) uniform fp_c4
{
    vec4 _m0[4096];
} fp_c4_1;

layout(set = 0, binding = 20, std140) uniform fp_c1
{
    vec4 _m0[4096];
} fp_c1_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_16;
layout(set = 2, binding = 129) uniform sampler2D fp_t_tcb_10;
layout(set = 2, binding = 130) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 131) uniform sampler2D fp_t_tcb_A;
layout(set = 2, binding = 132) uniform sampler2D fp_t_tcb_1A;
layout(set = 2, binding = 133) uniform sampler2D fp_t_tcb_12;
layout(set = 2, binding = 134) uniform sampler2D fp_t_tcb_C;
layout(set = 2, binding = 135) uniform sampler2D fp_t_tcb_18;
layout(set = 2, binding = 136) uniform sampler2D fp_t_tcb_E;

layout(location = 0) in vec4 _45;
layout(location = 0) out vec4 _48;
layout(location = 1) out vec4 _50;
layout(location = 2) out vec4 _52;
layout(location = 3) out vec4 _54;
layout(location = 4) out vec4 _56;

float ReduceMin4(vec4 value)
{
    return min(min(value.x, value.y), min(value.z, value.w));
}

float ReduceMax4(vec4 value)
{
    return max(max(value.x, value.y), max(value.z, value.w));
}

vec3 ProjectBasis(vec3 color)
{
    float weighted = fma(color.g, fp_c1_1._m0[0].x, color.r * 0.2989999949932098388671875);
    weighted = fma(color.b, fp_c1_1._m0[0].y, weighted);
    float inverse_scale = 1.0 / fma(weighted, fp_c4_1._m0[0].z, 1.0);
    vec3 normalised = color * inverse_scale;

    return vec3(
        fma(normalised.b, -0.25, fma(normalised.r, 0.25, normalised.g * 0.5)),
        fma(normalised.b, 0.5, normalised.r * 0.5),
        fma(normalised.b, -0.25, fma(normalised.r, 0.25, normalised.g * -0.5)));
}

vec3 ReconstructColor(vec3 basis)
{
    vec3 packed = vec3(
        basis.x + basis.y + basis.z,
        basis.x - basis.z,
        basis.y - basis.x - basis.z);
    float weighted = fma(packed.y, fp_c1_1._m0[0].x, packed.x * 0.2989999949932098388671875);
    weighted = fma(packed.z, fp_c1_1._m0[0].y, weighted);
    float inverse_scale = 1.0 / fma(weighted, -fp_c4_1._m0[0].z, 1.0);
    return packed * inverse_scale;
}

void main()
{
    vec2 uv = _45.xy;

    vec4 resolve_depth = textureGatherOffsets(
        fp_t_tcb_16,
        uv,
        ivec2[](ivec2(-2), ivec2(2, -2), ivec2(-2, 2), ivec2(2)));
    float center_depth = texture(fp_t_tcb_16, uv).x;

    float horizontal_pick = resolve_depth.x >= resolve_depth.y ? 1.0 : 0.0;
    float vertical_pick = resolve_depth.z >= resolve_depth.w ? 1.0 : 0.0;
    vec2 pair_min = vec2(min(resolve_depth.x, resolve_depth.y), min(resolve_depth.z, resolve_depth.w));
    float pair_select = pair_min.x >= pair_min.y ? 1.0 : 0.0;
    float horizontal_axis = fma(horizontal_pick, 4.0, -2.0);
    float vertical_axis = fma(vertical_pick, 4.0, -horizontal_axis);
    float branch_axis = fma(pair_select, 4.0, -2.0);
    float branch_offset = fma(pair_select, vertical_axis - 2.0, horizontal_axis);
    float follow_edge = center_depth >= min(pair_min.x, pair_min.y) ? 1.0 : 0.0;
    vec2 resolve_uv = uv + vec2(
        follow_edge * branch_offset * fp_c4_1._m0[4].z,
        follow_edge * branch_axis * fp_c4_1._m0[4].w);

    vec3 resolve_sample = texture(fp_t_tcb_10, resolve_uv).xyw;
    int quadrant = int(trunc(resolve_sample.z * 3.0099999904632568359375));
    vec2 guide_sign = vec2(
        1.0 - 2.0 * float(quadrant & 1),
        -1.0 + 2.0 * float((quadrant & 2) >> 1));
    vec2 guide_delta = guide_sign * resolve_sample.xy * resolve_sample.xy;

    vec2 sample_offset = fp_c4_1._m0[3].zw;
    vec2 uv_left = uv + vec2(-sample_offset.x, 0.0);
    vec2 uv_down = uv + vec2(0.0, -sample_offset.y);
    vec2 uv_right = uv + vec2(sample_offset.x, 0.0);
    vec2 uv_up = uv + vec2(0.0, sample_offset.y);
    vec2 guide_uv = uv + guide_delta;

    vec4 sample_left = texture(fp_t_tcb_8, uv_left);
    vec4 sample_down = texture(fp_t_tcb_8, uv_down);
    vec4 sample_right = texture(fp_t_tcb_8, uv_right);
    vec4 sample_center = texture(fp_t_tcb_8, uv);
    vec4 sample_guide = texture(fp_t_tcb_A, guide_uv);
    vec4 sample_up = texture(fp_t_tcb_8, uv_up);
    float noise_floor = texture(fp_t_tcb_1A, uv).x;

    vec3 basis_left = ProjectBasis(sample_left.rgb);
    vec3 basis_down = ProjectBasis(sample_down.rgb);
    vec3 basis_right = ProjectBasis(sample_right.rgb);
    vec3 basis_center = ProjectBasis(sample_center.rgb);
    vec3 basis_guide = ProjectBasis(sample_guide.rgb);
    vec3 basis_up = ProjectBasis(sample_up.rgb);

    vec3 min_basis_cross = vec3(
        ReduceMin4(vec4(basis_left.x, basis_down.x, basis_right.x, basis_center.x)),
        ReduceMin4(vec4(basis_left.y, basis_down.y, basis_right.y, basis_center.y)),
        ReduceMin4(vec4(basis_left.z, basis_down.z, basis_right.z, basis_center.z)));
    vec3 max_basis_cross = vec3(
        ReduceMax4(vec4(basis_left.x, basis_down.x, basis_right.x, basis_center.x)),
        ReduceMax4(vec4(basis_left.y, basis_down.y, basis_right.y, basis_center.y)),
        ReduceMax4(vec4(basis_left.z, basis_down.z, basis_right.z, basis_center.z)));
    vec3 min_basis_five = min(min_basis_cross, basis_up);
    vec3 max_basis_five = max(max_basis_cross, basis_up);

    vec4 alpha_cross = vec4(sample_left.a, sample_down.a, sample_right.a, sample_center.a);
    float min_alpha_five = min(ReduceMin4(alpha_cross), sample_up.a);
    float max_alpha_five = max(ReduceMax4(alpha_cross), sample_up.a);

    float guide_basis_min = min(basis_center.x, basis_guide.x);
    float guide_basis_span = abs(basis_guide.x - basis_center.x);
    float guide_basis_weight = (1.0 + guide_basis_span) / (1.0 + guide_basis_min);

    vec2 guide_radius = guide_delta * fp_c4_1._m0[4].xy;
    float guide_radius_sq = dot(guide_radius, guide_radius);
    float guide_radius_clamp = clamp(sqrt(guide_radius_sq) * 2.0, 0.0, 1.0);
    float guide_envelope = clamp(
        0.100000001490116119384765625 * guide_basis_weight * (1.0 + 6.0 * guide_radius_clamp),
        0.0,
        1.0);

    float inside_mask = min(guide_uv.x, guide_uv.y) >= 0.0 ? 1.0 : 0.0;
    float in_bounds_mask = max(guide_uv.x, guide_uv.y) <= 1.0 ? 1.0 : 0.0;
    float small_guide_mask = guide_radius_sq <= fp_c4_1._m0[0].y ? 1.0 : 0.0;
    float guide_bias = fma(small_guide_mask * in_bounds_mask, -inside_mask, fp_c1_1._m0[0].w);
    float primary_blend = max(max(noise_floor, max(guide_envelope, fp_c1_1._m0[0].z)), guide_bias);

    vec3 weighted_basis =
        (basis_left + basis_down + basis_right + basis_up) * fp_c4_1._m0[1].x +
        basis_center * fp_c4_1._m0[1].y;
    float weighted_alpha =
        (sample_left.a + sample_down.a + sample_right.a + sample_up.a) * fp_c4_1._m0[1].x +
        sample_center.a * fp_c4_1._m0[1].y;

    vec3 clamped_guide_basis = clamp(basis_guide, min_basis_five, max_basis_five);
    float clamped_guide_alpha = clamp(sample_guide.a, min_alpha_five, max_alpha_five);

    float guide_length = 2.0 * length(guide_delta);
    float guide_reference = texture(fp_t_tcb_12, guide_uv).x;
    float guide_transition = 0.5 * clamp(30.0 * sqrt(abs(guide_length - guide_reference)), 0.0, 1.0);
    float basis_blend = max(primary_blend, guide_transition);

    vec3 merged_basis = mix(clamped_guide_basis, weighted_basis, basis_blend);
    float merged_alpha = mix(clamped_guide_alpha, weighted_alpha, basis_blend);
    vec3 reconstructed_color = ReconstructColor(merged_basis);

    vec3 scaled_color = reconstructed_color * fp_c4_1._m0[13].x;
    vec3 positive_scale = max(scaled_color - fp_c4_1._m0[13].y, 0.0);
    float response_scale = dot(positive_scale, vec3(fp_c4_1._m0[13].z));
    vec3 bounded_scale = min(scaled_color, scaled_color * response_scale);
    vec3 center_floor = bounded_scale * fp_c4_1._m0[13].w;

    vec4 depth_cross = textureGatherOffsets(
        fp_t_tcb_16,
        uv,
        ivec2[](ivec2(0, -1), ivec2(-1, 0), ivec2(1, 0), ivec2(0, 1)));
    vec4 negative_depth = -fp_c4_1._m0[5].y /
        (depth_cross * fp_c4_1._m0[5].x - fp_c4_1._m0[5].z);
    float negative_center_depth =
        -fp_c4_1._m0[5].y / (center_depth * fp_c4_1._m0[5].x - fp_c4_1._m0[5].z);

    vec4 encode_sample = texture(fp_t_tcb_18, uv);
    float encode_seed = fma(
        encode_sample.z,
        fp_c1_1._m0[1].x,
        fma(encode_sample.y, 31.875, encode_sample.x * 0.125));
    float encode_min = min(ReduceMin4(negative_depth), negative_center_depth);
    float encode_max = max(ReduceMax4(negative_depth), negative_center_depth);
    float encode_clamped = clamp(encode_seed, encode_min, encode_max);
    float encode_floor = min(negative_center_depth, encode_clamped);
    float encode_blend = clamp(1.0 / (abs(encode_floor - encode_clamped) + 1.0), 0.0, 1.0);
    float encoded_value = mix(encode_clamped, encode_floor, encode_blend);

    vec4 tc_down = texture(fp_t_tcb_C, uv_down);
    vec4 tc_up = texture(fp_t_tcb_C, uv_up);
    vec4 tc_left = texture(fp_t_tcb_C, uv_left);
    vec4 tc_right = texture(fp_t_tcb_C, uv_right);
    vec4 tc_center = texture(fp_t_tcb_C, uv);
    vec4 tc_guide = texture(fp_t_tcb_E, guide_uv);

    vec3 tc_neighbor_min = min(min(tc_down.rgb, tc_up.rgb), min(tc_left.rgb, tc_right.rgb));
    vec3 tc_neighbor_max = max(max(tc_down.rgb, tc_up.rgb), max(tc_left.rgb, tc_right.rgb));
    vec3 tc_center_target = max(center_floor, tc_center.rgb);
    vec3 tc_guide_clamped = clamp(
        tc_guide.rgb,
        min(tc_center_target, tc_neighbor_min),
        max(tc_center_target, tc_neighbor_max));

    float tc_alpha_min = min(tc_center.a, ReduceMin4(vec4(tc_down.a, tc_up.a, tc_left.a, tc_right.a)));
    float tc_alpha_max = max(tc_center.a, ReduceMax4(vec4(tc_down.a, tc_up.a, tc_left.a, tc_right.a)));
    float tc_alpha_clamped = clamp(tc_guide.a, tc_alpha_min, tc_alpha_max);

    float luminance_gate = clamp(max(tc_center.r, max(tc_center.g, tc_center.b)), 0.0, 1.0) *
        0.20000000298023223876953125;
    float secondary_blend = max(primary_blend, luminance_gate);
    vec4 blended_target = vec4(tc_center_target, tc_center.a);
    vec4 blended_source = vec4(tc_guide_clamped, tc_alpha_clamped);
    vec4 blended_tc = mix(blended_source, blended_target, secondary_blend);

    float encoded_bin = encoded_value * 8.0;
    float encoded_bin_floor = floor(encoded_bin);
    float encoded_byte = encoded_bin_floor * 0.0039215688593685626983642578125;
    vec3 packed_value = vec3(
        fract(encoded_bin),
        fract(encoded_byte),
        floor(encoded_byte) * 0.0039215688593685626983642578125);

    vec3 positive_color = max(reconstructed_color, 0);
    _48 = vec4(positive_color, merged_alpha);
    _50 = blended_tc;
    _52 = vec4(packed_value, 0.0);
    _54 = vec4(guide_length);
    _56 = _48;
}

