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
#include <chrono>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <exception>
#include <filesystem>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <span>
#include <string>
#include <thread>
#include <variant>
#include <vector>


#include "./path.hpp"

namespace renodx::utils::shader::compiler::vulkan {

namespace internal {

static std::shared_mutex mutex_slangc_path;
static std::filesystem::path cached_slangc_path;
static std::shared_mutex mutex_glslangvalidator_path;
static std::filesystem::path cached_glslangvalidator_path;
static std::shared_mutex mutex_spirv_dis_path;
static std::optional<std::filesystem::path> cached_spirv_dis;
static std::shared_mutex mutex_spirv_cross_path;
static std::optional<std::filesystem::path> cached_spirv_cross;
static std::atomic_uint32_t compile_counter = 0;

inline bool TryExecutableAdjacentPaths(const wchar_t* file_name, const auto& try_candidate) {
  std::array<wchar_t, MAX_PATH> module_path{};
  GetModuleFileNameW(nullptr, module_path.data(), static_cast<DWORD>(module_path.size()));
  return try_candidate(std::filesystem::path(module_path.data()).parent_path() / file_name);
}

inline bool TryVulkanSdkPath(const wchar_t* file_name, const auto& try_candidate) {
  wchar_t* vulkan_sdk = nullptr;
  size_t vulkan_sdk_len = 0;
  if (_wdupenv_s(&vulkan_sdk, &vulkan_sdk_len, L"VULKAN_SDK") != 0 || vulkan_sdk == nullptr) {
    return false;
  }

  std::filesystem::path sdk_path = vulkan_sdk;
  free(vulkan_sdk);
  return try_candidate(sdk_path / "Bin" / file_name);
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
  if (CreatePipe(&read_pipe, &write_pipe, &security_attributes, 0) == FALSE) {
    throw std::exception("Failed to create compiler pipe.");
  }
  if (SetHandleInformation(read_pipe, HANDLE_FLAG_INHERIT, 0) == FALSE) {
    CloseHandle(read_pipe);
    CloseHandle(write_pipe);
    throw std::exception("Failed to configure compiler pipe.");
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

  if (created == FALSE) {
    CloseHandle(read_pipe);
    throw std::exception("Failed to launch compiler.");
  }

  std::string output;
  std::array<char, 4096> buffer{};
  DWORD bytes_read = 0;
  while (ReadFile(read_pipe, buffer.data(), static_cast<DWORD>(buffer.size()), &bytes_read, nullptr) != FALSE && bytes_read > 0) {
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

  auto try_candidate = [&](const std::filesystem::path& candidate) {
    if (!candidate.empty() && std::filesystem::exists(candidate)) {
      cached_slangc_path = candidate;
      return true;
    }
    return false;
  };

  if (TryExecutableAdjacentPaths(L"slangc.exe", try_candidate)) return cached_slangc_path;
  if (TryVulkanSdkPath(L"slangc.exe", try_candidate)) return cached_slangc_path;

  throw std::exception("Could not locate slangc.exe. Place it next to the executable or install the Vulkan SDK.");
}

inline std::filesystem::path FindGlslangValidatorPath() {
  {
    std::shared_lock lock(mutex_glslangvalidator_path);
    if (!cached_glslangvalidator_path.empty()) return cached_glslangvalidator_path;
  }

  std::unique_lock lock(mutex_glslangvalidator_path);
  if (!cached_glslangvalidator_path.empty()) return cached_glslangvalidator_path;

  auto try_candidate = [&](const std::filesystem::path& candidate) {
    if (!candidate.empty() && std::filesystem::exists(candidate)) {
      cached_glslangvalidator_path = candidate;
      return true;
    }
    return false;
  };

  if (TryExecutableAdjacentPaths(L"glslangValidator.exe", try_candidate)) return cached_glslangvalidator_path;
  if (TryVulkanSdkPath(L"glslangValidator.exe", try_candidate)) return cached_glslangvalidator_path;

  throw std::exception(
      "Could not locate glslangValidator.exe. Place it next to the executable or install the Vulkan SDK.");
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

inline void AppendDefaultFlags(std::vector<std::wstring>& args) {
  args.emplace_back(L"-O0");
}

inline void AppendGlslangValidatorDefaultFlags(std::vector<std::wstring>& args) {
  args.emplace_back(L"-V");
  args.emplace_back(L"--target-env");
  args.emplace_back(L"vulkan1.3");
}

inline std::optional<std::filesystem::path> FindSpirvDisPath() {
  {
    std::shared_lock lock(mutex_spirv_dis_path);
    if (cached_spirv_dis.has_value()) return cached_spirv_dis;
  }

  std::unique_lock lock(mutex_spirv_dis_path);
  if (cached_spirv_dis.has_value()) return cached_spirv_dis;

  auto try_candidate = [&](const std::filesystem::path& candidate) {
    if (!candidate.empty() && std::filesystem::exists(candidate)) {
      cached_spirv_dis = candidate;
      return true;
    }
    return false;
  };

  if (TryExecutableAdjacentPaths(L"spirv-dis.exe", try_candidate)) return cached_spirv_dis;
  if (TryVulkanSdkPath(L"spirv-dis.exe", try_candidate)) return cached_spirv_dis;

  return std::nullopt;
}

inline std::optional<std::filesystem::path> FindSpirvCrossPath() {
  {
    std::shared_lock lock(mutex_spirv_cross_path);
    if (cached_spirv_cross.has_value()) return cached_spirv_cross;
  }

  std::unique_lock lock(mutex_spirv_cross_path);
  if (cached_spirv_cross.has_value()) return cached_spirv_cross;

  auto try_candidate = [&](const std::filesystem::path& candidate) {
    if (!candidate.empty() && std::filesystem::exists(candidate)) {
      cached_spirv_cross = candidate;
      return true;
    }
    return false;
  };

  if (TryExecutableAdjacentPaths(L"spirv-cross.exe", try_candidate)) return cached_spirv_cross;
  if (TryVulkanSdkPath(L"spirv-cross.exe", try_candidate)) return cached_spirv_cross;

  return std::nullopt;
}

}  // namespace internal

inline void AppendSpirvCrossFlags(std::vector<std::wstring>& args) {
  args.emplace_back(L"--version");
  args.emplace_back(L"450");
  args.emplace_back(L"--vulkan-semantics");
  args.emplace_back(L"--no-es");
}

inline std::string DisassembleSpirv(std::span<const uint8_t> data) {
  auto spirv_dis = internal::FindSpirvDisPath();
  if (!spirv_dis.has_value()) {
    throw std::exception("spirv-dis.exe not found.");
  }

  auto spv_path = internal::GetTempOutputPath(L".spv");
  auto spvasm_path = internal::GetTempOutputPath(L".spvasm");
  auto output_dir = spv_path.parent_path();

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

inline std::string DecompileSpirvToGlsl(std::span<const uint8_t> data) {
  auto spirv_cross = internal::FindSpirvCrossPath();
  if (!spirv_cross.has_value()) {
    throw std::exception("spirv-cross.exe not found.");
  }

  auto spv_path = internal::GetTempOutputPath(L".spv");
  auto output_dir = spv_path.parent_path();

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

  if (!is_stage_target) {
    throw std::exception("Only Slang stage targets are supported (frag/vert/comp).");
  }

  std::wstring output_extension = L".spv";
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

struct ShaderCompileRequest {
  std::filesystem::path file_path;
  std::string shader_target;
  uint32_t shader_hash = 0;
};

struct ShaderCompileResult {
  uint32_t shader_hash = 0;
  std::filesystem::path file_path;
  std::variant<std::exception, std::vector<uint8_t>> compilation;
  bool processed = false;
  bool failed = false;
};

inline std::vector<ShaderCompileResult> CompileShadersFromFiles(
    const std::vector<ShaderCompileRequest>& requests,
    const std::vector<std::pair<std::string, std::string>>& defines = {}) {
  std::vector<ShaderCompileResult> results(requests.size());
  if (requests.empty()) return results;

  constexpr int compile_retry_count = 3;
  constexpr int compile_retry_delay_ms = 25;

  auto process_index = [&](size_t index) {
    const auto& request = requests[index];
    ShaderCompileResult result = {
        .shader_hash = request.shader_hash,
        .file_path = request.file_path,
    };

    for (int attempt = 0; attempt < compile_retry_count; ++attempt) {
      try {
        result.compilation = CompileShaderFromFile(
            request.file_path.c_str(),
            request.shader_target.c_str(),
            defines);
        result.processed = true;
        result.failed = false;
        results[index] = std::move(result);
        return;
      } catch (std::exception& e) {
        result.compilation = e;
        if (attempt + 1 < compile_retry_count) {
          std::this_thread::sleep_for(std::chrono::milliseconds(compile_retry_delay_ms));
          continue;
        }
        result.failed = true;
      }
    }

    results[index] = std::move(result);
  };

  const size_t max_threads = (std::max)(static_cast<size_t>(1),
                                        static_cast<size_t>((std::max)(1u, std::thread::hardware_concurrency() / 2)));
  const size_t thread_count = (std::min)(max_threads, requests.size());

  if (thread_count > 1) {
    std::atomic_size_t next_index = 0;
    auto worker = [&]() {
      while (true) {
        const size_t index = next_index.fetch_add(1);
        if (index >= requests.size()) return;
        process_index(index);
      }
    };

    std::vector<std::thread> threads;
    threads.reserve(thread_count);
    for (size_t i = 0; i < thread_count; ++i) {
      threads.emplace_back(worker);
    }
    for (auto& thread : threads) {
      thread.join();
    }
  } else {
    for (size_t i = 0; i < requests.size(); ++i) {
      process_index(i);
    }
  }

  return results;
}

inline std::vector<uint8_t> CompileGlslFromFile(
    LPCWSTR file_path,
    LPCSTR shader_target,
    const std::vector<std::pair<std::string, std::string>>& defines = {}) {
  if (file_path == nullptr || shader_target == nullptr) {
    throw std::exception("Missing GLSL compile arguments.");
  }

  const std::filesystem::path source_path = file_path;
  if (!std::filesystem::exists(source_path)) {
    throw std::exception("GLSL source file not found.");
  }

  const std::string target = internal::ToLower(shader_target);
  std::wstring stage;
  if (target == "frag") {
    stage = L"frag";
  } else if (target == "vert") {
    stage = L"vert";
  } else if (target == "comp") {
    stage = L"comp";
  } else {
    throw std::exception("Invalid GLSL stage target.");
  }

  auto output_path = internal::GetTempOutputPath(L".spv");

  std::vector<std::wstring> args;
  internal::AppendGlslangValidatorDefaultFlags(args);
  args.emplace_back(L"-S");
  args.emplace_back(stage);

  std::wstring include_dir_flag = L"-I";
  include_dir_flag.append(source_path.parent_path().wstring());
  args.emplace_back(include_dir_flag);

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
  args.emplace_back(source_path.wstring());

  const auto glslangvalidator_path = internal::FindGlslangValidatorPath();
  const std::wstring command_line = internal::QuoteArg(glslangvalidator_path.wstring()) + L" " + internal::JoinArgs(args);
  const auto result = internal::RunProcess(command_line, source_path.parent_path());

  if (result.exit_code != 0) {
    if (result.output.empty()) {
      throw std::exception("glslangValidator failed.");
    }
    throw std::exception(result.output.c_str());
  }

  auto output_data = renodx::utils::path::ReadBinaryFile(output_path);
  if (output_data.empty()) {
    throw std::exception("glslangValidator did not produce output.");
  }
  std::filesystem::remove(output_path);
  return output_data;
}

}  // namespace renodx::utils::shader::compiler::vulkan
