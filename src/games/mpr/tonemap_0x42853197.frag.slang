#version 450
#include "./shared.h"
#include "./shared.slang"

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

layout(set = 0, binding = 19, std140) uniform fp_c0
{
    vec4 _m0[4096];
} fp_c0_1;

layout(set = 0, binding = 22, std140) uniform fp_c3
{
    vec4 _m0[4096];
} fp_c3_1;

layout(set = 2, binding = 128) uniform sampler2D fp_t_tcb_8;
layout(set = 2, binding = 129) uniform sampler3D fp_t_tcb_A;
layout(set = 2, binding = 130) uniform sampler3D fp_t_tcb_C;

layout(location = 0) noperspective in vec4 in;
layout(location = 0) out vec4 out;

void main()
{
    vec4 scene = texture(fp_t_tcb_8, in.xy);

    vec3 color = Tonemap(scene.rgb);
    vec3 hdr = Tonemap(scene.rgb, true);
    color = lut(color);
    hdr = lut(hdr, true);

    if (RENODX_TONE_MAP_TYPE != 0) color = ColourCorrect(hdr, color);
    out.xyz = ApplyColorGrade(color);
    out.w = scene.w;
    out.xyz = DisplayMap(out.xyz);
    out = renodx::draw::RenderIntermediatePass(out);

    // vec2 debug_uv = float2(0.5f, 0.5f);
    // vec3 debug_in = texture(fp_t_tcb_8, debug_uv).rgb;
    // vec3 debug_sdr = Tonemap(debug_in);
    // vec3 debug_hdr = Tonemap(debug_in, true);
    // out.xyz = DrawTonemapDebugOverlay(out.xyz, in.xy, debug_in, debug_sdr, debug_hdr);
}

vec3 Tonemap(vec3 color, bool extended = false)
{
    vec4 curve0_params = fp_c3_1._m0[1];
    vec4 curve1_params = fp_c3_1._m0[2];
    vec4 curve2_params = fp_c3_1._m0[3];

    precise vec3 scaled = color * fp_c3_1._m0[0].x;
    float scale = renodx::math::Select(extended, renodx::tonemap::neutwo::ComputeMaxChannelScale(scaled), 1.f);
    scaled *= scale;
    precise vec3 base_curve = fma(
        scaled * scaled,
        fma(scaled, curve0_params.x, curve0_params.y),
        fma(scaled, curve0_params.z, curve0_params.w));

    precise vec3 mid_curve = fma(scaled, curve1_params.x, curve1_params.y);

    precise vec3 ratio_input = fma(scaled, curve2_params.y, curve2_params.z);
    precise vec3 high_curve = fma(ratio_input / (ratio_input + 1.0), curve2_params.x, curve2_params.w);

    vec3 mid_mask = step(curve1_params.z, scaled);
    vec3 high_mask = step(curve1_params.w, scaled);

    vec3 result = base_curve + (mid_curve - base_curve) * mid_mask + (high_curve - mid_curve) * high_mask;

    return result / scale;
}

vec3 lut(vec3 color, bool extended = false)
{
  float scale = renodx::math::Select(extended, renodx::tonemap::neutwo::ComputeMaxChannelScale(color), 1.f);
  color *= scale;
  vec4 lut_params = fp_c3_1._m0[4];
  vec3 lut_coords = fma(color, lut_params.y, lut_params.x);
  vec3 graded_color = texture(fp_t_tcb_A, lut_coords).xyz;
  vec3 output_coords = fma(graded_color, lut_params.w, lut_params.z);
  vec3 result = texture(fp_t_tcb_C, output_coords).xyz;
  return lerp(color, result, LUT_STRENGTH) / scale;
}

vec3 DrawTonemapCurveGraph(vec3 base_color, float2 position)
{
    const float2 graph_origin = float2(440.0f, 16.0f);
    const float graph_size = float(renodx::debug::graph::SIZE);
    float2 graph_max = graph_origin + graph_size;

    if (position.x < graph_origin.x || position.y < graph_origin.y || position.x >= graph_max.x || position.y >= graph_max.y) {
        return base_color;
    }

    float2 graph_position = position - graph_origin;
    float peak_ratio = RENODX_PEAK_WHITE_NITS / RENODX_DIFFUSE_WHITE_NITS;

    renodx::debug::graph::Config sdr_config =
        renodx::debug::graph::DrawStart(graph_position, base_color, graph_size, graph_size, peak_ratio, 1.0f);
    if (!sdr_config.draw) {
        return sdr_config.color;
    }

    float x = sdr_config.x;
    float3 sdr_curve = Tonemap(float3(x, x, x));
    float3 hdr_curve = Tonemap(float3(x, x, x), true);

    float3 graphed = renodx::debug::graph::DrawEnd(sdr_curve, sdr_config);

    renodx::debug::graph::Config hdr_config =
        renodx::debug::graph::DrawStart(graph_position, graphed, graph_size, graph_size, peak_ratio, 1.0f);
    if (!hdr_config.draw) {
        return hdr_config.color;
    }

    float3 hdr_graph = renodx::debug::graph::DrawEnd(hdr_curve, hdr_config);
    return lerp(graphed, hdr_graph, 0.6f);
}

