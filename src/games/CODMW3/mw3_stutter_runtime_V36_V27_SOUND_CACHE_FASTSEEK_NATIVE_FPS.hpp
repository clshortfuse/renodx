#pragma once

#define WIN32_LEAN_AND_MEAN
#include <Windows.h>
#include <intrin.h>
#include <detours.h>
#include "hook_transaction.hpp"

#include <algorithm>
#include <array>
#include <atomic>
#include <cstdint>
#include <cstring>
#include <iomanip>
#include <sstream>

namespace mw3_deep_profiler {

// ============================================================================
// MW3 x64 V36 V27-exact hot path + cached-sound fast seek + native FPS
//
// Proven fixes kept:
//   * exact 0x3BB62B synchronous .iwd reader -> read-only mapped cache
//   * exact 0x1BE473 Sleep(1) backend poll -> SwitchToThread
//
// V27 keeps the proven V21/V23 persistent mapping + exact CRT _read bypass,
// then ports only the high-confidence V24 archive/sync behavior into a LEAN
// production path. The V25P Tracy/flight-recorder hot-path accounting is gone.
// New trace-guided changes:
//   * TLS-first mapped IWD lookup without re-walking the CRT fd table
//   * sparse archive-burst detection (no QPC/atomics on every tiny read)
//   * temporary archive worker ABOVE_NORMAL priority with verified idle restore
//   * adaptive precise 0x18B895/0x24AA36 timers that stop calibrating after warmup
//   * event-preserving progressive 2/4 ms timeout coalescing after repeated
//     0x24AA36 timeouts, including isolated RenderSync stalls with no IWD burst
//
// V27 additionally accelerates the ACTUAL minizip raw-DEFLATE stage used by IWD entries:
//   * minizip unzReadCurrentFile = iw5sp+0x3157C0
//   * bundled zlib 1.1.4 inflate = iw5sp+0x312790
//   * only streams first reached from the exact minizip callsite are eligible
//   * modern zlib-ng runs in a SHADOW z_stream; MW3's old zlib state remains allocated
//     separately and is still cleaned up by the stock inflateEnd path
//   * if mw3_zlibng_v27.dll is absent or initialization fails, stock zlib 1.1.4 is used
//
// The real producer event always remains wait object #0 and can wake immediately.
// No completion is fabricated. The old query/renderer executable-byte experiments
// remain disabled. Only the exact CRT _read entry is detoured; other hooks are IAT.
// ============================================================================

constexpr DWORD MW3_EXPECTED_PE_TIMESTAMP = 0x6A743A58u;
constexpr DWORD MW3_EXPECTED_SIZE_OF_IMAGE = 0x044BE000u;
constexpr uintptr_t MW3_IWD_STREAM_READ_CALLER_RVA = 0x003BB62Bu;
constexpr uintptr_t MW3_BACKEND_SLEEP1_RETURN_RVA = 0x001BE473u;
constexpr uintptr_t MW3_RENDER_SLEEP1_RETURN_RVA = 0x0018B895u;
constexpr uintptr_t MW3_RENDER_WAIT1_RETURN_RVA = 0x0024AA36u;
constexpr uintptr_t MW3_CRT_READ_RVA = 0x003BB340u;
constexpr uintptr_t MW3_MINIZIP_UNZ_READ_CURRENT_FILE_RVA = 0x003157C0u;
constexpr uintptr_t MW3_ZLIB_INFLATE_RVA = 0x00312790u;
constexpr uintptr_t MW3_ZLIB_INFLATE_END_RVA = 0x000ACA90u;
constexpr uintptr_t MW3_MINIZIP_INFLATE_RETURN_RVA = 0x00315931u;

constexpr uintptr_t MW3_FS_SEEK_RVA = 0x002B6460u;
constexpr uintptr_t MW3_SOUND_FS_SEEK_RETURN_RVA = 0x0030E444u;
constexpr uintptr_t MW3_FS_HANDLE_TABLE_RVA = 0x026563F0u;
constexpr size_t MW3_FS_HANDLE_RECORD_SIZE = 0x138u;
constexpr size_t MW3_FS_HANDLE_COUNT = 64u;
constexpr size_t MW3_FS_HANDLE_NAME_OFFSET = 0x34u;
constexpr size_t MW3_UNZ_CURRENT_FILE_OFFSET = 0x80u;

constexpr std::array<uint8_t, 24> MW3_FS_SEEK_SIGNATURE = {
    0x48, 0x89, 0x5C, 0x24, 0x10,
    0x48, 0x89, 0x6C, 0x24, 0x18,
    0x48, 0x89, 0x7C, 0x24, 0x20,
    0x41, 0x56, 0x48, 0x83, 0xEC, 0x20,
    0x4C, 0x69, 0xF1,
};

// Exact callsite in minizip's unzReadCurrentFile:
//   lea rcx,[rbx+8]       ; old z_stream (80-byte zlib 1.1.4 ABI)
//   mov edx,2             ; Z_SYNC_FLUSH
//   call iw5sp+0x312790   ; bundled zlib 1.1.4 inflate
constexpr std::array<uint8_t, 14> MW3_MINIZIP_INFLATE_CALL_SIGNATURE = {
    0x48, 0x8D, 0x4B, 0x08,
    0xBA, 0x02, 0x00, 0x00, 0x00,
    0xE8, 0x5F, 0xCE, 0xFF, 0xFF,
};
constexpr uintptr_t MW3_MINIZIP_INFLATE_CALL_SIGNATURE_RVA = 0x00315923u;

constexpr std::array<uint8_t, 16> MW3_ZLIB_INFLATE_SIGNATURE = {
    0x48, 0x89, 0x5C, 0x24, 0x08,
    0x48, 0x89, 0x6C, 0x24, 0x10,
    0x48, 0x89, 0x74, 0x24, 0x18,
    0x48,
};
constexpr std::array<uint8_t, 16> MW3_ZLIB_INFLATE_END_SIGNATURE = {
    0x40, 0x53, 0x48, 0x83, 0xEC, 0x20,
    0x48, 0x8B, 0xD9, 0x48, 0x85, 0xC9,
    0x74, 0x41, 0x48, 0x8B,
};

// Exact static-CRT descriptor table used by this September-2026 x64 build.
// _read indexes blocks by fd >> 6; each descriptor record is 72 bytes.
constexpr uintptr_t MW3_CRT_FD_TABLE_RVA = 0x04435140u;
constexpr uintptr_t MW3_CRT_FD_LIMIT_RVA = 0x04435540u;
constexpr size_t MW3_CRT_FD_RECORD_SIZE = 72u;
constexpr size_t MW3_CRT_FD_HANDLE_OFFSET = 0x28u;
constexpr size_t MW3_CRT_FD_FLAGS_OFFSET = 0x38u;
constexpr size_t MW3_CRT_FD_TEXTMODE_OFFSET = 0x39u;

// Adaptive high-resolution timing. Calibrate only during a short warm-up and
// then freeze the request, avoiding permanent QPC work in the renderer hot path.
constexpr double MW3_PRECISE_TARGET_ACTUAL_MS = 0.90;
constexpr double MW3_PRECISE_INITIAL_REQUEST_MS = 0.60;
constexpr double MW3_PRECISE_MIN_REQUEST_MS = 0.20;
constexpr double MW3_PRECISE_MAX_REQUEST_MS = 0.90;
constexpr double MW3_PRECISE_CALIBRATION_GAIN = 0.22;
constexpr uint32_t MW3_PRECISE_CALIBRATION_SAMPLES = 64u;

// Progressive event-preserving RenderSync coalescing. V24 used 2 ms only while
// an archive burst was active. The supplied Tracy captures also show isolated
// 0x24AA36 timeout storms with almost no IWD traffic, so after a longer timeout
// streak V27 also coalesces those to 2 ms. During a proven IWD burst it can step
// to 4 ms. The actual event remains first and wakes immediately at any point.
constexpr double MW3_RENDER_COALESCE_2MS = 2.00;
constexpr double MW3_ARCHIVE_COALESCE_4MS = 4.00;
constexpr uint32_t MW3_COALESCE_STREAK_2MS = 3u;
constexpr uint32_t MW3_COALESCE_STREAK_4MS = 8u;
constexpr uint32_t MW3_ISOLATED_SYNC_COALESCE_STREAK = 8u;

constexpr double MW3_ARCHIVE_BURST_WINDOW_MS = 6.00;
constexpr uint64_t MW3_ARCHIVE_BURST_MIN_BYTES = 256ull * 1024ull;
constexpr uint64_t MW3_ARCHIVE_BURST_MIN_CALLS = 32u;
constexpr double MW3_ARCHIVE_PRIORITY_IDLE_GAP_MS = 8.0;
constexpr uintptr_t MW3_WORKER_WAIT_RETURN_RVA = 0x0024A6B7u;

constexpr std::array<uint8_t, 10> MW3_BACKEND_SLEEP1_SIGNATURE = {
    0xB9, 0x01, 0x00, 0x00, 0x00,  // mov ecx,1
    0xE8, 0x9D, 0xBF, 0x08, 0x00,  // call iw5sp+0x24A410 (Sleep thunk)
};
constexpr uintptr_t MW3_BACKEND_SLEEP1_SIGNATURE_RVA = 0x001BE469u;

constexpr std::array<uint8_t, 10> MW3_RENDER_SLEEP1_SIGNATURE = {
    0xB9, 0x01, 0x00, 0x00, 0x00,  // mov ecx,1
    0xE8, 0x7B, 0xEB, 0x0B, 0x00,  // call iw5sp+0x24A410 (Sleep thunk)
};
constexpr uintptr_t MW3_RENDER_SLEEP1_SIGNATURE_RVA = 0x0018B88Bu;

constexpr std::array<uint8_t, 18> MW3_RENDER_WAIT1_SIGNATURE = {
    0x48, 0x8B, 0x0D, 0x55, 0xAF, 0xDB, 0x01,  // mov rcx,[event]
    0xBA, 0x01, 0x00, 0x00, 0x00,              // mov edx,1
    0xFF, 0x15, 0xD2, 0x87, 0x19, 0x00,        // call WaitForSingleObject
};
constexpr uintptr_t MW3_RENDER_WAIT1_SIGNATURE_RVA = 0x0024AA24u;

constexpr std::array<uint8_t, 20> MW3_CRT_READ_SIGNATURE = {
    0x48, 0x89, 0x54, 0x24, 0x10, 0x53, 0x55, 0x57,
    0x41, 0x54, 0x41, 0x55, 0x41, 0x56, 0x41, 0x57,
    0x48, 0x83, 0xEC, 0x60,
};
constexpr uintptr_t MW3_CRT_READ_SIGNATURE_RVA = MW3_CRT_READ_RVA;

constexpr std::array<uint8_t, 6> MW3_IWD_READ_CALL_SIGNATURE = {
    0xFF, 0x15, 0xBD, 0x7C, 0x02, 0x00,  // call [iw5sp+0x3E32E8] = ReadFile
};
constexpr uintptr_t MW3_IWD_READ_CALL_SIGNATURE_RVA = 0x003BB625u;

constexpr size_t FILE_PATH_SLOT_COUNT = 256u;
constexpr size_t IWD_HANDLE_SLOT_COUNT = 64u;
constexpr size_t IWD_ARCHIVE_SLOT_COUNT = 96u;
constexpr size_t MAX_IAT_HOOKS = 16u;

uintptr_t g_exe_base = 0u;
uintptr_t g_exe_end = 0u;
std::atomic<bool> g_runtime_attempted{false};
std::atomic<bool> g_runtime_installed{false};
std::atomic<int> g_iwd_cache_mode{1};
std::atomic<bool> g_backend_sleep1_yield_enabled{true};
std::atomic<bool> g_renderer_sleep1_precise_enabled{true};
std::atomic<bool> g_renderer_wait1_precise_enabled{true};
std::atomic<bool> g_crt_iwd_fast_read_enabled{true};
std::atomic<bool> g_archive_burst_wait_coalesce_enabled{true};
std::atomic<bool> g_archive_thread_priority_boost_enabled{true};
std::atomic<bool> g_zlibng_iwd_inflate_enabled{true};
std::atomic<bool> g_zlibng_loaded{false};
std::atomic<uint64_t> g_zlibng_streams_accelerated{0u};
std::atomic<uint64_t> g_zlibng_stream_init_failures{0u};
std::atomic<uint64_t> g_zlibng_generation_resets{0u};
std::atomic<int64_t> g_archive_burst_until_qpc{0};

std::atomic<uint64_t> g_unique_archive_maps{0u};
std::atomic<uint64_t> g_handle_bindings{0u};
std::atomic<uint64_t> g_mapping_reuses{0u};
std::atomic<uint64_t> g_backend_yields{0u};
std::atomic<uint64_t> g_fallbacks{0u};
std::atomic<uint64_t> g_precise_timer_failures{0u};

void SetIwdCacheMode(int mode) {
  g_iwd_cache_mode.store(std::clamp(mode, 0, 1), std::memory_order_release);
}

int GetIwdCacheMode() {
  return g_iwd_cache_mode.load(std::memory_order_acquire);
}

void SetBackendSleep1YieldEnabled(bool enabled) {
  g_backend_sleep1_yield_enabled.store(enabled, std::memory_order_release);
}

bool GetBackendSleep1YieldEnabled() {
  return g_backend_sleep1_yield_enabled.load(std::memory_order_acquire);
}

void SetRendererSleep1PreciseEnabled(bool enabled) {
  g_renderer_sleep1_precise_enabled.store(enabled, std::memory_order_release);
}

bool GetRendererSleep1PreciseEnabled() {
  return g_renderer_sleep1_precise_enabled.load(std::memory_order_acquire);
}

void SetRendererWait1PreciseEnabled(bool enabled) {
  g_renderer_wait1_precise_enabled.store(enabled, std::memory_order_release);
}

bool GetRendererWait1PreciseEnabled() {
  return g_renderer_wait1_precise_enabled.load(std::memory_order_acquire);
}

void SetCrtIwdFastReadEnabled(bool enabled) {
  g_crt_iwd_fast_read_enabled.store(enabled, std::memory_order_release);
}

bool GetCrtIwdFastReadEnabled() {
  return g_crt_iwd_fast_read_enabled.load(std::memory_order_acquire);
}

void SetArchiveBurstWaitCoalesceEnabled(bool enabled) {
  g_archive_burst_wait_coalesce_enabled.store(enabled, std::memory_order_release);
}

bool GetArchiveBurstWaitCoalesceEnabled() {
  return g_archive_burst_wait_coalesce_enabled.load(std::memory_order_acquire);
}

void SetArchiveThreadPriorityBoostEnabled(bool enabled) {
  g_archive_thread_priority_boost_enabled.store(enabled, std::memory_order_release);
}

bool GetArchiveThreadPriorityBoostEnabled() {
  return g_archive_thread_priority_boost_enabled.load(std::memory_order_acquire);
}

void SetZlibNgIwdInflateEnabled(bool enabled) {
  g_zlibng_iwd_inflate_enabled.store(enabled, std::memory_order_release);
}

bool GetZlibNgIwdInflateEnabled() {
  return g_zlibng_iwd_inflate_enabled.load(std::memory_order_acquire);
}

bool BytesEqualAtRva(
    uintptr_t rva,
    const uint8_t* expected,
    size_t size) {
  if (g_exe_base == 0u || expected == nullptr || size == 0u) return false;
  const uintptr_t address = g_exe_base + rva;
  if (address < g_exe_base || address + size > g_exe_end) return false;
  return std::memcmp(
      reinterpret_cast<const void*>(address),
      expected,
      size) == 0;
}

bool InitializeExeIdentity() {
#if !defined(_WIN64)
  return false;
#else
  const uintptr_t base =
      reinterpret_cast<uintptr_t>(GetModuleHandleW(nullptr));
  if (base == 0u) return false;

  const auto* dos =
      reinterpret_cast<const IMAGE_DOS_HEADER*>(base);
  if (dos->e_magic != IMAGE_DOS_SIGNATURE || dos->e_lfanew <= 0) return false;

  const auto* nt =
      reinterpret_cast<const IMAGE_NT_HEADERS64*>(
          base + static_cast<uintptr_t>(dos->e_lfanew));
  if (nt->Signature != IMAGE_NT_SIGNATURE
      || nt->FileHeader.Machine != IMAGE_FILE_MACHINE_AMD64
      || nt->FileHeader.TimeDateStamp != MW3_EXPECTED_PE_TIMESTAMP
      || nt->OptionalHeader.SizeOfImage != MW3_EXPECTED_SIZE_OF_IMAGE) {
    return false;
  }

  g_exe_base = base;
  g_exe_end = base + nt->OptionalHeader.SizeOfImage;

  if (!BytesEqualAtRva(
          MW3_BACKEND_SLEEP1_SIGNATURE_RVA,
          MW3_BACKEND_SLEEP1_SIGNATURE.data(),
          MW3_BACKEND_SLEEP1_SIGNATURE.size())
      || !BytesEqualAtRva(
          MW3_RENDER_SLEEP1_SIGNATURE_RVA,
          MW3_RENDER_SLEEP1_SIGNATURE.data(),
          MW3_RENDER_SLEEP1_SIGNATURE.size())
      || !BytesEqualAtRva(
          MW3_RENDER_WAIT1_SIGNATURE_RVA,
          MW3_RENDER_WAIT1_SIGNATURE.data(),
          MW3_RENDER_WAIT1_SIGNATURE.size())
      || !BytesEqualAtRva(
          MW3_CRT_READ_SIGNATURE_RVA,
          MW3_CRT_READ_SIGNATURE.data(),
          MW3_CRT_READ_SIGNATURE.size())
      || !BytesEqualAtRva(
          MW3_IWD_READ_CALL_SIGNATURE_RVA,
          MW3_IWD_READ_CALL_SIGNATURE.data(),
          MW3_IWD_READ_CALL_SIGNATURE.size())) {
    g_exe_base = 0u;
    g_exe_end = 0u;
    return false;
  }

  return true;
#endif
}

uintptr_t ReturnAddressToExeRva(uintptr_t return_address) {
  if (g_exe_base == 0u
      || return_address < g_exe_base
      || return_address >= g_exe_end) {
    return 0u;
  }
  return return_address - g_exe_base;
}

// -----------------------------------------------------------------------------
// Main-EXE IAT hook support
// -----------------------------------------------------------------------------

struct IatHookRecord {
  void** slot = nullptr;
  void* original = nullptr;
  void* replacement = nullptr;
};

std::array<IatHookRecord, MAX_IAT_HOOKS> g_iat_hooks = {};
size_t g_iat_hook_count = 0u;

bool PatchIatSymbol(
    const char* function_name,
    void* replacement,
    void** original_storage) {
  if (g_exe_base == 0u
      || function_name == nullptr
      || replacement == nullptr
      || original_storage == nullptr) {
    return false;
  }

  const auto* dos =
      reinterpret_cast<const IMAGE_DOS_HEADER*>(g_exe_base);
  const auto* nt =
      reinterpret_cast<const IMAGE_NT_HEADERS64*>(
          g_exe_base + static_cast<uintptr_t>(dos->e_lfanew));
  const auto& directory =
      nt->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT];
  if (directory.VirtualAddress == 0u || directory.Size == 0u) return false;

