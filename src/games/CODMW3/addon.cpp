/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0
#define RENODX_MODS_SWAPCHAIN_VERSION 2


#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <Windows.h>

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>
#include <detours.h>
#include <d3d9.h>
#include <d3d11.h>
#include <dxgi.h>
#include <d3dcompiler.h>

#include <embed/shaders.h>

#include <algorithm>
#include <atomic>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <iomanip>
#include <initializer_list>
#include <limits>
#include <mutex>
#include <ranges>
#include <sstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/resource.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"
#include "./mw3_microstutter_core_V14_TRAVERSAL.hpp"
#include "./mw3_stutter_runtime_V36_V27_SOUND_CACHE_FASTSEEK_NATIVE_FPS.hpp"
#include "./mw3_frame_deadline.hpp"
#include "mw3_precise_wait.hpp"
#include "./half_filter.hpp"

#ifndef RENODX_PSYCHOV24_SLIDER_LAYOUT_VERSION
#error "CODBLOPS: shared.h is outdated. Replace shared.h with the PsychoV24 slider version from the same package."
#endif

namespace {

// ============================================================================
// MW3 x64 V27 lean trace-guided archive/sync runtime + V13 pacing + Plutonium-style mouse fix
// High-polling-rate mouse / Raw Input bridge
// ============================================================================
//
// Goals:
//   * Preserve every physical relative mouse delta. There is no 125/500/1000 Hz
//     resampling and no artificial polling cap.
//   * Keep the game's native sensitivity, ADS, m_yaw/m_pitch, m_filter and aim
//     math by continuing to feed movement through its GetCursorPos/SetCursorPos
//     relative-mouse path.
//   * Avoid making the old Win32 message loop process thousands of individual
//     WM_MOUSEMOVE/WM_INPUT messages per second. While the game is recentering
//     the cursor for gameplay, raw reports are accumulated and input-only bursts
//     are drained in one PeekMessage/GetMessage hook invocation.
//   * Do not suppress legacy button/wheel messages. Raw Input is registered
//     WITHOUT RIDEV_NOLEGACY, so mouse buttons, wheel and menus remain native.
//   * Automatically fall back to the original cursor path in menus, after focus
//     loss, and while the ReShade overlay wants the mouse.
//
// The stock WaW/BO1/IW5 executables all import GetCursorPos, SetCursorPos,
// PeekMessageA and GetMessageA and do not import the Windows Raw Input APIs.
// This bridge therefore patches only those four main-EXE IAT slots. Calls made
// by ReShade or other DLLs are not redirected.

namespace cod_high_polling_mouse {

using PeekMessageAFn = BOOL(WINAPI*)(LPMSG, HWND, UINT, UINT, UINT);
using GetMessageAFn = BOOL(WINAPI*)(LPMSG, HWND, UINT, UINT);

struct IATHook {
  uintptr_t* slot = nullptr;
  uintptr_t original = 0u;
  uintptr_t replacement = 0u;
};

inline std::atomic<bool> g_enabled{true};
inline std::atomic<bool> g_overlay_capturing_mouse{false};
inline std::atomic<uintptr_t> g_game_hwnd{0u};
inline std::atomic<bool> g_iat_hooks_installed{false};
inline std::atomic<bool> g_cl_mouse_hook_installed{false};
inline std::atomic<bool> g_raw_registered{false};
inline std::atomic<bool> g_logged_install_failure{false};
inline std::atomic<bool> g_logged_raw_active{false};

inline std::atomic<int64_t> g_raw_total_x{0};
inline std::atomic<int64_t> g_raw_total_y{0};
inline std::atomic<int64_t> g_raw_consumed_x{0};
inline std::atomic<int64_t> g_raw_consumed_y{0};
inline std::atomic<uint64_t> g_raw_report_count{0u};
inline std::atomic<uint64_t> g_last_cl_mouse_tick{0u};

inline PeekMessageAFn g_original_peek_message_a = nullptr;
inline GetMessageAFn g_original_get_message_a = nullptr;
inline IATHook g_peek_message_hook = {};
inline IATHook g_get_message_hook = {};

inline bool g_saved_raw_registration_valid = false;
inline RAWINPUTDEVICE g_saved_raw_registration = {};
inline HWND g_registered_hwnd = nullptr;

constexpr uint64_t kRelativeModeHoldMs = 250u;
constexpr uint32_t kMaxInputMessagesDrainedPerCall = 512u;

// These are the exact native IW5 CL_MouseEvent functions recovered from the
// user's supplied executables. The hook replaces ONLY the cursor-derived dx/dy
// arguments. x/y, recentering, sensitivity, ADS, m_yaw/m_pitch, acceleration,
// filtering and all downstream camera code remain the game's own implementation.
using CLMouseEventFn = int(__fastcall*)(int, int, int, int);
inline CLMouseEventFn g_original_cl_mouse_event = nullptr;
constexpr WORD kExpectedMachine = IMAGE_FILE_MACHINE_AMD64;
constexpr DWORD kExpectedTimestamp = 0x6A743A58u;
constexpr DWORD kExpectedSizeOfImage = 0x044BE000u;
constexpr uintptr_t kCLMouseEventRva = 0x0007D920u;
constexpr std::array<uint8_t, 16> kCLMouseEventSignature = {
    0x48, 0x89, 0x5C, 0x24, 0x08, 0x57, 0x48, 0x83,
    0xEC, 0x20, 0x8B, 0x05, 0x20, 0x4C, 0x66, 0x00,
};

void LogInfo(const char* text) {
  reshade::log::message(
      reshade::log::level::info,
      text != nullptr ? text : "[MW3 Mouse Fix] (null)");
}

void LogWarning(const char* text) {
  reshade::log::message(
      reshade::log::level::warning,
      text != nullptr ? text : "[MW3 Mouse Fix] (null)");
}

bool EqualAsciiInsensitive(const char* a, const char* b) {
  if (a == nullptr || b == nullptr) return false;
  while (*a != '\0' && *b != '\0') {
    char ca = *a++;
    char cb = *b++;
    if (ca >= 'A' && ca <= 'Z') ca = static_cast<char>(ca - 'A' + 'a');
    if (cb >= 'A' && cb <= 'Z') cb = static_cast<char>(cb - 'A' + 'a');
    if (ca != cb) return false;
  }
  return *a == '\0' && *b == '\0';
}

bool FindAndPatchMainExeIAT(
    const char* imported_dll,
    const char* imported_name,
    void* replacement,
    IATHook& hook) {
  if (imported_dll == nullptr || imported_name == nullptr || replacement == nullptr) {
    return false;
  }

  auto* module = reinterpret_cast<uint8_t*>(GetModuleHandleW(nullptr));
  if (module == nullptr) return false;

  auto* dos = reinterpret_cast<IMAGE_DOS_HEADER*>(module);
  if (dos->e_magic != IMAGE_DOS_SIGNATURE || dos->e_lfanew <= 0) return false;

  auto* nt = reinterpret_cast<IMAGE_NT_HEADERS*>(module + dos->e_lfanew);
  if (nt->Signature != IMAGE_NT_SIGNATURE) return false;

  const auto& directory =
      nt->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT];
  if (directory.VirtualAddress == 0u
      || directory.Size < sizeof(IMAGE_IMPORT_DESCRIPTOR)) {
    return false;
  }

  auto* descriptor = reinterpret_cast<IMAGE_IMPORT_DESCRIPTOR*>(
      module + directory.VirtualAddress);

  for (; descriptor->Name != 0u; ++descriptor) {
    const char* dll_name = reinterpret_cast<const char*>(module + descriptor->Name);
    if (!EqualAsciiInsensitive(dll_name, imported_dll)) continue;
    if (descriptor->OriginalFirstThunk == 0u || descriptor->FirstThunk == 0u) {
      return false;
    }

    auto* name_thunk = reinterpret_cast<IMAGE_THUNK_DATA*>(
        module + descriptor->OriginalFirstThunk);
    auto* iat_thunk = reinterpret_cast<IMAGE_THUNK_DATA*>(
        module + descriptor->FirstThunk);

    for (; name_thunk->u1.AddressOfData != 0u; ++name_thunk, ++iat_thunk) {
      if (IMAGE_SNAP_BY_ORDINAL(name_thunk->u1.Ordinal)) continue;

      auto* import = reinterpret_cast<IMAGE_IMPORT_BY_NAME*>(
          module + static_cast<uintptr_t>(name_thunk->u1.AddressOfData));
      if (std::strcmp(reinterpret_cast<const char*>(import->Name), imported_name) != 0) {
        continue;
      }

      auto* slot = reinterpret_cast<uintptr_t*>(&iat_thunk->u1.Function);
      const uintptr_t original = *slot;
      const uintptr_t replacement_value = reinterpret_cast<uintptr_t>(replacement);

      DWORD old_protect = 0u;
      if (!VirtualProtect(slot, sizeof(uintptr_t), PAGE_READWRITE, &old_protect)) {
        return false;
      }

      *slot = replacement_value;
      FlushInstructionCache(GetCurrentProcess(), slot, sizeof(uintptr_t));

      DWORD ignored = 0u;
      VirtualProtect(slot, sizeof(uintptr_t), old_protect, &ignored);

      hook.slot = slot;
      hook.original = original;
      hook.replacement = replacement_value;
      return true;
    }
  }

  return false;
}

void RestoreIATHook(IATHook& hook) {
  if (hook.slot == nullptr || hook.original == 0u) {
    hook = {};
    return;
  }

  DWORD old_protect = 0u;
  if (VirtualProtect(hook.slot, sizeof(uintptr_t), PAGE_READWRITE, &old_protect)) {
    if (*hook.slot == hook.replacement) {
      *hook.slot = hook.original;
      FlushInstructionCache(GetCurrentProcess(), hook.slot, sizeof(uintptr_t));
    }
    DWORD ignored = 0u;
    VirtualProtect(hook.slot, sizeof(uintptr_t), old_protect, &ignored);
  }
  hook = {};
}

HWND GameWindow() {
  return reinterpret_cast<HWND>(g_game_hwnd.load(std::memory_order_acquire));
}

void RebaseRawDeltas() {
  const int64_t x = g_raw_total_x.load(std::memory_order_relaxed);
  const int64_t y = g_raw_total_y.load(std::memory_order_relaxed);
  g_raw_consumed_x.store(x, std::memory_order_relaxed);
  g_raw_consumed_y.store(y, std::memory_order_relaxed);
}

bool RelativeCaptureActive() {
  if (!g_enabled.load(std::memory_order_acquire)
      || !g_raw_registered.load(std::memory_order_acquire)
      || g_overlay_capturing_mouse.load(std::memory_order_acquire)) {
    return false;
  }

  const HWND hwnd = GameWindow();
  if (hwnd == nullptr || GetForegroundWindow() != hwnd) return false;

  const uint64_t last = g_last_cl_mouse_tick.load(std::memory_order_relaxed);
  const uint64_t now = GetTickCount64();
  return last != 0u && now >= last && (now - last) <= kRelativeModeHoldMs;
}

void SaveExistingRawMouseRegistration() {
  g_saved_raw_registration_valid = false;
  g_saved_raw_registration = {};

  UINT count = 0u;
  GetRegisteredRawInputDevices(nullptr, &count, sizeof(RAWINPUTDEVICE));
  if (count == 0u) return;

  std::vector<RAWINPUTDEVICE> devices(count);
  UINT capacity = count;
  if (GetRegisteredRawInputDevices(
          devices.data(),
          &capacity,
          sizeof(RAWINPUTDEVICE)) == static_cast<UINT>(-1)) {
    return;
  }

  for (UINT i = 0u; i < capacity; ++i) {
    if (devices[i].usUsagePage == 0x01u && devices[i].usUsage == 0x02u) {
      g_saved_raw_registration = devices[i];
      g_saved_raw_registration_valid = true;
      return;
    }
  }
}

bool RegisterRawMouse(HWND hwnd) {
  if (hwnd == nullptr) return false;

  SaveExistingRawMouseRegistration();

  RAWINPUTDEVICE mouse = {};
  mouse.usUsagePage = 0x01u;  // Generic desktop controls
  mouse.usUsage = 0x02u;      // Mouse
  // Match the established IW-family raw-input implementation: receive raw
  // reports through the game window even if Windows momentarily changes focus.
  // Actual camera injection still requires the game to be foreground.
  mouse.dwFlags = RIDEV_INPUTSINK;
  mouse.hwndTarget = hwnd;

  if (!RegisterRawInputDevices(&mouse, 1u, sizeof(mouse))) return false;

  g_registered_hwnd = hwnd;
  g_raw_registered.store(true, std::memory_order_release);
  RebaseRawDeltas();
  return true;
}

void RestoreRawMouseRegistration() {
  if (!g_raw_registered.exchange(false, std::memory_order_acq_rel)) return;

  if (g_saved_raw_registration_valid) {
    RegisterRawInputDevices(
        &g_saved_raw_registration,
        1u,
        sizeof(g_saved_raw_registration));
  } else {
    RAWINPUTDEVICE remove = {};
    remove.usUsagePage = 0x01u;
    remove.usUsage = 0x02u;
    remove.dwFlags = RIDEV_REMOVE;
    remove.hwndTarget = nullptr;
    RegisterRawInputDevices(&remove, 1u, sizeof(remove));
  }

  g_registered_hwnd = nullptr;
  g_saved_raw_registration_valid = false;
  g_saved_raw_registration = {};
}

void ProcessRawInput(HRAWINPUT handle) {
  if (handle == nullptr) return;

  UINT size = 0u;
  if (GetRawInputData(
          handle,
          RID_INPUT,
          nullptr,
          &size,
          sizeof(RAWINPUTHEADER)) == static_cast<UINT>(-1)
      || size < sizeof(RAWINPUTHEADER)) {
    return;
  }

  // Avoid the Windows SDK RPC `small` macro from rpcndr.h.
  std::array<uint8_t, sizeof(RAWINPUT)> stack_storage = {};
  std::vector<uint8_t> dynamic_storage;
  void* storage = stack_storage.data();
  if (size > stack_storage.size()) {
    dynamic_storage.resize(size);
    storage = dynamic_storage.data();
  }

  UINT read_size = size;
  const UINT result = GetRawInputData(
      handle,
      RID_INPUT,
      storage,
      &read_size,
      sizeof(RAWINPUTHEADER));
  if (result == static_cast<UINT>(-1) || result < sizeof(RAWINPUTHEADER)) return;

  const auto* raw = reinterpret_cast<const RAWINPUT*>(storage);
  if (raw->header.dwType != RIM_TYPEMOUSE) return;

  const RAWMOUSE& mouse = raw->data.mouse;
  if ((mouse.usFlags & MOUSE_MOVE_ABSOLUTE) != 0u) {
    // Gaming mice are relative. Ignore tablets/touch-style absolute devices
    // rather than mixing coordinate systems into camera movement.
    return;
  }

  g_raw_total_x.fetch_add(static_cast<int64_t>(mouse.lLastX), std::memory_order_relaxed);
  g_raw_total_y.fetch_add(static_cast<int64_t>(mouse.lLastY), std::memory_order_relaxed);
  g_raw_report_count.fetch_add(1u, std::memory_order_relaxed);
}

void CleanupConsumedRawInput(const MSG& message) {
  if (message.message != WM_INPUT) return;
  ProcessRawInput(reinterpret_cast<HRAWINPUT>(message.lParam));
  if (message.hwnd != nullptr && GET_RAWINPUT_CODE_WPARAM(message.wParam) == RIM_INPUT) {
    DefWindowProcA(message.hwnd, message.message, message.wParam, message.lParam);
  }
}

bool IsMovementOnlyMessage(const MSG& message) {
  return message.message == WM_INPUT || message.message == WM_MOUSEMOVE;
}

void ObserveRawMessageWithoutConsuming(const MSG& message) {
  if (message.message == WM_INPUT) {
    ProcessRawInput(reinterpret_cast<HRAWINPUT>(message.lParam));
  }
}

BOOL WINAPI HookPeekMessageA(
    LPMSG message,
    HWND hwnd,
    UINT min_filter,
    UINT max_filter,
    UINT remove_message) {
  if (g_original_peek_message_a == nullptr) return FALSE;

  const BOOL first = g_original_peek_message_a(
      message, hwnd, min_filter, max_filter, remove_message);

  if (!first || message == nullptr) return first;

  // Only parse a raw handle after the message has actually been removed. A
  // PM_NOREMOVE peek can expose the same HRAWINPUT repeatedly.
  if ((remove_message & PM_REMOVE) != 0u) {
    ObserveRawMessageWithoutConsuming(*message);
  }

  if ((remove_message & PM_REMOVE) == 0u
      || min_filter != 0u
      || max_filter != 0u
      || !RelativeCaptureActive()
      || !IsMovementOnlyMessage(*message)) {
    return first;
  }

  // This message will not be dispatched, so perform WM_INPUT cleanup ourselves.
  if (message->message == WM_INPUT
      && message->hwnd != nullptr
      && GET_RAWINPUT_CODE_WPARAM(message->wParam) == RIM_INPUT) {
    DefWindowProcA(message->hwnd, message->message, message->wParam, message->lParam);
  }

  for (uint32_t drained = 1u;
       drained < kMaxInputMessagesDrainedPerCall;
       ++drained) {
    MSG next = {};
    if (!g_original_peek_message_a(&next, hwnd, 0u, 0u, PM_REMOVE)) {
      return FALSE;
    }

    if (!IsMovementOnlyMessage(next)) {
      *message = next;
      return TRUE;
    }

    CleanupConsumedRawInput(next);
  }

  return FALSE;
}

BOOL WINAPI HookGetMessageA(
    LPMSG message,
    HWND hwnd,
    UINT min_filter,
    UINT max_filter) {
  if (g_original_get_message_a == nullptr) return -1;

  const BOOL first = g_original_get_message_a(message, hwnd, min_filter, max_filter);
  if (first <= 0 || message == nullptr) return first;

  ObserveRawMessageWithoutConsuming(*message);

  if (min_filter != 0u
      || max_filter != 0u
      || !RelativeCaptureActive()
      || !IsMovementOnlyMessage(*message)) {
    return first;
  }

  if (message->message == WM_INPUT
      && message->hwnd != nullptr
      && GET_RAWINPUT_CODE_WPARAM(message->wParam) == RIM_INPUT) {
    DefWindowProcA(message->hwnd, message->message, message->wParam, message->lParam);
  }

  // Never block after collapsing a high-polling movement burst. This mirrors
  // the practical purpose of Plutonium's separate fix_mouse_lag path: reduce
  // the amount of old message-pump work generated by high-rate mouse motion.
  for (uint32_t drained = 1u;
       drained < kMaxInputMessagesDrainedPerCall;
       ++drained) {
    MSG next = {};
    if (g_original_peek_message_a == nullptr
        || !g_original_peek_message_a(&next, hwnd, 0u, 0u, PM_REMOVE)) {
      *message = {};
      message->hwnd = GameWindow();
      message->message = WM_NULL;
      return TRUE;
    }

    if (next.message == WM_QUIT) {
      *message = next;
      return FALSE;
    }

    if (!IsMovementOnlyMessage(next)) {
      *message = next;
      return TRUE;
    }

    CleanupConsumedRawInput(next);
  }

  *message = {};
  message->hwnd = GameWindow();
  message->message = WM_NULL;
  return TRUE;
}

bool VerifyCLMouseEventTarget() {
  auto* module = reinterpret_cast<uint8_t*>(GetModuleHandleW(nullptr));
  if (module == nullptr) return false;

  auto* dos = reinterpret_cast<IMAGE_DOS_HEADER*>(module);
  if (dos->e_magic != IMAGE_DOS_SIGNATURE || dos->e_lfanew <= 0) return false;
  auto* nt = reinterpret_cast<IMAGE_NT_HEADERS*>(module + dos->e_lfanew);
  if (nt->Signature != IMAGE_NT_SIGNATURE) return false;

  if (nt->FileHeader.Machine != kExpectedMachine
      || nt->FileHeader.TimeDateStamp != kExpectedTimestamp
      || nt->OptionalHeader.SizeOfImage != kExpectedSizeOfImage) {
    return false;
  }

  const auto* target = module + kCLMouseEventRva;
  return std::memcmp(
             target,
             kCLMouseEventSignature.data(),
             kCLMouseEventSignature.size()) == 0;
}

int __fastcall HookCLMouseEvent(int x, int y, int stock_dx, int stock_dy) {
  const auto original = g_original_cl_mouse_event;
  if (original == nullptr) return 0;

  const uint64_t now = GetTickCount64();

  if (!g_enabled.load(std::memory_order_acquire)
      || !g_raw_registered.load(std::memory_order_acquire)
      || g_overlay_capturing_mouse.load(std::memory_order_acquire)
      || GameWindow() == nullptr
      || GetForegroundWindow() != GameWindow()) {
    RebaseRawDeltas();
    const int result = original(x, y, stock_dx, stock_dy);
    g_last_cl_mouse_tick.store(
        result != 0 ? now : 0u,
        std::memory_order_relaxed);
    return result;
  }

  const int64_t total_x = g_raw_total_x.load(std::memory_order_relaxed);
  const int64_t total_y = g_raw_total_y.load(std::memory_order_relaxed);
  const int64_t previous_x = g_raw_consumed_x.exchange(total_x, std::memory_order_acq_rel);
  const int64_t previous_y = g_raw_consumed_y.exchange(total_y, std::memory_order_acq_rel);

  const int64_t raw_dx64 = total_x - previous_x;
  const int64_t raw_dy64 = total_y - previous_y;
  const int raw_dx = static_cast<int>(std::clamp<int64_t>(
      raw_dx64, static_cast<int64_t>(std::numeric_limits<int>::min()),
      static_cast<int64_t>(std::numeric_limits<int>::max())));
  const int raw_dy = static_cast<int>(std::clamp<int64_t>(
      raw_dy64, static_cast<int64_t>(std::numeric_limits<int>::min()),
      static_cast<int64_t>(std::numeric_limits<int>::max())));

  if (!g_logged_raw_active.exchange(true, std::memory_order_acq_rel)) {
    LogInfo(
        "[MW3 Mouse Fix] Plutonium-style direct raw delta path active: CL_MouseEvent receives WM_INPUT dx/dy directly; stock cursor-derived deltas are bypassed.");
  }

  const int result = original(x, y, raw_dx, raw_dy);
  if (result != 0) {
    g_last_cl_mouse_tick.store(now, std::memory_order_relaxed);
  } else {
    // CL_MouseEvent returning false means the engine is not requesting relative
    // recentering (menus/UI). Do not collapse its normal cursor messages.
    g_last_cl_mouse_tick.store(0u, std::memory_order_relaxed);
    RebaseRawDeltas();
  }
  return result;
}

bool InstallCLMouseEventHook() {
  if (g_cl_mouse_hook_installed.load(std::memory_order_acquire)) return true;
  if (!VerifyCLMouseEventTarget()) {
    LogWarning(
        "[MW3 Mouse Fix] Exact CL_MouseEvent signature/build verification failed; direct raw-input injection left disabled.");
    return false;
  }

  auto* module = reinterpret_cast<uint8_t*>(GetModuleHandleW(nullptr));
  g_original_cl_mouse_event = reinterpret_cast<CLMouseEventFn>(
      module + kCLMouseEventRva);

  if (DetourTransactionBegin() != NO_ERROR) return false;
  DetourUpdateThread(GetCurrentThread());
  const LONG attach = DetourAttach(
      reinterpret_cast<PVOID*>(&g_original_cl_mouse_event),
      reinterpret_cast<PVOID>(&HookCLMouseEvent));
  if (attach != NO_ERROR) {
    DetourTransactionAbort();
    g_original_cl_mouse_event = nullptr;
    return false;
  }

  const LONG commit = DetourTransactionCommit();
  if (commit != NO_ERROR) {
    g_original_cl_mouse_event = nullptr;
    return false;
  }

  g_cl_mouse_hook_installed.store(true, std::memory_order_release);
  LogInfo(
      "[MW3 Mouse Fix] Direct native CL_MouseEvent raw-delta hook installed; legacy cursor-derived dx/dy is bypassed during gameplay.");
  return true;
}

void RemoveCLMouseEventHook() {
  if (!g_cl_mouse_hook_installed.exchange(false, std::memory_order_acq_rel)) return;
  if (g_original_cl_mouse_event == nullptr) return;

  if (DetourTransactionBegin() == NO_ERROR) {
    DetourUpdateThread(GetCurrentThread());
    if (DetourDetach(
            reinterpret_cast<PVOID*>(&g_original_cl_mouse_event),
            reinterpret_cast<PVOID>(&HookCLMouseEvent)) == NO_ERROR) {
      DetourTransactionCommit();
    } else {
      DetourTransactionAbort();
    }
  }

  g_original_cl_mouse_event = nullptr;
}

bool InstallMessageHooks() {
  if (g_iat_hooks_installed.load(std::memory_order_acquire)) return true;

  const bool peek_message = FindAndPatchMainExeIAT(
      "user32.dll", "PeekMessageA",
      reinterpret_cast<void*>(&HookPeekMessageA),
      g_peek_message_hook);
  if (peek_message) {
    g_original_peek_message_a = reinterpret_cast<PeekMessageAFn>(
        g_peek_message_hook.original);
  }

  const bool get_message = FindAndPatchMainExeIAT(
      "user32.dll", "GetMessageA",
      reinterpret_cast<void*>(&HookGetMessageA),
      g_get_message_hook);
  if (get_message) {
    g_original_get_message_a = reinterpret_cast<GetMessageAFn>(
        g_get_message_hook.original);
  }

  if (!peek_message || !get_message) {
    RestoreIATHook(g_get_message_hook);
    RestoreIATHook(g_peek_message_hook);
    g_original_peek_message_a = nullptr;
    g_original_get_message_a = nullptr;
    return false;
  }

  g_iat_hooks_installed.store(true, std::memory_order_release);
  return true;
}

bool InstallHooks() {
  if (!InstallMessageHooks() || !InstallCLMouseEventHook()) {
    RestoreIATHook(g_get_message_hook);
    RestoreIATHook(g_peek_message_hook);
    g_original_peek_message_a = nullptr;
    g_original_get_message_a = nullptr;
    g_iat_hooks_installed.store(false, std::memory_order_release);
    RemoveCLMouseEventHook();

    if (!g_logged_install_failure.exchange(true, std::memory_order_acq_rel)) {
      LogWarning(
          "[MW3 Mouse Fix] Could not install the complete Plutonium-style mouse path; stock input left active rather than partially hooking it.");
    }
    return false;
  }

  return true;
}

void SetEnabled(bool enabled) {
  g_enabled.store(enabled, std::memory_order_release);
  if (!enabled) {
    g_last_cl_mouse_tick.store(0u, std::memory_order_relaxed);
    RebaseRawDeltas();
  }
}

void Update(HWND hwnd, bool enabled, bool overlay_capturing_mouse) {
  SetEnabled(enabled);

  const bool previous_overlay = g_overlay_capturing_mouse.exchange(
      overlay_capturing_mouse,
      std::memory_order_acq_rel);
  if (previous_overlay != overlay_capturing_mouse) {
    RebaseRawDeltas();
    g_last_cl_mouse_tick.store(0u, std::memory_order_relaxed);
  }

  const uintptr_t previous_hwnd = g_game_hwnd.exchange(
      reinterpret_cast<uintptr_t>(hwnd),
      std::memory_order_acq_rel);

  if (!enabled || hwnd == nullptr) {
    if (g_raw_registered.load(std::memory_order_acquire)) {
      RestoreRawMouseRegistration();
    }
    RebaseRawDeltas();
    return;
  }

  if (!InstallHooks()) return;

  if (!g_raw_registered.load(std::memory_order_acquire)
      || previous_hwnd != reinterpret_cast<uintptr_t>(hwnd)
      || g_registered_hwnd != hwnd) {
    if (g_raw_registered.load(std::memory_order_acquire)) {
      RestoreRawMouseRegistration();
    }

    if (!RegisterRawMouse(hwnd)) {
      LogWarning(
          "[MW3 Mouse Fix] RegisterRawInputDevices failed; stock mouse path remains active.");
      return;
    }

    g_raw_total_x.store(0, std::memory_order_relaxed);
    g_raw_total_y.store(0, std::memory_order_relaxed);
    g_raw_report_count.store(0u, std::memory_order_relaxed);
    RebaseRawDeltas();
    g_last_cl_mouse_tick.store(0u, std::memory_order_relaxed);

    LogInfo(
        "[MW3 Mouse Fix] Raw mouse registered with RIDEV_INPUTSINK; high-rate reports will be accumulated and injected directly into CL_MouseEvent.");
  }
}

void Shutdown() {
  g_enabled.store(false, std::memory_order_release);
  g_overlay_capturing_mouse.store(false, std::memory_order_release);
  g_last_cl_mouse_tick.store(0u, std::memory_order_relaxed);
  RebaseRawDeltas();

  RestoreRawMouseRegistration();
  RemoveCLMouseEventHook();

  RestoreIATHook(g_get_message_hook);
  RestoreIATHook(g_peek_message_hook);
  g_original_peek_message_a = nullptr;
  g_original_get_message_a = nullptr;
  g_iat_hooks_installed.store(false, std::memory_order_release);
  g_game_hwnd.store(0u, std::memory_order_release);
}

}  // namespace cod_high_polling_mouse


