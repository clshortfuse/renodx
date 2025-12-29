/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <Windows.h>

#include <algorithm>
#include <array>
#include <atomic>
#include <cctype>
#include <cstdint>
#include <cstring>
#include <cstdlib>
#include <exception>
#include <filesystem>
#include <mutex>
#include <sstream>
#include <shared_mutex>
#include <span>
#include <string>
#include <vector>

#include "./path.hpp"

namespace renodx::utils::shader::compiler::slang {

namespace internal {

static std::shared_mutex mutex_slangc_path;
static std::filesystem::path cached_slangc_path;
static std::atomic_uint32_t compile_counter = 0;
static std::optional<std::filesystem::path> cached_spirv_dis;
static std::optional<std::filesystem::path> cached_spirv_cross;

inline std::wstring ToWide(const char* value, UINT code_page = CP_UTF8) {
  if (value == nullptr || value[0] == '\0') return {};
  const int wide_char_length = MultiByteToWideChar(code_page, 0, value, -1, nullptr, 0);
  if (wide_char_length == 0) return {};
  std::wstring wide_string(wide_char_length, L'\0');
  MultiByteToWideChar(code_page, 0, value, -1, wide_string.data(), wide_char_length);
  wide_string.resize(wide_char_length - 1);
  return wide_string;
}

inline std::wstring QuoteArg(const std::wstring& arg) {
  if (arg.empty()) return L"\"\"";
  if (arg.find_first_of(L" \t\"") == std::wstring::npos) return arg;
  std::wstring escaped = L"\"";
  for (const auto ch : arg) {
    if (ch == L'"') {
      escaped += L'\\';
    }
    escaped += ch;
  }
  escaped += L"\"";
  return escaped;
}

inline std::wstring JoinArgs(const std::vector<std::wstring>& args) {
  std::wstring output;
  for (size_t i = 0; i < args.size(); ++i) {
    if (i != 0) output += L" ";
    output += QuoteArg(args[i]);
  }
  return output;
}

struct ProcessResult {
  DWORD exit_code = 0;
  std::string output;
};

inline ProcessResult RunProcess(const std::wstring& command_line, const std::filesystem::path& working_dir) {
  SECURITY_ATTRIBUTES security_attributes{};
  security_attributes.nLength = sizeof(SECURITY_ATTRIBUTES);
  security_attributes.bInheritHandle = TRUE;

  HANDLE read_pipe = nullptr;
  HANDLE write_pipe = nullptr;
  if (!CreatePipe(&read_pipe, &write_pipe, &security_attributes, 0)) {
    throw std::exception("Failed to create slangc pipe.");
  }
  if (!SetHandleInformation(read_pipe, HANDLE_FLAG_INHERIT, 0)) {
    CloseHandle(read_pipe);
    CloseHandle(write_pipe);
    throw std::exception("Failed to configure slangc pipe.");
  }

  STARTUPINFOW startup_info{};
  startup_info.cb = sizeof(STARTUPINFOW);
  startup_info.dwFlags = STARTF_USESTDHANDLES;
  startup_info.hStdOutput = write_pipe;
  startup_info.hStdError = write_pipe;

  PROCESS_INFORMATION process_info{};
  std::wstring command_line_mutable = command_line;

  BOOL created = CreateProcessW(
      nullptr,
      command_line_mutable.data(),
      nullptr,
      nullptr,
      TRUE,
      CREATE_NO_WINDOW,
      nullptr,
      working_dir.empty() ? nullptr : working_dir.wstring().c_str(),
      &startup_info,
      &process_info);

  CloseHandle(write_pipe);

  if (!created) {
    CloseHandle(read_pipe);
    throw std::exception("Failed to launch slangc.");
  }

  std::string output;
  std::array<char, 4096> buffer{};
  DWORD bytes_read = 0;
  while (ReadFile(read_pipe, buffer.data(), static_cast<DWORD>(buffer.size()), &bytes_read, nullptr) && bytes_read > 0) {
    output.append(buffer.data(), bytes_read);
  }

  WaitForSingleObject(process_info.hProcess, INFINITE);
  DWORD exit_code = 0;
  GetExitCodeProcess(process_info.hProcess, &exit_code);

  CloseHandle(read_pipe);
  CloseHandle(process_info.hProcess);
  CloseHandle(process_info.hThread);

  return ProcessResult{.exit_code = exit_code, .output = output};
}

inline std::filesystem::path FindSlangcPath() {
  {
    std::shared_lock lock(mutex_slangc_path);
    if (!cached_slangc_path.empty()) return cached_slangc_path;
  }

  std::unique_lock lock(mutex_slangc_path);
  if (!cached_slangc_path.empty()) return cached_slangc_path;

#ifdef RENODX_SLANGC_BIN_PATH
  if (!std::string(RENODX_SLANGC_BIN_PATH).empty()) {
    auto cmake_path = std::filesystem::path(RENODX_SLANGC_BIN_PATH);
    if (std::filesystem::exists(cmake_path)) {
      cached_slangc_path = cmake_path;
      return cached_slangc_path;
    }
  }
#endif

  auto try_candidate = [&](const std::filesystem::path& candidate) {
    if (!candidate.empty() && std::filesystem::exists(candidate)) {
      cached_slangc_path = candidate;
      return true;
    }
    return false;
  };

  auto try_env = [&](const wchar_t* name) {
    wchar_t* env_path = nullptr;
    size_t env_len = 0;
    if (_wdupenv_s(&env_path, &env_len, name) != 0 || env_path == nullptr) {
      return false;
    }
    std::filesystem::path candidate = env_path;
    free(env_path);
    return try_candidate(candidate);
  };

  if (try_env(L"SLANGC_BIN")) return cached_slangc_path;
  if (try_env(L"SLANGC")) return cached_slangc_path;

  try {
    if (try_candidate(std::filesystem::current_path() / "slangc.exe")) return cached_slangc_path;
  } catch (...) {
  }

  std::array<wchar_t, MAX_PATH> module_path{};
  GetModuleFileNameW(nullptr, module_path.data(), static_cast<DWORD>(module_path.size()));
  std::filesystem::path search_root = std::filesystem::path(module_path.data()).parent_path();
  for (int i = 0; i < 4; ++i) {
    if (try_candidate(search_root / "slangc.exe")) return cached_slangc_path;
    if (try_candidate(search_root / "bin" / "slangc.exe")) return cached_slangc_path;
    if (!search_root.has_parent_path()) break;
    search_root = search_root.parent_path();
  }

  throw std::exception("Could not locate slangc.exe. Set SLANGC_BIN or place it next to the addon or in a bin folder.");
}

inline std::filesystem::path GetTempOutputPath(const std::wstring& extension) {
  auto output_dir = renodx::utils::path::GetOutputPath();
  if (!std::filesystem::exists(output_dir)) {
    std::filesystem::create_directory(output_dir);
  }
  output_dir /= "slang";
  if (!std::filesystem::exists(output_dir)) {
    std::filesystem::create_directory(output_dir);
  }

  const uint32_t counter = compile_counter.fetch_add(1);
  std::array<wchar_t, 64> filename{};
  swprintf_s(filename.data(), filename.size(), L"slang_%08X", counter);
  output_dir /= filename.data();
  output_dir += extension;
  return output_dir;
}

inline std::string ToLower(std::string input) {
  std::transform(input.begin(), input.end(), input.begin(), [](unsigned char ch) {
    return static_cast<char>(std::tolower(ch));
  });
  return input;
}

inline void AppendFlagsFromString(const std::string& flags, std::vector<std::wstring>& args) {
  std::istringstream stream(flags);
  std::string token;
  while (stream >> token) {
    args.emplace_back(ToWide(token.c_str()));
  }
}

inline void AppendDefaultFlags(std::vector<std::wstring>& args) {
#ifdef RENODX_SLANGC_FLAGS
  AppendFlagsFromString(RENODX_SLANGC_FLAGS, args);
#else
  args.emplace_back(L"-O3");
  args.emplace_back(L"-g0");
  args.emplace_back(L"-entry");
  args.emplace_back(L"main");
  args.emplace_back(L"-Wno-30056");
  args.emplace_back(L"-Wno-15205");
#endif
}

inline std::optional<std::filesystem::path> FindSpirvDisPath() {
  if (cached_spirv_dis.has_value()) return cached_spirv_dis;

  auto try_candidate = [&](const std::filesystem::path& candidate) {
    if (!candidate.empty() && std::filesystem::exists(candidate)) {
      cached_spirv_dis = candidate;
      return true;
    }
    return false;
  };

  auto try_env = [&](const wchar_t* name) {
    wchar_t* env_path = nullptr;
    size_t env_len = 0;
    if (_wdupenv_s(&env_path, &env_len, name) != 0 || env_path == nullptr) {
      return false;
    }
    std::filesystem::path candidate = env_path;
    free(env_path);
    return try_candidate(candidate);
  };

  if (try_env(L"SPIRV_DIS")) return cached_spirv_dis;

  wchar_t* vulkan_sdk = nullptr;
  size_t vulkan_sdk_len = 0;
  if (_wdupenv_s(&vulkan_sdk, &vulkan_sdk_len, L"VULKAN_SDK") == 0 && vulkan_sdk != nullptr) {
    std::filesystem::path sdk_path = vulkan_sdk;
    free(vulkan_sdk);
    if (try_candidate(sdk_path / "Bin" / "spirv-dis.exe")) return cached_spirv_dis;
  }

  try {
    if (try_candidate(std::filesystem::current_path() / "spirv-dis.exe")) return cached_spirv_dis;
  } catch (...) {
  }

  std::array<wchar_t, MAX_PATH> module_path{};
  GetModuleFileNameW(nullptr, module_path.data(), static_cast<DWORD>(module_path.size()));
  std::filesystem::path search_root = std::filesystem::path(module_path.data()).parent_path();
  for (int i = 0; i < 4; ++i) {
    if (try_candidate(search_root / "spirv-dis.exe")) return cached_spirv_dis;
    if (try_candidate(search_root / "bin" / "spirv-dis.exe")) return cached_spirv_dis;
    if (!search_root.has_parent_path()) break;
    search_root = search_root.parent_path();
  }

  return std::nullopt;
}

inline std::optional<std::filesystem::path> FindSpirvCrossPath() {
  if (cached_spirv_cross.has_value()) return cached_spirv_cross;

  auto try_candidate = [&](const std::filesystem::path& candidate) {
    if (!candidate.empty() && std::filesystem::exists(candidate)) {
      cached_spirv_cross = candidate;
      return true;
    }
    return false;
  };

#ifdef RENODX_SPIRV_CROSS_BIN_PATH
  if (!std::string(RENODX_SPIRV_CROSS_BIN_PATH).empty()) {
    auto cmake_path = std::filesystem::path(RENODX_SPIRV_CROSS_BIN_PATH);
    if (std::filesystem::exists(cmake_path)) {
      cached_spirv_cross = cmake_path;
      return cached_spirv_cross;
    }
  }
#endif

  wchar_t* vulkan_sdk = nullptr;
  size_t vulkan_sdk_len = 0;
  if (_wdupenv_s(&vulkan_sdk, &vulkan_sdk_len, L"VULKAN_SDK") == 0 && vulkan_sdk != nullptr) {
    std::filesystem::path sdk_path = vulkan_sdk;
    free(vulkan_sdk);
    if (try_candidate(sdk_path / "Bin" / "spirv-cross.exe")) return cached_spirv_cross;
  }

  try {
    if (try_candidate(std::filesystem::current_path() / "spirv-cross.exe")) return cached_spirv_cross;
  } catch (...) {
  }

  std::array<wchar_t, MAX_PATH> module_path{};
  GetModuleFileNameW(nullptr, module_path.data(), static_cast<DWORD>(module_path.size()));
  std::filesystem::path search_root = std::filesystem::path(module_path.data()).parent_path();
  for (int i = 0; i < 4; ++i) {
    if (try_candidate(search_root / "spirv-cross.exe")) return cached_spirv_cross;
    if (try_candidate(search_root / "bin" / "spirv-cross.exe")) return cached_spirv_cross;
    if (!search_root.has_parent_path()) break;
    search_root = search_root.parent_path();
  }

  return std::nullopt;
}

}  // namespace internal

inline void AppendSpirvCrossFlags(std::vector<std::wstring>& args) {
#ifdef RENODX_SPIRV_CROSS_FLAGS
  internal::AppendFlagsFromString(RENODX_SPIRV_CROSS_FLAGS, args);
#else
  args.emplace_back(L"--version");
  args.emplace_back(L"450");
  args.emplace_back(L"--vulkan-semantics");
  args.emplace_back(L"--no-es");
#endif
}

inline std::string DisassembleSpirv(std::span<const uint8_t> data, uint32_t shader_hash) {
  auto spirv_dis = internal::FindSpirvDisPath();
  if (!spirv_dis.has_value()) {
    throw std::exception("spirv-dis.exe not found.");
  }

  auto output_dir = renodx::utils::path::GetOutputPath();
  output_dir /= "spirv";
  std::filesystem::create_directories(output_dir);

  std::array<wchar_t, 11> hash_string{};
  swprintf_s(hash_string.data(), hash_string.size(), L"0x%08X", shader_hash);

  auto spv_path = output_dir / hash_string.data();
  spv_path += L".spv";
  auto spvasm_path = output_dir / hash_string.data();
  spvasm_path += L".spvasm";

  std::vector<uint8_t> data_copy(data.begin(), data.end());
  renodx::utils::path::WriteBinaryFile(spv_path, data_copy);

  std::wstring command_line = L"\"";
  command_line += spirv_dis->wstring();
  command_line += L"\" \"";
  command_line += spv_path.wstring();
  command_line += L"\" -o \"";
  command_line += spvasm_path.wstring();
  command_line += L"\"";

  auto result = internal::RunProcess(command_line, output_dir);
  if (result.exit_code != 0) {
    std::filesystem::remove(spv_path);
    std::filesystem::remove(spvasm_path);
    if (result.output.empty()) {
      throw std::exception("spirv-dis failed.");
    }
    throw std::exception(result.output.c_str());
  }

  std::string disassembly = renodx::utils::path::ReadTextFile(spvasm_path);
  std::filesystem::remove(spv_path);
  std::filesystem::remove(spvasm_path);
  if (disassembly.empty()) {
    throw std::exception("spirv-dis output is empty.");
  }
  return disassembly;
}

inline std::string DecompileSpirvToGlsl(std::span<const uint8_t> data, uint32_t shader_hash) {
  auto spirv_cross = internal::FindSpirvCrossPath();
  if (!spirv_cross.has_value()) {
    throw std::exception("spirv-cross.exe not found.");
  }

  auto output_dir = renodx::utils::path::GetOutputPath();
  output_dir /= "spirv_cross";
  std::filesystem::create_directories(output_dir);

  std::array<wchar_t, 11> hash_string{};
  swprintf_s(hash_string.data(), hash_string.size(), L"0x%08X", shader_hash);

  auto spv_path = output_dir / hash_string.data();
  spv_path += L".spv";

  std::vector<uint8_t> data_copy(data.begin(), data.end());
  renodx::utils::path::WriteBinaryFile(spv_path, data_copy);

  std::vector<std::wstring> args;
  args.emplace_back(spv_path.wstring());
  AppendSpirvCrossFlags(args);

  const std::wstring command_line = internal::QuoteArg(spirv_cross->wstring()) + L" " + internal::JoinArgs(args);
  auto result = internal::RunProcess(command_line, output_dir);
  std::filesystem::remove(spv_path);

  if (result.exit_code != 0) {
    if (result.output.empty()) {
      throw std::exception("spirv-cross failed.");
    }
    throw std::exception(result.output.c_str());
  }

  if (result.output.empty()) {
    throw std::exception("spirv-cross output is empty.");
  }

  return result.output;
}

inline std::vector<uint8_t> CompileShaderFromFile(
    LPCWSTR file_path,
    LPCSTR shader_target,
    const std::vector<std::pair<std::string, std::string>>& defines = {}) {
  if (file_path == nullptr || shader_target == nullptr) {
    throw std::exception("Missing slang compile arguments.");
  }

  const std::filesystem::path source_path = file_path;
  if (!std::filesystem::exists(source_path)) {
    throw std::exception("Slang source file not found.");
  }

  const std::string target = internal::ToLower(shader_target);
  bool is_stage_target = false;
  std::wstring stage;

  if (target == "frag") {
    is_stage_target = true;
    stage = L"fragment";
  } else if (target == "vert") {
    is_stage_target = true;
    stage = L"vertex";
  } else if (target == "comp") {
    is_stage_target = true;
    stage = L"compute";
  }

  std::wstring output_extension = is_stage_target ? L".spv" : L".cso";
  auto output_path = internal::GetTempOutputPath(output_extension);

  std::vector<std::wstring> args;
  args.emplace_back(source_path.wstring());
  internal::AppendDefaultFlags(args);
  args.emplace_back(L"-I");
  args.emplace_back(source_path.parent_path().wstring());

  if (is_stage_target) {
    args.emplace_back(L"-stage");
    args.emplace_back(stage);
    args.emplace_back(L"-target");
    args.emplace_back(L"spirv");
  } else {
    if (strlen(shader_target) < 5 || shader_target[2] != '_' || shader_target[4] != '_') {
      throw std::exception("Invalid slang target profile.");
    }
    args.emplace_back(L"-profile");
    args.emplace_back(std::wstring(shader_target, shader_target + strlen(shader_target)));

    char major = shader_target[3];
    if (major >= '6') {
      args.emplace_back(L"-target");
      args.emplace_back(L"dxil");
    } else {
      args.emplace_back(L"-target");
      args.emplace_back(L"dxbc");
    }
  }

  for (const auto& [key, value] : defines) {
    if (key.empty()) continue;
    std::wstring definition = L"-D";
    definition.append(std::wstring(key.begin(), key.end()));
    if (!value.empty()) {
      definition.push_back(L'=');
      definition.append(std::wstring(value.begin(), value.end()));
    }
    args.emplace_back(definition);
  }

  args.emplace_back(L"-o");
  args.emplace_back(output_path.wstring());

  const auto slangc_path = internal::FindSlangcPath();
  const std::wstring command_line = internal::QuoteArg(slangc_path.wstring()) + L" " + internal::JoinArgs(args);
  const auto result = internal::RunProcess(command_line, source_path.parent_path());

  if (result.exit_code != 0) {
    if (result.output.empty()) {
      throw std::exception("slangc failed.");
    }
    throw std::exception(result.output.c_str());
  }

  auto output_data = renodx::utils::path::ReadBinaryFile(output_path);
  if (output_data.empty()) {
    throw std::exception("slangc did not produce output.");
  }
  std::filesystem::remove(output_path);
  return output_data;
}

}  // namespace renodx::utils::shader::compiler::slang
