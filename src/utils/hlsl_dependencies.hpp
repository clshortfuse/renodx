/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <filesystem>
#include <fstream>
#include <regex>
#include <set>
#include <string>
#include <system_error>
#include <vector>

namespace renodx::utils::shader::dependencies {

namespace fs = std::filesystem;

struct DependencyPath {
  fs::path path;
  bool exists = false;
};

inline fs::path NormalizePath(const fs::path& path) {
  std::error_code error_code;
  auto normalized_path = fs::weakly_canonical(path, error_code);
  if (!error_code) {
    return normalized_path;
  }

  error_code.clear();
  normalized_path = fs::absolute(path, error_code);
  if (!error_code) {
    return normalized_path.lexically_normal();
  }

  return path.lexically_normal();
}

inline bool ShouldTrackIncludeDependency(const fs::path& include_path, bool exists) {
  if (include_path.extension() == ".hpp") return false;
  if (!exists && !include_path.has_extension()) return false;
  return true;
}

inline std::set<fs::path> ParseIncludes(const fs::path& hlsl_file) {
  std::set<fs::path> includes;
  std::ifstream file(hlsl_file);
  if (!file.is_open()) {
    return includes;
  }

  // Only quoted includes are local shader file dependencies. Angle includes are
  // compiler/system include lookups (for example C++ headers in shared files)
  // and should not be resolved relative to the current HLSL file.
  static const std::regex INCLUDE_REGEX(R"(^\s*#\s*include\s+"([^"]+)["])");
  std::string line;
  const auto base_dir = NormalizePath(hlsl_file).parent_path();

  while (std::getline(file, line)) {
    std::smatch match;
    if (!std::regex_search(line, match, INCLUDE_REGEX)) {
      continue;
    }

    includes.insert(NormalizePath(base_dir / match[1].str()));
  }

  return includes;
}

inline void CollectIncludedDependencies(
    const fs::path& hlsl_file,
    std::vector<DependencyPath>& dependencies) {
  std::set<fs::path> visited;
  std::vector<fs::path> pending = {NormalizePath(hlsl_file)};

  while (!pending.empty()) {
    const auto normalized = NormalizePath(pending.back());
    pending.pop_back();
    if (!visited.emplace(normalized).second) {
      continue;
    }

    for (const auto& include_path : ParseIncludes(normalized)) {
      std::error_code error_code;
      const bool exists = fs::exists(include_path, error_code);
      const bool valid_dependency = exists && !error_code;
      if (!ShouldTrackIncludeDependency(include_path, valid_dependency)) {
        continue;
      }

      dependencies.push_back(DependencyPath{
          .path = include_path,
          .exists = valid_dependency,
      });
      if (valid_dependency) {
        pending.push_back(include_path);
      }
    }
  }
}

inline std::vector<DependencyPath> CollectDependencies(const fs::path& hlsl_file) {
  const auto normalized = NormalizePath(hlsl_file);
  std::error_code error_code;
  std::vector<DependencyPath> dependencies = {
      DependencyPath{
          .path = normalized,
          .exists = fs::exists(normalized, error_code) && !error_code,
      },
  };

  CollectIncludedDependencies(normalized, dependencies);

  std::set<fs::path> seen;
  std::vector<DependencyPath> unique_dependencies;
  unique_dependencies.reserve(dependencies.size());
  for (const auto& dependency : dependencies) {
    if (seen.emplace(dependency.path).second) {
      unique_dependencies.push_back(dependency);
    }
  }

  return unique_dependencies;
}

}  // namespace renodx::utils::shader::dependencies
