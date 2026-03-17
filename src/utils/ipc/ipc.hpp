/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <Windows.h>

#include <atomic>
#include <condition_variable>
#include <cstdint>
#include <exception>
#include <functional>
#include <memory>
#include <mutex>
#include <optional>
#include <span>
#include <sstream>
#include <string>
#include <string_view>
#include <thread>
#include <unordered_map>
#include <utility>
#include <vector>

namespace renodx::utils::ipc {

using Payload = std::vector<uint8_t>;
inline constexpr std::uint32_t DEFAULT_PIPE_BUFFER_SIZE = 64u * 1024u;
inline constexpr std::uint32_t DEFAULT_MAX_MESSAGE_SIZE = 4u * 1024u * 1024u;
// DACL:
// - SYSTEM: full access
// - Built-in Administrators: full access
// - Everyone: generic read/write
// Remote clients are still rejected by the pipe creation flags.
inline constexpr std::wstring_view DEFAULT_LOCAL_PIPE_RW_SECURITY_DESCRIPTOR_SDDL =
    L"D:(A;;GA;;;SY)(A;;GA;;;BA)(A;;GRGW;;;WD)";

enum class MessageKind : std::uint8_t {
  REQUEST = 0,
  RESPONSE = 1,
  EVENT = 2,
};

struct Message {
  MessageKind kind = MessageKind::REQUEST;
  std::uint64_t id = 0;
  std::string name;
  Payload payload;
  std::uint64_t connection_id = 0u;
};

inline Payload ToPayload(std::span<const std::uint8_t> bytes) {
  return {bytes.begin(), bytes.end()};
}

inline Payload ToPayload(std::string_view text) {
  return {reinterpret_cast<const std::uint8_t*>(text.data()), reinterpret_cast<const std::uint8_t*>(text.data() + text.size())};
}

inline std::string PayloadToString(std::span<const std::uint8_t> bytes) {
  return {reinterpret_cast<const char*>(bytes.data()), bytes.size()};
}

inline Message MakeMessage(
    MessageKind kind,
    std::uint64_t id,
    std::string_view name,
    std::span<const std::uint8_t> payload = {}) {
  return Message{
      .kind = kind,
      .id = id,
      .name = std::string(name),
      .payload = ToPayload(payload),
  };
}

inline Message MakeRequest(std::uint64_t id, std::string_view name, std::span<const std::uint8_t> payload = {}) {
  return MakeMessage(MessageKind::REQUEST, id, name, payload);
}

inline Message MakeResponse(std::uint64_t id, std::string_view name, std::span<const std::uint8_t> payload = {}) {
  return MakeMessage(MessageKind::RESPONSE, id, name, payload);
}

inline Message MakeEvent(std::string_view name, std::span<const std::uint8_t> payload = {}) {
  return MakeMessage(MessageKind::EVENT, 0, name, payload);
}

struct ServerConfig {
  std::wstring pipe_name;
  std::uint32_t input_buffer_size = DEFAULT_PIPE_BUFFER_SIZE;
  std::uint32_t output_buffer_size = DEFAULT_PIPE_BUFFER_SIZE;
  std::uint32_t max_message_size = DEFAULT_MAX_MESSAGE_SIZE;
  std::uint32_t max_instances = 1u;
  std::optional<std::wstring> security_descriptor_sddl = std::wstring(DEFAULT_LOCAL_PIPE_RW_SECURITY_DESCRIPTOR_SDDL);
};

class Server;
using MessageHandler = std::function<void(const Message&, Server&)>;
using ConnectionClosedHandler = std::function<void(std::uint64_t, Server&)>;

namespace internal {

template <typename Function>
[[nodiscard]] inline Function LoadModuleProc(std::wstring_view module_name, const char* proc_name) {
  auto module = GetModuleHandleW(module_name.data());
  if (module == nullptr) {
    module = LoadLibraryW(module_name.data());
  }
  if (module == nullptr) {
    return nullptr;
  }

  return reinterpret_cast<Function>(GetProcAddress(module, proc_name));
}

constexpr std::uint32_t FRAME_MAGIC = 0x49584452u;  // RDXI
constexpr std::uint16_t FRAME_VERSION = 1u;

struct FrameHeader {
  std::uint32_t magic = FRAME_MAGIC;
  std::uint16_t version = FRAME_VERSION;
  std::uint8_t kind = 0u;
  std::uint8_t reserved = 0u;
  std::uint64_t id = 0u;
  std::uint32_t name_size = 0u;
  std::uint32_t payload_size = 0u;
};

static_assert(sizeof(FrameHeader) == 24u);

inline std::wstring ToWide(std::string_view text) {
  if (text.empty()) return {};

  auto required = MultiByteToWideChar(CP_UTF8, 0, text.data(), static_cast<int>(text.size()), nullptr, 0);
  if (required <= 0) return {};

  std::wstring wide(required, L'\0');
  required = MultiByteToWideChar(CP_UTF8, 0, text.data(), static_cast<int>(text.size()), wide.data(), static_cast<int>(wide.size()));
  if (required <= 0) return {};
  return wide;
}

inline std::string ToNarrow(std::wstring_view text) {
  if (text.empty()) return {};

  auto required = WideCharToMultiByte(CP_UTF8, 0, text.data(), static_cast<int>(text.size()), nullptr, 0, nullptr, nullptr);
  if (required <= 0) return {};

  std::string narrow(required, '\0');
  required = WideCharToMultiByte(CP_UTF8, 0, text.data(), static_cast<int>(text.size()), narrow.data(), static_cast<int>(narrow.size()), nullptr, nullptr);
  if (required <= 0) return {};
  return narrow;
}

inline std::string FormatSystemMessage(DWORD error) {
  if (error == ERROR_SUCCESS) return {};

  wchar_t* buffer = nullptr;
  const auto flags = FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS;
  const auto length = FormatMessageW(
      flags,
      nullptr,
      error,
      0,
      reinterpret_cast<LPWSTR>(&buffer),
      0,
      nullptr);
  if (length == 0 || buffer == nullptr) {
    return {};
  }

  std::wstring_view message(buffer, length);
  while (!message.empty()) {
    const auto tail = message.back();
    if (tail != L'\r' && tail != L'\n' && tail != L' ') break;
    message.remove_suffix(1);
  }

  auto result = ToNarrow(message);
  LocalFree(buffer);
  return result;
}

template <typename... Args>
inline void DebugLog(Args&&... args) {
  std::ostringstream stream;
  (stream << ... << std::forward<Args>(args));
  auto message = stream.str();
  message.push_back('\n');
  OutputDebugStringA(message.c_str());
}

inline std::wstring NormalizePipeName(std::wstring_view pipe_name) {
  static constexpr auto PIPE_PREFIX = std::wstring_view(LR"(\\.\pipe\)");
  if (pipe_name.empty()) return {};
  if (pipe_name.starts_with(PIPE_PREFIX)) return std::wstring(pipe_name);
  return std::wstring(PIPE_PREFIX) + std::wstring(pipe_name);
}

inline std::wstring NormalizePipeName(std::string_view pipe_name) {
  return NormalizePipeName(ToWide(pipe_name));
}

inline void CloseHandleIfValid(HANDLE& handle) {
  if (handle != nullptr && handle != INVALID_HANDLE_VALUE) {
    CloseHandle(handle);
  }
  handle = INVALID_HANDLE_VALUE;
}

inline bool WriteExact(HANDLE pipe, const void* data, std::size_t size) {
  auto remaining = static_cast<DWORD>(size);
  const auto* cursor = static_cast<const std::uint8_t*>(data);

  while (remaining > 0u) {
    DWORD written = 0u;
    if (WriteFile(pipe, cursor, remaining, &written, nullptr) == 0) {
      return false;
    }
    if (written == 0u) return false;
    remaining -= written;
    cursor += written;
  }

  return true;
}

inline bool ReadExact(HANDLE pipe, void* data, std::size_t size) {
  auto remaining = static_cast<DWORD>(size);
  auto* cursor = static_cast<std::uint8_t*>(data);

  while (remaining > 0u) {
    DWORD read = 0u;
    if (ReadFile(pipe, cursor, remaining, &read, nullptr) == 0) {
      return false;
    }
    if (read == 0u) return false;
    remaining -= read;
    cursor += read;
  }

  return true;
}

inline bool SendMessage(HANDLE pipe, const Message& message) {
  auto name_size = message.name.size();
  auto payload_size = message.payload.size();
  if (name_size > UINT32_MAX || payload_size > UINT32_MAX) return false;

  auto header = FrameHeader{
      .magic = FRAME_MAGIC,
      .version = FRAME_VERSION,
      .kind = static_cast<std::uint8_t>(message.kind),
      .reserved = 0u,
      .id = message.id,
      .name_size = static_cast<std::uint32_t>(name_size),
      .payload_size = static_cast<std::uint32_t>(payload_size),
  };

  if (!WriteExact(pipe, &header, sizeof(header))) return false;
  if (name_size != 0u && !WriteExact(pipe, message.name.data(), name_size)) return false;
  if (payload_size != 0u && !WriteExact(pipe, message.payload.data(), payload_size)) return false;

  return true;
}

inline bool ReceiveMessage(HANDLE pipe, Message& message, std::uint32_t max_message_size) {
  FrameHeader header = {};
  if (!ReadExact(pipe, &header, sizeof(header))) return false;

  if (header.magic != FRAME_MAGIC || header.version != FRAME_VERSION) return false;
  if (header.kind > static_cast<std::uint8_t>(MessageKind::EVENT)) return false;

  const auto total_size = static_cast<std::uint64_t>(header.name_size) + static_cast<std::uint64_t>(header.payload_size);
  if (total_size > max_message_size) return false;

  message.kind = static_cast<MessageKind>(header.kind);
  message.id = header.id;
  message.name.assign(header.name_size, '\0');
  message.payload.assign(header.payload_size, 0u);

  if (header.name_size != 0u && !ReadExact(pipe, message.name.data(), header.name_size)) return false;
  if (header.payload_size != 0u && !ReadExact(pipe, message.payload.data(), header.payload_size)) return false;

  return true;
}

struct SecurityAttributesStorage {
  using ConvertSecurityDescriptorFn = BOOL(WINAPI*)(LPCWSTR, DWORD, PSECURITY_DESCRIPTOR*, PULONG);

