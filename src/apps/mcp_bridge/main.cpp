/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <Windows.h>

#include <algorithm>
#include <charconv>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <exception>
#include <format>
#include <iostream>
#include <limits>
#include <optional>
#include <array>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

#include "../../addons/devkit/mcp/tool_catalog.hpp"
#include "../../utils/ipc/ipc.hpp"
#include "../../utils/mcp/protocol.hpp"
#include "../../utils/mcp/types.hpp"

namespace {

namespace ipc = renodx::utils::ipc;
namespace mcp = renodx::utils::mcp;
namespace devkit_tool_catalog = renodx::addons::devkit::mcp::tool_catalog;
namespace json_rpc = renodx::utils::json_rpc;
using json = mcp::json;
using ToolDescriptor = mcp::ToolDescriptor;

constexpr std::string_view DEFAULT_PIPE_PREFIX = "renodx-devkit-mcp";
constexpr std::uint32_t DEFAULT_PIPE_WAIT_MS = 1000u;
constexpr std::string_view BRIDGE_SERVER_NAME = "renodx-mcp-bridge";
constexpr std::string_view BRIDGE_SERVER_TITLE = "RenoDX MCP Bridge";
constexpr std::string_view BRIDGE_SERVER_VERSION = "0.1.0";
constexpr std::string_view BRIDGE_TOOL_LIST_CONNECTIONS = "renodx_list_connections";
constexpr std::string_view BRIDGE_TOOL_CONNECT = "renodx_connect";
constexpr std::string_view BRIDGE_INSTRUCTIONS =
    "Use renodx_list_connections to discover RenoDX DevKit instances. Devkit proxy tools are advertised up front and auto-connect to a single available backend when invoked.";

struct Options {
  std::optional<std::string> pipe_name = std::nullopt;
  std::uint32_t wait_ms = DEFAULT_PIPE_WAIT_MS;
};

struct ParseResult {
  std::optional<Options> options;
  int exit_code = 0;
};

struct BackendDiagnostic {
  std::string stage;
  std::optional<std::string> pipe_name = std::nullopt;
  std::optional<std::uint32_t> win32_error = std::nullopt;
  std::string message;
  std::optional<std::string> hint = std::nullopt;
};

struct PipeConnection {
  size_t index = 0u;
  std::string pipe_name;
  bool is_selected = false;
  bool is_connected = false;
};

struct ConnectionsStructuredContent {
  size_t available_count = 0u;
  std::vector<PipeConnection> connections;
  std::optional<std::string> selected_pipe = std::nullopt;
  std::optional<std::string> connected_pipe = std::nullopt;
  bool manual_selection = false;
  std::optional<std::string> auto_connect_pipe = std::nullopt;
  std::optional<BackendDiagnostic> connection_error = std::nullopt;
};

struct ToolResultPayload {
  std::string text;
  std::optional<ConnectionsStructuredContent> structured_content = std::nullopt;
  bool is_error = false;
  bool tools_list_changed = false;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const PipeConnection& connection) {
  j = {
      {"index", connection.index},
      {"pipe", connection.pipe_name},
      {"selected", connection.is_selected},
      {"connected", connection.is_connected},
  };
}

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const BackendDiagnostic& diagnostic) {
  j = {
      {"stage", diagnostic.stage},
      {"message", diagnostic.message},
  };
  if (diagnostic.pipe_name.has_value()) {
    j["pipe"] = diagnostic.pipe_name.value();
  }
  if (diagnostic.win32_error.has_value()) {
    j["win32Error"] = diagnostic.win32_error.value();
  }
  if (diagnostic.hint.has_value()) {
    j["hint"] = diagnostic.hint.value();
  }
}

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& j, const ConnectionsStructuredContent& content) {
  j = {
      {"availableCount", content.available_count},
      {"connections", content.connections},
      {"selectedPipe", content.selected_pipe.has_value() ? json(content.selected_pipe.value()) : json(nullptr)},
      {"connectedPipe", content.connected_pipe.has_value() ? json(content.connected_pipe.value()) : json(nullptr)},
      {"manualSelection", content.manual_selection},
  };
  if (content.auto_connect_pipe.has_value()) {
    j["autoConnectPipe"] = content.auto_connect_pipe.value();
  }
  if (content.connection_error.has_value()) {
    j["connectionError"] = content.connection_error.value();
  }
}

struct HandleFrameResult {
  std::optional<std::string> response;
  std::vector<std::string> notifications;
};

[[nodiscard]] bool ParseUnsigned(std::string_view value, std::uint32_t& result) {
  std::uint64_t parsed = 0u;
  const auto [parsed_end, parsed_error] = std::from_chars(value.data(), value.data() + value.size(), parsed);
  if (parsed_error != std::errc{} || parsed_end != value.data() + value.size()) {
    return false;
  }
  if (parsed > (std::numeric_limits<std::uint32_t>::max)()) return false;
  result = static_cast<std::uint32_t>(parsed);
  return true;
}

