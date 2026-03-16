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
static constexpr int INVALID_REQUEST = -32600;

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

inline json MakeSuccessResponse(const json& id, const json& result) {
  return json{
      {"jsonrpc", std::string(VERSION)},
      {"id", id},
      {"result", result},
  };
}

inline json MakeErrorResponse(
    const json& id,
    int code,
    std::string_view message,
    const json& data = nullptr) {
  json error = {
      {"code", code},
      {"message", std::string(message)},
  };
  if (!data.is_null()) {
    error["data"] = data;
  }

  return json{
      {"jsonrpc", std::string(VERSION)},
      {"id", id},
      {"error", error},
  };
}

inline json MakeRequest(const json& id, std::string_view method, const json& params = nullptr) {
  json request = {
      {"jsonrpc", std::string(VERSION)},
      {"id", id},
      {"method", std::string(method)},
  };
  if (!params.is_null()) {
    request["params"] = params;
  }
  return request;
}

inline json MakeNotification(std::string_view method, const json& params = nullptr) {
  json notification = {
      {"jsonrpc", std::string(VERSION)},
      {"method", std::string(method)},
  };
  if (!params.is_null()) {
    notification["params"] = params;
  }
  return notification;
}

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
        .error_response = MakeErrorResponse(nullptr, INVALID_REQUEST, invalid_object_message),
    };
  }

  const bool has_id = request.contains("id");
  const json response_id = NormalizeResponseId(request);
  if (has_id && !IsValidRequestId(request["id"])) {
    return ParseRequestResult{
        .error_response = MakeErrorResponse(
            response_id,
            INVALID_REQUEST,
            "Request id must be a string, number, or null"),
    };
  }

  if (!request.contains("jsonrpc")
      || !request["jsonrpc"].is_string()
      || request["jsonrpc"].get_ref<const std::string&>() != VERSION) {
    return ParseRequestResult{
        .error_response = has_id
                              ? std::optional<json>(MakeErrorResponse(
                                    response_id,
                                    INVALID_REQUEST,
                                    "Only JSON-RPC 2.0 messages are supported"))
                              : std::nullopt,
    };
  }

  if (!request.contains("method") || !request["method"].is_string()) {
    return ParseRequestResult{
        .error_response = has_id
                              ? std::optional<json>(MakeErrorResponse(
                                    response_id,
                                    INVALID_REQUEST,
                                    invalid_request_message))
                              : std::nullopt,
    };
  }

  if (request.contains("params")
      && !request["params"].is_object()
      && !request["params"].is_array()) {
    return ParseRequestResult{
        .error_response = has_id
                              ? std::optional<json>(MakeErrorResponse(
                                    response_id,
                                    INVALID_REQUEST,
                                    "Request params must be an object or array"))
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
