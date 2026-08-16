/*
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64
#define DEBUG_LEVEL_0

#include <algorithm>
#include <array>
#include <atomic>
#include <bit>
#include <charconv>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <format>
#include <limits>
#include <mutex>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <system_error>
#include <utility>
#include <vector>

#include <Windows.h>

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <embed/temporal_aux_exact.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/cross_addon.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "../../utils/swapchain.hpp"
#include "./dlss/embedded_bootstrap.hpp"
#include "./debug/render_debug.hpp"
#include "./effects/dof_runtime.hpp"
#include "./effects/retinal_capture.hpp"
#include "./effects/retinal_observability.hpp"
#include "./hdr/peak_brightness.hpp"
#include "./shared.h"
#include "./dlss/temporal_capture.hpp"
#include "./ultrawide.hpp"

#ifndef DETROIT_EFFECTS_ADDON
namespace renodx::games::detroitbecomehuman::dlss::embedded {

void SetRuntimeCommandTracking(bool) {}
bool CanInsertComputeWriteBarrier(std::uint64_t) { return false; }
bool InsertComputeWriteBarrier(std::uint64_t) { return false; }

bool CaptureDofCompositeImageSnapshot(
    std::uint64_t,
    DofCompositeImageSnapshot* snapshot,
    DofCompositeCaptureDetail* detail) {
  if (snapshot != nullptr) *snapshot = {};
  if (detail != nullptr) *detail = DofCompositeCaptureDetail::kNotAttempted;
  return false;
}

bool ReleaseDofCompositeImageSnapshot(const DofCompositeImageSnapshot&) {
  return false;
}

bool RestoreDofCompositeComputeState(
    const DofCompositeImageSnapshot&,
    const void*,
    std::uint32_t) {
  return false;
}

}  // namespace renodx::games::detroitbecomehuman::dlss::embedded
#endif

namespace {

#ifdef DETROIT_EFFECTS_ADDON
constexpr bool kEffectsAddon = true;
#else
constexpr bool kEffectsAddon = false;
#endif

constexpr float OUTPUT_MODE_AUTO = 0.f;
constexpr float OUTPUT_MODE_SDR = 1.f;
constexpr float OUTPUT_MODE_HDR10 = 2.f;

constexpr float CAS_MODE_VANILLA = 0.f;
constexpr float CAS_MODE_OFF = 1.f;
constexpr float CAS_MODE_RENODX = 2.f;

constexpr char RESHADE_CAPTURE_ENVIRONMENT[] =
    "RENODX_DETROIT_RESHADE_CAPTURE";
constexpr char RESHADE_CAPTURE_DELAY_ENVIRONMENT[] =
    "RENODX_DETROIT_RESHADE_CAPTURE_DELAY_SECONDS";
constexpr std::uint32_t RESHADE_CAPTURE_STABLE_FRAMES = 90u;
constexpr std::uint32_t RESHADE_CAPTURE_DEFAULT_DELAY_SECONDS = 30u;
constexpr std::uint32_t RESHADE_CAPTURE_MAX_DELAY_SECONDS = 600u;

namespace ultrawide = renodx::games::detroitbecomehuman::ultrawide;
namespace temporal_capture =
    renodx::games::detroitbecomehuman::temporal_capture;
namespace supported_build =
    renodx::games::detroitbecomehuman::supported_build;
namespace embedded_dlss =
    renodx::games::detroitbecomehuman::dlss::embedded;
namespace dof = renodx::games::detroitbecomehuman::dof;
namespace peak_brightness =
    renodx::games::detroitbecomehuman::peak_brightness;
namespace render_debug =
    renodx::games::detroitbecomehuman::render_debug;
namespace retinal = renodx::games::detroitbecomehuman::retinal;
namespace retinal_capture =
    renodx::games::detroitbecomehuman::retinal_capture;
namespace retinal_observability =
    renodx::games::detroitbecomehuman::retinal_observability;

struct EffectsApi;

struct __declspec(uuid("d920d9be-4d54-4d28-90ec-e306386a7b52")) AddonSharedState {
  std::atomic<const EffectsApi*> effects_api = nullptr;
  std::atomic_uint32_t hdr_sharpening_normalization =
      std::bit_cast<std::uint32_t>(1.f);
};

renodx::utils::cross_addon::Shared<AddonSharedState> addon_shared;

struct alignas(16) UltrawideRuntimeData {
  volatile LONG aspect_ratio_bits;
  volatile LONG ui_half_extent_bits;
};

struct UltrawidePatchState {
  std::array<std::uint8_t*, ultrawide::kRuntimePatchPlan.size()> displacement_addresses = {};
  std::array<std::int32_t, ultrawide::kRuntimePatchPlan.size()> original_displacements = {};
  std::array<std::int32_t, ultrawide::kRuntimePatchPlan.size()> redirected_displacements = {};
  std::array<DWORD, ultrawide::kRuntimePatchPlan.size()> original_protections = {};
  std::array<bool, ultrawide::kRuntimePatchPlan.size()> active_patches = {};
  UltrawideRuntimeData* runtime_data = nullptr;
};

UltrawidePatchState ultrawide_patch;
std::mutex ultrawide_patch_mutex;
std::atomic<UltrawideRuntimeData*> ultrawide_runtime_data = nullptr;
std::atomic_bool ultrawide_installed = false;
std::atomic_bool ultrawide_install_attempted = false;
std::atomic_bool ultrawide_force_vanilla = false;
std::atomic<reshade::api::swapchain*> tracked_swapchain = nullptr;
std::atomic<reshade::api::effect_runtime*> tracked_effect_runtime = nullptr;
float peak_brightness_source =
    static_cast<float>(peak_brightness::Source::kAutomatic);
float manual_peak_nits = peak_brightness::kFallbackPeakNits;
peak_brightness::RefreshController peak_brightness_refresh;
std::optional<DXGI_OUTPUT_DESC1> detected_output_desc = std::nullopt;
std::optional<float> detected_peak_nits = std::nullopt;
std::atomic_bool peak_brightness_refresh_requested = true;
std::string peak_brightness_status =
    "Auto: waiting for the Vulkan swapchain; effective peak is 1000 nits fallback.";
float aspect_ratio_mode = 1.f;
float dlss_mode = static_cast<float>(DETROIT_DLSS_MODE_NATIVE);
float dlaa_sharpening = 0.f;
float dof_mode = 0.f;
std::atomic_bool retinal_mode_downgraded = false;
float dof_quality = 1.f;
float dof_focus_distance = 100.f;
float dof_blur_radius = 100.f;
float dof_far_strength = 100.f;
float dof_vanilla_transition = 100.f;
float dof_fill_coc_reconstruction = 0.f;
float dof_fill_transition = 0.f;
float dof_fill_rgb_reconstruction = 0.f;
float experimental_motion_blur = 0.f;
dof::RuntimeController dof_runtime_controller;
std::atomic_bool dof_tracking_enabled = false;
float retinal_fixation_x = 50.f;
float retinal_fixation_y = 50.f;
float retinal_strength = 100.f;
float retinal_horizontal_fov =
    retinal::kDefaultHorizontalScreenAngleDegrees;
float retinal_maximum_sigma = retinal::kMaximumSigmaPixels;
retinal::Runtime retinal_runtime;
retinal_observability::RunResultState retinal_run_result_state(
    retinal::RunResult::kNotRetinalMode);
retinal_observability::CaptureDiagnosticState retinal_capture_diagnostic_state;
std::atomic_bool retinal_force_disabled = false;
std::atomic_bool retinal_restore_failure_logged = false;
float render_debug_mode = 0.f;
float render_debug_dashboard = 0.f;
float render_debug_single_source =
    static_cast<float>(render_debug::Source::kDofFullResolutionCoc);
float render_debug_custom_slot_1 =
    static_cast<float>(render_debug::Source::kDofFullResolutionCoc);
float render_debug_custom_slot_2 =
    static_cast<float>(render_debug::Source::kTemporalDepth);
float render_debug_custom_slot_3 =
    static_cast<float>(render_debug::Source::kSceneBeforeGrade);
float render_debug_channel = 0.f;
float render_debug_mapping = 0.f;
float render_debug_opacity = 100.f;
render_debug::RuntimeController render_debug_runtime_controller;
std::atomic_bool render_debug_temporal_replacement_active = false;
const std::vector<std::string> render_debug_source_labels = {
    "None",
    "DOF Coarse CoC",
    "DOF Full-resolution CoC",
    "DOF Near Alpha",
    "DOF Far Alpha",
    "DOF Gather/Fill Near + Far",
    "TAA Depth",
    "TAA Motion Vectors",
    "TAA History",
    "Scene Before Grade",
    "Scene After Grade",
    "Scene Luminance",
    "GTAO (Unavailable)",
    "Diffuse Lighting (Unavailable)",
    "Specular Lighting (Unavailable)",
    "Retinal Fixation (Unavailable)",
    "Retinal Eccentricity (Unavailable)",
    "Retinal Nyquist (Unavailable)",
    "Retinal Radius (Unavailable)",
    "DOF Vanilla Transition Control",
    "DOF Final Vanilla Transition",
};
std::once_flag dof_build_verification_once;
std::atomic_bool dof_supported_executable = false;
std::atomic_bool dof_device_reset_logged = false;
std::atomic_bool aspect_ratio_enabled = true;
std::atomic_uint32_t output_width = 0u;
std::atomic_uint32_t output_height = 0u;
HMODULE addon_module = nullptr;
std::atomic_bool addon_attached = false;
std::atomic_bool bootstrap_setup_attempted = false;
bool embedded_hooks_requested_at_startup = false;
std::atomic_bool embedded_hooks_active = false;
embedded_dlss::ExtensionCache initial_extension_cache;

std::filesystem::path GetModulePath(HMODULE module) {
  std::vector<wchar_t> path(1024u);
  for (;;) {
    const DWORD length = GetModuleFileNameW(
        module, path.data(), static_cast<DWORD>(path.size()));
    if (length == 0u) return {};
    if (length < path.size() - 1u) {
      return std::filesystem::path(std::wstring(path.data(), length));
    }
    path.resize(path.size() * 2u);
  }
}

std::string ReadConfigString(const char* section, const char* key) {
  std::size_t size = 0u;
  if (!reshade::get_config_value(nullptr, section, key, nullptr, &size) || size == 0u) {
    return {};
  }
  std::string value(size, '\0');
  if (!reshade::get_config_value(nullptr, section, key, value.data(), &size)) return {};
  value.resize(std::min(size, value.size()));
  while (!value.empty() && value.back() == '\0') value.pop_back();
  return value;
}

std::vector<std::string> ReadConfigArray(const char* section, const char* key) {
  std::size_t size = 0u;
  if (!reshade::get_config_value(nullptr, section, key, nullptr, &size) || size == 0u) {
    return {};
  }
  std::string raw(size, '\0');
  if (!reshade::get_config_value(nullptr, section, key, raw.data(), &size)) return {};
  std::vector<std::string> values;
  for (std::size_t offset = 0u; offset < raw.size();) {
    const std::size_t length = std::strlen(raw.c_str() + offset);
    if (length == 0u) break;
    values.emplace_back(raw.c_str() + offset, length);
    offset += length + 1u;
  }
  return values;
}

bool EnsureLoadFromDllMainEntry() {
  const auto filename = GetModulePath(addon_module).filename().string();
  if (filename.empty()) return false;
  auto values = ReadConfigArray("ADDON", "LoadFromDllMain");
  if (!embedded_dlss::MergeLoadFromDllMainEntry(&values, filename)) return true;
  std::string serialized;
  for (const auto& value : values) {
    serialized.append(value);
    serialized.push_back('\0');
  }
  reshade::set_config_value(
      nullptr, "ADDON", "LoadFromDllMain", serialized.data(), serialized.size());
  reshade::log::message(
      reshade::log::level::warning,
      "Detroit DLSS: added addon to ADDON.LoadFromDllMain; restart required.");
  return true;
}

embedded_dlss::ExtensionCache ReadExtensionCache() {
  embedded_dlss::ExtensionCache cache;
  int schema = 0;
  bool ready = false;
  (void)reshade::get_config_value(
      nullptr, "RENODX_DETROIT_DLSS", "BootstrapVersion", schema);
  (void)reshade::get_config_value(
      nullptr, "RENODX_DETROIT_DLSS", "BootstrapReady", ready);
  cache.schema_version = schema > 0 ? static_cast<std::uint32_t>(schema) : 0u;
  cache.ready = ready;
  cache.executable_sha256 =
      ReadConfigString("RENODX_DETROIT_DLSS", "ExecutableSha256");
  cache.instance_extensions =
      ReadConfigString("RENODX_DETROIT_DLSS", "InstanceExtensions");
  cache.device_extensions =
      ReadConfigString("RENODX_DETROIT_DLSS", "DeviceExtensions");
  return cache;
}

bool ReadStartupEmbeddedHookRequest() {
  float startup_dof_mode = 0.f;
  (void)reshade::get_config_value(
      nullptr, "renodx-preset1", "DepthOfFieldMode", startup_dof_mode);
  return embedded_dlss::NeedsEmbeddedBridge(
      DETROIT_DLSS_MODE_NATIVE,
      startup_dof_mode >= 2.5f);
}

void WriteExtensionCache(const embedded_dlss::ExtensionCache& cache) {
  reshade::set_config_value(
      nullptr, "RENODX_DETROIT_DLSS", "BootstrapReady", false);
  reshade::set_config_value(
      nullptr,
      "RENODX_DETROIT_DLSS",
      "BootstrapVersion",
      static_cast<int>(cache.schema_version));
  reshade::set_config_value(
      nullptr, "RENODX_DETROIT_DLSS", "ExecutableSha256", cache.executable_sha256.c_str());
  reshade::set_config_value(
      nullptr, "RENODX_DETROIT_DLSS", "InstanceExtensions", cache.instance_extensions.c_str());
  reshade::set_config_value(
      nullptr, "RENODX_DETROIT_DLSS", "DeviceExtensions", cache.device_extensions.c_str());
  reshade::set_config_value(
      nullptr, "RENODX_DETROIT_DLSS", "BootstrapReady", cache.ready);
}

struct ReShadeCaptureState {
  bool initialized = false;
  bool enabled = false;
  bool captured = false;
  bool automatic_postfix = true;
  DetroitDlssMode observed_mode = DETROIT_DLSS_MODE_NATIVE;
  std::uint64_t last_evaluation_serial = 0u;
  std::uint32_t stable_frames = 0u;
  std::uint32_t delay_seconds = RESHADE_CAPTURE_DEFAULT_DELAY_SECONDS;
  std::chrono::steady_clock::time_point stable_since;
  bool stable_since_valid = false;
  std::string postfix;
};

std::mutex reshade_capture_mutex;
ReShadeCaptureState reshade_capture;

void LogUltrawide(reshade::log::level level, const std::string& message) {
  reshade::log::message(level, ("Detroit ultrawide: " + message).c_str());
}

void LogReShadeCapture(reshade::log::level level, const std::string& message) {
  reshade::log::message(level, ("Detroit ReShade capture: " + message).c_str());
}

std::string GetDlssModePostfix(DetroitDlssMode mode) {
  switch (mode) {
    case DETROIT_DLSS_MODE_NATIVE:
      return "Native-TAA";
    case DETROIT_DLSS_MODE_DLAA:
      return "DLAA";
    default:
      return "Unknown-Mode";
  }
}

bool InitializeReShadeCaptureRequest() {
  std::scoped_lock lock(reshade_capture_mutex);
  if (reshade_capture.initialized) return reshade_capture.enabled;
  reshade_capture.initialized = true;

  std::array<char, 96u> value = {};
  const DWORD length = GetEnvironmentVariableA(
      RESHADE_CAPTURE_ENVIRONMENT,
      value.data(),
      static_cast<DWORD>(value.size()));
  if (length == 0u || length >= value.size()) return false;

  const std::string_view requested(value.data(), length);
  reshade_capture.enabled = true;
  reshade_capture.automatic_postfix = requested == "1" || requested == "auto";
  if (!reshade_capture.automatic_postfix) {
    reshade_capture.postfix.reserve(requested.size());
    for (const unsigned char character : requested) {
      const bool allowed = (character >= 'a' && character <= 'z')
                           || (character >= 'A' && character <= 'Z')
                           || (character >= '0' && character <= '9')
                           || character == '-' || character == '_';
      reshade_capture.postfix.push_back(allowed ? static_cast<char>(character)
                                                : '-');
    }
    if (reshade_capture.postfix.empty()) {
      reshade_capture.automatic_postfix = true;
    }
  }

  std::array<char, 16u> delay_value = {};
  const DWORD delay_length = GetEnvironmentVariableA(
      RESHADE_CAPTURE_DELAY_ENVIRONMENT,
      delay_value.data(),
      static_cast<DWORD>(delay_value.size()));
  if (delay_length != 0u && delay_length < delay_value.size()) {
    std::uint32_t requested_delay = 0u;
    const auto* begin = delay_value.data();
    const auto* end = begin + delay_length;
    const auto parse_result = std::from_chars(begin, end, requested_delay);
    if (parse_result.ec == std::errc{} && parse_result.ptr == end
        && requested_delay <= RESHADE_CAPTURE_MAX_DELAY_SECONDS) {
      reshade_capture.delay_seconds = requested_delay;
    } else {
      LogReShadeCapture(
          reshade::log::level::warning,
          std::format(
              "ignored invalid {} value '{}'; expected 0-{} seconds.",
              RESHADE_CAPTURE_DELAY_ENVIRONMENT,
              std::string_view(begin, delay_length),
              RESHADE_CAPTURE_MAX_DELAY_SECONDS));
    }
  }

  LogReShadeCapture(
      reshade::log::level::info,
      std::format(
          "one clean internal screenshot requested after {} stable frames and "
          "{} stable seconds.",
          RESHADE_CAPTURE_STABLE_FRAMES,
          reshade_capture.delay_seconds));
  temporal_capture::SetEvaluationSerialTracking(true);
  return true;
}


void StoreRuntimeFloat(volatile LONG* destination, float value) {
  const auto bits = std::bit_cast<std::uint32_t>(value);
  InterlockedExchange(destination, static_cast<LONG>(bits));
}

void RefreshUltrawideValues() {
  const auto values = ultrawide::CalculateActiveValues(
      output_width.load(std::memory_order_relaxed),
      output_height.load(std::memory_order_relaxed),
      aspect_ratio_enabled.load(std::memory_order_relaxed)
          && !ultrawide_force_vanilla.load(std::memory_order_relaxed));

  if (auto* runtime_data = ultrawide_runtime_data.load(std::memory_order_acquire);
      runtime_data != nullptr) {
    StoreRuntimeFloat(&runtime_data->aspect_ratio_bits, values.aspect_ratio);
    StoreRuntimeFloat(&runtime_data->ui_half_extent_bits, values.ui_half_extent);
  }
}

void ForceUltrawideRuntimeVanilla() {
  ultrawide_force_vanilla.store(true, std::memory_order_release);
  if (auto* runtime_data = ultrawide_runtime_data.load(std::memory_order_acquire);
      runtime_data != nullptr) {
    StoreRuntimeFloat(&runtime_data->aspect_ratio_bits, ultrawide::kVanillaAspect);
    StoreRuntimeFloat(
        &runtime_data->ui_half_extent_bits, ultrawide::kNativeUiHalfExtent);
  }
}

void ApplyAspectRatioMode(float selected_mode) {
  const bool enabled = selected_mode >= 0.5f;
  aspect_ratio_mode = enabled ? 1.f : 0.f;
  aspect_ratio_enabled.store(enabled, std::memory_order_relaxed);
  RefreshUltrawideValues();

  if (ultrawide_installed.load(std::memory_order_acquire)) {
    const auto width = output_width.load(std::memory_order_relaxed);
    const auto height = output_height.load(std::memory_order_relaxed);
    const auto values = ultrawide::CalculateActiveValues(
        width,
        height,
        enabled && !ultrawide_force_vanilla.load(std::memory_order_relaxed));
    LogUltrawide(
        reshade::log::level::info,
        std::format(
            "aspect mode changed: swapchain {}x{}, aspect {:.6f}, UI half-extent {:.6f}, mode {}.",
            width,
            height,
            values.aspect_ratio,
            values.ui_half_extent,
            enabled ? "Auto" : "Vanilla 16:9"));
  }
}

void OnAspectRatioModeChanged() {
  ApplyAspectRatioMode(aspect_ratio_mode);
}

void RefreshEmbeddedCommandTracking() {
  const bool requested = embedded_dlss::NeedsRuntimeCommandTracking(
      temporal_capture::GetMode(), dof_mode >= 2.5f);
  embedded_dlss::SetRuntimeCommandTracking(
      requested && embedded_hooks_active.load(std::memory_order_acquire));
}

void ApplyDlssMode(float selected_mode) {
  auto next_mode =
      renodx::games::detroitbecomehuman::dlss_policy::ParsePersistedDlssMode(
          selected_mode);
  if (!embedded_dlss::kDlssRuntimeEnabled) {
    next_mode = DETROIT_DLSS_MODE_NATIVE;
  }
  dlss_mode = static_cast<float>(next_mode);
  temporal_capture::SetMode(next_mode);
  RefreshEmbeddedCommandTracking();
}

void OnDlssModeChanged() {
  ApplyDlssMode(dlss_mode);
}

ultrawide::PatchOperationResult AtomicWriteRipDisplacement(
    std::uint8_t* destination,
    std::int32_t expected,
    std::int32_t replacement,
    DWORD& original_protection) {
  constexpr std::uintptr_t kAtomicWordSize = sizeof(LONG64);
  const auto destination_address = reinterpret_cast<std::uintptr_t>(destination);
  const auto atomic_address = destination_address & ~(kAtomicWordSize - 1u);
  const auto displacement_offset = destination_address - atomic_address;
  if (displacement_offset + sizeof(std::int32_t) > kAtomicWordSize) {
    LogUltrawide(
        reshade::log::level::error,
        "RIP displacement crosses an atomic 64-bit word boundary.");
    return {};
  }

  auto* atomic_word = reinterpret_cast<volatile LONG64*>(atomic_address);
  DWORD old_protection = 0;
  if (VirtualProtect(
          reinterpret_cast<void*>(atomic_address),
          kAtomicWordSize,
          PAGE_EXECUTE_READWRITE,
          &old_protection)
      == FALSE) {
    LogUltrawide(
        reshade::log::level::error,
        std::format("VirtualProtect failed before write (error {}).", GetLastError()));
    return {};
  }
  if (original_protection == 0u) original_protection = old_protection;

  ultrawide::PatchOperationResult result;
  const LONG64 observed = InterlockedCompareExchange64(atomic_word, 0, 0);
  std::int32_t observed_displacement = 0;
  std::memcpy(
      &observed_displacement,
      reinterpret_cast<const std::uint8_t*>(&observed) + displacement_offset,
      sizeof(observed_displacement));

  switch (ultrawide::DecideDisplacementWrite(
      observed_displacement, expected, replacement)) {
    case ultrawide::DisplacementWriteAction::kAlreadyReplaced:
      result.bytes_written = true;
      break;
    case ultrawide::DisplacementWriteAction::kWriteReplacement: {
      LONG64 desired = observed;
      std::memcpy(
          reinterpret_cast<std::uint8_t*>(&desired) + displacement_offset,
          &replacement,
          sizeof(replacement));
      result.bytes_written =
          InterlockedCompareExchange64(atomic_word, desired, observed) == observed;
      if (result.bytes_written) {
        FlushInstructionCache(
            GetCurrentProcess(),
            reinterpret_cast<const void*>(atomic_address),
            kAtomicWordSize);
      } else {
        LogUltrawide(
            reshade::log::level::error,
            "RIP displacement changed concurrently; atomic patch was refused.");
      }
      break;
    }
    case ultrawide::DisplacementWriteAction::kRefuse:
      LogUltrawide(
          reshade::log::level::error,
          "RIP displacement no longer has the expected value; atomic patch was refused.");
      break;
  }

  const DWORD final_protection = original_protection;
  DWORD ignored_protection = 0;
  result.final_protection_restored = VirtualProtect(
                                         reinterpret_cast<void*>(atomic_address),
                                         kAtomicWordSize,
                                         final_protection,
                                         &ignored_protection)
                                     != FALSE;
  if (!result.final_protection_restored) {
    LogUltrawide(
        reshade::log::level::error,
        std::format("VirtualProtect failed while restoring protection (error {}).", GetLastError()));
  }
  return result;
}

struct MainModuleText {
  std::uint8_t* module_base;
  std::span<const std::uint8_t> text;
};

std::optional<MainModuleText> GetSupportedMainModuleText() {
  auto* module_base = reinterpret_cast<std::uint8_t*>(GetModuleHandleW(nullptr));
  if (module_base == nullptr) return std::nullopt;

  const auto* dos_header = reinterpret_cast<const IMAGE_DOS_HEADER*>(module_base);
  if (dos_header->e_magic != IMAGE_DOS_SIGNATURE) return std::nullopt;

  const auto* nt_headers = reinterpret_cast<const IMAGE_NT_HEADERS64*>(
      module_base + dos_header->e_lfanew);
  if (nt_headers->Signature != IMAGE_NT_SIGNATURE
      || nt_headers->FileHeader.Machine != IMAGE_FILE_MACHINE_AMD64
      || nt_headers->OptionalHeader.Magic != IMAGE_NT_OPTIONAL_HDR64_MAGIC) {
    return std::nullopt;
  }

  if (nt_headers->FileHeader.TimeDateStamp != ultrawide::kSupportedExeTimestamp
      || nt_headers->OptionalHeader.SizeOfImage != ultrawide::kSupportedExeImageSize) {
    LogUltrawide(
        reshade::log::level::error,
        std::format(
            "unsupported DetroitBecomeHuman.exe (timestamp 0x{:08X}, image size 0x{:08X}).",
            nt_headers->FileHeader.TimeDateStamp,
            nt_headers->OptionalHeader.SizeOfImage));
    return std::nullopt;
  }

  const auto* section = IMAGE_FIRST_SECTION(nt_headers);
  for (std::uint16_t index = 0; index < nt_headers->FileHeader.NumberOfSections; ++index) {
    if (std::memcmp(section[index].Name, ".text", 5u) != 0) continue;
    return MainModuleText{
        .module_base = module_base,
        .text = std::span<const std::uint8_t>(
            module_base + section[index].VirtualAddress,
            section[index].Misc.VirtualSize),
    };
  }
  return std::nullopt;
}

std::uint8_t* FindUniquePattern(
    const MainModuleText& module,
    std::span<const ultrawide::PatternByte> pattern,
    const char* label) {
  const auto matches = ultrawide::FindPatternMatches(module.text, pattern);
  if (matches.size() != 1u) {
    LogUltrawide(
        reshade::log::level::error,
        std::format("{} signature matched {} times; aspect fix was not installed.", label, matches.size()));
    return nullptr;
  }
  return const_cast<std::uint8_t*>(module.text.data()) + matches.front();
}

void* AllocateNearPatchData(
    const MainModuleText& module,
    std::uintptr_t aspect_next_instruction,
    std::uintptr_t ui_next_instruction) {
  SYSTEM_INFO system_info = {};
  GetSystemInfo(&system_info);
  const auto allocation_granularity =
      static_cast<std::uintptr_t>(system_info.dwAllocationGranularity);
  const auto page_size = static_cast<std::size_t>(system_info.dwPageSize);
  const auto align_up = [allocation_granularity](std::uintptr_t value) {
    return (value + allocation_granularity - 1u) & ~(allocation_granularity - 1u);
  };

  auto cursor = align_up(
      reinterpret_cast<std::uintptr_t>(module.module_base) + ultrawide::kSupportedExeImageSize);
  const auto upper_bound =
      reinterpret_cast<std::uintptr_t>(module.module_base) + 0x70000000u;

  while (cursor < upper_bound) {
    MEMORY_BASIC_INFORMATION memory_info = {};
    if (VirtualQuery(
            reinterpret_cast<const void*>(cursor),
            &memory_info,
            sizeof(memory_info))
        == 0u) {
      break;
    }

    const auto region_base = reinterpret_cast<std::uintptr_t>(memory_info.BaseAddress);
    const auto region_end = region_base + memory_info.RegionSize;
    if (memory_info.State == MEM_FREE) {
      const auto candidate = align_up(region_base);
      if (candidate + page_size <= region_end
          && ultrawide::CalculateRipDisplacement(aspect_next_instruction, candidate).has_value()
          && ultrawide::CalculateRipDisplacement(
                 ui_next_instruction, candidate + sizeof(LONG))
                 .has_value()) {
        if (auto* allocation = VirtualAlloc(
                reinterpret_cast<void*>(candidate),
                page_size,
                MEM_RESERVE | MEM_COMMIT,
                PAGE_READWRITE);
            allocation != nullptr) {
          return allocation;
        }
      }
    }

    if (region_end <= cursor) break;
    cursor = region_end;
  }
  return nullptr;
}

bool InstallUltrawidePatch() {
  std::scoped_lock lock(ultrawide_patch_mutex);
  if (ultrawide_installed.load(std::memory_order_acquire)) return true;
  if (ultrawide_patch.active_patches[ultrawide::kAspectPatchIndex]
      || ultrawide_patch.active_patches[ultrawide::kUiPatchIndex]) {
    LogUltrawide(
        reshade::log::level::error,
        "a previous partial patch is still active; refusing another installation attempt.");
    return false;
  }

  const auto module = GetSupportedMainModuleText();
  if (!module.has_value()) {
    LogUltrawide(reshade::log::level::error, "supported main-module layout was not found.");
    return false;
  }

  auto* aspect_pattern = FindUniquePattern(
      module.value(), ultrawide::kAspectGetterPatch.pattern, "aspect getter");
  auto* ui_pattern = FindUniquePattern(
      module.value(), ultrawide::kUiHalfExtentPatch.pattern, "UI half-extent");
  if (aspect_pattern == nullptr || ui_pattern == nullptr) return false;

  auto* aspect_getter =
      aspect_pattern + ultrawide::kAspectGetterPatch.instruction_offset;
  auto* ui_half_extent_load =
      ui_pattern + ultrawide::kUiHalfExtentPatch.instruction_offset;
  if (std::memcmp(
          aspect_getter,
          ultrawide::kAspectGetterPatch.instruction.data(),
          ultrawide::kAspectGetterPatch.instruction.size())
          != 0
      || std::memcmp(
             ui_half_extent_load,
             ultrawide::kUiHalfExtentPatch.instruction.data(),
             ultrawide::kUiHalfExtentPatch.instruction.size())
             != 0) {
    LogUltrawide(reshade::log::level::error, "instruction validation failed.");
    return false;
  }

  UltrawidePatchState candidate;
  candidate.displacement_addresses[ultrawide::kAspectPatchIndex] =
      aspect_getter + ultrawide::kAspectGetterPatch.displacement_offset;
  candidate.displacement_addresses[ultrawide::kUiPatchIndex] =
      ui_half_extent_load + ultrawide::kUiHalfExtentPatch.displacement_offset;
  std::memcpy(
      &candidate.original_displacements[ultrawide::kAspectPatchIndex],
      candidate.displacement_addresses[ultrawide::kAspectPatchIndex],
      sizeof(std::int32_t));
  std::memcpy(
      &candidate.original_displacements[ultrawide::kUiPatchIndex],
      candidate.displacement_addresses[ultrawide::kUiPatchIndex],
      sizeof(std::int32_t));

  const auto aspect_original_target = reinterpret_cast<std::uintptr_t>(
                                          aspect_getter
                                          + ultrawide::kAspectGetterPatch.instruction.size())
                                      + candidate.original_displacements[ultrawide::kAspectPatchIndex];
  const auto ui_original_target = reinterpret_cast<std::uintptr_t>(
                                      ui_half_extent_load
                                      + ultrawide::kUiHalfExtentPatch.instruction.size())
                                  + candidate.original_displacements[ultrawide::kUiPatchIndex];
  if (aspect_original_target
          != reinterpret_cast<std::uintptr_t>(module->module_base)
                 + ultrawide::kAspectGetterPatch.expected_original_target_rva
      || ui_original_target
             != reinterpret_cast<std::uintptr_t>(module->module_base)
                    + ultrawide::kUiHalfExtentPatch.expected_original_target_rva) {
    LogUltrawide(
        reshade::log::level::error,
        "original RIP targets do not match Build 12158144; aspect fix was refused.");
    return false;
  }

  auto* runtime_data = static_cast<UltrawideRuntimeData*>(AllocateNearPatchData(
      module.value(),
      reinterpret_cast<std::uintptr_t>(
          aspect_getter + ultrawide::kAspectGetterPatch.instruction.size()),
      reinterpret_cast<std::uintptr_t>(
          ui_half_extent_load + ultrawide::kUiHalfExtentPatch.instruction.size())));
  if (runtime_data == nullptr) {
    LogUltrawide(reshade::log::level::error, "could not allocate RIP-relative runtime data.");
    return false;
  }

  candidate.runtime_data = runtime_data;
  ultrawide_runtime_data.store(runtime_data, std::memory_order_release);
  RefreshUltrawideValues();

  const auto aspect_displacement = ultrawide::CalculateRipDisplacement(
      reinterpret_cast<std::uintptr_t>(
          aspect_getter + ultrawide::kAspectGetterPatch.instruction.size()),
      reinterpret_cast<std::uintptr_t>(&runtime_data->aspect_ratio_bits));
  const auto ui_displacement = ultrawide::CalculateRipDisplacement(
      reinterpret_cast<std::uintptr_t>(
          ui_half_extent_load + ultrawide::kUiHalfExtentPatch.instruction.size()),
      reinterpret_cast<std::uintptr_t>(&runtime_data->ui_half_extent_bits));
  if (!aspect_displacement.has_value() || !ui_displacement.has_value()) {
    ultrawide_runtime_data.store(nullptr, std::memory_order_release);
    LogUltrawide(reshade::log::level::error, "allocated data is outside RIP-relative range.");
    return false;
  }

  candidate.redirected_displacements[ultrawide::kAspectPatchIndex] =
      aspect_displacement.value();
  candidate.redirected_displacements[ultrawide::kUiPatchIndex] =
      ui_displacement.value();

  const auto apply = [&candidate](std::size_t index) {
    return AtomicWriteRipDisplacement(
        candidate.displacement_addresses[index],
        candidate.original_displacements[index],
        candidate.redirected_displacements[index],
        candidate.original_protections[index]);
  };
  const auto restore = [&candidate](std::size_t index) {
    return AtomicWriteRipDisplacement(
        candidate.displacement_addresses[index],
        candidate.redirected_displacements[index],
        candidate.original_displacements[index],
        candidate.original_protections[index]);
  };

  if (!ultrawide::ApplyPatchTransaction(apply, restore, candidate.active_patches)) {
    const bool rollback_complete =
        !candidate.active_patches[ultrawide::kAspectPatchIndex]
        && !candidate.active_patches[ultrawide::kUiPatchIndex];
    if (rollback_complete) {
      ultrawide_runtime_data.store(nullptr, std::memory_order_release);
    } else {
      ForceUltrawideRuntimeVanilla();
      ultrawide_patch = candidate;
      LogUltrawide(
          reshade::log::level::error,
          "installation rollback was incomplete; remaining redirect points to safe vanilla values.");
    }
    return false;
  }

  ultrawide_patch = candidate;
  ultrawide_force_vanilla.store(false, std::memory_order_release);
  RefreshUltrawideValues();
  ultrawide_installed.store(true, std::memory_order_release);
  const auto width = output_width.load(std::memory_order_relaxed);
  const auto height = output_height.load(std::memory_order_relaxed);
  const auto values = ultrawide::CalculateActiveValues(
      width,
      height,
      aspect_ratio_enabled.load(std::memory_order_relaxed));
  LogUltrawide(
      reshade::log::level::info,
      std::format(
          "automatic override installed for Build 12158144: swapchain {}x{}, aspect {:.6f}, UI half-extent {:.6f}, mode {}.",
          width,
          height,
          values.aspect_ratio,
          values.ui_half_extent,
          aspect_ratio_enabled.load(std::memory_order_relaxed) ? "Auto" : "Vanilla 16:9"));
  return true;
}

void RestoreUltrawidePatch() {
  std::scoped_lock lock(ultrawide_patch_mutex);
  if (!ultrawide_patch.active_patches[ultrawide::kAspectPatchIndex]
      && !ultrawide_patch.active_patches[ultrawide::kUiPatchIndex]) {
    return;
  }

  ForceUltrawideRuntimeVanilla();

  const auto restore = [](std::size_t index) {
    return AtomicWriteRipDisplacement(
        ultrawide_patch.displacement_addresses[index],
        ultrawide_patch.redirected_displacements[index],
        ultrawide_patch.original_displacements[index],
        ultrawide_patch.original_protections[index]);
  };
  const bool restored = ultrawide::RestorePatchTransaction(
      restore, ultrawide_patch.active_patches);
  ultrawide_installed.store(false, std::memory_order_release);
  if (!restored) {
    LogUltrawide(
        reshade::log::level::error,
        "one or more original displacements could not be restored; safe vanilla data remains allocated.");
    return;
  }

  ultrawide_runtime_data.store(nullptr, std::memory_order_release);
  ultrawide_force_vanilla.store(false, std::memory_order_release);
  ultrawide_patch = {};
  LogUltrawide(
      reshade::log::level::info,
      "original aspect and UI half-extent instructions restored.");
}

ShaderInjectData shader_injection;
std::atomic_bool ui_path_seen = false;
std::atomic_uint64_t last_dlaa_sharpening_log_key =
    std::numeric_limits<std::uint64_t>::max();
std::atomic_uint64_t last_dof_log_key =
    std::numeric_limits<std::uint64_t>::max();

constexpr std::uint32_t RUNTIME_FLAG_DLSS_OUTPUT = 1u << 0u;
constexpr std::uint32_t RUNTIME_FLAG_PSYCHOV_BT2020 = 1u << 1u;
constexpr std::uint32_t RUNTIME_FLAG_EXPERIMENTAL_MOTION_BLUR = 1u << 2u;
constexpr std::uint32_t RUNTIME_FLAG_MASK =
    RUNTIME_FLAG_DLSS_OUTPUT | RUNTIME_FLAG_PSYCHOV_BT2020
    | RUNTIME_FLAG_EXPERIMENTAL_MOTION_BLUR;

std::uint32_t GetRuntimeFlags(const ShaderInjectData& injection) {
  if (!std::isfinite(injection.runtime_flags)) return 0u;
  return static_cast<std::uint32_t>(std::clamp(
      std::lround(injection.runtime_flags),
      0l,
      static_cast<long>(RUNTIME_FLAG_MASK)));
}

std::uint32_t GetRuntimeFlags() { return GetRuntimeFlags(shader_injection); }

void SetRuntimeFlag(
    ShaderInjectData& injection,
    std::uint32_t flag,
    bool enabled) {
  auto flags = GetRuntimeFlags(injection);
  flags = enabled ? (flags | flag) : (flags & ~flag);
  injection.runtime_flags = static_cast<float>(flags);
}

void SetRuntimeFlag(std::uint32_t flag, bool enabled) {
  SetRuntimeFlag(shader_injection, flag, enabled);
}

void OnExperimentalMotionBlurSettingsChanged() {
  SetRuntimeFlag(
      RUNTIME_FLAG_EXPERIMENTAL_MOTION_BLUR,
      experimental_motion_blur >= 0.5f);
}

bool ShouldWritePsychoVBt2020Intermediate() {
  const bool psychov_active = shader_injection.tone_map_type == 2.f
                              || shader_injection.tone_map_type == 3.f
                              || shader_injection.tone_map_type == 4.f;
  return shader_injection.output_is_hdr >= 0.5f
         && shader_injection.output_mode != OUTPUT_MODE_SDR
         && psychov_active
         && std::bit_cast<std::uint32_t>(
                shader_injection.scene_path_active)
                == 0u;
}

bool IsSharedHdrIntermediateTarget(
    reshade::api::command_list* command_list) {
  if (command_list == nullptr) return false;
  const auto& render_targets =
      renodx::utils::swapchain::GetRenderTargets(command_list);
  if (render_targets.empty() || render_targets.front().handle == 0u) {
    return false;
  }

  auto* device = command_list->get_device();
  const auto resource =
      device->get_resource_from_view(render_targets.front());
  if (resource.handle == 0u) return false;
  const auto description = device->get_resource_desc(resource);
  if (description.type != reshade::api::resource_type::texture_2d
      || description.texture.format
             != reshade::api::format::r16g16b16a16_float) {
    return false;
  }

  const auto expected_width =
      output_width.load(std::memory_order_relaxed);
  const auto expected_height =
      output_height.load(std::memory_order_relaxed);
  return (expected_width == 0u
          || description.texture.width == expected_width)
         && (expected_height == 0u
             || description.texture.height == expected_height);
}

bool OnSharedHdrUiReplace(reshade::api::command_list* command_list) {
  // Several Scaleform CRCs are also used for small RGBA8 offscreen textures.
  // Keep those draws native; the final compositor performs the single UI
  // brightness/primaries transform when it writes the shared HDR target.
  const bool replace = IsSharedHdrIntermediateTarget(command_list);
  if (replace) ui_path_seen.store(true, std::memory_order_relaxed);
  return replace;
}

std::string_view GetDofStatusText(dof::RuntimeStatus status) {
  switch (status) {
    case dof::RuntimeStatus::kVanilla:
      return "Vanilla";
    case dof::RuntimeStatus::kWaitingForChain:
      return "waiting for complete chain";
    case dof::RuntimeStatus::kIncompleteChain:
      return "incomplete chain fallback";
    case dof::RuntimeStatus::kActiveCleanBalanced:
      return "Clean Balanced";
    case dof::RuntimeStatus::kActiveCleanHigh:
      return "Clean High";
    case dof::RuntimeStatus::kActiveCinematicBalanced:
      return "Cinematic Balanced";
    case dof::RuntimeStatus::kActiveCinematicHigh:
      return "Cinematic High";
    case dof::RuntimeStatus::kActiveRetinalBalanced:
      return "Retinal Balanced";
    case dof::RuntimeStatus::kActiveRetinalHigh:
      return "Retinal High";
    case dof::RuntimeStatus::kUnsupportedBuild:
      return "unsupported build fallback";
  }
  return "unknown";
}

retinal::RunResult GetRetinalRunResult() noexcept {
  return retinal_run_result_state.Get();
}

retinal_observability::CaptureDiagnostic GetRetinalCaptureDiagnostic() noexcept {
  return retinal_capture_diagnostic_state.Get();
}

reshade::log::level GetRetinalLogLevel(
    retinal_observability::LogClass log_class) noexcept {
  switch (log_class) {
    case retinal_observability::LogClass::kInfo:
      return reshade::log::level::info;
    case retinal_observability::LogClass::kWarning:
      return reshade::log::level::warning;
    case retinal_observability::LogClass::kError:
      return reshade::log::level::error;
  }
  return reshade::log::level::warning;
}

void SetRetinalRunResult(retinal::RunResult result) {
  const auto transition = retinal_run_result_state.Update(result);
  if (!transition.changed) return;

  reshade::log::message(
      GetRetinalLogLevel(retinal_observability::GetLogClass(result)),
      std::format(
          "Detroit Retinal DOF: RunResult {} -> {}.",
          retinal_observability::GetRunResultText(transition.previous),
          retinal_observability::GetRunResultText(transition.current))
          .c_str());
}

void SetRetinalCaptureDiagnostic(
    retinal_observability::CaptureDiagnostic diagnostic) {
  const auto transition = retinal_capture_diagnostic_state.Update(diagnostic);
  if (!transition.changed) return;

  reshade::log::message(
      GetRetinalLogLevel(
          retinal_observability::GetLogClass(diagnostic.result)),
      std::format(
          "Detroit Retinal DOF: CaptureResult {} / {} -> {} / {}.",
          retinal_observability::GetCaptureResultText(
              transition.previous.result),
          retinal_observability::GetEmbeddedCaptureDetailText(
              transition.previous.embedded_detail),
          retinal_observability::GetCaptureResultText(
              transition.current.result),
          retinal_observability::GetEmbeddedCaptureDetailText(
              transition.current.embedded_detail))
          .c_str());
}

void LogDofStatus(const dof::FrameResult& result) {
  const auto log_key =
      (static_cast<std::uint64_t>(result.status) << 32u)
      | static_cast<std::uint64_t>(result.mode);
  if (last_dof_log_key.load(std::memory_order_relaxed) == log_key) return;
  if (last_dof_log_key.exchange(log_key, std::memory_order_acq_rel)
      == log_key) {
    return;
  }
  reshade::log::message(
      result.status == dof::RuntimeStatus::kIncompleteChain
              || result.status == dof::RuntimeStatus::kUnsupportedBuild
          ? reshade::log::level::warning
          : reshade::log::level::info,
      std::format(
          "Detroit DOF: {}, effective mode {}, observed pass mask 0x{:02X}.",
          GetDofStatusText(result.status),
          static_cast<std::uint32_t>(result.mode),
          result.observed_pass_mask)
          .c_str());
}

bool IsDofSupportedBuild() {
  std::call_once(dof_build_verification_once, []() {
    dof_supported_executable.store(
        embedded_dlss::VerifySupportedExecutable(),
        std::memory_order_release);
  });
  return dof_supported_executable.load(std::memory_order_acquire)
         && supported_build::kDofInputsEmpiricallyVerified;
}

void SetDofTrackingEnabled(bool enabled) {
  if (dof_tracking_enabled.load(std::memory_order_acquire) == enabled) return;
  dof_tracking_enabled.store(false, std::memory_order_release);
  dof_runtime_controller.Reset();
  dof_tracking_enabled.store(enabled, std::memory_order_release);
}

void UpdateDofRuntimeMode() {
  if (!dof_tracking_enabled.load(std::memory_order_acquire)) return;
  const auto requested_style = dof_mode >= 2.5f
                                   ? dof::RuntimeStyle::kRetinal
                               : dof_mode >= 1.5f
                                   ? dof::RuntimeStyle::kCinematic
                               : dof_mode >= 0.5f
                                   ? dof::RuntimeStyle::kClean
                                   : dof::RuntimeStyle::kVanilla;
  const auto result = dof_runtime_controller.FinishFrame(
      requested_style,
      dof_quality >= 0.5f,
      IsDofSupportedBuild());
  shader_injection.dof_runtime_mode = dof::PackRuntimePayload(
      result.mode,
      {
          .focus_distance_percent = dof_focus_distance,
          .blur_radius_percent = dof_blur_radius,
          .far_strength_percent = dof_far_strength,
          .vanilla_transition_percent = dof_vanilla_transition,
          .fill_edge_aware_coc = dof_fill_coc_reconstruction >= 0.5f,
          .fill_adaptive_transition = dof_fill_transition >= 0.5f,
          .fill_dense_rgb = dof_fill_rgb_reconstruction >= 0.5f,
      });
  LogDofStatus(result);
}

void OnDofSettingsChanged() {
  if (dof_mode >= 2.5f) {
    dof_mode = 2.f;
    retinal_mode_downgraded.store(true, std::memory_order_release);
    reshade::log::message(
        reshade::log::level::warning,
        "Detroit Retinal DOF: temporarily unavailable without global Vulkan interposition; using Cinematic.");
  }
  RefreshEmbeddedCommandTracking();
  const bool tracking_enabled = dof_mode >= 0.5f;
  SetDofTrackingEnabled(tracking_enabled);
  if (tracking_enabled) return;
  shader_injection.dof_runtime_mode =
      static_cast<float>(dof::RuntimeMode::kVanilla);
  LogDofStatus({});
}

render_debug::Source GetRenderDebugSource(float value) {
  const auto source = static_cast<std::uint32_t>(std::clamp(
      std::lround(value),
      0l,
      static_cast<long>(
          render_debug::Source::kDofVanillaTransitionContribution)));
  return static_cast<render_debug::Source>(source);
}

render_debug::Config GetRenderDebugConfig() {
  return {
      .mode = static_cast<render_debug::OverlayMode>(std::clamp(
          std::lround(render_debug_mode), 0l, 2l)),
      .dashboard = static_cast<render_debug::DashboardPreset>(std::clamp(
          std::lround(render_debug_dashboard), 0l, 6l)),
      .single_source = GetRenderDebugSource(render_debug_single_source),
      .custom_slots = {
          GetRenderDebugSource(render_debug_custom_slot_1),
          GetRenderDebugSource(render_debug_custom_slot_2),
          GetRenderDebugSource(render_debug_custom_slot_3),
      },
      .channel = static_cast<render_debug::Channel>(std::clamp(std::lround(render_debug_channel), 0l, 7l)),
      .mapping = static_cast<render_debug::Mapping>(std::clamp(std::lround(render_debug_mapping), 0l, 3l)),
      .opacity = std::clamp(render_debug_opacity * 0.01f, 0.f, 1.f),
      .temporal_source_unavailable = temporal_capture::GetMode() != DETROIT_DLSS_MODE_NATIVE,
  };
}

void OnRenderDebugSettingsChanged() {
  const auto config = GetRenderDebugConfig();
  render_debug_runtime_controller.SetConfig(config);
  render_debug_runtime_controller.ResetDevice();
  if (config.mode != render_debug::OverlayMode::kOff) return;
  render_debug_temporal_replacement_active.store(
      false, std::memory_order_release);
  shader_injection.scene_path_active = 0.f;
}

void UpdateRenderDebugRuntime() {
  if (render_debug_mode < 0.5f) return;
  render_debug_runtime_controller.SetConfig(GetRenderDebugConfig());
  const auto result = render_debug_runtime_controller.FinishFrame(
      IsDofSupportedBuild());
  shader_injection.scene_path_active = result.payload;
  render_debug_temporal_replacement_active.store(
      std::bit_cast<std::uint32_t>(result.payload) != 0u
          && (result.required_pass_mask
              & static_cast<std::uint32_t>(
                  render_debug::ProducerPass::kTemporal))
                 != 0u,
      std::memory_order_release);
}

bool RenderDebugSelectionUnavailable() {
  return render_debug::HasUnavailableSource(
      render_debug::Resolve(GetRenderDebugConfig()));
}

void ObserveDofPass(dof::Pass pass) {
  if (!dof_tracking_enabled.load(std::memory_order_acquire)) return;
  dof_runtime_controller.Observe(pass);
}

bool OnDofSplitDraw(reshade::api::command_list*) {
  ObserveDofPass(dof::Pass::kSplit);
  return true;
}

bool OnDofGatherDraw(reshade::api::command_list*) {
  ObserveDofPass(dof::Pass::kGather);
  return true;
}

bool OnDofFillDraw(reshade::api::command_list*) {
  ObserveDofPass(dof::Pass::kFill);
  return true;
}

[[maybe_unused]] void ApplyRetinalDofFilter(
    reshade::api::command_list* command_list) {
  const auto effective_mode = dof_runtime_controller.GetMode();
  if (!dof::IsRetinalMode(effective_mode)) {
    SetRetinalCaptureDiagnostic({});
    SetRetinalRunResult(retinal::RunResult::kNotRetinalMode);
    return;
  }
  if (std::bit_cast<std::uint32_t>(shader_injection.scene_path_active) != 0u) {
    // Diagnostics must show the producer data itself, not a subsequently
    // blurred visualization of it.
    SetRetinalCaptureDiagnostic({});
    SetRetinalRunResult(retinal::RunResult::kDebugOverlayActive);
    return;
  }
  const float retinal_effect_strength =
      std::isfinite(retinal_strength)
          ? std::clamp(retinal_strength * 0.01f, 0.f, 1.f)
          : 0.f;
  const float retinal_sigma =
      std::isfinite(retinal_maximum_sigma)
          ? std::clamp(
                retinal_maximum_sigma, 0.f, retinal::kMaximumSigmaPixels)
          : 0.f;
  if (retinal_effect_strength <= 0.f || retinal_sigma <= 0.f) {
    // A disabled retinal filter must be genuinely free: do not capture the
    // composite state, create resources, emit barriers or dispatch either
    // separable pass.
    SetRetinalCaptureDiagnostic({});
    SetRetinalRunResult(retinal::RunResult::kBypassedZeroEffect);
    return;
  }
  if (command_list == nullptr
      || retinal_force_disabled.load(std::memory_order_acquire)
      || !embedded_dlss::CanInsertComputeWriteBarrier(
          command_list->get_native())) {
    SetRetinalCaptureDiagnostic({});
    SetRetinalRunResult(retinal::RunResult::kBarrierUnavailable);
    return;
  }

  const auto capture = retinal_capture::CaptureCompositeOutput(command_list);
  SetRetinalCaptureDiagnostic({
      .result = capture.result,
      .embedded_detail = capture.embedded_detail,
  });
  if (!capture.IsValid()) {
    if (capture.result
        == retinal_capture::CaptureResult::kSnapshotReleaseFailed) {
      retinal_force_disabled.store(true, std::memory_order_release);
      if (!retinal_restore_failure_logged.exchange(
              true, std::memory_order_acq_rel)) {
        reshade::log::message(
            reshade::log::level::error,
            "Detroit Retinal DOF: Vulkan snapshot release failed; the post-filter is disabled until device recreation.");
      }
      SetRetinalRunResult(retinal::RunResult::kStateRestoreFailed);
      return;
    }
    SetRetinalRunResult(retinal::RunResult::kMissingCompositeCapture);
    return;
  }

  auto result = retinal_runtime.Run(
      command_list,
      {
          .output = capture.output,
          .effective_mode = effective_mode,
          .fixation_uv = {
              std::clamp(retinal_fixation_x * 0.01f, 0.f, 1.f),
              std::clamp(retinal_fixation_y * 0.01f, 0.f, 1.f),
          },
          .fixation_blend = retinal_effect_strength,
          .horizontal_screen_angle_degrees = retinal_horizontal_fov,
          .maximum_sigma_pixels = retinal_sigma,
      });
  bool barrier_restored = true;
  if (result == retinal::RunResult::kDispatched) {
    barrier_restored = embedded_dlss::InsertComputeWriteBarrier(
        command_list->get_native());
    if (!barrier_restored) {
      result = retinal::RunResult::kBarrierUnavailable;
    }
  }
  const bool state_restored = result == retinal::RunResult::kDispatched
                                      || result == retinal::RunResult::kBarrierUnavailable
                                  ? retinal_capture::RestoreCompositeState(
                                        capture, &shader_injection, sizeof(shader_injection))
                                  : retinal_capture::ReleaseCompositeState(capture);
  if (!state_restored) {
    result = retinal::RunResult::kStateRestoreFailed;
  }
  if (!barrier_restored || !state_restored) {
    retinal_force_disabled.store(true, std::memory_order_release);
    if (!retinal_restore_failure_logged.exchange(
            true, std::memory_order_acq_rel)) {
      reshade::log::message(
          reshade::log::level::error,
          "Detroit Retinal DOF: Vulkan barrier/state restore failed; the post-filter is disabled until device recreation.");
    }
  }
  SetRetinalRunResult(result);
}

void OnDofCompositeDrawn(reshade::api::command_list*) {
  ObserveDofPass(dof::Pass::kComposite);
  if (render_debug_mode >= 0.5f) {
    render_debug_runtime_controller.Observe(
        render_debug::ProducerPass::kDofComposite);
  }
}

struct DlaaSharpeningGate {
  DetroitDlssMode mode = DETROIT_DLSS_MODE_NATIVE;
  bool active = false;
  bool exact_command_list_match = false;
  float strength = 0.f;
};

struct EffectsApi {
  void (*sync_shader_injection)(
      std::uint64_t command_list,
      bool scene_composite,
      ShaderInjectData* destination);
  void (*sync_dlaa_sharpening)();
};

DlaaSharpeningGate GetDlaaSharpeningGate(std::uint64_t command_list) {
  const auto mode = temporal_capture::GetMode();
  if (renodx::games::detroitbecomehuman::temporal_mode_state::
          CanUseNativeModeFastPath(mode)) {
    return {.mode = mode};
  }
  const auto authorization =
      temporal_capture::QueryDlssOutputAuthorizationForCommandList(
          command_list);
  const bool exact_command_list_match = authorization.authorized;
  // Suppress native CAS only when this exact command list owns a valid output
  // from the current DLAA generation. A selected UI mode can still fall back to
  // native TAA while feature creation or adapter scratch is unavailable.
  const bool active =
      authorization.snapshot.mode == DETROIT_DLSS_MODE_DLAA
      && exact_command_list_match;
  return {
      .mode = authorization.snapshot.mode,
      .active = active,
      .exact_command_list_match = exact_command_list_match,
      .strength = active ? std::clamp(dlaa_sharpening, 0.f, 1.f) : 0.f,
  };
}

void SyncDlaaSharpening() {
  if constexpr (!kEffectsAddon) {
    if (addon_shared.data == nullptr) return;
    const float normalization = std::max(
        shader_injection.peak_white_nits
            / std::max(shader_injection.diffuse_white_nits, 1.f),
        1.f);
    addon_shared.data->hdr_sharpening_normalization.store(
        std::bit_cast<std::uint32_t>(normalization),
        std::memory_order_release);
    if (const auto* api = addon_shared.data->effects_api.load(
            std::memory_order_acquire);
        api != nullptr) {
      api->sync_dlaa_sharpening();
    }
    return;
  }

  const float normalization = addon_shared.data == nullptr
                                  ? 1.f
                                  : std::bit_cast<float>(
                                        addon_shared.data
                                            ->hdr_sharpening_normalization.load(
                                                std::memory_order_acquire));
  temporal_capture::SetDlaaSharpening(
      std::clamp(dlaa_sharpening, 0.f, 1.f),
      std::max(normalization, 1.f));
}

#ifdef DETROIT_EFFECTS_ADDON
void ApplyDlssOutputMarker(
    std::uint64_t command_list,
    std::string_view pass_name,
    bool log_gate,
    ShaderInjectData* destination) {
  const auto gate = GetDlaaSharpeningGate(command_list);
  // The late scene/OETF shaders only need a boolean marker to suppress
  // Detroit's optional native CAS. Sharpening strength is transferred through
  // TemporalFrameInputs and consumed by the pre-DOF adapter pack instead.
  SetRuntimeFlag(RUNTIME_FLAG_DLSS_OUTPUT, gate.active);
  if (destination != nullptr && destination != &shader_injection) {
    SetRuntimeFlag(*destination, RUNTIME_FLAG_DLSS_OUTPUT, gate.active);
  }

  if (!log_gate) return;
  const auto strength_percent = static_cast<std::uint32_t>(
      std::lround(gate.strength * 100.f));
  // Dragging an ImGui slider can otherwise emit one line per rendered frame.
  // Endpoint telemetry is enough to prove both passthrough and full RCAS.
  if (gate.active && strength_percent != 0u && strength_percent != 100u) {
    return;
  }
  // The temporal pass can legitimately report fallback and success for
  // different command lists recorded in the same frame. Neither that runtime
  // status nor the exact-list diagnostic changes the configured strength. Keep
  // them out of the deduplication key so the render thread cannot turn an
  // expected 5 <-> 6 transition into synchronous per-frame log I/O.
  const auto log_key = temporal_capture::MakeTelemetryKey(
      static_cast<std::uint32_t>(gate.mode),
      gate.active,
      strength_percent);
  if (last_dlaa_sharpening_log_key.load(std::memory_order_relaxed) == log_key) {
    return;
  }
  if (last_dlaa_sharpening_log_key.exchange(
          log_key,
          std::memory_order_acq_rel)
      == log_key) {
    return;
  }
  reshade::log::message(
      reshade::log::level::info,
      std::format(
          "Detroit DLAA sharpening: pre-DOF adapter RCAS configured at {}%, {} marker {}, exact command-list match {}, runtime status {}.",
          strength_percent,
          pass_name,
          gate.active ? "active" : "inactive",
          gate.exact_command_list_match ? "yes" : "no",
          static_cast<std::uint32_t>(temporal_capture::GetStatus()))
          .c_str());
}

void SyncEffectsForHdr(
    std::uint64_t command_list,
    bool scene_composite,
    ShaderInjectData* destination) {
  if (destination == nullptr) return;
  if (scene_composite) {
    if (command_list != 0u) {
      temporal_capture::MarkMainTemporalCommandList(command_list);
    }
    if (render_debug_mode >= 0.5f) {
      render_debug_runtime_controller.Observe(
          render_debug::ProducerPass::kSceneComposite);
    }
    destination->scene_path_active = shader_injection.scene_path_active;
  }
  ApplyDlssOutputMarker(
      command_list,
      scene_composite ? "scene composite" : "native CAS suppression",
      scene_composite,
      destination);
}

const EffectsApi effects_api = {
    .sync_shader_injection = &SyncEffectsForHdr,
    .sync_dlaa_sharpening = &SyncDlaaSharpening,
};

#else
void SyncHdrShaderInjection(
    reshade::api::command_list* command_list,
    bool scene_composite) {
  const auto native = command_list != nullptr ? command_list->get_native() : 0u;
  if (addon_shared.data != nullptr) {
    if (const auto* api = addon_shared.data->effects_api.load(
            std::memory_order_acquire);
        api != nullptr) {
      api->sync_shader_injection(native, scene_composite, &shader_injection);
      return;
    }
  }
  SetRuntimeFlag(RUNTIME_FLAG_DLSS_OUTPUT, false);
  if (scene_composite) shader_injection.scene_path_active = 0.f;
}

bool OnSceneDraw(reshade::api::command_list* command_list) {
  SyncHdrShaderInjection(command_list, true);
  SetRuntimeFlag(
      RUNTIME_FLAG_PSYCHOV_BT2020,
      ShouldWritePsychoVBt2020Intermediate());
  return true;
}

bool OnFinalCasDraw(reshade::api::command_list* command_list) {
  // The adapter pack owns DLAA sharpening. This optional native CAS variant
  // only needs the same mode marker so its own late lobe can be disabled.
  SyncHdrShaderInjection(command_list, false);
  return true;
}
#endif

bool OnTemporalAuxiliaryReplace(reshade::api::command_list* command_list) {
  if (render_debug_mode >= 0.5f) {
    render_debug_runtime_controller.Observe(
        render_debug::ProducerPass::kTemporal);
  }
  if (temporal_capture::RequestAuxiliaryTemporalReplacement(command_list)) {
    return true;
  }
  return command_list != nullptr
         && temporal_capture::GetMode() == DETROIT_DLSS_MODE_NATIVE
         && render_debug_temporal_replacement_active.load(
             std::memory_order_acquire);
}

bool IsHdrOutputColorSpace(reshade::api::color_space color_space) {
  return color_space == reshade::api::color_space::hdr10_st2084
         || color_space == reshade::api::color_space::hdr10_hlg
         || color_space == reshade::api::color_space::extended_srgb_linear;
}

std::string WideStringToUtf8(const wchar_t* value) {
  if (value == nullptr || *value == L'\0') return {};
  const int required_size = WideCharToMultiByte(
      CP_UTF8, 0, value, -1, nullptr, 0, nullptr, nullptr);
  if (required_size <= 1) return {};

  std::string result(static_cast<std::size_t>(required_size), '\0');
  if (WideCharToMultiByte(
          CP_UTF8,
          0,
          value,
          -1,
          result.data(),
          required_size,
          nullptr,
          nullptr)
      <= 0) {
    return {};
  }
  result.pop_back();
  return result;
}

std::string GetDisplayName(const DXGI_OUTPUT_DESC1& output_desc) {
  DISPLAY_DEVICEW display_device = {};
  display_device.cb = sizeof(display_device);
  if (EnumDisplayDevicesW(
          output_desc.DeviceName, 0u, &display_device, 0u)) {
    if (auto name = WideStringToUtf8(display_device.DeviceString);
        !name.empty()) {
      return name;
    }
  }
  if (auto name = WideStringToUtf8(output_desc.DeviceName); !name.empty()) {
    return name;
  }
  return "unknown display";
}

void SetPeakBrightnessStatus(
    std::string status_text,
    reshade::log::level log_level,
    bool log_change) {
  const bool changed = status_text != peak_brightness_status;
  peak_brightness_status = std::move(status_text);
  if (auto* status =
          renodx::utils::settings::FindSetting("PeakBrightnessStatus");
      status != nullptr) {
    status->label = peak_brightness_status;
  }
  if (changed && log_change) {
    reshade::log::message(log_level, peak_brightness_status.c_str());
  }
}

void ApplyPeakBrightness(
    const peak_brightness::Resolution& resolution,
    std::string status_text,
    reshade::log::level log_level,
    bool log_change) {
  if (shader_injection.peak_white_nits
      != resolution.effective_peak_nits) {
    shader_injection.peak_white_nits = resolution.effective_peak_nits;
    SyncDlaaSharpening();
  }
  SetPeakBrightnessStatus(
      std::move(status_text), log_level, log_change);
}

void UpdatePeakBrightness(
    reshade::api::swapchain* swapchain,
    bool force_refresh) {
  const auto source =
      peak_brightness::ParseSource(peak_brightness_source);
  if (source == peak_brightness::Source::kManual) {
    const auto resolution = peak_brightness::Resolve(
        source, manual_peak_nits, detected_peak_nits);
    ApplyPeakBrightness(
        resolution,
        std::format(
            "Manual: {:.0f} nits effective (saved ToneMapPeakNits; DXGI polling is disabled).",
            resolution.effective_peak_nits),
        reshade::log::level::info,
        false);
    return;
  }

  if (swapchain == nullptr) {
    detected_output_desc.reset();
    detected_peak_nits.reset();
    const auto resolution = peak_brightness::Resolve(
        source, manual_peak_nits, detected_peak_nits);
    ApplyPeakBrightness(
        resolution,
        "Auto: waiting for the Vulkan swapchain; effective peak is 1000 nits fallback.",
        reshade::log::level::info,
        false);
    return;
  }

  const auto window = static_cast<HWND>(swapchain->get_hwnd());
  const HMONITOR monitor = window == nullptr
                               ? nullptr
                               : MonitorFromWindow(window, MONITOR_DEFAULTTONEAREST);
  const bool output_is_hdr =
      IsHdrOutputColorSpace(swapchain->get_color_space());
  const bool refresh_requested =
      peak_brightness_refresh_requested.exchange(
          false, std::memory_order_acq_rel);
  if (!peak_brightness_refresh.ShouldRefresh(
          source,
          reinterpret_cast<std::uintptr_t>(monitor),
          output_is_hdr,
          peak_brightness::RefreshController::Clock::now(),
          force_refresh || refresh_requested)) {
    return;
  }

  detected_output_desc =
      renodx::utils::swapchain::GetDirectXOutputDesc1(window);
  detected_peak_nits = detected_output_desc.has_value()
                           ? renodx::utils::swapchain::GetPeakNits(*detected_output_desc)
                           : std::nullopt;
  const auto resolution = peak_brightness::Resolve(
      source, manual_peak_nits, detected_peak_nits);

  if (!detected_output_desc.has_value()) {
    ApplyPeakBrightness(
        resolution,
        "Auto detection failed: no DXGI output matched the Vulkan HWND/HMONITOR; effective peak is 1000 nits fallback.",
        reshade::log::level::warning,
        true);
    return;
  }

  const auto& output_desc = *detected_output_desc;
  const auto display_name = GetDisplayName(output_desc);
  if (!detected_peak_nits.has_value()) {
    ApplyPeakBrightness(
        resolution,
        std::format(
            "Auto detection failed on {}: DXGI MaxLuminance {:.2f} nits, color space {}; effective peak is 1000 nits fallback.",
            display_name,
            output_desc.MaxLuminance,
            static_cast<int>(output_desc.ColorSpace)),
        reshade::log::level::warning,
        true);
    return;
  }

  ApplyPeakBrightness(
      resolution,
      std::format(
          "Auto: {:.0f} nits effective from DXGI MaxLuminance on {} (min {:.4f}, full-frame {:.0f} nits).",
          resolution.effective_peak_nits,
          display_name,
          output_desc.MinLuminance,
          output_desc.MaxFullFrameLuminance),
      reshade::log::level::info,
      true);
}

void OnPeakBrightnessSettingsChanged() {
  peak_brightness_refresh_requested.store(true, std::memory_order_release);
  const auto source =
      peak_brightness::ParseSource(peak_brightness_source);
  if (source == peak_brightness::Source::kManual) {
    UpdatePeakBrightness(nullptr, false);
    return;
  }

  const auto resolution = peak_brightness::Resolve(
      source, manual_peak_nits, detected_peak_nits);
  ApplyPeakBrightness(
      resolution,
      std::format(
          "Auto: refreshing DXGI display metadata; current effective peak is {:.0f} nits{}.",
          resolution.effective_peak_nits,
          resolution.used_fallback ? " fallback" : ""),
      reshade::log::level::info,
      false);
}

#ifdef DETROIT_EFFECTS_ADDON
renodx::mods::shader::CustomShaders effect_shaders = {
    {supported_build::kMotionBlurShaderCrc, {
                                                .crc32 = supported_build::kMotionBlurShaderCrc,
                                                .code = __0xC03380A0,
                                            }},
    {supported_build::kDofSplitShaderCrc, {
                                              .crc32 = supported_build::kDofSplitShaderCrc,
                                              .code = __0xE9907978,
                                              .on_draw = &OnDofSplitDraw,
                                          }},
    {supported_build::kDofGatherShaderCrc, {
                                               .crc32 = supported_build::kDofGatherShaderCrc,
                                               .code = __0x747E19D2,
                                               .on_draw = &OnDofGatherDraw,
                                           }},
    {supported_build::kDofFillShaderCrc, {
                                             .crc32 = supported_build::kDofFillShaderCrc,
                                             .code = __0x508514FB,
                                             .on_draw = &OnDofFillDraw,
                                         }},
    {supported_build::kDofCompositeShaderCrc, {
                                                  .crc32 = supported_build::kDofCompositeShaderCrc,
                                                  .code = __0xAC7A8193,
                                                  .on_drawn = &OnDofCompositeDrawn,
                                              }},
    {supported_build::kTemporalAaShaderCrc, {
                                                .crc32 = supported_build::kTemporalAaShaderCrc,
                                                .code = __temporal_aux_exact,
                                                .on_replace = &OnTemporalAuxiliaryReplace,
                                            }},
};
#else
renodx::mods::shader::CustomShaders hdr_shaders = {
    {0xEBFBDDB1, {
                     .crc32 = 0xEBFBDDB1,
                     .code = __0xEBFBDDB1,
                     .on_draw = &OnSceneDraw,
                 }},
    {0x2892BFCA, {
                     .crc32 = 0x2892BFCA,
                     .code = __0x2892BFCA,
                     .on_replace = &OnSharedHdrUiReplace,
                 }},
    {0x8808E4CC, {
                     .crc32 = 0x8808E4CC,
                     .code = __0x8808E4CC,
                     .on_replace = &OnSharedHdrUiReplace,
                 }},
    {0x9827B559, {
                     .crc32 = 0x9827B559,
                     .code = __0x9827B559,
                     .on_replace = &OnSharedHdrUiReplace,
                 }},
    {0x11C1C2C5, {
                     .crc32 = 0x11C1C2C5,
                     .code = __0x11C1C2C5,
                     .on_replace = &OnSharedHdrUiReplace,
                 }},
    {0x97874322, {
                     .crc32 = 0x97874322,
                     .code = __0x97874322,
                     .on_replace = &OnSharedHdrUiReplace,
                 }},
    {0xC5B9F7FA, {
                     .crc32 = 0xC5B9F7FA,
                     .code = __0xC5B9F7FA,
                     .on_replace = &OnSharedHdrUiReplace,
                 }},
    {0xEF606BCD, {
                     .crc32 = 0xEF606BCD,
                     .code = __0xEF606BCD,
                     .on_replace = &OnSharedHdrUiReplace,
                 }},
    {0x94F97DCF, {
                     .crc32 = 0x94F97DCF,
                     .code = __0x94F97DCF,
                     .on_draw = &OnFinalCasDraw,
                 }},
    {0xF478AFEF, {
                     .crc32 = 0xF478AFEF,
                     .code = __0xF478AFEF,
                 }},
};
#endif

constexpr int MigrateLegacyToneMapType(int legacy_value) {
  switch (legacy_value) {
    case 0:  // Vanilla
      return 0;
    case 1:  // Removed Reinhard
    case 2:  // RenoDRT
      return 1;
    case 3:  // PsychoV-17
      return 2;
    case 4:  // PsychoV-22
      return 3;
    case 5:  // PsychoV-24
      return 4;
    default:
      return 1;
  }
}

void MigrateToneMapTypeSettings() {
  for (const char* section : {
           "renodx-preset1",
           "renodx-preset2",
           "renodx-preset3",
       }) {
    int current_value = 0;
    if (reshade::get_config_value(
            nullptr, section, "ToneMapTypeV2", current_value)) {
      continue;
    }

    int legacy_value = 0;
    if (!reshade::get_config_value(
            nullptr, section, "ToneMapType", legacy_value)) {
      continue;
    }
    reshade::set_config_value(
        nullptr,
        section,
        "ToneMapTypeV2",
        MigrateLegacyToneMapType(legacy_value));
  }
}

renodx::utils::settings::Settings settings =
    renodx::templates::settings::JoinSettings({
#ifndef DETROIT_EFFECTS_ADDON
        []() {
          auto default_settings =
              renodx::templates::settings::CreateDefaultSettings({
                  {"ToneMapType",
                   {
                       .key = "ToneMapTypeV2",
                       .binding = &shader_injection.tone_map_type,
                       .default_value = 1.f,
                       .labels = {"Vanilla", "RenoDRT", "PsychoV-17", "PsychoV-22", "PsychoV-24"},
                       .parse = [](float value) { return value; },
                   }},
                  {"ToneMapPeakNits",
                   {
                       .binding = &manual_peak_nits,
                       .default_value = 1000.f,
                       .can_reset = false,
                       .label = "Manual Peak Brightness",
                       .tooltip = "Saved manual peak in nits. Auto detection never overwrites this value.",
                       .is_enabled = []() { return peak_brightness::ParseSource(
                                                       peak_brightness_source)
                                                   == peak_brightness::Source::kManual; },
                       .on_change_value = [](float, float) { OnPeakBrightnessSettingsChanged(); },
                   }},
                  {"ToneMapGameNits",
                   {
                       .binding = &shader_injection.diffuse_white_nits,
                       .default_value = 203.f,
                       .on_change_value = [](float, float) { SyncDlaaSharpening(); },
                   }},
                  {"ToneMapUINits",
                   {
                       .binding = &shader_injection.graphics_white_nits,
                       .default_value = 203.f,
                       .is_visible = []() {
                         return shader_injection.ui_path_active != 0.f;
                       },
                   }},
                  {"ColorGradeExposure", {.binding = &shader_injection.tone_map_exposure}},
                  {"ColorGradeHighlights", {.binding = &shader_injection.tone_map_highlights}},
                  {"ColorGradeShadows", {.binding = &shader_injection.tone_map_shadows}},
                  {"ColorGradeContrast", {.binding = &shader_injection.tone_map_contrast}},
                  {"ColorGradeSaturation", {.binding = &shader_injection.tone_map_saturation}},
                  {"ColorGradeHighlightSaturation", {
                                                        .binding = &shader_injection.tone_map_highlight_saturation,
                                                        .is_visible = []() {
                                                          return renodx::templates::settings::current_settings_mode >= 1.f
                                                                 && shader_injection.tone_map_type < 2.f;
                                                        },
                                                    }},
                  {"ColorGradeBlowout", {
                                            .binding = &shader_injection.tone_map_blowout,
                                            .is_visible = []() {
                                              return renodx::templates::settings::current_settings_mode >= 1.f
                                                     && shader_injection.tone_map_type < 2.f;
                                            },
                                        }},
                  {"ColorGradeFlare", {
                                          .binding = &shader_injection.tone_map_flare,
                                          .is_visible = []() {
                                            return renodx::templates::settings::current_settings_mode >= 1.f
                                                   && shader_injection.tone_map_type < 2.f;
                                          },
                                      }},
                  {"SceneGradeStrength", {
                                             .binding = &shader_injection.color_grade_strength,
                                             .default_value = 100.f,
                                             .label = "Scene Grading",
                                             .section = "Color Grading",
                                             .tooltip = "Strength of Detroit's original scene color grading.",
                                             .parse = [](float value) { return value * 0.01f; },
                                         }},
              });
          default_settings.insert(
              default_settings.begin() + 2,
              renodx::templates::settings::CreateSetting({
                  .key = "PeakBrightnessSource",
                  .binding = &peak_brightness_source,
                  .value_type =
                      renodx::utils::settings::SettingValueType::INTEGER,
                  .default_value = 0.f,
                  .can_reset = true,
                  .label = "Peak Brightness Source",
                  .section = "Tone Mapping",
                  .tooltip = "Auto reads DXGI MaxLuminance for the monitor containing Detroit's Vulkan window.",
                  .labels = {"Auto", "Manual"},
                  .on_change_value = [](float, float) {
                    OnPeakBrightnessSettingsChanged();
                  },
              }));
          default_settings.insert(
              default_settings.begin() + 4,
              renodx::templates::settings::CreateSetting({
                  .key = "PeakBrightnessStatus",
                  .value_type =
                      renodx::utils::settings::SettingValueType::TEXT,
                  .can_reset = false,
                  .label = peak_brightness_status,
                  .section = "Tone Mapping",
              }));
          return default_settings;
        }(),
        renodx::templates::settings::CreateSettings({
            {{
                .key = "ColorGradeConeResponse",
                .binding = &shader_injection.psychov_cone_response,
                .default_value = 50.f,
                .label = "Cone Response",
                .section = "Color Grading",
                .tooltip = "Controls the PsychoV cone response shaping.",
                .min = 0.f,
                .max = 100.f,
                .parse = [](float value) { return value * 0.02f; },
                .is_visible = []() { return shader_injection.tone_map_type >= 2.f; },
            }},
            {{
                .key = "ToneMapPsychoVExposureMatch",
                .binding = &shader_injection.psychov_exposure_match,
                .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
                .default_value = 1.f,
                .label = "Exposure Match",
                .section = "Color Grading",
                .tooltip = "Matches PsychoV's 18% gray anchor to Detroit's neutral scene-grading output.",
                .is_visible = []() {
                  return shader_injection.tone_map_type >= 2.f;
                },
            }},
            {{
                .key = "ToneMapPsychoVVanillaHDRSlope",
                .binding = &shader_injection.psychov_vanilla_slope,
                .default_value = 100.f,
                .label = "Vanilla HDR Slope",
                .section = "Color Grading",
                .tooltip = "Blends PsychoV cone response from native to Detroit's neutral scene-grading slope.",
                .min = 0.f,
                .max = 100.f,
                .parse = [](float value) { return value * 0.01f; },
                .is_visible = []() { return shader_injection.tone_map_type >= 2.f; },
            }},
        }),
#endif
        renodx::templates::settings::CreateSettings({
#ifdef DETROIT_EFFECTS_ADDON
            {{
                .key = "DepthOfFieldMode",
                .binding = &dof_mode,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = 0.f,
                .can_reset = true,
                .label = "Depth of Field",
                .section = "Depth of Field",
                .tooltip = "Vanilla is the exact reference path. Enhanced styles apply custom focus and radius before Detroit's authored Split/Gather/Fill chain. Clean uses precise full-resolution CoC visibility, Cinematic restores authored far coverage, and High reconstructs small CoC from full-resolution color.",
                .labels = {"Vanilla", "Clean", "Cinematic"},
                .on_change_value = [](float, float current) {
                  dof_mode = current;
                  OnDofSettingsChanged();
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Saved Retinal DOF was changed to Cinematic. Retinal remains preserved for a later targeted redesign.",
                .section = "Depth of Field",
                .is_visible = []() {
                  return retinal_mode_downgraded.load(std::memory_order_acquire);
                },
            }},
            {{
                .key = "DepthOfFieldQuality",
                .binding = &dof_quality,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = 1.f,
                .can_reset = true,
                .label = "DOF Quality",
                .section = "Depth of Field",
                .tooltip = "Detroit's Gather keeps its complete authored 49-tap aperture kernel in both modes. Balanced keeps the original reduced-resolution resolve. High adds a depth/CoC-aware full-resolution 3x3 color bridge and overlaps it smoothly with the authored FarDofMap across small blur radii. Retinal additionally uses paired hardware-linear Gaussian taps.",
                .labels = {"Balanced", "High"},
                .is_enabled = []() { return dof_mode >= 0.5f; },
                .on_change_value = [](float, float current) { dof_quality = current; },
            }},
            {{
                .key = "DepthOfFieldFocusDistance",
                .binding = &dof_focus_distance,
                .default_value = 100.f,
                .can_reset = true,
                .label = "Focus Distance",
                .section = "Depth of Field",
                .tooltip = "Scales Detroit's authored focal distance. It is ignored by Vanilla.",
                .min = 0.f,
                .max = 200.f,
                .format = "%.0f%%",
                .is_enabled = []() { return dof_mode >= 0.5f; },
            }},
            {{
                .key = "DepthOfFieldBlurRadius",
                .binding = &dof_blur_radius,
                .default_value = 100.f,
                .can_reset = true,
                .label = "Blur Radius",
                .section = "Depth of Field",
                .tooltip = "Scales the full-resolution Circle of Confusion radius. It is ignored by Vanilla.",
                .min = 0.f,
                .max = 200.f,
                .format = "%.0f%%",
                .is_enabled = []() { return dof_mode >= 0.5f; },
            }},
            {{
                .key = "DepthOfFieldFarStrength",
                .binding = &dof_far_strength,
                .default_value = 100.f,
                .can_reset = true,
                .label = "Background Bokeh",
                .section = "Depth of Field",
                .tooltip = "Scales far-layer blur coverage without changing its focal boundary. It is ignored by Vanilla.",
                .min = 0.f,
                .max = 200.f,
                .format = "%.0f%%",
                .is_enabled = []() { return dof_mode >= 0.5f; },
            }},
            {{
                .key = "DepthOfFieldVanillaTransition",
                .binding = &dof_vanilla_transition,
                .default_value = 100.f,
                .can_reset = true,
                .label = "Vanilla Transition Blend",
                .section = "Depth of Field",
                .tooltip = "Blends from Clean's precise full-resolution visibility to Detroit's authored Gather coverage. The fractional R8 alpha preserved by Fill is used without spatial blur; High separately uses a full-resolution 3x3 color bridge for small CoC, while full-resolution CoC keeps focused foreground pixels outside the far layer. Clean and Vanilla ignore it.",
                .min = 0.f,
                .max = 100.f,
                .format = "%.0f%%",
                .is_enabled = []() { return dof_mode >= 1.5f; },
            }},
            {{
                .key = "DepthOfFieldFillCocReconstruction",
                .binding = &dof_fill_coc_reconstruction,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = 0.f,
                .can_reset = true,
                .label = "Fill CoC Reconstruction",
                .section = "Depth of Field - Fill Quality",
                .tooltip = "Bilinear (Current) reconstructs High Fill from four coarse CoC texels. Edge-aware 3x3 adds a monotonic nine-tap reconstruction and rejects incompatible coarse values. Fill has no full-resolution depth binding, so this changes hidden-background RGB radius only and never authored Gather alpha.",
                .labels = {"Bilinear (Current)", "Edge-aware 3x3"},
                .is_enabled = []() {
                  return dof_mode >= 0.5f && dof_quality >= 0.5f;
                },
            }},
            {{
                .key = "DepthOfFieldFillTransition",
                .binding = &dof_fill_transition,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = 0.f,
                .can_reset = true,
                .label = "Fill Transition",
                .section = "Depth of Field - Fill Quality",
                .tooltip = "Fixed 2-4 (Current) keeps the validated smoothstep range. Adaptive narrows it on smooth coarse CoC and widens it at strong gradients. It blends hidden-background RGB only; authored aperture coverage remains unchanged.",
                .labels = {"Fixed 2-4 (Current)", "Adaptive"},
                .is_enabled = []() {
                  return dof_mode >= 0.5f && dof_quality >= 0.5f;
                },
            }},
            {{
                .key = "DepthOfFieldFillRgbReconstruction",
                .binding = &dof_fill_rgb_reconstruction,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = 0.f,
                .can_reset = true,
                .label = "Fill RGB Reconstruction",
                .section = "Depth of Field - Fill Quality",
                .tooltip = "3x3 (Current) keeps Detroit's validated Fill sampling. Dense 5x5 uses 25 background-valid RGB samples inside the same maximum footprint for a smoother hidden-background estimate. It costs more GPU time and does not modify Gather alpha.",
                .labels = {"3x3 (Current)", "Dense 5x5"},
                .is_enabled = []() {
                  return dof_mode >= 0.5f && dof_quality >= 0.5f;
                },
            }},
            {{
                .key = "RetinalFixationX",
                .binding = &retinal_fixation_x,
                .default_value = 50.f,
                .can_reset = true,
                .label = "Fixation X",
                .section = "Retinal DOF",
                .tooltip = "Horizontal fixation point. Center is the safe default because Detroit's world-space autofocus target has no verified screen projection contract.",
                .min = 0.f,
                .max = 100.f,
                .format = "%.0f%%",
                .is_visible = []() { return dof_mode >= 2.5f; },
            }},
            {{
                .key = "RetinalFixationY",
                .binding = &retinal_fixation_y,
                .default_value = 50.f,
                .can_reset = true,
                .label = "Fixation Y",
                .section = "Retinal DOF",
                .tooltip = "Vertical fixation point in screen space.",
                .min = 0.f,
                .max = 100.f,
                .format = "%.0f%%",
                .is_visible = []() { return dof_mode >= 2.5f; },
            }},
            {{
                .key = "RetinalStrength",
                .binding = &retinal_strength,
                .default_value = 100.f,
                .can_reset = true,
                .label = "Retinal Strength",
                .section = "Retinal DOF",
                .tooltip = "Blends the additional Watson retinal-acuity variance. It does not change Detroit's authored CoC or focus distance.",
                .min = 0.f,
                .max = 100.f,
                .format = "%.0f%%",
                .is_visible = []() { return dof_mode >= 2.5f; },
            }},
            {{
                .key = "RetinalHorizontalFov",
                .binding = &retinal_horizontal_fov,
                .default_value = retinal::kDefaultHorizontalScreenAngleDegrees,
                .can_reset = true,
                .label = "Horizontal View Angle",
                .section = "Retinal DOF",
                .tooltip = "Physical horizontal viewing angle used to convert screen pixels to visual degrees.",
                .min = retinal::kMinimumHorizontalScreenAngleDegrees,
                .max = retinal::kMaximumHorizontalScreenAngleDegrees,
                .format = "%.0f deg",
                .is_visible = []() { return dof_mode >= 2.5f; },
            }},
            {{
                .key = "RetinalMaximumSigma",
                .binding = &retinal_maximum_sigma,
                .default_value = retinal::kMaximumSigmaPixels,
                .can_reset = true,
                .label = "Maximum Peripheral Sigma",
                .section = "Retinal DOF",
                .tooltip = "Safety ceiling for the full-resolution peripheral Gaussian radius.",
                .min = 0.f,
                .max = retinal::kMaximumSigmaPixels,
                .format = "%.1f px",
                .is_visible = []() { return dof_mode >= 2.5f; },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Vanilla DOF is active.",
                .section = "Depth of Field",
                .is_visible = []() { return dof_mode < 0.5f; },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "The selected DOF style is waiting for all four supported passes. Vanilla fallback is active.",
                .section = "Depth of Field",
                .is_visible = []() {
                  const auto status = dof_runtime_controller.GetStatus();
                  return dof_mode >= 0.5f
                         && (status == dof::RuntimeStatus::kWaitingForChain
                             || status == dof::RuntimeStatus::kIncompleteChain);
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Clean Balanced is active on the complete supported DOF chain.",
                .section = "Depth of Field",
                .is_visible = []() {
                  return dof_mode >= 0.5f
                         && dof_runtime_controller.GetStatus()
                                == dof::RuntimeStatus::kActiveCleanBalanced;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Clean High is active with the full-resolution small-CoC bridge on the complete supported DOF chain.",
                .section = "Depth of Field",
                .is_visible = []() {
                  return dof_mode >= 0.5f
                         && dof_runtime_controller.GetStatus()
                                == dof::RuntimeStatus::kActiveCleanHigh;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Cinematic Balanced is active with authored Gather/Fill coverage and foreground bokeh at Vanilla strength.",
                .section = "Depth of Field",
                .is_visible = []() {
                  return dof_mode >= 0.5f
                         && dof_runtime_controller.GetStatus()
                                == dof::RuntimeStatus::kActiveCinematicBalanced;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Cinematic High is active with the full-resolution small-CoC bridge, authored Gather/Fill coverage, and foreground bokeh at Vanilla strength.",
                .section = "Depth of Field",
                .is_visible = []() {
                  return dof_mode >= 0.5f
                         && dof_runtime_controller.GetStatus()
                                == dof::RuntimeStatus::kActiveCinematicHigh;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Retinal DOF is active: Cinematic depth plus the full-resolution Watson acuity filter.",
                .section = "Depth of Field",
                .is_visible = []() {
                  const auto status = dof_runtime_controller.GetStatus();
                  return (status == dof::RuntimeStatus::kActiveRetinalBalanced
                          || status == dof::RuntimeStatus::kActiveRetinalHigh)
                         && GetRetinalRunResult()
                                == retinal::RunResult::kDispatched;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Retinal post-filter is suspended while Render Debug is visible; Cinematic depth remains active.",
                .section = "Depth of Field",
                .is_visible = []() {
                  return dof_mode >= 2.5f
                         && GetRetinalRunResult()
                                == retinal::RunResult::kDebugOverlayActive;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Retinal post-filter is bypassed at zero strength or sigma; Cinematic depth remains active.",
                .section = "Depth of Field",
                .is_visible = []() {
                  return dof_mode >= 2.5f
                         && GetRetinalRunResult()
                                == retinal::RunResult::kBypassedZeroEffect;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Retinal post-filter could not validate its Vulkan composite contract; Cinematic depth remains active.",
                .section = "Depth of Field",
                .is_visible = []() {
                  const auto status = dof_runtime_controller.GetStatus();
                  const auto result = GetRetinalRunResult();
                  return (status == dof::RuntimeStatus::kActiveRetinalBalanced
                          || status == dof::RuntimeStatus::kActiveRetinalHigh)
                         && result != retinal::RunResult::kDispatched
                         && result != retinal::RunResult::kDebugOverlayActive
                         && result != retinal::RunResult::kBypassedZeroEffect;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::CUSTOM,
                .label = "Retinal Runtime Result",
                .section = "Depth of Field",
                .on_draw = []() {
                  const auto run_text = retinal_observability::GetRunResultText(
                      GetRetinalRunResult());
                  const auto capture = GetRetinalCaptureDiagnostic();
                  const auto capture_text =
                      retinal_observability::GetCaptureResultText(
                          capture.result);
                  const auto embedded_text =
                      retinal_observability::GetEmbeddedCaptureDetailText(
                          capture.embedded_detail);
                  ImGui::TextWrapped(
                      "Retinal RunResult: %.*s",
                      static_cast<int>(run_text.size()),
                      run_text.data());
                  ImGui::TextWrapped(
                      "Retinal CaptureResult: %.*s / %.*s",
                      static_cast<int>(capture_text.size()),
                      capture_text.data(),
                      static_cast<int>(embedded_text.size()),
                      embedded_text.data());
                  return false; },
                .is_visible = []() { return dof_mode >= 2.5f; },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "This executable or DOF shader revision is unsupported. Vanilla fallback is active.",
                .section = "Depth of Field",
                .is_visible = []() {
                  return dof_mode >= 0.5f
                         && dof_runtime_controller.GetStatus()
                                == dof::RuntimeStatus::kUnsupportedBuild;
                },
            }},
            {{
                .key = "ExperimentalMotionBlur",
                .binding = &experimental_motion_blur,
                .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
                .default_value = 0.f,
                .can_reset = true,
                .label = "Camera Motion Blur Edge Feather",
                .section = "Experimental",
                .tooltip = "Experimental depth-aware feathering for character silhouettes during fast camera motion. It is disabled by default because the effect was subtle during controller gameplay and has not been validated across the full game.",
                .on_change_value = [](float, float current) {
                  experimental_motion_blur = current;
                  OnExperimentalMotionBlurSettingsChanged();
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Experimental features are optional, disabled by default, and may vary by scene.",
                .section = "Experimental",
            }},
            {{
                .key = "RenderDebugMode",
                .binding = &render_debug_mode,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = 0.f,
                .can_reset = true,
                .label = "Render Debug Inspector",
                .section = "Render Debug",
                .tooltip = "Inline false-color inspection of verified Detroit render inputs. Off is a literal zero payload and adds no dispatches.",
                .labels = {"Off", "Single", "Dashboard"},
                .on_change_value = [](float, float current) {
                  render_debug_mode = current;
                  OnRenderDebugSettingsChanged();
                },
            }},
            {{
                .key = "RenderDebugDashboard",
                .binding = &render_debug_dashboard,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = 0.f,
                .can_reset = true,
                .label = "Dashboard",
                .section = "Render Debug",
                .tooltip = "Depth of Field shows the established CoC/layer diagnostic. DOF Vanilla Transition shows full-resolution CoC, the decoded blend strength, and the final authored Gather-coverage contribution.",
                .labels = {
                    "Depth of Field",
                    "Temporal AA",
                    "Scene",
                    "Lighting (Unavailable)",
                    "Retinal (Unavailable)",
                    "Custom",
                    "DOF Vanilla Transition",
                },
                .is_visible = []() { return render_debug_mode >= 1.5f; },
            }},
            {{
                .key = "RenderDebugSource",
                .binding = &render_debug_single_source,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = static_cast<float>(render_debug::Source::kDofFullResolutionCoc),
                .can_reset = true,
                .label = "Source",
                .section = "Render Debug",
                .labels = render_debug_source_labels,
                .is_visible = []() {
                  return render_debug_mode >= 0.5f
                         && render_debug_mode < 1.5f;
                },
            }},
            {{
                .key = "RenderDebugCustomSlot1",
                .binding = &render_debug_custom_slot_1,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = static_cast<float>(render_debug::Source::kDofFullResolutionCoc),
                .can_reset = true,
                .label = "Custom Left",
                .section = "Render Debug",
                .labels = render_debug_source_labels,
                .is_visible = []() {
                  return render_debug_mode >= 1.5f
                         && render_debug_dashboard >= 4.5f
                         && render_debug_dashboard < 5.5f;
                },
            }},
            {{
                .key = "RenderDebugCustomSlot2",
                .binding = &render_debug_custom_slot_2,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = static_cast<float>(render_debug::Source::kTemporalDepth),
                .can_reset = true,
                .label = "Custom Center",
                .section = "Render Debug",
                .labels = render_debug_source_labels,
                .is_visible = []() {
                  return render_debug_mode >= 1.5f
                         && render_debug_dashboard >= 4.5f
                         && render_debug_dashboard < 5.5f;
                },
            }},
            {{
                .key = "RenderDebugCustomSlot3",
                .binding = &render_debug_custom_slot_3,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = static_cast<float>(render_debug::Source::kSceneBeforeGrade),
                .can_reset = true,
                .label = "Custom Right",
                .section = "Render Debug",
                .labels = render_debug_source_labels,
                .is_visible = []() {
                  return render_debug_mode >= 1.5f
                         && render_debug_dashboard >= 4.5f
                         && render_debug_dashboard < 5.5f;
                },
            }},
            {{
                .key = "RenderDebugChannel",
                .binding = &render_debug_channel,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = 0.f,
                .can_reset = true,
                .label = "Channel",
                .section = "Render Debug",
                .labels = {"Auto", "RGB", "R", "G", "B", "Alpha", "Luminance", "Vector"},
                .is_enabled = []() { return render_debug_mode >= 0.5f; },
            }},
            {{
                .key = "RenderDebugMapping",
                .binding = &render_debug_mapping,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = 0.f,
                .can_reset = true,
                .label = "False-color Mapping",
                .section = "Render Debug",
                .labels = {"Auto", "Linear", "Signed", "Log2"},
                .is_enabled = []() { return render_debug_mode >= 0.5f; },
            }},
            {{
                .key = "RenderDebugOpacity",
                .binding = &render_debug_opacity,
                .default_value = 100.f,
                .can_reset = true,
                .label = "Opacity",
                .section = "Render Debug",
                .min = 0.f,
                .max = 100.f,
                .format = "%.0f%%",
                .is_enabled = []() { return render_debug_mode >= 0.5f; },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Waiting for every required inline producer in one frame; the normal image remains active.",
                .section = "Render Debug",
                .is_visible = []() {
                  return render_debug_mode >= 0.5f
                         && render_debug_runtime_controller.GetStatus()
                                == render_debug::RuntimeStatus::kWaitingForPasses;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "The selected source is not verified for this path. Magenta checkerboard marks it as unavailable.",
                .section = "Render Debug",
                .is_visible = []() {
                  return render_debug_mode >= 0.5f
                         && RenderDebugSelectionUnavailable();
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "This executable revision is unsupported; Render Debug remains Off.",
                .section = "Render Debug",
                .is_visible = []() {
                  return render_debug_mode >= 0.5f
                         && render_debug_runtime_controller.GetStatus()
                                == render_debug::RuntimeStatus::kUnsupportedBuild;
                },
            }},
            {{
                .key = "DLSSMode",
                .binding = &dlss_mode,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = static_cast<float>(DETROIT_DLSS_MODE_NATIVE),
                .can_reset = true,
                .label = "Temporal Anti-Aliasing",
                .section = "DLSS",
                .tooltip = "DLAA replaces Detroit's native TAA at output resolution. The game Resolution Scaling setting must be 100%; reduced render extents fail closed to Native TAA. DLSS Super Resolution is not included.",
                .labels = {"Native TAA", "DLAA"},
                .is_enabled = []() { return embedded_dlss::kDlssRuntimeEnabled; },
                .on_change_value = [](float, float current) { ApplyDlssMode(current); },
            }},
            {{
                .key = "DLAASharpening",
                .binding = &dlaa_sharpening,
                .default_value = 0.f,
                .can_reset = true,
                .label = "DLAA Sharpening",
                .section = "DLSS",
                .tooltip = "Scene-linear RCAS applied to the successful NGX output before Detroit's DOF. Zero is an exact passthrough.",
                .min = 0.f,
                .max = 100.f,
                .is_enabled = []() { return embedded_dlss::kDlssRuntimeEnabled
                                            && temporal_capture::GetMode()
                                                   == DETROIT_DLSS_MODE_DLAA; },
                .parse = [](float value) { return value * 0.01f; },
                .on_change_value = [](float, float) { SyncDlaaSharpening(); },
            }},
            {{
                .key = "DLSSBootstrapStatus",
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "First-run setup",
                .section = "DLSS",
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "The targeted DLAA Vulkan backend is unavailable; Native TAA remains active.",
                .section = "DLSS",
                .is_visible = []() {
                  return temporal_capture::GetStatus()
                             == temporal_capture::RuntimeStatus::kNative
                         && !embedded_hooks_active.load(std::memory_order_acquire);
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Native TAA is active. The two targeted Vulkan command hooks use direct lock-free trampolines.",
                .section = "DLSS",
                .is_visible = []() {
                  return temporal_capture::GetStatus()
                             == temporal_capture::RuntimeStatus::kNative
                         && embedded_hooks_active.load(std::memory_order_acquire);
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "DLAA is selected; waiting for a complete verified TAA dispatch. Native TAA fallback is active.",
                .section = "DLSS",
                .is_visible = []() {
                  return temporal_capture::GetStatus()
                         == temporal_capture::RuntimeStatus::kWaitingForDispatch;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "The TAA descriptor snapshot is incomplete. Native TAA fallback is active.",
                .section = "DLSS",
                .is_visible = []() {
                  return temporal_capture::GetStatus()
                         == temporal_capture::RuntimeStatus::kDescriptorContractIncomplete;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Diagnostic: a complete DLSS frame reached the bridge boundary. Bridge Configure/Evaluate are intentionally disabled.",
                .section = "DLSS",
                .is_visible = []() {
                  return temporal_capture::GetStatus()
                         == temporal_capture::RuntimeStatus::kBridgeInputReadyDiagnostic;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "TAA resources were captured, but current-frame b52/jitter, depth, motion-vector, exposure, history and UI-free-color proofs are incomplete. NGX is fail-closed and Native TAA remains active.",
                .section = "DLSS",
                .is_visible = []() {
                  return temporal_capture::GetStatus()
                         == temporal_capture::RuntimeStatus::kTemporalContractUnverified;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "The local DLSS bridge is unavailable or rejected this frame. Native TAA fallback is active.",
                .section = "DLSS",
                .is_visible = []() {
                  return temporal_capture::GetStatus()
                         == temporal_capture::RuntimeStatus::kBridgeFallback;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "DLAA produced a valid result for this frame.",
                .section = "DLSS",
                .is_visible = []() {
                  return temporal_capture::GetStatus()
                         == temporal_capture::RuntimeStatus::kDlssActive;
                },
            }},
            {{
                .key = "AspectRatioMode",
                .binding = &aspect_ratio_mode,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = 1.f,
                .can_reset = true,
                .label = "Aspect Ratio",
                .section = "Ultrawide",
                .tooltip = "Auto uses the Vulkan swapchain ratio for the scene and compensates Scaleform so UI keeps its 16:9 visual size.",
                .labels = {"Vanilla 16:9", "Auto (Ultrawide)"},
                .on_change_value = [](float, float current) {
                  ApplyAspectRatioMode(current);
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Ultrawide is signature-gated to Steam Build 12158144. At 3440x1440 Auto uses a 43:18 scene while preserving the 16:9 UI size.",
                .section = "Ultrawide",
            }},
#else
            {{
                .key = "OutputMode",
                .binding = &shader_injection.output_mode,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = OUTPUT_MODE_AUTO,
                .can_reset = true,
                .label = "Output Mode",
                .section = "Display Output",
                .tooltip = "Auto follows Detroit's native Vulkan swapchain. SDR and HDR10 select the matching shader path but do not switch Windows HDR.",
                .labels = {"Auto", "SDR", "HDR10"},
            }},
            {{
                .key = "CASMode",
                .binding = &shader_injection.cas_mode,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = CAS_MODE_RENODX,
                .can_reset = true,
                .label = "CAS",
                .section = "Sharpening",
                .tooltip = "Vanilla restores Detroit's original 300-nit-clamped CAS for reference. Off disables sharpening; RenoDX Strength keeps HDR headroom.",
                .labels = {"Vanilla", "Off", "RenoDX Strength"},
                .is_visible = []() {
                  return renodx::templates::settings::current_settings_mode >= 1.f;
                },
            }},
            {{
                .key = "CASStrength",
                .binding = &shader_injection.cas_strength,
                .default_value = 100.f,
                .can_reset = true,
                .label = "CAS Strength",
                .section = "Sharpening",
                .tooltip = "HDR-safe CAS sharpening strength.",
                .min = 0.f,
                .max = 100.f,
                .is_enabled = []() { return shader_injection.cas_mode == CAS_MODE_RENODX; },
                .parse = [](float value) { return value * 0.01f; },
                .is_visible = []() { return renodx::templates::settings::current_settings_mode >= 1.f; },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Output Mode cannot enable Windows HDR. Use SDR with Windows HDR off, or HDR10 with Windows HDR on and Auto HDR / RTX HDR off.",
                .section = "Display Output",
                .is_visible = []() {
                  return renodx::templates::settings::current_settings_mode >= 1.f;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Experimental HDR core for Steam Build 12158144 (Vulkan x64). Optional DLSS, DOF, motion blur, debug, and ultrawide logic lives in RenoDX Detroit Effects.",
                .section = "About",
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
                .section = "About",
            }},
#endif
        }),
    });

void OnPresetOff() {
#ifdef DETROIT_EFFECTS_ADDON
  const bool dof_was_enhanced = dof_mode >= 0.5f;
  renodx::utils::settings::UpdateSettings({
      {"DepthOfFieldMode", 0.f},
      {"DepthOfFieldQuality", 1.f},
      {"DepthOfFieldFocusDistance", 100.f},
      {"DepthOfFieldBlurRadius", 100.f},
      {"DepthOfFieldFarStrength", 100.f},
      {"DepthOfFieldVanillaTransition", 100.f},
      {"DepthOfFieldFillCocReconstruction", 0.f},
      {"DepthOfFieldFillTransition", 0.f},
      {"DepthOfFieldFillRgbReconstruction", 0.f},
      {"ExperimentalMotionBlur", 0.f},
      {"RetinalFixationX", 50.f},
      {"RetinalFixationY", 50.f},
      {"RetinalStrength", 100.f},
      {"RetinalHorizontalFov", retinal::kDefaultHorizontalScreenAngleDegrees},
      {"RetinalMaximumSigma", retinal::kMaximumSigmaPixels},
      {"RenderDebugMode", 0.f},
      {"RenderDebugDashboard", 0.f},
      {"RenderDebugSource", static_cast<float>(
                                render_debug::Source::kDofFullResolutionCoc)},
      {"RenderDebugCustomSlot1", static_cast<float>(
                                     render_debug::Source::kDofFullResolutionCoc)},
      {"RenderDebugCustomSlot2", static_cast<float>(
                                     render_debug::Source::kTemporalDepth)},
      {"RenderDebugCustomSlot3", static_cast<float>(
                                     render_debug::Source::kSceneBeforeGrade)},
      {"RenderDebugChannel", 0.f},
      {"RenderDebugMapping", 0.f},
      {"RenderDebugOpacity", 100.f},
      {"DLSSMode", static_cast<float>(DETROIT_DLSS_MODE_NATIVE)},
      {"DLAASharpening", 0.f},
  });
  OnDofSettingsChanged();
  OnExperimentalMotionBlurSettingsChanged();
  OnRenderDebugSettingsChanged();
  if (dof_was_enhanced) {
    reshade::log::message(
        reshade::log::level::warning,
        "Detroit DOF: Preset Off forced the Vanilla fallback.");
  }
  OnAspectRatioModeChanged();
#else
  renodx::utils::settings::UpdateSettings({
      {"OutputMode", OUTPUT_MODE_AUTO},
      {"ToneMapTypeV2", 0.f},
      {"PeakBrightnessSource", 0.f},
      {"ToneMapPeakNits", 1000.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 300.f},
      {"ColorGradeConeResponse", 50.f},
      {"ToneMapPsychoVExposureMatch", 1.f},
      {"ToneMapPsychoVVanillaHDRSlope", 100.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"SceneGradeStrength", 100.f},
      {"CASMode", CAS_MODE_VANILLA},
      {"CASStrength", 100.f},
  });
  OnPeakBrightnessSettingsChanged();
#endif
}

bool TryTrackGameSwapchain(reshade::api::swapchain* swapchain) {
  if (swapchain == nullptr) return false;
  if (auto* tracked = tracked_swapchain.load(std::memory_order_acquire);
      tracked != nullptr) {
    return tracked == swapchain;
  }
  if (auto* window = static_cast<HWND>(swapchain->get_hwnd()); window != nullptr) {
    DWORD process_id = 0u;
    GetWindowThreadProcessId(window, &process_id);
    if (process_id != GetCurrentProcessId()) return false;
  }

  auto* expected = static_cast<reshade::api::swapchain*>(nullptr);
  return tracked_swapchain.compare_exchange_strong(
             expected, swapchain, std::memory_order_acq_rel)
         || expected == swapchain;
}

bool UpdateUltrawideFromSwapchain(
    reshade::api::swapchain* swapchain,
    bool force_refresh) {
  if (swapchain == nullptr) return false;
  if (!force_refresh
      && tracked_swapchain.load(std::memory_order_acquire) == swapchain
      && output_width.load(std::memory_order_relaxed) != 0u
      && output_height.load(std::memory_order_relaxed) != 0u) {
    return true;
  }
  if (swapchain->get_back_buffer_count() == 0u) return false;

  auto* device = swapchain->get_device();
  const auto back_buffer = swapchain->get_back_buffer(0u);
  const auto description = device->get_resource_desc(back_buffer);
  if (description.type != reshade::api::resource_type::texture_2d
      || description.texture.width == 0u
      || description.texture.height == 0u) {
    return false;
  }

  const auto width = static_cast<std::uint32_t>(description.texture.width);
  const auto height = static_cast<std::uint32_t>(description.texture.height);
  const auto previous_width = output_width.exchange(width, std::memory_order_relaxed);
  const auto previous_height = output_height.exchange(height, std::memory_order_relaxed);
  if (width == previous_width && height == previous_height) return true;
  if constexpr (!kEffectsAddon) return true;

  RefreshUltrawideValues();
  if (ultrawide_installed.load(std::memory_order_acquire)) {
    const auto values = ultrawide::CalculateActiveValues(
        width,
        height,
        aspect_ratio_enabled.load(std::memory_order_relaxed));
    LogUltrawide(
        reshade::log::level::info,
        std::format(
            "swapchain {}x{} detected (aspect {:.6f}, UI half-extent {:.6f}).",
            width,
            height,
            values.aspect_ratio,
            values.ui_half_extent));
  }
  return true;
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool) {
  if (!TryTrackGameSwapchain(swapchain)) return;
  if constexpr (!kEffectsAddon) {
    shader_injection.output_is_hdr =
        IsHdrOutputColorSpace(swapchain->get_color_space()) ? 1.f : 0.f;
    UpdatePeakBrightness(swapchain, true);
  }
  if (!UpdateUltrawideFromSwapchain(swapchain, true)) return;
  if constexpr (!kEffectsAddon) return;
  if (!ultrawide_install_attempted.exchange(true, std::memory_order_acq_rel)) {
    InstallUltrawidePatch();
  }
}

void OnInitEffectRuntime(reshade::api::effect_runtime* runtime) {
  if (runtime == nullptr) return;
  if (auto* window = static_cast<HWND>(runtime->get_hwnd()); window != nullptr) {
    DWORD process_id = 0u;
    GetWindowThreadProcessId(window, &process_id);
    if (process_id != GetCurrentProcessId()) return;
  }

  if (!InitializeReShadeCaptureRequest()) return;
  auto* expected = static_cast<reshade::api::effect_runtime*>(nullptr);
  (void)tracked_effect_runtime.compare_exchange_strong(
      expected, runtime, std::memory_order_acq_rel);
}

void OnDestroyEffectRuntime(reshade::api::effect_runtime* runtime) {
  auto* expected = runtime;
  tracked_effect_runtime.compare_exchange_strong(
      expected, nullptr, std::memory_order_acq_rel);
}

void TrySaveRequestedReShadeScreenshot(reshade::api::swapchain* swapchain) {
  auto* runtime = tracked_effect_runtime.load(std::memory_order_acquire);
  if (runtime == nullptr || swapchain == nullptr
      || runtime->get_device() != swapchain->get_device()) {
    return;
  }
  if (runtime->get_hwnd() != nullptr && swapchain->get_hwnd() != nullptr
      && runtime->get_hwnd() != swapchain->get_hwnd()) {
    return;
  }

  std::string postfix;
  {
    std::scoped_lock lock(reshade_capture_mutex);
    if (!reshade_capture.enabled || reshade_capture.captured) return;

    const auto mode = temporal_capture::GetMode();
    const auto status = temporal_capture::GetStatus();
    const auto evaluation_serial = temporal_capture::GetEvaluationSerial();
    const bool valid_output =
        mode == DETROIT_DLSS_MODE_NATIVE
            ? status == temporal_capture::RuntimeStatus::kNative
            : status == temporal_capture::RuntimeStatus::kDlssActive;
    if (!valid_output || evaluation_serial == 0u) {
      reshade_capture.observed_mode = mode;
      reshade_capture.last_evaluation_serial = evaluation_serial;
      reshade_capture.stable_frames = 0u;
      reshade_capture.stable_since_valid = false;
      return;
    }
    if (mode != reshade_capture.observed_mode) {
      reshade_capture.observed_mode = mode;
      reshade_capture.last_evaluation_serial = evaluation_serial;
      reshade_capture.stable_frames = 0u;
      reshade_capture.stable_since_valid = false;
      return;
    }
    if (evaluation_serial == reshade_capture.last_evaluation_serial) return;

    reshade_capture.last_evaluation_serial = evaluation_serial;
    const auto now = std::chrono::steady_clock::now();
    if (!reshade_capture.stable_since_valid) {
      reshade_capture.stable_since = now;
      reshade_capture.stable_since_valid = true;
    }
    ++reshade_capture.stable_frames;
    if (reshade_capture.stable_frames < RESHADE_CAPTURE_STABLE_FRAMES) return;
    if (now - reshade_capture.stable_since
        < std::chrono::seconds(reshade_capture.delay_seconds)) {
      return;
    }

    postfix = reshade_capture.automatic_postfix
                  ? GetDlssModePostfix(mode)
                  : reshade_capture.postfix;
    reshade_capture.captured = true;
  }

  // The generic present event runs immediately before ReShade's own present
  // processing. Calling the public runtime API here captures the game buffer
  // without the ReShade overlay or any Windows desktop composition.
  runtime->save_screenshot(postfix.c_str());
  LogReShadeCapture(
      reshade::log::level::info,
      std::format("saved internal screenshot with postfix '{}'.", postfix));
}

void OnDestroySwapchain(reshade::api::swapchain* swapchain, bool resize) {
  auto* expected = swapchain;
  if (!tracked_swapchain.compare_exchange_strong(
          expected, nullptr, std::memory_order_acq_rel)) {
    return;
  }
  output_width.store(0u, std::memory_order_relaxed);
  output_height.store(0u, std::memory_order_relaxed);

  if constexpr (!kEffectsAddon) {
    peak_brightness_refresh.Reset();
    detected_output_desc.reset();
    detected_peak_nits.reset();
    peak_brightness_refresh_requested.store(true, std::memory_order_release);
    UpdatePeakBrightness(nullptr, false);
  } else if (!resize) {
    RestoreUltrawidePatch();
    ultrawide_install_attempted.store(false, std::memory_order_release);
  }
}

void OnDestroyDevice(reshade::api::device* device) {
  if (auto* swapchain = tracked_swapchain.load(std::memory_order_acquire);
      swapchain != nullptr && swapchain->get_device() != device) {
    return;
  }
  dof_runtime_controller.Reset();
  shader_injection.dof_runtime_mode =
      static_cast<float>(dof::RuntimeMode::kVanilla);
  render_debug_runtime_controller.ResetDevice();
  render_debug_temporal_replacement_active.store(
      false, std::memory_order_release);
  shader_injection.scene_path_active = 0.f;
  retinal_runtime.Destroy(device);
  SetRetinalCaptureDiagnostic({});
  SetRetinalRunResult(retinal::RunResult::kNotRetinalMode);
  retinal_force_disabled.store(false, std::memory_order_release);
  retinal_restore_failure_logged.store(false, std::memory_order_release);
  if (!dof_device_reset_logged.exchange(true, std::memory_order_acq_rel)) {
    reshade::log::message(
        reshade::log::level::warning,
        "Detroit DOF: Vulkan device recreation forced the Vanilla fallback.");
  }
}

void MigrateDlssModeSettings() {
  for (const char* section : {
           "renodx-preset1",
           "renodx-preset2",
           "renodx-preset3",
       }) {
    float persisted = 0.f;
    if (!reshade::get_config_value(
            nullptr, section, "DLSSMode", persisted)) {
      continue;
    }
    const auto canonical =
        renodx::games::detroitbecomehuman::dlss_policy::ParsePersistedDlssMode(
            persisted);
    if (persisted == static_cast<float>(canonical)) continue;
    reshade::set_config_value(
        nullptr, section, "DLSSMode", static_cast<int>(canonical));
  }
}

void MigrateRetinalDofSettings() {
  bool migrated = false;
  for (const char* section : {
           "renodx-preset1",
           "renodx-preset2",
           "renodx-preset3",
       }) {
    float persisted = 0.f;
    if (!reshade::get_config_value(
            nullptr, section, "DepthOfFieldMode", persisted)
        || persisted < 2.5f) {
      continue;
    }
    reshade::set_config_value(nullptr, section, "DepthOfFieldMode", 2);
    migrated = true;
  }
  if (!migrated) return;
  retinal_mode_downgraded.store(true, std::memory_order_release);
  reshade::log::message(
      reshade::log::level::warning,
      "Detroit Retinal DOF: temporarily unavailable without global Vulkan interposition; using Cinematic.");
}

void OnPresent(
    reshade::api::command_queue*,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect*,
    const reshade::api::rect*,
    uint32_t,
    const reshade::api::rect*) {
  if constexpr (kEffectsAddon) {
    if (embedded_hooks_requested_at_startup
        && !bootstrap_setup_attempted.load(std::memory_order_acquire)
        && !bootstrap_setup_attempted.exchange(true, std::memory_order_acq_rel)) {
      (void)EnsureLoadFromDllMainEntry();
      embedded_dlss::RefreshDeferredStatus();
      const bool cache_valid =
          embedded_dlss::IsValidCache(initial_extension_cache);
      if (!cache_valid || !embedded_dlss::WasLoadedEarly()) {
        const auto ngx_path =
            GetModulePath(addon_module).parent_path() / L"nvngx_dlss.dll";
        if (std::filesystem::is_regular_file(ngx_path)) {
          embedded_dlss::ExtensionCache refreshed;
          if (embedded_dlss::QueryRequiredExtensionsIsolated(addon_module, &refreshed)) {
            WriteExtensionCache(refreshed);
            initial_extension_cache = std::move(refreshed);
            embedded_dlss::SetRestartRequired();
          }
        } else {
          embedded_dlss::SetNativeFallback("nvngx_dlss.dll is missing");
          reshade::log::message(
              reshade::log::level::error,
              "Detroit DLSS: nvngx_dlss.dll is missing; Native TAA fallback is active.");
        }
      }
    }
    static thread_local std::uint64_t displayed_bootstrap_revision = 0u;
    const auto bootstrap_revision = embedded_dlss::GetStatusRevision();
    if (displayed_bootstrap_revision != bootstrap_revision) {
      if (auto* status =
              renodx::utils::settings::FindSetting("DLSSBootstrapStatus");
          status != nullptr) {
        status->label = embedded_hooks_requested_at_startup
                            ? embedded_dlss::GetStatusText()
                            : "Native TAA fallback: targeted DLAA backend not loaded.";
      }
      displayed_bootstrap_revision = bootstrap_revision;
    }
    if (!ultrawide_install_attempted.load(std::memory_order_acquire)
        && TryTrackGameSwapchain(swapchain)
        && UpdateUltrawideFromSwapchain(swapchain, false)
        && !ultrawide_install_attempted.exchange(
            true, std::memory_order_acq_rel)) {
      InstallUltrawidePatch();
    }
    UpdateRenderDebugRuntime();
    UpdateDofRuntimeMode();
    TrySaveRequestedReShadeScreenshot(swapchain);
  } else {
    if (TryTrackGameSwapchain(swapchain)) {
      (void)UpdateUltrawideFromSwapchain(swapchain, false);
    }
    const auto color_space = swapchain->get_color_space();
    shader_injection.output_is_hdr =
        IsHdrOutputColorSpace(color_space) ? 1.f : 0.f;
    if (peak_brightness::ParseSource(peak_brightness_source)
        != peak_brightness::Source::kManual) {
      UpdatePeakBrightness(swapchain, false);
    }
    shader_injection.ui_path_active =
        ui_path_seen.load(std::memory_order_relaxed) ? 1.f : 0.f;
  }
  // The carrier bit describes the frame that just finished. Clear all
  // transient flags so a video/loading frame without the scene composite
  // falls back to Detroit's native BT.709 intermediate.
  shader_injection.runtime_flags = 0.f;
}

}  // namespace

#ifdef DETROIT_EFFECTS_ADDON
extern "C" __declspec(dllexport) constexpr const char* NAME =
    "RenoDX Detroit Effects";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "Optional non-HDR effects for RenoDX Detroit (Vulkan, experimental)";
#else
extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "RenoDX HDR for Detroit: Become Human (Vulkan, experimental)";
#endif

bool AttachAddon(HMODULE h_module) {
  // Both modules publish callback addresses that remain valid until process
  // teardown. Pin before registering either add-on with ReShade.
  HMODULE pinned_module = nullptr;
  if (!GetModuleHandleExW(
          GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS
              | GET_MODULE_HANDLE_EX_FLAG_PIN,
          reinterpret_cast<LPCWSTR>(&AttachAddon),
          &pinned_module)) {
    return false;
  }
  if (addon_attached.exchange(true, std::memory_order_acq_rel)) return true;
  addon_module = h_module;
  DisableThreadLibraryCalls(h_module);
  if (!reshade::register_addon(h_module)) {
    addon_attached.store(false, std::memory_order_release);
    return false;
  }
  // register_addon initializes ReShade's cached handle for this module. No
  // other ReShade API (including config access) is valid before this point.
  (void)addon_shared.RegisterModule();
  if (addon_shared.data == nullptr) {
    addon_attached.store(false, std::memory_order_release);
    return false;
  }
  renodx::mods::shader::allow_multiple_push_constants = true;
  renodx::mods::shader::force_pipeline_cloning = true;

#ifdef DETROIT_EFFECTS_ADDON
  initial_extension_cache = ReadExtensionCache();
  embedded_hooks_requested_at_startup = ReadStartupEmbeddedHookRequest();
  if (embedded_hooks_requested_at_startup) {
    embedded_hooks_active.store(
        embedded_dlss::AttachEarlyHooks(
            h_module,
            initial_extension_cache,
            true),
        std::memory_order_release);
  } else {
    reshade::log::message(
        reshade::log::level::info,
        "Detroit DLAA/Retinal: lightweight Vulkan backend is not loaded; Native TAA remains active.");
  }
  renodx::games::detroitbecomehuman::dlss_bridge_client::client.SetApiProvider(
      &embedded_dlss::GetApi);
  renodx::utils::settings::on_preset_changed_callbacks.emplace_back(
      &OnAspectRatioModeChanged);
  renodx::utils::settings::on_preset_changed_callbacks.emplace_back(
      &OnDlssModeChanged);
  renodx::utils::settings::on_preset_changed_callbacks.emplace_back(
      &OnDofSettingsChanged);
  renodx::utils::settings::on_preset_changed_callbacks.emplace_back(
      &OnExperimentalMotionBlurSettingsChanged);
  renodx::utils::settings::on_preset_changed_callbacks.emplace_back(
      &OnRenderDebugSettingsChanged);
  renodx::utils::settings::on_preset_changed_callbacks.emplace_back(
      &SyncDlaaSharpening);
  reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
  reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
  reshade::register_event<reshade::addon_event::init_effect_runtime>(OnInitEffectRuntime);
  reshade::register_event<reshade::addon_event::destroy_effect_runtime>(OnDestroyEffectRuntime);
  reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
  reshade::register_event<reshade::addon_event::present>(OnPresent);
  MigrateDlssModeSettings();
  MigrateRetinalDofSettings();
  renodx::utils::settings::Use(
      DLL_PROCESS_ATTACH, &settings, &OnPresetOff);
  temporal_capture::Use(DLL_PROCESS_ATTACH);
  renodx::mods::shader::use_shared_pipeline_injection = true;
  renodx::mods::shader::Use(
      DLL_PROCESS_ATTACH, effect_shaders, &shader_injection);
  OnAspectRatioModeChanged();
  OnDlssModeChanged();
  OnDofSettingsChanged();
  OnExperimentalMotionBlurSettingsChanged();
  OnRenderDebugSettingsChanged();
  addon_shared.data->effects_api.store(&effects_api, std::memory_order_release);
  SyncDlaaSharpening();
#else
  renodx::utils::settings::on_preset_changed_callbacks.emplace_back(
      &OnPeakBrightnessSettingsChanged);
  renodx::utils::settings::on_preset_changed_callbacks.emplace_back(
      &SyncDlaaSharpening);
  reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
  reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
  reshade::register_event<reshade::addon_event::present>(OnPresent);
  MigrateToneMapTypeSettings();
  renodx::utils::settings::Use(
      DLL_PROCESS_ATTACH, &settings, &OnPresetOff);
  // HDR UI replacement queries the active render targets.
  renodx::utils::swapchain::Use(DLL_PROCESS_ATTACH);
  renodx::mods::shader::Use(
      DLL_PROCESS_ATTACH, hdr_shaders, &shader_injection);
  OnPeakBrightnessSettingsChanged();
  SyncDlaaSharpening();
#endif
  return true;
}

void DetachAddon(HMODULE h_module, bool process_terminating) {
  (void)h_module;
  (void)process_terminating;
  // AttachAddon guarantees that the module is pinned before any registration.
  // DllMain therefore only records terminal state. Vulkan/ReShade/settings and
  // Detours teardown must never run while the Windows loader lock is held.
  addon_attached.store(false, std::memory_order_release);
}

BOOL APIENTRY DllMain(HMODULE h_module, DWORD reason, LPVOID reserved) {
  if (reason == DLL_PROCESS_ATTACH) {
#ifdef DETROIT_EFFECTS_ADDON
    if (embedded_dlss::IsExtensionProbeHost()) {
      DisableThreadLibraryCalls(h_module);
      return TRUE;
    }
#endif
    return AttachAddon(h_module) ? TRUE : FALSE;
  }
  if (reason == DLL_PROCESS_DETACH) DetachAddon(h_module, reserved != nullptr);
  return TRUE;
}