[[nodiscard]] std::optional<std::string> GetEnvironmentString(const char* name) {
  char* value = nullptr;
  size_t length = 0u;
  const auto error = _dupenv_s(&value, &length, name);
  if (error != 0 || value == nullptr || length == 0u) {
    if (value != nullptr) {
      free(value);
    }
    return std::nullopt;
  }

  std::string result(value);
  free(value);
  if (result.empty()) return std::nullopt;
  return result;
}

[[nodiscard]] ParseResult ParseOptions(int argc, char** argv) {
  Options options = {};

  if (auto env_pipe_name = GetEnvironmentString("RENODX_MCP_PIPE"); env_pipe_name.has_value()) {
    options.pipe_name = env_pipe_name.value();
  }

  for (int i = 1; i < argc; ++i) {
    const std::string_view argument(argv[i]);
    if (argument == "--help" || argument == "-h") {
      std::cout
          << "Usage: mcp_bridge [--pipe <name>] [--wait-ms <milliseconds>]\n"
          << "Defaults:\n"
          << "  --pipe <auto-discover matching RenoDX pipes>\n"
          << "  --wait-ms " << DEFAULT_PIPE_WAIT_MS << "\n";
      return ParseResult{
          .options = std::nullopt,
          .exit_code = 0,
      };
    }
    if (argument == "--pipe") {
      if (++i >= argc) {
        std::cerr << "--pipe requires a value\n";
        return ParseResult{
            .options = std::nullopt,
            .exit_code = 1,
        };
      }
      options.pipe_name = argv[i];
      continue;
    }
    if (argument == "--wait-ms") {
      if (++i >= argc) {
        std::cerr << "--wait-ms requires a value\n";
        return ParseResult{
            .options = std::nullopt,
            .exit_code = 1,
        };
      }
      if (!ParseUnsigned(argv[i], options.wait_ms)) {
        std::cerr << "--wait-ms must be an unsigned integer\n";
        return ParseResult{
            .options = std::nullopt,
            .exit_code = 1,
        };
      }
      continue;
    }

    std::cerr << "Unknown argument: " << argument << "\n";
    return ParseResult{
        .options = std::nullopt,
        .exit_code = 1,
    };
  }

  return ParseResult{
      .options = options,
      .exit_code = 0,
  };
}

[[nodiscard]] std::string WideToUtf8(std::wstring_view value) {
  if (value.empty()) return {};

  auto required = WideCharToMultiByte(CP_UTF8, 0, value.data(), static_cast<int>(value.size()), nullptr, 0, nullptr, nullptr);
  if (required <= 0) return {};

  std::string result(required, '\0');
  required = WideCharToMultiByte(
      CP_UTF8,
      0,
      value.data(),
      static_cast<int>(value.size()),
      result.data(),
      static_cast<int>(result.size()),
      nullptr,
      nullptr);
  if (required <= 0) return {};
  return result;
}

[[nodiscard]] bool MatchesDevkitPipePrefix(std::string_view pipe_name) {
  return pipe_name.starts_with(DEFAULT_PIPE_PREFIX);
}

[[nodiscard]] std::vector<std::string> EnumerateDevkitPipes() {
  std::vector<std::string> pipes;

  WIN32_FIND_DATAW find_data = {};
  auto* find_handle = FindFirstFileW(LR"(\\.\pipe\*)", &find_data);
  if (find_handle == INVALID_HANDLE_VALUE) {
    return pipes;
  }

  do {
    auto pipe_name = WideToUtf8(find_data.cFileName);
    if (MatchesDevkitPipePrefix(pipe_name)) {
      pipes.push_back(pipe_name);
    }
  } while (FindNextFileW(find_handle, &find_data) != FALSE);

  FindClose(find_handle);

  std::ranges::sort(pipes);
  const auto duplicates = std::ranges::unique(pipes);
  pipes.erase(duplicates.begin(), duplicates.end());
  return pipes;
}

const std::vector<ToolDescriptor> FALLBACK_DEVKIT_TOOLS = [] {
  std::vector<ToolDescriptor> tools = {};
  tools.reserve(devkit_tool_catalog::METADATA.size());
  for (const auto& [tool_name, metadata] : devkit_tool_catalog::METADATA) {
    tools.push_back(ToolDescriptor{
        .name = tool_name,
        .metadata = metadata,
    });
  }
  return tools;
}();

const std::array<ToolDescriptor, 2> LOCAL_TOOLS = {
    ToolDescriptor{
        .name = BRIDGE_TOOL_LIST_CONNECTIONS,
        .metadata = {
            .title = "List Connections",
            .description = "List available RenoDX DevKit MCP pipe endpoints and current bridge selection state.",
            .annotations = {
                .read_only_hint = true,
            },
        },
    },
    ToolDescriptor{
        .name = BRIDGE_TOOL_CONNECT,
        .metadata = {
            .title = "Connect",
            .description = "Select a RenoDX DevKit pipe by name or index and connect the bridge to it.",
            .input_schema = {
                .properties = {
                    {"pipe", {.types = {"string"}}},
                    {"index", {.types = {"integer"}, .minimum = 0}},
                },
            },
        },
    },
};

