/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <functional>
#include <format>
#include <mutex>
#include <string>
#include <string_view>

#include <Windows.h>

#include <include/reshade.hpp>

#include "../../../utils/build_info.hpp"
#include "../../../utils/mcp/server.hpp"

namespace renodx::addons::devkit::mcp::server_session {

struct Session {
  std::mutex start_mutex;
  bool start_failed = false;
  bool start_succeeded = false;
  renodx::utils::mcp::Server server;
};

inline Session Create(std::wstring_view pipe_prefix) {
  return Session{
      .server = renodx::utils::mcp::Server({
          .pipe_name = std::format(L"{}-{}", pipe_prefix, GetCurrentProcessId()),
          .server_name = "renodx-devkit",
          .server_title = "RenoDX DevKit",
          .server_version = std::string(renodx::build_info::kBuildVersion),
          .transport_log_handler = [](std::string_view message) {
            reshade::log::message(reshade::log::level::error, std::string(message).c_str());
          },
      }),
  };
}

inline void EnsureStarted(
    Session& session,
    const std::function<void(renodx::utils::mcp::Server&)>& register_tools,
    const std::function<std::string()>& get_pipe_name) {
  if (session.server.IsRunning()) return;

  std::scoped_lock lock(session.start_mutex);
  if (session.server.IsRunning() || session.start_failed) return;

  if (session.start_succeeded) {
    session.start_failed = true;
    reshade::log::message(reshade::log::level::error,
                          "devkit::mcp(Server stopped after startup; see transport error above. Automatic restart disabled)");
    return;
  }

  register_tools(session.server);
  if (session.server.Start()) {
    session.start_succeeded = true;
    reshade::log::message(
        reshade::log::level::info,
        std::format("devkit::mcp(Listening on {})", get_pipe_name()).c_str());
    return;
  }

  session.start_failed = true;
  reshade::log::message(reshade::log::level::warning, "devkit::mcp(Failed to start MCP server)");
}

inline void Stop(Session& session) {
  session.start_failed = false;
  session.start_succeeded = false;
  session.server.Stop();
}

}  // namespace renodx::addons::devkit::mcp::server_session