  SECURITY_ATTRIBUTES attributes = {
      .nLength = sizeof(SECURITY_ATTRIBUTES),
      .lpSecurityDescriptor = nullptr,
      .bInheritHandle = FALSE,
  };
  PSECURITY_DESCRIPTOR security_descriptor = nullptr;

  SecurityAttributesStorage() = default;
  SecurityAttributesStorage(const SecurityAttributesStorage&) = delete;
  SecurityAttributesStorage& operator=(const SecurityAttributesStorage&) = delete;

  ~SecurityAttributesStorage() {
    if (security_descriptor != nullptr) {
      LocalFree(security_descriptor);
    }
  }

  bool Initialize(std::wstring_view security_descriptor_sddl) {
    if (security_descriptor_sddl.empty()) {
      return true;
    }

    constexpr DWORD SDDL_REVISION_1_VALUE = 1u;
    static const auto convert_security_descriptor =
        LoadModuleProc<ConvertSecurityDescriptorFn>(L"advapi32.dll", "ConvertStringSecurityDescriptorToSecurityDescriptorW");
    if (convert_security_descriptor == nullptr) {
      return false;
    }

    if (convert_security_descriptor(
            security_descriptor_sddl.data(),
            SDDL_REVISION_1_VALUE,
            &security_descriptor,
            nullptr)
        == FALSE) {
      return false;
    }

    attributes.lpSecurityDescriptor = security_descriptor;
    return true;
  }