  auto* descriptor =
      reinterpret_cast<IMAGE_IMPORT_DESCRIPTOR*>(
          g_exe_base + directory.VirtualAddress);

  bool patched_any = false;

  for (; descriptor->Name != 0u; ++descriptor) {
    if (descriptor->FirstThunk == 0u
        || descriptor->OriginalFirstThunk == 0u) {
      continue;
    }

    auto* names =
        reinterpret_cast<IMAGE_THUNK_DATA64*>(
            g_exe_base + descriptor->OriginalFirstThunk);
    auto* iat =
        reinterpret_cast<IMAGE_THUNK_DATA64*>(
            g_exe_base + descriptor->FirstThunk);

    for (; names->u1.AddressOfData != 0u; ++names, ++iat) {
      if (IMAGE_SNAP_BY_ORDINAL64(names->u1.Ordinal)) continue;

      const auto* by_name =
          reinterpret_cast<const IMAGE_IMPORT_BY_NAME*>(
              g_exe_base + names->u1.AddressOfData);
      if (std::strcmp(
              reinterpret_cast<const char*>(by_name->Name),
              function_name) != 0) {
        continue;
      }

      if (g_iat_hook_count >= g_iat_hooks.size()) return patched_any;

      void** slot = reinterpret_cast<void**>(&iat->u1.Function);
      void* original = *slot;
      if (original == nullptr || original == replacement) continue;
      // One hook has one stable call-through target. Do not chain it through
      // itself or combine imports already owned by different interceptors.
      if (*original_storage != nullptr && *original_storage != original) continue;

      if (*original_storage == nullptr) *original_storage = original;

      DWORD old_protect = 0u;
      if (VirtualProtect(
              slot, sizeof(void*), PAGE_READWRITE, &old_protect) == FALSE) {
        continue;
      }

      const auto observed = InterlockedCompareExchangePointer(
          reinterpret_cast<PVOID volatile*>(slot),
          replacement, original);

      DWORD ignored = 0u;
      VirtualProtect(slot, sizeof(void*), old_protect, &ignored);
      if (observed != original) continue;

      g_iat_hooks[g_iat_hook_count++] = {
          slot,
          original,
          replacement,
      };
      patched_any = true;
    }
  }

  return patched_any;
}

void RestoreIatHooks() {
  for (size_t i = 0u; i < g_iat_hook_count; ++i) {
    auto& hook = g_iat_hooks[i];
    if (hook.slot == nullptr || hook.original == nullptr) continue;

    DWORD old_protect = 0u;
    if (VirtualProtect(
            hook.slot, sizeof(void*), PAGE_READWRITE, &old_protect) == FALSE) {
      continue;
    }

    InterlockedCompareExchangePointer(
        reinterpret_cast<PVOID volatile*>(hook.slot),
        hook.original, hook.replacement);

    DWORD ignored = 0u;
    VirtualProtect(hook.slot, sizeof(void*), old_protect, &ignored);
  }

  g_iat_hooks = {};
  g_iat_hook_count = 0u;
}

// -----------------------------------------------------------------------------
// File path tracking
// -----------------------------------------------------------------------------

struct FilePathSlot {
  uintptr_t handle = 0u;
  std::array<char, 160> path = {};
};

std::array<FilePathSlot, FILE_PATH_SLOT_COUNT> g_file_paths = {};
SRWLOCK g_file_path_lock = SRWLOCK_INIT;

size_t FilePathSlotIndex(uintptr_t handle) {
  handle ^= handle >> 11u;
  handle ^= handle >> 23u;
  return static_cast<size_t>(handle % FILE_PATH_SLOT_COUNT);
}

void StoreFilePathA(HANDLE handle, const char* path) {
  if (handle == nullptr
      || handle == INVALID_HANDLE_VALUE
      || path == nullptr
      || path[0] == '\0') {
    return;
  }

  const uintptr_t key = reinterpret_cast<uintptr_t>(handle);
  AcquireSRWLockExclusive(&g_file_path_lock);
  auto& slot = g_file_paths[FilePathSlotIndex(key)];
  slot.handle = key;
  slot.path.fill('\0');
  strncpy_s(slot.path.data(), slot.path.size(), path, _TRUNCATE);
  ReleaseSRWLockExclusive(&g_file_path_lock);
}

void StoreFilePathW(HANDLE handle, const wchar_t* path) {
  if (handle == nullptr
      || handle == INVALID_HANDLE_VALUE
      || path == nullptr
      || path[0] == L'\0') {
    return;
  }

  std::array<char, 160> converted = {};
  const int result = WideCharToMultiByte(
      CP_UTF8,
      0,
      path,
      -1,
      converted.data(),
      static_cast<int>(converted.size()),
      nullptr,
      nullptr);
  if (result > 0) StoreFilePathA(handle, converted.data());
}

void RemoveFilePathForHandle(HANDLE handle) {
  if (handle == nullptr || handle == INVALID_HANDLE_VALUE) return;
  const uintptr_t key = reinterpret_cast<uintptr_t>(handle);
  AcquireSRWLockExclusive(&g_file_path_lock);
  auto& slot = g_file_paths[FilePathSlotIndex(key)];
  if (slot.handle == key) {
    slot.handle = 0u;
    slot.path.fill('\0');
  }
  ReleaseSRWLockExclusive(&g_file_path_lock);
}

void CopyFilePathForHandle(
    uintptr_t handle,
    std::array<char, 160>& destination) {
  destination.fill('\0');
  if (handle == 0u
      || handle == reinterpret_cast<uintptr_t>(INVALID_HANDLE_VALUE)) {
    return;
  }

  AcquireSRWLockShared(&g_file_path_lock);
  const auto& slot = g_file_paths[FilePathSlotIndex(handle)];
  if (slot.handle == handle) destination = slot.path;
  ReleaseSRWLockShared(&g_file_path_lock);
}

bool ResolveFilePathFromLiveHandle(
    uintptr_t handle,
    std::array<char, 160>& destination) {
  if (destination[0] != '\0'
      || handle == 0u
      || handle == reinterpret_cast<uintptr_t>(INVALID_HANDLE_VALUE)) {
    return destination[0] != '\0';
  }

  wchar_t wide_path[512] = {};
  const DWORD count = GetFinalPathNameByHandleW(
      reinterpret_cast<HANDLE>(handle),
      wide_path,
      static_cast<DWORD>(sizeof(wide_path) / sizeof(wide_path[0])),
      FILE_NAME_NORMALIZED);
  if (count == 0u || count >= (sizeof(wide_path) / sizeof(wide_path[0]))) {
    return false;
  }

  const wchar_t* source = wide_path;
  if (count >= 4u
      && wide_path[0] == L'\\'
      && wide_path[1] == L'\\'
      && wide_path[2] == L'?'
      && wide_path[3] == L'\\') {
    source += 4;
  }

  const int converted = WideCharToMultiByte(
      CP_UTF8,
      0,
      source,
      -1,
      destination.data(),
      static_cast<int>(destination.size()),
      nullptr,
      nullptr);
  if (converted <= 0) {
    destination.fill('\0');
    return false;
  }

  StoreFilePathA(reinterpret_cast<HANDLE>(handle), destination.data());
  return true;
}

bool IsIwdPath(const std::array<char, 160>& path) {
  size_t length = 0u;
  while (length < path.size() && path[length] != '\0') ++length;
  if (length < 4u) return false;

  auto lower_ascii = [](char c) {
    return c >= 'A' && c <= 'Z'
        ? static_cast<char>(c + ('a' - 'A'))
        : c;
  };

  return lower_ascii(path[length - 4u]) == '.'
      && lower_ascii(path[length - 3u]) == 'i'
      && lower_ascii(path[length - 2u]) == 'w'
      && lower_ascii(path[length - 1u]) == 'd';
}

bool IwdPathEquals(
    const std::array<char, 160>& a,
    const std::array<char, 160>& b) {
  for (size_t i = 0u; i < a.size(); ++i) {
    char ca = a[i];
    char cb = b[i];
    if (ca >= 'A' && ca <= 'Z') ca = static_cast<char>(ca - 'A' + 'a');
    if (cb >= 'A' && cb <= 'Z') cb = static_cast<char>(cb - 'A' + 'a');
    if (ca != cb) return false;
    if (ca == '\0') return true;
  }
  return true;
}

// -----------------------------------------------------------------------------
// Persistent per-archive IWD mappings
// -----------------------------------------------------------------------------

struct IwdArchiveMapping {
  HANDLE mapping = nullptr;
  const uint8_t* view = nullptr;
  uint64_t size = 0u;
  std::array<char, 160> path = {};
};

struct IwdHandleSlot {
  SRWLOCK lock = SRWLOCK_INIT;
  uintptr_t handle = 0u;
  const uint8_t* view = nullptr;
  uint64_t size = 0u;
  uint64_t virtual_position = 0u;
  bool position_valid = false;
  uint16_t archive_index = 0xFFFFu;
};

std::array<IwdArchiveMapping, IWD_ARCHIVE_SLOT_COUNT> g_archives = {};
std::array<IwdHandleSlot, IWD_HANDLE_SLOT_COUNT> g_handles = {};
SRWLOCK g_iwd_table_lock = SRWLOCK_INIT;

thread_local IwdHandleSlot* g_tls_handle_slot = nullptr;
thread_local uintptr_t g_tls_handle = 0u;

IwdHandleSlot* FindHandleNoLock(uintptr_t handle) {
  if (handle == 0u
      || handle == reinterpret_cast<uintptr_t>(INVALID_HANDLE_VALUE)) {
    return nullptr;
  }
  for (auto& slot : g_handles) {
    if (slot.handle == handle) return &slot;
  }
  return nullptr;
}

IwdHandleSlot* FindEmptyHandleNoLock() {
  for (auto& slot : g_handles) {
    if (slot.handle == 0u) return &slot;
  }
  return nullptr;
}

int FindArchiveNoLock(const std::array<char, 160>& path) {
  for (size_t i = 0u; i < g_archives.size(); ++i) {
    if (g_archives[i].view != nullptr
        && IwdPathEquals(g_archives[i].path, path)) {
      return static_cast<int>(i);
    }
  }
  return -1;
}

int FindEmptyArchiveNoLock() {
  for (size_t i = 0u; i < g_archives.size(); ++i) {
    if (g_archives[i].view == nullptr) return static_cast<int>(i);
  }
  return -1;
}

void ResetHandleSlotLocked(IwdHandleSlot& slot) {
  slot.handle = 0u;
  slot.view = nullptr;
  slot.size = 0u;
  slot.virtual_position = 0u;
  slot.position_valid = false;
  slot.archive_index = 0xFFFFu;
}

void ResetArchive(IwdArchiveMapping& archive) {
  if (archive.view != nullptr) UnmapViewOfFile(archive.view);
  if (archive.mapping != nullptr) ::CloseHandle(archive.mapping);
  archive.mapping = nullptr;
  archive.view = nullptr;
  archive.size = 0u;
  archive.path.fill('\0');
}

