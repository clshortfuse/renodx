/* Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 * Standalone Windows transport regression test; see ipc_pipe_test.md.
 */
#define main renodx_bridge_main
#include "../src/apps/mcp_bridge/main.cpp"
#undef main

int main() {
  int failures = 0;
  auto check = [&](bool ok, const char* name) {
    std::cout << (ok ? "PASS " : "FAIL ") << name << '\n';
    if (!ok) ++failures;
  };
  check(MatchesDevkitPipePrefix("renodx-devkit-mcp-1"), "legacy discovery match");
  check(MatchesDevkitPipePrefix("LOCAL\\renodx-devkit-mcp-1"), "LOCAL discovery match");
  check(MatchesDevkitPipePrefix("local\\renodx-devkit-mcp-1"), "case-insensitive LOCAL prefix");
  check(!MatchesDevkitPipePrefix("LOCAL\\unrelated-1"), "unrelated pipe excluded");

  const auto echo = [](const ipc::Message& m, ipc::Server& server) { server.SendResponse(m, m.payload); };
  for (const auto* prefix : {L"", L"LOCAL\\"}) {
    ipc::Server server;
    auto name = std::wstring(prefix) + L"renodx-devkit-mcp-test-" + std::to_wstring(GetCurrentProcessId());
    check(server.Start({.pipe_name = name, .max_instances = 4}, echo), "listener startup");
    check(server.IsRunning(), "running after successful Start");
    const auto pipes = EnumerateDevkitPipes();
    const auto utf8_name = WideToUtf8(name);
    check(std::ranges::find(pipes, utf8_name) != pipes.end(), "OS discovery preserves full pipe name");
    for (int i = 0; i < 3; ++i) {
      ipc::Client client;
      check(client.Connect(name, 1000), "connect/reconnect with enumerated namespace");
      ipc::Message response;
      check(client.Request(ipc::MakeRequest(42, "echo", ipc::ToPayload("transport test")), response)
            && ipc::PayloadToString(response.payload) == "transport test", "framed request/response");
    }
    server.Stop();
    check(!server.IsRunning(), "Stop while listener awaits connection");
  }

  ipc::Server failed;
  std::string diagnostic;
  auto log = [&](std::string_view s) { diagnostic = s; };
  check(!failed.Start({.pipe_name = std::wstring(300, L'x'), .log_handler = log}, echo), "invalid pipe name fails Start synchronously");
  check(!failed.IsRunning() && diagnostic.find("CreateNamedPipeW") != std::string::npos
        && diagnostic.find("GetLastError=") != std::string::npos, "creation failure logs operation and Win32 error");
  diagnostic.clear();
  check(!failed.Start({.pipe_name = L"renodx-invalid-sddl", .security_descriptor_sddl = L"invalid", .log_handler = log}, echo), "invalid security descriptor fails Start");
  check(diagnostic.find("ConvertStringSecurityDescriptorToSecurityDescriptorW") != std::string::npos, "security failure logged");
  check(failed.Start(L"renodx-retry-test", echo), "explicit retry after failed startup");
  failed.Stop();
  return failures ? 1 : 0;
}