  [[nodiscard]] SECURITY_ATTRIBUTES* Get() {
    return security_descriptor == nullptr ? nullptr : &attributes;
  }
};

}  // namespace internal

// NOLINTBEGIN(readability-identifier-naming)
class Server {
 private:
  struct ConnectionState {
    std::uint64_t id = 0u;
    HANDLE pipe = INVALID_HANDLE_VALUE;
    mutable std::mutex write_mutex;
  };

 public:
  Server() = default;
  Server(const Server&) = delete;
  Server& operator=(const Server&) = delete;

  ~Server() {
    Stop();
  }

  bool Start(const ServerConfig& config, MessageHandler handler, ConnectionClosedHandler connection_closed_handler = {}) {
    if (config.pipe_name.empty()) return false;
    if (worker_thread_.joinable()) return false;
    if (config.max_instances == 0u) return false;
    if (config.max_instances > PIPE_UNLIMITED_INSTANCES && config.max_instances != PIPE_UNLIMITED_INSTANCES) return false;

    pipe_name_ = internal::NormalizePipeName(config.pipe_name);
    input_buffer_size_ = config.input_buffer_size;
    output_buffer_size_ = config.output_buffer_size;
    max_message_size_ = config.max_message_size;
    max_instances_ = config.max_instances;
    security_descriptor_sddl_ = config.security_descriptor_sddl;
    handler_ = std::move(handler);
    connection_closed_handler_ = std::move(connection_closed_handler);
    stop_requested_ = false;
    running_ = true;
    connection_count_ = 0u;
    next_connection_id_ = 1u;
    worker_thread_ = std::thread(&Server::Run, this);
    return true;
  }

