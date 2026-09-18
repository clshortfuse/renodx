#pragma once

// MW3 2011 x64 microstutter core V8 ADAPTIVE ATTRIBUTION TEST.
//
// Target: September 2026 Steam x64 iw5sp.exe
// PE timestamp: 0x6A743A58
//
// Design goals:
//  * Preserve the engine's real event synchronization (never fake completion).
//  * Change only the exact 0x24AA36 / 1 ms renderer wait on the D3D9 Present
//    thread. Other threads at that same call site remain vanilla.
//  * Keep known renderer producers at ABOVE_NORMAL and temporarily burst them
//    to HIGHEST as soon as the Present thread suffers ONE timeout.
//  * Preserve timeout pressure across a short run of successful wakes so one
//    recovery frame does not immediately expose the Present thread to another
//    short timeout/retry storm.
//  * Release burst priority with both success and Present-count hysteresis.
//  * Do not hook Sleep, do not alter process priority, and do not patch renderer,
//    query, audio or streaming code bytes.
//  * Be independent of ReShade so the same core can be used by RenoDX or a
//    standalone injected DLL.

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#ifndef NOMINMAX
#define NOMINMAX
#endif

#include <Windows.h>
#include <intrin.h>

#include <array>
#include <atomic>
#include <cstdint>
#include <cmath>
#include <cstdio>
#include <cstring>