IwdHandleSlot* LockExistingHandle(HANDLE file) {
  const uintptr_t key = reinterpret_cast<uintptr_t>(file);

  if (g_tls_handle_slot != nullptr && g_tls_handle == key) {
    AcquireSRWLockExclusive(&g_tls_handle_slot->lock);
    if (g_tls_handle_slot->handle == key
        && g_tls_handle_slot->view != nullptr) {
      return g_tls_handle_slot;
    }
    ReleaseSRWLockExclusive(&g_tls_handle_slot->lock);
    g_tls_handle_slot = nullptr;
    g_tls_handle = 0u;
  }

  AcquireSRWLockShared(&g_iwd_table_lock);
  IwdHandleSlot* slot = FindHandleNoLock(key);
  if (slot != nullptr) AcquireSRWLockExclusive(&slot->lock);
  ReleaseSRWLockShared(&g_iwd_table_lock);

  if (slot != nullptr && slot->handle == key && slot->view != nullptr) {
    g_tls_handle_slot = slot;
    g_tls_handle = key;
  }
  return slot;
}

void UnlockHandle(IwdHandleSlot* slot) {
  if (slot != nullptr) ReleaseSRWLockExclusive(&slot->lock);
}

bool SyncKernelPointerLocked(HANDLE file, IwdHandleSlot& slot) {
  if (!slot.position_valid) return true;
  LARGE_INTEGER position = {};
  position.QuadPart = static_cast<LONGLONG>(slot.virtual_position);
  return ::SetFilePointerEx(file, position, nullptr, FILE_BEGIN) != FALSE;
}

IwdHandleSlot* LockOrCreateHandle(HANDLE file) {
  if (GetIwdCacheMode() == 0
      || file == nullptr
      || file == INVALID_HANDLE_VALUE) {
    return nullptr;
  }

  if (IwdHandleSlot* existing = LockExistingHandle(file)) {
    return existing;
  }

  std::array<char, 160> path = {};
  CopyFilePathForHandle(reinterpret_cast<uintptr_t>(file), path);
  ResolveFilePathFromLiveHandle(reinterpret_cast<uintptr_t>(file), path);
  if (!IsIwdPath(path)) return nullptr;

  AcquireSRWLockExclusive(&g_iwd_table_lock);

  const uintptr_t key = reinterpret_cast<uintptr_t>(file);
  IwdHandleSlot* slot = FindHandleNoLock(key);
  if (slot == nullptr) slot = FindEmptyHandleNoLock();
  if (slot == nullptr) {
    ReleaseSRWLockExclusive(&g_iwd_table_lock);
    g_fallbacks.fetch_add(1u, std::memory_order_relaxed);
    return nullptr;
  }

  AcquireSRWLockExclusive(&slot->lock);
  if (slot->handle == key && slot->view != nullptr) {
    g_tls_handle_slot = slot;
    g_tls_handle = key;
    ReleaseSRWLockExclusive(&g_iwd_table_lock);
    return slot;
  }

  int archive_index = FindArchiveNoLock(path);
  const bool reused = archive_index >= 0;

  if (archive_index < 0) {
    archive_index = FindEmptyArchiveNoLock();
    if (archive_index < 0) {
      ReleaseSRWLockExclusive(&slot->lock);
      ReleaseSRWLockExclusive(&g_iwd_table_lock);
      g_fallbacks.fetch_add(1u, std::memory_order_relaxed);
      return nullptr;
    }

    LARGE_INTEGER size = {};
    HANDLE mapping = nullptr;
    const uint8_t* view = nullptr;

    if (GetFileSizeEx(file, &size) != FALSE && size.QuadPart > 0) {
      mapping = CreateFileMappingW(
          file, nullptr, PAGE_READONLY, 0u, 0u, nullptr);
      if (mapping != nullptr) {
        view = static_cast<const uint8_t*>(
            MapViewOfFile(mapping, FILE_MAP_READ, 0u, 0u, 0u));
      }
    }

    if (view == nullptr) {
      if (mapping != nullptr) ::CloseHandle(mapping);
      ReleaseSRWLockExclusive(&slot->lock);
      ReleaseSRWLockExclusive(&g_iwd_table_lock);
      g_fallbacks.fetch_add(1u, std::memory_order_relaxed);
      return nullptr;
    }

    auto& archive = g_archives[static_cast<size_t>(archive_index)];
    archive.mapping = mapping;
    archive.view = view;
    archive.size = static_cast<uint64_t>(size.QuadPart);
    archive.path = path;
    g_unique_archive_maps.fetch_add(1u, std::memory_order_relaxed);

    std::stringstream message;
    message << "[MW3 V27 IWD Cache] persistent archive view: "
            << archive.path.data() << " | "
            << std::fixed << std::setprecision(1)
            << (static_cast<double>(archive.size) / (1024.0 * 1024.0))
            << " MiB";
    reshade::log::message(
        reshade::log::level::info, message.str().c_str());
  }

  auto& archive = g_archives[static_cast<size_t>(archive_index)];

  LARGE_INTEGER zero = {};
  LARGE_INTEGER current = {};
  const BOOL have_position =
      ::SetFilePointerEx(file, zero, &current, FILE_CURRENT);

  slot->handle = key;
  slot->view = archive.view;
  slot->size = archive.size;
  slot->virtual_position =
      have_position != FALSE && current.QuadPart >= 0
          ? static_cast<uint64_t>(current.QuadPart)
          : 0u;
  slot->position_valid =
      have_position != FALSE && current.QuadPart >= 0;
  slot->archive_index = static_cast<uint16_t>(archive_index);

  g_handle_bindings.fetch_add(1u, std::memory_order_relaxed);
  if (reused) g_mapping_reuses.fetch_add(1u, std::memory_order_relaxed);

  g_tls_handle_slot = slot;
  g_tls_handle = key;

  ReleaseSRWLockExclusive(&g_iwd_table_lock);
  return slot;
}

bool TryServeIwdRead(
    HANDLE file,
    LPVOID buffer,
    DWORD bytes_to_read,
    LPDWORD bytes_read,
    LPOVERLAPPED overlapped,
    uintptr_t caller_rva,
    DWORD& actual_out) {
  actual_out = 0u;
  if (GetIwdCacheMode() == 0
      || caller_rva != MW3_IWD_STREAM_READ_CALLER_RVA
      || overlapped != nullptr
      || buffer == nullptr) {
    return false;
  }

  IwdHandleSlot* slot = LockOrCreateHandle(file);
  if (slot == nullptr) return false;

  if (!slot->position_valid || slot->virtual_position > slot->size) {
    UnlockHandle(slot);
    g_fallbacks.fetch_add(1u, std::memory_order_relaxed);
    return false;
  }

  const uint64_t available = slot->size - slot->virtual_position;
  const DWORD actual = static_cast<DWORD>(
      std::min<uint64_t>(available, static_cast<uint64_t>(bytes_to_read)));

  if (actual != 0u) {
    std::memcpy(
        buffer,
        slot->view + slot->virtual_position,
        static_cast<size_t>(actual));
  }

  slot->virtual_position += actual;
  actual_out = actual;
  if (bytes_read != nullptr) *bytes_read = actual;
  UnlockHandle(slot);

  // No per-read diagnostics or atomic byte/call counters in the lean build.
  return true;
}

void RemoveHandleBinding(HANDLE handle) {
  if (handle == nullptr || handle == INVALID_HANDLE_VALUE) return;
  const uintptr_t key = reinterpret_cast<uintptr_t>(handle);

  if (g_tls_handle == key) {
    g_tls_handle_slot = nullptr;
    g_tls_handle = 0u;
  }

  AcquireSRWLockExclusive(&g_iwd_table_lock);
  IwdHandleSlot* slot = FindHandleNoLock(key);
  if (slot != nullptr) {
    AcquireSRWLockExclusive(&slot->lock);
    ResetHandleSlotLocked(*slot);
    ReleaseSRWLockExclusive(&slot->lock);
  }
  ReleaseSRWLockExclusive(&g_iwd_table_lock);
}

void CleanupMappings() {
  AcquireSRWLockExclusive(&g_iwd_table_lock);
  for (auto& slot : g_handles) {
    AcquireSRWLockExclusive(&slot.lock);
    ResetHandleSlotLocked(slot);
    ReleaseSRWLockExclusive(&slot.lock);
  }
  for (auto& archive : g_archives) ResetArchive(archive);
  ReleaseSRWLockExclusive(&g_iwd_table_lock);
}

// -----------------------------------------------------------------------------
// High-resolution ~1 ms timing helper
// -----------------------------------------------------------------------------

extern void* g_orig_sleep;
using WaitForSingleObjectFn = DWORD (WINAPI*)(HANDLE, DWORD);

thread_local HANDLE g_tls_high_res_timer = nullptr;
thread_local bool g_tls_high_res_timer_attempted = false;
thread_local double g_tls_wait_request_ms = MW3_PRECISE_INITIAL_REQUEST_MS;
thread_local double g_tls_sleep_request_ms = MW3_PRECISE_INITIAL_REQUEST_MS;
thread_local uint32_t g_tls_wait_calibration_samples = 0u;
thread_local uint32_t g_tls_sleep_calibration_samples = 0u;
thread_local uint32_t g_tls_renderer_timeout_streak = 0u;

inline int64_t QpcNowRaw() {
  LARGE_INTEGER q = {};
  QueryPerformanceCounter(&q);
  return q.QuadPart;
}

inline double QpcElapsedMs(int64_t begin, int64_t end) {
  static LARGE_INTEGER frequency = []() {
    LARGE_INTEGER f = {};
    QueryPerformanceFrequency(&f);
    return f;
  }();
  if (frequency.QuadPart <= 0 || end < begin) return 0.0;
  return static_cast<double>(end - begin) * 1000.0
      / static_cast<double>(frequency.QuadPart);
}

inline int64_t QpcTicksFromMs(double ms) {
  static LARGE_INTEGER frequency = []() {
    LARGE_INTEGER f = {};
    QueryPerformanceFrequency(&f);
    return f;
  }();
  if (frequency.QuadPart <= 0) return 0;
  return static_cast<int64_t>(
      static_cast<double>(frequency.QuadPart) * ms / 1000.0);
}

HANDLE GetThreadHighResTimer() {
  if (g_tls_high_res_timer != nullptr) return g_tls_high_res_timer;
  if (g_tls_high_res_timer_attempted) return nullptr;
  g_tls_high_res_timer_attempted = true;
  g_tls_high_res_timer = CreateWaitableTimerExW(
      nullptr, nullptr, 0x00000002u, TIMER_MODIFY_STATE | SYNCHRONIZE);
  if (g_tls_high_res_timer == nullptr) {
    g_precise_timer_failures.fetch_add(1u, std::memory_order_relaxed);
  }
  return g_tls_high_res_timer;
}

void CalibrateTimerRequest(double& request_ms, double actual_ms) {
  if (actual_ms <= 0.0 || actual_ms > 8.0) return;
  const double error = MW3_PRECISE_TARGET_ACTUAL_MS - actual_ms;
  request_ms = std::clamp(
      request_ms + error * MW3_PRECISE_CALIBRATION_GAIN,
      MW3_PRECISE_MIN_REQUEST_MS,
      MW3_PRECISE_MAX_REQUEST_MS);
}

bool ArmPreciseTimer(HANDLE timer, double request_ms) {
  if (timer == nullptr) return false;
  (void)::WaitForSingleObject(timer, 0u);
  LARGE_INTEGER due = {};
  const double clamped = std::clamp(
      request_ms, MW3_PRECISE_MIN_REQUEST_MS, MW3_ARCHIVE_COALESCE_4MS);
  due.QuadPart = -std::max<LONGLONG>(
      1LL, static_cast<LONGLONG>(clamped * 10000.0));
  if (::SetWaitableTimer(timer, &due, 0, nullptr, nullptr, FALSE) == FALSE) {
    g_precise_timer_failures.fetch_add(1u, std::memory_order_relaxed);
    return false;
  }
  return true;
}

bool ArchiveBurstActiveForCoalescing() {
  const int64_t until = g_archive_burst_until_qpc.load(std::memory_order_relaxed);
  if (until <= 0) return false;
  return QpcNowRaw() <= until;
}

DWORD PreciseRendererEventWait(
    WaitForSingleObjectFn original,
    HANDLE object,
    DWORD milliseconds) {
  if (original == nullptr) return WAIT_FAILED;

  const DWORD immediate = original(object, 0u);
  if (immediate != WAIT_TIMEOUT) {
    g_tls_renderer_timeout_streak = 0u;
    return immediate;
  }

  double request_ms = g_tls_wait_request_ms;
  bool coalesced = false;
  if (GetArchiveBurstWaitCoalesceEnabled()
      && g_tls_renderer_timeout_streak >= MW3_COALESCE_STREAK_2MS) {
    const bool archive_burst = ArchiveBurstActiveForCoalescing();
    if (archive_burst && g_tls_renderer_timeout_streak >= MW3_COALESCE_STREAK_4MS) {
      request_ms = MW3_ARCHIVE_COALESCE_4MS;
      coalesced = true;
    } else if (archive_burst
               || g_tls_renderer_timeout_streak >= MW3_ISOLATED_SYNC_COALESCE_STREAK) {
      request_ms = MW3_RENDER_COALESCE_2MS;
      coalesced = true;
    }
  }

  HANDLE timer = GetThreadHighResTimer();
  if (timer == nullptr || !ArmPreciseTimer(timer, request_ms)) {
    return original(object, milliseconds);
  }

  const bool calibrating =
      !coalesced && g_tls_wait_calibration_samples < MW3_PRECISE_CALIBRATION_SAMPLES;
  const int64_t begin = calibrating ? QpcNowRaw() : 0;

  HANDLE objects[2] = {object, timer};
  const DWORD result = ::WaitForMultipleObjects(2u, objects, FALSE, INFINITE);

  if (result == WAIT_OBJECT_0) {
    (void)::CancelWaitableTimer(timer);
    (void)::WaitForSingleObject(timer, 0u);
    g_tls_renderer_timeout_streak = 0u;
    return WAIT_OBJECT_0;
  }
  if (result == WAIT_OBJECT_0 + 1u) {
    ++g_tls_renderer_timeout_streak;
    if (calibrating) {
      const int64_t end = QpcNowRaw();
      CalibrateTimerRequest(g_tls_wait_request_ms, QpcElapsedMs(begin, end));
      ++g_tls_wait_calibration_samples;
    }
    return WAIT_TIMEOUT;
  }
  if (result == WAIT_ABANDONED_0) return WAIT_ABANDONED_0;
  return result;
}

void PreciseRendererSleep1() {
  HANDLE timer = GetThreadHighResTimer();
  const auto original = reinterpret_cast<void (WINAPI*)(DWORD)>(g_orig_sleep);
  if (timer == nullptr || !ArmPreciseTimer(timer, g_tls_sleep_request_ms)) {
    if (original != nullptr) original(1u);
    return;
  }

  const bool calibrating =
      g_tls_sleep_calibration_samples < MW3_PRECISE_CALIBRATION_SAMPLES;
  const int64_t begin = calibrating ? QpcNowRaw() : 0;
  (void)::WaitForSingleObject(timer, INFINITE);
  if (calibrating) {
    const int64_t end = QpcNowRaw();
    CalibrateTimerRequest(g_tls_sleep_request_ms, QpcElapsedMs(begin, end));
    ++g_tls_sleep_calibration_samples;
  }
}

// -----------------------------------------------------------------------------
// Hook implementations
// -----------------------------------------------------------------------------

void ResetArchiveBurstTlsOnWorkerIdle();

using SleepFn = VOID (WINAPI*)(DWORD);
using ReadFileFn = BOOL (WINAPI*)(
    HANDLE, LPVOID, DWORD, LPDWORD, LPOVERLAPPED);