  bool Start(std::wstring_view pipe_name, MessageHandler handler) {
    return Start(std::wstring_view(pipe_name), std::move(handler), {});
  }

  bool Start(std::wstring_view pipe_name, MessageHandler handler, ConnectionClosedHandler connection_closed_handler) {
    return Start(ServerConfig{.pipe_name = std::wstring(pipe_name)}, std::move(handler), std::move(connection_closed_handler));
  }

  bool Start(std::string_view pipe_name, MessageHandler handler) {
    return Start(std::string_view(pipe_name), std::move(handler), {});
  }

  bool Start(std::string_view pipe_name, MessageHandler handler, ConnectionClosedHandler connection_closed_handler) {
    return Start(ServerConfig{.pipe_name = internal::ToWide(pipe_name)}, std::move(handler), std::move(connection_closed_handler));
  }

  void Stop() {
    stop_requested_ = true;
    state_condition_.notify_all();

    HANDLE listener_pipe = INVALID_HANDLE_VALUE;
    std::vector<std::shared_ptr<ConnectionState>> connections;
    {
      std::scoped_lock lock(state_mutex_);
      listener_pipe = listener_pipe_;
      connections.reserve(connections_.size());
      for (const auto& [connection_id, connection] : connections_) {
        connections.push_back(connection);
      }
    }

    if (listener_pipe != INVALID_HANDLE_VALUE) {
      CancelIoEx(listener_pipe, nullptr);
      DisconnectNamedPipe(listener_pipe);
    }

    for (const auto& connection : connections) {
      std::scoped_lock lock(connection->write_mutex);
      if (connection->pipe != INVALID_HANDLE_VALUE) {
        CancelIoEx(connection->pipe, nullptr);
        DisconnectNamedPipe(connection->pipe);
      }
    }

    if (worker_thread_.joinable()) {
      worker_thread_.join();
    }

    {
      std::unique_lock lock(state_mutex_);
      state_condition_.wait(lock, [this]() {
        return connections_.empty();
      });
      listener_pipe_ = INVALID_HANDLE_VALUE;
    }

    handler_ = {};
    connection_closed_handler_ = {};
    running_ = false;
    connection_count_ = 0u;
  }

  [[nodiscard]] bool IsRunning() const {
    return running_;
  }

  [[nodiscard]] bool IsConnected() const {
    return connection_count_.load(std::memory_order_acquire) != 0u;
  }

  [[nodiscard]] std::wstring GetPipeName() const {
    return pipe_name_;
  }

  bool Send(const Message& message) {
    if (message.connection_id != 0u) {
      return SendToConnection(message.connection_id, message);
    }

    if (message.kind == MessageKind::EVENT) {
      return Broadcast(message);
    }

    std::shared_ptr<ConnectionState> connection;
    {
      std::scoped_lock lock(state_mutex_);
      if (connections_.size() != 1u) return false;
      connection = connections_.begin()->second;
    }

    return SendToConnection(connection, message);
  }

  bool SendResponse(std::uint64_t id, std::string_view name, std::span<const std::uint8_t> payload = {}) {
    return Send(MakeResponse(id, name, payload));
  }

  bool SendResponse(const Message& request, std::span<const std::uint8_t> payload, std::string_view name = {}) {
    auto response_name = name.empty() ? std::string_view(request.name) : name;
    auto response = MakeResponse(request.id, response_name, payload);
    response.connection_id = request.connection_id;
    return Send(response);
  }

  bool SendEvent(std::string_view name, std::span<const std::uint8_t> payload = {}) {
    return Broadcast(MakeEvent(name, payload));
  }

