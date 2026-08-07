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
#include <format>
#include <limits>
#include <mutex>
#include <span>
#include <string>
#include <string_view>
#include <system_error>
#include <vector>

#include <Windows.h>

#include <deps/imgui/imgui.h>
#include <embed/shaders.h>
#include <include/reshade.hpp>

#include "../../mods/shader.hpp"
#include "../../templates/settings.hpp"
#include "../../utils/date.hpp"
#include "../../utils/settings.hpp"
#include "./dlss_scale_transition.hpp"
#include "./resolution_scaling_win32.hpp"
#include "./shared.h"
#include "./temporal_capture.hpp"
#include "./ultrawide.hpp"

namespace {

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
namespace resolution_scaling =
    renodx::games::detroitbecomehuman::resolution_scaling;
namespace dlss_scale_transition =
    renodx::games::detroitbecomehuman::dlss_scale_transition;
constexpr std::size_t ASPECT_PATCH_INDEX = 0u;
constexpr std::size_t UI_PATCH_INDEX = 1u;

struct alignas(16) UltrawideRuntimeData {
  volatile LONG aspect_ratio_bits;
  volatile LONG ui_scale_bits;
};

struct UltrawidePatchState {
  std::array<std::uint8_t*, 2u> displacement_addresses = {};
  std::array<std::int32_t, 2u> original_displacements = {};
  std::array<std::int32_t, 2u> redirected_displacements = {};
  std::array<DWORD, 2u> original_protections = {};
  std::array<bool, 2u> active_patches = {};
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
float aspect_ratio_mode = 1.f;
float dlss_mode = static_cast<float>(DETROIT_DLSS_MODE_NATIVE);
float dlaa_sharpening = 0.f;
std::atomic_bool aspect_ratio_enabled = true;
std::atomic_uint32_t output_width = 0u;
std::atomic_uint32_t output_height = 0u;
resolution_scaling::RuntimeController resolution_scale_controller;
dlss_scale_transition::Controller dlss_scale_transition_controller;
std::mutex resolution_scale_mutex;
DetroitDlssModeSettings cached_dlss_scale_settings = {};
DetroitDlssMode cached_dlss_scale_mode = DETROIT_DLSS_MODE_NATIVE;
std::uint32_t cached_dlss_scale_output_width = 0u;
std::uint32_t cached_dlss_scale_output_height = 0u;
bool cached_dlss_scale_settings_valid = false;
bool dlss_scale_session_valid = false;
float cached_dlss_target_scale = 1.f;
std::uint32_t last_scale_log_key = std::numeric_limits<std::uint32_t>::max();

struct ReShadeCaptureState {
  bool initialized = false;
  bool enabled = false;
  bool captured = false;
  bool automatic_postfix = true;
  DetroitDlssMode observed_mode = DETROIT_DLSS_MODE_NATIVE;
  std::uint64_t last_evaluation_serial = 0u;
  std::uint32_t stable_frames = 0u;
  std::uint32_t delay_seconds = RESHADE_CAPTURE_DEFAULT_DELAY_SECONDS;
  std::chrono::steady_clock::time_point stable_since = {};
  bool stable_since_valid = false;
  std::string postfix;
};

std::mutex reshade_capture_mutex;
ReShadeCaptureState reshade_capture;

void LogUltrawide(reshade::log::level level, const std::string& message) {
  reshade::log::message(level, ("Detroit ultrawide: " + message).c_str());
}

void LogDlssScale(reshade::log::level level, const std::string& message) {
  reshade::log::message(level, ("Detroit DLSS scale: " + message).c_str());
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
    case DETROIT_DLSS_MODE_QUALITY:
      return "DLSS-Quality";
    case DETROIT_DLSS_MODE_BALANCED:
      return "DLSS-Balanced";
    case DETROIT_DLSS_MODE_PERFORMANCE:
      return "DLSS-Performance";
    default:
      return "Unknown-Mode";
  }
}

void InitializeReShadeCaptureRequest() {
  std::scoped_lock lock(reshade_capture_mutex);
  if (reshade_capture.initialized) return;
  reshade_capture.initialized = true;

  std::array<char, 96u> value = {};
  const DWORD length = GetEnvironmentVariableA(
      RESHADE_CAPTURE_ENVIRONMENT,
      value.data(),
      static_cast<DWORD>(value.size()));
  if (length == 0u || length >= value.size()) return;

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
}

void InvalidateDlssScaleSettings() {
  std::scoped_lock lock(resolution_scale_mutex);
  cached_dlss_scale_settings_valid = false;
  dlss_scale_session_valid = false;
  last_scale_log_key = std::numeric_limits<std::uint32_t>::max();
}

void LogScaleResultOnce(
    DetroitDlssMode mode,
    resolution_scaling::ControllerResult result,
    float target_scale) {
  const auto result_code = static_cast<std::uint32_t>(result);
  const std::uint32_t key =
      (static_cast<std::uint32_t>(mode) << 28u)
      ^ (result_code << 20u) ^ std::bit_cast<std::uint32_t>(target_scale);
  if (last_scale_log_key == key) return;
  last_scale_log_key = key;
  const bool accepted = result == resolution_scaling::ControllerResult::kSuccess
                        || result == resolution_scaling::ControllerResult::kNoChange;
  LogDlssScale(
      accepted ? reshade::log::level::info : reshade::log::level::warning,
      std::format(
          "mode {} requested scale {:.6f}; controller result {}{}.",
          mode,
          target_scale,
          result_code,
          accepted ? "" : "; native TAA remains the safe fallback"));
}

void UpdateDlssRenderScale() {
  const auto mode = temporal_capture::GetMode();
  std::scoped_lock lock(resolution_scale_mutex);

  auto snapshot = resolution_scale_controller.GetSnapshot();
  if (!renodx::games::detroitbecomehuman::dlss_policy::IsDlssMode(mode)) {
    dlss_scale_transition_controller.SetIdle();
    dlss_scale_session_valid = false;
    cached_dlss_scale_settings_valid = false;
    if (!snapshot.armed) return;
    const auto result = resolution_scale_controller.Shutdown(
        resolution_scaling::RuntimeCallContext::kOutsideLoaderLock);
    LogScaleResultOnce(mode, result, snapshot.serialized_scale);
    return;
  }

  const auto width = output_width.load(std::memory_order_relaxed);
  const auto height = output_height.load(std::memory_order_relaxed);
  if (width == 0u || height == 0u) return;

  const bool session_changed = !dlss_scale_session_valid
                               || cached_dlss_scale_mode != mode
                               || cached_dlss_scale_output_width != width
                               || cached_dlss_scale_output_height != height;
  if (session_changed) {
    // Never carry a reduced extent into a new mode or output-resolution
    // session. Shutdown restores Detroit's dimensions from the unchanged
    // serialized scale before detaching the old hook.
    if (snapshot.armed) {
      const auto shutdown_result = resolution_scale_controller.Shutdown(
          resolution_scaling::RuntimeCallContext::kOutsideLoaderLock);
      if (shutdown_result != resolution_scaling::ControllerResult::kSuccess
          && shutdown_result
                 != resolution_scaling::ControllerResult::kNoChange) {
        dlss_scale_transition_controller.LatchFallback();
        LogScaleResultOnce(mode, shutdown_result, snapshot.serialized_scale);
        return;
      }
    }
    cached_dlss_scale_mode = mode;
    cached_dlss_scale_output_width = width;
    cached_dlss_scale_output_height = height;
    cached_dlss_scale_settings_valid = false;
    dlss_scale_session_valid = true;
    cached_dlss_target_scale = 1.f;
    dlss_scale_transition_controller.Reset(
        temporal_capture::GetSrPreflightSerial(),
        temporal_capture::GetEvaluationSerial());
    snapshot = resolution_scale_controller.GetSnapshot();
  }

  if (dlss_scale_transition_controller.GetPhase()
      == dlss_scale_transition::Phase::kFallbackLatched) {
    if (!snapshot.armed) return;
    const auto result = resolution_scale_controller.Shutdown(
        resolution_scaling::RuntimeCallContext::kOutsideLoaderLock);
    LogScaleResultOnce(mode, result, snapshot.serialized_scale);
    return;
  }

  if (!cached_dlss_scale_settings_valid) {
    DetroitDlssModeSettings settings = {};
    if (!renodx::games::detroitbecomehuman::dlss_bridge_client::client
             .QueryModeSettings(mode, width, height, &settings)) {
      LogScaleResultOnce(
          mode,
          resolution_scaling::ControllerResult::kNotArmed,
          1.f);
      return;
    }
    const auto exact_scale =
        resolution_scaling::SelectScaleForExactTruncatedExtent(
            {width, height},
            {
                settings.render_width,
                settings.render_height,
            });
    if (!exact_scale.has_value()) {
      dlss_scale_transition_controller.LatchFallback();
      LogScaleResultOnce(
          mode,
          resolution_scaling::ControllerResult::kScaleRejected,
          1.f);
      return;
    }

    // QueryModeSettings can succeed only through the layer's independent
    // executable SHA-256 gate. The controller additionally validates the
    // loaded PE identity and exact code slices before installing its hook.
    const resolution_scaling::ExecutableIdentity identity = {
        .file_size = renodx::games::detroitbecomehuman::supported_build::kExecutableSize,
        .sha256 = renodx::games::detroitbecomehuman::supported_build::kExecutableSha256,
    };
    const auto arm_result = resolution_scale_controller.Arm(
        GetModuleHandleW(nullptr), identity);
    if (arm_result != resolution_scaling::ControllerResult::kSuccess
        && arm_result != resolution_scaling::ControllerResult::kAlreadyArmed) {
      dlss_scale_transition_controller.LatchFallback();
      LogScaleResultOnce(mode, arm_result, 1.f);
      return;
    }

    cached_dlss_scale_settings = settings;
    cached_dlss_target_scale = exact_scale.value();
    cached_dlss_scale_settings_valid = true;
    (void)dlss_scale_transition_controller.MarkSettingsReady();
    if (mode == DETROIT_DLSS_MODE_DLAA) {
      const auto native_scale_result = resolution_scale_controller.Apply(
          1.f,
          resolution_scaling::RuntimeCallContext::kOutsideLoaderLock);
      if (native_scale_result == resolution_scaling::ControllerResult::kSuccess
          || native_scale_result
                 == resolution_scaling::ControllerResult::kNoChange) {
        (void)dlss_scale_transition_controller.MarkTargetScaleApplied();
      } else {
        dlss_scale_transition_controller.LatchFallback();
        LogScaleResultOnce(mode, native_scale_result, 1.f);
        return;
      }
    }
  }

  snapshot = resolution_scale_controller.GetSnapshot();
  const bool target_extent_observed =
      snapshot.last_base_extent
          == resolution_scaling::PixelExtent{width, height}
      && snapshot.last_render_extent
             == resolution_scaling::PixelExtent{
                 cached_dlss_scale_settings.render_width,
                 cached_dlss_scale_settings.render_height,
             };
  const auto action = dlss_scale_transition_controller.Observe({
      .preflight_serial = temporal_capture::GetSrPreflightSerial(),
      .evaluation_serial = temporal_capture::GetEvaluationSerial(),
      .target_extent_observed = target_extent_observed,
      .dlss_output_valid = temporal_capture::GetStatus()
                           == temporal_capture::RuntimeStatus::kDlssActive,
  });

  if (action == dlss_scale_transition::Action::kApplyTargetScale) {
    const auto result = resolution_scale_controller.Apply(
        cached_dlss_target_scale,
        resolution_scaling::RuntimeCallContext::kOutsideLoaderLock);
    if (result == resolution_scaling::ControllerResult::kSuccess
        || result == resolution_scaling::ControllerResult::kNoChange) {
      (void)dlss_scale_transition_controller.MarkTargetScaleApplied();
    } else {
      dlss_scale_transition_controller.LatchFallback();
    }
    LogScaleResultOnce(mode, result, cached_dlss_target_scale);
    return;
  }

  if (action == dlss_scale_transition::Action::kRestoreNativeScale) {
    snapshot = resolution_scale_controller.GetSnapshot();
    if (!snapshot.armed) return;
    const auto result = resolution_scale_controller.Shutdown(
        resolution_scaling::RuntimeCallContext::kOutsideLoaderLock);
    LogScaleResultOnce(mode, result, snapshot.serialized_scale);
  }
}

void ShutdownDlssRenderScale() {
  std::scoped_lock lock(resolution_scale_mutex);
  const auto snapshot = resolution_scale_controller.GetSnapshot();
  if (snapshot.armed) {
    const auto result = resolution_scale_controller.Shutdown(
        resolution_scaling::RuntimeCallContext::kOutsideLoaderLock);
    LogScaleResultOnce(
        DETROIT_DLSS_MODE_NATIVE,
        result,
        snapshot.serialized_scale);
  }
  cached_dlss_scale_settings_valid = false;
  dlss_scale_session_valid = false;
  dlss_scale_transition_controller.SetIdle();
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
    StoreRuntimeFloat(&runtime_data->ui_scale_bits, values.ui_scale);
  }
}