// ============================================================================
// MW3 x64 V14 exact render-poll wait replacement
// ============================================================================
//
// Earlier runtime probes identified one hot Present-thread Sleep(1) backoff at
// return RVA 0x18B895. The call site is:
//
//   0x18B88B  mov ecx, 1
//   0x18B890  call 0x24A410  ; engine Sleep thunk
//   0x18B895  ...
//
// On the tested x64 build that nominal 1 ms sleep frequently consumed ~1-2 ms
// on the Present thread. V12 can replace only this exact, signature-verified
// backoff with Sleep(0) or a true busy poll. No other Sleep call is modified.
namespace mw3_render_poll_wait {

constexpr WORD kExpectedMachine = IMAGE_FILE_MACHINE_AMD64;
constexpr DWORD kExpectedTimestamp = 0x6A743A58u;
constexpr DWORD kExpectedSizeOfImage = 0x044BE000u;
constexpr uintptr_t kPollSleepSiteRva = 0x0018B88Bu;

constexpr std::array<uint8_t, 10> kStockBytes = {
    0xB9, 0x01, 0x00, 0x00, 0x00,  // mov ecx,1
    0xE8, 0x7B, 0xEB, 0x0B, 0x00,  // call 0x24A410
};
constexpr std::array<uint8_t, 10> kYieldBytes = {
    0xB9, 0x00, 0x00, 0x00, 0x00,  // mov ecx,0
    0xE8, 0x7B, 0xEB, 0x0B, 0x00,  // call 0x24A410
};
constexpr std::array<uint8_t, 10> kBusyBytes = {
    0x90, 0x90, 0x90, 0x90, 0x90,
    0x90, 0x90, 0x90, 0x90, 0x90,
};

enum class Mode : int {
  Stock = 0,
  Yield = 1,
  Busy = 2,
};

inline uintptr_t g_exe_base = 0u;
inline std::atomic<int> g_requested_mode{static_cast<int>(Mode::Stock)};
inline std::atomic<int> g_applied_mode{-1};
inline std::atomic<bool> g_warned_signature{false};

void LogInfo(const char* text) {
  reshade::log::message(reshade::log::level::info, text);
}
void LogWarning(const char* text) {
  reshade::log::message(reshade::log::level::warning, text);
}

bool VerifyTargetBuild() {
  auto* module = reinterpret_cast<uint8_t*>(GetModuleHandleW(nullptr));
  if (module == nullptr) return false;
  auto* dos = reinterpret_cast<IMAGE_DOS_HEADER*>(module);
  if (dos->e_magic != IMAGE_DOS_SIGNATURE || dos->e_lfanew <= 0) return false;
  auto* nt = reinterpret_cast<IMAGE_NT_HEADERS64*>(module + dos->e_lfanew);
  if (nt->Signature != IMAGE_NT_SIGNATURE
      || nt->FileHeader.Machine != kExpectedMachine
      || nt->FileHeader.TimeDateStamp != kExpectedTimestamp
      || nt->OptionalHeader.SizeOfImage != kExpectedSizeOfImage) {
    return false;
  }
  g_exe_base = reinterpret_cast<uintptr_t>(module);
  return true;
}

bool WriteExecutableBytes(void* address, const uint8_t* bytes, size_t size) {
  if (address == nullptr || bytes == nullptr || size == 0u) return false;
  DWORD old_protect = 0u;
  if (!VirtualProtect(address, size, PAGE_EXECUTE_READWRITE, &old_protect)) {
    return false;
  }
  std::memcpy(address, bytes, size);
  FlushInstructionCache(GetCurrentProcess(), address, size);
  DWORD ignored = 0u;
  VirtualProtect(address, size, old_protect, &ignored);
  return true;
}

bool IsKnownBytes(const uint8_t* target) {
  return std::memcmp(target, kStockBytes.data(), kStockBytes.size()) == 0
      || std::memcmp(target, kYieldBytes.data(), kYieldBytes.size()) == 0
      || std::memcmp(target, kBusyBytes.data(), kBusyBytes.size()) == 0;
}

bool ApplyMode(Mode mode) {
  if (g_exe_base == 0u && !VerifyTargetBuild()) return false;
  auto* target = reinterpret_cast<uint8_t*>(g_exe_base + kPollSleepSiteRva);
  if (!IsKnownBytes(target)) {
    if (!g_warned_signature.exchange(true, std::memory_order_acq_rel)) {
      LogWarning("[MW3 V14 Busy Wait] exact 0x18B88B Sleep(1) signature mismatch; render-poll wait left stock.");
    }
    return false;
  }

  const auto* wanted = &kStockBytes;
  if (mode == Mode::Yield) wanted = &kYieldBytes;
  if (mode == Mode::Busy) wanted = &kBusyBytes;

  if (std::memcmp(target, wanted->data(), wanted->size()) != 0
      && !WriteExecutableBytes(target, wanted->data(), wanted->size())) {
    return false;
  }

  const int previous = g_applied_mode.exchange(static_cast<int>(mode), std::memory_order_acq_rel);
  if (previous != static_cast<int>(mode)) {
    if (mode == Mode::Stock) {
      LogInfo("[MW3 V14 Busy Wait] exact Present-thread render poll restored to stock Sleep(1).");
    } else if (mode == Mode::Yield) {
      LogInfo("[MW3 V14 Busy Wait] exact Present-thread render poll now uses Sleep(0) yield instead of Sleep(1).");
    } else {
      LogInfo("[MW3 V14 Busy Wait] Plutonium-style busy poll active at exact RVA 0x18B88B; the verified Present-thread Sleep(1) is bypassed.");
    }
  }
  return true;
}

void SetRequestedMode(int mode) {
  // V15.1 profiler hardening: never patch executable bytes from settings/DllMain.
  // The requested state is applied only from the first real native-D3D9 Present.
  mode = std::clamp(mode, 0, 2);
  g_requested_mode.store(mode, std::memory_order_release);
}

void Update() {
  const int mode = std::clamp(g_requested_mode.load(std::memory_order_acquire), 0, 2);
  if (g_applied_mode.load(std::memory_order_acquire) != mode) {
    ApplyMode(static_cast<Mode>(mode));
  }
}

void ForceStockForTransition() {
  ApplyMode(Mode::Stock);
}

void Shutdown() {
  if (g_exe_base != 0u) {
    auto* target = reinterpret_cast<uint8_t*>(g_exe_base + kPollSleepSiteRva);
    if (IsKnownBytes(target)) {
      WriteExecutableBytes(target, kStockBytes.data(), kStockBytes.size());
    }
  }
  g_applied_mode.store(-1, std::memory_order_release);
}

}  // namespace mw3_render_poll_wait

float mw3_render_poll_wait_mode = 0.f;

// ============================================================================
// MW3 x64 V14 visible-frame pacing
// ============================================================================
//
// V11/V12 disabled MW3's own com_maxfps read and then waited at the native D3D9
// Present boundary. That improved coarse cadence but made the engine internally
// behave as if its frame target were 1 ms, while the actual visible frame still
// had to pass through RenoDX's D3D11 HDR proxy afterwards.
//
// V14 keeps MW3's original Com_Frame limiter completely intact. The engine still
// sees the real com_maxfps value and performs its normal simulation/input timing.
// We only finish the fractional part of the deadline at the *visible* D3D11 proxy
// Present. Example at 120 FPS: stock IW5 gets close with its 8 ms integer target;
// this limiter finishes the frame at 8.333333 ms instead of replacing engine
// timing with an external 8.333 ms sleep after a 1 ms internal frame.
namespace mw3_smooth_frame_pacing {

constexpr WORD kExpectedMachine = IMAGE_FILE_MACHINE_AMD64;
constexpr DWORD kExpectedTimestamp = 0x6A743A58u;
constexpr DWORD kExpectedSizeOfImage = 0x044BE000u;
constexpr uintptr_t kComMaxFpsDvarPtrRva = 0x01EFB9E8u;
constexpr uintptr_t kComFrameMaxFpsReadRva = 0x0023D08Cu;
constexpr std::array<uint8_t, 3> kComFrameMaxFpsReadOriginal = {
    0x8B, 0x48, 0x10,  // mov ecx, dword ptr [rax+10h]
};
constexpr std::array<uint8_t, 3> kOldExternalBypassBytes = {
    0x31, 0xC9, 0x90,  // V11/V12 xor ecx,ecx / nop
};

inline std::atomic<bool> g_enabled{true};
inline std::atomic<bool> g_logged_active{false};
inline std::atomic<bool> g_stock_limiter_verified{false};
inline std::atomic<uintptr_t> g_com_maxfps_dvar{0u};
inline uintptr_t g_exe_base = 0u;

struct SmoothLimiterState {
  uint64_t qpc_frequency = 0u;
  double next_deadline = 0.0;
  int target_fps = 0;
  HANDLE timer = nullptr;
  double wake_error_us = 120.0;
  bool initialized = false;
};
thread_local SmoothLimiterState g_limiter;

void LogInfo(const char* text) {
  reshade::log::message(reshade::log::level::info,
                       text != nullptr ? text : "[MW3 V14 Frame Pacing] (null)");
}
void LogWarning(const char* text) {
  reshade::log::message(reshade::log::level::warning,
                       text != nullptr ? text : "[MW3 V14 Frame Pacing] (null)");
}

bool IsReadableRange(const void* pointer, size_t size) {
  if (pointer == nullptr || size == 0u) return false;
  MEMORY_BASIC_INFORMATION mbi = {};
  if (VirtualQuery(pointer, &mbi, sizeof(mbi)) == 0u) return false;
  if (mbi.State != MEM_COMMIT) return false;
  if ((mbi.Protect & (PAGE_NOACCESS | PAGE_GUARD)) != 0u) return false;
  const uintptr_t begin = reinterpret_cast<uintptr_t>(pointer);
  const uintptr_t end = begin + size;
  const uintptr_t region_end = reinterpret_cast<uintptr_t>(mbi.BaseAddress) + mbi.RegionSize;
  return end >= begin && end <= region_end;
}

bool WriteExecutableBytes(void* address, const uint8_t* bytes, size_t size) {
  if (address == nullptr || bytes == nullptr || size == 0u) return false;
  DWORD old_protect = 0u;
  if (!VirtualProtect(address, size, PAGE_EXECUTE_READWRITE, &old_protect)) return false;
  std::memcpy(address, bytes, size);
  FlushInstructionCache(GetCurrentProcess(), address, size);
  DWORD ignored = 0u;
  VirtualProtect(address, size, old_protect, &ignored);
  return true;
}

bool VerifyTargetBuild() {
  auto* module = reinterpret_cast<uint8_t*>(GetModuleHandleW(nullptr));
  if (module == nullptr) return false;
  auto* dos = reinterpret_cast<IMAGE_DOS_HEADER*>(module);
  if (dos->e_magic != IMAGE_DOS_SIGNATURE || dos->e_lfanew <= 0) return false;
  auto* nt = reinterpret_cast<IMAGE_NT_HEADERS64*>(module + dos->e_lfanew);
  if (nt->Signature != IMAGE_NT_SIGNATURE
      || nt->FileHeader.Machine != kExpectedMachine
      || nt->FileHeader.TimeDateStamp != kExpectedTimestamp
      || nt->OptionalHeader.SizeOfImage != kExpectedSizeOfImage) {
    return false;
  }
  g_exe_base = reinterpret_cast<uintptr_t>(module);
  return true;
}

// V13 actively restores the old V11/V12 bypass if this module is hot-reloaded,
// then keeps the stock instruction untouched for the rest of the process.
bool EnsureStockComFrameLimiter() {
  if (g_stock_limiter_verified.load(std::memory_order_acquire)) return true;
  if (g_exe_base == 0u && !VerifyTargetBuild()) return false;
  auto* target = reinterpret_cast<uint8_t*>(g_exe_base + kComFrameMaxFpsReadRva);
  if (std::memcmp(target, kComFrameMaxFpsReadOriginal.data(), kComFrameMaxFpsReadOriginal.size()) == 0) {
    g_stock_limiter_verified.store(true, std::memory_order_release);
    return true;
  }
  if (std::memcmp(target, kOldExternalBypassBytes.data(), kOldExternalBypassBytes.size()) == 0) {
    if (!WriteExecutableBytes(target, kComFrameMaxFpsReadOriginal.data(), kComFrameMaxFpsReadOriginal.size())) {
      return false;
    }
    g_stock_limiter_verified.store(true, std::memory_order_release);
    LogInfo("[MW3 V36 Frame Pacing] restored MW3's native com_maxfps read at RVA 0x23D08C; engine simulation timing is stock again.");
    return true;
  }
  LogWarning("[MW3 V36 Frame Pacing] Com_Frame signature mismatch at RVA 0x23D08C; visible-frame limiter disabled for safety.");
  return false;
}

int ReadComMaxFps() {
  uintptr_t cached = g_com_maxfps_dvar.load(std::memory_order_acquire);
  if (cached != 0u) {
    return *reinterpret_cast<const volatile int*>(cached + 0x10u);
  }

  if (g_exe_base == 0u && !VerifyTargetBuild()) return 0;
  auto** dvar_slot = reinterpret_cast<uint8_t**>(g_exe_base + kComMaxFpsDvarPtrRva);
  if (!IsReadableRange(dvar_slot, sizeof(*dvar_slot))) return 0;
  uint8_t* dvar = *dvar_slot;
  if (!IsReadableRange(dvar, 0x14u)) return 0;
  g_com_maxfps_dvar.store(
      reinterpret_cast<uintptr_t>(dvar), std::memory_order_release);
  return *reinterpret_cast<const volatile int*>(dvar + 0x10u);
}

uint64_t QpcNow() {
  LARGE_INTEGER value = {};
  QueryPerformanceCounter(&value);
  return static_cast<uint64_t>(value.QuadPart);
}
uint64_t QpcFrequency() {
  if (g_limiter.qpc_frequency != 0u) return g_limiter.qpc_frequency;
  LARGE_INTEGER value = {};
  if (!QueryPerformanceFrequency(&value) || value.QuadPart <= 0) return 0u;
  g_limiter.qpc_frequency = static_cast<uint64_t>(value.QuadPart);
  return g_limiter.qpc_frequency;
}

void ResetLimiter() {
  g_limiter.next_deadline = 0.0;
  g_limiter.target_fps = 0;
  g_limiter.initialized = false;
  g_limiter.wake_error_us = 120.0;
}

HANDLE GetLimiterTimer() {
  if (g_limiter.timer != nullptr) return g_limiter.timer;
#ifndef CREATE_WAITABLE_TIMER_HIGH_RESOLUTION
#define CREATE_WAITABLE_TIMER_HIGH_RESOLUTION 0x00000002
#endif
  HANDLE timer = CreateWaitableTimerExW(nullptr, nullptr,
      CREATE_WAITABLE_TIMER_HIGH_RESOLUTION, TIMER_MODIFY_STATE | SYNCHRONIZE);
  if (timer == nullptr) timer = CreateWaitableTimerW(nullptr, FALSE, nullptr);
  g_limiter.timer = timer;
  return timer;
}

void LimitVisibleFrame(int target_fps) {
  if (target_fps <= 0 || target_fps > 1000) {
    ResetLimiter();
    return;
  }
  const uint64_t frequency = QpcFrequency();
  if (frequency == 0u) return;
  const double period_ticks = static_cast<double>(frequency) / static_cast<double>(target_fps);
  uint64_t now = QpcNow();
  auto& state = g_limiter;

  const bool reset = !state.initialized || state.target_fps != target_fps;
  state.next_deadline = mw3_frame_deadline::Advance(
      state.next_deadline, static_cast<double>(now), period_ticks, reset);
  state.initialized = true;
  state.target_fps = target_fps;


  if (state.next_deadline <= static_cast<double>(now)) return;

  mw3_precise_wait::Until(state.next_deadline, frequency, GetLimiterTimer(), state.wake_error_us);
}

void SetEnabled(bool enabled) {
  g_enabled.store(enabled, std::memory_order_release);
  if (enabled && !EnsureStockComFrameLimiter()) {
    g_enabled.store(false, std::memory_order_release);
  }
  if (!enabled) ResetLimiter();
}

void OnVisibleProxyPresent() {
  if (!g_enabled.load(std::memory_order_acquire)) return;
  if (!EnsureStockComFrameLimiter()) return;
  const int target_fps = ReadComMaxFps();
  if (target_fps <= 0) {
    ResetLimiter();
    return;
  }
  if (!g_logged_active.exchange(true, std::memory_order_acq_rel)) {
    LogInfo("[MW3 Adaptive Frame Pacing] visible proxy pacing active; adaptive timer + spin finish; late frames pass immediately; native com_maxfps retained.");
  }
  LimitVisibleFrame(target_fps);
}

void Shutdown() {
  g_enabled.store(false, std::memory_order_release);
  EnsureStockComFrameLimiter();
  g_com_maxfps_dvar.store(0u, std::memory_order_release);
  if (g_limiter.timer != nullptr) {
    CloseHandle(g_limiter.timer);
    g_limiter.timer = nullptr;
  }
  ResetLimiter();
  g_logged_active.store(false, std::memory_order_release);
}

}  // namespace mw3_smooth_frame_pacing

float mw3_smooth_frame_pacing_enabled = 1.f;
float mw3_iwd_stream_cache_mode = 1.f;
float mw3_crt_iwd_fast_read_enabled = 1.f;
float mw3_zlibng_iwd_inflate_enabled = 1.f;
float mw3_backend_sleep1_yield_enabled = 1.f;
float mw3_renderer_sleep1_precise_enabled = 1.f;
float mw3_renderer_wait1_precise_enabled = 1.f;
float mw3_archive_burst_wait_coalesce_enabled = 1.f;
float mw3_archive_thread_priority_boost_enabled = 1.f;
float mw3_preload_shaders_enabled = 1.f;

// ============================================================================
// V14 exact D3D9 query polling patches
// ============================================================================
namespace mw3_query_polling {
constexpr WORD kExpectedMachine = IMAGE_FILE_MACHINE_AMD64;
constexpr DWORD kExpectedTimestamp = 0x6A743A58u;
constexpr DWORD kExpectedSizeOfImage = 0x044BE000u;
constexpr std::array<uintptr_t, 5> kSafeRvas = {
    0x00186672u, 0x001E91EAu, 0x001E92A6u, 0x001E931Au, 0x001E9746u};
constexpr std::array<uintptr_t, 2> kRingRvas = {0x001BD696u, 0x001BE748u};
constexpr std::array<uint8_t, 10> kStock = {
    0x41,0xB9,0x01,0x00,0x00,0x00,0x45,0x8D,0x41,0x03};
constexpr std::array<uint8_t, 10> kNoFlush = {
    0x45,0x33,0xC9,0x41,0xB8,0x04,0x00,0x00,0x00,0x90};
inline uintptr_t g_base = 0u;
inline std::atomic<int> g_requested_mode{0};
inline std::atomic<int> g_applied_mode{-1};
inline std::atomic<bool> g_warned{false};

bool Verify() {
  auto* module = reinterpret_cast<uint8_t*>(GetModuleHandleW(nullptr));
  if (!module) return false;
  auto* dos = reinterpret_cast<IMAGE_DOS_HEADER*>(module);
  if (dos->e_magic != IMAGE_DOS_SIGNATURE || dos->e_lfanew <= 0) return false;
  auto* nt = reinterpret_cast<IMAGE_NT_HEADERS64*>(module + dos->e_lfanew);
  if (nt->Signature != IMAGE_NT_SIGNATURE || nt->FileHeader.Machine != kExpectedMachine
      || nt->FileHeader.TimeDateStamp != kExpectedTimestamp
      || nt->OptionalHeader.SizeOfImage != kExpectedSizeOfImage) return false;
  g_base = reinterpret_cast<uintptr_t>(module);
  return true;
}

bool WriteBytes(uintptr_t rva, const std::array<uint8_t,10>& wanted) {
  if (g_base == 0u && !Verify()) return false;
  auto* target = reinterpret_cast<uint8_t*>(g_base + rva);
  const bool known = std::memcmp(target,kStock.data(),kStock.size()) == 0
      || std::memcmp(target,kNoFlush.data(),kNoFlush.size()) == 0;
  if (!known) return false;
  if (std::memcmp(target,wanted.data(),wanted.size()) == 0) return true;
  DWORD oldp=0;
  if (!VirtualProtect(target,wanted.size(),PAGE_EXECUTE_READWRITE,&oldp)) return false;
  std::memcpy(target,wanted.data(),wanted.size());
  FlushInstructionCache(GetCurrentProcess(),target,wanted.size());
  DWORD ignored=0; VirtualProtect(target,wanted.size(),oldp,&ignored);
  return true;
}

bool Apply(int mode) {
  mode = std::clamp(mode,0,2);
  if (g_base == 0u && !Verify()) return false;
  bool ok=true;
  for (auto rva : kSafeRvas) ok &= WriteBytes(rva, mode >= 1 ? kNoFlush : kStock);
  for (auto rva : kRingRvas) ok &= WriteBytes(rva, mode >= 2 ? kNoFlush : kStock);
  if (!ok) {
    if (!g_warned.exchange(true,std::memory_order_acq_rel))
      reshade::log::message(reshade::log::level::warning,
          "[MW3 V14 Query Polling] one or more exact GetData signatures did not match; unknown sites were left untouched.");
    return false;
  }
  const int old=g_applied_mode.exchange(mode,std::memory_order_acq_rel);
  if (old != mode) {
    const char* text = mode == 0
      ? "[MW3 V14 Query Polling] stock D3DGETDATA_FLUSH restored at all 7 verified poll sites."
      : mode == 1
      ? "[MW3 V14 Query Polling] safe mode: 5 non-blocking query polls use GetData flags=0; renderer query-ring polls remain stock."
      : "[MW3 V14 Query Polling] aggressive mode: safe + 2 renderer query-ring polls use GetData flags=0.";
    reshade::log::message(reshade::log::level::info,text);
  }
  return true;
}
void SetRequestedMode(int mode) {
  // V15.1 profiler hardening: defer all code-byte changes until native D3D9 Present.
  g_requested_mode.store(std::clamp(mode,0,2),std::memory_order_release);
}
void Update() { int m=g_requested_mode.load(std::memory_order_acquire); if (g_applied_mode.load(std::memory_order_acquire)!=m) Apply(m); }
void ForceStockForTransition() { Apply(0); }
void Shutdown() { if (g_base!=0u) { for(auto r:kSafeRvas) WriteBytes(r,kStock); for(auto r:kRingRvas) WriteBytes(r,kStock); } g_applied_mode.store(-1,std::memory_order_release); }

} // namespace mw3_query_polling

float mw3_query_polling_mode = 0.f;

// ============================================================================
// V14 blocking D3D9 event-query retry yield
// ============================================================================
//
// A verified x64 event-query path retries IDirect3DQuery9::GetData while the
// real result is still S_FALSE. Older experiments proved there is a 12-byte
// alignment cave that can safely route the retry through the engine's Sleep
// thunk before looping back. V14 uses Sleep(0), not Sleep(1): this yields the
// CPU to a runnable renderer/driver thread without adding a coarse millisecond
// delay. Query completion is never faked and D3DGETDATA_FLUSH remains intact
// for this genuinely blocking path.
namespace mw3_blocking_query_yield {

constexpr WORD kExpectedMachine = IMAGE_FILE_MACHINE_AMD64;
constexpr DWORD kExpectedTimestamp = 0x6A743A58u;
constexpr DWORD kExpectedSizeOfImage = 0x044BE000u;
constexpr uintptr_t kCaveRva = 0x001DAE54u;
constexpr uintptr_t kBranchRva = 0x001DAE9Fu;

constexpr std::array<uint8_t, 12> kCaveStock = {
    0xCC,0xCC,0xCC,0xCC,0xCC,0xCC,0xCC,0xCC,0xCC,0xCC,0xCC,0xCC};
constexpr std::array<uint8_t, 12> kCaveYield1 = {
    0xB9,0x01,0x00,0x00,0x00,0xE8,0xB2,0xF5,0x06,0x00,0xEB,0x14};
constexpr std::array<uint8_t, 12> kCaveYield0 = {
    0xB9,0x00,0x00,0x00,0x00,0xE8,0xB2,0xF5,0x06,0x00,0xEB,0x14};
constexpr std::array<uint8_t, 2> kBranchStock = {0x74,0xD3};
constexpr std::array<uint8_t, 2> kBranchYield = {0x74,0xB3};

inline uintptr_t g_base = 0u;
inline std::atomic<bool> g_enabled{true};
inline std::atomic<int> g_applied{-1};
inline std::atomic<bool> g_warned{false};

bool Verify() {
  auto* module = reinterpret_cast<uint8_t*>(GetModuleHandleW(nullptr));
  if (module == nullptr) return false;
  auto* dos = reinterpret_cast<IMAGE_DOS_HEADER*>(module);
  if (dos->e_magic != IMAGE_DOS_SIGNATURE || dos->e_lfanew <= 0) return false;
  auto* nt = reinterpret_cast<IMAGE_NT_HEADERS64*>(module + dos->e_lfanew);
  if (nt->Signature != IMAGE_NT_SIGNATURE
      || nt->FileHeader.Machine != kExpectedMachine
      || nt->FileHeader.TimeDateStamp != kExpectedTimestamp
      || nt->OptionalHeader.SizeOfImage != kExpectedSizeOfImage) {
    return false;
  }
  g_base = reinterpret_cast<uintptr_t>(module);
  return true;
}

template <size_t N>
bool WriteKnown(
    uintptr_t rva,
    const std::array<uint8_t, N>& wanted,
    std::initializer_list<const std::array<uint8_t, N>*> known) {
  if (g_base == 0u && !Verify()) return false;
  auto* target = reinterpret_cast<uint8_t*>(g_base + rva);
  bool is_known = false;
  for (const auto* bytes : known) {
    if (bytes != nullptr
        && std::memcmp(target, bytes->data(), bytes->size()) == 0) {
      is_known = true;
      break;
    }
  }
  if (!is_known) return false;
  if (std::memcmp(target, wanted.data(), wanted.size()) == 0) return true;

  DWORD old_protect = 0u;
  if (!VirtualProtect(
          target, wanted.size(), PAGE_EXECUTE_READWRITE, &old_protect)) {
    return false;
  }
  std::memcpy(target, wanted.data(), wanted.size());
  FlushInstructionCache(GetCurrentProcess(), target, wanted.size());
  DWORD ignored = 0u;
  VirtualProtect(target, wanted.size(), old_protect, &ignored);
  return true;
}

bool Apply(bool enabled) {
  if (g_base == 0u && !Verify()) return false;

  bool ok = true;
  if (enabled) {
    // Write the cave first; the original branch still cannot reach it.
    ok &= WriteKnown(
        kCaveRva,
        kCaveYield0,
        {&kCaveStock, &kCaveYield0, &kCaveYield1});
    if (ok) {
      ok &= WriteKnown(
          kBranchRva,
          kBranchYield,
          {&kBranchStock, &kBranchYield});
    }
  } else {
    // Stop routing into the cave first, then restore the unused cave bytes.
    ok &= WriteKnown(
        kBranchRva,
        kBranchStock,
        {&kBranchStock, &kBranchYield});
    if (ok) {
      ok &= WriteKnown(
          kCaveRva,
          kCaveStock,
          {&kCaveStock, &kCaveYield0, &kCaveYield1});
    }
  }

  if (!ok) {
    if (!g_warned.exchange(true, std::memory_order_acq_rel)) {
      reshade::log::message(
          reshade::log::level::warning,
          "[MW3 V14 Query Yield] exact blocking-query signature mismatch; retry loop left unchanged.");
    }
    return false;
  }

  const int wanted = enabled ? 1 : 0;
  const int old = g_applied.exchange(wanted, std::memory_order_acq_rel);
  if (old != wanted) {
    reshade::log::message(
        reshade::log::level::info,
        enabled
            ? "[MW3 V14 Query Yield] blocking GetData S_FALSE retry now yields with Sleep(0); real GPU completion and FLUSH semantics are preserved."
            : "[MW3 V14 Query Yield] blocking GetData retry restored to stock tight loop.");
  }
  return true;
}

void SetEnabled(bool enabled) {
  // V15.1 profiler hardening: defer the optional code-cave/branch patch until
  // native D3D9 Present. Default is stock/off in the profiler build.
  g_enabled.store(enabled, std::memory_order_release);
}

void Update() {
  const bool enabled = g_enabled.load(std::memory_order_acquire);
  const int wanted = enabled ? 1 : 0;
  if (g_applied.load(std::memory_order_acquire) != wanted) {
    Apply(enabled);
  }
}

void ForceStockForTransition() {
  Apply(false);
}

void Shutdown() {
  if (g_base != 0u) {
    Apply(false);
  }
  g_applied.store(-1, std::memory_order_release);
}

}  // namespace mw3_blocking_query_yield

float mw3_blocking_query_yield_enabled = 0.f;

// ============================================================================
// V14 RenoDX HDR proxy queue latency
// ============================================================================
namespace mw3_proxy_latency {
inline std::atomic<int> g_mode{1}; // 0=DXGI default(3), 1=1 frame, 2=2 frames
inline std::atomic<uintptr_t> g_last_device{0u};
inline std::atomic<int> g_last_latency{-1};
inline std::atomic<bool> g_warned{false};

int RequestedLatency() {
  const int mode=std::clamp(g_mode.load(std::memory_order_acquire),0,2);
  return mode==0 ? 3 : mode;
}
void SetMode(int mode) { g_mode.store(std::clamp(mode,0,2),std::memory_order_release); g_last_latency.store(-1,std::memory_order_release); }
void Update(reshade::api::device* device) {
  if (device == nullptr || device->get_api()!=reshade::api::device_api::d3d11) return;
  auto* native=reinterpret_cast<ID3D11Device*>(device->get_native());
  if (native==nullptr) return;
  const uintptr_t key=reinterpret_cast<uintptr_t>(native);
  const int latency=RequestedLatency();
  if (g_last_device.load(std::memory_order_acquire)==key
      && g_last_latency.load(std::memory_order_acquire)==latency) return;
  IDXGIDevice1* dxgi=nullptr;
  const HRESULT qi=native->QueryInterface(__uuidof(IDXGIDevice1),reinterpret_cast<void**>(&dxgi));
  if (FAILED(qi) || dxgi==nullptr) {
    if (!g_warned.exchange(true,std::memory_order_acq_rel))
      reshade::log::message(reshade::log::level::warning,"[MW3 V14 Proxy] IDXGIDevice1 unavailable; frame-latency queue left unchanged.");
    return;
  }
  const HRESULT hr=dxgi->SetMaximumFrameLatency(static_cast<UINT>(latency));
  dxgi->Release();
  if (FAILED(hr)) {
    if (!g_warned.exchange(true,std::memory_order_acq_rel))
      reshade::log::message(reshade::log::level::warning,"[MW3 V14 Proxy] SetMaximumFrameLatency failed; proxy queue left unchanged.");
    return;
  }
  g_last_device.store(key,std::memory_order_release);
  g_last_latency.store(latency,std::memory_order_release);
  char msg[160] = {};
  std::snprintf(msg,sizeof(msg),"[MW3 V14 Proxy] D3D11 HDR proxy maximum frame latency = %d.",latency);
  reshade::log::message(reshade::log::level::info,msg);
}
void Shutdown() { g_last_device.store(0u,std::memory_order_release); g_last_latency.store(-1,std::memory_order_release); }
} // namespace mw3_proxy_latency