 private:
  void Run() {
    internal::SecurityAttributesStorage security_attributes = {};
    if (security_descriptor_sddl_.has_value() && !security_attributes.Initialize(security_descriptor_sddl_.value())) {
      internal::DebugLog("ipc::Server(Failed to create security descriptor for ", internal::ToNarrow(pipe_name_), ")");
      running_ = false;
      return;
    }

    while (!stop_requested_) {
      {
        std::unique_lock lock(state_mutex_);
        state_condition_.wait(lock, [this]() {
          return stop_requested_ || connections_.size() < max_instances_;
        });
        if (stop_requested_) {
          break;
        }
      }

      HANDLE pipe = CreateNamedPipeW(
          pipe_name_.c_str(),
          PIPE_ACCESS_DUPLEX,
          PIPE_TYPE_BYTE | PIPE_WAIT | PIPE_REJECT_REMOTE_CLIENTS,
          max_instances_,
          output_buffer_size_,
          input_buffer_size_,
          0,
          security_attributes.Get());

      if (pipe == INVALID_HANDLE_VALUE) {
        internal::DebugLog("ipc::Server(CreateNamedPipeW failed for ", internal::ToNarrow(pipe_name_), ")");
        break;
      }

      {
        std::scoped_lock lock(state_mutex_);
        listener_pipe_ = pipe;
      }

      const auto connect_result = ConnectNamedPipe(pipe, nullptr);
      const auto connect_error = connect_result != FALSE ? ERROR_SUCCESS : GetLastError();
      const bool connected = connect_result != FALSE || connect_error == ERROR_PIPE_CONNECTED;
      {
        std::scoped_lock lock(state_mutex_);
        if (listener_pipe_ == pipe) {
          listener_pipe_ = INVALID_HANDLE_VALUE;
        }
      }
      if (!connected) {
        if (connect_error != ERROR_OPERATION_ABORTED) {
          internal::DebugLog("ipc::Server(ConnectNamedPipe failed, error=", connect_error, ")");
        }
        internal::CloseHandleIfValid(pipe);
        if (stop_requested_) break;
        continue;
      }

      if (stop_requested_) {
        DisconnectNamedPipe(pipe);
        internal::CloseHandleIfValid(pipe);
        break;
      }

      auto connection = std::make_shared<ConnectionState>();
      connection->id = next_connection_id_.fetch_add(1u, std::memory_order_relaxed);
      connection->pipe = pipe;
      {
        std::scoped_lock lock(state_mutex_);
        connections_[connection->id] = connection;
        connection_count_.store(connections_.size(), std::memory_order_release);
      }

      std::thread(&Server::RunConnection, this, connection).detach();
    }

    HANDLE listener_pipe = INVALID_HANDLE_VALUE;
    {
      std::scoped_lock lock(state_mutex_);
      listener_pipe = listener_pipe_;
      listener_pipe_ = INVALID_HANDLE_VALUE;
    }
    internal::CloseHandleIfValid(listener_pipe);
    running_ = false;
  }

  void RunConnection(const std::shared_ptr<ConnectionState>& connection) {
    while (!stop_requested_) {
      Message message = {};
      if (!internal::ReceiveMessage(connection->pipe, message, max_message_size_)) {
        auto error = GetLastError();
        if (!stop_requested_
            && error != ERROR_BROKEN_PIPE
            && error != ERROR_PIPE_NOT_CONNECTED
            && error != ERROR_OPERATION_ABORTED) {
          internal::DebugLog("ipc::Server(Receive failed, error=", error, ")");
        }
        break;
      }

      message.connection_id = connection->id;
      if (handler_) {
        try {
          handler_(message, *this);
        } catch (const std::exception& exception) {
          internal::DebugLog("ipc::Server(handler threw: ", exception.what(), ")");
          break;
        } catch (...) {
          internal::DebugLog("ipc::Server(handler threw an unknown exception)");
          break;
        }
      }
    }

    RemoveConnection(connection->id);
  }

