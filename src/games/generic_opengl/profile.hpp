#pragma once

#include <Windows.h>
#include <include/reshade.hpp>
#include <nlohmann/json.hpp>
#include <filesystem>
#include <fstream>
#include <map>
#include <stdexcept>
#include <string>
#include <vector>
#include <cmath>
#include <set>

namespace generic_opengl {
namespace fs = std::filesystem;
inline constexpr size_t MAX_SOURCE_SIZE = 16 * 1024 * 1024;
inline thread_local bool internal_gl = false;

inline void Log(const std::string& text, bool error = false) {
  reshade::log::message(error ? reshade::log::level::warning : reshade::log::level::info,
                        ("[Generic OpenGL] " + text).c_str());
}

struct Parameter {
  std::string name;
  std::string label;
  float value = 0.f;
  float min = 0.f;
  float max = 1.f;
};
struct ParameterConfig {
  bool enabled = false;
  unsigned ubo_binding = 13;
  unsigned arb_start = 80;
  bool arb_environment = false;
  std::vector<Parameter> values;
};
struct Profile {
  fs::path root;
  bool dump = true;
  bool replace = true;
  bool hdr = false;
  bool default_framebuffer = false;
  bool fixed_function = false;
  bool unclamp_vertex = false;
  bool unclamp_fragment = false;
  bool steam_vulkan_workaround = true;
  std::string fixed_fragment;
  // Key: 0xCRC32.stage.glsl or 0xCRC32.stage.arb. Paths are relative to root.
  std::map<std::string, std::string> files;
  ParameterConfig parameters;
};
inline Profile profile;

// All file-backed replacements live under the profile root, including symlinks.
inline fs::path ProfilePath(const std::string& relative) {
  const fs::path path(relative);
  if (path.empty() || path.is_absolute() || path.has_root_name())
    throw std::runtime_error("Expected a relative profile path: " + relative);
  const auto root = fs::weakly_canonical(profile.root);
  const auto resolved = fs::weakly_canonical(root / path);
  const auto within = resolved.lexically_relative(root);
  if (within.empty() || *within.begin() == "..")
    throw std::runtime_error("Path leaves the profile directory: " + relative);
  return resolved;
}

inline std::string ReadSource(const fs::path& path) {
  const auto size = fs::file_size(path);
  if (size == 0 || size > MAX_SOURCE_SIZE) throw std::runtime_error("Invalid file size: " + path.string());
  std::string source(static_cast<size_t>(size), '\0');
  std::ifstream stream(path, std::ios::binary);
  if (!stream.read(source.data(), static_cast<std::streamsize>(source.size())))
    throw std::runtime_error("Cannot read " + path.string());
  if (source.find('\0') != std::string::npos) throw std::runtime_error("Embedded NUL in " + path.string());
  return source;
}

inline void LoadProfile() {
  wchar_t executable[32768] = {};
  const auto size = GetModuleFileNameW(nullptr, executable, 32768);
  if (size == 0 || size >= 32768) throw std::runtime_error("Cannot resolve executable directory");
  profile.root = fs::path(executable).parent_path() / L"renodx-opengl";
  const auto config = profile.root / L"profile.json";
  if (!fs::exists(config)) {
    Log("No profile.json; source capture only (no replacements without matching files). Root: " + profile.root.string());
    return;
  }
  const auto json = nlohmann::json::parse(ReadSource(config));
  Profile next;
  next.root = profile.root;
  next.dump = json.value("dump_shaders", true);
  next.replace = json.value("replace_shaders", true);
  next.hdr = json.value("hdr_proxy", false);
  next.default_framebuffer = json.value("redirect_default_framebuffer", false);
  next.steam_vulkan_workaround = json.value("steam_vulkan_workaround", true);
  if (json.contains("replacements")) next.files = json.at("replacements").get<decltype(next.files)>();
  if (json.contains("parameters")) {
    const auto& config = json.at("parameters");
    next.parameters.enabled = config.value("enabled", false);
    const int binding = config.value("ubo_binding", 13);
    const int start = config.value("arb_start", 80);
    if (binding < 0 || binding > 65535 || start < 0 || start > 65535)
      throw std::runtime_error("Parameter binding/start must be between 0 and 65535");
    next.parameters.ubo_binding = static_cast<unsigned>(binding);
    next.parameters.arb_start = static_cast<unsigned>(start);
    const auto mode = config.value("arb_mode", std::string("local"));
    if (mode != "local" && mode != "env") throw std::runtime_error("arb_mode must be local or env");
    next.parameters.arb_environment = mode == "env";
    if (config.contains("values") && !config.at("values").is_array())
      throw std::runtime_error("Parameter values must be an array");
    std::set<std::string> names;
    for (const auto& item : config.value("values", nlohmann::json::array())) {
      Parameter value;
      value.name = item.at("name").get<std::string>();
      value.label = item.value("label", value.name);
      value.value = item.value("value", 0.f);
      value.min = item.value("min", 0.f);
      value.max = item.value("max", 1.f);
      if (value.name.empty() || value.name.size() > 64 || value.name.find_first_not_of("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_") != std::string::npos
          || !names.insert(value.name).second)
        throw std::runtime_error("Parameter names must be unique ASCII names of 1-64 letters, digits or underscores");
      if (!std::isfinite(value.value) || !std::isfinite(value.min) || !std::isfinite(value.max)
          || value.min >= value.max || value.value < value.min || value.value > value.max)
        throw std::runtime_error("Invalid parameter value/range: " + value.name);
      next.parameters.values.push_back(std::move(value));
    }
    if (next.parameters.values.size() > 64 || (next.parameters.enabled && next.parameters.values.empty()))
      throw std::runtime_error("Enable parameters with between 1 and 64 scalar values");
  }
  if (json.contains("fixed_function")) {
    const auto& fixed = json.at("fixed_function");
    next.fixed_function = fixed.value("enabled", false);
    next.fixed_fragment = fixed.value("fragment_shader", std::string{});
    next.unclamp_vertex = fixed.value("unclamp_vertex_color", false);
    next.unclamp_fragment = fixed.value("unclamp_fragment_color", false);
  }
  if (next.default_framebuffer && !next.hdr)
    throw std::runtime_error("redirect_default_framebuffer requires hdr_proxy");
  for (const auto& [key, file] : next.files) (void)ProfilePath(file);
  if (!next.fixed_fragment.empty()) (void)ProfilePath(next.fixed_fragment);
  profile = std::move(next);
  Log("Loaded profile from " + config.string());
}
}  // namespace generic_opengl
