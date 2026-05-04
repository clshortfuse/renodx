/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <cstddef>
#include <cstdint>
#include <exception>
#include <functional>
#include <mutex>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <unordered_map>
#include <utility>
#include <vector>

#include "../ipc/ipc.hpp"
#include "../json_rpc.hpp"
#include "./protocol.hpp"
#include "./types.hpp"

namespace renodx::utils::mcp {

struct ServerConfig {
  std::wstring pipe_name = L"renodx-mcp";
  std::string server_name = "renodx-mcp";
  std::string server_title = "RenoDX MCP";
  std::string server_version = "0.1.0";
  std::string instructions;
  std::uint32_t transport_max_instances = 4u;
  std::optional<std::wstring> transport_security_descriptor_sddl = std::wstring(utils::ipc::DEFAULT_LOCAL_PIPE_RW_SECURITY_DESCRIPTOR_SDDL);
};

class Server {
 public:
  explicit Server(const ServerConfig& server_config = {})
      : config(server_config) {}
  Server(const Server&) = delete;
  Server& operator=(const Server&) = delete;

  bool Start() {
    if (config.pipe_name.empty()) return false;

    Stop();
    {
      std::scoped_lock lock(session_state_mutex);
      session_states.clear();
    }

    return transport_server.Start(utils::ipc::ServerConfig{
                                      .pipe_name = config.pipe_name,
                                      .max_instances = config.transport_max_instances,
                                      .security_descriptor_sddl = config.transport_security_descriptor_sddl,
                                  },
                                  [this](const utils::ipc::Message& message, utils::ipc::Server& transport) {
                                    HandleTransportMessage(message, transport);
                                  },
                                  [this](std::uint64_t connection_id, utils::ipc::Server&) {
                                    ClearSessionState(connection_id);
                                  });
  }

  void Stop() {
    {
      std::scoped_lock lock(session_state_mutex);
      session_states.clear();
    }
    transport_server.Stop();
  }

  [[nodiscard]] bool IsRunning() const {
    return transport_server.IsRunning();
  }

  [[nodiscard]] bool IsConnected() const {
    return transport_server.IsConnected();
  }

  [[nodiscard]] std::wstring GetPipeName() const {
    return transport_server.GetPipeName();
  }

  [[nodiscard]] const ServerConfig& GetConfig() const {
    return config;
  }

  [[nodiscard]] size_t GetToolCount() const {
    std::scoped_lock lock(tools_mutex);
    return tools.size();
  }

  bool RegisterTool(const Tool& tool) {
    if (tool.name.empty() || !tool.handler) return false;

    std::scoped_lock lock(tools_mutex);
    tools[tool.name] = tool;
    return true;
  }

  void ClearTools() {
    std::scoped_lock lock(tools_mutex);
    tools.clear();
  }

 private:
  struct SessionState {
    bool initialized = false;
  };

  struct ToolRecord {
    std::string name;
    std::string title;
    std::string description;
    InputSchema input_schema;
    ToolAnnotations annotations;
    std::function<ToolResult(const json& arguments)> handler;
  };

  static json ParsePayload(std::span<const std::uint8_t> payload) {
    const auto payload_string = utils::ipc::PayloadToString(payload);
    if (payload_string.empty()) return {};
    return json::parse(payload_string, nullptr, false);
  }

  static utils::ipc::Payload EncodePayload(const json& value) {
    return utils::ipc::ToPayload(value.dump());
  }

  [[nodiscard]] std::vector<ToolRecord> CopyTools() const {
    std::vector<ToolRecord> records;
    {
      std::scoped_lock lock(tools_mutex);
      records.reserve(tools.size());
      for (const auto& [name, tool] : tools) {
        records.push_back(ToolRecord{
            .name = name,
            .title = tool.title,
            .description = tool.description,
            .input_schema = tool.input_schema,
            .annotations = tool.annotations,
            .handler = tool.handler,
        });
      }
    }

    std::ranges::sort(records, [](const ToolRecord& lhs, const ToolRecord& rhs) {
      return lhs.name < rhs.name;
    });
    return records;
  }