  void RemoveConnection(std::uint64_t connection_id) {
    std::shared_ptr<ConnectionState> connection;
    {
      std::scoped_lock lock(state_mutex_);
      if (auto it = connections_.find(connection_id); it != connections_.end()) {
        connection = std::move(it->second);
        connections_.erase(it);
      }
      connection_count_.store(connections_.size(), std::memory_order_release);
    }
    state_condition_.notify_all();

    if (connection != nullptr && connection_closed_handler_) {
      try {
        connection_closed_handler_(connection_id, *this);
      } catch (const std::exception& exception) {
        internal::DebugLog("ipc::Server(connection closed handler threw: ", exception.what(), ")");
      } catch (...) {
        internal::DebugLog("ipc::Server(connection closed handler threw an unknown exception)");
      }
    }

    CloseConnection(connection);
  }

  static void CloseConnection(const std::shared_ptr<ConnectionState>& connection) {
    if (connection == nullptr) return;

    std::scoped_lock lock(connection->write_mutex);
    if (connection->pipe != INVALID_HANDLE_VALUE) {
      DisconnectNamedPipe(connection->pipe);
      internal::CloseHandleIfValid(connection->pipe);
    }
  }

  bool SendToConnection(std::uint64_t connection_id, const Message& message) {
    std::shared_ptr<ConnectionState> connection;
    {
      std::scoped_lock lock(state_mutex_);
      if (auto it = connections_.find(connection_id); it != connections_.end()) {
        connection = it->second;
      }
    }

    return SendToConnection(connection, message);
  }

  static bool SendToConnection(const std::shared_ptr<ConnectionState>& connection, const Message& message) {
    if (connection == nullptr) return false;

    std::scoped_lock lock(connection->write_mutex);
    if (connection->pipe == INVALID_HANDLE_VALUE) return false;
    return internal::SendMessage(connection->pipe, message);
  }

  bool Broadcast(const Message& message) {
    std::vector<std::shared_ptr<ConnectionState>> connections;
    {
      std::scoped_lock lock(state_mutex_);
      connections.reserve(connections_.size());
      for (const auto& [connection_id, connection] : connections_) {
        connections.push_back(connection);
      }
    }

    bool sent = false;
    for (const auto& connection : connections) {
      sent = SendToConnection(connection, message) || sent;
    }

    return sent;
  }

  std::wstring pipe_name_;
  std::uint32_t input_buffer_size_ = DEFAULT_PIPE_BUFFER_SIZE;
  std::uint32_t output_buffer_size_ = DEFAULT_PIPE_BUFFER_SIZE;
  std::uint32_t max_message_size_ = DEFAULT_MAX_MESSAGE_SIZE;
  std::uint32_t max_instances_ = 1u;
  std::optional<std::wstring> security_descriptor_sddl_;
  MessageHandler handler_;
  ConnectionClosedHandler connection_closed_handler_;
  std::thread worker_thread_;
  std::atomic_bool stop_requested_ = false;
  std::atomic_bool running_ = false;
  std::atomic_size_t connection_count_ = 0u;
  std::atomic<std::uint64_t> next_connection_id_ = 1u;
  mutable std::mutex state_mutex_;
  std::condition_variable state_condition_;
  HANDLE listener_pipe_ = INVALID_HANDLE_VALUE;
  std::unordered_map<std::uint64_t, std::shared_ptr<ConnectionState>> connections_;
};

class Client {
 public:
  Client() = default;
  Client(const Client&) = delete;
  Client& operator=(const Client&) = delete;

  ~Client() {
    Disconnect();
  }

  bool Connect(std::wstring_view pipe_name, std::uint32_t wait_ms = 0u) {
    return ConnectNormalized(internal::NormalizePipeName(pipe_name), wait_ms);
  }

  bool Connect(std::string_view pipe_name, std::uint32_t wait_ms = 0u) {
    return ConnectNormalized(internal::NormalizePipeName(pipe_name), wait_ms);
  }

  void Disconnect() {
    std::scoped_lock lock(mutex_);
    ResetConnectionLocked();
  }

  [[nodiscard]] bool IsConnected() const {
    std::scoped_lock lock(mutex_);
    return pipe_ != INVALID_HANDLE_VALUE;
  }

  [[nodiscard]] std::wstring GetPipeName() const {
    std::scoped_lock lock(mutex_);
    return pipe_name_;
  }

  [[nodiscard]] std::optional<DWORD> GetLastErrorCode() const {
    std::scoped_lock lock(mutex_);
    return last_error_code_;
  }

  [[nodiscard]] std::string GetLastErrorMessage() const {
    std::scoped_lock lock(mutex_);
    return last_error_message_;
  }