vec3 DrawTonemapDebugOverlay(vec3 base_color, vec2 uv, vec3 scene_rgb, vec3 tonemapped_sdr, vec3 tonemapped_hdr)
{
    float2 resolution = float2(textureSize(fp_t_tcb_8, 0));
    float2 position = float2(uv.x * resolution.x, (1.0f - uv.y) * resolution.y);

    base_color = DrawTonemapCurveGraph(base_color, position);

    float2 panel_min = float2(16.0f, 16.0f);
    float2 panel_max = panel_min + float2(400.0f, 260.0f);
    float2 text_origin = panel_min + float2(8.0f, 8.0f);

    renodx::canvas::Context canvas = renodx::canvas::CreateContext(
            position,
            text_origin,
            float2(8.0f, 12.0f),
            base_color,
            0.0f);

    renodx::canvas::SetColor(canvas, 0x000000, 0.80f);
    renodx::canvas::FillRect(canvas, panel_min, panel_max);

    renodx::canvas::SetColor(canvas, 0x66CCFF, 0.95f);
    renodx::canvas::DrawText(canvas, 'M', 'P', 'R', ' ', 'T', 'M', ' ', 'D', 'E', 'B', 'U', 'G');

    renodx::canvas::NewLine(canvas);
    renodx::canvas::SetColor(canvas, 0xFFFFFF, 0.95f);
    renodx::canvas::DrawText(canvas, 'S', 'C', 'A', 'L', 'E', ':');
    renodx::canvas::DrawFloat(canvas, fp_c3_1._m0[0].x, 2.0f, 5.0f);

    renodx::canvas::NewLine(canvas);
    renodx::canvas::DrawText(canvas, 'T', '1', ':');
    renodx::canvas::DrawFloat(canvas, fp_c3_1._m0[2].z, 2.0f, 4.0f);
    renodx::canvas::InsertSpaces(canvas, 2.0f);
    renodx::canvas::DrawText(canvas, 'T', '2', ':');
    renodx::canvas::DrawFloat(canvas, fp_c3_1._m0[2].w, 2.0f, 4.0f);

    renodx::canvas::NewLine(canvas);
    renodx::canvas::DrawText(canvas, 'T', '(', '0', '.', '1', '8', ')', ':');
    renodx::canvas::DrawFloat(canvas, Tonemap(vec3(0.18f)).x, 2.0f, 4.0f);
    renodx::canvas::InsertSpaces(canvas, 2.0f);
    renodx::canvas::DrawText(canvas, 'T', '(', '1', '.', '0', ')', ':');
    renodx::canvas::DrawFloat(canvas, Tonemap(vec3(1.0f)).x, 2.0f, 4.0f);

    renodx::canvas::NewLine(canvas);
    renodx::canvas::DrawText(canvas, 'T', '(', '4', '.', '0', ')', ':');
    renodx::canvas::DrawFloat(canvas, Tonemap(vec3(4.0f)).x, 2.0f, 4.0f);
    renodx::canvas::InsertSpaces(canvas, 2.0f);
    renodx::canvas::DrawText(canvas, 'T', '(', '1', '6', ')', ':');
    renodx::canvas::DrawFloat(canvas, Tonemap(vec3(16.0f)).x, 2.0f, 4.0f);

    renodx::canvas::NewLine(canvas);
    renodx::canvas::SetColor(canvas, 0x99FF99, 1.f);
    renodx::canvas::DrawText(canvas, 'I', 'N', ':');
    renodx::canvas::DrawFloat(canvas, scene_rgb.x, 2.0f, 4.0f);
    renodx::canvas::InsertSpaces(canvas, 1.0f);
    renodx::canvas::DrawFloat(canvas, scene_rgb.y, 2.0f, 4.0f);
    renodx::canvas::InsertSpaces(canvas, 1.0f);
    renodx::canvas::DrawFloat(canvas, scene_rgb.z, 2.0f, 4.0f);

    renodx::canvas::NewLine(canvas);
    renodx::canvas::SetColor(canvas, 0xFFCC66, 0.95f);
    renodx::canvas::DrawText(canvas, 'S', 'D', 'R', ':');
    renodx::canvas::DrawFloat(canvas, tonemapped_sdr.x, 2.0f, 4.0f);
    renodx::canvas::InsertSpaces(canvas, 1.0f);
    renodx::canvas::DrawFloat(canvas, tonemapped_sdr.y, 2.0f, 4.0f);
    renodx::canvas::InsertSpaces(canvas, 1.0f);
    renodx::canvas::DrawFloat(canvas, tonemapped_sdr.z, 2.0f, 4.0f);

    renodx::canvas::NewLine(canvas);
    renodx::canvas::SetColor(canvas, 0xFF99CC, 0.95f);
    renodx::canvas::DrawText(canvas, 'H', 'D', 'R', ':');
    renodx::canvas::DrawFloat(canvas, tonemapped_hdr.x, 2.0f, 4.0f);
    renodx::canvas::InsertSpaces(canvas, 1.0f);
    renodx::canvas::DrawFloat(canvas, tonemapped_hdr.y, 2.0f, 4.0f);
    renodx::canvas::InsertSpaces(canvas, 1.0f);
    renodx::canvas::DrawFloat(canvas, tonemapped_hdr.z, 2.0f, 4.0f);

    return renodx::canvas::GetOutput(canvas).rgb;
}