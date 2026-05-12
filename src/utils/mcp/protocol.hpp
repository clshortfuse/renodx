/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <array>
#include <optional>
#include <string>
#include <string_view>

#include "./types.hpp"

namespace renodx::utils::mcp {

inline constexpr std::string_view PROTOCOL_VERSION = "2025-11-25";
inline constexpr std::string_view PROTOCOL_VERSION_2025_06_18 = "2025-06-18";
inline constexpr std::array<std::string_view, 2> SUPPORTED_PROTOCOL_VERSIONS = {
    PROTOCOL_VERSION,
    PROTOCOL_VERSION_2025_06_18,
};
inline constexpr std::string_view TRANSPORT_MESSAGE_NAME = "mcp";
inline constexpr std::string_view METHOD_INITIALIZE = "initialize";
inline constexpr std::string_view METHOD_PING = "ping";
inline constexpr std::string_view METHOD_TOOLS_LIST = "tools/list";
inline constexpr std::string_view METHOD_TOOLS_CALL = "tools/call";
inline constexpr std::string_view NOTIFICATION_INITIALIZED = "notifications/initialized";
inline constexpr int SESSION_NOT_INITIALIZED = -32000;

struct InitializeToolsCapabilities {
  bool list_changed = false;
};

struct InitializeCapabilities {
  InitializeToolsCapabilities tools = {};
};

struct ServerInfo {
  std::string_view name;
  std::string_view title;
  std::string_view version;
};

struct InitializeResult {
  std::string_view protocol_version = PROTOCOL_VERSION;
  InitializeCapabilities capabilities = {};
  ServerInfo server_info;
  std::optional<std::string_view> instructions = std::nullopt;
};

struct ToolCallContent {
  std::string text;
};

struct ToolCallResponse {
  std::string text;
  json structured_content = nullptr;
  bool is_error = false;
};

[[nodiscard]] inline bool IsSupportedProtocolVersion(std::string_view version) {
  for (const auto supported_version : SUPPORTED_PROTOCOL_VERSIONS) {
    if (version == supported_version) {
      return true;
    }
  }

  return false;
}

[[nodiscard]] inline std::string_view NegotiateProtocolVersion(std::string_view requested_version) {
  for (const auto supported_version : SUPPORTED_PROTOCOL_VERSIONS) {
    if (requested_version == supported_version) {
      return supported_version;
    }
  }

  return PROTOCOL_VERSION;
}

[[nodiscard]] inline std::string_view NegotiateProtocolVersionFromInitializeParams(const json& params) {
  if (!params.is_object()) {
    return PROTOCOL_VERSION;
  }
  if (!params.contains("protocolVersion") || !params["protocolVersion"].is_string()) {
    return PROTOCOL_VERSION;
  }

  return NegotiateProtocolVersion(std::string_view(params["protocolVersion"].get_ref<const std::string&>()));
}

[[nodiscard]] inline std::optional<json> ValidateInitializeRequest(const json& id, const json& params) {
  if (!params.is_object()) {
    return renodx::utils::json_rpc::ErrorResponseMessage{
        .id = id,
        .error = renodx::utils::json_rpc::ErrorObject{
            .code = renodx::utils::json_rpc::INVALID_PARAMS,
            .message = "initialize params must be an object",
        },
    };
  }

  if (!params.contains("protocolVersion") || !params["protocolVersion"].is_string()) {
    return renodx::utils::json_rpc::ErrorResponseMessage{
        .id = id,
        .error = renodx::utils::json_rpc::ErrorObject{
            .code = renodx::utils::json_rpc::INVALID_PARAMS,
            .message = "initialize requires a string protocolVersion",
        },
    };
  }

  return std::nullopt;
}

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& value, const InitializeToolsCapabilities& capabilities) {
  value = {
      {"listChanged", capabilities.list_changed},
  };
}

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& value, const InitializeCapabilities& capabilities) {
  value = {
      {"tools", capabilities.tools},
  };
}

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& value, const ServerInfo& server_info) {
  value = {
      {"name", server_info.name},
      {"version", server_info.version},
  };
  if (!server_info.title.empty()) {
    value["title"] = server_info.title;
  }
}

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& value, const InitializeResult& result) {
  value = {
      {"protocolVersion", result.protocol_version},
      {"capabilities", result.capabilities},
      {"serverInfo", result.server_info},
  };
  if (result.instructions.has_value() && !result.instructions.value().empty()) {
    value["instructions"] = result.instructions.value();
  }
}

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& value, const ToolCallContent& content) {
  value = {
      {"type", "text"},
      {"text", content.text},
  };
}

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& value, const ToolCallResponse& response) {
  value = {
      {"content", std::vector<ToolCallContent>{
                      {
                          .text = response.text.empty()
                                      ? (response.is_error ? "Tool call failed." : "Tool call completed.")
                                      : response.text,
                      },
                  }},
      {"isError", response.is_error},
  };
  if (!response.structured_content.is_null()) {
    value["structuredContent"] = response.structured_content;
  }
}

}  // namespace renodx::utils::mcp