using CreateFileAFn = HANDLE (WINAPI*)(
    LPCSTR, DWORD, DWORD, LPSECURITY_ATTRIBUTES, DWORD, DWORD, HANDLE);
using CreateFileWFn = HANDLE (WINAPI*)(
    LPCWSTR, DWORD, DWORD, LPSECURITY_ATTRIBUTES, DWORD, DWORD, HANDLE);
using CloseHandleFn = BOOL (WINAPI*)(HANDLE);
using SetFilePointerFn = DWORD (WINAPI*)(HANDLE, LONG, PLONG, DWORD);
using SetFilePointerExFn = BOOL (WINAPI*)(
    HANDLE, LARGE_INTEGER, PLARGE_INTEGER, DWORD);

void* g_orig_sleep = nullptr;
void* g_orig_wait_single = nullptr;
void* g_orig_read_file = nullptr;
void* g_orig_create_file_a = nullptr;
void* g_orig_create_file_w = nullptr;
void* g_orig_close_handle = nullptr;
void* g_orig_set_file_pointer = nullptr;
void* g_orig_set_file_pointer_ex = nullptr;

VOID WINAPI HookSleep(DWORD milliseconds) {
  const uintptr_t return_address =
      reinterpret_cast<uintptr_t>(_ReturnAddress());
  const uintptr_t caller_rva = ReturnAddressToExeRva(return_address);

  if (milliseconds == 1u
      && caller_rva == MW3_BACKEND_SLEEP1_RETURN_RVA
      && GetBackendSleep1YieldEnabled()) {
    (void)SwitchToThread();
    return;
  }

  if (milliseconds == 1u
      && caller_rva == MW3_RENDER_SLEEP1_RETURN_RVA
      && GetRendererSleep1PreciseEnabled()) {
    PreciseRendererSleep1();
    return;
  }

  const auto original = reinterpret_cast<SleepFn>(g_orig_sleep);
  if (original != nullptr) original(milliseconds);
}

DWORD WINAPI HookWaitForSingleObject(HANDLE object, DWORD milliseconds) {
  const auto original =
      reinterpret_cast<WaitForSingleObjectFn>(g_orig_wait_single);
  if (original == nullptr) return WAIT_FAILED;

  const uintptr_t caller_rva =
      ReturnAddressToExeRva(
          reinterpret_cast<uintptr_t>(_ReturnAddress()));

  if (caller_rva == MW3_WORKER_WAIT_RETURN_RVA) {
    // Verified archive/job worker idle boundary. Restore burst-only priority and
    // clear sparse burst state before the worker actually blocks.
    ResetArchiveBurstTlsOnWorkerIdle();
  }

  if (!GetRendererWait1PreciseEnabled()
      || milliseconds != 1u
      || caller_rva != MW3_RENDER_WAIT1_RETURN_RVA
      || object == nullptr
      || object == INVALID_HANDLE_VALUE) {
    return original(object, milliseconds);
  }

  return PreciseRendererEventWait(original, object, milliseconds);
}

BOOL WINAPI HookReadFile(
    HANDLE file,
    LPVOID buffer,
    DWORD bytes_to_read,
    LPDWORD bytes_read,
    LPOVERLAPPED overlapped) {
  const uintptr_t caller_rva =
      ReturnAddressToExeRva(
          reinterpret_cast<uintptr_t>(_ReturnAddress()));

  const auto original = reinterpret_cast<ReadFileFn>(g_orig_read_file);
  if (original == nullptr) return FALSE;

  const DWORD incoming_last_error = GetLastError();

  DWORD local_bytes_read = 0u;
  LPDWORD observed_bytes_read = bytes_read;
  if (observed_bytes_read == nullptr && overlapped == nullptr) {
    observed_bytes_read = &local_bytes_read;
  }

  DWORD cached_actual = 0u;
  if (TryServeIwdRead(
          file,
          buffer,
          bytes_to_read,
          observed_bytes_read,
          overlapped,
          caller_rva,
          cached_actual)) {
    SetLastError(incoming_last_error);
    return TRUE;
  }

  IwdHandleSlot* slot =
      overlapped == nullptr ? LockExistingHandle(file) : nullptr;
  if (slot != nullptr && !SyncKernelPointerLocked(file, *slot)) {
    UnlockHandle(slot);
    slot = nullptr;
  }

  SetLastError(incoming_last_error);
  const BOOL result =
      original(file, buffer, bytes_to_read, observed_bytes_read, overlapped);
  const DWORD actual =
      result != FALSE && observed_bytes_read != nullptr
          ? *observed_bytes_read
          : 0u;

  if (slot != nullptr) {
    if (result != FALSE && slot->position_valid) {
      slot->virtual_position += actual;
    }
    UnlockHandle(slot);
  }

  return result;
}

HANDLE WINAPI HookCreateFileA(
    LPCSTR filename,
    DWORD desired_access,
    DWORD share_mode,
    LPSECURITY_ATTRIBUTES security,
    DWORD creation_disposition,
    DWORD flags_and_attributes,
    HANDLE template_file) {
  const auto original =
      reinterpret_cast<CreateFileAFn>(g_orig_create_file_a);
  if (original == nullptr) return INVALID_HANDLE_VALUE;

  const HANDLE result = original(
      filename,
      desired_access,
      share_mode,
      security,
      creation_disposition,
      flags_and_attributes,
      template_file);
  StoreFilePathA(result, filename);
  return result;
}

HANDLE WINAPI HookCreateFileW(
    LPCWSTR filename,
    DWORD desired_access,
    DWORD share_mode,
    LPSECURITY_ATTRIBUTES security,
    DWORD creation_disposition,
    DWORD flags_and_attributes,
    HANDLE template_file) {
  const auto original =
      reinterpret_cast<CreateFileWFn>(g_orig_create_file_w);
  if (original == nullptr) return INVALID_HANDLE_VALUE;

  const HANDLE result = original(
      filename,
      desired_access,
      share_mode,
      security,
      creation_disposition,
      flags_and_attributes,
      template_file);
  StoreFilePathW(result, filename);
  return result;
}

DWORD WINAPI HookSetFilePointer(
    HANDLE file,
    LONG distance_low,
    PLONG distance_high,
    DWORD move_method) {
  const auto original =
      reinterpret_cast<SetFilePointerFn>(g_orig_set_file_pointer);
  if (original == nullptr) return INVALID_SET_FILE_POINTER;

  IwdHandleSlot* slot = LockExistingHandle(file);
  if (slot != nullptr) SyncKernelPointerLocked(file, *slot);

  SetLastError(NO_ERROR);
  const DWORD result =
      original(file, distance_low, distance_high, move_method);
  const DWORD saved_error = GetLastError();
  const bool success =
      result != INVALID_SET_FILE_POINTER || saved_error == NO_ERROR;

  if (slot != nullptr) {
    if (success) {
      LARGE_INTEGER position = {};
      position.LowPart = result;
      position.HighPart = distance_high != nullptr ? *distance_high : 0;
      slot->virtual_position =
          position.QuadPart >= 0
              ? static_cast<uint64_t>(position.QuadPart)
              : 0u;
      slot->position_valid = position.QuadPart >= 0;
    }
    UnlockHandle(slot);
  }

  SetLastError(saved_error);
  return result;
}

BOOL WINAPI HookSetFilePointerEx(
    HANDLE file,
    LARGE_INTEGER distance,
    PLARGE_INTEGER new_position,
    DWORD move_method) {
  const auto original =
      reinterpret_cast<SetFilePointerExFn>(g_orig_set_file_pointer_ex);
  if (original == nullptr) return FALSE;

  IwdHandleSlot* slot = LockExistingHandle(file);
  if (slot != nullptr) SyncKernelPointerLocked(file, *slot);

  LARGE_INTEGER local_position = {};
  PLARGE_INTEGER observed_position =
      new_position != nullptr ? new_position : &local_position;

  const BOOL result =
      original(file, distance, observed_position, move_method);
  const DWORD saved_error = GetLastError();

  if (slot != nullptr) {
    if (result != FALSE) {
      slot->virtual_position =
          observed_position->QuadPart >= 0
              ? static_cast<uint64_t>(observed_position->QuadPart)
              : 0u;
      slot->position_valid = observed_position->QuadPart >= 0;
    }
    UnlockHandle(slot);
  }

  SetLastError(saved_error);
  return result;
}

void InvalidateFastCrtTlsForHandle(HANDLE handle);

BOOL WINAPI HookCloseHandle(HANDLE handle) {
  InvalidateFastCrtTlsForHandle(handle);
  RemoveHandleBinding(handle);
  RemoveFilePathForHandle(handle);
  const auto original =
      reinterpret_cast<CloseHandleFn>(g_orig_close_handle);
  return original != nullptr ? original(handle) : FALSE;
}

// -----------------------------------------------------------------------------
// Exact-build statically linked CRT _read fast path
// -----------------------------------------------------------------------------


// -----------------------------------------------------------------------------
// V27: modern zlib-ng shadow-stream accelerator for the REAL IWD DEFLATE stage
// -----------------------------------------------------------------------------
// The supplied x64 executable embeds zlib 1.1.4. Static disassembly proves that
// minizip unzReadCurrentFile (iw5sp+0x3157C0) calls the bundled inflate at
// iw5sp+0x312790 with Z_SYNC_FLUSH. V21/V23/V26 removed physical I/O and CRT
// overhead, but the user's Tracy captures still scale with logical IWD work.
//
// We deliberately DO NOT pass MW3's old 80-byte z_stream to a modern zlib DLL:
// current zlib-compatible x64 builds use an 88-byte z_stream (reserved field).
// Instead each eligible MW3 stream gets an independent modern shadow stream.
// Input/output pointers are mirrored before each inflate call and public counters
// are copied back afterward. MW3's original old-zlib state remains untouched and
// is freed by its original inflateEnd, so fallback/teardown never asks one zlib
// implementation to free the other's private state.

constexpr size_t MW3_ZNG_SHADOW_SLOT_COUNT = 64u;
constexpr int MW3_Z_OK = 0;
constexpr int MW3_Z_STREAM_END = 1;
constexpr int MW3_Z_RAW_DEFLATE_WINDOW_BITS = -15;

struct Mw3OldZStream80 {
  unsigned char* next_in;
  unsigned int avail_in;
  unsigned long total_in;
  unsigned char* next_out;
  unsigned int avail_out;
  unsigned long total_out;
  const char* msg;
  void* state;
  void* (__cdecl* zalloc)(void*, unsigned int, unsigned int);
  void (__cdecl* zfree)(void*, void*);
  void* opaque;
  int data_type;
  unsigned long adler;
};

struct Mw3ModernZStream88 {
  unsigned char* next_in;
  unsigned int avail_in;
  unsigned long total_in;
  unsigned char* next_out;
  unsigned int avail_out;
  unsigned long total_out;
  const char* msg;
  void* state;
  void* (__cdecl* zalloc)(void*, unsigned int, unsigned int);
  void (__cdecl* zfree)(void*, void*);
  void* opaque;
  int data_type;
  unsigned long adler;
  unsigned long reserved;
};

#if defined(_WIN64)
static_assert(sizeof(Mw3OldZStream80) == 0x50, "MW3 zlib 1.1.4 stream ABI changed");
static_assert(sizeof(Mw3ModernZStream88) == 0x58, "modern zlib-compatible x64 stream ABI changed");
#endif

using GameInflateFn = int(__fastcall*)(Mw3OldZStream80*, int);
using GameInflateEndFn = int(__fastcall*)(Mw3OldZStream80*);
using GameFsSeekFn = int(__fastcall*)(uint64_t, int64_t, int);
using ZngVersionFn = const char* (__cdecl*)();
using ZngInflateInit2Fn = int(__cdecl*)(Mw3ModernZStream88*, int, const char*, int);
using ZngInflateFn = int(__cdecl*)(Mw3ModernZStream88*, int);
using ZngInflateEndFn = int(__cdecl*)(Mw3ModernZStream88*);

HMODULE g_zng_module = nullptr;
ZngVersionFn g_zng_version = nullptr;
ZngInflateInit2Fn g_zng_inflate_init2 = nullptr;
ZngInflateFn g_zng_inflate = nullptr;
ZngInflateEndFn g_zng_inflate_end = nullptr;
GameInflateFn g_original_game_inflate = nullptr;
GameInflateEndFn g_original_game_inflate_end = nullptr;
GameFsSeekFn g_original_game_fs_seek = nullptr;
std::atomic<bool> g_zng_detours_installed{false};
std::atomic<bool> g_sound_fs_seek_detoured{false};

// Defined in the persistent IWD mapping section below. The minizip refill path
// reaches the exact CRT _read hook before inflate, so this TLS pointer identifies
// the archive mapping that contains the current compressed entry.
extern thread_local IwdHandleSlot* g_tls_crt_fast_slot;

struct ZngShadowSlot {
  SRWLOCK lock = SRWLOCK_INIT;
  Mw3OldZStream80* old_stream = nullptr;
  // V31: MW3 zlib private state pointer identifies the current DEFLATE generation.
  // The z_stream address itself may be recycled across entries.
  void* old_state_generation = nullptr;
  Mw3ModernZStream88 modern = {};
  bool modern_initialized = false;
};
std::array<ZngShadowSlot, MW3_ZNG_SHADOW_SLOT_COUNT> g_zng_shadow_slots = {};
SRWLOCK g_zng_table_lock = SRWLOCK_INIT;
thread_local Mw3OldZStream80* g_tls_zng_old_stream = nullptr;
thread_local ZngShadowSlot* g_tls_zng_slot = nullptr;


// -----------------------------------------------------------------------------
// V36 streamed-sound decoded-prefix cache + fully-cached fast seek
// -----------------------------------------------------------------------------
// The sound loader calls FS_Seek from exactly iw5sp+0x30E43F before its 128 KiB
// FS_Read. For compressed entries, stock FS_Seek closes/reopens on backward seeks
// and then decompresses from byte zero up to the requested offset. V32/V33 fixed
// the null-output compatibility problem, but that made this repeated decode work
// real again and therefore brought some traversal hitches back.
//
// V34 marks only this exact sound FS_Seek caller. For that one FS handle it owns a
// separate raw-DEFLATE zlib-ng decoder fed DIRECTLY from the existing persistent
// mapped IWD view. The cache grows only as far as the sound stream requests. Each
// uncompressed byte is decoded at most once for the lifetime of that sound entry;
// backward seeks and repeated reads are served from the decoded prefix.
//
// Non-audio IWD entries never enter this path and keep the V31/V33 hot path.
constexpr uint32_t MW3_SOUND_CACHE_MAX_ENTRY_BYTES = 128u * 1024u * 1024u;
constexpr size_t MW3_SOUND_CACHE_COMMIT_GRANULARITY = 256u * 1024u;
constexpr int MW3_Z_NO_FLUSH = 0;
constexpr int MW3_Z_BUF_ERROR = -5;

struct SoundEntryMeta {
  uintptr_t unz_file_identity = 0u;
  const uint8_t* archive_view = nullptr;
  uint64_t archive_size = 0u;
  uint32_t data_offset = 0u;
  uint32_t compressed_size = 0u;
  uint32_t uncompressed_size = 0u;
};

