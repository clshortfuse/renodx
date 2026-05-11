#pragma once

#include <algorithm>
#include <atomic>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <format>
#include <fstream>
#include <functional>
#include <include/reshade.hpp>
#include <include/reshade_api_resource.hpp>
#include <memory>
#include <mutex>
#include <optional>
#include <shared_mutex>
#include <span>
#include <string>
#include <string_view>
#include <vector>

#include "./cross_addon.hpp"
#include "./data.hpp"
#include "./hash.hpp"
#include "./png.hpp"
#include "./resource.hpp"

namespace renodx::utils::resource::replace {

enum class UploadPath : uint8_t {
  CREATE_RESOURCE = 1u << 0u,
  UPDATE_TEXTURE_REGION = 1u << 1u,
  COPY_BUFFER_TO_TEXTURE = 1u << 3u,
};

inline constexpr uint32_t UPLOAD_PATH_ALL = static_cast<uint32_t>(UploadPath::CREATE_RESOURCE)
                                            | static_cast<uint32_t>(UploadPath::UPDATE_TEXTURE_REGION);

inline constexpr int32_t ANY_DIMENSION = -1;

struct ResourceReplaceRule {
  std::string name;

  bool enabled = true;
  uint32_t upload_paths = UPLOAD_PATH_ALL;
  uint32_t subresource = 0u;
  bool require_full_update = true;
  bool require_upload_heap_source = true;

  reshade::api::format format = reshade::api::format::unknown;
  reshade::api::resource_usage usage_include = reshade::api::resource_usage::shader_resource;
  reshade::api::resource_usage usage_exclude = static_cast<reshade::api::resource_usage>(
      static_cast<uint32_t>(reshade::api::resource_usage::render_target)
      | static_cast<uint32_t>(reshade::api::resource_usage::depth_stencil));

  int32_t width = ANY_DIMENSION;
  int32_t height = ANY_DIMENSION;
  int32_t depth_or_layers = ANY_DIMENSION;

