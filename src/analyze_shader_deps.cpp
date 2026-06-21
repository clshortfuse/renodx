/*
 * Copyright (C) 2026 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#include <filesystem>
#include <fstream>
#include <iostream>
#include <regex>
#include <set>
#include <string>
#include <system_error>
#include <vector>

namespace fs = std::filesystem;

struct DependencyPath {
  fs::path path;
  bool exists = false;
};

fs::path NormalizePath(const fs::path& path) {
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

bool ShouldTrackIncludeDependency(const fs::path& include_path, bool exists) {
  if (include_path.extension() == ".hpp") return false;
  if (!exists && !include_path.has_extension()) return false;
  return true;
}

// Parse a single source file for #include directives.
// Returns normalized absolute paths to avoid duplicates like "foo.hlsl" vs "././foo.hlsl".
std::set<fs::path> ParseIncludes(const fs::path& source_file) {
  std::set<fs::path> includes;
  std::ifstream file(source_file);
  if (!file.is_open()) {
    std::cerr << "Warning: Could not open " << source_file << '\n';
    return includes;
  }

  // Only quoted includes are local shader file dependencies. Angle includes are
  // compiler/system include lookups (for example C++ headers in shared files)
  // and should not be resolved relative to the current source file.
  std::regex include_regex(R"(^\s*#\s*include\s+"([^"]+)["])");
  std::string line;
  auto base_dir = NormalizePath(source_file).parent_path();

  while (std::getline(file, line)) {
    std::smatch match;
    if (std::regex_search(line, match, include_regex)) {
      includes.insert(NormalizePath(base_dir / match[1].str()));
    }
  }

  return includes;
}

void CollectIncludedDependencies(
    const fs::path& source_file,
    std::vector<DependencyPath>& dependencies) {
  std::set<fs::path> visited;
  std::vector<fs::path> pending = {NormalizePath(source_file)};

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

std::vector<DependencyPath> CollectDependencies(const fs::path& source_file) {
  const auto normalized = NormalizePath(source_file);
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

// Write Ninja-style dependency file
void WriteDependencyFile(
    const fs::path& depfile_path,
    const fs::path& target_file,
    const std::vector<DependencyPath>& dependencies) {
  // Create parent directory if it doesn't exist
  auto parent_dir = depfile_path.parent_path();
  if (!parent_dir.empty() && !fs::exists(parent_dir)) {
    try {
      fs::create_directories(parent_dir);
    } catch (const std::exception& e) {
      std::cerr << "Error: Could not create directory " << parent_dir << ": " << e.what() << '\n';
      exit(1);
    }
  }

  std::ofstream depfile(depfile_path);
  if (!depfile.is_open()) {
    std::cerr << "Error: Could not write dependency file \"" << depfile_path << "\"" << '\n';
    exit(1);
  }

  // Format: target: dep1 dep2 dep3 ...
  // Use forward slashes and escape spaces
  auto escape_path = [](const fs::path& p) {
    std::string str = p.generic_string();
    // Escape spaces for Make/Ninja
    size_t pos = 0;
    while ((pos = str.find(' ', pos)) != std::string::npos) {
      str.replace(pos, 1, "\\ ");
      pos += 2;
    }
    return str;
  };

  depfile << escape_path(target_file) << ":";

  for (const auto& dep : dependencies) {
    depfile << " " << escape_path(dep.path);
  }

  depfile << '\n';
}

int main(int argc, char* argv[]) {
  if (argc != 4) {
    std::cerr << "Usage: " << argv[0] << " <input.source> <output.binary> <depfile.d>" << '\n';
    std::cerr << "  Analyzes source #include dependencies and writes a Ninja-style .d file" << '\n';
    return 1;
  }

  fs::path input_file = argv[1];
  fs::path output_file = argv[2];
  fs::path depfile_path = argv[3];

  if (!fs::exists(input_file)) {
    std::cerr << "Error: Input file does not exist: " << input_file << '\n';
    return 1;
  }

  const auto dependencies = CollectDependencies(input_file);

  // Write dependency file: depfile.d contains "output_file.cso: input deps..."
  WriteDependencyFile(depfile_path, output_file, dependencies);

  return 0;
}