void ForceUltrawideRuntimeVanilla() {
  ultrawide_force_vanilla.store(true, std::memory_order_release);
  if (auto* runtime_data = ultrawide_runtime_data.load(std::memory_order_acquire);
      runtime_data != nullptr) {
    StoreRuntimeFloat(&runtime_data->aspect_ratio_bits, ultrawide::kVanillaAspect);
    StoreRuntimeFloat(&runtime_data->ui_scale_bits, ultrawide::kReferenceUiScale);
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
            "aspect mode changed: swapchain {}x{}, aspect {:.6f}, UI scale {:.6f}, mode {}.",
            width,
            height,
            values.aspect_ratio,
            values.ui_scale,
            enabled ? "Auto" : "Vanilla 16:9"));
  }
}

void OnAspectRatioModeChanged() {
  ApplyAspectRatioMode(aspect_ratio_mode);
}

void ApplyDlssMode(float selected_mode) {
  auto next_mode = static_cast<DetroitDlssMode>(selected_mode);
  if (next_mode != DETROIT_DLSS_MODE_NATIVE
      && next_mode != DETROIT_DLSS_MODE_DLAA) {
    next_mode = DETROIT_DLSS_MODE_DLAA;
  }
  dlss_mode = static_cast<float>(next_mode);
  const auto previous_mode = temporal_capture::GetMode();
  temporal_capture::SetMode(next_mode);
  if (next_mode != previous_mode) InvalidateDlssScaleSettings();
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
          && ultrawide::CalculateRipDisplacement(ui_next_instruction, candidate + sizeof(LONG)).has_value()) {
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
  if (ultrawide_patch.active_patches[ASPECT_PATCH_INDEX]
      || ultrawide_patch.active_patches[UI_PATCH_INDEX]) {
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
      module.value(), ultrawide::kUiScalePatch.pattern, "UI scale");
  if (aspect_pattern == nullptr || ui_pattern == nullptr) return false;

  auto* aspect_getter =
      aspect_pattern + ultrawide::kAspectGetterPatch.instruction_offset;
  auto* ui_scale_load = ui_pattern + ultrawide::kUiScalePatch.instruction_offset;
  if (std::memcmp(
          aspect_getter,
          ultrawide::kAspectGetterPatch.instruction.data(),
          ultrawide::kAspectGetterPatch.instruction.size())
          != 0
      || std::memcmp(
             ui_scale_load,
             ultrawide::kUiScalePatch.instruction.data(),
             ultrawide::kUiScalePatch.instruction.size())
             != 0) {
    LogUltrawide(reshade::log::level::error, "instruction validation failed.");
    return false;
  }

  UltrawidePatchState candidate;
  candidate.displacement_addresses[ASPECT_PATCH_INDEX] =
      aspect_getter + ultrawide::kAspectGetterPatch.displacement_offset;
  candidate.displacement_addresses[UI_PATCH_INDEX] =
      ui_scale_load + ultrawide::kUiScalePatch.displacement_offset;
  std::memcpy(
      &candidate.original_displacements[ASPECT_PATCH_INDEX],
      candidate.displacement_addresses[ASPECT_PATCH_INDEX],
      sizeof(std::int32_t));
  std::memcpy(
      &candidate.original_displacements[UI_PATCH_INDEX],
      candidate.displacement_addresses[UI_PATCH_INDEX],
      sizeof(std::int32_t));

  const auto aspect_original_target = reinterpret_cast<std::uintptr_t>(
                                          aspect_getter
                                          + ultrawide::kAspectGetterPatch.instruction.size())
                                      + candidate.original_displacements[ASPECT_PATCH_INDEX];
  const auto ui_original_target = reinterpret_cast<std::uintptr_t>(
                                      ui_scale_load
                                      + ultrawide::kUiScalePatch.instruction.size())
                                  + candidate.original_displacements[UI_PATCH_INDEX];
  if (aspect_original_target
          != reinterpret_cast<std::uintptr_t>(module->module_base)
                 + ultrawide::kAspectGetterPatch.expected_original_target_rva
      || ui_original_target
             != reinterpret_cast<std::uintptr_t>(module->module_base)
                    + ultrawide::kUiScalePatch.expected_original_target_rva) {
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
          ui_scale_load + ultrawide::kUiScalePatch.instruction.size())));
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
          ui_scale_load + ultrawide::kUiScalePatch.instruction.size()),
      reinterpret_cast<std::uintptr_t>(&runtime_data->ui_scale_bits));
  if (!aspect_displacement.has_value() || !ui_displacement.has_value()) {
    ultrawide_runtime_data.store(nullptr, std::memory_order_release);
    LogUltrawide(reshade::log::level::error, "allocated data is outside RIP-relative range.");
    return false;
  }

  candidate.redirected_displacements[ASPECT_PATCH_INDEX] = aspect_displacement.value();
  candidate.redirected_displacements[UI_PATCH_INDEX] = ui_displacement.value();

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
        !candidate.active_patches[ASPECT_PATCH_INDEX]
        && !candidate.active_patches[UI_PATCH_INDEX];
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
          "automatic override installed for Build 12158144: swapchain {}x{}, aspect {:.6f}, UI scale {:.6f}, mode {}.",
          width,
          height,
          values.aspect_ratio,
          values.ui_scale,
          aspect_ratio_enabled.load(std::memory_order_relaxed) ? "Auto" : "Vanilla 16:9"));
  return true;
}