  bool Send(const Message& message) {
    std::scoped_lock lock(mutex_);
    if (pipe_ == INVALID_HANDLE_VALUE) return false;
    if (internal::SendMessage(pipe_, message)) return true;
    SetLastErrorLocked(GetLastError());
    ResetConnectionLocked();
    return false;
  }

  bool SendRequest(std::uint64_t id, std::string_view name, std::span<const std::uint8_t> payload = {}) {
    return Send(MakeRequest(id, name, payload));
  }

  bool SendResponse(std::uint64_t id, std::string_view name, std::span<const std::uint8_t> payload = {}) {
    return Send(MakeResponse(id, name, payload));
  }

  bool SendEvent(std::string_view name, std::span<const std::uint8_t> payload = {}) {
    return Send(MakeEvent(name, payload));
  }

  std::optional<Message> Receive(std::uint32_t max_message_size = DEFAULT_MAX_MESSAGE_SIZE) {
    std::scoped_lock lock(mutex_);
    if (pipe_ == INVALID_HANDLE_VALUE) return std::nullopt;

    Message message = {};
    if (!internal::ReceiveMessage(pipe_, message, max_message_size)) {
      auto error = GetLastError();
      if (error == ERROR_SUCCESS) {
        error = ERROR_INVALID_DATA;
      }
      SetLastErrorLocked(error);
      ResetConnectionLocked();
      return std::nullopt;
    }
    return message;
  }

  bool Request(const Message& request, Message& response, std::uint32_t max_message_size = DEFAULT_MAX_MESSAGE_SIZE) {
    if (request.kind != MessageKind::REQUEST) return false;
    if (!Send(request)) return false;

    auto received = Receive(max_message_size);
    if (!received.has_value()) return false;
    if (received->kind != MessageKind::RESPONSE) return false;
    if (received->id != request.id) return false;

    response = std::move(received.value());
    return true;
  }

 private:
  bool ConnectNormalized(std::wstring normalized_pipe_name, std::uint32_t wait_ms) {
    Disconnect();
    if (normalized_pipe_name.empty()) return false;

    HANDLE pipe = CreateFileW(
        normalized_pipe_name.c_str(),
        GENERIC_READ | GENERIC_WRITE,
        0,
        nullptr,
        OPEN_EXISTING,
        0,
        nullptr);

    auto last_error = pipe == INVALID_HANDLE_VALUE ? GetLastError() : ERROR_SUCCESS;

    if (pipe == INVALID_HANDLE_VALUE && last_error == ERROR_PIPE_BUSY && wait_ms != 0u) {
      if (WaitNamedPipeW(normalized_pipe_name.c_str(), wait_ms) != FALSE) {
        pipe = CreateFileW(
            normalized_pipe_name.c_str(),
            GENERIC_READ | GENERIC_WRITE,
            0,
            nullptr,
            OPEN_EXISTING,
            0,
            nullptr);
        last_error = pipe == INVALID_HANDLE_VALUE ? GetLastError() : ERROR_SUCCESS;
      } else {
        last_error = GetLastError();
      }
    }

    if (pipe == INVALID_HANDLE_VALUE) {
      std::scoped_lock lock(mutex_);
      pipe_name_.clear();
      SetLastErrorLocked(last_error);
      return false;
    }

    std::scoped_lock lock(mutex_);
    pipe_ = pipe;
    pipe_name_ = std::move(normalized_pipe_name);
    ClearLastErrorLocked();
    return true;
  }

  void ResetConnectionLocked() {
    if (pipe_ != INVALID_HANDLE_VALUE) {
      CancelIoEx(pipe_, nullptr);
      internal::CloseHandleIfValid(pipe_);
    }
    pipe_name_.clear();
  }

  void ClearLastErrorLocked() {
    last_error_code_.reset();
    last_error_message_.clear();
  }

  void SetLastErrorLocked(DWORD error) {
    last_error_code_ = error;
    last_error_message_ = internal::FormatSystemMessage(error);
  }

  mutable std::mutex mutex_;
  HANDLE pipe_ = INVALID_HANDLE_VALUE;
  std::wstring pipe_name_;
  std::optional<DWORD> last_error_code_;
  std::string last_error_message_;
};
// NOLINTEND(readability-identifier-naming)

}  // namespace renodx::utils::ipc
