/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <chrono>
#include <cmath>
#include <condition_variable>
#include <cstdint>
#include <deque>
#include <exception>
#include <filesystem>
#include <format>
#include <functional>
#include <limits>
#include <memory>
#include <mutex>
#include <optional>
#include <span>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

#include <include/reshade.hpp>

#include "../../../utils/exr.hpp"
#include "../../../utils/mcp/types.hpp"
#include "../../../utils/mcp/arguments.hpp"
#include "../../../utils/png.hpp"
#include "../../../utils/resource.hpp"
#include "resource_handle.hpp"
#include "resource_view_summary.hpp"

namespace renodx::addons::devkit::mcp::resource_analysis {

using json = renodx::utils::mcp::json;
using ToolResult = renodx::utils::mcp::ToolResult;
namespace mcp_arguments = renodx::utils::mcp::arguments;

enum class PreviewMode : std::uint8_t {
  CLAMPED = 0,
  NEUTWO = 1,
};

enum class OutputFormat : std::uint8_t {
  PNG = 0,
  EXR = 1,
};

struct PendingRequest {
  reshade::api::resource_view resource_view = {0u};
  std::optional<std::filesystem::path> output_path = std::nullopt;
  PreviewMode preview_mode = PreviewMode::CLAMPED;
  std::string preview_mode_name = "clamped";
  bool prefer_clone = false;
  std::mutex mutex;
  std::condition_variable cv;
  bool started = false;
  bool canceled = false;
  bool completed = false;
  std::optional<ToolResult> result = std::nullopt;
};

struct ToolContext {
  std::function<std::uint32_t(const json& arguments)> resolve_device_index;
  std::function<bool(std::uint32_t device_index, const std::shared_ptr<PendingRequest>& request)> enqueue_request;
  std::function<void(std::uint32_t device_index, const std::shared_ptr<PendingRequest>& request)> cancel_request;
};

struct ProcessingContext {
  std::function<std::string(std::uint64_t value)> format_handle;
  std::function<std::string(reshade::api::format format)> format_format;
  std::function<resource_view_summary::ResourceViewSummary(reshade::api::resource_view resource_view, reshade::api::device* device)> build_resource_view_summary;
};

namespace internal {

[[nodiscard]] inline std::string FormatHandle(const ProcessingContext& context, std::uint64_t value) {
  if (context.format_handle) {
    return context.format_handle(value);
  }
  return std::format("0x{:016X}", value);
}

[[nodiscard]] inline std::string FormatFormat(const ProcessingContext& context, reshade::api::format format) {
  if (context.format_format) {
    return context.format_format(format);
  }
  return std::format("{}", static_cast<std::uint32_t>(format));
}

[[nodiscard]] inline renodx::utils::resource::ResourceViewInfo* FindTrackedResourceViewInfo(reshade::api::resource_view resource_view) {
  if (resource_view.handle == 0u) return nullptr;
  return renodx::utils::resource::GetResourceViewInfo(resource_view);
}

struct AnalysisTarget {
  reshade::api::resource_view requested_view = {0u};
  reshade::api::resource_view resolved_view = {0u};
  reshade::api::resource_view_desc resolved_view_desc;
  reshade::api::resource resolved_resource = {0u};
  reshade::api::resource_desc resolved_resource_desc;
  bool used_clone = false;
};

struct ScalarStats {
  std::optional<double> minimum = std::nullopt;
  std::optional<double> maximum = std::nullopt;
  std::optional<double> mean = std::nullopt;

  ScalarStats() = default;

  ScalarStats(double minimum_value, double maximum_value, double sum, std::uint64_t count) {
    if (count == 0u) {
      return;
    }

    minimum = minimum_value;
    maximum = maximum_value;
    mean = sum / static_cast<double>(count);
  }
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const ScalarStats& value) {
  j = {
      {"min", value.minimum.has_value() ? json(value.minimum.value()) : json(nullptr)},
      {"max", value.maximum.has_value() ? json(value.maximum.value()) : json(nullptr)},
      {"mean", value.mean.has_value() ? json(value.mean.value()) : json(nullptr)},
  };
}

struct RatioStats {
  std::uint64_t count = 0u;
  double ratio = 0.0;

  RatioStats() = default;