struct BridgeToolDescriptor {
  std::string name;
  json payload;
};

// NOLINTNEXTLINE(readability-identifier-naming)
inline void to_json(json& value, const BridgeToolDescriptor& descriptor) {
  value = descriptor.payload;
}

[[nodiscard]] BridgeToolDescriptor MakeBridgeToolDescriptor(const ToolDescriptor& descriptor) {
  return BridgeToolDescriptor{
      .name = std::string(descriptor.name),
      .payload = json(descriptor),
  };
}

[[nodiscard]] BridgeToolDescriptor ParseBridgeToolDescriptor(const json& tool) {
  if (!tool.is_object()) {
    throw std::runtime_error("tools/list entries must be objects.");
  }
  if (!tool.contains("name") || !tool["name"].is_string()) {
    throw std::runtime_error("tools/list entries require a string name.");
  }

  return BridgeToolDescriptor{
      .name = tool["name"].get<std::string>(),
      .payload = tool,
  };
}

void UpsertTool(std::vector<BridgeToolDescriptor>& tools, const BridgeToolDescriptor& tool) {
  auto existing = std::ranges::find_if(tools, [&tool](const BridgeToolDescriptor& candidate) {
    return candidate.name == tool.name;
  });
  if (existing != tools.end()) {
    *existing = tool;
    return;
  }

  tools.push_back(tool);
}

[[nodiscard]] std::optional<std::string> GetWin32Hint(std::uint32_t error) {
  if (error == ERROR_PIPE_BUSY) {
    return "All available RenoDX MCP pipe instances are busy. Another client may still be connected, or the server may have reached its connection limit.";
  }
  if (error == ERROR_SEM_TIMEOUT) {
    return "Timed out waiting for an available RenoDX MCP pipe instance. Another client may still be connected, or the server may have reached its connection limit.";
  }
  return std::nullopt;
}

class StdioTransport {
 public:
  [[nodiscard]] static bool ReadFrame(std::string& payload) {
    std::string line;
    while (std::getline(std::cin, line)) {
      if (!line.empty() && line.back() == '\r') {
        line.pop_back();
      }
      if (line.empty()) continue;
      payload = line;
      return true;
    }

    payload.clear();
    return false;
  }

  static bool WriteFrame(std::string_view payload) {
    std::cout << payload << '\n'
              << std::flush;
    return !std::cout.fail();
  }
};

class Bridge {
 public:
  explicit Bridge(const Options& bridge_options)
      : options(bridge_options),
        selected_pipe(options.pipe_name),
        manual_pipe_selection(options.pipe_name.has_value()) {}

  [[nodiscard]] HandleFrameResult HandleFrame(std::string_view frame) {
    auto request = json::parse(frame, nullptr, false);
    if (request.is_discarded()) {
      return HandleFrameResult{
          .response = json(json_rpc::ErrorResponseMessage{
                               .id = nullptr,
                               .error = json_rpc::ErrorObject{
                                   .code = json_rpc::PARSE_ERROR,
                                   .message = "Failed to parse JSON-RPC payload",
                               },
                           })
                          .dump(),
      };
    }
    return HandleRequestObject(request);
  }

 private:
  [[nodiscard]] static std::optional<std::string> ValidateBackendInitializeResult(const json& result) {
    if (!result.is_object()) {
      return "The backend did not return a valid initialize result.";
    }
    if (!result.contains("protocolVersion") || !result["protocolVersion"].is_string()) {
      return "The backend did not return a valid initialize result protocolVersion.";
    }
    if (result["protocolVersion"].get_ref<const std::string&>() != mcp::PROTOCOL_VERSION) {
      return std::format(
          "The backend requested unsupported MCP protocol version '{}'.",
          result["protocolVersion"].get_ref<const std::string&>());
    }
    if (!result.contains("capabilities") || !result["capabilities"].is_object()) {
      return "The backend did not return valid initialize capabilities.";
    }
    if (!result.contains("serverInfo") || !result["serverInfo"].is_object()) {
      return "The backend did not return valid initialize serverInfo.";
    }

    const auto& server_info = result["serverInfo"];
    if (!server_info.contains("name")
        || !server_info["name"].is_string()
        || !server_info.contains("version")
        || !server_info["version"].is_string()) {
      return "The backend did not return valid initialize serverInfo.";
    }

    return std::nullopt;
  }