struct SoundPrefixCache {
  SRWLOCK lock = SRWLOCK_INIT;
  uintptr_t unz_file_identity = 0u;
  const uint8_t* archive_view = nullptr;
  uint64_t archive_size = 0u;
  uint32_t data_offset = 0u;
  uint32_t compressed_size = 0u;
  uint32_t uncompressed_size = 0u;
  uint8_t* decoded = nullptr;
  size_t committed_bytes = 0u;
  uint32_t decoded_bytes = 0u;
  Mw3ModernZStream88 decoder = {};
  bool decoder_initialized = false;
  bool stream_end = false;
  bool failed = false;
};

std::array<SoundPrefixCache, MW3_FS_HANDLE_COUNT> g_sound_prefix_caches = {};
thread_local int g_tls_sound_fs_handle = -1;

char LowerAsciiFast(char c) {
  return (c >= 'A' && c <= 'Z') ? static_cast<char>(c + ('a' - 'A')) : c;
}

bool IsSoundNameForFsHandle(uint64_t handle_index) {
  if (g_exe_base == 0u || handle_index >= MW3_FS_HANDLE_COUNT) return false;
  const uintptr_t record = g_exe_base + MW3_FS_HANDLE_TABLE_RVA
      + static_cast<uintptr_t>(handle_index) * MW3_FS_HANDLE_RECORD_SIZE;
  const char* name = reinterpret_cast<const char*>(record + MW3_FS_HANDLE_NAME_OFFSET);
  if (name == nullptr) return false;
  return LowerAsciiFast(name[0]) == 's'
      && LowerAsciiFast(name[1]) == 'o'
      && LowerAsciiFast(name[2]) == 'u'
      && LowerAsciiFast(name[3]) == 'n'
      && LowerAsciiFast(name[4]) == 'd'
      && (name[5] == '/' || name[5] == '\\');
}

Mw3OldZStream80* CurrentZStreamForFsHandle(uint64_t handle_index) {
  if (g_exe_base == 0u || handle_index >= MW3_FS_HANDLE_COUNT) return nullptr;
  const uintptr_t record = g_exe_base + MW3_FS_HANDLE_TABLE_RVA
      + static_cast<uintptr_t>(handle_index) * MW3_FS_HANDLE_RECORD_SIZE;
  const uintptr_t unz_file = *reinterpret_cast<const uintptr_t*>(record);
  if (unz_file == 0u) return nullptr;
  const uintptr_t current_file = *reinterpret_cast<const uintptr_t*>(
      unz_file + MW3_UNZ_CURRENT_FILE_OFFSET);
  if (current_file == 0u) return nullptr;
  return reinterpret_cast<Mw3OldZStream80*>(current_file + 0x08u);
}

bool TryGetSoundEntryMeta(
    uint64_t handle_index,
    Mw3OldZStream80* old_stream,
    SoundEntryMeta& out) {
  out = {};
  if (old_stream == nullptr
      || handle_index >= MW3_FS_HANDLE_COUNT
      || !IsSoundNameForFsHandle(handle_index)) {
    return false;
  }

  const uintptr_t record = g_exe_base + MW3_FS_HANDLE_TABLE_RVA
      + static_cast<uintptr_t>(handle_index) * MW3_FS_HANDLE_RECORD_SIZE;
  const uintptr_t unz_file = *reinterpret_cast<const uintptr_t*>(record);
  if (unz_file == 0u) return false;
  const uintptr_t current_file = *reinterpret_cast<const uintptr_t*>(
      unz_file + MW3_UNZ_CURRENT_FILE_OFFSET);
  if (current_file == 0u
      || reinterpret_cast<Mw3OldZStream80*>(current_file + 0x08u) != old_stream) {
    return false;
  }

  IwdHandleSlot* mapped = g_tls_crt_fast_slot;
  if (mapped == nullptr || mapped->view == nullptr || mapped->size == 0u) {
    return false;
  }

  const auto* current = reinterpret_cast<const uint8_t*>(old_stream) - 0x08u;
  const uint32_t current_compressed_file_offset =
      *reinterpret_cast<const uint32_t*>(current + 0x58u);
  const uint32_t remaining_compressed = *reinterpret_cast<const uint32_t*>(current + 0x6Cu);
  const uint32_t remaining_uncompressed = *reinterpret_cast<const uint32_t*>(current + 0x70u);

  const uint64_t loaded_compressed64 = static_cast<uint64_t>(old_stream->total_in)
      + static_cast<uint64_t>(old_stream->avail_in);
  if (loaded_compressed64 > current_compressed_file_offset) return false;
  const uint32_t data_offset = static_cast<uint32_t>(
      static_cast<uint64_t>(current_compressed_file_offset) - loaded_compressed64);

  const uint64_t compressed_size64 = loaded_compressed64
      + static_cast<uint64_t>(remaining_compressed);
  const uint64_t uncompressed_size64 = static_cast<uint64_t>(old_stream->total_out)
      + static_cast<uint64_t>(remaining_uncompressed);

  if (compressed_size64 == 0u
      || compressed_size64 > 0xFFFFFFFFull
      || uncompressed_size64 == 0u
      || uncompressed_size64 > MW3_SOUND_CACHE_MAX_ENTRY_BYTES
      || static_cast<uint64_t>(data_offset) + compressed_size64 > mapped->size) {
    return false;
  }

  out.unz_file_identity = unz_file;
  out.archive_view = mapped->view;
  out.archive_size = mapped->size;
  out.data_offset = data_offset;
  out.compressed_size = static_cast<uint32_t>(compressed_size64);
  out.uncompressed_size = static_cast<uint32_t>(uncompressed_size64);
  return true;
}

void ResetSoundPrefixCacheLocked(SoundPrefixCache& cache) {
  if (cache.decoder_initialized && g_zng_inflate_end != nullptr) {
    (void)g_zng_inflate_end(&cache.decoder);
  }
  if (cache.decoded != nullptr) {
    (void)VirtualFree(cache.decoded, 0u, MEM_RELEASE);
  }
  cache.unz_file_identity = 0u;
  cache.archive_view = nullptr;
  cache.archive_size = 0u;
  cache.data_offset = 0u;
  cache.compressed_size = 0u;
  cache.uncompressed_size = 0u;
  cache.decoded = nullptr;
  cache.committed_bytes = 0u;
  cache.decoded_bytes = 0u;
  cache.decoder = {};
  cache.decoder_initialized = false;
  cache.stream_end = false;
  cache.failed = false;
}

bool SoundCacheKeyMatches(
    const SoundPrefixCache& cache,
    const SoundEntryMeta& meta) {
  return cache.unz_file_identity == meta.unz_file_identity
      && cache.archive_view == meta.archive_view
      && cache.archive_size == meta.archive_size
      && cache.data_offset == meta.data_offset
      && cache.compressed_size == meta.compressed_size
      && cache.uncompressed_size == meta.uncompressed_size;
}

bool InitializeSoundPrefixCacheLocked(
    SoundPrefixCache& cache,
    const SoundEntryMeta& meta) {
  if (g_zng_inflate_init2 == nullptr || g_zng_version == nullptr) return false;

  if (!SoundCacheKeyMatches(cache, meta)) {
    ResetSoundPrefixCacheLocked(cache);
  }
  if (cache.decoder_initialized && cache.decoded != nullptr) return !cache.failed;
  if (cache.failed) return false;

  void* reserved = VirtualAlloc(
      nullptr,
      static_cast<SIZE_T>(meta.uncompressed_size),
      MEM_RESERVE,
      PAGE_READWRITE);
  if (reserved == nullptr) {
    cache.failed = true;
    return false;
  }

  cache.unz_file_identity = meta.unz_file_identity;
  cache.archive_view = meta.archive_view;
  cache.archive_size = meta.archive_size;
  cache.data_offset = meta.data_offset;
  cache.compressed_size = meta.compressed_size;
  cache.uncompressed_size = meta.uncompressed_size;
  cache.decoded = static_cast<uint8_t*>(reserved);
  cache.decoder = {};
  cache.decoder.zalloc = nullptr;
  cache.decoder.zfree = nullptr;
  cache.decoder.opaque = nullptr;

  const char* version_text = g_zng_version();
  const int init_result = g_zng_inflate_init2(
      &cache.decoder,
      MW3_Z_RAW_DEFLATE_WINDOW_BITS,
      version_text,
      static_cast<int>(sizeof(Mw3ModernZStream88)));
  if (init_result != MW3_Z_OK) {
    ResetSoundPrefixCacheLocked(cache);
    cache.failed = true;
    return false;
  }

  cache.decoder.next_in = const_cast<unsigned char*>(
      meta.archive_view + meta.data_offset);
  cache.decoder.avail_in = meta.compressed_size;
  cache.decoder_initialized = true;

  static std::atomic<bool> logged_first{false};
  if (!logged_first.exchange(true, std::memory_order_acq_rel)) {
    reshade::log::message(
        reshade::log::level::info,
        "[MW3 V36 Audio Cache] streamed-sound decoded-prefix cache active; direct mapped-IWD zlib-ng decoder will decompress each requested sound byte at most once.");
  }
  return true;
}

bool EnsureSoundPrefixDecodedLocked(
    SoundPrefixCache& cache,
    uint32_t required_bytes) {
  if (cache.failed || !cache.decoder_initialized || cache.decoded == nullptr) {
    return false;
  }
  required_bytes = std::min(required_bytes, cache.uncompressed_size);
  if (required_bytes <= cache.decoded_bytes) return true;

  const size_t commit_target = std::min<size_t>(
      cache.uncompressed_size,
      (static_cast<size_t>(required_bytes)
          + MW3_SOUND_CACHE_COMMIT_GRANULARITY - 1u)
          & ~(MW3_SOUND_CACHE_COMMIT_GRANULARITY - 1u));
  if (commit_target > cache.committed_bytes) {
    void* committed = VirtualAlloc(
        cache.decoded + cache.committed_bytes,
        commit_target - cache.committed_bytes,
        MEM_COMMIT,
        PAGE_READWRITE);
    if (committed == nullptr) {
      cache.failed = true;
      return false;
    }
    cache.committed_bytes = commit_target;
  }

  while (cache.decoded_bytes < required_bytes && !cache.stream_end) {
    const uint32_t wanted = required_bytes - cache.decoded_bytes;
    cache.decoder.next_out = cache.decoded + cache.decoded_bytes;
    cache.decoder.avail_out = wanted;

    const unsigned int in_before = cache.decoder.avail_in;
    const unsigned int out_before = cache.decoder.avail_out;
    const int result = g_zng_inflate(&cache.decoder, MW3_Z_NO_FLUSH);
    const uint32_t produced = out_before - cache.decoder.avail_out;
    cache.decoded_bytes += produced;

    if (result == MW3_Z_STREAM_END) {
      cache.stream_end = true;
      break;
    }
    const bool progress = produced != 0u || cache.decoder.avail_in != in_before;
    if (result != MW3_Z_OK && !(result == MW3_Z_BUF_ERROR && progress)) {
      cache.failed = true;
      return false;
    }
    if (!progress) {
      cache.failed = true;
      return false;
    }
  }

  return cache.decoded_bytes >= required_bytes;
}

bool SoundCacheMatchesCurrentStream(
    uint64_t handle_index,
    Mw3OldZStream80* old_stream,
    const SoundPrefixCache& cache,
    uint32_t* uncompressed_size_out = nullptr) {
  if (old_stream == nullptr
      || handle_index >= MW3_FS_HANDLE_COUNT
      || !IsSoundNameForFsHandle(handle_index)
      || cache.unz_file_identity == 0u
      || cache.decoded == nullptr
      || !cache.decoder_initialized
      || cache.failed) {
    return false;
  }

  const uintptr_t record = g_exe_base + MW3_FS_HANDLE_TABLE_RVA
      + static_cast<uintptr_t>(handle_index) * MW3_FS_HANDLE_RECORD_SIZE;
  const uintptr_t unz_file = *reinterpret_cast<const uintptr_t*>(record);
  if (unz_file == 0u || unz_file != cache.unz_file_identity) return false;

  const uintptr_t current_file = *reinterpret_cast<const uintptr_t*>(
      unz_file + MW3_UNZ_CURRENT_FILE_OFFSET);
  if (current_file == 0u
      || reinterpret_cast<Mw3OldZStream80*>(current_file + 0x08u) != old_stream) {
    return false;
  }

  const auto* current = reinterpret_cast<const uint8_t*>(old_stream) - 0x08u;
  const uint32_t current_compressed_file_offset =
      *reinterpret_cast<const uint32_t*>(current + 0x58u);
  const uint32_t remaining_compressed =
      *reinterpret_cast<const uint32_t*>(current + 0x6Cu);
  const uint32_t remaining_uncompressed =
      *reinterpret_cast<const uint32_t*>(current + 0x70u);

  const uint64_t loaded_compressed64 = static_cast<uint64_t>(old_stream->total_in)
      + static_cast<uint64_t>(old_stream->avail_in);
  if (loaded_compressed64 > current_compressed_file_offset) return false;
  const uint64_t data_offset64 =
      static_cast<uint64_t>(current_compressed_file_offset) - loaded_compressed64;
  const uint64_t compressed_size64 = loaded_compressed64
      + static_cast<uint64_t>(remaining_compressed);
  const uint64_t uncompressed_size64 = static_cast<uint64_t>(old_stream->total_out)
      + static_cast<uint64_t>(remaining_uncompressed);

  if (data_offset64 != cache.data_offset
      || compressed_size64 != cache.compressed_size
      || uncompressed_size64 != cache.uncompressed_size) {
    return false;
  }

  if (uncompressed_size_out != nullptr) {
    *uncompressed_size_out = static_cast<uint32_t>(uncompressed_size64);
  }
  return true;
}

