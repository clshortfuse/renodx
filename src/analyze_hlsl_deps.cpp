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
#include <vector>

namespace fs = std::filesystem;

// Parse a single HLSL file for #include directives
// Returns normalized absolute paths to avoid duplicates like "foo.hlsl" vs "././foo.hlsl"
std::set<fs::path> ParseIncludes(const fs::path& hlsl_file) {
  std::set<fs::path> includes;
  std::ifstream file(hlsl_file);
  if (!file.is_open()) {
    std::cerr << "Warning: Could not open " << hlsl_file << '\n';
    return includes;
  }

  // Match: #include "path" or #include <path>
  std::regex include_regex(R"(^\s*#\s*include\s+[\"<]([^\">]+)[\">])");
  std::string line;
  auto base_dir = hlsl_file.parent_path();

  while (std::getline(file, line)) {
    std::smatch match;
    if (std::regex_search(line, match, include_regex)) {
      fs::path include_path = base_dir / match[1].str();
      try {
        // Normalize to resolve .., ., etc.
        include_path = fs::weakly_canonical(include_path);
      } catch (...) {
        // If path doesn't exist yet, normalize what we can
        include_path = include_path.lexically_normal();
      }
      includes.insert(include_path);
    }
  }

  return includes;
}

// Recursively collect all dependencies
// NOLINTNEXTLINE
void CollectDependencies(
    const fs::path& hlsl_file,
    std::set<fs::path>& visited,
    std::vector<fs::path>& dependencies) {
  // Avoid infinite loops
  if (visited.contains(hlsl_file)) {
    return;
  }
  visited.insert(hlsl_file);

  // Parse includes from this file (already normalized)
  auto includes = ParseIncludes(hlsl_file);

  for (const auto& resolved : includes) {

    // Add to dependencies
    dependencies.push_back(resolved);

    // Recurse if file exists
    if (fs::exists(resolved)) {
      CollectDependencies(resolved, visited, dependencies);
    }
  }
}

// Write Ninja-style dependency file
void WriteDependencyFile(
    const fs::path& depfile_path,
    const fs::path& target_file,
    const std::vector<fs::path>& dependencies) {
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
    depfile << " " << escape_path(dep);
  }

  depfile << '\n';
}

int main(int argc, char* argv[]) {
  if (argc != 4) {
    std::cerr << "Usage: " << argv[0] << " <input.hlsl> <output.h> <depfile.d>" << '\n';
    std::cerr << "  Analyzes HLSL #include dependencies and writes a Ninja-style .d file" << '\n';
    return 1;
  }

  fs::path input_file = argv[1];
  fs::path output_file = argv[2];
  fs::path depfile_path = argv[3];

  if (!fs::exists(input_file)) {
    std::cerr << "Error: Input file does not exist: " << input_file << '\n';
    return 1;
  }

  // Collect all dependencies recursively
  std::set<fs::path> visited;
  std::vector<fs::path> dependencies;
  dependencies.push_back(input_file);  // Include the source file itself

  CollectDependencies(input_file, visited, dependencies);

  // Remove duplicates while preserving order
  std::set<fs::path> seen;
  std::vector<fs::path> unique_deps;
  for (const auto& dep : dependencies) {
    if (seen.insert(dep).second) {
      unique_deps.push_back(dep);
    }
  }

  // Write dependency file: depfile.d contains "output_file.cso: input deps..."
  WriteDependencyFile(depfile_path, output_file, unique_deps);

  return 0;
}
