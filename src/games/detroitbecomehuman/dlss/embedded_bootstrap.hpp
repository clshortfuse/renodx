/*
 * SPDX-License-Identifier: MIT
 */

#pragma once

#include <algorithm>
#include <cctype>
#include <cstdint>
#include <string>
#include <string_view>
#include <vector>

#include <Windows.h>

#include "../dlss_bridge_abi.h"

namespace renodx::games::detroitbecomehuman::dlss::embedded {

inline constexpr std::uint32_t kCacheSchemaVersion = 1u;
inline constexpr std::string_view kSupportedExecutableSha256 =
    "ECF52321921387E683904E089082D76B973326FC093AF14E524056715519C1CF";

// Targeted descriptor/resource tracking is active for DLSS/DLAA. It intentionally
// does not install the global vkCmdBindPipeline/vkCmdBindDescriptorSets hooks
// that caused the original CPU/FPS regression; those remain Retinal-DOF-only.
inline constexpr bool kDlssRuntimeEnabled = true;

enum class BootstrapStatus : std::uint32_t {
  kFirstRunSetup = 0u,
  kRestartRequired,
  kEarlyHookActive,
  kDlaaReady,
  kNativeFallback,
};

struct ExtensionCache {
  std::uint32_t schema_version = 0u;
  bool ready = false;
  std::string executable_sha256;
  std::string instance_extensions;
  std::string device_extensions;
};

[[nodiscard]] inline bool EqualsInsensitiveAscii(
    std::string_view left, std::string_view right) {
  return left.size() == right.size()
         && std::equal(left.begin(), left.end(), right.begin(), [](char a, char b) {
              return std::tolower(static_cast<unsigned char>(a))
                     == std::tolower(static_cast<unsigned char>(b));
            });
}

[[nodiscard]] inline std::string_view FileName(std::string_view path) {
  const auto separator = path.find_last_of("/\\");
  return separator == std::string_view::npos ? path : path.substr(separator + 1u);
}

[[nodiscard]] inline bool IsValidExtensionList(std::string_view serialized) {
  if (serialized.size() >= 16u * 1024u) return false;
  if (serialized.empty()) return true;
  std::vector<std::string_view> names;
  for (std::size_t start = 0u; start <= serialized.size();) {
    const auto end = serialized.find(';', start);
    const auto name = serialized.substr(
        start, end == std::string_view::npos ? serialized.size() - start : end - start);
    if (name.empty() || name.size() >= 256u
        || std::find(names.begin(), names.end(), name) != names.end()) {
      return false;
    }
    names.push_back(name);
    if (names.size() > 64u || end == std::string_view::npos) break;
    start = end + 1u;
  }
  return names.size() <= 64u;
}

[[nodiscard]] inline bool IsValidCache(const ExtensionCache& cache) {
  return cache.ready && cache.schema_version == kCacheSchemaVersion
         && EqualsInsensitiveAscii(cache.executable_sha256, kSupportedExecutableSha256)
         && IsValidExtensionList(cache.instance_extensions)
         && IsValidExtensionList(cache.device_extensions);
}

[[nodiscard]] inline bool CanAttachEarlyHooks(const ExtensionCache& cache) {
  return IsValidCache(cache);
}

[[nodiscard]] inline bool MergeLoadFromDllMainEntry(
    std::vector<std::string>* entries, std::string_view addon_filename) {
  if (entries == nullptr || addon_filename.empty()) return false;
  if (std::any_of(entries->begin(), entries->end(), [&](const std::string& entry) {
        return EqualsInsensitiveAscii(FileName(entry), addon_filename);
      })) {
    return false;
  }
  entries->emplace_back(addon_filename);
  return true;
}

// Loader-lock entry point. This only consumes a previously validated cache and
// attaches Detours to the already-loaded ReShade Vulkan layer.
bool AttachEarlyHooks(
    HMODULE addon_module,
    const ExtensionCache& cache,
    bool install_native_command_hooks);
void DetachEarlyHooks(bool process_terminating);
bool IsExtensionProbeHost();

// Deferred work. These functions must only be called after device creation and
// outside DllMain/the Vulkan loader lock.
bool VerifySupportedExecutable();
bool QueryRequiredExtensions(ExtensionCache* cache);
bool QueryRequiredExtensionsIsolated(HMODULE addon_module, ExtensionCache* cache);
void SetRestartRequired();
void RefreshDeferredStatus();
void SetNativeFallback(const char* reason);

BootstrapStatus GetStatus();
const char* GetStatusText();
bool WasLoadedEarly();
bool IsBridgeReady();

[[nodiscard]] inline constexpr bool NeedsRuntimeCommandTracking(
    DetroitDlssMode mode, bool retinal_dof_requested) noexcept {
  (void)mode;
  return retinal_dof_requested;
}

[[nodiscard]] inline constexpr bool NeedsEmbeddedBridge(
    DetroitDlssMode mode, bool retinal_dof_requested) noexcept {
  (void)mode;
  // NGX extensions and targeted descriptor/resource tracking must be present
  // from device creation, independently of Retinal DOF command-state hooks.
  return kDlssRuntimeEnabled || retinal_dof_requested;
}

// Calling a Vulkan layer's vkAllocateCommandBuffers trampoline directly skips
// the loader step that installs the current layer dispatch pointer on returned
// dispatchable objects. Copying it from the parent device makes the private
// command buffer safe to pass back through that same layer.
[[nodiscard]] inline bool RestoreVulkanLayerDispatchPointer(
    void* parent_dispatchable, void* child_dispatchable) noexcept {
  if (parent_dispatchable == nullptr || child_dispatchable == nullptr) return false;
  void* const layer_dispatch =
      *reinterpret_cast<void* const*>(parent_dispatchable);
  if (layer_dispatch == nullptr) return false;
  *reinterpret_cast<void**>(child_dispatchable) = layer_dispatch;
  return true;
}

// Targeted DLSS/DLAA keeps only resource and descriptor metadata warm. This
// separate gate enables per-command-buffer bind state solely for Retinal DOF.
void SetRuntimeCommandTracking(bool enabled);

bool CanInsertComputeWriteBarrier(std::uint64_t command_buffer);
bool InsertComputeWriteBarrier(std::uint64_t command_buffer);

// Narrow, production-only snapshot used by the Retinal DOF post-filter. The
// Vulkan layer records only descriptor sets whose exact layout matches the
// verified Detroit DOF composite contract; this deliberately avoids enabling
// RenoDX's process-wide descriptor tracing slow path.
enum class DofCompositeCaptureDetail : std::uint32_t {
  kNotAttempted = 0u,
  kSuccess,
  kInvalidArgument,
  kDeviceStateUnavailable,
  kUnsupportedExecutable,
  kDeviceDestroying,
  kPushConstantsUnavailable,
  kCommandStateMissing,
  kCommandStateIncomplete,
  kDescriptorSetMissing,
  kDescriptorSetLayoutMissing,
  kDescriptorSetLayoutMismatch,
  kPipelineLayoutMissing,
  kPipelineLayoutMismatch,
  kOutputBindingUnavailable,
  kDepthBindingUnavailable,
  kOutputDescriptorTypeMismatch,
  kOutputLayoutMismatch,
  kDepthDescriptorTypeMismatch,
};

struct DofCompositeImageSnapshot {
  std::uint64_t command_buffer = 0u;
  std::uint64_t descriptor_set = 0u;
  std::uint64_t pipeline_layout = 0u;
  std::uint64_t compute_pipeline = 0u;
  std::uint32_t descriptor_set_index = 0u;
  std::uint32_t binding = 16u;
  std::uint32_t dynamic_offset_count = 0u;
  std::uint32_t dynamic_offset = 0u;
  std::uint32_t push_constant_stage_flags = 0u;
  std::uint32_t push_constant_offset = 0u;
  std::uint32_t push_constant_size = 0u;
  DetroitDlssImageBindingSnapshot image = {};
  DetroitDlssImageBindingSnapshot depth = {};
};

[[nodiscard]] bool CaptureDofCompositeImageSnapshot(
    std::uint64_t command_buffer,
    DofCompositeImageSnapshot* snapshot,
    DofCompositeCaptureDetail* detail = nullptr);

// Releases the temporary tracking freeze when no private commands were
// recorded after capture. This does not emit Vulkan commands or alter GPU
// state.
[[nodiscard]] bool ReleaseDofCompositeImageSnapshot(
    const DofCompositeImageSnapshot& snapshot);

// Restores the exact native compute state captured above, including the
// dynamic offset required by Detroit's b52 UBO and the current 112-byte
// ShaderInjectData push payload. ReShade's generic descriptor-table restore
// cannot represent the dynamic offset on Vulkan.
[[nodiscard]] bool RestoreDofCompositeComputeState(
    const DofCompositeImageSnapshot& snapshot,
    const void* push_constant_data,
    std::uint32_t push_constant_size);

DetroitDlssResultCode DETROIT_DLSS_CALL GetApi(
    std::uint32_t requested_version,
    DetroitDlssApiV2* api);

}  // namespace renodx::games::detroitbecomehuman::dlss::embedded