namespace mw3_microstutter {

enum class LogLevel : uint32_t {
  Info = 0,
  Warning = 1,
};

using LogFn = void (*)(LogLevel level, const char* message);

inline constexpr DWORD kExpectedPETimestamp = 0x6A743A58u;
inline constexpr uintptr_t kMainRenderWaitReturnRva = 0x0024AA36u;
inline constexpr DWORD kOriginalRenderWaitMs = 1u;

// V8 keeps the proven 8/12/20 ms event ceilings, but replaces the fixed ultra-low
// V7 thresholds with a learned renderer-wait baseline. It reacts to waits that
// are abnormal for the current machine instead of treating every tiny scheduler
// fluctuation as a stall. It avoids entering the engine's
// timeout/retry path as easily. These are MAXIMUM wait times: SetEvent wakes
// the Present thread immediately, so a producer that is ready in 0.2 ms still
// returns in ~0.2 ms. The larger ceilings matter only when the renderer is late.
inline constexpr DWORD kPresentWaitBaseMs = 8u;
inline constexpr DWORD kPresentWaitStage2Ms = 12u;
inline constexpr DWORD kPresentWaitBurstMs = 20u;

// One real timeout is enough to enter burst recovery. V8 can also prime the
// producer side before a timeout when the exact renderer wait is statistically
// late relative to its learned recent baseline.
inline constexpr uint32_t kBurstAfterPresentTimeouts = 1u;
inline constexpr uint64_t kBurstMinHoldPresents = 4u;
inline constexpr uint64_t kBurstForceReleaseAfterPresents = 10u;
inline constexpr uint32_t kBurstReleaseSuccesses = 12u;

inline constexpr uint32_t kTimeoutPressureAdd = 4u;
inline constexpr uint32_t kTimeoutPressureMax = 12u;
inline constexpr uint32_t kTimeoutPressureBurstThreshold = 3u;

// Adaptive renderer-wait detector. The first few successful waits are used to
// establish an EWMA baseline and jitter estimate. Afterwards the thresholds are
// baseline-relative, with conservative floors so normal QPC/scheduler noise does
// not cause constant bursting on very fast systems.
inline constexpr uint32_t kAdaptiveWarmupSamples = 64u;
inline constexpr uint64_t kAdaptiveFallbackCleanUs = 75u;
inline constexpr uint64_t kAdaptiveFallbackSoftUs = 150u;
inline constexpr uint64_t kAdaptiveFallbackStrongUs = 400u;
inline constexpr uint64_t kAdaptiveMinCleanUs = 50u;
inline constexpr uint64_t kAdaptiveMaxCleanUs = 300u;
inline constexpr uint64_t kAdaptiveMinSoftUs = 100u;
inline constexpr uint64_t kAdaptiveMaxSoftUs = 1800u;
inline constexpr uint64_t kAdaptiveMinStrongUs = 250u;
inline constexpr uint64_t kAdaptiveMaxStrongUs = 5000u;
inline constexpr uint32_t kSoftPressureAdd = 2u;
inline constexpr uint32_t kStrongSoftPressureAdd = 4u;
inline constexpr uint32_t kSoftBurstAfterStreak = 2u;
inline constexpr uint64_t kSoftBurstHoldPresents = 3u;

// Frame-overrun correlation is deliberately independent of a specific FPS cap.
// V8 learns the observed D3D9 Present period and calls a frame late when it is
// more than ~2.5% (or 300 us) beyond that learned period.
inline constexpr uint64_t kFramePeriodMinUs = 2000u;
inline constexpr uint64_t kFramePeriodMaxUs = 100000u;
inline constexpr uint64_t kFrameOverrunMinHeadroomUs = 300u;
inline constexpr uint32_t kFrameOverrunHeadroomDivisor = 40u;  // 2.5%

// Experimental source-side scheduling test. The producer thread itself joins
// the Windows MMCSS "Games" task the first time the known renderer SetEvent
// path is observed. Failure is harmless and falls back to the normal V8 policy.
// MMCSS registration is process-lifetime in this test build; do not hot-unload
// the addon while the game is actively running.
inline constexpr bool kEnableMmcssGames = true;

inline constexpr uintptr_t kProducerRvaBegin = 0x001E9000u;
inline constexpr uintptr_t kProducerRvaEnd = 0x001EB000u;
inline constexpr int kProducerBasePriority = THREAD_PRIORITY_ABOVE_NORMAL;
inline constexpr int kProducerBurstPriority = THREAD_PRIORITY_HIGHEST;
inline constexpr uint64_t kArmAfterPresents = 120u;

// Read-only build signatures. These accept both the vanilla D3DGETDATA_FLUSH
// form and the earlier optional no-FLUSH experiment, but this core does not
// modify either location.
inline constexpr uintptr_t kSignatureRva0 = 0x00186672u;
inline constexpr uintptr_t kSignatureRva1 = 0x001E9746u;
inline constexpr std::array<uint8_t, 10> kQueryPollOriginal = {
    0x41, 0xB9, 0x01, 0x00, 0x00,
    0x00, 0x45, 0x8D, 0x41, 0x03,
};
inline constexpr std::array<uint8_t, 10> kQueryPollNoFlush = {
    0x45, 0x33, 0xC9, 0x41, 0xB8,
    0x04, 0x00, 0x00, 0x00, 0x90,
};

inline LogFn g_logger = nullptr;
inline uintptr_t g_exe_base = 0u;
inline uintptr_t g_exe_end = 0u;
inline DWORD g_exe_timestamp = 0u;
inline std::atomic<bool> g_exe_verified{false};
inline std::atomic<bool> g_init_attempted{false};
inline std::atomic<bool> g_fix_armed{false};

inline std::atomic<uint64_t> g_present_count{0u};
inline std::atomic<DWORD> g_present_thread_id{0u};
inline std::atomic<uintptr_t> g_renderer_sync_handle{0u};
inline std::atomic<uintptr_t> g_logged_sync_handle{0u};

inline std::atomic<uint32_t> g_present_timeout_streak{0u};
inline std::atomic<uint32_t> g_timeout_pressure{0u};
inline std::atomic<uint32_t> g_successes_since_timeout{0u};
inline std::atomic<bool> g_producer_burst_active{false};
inline std::atomic<uint64_t> g_burst_hold_until_present{0u};
inline std::atomic<uint64_t> g_last_stall_present{0u};
inline std::atomic<uint32_t> g_soft_stall_streak{0u};
inline uint64_t g_qpc_frequency = 0u;


// Exact renderer-wait baseline (Present thread only).
inline double g_wait_baseline_us = 0.0;
inline double g_wait_deviation_us = 0.0;
inline uint64_t g_wait_baseline_samples = 0u;

// Per-frame wait attribution. The hook accumulates target-wait cost and the
// following D3D9 Present consumes it for the frame that just completed.
inline std::atomic<uint64_t> g_current_frame_wait_total_us{0u};
inline std::atomic<uint64_t> g_current_frame_wait_max_us{0u};
inline std::atomic<int64_t> g_last_d3d9_present_qpc{0};
inline std::atomic<int64_t> g_last_proxy_present_qpc{0};
inline std::atomic<uint64_t> g_frame_period_us{0u};
inline std::atomic<uint64_t> g_frame_period_samples{0u};
inline std::atomic<uint64_t> g_frame_outlier_candidate_us{0u};
inline std::atomic<uint32_t> g_frame_outlier_streak{0u};
inline std::atomic<uint64_t> g_proxy_gap_baseline_us{0u};
inline std::atomic<uint64_t> g_proxy_gap_samples{0u};

inline std::atomic<uint64_t> g_target_present_calls{0u};
inline std::atomic<uint64_t> g_target_present_base_calls{0u};
inline std::atomic<uint64_t> g_target_present_stage2_calls{0u};
inline std::atomic<uint64_t> g_target_present_burst_calls{0u};
inline std::atomic<uint64_t> g_target_present_object0{0u};
inline std::atomic<uint64_t> g_target_present_timeouts{0u};
inline std::atomic<uint64_t> g_target_present_failed{0u};
inline std::atomic<uint64_t> g_target_present_near_soft_stalls{0u};
inline std::atomic<uint64_t> g_target_present_soft_stalls{0u};
inline std::atomic<uint64_t> g_target_present_hard_soft_stalls{0u};
inline std::atomic<uint64_t> g_target_present_max_wait_us{0u};
inline std::atomic<uint64_t> g_timeout_base_tier{0u};
inline std::atomic<uint64_t> g_timeout_stage2_tier{0u};
inline std::atomic<uint64_t> g_timeout_burst_tier{0u};
inline std::atomic<uint64_t> g_burst_activations{0u};
inline std::atomic<uint64_t> g_burst_deactivations{0u};

inline std::atomic<uint64_t> g_frame_overruns{0u};
inline std::atomic<uint64_t> g_frame_overruns_renderer{0u};
inline std::atomic<uint64_t> g_frame_overruns_near_renderer{0u};
inline std::atomic<uint64_t> g_frame_overruns_unattributed{0u};
inline std::atomic<uint64_t> g_frame_max_interval_us{0u};
inline std::atomic<uint64_t> g_proxy_present_count{0u};
inline std::atomic<uint64_t> g_proxy_interval_overruns{0u};
inline std::atomic<uint64_t> g_proxy_late_gaps{0u};
inline std::atomic<uint64_t> g_proxy_max_gap_us{0u};
inline std::atomic<uint64_t> g_mmcss_registered{0u};
inline std::atomic<uint64_t> g_mmcss_failed{0u};

inline void SetLogger(LogFn logger) {
  g_logger = logger;
}

inline void Log(LogLevel level, const char* message) {
  if (g_logger != nullptr && message != nullptr) {
    g_logger(level, message);
  }
}

inline bool AddressRangeValid(uintptr_t rva, size_t size) {
  if (g_exe_base == 0u || g_exe_end <= g_exe_base) return false;
  if (rva > (g_exe_end - g_exe_base)) return false;
  const uintptr_t address = g_exe_base + rva;
  if (address < g_exe_base || address > g_exe_end) return false;
  if (size > static_cast<size_t>(g_exe_end - address)) return false;
  return true;
}

inline bool BytesMatchEither(uintptr_t rva) {
  if (!AddressRangeValid(rva, kQueryPollOriginal.size())) return false;
  const auto* ptr = reinterpret_cast<const uint8_t*>(g_exe_base + rva);
  return std::memcmp(ptr, kQueryPollOriginal.data(), kQueryPollOriginal.size()) == 0
      || std::memcmp(ptr, kQueryPollNoFlush.data(), kQueryPollNoFlush.size()) == 0;
}

inline bool VerifyTargetBuild() {
  if (g_exe_verified.load(std::memory_order_acquire)) return true;

  auto* module = reinterpret_cast<uint8_t*>(GetModuleHandleW(nullptr));
  if (module == nullptr) return false;

  const auto* dos = reinterpret_cast<const IMAGE_DOS_HEADER*>(module);
  if (dos->e_magic != IMAGE_DOS_SIGNATURE || dos->e_lfanew <= 0) {
    Log(LogLevel::Warning, "[MW3 Microstutter V8] REFUSED: invalid executable DOS header.");
    return false;
  }

  const auto* nt = reinterpret_cast<const IMAGE_NT_HEADERS64*>(
      module + static_cast<uintptr_t>(dos->e_lfanew));
  if (nt->Signature != IMAGE_NT_SIGNATURE
      || nt->FileHeader.Machine != IMAGE_FILE_MACHINE_AMD64
      || nt->OptionalHeader.Magic != IMAGE_NT_OPTIONAL_HDR64_MAGIC) {
    Log(LogLevel::Warning, "[MW3 Microstutter V8] REFUSED: executable is not the expected x64 PE build.");
    return false;
  }

  g_exe_base = reinterpret_cast<uintptr_t>(module);
  g_exe_end = g_exe_base + nt->OptionalHeader.SizeOfImage;
  g_exe_timestamp = nt->FileHeader.TimeDateStamp;

  const bool timestamp_ok = g_exe_timestamp == kExpectedPETimestamp;
  const bool signatures_ok = BytesMatchEither(kSignatureRva0)
      && BytesMatchEither(kSignatureRva1);
  const bool ok = timestamp_ok && signatures_ok;

  char message[256] = {};
  std::snprintf(
      message,
      sizeof(message),
      "[MW3 Microstutter V8] EXE verification: timestamp=0x%08lX signatures=%s result=%s",
      static_cast<unsigned long>(g_exe_timestamp),
      signatures_ok ? "matched" : "mismatch",
      ok ? "OK" : "REFUSED");
  Log(ok ? LogLevel::Info : LogLevel::Warning, message);

  g_exe_verified.store(ok, std::memory_order_release);
  return ok;
}

inline uintptr_t ReturnAddressToExeRva(uintptr_t return_address) {
  if (return_address < g_exe_base || return_address >= g_exe_end) return 0u;
  return return_address - g_exe_base;
}


using AvSetMmThreadCharacteristicsWFn = HANDLE (WINAPI*)(LPCWSTR, LPDWORD);
inline HMODULE g_avrt_module = nullptr;
inline AvSetMmThreadCharacteristicsWFn g_av_set_mm_thread_characteristics = nullptr;

inline void InitializeMmcssApi() {
  if (!kEnableMmcssGames || g_av_set_mm_thread_characteristics != nullptr) return;
  HMODULE module = LoadLibraryW(L"avrt.dll");
  if (module == nullptr) {
    Log(LogLevel::Warning,
        "[MW3 Microstutter V8] MMCSS Games experiment unavailable: avrt.dll could not be loaded.");
    return;
  }
  auto fn = reinterpret_cast<AvSetMmThreadCharacteristicsWFn>(
      GetProcAddress(module, "AvSetMmThreadCharacteristicsW"));
  if (fn == nullptr) {
    Log(LogLevel::Warning,
        "[MW3 Microstutter V8] MMCSS Games experiment unavailable: AvSetMmThreadCharacteristicsW missing.");
    return;
  }
  // Keep Avrt.dll loaded for process lifetime. Producer MMCSS associations must
  // be reverted from the same producer thread, so hot-unload is intentionally
  // unsupported for this experiment.
  g_avrt_module = module;
  g_av_set_mm_thread_characteristics = fn;
  Log(LogLevel::Info,
      "[MW3 Microstutter V8] MMCSS Games API ready (experimental producer registration enabled).");
}

inline void MaybeRegisterCurrentProducerMmcss(
    uintptr_t set_caller_rva,
    HANDLE event_handle) {
  if (!kEnableMmcssGames || g_av_set_mm_thread_characteristics == nullptr) return;
  if (set_caller_rva < kProducerRvaBegin || set_caller_rva >= kProducerRvaEnd) return;

  const uintptr_t learned_handle =
      g_renderer_sync_handle.load(std::memory_order_acquire);
  if (learned_handle == 0u
      || reinterpret_cast<uintptr_t>(event_handle) != learned_handle) {
    return;
  }
  if (GetCurrentThreadId() == g_present_thread_id.load(std::memory_order_relaxed)) {
    return;
  }

  thread_local bool tls_mmcss_attempted = false;
  thread_local HANDLE tls_mmcss_handle = nullptr;
  thread_local DWORD tls_mmcss_task_index = 0u;
  if (tls_mmcss_attempted) return;
  tls_mmcss_attempted = true;

  tls_mmcss_handle = g_av_set_mm_thread_characteristics(
      L"Games",
      &tls_mmcss_task_index);
  if (tls_mmcss_handle != nullptr) {
    g_mmcss_registered.fetch_add(1u, std::memory_order_relaxed);
    char message[256] = {};
    std::snprintf(
        message,
        sizeof(message),
        "[MW3 Microstutter V8] producer thread=%lu joined MMCSS Games task index=%lu",
        static_cast<unsigned long>(GetCurrentThreadId()),
        static_cast<unsigned long>(tls_mmcss_task_index));
    Log(LogLevel::Info, message);
  } else {
    g_mmcss_failed.fetch_add(1u, std::memory_order_relaxed);
    char message[256] = {};
    std::snprintf(
        message,
        sizeof(message),
        "[MW3 Microstutter V8] producer thread=%lu MMCSS Games registration failed error=%lu; normal priority fallback remains active",
        static_cast<unsigned long>(GetCurrentThreadId()),
        static_cast<unsigned long>(GetLastError()));
    Log(LogLevel::Warning, message);
  }
}

struct BoostedThread {
  DWORD thread_id = 0u;
  HANDLE handle = nullptr;
  int original_priority = THREAD_PRIORITY_NORMAL;
  int base_priority = THREAD_PRIORITY_ABOVE_NORMAL;
  BOOL original_boost_disabled = FALSE;
  bool have_original_boost = false;
  bool changed = false;
  uintptr_t first_set_caller_rva = 0u;
};

inline constexpr size_t kMaxBoostedThreads = 8u;
inline std::array<BoostedThread, kMaxBoostedThreads> g_boosted_threads = {};
inline SRWLOCK g_boost_lock = SRWLOCK_INIT;

inline int MaxPriority(int lhs, int rhs) {
  return lhs > rhs ? lhs : rhs;
}

inline void SetKnownProducerBurst(bool enable) {
  const bool previous =
      g_producer_burst_active.exchange(enable, std::memory_order_acq_rel);
  if (previous == enable) return;

  if (enable) {
    g_burst_activations.fetch_add(1u, std::memory_order_relaxed);
  } else {
    g_burst_deactivations.fetch_add(1u, std::memory_order_relaxed);
  }

  AcquireSRWLockExclusive(&g_boost_lock);
  for (auto& slot : g_boosted_threads) {
    if (slot.handle == nullptr) continue;
    const int target = enable
        ? MaxPriority(slot.base_priority, kProducerBurstPriority)
        : slot.base_priority;
    SetThreadPriority(slot.handle, target);
  }
  ReleaseSRWLockExclusive(&g_boost_lock);
}

inline void MaybeBoostCurrentProducer(uintptr_t set_caller_rva, HANDLE event_handle) {
  if (!g_fix_armed.load(std::memory_order_acquire)) return;

  thread_local uintptr_t tls_registered_event = 0u;
  const uintptr_t current_handle = reinterpret_cast<uintptr_t>(event_handle);
  if (current_handle != 0u && tls_registered_event == current_handle) return;

  if (set_caller_rva < kProducerRvaBegin || set_caller_rva >= kProducerRvaEnd) {
    return;
  }

  const uintptr_t learned_handle =
      g_renderer_sync_handle.load(std::memory_order_acquire);
  if (learned_handle == 0u || current_handle != learned_handle) return;

  const DWORD thread_id = GetCurrentThreadId();
  const DWORD present_thread =
      g_present_thread_id.load(std::memory_order_relaxed);
  if (thread_id == 0u || (present_thread != 0u && thread_id == present_thread)) {
    return;
  }

  MaybeRegisterCurrentProducerMmcss(set_caller_rva, event_handle);

  AcquireSRWLockExclusive(&g_boost_lock);

  for (const auto& slot : g_boosted_threads) {
    if (slot.thread_id == thread_id) {
      tls_registered_event = current_handle;
      ReleaseSRWLockExclusive(&g_boost_lock);
      return;
    }
  }

  BoostedThread* free_slot = nullptr;
  for (auto& slot : g_boosted_threads) {
    if (slot.thread_id == 0u) {
      free_slot = &slot;
      break;
    }
  }
  if (free_slot == nullptr) {
    ReleaseSRWLockExclusive(&g_boost_lock);
    return;
  }

  HANDLE real_thread = OpenThread(
      THREAD_QUERY_INFORMATION | THREAD_SET_INFORMATION,
      FALSE,
      thread_id);
  if (real_thread == nullptr) {
    ReleaseSRWLockExclusive(&g_boost_lock);
    return;
  }

  const int original_priority = GetThreadPriority(real_thread);
  if (original_priority == THREAD_PRIORITY_ERROR_RETURN) {
    CloseHandle(real_thread);
    ReleaseSRWLockExclusive(&g_boost_lock);
    return;
  }

  BOOL original_boost_disabled = FALSE;
  const bool have_original_boost =
      GetThreadPriorityBoost(real_thread, &original_boost_disabled) != FALSE;

  const int base_priority = MaxPriority(original_priority, kProducerBasePriority);
  const bool burst_active =
      g_producer_burst_active.load(std::memory_order_relaxed);
  const int requested_priority = burst_active
      ? MaxPriority(base_priority, kProducerBurstPriority)
      : base_priority;

  bool changed = false;
  if (requested_priority != original_priority) {
    changed = SetThreadPriority(real_thread, requested_priority) != FALSE;
  }

  // FALSE keeps Windows' normal dynamic priority boosts enabled.
  SetThreadPriorityBoost(real_thread, FALSE);

  free_slot->thread_id = thread_id;
  free_slot->handle = real_thread;
  free_slot->original_priority = original_priority;
  free_slot->base_priority = base_priority;
  free_slot->original_boost_disabled = original_boost_disabled;
  free_slot->have_original_boost = have_original_boost;
  free_slot->changed = changed;
  free_slot->first_set_caller_rva = set_caller_rva;

  tls_registered_event = current_handle;

  char message[256] = {};
  std::snprintf(
      message,
      sizeof(message),
      "[MW3 Microstutter V8] producer thread=%lu SetEvent caller=0x%llX priority %d -> %d%s",
      static_cast<unsigned long>(thread_id),
      static_cast<unsigned long long>(set_caller_rva),
      original_priority,
      requested_priority,
      burst_active ? " (joined burst)" : "");
  Log(changed || requested_priority == original_priority
          ? LogLevel::Info
          : LogLevel::Warning,
      message);

  ReleaseSRWLockExclusive(&g_boost_lock);
}

inline void RestoreProducerPriorities() {
  AcquireSRWLockExclusive(&g_boost_lock);
  for (auto& slot : g_boosted_threads) {
    if (slot.thread_id == 0u) continue;
    if (slot.handle != nullptr) {
      SetThreadPriority(slot.handle, slot.original_priority);
      if (slot.have_original_boost) {
        SetThreadPriorityBoost(slot.handle, slot.original_boost_disabled);
      }
      CloseHandle(slot.handle);
    }
    slot = {};
  }
  ReleaseSRWLockExclusive(&g_boost_lock);
}

inline void AddTimeoutPressure(uint32_t amount) {
  uint32_t current = g_timeout_pressure.load(std::memory_order_relaxed);
  for (;;) {
    const uint32_t desired =
        (current >= kTimeoutPressureMax - amount)
            ? kTimeoutPressureMax
            : current + amount;
    if (g_timeout_pressure.compare_exchange_weak(
            current,
            desired,
            std::memory_order_relaxed,
            std::memory_order_relaxed)) {
      return;
    }
  }
}

inline void UpdateMaxWaitUs(uint64_t value) {
  uint64_t current =
      g_target_present_max_wait_us.load(std::memory_order_relaxed);
  while (value > current
      && !g_target_present_max_wait_us.compare_exchange_weak(
          current,
          value,
          std::memory_order_relaxed,
          std::memory_order_relaxed)) {
  }
}


struct AdaptiveWaitThresholds {
  uint64_t clean_us = kAdaptiveFallbackCleanUs;
  uint64_t soft_us = kAdaptiveFallbackSoftUs;
  uint64_t strong_us = kAdaptiveFallbackStrongUs;
};

inline uint64_t ClampDoubleToU64(double value, uint64_t lo, uint64_t hi) {
  if (value <= static_cast<double>(lo)) return lo;
  if (value >= static_cast<double>(hi)) return hi;
  return static_cast<uint64_t>(value + 0.5);
}

inline AdaptiveWaitThresholds GetAdaptiveWaitThresholds() {
  if (g_wait_baseline_samples < 16u || g_wait_baseline_us <= 0.0) {
    return {};
  }

  const double deviation = g_wait_deviation_us < 10.0
      ? 10.0
      : g_wait_deviation_us;
  const double clean_headroom = deviation * 1.25 > 25.0
      ? deviation * 1.25
      : 25.0;
  const double soft_headroom = deviation * 3.0 > 75.0
      ? deviation * 3.0
      : 75.0;
  const double strong_headroom = deviation * 6.0 > 200.0
      ? deviation * 6.0
      : 200.0;

  AdaptiveWaitThresholds thresholds = {};
  thresholds.clean_us = ClampDoubleToU64(
      g_wait_baseline_us + clean_headroom,
      kAdaptiveMinCleanUs,
      kAdaptiveMaxCleanUs);
  thresholds.soft_us = ClampDoubleToU64(
      g_wait_baseline_us + soft_headroom,
      kAdaptiveMinSoftUs,
      kAdaptiveMaxSoftUs);
  thresholds.strong_us = ClampDoubleToU64(
      g_wait_baseline_us + strong_headroom,
      kAdaptiveMinStrongUs,
      kAdaptiveMaxStrongUs);

  if (thresholds.soft_us <= thresholds.clean_us) {
    thresholds.soft_us = thresholds.clean_us + 25u;
  }
  if (thresholds.strong_us <= thresholds.soft_us + 50u) {
    thresholds.strong_us = thresholds.soft_us + 50u;
  }
  return thresholds;
}

inline void ObserveCleanRendererWait(uint64_t elapsed_us) {
  if (elapsed_us == 0u) return;

  // During warmup, cap pathological startup samples so they do not teach the
  // detector that a multi-millisecond hitch is normal. After warmup only waits
  // below the current soft threshold are allowed to move the baseline.
  const AdaptiveWaitThresholds thresholds = GetAdaptiveWaitThresholds();
  if (g_wait_baseline_samples >= kAdaptiveWarmupSamples
      && elapsed_us > thresholds.soft_us) {
    return;
  }

  double sample = static_cast<double>(elapsed_us);
  if (g_wait_baseline_samples < kAdaptiveWarmupSamples && sample > 1000.0) {
    sample = 1000.0;
  }

  if (g_wait_baseline_samples == 0u) {
    g_wait_baseline_us = sample;
    g_wait_deviation_us = sample * 0.25 + 10.0;
    g_wait_baseline_samples = 1u;
    return;
  }

  const double alpha = g_wait_baseline_samples < kAdaptiveWarmupSamples
      ? 0.08
      : 0.02;
  const double error = sample - g_wait_baseline_us;
  g_wait_baseline_us += alpha * error;
  const double abs_error = std::fabs(error);
  g_wait_deviation_us += alpha * (abs_error - g_wait_deviation_us);
  ++g_wait_baseline_samples;
}

inline void UpdateAtomicMax(std::atomic<uint64_t>& target, uint64_t value) {
  uint64_t current = target.load(std::memory_order_relaxed);
  while (value > current
      && !target.compare_exchange_weak(
          current,
          value,
          std::memory_order_relaxed,
          std::memory_order_relaxed)) {
  }
}

inline uint64_t CurrentFrameOverrunThresholdUs(uint64_t period_us) {
  if (period_us == 0u) return 0u;
  const uint64_t proportional = period_us / kFrameOverrunHeadroomDivisor;
  const uint64_t headroom = proportional > kFrameOverrunMinHeadroomUs
      ? proportional
      : kFrameOverrunMinHeadroomUs;
  return period_us + headroom;
}

inline void ObserveFramePeriod(uint64_t interval_us, bool overrun) {
  if (interval_us < kFramePeriodMinUs || interval_us > kFramePeriodMaxUs) return;

  uint64_t period = g_frame_period_us.load(std::memory_order_relaxed);
  uint64_t samples = g_frame_period_samples.load(std::memory_order_relaxed);
  if (period == 0u) {
    g_frame_period_us.store(interval_us, std::memory_order_relaxed);
    g_frame_period_samples.store(1u, std::memory_order_relaxed);
    return;
  }

  // Do not let hitches inflate the learned cap. Warmup converges quickly;
  // stable operation moves slowly so the baseline tracks small cap changes.
  if (overrun && samples >= 16u) return;
  const uint64_t low = period * 3u / 4u;
  const uint64_t high = period * 5u / 4u;
  if (samples >= 16u && (interval_us < low || interval_us > high)) {
    // A menu -> gameplay transition or a changed RenoDX cap can legitimately
    // move the frame period by much more than 25%. Rebase only after 30
    // consecutive intervals agree on the new cadence, so one hitch can never
    // redefine the limiter baseline.
    uint64_t candidate =
        g_frame_outlier_candidate_us.load(std::memory_order_relaxed);
    uint32_t streak = g_frame_outlier_streak.load(std::memory_order_relaxed);
    const uint64_t candidate_low = candidate * 9u / 10u;
    const uint64_t candidate_high = candidate * 11u / 10u;
    if (candidate != 0u
        && interval_us >= candidate_low
        && interval_us <= candidate_high) {
      ++streak;
      const uint64_t smoothed = (candidate * 7u + interval_us) / 8u;
      g_frame_outlier_candidate_us.store(smoothed, std::memory_order_relaxed);
    } else {
      candidate = interval_us;
      streak = 1u;
      g_frame_outlier_candidate_us.store(candidate, std::memory_order_relaxed);
    }
    g_frame_outlier_streak.store(streak, std::memory_order_relaxed);
    if (streak >= 30u) {
      const uint64_t rebased =
          g_frame_outlier_candidate_us.load(std::memory_order_relaxed);
      g_frame_period_us.store(rebased, std::memory_order_relaxed);
      g_frame_period_samples.store(16u, std::memory_order_relaxed);
      g_frame_outlier_candidate_us.store(0u, std::memory_order_relaxed);
      g_frame_outlier_streak.store(0u, std::memory_order_relaxed);
    }
    return;
  }

  g_frame_outlier_candidate_us.store(0u, std::memory_order_relaxed);
  g_frame_outlier_streak.store(0u, std::memory_order_relaxed);
  const uint64_t divisor = samples < 64u ? 8u : 64u;
  const uint64_t next = (period * (divisor - 1u) + interval_us) / divisor;
  g_frame_period_us.store(next, std::memory_order_relaxed);
  g_frame_period_samples.store(samples + 1u, std::memory_order_relaxed);
}

inline void NoteRendererStall(uint64_t present_count, uint64_t hold_presents) {
  g_last_stall_present.store(present_count, std::memory_order_relaxed);
  const uint64_t desired = present_count + hold_presents;
  uint64_t current =
      g_burst_hold_until_present.load(std::memory_order_relaxed);
  while (desired > current
      && !g_burst_hold_until_present.compare_exchange_weak(
          current,
          desired,
          std::memory_order_relaxed,
          std::memory_order_relaxed)) {
  }
}

inline uint64_t QpcElapsedUs(const LARGE_INTEGER& begin, const LARGE_INTEGER& end) {
  if (g_qpc_frequency == 0u || end.QuadPart <= begin.QuadPart) return 0u;
  const uint64_t ticks = static_cast<uint64_t>(end.QuadPart - begin.QuadPart);
  return (ticks * 1000000ull) / g_qpc_frequency;
}

using WaitForSingleObjectFn = DWORD (WINAPI*)(HANDLE, DWORD);
using SetEventFn = BOOL (WINAPI*)(HANDLE);

inline void* g_orig_wait_single = nullptr;
inline void* g_orig_set_event = nullptr;

inline DWORD WINAPI HookWaitForSingleObject(HANDLE handle, DWORD milliseconds) {
  const auto original =
      reinterpret_cast<WaitForSingleObjectFn>(g_orig_wait_single);
  if (original == nullptr) return WAIT_FAILED;

  if (!g_fix_armed.load(std::memory_order_acquire)) {
    return original(handle, milliseconds);
  }

  const uintptr_t caller_rva = ReturnAddressToExeRva(
      reinterpret_cast<uintptr_t>(_ReturnAddress()));

  if (caller_rva != kMainRenderWaitReturnRva
      || milliseconds != kOriginalRenderWaitMs
      || handle == nullptr) {
    return original(handle, milliseconds);
  }

  const uintptr_t handle_value = reinterpret_cast<uintptr_t>(handle);
  g_renderer_sync_handle.store(handle_value, std::memory_order_release);

  uintptr_t logged = g_logged_sync_handle.load(std::memory_order_relaxed);
  if (logged != handle_value
      && g_logged_sync_handle.compare_exchange_strong(
          logged,
          handle_value,
          std::memory_order_acq_rel,
          std::memory_order_relaxed)) {
    char message[320] = {};
    std::snprintf(
        message,
        sizeof(message),
        "[MW3 Microstutter V8] learned renderer sync event=0x%llX at 0x24AA36; Present waits=%lu/%lu/%lums; adaptive wait baseline enabled; worker waits=vanilla1ms",
        static_cast<unsigned long long>(handle_value),
        static_cast<unsigned long>(kPresentWaitBaseMs),
        static_cast<unsigned long>(kPresentWaitStage2Ms),
        static_cast<unsigned long>(kPresentWaitBurstMs));
    Log(LogLevel::Info, message);
  }

  const DWORD thread_id = GetCurrentThreadId();
  const DWORD present_thread =
      g_present_thread_id.load(std::memory_order_relaxed);

  // The exact wait site is shared by renderer threads. Only the real Present
  // thread receives the V8 policy; worker-thread semantics stay vanilla.
  if (present_thread == 0u || thread_id != present_thread) {
    return original(handle, milliseconds);
  }

  const uint32_t timeout_streak =
      g_present_timeout_streak.load(std::memory_order_relaxed);
  const uint32_t timeout_pressure =
      g_timeout_pressure.load(std::memory_order_relaxed);

  enum class WaitTier : uint32_t { Base, Stage2, Burst };
  WaitTier tier = WaitTier::Base;
  DWORD effective_timeout = kPresentWaitBaseMs;

  if (timeout_streak >= 2u
      || timeout_pressure >= kTimeoutPressureBurstThreshold) {
    tier = WaitTier::Burst;
    effective_timeout = kPresentWaitBurstMs;
    g_target_present_burst_calls.fetch_add(1u, std::memory_order_relaxed);
  } else if (timeout_streak >= 1u || timeout_pressure != 0u) {
    tier = WaitTier::Stage2;
    effective_timeout = kPresentWaitStage2Ms;
    g_target_present_stage2_calls.fetch_add(1u, std::memory_order_relaxed);
  } else {
    g_target_present_base_calls.fetch_add(1u, std::memory_order_relaxed);
  }
  g_target_present_calls.fetch_add(1u, std::memory_order_relaxed);

  LARGE_INTEGER qpc_begin = {};
  LARGE_INTEGER qpc_end = {};
  if (g_qpc_frequency != 0u) QueryPerformanceCounter(&qpc_begin);
  const DWORD result = original(handle, effective_timeout);
  if (g_qpc_frequency != 0u) QueryPerformanceCounter(&qpc_end);

  const uint64_t elapsed_us = QpcElapsedUs(qpc_begin, qpc_end);
  if (elapsed_us != 0u) {
    UpdateMaxWaitUs(elapsed_us);
    g_current_frame_wait_total_us.fetch_add(elapsed_us, std::memory_order_relaxed);
    UpdateAtomicMax(g_current_frame_wait_max_us, elapsed_us);
  }

  if (result == WAIT_OBJECT_0) {
    g_target_present_object0.fetch_add(1u, std::memory_order_relaxed);
    g_present_timeout_streak.store(0u, std::memory_order_relaxed);

    const uint64_t present_count =
        g_present_count.load(std::memory_order_relaxed);
    const AdaptiveWaitThresholds adaptive = GetAdaptiveWaitThresholds();

    if (elapsed_us >= adaptive.strong_us) {
      g_target_present_soft_stalls.fetch_add(1u, std::memory_order_relaxed);
      g_target_present_hard_soft_stalls.fetch_add(1u, std::memory_order_relaxed);
      g_soft_stall_streak.fetch_add(1u, std::memory_order_relaxed);
      g_successes_since_timeout.store(0u, std::memory_order_relaxed);
      AddTimeoutPressure(kStrongSoftPressureAdd);
      NoteRendererStall(present_count, kSoftBurstHoldPresents);
      SetKnownProducerBurst(true);
    } else if (elapsed_us >= adaptive.soft_us) {
      g_target_present_soft_stalls.fetch_add(1u, std::memory_order_relaxed);
      const uint32_t soft_streak =
          g_soft_stall_streak.fetch_add(1u, std::memory_order_relaxed) + 1u;
      g_successes_since_timeout.store(0u, std::memory_order_relaxed);
      AddTimeoutPressure(kSoftPressureAdd);
      NoteRendererStall(present_count, 2u);
      if (soft_streak >= kSoftBurstAfterStreak) {
        SetKnownProducerBurst(true);
      }
    } else {
      g_soft_stall_streak.store(0u, std::memory_order_relaxed);

      if (elapsed_us > adaptive.clean_us) {
        // Baseline-relative neutral band: not late enough to call a stall, but
        // not clean enough to immediately unwind pressure either.
        g_target_present_near_soft_stalls.fetch_add(1u, std::memory_order_relaxed);
        g_successes_since_timeout.store(0u, std::memory_order_relaxed);
      } else {
        const uint32_t pressure =
            g_timeout_pressure.load(std::memory_order_relaxed);
        if (pressure != 0u) {
          g_timeout_pressure.store(pressure - 1u, std::memory_order_relaxed);
        }

        if (g_producer_burst_active.load(std::memory_order_relaxed)) {
          const uint32_t successes =
              g_successes_since_timeout.fetch_add(1u, std::memory_order_relaxed) + 1u;
          const uint64_t hold_until =
              g_burst_hold_until_present.load(std::memory_order_relaxed);
          if (successes >= kBurstReleaseSuccesses && present_count >= hold_until) {
            SetKnownProducerBurst(false);
          }
        }
      }
    }

    // Stalls do not get to redefine "normal" after warmup; the helper rejects
    // them using the current adaptive soft threshold.
    ObserveCleanRendererWait(elapsed_us);
  } else if (result == WAIT_TIMEOUT) {
    g_target_present_timeouts.fetch_add(1u, std::memory_order_relaxed);
    if (tier == WaitTier::Base) {
      g_timeout_base_tier.fetch_add(1u, std::memory_order_relaxed);
    } else if (tier == WaitTier::Stage2) {
      g_timeout_stage2_tier.fetch_add(1u, std::memory_order_relaxed);
    } else {
      g_timeout_burst_tier.fetch_add(1u, std::memory_order_relaxed);
    }

    g_successes_since_timeout.store(0u, std::memory_order_relaxed);
    g_soft_stall_streak.store(0u, std::memory_order_relaxed);

    const uint32_t streak =
        g_present_timeout_streak.fetch_add(1u, std::memory_order_relaxed) + 1u;
    AddTimeoutPressure(kTimeoutPressureAdd);

    const uint64_t present_count =
        g_present_count.load(std::memory_order_relaxed);
    NoteRendererStall(present_count, kBurstMinHoldPresents);

    if (streak >= kBurstAfterPresentTimeouts) {
      SetKnownProducerBurst(true);
    }
  } else {
    if (result == WAIT_FAILED) {
      g_target_present_failed.fetch_add(1u, std::memory_order_relaxed);
    }
    g_present_timeout_streak.store(0u, std::memory_order_relaxed);
    g_timeout_pressure.store(0u, std::memory_order_relaxed);
    g_successes_since_timeout.store(0u, std::memory_order_relaxed);
    g_soft_stall_streak.store(0u, std::memory_order_relaxed);
    SetKnownProducerBurst(false);
  }

  return result;
}

inline BOOL WINAPI HookSetEvent(HANDLE handle) {
  const auto original = reinterpret_cast<SetEventFn>(g_orig_set_event);
  if (original == nullptr) return FALSE;

  if (!g_fix_armed.load(std::memory_order_acquire)) {
    return original(handle);
  }

  // Most engine SetEvent calls are unrelated. Check the learned HANDLE before
  // paying for _ReturnAddress/RVA conversion and producer-table work.
  const uintptr_t learned_handle =
      g_renderer_sync_handle.load(std::memory_order_acquire);
  if (learned_handle == 0u
      || reinterpret_cast<uintptr_t>(handle) != learned_handle) {
    return original(handle);
  }

  const uintptr_t caller_rva = ReturnAddressToExeRva(
      reinterpret_cast<uintptr_t>(_ReturnAddress()));
  MaybeBoostCurrentProducer(caller_rva, handle);
  return original(handle);
}

struct IatHookRecord {
  void** slot = nullptr;
  void* original = nullptr;
  void* replacement = nullptr;
};

inline constexpr size_t kMaxIatHooks = 8u;
inline std::array<IatHookRecord, kMaxIatHooks> g_iat_hooks = {};
inline size_t g_iat_hook_count = 0u;
inline bool g_iat_hooks_installed = false;

inline bool PatchIatSymbol(
    const char* function_name,
    void* replacement,
    void** original_storage) {
  if (!g_exe_verified.load(std::memory_order_acquire)
      || g_exe_base == 0u
      || function_name == nullptr
      || replacement == nullptr
      || original_storage == nullptr) {
    return false;
  }

  const auto* dos = reinterpret_cast<const IMAGE_DOS_HEADER*>(g_exe_base);
  const auto* nt = reinterpret_cast<const IMAGE_NT_HEADERS64*>(
      g_exe_base + static_cast<uintptr_t>(dos->e_lfanew));
  const auto& directory =
      nt->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT];
  if (directory.VirtualAddress == 0u || directory.Size == 0u) return false;