float mw3_proxy_latency_mode = 1.f;
float mw3_streamed_audio_pretouch = 0.f;
float mw3_native_fps_limit = 120.f;
std::atomic<int> g_mw3_audio_pretouch_applied{-1};
std::atomic<int> g_mw3_preload_shaders_applied{-1};
std::atomic<int> g_mw3_native_fps_limit_applied{-1};

float cod_high_polling_mouse_fix = 1.f;

// Track the ReShade overlay through the add-on API instead of calling
// ImGui::GetCurrentContext() from Present. The RenoDX target does not export
// that ImGui symbol, which caused an lld-link failure in the full-smoothness
// builds. Returning false preserves ReShade's normal open/close behavior.
std::atomic<bool> g_reshade_overlay_open{false};

bool OnReShadeOpenOverlay(
    reshade::api::effect_runtime* runtime,
    bool open,
    reshade::api::input_source source) {
  (void)runtime;
  (void)source;
  g_reshade_overlay_open.store(open, std::memory_order_release);
  return false;
}


void MW3MicrostutterLog(
    mw3_microstutter::LogLevel level,
    const char* message) {
  reshade::log::message(
      level == mw3_microstutter::LogLevel::Warning
          ? reshade::log::level::warning
          : reshade::log::level::info,
      message != nullptr ? message : "[MW3 Microstutter V8] (null log message)");
}

#define UpgradeRTVReplaceShader(value)       \
  {                                          \
      value,                                 \
      {                                      \
          .crc32 = value,                    \
          .code = __##value,                 \
          .on_draw = [](auto* cmd_list) {                                                             \
            auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                         \
            bool changed = false;                                                                     \
            for (auto rtv : rtvs) {                                                                   \
              changed |= renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv);   \
            }                                                                                         \
            if (changed) {                                                                            \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                    \
              renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0}); \
            }                                                                                         \
            return true; }, \
      },                                     \
  }

#define UpgradeRTVShader(value)              \
  {                                          \
      value,                                 \
      {                                      \
          .crc32 = value,                    \
          .on_draw = [](auto* cmd_list) {                                                           \
            auto rtvs = renodx::utils::swapchain::GetRenderTargets(cmd_list);                       \
            bool changed = false;                                                                   \
            for (auto rtv : rtvs) {                                                                 \
              changed |= renodx::mods::swapchain::ActivateCloneHotSwap(cmd_list->get_device(), rtv); \
            }                                                                                       \
            if (changed) {                                                                          \
              renodx::mods::swapchain::FlushDescriptors(cmd_list);                                  \
              renodx::mods::swapchain::RewriteRenderTargets(cmd_list, rtvs.size(), rtvs.data(), {0});      \
            }                                                                                       \
            return true; }, \
      },                                     \
  }
renodx::mods::shader::CustomShaders custom_shaders = {
    // CustomShaderEntry(0x00000000),
    // CustomSwapchainShader(0x00000000),
    // BypassShaderEntry(0x00000000),
    __ALL_CUSTOM_SHADERS,
    
};

ShaderInjectData shader_injection;

float current_settings_mode = 0;
#if 0  // Automatic DX9 output unclamper disabled
float dx9_auto_output_unclamp_mode = 2.f;
#endif
float force_windowed_borderless = 1.f;

constexpr float TONE_MAP_TYPE_VANILLA = 0.f;
constexpr float TONE_MAP_TYPE_RENODRT = 3.f;
constexpr float TONE_MAP_TYPE_PSYCHOV24 = 24.f;

inline bool IsCustomToneMapperEnabled() {
  return shader_injection.tone_map_type != TONE_MAP_TYPE_VANILLA;
}

inline bool IsRenoDRTEnabled() {
  return shader_injection.tone_map_type == TONE_MAP_TYPE_RENODRT;
}

inline bool IsPsychoV24Enabled() {
  return shader_injection.tone_map_type == TONE_MAP_TYPE_PSYCHOV24;
}

void ApplySwapChainEncoding(float value) {
  const bool is_hdr10 = value == 4.f;

  renodx::mods::swapchain::SetUseHDR10(is_hdr10);
  renodx::mods::swapchain::use_resize_buffer = value < 4.f;
  shader_injection.swap_chain_encoding_color_space = is_hdr10 ? 1.f : 0.f;
}


#if 0  // Automatic DX9 output unclamper disabled; CPU blit/readback remains enabled
// ============================================================================
// Guarded D3D9 terminal output unclamping
// ============================================================================
//
// A terminal sqrt(saturate(...)) sequence is not enough to prove that a shader
// writes final scene color. BO1 uses the same encoding pattern in surface,
// character, weapon, fog, sky, shadow-adjacent, and packed/intermediate passes.
// Blindly patching all matches can expose black skybox borders, remove fog
// masking, flatten object shading, or corrupt packed textures.
//
// Fog/sky hashes are therefore hard-blocked in every mode. Curated post-process
// shaders retain the original full unclamp. Explicitly known weapon/viewmodel
// lighting shaders also receive the full terminal unclamp: their earlier
// material, normal, shadow, attenuation, and visibility saturations remain
// untouched, so only the final HDR ceiling is removed.
//
// Level 3 applies the same terminal-only highlight unclamp as the supplied
// weapon HLSL examples to every accepted viewmodel and world geometry-lighting
// shader:
//
//   sqrt(saturate(finalLighting)) -> sqrt(max(finalLighting, 0))
//
// No brightness multiplier is added, and no earlier material, texture, BRDF,
// shadow, attenuation, fog, color, or intermediate saturation is changed.
// Simple fog, sky, copy, LUT, and blend-only shaders are rejected. Level 4 is a
// safe alias of level 3 instead of enabling a broader destructive scan.
//
// Supported terminal forms:
//
//   1. sqrt(saturate(rgb)) output chains:
//
//        mul_sat r0.xyz, ...
//        rsq     r0.x, r0.x
//        rsq     r0.y, r0.y
//        rsq     r0.z, r0.z
//        rcp     oC0.x, r0.x
//        rcp     oC0.y, r0.y
//        rcp     oC0.z, r0.z
//
//      becomes the bytecode equivalent of:
//
//        rgb = original_expression;
//        rgb = max(rgb, 0.0f);
//        output = sqrt(rgb);
//
//   2. A direct final RGB _sat write to oC0.xyz. The original instruction is
//      redirected through a free temporary register, then max(rgb, 0) is
//      written to oC0.xyz.
//
// The lower zero bound is deliberately retained. Blindly clearing _sat before
// an rsq/rcp square-root sequence would allow negative values to create NaNs.
//
// The patch runs after RenoDX's normal shader replacement hook is registered,
// so embedded hash-based replacements are processed first. The patched shader
// bytecode is cached for the lifetime of the addon.

constexpr uint32_t DX9_AUTO_UNCLAMP_OFF = 0u;
constexpr uint32_t DX9_AUTO_UNCLAMP_CURATED_POST_SKY = 1u;
constexpr uint32_t DX9_AUTO_UNCLAMP_CURATED_WITH_MODEL = 2u;
constexpr uint32_t DX9_AUTO_UNCLAMP_HEURISTIC_SQRT = 3u;
constexpr uint32_t DX9_AUTO_UNCLAMP_HEURISTIC_ALL = 4u;

constexpr uint32_t DX9_PS_3_0_VERSION = 0xFFFF0300u;
constexpr uint32_t DX9_SHADER_END = 0x0000FFFFu;
constexpr uint32_t DX9_SHADER_COMMENT_OPCODE = 0x0000FFFEu;
constexpr uint32_t DX9_OPCODE_MASK = 0x0000FFFFu;
constexpr uint32_t DX9_INSTRUCTION_LENGTH_MASK = 0x0F000000u;
constexpr uint32_t DX9_INSTRUCTION_LENGTH_SHIFT = 24u;
constexpr uint32_t DX9_COMMENT_LENGTH_MASK = 0x7FFF0000u;
constexpr uint32_t DX9_COMMENT_LENGTH_SHIFT = 16u;
constexpr uint32_t DX9_INSTRUCTION_PREDICATED = 0x10000000u;

constexpr uint32_t DX9_PARAMETER_TOKEN = 0x80000000u;
constexpr uint32_t DX9_REGISTER_NUMBER_MASK = 0x000007FFu;
constexpr uint32_t DX9_REGISTER_TYPE_MASK = 0x70001800u;
constexpr uint32_t DX9_WRITE_MASK_MASK = 0x000F0000u;
constexpr uint32_t DX9_WRITE_MASK_SHIFT = 16u;
constexpr uint32_t DX9_DEST_MODIFIER_MASK = 0x00F00000u;
constexpr uint32_t DX9_DEST_SATURATE = 0x00100000u;
constexpr uint32_t DX9_DEST_PARTIAL_PRECISION = 0x00200000u;
constexpr uint32_t DX9_SOURCE_SWIZZLE_MASK = 0x00FF0000u;
constexpr uint32_t DX9_SOURCE_SWIZZLE_SHIFT = 16u;
constexpr uint32_t DX9_SOURCE_MODIFIER_MASK = 0x0F000000u;

constexpr uint32_t DX9_REGISTER_TEMP = 0u;
constexpr uint32_t DX9_REGISTER_INPUT = 1u;
constexpr uint32_t DX9_REGISTER_COLOR_OUTPUT = 8u;
constexpr uint32_t DX9_REGISTER_SAMPLER = 10u;

constexpr uint32_t DX9_DCL_USAGE_MASK = 0x0000001Fu;
constexpr uint32_t DX9_DCL_USAGE_INDEX_MASK = 0x000F0000u;
constexpr uint32_t DX9_DCL_USAGE_INDEX_SHIFT = 16u;
constexpr uint32_t DX9_DECL_USAGE_TEXCOORD = 5u;
constexpr uint32_t DX9_DECL_USAGE_COLOR = 10u;

constexpr uint16_t DX9_OP_MOV = 1u;
constexpr uint16_t DX9_OP_ADD = 2u;
constexpr uint16_t DX9_OP_SUB = 3u;
constexpr uint16_t DX9_OP_MAD = 4u;
constexpr uint16_t DX9_OP_MUL = 5u;
constexpr uint16_t DX9_OP_RCP = 6u;
constexpr uint16_t DX9_OP_RSQ = 7u;
constexpr uint16_t DX9_OP_DP3 = 8u;
constexpr uint16_t DX9_OP_DP4 = 9u;
constexpr uint16_t DX9_OP_MIN = 10u;
constexpr uint16_t DX9_OP_MAX = 11u;
constexpr uint16_t DX9_OP_LRP = 18u;
constexpr uint16_t DX9_OP_DCL = 31u;
constexpr uint16_t DX9_OP_DEFB = 47u;
constexpr uint16_t DX9_OP_DEFI = 48u;
constexpr uint16_t DX9_OP_TEXLD = 66u;
constexpr uint16_t DX9_OP_DEF = 81u;
constexpr uint16_t DX9_OP_CMP = 88u;

constexpr uint32_t DX9_WRITE_X = 0x1u;
constexpr uint32_t DX9_WRITE_Y = 0x2u;
constexpr uint32_t DX9_WRITE_Z = 0x4u;
constexpr uint32_t DX9_WRITE_W = 0x8u;
constexpr uint32_t DX9_WRITE_RGB = 0x7u;

constexpr uint32_t DX9_SWIZZLE_X = 0x00u;
constexpr uint32_t DX9_SWIZZLE_Y = 0x55u;
constexpr uint32_t DX9_SWIZZLE_Z = 0xAAu;
constexpr uint32_t DX9_SWIZZLE_W = 0xFFu;
constexpr uint32_t DX9_SWIZZLE_XYZW = 0xE4u;

// Known final post-process output shaders. Sky/cloud entries are intentionally
// excluded: unclamping them can reveal black texture borders or defeat fog masks.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_POST_ALLOWLIST = {
    0x1167C22Au,
    0x23B35169u,
    0x357DE7FDu,
    0x59760569u,
    0x706435ADu,
    0x70F19652u,
    0x783482DEu,
    0x79E32AF8u,
    0x81444CACu,
    0x88954051u,
    0x8F5D2EFFu,
    0x93610C4Cu,  // LUT pass: strict matcher currently leaves it unchanged.
    0xC9558BEFu,
    0xCAB1BCB8u,
};

// Exact known weapon/viewmodel-lighting shaders available to the curated model
// mode. These receive the full terminal unclamp rather than the guarded scanner
// path. Only the final output saturation is removed; all earlier BRDF, shadow,
// attenuation, fog, and material masks stay exactly as authored by the game.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_MODEL_ALLOWLIST = {
    0xBACB9CF2u,  // Weapon/viewmodel spotlight lighting.
    0xCDCD3EAEu,  // Related weapon/viewmodel lighting variant.
};

// Exact weapon/viewmodel examples that must be fully unclamped by level 3.
// These shaders end with the equivalent of:
//
//   output = sqrt(saturate(finalLighting * hdrControl.x));
//
// Level 3 rewrites only that terminal expression to:
//
//   output = sqrt(max(finalLighting * hdrControl.x, 0));
//
// This is the same transformation used by the supplied HLSL examples. It does
// not remove any earlier material, normal, shadow, attenuation, fog, or BRDF
// clamps. Exact hashes bypass the guarded geometry reconstruction.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_LEVEL3_VIEWMODEL_ALLOWLIST = {
    0x44B59D36u,  // weapon2: final mul_sat + sqrt output.
    0xBACB9CF2u,  // weapon1: final mul_sat + sqrt output.
    0xCDCD3EAEu,  // related weapon/viewmodel lighting variant.
    0xE07AC027u,  // weapon3: final mul_sat + sqrt output.
};

// Known sky/cloud passes enabled only for the level-3/4 sky test. They remain
// blocked in curated modes and are still limited to the strict terminal sqrt
// rewrite; direct oC0 rewrites remain disabled for them.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_LEVEL3_SKY_TEST_ALLOWLIST = {
    0x94BC7D3Eu,
    0xDAC6E2D9u,
};

// Add confirmed fog, packed-data, or special-effect hashes here. The two known
// sky hashes above are intentionally not in this permanent denylist so level 3
// can test them through the strict terminal-only path.
const std::unordered_set<uint32_t> DX9_AUTO_UNCLAMP_DENYLIST = {
    // 0x00000000u,
};

bool DX9AutoUnclampModeAllowsHash(uint32_t mode, uint32_t hash) {
  if (DX9_AUTO_UNCLAMP_DENYLIST.contains(hash)) return false;
  if (DX9_AUTO_UNCLAMP_LEVEL3_SKY_TEST_ALLOWLIST.contains(hash)
      && mode < DX9_AUTO_UNCLAMP_HEURISTIC_SQRT) {
    return false;
  }

  switch (mode) {
    case DX9_AUTO_UNCLAMP_CURATED_POST_SKY:
      return DX9_AUTO_UNCLAMP_POST_ALLOWLIST.contains(hash);

    case DX9_AUTO_UNCLAMP_CURATED_WITH_MODEL:
      return DX9_AUTO_UNCLAMP_POST_ALLOWLIST.contains(hash)
          || DX9_AUTO_UNCLAMP_MODEL_ALLOWLIST.contains(hash);

    case DX9_AUTO_UNCLAMP_HEURISTIC_SQRT:
    case DX9_AUTO_UNCLAMP_HEURISTIC_ALL:
      return true;

    default:
      return false;
  }
}

bool DX9AutoUnclampModeAllowsDirectOutput(uint32_t mode, uint32_t hash) {
  (void)mode;
  if (DX9_AUTO_UNCLAMP_DENYLIST.contains(hash)) return false;

  // A broad direct oC0 saturation rewrite can remove material/fog masks and was
  // responsible for the flat, unshaded appearance in the old level 4. Keep this
  // path strictly hash-curated in every mode. Automatic scanning is limited to
  // terminal sqrt chains, where only the final highlight ceiling is touched.
  return DX9_AUTO_UNCLAMP_POST_ALLOWLIST.contains(hash);
}

enum class DX9AutoUnclampPatchKind : uint32_t {
  NONE = 0u,
  SQRT_OUTPUT,
  SQRT_OUTPUT_GUARDED,
  DIRECT_OUTPUT,
};

struct DX9InstructionInfo {
  size_t token_offset = 0u;
  uint16_t opcode = 0u;
  uint8_t operand_count = 0u;
  uint32_t instruction_token = 0u;
};

struct DX9ShaderStats {
  uint32_t texture_samples = 0u;
  uint32_t dot_products = 0u;
  uint32_t multiplies = 0u;
  uint32_t multiply_adds = 0u;
  uint32_t adds = 0u;
  uint32_t lerps = 0u;
  uint32_t compares = 0u;

  uint32_t input_declarations = 0u;
  uint32_t texcoord_declaration_mask = 0u;
  uint32_t sampler_declaration_mask = 0u;
  bool declares_color0 = false;
};

struct DX9AutoUnclampPlan {
  DX9AutoUnclampPatchKind kind = DX9AutoUnclampPatchKind::NONE;
  size_t instruction_index = 0u;
  std::array<uint32_t, 2u> free_temps = {0u, 0u};
  uint32_t free_temp_count = 0u;
};

struct DX9CachedAutoUnclampShader {
  uint32_t source_crc32 = 0u;
  size_t source_size = 0u;
  DX9AutoUnclampPatchKind kind = DX9AutoUnclampPatchKind::NONE;
  std::vector<uint32_t> bytecode;
};

std::mutex g_dx9_auto_unclamp_mutex;
std::unordered_map<uint64_t, DX9CachedAutoUnclampShader>
    g_dx9_auto_unclamp_cache;
uint32_t g_dx9_auto_unclamp_sqrt_count = 0u;
uint32_t g_dx9_auto_unclamp_guarded_count = 0u;
uint32_t g_dx9_auto_unclamp_direct_count = 0u;
uint32_t g_dx9_auto_unclamp_log_count = 0u;

uint32_t DX9GetRegisterType(uint32_t token) {
  return ((token >> 28u) & 0x7u) | ((token >> 8u) & 0x18u);
}

uint32_t DX9GetRegisterNumber(uint32_t token) {
  return token & DX9_REGISTER_NUMBER_MASK;
}

uint32_t DX9GetWriteMask(uint32_t token) {
  return (token & DX9_WRITE_MASK_MASK) >> DX9_WRITE_MASK_SHIFT;
}

uint32_t DX9GetSourceSwizzle(uint32_t token) {
  return (token & DX9_SOURCE_SWIZZLE_MASK) >> DX9_SOURCE_SWIZZLE_SHIFT;
}

uint32_t DX9EncodeRegisterType(uint32_t type) {
  return ((type & 0x7u) << 28u) | ((type & 0x18u) << 8u);
}

uint32_t DX9SetRegister(uint32_t token, uint32_t type, uint32_t number) {
  token &= ~(DX9_REGISTER_TYPE_MASK | DX9_REGISTER_NUMBER_MASK);
  token |= DX9_PARAMETER_TOKEN;
  token |= DX9EncodeRegisterType(type);
  token |= number & DX9_REGISTER_NUMBER_MASK;
  return token;
}

uint32_t DX9MakeInstruction(uint16_t opcode, uint32_t operand_count) {
  return static_cast<uint32_t>(opcode)
      | ((operand_count << DX9_INSTRUCTION_LENGTH_SHIFT)
         & DX9_INSTRUCTION_LENGTH_MASK);
}

uint32_t DX9MakeTempDest(
    uint32_t register_number,
    uint32_t write_mask,
    bool partial_precision) {
  uint32_t token = DX9_PARAMETER_TOKEN;
  token |= DX9EncodeRegisterType(DX9_REGISTER_TEMP);
  token |= register_number & DX9_REGISTER_NUMBER_MASK;
  token |= (write_mask << DX9_WRITE_MASK_SHIFT) & DX9_WRITE_MASK_MASK;
  if (partial_precision) token |= DX9_DEST_PARTIAL_PRECISION;
  return token;
}

uint32_t DX9MakeTempSource(
    uint32_t register_number,
    uint32_t swizzle = DX9_SWIZZLE_XYZW) {
  uint32_t token = DX9_PARAMETER_TOKEN;
  token |= DX9EncodeRegisterType(DX9_REGISTER_TEMP);
  token |= register_number & DX9_REGISTER_NUMBER_MASK;
  token |= (swizzle << DX9_SOURCE_SWIZZLE_SHIFT)
      & DX9_SOURCE_SWIZZLE_MASK;
  return token;
}

bool DX9OpcodeMayHaveSaturatedColorDestination(uint16_t opcode) {
  switch (opcode) {
    case DX9_OP_MOV:
    case DX9_OP_ADD:
    case DX9_OP_SUB:
    case DX9_OP_MAD:
    case DX9_OP_MUL:
    case DX9_OP_DP3:
    case DX9_OP_DP4:
    case DX9_OP_MIN:
    case DX9_OP_MAX:
    case DX9_OP_LRP:
    case DX9_OP_TEXLD:
    case DX9_OP_CMP:
      return true;
    default:
      return false;
  }
}

bool DX9ParseShader(
    const uint32_t* tokens,
    size_t token_count,
    std::vector<DX9InstructionInfo>& instructions) {
  instructions.clear();

  if (tokens == nullptr || token_count < 2u) return false;
  if (tokens[0] != DX9_PS_3_0_VERSION) return false;

  size_t token_offset = 1u;
  while (token_offset < token_count) {
    const uint32_t instruction_token = tokens[token_offset];
    const uint16_t opcode =
        static_cast<uint16_t>(instruction_token & DX9_OPCODE_MASK);

    if (opcode == static_cast<uint16_t>(DX9_SHADER_END)) {
      instructions.push_back({
          .token_offset = token_offset,
          .opcode = opcode,
          .operand_count = 0u,
          .instruction_token = instruction_token,
      });
      return true;
    }

    if (opcode == static_cast<uint16_t>(DX9_SHADER_COMMENT_OPCODE)) {
      const size_t comment_dwords =
          (instruction_token & DX9_COMMENT_LENGTH_MASK)
          >> DX9_COMMENT_LENGTH_SHIFT;
      if (token_offset + 1u + comment_dwords > token_count) return false;
      token_offset += 1u + comment_dwords;
      continue;
    }

    const uint32_t operand_count =
        (instruction_token & DX9_INSTRUCTION_LENGTH_MASK)
        >> DX9_INSTRUCTION_LENGTH_SHIFT;
    if (token_offset + 1u + operand_count > token_count) return false;

    instructions.push_back({
        .token_offset = token_offset,
        .opcode = opcode,
        .operand_count = static_cast<uint8_t>(operand_count),
        .instruction_token = instruction_token,
    });

    token_offset += 1u + operand_count;
  }

  return false;
}

DX9ShaderStats DX9CollectShaderStats(
    const uint32_t* tokens,
    const std::vector<DX9InstructionInfo>& instructions) {
  DX9ShaderStats stats = {};

  for (const auto& instruction : instructions) {
    switch (instruction.opcode) {
      case DX9_OP_TEXLD:
        ++stats.texture_samples;
        break;
      case DX9_OP_DP3:
      case DX9_OP_DP4:
        ++stats.dot_products;
        break;
      case DX9_OP_MUL:
        ++stats.multiplies;
        break;
      case DX9_OP_MAD:
        ++stats.multiply_adds;
        break;
      case DX9_OP_ADD:
      case DX9_OP_SUB:
        ++stats.adds;
        break;
      case DX9_OP_LRP:
        ++stats.lerps;
        break;
      case DX9_OP_CMP:
        ++stats.compares;
        break;
      case DX9_OP_DCL:
        if (tokens != nullptr && instruction.operand_count >= 2u) {
          const uint32_t usage_token =
              tokens[instruction.token_offset + 1u];
          const uint32_t register_token =
              tokens[instruction.token_offset + 2u];
          const uint32_t register_type = DX9GetRegisterType(register_token);
          const uint32_t register_number = DX9GetRegisterNumber(register_token);

          if (register_type == DX9_REGISTER_INPUT) {
            ++stats.input_declarations;

            const uint32_t usage = usage_token & DX9_DCL_USAGE_MASK;
            const uint32_t usage_index =
                (usage_token & DX9_DCL_USAGE_INDEX_MASK)
                >> DX9_DCL_USAGE_INDEX_SHIFT;

            if (usage == DX9_DECL_USAGE_TEXCOORD && usage_index < 32u) {
              stats.texcoord_declaration_mask |= 1u << usage_index;
            } else if (usage == DX9_DECL_USAGE_COLOR && usage_index == 0u) {
              stats.declares_color0 = true;
            }
          } else if (
              register_type == DX9_REGISTER_SAMPLER
              && register_number < 32u) {
            stats.sampler_declaration_mask |= 1u << register_number;
          }
        }
        break;
      default:
        break;
    }
  }

  return stats;
}

bool DX9HasDeclaredSampler(
    const DX9ShaderStats& stats,
    uint32_t sampler_register) {
  return sampler_register < 32u
      && (stats.sampler_declaration_mask & (1u << sampler_register)) != 0u;
}

bool DX9HasMaterialLightingSignature(const DX9ShaderStats& stats) {
  // BO1 material shaders normally expose at least one of these slots:
  //   s1 = normal map, s2 = shadow map, s4 = specular map.
  // Viewmodels additionally tend to use s11/s15, handled separately below.
  return DX9HasDeclaredSampler(stats, 1u)
      || DX9HasDeclaredSampler(stats, 2u)
      || DX9HasDeclaredSampler(stats, 4u);
}

bool DX9LooksLikeSkyFogOrUtility(
    const DX9ShaderStats& stats,
    const DX9InstructionInfo& terminal_candidate,
    size_t instruction_count) {
  const bool has_texcoord8 =
      (stats.texcoord_declaration_mask & (1u << 8u)) != 0u;
  const bool has_model_lighting = DX9HasDeclaredSampler(stats, 11u);
  const bool has_reflection_probe = DX9HasDeclaredSampler(stats, 15u);

  // A confirmed BO1 viewmodel declaration signature always wins over the
  // structural sky filter. Some weapon variants use only one of s11/s15.
  if (has_texcoord8 && (has_model_lighting || has_reflection_probe)) {
    return false;
  }

  // Normal/shadow/specular resources are strong evidence of material lighting.
  if (DX9HasMaterialLightingSignature(stats)) return false;

  const uint32_t lighting_math =
      stats.multiplies + stats.multiply_adds + stats.adds;

  // Copy, LUT, fog-composite and many sky/cloud passes commonly end in these
  // operations. They must not enter an automatic unclamp path.
  if (terminal_candidate.opcode == DX9_OP_TEXLD
      || terminal_candidate.opcode == DX9_OP_LRP
      || terminal_candidate.opcode == DX9_OP_CMP) {
    return true;
  }

  // No dot-product lighting means the terminal saturation is much more likely
  // to be a mask, fog/sky blend, UI/effect value or packed intermediate.
  if (stats.dot_products == 0u) return true;

  // Reject lightweight non-material shaders. This catches unknown sky variants
  // even when their hash is not yet in the hard denylist.
  if (stats.texture_samples <= 2u
      && stats.dot_products <= 2u
      && lighting_math < 12u) {
    return true;
  }

  if (instruction_count < 24u && lighting_math < 10u) return true;

  return false;
}

bool DX9LooksLikeAdditionalSkyShader(
    const DX9ShaderStats& stats,
    const DX9InstructionInfo& terminal_candidate,
    size_t instruction_count) {
  const bool has_texcoord8 =
      (stats.texcoord_declaration_mask & (1u << 8u)) != 0u;
  const bool has_model_lighting = DX9HasDeclaredSampler(stats, 11u);
  const bool has_reflection_probe = DX9HasDeclaredSampler(stats, 15u);

  // Never classify likely viewmodels as sky.
  if (has_texcoord8 && (has_model_lighting || has_reflection_probe)) {
    return false;
  }

  // Never classify ordinary material lighting as sky.
  if (DX9HasMaterialLightingSignature(stats)) return false;

  // Restrict the broad sky path to arithmetic-produced highlight outputs.
  if (terminal_candidate.opcode != DX9_OP_MUL
      && terminal_candidate.opcode != DX9_OP_MAD
      && terminal_candidate.opcode != DX9_OP_ADD
      && terminal_candidate.opcode != DX9_OP_SUB) {
    return false;
  }

  const uint32_t lighting_math =
      stats.multiplies + stats.multiply_adds + stats.adds;

  // Broad test path for additional sky/cloud shaders. Keep the range moderate
  // so obvious utility passes remain rejected.
  return stats.texture_samples <= 4u
      && stats.dot_products <= 2u
      && lighting_math >= 4u
      && lighting_math <= 32u
      && instruction_count >= 12u
      && instruction_count <= 128u;
}