  [[nodiscard]] ConnectionsStructuredContent BuildConnectionsStructuredContent(const std::vector<std::string>& available_pipes) const {
    ConnectionsStructuredContent content = {
        .available_count = available_pipes.size(),
        .selected_pipe = selected_pipe,
        .connected_pipe = connected_pipe,
        .manual_selection = manual_pipe_selection,
    };
    content.connections.reserve(available_pipes.size());

    for (size_t index = 0; index < available_pipes.size(); ++index) {
      const auto& pipe_name = available_pipes[index];
      content.connections.push_back({
          .index = index,
          .pipe_name = pipe_name,
          .is_selected = selected_pipe.has_value() && selected_pipe.value() == pipe_name,
          .is_connected = connected_pipe.has_value() && connected_pipe.value() == pipe_name,
      });
    }

    if (!selected_pipe.has_value() && available_pipes.size() == 1u) {
      content.auto_connect_pipe = available_pipes.front();
    }

    if (last_backend_error.has_value()) {
      content.connection_error = last_backend_error.value();
    }

    return content;
  }

  void ClearBackendDiagnostic() {
    last_backend_error.reset();
  }

  void SetBackendDiagnostic(BackendDiagnostic diagnostic) {
    if (diagnostic.message.empty()) {
      diagnostic.message = "The backend operation failed without a reported system error.";
    }
    if (!diagnostic.hint.has_value() && diagnostic.win32_error.has_value()) {
      diagnostic.hint = GetWin32Hint(diagnostic.win32_error.value());
    }
    last_backend_error = diagnostic;
  }

  [[nodiscard]] BackendDiagnostic BuildClientDiagnostic(
      std::string_view stage,
      const std::optional<std::string>& pipe_name) const {
    BackendDiagnostic diagnostic = {
        .stage = std::string(stage),
        .pipe_name = pipe_name,
    };

    diagnostic.win32_error = client.GetLastErrorCode();
    diagnostic.message = client.GetLastErrorMessage();
    if (diagnostic.win32_error.has_value() && diagnostic.message.empty()) {
      diagnostic.message = std::format("Win32 error {}.", diagnostic.win32_error.value());
    }
    if (diagnostic.win32_error.has_value()) {
      diagnostic.hint = GetWin32Hint(diagnostic.win32_error.value());
    }
    if (diagnostic.message.empty()) {
      diagnostic.message = "The backend operation failed without a reported system error.";
    }

    return diagnostic;
  }

  [[nodiscard]] std::string BuildBackendUnavailableText() const {
    if (!last_backend_error.has_value()) {
      return "No RenoDX DevKit backend is currently connected. Use renodx_list_connections or renodx_connect first.";
    }

    std::string text = "Failed to connect to the RenoDX DevKit backend";
    if (last_backend_error->pipe_name.has_value()) {
      text += std::format(" '{}'", last_backend_error->pipe_name.value());
    }
    text += std::format(" during {}.", last_backend_error->stage);
    if (last_backend_error->win32_error.has_value()) {
      text += std::format(
          " Win32 {}: {}",
          last_backend_error->win32_error.value(),
          last_backend_error->message);
    } else if (!last_backend_error->message.empty()) {
      text += std::format(" {}", last_backend_error->message);
    }
    if (last_backend_error->hint.has_value()) {
      text += std::format(" {}", last_backend_error->hint.value());
    }
    return text;
  }

  [[nodiscard]] ToolResultPayload BuildBackendUnavailableToolResult() const {
    return ToolResultPayload{
        .text = BuildBackendUnavailableText(),
        .structured_content = BuildConnectionsStructuredContent(EnumerateDevkitPipes()),
        .is_error = true,
    };
  }

  [[nodiscard]] static bool IsLocalTool(std::string_view tool_name) {
    return tool_name == BRIDGE_TOOL_LIST_CONNECTIONS || tool_name == BRIDGE_TOOL_CONNECT;
  }

  void DisconnectBackend() {
    client.Disconnect();
    connected_pipe.reset();
    backend_initialized = false;
  }

  [[nodiscard]] bool SendBackendNotification(const json& request, std::string_view stage) {
    if (!client.IsConnected()) return false;

    const auto payload = ipc::ToPayload(request.dump());
    if (client.Send(ipc::MakeEvent(mcp::TRANSPORT_MESSAGE_NAME, payload))) {
      return true;
    }

    SetBackendDiagnostic(BuildClientDiagnostic(stage, connected_pipe));
    DisconnectBackend();
    return false;
  }

