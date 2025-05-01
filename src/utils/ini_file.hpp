#pragma once

#include <sstream>
#include <string>
#include <vector>

#include <tuple>

#include "./path.hpp"

namespace renodx::utils::ini_file {

static std::vector<std::tuple<std::string, std::string, std::string>> ParseIniContents(const std::string& ini_content) {
  std::vector<std::tuple<std::string, std::string, std::string>> result;
  std::istringstream stream(ini_content);
  std::string line;
  std::string current_section;

  while (std::getline(stream, line)) {
    // Trim whitespace
    line.erase(0, line.find_first_not_of(" \t\r\n"));
    line.erase(line.find_last_not_of(" \t\r\n") + 1);

    if (line.empty() || line[0] == ';' || line[0] == '#') {
      continue;
    }

    if (line.front() == '[' && line.back() == ']') {
      current_section = line.substr(1, line.size() - 2);
      continue;
    }

    auto eq_pos = line.find('=');
    if (eq_pos != std::string::npos) {
      std::string key = line.substr(0, eq_pos);
      std::string value = line.substr(eq_pos + 1);

      auto comment_pos = value.find_first_of(";#");
      if (comment_pos != std::string::npos) {
        value = value.substr(0, comment_pos);
      }

      // Trim key and value
      key.erase(0, key.find_first_not_of(" \t\r\n"));
      key.erase(key.find_last_not_of(" \t\r\n") + 1);
      value.erase(0, value.find_first_not_of(" \t\r\n"));
      value.erase(value.find_last_not_of(" \t\r\n") + 1);

      result.emplace_back(current_section, key, value);
    }
  }
  return result;
}

static std::string GenerateIni(const std::vector<std::tuple<std::string, std::string, std::string>>& ini_data) {
  std::ostringstream out;
  std::string current_section;

  for (const auto& entry : ini_data) {
    const auto& section = std::get<0>(entry);
    const auto& key = std::get<1>(entry);
    const auto& value = std::get<2>(entry);

    if (section != current_section) {
      if (!current_section.empty()) {
        out << "\n";
      }
      if (!section.empty()) {
        out << "[" << section << "]\n";
      }
      current_section = section;
    }

    out << key << "=" << value << "\n";
  }

  return out.str();
}

static std::tuple<std::string, std::string, std::string>* FindLastEntry(
    std::vector<std::tuple<std::string, std::string, std::string>>& ini_data,
    const std::string& section_filter,
    const std::string& key_filter) {
  std::tuple<std::string, std::string, std::string>* result = nullptr;

  for (auto& entry : ini_data) {
    const auto& section = std::get<0>(entry);
    const auto& key = std::get<1>(entry);

    if ((section_filter.empty() || section == section_filter) && (key_filter.empty() || key == key_filter)) {
      result = &entry;
    }
  }

  return result;
}

static void InsertEntry(
    std::vector<std::tuple<std::string, std::string, std::string>>& ini_data,
    const std::string& section,
    const std::string& key,
    const std::string& value) {
  auto it = ini_data.begin();
  auto last_section_it = ini_data.end();

  while (it != ini_data.end()) {
    const auto& current_section = std::get<0>(*it);

    if (current_section == section) {
      last_section_it = it;
    } else if (!current_section.empty() && last_section_it != ini_data.end()) {
      // Found a new section after the target section
      break;
    }

    ++it;
  }

  // Insert the new entry after the last entry of the section or at the end
  ini_data.insert(last_section_it == ini_data.end() ? ini_data.end() : std::next(last_section_it),
                  std::make_tuple(section, key, value));
}

static bool UpdateIniFile(
    const std::filesystem::path& file_path,
    const std::vector<std::tuple<std::string, std::string, std::string>>& ini_data,
    bool force_create_file = false,
    bool force_create_entry = false) {
  std::string existing_content;

  bool file_exists = std::filesystem::exists(file_path);
  if (file_exists) {
    existing_content = renodx::utils::path::ReadTextFile(file_path);
  } else if (!force_create_file) {
    return false;  // File does not exist and force_create_file is false
  }

  auto existing_data = ParseIniContents(existing_content);

  bool updated = false;
  for (const auto& entry : ini_data) {
    const auto& section = std::get<0>(entry);
    const auto& key = std::get<1>(entry);
    const auto& value = std::get<2>(entry);

    auto* existing_entry = FindLastEntry(existing_data, section, key);
    if (existing_entry != nullptr) {
      if (std::get<2>(*existing_entry) != value) {
        std::get<2>(*existing_entry) = value;
        updated = true;
      }
    } else if (force_create_entry) {
      InsertEntry(existing_data, section, key, value);
      updated = true;
    }
  }

  if (!updated && file_exists) {
    return true;  // File exists and no updates were made
  }

  std::ofstream output_file(file_path, std::ios::trunc);
  if (!output_file) {
    return false;  // Failed to open file for writing
  }

  output_file << GenerateIni(existing_data);
  output_file.close();

  return true;  // Successfully updated the INI file
}

}  // namespace renodx::utils::ini_file