bool TryServeSoundPrefixCache(
    Mw3OldZStream80* old_stream,
    int& result_out) {
  const int sound_handle = g_tls_sound_fs_handle;
  if (sound_handle < 0
      || sound_handle >= static_cast<int>(MW3_FS_HANDLE_COUNT)
      || old_stream == nullptr
      || old_stream->avail_out == 0u) {
    return false;
  }

  const bool is_real_output_read = old_stream->next_out != nullptr;
  const uint64_t position64 = static_cast<uint64_t>(old_stream->total_out);
  const uint32_t request = old_stream->avail_out;
  auto& cache = g_sound_prefix_caches[static_cast<size_t>(sound_handle)];

  // V36 cached-read fast path: once this exact sound entry has a decoded prefix,
  // ordinary 128 KiB stream reads only need a shared lock and a memcpy. The
  // exclusive decoder lock is reserved for prefix growth or cache replacement.
  AcquireSRWLockShared(&cache.lock);
  uint32_t cached_uncompressed_size = 0u;
  if (SoundCacheMatchesCurrentStream(
          static_cast<uint64_t>(sound_handle),
          old_stream,
          cache,
          &cached_uncompressed_size)
      && position64 <= cached_uncompressed_size) {
    const uint32_t position = static_cast<uint32_t>(position64);
    const uint32_t target = static_cast<uint32_t>(std::min<uint64_t>(
        cached_uncompressed_size,
        position64 + static_cast<uint64_t>(request)));
    if (target <= cache.decoded_bytes) {
      const uint32_t actual = target - position;
      if (actual != 0u && old_stream->next_out != nullptr) {
        std::memcpy(old_stream->next_out, cache.decoded + position, actual);
        old_stream->next_out += actual;
      }
      old_stream->avail_out -= actual;
      old_stream->total_out += actual;
      result_out = old_stream->total_out >= cached_uncompressed_size
          ? MW3_Z_STREAM_END
          : MW3_Z_OK;
      ReleaseSRWLockShared(&cache.lock);
      if (is_real_output_read) g_tls_sound_fs_handle = -1;
      return true;
    }
  }
  ReleaseSRWLockShared(&cache.lock);

  // Prefix growth still uses the exact V34/V35 validated path and full mapped-IWD
  // identity. If metadata cannot be proven, fall back to V33 behavior unchanged.
  SoundEntryMeta meta = {};
  if (!TryGetSoundEntryMeta(
          static_cast<uint64_t>(sound_handle), old_stream, meta)) {
    g_tls_sound_fs_handle = -1;
    return false;
  }

  AcquireSRWLockExclusive(&cache.lock);
  if (!InitializeSoundPrefixCacheLocked(cache, meta)) {
    ReleaseSRWLockExclusive(&cache.lock);
    g_tls_sound_fs_handle = -1;
    return false;
  }

  if (position64 > cache.uncompressed_size) {
    ReleaseSRWLockExclusive(&cache.lock);
    g_tls_sound_fs_handle = -1;
    return false;
  }
  const uint32_t position = static_cast<uint32_t>(position64);
  const uint32_t target = static_cast<uint32_t>(std::min<uint64_t>(
      cache.uncompressed_size,
      position64 + static_cast<uint64_t>(request)));

  if (!EnsureSoundPrefixDecodedLocked(cache, target)) {
    ReleaseSRWLockExclusive(&cache.lock);
    g_tls_sound_fs_handle = -1;
    return false;
  }

  const uint32_t available = cache.decoded_bytes - position;
  const uint32_t actual = std::min(request, available);
  if (actual != 0u && old_stream->next_out != nullptr) {
    std::memcpy(old_stream->next_out, cache.decoded + position, actual);
    old_stream->next_out += actual;
  }
  old_stream->avail_out -= actual;
  old_stream->total_out += actual;

  result_out = old_stream->total_out >= cache.uncompressed_size
      ? MW3_Z_STREAM_END
      : MW3_Z_OK;
  ReleaseSRWLockExclusive(&cache.lock);

  if (is_real_output_read) {
    g_tls_sound_fs_handle = -1;
  }
  return true;
}

bool TryFastSeekFullyCachedSound(
    uint64_t handle_index,
    int64_t offset,
    int origin) {
  // IW5's exact streamed-sound caller uses origin 2 for absolute SEEK_SET.
  // Only bypass the stock seek when the complete following 128 KiB read is
  // already decoded. First-time/uncached seeks remain on the validated V35 path.
  if (origin != 2
      || offset < 0
      || static_cast<uint64_t>(offset) > 0xFFFFFFFFull
      || handle_index >= MW3_FS_HANDLE_COUNT) {
    return false;
  }

  Mw3OldZStream80* old_stream = CurrentZStreamForFsHandle(handle_index);
  if (old_stream == nullptr) return false;

  auto& cache = g_sound_prefix_caches[static_cast<size_t>(handle_index)];
  AcquireSRWLockShared(&cache.lock);
  uint32_t uncompressed_size = 0u;
  if (!SoundCacheMatchesCurrentStream(
          handle_index, old_stream, cache, &uncompressed_size)) {
    ReleaseSRWLockShared(&cache.lock);
    return false;
  }

  const uint32_t target = static_cast<uint32_t>(offset);
  if (target > uncompressed_size) {
    ReleaseSRWLockShared(&cache.lock);
    return false;
  }
  constexpr uint32_t kSoundReadBytes = 0x20000u;
  const uint32_t needed = static_cast<uint32_t>(std::min<uint64_t>(
      uncompressed_size,
      static_cast<uint64_t>(target) + kSoundReadBytes));
  if (cache.decoded_bytes < needed) {
    ReleaseSRWLockShared(&cache.lock);
    return false;
  }

  auto* current = reinterpret_cast<uint8_t*>(old_stream) - 0x08u;
  old_stream->next_out = nullptr;
  old_stream->avail_out = 0u;
  old_stream->total_out = target;
  *reinterpret_cast<uint32_t*>(current + 0x70u) = uncompressed_size - target;
  ReleaseSRWLockShared(&cache.lock);

  static std::atomic<bool> logged_first_fast_seek{false};
  if (!logged_first_fast_seek.exchange(true, std::memory_order_acq_rel)) {
    reshade::log::message(
        reshade::log::level::info,
        "[MW3 V36 Audio Cache] fully-cached streamed-sound SEEK_SET fast path active; IW5 discard/reopen seek loop is bypassed only when the following 128 KiB block is already decoded.");
  }
  return true;
}

int __fastcall HookGameFsSeek(uint64_t handle_index, int64_t offset, int origin) {
  const auto original = g_original_game_fs_seek;
  if (original == nullptr) return -1;
  const uintptr_t caller_rva = ReturnAddressToExeRva(
      reinterpret_cast<uintptr_t>(_ReturnAddress()));
  if (caller_rva == MW3_SOUND_FS_SEEK_RETURN_RVA
      && handle_index < MW3_FS_HANDLE_COUNT) {
    g_tls_sound_fs_handle = static_cast<int>(handle_index);
    if (TryFastSeekFullyCachedSound(handle_index, offset, origin)) {
      return 0;
    }
    const int result = original(handle_index, offset, origin);
    if (result != 0) g_tls_sound_fs_handle = -1;
    return result;
  }
  return original(handle_index, offset, origin);
}

bool GetGameDirectory(std::array<wchar_t, MAX_PATH>& path) {
  path.fill(L'\0');
  const DWORD n = GetModuleFileNameW(nullptr, path.data(), static_cast<DWORD>(path.size()));
  if (n == 0u || n >= path.size()) return false;
  wchar_t* slash = nullptr;
  for (wchar_t* p = path.data(); *p != L'\0'; ++p) {
    if (*p == L'\\' || *p == L'/') slash = p;
  }
  if (slash == nullptr) return false;
  slash[1] = L'\0';
  return true;
}

bool LoadZlibNgAccelerator() {
  if (g_zng_module != nullptr) return true;
  std::array<wchar_t, MAX_PATH> path = {};
  if (!GetGameDirectory(path)) return false;
  constexpr wchar_t dll_name[] = L"mw3_zlibng_v27.dll";
  const size_t base_len = wcslen(path.data());
  if (base_len + (sizeof(dll_name) / sizeof(dll_name[0])) >= path.size()) return false;
  wcscat_s(path.data(), path.size(), dll_name);

  HMODULE module = LoadLibraryW(path.data());
  if (module == nullptr) {
    g_zlibng_loaded.store(false, std::memory_order_release);
    reshade::log::message(
        reshade::log::level::warning,
        "[MW3 V27 zlib-ng] mw3_zlibng_v27.dll not found beside iw5sp.exe; IWD DEFLATE acceleration is unavailable and stock zlib 1.1.4 remains active.");
    return false;
  }

  auto version = reinterpret_cast<ZngVersionFn>(GetProcAddress(module, "zlibVersion"));
  auto init2 = reinterpret_cast<ZngInflateInit2Fn>(GetProcAddress(module, "inflateInit2_"));
  auto inflate = reinterpret_cast<ZngInflateFn>(GetProcAddress(module, "inflate"));
  auto end = reinterpret_cast<ZngInflateEndFn>(GetProcAddress(module, "inflateEnd"));
  if (version == nullptr || init2 == nullptr || inflate == nullptr || end == nullptr) {
    FreeLibrary(module);
    reshade::log::message(
        reshade::log::level::warning,
        "[MW3 V27 zlib-ng] accelerator DLL is missing required zlib-compat exports; stock zlib 1.1.4 remains active.");
    return false;
  }

  const char* version_text = version();
  if (version_text == nullptr || version_text[0] == '\0') {
    FreeLibrary(module);
    return false;
  }

  g_zng_module = module;
  g_zng_version = version;
  g_zng_inflate_init2 = init2;
  g_zng_inflate = inflate;
  g_zng_inflate_end = end;
  g_zlibng_loaded.store(true, std::memory_order_release);

  std::stringstream message;
  message << "[MW3 V27 zlib-ng] loaded modern zlib-compatible decoder: " << version_text
          << " | shadow-stream ABI=88 bytes | MW3 old stream ABI=80 bytes";
  reshade::log::message(reshade::log::level::info, message.str().c_str());
  return true;
}

ZngShadowSlot* FindShadowNoLock(Mw3OldZStream80* old_stream) {
  if (old_stream == nullptr) return nullptr;
  for (auto& slot : g_zng_shadow_slots) {
    if (slot.old_stream == old_stream) return &slot;
  }
  return nullptr;
}

ZngShadowSlot* FindEmptyShadowNoLock() {
  for (auto& slot : g_zng_shadow_slots) {
    if (slot.old_stream == nullptr) return &slot;
  }
  return nullptr;
}

void ResetShadowLocked(ZngShadowSlot& slot, bool call_end) {
  if (call_end && slot.modern_initialized && g_zng_inflate_end != nullptr) {
    (void)g_zng_inflate_end(&slot.modern);
  }
  slot.modern = {};
  slot.modern_initialized = false;
  slot.old_state_generation = nullptr;
  slot.old_stream = nullptr;
}

ZngShadowSlot* LockExistingShadow(Mw3OldZStream80* old_stream) {
  // V31 keeps V27's TLS-first hot path. The only added hot-path work is one
  // pointer comparison against MW3 zlib's private state for this generation.
  if (g_tls_zng_old_stream == old_stream && g_tls_zng_slot != nullptr) {
    ZngShadowSlot* slot = g_tls_zng_slot;
    AcquireSRWLockExclusive(&slot->lock);
    if (slot->old_stream == old_stream
        && slot->modern_initialized
        && slot->old_state_generation == old_stream->state) {
      return slot;
    }
    ReleaseSRWLockExclusive(&slot->lock);
    g_tls_zng_old_stream = nullptr;
    g_tls_zng_slot = nullptr;
  }

  AcquireSRWLockShared(&g_zng_table_lock);
  ZngShadowSlot* slot = FindShadowNoLock(old_stream);
  if (slot != nullptr) AcquireSRWLockExclusive(&slot->lock);
  ReleaseSRWLockShared(&g_zng_table_lock);
  if (slot != nullptr
      && slot->old_stream == old_stream
      && slot->modern_initialized
      && slot->old_state_generation == old_stream->state) {
    g_tls_zng_old_stream = old_stream;
    g_tls_zng_slot = slot;
    return slot;
  }
  if (slot != nullptr) ReleaseSRWLockExclusive(&slot->lock);
  return nullptr;
}

ZngShadowSlot* LockOrCreateShadow(Mw3OldZStream80* old_stream) {
  if (old_stream == nullptr
      || g_zng_inflate_init2 == nullptr
      || g_zng_version == nullptr) {
    return nullptr;
  }

  if (ZngShadowSlot* existing = LockExistingShadow(old_stream)) return existing;

  // Never switch decoder implementations in the middle of an already-started
  // DEFLATE stream. A setting change takes effect on the next IWD entry.
  if (old_stream->total_in != 0u || old_stream->total_out != 0u) return nullptr;

  AcquireSRWLockExclusive(&g_zng_table_lock);
  ZngShadowSlot* slot = FindShadowNoLock(old_stream);
  if (slot != nullptr) {
    AcquireSRWLockExclusive(&slot->lock);
    // Same public z_stream address but a different MW3 private state means the
    // address was recycled for a new DEFLATE generation without our shadow
    // seeing the previous lifetime end. Retire only the stale modern state.
    if (slot->old_stream == old_stream
        && slot->old_state_generation != old_stream->state) {
      ResetShadowLocked(*slot, true);
      g_zlibng_generation_resets.fetch_add(1u, std::memory_order_relaxed);
    } else if (slot->old_stream == old_stream && !slot->modern_initialized) {
      ResetShadowLocked(*slot, false);
    }
  } else {
    slot = FindEmptyShadowNoLock();
    if (slot != nullptr) AcquireSRWLockExclusive(&slot->lock);
  }
  if (slot == nullptr) {
    ReleaseSRWLockExclusive(&g_zng_table_lock);
    g_zlibng_stream_init_failures.fetch_add(1u, std::memory_order_relaxed);
    return nullptr;
  }
  if (slot->old_stream == nullptr) {
    slot->old_stream = old_stream;
    slot->old_state_generation = old_stream->state;
    slot->modern = {};
    slot->modern.zalloc = nullptr;
    slot->modern.zfree = nullptr;
    slot->modern.opaque = nullptr;
    const char* version_text = g_zng_version();
    const int init_result = g_zng_inflate_init2(
        &slot->modern,
        MW3_Z_RAW_DEFLATE_WINDOW_BITS,
        version_text,
        static_cast<int>(sizeof(Mw3ModernZStream88)));
    if (init_result == MW3_Z_OK) {
      slot->modern_initialized = true;
      g_zlibng_streams_accelerated.fetch_add(1u, std::memory_order_relaxed);
      static std::atomic<bool> logged_first{false};
      if (!logged_first.exchange(true, std::memory_order_acq_rel)) {
        reshade::log::message(
            reshade::log::level::info,
            "[MW3 V27 zlib-ng] first compressed IWD entry is using the modern shadow inflater; old zlib 1.1.4 state remains separate for stock cleanup.");
      }
    } else {
      ResetShadowLocked(*slot, false);
      g_zlibng_stream_init_failures.fetch_add(1u, std::memory_order_relaxed);
      ReleaseSRWLockExclusive(&slot->lock);
      ReleaseSRWLockExclusive(&g_zng_table_lock);
      return nullptr;
    }
  }
  g_tls_zng_old_stream = old_stream;
  g_tls_zng_slot = slot;
  ReleaseSRWLockExclusive(&g_zng_table_lock);
  return slot;
}

void MirrorOldToModernForInflate(
    const Mw3OldZStream80& old_stream,
    Mw3ModernZStream88& modern) {
  modern.next_in = old_stream.next_in;
  modern.avail_in = old_stream.avail_in;
  modern.next_out = old_stream.next_out;
  modern.avail_out = old_stream.avail_out;
}

void MirrorModernBackToOld(
    const Mw3ModernZStream88& modern,
    Mw3OldZStream80& old_stream) {
  old_stream.next_in = modern.next_in;
  old_stream.avail_in = modern.avail_in;
  old_stream.total_in = modern.total_in;
  old_stream.next_out = modern.next_out;
  old_stream.avail_out = modern.avail_out;
  old_stream.total_out = modern.total_out;
  old_stream.msg = modern.msg;
  old_stream.data_type = modern.data_type;
  old_stream.adler = modern.adler;
}

// IW5's compressed FS_Seek implementation deliberately asks unzReadCurrentFile
// to advance a DEFLATE stream with next_out == nullptr. Modern zlib-compatible
// inflate rejects that. V33 keeps V32's correctness fix, but makes the discard
// path much leaner:
//   * a 256 KiB per-thread sink (4x V32)
//   * multiple sink windows are consumed inside ONE hooked inflate call while
//     the current 16 KiB compressed refill still has input
//   * no per-window atomic telemetry
// This preserves the exact public z_stream state expected by IW5 while avoiding
// repeated hook/SRW/minizip round-trips for highly-compressible seek data.
alignas(64) thread_local std::array<unsigned char, 256u * 1024u>
    g_zng_discard_scratch = {};

