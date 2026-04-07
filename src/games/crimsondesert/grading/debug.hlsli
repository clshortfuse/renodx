#ifndef SRC_CRIMSONDESERT_GRADING_DEBUG_HLSLI_
#define SRC_CRIMSONDESERT_GRADING_DEBUG_HLSLI_

#if CUSTOM_TONEMAP_DEBUG
#include "../../../shaders/debug.hlsl"
#include "../../../shaders/canvas.hlsl"

#ifndef CUSTOM_TONEMAP_DEBUG_GRAPH
#define CUSTOM_TONEMAP_DEBUG_GRAPH 0.0f
#endif

#ifndef CUSTOM_TONEMAP_DEBUG_STATS
#define CUSTOM_TONEMAP_DEBUG_STATS 0.0f
#endif

bool TonemapDebugEnabled() {
  return CUSTOM_TONEMAP_DEBUG_GRAPH > 0.5f;
}

bool TonemapStatsEnabled() {
  return CUSTOM_TONEMAP_DEBUG_STATS > 0.5f;
}

bool TonemapDebugColorEquals(float3 lhs, float3 rhs) {
  return all(abs(lhs - rhs) < 0.001f.xxx);
}

float TonemapDebugSafe(float value, float fallback = 0.0f) {
  return (isnan(value) || isinf(value)) ? fallback : value;
}

float3 DrawTonemapGraph(float3 color, inout renodx::debug::graph::Config graph_config, float graph_scale = 1.0f) {
  if (!graph_config.draw) {
    return color;
  }

  float3 graph_input = color / graph_scale;
  float3 graph_color = renodx::debug::graph::DrawEnd(graph_input, graph_config);

  if (TonemapDebugColorEquals(graph_color, 0.05f.xxx)) {
    return float3(0.07f, 0.07f, 0.08f);
  }
  if (TonemapDebugColorEquals(graph_color, float3(0.3f, 0.0f, 0.3f))) {
    return float3(0.36f, 0.18f, 0.32f);
  }
  if (TonemapDebugColorEquals(graph_color, float3(0.0f, 0.3f, 0.3f))) {
    return float3(0.14f, 0.30f, 0.32f);
  }
  if (TonemapDebugColorEquals(graph_color, float3(0.0f, 0.3f, 0.0f))) {
    return float3(0.16f, 0.28f, 0.16f);
  }
  if (TonemapDebugColorEquals(graph_color, float3(0.0f, 0.0f, 0.3f))) {
    return float3(0.16f, 0.20f, 0.34f);
  }

  return graph_color * graph_scale;
}

float3 DrawPerceptualTonemapDebug(
    float3 color,
    uint2 pixel,
    float exposure0_x,
    float user_exposure,
    float exposure2_x,
    float exposure2_y,
    float exposure2_z,
    float exposure2_w,
    float histogram_mean,
    float histogram_target,
    float exposure_mul) {
  float2 position = float2(pixel) + 0.5f;
  float2 panel_min = float2(10.0f, 10.0f);
  float2 panel_max = float2(248.0f, 206.0f);

  renodx::canvas::Context context = renodx::canvas::CreateContext(
      position,
      panel_min + float2(8.0f, 8.0f),
      float2(8.0f, 12.0f),
      color,
      1.0f,
      1.0f.xxx,
      1.0f,
      1.0f,
      renodx::canvas::MODE_NORMAL,
      0.0f,
      1.15f);

  renodx::canvas::SetColor(context, 0x101418, 0.96f, 1.0f);
  renodx::canvas::FillRect(context, panel_min, panel_max);

  renodx::canvas::SetColor(context, 0x3df58f, 1.0f, 1.0f);
  renodx::canvas::DrawText(context, 'P', '1', '7');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawText(context, 'A', 'E');
  renodx::canvas::NewLine(context);

  renodx::canvas::SetColor(context, 0xd8dde3, 1.0f, 1.0f);
  renodx::canvas::DrawText(context, 'E', 'x', 'p', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(exposure0_x), 0.0f, 6.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'U', 's', 'r', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(user_exposure), 0.0f, 6.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'M', 'e', 't', 'e');
  renodx::canvas::DrawText(context, 'r', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(exposure2_x), 0.0f, 6.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'F', 'a', 's', 't');
  renodx::canvas::DrawText(context, 'B', 'g', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(exposure2_y), 0.0f, 6.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'A', 'd', 'a', 'p');
  renodx::canvas::DrawText(context, 't', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(exposure2_z), 0.0f, 6.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'S', 'l', 'o', 'w');
  renodx::canvas::DrawText(context, 'B', 'g', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(exposure2_w), 0.0f, 6.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'C', 'u', 'r', 'r');
  renodx::canvas::DrawText(context, 'e', 'n', 't', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(histogram_mean), 0.0f, 6.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'T', 'a', 'r', 'g');
  renodx::canvas::DrawText(context, 'e', 't', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(histogram_target), 0.0f, 6.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'M', 'i', 'n', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(AE_PERCEPTUAL_MIN_BRIGHTNESS), 0.0f, 6.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'M', 'a', 'x', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(AE_PERCEPTUAL_MAX_BRIGHTNESS), 0.0f, 6.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'C', 'u', 'r');
  renodx::canvas::DrawText(context, 'N', 'i', 't', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(histogram_mean * RENODX_DIFFUSE_WHITE_NITS), 0.0f, 3.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'T', 'g', 't');
  renodx::canvas::DrawText(context, 'N', 'i', 't', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(histogram_target * RENODX_DIFFUSE_WHITE_NITS), 0.0f, 3.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'R', 'a', 't', 'i');
  renodx::canvas::DrawText(context, 'o', ':');
  renodx::canvas::InsertSpace(context);
  float ratio = (histogram_mean > 0.0f && !isnan(histogram_mean) && !isinf(histogram_mean) &&
                 histogram_target > 0.0f && !isnan(histogram_target) && !isinf(histogram_target))
      ? (histogram_target / histogram_mean)
      : 0.0f;
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(ratio), 0.0f, 6.0f);
  renodx::canvas::NewLine(context);

  renodx::canvas::DrawText(context, 'S', 'c', 'a', 'l');
  renodx::canvas::DrawText(context, 'e', ':');
  renodx::canvas::InsertSpace(context);
  renodx::canvas::DrawFloat(context, TonemapDebugSafe(exposure_mul), 0.0f, 6.0f);

  return renodx::canvas::GetOutput(context).rgb;
}

#else

bool TonemapDebugEnabled() {
  return false;
}

bool TonemapStatsEnabled() {
  return false;
}

float3 DrawTonemapGraph(float3 color, inout uint dummy_graph_config, float graph_scale = 1.0f) {
  return color;
}

float3 DrawPerceptualTonemapDebug(
    float3 color,
    uint2 pixel,
    float exposure0_x,
    float user_exposure,
    float exposure2_x,
    float exposure2_y,
    float exposure2_z,
    float exposure2_w,
    float histogram_mean,
    float histogram_target,
    float exposure_mul) {
  return color;
}

#endif

#endif