  [[nodiscard]] std::optional<ToolRecord> FindTool(std::string_view name) const {
    std::scoped_lock lock(tools_mutex);
    if (auto iterator = tools.find(std::string(name)); iterator != tools.end()) {
      return ToolRecord{
          .name = iterator->first,
          .title = iterator->second.title,
          .description = iterator->second.description,
          .input_schema = iterator->second.input_schema,
          .annotations = iterator->second.annotations,
          .handler = iterator->second.handler,
      };
    }
    return std::nullopt;
  }

  void SetSessionInitialized(std::uint64_t connection_id, bool initialized) {
    if (connection_id == 0u) return;

    std::scoped_lock lock(session_state_mutex);
    session_states[connection_id].initialized = initialized;
  }

  void ClearSessionState(std::uint64_t connection_id) {
    if (connection_id == 0u) return;

    std::scoped_lock lock(session_state_mutex);
    session_states.erase(connection_id);
  }

  [[nodiscard]] bool IsSessionInitialized(std::uint64_t connection_id) const {
    if (connection_id == 0u) return false;

    std::scoped_lock lock(session_state_mutex);
    if (auto iterator = session_states.find(connection_id); iterator != session_states.end()) {
      return iterator->second.initialized;
    }
    return false;
  }

  json HandleInitialize(const json& id, const json& params, std::uint64_t connection_id) {
    if (const auto error_response = ValidateInitializeRequest(id, params); error_response.has_value()) {
      return error_response.value();
    }

    SetSessionInitialized(connection_id, true);
    return renodx::utils::json_rpc::SuccessResponseMessage{
        .id = id,
        .result = InitializeResult{
            .server_info = {
                .name = config.server_name,
                .title = config.server_title,
                .version = config.server_version,
            },
            .instructions = config.instructions,
        },
    };
  }

  json HandleToolsList(const json& id) const {
    json tool_list = json::array();
    for (const auto& tool : CopyTools()) {
      tool_list.push_back(ToolDescriptor{
          .name = tool.name,
          .metadata = {
              .title = tool.title,
              .description = tool.description,
              .input_schema = tool.input_schema,
              .annotations = tool.annotations,
          },
      });
    }

    return renodx::utils::json_rpc::SuccessResponseMessage{
        .id = id,
        .result = json{
            {"tools", tool_list},
        },
    };
  }

  json HandleToolsCall(const json& id, const json& params) const {
    if (!params.is_object()) {
      return renodx::utils::json_rpc::ErrorResponseMessage{
          .id = id,
          .error = renodx::utils::json_rpc::ErrorObject{
              .code = renodx::utils::json_rpc::INVALID_PARAMS,
              .message = "tools/call params must be an object",
          },
      };
    }
    if (!params.contains("name") || !params["name"].is_string()) {
      return renodx::utils::json_rpc::ErrorResponseMessage{
          .id = id,
          .error = renodx::utils::json_rpc::ErrorObject{
              .code = renodx::utils::json_rpc::INVALID_PARAMS,
              .message = "tools/call requires a string tool name",
          },
      };
    }

    auto tool_name = params["name"].get<std::string>();
    auto tool = FindTool(tool_name);
    if (!tool.has_value()) {
      return renodx::utils::json_rpc::ErrorResponseMessage{
          .id = id,
          .error = renodx::utils::json_rpc::ErrorObject{
              .code = renodx::utils::json_rpc::INVALID_PARAMS,
              .message = "Unknown tool",
              .data = json{
                  {"tool", tool_name},
              },
          },
      };
    }

    json arguments = json::object();
    if (params.contains("arguments")) {
      arguments = params["arguments"];
      if (!arguments.is_object()) {
        return renodx::utils::json_rpc::ErrorResponseMessage{
            .id = id,
            .error = renodx::utils::json_rpc::ErrorObject{
                .code = renodx::utils::json_rpc::INVALID_PARAMS,
                .message = "tools/call arguments must be an object",
                .data = json{
                    {"tool", tool_name},
                },
            },
        };
      }
    }

    try {
      auto tool_result = tool->handler(arguments);
      return renodx::utils::json_rpc::SuccessResponseMessage{
          .id = id,
          .result = ToolCallResponse{
              .text = tool_result.text,
              .structured_content = tool_result.structured_content,
              .is_error = tool_result.is_error,
          },
      };
    } catch (const std::exception& exception) {
      return renodx::utils::json_rpc::SuccessResponseMessage{
          .id = id,
          .result = ToolCallResponse{
              .text = exception.what(),
              .structured_content = json{
                  {"tool", tool_name},
              },
              .is_error = true,
          },
      };
    } catch (...) {
      return renodx::utils::json_rpc::SuccessResponseMessage{
          .id = id,
          .result = ToolCallResponse{
              .text = "Tool call threw an unknown exception.",
              .structured_content = json{
                  {"tool", tool_name},
              },
              .is_error = true,
          },
      };
    }
  }