  [[nodiscard]] std::optional<json_rpc::Response> SendBackendRequest(const json& request, std::string_view stage) {
    if (!client.IsConnected()) return std::nullopt;

    ipc::Message response = {};
    const auto payload = ipc::ToPayload(request.dump());
    if (!client.Request(
            ipc::MakeRequest(next_transport_id++, mcp::TRANSPORT_MESSAGE_NAME, payload),
            response)) {
      SetBackendDiagnostic(BuildClientDiagnostic(stage, connected_pipe));
      DisconnectBackend();
      return std::nullopt;
    }

    auto parsed = json::parse(ipc::PayloadToString(response.payload), nullptr, false);
    if (parsed.is_discarded()) {
      SetBackendDiagnostic(BackendDiagnostic{
          .stage = std::string(stage),
          .pipe_name = connected_pipe,
          .message = "The backend returned malformed JSON.",
      });
      DisconnectBackend();
      return std::nullopt;
    }

    auto parsed_response = json_rpc::ParseResponseObject(
        parsed,
        "The backend returned a JSON-RPC response that is not an object.",
        "The backend returned an invalid JSON-RPC response.");
    if (!parsed_response.response.has_value()) {
      SetBackendDiagnostic(BackendDiagnostic{
          .stage = std::string(stage),
          .pipe_name = connected_pipe,
          .message = parsed_response.error_message.value_or("The backend returned an invalid JSON-RPC response."),
      });
      DisconnectBackend();
      return std::nullopt;
    }

    if (parsed_response.response->id != request["id"]) {
      SetBackendDiagnostic(BackendDiagnostic{
          .stage = std::string(stage),
          .pipe_name = connected_pipe,
          .message = "The backend returned a response with a mismatched id.",
      });
      DisconnectBackend();
      return std::nullopt;
    }

    return parsed_response.response;
  }

  [[nodiscard]] bool InitializeBackendSession() {
    if (!client.IsConnected()) return false;
    if (backend_initialized) return true;

    auto response = SendBackendRequest(
        json(json_rpc::RequestMessage{
            .id = next_backend_jsonrpc_id++,
            .method = "initialize",
            .params = json{
                {"protocolVersion", std::string(mcp::PROTOCOL_VERSION)},
                {"capabilities", {
                                     {"tools", json::object()},
                                 }},
                {"clientInfo", {
                                   {"name", BRIDGE_SERVER_NAME},
                                   {"version", BRIDGE_SERVER_VERSION},
                               }},
            },
        }),
        "initialize");
    if (!response.has_value() || !response.value().result.has_value()) {
      if (!last_backend_error.has_value()) {
        SetBackendDiagnostic(BackendDiagnostic{
            .stage = "initialize",
            .pipe_name = connected_pipe,
            .message = "The backend did not return a valid initialize result.",
        });
      }
      DisconnectBackend();
      return false;
    }

    if (const auto validation_error = ValidateBackendInitializeResult(response.value().result.value());
        validation_error.has_value()) {
      if (!last_backend_error.has_value()) {
        SetBackendDiagnostic(BackendDiagnostic{
            .stage = "initialize",
            .pipe_name = connected_pipe,
            .message = validation_error.value(),
        });
      }
      DisconnectBackend();
      return false;
    }

    if (!SendBackendNotification(
            json(json_rpc::NotificationMessage{
                .method = "notifications/initialized",
            }),
            "notifications/initialized")) {
      DisconnectBackend();
      return false;
    }

    ClearBackendDiagnostic();
    backend_initialized = true;
    return true;
  }

  [[nodiscard]] bool ConnectToPipe(std::string_view pipe_name) {
    if (connected_pipe.has_value()
        && connected_pipe.value() == pipe_name
        && client.IsConnected()
        && backend_initialized) {
      return true;
    }

    if (connected_pipe.has_value()
        && connected_pipe.value() == pipe_name
        && client.IsConnected()) {
      return InitializeBackendSession();
    }

    DisconnectBackend();
    if (!client.Connect(pipe_name, options.wait_ms)) {
      SetBackendDiagnostic(BuildClientDiagnostic("connect", std::string(pipe_name)));
      return false;
    }

    connected_pipe = std::string(pipe_name);
    if (!InitializeBackendSession()) {
      DisconnectBackend();
      return false;
    }

    return true;
  }

  [[nodiscard]] bool EnsureBackendReady() {
    if (client.IsConnected() && backend_initialized) return true;

    if (selected_pipe.has_value()) {
      if (ConnectToPipe(selected_pipe.value())) {
        return true;
      }
      if (manual_pipe_selection) {
        return false;
      }
    }

    auto available_pipes = EnumerateDevkitPipes();
    if (available_pipes.size() != 1u) {
      return false;
    }

    selected_pipe = available_pipes.front();
    manual_pipe_selection = false;
    return ConnectToPipe(selected_pipe.value());
  }

  [[nodiscard]] std::vector<BridgeToolDescriptor> GetBackendTools() {
    if (!EnsureBackendReady()) {
      return {};
    }

    auto response = SendBackendRequest(
        json(json_rpc::RequestMessage{
            .id = next_backend_jsonrpc_id++,
            .method = "tools/list",
        }),
        "tools/list");
    if (!response.has_value()
        || !response->result.has_value()
        || !response->result->is_object()
        || !response->result->contains("tools")
        || !response->result.value()["tools"].is_array()) {
      if (!last_backend_error.has_value()) {
        SetBackendDiagnostic(BackendDiagnostic{
            .stage = "tools/list",
            .pipe_name = connected_pipe,
            .message = "The backend did not return a valid tools/list result.",
        });
      }
      return {};
    }

    std::vector<BridgeToolDescriptor> tools = {};
    tools.reserve(response->result.value()["tools"].size());
    try {
      for (const auto& tool : response->result.value()["tools"]) {
        tools.push_back(ParseBridgeToolDescriptor(tool));
      }
    } catch (const std::exception& exception) {
      if (!last_backend_error.has_value()) {
        SetBackendDiagnostic(BackendDiagnostic{
            .stage = "tools/list",
            .pipe_name = connected_pipe,
            .message = exception.what(),
        });
      }
      return {};
    }
    return tools;
  }

