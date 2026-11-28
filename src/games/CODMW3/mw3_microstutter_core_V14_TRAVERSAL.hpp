#pragma once

// MW3 x64 V14 exact-site renderer/traversal policy.
//
// Earlier experiments intercepted the executable's imported WaitForSingleObject
// and SetEvent functions. Runtime probes showed IW5 executes a very large number
// of waits per frame, and multiple threads can signal the learned renderer event.
// Wrapping the global IAT therefore adds bookkeeping to unrelated synchronization
// and can promote multiple workers into MMCSS.
//
// V14 deliberately keeps that layer removed. The engine's verified renderer event,
// 1 ms WaitForSingleObject timeout and SetEvent producers are left byte-for-byte
// stock. Performance work is done only at exact, signature-verified hot sites in
// addon.cpp (render-poll Sleep, D3D9 query flags/retry, and visible-frame presentation).

#include <Windows.h>
#include <atomic>
#include <cstdint>

namespace mw3_microstutter {

enum class LogLevel : uint32_t {
  Info = 0,
  Warning = 1,
};

using LogFn = void (*)(LogLevel level, const char* message);

inline LogFn g_logger = nullptr;
inline std::atomic<uint64_t> g_present_count{0u};
inline std::atomic<bool> g_logged{false};

inline void SetLogger(LogFn logger) {
  g_logger = logger;
}

inline void NotifyPresent() {
  const uint64_t count = g_present_count.fetch_add(1u, std::memory_order_relaxed) + 1u;
  if (count < 120u || g_logged.exchange(true, std::memory_order_acq_rel)) return;
  if (g_logger != nullptr) {
    g_logger(
        LogLevel::Info,
        "[MW3 V14 Exact Sync] stock renderer WaitForSingleObject/SetEvent path preserved; no global wait/event IAT hooks, no MMCSS producer promotion, no fake completion.");
  }
}

inline void NotifyProxyPresent() {}

inline void Shutdown() {
  g_present_count.store(0u, std::memory_order_release);
  g_logged.store(false, std::memory_order_release);
}

}  // namespace mw3_microstutter