  auto* descriptor = reinterpret_cast<IMAGE_IMPORT_DESCRIPTOR*>(
      g_exe_base + directory.VirtualAddress);
  bool patched_any = false;

  for (; descriptor->Name != 0u; ++descriptor) {
    if (descriptor->FirstThunk == 0u || descriptor->OriginalFirstThunk == 0u) {
      continue;
    }

    auto* names = reinterpret_cast<IMAGE_THUNK_DATA64*>(
        g_exe_base + descriptor->OriginalFirstThunk);
    auto* iat = reinterpret_cast<IMAGE_THUNK_DATA64*>(
        g_exe_base + descriptor->FirstThunk);

    for (; names->u1.AddressOfData != 0u; ++names, ++iat) {
      if (IMAGE_SNAP_BY_ORDINAL64(names->u1.Ordinal)) continue;

      const auto* by_name = reinterpret_cast<const IMAGE_IMPORT_BY_NAME*>(
          g_exe_base + names->u1.AddressOfData);
      if (std::strcmp(
              reinterpret_cast<const char*>(by_name->Name),
              function_name) != 0) {
        continue;
      }

      if (g_iat_hook_count >= g_iat_hooks.size()) return patched_any;

      void** slot = reinterpret_cast<void**>(&iat->u1.Function);
      void* original = *slot;
      if (original == nullptr) continue;

      if (*original_storage == nullptr) *original_storage = original;

      DWORD old_protect = 0u;
      if (VirtualProtect(slot, sizeof(void*), PAGE_READWRITE, &old_protect) == FALSE) {
        continue;
      }

      g_iat_hooks[g_iat_hook_count++] = {slot, original, replacement};
      InterlockedExchangePointer(
          reinterpret_cast<PVOID volatile*>(slot),
          replacement);

      DWORD ignored = 0u;
      VirtualProtect(slot, sizeof(void*), old_protect, &ignored);
      patched_any = true;
    }
  }