  std::optional<json> HandleRequestObject(const json& request, bool expect_response, std::uint64_t connection_id) {
    const auto parsed_request = renodx::utils::json_rpc::ParseRequestObject(
        request,
        "MCP messages must be JSON objects",
        "MCP requests must include a string method");
    if (!parsed_request.request.has_value()) {
      return expect_response && parsed_request.error_response.has_value()
                 ? std::optional(parsed_request.error_response.value())
                 : std::nullopt;
    }

    const auto& parsed = parsed_request.request.value();
    const auto& method = parsed.method;
    const auto& params = parsed.params;

    if (method == NOTIFICATION_INITIALIZED) {
      return std::nullopt;
    }

    const bool should_respond = expect_response && parsed.ExpectsResponse();
    if (!should_respond) {
      return std::nullopt;
    }

    const auto& id = parsed.id.value();

    if (method == METHOD_INITIALIZE) {
      return HandleInitialize(id, params, connection_id);
    }

    if (method == METHOD_PING) {
      return renodx::utils::json_rpc::SuccessResponseMessage{
          .id = id,
          .result = json::object(),
      };
    }

    if (!IsSessionInitialized(connection_id)) {
      return renodx::utils::json_rpc::ErrorResponseMessage{
          .id = id,
          .error = renodx::utils::json_rpc::ErrorObject{
              .code = SESSION_NOT_INITIALIZED,
              .message = "MCP session is not initialized",
          },
      };
    }

    if (method == METHOD_TOOLS_LIST) {
      return HandleToolsList(id);
    }

    if (method == METHOD_TOOLS_CALL) {
      return HandleToolsCall(id, params);
    }

    return renodx::utils::json_rpc::ErrorResponseMessage{
        .id = id,
        .error = renodx::utils::json_rpc::ErrorObject{
            .code = renodx::utils::json_rpc::METHOD_NOT_FOUND,
            .message = "Method not found",
            .data = json{
                {"method", method},
            },
        },
    };
  }

  void HandleTransportMessage(const utils::ipc::Message& message, utils::ipc::Server& transport) {
    if (message.kind == utils::ipc::MessageKind::RESPONSE) return;

    const bool expect_response = message.kind == utils::ipc::MessageKind::REQUEST;
    if (message.name != TRANSPORT_MESSAGE_NAME) {
      if (expect_response) {
        const auto error = renodx::utils::json_rpc::ErrorResponseMessage{
            .id = nullptr,
            .error = renodx::utils::json_rpc::ErrorObject{
                .code = renodx::utils::json_rpc::INVALID_REQUEST,
                .message = "Unsupported transport message",
                .data = json{
                    {"name", message.name},
                },
            },
        };
        transport.SendResponse(message, EncodePayload(error), message.name);
      }
      return;
    }

    auto request = ParsePayload(message.payload);
    if (request.is_discarded()) {
      if (expect_response) {
        transport.SendResponse(
            message,
            EncodePayload(renodx::utils::json_rpc::ErrorResponseMessage{
                .id = nullptr,
                .error = renodx::utils::json_rpc::ErrorObject{
                    .code = renodx::utils::json_rpc::PARSE_ERROR,
                    .message = "Failed to parse MCP JSON payload",
                },
            }),
            message.name);
      }
      return;
    }

    auto response = HandleRequestObject(request, expect_response, message.connection_id);
    if (expect_response && response.has_value()) {
      transport.SendResponse(message, EncodePayload(response.value()), message.name);
    }
  }

  ServerConfig config;
  utils::ipc::Server transport_server;
  mutable std::mutex tools_mutex;
  mutable std::mutex session_state_mutex;
  std::unordered_map<std::string, Tool> tools;
  std::unordered_map<std::uint64_t, SessionState> session_states;
};

}  // namespace renodx::utils::mcp
