/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <optional>
#include <string>
#include <string_view>

#include <nlohmann/json.hpp>

namespace renodx::utils::json_rpc {

using json = nlohmann::json;

// https://www.jsonrpc.org/specification

inline constexpr std::string_view VERSION = "2.0";
inline constexpr int PARSE_ERROR = -32700;
inline constexpr int INVALID_REQUEST = -32600;
inline constexpr int METHOD_NOT_FOUND = -32601;
inline constexpr int INVALID_PARAMS = -32602;
inline constexpr int INTERNAL_ERROR = -32603;

struct Request {
  std::optional<json> id = std::nullopt;
  std::string method;
  json params = json::object();

  [[nodiscard]] bool ExpectsResponse() const {
    return id.has_value();
  }
};

struct ParseRequestResult {
  std::optional<Request> request = std::nullopt;
  std::optional<json> error_response = std::nullopt;
};

struct Response {
  json id = nullptr;
  std::optional<json> result = std::nullopt;
  std::optional<json> error = std::nullopt;

  [[nodiscard]] bool IsError() const {
    return error.has_value();
  }
};

struct ParseResponseResult {
  std::optional<Response> response = std::nullopt;
  std::optional<std::string> error_message = std::nullopt;
};

struct ErrorObject {
  int code = INTERNAL_ERROR;
  std::string_view message;
  std::optional<json> data = std::nullopt;
};

struct SuccessResponseMessage {
  json id = nullptr;
  json result = nullptr;
};

struct ErrorResponseMessage {
  json id = nullptr;
  ErrorObject error = {};
};

struct RequestMessage {
  json id = nullptr;
  std::string_view method;
  std::optional<json> params = std::nullopt;
};

struct NotificationMessage {
  std::string_view method;
  std::optional<json> params = std::nullopt;
};

// NOLINTBEGIN(readability-identifier-naming)
inline void to_json(json& value, const ErrorObject& error) {
  value = json{
      {"code", error.code},
      {"message", std::string(error.message)},
  };
  if (error.data.has_value()) {
    value["data"] = *error.data;
  }
}

inline void to_json(json& value, const SuccessResponseMessage& response) {
  value = json{
      {"jsonrpc", std::string(VERSION)},
      {"id", response.id},
      {"result", response.result},
  };
}

inline void to_json(json& value, const ErrorResponseMessage& response) {
  value = json{
      {"jsonrpc", std::string(VERSION)},
      {"id", response.id},
      {"error", response.error},
  };
}

inline void to_json(json& value, const RequestMessage& request) {
  value = json{
      {"jsonrpc", std::string(VERSION)},
      {"id", request.id},
      {"method", std::string(request.method)},
  };
  if (request.params.has_value()) {
    value["params"] = *request.params;
  }
}

inline void to_json(json& value, const NotificationMessage& notification) {
  value = json{
      {"jsonrpc", std::string(VERSION)},
      {"method", std::string(notification.method)},
  };
  if (notification.params.has_value()) {
    value["params"] = *notification.params;
  }
}
// NOLINTEND(readability-identifier-naming)

inline bool IsValidRequestId(const json& id) {
  return id.is_null() || id.is_string() || id.is_number();
}

inline json NormalizeResponseId(const json& message) {
  if (!message.is_object() || !message.contains("id")) {
    return nullptr;
  }

  const auto& id = message["id"];
  return IsValidRequestId(id) ? id : json(nullptr);
}

inline ParseRequestResult ParseRequestObject(
    const json& request,
    std::string_view invalid_object_message,
    std::string_view invalid_request_message) {
  if (!request.is_object()) {
    return ParseRequestResult{
        .error_response = json(ErrorResponseMessage{
            .id = nullptr,
            .error = ErrorObject{
                .code = INVALID_REQUEST,
                .message = invalid_object_message,
            },
        }),
    };
  }

  const bool has_id = request.contains("id");
  const json response_id = NormalizeResponseId(request);
  if (has_id && !IsValidRequestId(request["id"])) {
    return ParseRequestResult{
        .error_response = json(ErrorResponseMessage{
            .id = response_id,
            .error = ErrorObject{
                .code = INVALID_REQUEST,
                .message = "Request id must be a string, number, or null",
            },
        }),
    };
  }

  if (!request.contains("jsonrpc")
      || !request["jsonrpc"].is_string()
      || request["jsonrpc"].get_ref<const std::string&>() != VERSION) {
    return ParseRequestResult{
        .error_response = has_id
                              ? std::optional<json>(json(ErrorResponseMessage{
                                    .id = response_id,
                                    .error = ErrorObject{
                                        .code = INVALID_REQUEST,
                                        .message = "Only JSON-RPC 2.0 messages are supported",
                                    },
                                }))
                              : std::nullopt,
    };
  }

  if (!request.contains("method") || !request["method"].is_string()) {
    return ParseRequestResult{
        .error_response = has_id
                              ? std::optional<json>(json(ErrorResponseMessage{
                                    .id = response_id,
                                    .error = ErrorObject{
                                        .code = INVALID_REQUEST,
                                        .message = invalid_request_message,
                                    },
                                }))
                              : std::nullopt,
    };
  }

  if (request.contains("params")
      && !request["params"].is_object()
      && !request["params"].is_array()) {
    return ParseRequestResult{
        .error_response = has_id
                              ? std::optional<json>(json(ErrorResponseMessage{
                                    .id = response_id,
                                    .error = ErrorObject{
                                        .code = INVALID_REQUEST,
                                        .message = "Request params must be an object or array",
                                    },
                                }))
                              : std::nullopt,
    };
  }

  return ParseRequestResult{
      .request = Request{
          .id = has_id ? std::optional<json>(request["id"]) : std::nullopt,
          .method = request["method"].get<std::string>(),
          .params = request.contains("params") ? request["params"] : json::object(),
      },
  };
}

inline ParseResponseResult ParseResponseObject(
    const json& response,
    std::string_view invalid_object_message,
    std::string_view invalid_response_message) {
  if (!response.is_object()) {
    return ParseResponseResult{
        .error_message = std::string(invalid_object_message),
    };
  }

  if (!response.contains("jsonrpc")
      || !response["jsonrpc"].is_string()
      || response["jsonrpc"].get_ref<const std::string&>() != VERSION) {
    return ParseResponseResult{
        .error_message = "Only JSON-RPC 2.0 messages are supported",
    };
  }

  if (!response.contains("id") || !IsValidRequestId(response["id"])) {
    return ParseResponseResult{
        .error_message = "Response id must be a string, number, or null",
    };
  }

  const bool has_result = response.contains("result");
  const bool has_error = response.contains("error");
  if (has_result == has_error) {
    return ParseResponseResult{
        .error_message = std::string(invalid_response_message),
    };
  }

  if (has_error) {
    const auto& error = response["error"];
    if (!error.is_object()
        || !error.contains("code")
        || !error["code"].is_number_integer()
        || !error.contains("message")
        || !error["message"].is_string()) {
      return ParseResponseResult{
          .error_message = "Response error must be an object with integer code and string message",
      };
    }
  }

  return ParseResponseResult{
      .response = Response{
          .id = response["id"],
          .result = has_result ? std::optional<json>(response["result"]) : std::nullopt,
          .error = has_error ? std::optional<json>(response["error"]) : std::nullopt,
      },
  };
}

}  // namespace renodx::utils::json_rpc