  return patched_any;
}

inline void RemoveHooks() {
  for (size_t i = 0u; i < g_iat_hook_count; ++i) {
    auto& hook = g_iat_hooks[i];
    if (hook.slot == nullptr || hook.original == nullptr) continue;
    if (*hook.slot != hook.replacement) continue;

    DWORD old_protect = 0u;
    if (VirtualProtect(
            hook.slot,
            sizeof(void*),
            PAGE_READWRITE,
            &old_protect) == FALSE) {
      continue;
    }

    InterlockedExchangePointer(
        reinterpret_cast<PVOID volatile*>(hook.slot),
        hook.original);
    DWORD ignored = 0u;
    VirtualProtect(hook.slot, sizeof(void*), old_protect, &ignored);
  }

  g_iat_hooks = {};
  g_iat_hook_count = 0u;
  g_iat_hooks_installed = false;
  g_orig_wait_single = nullptr;
  g_orig_set_event = nullptr;
}

inline bool InstallHooks() {
  if (g_iat_hooks_installed) return true;

  const bool wait_ok = PatchIatSymbol(
      "WaitForSingleObject",
      reinterpret_cast<void*>(&HookWaitForSingleObject),
      &g_orig_wait_single);
  const bool set_ok = PatchIatSymbol(
      "SetEvent",
      reinterpret_cast<void*>(&HookSetEvent),
      &g_orig_set_event);

  if (!wait_ok || !set_ok) {
    RemoveHooks();
    Log(LogLevel::Warning,
        "[MW3 Microstutter V8] required WaitForSingleObject/SetEvent IAT hooks could not both be installed.");
    return false;
  }

  g_iat_hooks_installed = true;
  Log(LogLevel::Info,
      "[MW3 Microstutter V8] hooks installed: WaitForSingleObject=yes SetEvent=yes Sleep=no.");
  return true;
}