  bool allow_dynamic = false;
  bool allow_multisampled = false;
};

struct MatchContext {
  UploadPath upload_path = UploadPath::CREATE_RESOURCE;
  reshade::api::resource source = {0u};
  reshade::api::resource destination = {0u};
  uint64_t source_offset = 0u;
  uint32_t source_subresource = 0u;
  uint32_t dest_subresource = 0u;
  const reshade::api::subresource_box* update_box = nullptr;
};

struct ReplacementData {
  std::vector<uint8_t> bytes;
  uint32_t row_pitch = 0u;
  uint32_t slice_pitch = 0u;
};

using ReplacementProvider = std::function<bool(
    const ResourceReplaceRule& rule,
    const MatchContext& context,
    const reshade::api::resource_desc& destination_desc,
    const reshade::api::subresource_data& source_data,
    ReplacementData& replacement_data)>;

struct Stats {
  uint64_t create_hits = 0u;
  uint64_t update_hits = 0u;
  uint64_t copy_texture_hits = 0u;
  uint64_t copy_buffer_hits = 0u;
  uint64_t map_hits = 0u;
  uint64_t replacements_applied = 0u;
};

struct TextureObservation {
  std::uint64_t id = 0u;
  UploadPath upload_path = UploadPath::CREATE_RESOURCE;
  std::uint32_t subresource = 0u;
  std::uint32_t crc32 = 0u;
  bool has_source_heap = false;
  reshade::api::memory_heap source_heap = reshade::api::memory_heap::unknown;
  reshade::api::format format = reshade::api::format::unknown;
  std::uint32_t width = 0u;
  std::uint32_t height = 0u;
  std::uint32_t depth_or_layers = 0u;
  std::uint32_t row_pitch = 0u;
  std::uint32_t slice_pitch = 0u;
  std::uint64_t source_size = 0u;
  std::uint64_t hit_count = 0u;
  std::uint64_t replacement_count = 0u;
  std::uint64_t last_source_handle = 0u;
  std::uint64_t last_destination_handle = 0u;
  bool has_sample = false;
  std::vector<std::uint8_t> sample_bytes;
};

struct __declspec(uuid("96126bac-9f16-44ca-ba37-33875c9002ed")) DeviceData {
  std::shared_mutex mutex;
  std::uint64_t next_observation_id = 1u;
  std::vector<ResourceReplaceRule> rules;
  Stats stats = {};
  std::vector<TextureObservation> observations;
};

struct __declspec(uuid("20bbd1a7-0373-4c5f-bb01-6f945a53a4a0")) SharedData {
  std::atomic_bool enabled = false;
};

static cross_addon::Shared<SharedData> shared;
static std::shared_mutex provider_mutex;
static ReplacementProvider provider = {};

static thread_local std::vector<std::vector<uint8_t>> create_data_to_delete;
static thread_local struct PendingCreateObservation {
  DeviceData* device_data = nullptr;
  std::uint64_t observation_id = 0u;
  reshade::api::device* device = nullptr;
  reshade::api::resource_desc desc = {};
} pending_create_observations[8];
static thread_local std::size_t pending_create_observation_count = 0u;

inline constexpr std::uint64_t MAX_CAPTURE_BYTES = 64ull * 1024ull * 1024ull;

inline std::uint32_t GetEffectiveRowPitch(
    const reshade::api::resource_desc& destination_desc,
    const reshade::api::subresource_data& source_data,
    std::uint32_t subresource) {
  const auto levels = std::max<std::uint32_t>(destination_desc.texture.levels, 1u);
  const auto level = subresource % levels;
  const auto width = std::max<std::uint32_t>(destination_desc.texture.width >> level, 1u);
  return source_data.row_pitch != 0u
             ? source_data.row_pitch
             : reshade::api::format_row_pitch(destination_desc.texture.format, width);
}

inline std::uint32_t GetEffectiveSlicePitch(
    const reshade::api::resource_desc& destination_desc,
    const reshade::api::subresource_data& source_data,
    std::uint32_t subresource) {
  const auto levels = std::max<std::uint32_t>(destination_desc.texture.levels, 1u);
  const auto level = subresource % levels;
  const auto height = std::max<std::uint32_t>(destination_desc.texture.height >> level, 1u);
  const auto row_pitch = GetEffectiveRowPitch(destination_desc, source_data, subresource);
  return source_data.slice_pitch != 0u
             ? source_data.slice_pitch
             : reshade::api::format_slice_pitch(destination_desc.texture.format, row_pitch, height);
}

template <typename T>
inline bool HasFlag(T set, T flag) {
  return (static_cast<uint32_t>(set) & static_cast<uint32_t>(flag)) != 0u;
}

inline bool MatchesPath(const ResourceReplaceRule& rule, UploadPath path) {
  return (rule.upload_paths & static_cast<uint32_t>(path)) != 0u;
}

inline std::string_view UploadPathName(UploadPath path) {
  switch (path) {
    case UploadPath::CREATE_RESOURCE:
      return "create_resource";
    case UploadPath::UPDATE_TEXTURE_REGION:
      return "update_texture_region";
    case UploadPath::COPY_BUFFER_TO_TEXTURE:
      return "copy_buffer_to_texture";
  }
  return "unknown";
}

inline std::string_view MemoryHeapName(reshade::api::memory_heap heap) {
  switch (heap) {
    case reshade::api::memory_heap::unknown:
      return "unknown";
    case reshade::api::memory_heap::gpu_only:
      return "gpu_only";
    case reshade::api::memory_heap::cpu_to_gpu:
      return "cpu_to_gpu";
    case reshade::api::memory_heap::gpu_to_cpu:
      return "gpu_to_cpu";
    case reshade::api::memory_heap::cpu_only:
      return "cpu_only";
    case reshade::api::memory_heap::custom:
      return "custom";
  }
  return "unknown";
}

inline bool IsUploadHeap(reshade::api::memory_heap heap) {
  return heap == reshade::api::memory_heap::cpu_to_gpu;
}

inline bool IsTextureUploadCandidate(const reshade::api::resource_desc& desc) {
  return desc.type == reshade::api::resource_type::texture_2d;
}

inline DeviceData* GetOrCreateDeviceData(reshade::api::device* device) {
  if (device == nullptr) return nullptr;
  DeviceData* data = renodx::utils::data::Get<DeviceData>(device);
  if (data != nullptr) return data;
  renodx::utils::data::CreateOrGet(device, data);
  return data;
}

inline bool MatchesRule(
    const ResourceReplaceRule& rule,
    const reshade::api::resource_desc& desc,
    const MatchContext& context) {
  if (!rule.enabled) return false;
  if (!MatchesPath(rule, context.upload_path)) return false;
  if (desc.type != reshade::api::resource_type::texture_2d) return false;
  if (context.dest_subresource != rule.subresource) return false;
  if (!rule.allow_multisampled && desc.texture.samples != 1u) return false;
  if (!rule.allow_dynamic
      && HasFlag(desc.flags, reshade::api::resource_flags::dynamic)) {
    return false;
  }
  if (rule.format != reshade::api::format::unknown && desc.texture.format != rule.format) {
    return false;
  }
  if (rule.usage_include != reshade::api::resource_usage::undefined
      && !HasFlag(desc.usage, rule.usage_include)) {
    return false;
  }
  if (rule.usage_exclude != reshade::api::resource_usage::undefined
      && HasFlag(desc.usage, rule.usage_exclude)) {
    return false;
  }
  if (rule.width >= 0 && desc.texture.width != static_cast<uint32_t>(rule.width)) return false;
  if (rule.height >= 0 && desc.texture.height != static_cast<uint32_t>(rule.height)) return false;
  if (rule.depth_or_layers >= 0 && desc.texture.depth_or_layers != static_cast<uint32_t>(rule.depth_or_layers)) {
    return false;
  }
  if (rule.require_full_update && context.update_box != nullptr) {
    const auto width = static_cast<uint32_t>(context.update_box->right - context.update_box->left);
    const auto height = static_cast<uint32_t>(context.update_box->bottom - context.update_box->top);
    const auto depth = static_cast<uint32_t>(context.update_box->back - context.update_box->front);
    if (width != desc.texture.width || height != desc.texture.height || depth != desc.texture.depth_or_layers) {
      return false;
    }
  }
  return true;
}

inline const ResourceReplaceRule& GetProviderFallbackRule() {
  static const ResourceReplaceRule rule = []() {
    ResourceReplaceRule value = {};
    value.name = "__provider_fallback__";
    value.enabled = true;
    value.upload_paths = UPLOAD_PATH_ALL;
    value.subresource = 0u;
    value.require_full_update = true;
    value.require_upload_heap_source = false;
    value.format = reshade::api::format::unknown;
    value.usage_include = reshade::api::resource_usage::shader_resource;
    value.usage_exclude = static_cast<reshade::api::resource_usage>(
        static_cast<uint32_t>(reshade::api::resource_usage::render_target)
        | static_cast<uint32_t>(reshade::api::resource_usage::depth_stencil));
    value.width = ANY_DIMENSION;
    value.height = ANY_DIMENSION;
    value.depth_or_layers = 1;
    value.allow_dynamic = false;
    value.allow_multisampled = false;
    return value;
  }();
  return rule;
}

inline std::optional<ResourceReplaceRule> FindRule(
    DeviceData* device_data,
    const reshade::api::resource_desc& desc,
    const MatchContext& context) {
  if (device_data == nullptr) return std::nullopt;
  std::shared_lock lock(device_data->mutex);
  for (auto& rule : device_data->rules) {
    if (MatchesRule(rule, desc, context)) {
      return rule;
    }
  }
  return std::nullopt;
}

inline std::optional<ResourceReplaceRule> ResolveRule(
    DeviceData* device_data,
    const reshade::api::resource_desc& desc,
    const MatchContext& context) {
  auto explicit_rule = FindRule(device_data, desc, context);
  if (explicit_rule.has_value()) return explicit_rule;

  {
    std::shared_lock provider_lock(provider_mutex);
    if (!provider) return std::nullopt;
  }

  const auto& fallback_rule = GetProviderFallbackRule();
  if (!MatchesRule(fallback_rule, desc, context)) return std::nullopt;
  return fallback_rule;
}

inline void IncrementHit(DeviceData* device_data, UploadPath path) {
  if (device_data == nullptr) return;
  std::unique_lock lock(device_data->mutex);
  switch (path) {
    case UploadPath::CREATE_RESOURCE:
      device_data->stats.create_hits++;
      break;
    case UploadPath::UPDATE_TEXTURE_REGION:
      device_data->stats.update_hits++;
      break;
    case UploadPath::COPY_BUFFER_TO_TEXTURE:
      device_data->stats.copy_buffer_hits++;
      break;
  }
}

inline void IncrementReplacement(DeviceData* device_data) {
  if (device_data == nullptr) return;
  std::unique_lock lock(device_data->mutex);
  device_data->stats.replacements_applied++;
}

inline bool IsSupportedPngFormat(reshade::api::format format) {
  switch (format) {
    case reshade::api::format::r8g8b8a8_typeless:
    case reshade::api::format::r8g8b8a8_unorm:
    case reshade::api::format::r8g8b8a8_unorm_srgb:
    case reshade::api::format::r8g8b8x8_unorm:
    case reshade::api::format::r8g8b8x8_unorm_srgb:
    case reshade::api::format::b8g8r8a8_typeless:
    case reshade::api::format::b8g8r8a8_unorm:
    case reshade::api::format::b8g8r8a8_unorm_srgb:
    case reshade::api::format::b8g8r8x8_typeless:
    case reshade::api::format::b8g8r8x8_unorm:
    case reshade::api::format::b8g8r8x8_unorm_srgb:
      return true;
    default:
      return false;
  }
}

inline bool IsBgraFamily(reshade::api::format format) {
  switch (format) {
    case reshade::api::format::b8g8r8a8_typeless:
    case reshade::api::format::b8g8r8a8_unorm:
    case reshade::api::format::b8g8r8a8_unorm_srgb:
    case reshade::api::format::b8g8r8x8_typeless:
    case reshade::api::format::b8g8r8x8_unorm:
    case reshade::api::format::b8g8r8x8_unorm_srgb:
      return true;
    default:
      return false;
  }
}

inline std::optional<std::size_t> FindObservationIndex(
    DeviceData* device_data,
    UploadPath upload_path,
    std::uint32_t subresource,
    std::uint32_t crc32,
    bool has_source_heap,
    reshade::api::memory_heap source_heap,
    reshade::api::format format,
    std::uint32_t width,
    std::uint32_t height,
    std::uint32_t depth_or_layers,
    std::uint32_t row_pitch,
    std::uint32_t slice_pitch) {
  if (device_data == nullptr) return std::nullopt;
  for (std::size_t i = 0; i < device_data->observations.size(); ++i) {
    const auto& item = device_data->observations[i];
    if (item.upload_path == upload_path
        && item.subresource == subresource
        && item.crc32 == crc32
        && item.has_source_heap == has_source_heap
        && item.source_heap == source_heap
        && item.format == format
        && item.width == width
        && item.height == height
        && item.depth_or_layers == depth_or_layers
        && item.row_pitch == row_pitch
        && item.slice_pitch == slice_pitch) {
      return i;
    }
  }
  return std::nullopt;
}

inline std::uint64_t RecordObservation(
    DeviceData* device_data,
    const MatchContext& context,
    const reshade::api::resource_desc& destination_desc,
    const reshade::api::subresource_data& source_data,
    bool replacement_applied,
    std::optional<reshade::api::memory_heap> source_heap = std::nullopt) {
  if (device_data == nullptr || source_data.data == nullptr) return 0u;
  // ReShade exposes row pitch, but no source byte count. For partial texture
  // boxes, hashing a derived full-slice size can walk past the upload buffer.
  if (!renodx::utils::resource::IsFullSubresourceUpdate(
          destination_desc,
          context.dest_subresource,
          context.update_box)) {
    return 0u;
  }

  const auto row_pitch = GetEffectiveRowPitch(destination_desc, source_data, context.dest_subresource);
  const auto slice_pitch = GetEffectiveSlicePitch(destination_desc, source_data, context.dest_subresource);
  if (row_pitch == 0u || slice_pitch == 0u) return 0u;

  const auto source_size = static_cast<std::uint64_t>(slice_pitch);
  const auto* bytes = static_cast<const std::uint8_t*>(source_data.data);
  const auto crc32 = renodx::utils::hash::ComputeCRC32(bytes, static_cast<std::size_t>(source_size));

  std::unique_lock lock(device_data->mutex);
  const auto existing = FindObservationIndex(
      device_data,
      context.upload_path,
      context.dest_subresource,
      crc32,
      source_heap.has_value(),
      source_heap.value_or(reshade::api::memory_heap::unknown),
      destination_desc.texture.format,
      destination_desc.texture.width,
      destination_desc.texture.height,
      destination_desc.texture.depth_or_layers,
      row_pitch,
      slice_pitch);
  if (existing.has_value()) {
    auto& item = device_data->observations[existing.value()];
    item.hit_count += 1u;
    if (replacement_applied) item.replacement_count += 1u;
    item.has_source_heap = source_heap.has_value();
    item.source_heap = source_heap.value_or(reshade::api::memory_heap::unknown);
    item.last_source_handle = context.source.handle;
    item.last_destination_handle = context.destination.handle;
    return item.id;
  }

  TextureObservation item = {
      .id = device_data->next_observation_id++,
      .upload_path = context.upload_path,
      .subresource = context.dest_subresource,
      .crc32 = crc32,
      .has_source_heap = source_heap.has_value(),
      .source_heap = source_heap.value_or(reshade::api::memory_heap::unknown),
      .format = destination_desc.texture.format,
      .width = destination_desc.texture.width,
      .height = destination_desc.texture.height,
      .depth_or_layers = destination_desc.texture.depth_or_layers,
      .row_pitch = row_pitch,
      .slice_pitch = slice_pitch,
      .source_size = source_size,
      .hit_count = 1u,
      .replacement_count = replacement_applied ? 1u : 0u,
      .last_source_handle = context.source.handle,
      .last_destination_handle = context.destination.handle,
      .has_sample = false,
  };
  if (source_size <= MAX_CAPTURE_BYTES) {
    item.sample_bytes.assign(bytes, bytes + static_cast<std::size_t>(source_size));
    item.has_sample = true;
  }
  const auto observation_id = item.id;
  device_data->observations.push_back(std::move(item));
  return observation_id;
}

inline void UpdateObservationDestinationHandle(
    DeviceData* device_data,
    std::uint64_t observation_id,
    reshade::api::resource destination) {
  if (device_data == nullptr || observation_id == 0u || destination.handle == 0u) return;

  std::unique_lock lock(device_data->mutex);
  for (auto& item : device_data->observations) {
    if (item.id != observation_id) continue;
    item.last_destination_handle = destination.handle;
    return;
  }
}

inline bool MatchesPendingCreateObservation(
    const PendingCreateObservation& pending,
    reshade::api::device* device,
    const reshade::api::resource_desc& desc) {
  return pending.device == device
         && pending.desc.type == desc.type
         && pending.desc.texture.format == desc.texture.format
         && pending.desc.texture.width == desc.texture.width
         && pending.desc.texture.height == desc.texture.height
         && pending.desc.texture.depth_or_layers == desc.texture.depth_or_layers
         && pending.desc.texture.levels == desc.texture.levels
         && pending.desc.texture.samples == desc.texture.samples;
}

inline bool TryBuildReplacement(
    const ResourceReplaceRule& rule,
    const MatchContext& context,
    const reshade::api::resource_desc& destination_desc,
    const reshade::api::subresource_data& source_data,
    ReplacementData& replacement_data) {
  std::shared_lock provider_lock(provider_mutex);
  if (!provider) return false;
  if (!provider(rule, context, destination_desc, source_data, replacement_data)) return false;
  if (replacement_data.bytes.empty()) return false;
  if (replacement_data.row_pitch == 0u || replacement_data.slice_pitch == 0u) return false;
  return true;
}

inline bool OnCreateResource(
    reshade::api::device* device,
    reshade::api::resource_desc& desc,
    reshade::api::subresource_data* initial_data,
    reshade::api::resource_usage) {
  if (!shared.data->enabled.load(std::memory_order_relaxed)) return false;
  if (device == nullptr || initial_data == nullptr) return false;

  auto* device_data = GetOrCreateDeviceData(device);
  if (device_data == nullptr) return false;

  MatchContext context = {
      .upload_path = UploadPath::CREATE_RESOURCE,
      .dest_subresource = 0u,
      .update_box = nullptr,
  };
  const auto observed_source = *initial_data;
  std::optional<ResourceReplaceRule> rule = std::nullopt;
  if (IsTextureUploadCandidate(desc)) {
    IncrementHit(device_data, context.upload_path);
    rule = ResolveRule(device_data, desc, context);
  }

  ReplacementData replacement = {};
  const bool has_replacement = rule.has_value()
                               && TryBuildReplacement(*rule, context, desc, *initial_data, replacement);
  std::uint64_t observation_id = 0u;
  if (IsTextureUploadCandidate(desc)) {
    observation_id = RecordObservation(device_data, context, desc, observed_source, has_replacement);
    if (observation_id != 0u && pending_create_observation_count < std::size(pending_create_observations)) {
      pending_create_observations[pending_create_observation_count++] = PendingCreateObservation{
          .device_data = device_data,
          .observation_id = observation_id,
          .device = device,
          .desc = desc,
      };
    }
  }
  if (!has_replacement) return false;

  initial_data->data = replacement.bytes.data();
  initial_data->row_pitch = replacement.row_pitch;
  initial_data->slice_pitch = replacement.slice_pitch;
  create_data_to_delete.emplace_back(std::move(replacement.bytes));
  IncrementReplacement(device_data);
  return true;
}

inline void OnInitResource(
    reshade::api::device* device,
    const reshade::api::resource_desc& desc,
    const reshade::api::subresource_data*,
    reshade::api::resource_usage,
    reshade::api::resource resource) {
  if (pending_create_observation_count > 0u) {
    for (std::size_t i = pending_create_observation_count; i > 0u; --i) {
      const auto index = i - 1u;
      const auto& pending = pending_create_observations[index];
      if (!MatchesPendingCreateObservation(pending, device, desc)) continue;

      UpdateObservationDestinationHandle(pending.device_data, pending.observation_id, resource);
      pending_create_observations[index] = pending_create_observations[pending_create_observation_count - 1u];
      pending_create_observation_count -= 1u;
      break;
    }
  }
  create_data_to_delete.clear();
}

inline bool OnUpdateTextureRegion(
    reshade::api::device* device,
    const reshade::api::subresource_data& data,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box) {
  if (!shared.data->enabled.load(std::memory_order_relaxed)) return false;
  if (device == nullptr) return false;

  const auto desc = device->get_resource_desc(dest);
  auto* device_data = GetOrCreateDeviceData(device);
  if (device_data == nullptr) return false;
  if (!IsTextureUploadCandidate(desc)) return false;

  MatchContext context = {
      .upload_path = UploadPath::UPDATE_TEXTURE_REGION,
      .destination = dest,
      .dest_subresource = dest_subresource,
      .update_box = dest_box,
  };
  auto rule = ResolveRule(device_data, desc, context);
  IncrementHit(device_data, context.upload_path);
  const auto observed_source = data;
  ReplacementData replacement = {};
  const bool has_replacement = rule.has_value()
                               && TryBuildReplacement(*rule, context, desc, data, replacement);
  RecordObservation(device_data, context, desc, observed_source, has_replacement);
  if (!has_replacement) return false;

  reshade::api::subresource_data new_data = {
      .data = replacement.bytes.data(),
      .row_pitch = replacement.row_pitch,
      .slice_pitch = replacement.slice_pitch,
  };
  device->update_texture_region(new_data, dest, dest_subresource, dest_box);
  IncrementReplacement(device_data);
  return true;
}

inline void OnInitDevice(reshade::api::device* device) {
  if (device == nullptr) return;
  GetOrCreateDeviceData(device);
}

inline void OnDestroyDevice(reshade::api::device* device) {
  renodx::utils::data::Delete<DeviceData>(device);
}

inline bool SetRules(reshade::api::device* device, std::span<const ResourceReplaceRule> new_rules) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return false;
  std::unique_lock lock(data->mutex);
  data->rules.assign(new_rules.begin(), new_rules.end());
  return true;
}