int InflateDiscardOutput(
    Mw3OldZStream80& old_stream,
    Mw3ModernZStream88& modern,
    int flush) {
  if (g_zng_inflate == nullptr || old_stream.avail_out == 0u) return MW3_Z_OK;

  const unsigned int requested_out = old_stream.avail_out;
  unsigned int remaining_out = requested_out;
  int final_result = MW3_Z_OK;

  modern.next_in = old_stream.next_in;
  modern.avail_in = old_stream.avail_in;

  static std::atomic<bool> logged_first_discard_seek{false};
  if (!logged_first_discard_seek.exchange(true, std::memory_order_acq_rel)) {
    reshade::log::message(
        reshade::log::level::info,
        "[MW3 V33 zlib-ng] batched compressed FS_Seek discard path active; 256 KiB sink + in-hook batching.");
  }

  constexpr int MW3_Z_BUF_ERROR = -5;

  while (remaining_out != 0u) {
    const unsigned int sink_capacity = static_cast<unsigned int>(
        std::min<size_t>(g_zng_discard_scratch.size(), remaining_out));

    modern.next_out = g_zng_discard_scratch.data();
    modern.avail_out = sink_capacity;

    const unsigned int input_before = modern.avail_in;
    const unsigned int output_before = modern.avail_out;
    const unsigned long total_out_before = modern.total_out;

    int result = g_zng_inflate(&modern, flush);

    const unsigned long produced_long = modern.total_out - total_out_before;
    const unsigned int produced = static_cast<unsigned int>(
        std::min<unsigned long>(produced_long, remaining_out));
    const bool made_progress =
        modern.avail_in != input_before || modern.avail_out != output_before;

    remaining_out -= produced;

    if (result == MW3_Z_BUF_ERROR && made_progress) {
      // IW5's 2011 minizip treats every non-zero result except Z_STREAM_END as
      // fatal. Preserve the legacy behavior only when progress actually occurred.
      result = MW3_Z_OK;
    }

    final_result = result;

    if (result != MW3_Z_OK) break;
    if (!made_progress) break;
    if (remaining_out == 0u) break;

    // minizip must refill its 16 KiB compressed input buffer before more work.
    if (modern.avail_in == 0u) break;
  }

  old_stream.next_in = modern.next_in;
  old_stream.avail_in = modern.avail_in;
  old_stream.total_in = modern.total_in;
  old_stream.next_out = nullptr;
  old_stream.avail_out = remaining_out;
  old_stream.total_out = modern.total_out;
  old_stream.msg = modern.msg;
  old_stream.data_type = modern.data_type;
  old_stream.adler = modern.adler;

  return final_result;
}

int __fastcall HookGameInflate(Mw3OldZStream80* old_stream, int flush) {
  const auto original = g_original_game_inflate;
  if (original == nullptr) return -2;
  if (old_stream == nullptr) return original(old_stream, flush);

  // Existing ownership wins over a runtime setting change. This avoids ever
  // switching decoder implementations in the middle of one compressed entry.
  ZngShadowSlot* slot = LockExistingShadow(old_stream);
  if (slot == nullptr) {
    if (!GetZlibNgIwdInflateEnabled()
        || !g_zlibng_loaded.load(std::memory_order_acquire)) {
      return original(old_stream, flush);
    }
    const uintptr_t caller_rva = ReturnAddressToExeRva(
        reinterpret_cast<uintptr_t>(_ReturnAddress()));
    if (caller_rva != MW3_MINIZIP_INFLATE_RETURN_RVA) {
      return original(old_stream, flush);
    }
    slot = LockOrCreateShadow(old_stream);
    if (slot == nullptr) return original(old_stream, flush);
  }

  if (!slot->modern_initialized || g_zng_inflate == nullptr) {
    ReleaseSRWLockExclusive(&slot->lock);
    return original(old_stream, flush);
  }

  int result = MW3_Z_OK;

  // V36: only the exact streamed-sound FS_Seek/FS_Read thread can enter this
  // path. If the direct mapped-IWD prefix cache can satisfy the request, do not
  // advance the per-entry shadow inflater at all. This makes close/reopen/backward
  // sound seeks cheap while leaving every non-audio inflate on the V31/V33 path.
  if (TryServeSoundPrefixCache(old_stream, result)) {
    ReleaseSRWLockExclusive(&slot->lock);
    return result;
  }

  if (old_stream->next_out == nullptr && old_stream->avail_out != 0u) {
    result = InflateDiscardOutput(*old_stream, slot->modern, flush);
  } else {
    MirrorOldToModernForInflate(*old_stream, slot->modern);
    const unsigned int input_before = slot->modern.avail_in;
    const unsigned int output_before = slot->modern.avail_out;
    result = g_zng_inflate(&slot->modern, flush);
    const bool made_progress =
        slot->modern.avail_in != input_before
        || slot->modern.avail_out != output_before;
    constexpr int MW3_Z_BUF_ERROR = -5;
    if (result == MW3_Z_BUF_ERROR && made_progress) {
      result = MW3_Z_OK;
    }
    MirrorModernBackToOld(slot->modern, *old_stream);
  }
  ReleaseSRWLockExclusive(&slot->lock);
  return result;
}

int __fastcall HookGameInflateEnd(Mw3OldZStream80* old_stream) {
  const auto original = g_original_game_inflate_end;
  if (g_tls_zng_old_stream == old_stream) {
    g_tls_zng_old_stream = nullptr;
    g_tls_zng_slot = nullptr;
  }
  if (old_stream != nullptr) {
    AcquireSRWLockExclusive(&g_zng_table_lock);
    ZngShadowSlot* slot = FindShadowNoLock(old_stream);
    if (slot != nullptr) {
      AcquireSRWLockExclusive(&slot->lock);
      ResetShadowLocked(*slot, true);
      ReleaseSRWLockExclusive(&slot->lock);
    }
    ReleaseSRWLockExclusive(&g_zng_table_lock);
  }
  // Always let MW3's original zlib 1.1.4 release its own separate state.
  return original != nullptr ? original(old_stream) : -2;
}


bool ValidateSoundFsSeekTarget() {
  return BytesEqualAtRva(
      MW3_FS_SEEK_RVA,
      MW3_FS_SEEK_SIGNATURE.data(),
      MW3_FS_SEEK_SIGNATURE.size());
}

bool InstallSoundFsSeekDetour() {
  if (g_sound_fs_seek_detoured.load(std::memory_order_acquire)) return true;
  if (g_exe_base == 0u || !ValidateSoundFsSeekTarget()) return false;

  g_original_game_fs_seek = reinterpret_cast<GameFsSeekFn>(
      g_exe_base + MW3_FS_SEEK_RVA);
  LONG status = hook_transaction::Begin();
  if (status != NO_ERROR) {
    g_original_game_fs_seek = nullptr;
    return false;
  }
  if (status == NO_ERROR) {
    status = hook_transaction::Attach(
        reinterpret_cast<PVOID*>(&g_original_game_fs_seek),
        reinterpret_cast<PVOID>(&HookGameFsSeek));
  }
  if (status == NO_ERROR) status = hook_transaction::Commit();
  else hook_transaction::Abort();

  const bool ok = status == NO_ERROR;
  g_sound_fs_seek_detoured.store(ok, std::memory_order_release);
  if (ok) {
    reshade::log::message(
        reshade::log::level::info,
        "[MW3 V36 Audio Cache] exact streamed-sound FS_Seek marker installed at iw5sp+0x2B6460.");
  }
  if (!ok) {
    g_original_game_fs_seek = nullptr;
    reshade::log::message(
        reshade::log::level::warning,
        "[MW3 V36 Audio Cache] sound FS_Seek detour unavailable; retaining V33 seek behavior.");
  }
  return ok;
}

void RemoveSoundFsSeekDetour() {
  if (g_sound_fs_seek_detoured.load(std::memory_order_acquire)
      && g_original_game_fs_seek != nullptr) {
    LONG status = hook_transaction::Begin();
    if (status == NO_ERROR) {
      status = DetourDetach(
          reinterpret_cast<PVOID*>(&g_original_game_fs_seek),
          reinterpret_cast<PVOID>(&HookGameFsSeek));
    }
    if (status == NO_ERROR) status = hook_transaction::Commit();
    else hook_transaction::Abort();
    if (status != NO_ERROR) return;
  }
  g_sound_fs_seek_detoured.store(false, std::memory_order_release);
  // Preserve the call-through pointer for callbacks already in flight.
  g_tls_sound_fs_handle = -1;
}

bool ValidateZlibNgTargets() {
  return BytesEqualAtRva(
             MW3_MINIZIP_INFLATE_CALL_SIGNATURE_RVA,
             MW3_MINIZIP_INFLATE_CALL_SIGNATURE.data(),
             MW3_MINIZIP_INFLATE_CALL_SIGNATURE.size())
      && BytesEqualAtRva(
             MW3_ZLIB_INFLATE_RVA,
             MW3_ZLIB_INFLATE_SIGNATURE.data(),
             MW3_ZLIB_INFLATE_SIGNATURE.size())
      && BytesEqualAtRva(
             MW3_ZLIB_INFLATE_END_RVA,
             MW3_ZLIB_INFLATE_END_SIGNATURE.data(),
             MW3_ZLIB_INFLATE_END_SIGNATURE.size());
}

bool InstallZlibNgInflateDetours() {
  if (g_zng_detours_installed.load(std::memory_order_acquire)) return true;
  if (!GetZlibNgIwdInflateEnabled()
      || !LoadZlibNgAccelerator()
      || !ValidateZlibNgTargets()) {
    return false;
  }

  g_original_game_inflate = reinterpret_cast<GameInflateFn>(
      g_exe_base + MW3_ZLIB_INFLATE_RVA);
  g_original_game_inflate_end = reinterpret_cast<GameInflateEndFn>(
      g_exe_base + MW3_ZLIB_INFLATE_END_RVA);

  LONG status = hook_transaction::Begin();
  if (status != NO_ERROR) return false;
  if (status == NO_ERROR) {
    status = hook_transaction::Attach(
        reinterpret_cast<PVOID*>(&g_original_game_inflate),
        reinterpret_cast<PVOID>(&HookGameInflate));
  }
  if (status == NO_ERROR) {
    status = hook_transaction::Attach(
        reinterpret_cast<PVOID*>(&g_original_game_inflate_end),
        reinterpret_cast<PVOID>(&HookGameInflateEnd));
  }
  if (status == NO_ERROR) status = hook_transaction::Commit();
  else hook_transaction::Abort();

  const bool ok = status == NO_ERROR;
  g_zng_detours_installed.store(ok, std::memory_order_release);
  if (ok) {
    // Optional and narrow: failure keeps the proven V33 path rather than
    // disabling zlib-ng acceleration globally.
    (void)InstallSoundFsSeekDetour();
  }
  if (!ok) {
    g_original_game_inflate = nullptr;
    g_original_game_inflate_end = nullptr;
    reshade::log::message(
        reshade::log::level::warning,
        "[MW3 V27 zlib-ng] inflate detour install failed; stock zlib 1.1.4 remains active.");
  }
  return ok;
}

void RemoveZlibNgInflateDetoursAndCleanup() {
  RemoveSoundFsSeekDetour();
  if (g_sound_fs_seek_detoured.load(std::memory_order_acquire)) return;
  if (g_zng_detours_installed.load(std::memory_order_acquire)
      && g_original_game_inflate != nullptr
      && g_original_game_inflate_end != nullptr) {
    LONG status = hook_transaction::Begin();
    if (status == NO_ERROR) {
      status = DetourDetach(
          reinterpret_cast<PVOID*>(&g_original_game_inflate),
          reinterpret_cast<PVOID>(&HookGameInflate));
    }
    if (status == NO_ERROR) {
      status = DetourDetach(
          reinterpret_cast<PVOID*>(&g_original_game_inflate_end),
          reinterpret_cast<PVOID>(&HookGameInflateEnd));
    }
    if (status == NO_ERROR) status = hook_transaction::Commit();
    else hook_transaction::Abort();
    if (status != NO_ERROR) return;
  }
  g_zng_detours_installed.store(false, std::memory_order_release);
  // Preserve call-through pointers for callbacks already in flight.

  AcquireSRWLockExclusive(&g_zng_table_lock);
  for (auto& slot : g_zng_shadow_slots) {
    AcquireSRWLockExclusive(&slot.lock);
    ResetShadowLocked(slot, true);
    ReleaseSRWLockExclusive(&slot.lock);
  }
  ReleaseSRWLockExclusive(&g_zng_table_lock);

  for (auto& cache : g_sound_prefix_caches) {
    AcquireSRWLockExclusive(&cache.lock);
    ResetSoundPrefixCacheLocked(cache);
    ReleaseSRWLockExclusive(&cache.lock);
  }

  if (g_zng_module != nullptr) {
    FreeLibrary(g_zng_module);
    g_zng_module = nullptr;
  }
  g_zng_version = nullptr;
  g_zng_inflate_init2 = nullptr;
  g_zng_inflate = nullptr;
  g_zng_inflate_end = nullptr;
  g_tls_zng_old_stream = nullptr;
  g_tls_zng_slot = nullptr;
  g_zlibng_loaded.store(false, std::memory_order_release);
}

using GameCrtReadFn = int(__fastcall*)(int, void*, unsigned int);
GameCrtReadFn g_original_game_crt_read = nullptr;
std::atomic<bool> g_game_crt_read_detoured{false};

bool GameCrtFdToBinaryDiskHandle(int fd, HANDLE& handle_out) {
  handle_out = INVALID_HANDLE_VALUE;
  if (g_exe_base == 0u || fd < 0) return false;

  const int limit = *reinterpret_cast<const int*>(
      g_exe_base + MW3_CRT_FD_LIMIT_RVA);
  if (fd >= limit) return false;

  auto* blocks = reinterpret_cast<uintptr_t*>(
      g_exe_base + MW3_CRT_FD_TABLE_RVA);
  const uintptr_t block = blocks[static_cast<unsigned>(fd) >> 6u];
  if (block == 0u) return false;

  const size_t index = static_cast<unsigned>(fd) & 0x3Fu;
  auto* record = reinterpret_cast<const uint8_t*>(
      block + index * MW3_CRT_FD_RECORD_SIZE);
  const uint8_t flags = record[MW3_CRT_FD_FLAGS_OFFSET];
  const uint8_t text_mode = record[MW3_CRT_FD_TEXTMODE_OFFSET];

  // bit 0 = open; bit 1 = EOF; 0x08/0x40 select pipe/device handling.
  // Byte +0x39 is the CRT text-mode selector used by the stock _read path.
  // Only bypass the plain binary disk path; every translated/special case
  // remains 100% stock.
  if ((flags & 0x01u) == 0u
      || (flags & 0x4Au) != 0u
      || text_mode != 0u) {
    return false;
  }

  const uintptr_t handle_value = *reinterpret_cast<const uintptr_t*>(
      record + MW3_CRT_FD_HANDLE_OFFSET);
  if (handle_value == 0u
      || handle_value == reinterpret_cast<uintptr_t>(INVALID_HANDLE_VALUE)) {
    return false;
  }

  handle_out = reinterpret_cast<HANDLE>(handle_value);
  return true;
}