bool DX9LooksLikeGeometryLighting(
    const DX9ShaderStats& stats,
    const DX9InstructionInfo& terminal_candidate,
    size_t instruction_count) {
  if (DX9LooksLikeSkyFogOrUtility(
          stats,
          terminal_candidate,
          instruction_count)) {
    return false;
  }

  // Geometry highlight output should be produced by arithmetic, not a direct
  // texture/cmp/lerp terminal operation.
  if (terminal_candidate.opcode != DX9_OP_MUL
      && terminal_candidate.opcode != DX9_OP_MAD
      && terminal_candidate.opcode != DX9_OP_ADD
      && terminal_candidate.opcode != DX9_OP_SUB) {
    return false;
  }

  const uint32_t lighting_math =
      stats.multiplies + stats.multiply_adds + stats.adds;
  const bool has_material_resources = DX9HasMaterialLightingSignature(stats);

  // Broader level-3 material match. The prior test required too little proof in
  // some places but still missed many real lit surfaces. Prefer resource-backed
  // evidence, then allow a high-complexity fallback for compiler variants.
  if (has_material_resources
      && stats.texture_samples >= 2u
      && stats.dot_products >= 1u
      && lighting_math >= 6u
      && instruction_count >= 18u) {
    return true;
  }

  if (stats.input_declarations >= 4u
      && stats.texture_samples >= 3u
      && stats.dot_products >= 3u
      && lighting_math >= 12u
      && instruction_count >= 35u) {
    return true;
  }

  return false;
}

bool DX9LooksLikeBroadGeometryLighting(
    const DX9ShaderStats& stats,
    const DX9InstructionInfo& terminal_candidate,
    size_t instruction_count) {
  if (DX9LooksLikeSkyFogOrUtility(
          stats,
          terminal_candidate,
          instruction_count)) {
    return false;
  }

  if (terminal_candidate.opcode != DX9_OP_MUL
      && terminal_candidate.opcode != DX9_OP_MAD
      && terminal_candidate.opcode != DX9_OP_ADD
      && terminal_candidate.opcode != DX9_OP_SUB) {
    return false;
  }

  const uint32_t lighting_math =
      stats.multiplies + stats.multiply_adds + stats.adds;

  // Level 4 is broader than level 3, but still requires actual lighting work and
  // always uses the guarded terminal reconstruction for unknown geometry.
  if (DX9HasMaterialLightingSignature(stats)
      && stats.texture_samples >= 1u
      && stats.dot_products >= 1u
      && lighting_math >= 4u
      && instruction_count >= 14u) {
    return true;
  }

  return stats.input_declarations >= 3u
      && stats.texture_samples >= 3u
      && stats.dot_products >= 2u
      && lighting_math >= 10u
      && instruction_count >= 28u;
}

bool DX9LooksLikeViewmodelLighting(
    const DX9ShaderStats& stats,
    const DX9InstructionInfo& terminal_candidate,
    size_t instruction_count) {
  // BO1's confirmed first-person weapon shaders finish with a saturated MUL
  // before square-root output encoding. Keep this requirement so ordinary fog,
  // copy, LUT and blend passes cannot enter the full viewmodel path.
  if (terminal_candidate.opcode != DX9_OP_MUL) return false;

  const bool has_texcoord8 =
      (stats.texcoord_declaration_mask & (1u << 8u)) != 0u;
  const bool has_model_lighting_sampler =
      (stats.sampler_declaration_mask & (1u << 11u)) != 0u;
  const bool has_reflection_probe_sampler =
      (stats.sampler_declaration_mask & (1u << 15u)) != 0u;

  // These are the stable declarations shared by all supplied BO1 weapon
  // examples: COLOR0, TEXCOORD8, the s11 model-lighting volume and usually the
  // s15 reflection probe. Do not require a literal LRP opcode because the D3D9
  // compiler may lower the hero-lighting blend to MAD/ADD instructions.
  if (!stats.declares_color0 || !has_texcoord8) return false;
  if (!has_model_lighting_sampler && !has_reflection_probe_sampler) return false;
  if (stats.input_declarations < 6u) return false;

  const uint32_t lighting_math =
      stats.multiplies + stats.multiply_adds + stats.adds;

  // The thresholds are intentionally lower than the previous detector. The old
  // values rejected real weapon variants after compiler scheduling changed their
  // TEX/DP/LRP counts, even though their resource and input signatures matched.
  const bool model_lighting_signature =
      has_model_lighting_sampler
      && stats.texture_samples >= 4u
      && stats.dot_products >= 4u
      && lighting_math >= 12u
      && instruction_count >= 45u;

  const bool reflection_viewmodel_signature =
      has_reflection_probe_sampler
      && stats.texture_samples >= 5u
      && stats.dot_products >= 6u
      && lighting_math >= 16u
      && instruction_count >= 60u;

  return model_lighting_signature || reflection_viewmodel_signature;
}

std::array<bool, 32u> DX9FindUsedTemporaryRegisters(
    const uint32_t* tokens,
    const std::vector<DX9InstructionInfo>& instructions) {
  std::array<bool, 32u> used = {};

  for (const auto& instruction : instructions) {
    if (instruction.opcode == static_cast<uint16_t>(DX9_SHADER_END)) continue;

    uint32_t first_parameter = 0u;
    uint32_t parameter_count = instruction.operand_count;

    // dcl stores a usage token first and the actual register second.
    if (instruction.opcode == DX9_OP_DCL) {
      first_parameter = 1u;
      parameter_count = instruction.operand_count > 1u ? 1u : 0u;
    // def/defi/defb contain literal data after the first register token.
    } else if (instruction.opcode == DX9_OP_DEF
               || instruction.opcode == DX9_OP_DEFI
               || instruction.opcode == DX9_OP_DEFB) {
      parameter_count = std::min<uint32_t>(instruction.operand_count, 1u);
    }

    for (uint32_t parameter = 0u;
         parameter < parameter_count;
         ++parameter) {
      const uint32_t token =
          tokens[instruction.token_offset + 1u + first_parameter + parameter];
      if ((token & DX9_PARAMETER_TOKEN) == 0u) continue;
      if (DX9GetRegisterType(token) != DX9_REGISTER_TEMP) continue;

      const uint32_t register_number = DX9GetRegisterNumber(token);
      if (register_number < used.size()) used[register_number] = true;
    }
  }

  return used;
}

bool DX9IsTempComponentSource(
    uint32_t token,
    uint32_t register_number,
    uint32_t component) {
  static constexpr std::array<uint32_t, 4u> COMPONENT_SWIZZLES = {
      DX9_SWIZZLE_X,
      DX9_SWIZZLE_Y,
      DX9_SWIZZLE_Z,
      DX9_SWIZZLE_W,
  };

  if (component >= COMPONENT_SWIZZLES.size()) return false;
  return DX9GetRegisterType(token) == DX9_REGISTER_TEMP
      && DX9GetRegisterNumber(token) == register_number
      && DX9GetSourceSwizzle(token) == COMPONENT_SWIZZLES[component]
      && (token & DX9_SOURCE_MODIFIER_MASK) == 0u;
}

bool DX9IsSingleComponentWrite(uint32_t write_mask) {
  return write_mask == DX9_WRITE_X
      || write_mask == DX9_WRITE_Y
      || write_mask == DX9_WRITE_Z
      || write_mask == DX9_WRITE_W;
}

uint32_t DX9WriteMaskToComponent(uint32_t write_mask) {
  switch (write_mask) {
    case DX9_WRITE_X: return 0u;
    case DX9_WRITE_Y: return 1u;
    case DX9_WRITE_Z: return 2u;
    case DX9_WRITE_W: return 3u;
    default: return UINT32_MAX;
  }
}

bool DX9IsOutputAlphaMove(
    const uint32_t* tokens,
    const DX9InstructionInfo& instruction) {
  if (instruction.opcode != DX9_OP_MOV || instruction.operand_count < 2u) {
    return false;
  }

  const uint32_t dest = tokens[instruction.token_offset + 1u];
  return DX9GetRegisterType(dest) == DX9_REGISTER_COLOR_OUTPUT
      && DX9GetRegisterNumber(dest) == 0u
      && DX9GetWriteMask(dest) == DX9_WRITE_W;
}

bool DX9MatchesTerminalSqrtOutput(
    const uint32_t* tokens,
    const std::vector<DX9InstructionInfo>& instructions,
    size_t candidate_index,
    uint32_t temp_register) {
  std::array<bool, 3u> saw_rsq = {false, false, false};
  std::array<bool, 3u> saw_rcp = {false, false, false};

  for (size_t index = candidate_index + 1u;
       index + 1u < instructions.size();
       ++index) {
    const auto& instruction = instructions[index];
    if ((instruction.instruction_token & DX9_INSTRUCTION_PREDICATED) != 0u) {
      return false;
    }

    if (instruction.opcode == DX9_OP_RSQ
        && instruction.operand_count >= 2u) {
      const uint32_t dest = tokens[instruction.token_offset + 1u];
      const uint32_t source = tokens[instruction.token_offset + 2u];
      const uint32_t write_mask = DX9GetWriteMask(dest);

      if (DX9GetRegisterType(dest) == DX9_REGISTER_TEMP
          && DX9GetRegisterNumber(dest) == temp_register
          && DX9IsSingleComponentWrite(write_mask)) {
        const uint32_t component = DX9WriteMaskToComponent(write_mask);
        if (DX9IsTempComponentSource(source, temp_register, component)) {
          if (component < 3u) saw_rsq[component] = true;
          // An optional alpha square root is allowed but not modified.
          continue;
        }
      }
    }

    if (instruction.opcode == DX9_OP_RCP
        && instruction.operand_count >= 2u) {
      const uint32_t dest = tokens[instruction.token_offset + 1u];
      const uint32_t source = tokens[instruction.token_offset + 2u];
      const uint32_t write_mask = DX9GetWriteMask(dest);

      if (DX9GetRegisterType(dest) == DX9_REGISTER_COLOR_OUTPUT
          && DX9GetRegisterNumber(dest) == 0u
          && DX9IsSingleComponentWrite(write_mask)) {
        const uint32_t component = DX9WriteMaskToComponent(write_mask);
        if (DX9IsTempComponentSource(source, temp_register, component)) {
          if (component < 3u) {
            if (!saw_rsq[component]) return false;
            saw_rcp[component] = true;
          }
          // An optional alpha reciprocal is allowed but not modified.
          continue;
        }
      }
    }

    if (DX9IsOutputAlphaMove(tokens, instruction)) continue;

    // Any other operation after the candidate means the saturation is not a
    // strict terminal sqrt/output clamp and is intentionally left alone.
    return false;
  }

  return std::ranges::all_of(saw_rsq, [](bool value) { return value; })
      && std::ranges::all_of(saw_rcp, [](bool value) { return value; });
}

uint32_t DX9GetSwizzleComponent(uint32_t token, uint32_t component) {
  if (component >= 4u) return UINT32_MAX;
  const uint32_t swizzle = DX9GetSourceSwizzle(token);
  return (swizzle >> (component * 2u)) & 0x3u;
}

bool DX9MatchesViewmodelSqrtOutput(
    const uint32_t* tokens,
    const std::vector<DX9InstructionInfo>& instructions,
    size_t candidate_index,
    uint32_t source_temp_register) {
  // The generic matcher only accepted this exact form:
  //
  //   rsq r0.x, r0.x
  //   rcp oC0.x, r0.x
  //
  // BO1 viewmodel variants may instead use a second temporary and/or move the
  // completed RGB value to oC0 after the reciprocal. Track the data flow rather
  // than requiring one register-allocation layout.
  std::array<bool, 3u> saw_rsq = {false, false, false};
  std::array<uint32_t, 3u> rsq_register = {
      UINT32_MAX, UINT32_MAX, UINT32_MAX};
  std::array<bool, 3u> saw_sqrt_value = {false, false, false};
  std::array<uint32_t, 3u> sqrt_register = {
      UINT32_MAX, UINT32_MAX, UINT32_MAX};
  std::array<uint32_t, 3u> sqrt_component = {
      UINT32_MAX, UINT32_MAX, UINT32_MAX};
  std::array<bool, 3u> wrote_output = {false, false, false};

  for (size_t index = candidate_index + 1u;
       index + 1u < instructions.size();
       ++index) {
    const auto& instruction = instructions[index];
    if ((instruction.instruction_token & DX9_INSTRUCTION_PREDICATED) != 0u) {
      return false;
    }

    if (instruction.opcode == DX9_OP_RSQ
        && instruction.operand_count >= 2u) {
      const uint32_t dest = tokens[instruction.token_offset + 1u];
      const uint32_t source = tokens[instruction.token_offset + 2u];
      const uint32_t write_mask = DX9GetWriteMask(dest);

      if (DX9GetRegisterType(dest) == DX9_REGISTER_TEMP
          && DX9IsSingleComponentWrite(write_mask)) {
        const uint32_t component = DX9WriteMaskToComponent(write_mask);
        if (component < 3u
            && DX9IsTempComponentSource(
                source,
                source_temp_register,
                component)) {
          saw_rsq[component] = true;
          rsq_register[component] = DX9GetRegisterNumber(dest);
          continue;
        }
      }
    }

    if (instruction.opcode == DX9_OP_RCP
        && instruction.operand_count >= 2u) {
      const uint32_t dest = tokens[instruction.token_offset + 1u];
      const uint32_t source = tokens[instruction.token_offset + 2u];
      const uint32_t write_mask = DX9GetWriteMask(dest);

      if (DX9IsSingleComponentWrite(write_mask)) {
        const uint32_t component = DX9WriteMaskToComponent(write_mask);
        if (component < 3u
            && saw_rsq[component]
            && DX9IsTempComponentSource(
                source,
                rsq_register[component],
                component)) {
          const uint32_t dest_type = DX9GetRegisterType(dest);
          const uint32_t dest_register = DX9GetRegisterNumber(dest);

          if (dest_type == DX9_REGISTER_COLOR_OUTPUT
              && dest_register == 0u) {
            wrote_output[component] = true;
            continue;
          }

          if (dest_type == DX9_REGISTER_TEMP) {
            saw_sqrt_value[component] = true;
            sqrt_register[component] = dest_register;
            sqrt_component[component] = component;
            continue;
          }
        }
      }
    }

    if (instruction.opcode == DX9_OP_MOV
        && instruction.operand_count >= 2u) {
      const uint32_t dest = tokens[instruction.token_offset + 1u];
      const uint32_t source = tokens[instruction.token_offset + 2u];
      const uint32_t dest_type = DX9GetRegisterType(dest);
      const uint32_t dest_register = DX9GetRegisterNumber(dest);
      const uint32_t write_mask = DX9GetWriteMask(dest);

      if (dest_type == DX9_REGISTER_COLOR_OUTPUT && dest_register == 0u) {
        if (write_mask == DX9_WRITE_W) continue;
        if ((write_mask & DX9_WRITE_RGB) == 0u) continue;
        if (DX9GetRegisterType(source) != DX9_REGISTER_TEMP
            || (source & DX9_SOURCE_MODIFIER_MASK) != 0u) {
          return false;
        }

        const uint32_t source_register = DX9GetRegisterNumber(source);
        for (uint32_t output_component = 0u;
             output_component < 3u;
             ++output_component) {
          const uint32_t output_bit = 1u << output_component;
          if ((write_mask & output_bit) == 0u) continue;

          const uint32_t source_component =
              DX9GetSwizzleComponent(source, output_component);
          bool matched_component = false;

          for (uint32_t sqrt_index = 0u;
               sqrt_index < 3u;
               ++sqrt_index) {
            if (!saw_sqrt_value[sqrt_index]) continue;
            if (sqrt_register[sqrt_index] != source_register) continue;
            if (sqrt_component[sqrt_index] != source_component) continue;
            matched_component = true;
            break;
          }

          if (!matched_component) return false;
          wrote_output[output_component] = true;
        }
        continue;
      }
    }

    // Ignore unrelated scalar/alpha work after the lighting result, but reject
    // an unexpected RGB overwrite of the source temporary or the final color
    // output. This keeps the relaxed matcher tied to the terminal sqrt chain.
    if (instruction.operand_count > 0u
        && DX9OpcodeMayHaveSaturatedColorDestination(instruction.opcode)) {
      const uint32_t dest = tokens[instruction.token_offset + 1u];
      const uint32_t dest_type = DX9GetRegisterType(dest);
      const uint32_t dest_register = DX9GetRegisterNumber(dest);
      const uint32_t write_mask = DX9GetWriteMask(dest);

      if ((write_mask & DX9_WRITE_RGB) != 0u
          && ((dest_type == DX9_REGISTER_TEMP
               && dest_register == source_temp_register)
              || (dest_type == DX9_REGISTER_COLOR_OUTPUT
                  && dest_register == 0u))) {
        return false;
      }
    }
  }

  return std::ranges::all_of(saw_rsq, [](bool value) { return value; })
      && std::ranges::all_of(wrote_output, [](bool value) { return value; });
}

bool DX9MatchesDirectFinalOutput(
    const uint32_t* tokens,
    const std::vector<DX9InstructionInfo>& instructions,
    size_t candidate_index) {
  for (size_t index = candidate_index + 1u;
       index + 1u < instructions.size();
       ++index) {
    if (!DX9IsOutputAlphaMove(tokens, instructions[index])) return false;
  }
  return true;
}

DX9AutoUnclampPlan DX9BuildAutoUnclampPlan(
    const uint32_t* tokens,
    const std::vector<DX9InstructionInfo>& instructions,
    uint32_t mode,
    uint32_t source_crc32) {
  DX9AutoUnclampPlan plan = {};
  if (mode == DX9_AUTO_UNCLAMP_OFF || instructions.size() < 2u) return plan;
  if (DX9_AUTO_UNCLAMP_DENYLIST.contains(source_crc32)) return plan;

  const bool is_curated_post =
      DX9_AUTO_UNCLAMP_POST_ALLOWLIST.contains(source_crc32);
  const bool is_curated_model =
      DX9_AUTO_UNCLAMP_MODEL_ALLOWLIST.contains(source_crc32);
  const bool is_exact_viewmodel =
      DX9_AUTO_UNCLAMP_LEVEL3_VIEWMODEL_ALLOWLIST.contains(source_crc32);
  const bool is_exact_sky_test =
      mode >= DX9_AUTO_UNCLAMP_HEURISTIC_SQRT
      && DX9_AUTO_UNCLAMP_LEVEL3_SKY_TEST_ALLOWLIST.contains(source_crc32);
  const DX9ShaderStats stats = DX9CollectShaderStats(tokens, instructions);

  const auto used_temps = DX9FindUsedTemporaryRegisters(tokens, instructions);
  std::array<uint32_t, 32u> free_temps = {};
  uint32_t free_temp_count = 0u;
  for (uint32_t temp = 0u; temp < used_temps.size(); ++temp) {
    if (!used_temps[temp]) free_temps[free_temp_count++] = temp;
  }

  for (size_t candidate_index = instructions.size() - 1u;
       candidate_index-- > 0u;) {
    const auto& instruction = instructions[candidate_index];
    if (!DX9OpcodeMayHaveSaturatedColorDestination(instruction.opcode)) {
      continue;
    }
    if (instruction.operand_count == 0u) continue;
    if ((instruction.instruction_token & DX9_INSTRUCTION_PREDICATED) != 0u) {
      continue;
    }

    const uint32_t dest = tokens[instruction.token_offset + 1u];
    if ((dest & DX9_DEST_SATURATE) == 0u) continue;
    if (DX9GetWriteMask(dest) != DX9_WRITE_RGB) continue;

    const uint32_t register_type = DX9GetRegisterType(dest);
    const uint32_t register_number = DX9GetRegisterNumber(dest);

    const bool is_heuristic_viewmodel_candidate =
        mode >= DX9_AUTO_UNCLAMP_HEURISTIC_SQRT
        && (is_exact_viewmodel
            || DX9LooksLikeViewmodelLighting(
                stats,
                instruction,
                instructions.size()));

    const bool is_structural_extra_sky =
        mode >= DX9_AUTO_UNCLAMP_HEURISTIC_SQRT
        && !is_curated_post
        && !is_curated_model
        && !is_exact_viewmodel
        && !is_exact_sky_test
        && DX9LooksLikeAdditionalSkyShader(
            stats,
            instruction,
            instructions.size());

    const bool is_structural_sky_or_utility =
        !is_curated_post
        && !is_curated_model
        && !is_exact_viewmodel
        && !is_exact_sky_test
        && !is_structural_extra_sky
        && DX9LooksLikeSkyFogOrUtility(
            stats,
            instruction,
            instructions.size());

    const bool matches_strict_sqrt =
        register_type == DX9_REGISTER_TEMP
        && DX9MatchesTerminalSqrtOutput(
            tokens,
            instructions,
            candidate_index,
            register_number);

    const bool matches_viewmodel_sqrt =
        register_type == DX9_REGISTER_TEMP
        && is_heuristic_viewmodel_candidate
        && DX9MatchesViewmodelSqrtOutput(
            tokens,
            instructions,
            candidate_index,
            register_number);

    if (matches_strict_sqrt || matches_viewmodel_sqrt) {
      bool allow_sqrt = false;
      bool use_guarded_geometry = false;

      switch (mode) {
        case DX9_AUTO_UNCLAMP_CURATED_POST_SKY:
          allow_sqrt = is_curated_post;
          break;

        case DX9_AUTO_UNCLAMP_CURATED_WITH_MODEL:
          // Explicit weapon/viewmodel hashes use the full terminal unclamp.
          // Their internal shading clamps remain untouched, and the smaller
          // patch is much more likely to fit instruction-heavy ps_3_0 shaders.
          allow_sqrt = is_curated_post || is_curated_model;
          use_guarded_geometry = false;
          break;

        case DX9_AUTO_UNCLAMP_HEURISTIC_SQRT:
        case DX9_AUTO_UNCLAMP_HEURISTIC_ALL: {
          // Level 4 deliberately aliases level 3. Both modes now apply the same
          // weapon-style terminal highlight unclamp to almost every strict terminal
          // sqrt chain, while still protecting known and structural sky/fog/utility
          // shaders. The two confirmed sky hashes are explicitly allowed for this
          // test build. There is no guarded reconstruction or brightness multiplier.
          if (is_structural_sky_or_utility) break;

          const bool is_broad_viewmodel =
              is_heuristic_viewmodel_candidate;

          // Broad heuristic mode: if the shader ends in a proven terminal
          // sqrt(saturate(...)) output chain, allow the same final-only unclamp used
          // by the supplied weapon HLSL examples. This intentionally reaches world
          // geometry and most other lit shaders. Structural fog/utility passes remain
          // filtered, while the confirmed sky hashes and additional sky-like shaders
          // bypass that filter for testing.
          allow_sqrt = is_curated_post
              || is_curated_model
              || is_exact_viewmodel
              || is_exact_sky_test
              || is_structural_extra_sky
              || is_broad_viewmodel
              || matches_strict_sqrt;

          // Every accepted shader uses:
          //
          //   sqrt(saturate(finalLighting))
          //       -> sqrt(max(finalLighting, 0))
          //
          // This is exactly the supplied weapon-HLSL transformation.
          use_guarded_geometry = false;
          break;
        }

        default:
          break;
      }

      if (!allow_sqrt) continue;

      if (use_guarded_geometry) {
        // Legacy guarded reconstruction retained for source compatibility.
        // Level 3 and level 4 no longer select this path.
        if (instructions.size() > 504u || free_temp_count < 2u) continue;

        plan.kind = DX9AutoUnclampPatchKind::SQRT_OUTPUT_GUARDED;
        plan.instruction_index = candidate_index;
        plan.free_temps[0] = free_temps[0];
        plan.free_temps[1] = free_temps[1];
        plan.free_temp_count = 2u;
        return plan;
      }

      // Full unclamp adds two arithmetic instructions.
      if (instructions.size() > 510u || free_temp_count < 1u) continue;

      plan.kind = DX9AutoUnclampPatchKind::SQRT_OUTPUT;
      plan.instruction_index = candidate_index;
      plan.free_temps[0] = free_temps[0];
      plan.free_temp_count = 1u;
      return plan;
    }

    // Direct final-output rewrites are hash-curated only. Do not infer them from
    // a viewmodel/geometry signature: that broader path caused flat shading.
    const bool allow_direct_output =
        DX9AutoUnclampModeAllowsDirectOutput(mode, source_crc32);

    if (allow_direct_output
        && register_type == DX9_REGISTER_COLOR_OUTPUT
        && register_number == 0u
        && instructions.size() <= 510u
        && free_temp_count >= 2u
        && DX9MatchesDirectFinalOutput(
            tokens,
            instructions,
            candidate_index)) {
      plan.kind = DX9AutoUnclampPatchKind::DIRECT_OUTPUT;
      plan.instruction_index = candidate_index;
      plan.free_temps[0] = free_temps[0];
      plan.free_temps[1] = free_temps[1];
      plan.free_temp_count = 2u;
      return plan;
    }
  }

  return plan;
}