  [[nodiscard]] ToolResultPayload HandleListConnectionsTool() {
    auto available_pipes = EnumerateDevkitPipes();
    if (!connected_pipe.has_value() && !manual_pipe_selection && available_pipes.size() == 1u) {
      [[maybe_unused]] const bool backend_ready = EnsureBackendReady();
      available_pipes = EnumerateDevkitPipes();
    }

    std::string text;
    if (available_pipes.empty()) {
      text = "No available RenoDX DevKit connections.";
    } else if (connected_pipe.has_value()) {
      text = std::format(
          "Connected to {}. {} RenoDX DevKit connection(s) available.",
          connected_pipe.value(),
          available_pipes.size());
    } else {
      text = std::format(
          "Found {} RenoDX DevKit connection(s).",
          available_pipes.size());
    }

    return ToolResultPayload{
        .text = text,
        .structured_content = BuildConnectionsStructuredContent(available_pipes),
    };
  }

  [[nodiscard]] ToolResultPayload HandleConnectTool(const json& arguments) {
    if (!arguments.is_object()) {
      return ToolResultPayload{
          .text = "renodx_connect arguments must be an object.",
          .is_error = true,
      };
    }

    const bool has_pipe = arguments.contains("pipe");
    const bool has_index = arguments.contains("index");
    if (has_pipe && has_index) {
      return ToolResultPayload{
          .text = "Provide either 'pipe' or 'index', not both.",
          .is_error = true,
      };
    }

    const auto available_pipes = EnumerateDevkitPipes();
    std::optional<std::string> target_pipe = std::nullopt;

    if (has_pipe) {
      if (!arguments["pipe"].is_string()) {
        return ToolResultPayload{
            .text = "renodx_connect 'pipe' must be a string.",
            .is_error = true,
        };
      }
      target_pipe = arguments["pipe"].get<std::string>();
    } else if (has_index) {
      if (!arguments["index"].is_number_integer()) {
        return ToolResultPayload{
            .text = "renodx_connect 'index' must be an integer.",
            .is_error = true,
        };
      }

      const auto index = arguments["index"].get<std::int64_t>();
      if (index < 0 || static_cast<size_t>(index) >= available_pipes.size()) {
        return ToolResultPayload{
            .text = "renodx_connect index is out of range for the currently discovered pipes.",
            .structured_content = BuildConnectionsStructuredContent(available_pipes),
            .is_error = true,
        };
      }
      target_pipe = available_pipes[static_cast<size_t>(index)];
    } else if (selected_pipe.has_value()) {
      target_pipe = selected_pipe;
    } else if (available_pipes.size() == 1u) {
      target_pipe = available_pipes.front();
    } else if (available_pipes.empty()) {
      return ToolResultPayload{
          .text = "No available RenoDX DevKit connections.",
          .structured_content = BuildConnectionsStructuredContent(available_pipes),
          .is_error = true,
      };
    } else {
      return ToolResultPayload{
          .text = "Multiple RenoDX DevKit connections are available. Use 'index' or 'pipe' to choose one.",
          .structured_content = BuildConnectionsStructuredContent(available_pipes),
          .is_error = true,
      };
    }

    selected_pipe = target_pipe;
    manual_pipe_selection = true;

    const bool list_changed = !connected_pipe.has_value()
                              || connected_pipe.value() != target_pipe.value()
                              || !backend_initialized;
    if (!ConnectToPipe(target_pipe.value())) {
      const auto refreshed_pipes = EnumerateDevkitPipes();
      return ToolResultPayload{
          .text = BuildBackendUnavailableText(),
          .structured_content = BuildConnectionsStructuredContent(refreshed_pipes),
          .is_error = true,
      };
    }

    const auto refreshed_pipes = EnumerateDevkitPipes();
    return ToolResultPayload{
        .text = std::format("Connected to RenoDX DevKit pipe '{}'.", target_pipe.value()),
        .structured_content = BuildConnectionsStructuredContent(refreshed_pipes),
        .tools_list_changed = list_changed,
    };
  }

  [[nodiscard]] ToolResultPayload HandleLocalToolCall(std::string_view tool_name, const json& arguments) {
    if (tool_name == BRIDGE_TOOL_LIST_CONNECTIONS) {
      return HandleListConnectionsTool();
    }
    if (tool_name == BRIDGE_TOOL_CONNECT) {
      return HandleConnectTool(arguments);
    }

    return ToolResultPayload{
        .text = "Unknown bridge tool.",
        .is_error = true,
    };
  }

