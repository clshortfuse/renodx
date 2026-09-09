#pragma once
// V7: leave the 0x24AA20 poll entry completely untouched. V36 verifies bytes
// starting at 0x24AA24 on first Present; detouring the poll invalidates that check
// and disables the entire IWD/audio runtime. Keep its full signature check here.
// Call once from D3D9 device initialization, outside DllMain and before taking
// addon locks. Viewer connection NEVER installs or removes detours.
#include <Windows.h>
#include <TlHelp32.h>
#include <detours.h>
#include <array>
#include <atomic>
#include <cstdint>
#include <cstring>
#include <cstdio>

namespace mw3_tracy_engine_hooks {
using BackendFn = void (*)(uint32_t);
using InfiniteWaitFn = DWORD (*)();
inline BackendFn g_backend = nullptr;
inline InfiniteWaitFn g_infinite_wait = nullptr;
inline std::atomic<bool> g_attempted{false};

inline void HookBackend(uint32_t flags) {
  // ECX is an input: both inspected call sites set it, and the callee stores it.
  const DWORD incoming_error = GetLastError();
  DWORD outgoing_error;
  {
    ZoneScopedN("IW5 Engine / Backend state update (flags)");
    SetLastError(incoming_error);
    g_backend(flags);
    outgoing_error = GetLastError();
  }
  SetLastError(outgoing_error);
}
inline DWORD HookInfiniteWait() {
  const DWORD incoming_error = GetLastError();
  DWORD result, outgoing_error;
  {
    ZoneScopedN("IW5 Engine / Event wait INFINITE [24A990]");
    SetLastError(incoming_error);
    result = g_infinite_wait();
    outgoing_error = GetLastError();
  }
  SetLastError(outgoing_error);
  return result;
}
inline void Log(const char* text, LONG error = NO_ERROR) {
  char message[256];
  std::snprintf(message, sizeof(message), "[MW3 Tracy V3] %s (status=%ld)", text, error);
  reshade::log::message(error == NO_ERROR ? reshade::log::level::info
                                        : reshade::log::level::warning, message);
}

// All handles are collected BEFORE the transaction. No vector reallocations,
// logging, or addon locks are introduced while other threads are suspended.
struct ThreadHandles {
  std::array<HANDLE, 2048> handles{};
  size_t count = 0;
  ~ThreadHandles() { for (size_t i = 0; i < count; ++i) CloseHandle(handles[i]); }
  LONG Collect() {
    HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
    if (snapshot == INVALID_HANDLE_VALUE) return GetLastError();
    THREADENTRY32 entry{};
    entry.dwSize = sizeof(entry);
    LONG error = NO_ERROR;
    if (!Thread32First(snapshot, &entry)) {
      error = GetLastError();
    } else {
      do {
        if (entry.th32OwnerProcessID != GetCurrentProcessId()
            || entry.th32ThreadID == GetCurrentThreadId()) continue;
        if (count == handles.size()) { error = ERROR_TOO_MANY_TCBS; break; }
        HANDLE thread = OpenThread(THREAD_SUSPEND_RESUME | THREAD_GET_CONTEXT
            | THREAD_SET_CONTEXT | THREAD_QUERY_INFORMATION, FALSE, entry.th32ThreadID);
        if (!thread) { error = GetLastError(); break; }
        handles[count++] = thread;
      } while (Thread32Next(snapshot, &entry));
      if (error == NO_ERROR && GetLastError() != ERROR_NO_MORE_FILES) error = GetLastError();
    }
    CloseHandle(snapshot);
    return error;
  }
};

inline uintptr_t VerifyImage() {
#ifndef _WIN64
  return 0;
#else
  const auto base = reinterpret_cast<uintptr_t>(GetModuleHandleW(nullptr));
  if (!base) return 0;
  const auto* dos = reinterpret_cast<const IMAGE_DOS_HEADER*>(base);
  if (dos->e_magic != IMAGE_DOS_SIGNATURE || dos->e_lfanew <= 0
      || dos->e_lfanew > 0x100000) return 0;
  const auto* nt = reinterpret_cast<const IMAGE_NT_HEADERS64*>(base + dos->e_lfanew);
  if (nt->Signature != IMAGE_NT_SIGNATURE
      || nt->FileHeader.Machine != IMAGE_FILE_MACHINE_AMD64
      || nt->FileHeader.TimeDateStamp != 0x6A743A58u
      || nt->OptionalHeader.Magic != IMAGE_NT_OPTIONAL_HDR64_MAGIC
      || nt->OptionalHeader.SizeOfImage != 0x044BE000u) return 0;
  return base;
#endif
}

template<size_t N> inline bool Matches(uintptr_t base, uintptr_t rva,
                                      const std::array<uint8_t, N>& bytes) {
  MEMORY_BASIC_INFORMATION region{};
  const auto* address = reinterpret_cast<const void*>(base + rva);
  if (!VirtualQuery(address, &region, sizeof(region)) || region.State != MEM_COMMIT
      || (region.Protect & (PAGE_GUARD | PAGE_NOACCESS))
      || !(region.Protect & (PAGE_EXECUTE_READ | PAGE_EXECUTE_READWRITE | PAGE_EXECUTE_WRITECOPY))
      || base + rva + N > reinterpret_cast<uintptr_t>(region.BaseAddress) + region.RegionSize)
    return false;
  return std::memcmp(address, bytes.data(), N) == 0;
}

inline LONG InstallTransaction(ThreadHandles& threads) {
  LONG status = DetourTransactionBegin();
  if (status != NO_ERROR) return status;
  // Prepare trampolines before enlisting/suspending threads.
  status = DetourAttach(reinterpret_cast<PVOID*>(&g_backend), reinterpret_cast<PVOID>(&HookBackend));
  if (status == NO_ERROR) status = DetourAttach(reinterpret_cast<PVOID*>(&g_infinite_wait), reinterpret_cast<PVOID>(&HookInfiniteWait));
  for (size_t i = 0; status == NO_ERROR && i < threads.count; ++i)
    status = DetourUpdateThread(threads.handles[i]);
  if (status != NO_ERROR) {
    const LONG aborted = DetourTransactionAbort();
    Log("Engine CPU hooks aborted", status);
    if (aborted != NO_ERROR) Log("Transaction abort failed", aborted);
    return status; // Handles remain valid through abort, including thread resumption.
  }
  status = DetourTransactionCommit();
  return status;
}

inline void Initialize() {
  if (g_attempted.exchange(true)) return;
  const uintptr_t base = VerifyImage();
  // Complete instructions from the actual executable; not partial opcodes.
  constexpr std::array<uint8_t, 18> backend = {
    0x48,0x83,0xEC,0x28,0x48,0x8B,0x05,0xB5,0x1A,0x6B,0x01,
    0x33,0xD2,0x38,0x50,0x10,0x74,0x15};
  constexpr std::array<uint8_t, 19> wait = {
    0x48,0x8B,0x0D,0xD9,0xAF,0xDB,0x01,0xBA,0xFF,0xFF,0xFF,0xFF,
    0x48,0xFF,0x25,0x65,0x88,0x19,0x00};
  constexpr std::array<uint8_t, 22> poll = {
    0x48,0x83,0xEC,0x28,0x48,0x8B,0x0D,0x55,0xAF,0xDB,0x01,
    0xBA,0x01,0x00,0x00,0x00,0xFF,0x15,0xD2,0x87,0x19,0x00};
  if (!base || !Matches(base, 0x1D32A0, backend)
      || !Matches(base, 0x24A990, wait) || !Matches(base, 0x24AA20, poll)) {
    Log("Engine CPU hooks skipped: executable/signature mismatch", ERROR_BAD_EXE_FORMAT);
    return;
  }
  // Warm the existing Tracy client before suspending any of its threads.
  (void)tracy::GetProfiler().IsConnected();
  ThreadHandles threads;
  LONG status = threads.Collect();
  if (status != NO_ERROR) { Log("Engine CPU hooks skipped: thread enumeration failed", status); return; }
  // Process-lifetime hooks: pin the addon BEFORE installation, avoiding unsafe
  // detach/unload races with active zones. Restart the game to replace this DLL.
  HMODULE pinned = nullptr;
  if (!GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS | GET_MODULE_HANDLE_EX_FLAG_PIN,
      reinterpret_cast<LPCWSTR>(&Initialize), &pinned)) {
    Log("Engine CPU hooks skipped: module pin failed", GetLastError()); return;
  }
  g_backend = reinterpret_cast<BackendFn>(base + 0x1D32A0);
  g_infinite_wait = reinterpret_cast<InfiniteWaitFn>(base + 0x24A990);
  status = InstallTransaction(threads);
  Log(status == NO_ERROR ? "2 non-overlapping engine CPU hooks installed during device initialization; GPU timing is managed separately"
                         : "Engine CPU hook commit failed", status);
  // Handles are closed by threads' destructor only after commit has returned.
}
} // namespace mw3_tracy_engine_hooks
