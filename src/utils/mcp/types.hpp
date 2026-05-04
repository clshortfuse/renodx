/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <cstdint>
#include <functional>
#include <map>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

#include "../json_rpc.hpp"

namespace renodx::utils::mcp {

using json = renodx::utils::json_rpc::json;

struct InputSchemaProperty {
  std::vector<std::string> types;
  std::optional<std::int64_t> minimum = std::nullopt;
  std::optional<std::int64_t> maximum = std::nullopt;
  std::vector<std::string> enum_values;
  std::vector<std::string> item_types;
  std::vector<std::string> item_enum_values;
};

struct InputSchema {
  std::vector<std::pair<std::string, InputSchemaProperty>> properties;
  std::vector<std::string> required;
  bool additional_properties = false;
};

struct ToolAnnotations {
  bool read_only_hint = false;

  [[nodiscard]] bool IsEmpty() const {
    return !read_only_hint;
  }
};

struct ToolMetadata {
  std::string_view title;
  std::string_view description;
  InputSchema input_schema = {};
  ToolAnnotations annotations = {};
};

using ToolCatalog = std::map<std::string_view, ToolMetadata>;

struct ToolDescriptor {
  std::string_view name;
  ToolMetadata metadata;
};

struct ToolResult {
  std::string text;
  json structured_content = nullptr;
  bool is_error = false;
};

struct Tool {
  std::string name;
  std::string title;
  std::string description;
  InputSchema input_schema = {};
  ToolAnnotations annotations = {};
  std::function<ToolResult(const json& arguments)> handler;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& value, const InputSchemaProperty& property) {
  if (property.types.empty()) {
    throw std::logic_error("InputSchemaProperty.types must not be empty.");
  }
  if (property.item_types.empty() && !property.item_enum_values.empty()) {
    throw std::logic_error("InputSchemaProperty.item_enum_values requires item_types.");
  }

  value = json::object();
  if (property.types.size() == 1u) {
    value["type"] = property.types.front();
  } else {
    value["type"] = property.types;
  }
  if (property.minimum.has_value()) {
    value["minimum"] = property.minimum.value();
  }
  if (property.maximum.has_value()) {
    value["maximum"] = property.maximum.value();
  }
  if (!property.enum_values.empty()) {
    value["enum"] = property.enum_values;
  }
  if (!property.item_types.empty()) {
    json items = json::object();
    if (property.item_types.size() == 1u) {
      items["type"] = property.item_types.front();
    } else {
      items["type"] = property.item_types;
    }
    if (!property.item_enum_values.empty()) {
      items["enum"] = property.item_enum_values;
    }
    value["items"] = items;
  }
}

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& value, const InputSchema& schema) {
  json properties = json::object();
  for (const auto& [field_name, property] : schema.properties) {
    properties[field_name] = property;
  }

  value = json{
      {"type", "object"},
      {"properties", properties},
      {"additionalProperties", schema.additional_properties},
  };
  if (!schema.required.empty()) {
    value["required"] = schema.required;
  }
}

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& value, const ToolAnnotations& annotations) {
  value = json::object();
  if (annotations.read_only_hint) {
    value["readOnlyHint"] = true;
  }
}

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& value, const ToolDescriptor& descriptor) {
  value = json{
      {"name", descriptor.name},
      {"description", descriptor.metadata.description},
      {"inputSchema", descriptor.metadata.input_schema},
  };
  if (!descriptor.metadata.title.empty()) {
    value["title"] = descriptor.metadata.title;
  }
  if (!descriptor.metadata.annotations.IsEmpty()) {
    value["annotations"] = descriptor.metadata.annotations;
  }
}

}  // namespace renodx::utils::mcp