  [[nodiscard]] HandleFrameResult HandleRequestObject(const json& request) {
    HandleFrameResult result = {};
    const auto parsed_request = json_rpc::ParseRequestObject(
        request,
        "JSON-RPC payload must be an object",
        "Expected a JSON-RPC request object");
    if (!parsed_request.request.has_value()) {
      if (parsed_request.error_response.has_value()) {
        result.response = parsed_request.error_response->dump();
      }
      return result;
    }

    const auto& parsed = parsed_request.request.value();
    const bool expect_response = parsed.ExpectsResponse();
    const auto& method = parsed.method;
    const auto& params = parsed.params;

    if (method == mcp::NOTIFICATION_INITIALIZED) return result;

    if (!expect_response) {
      return result;
    }

    const auto& id = parsed.id.value();

    if (method == mcp::METHOD_INITIALIZE) {
      if (const auto error_response = mcp::ValidateInitializeRequest(id, params); error_response.has_value()) {
        result.response = error_response->dump();
        return result;
      }

      initialized = true;
      result.response = json(json_rpc::SuccessResponseMessage{
                                 .id = id,
                                 .result = mcp::InitializeResult{
                                     .capabilities = {
                                         .tools = {
                                             .list_changed = true,
                                         },
                                     },
                                     .server_info = {
                                         .name = BRIDGE_SERVER_NAME,
                                         .title = BRIDGE_SERVER_TITLE,
                                         .version = BRIDGE_SERVER_VERSION,
                                     },
                                     .instructions = BRIDGE_INSTRUCTIONS,
                                 },
                             })
                            .dump();
      return result;
    }

    if (method == mcp::METHOD_PING) {
      result.response = json(json_rpc::SuccessResponseMessage{
                                 .id = id,
                                 .result = json::object(),
                             })
                            .dump();
      return result;
    }

    if (!initialized) {
      result.response = json(json_rpc::ErrorResponseMessage{
                                 .id = id,
                                 .error = json_rpc::ErrorObject{
                                     .code = mcp::SESSION_NOT_INITIALIZED,
                                     .message = "MCP session is not initialized",
                                 },
                             })
                            .dump();
      return result;
    }

    if (method == mcp::METHOD_TOOLS_LIST) {
      std::vector<BridgeToolDescriptor> tools = {};
      tools.reserve(LOCAL_TOOLS.size() + FALLBACK_DEVKIT_TOOLS.size());
      for (const auto& tool : LOCAL_TOOLS) {
        UpsertTool(tools, MakeBridgeToolDescriptor(tool));
      }
      for (const auto& tool : FALLBACK_DEVKIT_TOOLS) {
        UpsertTool(tools, MakeBridgeToolDescriptor(tool));
      }
      for (const auto& tool : GetBackendTools()) {
        if (IsLocalTool(tool.name)) {
          continue;
        }
        UpsertTool(tools, tool);
      }

      result.response = json(json_rpc::SuccessResponseMessage{
                                 .id = id,
                                 .result = json{
                                     {"tools", tools},
                                 },
                             })
                            .dump();
      return result;
    }

    if (method == mcp::METHOD_TOOLS_CALL) {
      if (!params.is_object()) {
        result.response = json(json_rpc::ErrorResponseMessage{
                                   .id = id,
                                   .error = json_rpc::ErrorObject{
                                       .code = json_rpc::INVALID_PARAMS,
                                       .message = "tools/call params must be an object",
                                   },
                               })
                              .dump();
        return result;
      }
      if (!params.contains("name") || !params["name"].is_string()) {
        result.response = json(json_rpc::ErrorResponseMessage{
                                   .id = id,
                                   .error = json_rpc::ErrorObject{
                                       .code = json_rpc::INVALID_PARAMS,
                                       .message = "tools/call requires a string tool name",
                                   },
                               })
                              .dump();
        return result;
      }

      json arguments = json::object();
      if (params.contains("arguments")) {
        arguments = params["arguments"];
        if (!arguments.is_object()) {
          result.response = json(json_rpc::ErrorResponseMessage{
                                     .id = id,
                                     .error = json_rpc::ErrorObject{
                                         .code = json_rpc::INVALID_PARAMS,
                                         .message = "tools/call arguments must be an object",
                                     },
                                 })
                                .dump();
          return result;
        }
      }

      const auto tool_name = params["name"].get<std::string>();
      if (IsLocalTool(tool_name)) {
        auto tool_result = HandleLocalToolCall(tool_name, arguments);
        result.response = json(json_rpc::SuccessResponseMessage{
                                   .id = id,
                                   .result = mcp::ToolCallResponse{
                                       .text = tool_result.text,
                                       .structured_content = tool_result.structured_content.has_value()
                                                                 ? json(tool_result.structured_content.value())
                                                                 : json(nullptr),
                                       .is_error = tool_result.is_error,
                                   },
                               })
                              .dump();
        if (tool_result.tools_list_changed) {
          result.notifications.push_back(json(json_rpc::NotificationMessage{
                                                  .method = "notifications/tools/list_changed",
                                              })
                                             .dump());
        }
        return result;
      }

      if (!EnsureBackendReady()) {
        auto tool_result = BuildBackendUnavailableToolResult();
        result.response = json(json_rpc::SuccessResponseMessage{
                                   .id = id,
                                   .result = mcp::ToolCallResponse{
                                       .text = tool_result.text,
                                       .structured_content = tool_result.structured_content.has_value()
                                                                 ? json(tool_result.structured_content.value())
                                                                 : json(nullptr),
                                       .is_error = tool_result.is_error,
                                   },
                               })
                              .dump();
        return result;
      }

      auto backend_response = SendBackendRequest(
          json(json_rpc::RequestMessage{
              .id = next_backend_jsonrpc_id++,
              .method = "tools/call",
              .params = json{
                  {"name", tool_name},
                  {"arguments", arguments},
              },
          }),
          std::format("tools/call:{}", tool_name));
      if (!backend_response.has_value()) {
        auto tool_result = BuildBackendUnavailableToolResult();
        result.response = json(json_rpc::SuccessResponseMessage{
                                   .id = id,
                                   .result = mcp::ToolCallResponse{
                                       .text = tool_result.text,
                                       .structured_content = tool_result.structured_content.has_value()
                                                                 ? json(tool_result.structured_content.value())
                                                                 : json(nullptr),
                                       .is_error = tool_result.is_error,
                                   },
                               })
                              .dump();
        return result;
      }

      if (backend_response->result.has_value()) {
        result.response = json(json_rpc::SuccessResponseMessage{
                                   .id = id,
                                   .result = backend_response->result.value(),
                               })
                              .dump();
        return result;
      }

      const auto& error = backend_response->error.value();
      result.response = json(json_rpc::SuccessResponseMessage{
                                 .id = id,
                                 .result = mcp::ToolCallResponse{
                                     .text = error["message"].get<std::string>(),
                                     .structured_content = error.contains("data") ? error["data"] : json(nullptr),
                                     .is_error = backend_response->IsError(),
                                 },
                             })
                            .dump();
      return result;
    }

    result.response = json(json_rpc::ErrorResponseMessage{
                               .id = id,
                               .error = json_rpc::ErrorObject{
                                   .code = json_rpc::METHOD_NOT_FOUND,
                                   .message = "Method not found",
                                   .data = json{
                                       {"method", method},
                                   },
                               },
                           })
                          .dump();
    return result;
  }