inline bool Initialize() {
  if (g_fix_armed.load(std::memory_order_acquire)) return true;
  if (g_init_attempted.exchange(true, std::memory_order_acq_rel)) {
    return g_fix_armed.load(std::memory_order_acquire);
  }

  if (!VerifyTargetBuild()) return false;

  LARGE_INTEGER qpc_frequency = {};
  if (QueryPerformanceFrequency(&qpc_frequency) != FALSE
      && qpc_frequency.QuadPart > 0) {
    g_qpc_frequency = static_cast<uint64_t>(qpc_frequency.QuadPart);
  }

  InitializeMmcssApi();

  if (!InstallHooks()) return false;

  g_fix_armed.store(true, std::memory_order_release);
  Log(LogLevel::Info,
      "[MW3 Microstutter V8] ARMED: Present-only 8/12/20ms max waits + adaptive renderer-wait baseline + frame-overrun attribution + experimental MMCSS Games producer registration; RenoDX limiter/process/Present priorities unchanged.");
  return true;
}

inline void LogStats() {
  const AdaptiveWaitThresholds adaptive = GetAdaptiveWaitThresholds();
  const uint64_t frame_period = g_frame_period_us.load(std::memory_order_relaxed);
  char message[1024] = {};
  std::snprintf(
      message,
      sizeof(message),
      "[MW3 Microstutter V8] stats: present=%llu target=%llu base8=%llu stage12=%llu burst20=%llu object0=%llu timeout=%llu timeoutTier=%llu/%llu/%llu waitBase=%.1fus dev=%.1fus adaptive=%llu/%llu/%lluus near=%llu soft=%llu strong=%llu maxWaitUs=%llu frameBase=%lluus maxFrameUs=%llu overruns=%llu renderer=%llu nearRenderer=%llu unexplained=%llu proxyPresent=%llu proxyGapBase=%lluus proxyLateGap=%llu proxyOverrun=%llu proxyMaxGapUs=%llu mmcss=%llu/%llu failed=%llu burstOn=%llu burstOff=%llu",
      static_cast<unsigned long long>(g_present_count.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_target_present_calls.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_target_present_base_calls.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_target_present_stage2_calls.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_target_present_burst_calls.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_target_present_object0.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_target_present_timeouts.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_timeout_base_tier.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_timeout_stage2_tier.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_timeout_burst_tier.load(std::memory_order_relaxed)),
      g_wait_baseline_us,
      g_wait_deviation_us,
      static_cast<unsigned long long>(adaptive.clean_us),
      static_cast<unsigned long long>(adaptive.soft_us),
      static_cast<unsigned long long>(adaptive.strong_us),
      static_cast<unsigned long long>(g_target_present_near_soft_stalls.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_target_present_soft_stalls.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_target_present_hard_soft_stalls.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_target_present_max_wait_us.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(frame_period),
      static_cast<unsigned long long>(g_frame_max_interval_us.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_frame_overruns.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_frame_overruns_renderer.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_frame_overruns_near_renderer.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_frame_overruns_unattributed.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_proxy_present_count.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_proxy_gap_baseline_us.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_proxy_late_gaps.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_proxy_interval_overruns.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_proxy_max_gap_us.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_mmcss_registered.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_mmcss_failed.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_target_present_failed.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_burst_activations.load(std::memory_order_relaxed)),
      static_cast<unsigned long long>(g_burst_deactivations.load(std::memory_order_relaxed)));
  Log(LogLevel::Info, message);
}

// Call once for each real D3D9 Present, on the thread that performs Present.
// RenoDX supplies this from its ReShade Present callback. The standalone DLL
// supplies it from a native IDirect3DSwapChain9::Present hook.
inline void NotifyPresent() {
  g_present_thread_id.store(GetCurrentThreadId(), std::memory_order_relaxed);

  LARGE_INTEGER now = {};
  if (g_qpc_frequency != 0u) QueryPerformanceCounter(&now);
  const int64_t now_qpc = now.QuadPart;
  const int64_t previous_qpc =
      g_last_d3d9_present_qpc.exchange(now_qpc, std::memory_order_relaxed);

  const uint64_t frame_wait_total =
      g_current_frame_wait_total_us.exchange(0u, std::memory_order_relaxed);
  const uint64_t frame_wait_max =
      g_current_frame_wait_max_us.exchange(0u, std::memory_order_relaxed);
  (void)frame_wait_total;

  if (g_qpc_frequency != 0u && previous_qpc > 0 && now_qpc > previous_qpc) {
    LARGE_INTEGER begin = {};
    LARGE_INTEGER end = {};
    begin.QuadPart = previous_qpc;
    end.QuadPart = now_qpc;
    const uint64_t interval_us = QpcElapsedUs(begin, end);
    UpdateAtomicMax(g_frame_max_interval_us, interval_us);

    const uint64_t period = g_frame_period_us.load(std::memory_order_relaxed);
    const uint64_t overrun_threshold = CurrentFrameOverrunThresholdUs(period);
    const bool overrun = period != 0u && interval_us > overrun_threshold;

    if (overrun) {
      g_frame_overruns.fetch_add(1u, std::memory_order_relaxed);
      const AdaptiveWaitThresholds adaptive = GetAdaptiveWaitThresholds();
      if (frame_wait_max >= adaptive.soft_us) {
        g_frame_overruns_renderer.fetch_add(1u, std::memory_order_relaxed);
        AddTimeoutPressure(1u);
        const uint64_t present_count = g_present_count.load(std::memory_order_relaxed);
        NoteRendererStall(present_count, 2u);
        if (frame_wait_max >= adaptive.strong_us) {
          SetKnownProducerBurst(true);
        }
      } else if (frame_wait_max > adaptive.clean_us) {
        // The frame missed its cadence and the renderer wait was elevated even
        // though it did not independently cross the soft-stall threshold.
        g_frame_overruns_near_renderer.fetch_add(1u, std::memory_order_relaxed);
        AddTimeoutPressure(1u);
      } else {
        g_frame_overruns_unattributed.fetch_add(1u, std::memory_order_relaxed);
      }
    }

    ObserveFramePeriod(interval_us, overrun);
  }

  const uint64_t count =
      g_present_count.fetch_add(1u, std::memory_order_relaxed) + 1u;

  if (count == kArmAfterPresents) {
    Initialize();
    return;
  }

  if (!g_fix_armed.load(std::memory_order_acquire)) return;

  // Safety release: if target waits disappear after a burst, do not leave
  // producers at HIGHEST indefinitely.
  if (g_producer_burst_active.load(std::memory_order_relaxed)) {
    const uint64_t last_stall =
        g_last_stall_present.load(std::memory_order_relaxed);
    const uint64_t hold_until =
        g_burst_hold_until_present.load(std::memory_order_relaxed);
    if (last_stall != 0u
        && count >= hold_until
        && count >= last_stall + kBurstForceReleaseAfterPresents) {
      g_present_timeout_streak.store(0u, std::memory_order_relaxed);
      g_timeout_pressure.store(0u, std::memory_order_relaxed);
      g_successes_since_timeout.store(0u, std::memory_order_relaxed);
      g_soft_stall_streak.store(0u, std::memory_order_relaxed);
      SetKnownProducerBurst(false);
    }
  }

  if ((count % 1200u) == 0u) {
    LogStats();
  }
}

// RenoDX-only instrumentation for the FP16 D3D11 proxy/flip presentation path.
// This does not change proxy pacing; it tells us whether remaining frame drops
// happen after the original D3D9 renderer synchronization has completed.
inline void NotifyProxyPresent() {
  if (g_qpc_frequency == 0u) return;

  LARGE_INTEGER now = {};
  QueryPerformanceCounter(&now);
  const int64_t now_qpc = now.QuadPart;
  g_proxy_present_count.fetch_add(1u, std::memory_order_relaxed);

  const int64_t previous_proxy =
      g_last_proxy_present_qpc.exchange(now_qpc, std::memory_order_relaxed);
  if (previous_proxy > 0 && now_qpc > previous_proxy) {
    LARGE_INTEGER begin = {};
    LARGE_INTEGER end = {};
    begin.QuadPart = previous_proxy;
    end.QuadPart = now_qpc;
    const uint64_t interval_us = QpcElapsedUs(begin, end);
    const uint64_t period = g_frame_period_us.load(std::memory_order_relaxed);
    const uint64_t threshold = CurrentFrameOverrunThresholdUs(period);
    if (period != 0u && interval_us > threshold) {
      g_proxy_interval_overruns.fetch_add(1u, std::memory_order_relaxed);
    }
  }

  const int64_t game_qpc = g_last_d3d9_present_qpc.load(std::memory_order_relaxed);
  if (game_qpc <= 0 || now_qpc <= game_qpc) return;

  LARGE_INTEGER begin = {};
  LARGE_INTEGER end = {};
  begin.QuadPart = game_qpc;
  end.QuadPart = now_qpc;
  const uint64_t gap_us = QpcElapsedUs(begin, end);
  UpdateAtomicMax(g_proxy_max_gap_us, gap_us);

  uint64_t baseline = g_proxy_gap_baseline_us.load(std::memory_order_relaxed);
  uint64_t samples = g_proxy_gap_samples.load(std::memory_order_relaxed);
  if (baseline == 0u) {
    g_proxy_gap_baseline_us.store(gap_us, std::memory_order_relaxed);
    g_proxy_gap_samples.store(1u, std::memory_order_relaxed);
    return;
  }

  const uint64_t late_headroom = baseline / 2u > 250u ? baseline / 2u : 250u;
  if (gap_us > baseline + late_headroom) {
    g_proxy_late_gaps.fetch_add(1u, std::memory_order_relaxed);
    return;
  }

  const uint64_t divisor = samples < 64u ? 8u : 64u;
  const uint64_t next = (baseline * (divisor - 1u) + gap_us) / divisor;
  g_proxy_gap_baseline_us.store(next, std::memory_order_relaxed);
  g_proxy_gap_samples.store(samples + 1u, std::memory_order_relaxed);
}

inline void Shutdown() {
  g_fix_armed.store(false, std::memory_order_release);
  SetKnownProducerBurst(false);
  RemoveHooks();
  RestoreProducerPriorities();

  g_present_timeout_streak.store(0u, std::memory_order_relaxed);
  g_timeout_pressure.store(0u, std::memory_order_relaxed);
  g_successes_since_timeout.store(0u, std::memory_order_relaxed);
  g_soft_stall_streak.store(0u, std::memory_order_relaxed);
  g_qpc_frequency = 0u;
  g_wait_baseline_us = 0.0;
  g_wait_deviation_us = 0.0;
  g_wait_baseline_samples = 0u;
  g_current_frame_wait_total_us.store(0u, std::memory_order_relaxed);
  g_current_frame_wait_max_us.store(0u, std::memory_order_relaxed);
  g_last_d3d9_present_qpc.store(0, std::memory_order_relaxed);
  g_last_proxy_present_qpc.store(0, std::memory_order_relaxed);
  g_frame_outlier_candidate_us.store(0u, std::memory_order_relaxed);
  g_frame_outlier_streak.store(0u, std::memory_order_relaxed);
  g_renderer_sync_handle.store(0u, std::memory_order_relaxed);
  g_present_thread_id.store(0u, std::memory_order_relaxed);
}

inline bool IsArmed() {
  return g_fix_armed.load(std::memory_order_acquire);
}

}  // namespace mw3_microstutter