void RestoreUltrawidePatch() {
  std::scoped_lock lock(ultrawide_patch_mutex);
  if (!ultrawide_patch.active_patches[ASPECT_PATCH_INDEX]
      && !ultrawide_patch.active_patches[UI_PATCH_INDEX]) {
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
  LogUltrawide(reshade::log::level::info, "original aspect and UI instructions restored.");
}

ShaderInjectData shader_injection;
std::atomic_bool scene_path_seen = false;
std::atomic_bool ui_path_seen = false;
std::atomic_uint64_t last_dlaa_sharpening_log_key =
    std::numeric_limits<std::uint64_t>::max();

struct DlaaSharpeningGate {
  bool active = false;
  bool exact_command_list_match = false;
  float strength = 0.f;
};

DlaaSharpeningGate GetDlaaSharpeningGate(
    reshade::api::command_list* command_list) {
  const bool exact_command_list_match =
      command_list != nullptr
      && temporal_capture::QueryDlssOutputForCommandList(
          command_list->get_native());
  // Detroit's main menu and some transition frames execute the scene
  // composite without recording the temporal TAA pass at all. Keep the
  // selected post-AA sharpening deterministic there; in gameplay the same
  // pass runs immediately after the verified DLAA output. Runtime status still
  // reports whether the reconstruction itself is DLAA or native fallback.
  const bool active =
      temporal_capture::GetMode() == DETROIT_DLSS_MODE_DLAA;
  return {
      .active = active,
      .exact_command_list_match = exact_command_list_match,
      .strength = active ? std::clamp(dlaa_sharpening, 0.f, 1.f) : 0.f,
  };
}

void ApplyDlaaSharpeningPayload(
    reshade::api::command_list* command_list,
    std::string_view pass_name,
    bool log_gate) {
  const auto gate = GetDlaaSharpeningGate(command_list);
  // One marks the selected DLAA post-AA path; the fractional excess carries
  // the independent scene-linear RCAS strength [0, 1]. The push constants are
  // copied into this dispatch, so later in-flight frames cannot alter it.
  shader_injection.reserved = gate.active ? 1.f + gate.strength : 0.f;

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
  // status nor the exact-list diagnostic changes the sharpening payload. Keep
  // them out of the deduplication key so the render thread cannot turn an
  // expected 5 <-> 6 transition into synchronous per-frame log I/O.
  const auto log_key = temporal_capture::MakeTelemetryKey(
      static_cast<std::uint32_t>(temporal_capture::GetMode()),
      gate.active,
      strength_percent);
  if (last_dlaa_sharpening_log_key.exchange(
          log_key,
          std::memory_order_acq_rel)
      == log_key) {
    return;
  }
  reshade::log::message(
      reshade::log::level::info,
      std::format(
          "Detroit DLAA sharpening: {} gate {}, strength {}%, exact command-list match {}, runtime status {}.",
          pass_name,
          gate.active ? "active" : "inactive",
          strength_percent,
          gate.exact_command_list_match ? "yes" : "no",
          static_cast<std::uint32_t>(temporal_capture::GetStatus()))
          .c_str());
}

bool OnSceneDraw(reshade::api::command_list* command_list) {
  if (command_list != nullptr) {
    temporal_capture::MarkMainTemporalCommandList(command_list->get_native());
  }
  ApplyDlaaSharpeningPayload(command_list, "scene RCAS", true);
  return true;
}

void OnSceneDrawn(reshade::api::command_list*) {
  scene_path_seen.store(true, std::memory_order_relaxed);
}

void OnUiDrawn(reshade::api::command_list*) {
  ui_path_seen.store(true, std::memory_order_relaxed);
}

bool OnFinalCasDraw(reshade::api::command_list* command_list) {
  // Scene RCAS owns DLAA sharpening. This optional native CAS variant only
  // needs the same mode marker so its own lobe can be disabled.
  ApplyDlaaSharpeningPayload(command_list, "native CAS suppression", false);
  return true;
}

renodx::mods::shader::CustomShaders custom_shaders = {
    {0xEBFBDDB1, {
                     .crc32 = 0xEBFBDDB1,
                     .code = __0xEBFBDDB1,
                     .on_draw = &OnSceneDraw,
                     .on_drawn = &OnSceneDrawn,
                 }},
    {0x2892BFCA, {
                     .crc32 = 0x2892BFCA,
                     .code = __0x2892BFCA,
                     .on_drawn = &OnUiDrawn,
                 }},
    {0x8808E4CC, {
                     .crc32 = 0x8808E4CC,
                     .code = __0x8808E4CC,
                     .on_drawn = &OnUiDrawn,
                 }},
    {0x9827B559, {
                     .crc32 = 0x9827B559,
                     .code = __0x9827B559,
                     .on_drawn = &OnUiDrawn,
                 }},
    {0x94F97DCF, {
                     .crc32 = 0x94F97DCF,
                     .code = __0x94F97DCF,
                     .on_draw = &OnFinalCasDraw,
                 }},
};

renodx::utils::settings::Settings settings =
    renodx::templates::settings::JoinSettings({
        renodx::templates::settings::CreateDefaultSettings({
            {"ToneMapType",
             {
                 .binding = &shader_injection.tone_map_type,
                 .default_value = 2.f,
                 .labels = {"Vanilla", "Reinhard", "RenoDRT"},
                 .parse = [](float value) { return value; },
             }},
            {"ToneMapPeakNits",
             {
                 .binding = &shader_injection.peak_white_nits,
                 .default_value = 1000.f,
                 .can_reset = false,
             }},
            {"ToneMapGameNits",
             {
                 .binding = &shader_injection.diffuse_white_nits,
                 .default_value = 203.f,
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
            {"ColorGradeHighlightSaturation", {.binding = &shader_injection.tone_map_highlight_saturation}},
            {"ColorGradeBlowout", {.binding = &shader_injection.tone_map_blowout}},
            {"ColorGradeFlare", {.binding = &shader_injection.tone_map_flare}},
            {"SceneGradeStrength", {
                                       .binding = &shader_injection.color_grade_strength,
                                       .default_value = 100.f,
                                       .label = "Scene Grading",
                                       .section = "Color Grading",
                                       .tooltip = "Strength of Detroit's original scene color grading.",
                                       .parse = [](float value) { return value * 0.01f; },
                                   }},
        }),
        renodx::templates::settings::CreateSettings({
            {{
                .key = "DLSSMode",
                .binding = &dlss_mode,
                .value_type = renodx::utils::settings::SettingValueType::INTEGER,
                .default_value = static_cast<float>(DETROIT_DLSS_MODE_NATIVE),
                .can_reset = true,
                .label = "Temporal Anti-Aliasing",
                .section = "DLSS",
                .tooltip = "DLAA runs NVIDIA NGX anti-aliasing at native resolution. Rejected frames fall back safely to Detroit's native TAA.",
                .labels = {"Native TAA", "DLAA"},
                .on_change_value = [](float, float current) {
                  ApplyDlssMode(current);
                },
            }},
            {{
                .key = "DLAASharpening",
                .binding = &dlaa_sharpening,
                .default_value = 0.f,
                .can_reset = true,
                .label = "DLAA Sharpening",
                .section = "DLSS",
                .tooltip = "Scene-linear post-AA RCAS before film grain/UI. It sharpens verified DLAA gameplay frames and remains testable in menu/non-temporal passes; zero is an exact passthrough.",
                .min = 0.f,
                .max = 100.f,
                .is_enabled = []() { return temporal_capture::GetMode() == DETROIT_DLSS_MODE_DLAA; },
                .parse = [](float value) { return value * 0.01f; },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Native TAA is active. The TAA runtime contract is still captured for diagnostics.",
                .section = "DLSS",
                .is_visible = []() {
                  return temporal_capture::GetStatus()
                         == temporal_capture::RuntimeStatus::kNative;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "A DLSS mode is selected; waiting for a complete verified TAA dispatch. Native TAA fallback is active.",
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
                .label = "TAA resources were captured, but current-frame b52/jitter, depth, motion-vector, exposure, history and UI-free-color proofs are incomplete. NGX is fail-closed and Native TAA remains active.",
                .section = "DLSS",
                .is_visible = []() {
                  return temporal_capture::GetStatus()
                         == temporal_capture::RuntimeStatus::kTemporalContractUnverified;
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "DLSS Super Resolution is waiting for or was rejected by the exact-build runtime scale controller. Native TAA fallback is active.",
                .section = "DLSS",
                .is_visible = []() {
                  return temporal_capture::GetStatus()
                         == temporal_capture::RuntimeStatus::kSuperResolutionScaleUnavailable;
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
                .label = "DLAA produced a valid result for this frame. Sharpening is controlled by DLAA Sharpening.",
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
                .tooltip = "Auto replaces Detroit's isolated 16:9 aspect getter with the Vulkan swapchain ratio and compensates Scaleform UI size. It does not stretch the final image.",
                .labels = {"Vanilla 16:9", "Auto (Ultrawide)"},
                .on_change_value = [](float, float current) {
                  ApplyAspectRatioMode(current);
                },
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = "Ultrawide is signature-gated to Steam Build 12158144. Auto uses 43:18 at 3440x1440 and keeps 16:9 unchanged.",
                .section = "Ultrawide",
            }},
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
                .label = "Experimental HDR + ultrawide RC for Steam Build 12158144 (Vulkan x64). Late chapters require user validation.",
                .section = "About",
            }},
            {{
                .value_type = renodx::utils::settings::SettingValueType::TEXT,
                .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
                .section = "About",
            }},
        }),
    });

void OnPresetOff() {
  renodx::utils::settings::UpdateSettings({
      {"OutputMode", OUTPUT_MODE_AUTO},
      {"ToneMapType", 0.f},
      {"ToneMapPeakNits", 1000.f},
      {"ToneMapGameNits", 203.f},
      {"ToneMapUINits", 300.f},
      {"ColorGradeExposure", 1.f},
      {"ColorGradeHighlights", 50.f},
      {"ColorGradeShadows", 50.f},
      {"ColorGradeContrast", 50.f},
      {"ColorGradeSaturation", 50.f},
      {"ColorGradeHighlightSaturation", 50.f},
      {"ColorGradeBlowout", 0.f},
      {"ColorGradeFlare", 0.f},
      {"SceneGradeStrength", 100.f},
      {"DLSSMode", static_cast<float>(DETROIT_DLSS_MODE_NATIVE)},
      {"DLAASharpening", 0.f},
      {"CASMode", CAS_MODE_VANILLA},
      {"CASStrength", 100.f},
  });
  OnAspectRatioModeChanged();
}

bool TryTrackGameSwapchain(reshade::api::swapchain* swapchain) {
  if (swapchain == nullptr) return false;
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

bool UpdateUltrawideFromSwapchain(reshade::api::swapchain* swapchain) {
  if (swapchain == nullptr || swapchain->get_back_buffer_count() == 0u) return false;

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

  RefreshUltrawideValues();
  if (ultrawide_installed.load(std::memory_order_acquire)) {
    const auto values = ultrawide::CalculateActiveValues(
        width,
        height,
        aspect_ratio_enabled.load(std::memory_order_relaxed));
    LogUltrawide(
        reshade::log::level::info,
        std::format(
            "swapchain {}x{} detected (aspect {:.6f}, UI scale {:.6f}).",
            width,
            height,
            values.aspect_ratio,
            values.ui_scale));
  }
  return true;
}

void OnInitSwapchain(reshade::api::swapchain* swapchain, bool) {
  if (!TryTrackGameSwapchain(swapchain) || !UpdateUltrawideFromSwapchain(swapchain)) return;
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

  auto* expected = static_cast<reshade::api::effect_runtime*>(nullptr);
  if (tracked_effect_runtime.compare_exchange_strong(
          expected, runtime, std::memory_order_acq_rel)
      || expected == runtime) {
    InitializeReShadeCaptureRequest();
  }
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

  // A resize destroys the old output contract. Restore the user's serialized
  // scale before any replacement swapchain can establish a new DLSS session.
  ShutdownDlssRenderScale();
  if (!resize) {
    RestoreUltrawidePatch();
    ultrawide_install_attempted.store(false, std::memory_order_release);
  }
}

void OnDestroyDevice(reshade::api::device* device) {
  // This callback runs outside the Windows loader lock and precedes addon
  // unload. It is the final safe point for removing the executable detour if
  // the swapchain teardown path did not already do so.
  if (auto* swapchain = tracked_swapchain.load(std::memory_order_acquire);
      swapchain != nullptr && swapchain->get_device() != device) {
    return;
  }
  ShutdownDlssRenderScale();
}

void OnPresent(
    reshade::api::command_queue*,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect*,
    const reshade::api::rect*,
    uint32_t,
    const reshade::api::rect*) {
  if (TryTrackGameSwapchain(swapchain) && UpdateUltrawideFromSwapchain(swapchain)
      && !ultrawide_install_attempted.exchange(true, std::memory_order_acq_rel)) {
    InstallUltrawidePatch();
  }
  UpdateDlssRenderScale();
  const auto color_space = swapchain->get_color_space();
  shader_injection.output_is_hdr =
      color_space == reshade::api::color_space::hdr10_st2084
              || color_space == reshade::api::color_space::hdr10_hlg
              || color_space == reshade::api::color_space::extended_srgb_linear
          ? 1.f
          : 0.f;
  shader_injection.scene_path_active =
      scene_path_seen.load(std::memory_order_relaxed) ? 1.f : 0.f;
  shader_injection.ui_path_active =
      ui_path_seen.load(std::memory_order_relaxed) ? 1.f : 0.f;
  TrySaveRequestedReShadeScreenshot(swapchain);
  temporal_capture::BeginNextFrame();
}

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION =
    "RenoDX for Detroit: Become Human (Vulkan, experimental)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
      renodx::mods::shader::allow_multiple_push_constants = true;
      renodx::mods::shader::force_pipeline_cloning = true;
      renodx::utils::settings::on_preset_changed_callbacks.emplace_back(
          &OnAspectRatioModeChanged);
      renodx::utils::settings::on_preset_changed_callbacks.emplace_back(
          &OnDlssModeChanged);
      reshade::register_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::register_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::register_event<reshade::addon_event::init_effect_runtime>(OnInitEffectRuntime);
      reshade::register_event<reshade::addon_event::destroy_effect_runtime>(OnDestroyEffectRuntime);
      reshade::register_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::register_event<reshade::addon_event::present>(OnPresent);
      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::init_swapchain>(OnInitSwapchain);
      reshade::unregister_event<reshade::addon_event::destroy_swapchain>(OnDestroySwapchain);
      reshade::unregister_event<reshade::addon_event::init_effect_runtime>(OnInitEffectRuntime);
      reshade::unregister_event<reshade::addon_event::destroy_effect_runtime>(OnDestroyEffectRuntime);
      reshade::unregister_event<reshade::addon_event::destroy_device>(OnDestroyDevice);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      ForceUltrawideRuntimeVanilla();
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    OnAspectRatioModeChanged();
    OnDlssModeChanged();
  }
  temporal_capture::Use(fdw_reason);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  return TRUE;
}