inline Stats GetStats(reshade::api::device* device) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return {};
  std::shared_lock lock(data->mutex);
  return data->stats;
}

inline void ResetStats(reshade::api::device* device) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  std::unique_lock lock(data->mutex);
  data->stats = {};
}

inline std::vector<ResourceReplaceRule> GetRules(reshade::api::device* device) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return {};
  std::shared_lock lock(data->mutex);
  return data->rules;
}

inline std::vector<TextureObservation> GetObservations(reshade::api::device* device) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return {};
  std::shared_lock lock(data->mutex);
  return data->observations;
}

inline void ClearObservations(reshade::api::device* device) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) return;
  std::unique_lock lock(data->mutex);
  data->observations.clear();
  data->next_observation_id = 1u;
}

inline bool DumpObservationToFile(
    reshade::api::device* device,
    std::size_t observation_index,
    const std::filesystem::path& output_path,
    std::string* error = nullptr) {
  auto* data = renodx::utils::data::Get<DeviceData>(device);
  if (data == nullptr) {
    if (error != nullptr) *error = "Device data is not available.";
    return false;
  }

  TextureObservation observation = {};
  {
    std::shared_lock lock(data->mutex);
    if (observation_index >= data->observations.size()) {
      if (error != nullptr) *error = std::format("Observation index {} is out of range.", observation_index);
      return false;
    }
    observation = data->observations[observation_index];
  }

  if (!observation.has_sample || observation.sample_bytes.empty()) {
    if (error != nullptr) *error = "This observation does not include captured sample bytes.";
    return false;
  }

  std::error_code filesystem_error = {};
  const auto parent = output_path.parent_path();
  if (!parent.empty()) {
    std::filesystem::create_directories(parent, filesystem_error);
    if (filesystem_error) {
      if (error != nullptr) *error = std::format("Failed to create directory '{}': {}", parent.string(), filesystem_error.message());
      return false;
    }
  }

  auto target = output_path;
  if (!target.has_extension()) {
    target.replace_extension(L".bin");
  }

  if (target.extension() == L".png") {
    if (!IsSupportedPngFormat(observation.format)) {
      if (error != nullptr) {
        *error = "PNG export supports only RGBA8/BGRA8 families. Use .bin for other formats.";
      }
      return false;
    }
    if (observation.row_pitch < observation.width * 4u) {
      if (error != nullptr) *error = "Observation row pitch is smaller than width*4.";
      return false;
    }
    std::vector<std::uint8_t> rgba(
        static_cast<std::size_t>(observation.width) * static_cast<std::size_t>(observation.height) * 4u);
    const auto row_bytes = static_cast<std::size_t>(observation.width) * 4u;
    for (std::uint32_t y = 0u; y < observation.height; ++y) {
      const auto src_offset = static_cast<std::size_t>(observation.row_pitch) * static_cast<std::size_t>(y);
      const auto dst_offset = row_bytes * static_cast<std::size_t>(y);
      if (src_offset + row_bytes > observation.sample_bytes.size()) {
        if (error != nullptr) *error = "Observation sample buffer is too small for PNG export.";
        return false;
      }
      std::memcpy(rgba.data() + dst_offset, observation.sample_bytes.data() + src_offset, row_bytes);
      if (IsBgraFamily(observation.format)) {
        auto* row = rgba.data() + dst_offset;
        for (std::uint32_t x = 0u; x < observation.width; ++x) {
          std::swap(row[(x * 4u) + 0u], row[(x * 4u) + 2u]);
        }
      }
    }
    if (!renodx::utils::png::WriteRgba8(target, observation.width, observation.height, rgba)) {
      if (error != nullptr) *error = std::format("Failed to write PNG '{}'.", target.string());
      return false;
    }
    return true;
  }

  std::ofstream stream(target, std::ios::binary);
  if (!stream.good()) {
    if (error != nullptr) *error = std::format("Failed to open '{}' for writing.", target.string());
    return false;
  }
  stream.write(
      reinterpret_cast<const char*>(observation.sample_bytes.data()),
      static_cast<std::streamsize>(observation.sample_bytes.size()));
  if (!stream.good()) {
    if (error != nullptr) *error = std::format("Failed to write '{}'.", target.string());
    return false;
  }
  return true;
}