  Options options;
  ipc::Client client;
  std::uint64_t next_transport_id = 1u;
  std::uint64_t next_backend_jsonrpc_id = 1u;
  bool initialized = false;
  bool backend_initialized = false;
  std::optional<std::string> selected_pipe;
  std::optional<std::string> connected_pipe;
  bool manual_pipe_selection = false;
  std::optional<BackendDiagnostic> last_backend_error;
};

}  // namespace

int main(int argc, char** argv) {
  auto parse_result = ParseOptions(argc, argv);
  if (!parse_result.options.has_value()) {
    return parse_result.exit_code;
  }

  Bridge bridge(parse_result.options.value());
  std::string frame;
  while (StdioTransport::ReadFrame(frame)) {
    try {
      auto result = bridge.HandleFrame(frame);
      if (result.response.has_value() && !StdioTransport::WriteFrame(result.response.value())) {
        std::cerr << "Failed to write stdio response frame.\n";
        return 1;
      }
      for (const auto& notification : result.notifications) {
        if (!StdioTransport::WriteFrame(notification)) {
          std::cerr << "Failed to write stdio notification frame.\n";
          return 1;
        }
      }
    } catch (const std::exception& e) {
      const auto error = json(json_rpc::ErrorResponseMessage{
                                  .id = nullptr,
                                  .error = json_rpc::ErrorObject{
                                      .code = json_rpc::INTERNAL_ERROR,
                                      .message = e.what(),
                                  },
                              })
                             .dump();
      if (!StdioTransport::WriteFrame(error)) {
        std::cerr << "Failed to write stdio exception frame.\n";
        return 1;
      }
    } catch (...) {
      const auto error = json(json_rpc::ErrorResponseMessage{
                                  .id = nullptr,
                                  .error = json_rpc::ErrorObject{
                                      .code = json_rpc::INTERNAL_ERROR,
                                      .message = "Unhandled bridge exception",
                                  },
                              })
                             .dump();
      if (!StdioTransport::WriteFrame(error)) {
        std::cerr << "Failed to write stdio exception frame.\n";
        return 1;
      }
    }
  }

  return 0;
}
