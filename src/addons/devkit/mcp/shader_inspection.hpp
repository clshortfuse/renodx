/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstddef>
#include <cstdint>
#include <format>
#include <functional>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

#include "../../../utils/mcp/types.hpp"
#include "shader_hash.hpp"
#include "shader_summary.hpp"

namespace renodx::addons::devkit::mcp::shader_inspection {

using json = renodx::utils::mcp::json;
using ToolResult = renodx::utils::mcp::ToolResult;

enum class ViewMode : std::uint8_t {
  SUMMARY = 0b00000000,
  DISASSEMBLY = 0b00000001,
  DECOMPILATION = 0b00000010,
  ALL = 0b11111111,
};

struct TextSection {
  bool available = false;
  std::string text;
  std::optional<std::string> error = std::nullopt;
};

struct TextSectionSummary {
  bool available = false;
  std::optional<std::string> text = std::nullopt;
  std::optional<std::size_t> full_length = std::nullopt;
  std::optional<std::size_t> returned_length = std::nullopt;
  bool truncated = false;
  std::optional<std::string> error = std::nullopt;

  TextSectionSummary() = default;

  TextSectionSummary(const TextSection& section, const std::optional<std::size_t>& max_text_length)
      : available(section.available),
        error(section.error) {
    if (!section.available) {
      return;
    }

    auto returned_text_value = section.text;
    const auto full_length_value = returned_text_value.size();
    bool truncated_value = false;
    if (max_text_length.has_value() && returned_text_value.size() > max_text_length.value()) {
      returned_text_value.resize(max_text_length.value());
      truncated_value = true;
    }

    text = returned_text_value;
    full_length = full_length_value;
    returned_length = truncated_value ? max_text_length.value() : full_length_value;
    truncated = truncated_value;
  }
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const TextSectionSummary& value) {
  j = {
      {"available", value.available},
  };
  if (value.error.has_value()) {
    j["error"] = value.error.value();
  }
  if (value.text.has_value()) {
    j["text"] = value.text.value();
    j["fullLength"] = value.full_length.value();
    j["returnedLength"] = value.returned_length.value();
    j["truncated"] = value.truncated;
  }
}

struct ToolContext {
  std::function<std::uint32_t(const json& arguments)> resolve_device_index;
  std::function<shader_summary::TrackedShaderSummary(std::uint32_t device_index, std::uint32_t shader_hash)>
      get_shader_summary;
  std::function<TextSection(std::uint32_t device_index, std::uint32_t shader_hash)> get_disassembly;
  std::function<TextSection(std::uint32_t device_index, std::uint32_t shader_hash)> get_decompilation;
};

namespace internal {

[[nodiscard]] inline ViewMode ParseViewMode(std::string_view value) {
  if (value == "summary") return ViewMode::SUMMARY;
  if (value == "disassembly") return ViewMode::DISASSEMBLY;
  if (value == "decompilation") return ViewMode::DECOMPILATION;
  if (value == "all") return ViewMode::ALL;

  throw std::runtime_error(
      std::format("view '{}' is invalid. Expected 'summary', 'disassembly', 'decompilation', or 'all'.", value));
}

[[nodiscard]] inline ViewMode ParseViewSection(std::string_view value) {
  if (value == "disassembly") return ViewMode::DISASSEMBLY;
  if (value == "decompilation") return ViewMode::DECOMPILATION;

  throw std::runtime_error(
      std::format("views entries must be 'disassembly' or 'decompilation', not '{}'.", value));
}

[[nodiscard]] constexpr std::uint8_t GetViewModeBits(ViewMode view_mode) {
  return static_cast<std::uint8_t>(view_mode);
}

[[nodiscard]] constexpr bool HasViewModeFlag(ViewMode view_mode, ViewMode flag) {
  return (GetViewModeBits(view_mode) & GetViewModeBits(flag)) != 0u;
}

[[nodiscard]] constexpr ViewMode AddViewModeFlag(ViewMode view_mode, ViewMode flag) {
  return static_cast<ViewMode>(GetViewModeBits(view_mode) | GetViewModeBits(flag));
}

[[nodiscard]] inline std::string_view GetViewModeName(ViewMode view_mode) {
  if (view_mode == ViewMode::ALL) {
    return "all";
  }

  const auto view_mode_bits = GetViewModeBits(view_mode);
  if (view_mode == ViewMode::SUMMARY) {
    return "summary";
  }
  if (view_mode_bits == (GetViewModeBits(ViewMode::DISASSEMBLY) | GetViewModeBits(ViewMode::DECOMPILATION))) {
    return "all";
  }
  if (view_mode_bits == GetViewModeBits(ViewMode::DISASSEMBLY)) {
    return "disassembly";
  }
  if (view_mode_bits == GetViewModeBits(ViewMode::DECOMPILATION)) {
    return "decompilation";
  }

  return "all";
}

[[nodiscard]] inline std::vector<std::string> GetViewSectionNames(ViewMode view_mode) {
  std::vector<std::string> section_names;
  if (HasViewModeFlag(view_mode, ViewMode::DISASSEMBLY)) {
    section_names.emplace_back("disassembly");
  }
  if (HasViewModeFlag(view_mode, ViewMode::DECOMPILATION)) {
    section_names.emplace_back("decompilation");
  }
  return section_names;
}

[[nodiscard]] inline ViewMode GetRequestedViewMode(const json& arguments) {
  if (arguments.contains("view") && arguments.contains("views")) {
    throw std::runtime_error("Specify either view or views, not both.");
  }

  if (arguments.contains("views")) {
    const auto& views = arguments["views"];
    if (!views.is_array()) {
      throw std::runtime_error("views must be an array of strings.");
    }

    auto view_mode = ViewMode::SUMMARY;
    for (const auto& value : views) {
      if (!value.is_string()) {
        throw std::runtime_error("views must be an array of strings.");
      }
      view_mode = AddViewModeFlag(view_mode, ParseViewSection(value.get<std::string>()));
    }

    return view_mode;
  }

  if (arguments.contains("view")) {
    if (!arguments["view"].is_string()) {
      throw std::runtime_error("view must be a string.");
    }

    return ParseViewMode(arguments["view"].get<std::string>());
  }

  return ViewMode::ALL;
}

[[nodiscard]] inline std::optional<std::size_t> GetOptionalMaxTextLength(
    const json& arguments,
    std::string_view key) {
  if (!arguments.contains(key)) {
    return std::nullopt;
  }

  const auto& value = arguments[std::string(key)];
  if (!value.is_number_unsigned()) {
    throw std::runtime_error(std::format("{} must be a positive integer.", key));
  }

  const auto parsed_value = value.get<std::uint64_t>();
  if (parsed_value == 0u) {
    throw std::runtime_error(std::format("{} must be greater than zero.", key));
  }

  return static_cast<std::size_t>(parsed_value);
}

[[nodiscard]] inline std::string DescribeSections(const std::vector<std::string_view>& section_names) {
  if (section_names.empty()) return "summary";
  if (section_names.size() == 1u) return std::string(section_names.front());
  if (section_names.size() == 2u) {
    return std::format("{} and {}", section_names[0], section_names[1]);
  }

  std::string description;
  for (std::size_t index = 0; index < section_names.size(); ++index) {
    if (!description.empty()) {
      description += index + 1u == section_names.size() ? ", and " : ", ";
    }
    description += section_names[index];
  }
  return description;
}

[[nodiscard]] inline std::string FormatShaderHash(std::uint32_t shader_hash) {
  return std::format("0x{:08X}", shader_hash);
}

}  // namespace internal

inline ToolResult HandleGetShaderTool(const json& arguments, const ToolContext& context) {
  if (!context.resolve_device_index || !context.get_shader_summary) {
    throw std::runtime_error("The shader inspection tool context is not configured.");
  }

  const auto device_index = context.resolve_device_index(arguments);
  const auto shader_hash = shader_hash::GetRequired(arguments, "shaderHash");
  const auto view_mode = internal::GetRequestedViewMode(arguments);
  const auto max_text_length = internal::GetOptionalMaxTextLength(arguments, "maxTextLength");
  auto shader_summary = context.get_shader_summary(device_index, shader_hash);

  json result = {
      {"deviceIndex", device_index},
      {"view", internal::GetViewModeName(view_mode)},
      {"views", internal::GetViewSectionNames(view_mode)},
      {"shader", shader_summary},
  };

  json sections = json::object();
  std::vector<std::string_view> section_names;
  std::size_t unavailable_sections = 0u;

  const auto append_section = [&](std::string_view key, const std::function<TextSection(std::uint32_t, std::uint32_t)>& callback) {
    if (!callback) {
      sections[std::string(key)] = TextSectionSummary(
          TextSection{
              .available = false,
              .error = std::format("{} is not available in this MCP session.", key),
          },
          max_text_length);
      unavailable_sections += 1u;
      section_names.push_back(key);
      return;
    }

    auto section = callback(device_index, shader_hash);
    if (!section.available) {
      unavailable_sections += 1u;
    }
    sections[std::string(key)] = TextSectionSummary(section, max_text_length);
    section_names.push_back(key);
  };

  if (internal::HasViewModeFlag(view_mode, ViewMode::DISASSEMBLY)) {
    append_section("disassembly", context.get_disassembly);
  }
  if (internal::HasViewModeFlag(view_mode, ViewMode::DECOMPILATION)) {
    append_section("decompilation", context.get_decompilation);
  }

  if (!sections.empty()) {
    result["sections"] = sections;
  }

  auto text = std::format(
      "Returned shader {} from device #{}.",
      internal::FormatShaderHash(shader_hash),
      device_index);
  if (!section_names.empty()) {
    text += std::format(" Included {}.", internal::DescribeSections(section_names));
  }
  if (unavailable_sections != 0u) {
    text += std::format(" {} requested section(s) were unavailable.", unavailable_sections);
  }

  return ToolResult{
      .text = text,
      .structured_content = result,
  };
}

}  // namespace renodx::addons::devkit::mcp::shader_inspection