  RatioStats(std::uint64_t matching_count, std::uint64_t total_count)
      : count(matching_count),
        ratio(total_count == 0u ? 0.0 : static_cast<double>(matching_count) / static_cast<double>(total_count)) {}
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const RatioStats& value) {
  j = {
      {"count", value.count},
      {"ratio", value.ratio},
  };
}

[[nodiscard]] inline AnalysisTarget ResolveAnalysisTarget(
    reshade::api::resource_view resource_view,
    reshade::api::device* device,
    bool prefer_clone) {
  auto* resource_view_info = FindTrackedResourceViewInfo(resource_view);
  if (resource_view_info == nullptr || resource_view_info->destroyed || resource_view_info->resource_info == nullptr) {
    throw std::runtime_error(std::format("resourceViewHandle {} is not currently tracked.", resource_view.handle));
  }
  if (resource_view_info->device != device) {
    throw std::runtime_error("resourceViewHandle does not belong to the selected device.");
  }

  const auto* resource_info = resource_view_info->resource_info;
  if (resource_info->destroyed) {
    throw std::runtime_error("The selected resource view points to a destroyed resource.");
  }

  AnalysisTarget target = {
      .requested_view = resource_view,
      .resolved_view = resource_view,
      .resolved_view_desc = resource_view_info->desc,
      .resolved_resource = resource_info->resource,
      .resolved_resource_desc = resource_info->desc,
      .used_clone = false,
  };

  if (prefer_clone) {
    if (!resource_info->clone_enabled) {
      throw std::runtime_error("preferClone was requested, but clone hotswap is not enabled for the backing resource.");
    }
    if (resource_view_info->clone.handle == 0u || resource_info->clone.handle == 0u) {
      throw std::runtime_error("preferClone was requested, but the clone view/resource is not currently instantiated. Render a frame after enabling clone hotswap and try again.");
    }

    target.resolved_view = resource_view_info->clone;
    target.resolved_view_desc = resource_view_info->clone_desc;
    target.resolved_resource = resource_info->clone;
    target.resolved_resource_desc = resource_info->clone_desc;
    target.used_clone = true;
  }

  return target;
}

[[nodiscard]] inline float DecodeFloat16(uint16_t value) {
  const auto sign = static_cast<int>((value >> 15) & 0x1u);
  const auto exponent = static_cast<int>((value >> 10) & 0x1Fu);
  const auto mantissa = static_cast<uint32_t>(value & 0x03FFu);

  float decoded = 0.f;
  if (exponent == 0) {
    if (mantissa != 0u) {
      decoded = std::ldexp(static_cast<float>(mantissa), -24);
    }
  } else if (exponent == 0x1F) {
    decoded = mantissa == 0u
                  ? std::numeric_limits<float>::infinity()
                  : std::numeric_limits<float>::quiet_NaN();
  } else {
    decoded = std::ldexp(1.f + (static_cast<float>(mantissa) / 1024.f), exponent - 15);
  }

  return sign != 0 ? -decoded : decoded;
}

[[nodiscard]] inline float DecodeUnsignedFloat(uint32_t value, uint32_t mantissa_bits) {
  const auto exponent = static_cast<int>(value >> mantissa_bits);
  const auto mantissa = value & ((1u << mantissa_bits) - 1u);

  if (exponent == 0) {
    if (mantissa == 0u) return 0.f;
    return std::ldexp(static_cast<float>(mantissa), -14 - static_cast<int>(mantissa_bits));
  }
  if (exponent == 0x1F) {
    return mantissa == 0u
               ? std::numeric_limits<float>::infinity()
               : std::numeric_limits<float>::quiet_NaN();
  }

  return std::ldexp(1.f + (static_cast<float>(mantissa) / static_cast<float>(1u << mantissa_bits)), exponent - 15);
}

[[nodiscard]] inline float DecodeR11Component(uint32_t packed) {
  return DecodeUnsignedFloat(packed & 0x7FFu, 6u);
}

[[nodiscard]] inline float DecodeR10Component(uint32_t packed) {
  return DecodeUnsignedFloat(packed & 0x3FFu, 5u);
}

[[nodiscard]] inline float SrgbToLinear(float value) {
  if (value <= 0.04045f) {
    return value / 12.92f;
  }
  return std::pow((value + 0.055f) / 1.055f, 2.4f);
}

[[nodiscard]] inline float LinearToSrgb(float value) {
  if (value <= 0.0031308f) {
    return value * 12.92f;
  }
  return (1.055f * std::pow(value, 1.f / 2.4f)) - 0.055f;
}

[[nodiscard]] inline std::string_view GetPreviewModeName(PreviewMode preview_mode) {
  switch (preview_mode) {
    case PreviewMode::CLAMPED: return "clamped";
    case PreviewMode::NEUTWO:  return "neutwo";
    default:                   return "clamped";
  }
}

[[nodiscard]] inline OutputFormat GetOutputFormat(const std::filesystem::path& output_path) {
  return output_path.extension() == L".exr" ? OutputFormat::EXR : OutputFormat::PNG;
}

[[nodiscard]] inline PreviewMode ParsePreviewMode(std::string_view value) {
  if (value == "clamped") return PreviewMode::CLAMPED;
  if (value == "neutwo") return PreviewMode::NEUTWO;

  throw std::runtime_error(std::format("previewMode '{}' is invalid. Expected 'clamped' or 'neutwo'.", value));
}

[[nodiscard]] inline float ToneMapNeutwo(float value) {
  value = std::max(value, 0.f);
  return value / std::sqrt(std::fma(value, value, 1.f));
}

[[nodiscard]] inline float ComputeNeutwoMaxChannelScale(const float rgb[3]) {
  const auto max_channel = std::max(std::abs(rgb[0]), std::max(std::abs(rgb[1]), std::abs(rgb[2])));
  if (max_channel <= 0.f) return 1.f;

  const auto new_max = ToneMapNeutwo(max_channel);
  return new_max / max_channel;
}

[[nodiscard]] inline std::uint8_t EncodePreviewChannel(float value) {
  value = std::clamp(LinearToSrgb(value), 0.f, 1.f);
  return static_cast<uint8_t>(std::lround(value * 255.f));
}

inline void EncodePreviewPixel(
    const float rgba[4],
    PreviewMode preview_mode,
    std::uint8_t out_rgba[4]) {
  if (!std::isfinite(rgba[0]) || !std::isfinite(rgba[1]) || !std::isfinite(rgba[2])) {
    out_rgba[0] = 255u;
    out_rgba[1] = 0u;
    out_rgba[2] = 255u;
    out_rgba[3] = 255u;
    return;
  }

  float rgb[3] = {rgba[0], rgba[1], rgba[2]};
  if (preview_mode == PreviewMode::NEUTWO) {
    const auto scale = ComputeNeutwoMaxChannelScale(rgb);
    rgb[0] *= scale;
    rgb[1] *= scale;
    rgb[2] *= scale;
  } else {
    rgb[0] = std::clamp(rgb[0], 0.f, 1.f);
    rgb[1] = std::clamp(rgb[1], 0.f, 1.f);
    rgb[2] = std::clamp(rgb[2], 0.f, 1.f);
  }

  out_rgba[0] = EncodePreviewChannel(std::max(rgb[0], 0.f));
  out_rgba[1] = EncodePreviewChannel(std::max(rgb[1], 0.f));
  out_rgba[2] = EncodePreviewChannel(std::max(rgb[2], 0.f));

  const auto alpha = std::isfinite(rgba[3]) ? std::clamp(rgba[3], 0.f, 1.f) : 1.f;
  out_rgba[3] = static_cast<uint8_t>(std::lround(alpha * 255.f));
}

[[nodiscard]] inline bool WritePngPreview(
    const std::filesystem::path& output_path,
    uint32_t width,
    uint32_t height,
    const std::vector<uint8_t>& rgba_pixels) {
  return renodx::utils::png::WriteRgba8(output_path, width, height, rgba_pixels);
}

[[nodiscard]] inline bool DecodePixelToLinear(
    reshade::api::format format,
    const uint8_t* pixel,
    float rgba[4],
    uint32_t& channel_count) {
  channel_count = 4u;

  switch (format) {
    case reshade::api::format::r8g8b8a8_unorm: {
      rgba[0] = pixel[0] / 255.f;
      rgba[1] = pixel[1] / 255.f;
      rgba[2] = pixel[2] / 255.f;
      rgba[3] = pixel[3] / 255.f;
      return true;
    }
    case reshade::api::format::r8g8b8a8_unorm_srgb: {
      rgba[0] = SrgbToLinear(pixel[0] / 255.f);
      rgba[1] = SrgbToLinear(pixel[1] / 255.f);
      rgba[2] = SrgbToLinear(pixel[2] / 255.f);
      rgba[3] = pixel[3] / 255.f;
      return true;
    }
    case reshade::api::format::b8g8r8a8_unorm: {
      rgba[0] = pixel[2] / 255.f;
      rgba[1] = pixel[1] / 255.f;
      rgba[2] = pixel[0] / 255.f;
      rgba[3] = pixel[3] / 255.f;
      return true;
    }
    case reshade::api::format::b8g8r8a8_unorm_srgb: {
      rgba[0] = SrgbToLinear(pixel[2] / 255.f);
      rgba[1] = SrgbToLinear(pixel[1] / 255.f);
      rgba[2] = SrgbToLinear(pixel[0] / 255.f);
      rgba[3] = pixel[3] / 255.f;
      return true;
    }
    case reshade::api::format::r8g8b8x8_unorm: {
      rgba[0] = pixel[0] / 255.f;
      rgba[1] = pixel[1] / 255.f;
      rgba[2] = pixel[2] / 255.f;
      rgba[3] = 1.f;
      return true;
    }
    case reshade::api::format::r8g8b8x8_unorm_srgb: {
      rgba[0] = SrgbToLinear(pixel[0] / 255.f);
      rgba[1] = SrgbToLinear(pixel[1] / 255.f);
      rgba[2] = SrgbToLinear(pixel[2] / 255.f);
      rgba[3] = 1.f;
      return true;
    }
    case reshade::api::format::b8g8r8x8_unorm: {
      rgba[0] = pixel[2] / 255.f;
      rgba[1] = pixel[1] / 255.f;
      rgba[2] = pixel[0] / 255.f;
      rgba[3] = 1.f;
      return true;
    }
    case reshade::api::format::b8g8r8x8_unorm_srgb: {
      rgba[0] = SrgbToLinear(pixel[2] / 255.f);
      rgba[1] = SrgbToLinear(pixel[1] / 255.f);
      rgba[2] = SrgbToLinear(pixel[0] / 255.f);
      rgba[3] = 1.f;
      return true;
    }
    case reshade::api::format::r10g10b10a2_unorm: {
      const auto packed = *reinterpret_cast<const uint32_t*>(pixel);
      rgba[0] = ((packed >> 0) & 0x3FFu) / 1023.f;
      rgba[1] = ((packed >> 10) & 0x3FFu) / 1023.f;
      rgba[2] = ((packed >> 20) & 0x3FFu) / 1023.f;
      rgba[3] = ((packed >> 30) & 0x3u) / 3.f;
      return true;
    }
    case reshade::api::format::b10g10r10a2_unorm: {
      const auto packed = *reinterpret_cast<const uint32_t*>(pixel);
      rgba[2] = ((packed >> 0) & 0x3FFu) / 1023.f;
      rgba[1] = ((packed >> 10) & 0x3FFu) / 1023.f;
      rgba[0] = ((packed >> 20) & 0x3FFu) / 1023.f;
      rgba[3] = ((packed >> 30) & 0x3u) / 3.f;
      return true;
    }
    case reshade::api::format::r11g11b10_float: {
      const auto packed = *reinterpret_cast<const uint32_t*>(pixel);
      rgba[0] = DecodeR11Component((packed >> 0) & 0x7FFu);
      rgba[1] = DecodeR11Component((packed >> 11) & 0x7FFu);
      rgba[2] = DecodeR10Component((packed >> 22) & 0x3FFu);
      rgba[3] = 1.f;
      return true;
    }
    case reshade::api::format::r16_float: {
      rgba[0] = DecodeFloat16(*reinterpret_cast<const uint16_t*>(pixel));
      rgba[1] = 0.f;
      rgba[2] = 0.f;
      rgba[3] = 1.f;
      channel_count = 1u;
      return true;
    }
    case reshade::api::format::r16g16b16a16_float: {
      const auto* packed = reinterpret_cast<const uint16_t*>(pixel);
      rgba[0] = DecodeFloat16(packed[0]);
      rgba[1] = DecodeFloat16(packed[1]);
      rgba[2] = DecodeFloat16(packed[2]);
      rgba[3] = DecodeFloat16(packed[3]);
      return true;
    }
    default:
      return false;
  }
}

[[nodiscard]] inline ToolResult PerformResourceAnalysis(
    const ProcessingContext& context,
    std::uint32_t device_index,
    reshade::api::device* device,
    reshade::api::command_queue* queue,
    reshade::api::resource_view resource_view,
    const std::optional<std::filesystem::path>& output_path,
    PreviewMode preview_mode,
    std::string_view preview_mode_name,
    bool prefer_clone) {
  AnalysisTarget target = {};
  try {
    target = ResolveAnalysisTarget(resource_view, device, prefer_clone);
  } catch (const std::exception& exception) {
    auto error = std::string(exception.what());
    if (error.starts_with("resourceViewHandle ")) {
      error = std::format("resourceViewHandle {} is not currently tracked.", FormatHandle(context, resource_view.handle));
    }
    return ToolResult{
        .text = error,
        .structured_content = json{{"error", error}},
        .is_error = true,
    };
  }

  if (target.resolved_resource_desc.type != reshade::api::resource_type::texture_2d
      && target.resolved_resource_desc.type != reshade::api::resource_type::surface) {
    return ToolResult{
        .text = "Only 2D texture resource views are currently supported.",
        .structured_content = json{{"error", "Only 2D texture resource views are currently supported."}},
        .is_error = true,
    };
  }
  if (target.resolved_resource_desc.texture.samples != 1u) {
    return ToolResult{
        .text = "Multisampled resources are not currently supported.",
        .structured_content = json{{"error", "Multisampled resources are not currently supported."}},
        .is_error = true,
    };
  }

  const auto first_level = target.resolved_view_desc.texture.first_level;
  const auto first_layer = target.resolved_view_desc.texture.first_layer;
  const auto levels = std::max<uint32_t>(target.resolved_resource_desc.texture.levels, 1u);
  const auto subresource = first_level + (first_layer * levels);
  const auto width = std::max<uint32_t>(target.resolved_resource_desc.texture.width >> first_level, 1u);
  const auto height = std::max<uint32_t>(target.resolved_resource_desc.texture.height >> first_level, 1u);
  const auto intermediate_format = reshade::api::format_to_default_typed(target.resolved_resource_desc.texture.format, 0);
  const auto analysis_format = target.resolved_view_desc.format != reshade::api::format::unknown
                                   ? target.resolved_view_desc.format
                                   : intermediate_format;

  reshade::api::resource intermediate = {0u};
  if (!device->create_resource(
          reshade::api::resource_desc(
              width,
              height,
              1,
              1,
              intermediate_format,
              1,
              reshade::api::memory_heap::gpu_to_cpu,
              reshade::api::resource_usage::copy_dest),
          nullptr,
          reshade::api::resource_usage::copy_dest,
          &intermediate)) {
    return ToolResult{
        .text = "Failed to create a GPU-to-CPU readback resource.",
        .structured_content = json{{"error", "Failed to create a GPU-to-CPU readback resource."}},
        .is_error = true,
    };
  }

  auto* cmd_list = queue->get_immediate_command_list();
  cmd_list->copy_texture_region(target.resolved_resource, subresource, nullptr, intermediate, 0, nullptr);
  queue->flush_immediate_command_list();
  queue->wait_idle();

  ToolResult tool_result = {
      .text = "Failed to map the readback resource.",
      .structured_content = json{{"error", "Failed to map the readback resource."}},
      .is_error = true,
  };
  reshade::api::subresource_data mapped_data = {};
  if (device->map_texture_region(intermediate, 0, nullptr, reshade::api::map_access::read_only, &mapped_data)) {
    double channel_min[4] = {
        std::numeric_limits<double>::infinity(),
        std::numeric_limits<double>::infinity(),
        std::numeric_limits<double>::infinity(),
        std::numeric_limits<double>::infinity(),
    };
    double channel_max[4] = {
        -std::numeric_limits<double>::infinity(),
        -std::numeric_limits<double>::infinity(),
        -std::numeric_limits<double>::infinity(),
        -std::numeric_limits<double>::infinity(),
    };
    double channel_sum[4] = {0.0, 0.0, 0.0, 0.0};
    double luminance_min = std::numeric_limits<double>::infinity();
    double luminance_max = -std::numeric_limits<double>::infinity();
    double luminance_sum = 0.0;
    uint32_t channel_count = 4u;
    uint64_t pixel_count = 0u;
    uint64_t finite_pixel_count = 0u;
    uint64_t nan_pixel_count = 0u;
    uint64_t inf_pixel_count = 0u;
    uint64_t pixels_all_rgb_zero = 0u;
    uint64_t pixels_any_negative = 0u;
    uint64_t pixels_any_at_or_above_one = 0u;
    uint64_t pixels_any_above_one = 0u;
    uint64_t pixels_any_above_two = 0u;
    uint64_t pixels_any_above_four = 0u;
    bool supported_format = true;
    std::vector<std::uint8_t> preview_pixels;
    std::vector<float> exr_pixels;
    const auto output_format = output_path.has_value()
                                   ? GetOutputFormat(output_path.value())
                                   : OutputFormat::PNG;
    if (output_path.has_value() && output_format == OutputFormat::PNG) {
      preview_pixels.resize(static_cast<size_t>(width) * static_cast<size_t>(height) * 4u);
    }
    if (output_path.has_value() && output_format == OutputFormat::EXR) {
      if (analysis_format != reshade::api::format::r16g16b16a16_float) {
        exr_pixels.resize(static_cast<size_t>(width) * static_cast<size_t>(height) * 4u);
      }
    }

    for (uint32_t y = 0; y < height && supported_format; ++y) {
      const auto* row = static_cast<const std::uint8_t*>(mapped_data.data) + (static_cast<size_t>(mapped_data.row_pitch) * y);
      const auto pixel_stride = static_cast<size_t>(reshade::api::format_row_pitch(intermediate_format, 1));
      for (uint32_t x = 0; x < width; ++x) {
        float rgba[4] = {0.f, 0.f, 0.f, 1.f};
        uint32_t decoded_channel_count = 4u;
        const auto* pixel = row + (pixel_stride * x);
        if (!DecodePixelToLinear(analysis_format, pixel, rgba, decoded_channel_count)) {
          supported_format = false;
          break;
        }
        if (!preview_pixels.empty()) {
          EncodePreviewPixel(
              rgba,
              preview_mode,
              preview_pixels.data() + ((static_cast<size_t>(y) * static_cast<size_t>(width) + static_cast<size_t>(x)) * 4u));
        }
        if (!exr_pixels.empty()) {
          auto* out_pixel = exr_pixels.data() + ((static_cast<size_t>(y) * static_cast<size_t>(width) + static_cast<size_t>(x)) * 4u);
          out_pixel[0] = rgba[0];
          out_pixel[1] = rgba[1];
          out_pixel[2] = rgba[2];
          out_pixel[3] = rgba[3];
        }
        ++pixel_count;
        channel_count = decoded_channel_count;

        bool has_nan = false;
        bool has_inf = false;
        for (uint32_t channel = 0; channel < 4u; ++channel) {
          has_nan |= std::isnan(rgba[channel]);
          has_inf |= std::isinf(rgba[channel]);
        }
        if (has_nan) ++nan_pixel_count;
        if (has_inf) ++inf_pixel_count;
        if (has_nan || has_inf) continue;

        ++finite_pixel_count;

        const auto any_negative = rgba[0] < 0.f || rgba[1] < 0.f || rgba[2] < 0.f;
        const auto any_at_or_above_one = rgba[0] >= 1.f || rgba[1] >= 1.f || rgba[2] >= 1.f;
        const auto any_above_one = rgba[0] > 1.f || rgba[1] > 1.f || rgba[2] > 1.f;
        const auto any_above_two = rgba[0] > 2.f || rgba[1] > 2.f || rgba[2] > 2.f;
        const auto any_above_four = rgba[0] > 4.f || rgba[1] > 4.f || rgba[2] > 4.f;
        const auto all_rgb_zero = rgba[0] == 0.f && rgba[1] == 0.f && rgba[2] == 0.f;

        pixels_any_negative += any_negative ? 1u : 0u;
        pixels_any_at_or_above_one += any_at_or_above_one ? 1u : 0u;
        pixels_any_above_one += any_above_one ? 1u : 0u;
        pixels_any_above_two += any_above_two ? 1u : 0u;
        pixels_any_above_four += any_above_four ? 1u : 0u;
        pixels_all_rgb_zero += all_rgb_zero ? 1u : 0u;

        for (uint32_t channel = 0; channel < 4u; ++channel) {
          channel_min[channel] = std::min(channel_min[channel], static_cast<double>(rgba[channel]));
          channel_max[channel] = std::max(channel_max[channel], static_cast<double>(rgba[channel]));
          channel_sum[channel] += rgba[channel];
        }

        const auto luminance = (0.2126 * rgba[0]) + (0.7152 * rgba[1]) + (0.0722 * rgba[2]);
        luminance_min = std::min(luminance_min, luminance);
        luminance_max = std::max(luminance_max, luminance);
        luminance_sum += luminance;
      }
    }

    if (!supported_format) {
      device->unmap_texture_region(intermediate, 0);
      const auto error = std::format("Readback is not implemented for format {}.", FormatFormat(context, analysis_format));
      tool_result = ToolResult{
          .text = error,
          .structured_content = json{{"error", error}},
          .is_error = true,
      };
    } else {
      json output_json = nullptr;
      std::optional<std::string> output_error = std::nullopt;
      if (output_path.has_value()) {
        std::error_code filesystem_error;
        const auto parent_path = output_path->parent_path();
        if (!parent_path.empty()) {
          std::filesystem::create_directories(parent_path, filesystem_error);
        }
        if (filesystem_error) {
          output_error = std::format(
              "Failed to create output directory '{}': {}",
              output_path->parent_path().string(),
              filesystem_error.message());
        } else {
          switch (output_format) {
            case OutputFormat::PNG:
              if (!WritePngPreview(output_path.value(), width, height, preview_pixels)) {
                output_error = std::format(
                    "Failed to write preview PNG to '{}'.",
                    output_path->string());
              } else {
                output_json = json{
                    {"path", output_path->string()},
                    {"format", "png"},
                    {"mode", preview_mode_name},
                    {"width", width},
                    {"height", height},
                };
              }
              break;
            case OutputFormat::EXR:
              try {
                if (analysis_format == reshade::api::format::r16g16b16a16_float) {
                  if ((mapped_data.row_pitch % sizeof(std::uint16_t)) != 0u) {
                    output_error = std::format(
                        "Mapped RGBA16F readback row pitch ({}) is not aligned to 16-bit values.",
                        mapped_data.row_pitch);
                    break;
                  }

                  const auto row_stride_values = static_cast<size_t>(mapped_data.row_pitch) / sizeof(std::uint16_t);
                  const auto total_values = row_stride_values * static_cast<size_t>(height);
                  const auto* half_pixels = static_cast<const std::uint16_t*>(mapped_data.data);
                  renodx::utils::exr::WriteRgba16f(
                      output_path.value(),
                      width,
                      height,
                      std::span<const std::uint16_t>(half_pixels, total_values),
                      row_stride_values);
                } else {
                  renodx::utils::exr::WriteRgba16f(
                      output_path.value(),
                      width,
                      height,
                      std::span<const float>(exr_pixels.data(), exr_pixels.size()));
                }
                output_json = json{
                    {"path", output_path->string()},
                    {"format", "exr"},
                    {"layout", "scanline"},
                    {"compression", "none"},
                    {"pixelType", "rgba16f"},
                    {"width", width},
                    {"height", height},
                };
              } catch (const std::exception& exception) {
                output_error = std::format(
                    "Failed to write RGBA16F EXR dump to '{}': {}",
                    output_path->string(),
                    exception.what());
              }
              break;
          }
        }
      }

      device->unmap_texture_region(intermediate, 0);

      if (output_error.has_value()) {
        tool_result = ToolResult{
            .text = output_error.value(),
            .structured_content = json{{"error", output_error.value()}},
            .is_error = true,
        };
        device->destroy_resource(intermediate);
        return tool_result;
      }

      auto resource_view_json = context.build_resource_view_summary
                                    ? json(context.build_resource_view_summary(resource_view, device))
                                    : json(nullptr);
      json analysis_target_json = {
          {"preferClone", prefer_clone},
          {"usedClone", target.used_clone},
          {"requestedResourceViewHandle", FormatHandle(context, resource_view.handle)},
          {"resolvedResourceViewHandle", FormatHandle(context, target.resolved_view.handle)},
          {"resolvedResourceHandle", FormatHandle(context, target.resolved_resource.handle)},
          {"resolvedViewType", std::format("{}", static_cast<std::uint32_t>(target.resolved_view_desc.type))},
          {"resolvedViewFormat", FormatFormat(context, analysis_format)},
          {"resolvedResourceType", std::format("{}", static_cast<std::uint32_t>(target.resolved_resource_desc.type))},
          {"resolvedResourceFormat", target.resolved_resource_desc.type == reshade::api::resource_type::buffer
                                         ? json(nullptr)
                                         : json(FormatFormat(context, target.resolved_resource_desc.texture.format))},
      };
      json result = {
          {"deviceIndex", device_index},
          {"resourceViewHandle", FormatHandle(context, resource_view.handle)},
          {"resourceView", resource_view_json},
          {"analysisTarget", analysis_target_json},
          {
              "analysis",
              {
                  {"snapshotExact", false},
                  {"note", "This reads the current contents of the live resource view, not a frozen historical copy from the snapshot cache."},
                  {"subresourceIndex", subresource},
                  {"width", width},
                  {"height", height},
                  {"analysisFormat", FormatFormat(context, analysis_format)},
                  {"intermediateFormat", FormatFormat(context, intermediate_format)},
                  {"channelCount", channel_count},
                  {"pixelCount", pixel_count},
                  {"finitePixels", RatioStats(finite_pixel_count, pixel_count)},
                  {"nanPixels", RatioStats(nan_pixel_count, pixel_count)},
                  {"infPixels", RatioStats(inf_pixel_count, pixel_count)},
                  {"pixelsAllRgbZero", RatioStats(pixels_all_rgb_zero, pixel_count)},
                  {"pixelsAnyNegative", RatioStats(pixels_any_negative, pixel_count)},
                  {"pixelsAnyChannelAtOrAbove1", RatioStats(pixels_any_at_or_above_one, pixel_count)},
                  {"pixelsAnyChannelAbove1", RatioStats(pixels_any_above_one, pixel_count)},
                  {"pixelsAnyChannelAbove2", RatioStats(pixels_any_above_two, pixel_count)},
                  {"pixelsAnyChannelAbove4", RatioStats(pixels_any_above_four, pixel_count)},
                  {
                      "channels",
                      {
                          {"r", ScalarStats(channel_min[0], channel_max[0], channel_sum[0], finite_pixel_count)},
                          {"g", ScalarStats(channel_min[1], channel_max[1], channel_sum[1], finite_pixel_count)},
                          {"b", ScalarStats(channel_min[2], channel_max[2], channel_sum[2], finite_pixel_count)},
                          {"a", ScalarStats(channel_min[3], channel_max[3], channel_sum[3], finite_pixel_count)},
                      },
                  },
                  {"luminance", ScalarStats(luminance_min, luminance_max, luminance_sum, finite_pixel_count)},
              },
          },
      };
      if (!output_json.is_null()) {
        if (output_format == OutputFormat::PNG) {
          result["preview"] = output_json;
        } else {
          result["dump"] = output_json;
        }
      }

      std::string text;
      const auto analyzed_view_handle = FormatHandle(context, target.resolved_view.handle);
      const auto* const analyzed_view_label = target.used_clone ? "clone resource view" : "resource view";
      if (output_path.has_value()) {
        if (output_format == OutputFormat::PNG) {
          text = std::format(
              "Analyzed {}x{} {} {} {} on device #{}. Saved a {} preview to '{}'. {} pixel(s) are above 1.0 in at least one RGB channel.",
              width,
              height,
              FormatFormat(context, analysis_format),
              analyzed_view_label,
              analyzed_view_handle,
              device_index,
              preview_mode_name,
              output_path->string(),
              pixels_any_above_one);
        } else {
          text = std::format(
              "Analyzed {}x{} {} {} {} on device #{}. Saved an RGBA16F EXR dump to '{}'. {} pixel(s) are above 1.0 in at least one RGB channel.",
              width,
              height,
              FormatFormat(context, analysis_format),
              analyzed_view_label,
              analyzed_view_handle,
              device_index,
              output_path->string(),
              pixels_any_above_one);
        }
      } else {
        text = std::format(
            "Analyzed {}x{} {} {} {} on device #{}. {} pixel(s) are above 1.0 in at least one RGB channel.",
            width,
            height,
            FormatFormat(context, analysis_format),
            analyzed_view_label,
            analyzed_view_handle,
            device_index,
            pixels_any_above_one);
      }
      tool_result = ToolResult{
          .text = text,
          .structured_content = result,
      };
    }
  }

  device->destroy_resource(intermediate);
  return tool_result;
}

}  // namespace internal

[[nodiscard]] inline ToolResult HandleAnalyzeResourceTool(const json& arguments, const ToolContext& context) {
  if (!context.resolve_device_index || !context.enqueue_request) {
    throw std::runtime_error("AnalyzeResourceToolContext is not initialized.");
  }

  const auto resource_view_handle = resource_handle::GetRequired(arguments, "resourceViewHandle");
  const auto device_index = context.resolve_device_index(arguments);
  const auto output_path_value = mcp_arguments::GetOptional<std::string>(arguments, "outputPath").value_or("");
  const auto preview_mode_value = mcp_arguments::GetOptional<std::string>(arguments, "previewMode").value_or("clamped");
  const auto preview_mode = internal::ParsePreviewMode(preview_mode_value);
  const auto prefer_clone = mcp_arguments::GetOptional<bool>(arguments, "preferClone").value_or(false);

  std::optional<std::filesystem::path> output_path = std::nullopt;
  if (!output_path_value.empty()) {
    auto requested_path = std::filesystem::path(output_path_value);
    if (!requested_path.is_absolute()) {
      throw std::runtime_error("outputPath must be an absolute path.");
    }
    if (!requested_path.has_extension()) {
      requested_path.replace_extension(L".png");
    } else if (requested_path.extension() != L".png" && requested_path.extension() != L".exr") {
      throw std::runtime_error("outputPath must end in '.png' or '.exr'.");
    }
    output_path = requested_path.lexically_normal();
  }

  auto request = std::make_shared<PendingRequest>();
  request->resource_view = reshade::api::resource_view{resource_view_handle};
  request->output_path = std::move(output_path);
  request->preview_mode = preview_mode;
  request->preview_mode_name = std::string(internal::GetPreviewModeName(preview_mode));
  request->prefer_clone = prefer_clone;

  if (!context.enqueue_request(device_index, request)) {
    const auto error = std::format("Failed to queue the resource analysis request for device #{}.", device_index);
    return ToolResult{
        .text = error,
        .structured_content = json{{"error", error}},
        .is_error = true,
    };
  }

  {
    std::unique_lock request_lock(request->mutex);
    if (!request->cv.wait_for(request_lock, std::chrono::seconds(15), [&request] { return request->completed || request->started; })) {
      request->canceled = true;
      request_lock.unlock();
      if (context.cancel_request) {
        context.cancel_request(device_index, request);
      }
      return ToolResult{
          .text = "Timed out waiting for the next present to process the resource analysis request.",
          .structured_content = json{{"error", "Timed out waiting for the next present to process the resource analysis request."}},
          .is_error = true,
      };
    }

    if (!request->completed) {
      request->cv.wait(request_lock, [&request] { return request->completed; });
    }
  }

  if (!request->result.has_value()) {
    return ToolResult{
        .text = "The resource analysis request completed without a result.",
        .structured_content = json{{"error", "The resource analysis request completed without a result."}},
        .is_error = true,
    };
  }

  return request->result.value();
}

inline void ProcessPendingRequests(
    const std::deque<std::shared_ptr<PendingRequest>>& requests,
    std::uint32_t device_index,
    reshade::api::device* device,
    reshade::api::command_queue* queue,
    const ProcessingContext& context) {
  for (const auto& request : requests) {
    {
      std::scoped_lock request_lock(request->mutex);
      if (request->completed || request->canceled) {
        request->completed = true;
        request->cv.notify_all();
        continue;
      }
      request->started = true;
    }
    request->cv.notify_all();

    ToolResult result = {
        .text = "Unknown resource analysis failure.",
        .structured_content = json{{"error", "Unknown resource analysis failure."}},
        .is_error = true,
    };
    try {
      result = internal::PerformResourceAnalysis(
          context,
          device_index,
          device,
          queue,
          request->resource_view,
          request->output_path,
          request->preview_mode,
          request->preview_mode_name,
          request->prefer_clone);
    } catch (const std::exception& exception) {
      result = ToolResult{
          .text = exception.what(),
          .structured_content = json{{"error", exception.what()}},
          .is_error = true,
      };
    }

    {
      std::scoped_lock request_lock(request->mutex);
      request->result = std::move(result);
      request->completed = true;
    }
    request->cv.notify_all();
  }
}

}  // namespace renodx::addons::devkit::mcp::resource_analysis
