#pragma once

#include <algorithm>
#include <bit>
#include <cctype>
#include <filesystem>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <system_error>
#include <vector>

#include "../../utils/path.hpp"

namespace ryujinxlog {

struct LatestLogLineMatchConfig {
  std::filesystem::path logs_path;
  std::string_view line_marker;
  std::span<const std::string_view> accepted_terms;
};

struct ProcessWindowTitleMatchConfig {
  DWORD process_id = GetCurrentProcessId();
  std::span<const std::string_view> accepted_terms;
  bool require_visible = true;
};

inline std::string ToLowerAscii(std::string value) {
  std::transform(value.begin(), value.end(), value.begin(), [](unsigned char character) {
    return static_cast<char>(std::tolower(character));
  });
  return value;
}

inline std::optional<std::filesystem::path> FindLatestLogPath(const std::filesystem::path& logs_path) {
  if (!std::filesystem::exists(logs_path) || !std::filesystem::is_directory(logs_path)) return std::nullopt;

  std::optional<std::filesystem::path> latest_log_path;
  std::filesystem::file_time_type latest_write_time;

  for (const auto& entry : std::filesystem::directory_iterator(logs_path)) {
    if (!entry.is_regular_file()) continue;
    if (entry.path().extension() != ".log") continue;

    std::error_code last_write_time_error;
    const auto last_write_time = entry.last_write_time(last_write_time_error);
    if (last_write_time_error) continue;

    if (!latest_log_path.has_value() ||
        last_write_time > latest_write_time ||
        (last_write_time == latest_write_time && entry.path().filename().string() > latest_log_path->filename().string())) {
      latest_log_path = entry.path();
      latest_write_time = last_write_time;
    }
  }

  return latest_log_path;
}

inline bool DoesLatestLogLastMatchingLineContainAny(const LatestLogLineMatchConfig& config) {
  const auto latest_log_path = FindLatestLogPath(config.logs_path);
  if (!latest_log_path.has_value()) return true;

  const auto log_contents = renodx::utils::path::ReadTextFile(*latest_log_path);
  if (log_contents.empty()) return false;

  const auto normalized_marker = ToLowerAscii(std::string(config.line_marker));

  size_t search_offset = 0;
  std::optional<std::string> last_matching_line;
  while (search_offset < log_contents.size()) {
    const auto line_end = log_contents.find_first_of("\r\n", search_offset);
    const auto line_length = (line_end == std::string::npos ? log_contents.size() : line_end) - search_offset;
    auto normalized_line = ToLowerAscii(log_contents.substr(search_offset, line_length));
    if (normalized_line.find(normalized_marker) != std::string::npos) {
      last_matching_line = std::move(normalized_line);
    }

    if (line_end == std::string::npos) break;

    search_offset = line_end + 1;
    if (search_offset < log_contents.size() && log_contents[search_offset] == '\n' && log_contents[line_end] == '\r') {
      search_offset += 1;
    }
  }

  if (!last_matching_line.has_value()) return false;

  for (const auto accepted_term : config.accepted_terms) {
    if (accepted_term.empty()) continue;
    if (last_matching_line->find(ToLowerAscii(std::string(accepted_term))) != std::string::npos) {
      return true;
    }
  }

  return false;
}

struct ProcessWindowTitleSearchContext {
  DWORD process_id = 0;
  const std::vector<std::string>* accepted_terms = nullptr;
  bool require_visible = true;
  bool matched = false;
};

inline BOOL CALLBACK EnumerateProcessWindowsForTitleMatch(HWND hwnd, LPARAM lparam) {
  auto* context = std::bit_cast<ProcessWindowTitleSearchContext*>(lparam);
  if (context == nullptr || context->accepted_terms == nullptr) return TRUE;

  DWORD window_process_id = 0;
  GetWindowThreadProcessId(hwnd, &window_process_id);
  if (window_process_id != context->process_id) return TRUE;
  if (context->require_visible && IsWindowVisible(hwnd) == FALSE) return TRUE;

  const int title_length = GetWindowTextLengthA(hwnd);
  if (title_length <= 0) return TRUE;

  auto window_title = std::string(title_length + 1, '\0');
  const int copied_length = GetWindowTextA(hwnd, window_title.data(), static_cast<int>(window_title.size()));
  if (copied_length <= 0) return TRUE;

  window_title.resize(copied_length);
  const auto normalized_window_title = ToLowerAscii(window_title);

  for (const auto& accepted_term : *context->accepted_terms) {
    if (normalized_window_title.find(accepted_term) != std::string::npos) {
      context->matched = true;
      return FALSE;
    }
  }

  return TRUE;
}

inline bool DoesCurrentProcessWindowTitleContainAny(const ProcessWindowTitleMatchConfig& config) {
  if (config.accepted_terms.empty()) return false;

  auto normalized_terms = std::vector<std::string>{};
  normalized_terms.reserve(config.accepted_terms.size());
  for (const auto accepted_term : config.accepted_terms) {
    if (accepted_term.empty()) continue;
    normalized_terms.push_back(ToLowerAscii(std::string(accepted_term)));
  }
  if (normalized_terms.empty()) return false;

  auto context = ProcessWindowTitleSearchContext{
      .process_id = config.process_id,
      .accepted_terms = &normalized_terms,
      .require_visible = config.require_visible,
      .matched = false,
  };

  EnumWindows(EnumerateProcessWindowsForTitleMatch, std::bit_cast<LPARAM>(&context));
  return context.matched;
}

}  // namespace ryujinxlog