bool DX9ApplyAutoUnclampPlan(
    const uint32_t* source_tokens,
    size_t token_count,
    const std::vector<DX9InstructionInfo>& instructions,
    const DX9AutoUnclampPlan& plan,
    std::vector<uint32_t>& patched_tokens) {
  if (plan.kind == DX9AutoUnclampPatchKind::NONE) return false;
  if (plan.instruction_index >= instructions.size()) return false;

  const auto& candidate = instructions[plan.instruction_index];
  if (candidate.operand_count == 0u) return false;

  const size_t dest_offset = candidate.token_offset + 1u;
  const size_t insert_offset =
      candidate.token_offset + 1u + candidate.operand_count;
  if (dest_offset >= token_count || insert_offset > token_count) return false;

  patched_tokens.assign(source_tokens, source_tokens + token_count);

  const uint32_t original_dest = patched_tokens[dest_offset];
  const bool partial_precision =
      (original_dest & DX9_DEST_PARTIAL_PRECISION) != 0u;
  const uint32_t original_register = DX9GetRegisterNumber(original_dest);

  std::vector<uint32_t> inserted;

  if (plan.kind == DX9AutoUnclampPatchKind::SQRT_OUTPUT) {
    const uint32_t zero_temp = plan.free_temps[0];

    // Remove only _sat from the original RGB-producing instruction.
    patched_tokens[dest_offset] = original_dest & ~DX9_DEST_SATURATE;

    // rZero.rgb = rColor.rgb - rColor.rgb;  // exact 0 for finite input
    inserted.push_back(DX9MakeInstruction(DX9_OP_SUB, 3u));
    inserted.push_back(DX9MakeTempDest(
        zero_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(original_register));
    inserted.push_back(DX9MakeTempSource(original_register));

    // rColor.rgb = max(rColor.rgb, rZero.rgb);
    inserted.push_back(DX9MakeInstruction(DX9_OP_MAX, 3u));
    inserted.push_back(DX9MakeTempDest(
        original_register,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(original_register));
    inserted.push_back(DX9MakeTempSource(zero_temp));
  } else if (plan.kind == DX9AutoUnclampPatchKind::SQRT_OUTPUT_GUARDED) {
    const uint32_t raw_temp = plan.free_temps[0];
    const uint32_t aux_temp = plan.free_temps[1];

    // First evaluate the original expression without saturation into rRaw.
    patched_tokens[dest_offset] = DX9SetRegister(
        original_dest & ~DX9_DEST_SATURATE,
        DX9_REGISTER_TEMP,
        raw_temp);

    // Then replay the exact original saturated instruction into rColor. Keeping
    // both versions lets us construct a constant-free 16.0 cap:
    //
    //   vanilla = saturate(raw)
    //   limit   = vanilla * 16
    //   color   = max(min(raw, limit), 0)
    //
    // Below 1.0, min(raw, 16*raw) remains raw. Above 1.0, vanilla is 1 and
    // the recovered linear value is capped at 16.0. The following original
    // rsq/rcp chain can therefore output up to sqrt(16) = 4.0.
    const size_t candidate_dword_count = 1u + candidate.operand_count;
    inserted.insert(
        inserted.end(),
        source_tokens + candidate.token_offset,
        source_tokens + candidate.token_offset + candidate_dword_count);

    // rAux.rgb = rColor.rgb + rColor.rgb;  // 2 * saturate(raw)
    inserted.push_back(DX9MakeInstruction(DX9_OP_ADD, 3u));
    inserted.push_back(DX9MakeTempDest(
        aux_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(original_register));
    inserted.push_back(DX9MakeTempSource(original_register));

    // rAux.rgb = rAux.rgb + rAux.rgb;  // 4 * saturate(raw)
    inserted.push_back(DX9MakeInstruction(DX9_OP_ADD, 3u));
    inserted.push_back(DX9MakeTempDest(
        aux_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(aux_temp));
    inserted.push_back(DX9MakeTempSource(aux_temp));

    // rAux.rgb = rAux.rgb + rAux.rgb;  // 8 * saturate(raw)
    inserted.push_back(DX9MakeInstruction(DX9_OP_ADD, 3u));
    inserted.push_back(DX9MakeTempDest(
        aux_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(aux_temp));
    inserted.push_back(DX9MakeTempSource(aux_temp));

    // rAux.rgb = rAux.rgb + rAux.rgb;  // 16 * saturate(raw)
    inserted.push_back(DX9MakeInstruction(DX9_OP_ADD, 3u));
    inserted.push_back(DX9MakeTempDest(
        aux_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(aux_temp));
    inserted.push_back(DX9MakeTempSource(aux_temp));

    // rColor.rgb = min(rRaw.rgb, rAux.rgb);
    inserted.push_back(DX9MakeInstruction(DX9_OP_MIN, 3u));
    inserted.push_back(DX9MakeTempDest(
        original_register,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(raw_temp));
    inserted.push_back(DX9MakeTempSource(aux_temp));

    // rAux.rgb = rColor.rgb - rColor.rgb;  // safe zero after the finite cap
    inserted.push_back(DX9MakeInstruction(DX9_OP_SUB, 3u));
    inserted.push_back(DX9MakeTempDest(
        aux_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(original_register));
    inserted.push_back(DX9MakeTempSource(original_register));

    // rColor.rgb = max(rColor.rgb, rAux.rgb);
    inserted.push_back(DX9MakeInstruction(DX9_OP_MAX, 3u));
    inserted.push_back(DX9MakeTempDest(
        original_register,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(original_register));
    inserted.push_back(DX9MakeTempSource(aux_temp));
  } else if (plan.kind == DX9AutoUnclampPatchKind::DIRECT_OUTPUT) {
    const uint32_t color_temp = plan.free_temps[0];
    const uint32_t zero_temp = plan.free_temps[1];

    // Redirect the original oC0.rgb write into a free temporary and remove
    // only _sat. The original write mask and partial-precision modifier remain.
    patched_tokens[dest_offset] = DX9SetRegister(
        original_dest & ~DX9_DEST_SATURATE,
        DX9_REGISTER_TEMP,
        color_temp);

    inserted.push_back(DX9MakeInstruction(DX9_OP_SUB, 3u));
    inserted.push_back(DX9MakeTempDest(
        zero_temp,
        DX9_WRITE_RGB,
        partial_precision));
    inserted.push_back(DX9MakeTempSource(color_temp));
    inserted.push_back(DX9MakeTempSource(color_temp));

    // oC0.rgb = max(rColor.rgb, rZero.rgb);
    inserted.push_back(DX9MakeInstruction(DX9_OP_MAX, 3u));
    inserted.push_back(original_dest & ~DX9_DEST_SATURATE);
    inserted.push_back(DX9MakeTempSource(color_temp));
    inserted.push_back(DX9MakeTempSource(zero_temp));
  } else {
    return false;
  }

  patched_tokens.insert(
      patched_tokens.begin() + static_cast<std::ptrdiff_t>(insert_offset),
      inserted.begin(),
      inserted.end());
  return true;
}

uint32_t DX9CRC32(const void* data, size_t size) {
  static const std::array<uint32_t, 256u> TABLE = []() {
    std::array<uint32_t, 256u> table = {};
    for (uint32_t index = 0u; index < table.size(); ++index) {
      uint32_t value = index;
      for (uint32_t bit = 0u; bit < 8u; ++bit) {
        value = (value >> 1u)
            ^ ((value & 1u) != 0u ? 0xEDB88320u : 0u);
      }
      table[index] = value;
    }
    return table;
  }();

  const auto* bytes = static_cast<const uint8_t*>(data);
  uint32_t crc = 0xFFFFFFFFu;
  for (size_t index = 0u; index < size; ++index) {
    crc = TABLE[(crc ^ bytes[index]) & 0xFFu] ^ (crc >> 8u);
  }
  return crc ^ 0xFFFFFFFFu;
}

const char* DX9AutoUnclampKindName(DX9AutoUnclampPatchKind kind) {
  switch (kind) {
    case DX9AutoUnclampPatchKind::SQRT_OUTPUT:
      return "terminal sqrt RGB";
    case DX9AutoUnclampPatchKind::SQRT_OUTPUT_GUARDED:
      return "guarded geometry sqrt RGB";
    case DX9AutoUnclampPatchKind::DIRECT_OUTPUT:
      return "direct final RGB";
    default:
      return "none";
  }
}

bool OnCreatePipelineDX9AutoOutputUnclamp(
    reshade::api::device* device,
    reshade::api::pipeline_layout layout,
    uint32_t subobject_count,
    const reshade::api::pipeline_subobject* subobjects) {
  (void)layout;

  if (device == nullptr
      || device->get_api() != reshade::api::device_api::d3d9
      || subobjects == nullptr) {
    return false;
  }

  const uint32_t mode = std::clamp(
      static_cast<uint32_t>(std::lround(dx9_auto_output_unclamp_mode)),
      DX9_AUTO_UNCLAMP_OFF,
      DX9_AUTO_UNCLAMP_HEURISTIC_ALL);
  if (mode == DX9_AUTO_UNCLAMP_OFF) return false;

  bool modified = false;

  for (uint32_t subobject_index = 0u;
       subobject_index < subobject_count;
       ++subobject_index) {
    const auto& subobject = subobjects[subobject_index];
    if (subobject.type != reshade::api::pipeline_subobject_type::pixel_shader
        || subobject.count != 1u
        || subobject.data == nullptr) {
      continue;
    }

    auto* shader_desc =
        static_cast<reshade::api::shader_desc*>(subobject.data);
    if (shader_desc->code == nullptr
        || shader_desc->code_size < sizeof(uint32_t) * 2u
        || (shader_desc->code_size % sizeof(uint32_t)) != 0u) {
      continue;
    }

    const auto* source_tokens =
        static_cast<const uint32_t*>(shader_desc->code);
    const size_t token_count =
        shader_desc->code_size / sizeof(uint32_t);
    if (source_tokens[0] != DX9_PS_3_0_VERSION) continue;

    const uint32_t source_crc32 =
        DX9CRC32(shader_desc->code, shader_desc->code_size);
    if (!DX9AutoUnclampModeAllowsHash(mode, source_crc32)) continue;

    // PERFORMANCE: most BO1 shaders are created more than once across device/state
    // rebuilds. Reuse already-patched bytecode before reparsing and rebuilding it.
    // This preserves the existing cache semantics; it only moves the lookup earlier.
    const uint64_t early_cache_key =
        (static_cast<uint64_t>(source_crc32) << 32u)
        | static_cast<uint32_t>(shader_desc->code_size);
    {
      std::scoped_lock lock(g_dx9_auto_unclamp_mutex);
      const auto cache_it = g_dx9_auto_unclamp_cache.find(early_cache_key);
      if (cache_it != g_dx9_auto_unclamp_cache.end()
          && cache_it->second.source_crc32 == source_crc32
          && cache_it->second.source_size == shader_desc->code_size) {
        shader_desc->code = cache_it->second.bytecode.data();
        shader_desc->code_size =
            cache_it->second.bytecode.size() * sizeof(uint32_t);
        modified = true;
        continue;
      }
    }

    std::vector<DX9InstructionInfo> instructions;
    if (!DX9ParseShader(source_tokens, token_count, instructions)) continue;

    const DX9AutoUnclampPlan plan =
        DX9BuildAutoUnclampPlan(
            source_tokens,
            instructions,
            mode,
            source_crc32);
    if (plan.kind == DX9AutoUnclampPatchKind::NONE) continue;

    std::vector<uint32_t> patched_tokens;
    if (!DX9ApplyAutoUnclampPlan(
            source_tokens,
            token_count,
            instructions,
            plan,
            patched_tokens)) {
      continue;
    }

    // Parse the rebuilt stream once more before passing it to D3D9. This catches
    // malformed token lengths locally and leaves the original shader untouched.
    std::vector<DX9InstructionInfo> validation_instructions;
    if (!DX9ParseShader(
            patched_tokens.data(),
            patched_tokens.size(),
            validation_instructions)) {
      continue;
    }

    const uint64_t cache_key =
        (static_cast<uint64_t>(source_crc32) << 32u)
        | static_cast<uint32_t>(shader_desc->code_size);

    std::scoped_lock lock(g_dx9_auto_unclamp_mutex);
    auto [cache_it, inserted] = g_dx9_auto_unclamp_cache.try_emplace(
        cache_key,
        DX9CachedAutoUnclampShader{
            .source_crc32 = source_crc32,
            .source_size = shader_desc->code_size,
            .kind = plan.kind,
            .bytecode = std::move(patched_tokens),
        });

    // A CRC/size collision is extremely unlikely, but never reuse a cache entry
    // whose recorded source metadata does not match this shader.
    if (!inserted
        && (cache_it->second.source_crc32 != source_crc32
            || cache_it->second.source_size != shader_desc->code_size)) {
      continue;
    }

    shader_desc->code = cache_it->second.bytecode.data();
    shader_desc->code_size =
        cache_it->second.bytecode.size() * sizeof(uint32_t);
    modified = true;

    if (inserted) {
      if (plan.kind == DX9AutoUnclampPatchKind::SQRT_OUTPUT) {
        ++g_dx9_auto_unclamp_sqrt_count;
      } else if (
          plan.kind == DX9AutoUnclampPatchKind::SQRT_OUTPUT_GUARDED) {
        ++g_dx9_auto_unclamp_guarded_count;
      } else if (plan.kind == DX9AutoUnclampPatchKind::DIRECT_OUTPUT) {
        ++g_dx9_auto_unclamp_direct_count;
      }

      if (g_dx9_auto_unclamp_log_count < 64u) {
        ++g_dx9_auto_unclamp_log_count;
        std::stringstream stream;
        stream << "[RenoDX DX9 Auto Unclamp] Patched 0x";
        stream << std::uppercase << std::hex << std::setw(8)
               << std::setfill('0') << source_crc32;
        stream << std::dec << " (";
        stream << DX9AutoUnclampKindName(plan.kind);
        stream << ", mode=" << mode;
        stream << ", totals: sqrt=" << g_dx9_auto_unclamp_sqrt_count;
        stream << ", guarded=" << g_dx9_auto_unclamp_guarded_count;
        stream << ", direct=" << g_dx9_auto_unclamp_direct_count;
        stream << ")";
        reshade::log::message(
            reshade::log::level::info,
            stream.str().c_str());
      }
    }
  }

  return modified;
}

void ClearDX9AutoOutputUnclampCache() {
  std::scoped_lock lock(g_dx9_auto_unclamp_mutex);
  g_dx9_auto_unclamp_cache.clear();
}

#endif  // Automatic DX9 output unclamper

// ============================================================================
// D3D9 cloned-resource copy/readback fix
// ============================================================================
//
// ReShade reports IDirect3DDevice9::GetRenderTargetData through copy_resource.
// It reports UpdateSurface/StretchRect through copy_texture_region, and some
// StretchRect/MSAA paths through resolve_texture_region.
//
// The game may create an 8-bit system-memory surface and read an upgraded
// R16G16B16A16_FLOAT scene/swapchain clone into it. D3D9 cannot directly copy
// between those different formats. The original call can therefore fail and
// leave the destination black or unchanged.
//
// This handler:
//   1. Chains GPU copies through matching RenoDX clones when both sides have one.
//   2. For a float16 -> 8-bit CPU readback, first reads the float clone into a
//      matching CPU-visible float16 staging surface.
//   3. Converts that staging image into the game's original 8-bit destination.
//   4. Returns true only after fully replacing the incompatible original copy.
//
// The CPU fallback is intentionally restricted to D3D9, full-surface copies,
// equal dimensions, R16G16B16A16_FLOAT sources and common 32-bit SDR formats.

constexpr bool DX9_READBACK_FIX_ENABLED = true;

// Primary path: convert the live FP16 clone into the game's original 8-bit
// render target entirely on the D3D9 GPU immediately before a readback.
constexpr bool DX9_READBACK_GPU_BLIT_ENABLED = true;

// Safety net for unusual DX9 surfaces that cannot be sampled/rendered by the
// native blit path. This retains the known-working CPU behavior, but should not
// be reached for ordinary render-target readbacks.
constexpr bool DX9_READBACK_CPU_FALLBACK_ENABLED = true;

// RenoDX's scRGB/HDR clone is normally linear. Enable this to hand the game a
// conventional SDR/screenshot-like nonlinear representation.
constexpr bool DX9_READBACK_ENCODE_SRGB = true;

// Preserve the source alpha by default. Change to true only if the game's
// readback consumer requires an opaque X8/A8 surface.
constexpr bool DX9_READBACK_FORCE_OPAQUE_ALPHA = false;

thread_local bool g_inside_dx9_replacement_copy = false;

uint32_t g_dx9_readback_success_logs = 0;
uint32_t g_dx9_readback_failure_logs = 0;
uint32_t g_dx9_chain_logs = 0;
uint32_t g_dx9_gpu_blit_success_logs = 0;
uint32_t g_dx9_gpu_blit_failure_logs = 0;

struct DX9NativeReadbackBlitCache {
  reshade::api::device* device = nullptr;
  IDirect3DPixelShader9* pixel_shader = nullptr;
  IDirect3DStateBlock9* state_block = nullptr;
  IDirect3DTexture9* sampling_texture = nullptr;
  uint32_t sampling_width = 0u;
  uint32_t sampling_height = 0u;
};

std::mutex g_dx9_native_readback_mutex;
DX9NativeReadbackBlitCache g_dx9_native_readback_cache;

struct ScopedDX9ReplacementCopy {
  ScopedDX9ReplacementCopy() { g_inside_dx9_replacement_copy = true; }
  ~ScopedDX9ReplacementCopy() { g_inside_dx9_replacement_copy = false; }

  ScopedDX9ReplacementCopy(const ScopedDX9ReplacementCopy&) = delete;
  ScopedDX9ReplacementCopy& operator=(const ScopedDX9ReplacementCopy&) = delete;
};

struct DX9CopyEndpoint {
  reshade::api::resource input = {0u};
  reshade::api::resource original = {0u};
  reshade::api::resource clone = {0u};

  reshade::api::resource_desc input_desc = {};
  reshade::api::resource_desc original_desc = {};
  reshade::api::resource_desc clone_desc = {};

  bool has_live_tracking = false;
  bool has_clone = false;
  bool input_is_clone = false;
  bool clone_enabled = false;
};

bool IsTextureResource(const reshade::api::resource_desc& desc) {
  return desc.type == reshade::api::resource_type::surface
      || desc.type == reshade::api::resource_type::texture_1d
      || desc.type == reshade::api::resource_type::texture_2d
      || desc.type == reshade::api::resource_type::texture_3d;
}

bool SameTextureExtent(const reshade::api::resource_desc& left,
                       const reshade::api::resource_desc& right) {
  if (!IsTextureResource(left) || !IsTextureResource(right)) return false;

  return left.texture.width == right.texture.width
      && left.texture.height == right.texture.height
      && left.texture.depth_or_layers == right.texture.depth_or_layers;
}

bool ExactCopyCompatible(const reshade::api::resource_desc& source_desc,
                         const reshade::api::resource_desc& dest_desc) {
  if (source_desc.type != dest_desc.type) return false;
  if (!SameTextureExtent(source_desc, dest_desc)) return false;

  return source_desc.texture.format == dest_desc.texture.format
      && source_desc.texture.levels == dest_desc.texture.levels
      && source_desc.texture.samples == dest_desc.texture.samples;
}

DX9CopyEndpoint ResolveDX9CopyEndpoint(
    reshade::api::device* device,
    reshade::api::resource input) {
  DX9CopyEndpoint endpoint = {};
  endpoint.input = input;
  endpoint.original = input;

  if (device == nullptr || input.handle == 0u) return endpoint;

  endpoint.input_desc =
      renodx::utils::resource::GetResourceDesc(device, input);
  endpoint.original_desc = endpoint.input_desc;

  endpoint.has_live_tracking =
      renodx::utils::resource::GetLiveResourceInfo(
          input,
          [&](const renodx::utils::resource::ResourceInfo& info) {
            endpoint.original =
                info.resource.handle != 0u ? info.resource : input;
            endpoint.original_desc =
                info.desc.type != reshade::api::resource_type::unknown
                    ? info.desc
                    : endpoint.input_desc;

            endpoint.clone = info.clone;
            endpoint.clone_desc = info.clone_desc;
            endpoint.has_clone =
                info.clone.handle != 0u
                && info.clone_desc.type
                    != reshade::api::resource_type::unknown;
            endpoint.input_is_clone = info.is_clone;
            endpoint.clone_enabled = info.clone_enabled;
          });

  // RenoDX generally tracks the parent/original entry. If ReShade gives this
  // callback the clone handle itself, locate the parent whose clone matches it.
  //
  // PERFORMANCE: the old condition scanned the complete tracked-resource list for
  // every ordinary non-cloned D3D9 surface because has_clone was false. RenoDX
  // clones created by these BO1 upgrade rules are R16G16B16A16_FLOAT, so only a
  // float16 input can plausibly be a clone handle that needs the reverse lookup.
  // Original B8G8R8A8_UNORM/R16G16B16A16_UNORM resources still use the direct
  // GetLiveResourceInfo path above and keep the exact same cloning behavior.
  const bool may_be_clone_handle =
      endpoint.input_desc.type != reshade::api::resource_type::unknown
      && endpoint.input_desc.texture.format
          == reshade::api::format::r16g16b16a16_float;

  if (may_be_clone_handle
      && (!endpoint.has_clone || endpoint.input_is_clone)) {
    bool found_parent = false;
    renodx::utils::resource::ForEachResourceInfo(
        [&](const renodx::utils::resource::ResourceInfo& info) {
          if (found_parent) return;
          if (info.destroyed || info.clone.handle != input.handle) return;

          found_parent = true;
          endpoint.has_live_tracking = true;
          endpoint.input_is_clone = true;
          endpoint.original = info.resource;
          endpoint.original_desc = info.desc;
          endpoint.clone = input;
          endpoint.clone_desc =
              info.clone_desc.type != reshade::api::resource_type::unknown
                  ? info.clone_desc
                  : endpoint.input_desc;
          endpoint.has_clone = true;
          endpoint.clone_enabled = info.clone_enabled;
        });
  }

  return endpoint;
}

reshade::api::resource SelectCloneForCopy(const DX9CopyEndpoint& endpoint) {
  if (endpoint.has_clone && endpoint.clone.handle != 0u) {
    return endpoint.clone;
  }
  return endpoint.input;
}

reshade::api::resource_desc SelectCloneDescForCopy(
    const DX9CopyEndpoint& endpoint) {
  if (endpoint.has_clone
      && endpoint.clone_desc.type
          != reshade::api::resource_type::unknown) {
    return endpoint.clone_desc;
  }
  return endpoint.input_desc;
}

bool IsFloat16RGBA(reshade::api::format format) {
  return format == reshade::api::format::r16g16b16a16_float;
}

bool IsSupportedSDRReadbackFormat(reshade::api::format format) {
  switch (format) {
    case reshade::api::format::b8g8r8a8_unorm:
    case reshade::api::format::b8g8r8a8_unorm_srgb:
    case reshade::api::format::b8g8r8x8_unorm:
    case reshade::api::format::b8g8r8x8_unorm_srgb:
    case reshade::api::format::r8g8b8a8_unorm:
    case reshade::api::format::r8g8b8a8_unorm_srgb:
    case reshade::api::format::r8g8b8x8_unorm:
    case reshade::api::format::r8g8b8x8_unorm_srgb:
      return true;
    default:
      return false;
  }
}

bool IsBGRAReadbackFormat(reshade::api::format format) {
  switch (format) {
    case reshade::api::format::b8g8r8a8_unorm:
    case reshade::api::format::b8g8r8a8_unorm_srgb:
    case reshade::api::format::b8g8r8x8_unorm:
    case reshade::api::format::b8g8r8x8_unorm_srgb:
      return true;
    default:
      return false;
  }
}

bool IsX8ReadbackFormat(reshade::api::format format) {
  switch (format) {
    case reshade::api::format::b8g8r8x8_unorm:
    case reshade::api::format::b8g8r8x8_unorm_srgb:
    case reshade::api::format::r8g8b8x8_unorm:
    case reshade::api::format::r8g8b8x8_unorm_srgb:
      return true;
    default:
      return false;
  }
}

bool IsCPUVisibleReadbackHeap(reshade::api::memory_heap heap) {
  return heap == reshade::api::memory_heap::gpu_to_cpu
      || heap == reshade::api::memory_heap::cpu_only;
}

float HalfToFloat(uint16_t value) {
  const uint32_t sign = (value >> 15u) & 0x1u;
  const uint32_t exponent = (value >> 10u) & 0x1Fu;
  const uint32_t mantissa = value & 0x3FFu;

  float result = 0.0f;

  if (exponent == 0u) {
    // Half subnormal: mantissa / 1024 * 2^-14 = mantissa * 2^-24.
    result = std::ldexp(static_cast<float>(mantissa), -24);
  } else if (exponent == 0x1Fu) {
    if (mantissa == 0u) {
      result = std::numeric_limits<float>::infinity();
    } else {
      result = std::numeric_limits<float>::quiet_NaN();
    }
  } else {
    result = std::ldexp(
        1.0f + static_cast<float>(mantissa) / 1024.0f,
        static_cast<int>(exponent) - 15);
  }

  return sign != 0u ? -result : result;
}

float SanitizeUnit(float value) {
  if (!std::isfinite(value)) return 0.0f;
  return std::clamp(value, 0.0f, 1.0f);
}

float LinearToSRGB(float linear) {
  linear = SanitizeUnit(linear);

  if (linear <= 0.0031308f) {
    return 12.92f * linear;
  }

  return 1.055f * std::pow(linear, 1.0f / 2.4f) - 0.055f;
}

uint8_t FloatToUNorm8(float value, bool encode_srgb) {
  value = encode_srgb ? LinearToSRGB(value) : SanitizeUnit(value);
  return static_cast<uint8_t>(
      std::clamp(
          static_cast<int>(std::lround(value * 255.0f)),
          0,
          255));
}

// Fast safety fallback. This precomputes the exact old half-float -> 8-bit
// conversion once, so a rare unsupported GPU-blit surface does not fall back to
// millions of std::pow calls.
struct DX9HalfToUNorm8Tables {
  std::array<uint8_t, 65536u> srgb = {};
  std::array<uint8_t, 65536u> linear = {};
};

DX9HalfToUNorm8Tables g_dx9_half_to_unorm8_tables;
std::once_flag g_dx9_half_to_unorm8_once;

void EnsureDX9HalfToUNorm8Tables() {
  std::call_once(
      g_dx9_half_to_unorm8_once,
      []() {
        for (uint32_t bits = 0u; bits <= 0xFFFFu; ++bits) {
          const float value = HalfToFloat(static_cast<uint16_t>(bits));
          g_dx9_half_to_unorm8_tables.srgb[bits] =
              FloatToUNorm8(value, true);
          g_dx9_half_to_unorm8_tables.linear[bits] =
              FloatToUNorm8(value, false);
        }
      });
}

void ConvertDX9HalfReadbackToSDR(
    const reshade::api::subresource_data& source_data,
    const reshade::api::subresource_data& dest_data,
    uint32_t width,
    uint32_t height,
    reshade::api::format dest_format) {
  EnsureDX9HalfToUNorm8Tables();

  const auto* source_base =
      static_cast<const uint8_t*>(source_data.data);
  auto* dest_base = static_cast<uint8_t*>(dest_data.data);

  const auto& rgb_table =
      DX9_READBACK_ENCODE_SRGB
          ? g_dx9_half_to_unorm8_tables.srgb
          : g_dx9_half_to_unorm8_tables.linear;
  const auto& alpha_table = g_dx9_half_to_unorm8_tables.linear;

  const bool write_bgra = IsBGRAReadbackFormat(dest_format);
  const bool force_opaque =
      DX9_READBACK_FORCE_OPAQUE_ALPHA
      || IsX8ReadbackFormat(dest_format);

  for (uint32_t y = 0u; y < height; ++y) {
    const auto* source_row = reinterpret_cast<const uint16_t*>(
        source_base + static_cast<size_t>(y) * source_data.row_pitch);
    auto* dest_row =
        dest_base + static_cast<size_t>(y) * dest_data.row_pitch;

    for (uint32_t x = 0u; x < width; ++x) {
      const auto* source_pixel = source_row + static_cast<size_t>(x) * 4u;
      auto* dest_pixel = dest_row + static_cast<size_t>(x) * 4u;

      const uint8_t r = rgb_table[source_pixel[0]];
      const uint8_t g = rgb_table[source_pixel[1]];
      const uint8_t b = rgb_table[source_pixel[2]];
      const uint8_t a =
          force_opaque ? 255u : alpha_table[source_pixel[3]];

      if (write_bgra) {
        dest_pixel[0] = b;
        dest_pixel[1] = g;
        dest_pixel[2] = r;
      } else {
        dest_pixel[0] = r;
        dest_pixel[1] = g;
        dest_pixel[2] = b;
      }
      dest_pixel[3] = a;
    }
  }
}

void WriteSDRPixel(
    uint8_t* dest,
    reshade::api::format dest_format,
    float red,
    float green,
    float blue,
    float alpha) {
  const uint8_t r = FloatToUNorm8(red, DX9_READBACK_ENCODE_SRGB);
  const uint8_t g = FloatToUNorm8(green, DX9_READBACK_ENCODE_SRGB);
  const uint8_t b = FloatToUNorm8(blue, DX9_READBACK_ENCODE_SRGB);

  const bool force_opaque =
      DX9_READBACK_FORCE_OPAQUE_ALPHA
      || IsX8ReadbackFormat(dest_format);

  const uint8_t a =
      force_opaque ? 255u : FloatToUNorm8(alpha, false);

  if (IsBGRAReadbackFormat(dest_format)) {
    dest[0] = b;
    dest[1] = g;
    dest[2] = r;
    dest[3] = a;
  } else {
    dest[0] = r;
    dest[1] = g;
    dest[2] = b;
    dest[3] = a;
  }
}

void LogDX9ReadbackFailure(
    const char* reason,
    const reshade::api::resource_desc& source_desc,
    const reshade::api::resource_desc& dest_desc) {
  if (g_dx9_readback_failure_logs >= 8u) return;
  ++g_dx9_readback_failure_logs;

  std::stringstream stream;
  stream << "[RenoDX DX9 Readback] " << reason;
  stream << " (source: " << source_desc.texture.format;
  stream << ", destination: " << dest_desc.texture.format;
  stream << ", size: " << source_desc.texture.width;
  stream << "x" << source_desc.texture.height << ")";
  reshade::log::message(
      reshade::log::level::warning,
      stream.str().c_str());
}

bool TryChainDX9CopyResource(
    reshade::api::command_list* cmd_list,
    const DX9CopyEndpoint& source_endpoint,
    const DX9CopyEndpoint& dest_endpoint) {
  if (!source_endpoint.has_clone || !dest_endpoint.has_clone) return false;

  const reshade::api::resource selected_source =
      SelectCloneForCopy(source_endpoint);
  const reshade::api::resource selected_dest =
      SelectCloneForCopy(dest_endpoint);

  if (selected_source.handle == 0u || selected_dest.handle == 0u) return false;

  // Nothing to replace if the application already supplied both clone handles.
  if (selected_source.handle == source_endpoint.input.handle
      && selected_dest.handle == dest_endpoint.input.handle) {
    return false;
  }

  const reshade::api::resource_desc selected_source_desc =
      SelectCloneDescForCopy(source_endpoint);
  const reshade::api::resource_desc selected_dest_desc =
      SelectCloneDescForCopy(dest_endpoint);

  if (!ExactCopyCompatible(
          selected_source_desc,
          selected_dest_desc)) {
    return false;
  }

  {
    ScopedDX9ReplacementCopy guard;
    cmd_list->copy_resource(selected_source, selected_dest);
  }

  if (g_dx9_chain_logs < 8u) {
    ++g_dx9_chain_logs;
    std::stringstream stream;
    stream << "[RenoDX DX9 Readback] Chained copy_resource through clones: ";
    stream << selected_source_desc.texture.format;
    stream << " -> " << selected_dest_desc.texture.format;
    reshade::log::message(
        reshade::log::level::info,
        stream.str().c_str());
  }

  return true;
}

bool TryRedirectDX9CloneReadbackToOriginal(
    reshade::api::command_list* cmd_list,
    const DX9CopyEndpoint& source_endpoint,
    reshade::api::resource dest,
    const reshade::api::resource_desc& dest_desc) {
  if (!source_endpoint.input_is_clone) return false;
  if (source_endpoint.original.handle == 0u
      || source_endpoint.original.handle
          == source_endpoint.input.handle) {
    return false;
  }
  if (!IsCPUVisibleReadbackHeap(dest_desc.heap)) return false;
  if (!ExactCopyCompatible(
          source_endpoint.original_desc,
          dest_desc)) {
    return false;
  }

  {
    ScopedDX9ReplacementCopy guard;
    cmd_list->copy_resource(source_endpoint.original, dest);
  }

  if (g_dx9_chain_logs < 8u) {
    ++g_dx9_chain_logs;
    std::stringstream stream;
    stream << "[RenoDX DX9 Readback] Redirected clone readback to its ";
    stream << "matching original SDR resource (";
    stream << source_endpoint.original_desc.texture.format;
    stream << " -> " << dest_desc.texture.format << ")";
    reshade::log::message(
        reshade::log::level::info,
        stream.str().c_str());
  }

  return true;
}


// ============================================================================
// Native D3D9 GPU FP16 -> SDR readback blit
// ============================================================================
//
// This is the DX9 equivalent of the Starfield readback idea, but it is generic
// to upgraded game resources and does not depend on photo mode or Starfield's
// embedded screenshot shaders. The FP16 RenoDX clone is sampled by a tiny
// runtime-compiled ps_3_0 shader and written into the game's original 8-bit
// render target. The game's normal compatible 8-bit readback can then proceed.
//
// If the clone is a standalone IDirect3DSurface9 (not directly sampleable), a
// reusable A16B16G16R16F render-target texture is used as a GPU-only sampling
// intermediate via StretchRect. No FP16 pixels are mapped to the CPU on this
// primary path.

using DX9D3DCompileFn = HRESULT(WINAPI*)(
    LPCVOID,
    SIZE_T,
    LPCSTR,
    const D3D_SHADER_MACRO*,
    ID3DInclude*,
    LPCSTR,
    LPCSTR,
    UINT,
    UINT,
    ID3DBlob**,
    ID3DBlob**);

DX9D3DCompileFn GetDX9D3DCompile() {
  static DX9D3DCompileFn compile = []() -> DX9D3DCompileFn {
    const char* compiler_names[] = {
        "d3dcompiler_47.dll",
        "d3dcompiler_46.dll",
        "d3dcompiler_43.dll",
    };

    for (const char* name : compiler_names) {
      HMODULE module = LoadLibraryA(name);
      if (module == nullptr) continue;
      auto* proc = GetProcAddress(module, "D3DCompile");
      if (proc != nullptr) {
        return reinterpret_cast<DX9D3DCompileFn>(proc);
      }
    }
    return nullptr;
  }();
  return compile;
}

void ReleaseDX9NativeReadbackCacheUnlocked() {
  auto& cache = g_dx9_native_readback_cache;

  if (cache.sampling_texture != nullptr) {
    cache.sampling_texture->Release();
    cache.sampling_texture = nullptr;
  }
  if (cache.state_block != nullptr) {
    cache.state_block->Release();
    cache.state_block = nullptr;
  }
  if (cache.pixel_shader != nullptr) {
    cache.pixel_shader->Release();
    cache.pixel_shader = nullptr;
  }

  cache = {};
}

void ClearDX9NativeReadbackCache() {
  // Used only at DLL detach. Do not Release COM objects while the Windows loader
  // lock is held. Normal Reset/device teardown releases them through the
  // destroy_device callback; process teardown reclaims anything remaining.
  g_dx9_native_readback_cache = {};
}

IDirect3DDevice9* GetNativeD3D9Device(reshade::api::device* device) {
  if (device == nullptr || device->get_api() != reshade::api::device_api::d3d9) {
    return nullptr;
  }
  return reinterpret_cast<IDirect3DDevice9*>(device->get_native());
}

IDirect3DSurface9* GetDX9SurfaceFromResource(reshade::api::resource resource) {
  if (resource.handle == 0u) return nullptr;

  auto* object = reinterpret_cast<IUnknown*>(
      static_cast<uintptr_t>(resource.handle));
  if (object == nullptr) return nullptr;

  IDirect3DSurface9* surface = nullptr;
  if (SUCCEEDED(object->QueryInterface(
          __uuidof(IDirect3DSurface9),
          reinterpret_cast<void**>(&surface)))) {
    return surface;
  }

  IDirect3DTexture9* texture = nullptr;
  if (FAILED(object->QueryInterface(
          __uuidof(IDirect3DTexture9),
          reinterpret_cast<void**>(&texture)))) {
    return nullptr;
  }

  const HRESULT hr = texture->GetSurfaceLevel(0u, &surface);
  texture->Release();
  return SUCCEEDED(hr) ? surface : nullptr;
}

IDirect3DTexture9* GetDX9TextureFromResource(reshade::api::resource resource) {
  if (resource.handle == 0u) return nullptr;

  auto* object = reinterpret_cast<IUnknown*>(
      static_cast<uintptr_t>(resource.handle));
  if (object == nullptr) return nullptr;

  IDirect3DTexture9* texture = nullptr;
  if (FAILED(object->QueryInterface(
          __uuidof(IDirect3DTexture9),
          reinterpret_cast<void**>(&texture)))) {
    return nullptr;
  }
  return texture;
}

bool EnsureDX9NativeReadbackShader(
    IDirect3DDevice9* d3d_device,
    DX9NativeReadbackBlitCache& cache) {
  if (cache.pixel_shader != nullptr) return true;
  if (d3d_device == nullptr) return false;

  auto* compile = GetDX9D3DCompile();
  if (compile == nullptr) {
    if (g_dx9_gpu_blit_failure_logs < 8u) {
      ++g_dx9_gpu_blit_failure_logs;
      reshade::log::message(
          reshade::log::level::warning,
          "[RenoDX DX9 Readback] Could not load D3DCompile for GPU readback blit");
    }
    return false;
  }

  // Matches the old CPU fallback: clamp to SDR, encode linear RGB to sRGB, and
  // preserve alpha unless the destination is an X8 surface.
  static constexpr char PIXEL_SHADER_SOURCE[] = R"hlsl(
    sampler2D SourceSampler : register(s0);
    float4 ReadbackOptions : register(c0); // x = force opaque alpha

    float3 LinearToSRGB(float3 linearColor)
    {
        linearColor = saturate(linearColor);
        float3 low = linearColor * 12.92;
        float3 exponentValue = float3(1.0 / 2.4, 1.0 / 2.4, 1.0 / 2.4);
        float3 high = 1.055 * pow(max(linearColor, 0.0), exponentValue) - 0.055;
        float3 threshold = float3(0.0031308, 0.0031308, 0.0031308);
        float3 useHigh = step(threshold, linearColor);
        return lerp(low, high, useHigh);
    }

    float4 main(float2 texCoord : TEXCOORD0) : COLOR0
    {
        float4 color = tex2D(SourceSampler, texCoord);
        float3 linearRGB = saturate(color.rgb);
        float3 encodedRGB = LinearToSRGB(linearRGB);
        color.rgb = lerp(linearRGB, encodedRGB, saturate(ReadbackOptions.y));
        color.a = lerp(saturate(color.a), 1.0, saturate(ReadbackOptions.x));
        return color;
    }
  )hlsl";

  ID3DBlob* shader_blob = nullptr;
  ID3DBlob* error_blob = nullptr;
  const HRESULT compile_hr = compile(
      PIXEL_SHADER_SOURCE,
      sizeof(PIXEL_SHADER_SOURCE) - 1u,
      "renodx_dx9_readback_blit",
      nullptr,
      nullptr,
      "main",
      "ps_3_0",
      D3DCOMPILE_OPTIMIZATION_LEVEL3,
      0u,
      &shader_blob,
      &error_blob);

  if (FAILED(compile_hr) || shader_blob == nullptr) {
    if (g_dx9_gpu_blit_failure_logs < 8u) {
      ++g_dx9_gpu_blit_failure_logs;
      std::stringstream stream;
      stream << "[RenoDX DX9 Readback] Failed to compile native ps_3_0 readback blit";
      stream << " (hr=0x" << std::hex << static_cast<uint32_t>(compile_hr) << std::dec << ")";
      if (error_blob != nullptr && error_blob->GetBufferPointer() != nullptr) {
        stream << ": " << static_cast<const char*>(error_blob->GetBufferPointer());
      }
      reshade::log::message(reshade::log::level::warning, stream.str().c_str());
    }
    if (error_blob != nullptr) error_blob->Release();
    if (shader_blob != nullptr) shader_blob->Release();
    return false;
  }

  const HRESULT create_hr = d3d_device->CreatePixelShader(
      static_cast<const DWORD*>(shader_blob->GetBufferPointer()),
      &cache.pixel_shader);

  if (error_blob != nullptr) error_blob->Release();
  shader_blob->Release();

  if (FAILED(create_hr) || cache.pixel_shader == nullptr) {
    if (g_dx9_gpu_blit_failure_logs < 8u) {
      ++g_dx9_gpu_blit_failure_logs;
      reshade::log::message(
          reshade::log::level::warning,
          "[RenoDX DX9 Readback] Failed to create native D3D9 pixel shader");
    }
    return false;
  }

  return true;
}

bool EnsureDX9NativeReadbackStateBlock(
    IDirect3DDevice9* d3d_device,
    DX9NativeReadbackBlitCache& cache) {
  if (cache.state_block != nullptr) return true;
  if (d3d_device == nullptr) return false;
  return SUCCEEDED(d3d_device->CreateStateBlock(
      D3DSBT_ALL,
      &cache.state_block));
}

bool EnsureDX9SamplingTexture(
    IDirect3DDevice9* d3d_device,
    DX9NativeReadbackBlitCache& cache,
    uint32_t width,
    uint32_t height) {
  if (d3d_device == nullptr || width == 0u || height == 0u) return false;

  if (cache.sampling_texture != nullptr
      && cache.sampling_width == width
      && cache.sampling_height == height) {
    return true;
  }

  if (cache.sampling_texture != nullptr) {
    cache.sampling_texture->Release();
    cache.sampling_texture = nullptr;
  }
  cache.sampling_width = 0u;
  cache.sampling_height = 0u;

  const HRESULT hr = d3d_device->CreateTexture(
      width,
      height,
      1u,
      D3DUSAGE_RENDERTARGET,
      D3DFMT_A16B16G16R16F,
      D3DPOOL_DEFAULT,
      &cache.sampling_texture,
      nullptr);

  if (FAILED(hr) || cache.sampling_texture == nullptr) return false;

  cache.sampling_width = width;
  cache.sampling_height = height;
  return true;
}

IDirect3DTexture9* PrepareDX9ReadbackSourceTexture(
    IDirect3DDevice9* d3d_device,
    DX9NativeReadbackBlitCache& cache,
    reshade::api::resource clone,
    const reshade::api::resource_desc& clone_desc) {
  // Best case: the clone is already a texture and can be sampled directly.
  if (IDirect3DTexture9* texture = GetDX9TextureFromResource(clone)) {
    return texture;  // QueryInterface reference, caller releases.
  }

  // D3D9 render targets may instead be standalone surfaces. Keep the conversion
  // GPU-only by StretchRect'ing that FP16 surface into a reusable FP16 texture.
  IDirect3DSurface9* clone_surface = GetDX9SurfaceFromResource(clone);
  if (clone_surface == nullptr) return nullptr;

  if (!EnsureDX9SamplingTexture(
          d3d_device,
          cache,
          clone_desc.texture.width,
          clone_desc.texture.height)) {
    clone_surface->Release();
    return nullptr;
  }

  IDirect3DSurface9* sampling_surface = nullptr;
  const HRESULT level_hr = cache.sampling_texture->GetSurfaceLevel(
      0u,
      &sampling_surface);
  if (FAILED(level_hr) || sampling_surface == nullptr) {
    clone_surface->Release();
    return nullptr;
  }

  const HRESULT copy_hr = d3d_device->StretchRect(
      clone_surface,
      nullptr,
      sampling_surface,
      nullptr,
      D3DTEXF_NONE);

  sampling_surface->Release();
  clone_surface->Release();

  if (FAILED(copy_hr)) return nullptr;

  cache.sampling_texture->AddRef();
  return cache.sampling_texture;
}

struct DX9FullscreenVertex {
  float x;
  float y;
  float z;
  float rhw;
  float u;
  float v;
};

bool BlitDX9CloneToOriginalSDR(
    reshade::api::device* device,
    const DX9CopyEndpoint& source_endpoint) {

  if (!DX9_READBACK_GPU_BLIT_ENABLED || device == nullptr) return false;
  if (!source_endpoint.has_clone
      || !source_endpoint.clone_enabled
      || source_endpoint.clone.handle == 0u
      || source_endpoint.original.handle == 0u) {
    return false;
  }

  if (!IsFloat16RGBA(source_endpoint.clone_desc.texture.format)) return false;
  if (!IsSupportedSDRReadbackFormat(source_endpoint.original_desc.texture.format)) {
    return false;
  }
  if (!SameTextureExtent(
          source_endpoint.clone_desc,
          source_endpoint.original_desc)) {
    return false;
  }
  if (source_endpoint.clone_desc.texture.samples != 1u
      || source_endpoint.original_desc.texture.samples != 1u
      || source_endpoint.clone_desc.texture.depth_or_layers != 1u
      || source_endpoint.original_desc.texture.depth_or_layers != 1u) {
    return false;
  }

  IDirect3DDevice9* d3d_device = GetNativeD3D9Device(device);
  if (d3d_device == nullptr) return false;

  std::scoped_lock cache_lock(g_dx9_native_readback_mutex);
  auto& cache = g_dx9_native_readback_cache;

  if (cache.device != device) {
    ReleaseDX9NativeReadbackCacheUnlocked();
    cache.device = device;
  }

  if (!EnsureDX9NativeReadbackShader(d3d_device, cache)
      || !EnsureDX9NativeReadbackStateBlock(d3d_device, cache)) {
    return false;
  }

  IDirect3DTexture9* source_texture = PrepareDX9ReadbackSourceTexture(
      d3d_device,
      cache,
      source_endpoint.clone,
      source_endpoint.clone_desc);
  if (source_texture == nullptr) return false;

  IDirect3DSurface9* destination_surface =
      GetDX9SurfaceFromResource(source_endpoint.original);
  if (destination_surface == nullptr) {
    source_texture->Release();
    return false;
  }

  // Capture the complete game state before touching RT/shader/sampler bindings.
  // D3D9 state blocks do not reliably restore render targets/depth surfaces, so
  // save those explicitly too.
  if (FAILED(cache.state_block->Capture())) {
    destination_surface->Release();
    source_texture->Release();
    return false;
  }

  IDirect3DSurface9* old_render_target = nullptr;
  IDirect3DSurface9* old_depth_stencil = nullptr;
  d3d_device->GetRenderTarget(0u, &old_render_target);
  d3d_device->GetDepthStencilSurface(&old_depth_stencil);

  const uint32_t width = source_endpoint.original_desc.texture.width;
  const uint32_t height = source_endpoint.original_desc.texture.height;
  D3DVIEWPORT9 viewport = {
      0u,
      0u,
      width,
      height,
      0.0f,
      1.0f,
  };

  const DX9FullscreenVertex vertices[4] = {
      {-0.5f, -0.5f, 0.0f, 1.0f, 0.0f, 0.0f},
      {static_cast<float>(width) - 0.5f, -0.5f, 0.0f, 1.0f, 1.0f, 0.0f},
      {-0.5f, static_cast<float>(height) - 0.5f, 0.0f, 1.0f, 0.0f, 1.0f},
      {static_cast<float>(width) - 0.5f,
       static_cast<float>(height) - 0.5f,
       0.0f,
       1.0f,
       1.0f,
       1.0f},
  };

  const float shader_options[4] = {
      (DX9_READBACK_FORCE_OPAQUE_ALPHA
       || IsX8ReadbackFormat(source_endpoint.original_desc.texture.format))
          ? 1.0f
          : 0.0f,
      DX9_READBACK_ENCODE_SRGB ? 1.0f : 0.0f,
      0.0f,
      0.0f,
  };

  HRESULT draw_hr = S_OK;
  bool began_scene = false;
  {
    // Prevent the StretchRect/copy activity generated by this compatibility
    // pass from recursively entering the addon readback handlers.
    ScopedDX9ReplacementCopy guard;

    // GetRenderTargetData-style reads frequently occur after EndScene. Begin a
    // tiny scene when possible. If BeginScene returns D3DERR_INVALIDCALL the
    // game is already inside a scene, so drawing may proceed normally.
    const HRESULT begin_scene_hr = d3d_device->BeginScene();
    began_scene = SUCCEEDED(begin_scene_hr);

    if (FAILED(d3d_device->SetRenderTarget(0u, destination_surface))
        || FAILED(d3d_device->SetDepthStencilSurface(nullptr))
        || FAILED(d3d_device->SetViewport(&viewport))
        || FAILED(d3d_device->SetVertexShader(nullptr))
        || FAILED(d3d_device->SetPixelShader(cache.pixel_shader))
        || FAILED(d3d_device->SetFVF(D3DFVF_XYZRHW | D3DFVF_TEX1))
        || FAILED(d3d_device->SetTexture(0u, source_texture))) {
      draw_hr = E_FAIL;
    }

    if (SUCCEEDED(draw_hr)) {
      d3d_device->SetSamplerState(0u, D3DSAMP_ADDRESSU, D3DTADDRESS_CLAMP);
      d3d_device->SetSamplerState(0u, D3DSAMP_ADDRESSV, D3DTADDRESS_CLAMP);
      d3d_device->SetSamplerState(0u, D3DSAMP_MINFILTER, D3DTEXF_POINT);
      d3d_device->SetSamplerState(0u, D3DSAMP_MAGFILTER, D3DTEXF_POINT);
      d3d_device->SetSamplerState(0u, D3DSAMP_MIPFILTER, D3DTEXF_NONE);
      d3d_device->SetSamplerState(0u, D3DSAMP_SRGBTEXTURE, FALSE);

      d3d_device->SetRenderState(D3DRS_ZENABLE, FALSE);
      d3d_device->SetRenderState(D3DRS_ZWRITEENABLE, FALSE);
      d3d_device->SetRenderState(D3DRS_STENCILENABLE, FALSE);
      d3d_device->SetRenderState(D3DRS_ALPHATESTENABLE, FALSE);
      d3d_device->SetRenderState(D3DRS_ALPHABLENDENABLE, FALSE);
      d3d_device->SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
      d3d_device->SetRenderState(D3DRS_SCISSORTESTENABLE, FALSE);
      d3d_device->SetRenderState(D3DRS_SRGBWRITEENABLE, FALSE);
      d3d_device->SetRenderState(
          D3DRS_COLORWRITEENABLE,
          D3DCOLORWRITEENABLE_RED
              | D3DCOLORWRITEENABLE_GREEN
              | D3DCOLORWRITEENABLE_BLUE
              | D3DCOLORWRITEENABLE_ALPHA);

      d3d_device->SetPixelShaderConstantF(0u, shader_options, 1u);

      draw_hr = d3d_device->DrawPrimitiveUP(
          D3DPT_TRIANGLESTRIP,
          2u,
          vertices,
          sizeof(DX9FullscreenVertex));
    }

    if (began_scene) {
      const HRESULT end_scene_hr = d3d_device->EndScene();
      if (SUCCEEDED(draw_hr) && FAILED(end_scene_hr)) draw_hr = end_scene_hr;
    }
  }

  // Restore RT/depth explicitly, then restore the rest of the game state.
  if (old_render_target != nullptr) {
    d3d_device->SetRenderTarget(0u, old_render_target);
  }
  d3d_device->SetDepthStencilSurface(old_depth_stencil);
  cache.state_block->Apply();

  if (old_depth_stencil != nullptr) old_depth_stencil->Release();
  if (old_render_target != nullptr) old_render_target->Release();
  destination_surface->Release();
  source_texture->Release();

  if (FAILED(draw_hr)) {
    if (g_dx9_gpu_blit_failure_logs < 8u) {
      ++g_dx9_gpu_blit_failure_logs;
      reshade::log::message(
          reshade::log::level::warning,
          "[RenoDX DX9 Readback] Native GPU FP16 -> SDR blit failed; using CPU fallback");
    }
    return false;
  }

  if (g_dx9_gpu_blit_success_logs < 8u) {
    ++g_dx9_gpu_blit_success_logs;
    std::stringstream stream;
    stream << "[RenoDX DX9 Readback] GPU FP16 -> SDR compatibility blit (";
    stream << source_endpoint.clone_desc.texture.format;
    stream << " -> " << source_endpoint.original_desc.texture.format;
    stream << ", " << width << "x" << height << ")";
    reshade::log::message(
        reshade::log::level::info,
        stream.str().c_str());
  }

  return true;
}

enum class DX9GPUReadbackResult : uint32_t {
  NOT_HANDLED = 0u,
  CONTINUE_ORIGINAL_COPY,
  REPLACED_COPY,
};

DX9GPUReadbackResult TryHandleDX9ReadbackOnGPU(
    reshade::api::command_list* cmd_list,
    const DX9CopyEndpoint& source_endpoint,
    reshade::api::resource dest,
    const reshade::api::resource_desc& dest_desc) {
  if (!DX9_READBACK_GPU_BLIT_ENABLED
      || cmd_list == nullptr
      || dest.handle == 0u) {
    return DX9GPUReadbackResult::NOT_HANDLED;
  }

  if (!source_endpoint.has_clone
      || !source_endpoint.clone_enabled
      || !IsFloat16RGBA(source_endpoint.clone_desc.texture.format)
      || !IsSupportedSDRReadbackFormat(
          source_endpoint.original_desc.texture.format)
      || !IsSupportedSDRReadbackFormat(dest_desc.texture.format)
      || source_endpoint.original_desc.texture.format != dest_desc.texture.format
      || !IsCPUVisibleReadbackHeap(dest_desc.heap)
      || !SameTextureExtent(source_endpoint.clone_desc, dest_desc)
      || !SameTextureExtent(source_endpoint.original_desc, dest_desc)) {
    return DX9GPUReadbackResult::NOT_HANDLED;
  }

  auto* device = cmd_list->get_device();
  if (device == nullptr
      || device->get_api() != reshade::api::device_api::d3d9) {
    return DX9GPUReadbackResult::NOT_HANDLED;
  }

  if (!BlitDX9CloneToOriginalSDR(device, source_endpoint)) {
    return DX9GPUReadbackResult::NOT_HANDLED;
  }

  // ReShade may report the app's readback source either as the original handle
  // or directly as the enabled clone. If it is the original, leave the original
  // D3D9 GetRenderTargetData/copy alone: it is now an ordinary 8-bit -> 8-bit
  // readback. If it is the clone, replace only that incompatible copy with the
  // newly refreshed original SDR surface.
  if (!source_endpoint.input_is_clone) {
    return DX9GPUReadbackResult::CONTINUE_ORIGINAL_COPY;
  }

  IDirect3DDevice9* d3d_device = GetNativeD3D9Device(device);
  IDirect3DSurface9* original_surface =
      GetDX9SurfaceFromResource(source_endpoint.original);
  IDirect3DSurface9* dest_surface = GetDX9SurfaceFromResource(dest);

  if (d3d_device == nullptr
      || original_surface == nullptr
      || dest_surface == nullptr) {
    if (dest_surface != nullptr) dest_surface->Release();
    if (original_surface != nullptr) original_surface->Release();
    return DX9GPUReadbackResult::NOT_HANDLED;
  }

  HRESULT copy_hr = E_FAIL;
  {
    ScopedDX9ReplacementCopy guard;
    copy_hr = d3d_device->GetRenderTargetData(original_surface, dest_surface);
  }

  dest_surface->Release();
  original_surface->Release();

  if (FAILED(copy_hr)) {
    return DX9GPUReadbackResult::NOT_HANDLED;
  }

  return DX9GPUReadbackResult::REPLACED_COPY;
}

void OnInitDeviceDX9NativeReadback(reshade::api::device* device) {

  if (device == nullptr || device->get_api() != reshade::api::device_api::d3d9) {
    return;
  }


  std::scoped_lock lock(g_dx9_native_readback_mutex);
  if (g_dx9_native_readback_cache.device != device) {
    ReleaseDX9NativeReadbackCacheUnlocked();
    g_dx9_native_readback_cache.device = device;
  }
}

void OnDestroyDeviceDX9NativeReadback(reshade::api::device* device) {

  if (device == nullptr) return;

  std::scoped_lock lock(g_dx9_native_readback_mutex);
  if (g_dx9_native_readback_cache.device == device) {
    ReleaseDX9NativeReadbackCacheUnlocked();
  }
}

// Reusable CPU-visible FP16 staging surface for GetRenderTargetData.
// The old path allocated and destroyed this surface for every incompatible
// FP16 -> 8-bit readback. Caching it removes that repeated D3D9 resource churn.
struct DX9ReadbackStagingCache {
  reshade::api::device* device = nullptr;
  reshade::api::resource resource = {0u};
  reshade::api::resource_desc desc = {};
};

std::mutex g_dx9_readback_staging_mutex;
DX9ReadbackStagingCache g_dx9_readback_staging_cache;

bool DX9StagingDescMatches(
    const reshade::api::resource_desc& cached,
    const reshade::api::resource_desc& wanted) {
  if (cached.type == reshade::api::resource_type::unknown
      || wanted.type == reshade::api::resource_type::unknown) {
    return false;
  }

  return cached.type == wanted.type
      && cached.heap == wanted.heap
      && cached.usage == wanted.usage
      && cached.texture.format == wanted.texture.format
      && cached.texture.width == wanted.texture.width
      && cached.texture.height == wanted.texture.height
      && cached.texture.depth_or_layers == wanted.texture.depth_or_layers
      && cached.texture.levels == wanted.texture.levels
      && cached.texture.samples == wanted.texture.samples;
}

bool EnsureDX9ReadbackStaging(
    reshade::api::device* device,
    const reshade::api::resource_desc& wanted_desc,
    reshade::api::resource& staging) {
  if (device == nullptr) return false;

  auto& cache = g_dx9_readback_staging_cache;

  if (cache.device == device
      && cache.resource.handle != 0u
      && DX9StagingDescMatches(cache.desc, wanted_desc)) {
    staging = cache.resource;
    return true;
  }

  // Same live D3D9 device but dimensions/format changed: release the old cached
  // surface before replacing it. If the device changed, simply forget the old
  // handle; the old D3D9 device owns its resources and reclaims them on teardown.
  if (cache.device == device && cache.resource.handle != 0u) {
    device->destroy_resource(cache.resource);
  }

  cache = {};
  cache.device = device;

  if (!device->create_resource(
          wanted_desc,
          nullptr,
          reshade::api::resource_usage::copy_dest,
          &cache.resource)) {
    cache = {};
    return false;
  }

  cache.desc = wanted_desc;
  staging = cache.resource;
  return true;
}

// Called only while g_dx9_readback_staging_mutex is already held.
void InvalidateDX9ReadbackStaging(reshade::api::device* device) {
  auto& cache = g_dx9_readback_staging_cache;

  if (device != nullptr
      && cache.device == device
      && cache.resource.handle != 0u) {
    device->destroy_resource(cache.resource);
  }

  cache = {};
}

void ClearDX9ReadbackStagingCache() {
  // DLL_PROCESS_DETACH runs under the loader lock, so do not wait on the staging
  // mutex or call through a possibly-destroyed D3D9 device here. The D3D9 device
  // owns the cached allocation and frees it during device/process teardown.
  g_dx9_readback_staging_cache = {};
}

bool TryConvertDX9FloatReadbackToSDR(
    reshade::api::command_list* cmd_list,
    const DX9CopyEndpoint& source_endpoint,
    reshade::api::resource dest,
    const reshade::api::resource_desc& dest_desc) {
  auto* device = cmd_list != nullptr ? cmd_list->get_device() : nullptr;
  if (device == nullptr) return false;

  const reshade::api::resource float_source =
      SelectCloneForCopy(source_endpoint);
  const reshade::api::resource_desc float_source_desc =
      SelectCloneDescForCopy(source_endpoint);

  if (float_source.handle == 0u) return false;
  if (!IsTextureResource(float_source_desc)
      || !IsTextureResource(dest_desc)) {
    return false;
  }
  if (!IsFloat16RGBA(float_source_desc.texture.format)) return false;
  if (!IsSupportedSDRReadbackFormat(dest_desc.texture.format)) return false;
  if (!IsCPUVisibleReadbackHeap(dest_desc.heap)) return false;
  if (!SameTextureExtent(float_source_desc, dest_desc)) return false;
  if (float_source_desc.texture.depth_or_layers != 1u
      || dest_desc.texture.depth_or_layers != 1u) {
    return false;
  }
  if (float_source_desc.texture.samples != 1u
      || dest_desc.texture.samples != 1u) {
    return false;
  }

  // GetRenderTargetData is a whole-surface operation, so make a matching
  // CPU-visible float surface first. Its format matches the cloned source,
  // allowing D3D9 to perform the GPU readback legally.
  reshade::api::resource_desc staging_desc = float_source_desc;
  staging_desc.heap = reshade::api::memory_heap::gpu_to_cpu;
  staging_desc.usage = reshade::api::resource_usage::copy_dest;
  staging_desc.flags = {};
  staging_desc.texture.depth_or_layers = 1u;
  staging_desc.texture.levels = 1u;
  staging_desc.texture.samples = 1u;

  reshade::api::resource staging = {0u};

  // One cached staging surface is shared by D3D9 readbacks. Hold the lock across
  // copy/map/CPU conversion so another callback cannot overwrite it mid-readback.
  std::scoped_lock staging_lock(g_dx9_readback_staging_mutex);

  if (!EnsureDX9ReadbackStaging(
          device,
          staging_desc,
          staging)) {
    LogDX9ReadbackFailure(
        "Could not create/reuse the float16 CPU staging surface",
        float_source_desc,
        dest_desc);
    return false;
  }

  {
    ScopedDX9ReplacementCopy guard;
    cmd_list->copy_resource(float_source, staging);
  }

  reshade::api::subresource_data source_data = {};
  if (!device->map_texture_region(
          staging,
          0u,
          nullptr,
          reshade::api::map_access::read_only,
          &source_data)) {
    InvalidateDX9ReadbackStaging(device);
    LogDX9ReadbackFailure(
        "Could not map the float16 CPU staging surface",
        float_source_desc,
        dest_desc);
    return false;
  }

  reshade::api::subresource_data dest_data = {};
  if (!device->map_texture_region(
          dest,
          0u,
          nullptr,
          reshade::api::map_access::write_only,
          &dest_data)) {
    device->unmap_texture_region(staging, 0u);
    LogDX9ReadbackFailure(
        "Could not map the game's 8-bit readback surface",
        float_source_desc,
        dest_desc);
    return false;
  }

  const uint32_t width = float_source_desc.texture.width;
  const uint32_t height = float_source_desc.texture.height;

  ConvertDX9HalfReadbackToSDR(
      source_data,
      dest_data,
      width,
      height,
      dest_desc.texture.format);

  device->unmap_texture_region(dest, 0u);
  device->unmap_texture_region(staging, 0u);

  if (g_dx9_readback_success_logs < 8u) {
    ++g_dx9_readback_success_logs;

    std::stringstream stream;
    stream << "[RenoDX DX9 Readback] Replaced incompatible float16 -> SDR ";
    stream << "GetRenderTargetData copy (";
    stream << float_source_desc.texture.format;
    stream << " -> " << dest_desc.texture.format;
    stream << ", " << width << "x" << height << ")";
    reshade::log::message(
        reshade::log::level::info,
        stream.str().c_str());
  }

  return true;
}

bool OnDX9CopyResource(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    reshade::api::resource dest) {

  if (!DX9_READBACK_FIX_ENABLED
      || g_inside_dx9_replacement_copy
      || cmd_list == nullptr
      || source.handle == 0u
      || dest.handle == 0u) {
    return false;
  }

  auto* device = cmd_list->get_device();
  if (device == nullptr
      || device->get_api() != reshade::api::device_api::d3d9) {
    return false;
  }

  const DX9CopyEndpoint source_endpoint =
      ResolveDX9CopyEndpoint(device, source);
  const DX9CopyEndpoint dest_endpoint =
      ResolveDX9CopyEndpoint(device, dest);

  // First handle normal GPU scratch copies where both original resources were
  // cloned/upgraded. This is the D3D9 equivalent of resource chaining.
  if (TryChainDX9CopyResource(
          cmd_list,
          source_endpoint,
          dest_endpoint)) {
    return true;
  }

  // Then handle GetRenderTargetData. If ReShade supplied the clone handle
  // directly and RenoDX still has a matching original SDR surface, prefer that
  // zero-conversion path before falling back to CPU float16 -> 8-bit conversion.
  // ResolveDX9CopyEndpoint already queried this descriptor. Reuse it instead of
  // asking the resource tracker/device for the same description a second time.
  const reshade::api::resource_desc& dest_desc = dest_endpoint.input_desc;

  switch (TryHandleDX9ReadbackOnGPU(
              cmd_list,
              source_endpoint,
              dest,
              dest_desc)) {
    case DX9GPUReadbackResult::REPLACED_COPY:
      return true;
    case DX9GPUReadbackResult::CONTINUE_ORIGINAL_COPY:
      return false;
    default:
      break;
  }

  if (TryRedirectDX9CloneReadbackToOriginal(
          cmd_list,
          source_endpoint,
          dest,
          dest_desc)) {
    return true;
  }

  if (DX9_READBACK_CPU_FALLBACK_ENABLED
      && TryConvertDX9FloatReadbackToSDR(
          cmd_list,
          source_endpoint,
          dest,
          dest_desc)) {
    return true;
  }

  return false;
}

bool OnDX9CopyTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    const reshade::api::subresource_box* dest_box,
    reshade::api::filter_mode filter) {

  if (!DX9_READBACK_FIX_ENABLED
      || g_inside_dx9_replacement_copy
      || cmd_list == nullptr
      || source.handle == 0u
      || dest.handle == 0u) {
    return false;
  }

  auto* device = cmd_list->get_device();
  if (device == nullptr
      || device->get_api() != reshade::api::device_api::d3d9) {
    return false;
  }

  const DX9CopyEndpoint source_endpoint =
      ResolveDX9CopyEndpoint(device, source);
  const DX9CopyEndpoint dest_endpoint =
      ResolveDX9CopyEndpoint(device, dest);

  if (!source_endpoint.has_clone || !dest_endpoint.has_clone) return false;

  const reshade::api::resource selected_source =
      SelectCloneForCopy(source_endpoint);
  const reshade::api::resource selected_dest =
      SelectCloneForCopy(dest_endpoint);

  const reshade::api::resource_desc selected_source_desc =
      SelectCloneDescForCopy(source_endpoint);
  const reshade::api::resource_desc selected_dest_desc =
      SelectCloneDescForCopy(dest_endpoint);

  // The original source/destination boxes remain valid only when cloning kept
  // each resource's dimensions unchanged.
  if (!SameTextureExtent(
          source_endpoint.original_desc,
          selected_source_desc)
      || !SameTextureExtent(
          dest_endpoint.original_desc,
          selected_dest_desc)
      || selected_source_desc.texture.format
          != selected_dest_desc.texture.format) {
    return false;
  }

  if (selected_source.handle == source.handle
      && selected_dest.handle == dest.handle) {
    return false;
  }

  {
    ScopedDX9ReplacementCopy guard;
    cmd_list->copy_texture_region(
        selected_source,
        source_subresource,
        source_box,
        selected_dest,
        dest_subresource,
        dest_box,
        filter);
  }

  return true;
}

bool OnDX9ResolveTextureRegion(
    reshade::api::command_list* cmd_list,
    reshade::api::resource source,
    uint32_t source_subresource,
    const reshade::api::subresource_box* source_box,
    reshade::api::resource dest,
    uint32_t dest_subresource,
    uint32_t dest_x,
    uint32_t dest_y,
    uint32_t dest_z,
    reshade::api::format format) {

  if (!DX9_READBACK_FIX_ENABLED
      || g_inside_dx9_replacement_copy
      || cmd_list == nullptr
      || source.handle == 0u
      || dest.handle == 0u) {
    return false;
  }

  (void)format;

  auto* device = cmd_list->get_device();
  if (device == nullptr
      || device->get_api() != reshade::api::device_api::d3d9) {
    return false;
  }

  const DX9CopyEndpoint source_endpoint =
      ResolveDX9CopyEndpoint(device, source);
  const DX9CopyEndpoint dest_endpoint =
      ResolveDX9CopyEndpoint(device, dest);

  if (!source_endpoint.has_clone || !dest_endpoint.has_clone) return false;

  const reshade::api::resource selected_source =
      SelectCloneForCopy(source_endpoint);
  const reshade::api::resource selected_dest =
      SelectCloneForCopy(dest_endpoint);

  const reshade::api::resource_desc selected_source_desc =
      SelectCloneDescForCopy(source_endpoint);
  const reshade::api::resource_desc selected_dest_desc =
      SelectCloneDescForCopy(dest_endpoint);

  if (!SameTextureExtent(
          source_endpoint.original_desc,
          selected_source_desc)
      || !SameTextureExtent(
          dest_endpoint.original_desc,
          selected_dest_desc)
      || selected_source_desc.texture.format
          != selected_dest_desc.texture.format) {
    return false;
  }

  if (selected_source.handle == source.handle
      && selected_dest.handle == dest.handle) {
    return false;
  }

  const reshade::api::format selected_format =
      selected_dest_desc.texture.format;

  {
    ScopedDX9ReplacementCopy guard;
    cmd_list->resolve_texture_region(
        selected_source,
        source_subresource,
        source_box,
        selected_dest,
        dest_subresource,
        dest_x,
        dest_y,
        dest_z,
        selected_format);
  }

  return true;
}

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },
#if 0  // Automatic DX9 output unclamper disabled
    new renodx::utils::settings::Setting{
        .key = "DX9AutoOutputUnclamp",
        .binding = &dx9_auto_output_unclamp_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 3.f,
        .can_reset = true,
        .label = "Automatic Output Unclamp",
        .section = "HDR Pipeline",
        .tooltip = "Sky-test build: Level 3 applies the weapon-style terminal "
                   "highlight unclamp to almost every strict terminal sqrt output and "
                   "also to the two confirmed BO1 sky/cloud hashes and additional "
                   "sky-like shaders. The rewrite is only "
                   "sqrt(saturate(finalLighting)) -> sqrt(max(finalLighting, 0)); no "
                   "brightness multiplier, guarded reconstruction, or internal material "
                   "changes are used. Structural fog and utility shaders remain filtered. "
                   "Level 4 is a safe alias of level 3. Requires restart.",
        .labels = {
            "Off",
            "Curated post (sky/fog protected)",
            "Curated post + known viewmodels",
            "Broad highlights + broader sky test",
            "Same as level 3 (sky test alias)",
        },
        .is_global = true,
        .is_visible = []() { return false; },
    },
#endif  // Automatic DX9 output unclamper setting
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT", "PsychoV24"},
        .parse = [](float value) {
          if (value < 0.5f) return TONE_MAP_TYPE_VANILLA;
          if (value < 1.5f) return TONE_MAP_TYPE_RENODRT;
          return TONE_MAP_TYPE_PSYCHOV24;
        },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = false,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapScaling",
        .binding = &shader_injection.tone_map_per_channel,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Scaling",
        .section = "Tone Mapping",
        .tooltip = "Luminance scales colors consistently while per-channel saturates and blows out sooner",
        .labels = {"Luminance", "Per Channel"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapWorkingColorSpace",
        .binding = &shader_injection.tone_map_working_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Working Color Space",
        .section = "Tone Mapping",
        .labels = {"BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "HDRBoost",
        .binding = &shader_injection.hdr_boost,
        .default_value = 0.f,
        .label = "HDR Boost",
        .section = "Tone Mapping",
        .tooltip = "Applies the common.hlsl HDRBoost power curve before RenoDRT or PsychoV24. 0 disables it; 20 matches the common.hlsl default power of 0.20. Values above 50 are intentionally unavailable because the original curve can extrapolate above that point.",
        .min = 0.f,
        .max = 50.f,
        .format = "%.0f%%",
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueProcessor",
        .binding = &shader_injection.tone_map_hue_processor,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Hue Processor",
        .section = "Tone Mapping",
        .tooltip = "Selects hue processor",
        .labels = {"OKLab", "ICtCp", "darkTable UCS"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueCorrection",
        .binding = &shader_injection.tone_map_hue_correction,
        .default_value = 0.f,
        .label = "Hue Correction",
        .section = "Tone Mapping",
        .tooltip = "Hue retention strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapHueShift",
        .binding = &shader_injection.tone_map_hue_shift,
        .default_value = 50.f,
        .label = "Hue Shift",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .min = 0.f,
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampColorSpace",
        .binding = &shader_injection.tone_map_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Color Space",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapClampPeak",
        .binding = &shader_injection.tone_map_clamp_peak,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Clamp Peak",
        .section = "Tone Mapping",
        .tooltip = "Hue-shift emulation strength.",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_blowout,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV24Compression",
        .binding = &shader_injection.psychov24_compression,
        .default_value = 0.f,
        .label = "PsychoV24 Compression",
        .section = "Color Grading",
        .tooltip = "PsychoV24 shoulder curve. 0 = auto compression, 50 = 1.00, 100 = 2.00, 200 = 4.00.",
        .min = 0.f,
        .max = 400.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoV24Enabled(); },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV24ConeResponse",
        .binding = &shader_injection.psychov24_cone_response,
        .default_value = 50.f,
        .label = "PsychoV24 Cone Response",
        .section = "Color Grading",
        .tooltip = "Scales PsychoV24 cone response. 50 = 1.00 neutral. Higher values increase PsychoV24 contrast/purity response.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoV24Enabled(); },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV24GamutCompression",
        .binding = &shader_injection.psychov24_gamut_compression,
        .default_value = 100.f,
        .label = "PsychoV24 Gamut Compression",
        .section = "Color Grading",
        .tooltip = "PsychoV24 gamut compression strength.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.2f",
        .is_enabled = []() { return IsPsychoV24Enabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV24GamutMode",
        .binding = &shader_injection.psychov24_gamut_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "PsychoV24 Gamut Mode",
        .section = "Color Grading",
        .labels = {"BT709", "BT2020"},
        .is_enabled = []() { return IsPsychoV24Enabled(); },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV24HighlightSaturation",
        .binding = &shader_injection.psychov24_highlight_saturation,
        .default_value = 100.f,
        .label = "PsychoV24 Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Controls PsychoV24 highlight saturation inside the tonemapper. 100% is neutral; lower values reduce highlight color and higher values increase it.",
        .min = 0.f,
        .max = 200.f,
        .format = "%.0f%%",
        .is_enabled = []() { return IsPsychoV24Enabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "PsychoV24GamutHueRestore",
        .binding = &shader_injection.psychov24_gamut_hue_restore,
        .default_value = 0.f,
        .label = "PsychoV24 Gamut Hue Restore",
        .section = "Color Grading",
        .tooltip = "Restores the pre-gamut hue direction after PsychoV24 gamut compression. 0% disables it; 100% applies the full hue restoration.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f%%",
        .is_enabled = []() { return IsPsychoV24Enabled(); },
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "Scene Grading",
        .section = "Color Grading",
        .tooltip = "Scene grading as applied by the game",
        .max = 100.f,
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value * 0.01f; },
    },

    new renodx::utils::settings::Setting{
        .key = "BloomBrightness",
        .binding = &shader_injection.bloom_brightness,
        .default_value = 300.f,
        .label = "Bloom Brightness",
        .section = "Bloom",
        .tooltip = "Scales the restored bloom while preserving its corrected color. 100 = original restored brightness.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return false;},
    },
    new renodx::utils::settings::Setting{
        .key = "BloomFlareSize",
        .binding = &shader_injection.bloom_flare_size,
        .default_value = 100.f,
        .label = "Flare Size",
        .section = "Bloom",
        .tooltip = "Controls how much of broad, screen-covering lens flare is retained. 0 keeps mostly the bright core; 100 retains the full flare extent.",
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f%%",
        .parse = [](float value) { return value * 0.01f; },
        .is_visible = []() { return current_settings_mode >= 1;},
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainCustomColorSpace",
        .binding = &shader_injection.swap_chain_custom_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Custom Color Space",
        .section = "Display Output",
        .tooltip = "Selects output color space"
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nUS CRT for BT.601 (NTSC-U)."
                   "\nJPN CRT for BT.601 ARIB-TR-B9 D93 (NTSC-J)."
                   "\nDefault: US CRT",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "IntermediateDecoding",
        .binding = &shader_injection.intermediate_encoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Intermediate Encoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) {
            if (value == 0) return shader_injection.gamma_correction + 1.f;
            return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainDecoding",
        .binding = &shader_injection.swap_chain_decoding,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Swapchain Decoding",
        .section = "Display Output",
        .labels = {"Auto", "None", "SRGB", "2.2", "2.4"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) {
            if (value == 0) return shader_injection.intermediate_encoding;
            return value - 1.f; },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Gamma Correction",
        .section = "Display Output",
        .labels = {"None", "2.2", "2.4"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .is_visible = []() { return false; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainClampColorSpace",
        .binding = &shader_injection.swap_chain_clamp_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Clamp Color Space",
        .section = "Display Output",
        .labels = {"None", "BT709", "BT2020", "AP1"},
        .is_enabled = []() { return IsCustomToneMapperEnabled(); },
        .parse = [](float value) { return value - 1.f; },
        .is_visible = []() { return false; },
    },
};

const std::unordered_map<std::string, reshade::api::format> UPGRADE_TARGETS = {
    /* {"R8G8B8A8_TYPELESS", reshade::api::format::r8g8b8a8_typeless},
    {"B8G8R8A8_TYPELESS", reshade::api::format::b8g8r8a8_typeless},
    {"R8G8B8A8_UNORM", reshade::api::format::r8g8b8a8_unorm},
    {"B8G8R8A8_UNORM", reshade::api::format::b8g8r8a8_unorm},
    {"R8G8B8A8_SNORM", reshade::api::format::r8g8b8a8_snorm},
    {"R8G8B8A8_UNORM_SRGB", reshade::api::format::r8g8b8a8_unorm_srgb},
    {"B8G8R8A8_UNORM_SRGB", reshade::api::format::b8g8r8a8_unorm_srgb},
    {"R10G10B10A2_TYPELESS", reshade::api::format::r10g10b10a2_typeless},
    {"R10G10B10A2_UNORM", reshade::api::format::r10g10b10a2_unorm},
    {"B10G10R10A2_UNORM", reshade::api::format::b10g10r10a2_unorm},
    {"R11G11B10_FLOAT", reshade::api::format::r11g11b10_float},
    {"R16G16B16A16_TYPELESS", reshade::api::format::r16g16b16a16_typeless}, */
};

void OnPresetOff() {
  //   renodx::utils::settings::UpdateSetting("toneMapType", 0.f);
  //   renodx::utils::settings::UpdateSetting("toneMapPeakNits", 203.f);
  //   renodx::utils::settings::UpdateSetting("toneMapGameNits", 203.f);
  //   renodx::utils::settings::UpdateSetting("toneMapUINits", 203.f);
  //   renodx::utils::settings::UpdateSetting("toneMapGammaCorrection", 0);
  //   renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 0.f);
}

const auto UPGRADE_TYPE_NONE = 0.f;
const auto UPGRADE_TYPE_OUTPUT_SIZE = 1.f;
const auto UPGRADE_TYPE_OUTPUT_RATIO = 2.f;
const auto UPGRADE_TYPE_ANY = 3.f;

// ============================================================================
// D3D9 windowed -> borderless windowed, sized from the real backbuffer
// ============================================================================
//
// Do not derive borderless size from GetClientRect() and do not blindly stretch
// the HWND to the monitor. Both can disagree with an explicitly-sized D3D9
// backbuffer.
//
// Instead, OnPresent obtains the ACTUAL swapchain backbuffer resource and passes
// its texture dimensions here. A borderless popup has no non-client frame, so
// making its outer size equal to the backbuffer size also makes its client area
// equal to the backbuffer size.
//
// This keeps the game's D3D9 presentation/readback dimensions coherent and does
// not modify any of the DX9 CPU blit/readback handlers below.

void ApplyWindowedBorderless(
    HWND hwnd,
    uint32_t backbuffer_width,
    uint32_t backbuffer_height) {
  if (force_windowed_borderless < 0.5f) return;
  if (hwnd == nullptr || !IsWindow(hwnd)) return;
  if (backbuffer_width == 0u || backbuffer_height == 0u) return;

  const LONG_PTR style = GetWindowLongPtrW(hwnd, GWL_STYLE);
  const LONG_PTR ex_style = GetWindowLongPtrW(hwnd, GWL_EXSTYLE);

  // Never touch child windows.
  if ((style & WS_CHILD) != 0) return;

  // Only convert a normal framed/windowed HWND.
  // An exclusive/fullscreen popup normally has none of these frame bits, so it
  // remains completely untouched.
  constexpr LONG_PTR WINDOWED_FRAME_BITS =
      WS_CAPTION | WS_THICKFRAME | WS_BORDER | WS_DLGFRAME;

  if ((style & WINDOWED_FRAME_BITS) == 0) return;

  HMONITOR monitor = MonitorFromWindow(hwnd, MONITOR_DEFAULTTONEAREST);

  MONITORINFO monitor_info = {};
  monitor_info.cbSize = sizeof(monitor_info);
  if (!GetMonitorInfoW(monitor, &monitor_info)) return;

  const RECT& monitor_rect = monitor_info.rcMonitor;
  const int monitor_width = monitor_rect.right - monitor_rect.left;
  const int monitor_height = monitor_rect.bottom - monitor_rect.top;

  const int target_width = static_cast<int>(backbuffer_width);
  const int target_height = static_cast<int>(backbuffer_height);

  // Full native-resolution windowed mode becomes monitor-filling borderless.
  // Smaller D3D9 backbuffers stay at their actual render size and are centered.
  const int target_x =
      (target_width == monitor_width)
          ? monitor_rect.left
          : monitor_rect.left + ((monitor_width - target_width) / 2);

  const int target_y =
      (target_height == monitor_height)
          ? monitor_rect.top
          : monitor_rect.top + ((monitor_height - target_height) / 2);

  LONG_PTR borderless_style = style;
  borderless_style &= ~(WS_CAPTION | WS_THICKFRAME | WS_BORDER | WS_DLGFRAME |
                        WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX);
  borderless_style |= WS_POPUP | WS_VISIBLE;

  LONG_PTR borderless_ex_style = ex_style;
  borderless_ex_style &= ~(WS_EX_DLGMODALFRAME | WS_EX_CLIENTEDGE |
                           WS_EX_STATICEDGE | WS_EX_WINDOWEDGE);

  if (borderless_style != style) {
    SetWindowLongPtrW(hwnd, GWL_STYLE, borderless_style);
  }

  if (borderless_ex_style != ex_style) {
    SetWindowLongPtrW(hwnd, GWL_EXSTYLE, borderless_ex_style);
  }

  // Do not force Z-order/focus changes. Only apply the frame change, position,
  // and dimensions that correspond to the real D3D9 backbuffer.
  SetWindowPos(
      hwnd,
      nullptr,
      target_x,
      target_y,
      target_width,
      target_height,
      SWP_NOZORDER | SWP_NOOWNERZORDER | SWP_NOACTIVATE |
          SWP_FRAMECHANGED | SWP_SHOWWINDOW);
}


// ============================================================================
// MW3 x64 safe command console
//
// Architecture follows the command submission used by open IW clients:
// ReShade owns the UI/input, while MW3 owns command parsing and dvar handling.
//
// SAFETY / STABILITY:
// - No WndProc subclass.
// - No KEYCATCH_CONSOLE writes.
// - No Sys_ShowConsole call.
// - No external WinConsole.
// - No game rendering hooks beyond ReShade's normal overlay callback.
// - The build-specific Cbuf_AddText entry point is signature-checked before use.
//
// Target: user's September 3, 2026 x64 iw5sp.exe.
// Cbuf_AddText RVA was verified from the game's own "screenshot\n" call site.
// ============================================================================

constexpr uintptr_t MW3_CBUF_ADD_TEXT_RVA = 0x0022F680u;

std::array<char, 1024> g_mw3_command_input = {};
std::vector<std::string> g_mw3_command_history;
int g_mw3_command_history_pos = -1;
std::vector<std::string> g_mw3_recent_commands;
bool g_mw3_command_signature_error_logged = false;

bool IsSupportedMW3CbufAddText() {
  const auto* module =
      reinterpret_cast<const uint8_t*>(GetModuleHandleW(nullptr));
  if (module == nullptr) return false;

  // First bytes of Cbuf_AddText in the supplied x64 iw5sp.exe:
  //
  //   mov [rsp+08], rbx
  //   push rdi
  //   sub rsp, 20h
  //   mov edi, ecx
  //   mov rbx, rdx
  //   mov ecx, 1Fh
  //
  // Avoid including the following relative CALL displacement in the signature.
  static constexpr uint8_t expected[] = {
      0x48, 0x89, 0x5C, 0x24, 0x08,
      0x57,
      0x48, 0x83, 0xEC, 0x20,
      0x8B, 0xF9,
      0x48, 0x8B, 0xDA,
      0xB9, 0x1F, 0x00, 0x00, 0x00,
  };

  return std::memcmp(
             module + MW3_CBUF_ADD_TEXT_RVA,
             expected,
             sizeof(expected)) == 0;
}

bool SubmitMW3ConsoleCommand(const char* text) {
  if (text == nullptr || text[0] == '\0') return false;

  if (!IsSupportedMW3CbufAddText()) {
    if (!g_mw3_command_signature_error_logged) {
      g_mw3_command_signature_error_logged = true;
      reshade::log::message(
          reshade::log::level::error,
          "[MW3 Commands] Cbuf_AddText signature mismatch. "
          "Command execution is disabled for safety.");
    }
    return false;
  }

  std::string command = text;

  // Trim surrounding CR/LF so exactly one terminating newline is appended.
  while (!command.empty()
         && (command.back() == '\r' || command.back() == '\n')) {
    command.pop_back();
  }

  if (command.empty()) return false;

  // IW's command buffer consumes newline-terminated text. Open IW clients use
  // the same Cbuf_AddText(0, "...\\n") path for console Enter.
  command.push_back('\n');

  const uintptr_t module =
      reinterpret_cast<uintptr_t>(GetModuleHandleW(nullptr));

  using CbufAddTextFn = void (*)(int client_index, const char* command_text);
  const auto cbuf_add_text =
      reinterpret_cast<CbufAddTextFn>(module + MW3_CBUF_ADD_TEXT_RVA);

  // Single-player local client.
  cbuf_add_text(0, command.c_str());

  return true;
}

int MW3CommandHistoryCallback(ImGuiInputTextCallbackData* data) {
  if (data == nullptr
      || data->EventFlag != ImGuiInputTextFlags_CallbackHistory
      || g_mw3_command_history.empty()) {
    return 0;
  }

  const int old_position = g_mw3_command_history_pos;

  if (data->EventKey == ImGuiKey_UpArrow) {
    if (g_mw3_command_history_pos < 0) {
      g_mw3_command_history_pos =
          static_cast<int>(g_mw3_command_history.size()) - 1;
    } else if (g_mw3_command_history_pos > 0) {
      --g_mw3_command_history_pos;
    }
  } else if (data->EventKey == ImGuiKey_DownArrow) {
    if (g_mw3_command_history_pos >= 0) {
      ++g_mw3_command_history_pos;
      if (g_mw3_command_history_pos
          >= static_cast<int>(g_mw3_command_history.size())) {
        g_mw3_command_history_pos = -1;
      }
    }
  }

  if (old_position == g_mw3_command_history_pos) return 0;

  const char* replacement =
      g_mw3_command_history_pos >= 0
          ? g_mw3_command_history[
                static_cast<size_t>(g_mw3_command_history_pos)].c_str()
          : "";

  // RenoDX's bundled ImGui ABI does not export DeleteChars/InsertChars, so
  // replace the public callback buffer directly.
  if (data->Buf == nullptr || data->BufSize <= 0) return 0;

  const size_t replacement_length =
      std::min<size_t>(
          std::strlen(replacement),
          static_cast<size_t>(data->BufSize - 1));

  if (replacement_length != 0u) {
    std::memcpy(data->Buf, replacement, replacement_length);
  }

  data->Buf[replacement_length] = '\0';
  data->BufTextLen = static_cast<int>(replacement_length);
  data->CursorPos = data->BufTextLen;
  data->SelectionStart = data->BufTextLen;
  data->SelectionEnd = data->BufTextLen;
  data->BufDirty = true;

  return 0;
}

void ExecuteMW3CommandInput() {
  std::string command = g_mw3_command_input.data();

  const size_t first = command.find_first_not_of(" \t\r\n");
  if (first == std::string::npos) {
    g_mw3_command_input.fill('\0');
    return;
  }

  const size_t last = command.find_last_not_of(" \t\r\n");
  command = command.substr(first, last - first + 1);

  if (!SubmitMW3ConsoleCommand(command.c_str())) return;

  if (g_mw3_command_history.empty()
      || g_mw3_command_history.back() != command) {
    g_mw3_command_history.push_back(command);
    if (g_mw3_command_history.size() > 64u) {
      g_mw3_command_history.erase(g_mw3_command_history.begin());
    }
  }

  g_mw3_command_history_pos = -1;

  g_mw3_recent_commands.push_back(command);
  if (g_mw3_recent_commands.size() > 16u) {
    g_mw3_recent_commands.erase(g_mw3_recent_commands.begin());
  }

  g_mw3_command_input.fill('\0');
}

void DrawMW3CommandConsole(reshade::api::effect_runtime* runtime) {
  (void)runtime;

  // This callback is registered through reshade::register_overlay(), not the
  // reshade_overlay event. ReShade therefore invokes it only while its main
  // overlay is visible and creates the "MW3 Command Console" window itself.
  // Do not call ImGui::Begin/End for the containing window here.
  const bool supported = IsSupportedMW3CbufAddText();

  if (supported) {
    ImGui::TextUnformatted(
        "Native MW3 command buffer: ready");
  } else {
    ImGui::TextUnformatted(
        "Native MW3 command buffer: unsupported executable build");
  }

  ImGui::TextWrapped(
      "This safety-first console sends text directly to MW3's own "
      "Cbuf_AddText command buffer. It does not patch MW3 input state, "
      "open WinConsole, or call the removed retail drop-down console.");

  ImGui::Separator();

  ImGui::SetNextItemWidth(-1.0f);
  const ImGuiInputTextFlags input_flags =
      ImGuiInputTextFlags_EnterReturnsTrue
      | ImGuiInputTextFlags_CallbackHistory;

  if (ImGui::InputText(
          "##MW3CommandInput",
          g_mw3_command_input.data(),
          g_mw3_command_input.size(),
          input_flags,
          MW3CommandHistoryCallback)) {
    ExecuteMW3CommandInput();
  }

  if (ImGui::Button("Execute")) {
    ExecuteMW3CommandInput();
  }

  ImGui::SameLine();

  if (ImGui::Button("Clear local history")) {
    g_mw3_command_history.clear();
    g_mw3_recent_commands.clear();
    g_mw3_command_history_pos = -1;
  }

  ImGui::Separator();

  ImGui::TextUnformatted("Recently submitted:");

  if (g_mw3_recent_commands.empty()) {
    ImGui::TextDisabled("(none)");
  } else {
    for (const auto& command : g_mw3_recent_commands) {
      ImGui::TextUnformatted(command.c_str());
    }
  }

  ImGui::Separator();
  ImGui::TextDisabled(
      "Open ReShade with Home, then use this MW3 Command Console window. "
      "Closing the ReShade UI hides this console completely. "
      "Up/Down recalls command history. Engine print output is not hooked "
      "in this crash-safe build.");
}


void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect,
               uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {

  (void)source_rect;
  (void)dest_rect;
  (void)dirty_rect_count;
  (void)dirty_rects;
  if (queue == nullptr) return;
  auto* device = queue->get_device();
  if (device == nullptr) return;


  const auto api = device->get_api();

  if (api == reshade::api::device_api::d3d9) {


    // V27 production runtime: keep the exact-build cache/CRT/sync fixes, remove
    // Tracy/flight-recorder hot paths, and accelerate the real minizip DEFLATE
    // stage through an optional modern zlib-ng shadow stream.
    {

      mw3_deep_profiler::OnPresent(
          queue, swapchain, source_rect, dest_rect, dirty_rect_count, dirty_rects);
    }





    // The old executable-byte renderer/query experiments stay permanently stock.
    // Do this once rather than touching their atomics on every frame.
    static bool v22_stock_lock_done = false;
    if (!v22_stock_lock_done) {
      v22_stock_lock_done = true;

      mw3_render_poll_wait_mode = 0.f;
      mw3_query_polling_mode = 0.f;
      mw3_blocking_query_yield_enabled = 0.f;
      mw3_render_poll_wait::SetRequestedMode(0);
      mw3_query_polling::SetRequestedMode(0);
      mw3_blocking_query_yield::SetEnabled(false);

      reshade::log::message(
          reshade::log::level::info,
          "[MW3 V27 Stability] V36 optimizer runtime: legacy Tracy and ultra flight recorder are removed; all addon Tracy instrumentation is removed; old renderer/query executable-byte patches remain locked stock.");
      reshade::log::message(
          reshade::log::level::info,
          "[MW3 V27 IWD] persistent per-archive mapping + exact CRT _read fast path use TLS-first lookup; no per-read profiler atomics/QPC accounting.");
      reshade::log::message(
          reshade::log::level::info,
          "[MW3 V27 Inflate] actual IWD decoder identified: minizip iw5sp+0x3157C0 -> bundled zlib 1.1.4 inflate iw5sp+0x312790. Optional mw3_zlibng_v27.dll accelerates only that exact stream path.");
      reshade::log::message(
          reshade::log::level::info,
          "[MW3 V7 Sync] original V36 event-preserving wait/coalescing behavior restored; see Runtime hooks log for installation results.");
      reshade::log::message(
          reshade::log::level::info,
          "[MW3 V27 Archive] burst detection is sparse and the archive worker may use temporary ABOVE_NORMAL priority until its verified 0x24A6B7 idle wait.");
    }

    mw3_microstutter::NotifyPresent();

    // V36: the add-on FPS control drives IW5's own com_maxfps limiter instead
    // of applying a second swapchain-side cap. Keeping the engine limiter active
    // preserves IW5 simulation/input timing; Smooth Visible QPC only finishes
    // the fractional display deadline at the HDR proxy Present.
    const int wanted_native_fps = std::clamp(
        static_cast<int>(std::lround(mw3_native_fps_limit)), 0, 500);
    if (g_mw3_native_fps_limit_applied.load(std::memory_order_acquire)
        != wanted_native_fps) {
      char command[64] = {};
      std::snprintf(command, sizeof(command), "com_maxfps %d", wanted_native_fps);
      if (SubmitMW3ConsoleCommand(command)) {
        g_mw3_native_fps_limit_applied.store(
            wanted_native_fps, std::memory_order_release);
        char message[160] = {};
        std::snprintf(
            message, sizeof(message),
            "[MW3 V36 Frame Pacing] native com_maxfps set to %d by the RenoDX Performance slider%s.",
            wanted_native_fps, wanted_native_fps == 0 ? " (uncapped)" : "");
        reshade::log::message(reshade::log::level::info, message);
      }
    }

    const int wanted_audio = mw3_streamed_audio_pretouch >= 0.5f ? 1 : 0;
    if (g_mw3_audio_pretouch_applied.load(std::memory_order_acquire) != wanted_audio) {
      if (SubmitMW3ConsoleCommand(wanted_audio
              ? "snd_touchStreamFilesOnLoad 1"
              : "snd_touchStreamFilesOnLoad 0")) {
        g_mw3_audio_pretouch_applied.store(wanted_audio,std::memory_order_release);
        reshade::log::message(reshade::log::level::info,
            wanted_audio
                ? "[MW3 V27 Streaming] snd_touchStreamFilesOnLoad enabled for upcoming/first-use streamed audio."
                : "[MW3 V27 Streaming] snd_touchStreamFilesOnLoad restored to disabled.");
      }
    }

    // Long-standing IW5 PC tweak documented by PCGamingWiki/period guides:
    // front-load shader creation at level load instead of paying first-use work
    // in gameplay. This does not target the proven IWD archive stalls, but it
    // can remove a separate residual shader-first-use hitch class.
    const int wanted_shader_preload = mw3_preload_shaders_enabled >= 0.5f ? 1 : 0;
    if (g_mw3_preload_shaders_applied.load(std::memory_order_acquire)
        != wanted_shader_preload) {
      if (SubmitMW3ConsoleCommand(wanted_shader_preload
              ? "r_preloadShaders 1"
              : "r_preloadShaders 0")) {
        g_mw3_preload_shaders_applied.store(
            wanted_shader_preload, std::memory_order_release);
        reshade::log::message(
            reshade::log::level::info,
            wanted_shader_preload
                ? "[MW3 V27 Shader] r_preloadShaders=1 requested; shader first-use work is front-loaded where IW5 supports it."
                : "[MW3 V27 Shader] r_preloadShaders restored to 0.");
      }
    }

    if (swapchain == nullptr) return;
    HWND hwnd = reinterpret_cast<HWND>(swapchain->get_hwnd());
    if (hwnd == nullptr) return;

    const bool overlay_capturing_mouse =
        g_reshade_overlay_open.load(std::memory_order_acquire);
    {

      cod_high_polling_mouse::Update(
          hwnd,
          cod_high_polling_mouse_fix >= 0.5f,
          overlay_capturing_mouse);
    }

    uint32_t backbuffer_width = 0u;
    uint32_t backbuffer_height = 0u;
    const reshade::api::resource backbuffer = swapchain->get_back_buffer(0u);
    if (backbuffer.handle != 0u) {
      const reshade::api::resource_desc backbuffer_desc =
          device->get_resource_desc(backbuffer);
      backbuffer_width = backbuffer_desc.texture.width;
      backbuffer_height = backbuffer_desc.texture.height;
    }
    ApplyWindowedBorderless(hwnd, backbuffer_width, backbuffer_height);
    return;
  }

  if (api == reshade::api::device_api::d3d11) {


    // The RenoDX D3D11 proxy is the frame that is actually displayed. Finish the
    // fractional com_maxfps deadline here and keep its queue shallow.
    {

      mw3_proxy_latency::Update(device);
    }
    {

      mw3_smooth_frame_pacing::OnVisibleProxyPresent();
    }
    {

      mw3_microstutter::NotifyProxyPresent();
    }
    return;
  }

  if (api == reshade::api::device_api::opengl) {
    shader_injection.custom_flip_uv_y = 1.f;
  }
}
bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX (Generic)";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;
        mw3_microstutter::SetLogger(&MW3MicrostutterLog);

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;
        renodx::mods::shader::constant_buffer_offset = 50 * 4; 
        renodx::mods::swapchain::set_color_space = false; 
        // V36 uses MW3's native com_maxfps. Do not stack RenoDX's separate
        // swapchain FPS limiter on top of the engine limiter.
        renodx::utils::swapchain::fps_limit = 0.f;
        renodx::mods::swapchain::use_device_proxy = true;
          renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
            {
                reshade::api::device_api::d3d12,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
                },
            },
        };

        // Always register Present so Windowed Borderless works even when the
        // display proxy is disabled.
        reshade::register_event<reshade::addon_event::present>(OnPresent);
        reshade::register_event<reshade::addon_event::reshade_open_overlay>(
            OnReShadeOpenOverlay);


        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "HighPollingMouseFix",
              .binding = &cod_high_polling_mouse_fix,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Plutonium-Style High Polling Mouse Fix",
              .section = "Performance",
              .tooltip = "Plutonium/IW-family style path: accumulates WM_INPUT deltas and injects them directly into MW3's verified native CL_MouseEvent, bypassing the legacy GetCursorPos-derived dx/dy while preserving the game's own sensitivity, ADS, m_yaw/m_pitch, recentering and camera code. High-rate WM_INPUT/WM_MOUSEMOVE bursts are collapsed only during active gameplay to reduce message-pump overhead. Disable to restore the stock mouse path.",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .on_change_value = [](float previous, float current) {
                (void)previous;
                cod_high_polling_mouse_fix = current;
                cod_high_polling_mouse::SetEnabled(current >= 0.5f);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name,
              setting);
          cod_high_polling_mouse_fix = setting->GetValue();
          cod_high_polling_mouse::SetEnabled(
              cod_high_polling_mouse_fix >= 0.5f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3RenderPollWaitV27LockedStock",
              .binding = &mw3_render_poll_wait_mode,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Renderer Poll Wait",
              .section = "Performance",
              .tooltip = "V27 locks this to stock Sleep(1). The previous Yield/Busy modes hot-patched executable instructions while renderer threads were active and are disabled for stability.",
              .labels = {"Locked: Stock Sleep(1)"},
              .on_change_value = [](float previous, float current) {
                (void)previous;
                (void)current;
                mw3_render_poll_wait_mode = 0.f;
                mw3_render_poll_wait::SetRequestedMode(0);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name, setting);
          mw3_render_poll_wait_mode = 0.f;
          mw3_render_poll_wait::SetRequestedMode(0);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3NativeFpsLimitV36",
              .binding = &mw3_native_fps_limit,
              .default_value = 120.f,
              .label = "In-Game FPS Limit (com_maxfps)",
              .section = "Performance",
              .tooltip = "Controls MW3's own com_maxfps limiter through the native command buffer. This is intentionally used instead of RenoDX's separate swapchain FPS limiter because IW5's native cap gives smoother simulation/input pacing. 0 = uncapped. Smooth Visible QPC can remain enabled to finish fractional frame deadlines at the visible HDR proxy Present.",
              .min = 0.f,
              .max = 500.f,
              .format = "%.0f FPS",
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_native_fps_limit = std::clamp(std::round(current), 0.f, 500.f);
                g_mw3_native_fps_limit_applied.store(-1, std::memory_order_release);
                renodx::utils::swapchain::fps_limit = 0.f;
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name, setting);
          mw3_native_fps_limit = std::clamp(
              std::round(setting->GetValue()), 0.f, 500.f);
          g_mw3_native_fps_limit_applied.store(-1, std::memory_order_release);
          renodx::utils::swapchain::fps_limit = 0.f;
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3SmoothFramePacing",
              .binding = &mw3_smooth_frame_pacing_enabled,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Smooth Frame Pacing",
              .section = "Performance",
              .tooltip = "Keeps MW3's native com_maxfps and simulation timing intact, then finishes the fractional deadline at RenoDX's actual visible D3D11 HDR proxy Present. This avoids V11/V12's 1 ms internal-frame bypass while still correcting 120/144/165/240 Hz whole-millisecond quantization at display time. com_maxfps 0 remains uncapped.",
              .labels = {
                  "Stock Visible Output",
                  "Smooth Visible QPC",
              },
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_smooth_frame_pacing_enabled = current;
                mw3_smooth_frame_pacing::SetEnabled(current >= 0.5f);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name,
              setting);
          mw3_smooth_frame_pacing_enabled = setting->GetValue();
          mw3_smooth_frame_pacing::SetEnabled(
              mw3_smooth_frame_pacing_enabled >= 0.5f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3IwdStreamCacheV27",
              .binding = &mw3_iwd_stream_cache_mode,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "IWD Traversal Stream Cache",
              .section = "Performance",
              .tooltip = "V27 keeps one persistent read-only mapping per .iwd archive path with no explicit prefetch. This removes physical I/O; the separate Modern DEFLATE Decoder targets the remaining CPU decode stage.",
              .labels = {
                  "Disabled / Stock ReadFile",
                  "Persistent Mapped IWD Cache (No Prefetch)",
              },
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_iwd_stream_cache_mode = current;
                mw3_deep_profiler::SetIwdCacheMode(static_cast<int>(current));
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name,
              setting);
          mw3_iwd_stream_cache_mode = setting->GetValue();
          mw3_deep_profiler::SetIwdCacheMode(
              static_cast<int>(mw3_iwd_stream_cache_mode));
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3CrtIwdFastReadV27",
              .binding = &mw3_crt_iwd_fast_read_enabled,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "IWD CRT Fast Read",
              .section = "Performance",
              .tooltip = "Exact-build iw5sp+0x3BB340 binary-IWD fast path. This bypasses old CRT read overhead but does not replace ZIP/DEFLATE processing; the Modern DEFLATE Decoder setting below targets that actual CPU stage. Non-IWD/text/device/pipe reads remain stock.",
              .labels = {
                  "Stock CRT _read",
                  "Fast Binary IWD _read",
              },
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_crt_iwd_fast_read_enabled = current;
                mw3_deep_profiler::SetCrtIwdFastReadEnabled(current >= 0.5f);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name,
              setting);
          mw3_crt_iwd_fast_read_enabled = setting->GetValue();
          mw3_deep_profiler::SetCrtIwdFastReadEnabled(
              mw3_crt_iwd_fast_read_enabled >= 0.5f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3ZlibNgIwdInflateV27",
              .binding = &mw3_zlibng_iwd_inflate_enabled,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "IWD Modern DEFLATE Decoder",
              .section = "Performance",
              .tooltip = "V36 keeps the exact V27/V31 all-entry zlib-ng fast path and the corrected audio seek semantics, adds a shared-lock cached-read path, and bypasses IW5's discard/reopen seek loop only when the entire following 128 KiB sound block is already decoded. Only the exact streamed-sound FS_Seek caller gets a decoded-prefix cache backed by the existing persistent mapped IWD view: each requested sound byte is decompressed at most once, backward seeks are served from memory, and non-audio IWD inflation remains on the V31/V33 path. The private DLL remains mw3_zlibng_v27.dll and the V27 setting key is retained.",
              .labels = {
                  "Stock bundled zlib 1.1.4",
                  "Modern zlib-ng shadow inflater",
              },
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_zlibng_iwd_inflate_enabled = current;
                mw3_deep_profiler::SetZlibNgIwdInflateEnabled(current >= 0.5f);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name,
              setting);
          mw3_zlibng_iwd_inflate_enabled = setting->GetValue();
          mw3_deep_profiler::SetZlibNgIwdInflateEnabled(
              mw3_zlibng_iwd_inflate_enabled >= 0.5f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3BackendSleep1YieldV27",
              .binding = &mw3_backend_sleep1_yield_enabled,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Backend 1 ms Poll Scheduler",
              .section = "Performance",
              .tooltip = "Targets only the exact Sleep(1) call whose return address is iw5sp.exe+0x1BE473. The V19 residual-stutter trace measured this single Sleep(1) taking 64-588 ms in nasty hitches after physical I/O had fallen to zero. Targeted mode uses SwitchToThread so the real loop condition is still re-checked; all other Sleep/wait calls remain completely stock.",
              .labels = {
                  "Stock Sleep(1)",
                  "Targeted SwitchToThread",
              },
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_backend_sleep1_yield_enabled = current;
                mw3_deep_profiler::SetBackendSleep1YieldEnabled(current >= 0.5f);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name,
              setting);
          mw3_backend_sleep1_yield_enabled = setting->GetValue();
          mw3_deep_profiler::SetBackendSleep1YieldEnabled(
              mw3_backend_sleep1_yield_enabled >= 0.5f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3RendererSleep1PreciseV27",
              .binding = &mw3_renderer_sleep1_precise_enabled,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Renderer Sleep(1) Precision",
              .section = "Performance",
              .tooltip = "V27 calibrates the exact iw5sp+0x18B895 high-resolution timer during a short warm-up, then freezes the learned request so normal gameplay no longer pays QPC calibration overhead on every call.",
              .labels = {
                  "Stock Sleep(1)",
                  "Adaptive Precise ~0.90 ms Actual",
              },
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_renderer_sleep1_precise_enabled = current;
                mw3_deep_profiler::SetRendererSleep1PreciseEnabled(current >= 0.5f);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name,
              setting);
          mw3_renderer_sleep1_precise_enabled = setting->GetValue();
          mw3_deep_profiler::SetRendererSleep1PreciseEnabled(
              mw3_renderer_sleep1_precise_enabled >= 0.5f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3RendererWait1PreciseV27",
              .binding = &mw3_renderer_wait1_precise_enabled,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Renderer 1 ms Event Wait",
              .section = "Performance",
              .tooltip = "V27 keeps the real iw5sp+0x24AA36 producer event as wait object #0. Normal polls use a warm-up-calibrated ~0.90 ms timeout; repeated timeout storms coalesce to 2 ms, and sustained IWD bursts can step to 4 ms. A real producer signal always wakes immediately.",
              .labels = {
                  "Stock 1 ms Wait",
                  "Adaptive Event Wait + Burst Coalescing",
              },
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_renderer_wait1_precise_enabled = current;
                mw3_deep_profiler::SetRendererWait1PreciseEnabled(current >= 0.5f);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name,
              setting);
          mw3_renderer_wait1_precise_enabled = setting->GetValue();
          mw3_deep_profiler::SetRendererWait1PreciseEnabled(
              mw3_renderer_wait1_precise_enabled >= 0.5f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3ArchiveBurstWaitCoalesceV27",
              .binding = &mw3_archive_burst_wait_coalesce_enabled,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Render-Sync Timeout Coalescing",
              .section = "Performance",
              .tooltip = "Event-preserving progressive coalescing. After repeated 0x24AA36 timeouts V27 uses 2 ms deadlines; during proven archive bursts a longer streak can use 4 ms. The real producer event remains first and can wake immediately, so completion is never fabricated.",
              .labels = {
                  "Disabled / Normal Adaptive Poll",
                  "Enabled / Event-Preserving Coalescing",
              },
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_archive_burst_wait_coalesce_enabled = current;
                mw3_deep_profiler::SetArchiveBurstWaitCoalesceEnabled(current >= 0.5f);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name, setting);
          mw3_archive_burst_wait_coalesce_enabled = setting->GetValue();
          mw3_deep_profiler::SetArchiveBurstWaitCoalesceEnabled(
              mw3_archive_burst_wait_coalesce_enabled >= 0.5f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3ArchiveThreadPriorityBoostV27",
              .binding = &mw3_archive_thread_priority_boost_enabled,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Archive Decode Worker Priority",
              .section = "Performance",
              .tooltip = "Temporarily raises only the active mapped-IWD/CRT worker to THREAD_PRIORITY_ABOVE_NORMAL during a sustained archive burst, then restores its original priority when that thread reaches the known 0x24A6B7 worker-idle wait. Never uses highest/realtime priority and never changes the whole process priority class.",
              .labels = {
                  "Stock Thread Priority",
                  "Temporary Above Normal During Burst",
              },
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_archive_thread_priority_boost_enabled = current;
                mw3_deep_profiler::SetArchiveThreadPriorityBoostEnabled(current >= 0.5f);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name, setting);
          mw3_archive_thread_priority_boost_enabled = setting->GetValue();
          mw3_deep_profiler::SetArchiveThreadPriorityBoostEnabled(
              mw3_archive_thread_priority_boost_enabled >= 0.5f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3GPUQueryPollingV27LockedStock",
              .binding = &mw3_query_polling_mode,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "GPU Query Polling",
              .section = "Performance",
              .tooltip = "V27 locks all seven verified GetData call sites to the game's stock D3DGETDATA_FLUSH behavior. Runtime No-Flush instruction patching is disabled.",
              .labels = {"Locked: Stock FLUSH"},
              .on_change_value = [](float previous, float current) {
                (void)previous;
                (void)current;
                mw3_query_polling_mode = 0.f;
                mw3_query_polling::SetRequestedMode(0);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name, setting);
          mw3_query_polling_mode = 0.f;
          mw3_query_polling::SetRequestedMode(0);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3BlockingQueryYieldV27LockedStock",
              .binding = &mw3_blocking_query_yield_enabled,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Blocking GPU Query Retry",
              .section = "Performance",
              .tooltip = "V27 locks the blocking GetData retry path to the original tight retry. Runtime branch/code-cave switching is disabled.",
              .labels = {"Locked: Stock Tight Retry"},
              .on_change_value = [](float previous, float current) {
                (void)previous;
                (void)current;
                mw3_blocking_query_yield_enabled = 0.f;
                mw3_blocking_query_yield::SetEnabled(false);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name, setting);
          mw3_blocking_query_yield_enabled = 0.f;
          mw3_blocking_query_yield::SetEnabled(false);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3ProxyFrameLatencyV27",
              .binding = &mw3_proxy_latency_mode,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "HDR Proxy Frame Latency",
              .section = "Performance",
              .tooltip = "Controls the D3D11 RenoDX HDR proxy queue. 1 frame minimizes queued-frame latency and usually gives the cleanest cadence on a fast GPU; 2 is a throughput fallback; Driver Default restores DXGI's normal 3-frame maximum.",
              .labels = {"Driver Default (3)", "1 Frame", "2 Frames"},
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_proxy_latency_mode = current;
                mw3_proxy_latency::SetMode(static_cast<int>(current));
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          mw3_proxy_latency_mode = setting->GetValue();
          mw3_proxy_latency::SetMode(static_cast<int>(mw3_proxy_latency_mode));
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3StreamedAudioPreTouchV27",
              .binding = &mw3_streamed_audio_pretouch,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Streamed Audio Pre-Touch",
              .section = "Performance",
              .tooltip = "Sets MW3 x64's native snd_touchStreamFilesOnLoad dvar through Cbuf_AddText. This can move first-use streamed-audio file access into loading instead of gameplay. It may slightly increase level/load work.",
              .labels = {"Disabled", "Enabled"},
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_streamed_audio_pretouch = current;
                g_mw3_audio_pretouch_applied.store(-1,std::memory_order_release);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          mw3_streamed_audio_pretouch = setting->GetValue();
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "MW3PreloadShadersV27",
              .binding = &mw3_preload_shaders_enabled,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Native Shader Preload",
              .section = "Performance",
              .tooltip = "Sets IW5's native r_preloadShaders dvar. Community/PCGamingWiki guidance recommends 1 for smoother play by moving shader first-use work into level loading. It can increase level-load time and memory use. The profiler remains enabled.",
              .labels = {"Disabled", "Enabled"},
              .on_change_value = [](float previous, float current) {
                (void)previous;
                mw3_preload_shaders_enabled = current;
                g_mw3_preload_shaders_applied.store(-1, std::memory_order_release);
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(
              renodx::utils::settings::global_name, setting);
          mw3_preload_shaders_enabled = setting->GetValue();
          g_mw3_preload_shaders_applied.store(-1, std::memory_order_release);
          settings.push_back(setting);
        }

        // Register as a ReShade-managed overlay window. Unlike the generic
        // reshade_overlay event, this callback is only invoked while the
        // ReShade UI is actually open.
        reshade::register_overlay(
            "MW3 Command Console",
            DrawMW3CommandConsole);

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainForceBorderless",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Force Borderless",
              .section = "Display Output",
              .tooltip = "Forces fullscreen to be borderless for proper HDR",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .on_change_value = [](float previous, float current) { renodx::mods::swapchain::force_borderless = (current == 1.f); },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::force_borderless = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainWindowedBorderless",
              .binding = &force_windowed_borderless,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Windowed Borderless",
              .section = "Display Output",
              .tooltip = "Converts normal Windowed mode to borderless using the actual D3D9 swapchain backbuffer dimensions. Use the monitor native resolution for full-monitor borderless.",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .is_global = true,
              .is_visible = []() { return true; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          force_windowed_borderless = setting->GetValue();
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainPreventFullscreen",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Prevent Fullscreen",
              .section = "Display Output",
              .tooltip = "Prevent exclusive fullscreen for proper HDR",
              .labels = {
                  "Disabled",
                  "Enabled",
              },
              .on_change_value = [](float previous, float current) { renodx::mods::swapchain::prevent_full_screen = (current == 1.f); },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::prevent_full_screen = (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainEncoding",
              .binding = &shader_injection.swap_chain_encoding,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 5.f,
              .label = "Encoding",
              .section = "Display Output",
              .labels = {"None", "SRGB", "2.2", "2.4", "HDR10", "scRGB"},
              .is_enabled = []() { return IsCustomToneMapperEnabled(); },
              .on_change_value = [](float previous, float current) {
                ApplySwapChainEncoding(current);
              },
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          ApplySwapChainEncoding(setting->GetValue());
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxy",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 1.f,
              .label = "Use Display Proxy",
              .section = "Display Proxy",
              .labels = {"Off", "On"},
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          bool use_device_proxy = setting->GetValue() == 1.f;
          renodx::mods::swapchain::use_device_proxy = use_device_proxy;
          renodx::mods::swapchain::set_color_space = !use_device_proxy;
          if (!use_device_proxy) {
            shader_injection.custom_flip_uv_y = 0.f;
          }
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxyBaseWaitIdle",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Base Wait Idle",
              .section = "Display Proxy",
              .labels = {"Off", "On"},
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::device_proxy_wait_idle_source =
              (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "SwapChainDeviceProxyProxyWaitIdle",
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = "Proxy Wait Idle",
              .section = "Display Proxy",
              .labels = {"Off", "On"},
              .is_global = true,
              .is_visible = []() { return current_settings_mode >= 2; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          renodx::mods::swapchain::device_proxy_wait_idle_destination =
              (setting->GetValue() == 1.f);
          settings.push_back(setting);
        }

        for (const auto& [key, format] : UPGRADE_TARGETS) {
          auto* setting = new renodx::utils::settings::Setting{
              .key = "Upgrade_" + key,
              .value_type = renodx::utils::settings::SettingValueType::INTEGER,
              .default_value = 0.f,
              .label = key,
              .section = "Resource Upgrades",
              .labels = {
                  "Off",
                  "Output size",
                  "Output ratio",
                  "Any size",
              },
              .is_global = true,
              .is_visible = []() { return false; },
          };
          renodx::utils::settings::LoadSetting(renodx::utils::settings::global_name, setting);
          settings.push_back(setting);

          auto value = setting->GetValue();
          if (value > 0) {
            renodx::mods::swapchain::swap_chain_upgrade_targets.push_back({
                .old_format = format,
                .new_format = reshade::api::format::r16g16b16a16_float,
                .ignore_size = (value == UPGRADE_TYPE_ANY),
                .use_resource_view_cloning = true,
                .aspect_ratio = static_cast<float>((value == UPGRADE_TYPE_OUTPUT_RATIO)
                                                       ? renodx::mods::swapchain::SwapChainUpgradeTarget::BACK_BUFFER
                                                       : renodx::mods::swapchain::SwapChainUpgradeTarget::ANY),
                .usage_include = reshade::api::resource_usage::render_target,
            });
            std::stringstream s;
            s << "Applying user resource upgrade for ";
            s << format << ": " << value;
            reshade::log::message(reshade::log::level::info, s.str().c_str());
          }
        }
       
        // Upgrade only render-target resources and keep resource-view cloning
        // enabled so clears, RTVs and SRV variants continue to reference the same
        // upgraded resource.
       
        const reshade::api::format scene_intermediate_formats[] = {
    reshade::api::format::r8g8b8a8_unorm,
    reshade::api::format::r8g8b8a8_typeless,
    reshade::api::format::r8g8b8a8_unorm_srgb,
    reshade::api::format::b8g8r8a8_unorm,
    reshade::api::format::r10g10b10a2_unorm,
    reshade::api::format::b10g10r10a2_unorm,
};

const float scene_intermediate_aspect_ratios[] = {
    16.f / 9.f,    // Standard widescreen
    16.f / 10.f,
    24.f / 10.f,   // 3840x1600
    43.f / 18.f,   // 3440x1440
    64.f / 27.f,   // 5120x2160
};

for (const auto old_format : scene_intermediate_formats) {
  for (const float aspect_ratio : scene_intermediate_aspect_ratios) {
    renodx::mods::swapchain::resource_upgrade_infos.push_back({
        .old_format = old_format,
        .new_format = reshade::api::format::r16g16b16a16_float,
        .ignore_size = false,
        .use_resource_view_cloning = true,
          .use_resource_view_hot_swap = false,
        .aspect_ratio = aspect_ratio,
        .aspect_ratio_tolerance = 0.001f,
        .usage_include = reshade::api::resource_usage::render_target,
        .name = "Scene Intermediate",
    });
  }
}
      


     
    
        
        reshade::register_event<reshade::addon_event::init_device>(half_filter::Init);
        reshade::register_event<reshade::addon_event::destroy_device>(half_filter::Destroy);
        reshade::register_event<reshade::addon_event::destroy_swapchain>(half_filter::DestroySwapchain);
        reshade::register_event<reshade::addon_event::present>(half_filter::Present);
        // D3D9 upgraded-resource readback compatibility. The native GPU blit
        // refreshes the game's original SDR resource immediately before a
        // qualifying readback; CPU conversion remains only as a safety fallback.
        reshade::register_event<reshade::addon_event::init_device>(
            OnInitDeviceDX9NativeReadback);
        reshade::register_event<reshade::addon_event::destroy_device>(
            OnDestroyDeviceDX9NativeReadback);
        reshade::register_event<reshade::addon_event::copy_resource>(
            OnDX9CopyResource);
        reshade::register_event<reshade::addon_event::copy_texture_region>(
            OnDX9CopyTextureRegion);
        reshade::register_event<reshade::addon_event::resolve_texture_region>(
            OnDX9ResolveTextureRegion);


        reshade::log::message(
            reshade::log::level::info,
            "[MW3 V7 Integrated] V36 runtime + adaptive deadline finish + half-resolution filters ON; no Tracy.");

        initialized = true;
      }
      break;
    case DLL_PROCESS_DETACH: {
      g_reshade_overlay_open.store(false, std::memory_order_release);

      // ExitProcess terminates the other process threads before DLL detach, and
      // the OS is about to discard the entire address space. Restoring executable
      // code bytes, IAT hooks, Raw Input registrations or thread-local timer
      // handles here is unnecessary and can race ReShade/driver teardown.
      //
      // A true FreeLibrary/hot-unload has lpv_reserved == nullptr, so retain the
      // full reversible cleanup only for that case.
      const bool process_terminating = (lpv_reserved != nullptr);
      if (!process_terminating) {
        cod_high_polling_mouse::Shutdown();
        mw3_smooth_frame_pacing::Shutdown();
        mw3_proxy_latency::Shutdown();
        mw3_microstutter::Shutdown();
      }

      // Restore profiler hooks only for a true hot-unload. On normal process
      // termination avoid invasive teardown while other threads are already gone.
      mw3_deep_profiler::Shutdown(process_terminating);


      ClearDX9ReadbackStagingCache();
      ClearDX9NativeReadbackCache();
#if 0  // Automatic DX9 output unclamper disabled
      reshade::unregister_event<reshade::addon_event::create_pipeline>(
          OnCreatePipelineDX9AutoOutputUnclamp);
      ClearDX9AutoOutputUnclampCache();
#endif
      reshade::unregister_event<reshade::addon_event::resolve_texture_region>(
          OnDX9ResolveTextureRegion);
      reshade::unregister_event<reshade::addon_event::copy_texture_region>(
          OnDX9CopyTextureRegion);
      reshade::unregister_event<reshade::addon_event::copy_resource>(
          OnDX9CopyResource);
      reshade::unregister_event<reshade::addon_event::destroy_device>(
          OnDestroyDeviceDX9NativeReadback);
      reshade::unregister_event<reshade::addon_event::init_device>(
          OnInitDeviceDX9NativeReadback);
      reshade::unregister_overlay(
          "MW3 Command Console",
          DrawMW3CommandConsole);
      reshade::unregister_event<reshade::addon_event::reshade_open_overlay>(
          OnReShadeOpenOverlay);
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
    }
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);

#if 0  // Automatic DX9 output unclamper disabled
  // Register after RenoDX's shader module so hash-based embedded replacements
  // are resolved first and this patcher only sees the final ps_3_0 bytecode.
  if (fdw_reason == DLL_PROCESS_ATTACH) {
    reshade::register_event<reshade::addon_event::create_pipeline>(
        OnCreatePipelineDX9AutoOutputUnclamp);
  }
#endif

  return TRUE;
}