thread_local int g_tls_crt_fast_fd = -1;
thread_local HANDLE g_tls_crt_fast_handle = INVALID_HANDLE_VALUE;
thread_local IwdHandleSlot* g_tls_crt_fast_slot = nullptr;
thread_local uint64_t g_tls_archive_burst_bytes = 0u;
thread_local uint64_t g_tls_archive_burst_calls = 0u;
thread_local int64_t g_tls_archive_last_mark_qpc = 0;
thread_local bool g_tls_archive_priority_boosted = false;
thread_local int g_tls_archive_original_priority = THREAD_PRIORITY_NORMAL;

void RestoreArchiveThreadPriorityIfCurrent() {
  if (!g_tls_archive_priority_boosted) return;
  (void)::SetThreadPriority(GetCurrentThread(), g_tls_archive_original_priority);
  g_tls_archive_priority_boosted = false;
}

void ResetArchiveBurstTlsOnWorkerIdle() {
  RestoreArchiveThreadPriorityIfCurrent();
  g_tls_archive_burst_bytes = 0u;
  g_tls_archive_burst_calls = 0u;
  g_tls_archive_last_mark_qpc = 0;
}

void MarkArchiveBurstLean(unsigned int bytes) {
  if (bytes == 0u) return;
  g_tls_archive_burst_bytes += bytes;
  ++g_tls_archive_burst_calls;

  // Do not query the clock on every 4 KiB / 12 KiB read. Only sample once the
  // same worker has accumulated enough work to qualify as a real burst.
  if (g_tls_archive_burst_bytes < MW3_ARCHIVE_BURST_MIN_BYTES
      && g_tls_archive_burst_calls < MW3_ARCHIVE_BURST_MIN_CALLS) {
    return;
  }

  const int64_t now = QpcNowRaw();
  if (g_tls_archive_last_mark_qpc > 0
      && QpcElapsedMs(g_tls_archive_last_mark_qpc, now)
          > MW3_ARCHIVE_PRIORITY_IDLE_GAP_MS) {
    RestoreArchiveThreadPriorityIfCurrent();
  }

  g_tls_archive_last_mark_qpc = now;
  g_tls_archive_burst_bytes = 0u;
  g_tls_archive_burst_calls = 0u;
  g_archive_burst_until_qpc.store(
      now + QpcTicksFromMs(MW3_ARCHIVE_BURST_WINDOW_MS),
      std::memory_order_relaxed);

  if (GetArchiveThreadPriorityBoostEnabled()
      && !g_tls_archive_priority_boosted) {
    const int current = ::GetThreadPriority(GetCurrentThread());
    if (current != THREAD_PRIORITY_ERROR_RETURN
        && current < THREAD_PRIORITY_ABOVE_NORMAL
        && ::SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_ABOVE_NORMAL) != FALSE) {
      g_tls_archive_original_priority = current;
      g_tls_archive_priority_boosted = true;
    }
  }
}

void InvalidateFastCrtTlsForHandle(HANDLE handle) {
  if (handle == nullptr || handle == INVALID_HANDLE_VALUE) return;
  if (g_tls_crt_fast_handle == handle) {
    g_tls_crt_fast_fd = -1;
    g_tls_crt_fast_handle = INVALID_HANDLE_VALUE;
    g_tls_crt_fast_slot = nullptr;
  }
}

IwdHandleSlot* LockFastCrtSlotFromTls(int fd) {
  if (g_tls_crt_fast_fd != fd
      || g_tls_crt_fast_handle == INVALID_HANDLE_VALUE
      || g_tls_crt_fast_slot == nullptr) {
    return nullptr;
  }

  auto* slot = g_tls_crt_fast_slot;
  AcquireSRWLockExclusive(&slot->lock);
  if (slot->handle == reinterpret_cast<uintptr_t>(g_tls_crt_fast_handle)
      && slot->view != nullptr
      && slot->position_valid) {
    return slot;
  }

  ReleaseSRWLockExclusive(&slot->lock);
  g_tls_crt_fast_fd = -1;
  g_tls_crt_fast_handle = INVALID_HANDLE_VALUE;
  g_tls_crt_fast_slot = nullptr;
  return nullptr;
}

int __fastcall HookGameCrtRead(int fd, void* buffer, unsigned int count) {
  const auto original = g_original_game_crt_read;
  if (original == nullptr) return -1;

  if (!GetCrtIwdFastReadEnabled()
      || GetIwdCacheMode() == 0
      || buffer == nullptr
      || count == 0u
      || count > 0x7FFFFFFFu) {
    return original(fd, buffer, count);
  }

  // Hot case first: the archive worker repeatedly reads the same binary IWD fd.
  // This avoids re-walking MW3's CRT descriptor table on thousands of tiny reads.
  IwdHandleSlot* slot = LockFastCrtSlotFromTls(fd);
  HANDLE file = g_tls_crt_fast_handle;

  if (slot == nullptr) {
    if (!GameCrtFdToBinaryDiskHandle(fd, file)) {
      return original(fd, buffer, count);
    }

    std::array<char, 160> path = {};
    CopyFilePathForHandle(reinterpret_cast<uintptr_t>(file), path);
    if (path[0] == '\0') {
      (void)ResolveFilePathFromLiveHandle(
          reinterpret_cast<uintptr_t>(file), path);
    }
    if (!IsIwdPath(path)) return original(fd, buffer, count);

    slot = LockOrCreateHandle(file);
    if (slot != nullptr) {
      g_tls_crt_fast_fd = fd;
      g_tls_crt_fast_handle = file;
      g_tls_crt_fast_slot = slot;
    }
  }

  if (slot == nullptr || !slot->position_valid || slot->virtual_position > slot->size) {
    if (slot != nullptr) UnlockHandle(slot);
    return original(fd, buffer, count);
  }

  const uint64_t available = slot->size - slot->virtual_position;
  const unsigned int actual = static_cast<unsigned int>(
      std::min<uint64_t>(available, static_cast<uint64_t>(count)));
  if (actual != 0u) {
    std::memcpy(
        buffer,
        slot->view + slot->virtual_position,
        static_cast<size_t>(actual));
  }
  slot->virtual_position += actual;
  UnlockHandle(slot);

  MarkArchiveBurstLean(actual);
  return static_cast<int>(actual);
}

bool InstallGameCrtReadDetour() {
  if (g_game_crt_read_detoured.load(std::memory_order_acquire)) return true;
  if (g_exe_base == 0u) return false;

  g_original_game_crt_read = reinterpret_cast<GameCrtReadFn>(
      g_exe_base + MW3_CRT_READ_RVA);

  LONG status = hook_transaction::Begin();
  if (status != NO_ERROR) return false;
  if (status == NO_ERROR) {
    status = hook_transaction::Attach(
        reinterpret_cast<PVOID*>(&g_original_game_crt_read),
        reinterpret_cast<PVOID>(&HookGameCrtRead));
  }
  if (status == NO_ERROR) status = hook_transaction::Commit();
  else hook_transaction::Abort();

  const bool ok = status == NO_ERROR;
  g_game_crt_read_detoured.store(ok, std::memory_order_release);
  if (!ok) g_original_game_crt_read = nullptr;
  return ok;
}

void RemoveGameCrtReadDetour() {
  if (!g_game_crt_read_detoured.load(std::memory_order_acquire)
      || g_original_game_crt_read == nullptr) {
    return;
  }

  LONG status = hook_transaction::Begin();
  if (status == NO_ERROR) {
    status = DetourDetach(
        reinterpret_cast<PVOID*>(&g_original_game_crt_read),
        reinterpret_cast<PVOID>(&HookGameCrtRead));
  }
  if (status == NO_ERROR) status = hook_transaction::Commit();
  else hook_transaction::Abort();

  if (status != NO_ERROR) return;
  g_game_crt_read_detoured.store(false, std::memory_order_release);
  // Preserve the call-through pointer for callbacks already in flight.
}

// -----------------------------------------------------------------------------
// Lean runtime install / shutdown
// -----------------------------------------------------------------------------

bool InstallLeanRuntimeHooks() {
  if (g_runtime_installed.load(std::memory_order_acquire)) return true;

  size_t patched_types = 0u;
  auto patch = [&](const char* name, void* replacement, void** original) {
    const bool ok = PatchIatSymbol(name, replacement, original);
    if (ok) ++patched_types;
    return ok;
  };

  const bool sleep_ok =
      patch("Sleep", reinterpret_cast<void*>(&HookSleep), &g_orig_sleep);
  const bool wait_ok =
      patch(
          "WaitForSingleObject",
          reinterpret_cast<void*>(&HookWaitForSingleObject),
          &g_orig_wait_single);

  // Pointer/close semantics first. ReadFile is patched only after the critical
  // virtual-position helpers are confirmed, so a partial installation cannot
  // serve stale archive bytes.
  const bool close_ok =
      patch(
          "CloseHandle",
          reinterpret_cast<void*>(&HookCloseHandle),
          &g_orig_close_handle);
  const bool pointer_ex_ok =
      patch(
          "SetFilePointerEx",
          reinterpret_cast<void*>(&HookSetFilePointerEx),
          &g_orig_set_file_pointer_ex);

  // Optional on this build, but hook them when imported.
  (void)patch(
      "SetFilePointer",
      reinterpret_cast<void*>(&HookSetFilePointer),
      &g_orig_set_file_pointer);
  (void)patch(
      "CreateFileA",
      reinterpret_cast<void*>(&HookCreateFileA),
      &g_orig_create_file_a);
  (void)patch(
      "CreateFileW",
      reinterpret_cast<void*>(&HookCreateFileW),
      &g_orig_create_file_w);

  bool read_ok = false;
  if (close_ok && pointer_ex_ok) {
    read_ok =
        patch(
            "ReadFile",
            reinterpret_cast<void*>(&HookReadFile),
            &g_orig_read_file);
  }

  const bool crt_read_ok = InstallGameCrtReadDetour();
  const bool zlibng_ok = InstallZlibNgInflateDetours();

  const bool useful = sleep_ok || wait_ok || read_ok || crt_read_ok || zlibng_ok;
  g_runtime_installed.store(useful, std::memory_order_release);

  std::stringstream message;
  message << "[MW3 V34 Runtime] hooks: "
          << patched_types << " IAT type(s)"
          << " | Sleep=" << (sleep_ok ? "yes" : "no")
          << " | Wait1 precise=" << (wait_ok ? "yes" : "no")
          << " | ReadFile cache=" << (read_ok ? "yes" : "no")
          << " | CRT _read fast=" << (crt_read_ok ? "yes" : "no")
          << " | modern IWD inflate=" << (zlibng_ok ? "zlib-ng" : "stock-1.1.4")
          << " | persistent mappings=yes"
          << " | Tracy=OFF | flight recorder=OFF";
  reshade::log::message(
      useful ? reshade::log::level::info : reshade::log::level::warning,
      message.str().c_str());

  if (useful) {
    reshade::log::message(
        reshade::log::level::info,
        "[MW3 V27 Sync] 0x18B895/0x24AA36 use warm-up calibrated high-resolution timing; repeated 0x24AA36 timeout storms progressively coalesce to 2/4 ms while the real event can still wake immediately.");
    reshade::log::message(
        reshade::log::level::info,
        "[MW3 V27 Archive] exact static CRT _read uses TLS-first persistent mapped IWD serving with sparse burst detection and temporary archive-worker ABOVE_NORMAL priority; special/non-IWD cases stay stock.");
    reshade::log::message(
        reshade::log::level::info,
        zlibng_ok
            ? "[MW3 V34 Inflate] compressed IWD entries from minizip iw5sp+0x3157C0 use a modern zlib-ng shadow stream at the exact iw5sp+0x312790 inflate call; non-minizip zlib calls remain stock."
            : "[MW3 V34 Inflate] modern decoder unavailable; compressed IWD entries remain on bundled zlib 1.1.4 until mw3_zlibng_v27.dll is installed beside iw5sp.exe.");
  }

  return useful;
}

void OnPresent(
    reshade::api::command_queue* queue,
    reshade::api::swapchain* swapchain,
    const reshade::api::rect* source_rect,
    const reshade::api::rect* dest_rect,
    uint32_t dirty_rect_count,
    const reshade::api::rect* dirty_rects) {
  (void)swapchain;
  (void)source_rect;
  (void)dest_rect;
  (void)dirty_rect_count;
  (void)dirty_rects;

  if (queue == nullptr
      || g_runtime_installed.load(std::memory_order_acquire)) {
    return;
  }

  auto* device = queue->get_device();
  if (device == nullptr
      || device->get_api() != reshade::api::device_api::d3d9) {
    return;
  }

  bool expected = false;
  if (!g_runtime_attempted.compare_exchange_strong(
          expected, true, std::memory_order_acq_rel)) {
    return;
  }

  if (!InitializeExeIdentity()) {
    reshade::log::message(
        reshade::log::level::warning,
        "[MW3 V34 Runtime] exact September-2026 x64 EXE verification failed; leaving V34 V27-exact fixes disabled.");
    return;
  }

  (void)InstallLeanRuntimeHooks();
}

void Shutdown(bool process_terminating) {
  if (process_terminating) return; // Other threads may have died holding these locks.
  RestoreArchiveThreadPriorityIfCurrent();
  if (!process_terminating) {
    RemoveZlibNgInflateDetoursAndCleanup();
    RemoveGameCrtReadDetour();
    if (g_zng_detours_installed.load(std::memory_order_acquire) ||
        g_sound_fs_seek_detoured.load(std::memory_order_acquire) ||
        g_game_crt_read_detoured.load(std::memory_order_acquire)) return;
    RestoreIatHooks();
    CleanupMappings();
    if (g_tls_high_res_timer != nullptr) {
      ::CloseHandle(g_tls_high_res_timer);
      g_tls_high_res_timer = nullptr;
    }
    g_tls_high_res_timer_attempted = false;
  }

  AcquireSRWLockExclusive(&g_file_path_lock);
  g_file_paths = {};
  ReleaseSRWLockExclusive(&g_file_path_lock);

  g_tls_handle_slot = nullptr;
  g_tls_handle = 0u;
  g_tls_crt_fast_fd = -1;
  g_tls_crt_fast_handle = INVALID_HANDLE_VALUE;
  g_tls_crt_fast_slot = nullptr;
  g_tls_archive_burst_bytes = 0u;
  g_tls_archive_burst_calls = 0u;
  g_tls_archive_last_mark_qpc = 0;
  g_tls_renderer_timeout_streak = 0u;
  g_tls_wait_calibration_samples = 0u;
  g_tls_sleep_calibration_samples = 0u;
  g_archive_burst_until_qpc.store(0, std::memory_order_relaxed);

  g_runtime_installed.store(false, std::memory_order_release);
  g_runtime_attempted.store(false, std::memory_order_release);
  g_unique_archive_maps.store(0u, std::memory_order_relaxed);
  g_handle_bindings.store(0u, std::memory_order_relaxed);
  g_mapping_reuses.store(0u, std::memory_order_relaxed);
  g_backend_yields.store(0u, std::memory_order_relaxed);
  g_fallbacks.store(0u, std::memory_order_relaxed);
  g_precise_timer_failures.store(0u, std::memory_order_relaxed);
  g_zlibng_streams_accelerated.store(0u, std::memory_order_relaxed);
  g_zlibng_stream_init_failures.store(0u, std::memory_order_relaxed);
  g_zlibng_generation_resets.store(0u, std::memory_order_relaxed);
}

}  // namespace mw3_deep_profiler