inline void SetProvider(ReplacementProvider new_provider) {
  std::unique_lock lock(provider_mutex);
  provider = std::move(new_provider);
}

inline bool HasProvider() {
  std::shared_lock lock(provider_mutex);
  return static_cast<bool>(provider);
}

inline void SetEnabled(bool value) {
  auto* data = shared.data;
  if (data == nullptr) return;
  data->enabled.store(value, std::memory_order_relaxed);
}

inline bool IsEnabled() {
  auto* data = shared.data;
  if (data == nullptr) return false;
  return data->enabled.load(std::memory_order_relaxed);
}

static void Use(DWORD fdw_reason) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      renodx::utils::resource::use_resource_replace = true;
      renodx::utils::resource::Use(fdw_reason);

      if (shared.RegisterModule()) {
        reshade::log::message(reshade::log::level::info, "utils::resource::replace attached.");
      }
      shared.RegisterEvent<reshade::addon_event::init_device>(OnInitDevice);
      shared.RegisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      shared.RegisterEvent<reshade::addon_event::create_resource>(OnCreateResource);
      shared.RegisterEvent<reshade::addon_event::init_resource>(OnInitResource);
      shared.RegisterEvent<reshade::addon_event::update_texture_region>(OnUpdateTextureRegion);
      break;
    case DLL_PROCESS_DETACH:
      shared.UnregisterEvent<reshade::addon_event::init_device>(OnInitDevice);
      shared.UnregisterEvent<reshade::addon_event::destroy_device>(OnDestroyDevice);
      shared.UnregisterEvent<reshade::addon_event::create_resource>(OnCreateResource);
      shared.UnregisterEvent<reshade::addon_event::init_resource>(OnInitResource);
      shared.UnregisterEvent<reshade::addon_event::update_texture_region>(OnUpdateTextureRegion);
      shared.UnregisterModule();
      renodx::utils::resource::Use(fdw_reason);
      break;
  }
}

}  // namespace renodx::utils::resource::replace
